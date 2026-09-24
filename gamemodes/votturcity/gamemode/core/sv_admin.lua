-- 🛡️ VotturCity | sv_admin.lua | Admin + debug commands 🛡️ --
-- 🖥️ Kept separate from gameplay so debug never leaks into production paths. --

-- 🔍 Is this player allowed to run admin commands? --
local function IsAdmin(ply)
    if not VCity.IsLivePlayer(ply) then return false end -- 🛑 Invalid. --
    if ply:IsSuperAdmin() then return true end -- 👑 Superadmin. --
    if ply:IsAdmin() then return true end -- 🛡️ Admin. --
    return false -- 🙅 Default deny. --
end

-- 🎒 Give item: vcity_give <item> [count]. --
concommand.Add("vcity_give", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local id = VCity.SanitizeItemID(args[1]) -- 🧹 Item. --
    local count = VCity.SanitizeCount(args[2] or 1, 999) -- 🔢 Count. --
    if not id or not VCity.Items[id] then -- 🛑 Unknown. --
        ply:ChatPrint("❌ Unknown item. Try: bandage, medkit, ammo_9mm, w_akm...") -- 📝 Help. --
        return -- 🛑 Stop. --
    end
    local target = ply -- 👤 Default self. --
    VCity.Inventory_Give(target, id, count) -- 🎒 Give. --
    target:ChatPrint("✅ Gave " .. id .. " x" .. count) -- 📝 Confirm. --
end)

-- 🔫 Give weapon + ammo: vcity_givegun <glock|akm|shotgun|knife>. --
concommand.Add("vcity_givegun", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local map = { glock = { w = "vcity_glock", a = "ammo_9mm", n = 36 }, akm = { w = "vcity_akm", a = "ammo_rifle", n = 60 }, shotgun = { w = "vcity_shotgun", a = "ammo_shell", n = 12 }, knife = { w = "vcity_knife" } } -- 🗺️ Map. --
    local pick = map[string.lower(args[1] or "")] -- 🔍 Lookup. --
    if not pick then ply:ChatPrint("❌ Usage: vcity_givegun glock|akm|shotgun|knife") return end -- 📝 Help. --
    ply:Give(pick.w) -- 🔫 Give weapon. --
    if pick.a then VCity.Inventory_Give(ply, pick.a, pick.n, true) VCity.Inventory_Sync(ply) end -- 🎒 Ammo. --
    ply:SelectWeapon(pick.w) -- 🎯 Equip. --
end)

-- 🩸 Inspect vitals: vcity_vitals [name]. --
concommand.Add("vcity_vitals", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local target = ply -- 👤 Default. --
    if args[1] then -- 🔍 Named target. --
        for _, p in ipairs(player.GetAll()) do -- 🔁 Search. --
            if string.find(string.lower(p:Nick()), string.lower(args[1])) then target = p break end -- 🎯 Match. --
        end
    end
    if not VCity.IsLivePlayer(target) then return end -- 🛑 Invalid. --
    ply:ChatPrint("🩸 " .. target:Nick() .. " HP=" .. target:Health() .. " Blood=" .. math.floor(target.VCity_Blood or 0) .. " Pain=" .. math.floor(target.VCity_Pain or 0) .. " Bleed=" .. (target.VCity_Bleed or 0) .. " State=" .. VCity.State_GetName(target)) -- 📝 Dump. --
    for id = 1, 9 do -- 🦴 Limbs. --
        local L = (target.VCity_Limbs or {})[id] -- 🦴 Region. --
        if L and (L.dmg > 1 or L.wound > 0 or L.fracture) then -- 🩸 Injured only. --
            ply:ChatPrint("  🦴 " .. (VCity.LimbDefs[id].name or id) .. " dmg=" .. math.floor(L.dmg) .. " wound=" .. L.wound .. " fx=" .. tostring(L.fracture) .. " band=" .. tostring(L.bandaged)) -- 📝 Limb. --
        end
    end
end)

-- 🌱 Reset player: vcity_reset [name]. --
concommand.Add("vcity_reset", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local target = ply -- 👤 Default. --
    if args[1] then for _, p in ipairs(player.GetAll()) do if string.find(string.lower(p:Nick()), string.lower(args[1])) then target = p break end end end -- 🔍 Find. --
    if not VCity.IsLivePlayer(target) then return end -- 🛑 Invalid. --
    VCity.Vitals_Reset(target) -- ❤️ Reset. --
    target:SetHealth(target:GetMaxHealth()) -- ❤️ HP. --
    target:SetArmor(0) -- 🛡️ Armor. --
    VCity.State_Set(target, VCity.State.ALIVE) -- 🚦 Alive. --
    target:Freeze(false) -- 🧊 Unfreeze. --
    VCity.Vitals_Sync(target) -- 📡 Sync. --
    target:ChatPrint("🌱 You were reset by an admin.") -- 📝 Feedback. --
end)

-- 🩸 Test damage: vcity_hurt <amount> [limb]. --
concommand.Add("vcity_hurt", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local amt = math.Clamp(tonumber(args[1]) or 10, 1, 200) -- 🔢 Amount. --
    local dmg = DamageInfo() -- 📦 Damage. --
    dmg:SetAttacker(ply) -- 👤 Self (no XP exploit: attacker==victim skips XP). --
    dmg:SetInflictor(ply) -- 👤 Inflictor. --
    dmg:SetDamage(amt) -- 🩸 Amount. --
    dmg:SetDamageType(DMG_BULLET) -- 🔫 Bullet. --
    dmg:SetDamagePosition(ply:GetPos() + Vector(0, 0, 50)) -- 📍 Chest-ish. --
    ply:TakeDamageInfo(dmg) -- 🩸 Apply. --
    ply:ChatPrint("🩸 Hurt yourself for " .. amt) -- 📝 Confirm. --
end)

-- 🩹 Test heal: vcity_healme. --
concommand.Add("vcity_healme", function(ply)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    VCity.Inventory_Give(ply, "medkit", 1, true) -- 🩺 Give kit silently. --
    local ok, msg = VCity.Medical_Treat(ply, ply, "medkit") -- 🩹 Treat (no consume check bypass: we gave it). --
    VCity.Inventory_Take(ply, "medkit", 1, true) -- 🧹 Consume. --
    VCity.Inventory_Sync(ply) -- 📡 Sync. --
    ply:ChatPrint((ok and "✅ " or "❌ ") .. msg) -- 📝 Result. --
end)

-- 📊 Perf diagnostics: vcity_perf. --
concommand.Add("vcity_perf", function(ply)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local msg = "📊 Players=" .. player.GetCount() .. " Pickups=" .. #ents.FindByClass("vcity_pickup") .. " Corpses=" .. #ents.FindByClass("vcity_corpse") .. " Ragdolls=" .. #ents.FindByClass("prop_ragdoll") -- 📊 Stats. --
    if IsValid(ply) then ply:ChatPrint(msg) else print(msg) end -- 📝 Output. --
end)

-- 📡 Net diagnostics: vcity_netinfo. --
concommand.Add("vcity_netinfo", function(ply)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local n = table.Count(VCity.Net) -- 📡 Channels. --
    local msg = "📡 Net channels=" .. n .. " (" .. table.concat(table.GetKeys(VCity.Net), ", ") .. ")" -- 📝 List. --
    if IsValid(ply) then ply:ChatPrint(msg) else print(msg) end -- 📝 Output. --
end)
