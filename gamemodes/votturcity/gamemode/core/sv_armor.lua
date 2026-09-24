-- 🛡️ VotturCity | sv_armor.lua | Per-limb gear protection authority 🛡️ --
-- 🖥️ Equips consume from inventory; unequip returns. Scale called by damage code. --

-- 🆕 Init gear table on spawn. --
hook.Add("PlayerSpawn", "VCity_GearInit", function(ply)
    timer.Simple(0.1, function() -- ⏳ After base spawn. --
        if not IsValid(ply) then return end -- 🛑 Left. --
        ply.VCity_Gear = ply.VCity_Gear or {} -- 🎽 Table. --
        -- 📡 Clear mirrors (gear does NOT persist through death — looted from corpse). --
        for _, slot in ipairs(VCity.GearSlots) do ply:SetNWString("VCity_Gear_" .. slot, "") end -- 📡 Clear. --
    end)
end)

-- 🧮 Scale damage by equipped gear for a limb + kind. Called from sv_damage. --
function VCity.Armor_Scale(ply, limb, damage, kind)
    local gear = ply.VCity_Gear or {} -- 🎽 Equipped. --
    local mult = 1 -- 🧮 Multiplier. --
    -- 🪖 Helmet guards head + brain. --
    if (limb == VCity.Limb.HEAD or limb == VCity.Limb.BRAIN) and gear.head == "helmet" then -- 🪖 Helmet. --
        mult = mult * (1 - (VCity.Config.GearProtect.helmet or 0.4)) -- 🛡️ Reduce. --
    end
    -- 🦺 Vest guards chest/stomach/pelvis. --
    if (limb == VCity.Limb.CHEST or limb == VCity.Limb.STOMACH or limb == VCity.Limb.PELVIS) and gear.body == "armor_vest" then -- 🦺 Vest. --
        mult = mult * (1 - (VCity.Config.GearProtect.vest or 0.35)) -- 🛡️ Reduce. --
    end
    -- 😷 Mask gives tiny all-around resist (mostly rad, handled in events). --
    if gear.face == "gas_mask" then -- 😷 Mask. --
        mult = mult * (1 - (VCity.Config.GearProtect.mask or 0.1) * 0.5) -- 🛡️ Small. --
    end
    -- 🐌 Speed costs applied in vitals? No — apply here directly when gear changes. --
    return damage * mult -- ✅ Scaled. --
end

-- ☢️ Radiation resist helper for events module. --
function VCity.Armor_RadMult(ply)
    local gear = ply.VCity_Gear or {} -- 🎽 Gear. --
    local mult = 1 -- 🧮 Multiplier. --
    if gear.face == "gas_mask" then mult = mult * (1 - (VCity.Config.GearRadResist.mask or 0.8)) end -- 😷 Big cut. --
    if gear.head == "helmet" then mult = mult * (1 - (VCity.Config.GearRadResist.helmet or 0.1)) end -- 🪖 Small. --
    return mult -- ✅ Multiplier. --
end

-- 🎽 Equip: consumes one from inventory into the slot (returns old to inventory). --
function VCity.Armor_Equip(ply, itemId)
    local slot = VCity.Gear_SlotFor(itemId) -- 🗺️ Slot. --
    if not slot then return false, "Not gear." end -- 🛑 Bad. --
    if not VCity.Inventory_Has(ply, itemId, 1) then return false, "You don't have it." end -- 🎒 Missing. --
    ply.VCity_Gear = ply.VCity_Gear or {} -- 🎽 Ensure. --
    -- ↩️ Stash current back first. --
    local cur = ply.VCity_Gear[slot] -- 📦 Current. --
    if cur then VCity.Inventory_Give(ply, cur, 1, true) end -- 🎒 Return old. --
    VCity.Inventory_Take(ply, itemId, 1, true) -- 🧹 Consume new. --
    ply.VCity_Gear[slot] = itemId -- 🎽 Equip. --
    ply:SetNWString("VCity_Gear_" .. slot, itemId) -- 📡 Mirror. --
    -- 🐌 Apply speed cost (recomputed from base each equip). --
    local cost = 0 -- 🐌 Total. --
    for _, s in ipairs(VCity.GearSlots) do -- 🔁 Slots. --
        local it = ply.VCity_Gear[s] -- 📦 Item. --
        if it == "helmet" then cost = cost + (VCity.Config.GearSpeedCost.helmet or 0) end -- 🪖 Cost. --
        if it == "armor_vest" then cost = cost + (VCity.Config.GearSpeedCost.vest or 0) end -- 🦺 Cost. --
    end
    ply.VCity_GearCost = cost -- 💾 Store for vitals? (vitals adds pain slow on top). --
    VCity.Inventory_Sync(ply) -- 📡 Sync. --
    return true, "🎽 Equipped " .. ((VCity.Items[itemId] or {}).name or itemId) -- ✅ Done. --
end

-- 🎽 Unequip: returns to inventory if space. --
function VCity.Armor_Unequip(ply, slot)
    ply.VCity_Gear = ply.VCity_Gear or {} -- 🎽 Ensure. --
    local cur = ply.VCity_Gear[slot] -- 📦 Current. --
    if not cur then return false, "Slot empty." end -- 🙅 Empty. --
    local left = VCity.Inventory_Give(ply, cur, 1, true) -- 🎒 Return. --
    if left > 0 then return false, "Inventory full!" end -- 🎒 Full. --
    ply.VCity_Gear[slot] = nil -- 🧹 Clear. --
    ply:SetNWString("VCity_Gear_" .. slot, "") -- 📡 Mirror. --
    VCity.Inventory_Sync(ply) -- 📡 Sync. --
    return true, "🎽 Unequipped." -- ✅ Done. --
end

-- 📥 Gear net: string op ("equip"/"unequip") + string id/slot. --
net.Receive("VCity_Gear", function(_, ply)
    if not VCity.IsLivePlayer(ply) or not ply:Alive() then return end -- 🛑 Validate. --
    if not VCity.Throttled("Gear_" .. ply:SteamID64(), 0.5) then return end -- ⏱️ Throttle. --
    local op = net.ReadString() -- 📝 Op. --
    local arg = net.ReadString() -- 📝 Arg. --
    if op == "equip" then -- 🎽 Equip. --
        local id = VCity.SanitizeItemID(arg) -- 🧹 Item. --
        if not id then return end -- 🛑 Bad. --
        local ok, msg = VCity.Armor_Equip(ply, id) -- 🎽 Equip. --
        VCity.Notify(ply, ok and 1 or 2, msg) -- 📝 Feedback. --
    elseif op == "unequip" then -- 🎽 Unequip. --
        local slot = string.lower(arg or "") -- 🗺️ Slot. --
        if slot ~= "head" and slot ~= "body" and slot ~= "face" then return end -- 🛑 Bad. --
        local ok, msg = VCity.Armor_Unequip(ply, slot) -- 🎽 Unequip. --
        VCity.Notify(ply, ok and 1 or 2, msg) -- 📝 Feedback. --
    end
end)

-- 💀 Drop gear into corpse on death (so winners can loot armor). --
hook.Add("DoPlayerDeath", "VCity_GearDrop", function(ply)
    local gear = ply.VCity_Gear or {} -- 🎽 Gear. --
    for slot, itemId in pairs(gear) do -- 🔁 Each. --
        if itemId then VCity.Inventory_Give(ply, itemId, 1, true) end -- 🎒 Return to inv (corpse snapshot grabs it). --
    end
    ply.VCity_Gear = {} -- 🧹 Clear. --
end)
