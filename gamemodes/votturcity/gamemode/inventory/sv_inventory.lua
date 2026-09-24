-- 🎒 VotturCity | sv_inventory.lua | Server inventory authority 🎒 --
-- 🖥️ Clients REQUEST; server VALIDATES + APPLIES. Never trust counts from client. --

-- 🆕 Ensure a player has an inventory table. --
function VCity.Inventory_Ensure(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    ply.VCity_Inventory = ply.VCity_Inventory or {} -- 🎒 Create. --
end

-- 🔍 Does the player hold at least `count` of `itemId`? --
function VCity.Inventory_Has(ply, itemId, count)
    if not VCity.IsLivePlayer(ply) then return false end -- 🛑 Validate. --
    itemId = VCity.SanitizeItemID(itemId) -- 🧹 Sanitize. --
    if not itemId then return false end -- 🛑 Bad. --
    count = VCity.SanitizeCount(count or 1, 9999) -- 🔢 Count. --
    return VCity.Inventory_Count(ply.VCity_Inventory, itemId) >= count -- ✅ Check. --
end

-- ➕ Give items (stacking + weight + slot enforced). Returns leftover count. --
function VCity.Inventory_Give(ply, itemId, count, silent)
    if not VCity.IsLivePlayer(ply) then return count or 0 end -- 🛑 Validate. --
    itemId = VCity.SanitizeItemID(itemId) -- 🧹 Sanitize. --
    local def = itemId and VCity.Items[itemId] or nil -- 🧾 Def. --
    if not def then return count or 0 end -- 🛑 Unknown item. --
    count = VCity.SanitizeCount(count or 1, 999) -- 🔢 Count. --
    VCity.Inventory_Ensure(ply) -- 🎒 Ensure. --
    local inv = ply.VCity_Inventory -- 📦 Ref. --
    -- ⚖️ Weight gate: reject if it would exceed max. --
    local newWeight = VCity.Inventory_Weight(inv) + (def.w or 0) * count -- ⚖️ Projected. --
    if newWeight > VCity.Config.InvMaxWeight then -- 🛑 Too heavy. --
        if not silent then VCity.Notify(ply, 2, "🎒 Too heavy!") end -- 📝 Feedback. --
        return count -- 📦 All leftover. --
    end
    -- 📦 Slot gate: count DISTINCT stacks. --
    local function StackCount() -- 🧮 Helper. --
        local n = 0 -- 🧮 Count. --
        for _, s in ipairs(inv) do n = n + 1 end -- ➕ Count stacks. --
        return n -- ✅ Total. --
    end
    local remaining = count -- 📦 Leftover. --
    -- 🥇 First: top up existing partial stacks. --
    for _, stack in ipairs(inv) do -- 🔁 Existing. --
        if remaining <= 0 then break end -- ✅ Done. --
        if stack.id == itemId then -- 🎯 Same item. --
            local space = (def.max or 99) - (stack.count or 0) -- 📦 Room. --
            if space > 0 then -- ✅ Room. --
                local add = math.min(space, remaining) -- ➕ Amount. --
                stack.count = stack.count + add -- 📈 Grow. --
                remaining = remaining - add -- 📉 Shrink leftover. --
            end
        end
    end
    -- 🥈 Then: create new stacks while slots allow. --
    while remaining > 0 do -- 🔁 New stacks. --
        if StackCount() >= VCity.Config.InvSlots then -- 🛑 Full. --
            if not silent then VCity.Notify(ply, 2, "🎒 Inventory full!") end -- 📝 Feedback. --
            break -- 🛑 Stop. --
        end
        local add = math.min(def.max or 99, remaining) -- ➕ Amount. --
        table.insert(inv, { id = itemId, count = add }) -- ➕ New stack. --
        remaining = remaining - add -- 📉 Shrink. --
    end
    -- 🔫 Weapon items also grant the actual SWEP (once). --
    if def.weapon and (count - remaining) > 0 then -- 🔫 Weapon pickup. --
        if not ply:HasWeapon(def.weapon) then -- 🙅 Don't dupe. --
            ply:Give(def.weapon) -- 🔫 Grant. --
        end
    end
    -- 🛡️ Armor vest applies immediately + consumes one. --
    if itemId == "armor_vest" and (count - remaining) > 0 then -- 🛡️ Vest. --
        ply:SetArmor(50) -- 🛡️ Set armor. --
        VCity.Inventory_Take(ply, "armor_vest", 1, true) -- 🧹 Consume silently. --
        if not silent then VCity.Notify(ply, 1, "🛡️ Armor equipped!") end -- 📝 Feedback. --
    end
    if not silent then VCity.Inventory_Sync(ply) end -- 📡 Sync. --
    return remaining -- ✅ Leftover. --
end

-- ➖ Take items. Returns true if fully removed. --
function VCity.Inventory_Take(ply, itemId, count, silent)
    if not VCity.IsLivePlayer(ply) then return false end -- 🛑 Validate. --
    itemId = VCity.SanitizeItemID(itemId) -- 🧹 Sanitize. --
    if not itemId then return false end -- 🛑 Bad. --
    count = VCity.SanitizeCount(count or 1, 9999) -- 🔢 Count. --
    VCity.Inventory_Ensure(ply) -- 🎒 Ensure. --
    if VCity.Inventory_Count(ply.VCity_Inventory, itemId) < count then return false end -- 🛑 Insufficient. --
    local need = count -- 📦 Remaining to remove. --
    -- 🔁 Walk backwards so table.remove is safe. --
    for i = #ply.VCity_Inventory, 1, -1 do -- 🔁 Reverse. --
        if need <= 0 then break end -- ✅ Done. --
        local stack = ply.VCity_Inventory[i] -- 📦 Stack. --
        if stack.id == itemId then -- 🎯 Match. --
            local take = math.min(stack.count, need) -- ➖ Amount. --
            stack.count = stack.count - take -- 📉 Shrink. --
            need = need - take -- 📉 Shrink need. --
            if stack.count <= 0 then table.remove(ply.VCity_Inventory, i) end -- 🧹 Remove empty. --
        end
    end
    if not silent then VCity.Inventory_Sync(ply) end -- 📡 Sync. --
    return need <= 0 -- ✅ Success. --
end

-- 📡 Push full inventory to the owner (event-driven, never per-frame). --
function VCity.Inventory_Sync(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    net.Start(VCity.Net.INV) -- 🎒 Open channel. --
    local inv = ply.VCity_Inventory or {} -- 📦 Ref. --
    net.WriteUInt(#inv, 8) -- 🔢 Stack count (8-bit, max 255). --
    for _, stack in ipairs(inv) do -- 🔁 Each stack. --
        net.WriteString(stack.id) -- 🆔 ID. --
        net.WriteUInt(math.Clamp(stack.count or 0, 0, 1023), 10) -- 🔢 Count (10-bit). --
    end
    net.WriteFloat(VCity.Inventory_Weight(inv)) -- ⚖️ Weight for HUD. --
    net.Send(ply) -- 📤 Owner only. --
end

-- 📦 Spawn a world pickup entity for an item stack. --
function VCity.Inventory_SpawnPickup(itemId, count, pos)
    local def = VCity.Item_Get(itemId) -- 🧾 Def. --
    if not def then return nil end -- 🛑 Unknown. --
    count = VCity.SanitizeCount(count or 1, def.max or 99) -- 🔢 Count. --
    local ent = ents.Create("vcity_pickup") -- 📦 Entity. --
    if not IsValid(ent) then return nil end -- 🛑 Failed. --
    ent:SetPos(pos) -- 📍 Position. --
    ent:Spawn() -- 🌱 Spawn. --
    ent:Activate() -- ⚡ Activate. --
    ent:SetItem(itemId, count) -- 🏷️ Assign contents. --
    return ent -- ✅ Entity. --
end

-- 🎒 Client -> server: use / move / equip requests. --
-- 📨 Message layout: UInt8 op (0=use medical handled elsewhere, 1=drop, 2=destroy/scrap). --
net.Receive(VCity.Net.INV_OP, function(_, ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    if not ply:Alive() then return end -- 💀 Dead can't. --
    -- ⏱️ Rate limit inventory ops (5/sec max per player). --
    if not VCity.Throttled("InvOp_" .. ply:SteamID64(), 0.2) then return end -- ⏱️ Throttle. --
    local op = net.ReadUInt(8) -- 🔢 Operation. --
    local itemId = VCity.SanitizeItemID(net.ReadString()) -- 🧹 Item. --
    if not itemId or not VCity.Items[itemId] then return end -- 🛑 Unknown. --
    if op == 2 then -- 🗑️ Destroy / scrap for tiny XP. --
        if VCity.Inventory_Take(ply, itemId, 1) then -- 🧹 Removed. --
            VCity.XP_Grant(ply, 2, "scrap") -- ⭐ Tiny reward. --
            VCity.Notify(ply, 0, "🗑️ Scrapped " .. (VCity.Items[itemId].name or itemId)) -- 📝 Feedback. --
        end
    end
end)

-- 📦 Client -> server: drop request (spawns world pickup). --
net.Receive(VCity.Net.INV_DROP, function(_, ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    if not ply:Alive() then return end -- 💀 Dead can't. --
    if not VCity.State_CanAct(ply) then return end -- 🛑 Busy/down. --
    if not VCity.Throttled("InvDrop_" .. ply:SteamID64(), 0.3) then return end -- ⏱️ Throttle. --
    local itemId = VCity.SanitizeItemID(net.ReadString()) -- 🧹 Item. --
    local count = VCity.SanitizeCount(net.ReadUInt(10), 999) -- 🔢 Count. --
    if not itemId or not VCity.Items[itemId] then return end -- 🛑 Unknown. --
    -- 📏 Drop position in front of player (validated server-side). --
    local pos = ply:GetPos() + ply:GetForward() * 40 + Vector(0, 0, 20) -- 📍 Spot. --
    -- 🧱 Keep inside world (simple ground trace). --
    local tr = util.TraceLine({ start = ply:EyePos(), endpos = pos, filter = ply }) -- 🔍 Trace. --
    if tr.HitPos then pos = tr.HitPos + Vector(0, 0, 10) end -- 📍 Adjust. --
    if VCity.Inventory_Take(ply, itemId, count) then -- 🎒 Removed. --
        VCity.Inventory_SpawnPickup(itemId, count, pos) -- 📦 Spawn world item. --
        -- 🔫 If it was a weapon item, strip the SWEP too. --
        local def = VCity.Items[itemId] -- 🧾 Def. --
        if def.weapon and VCity.Inventory_Count(ply.VCity_Inventory, itemId) <= 0 then -- 🔫 Last one. --
            local w = ply:GetWeapon(def.weapon) -- 🔍 Find. --
            if IsValid(w) then ply:StripWeapon(def.weapon) end -- 🧹 Strip. --
        end
    end
end)
