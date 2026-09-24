-- 🛡️ VotturCity | sv_admin2.lua | Extended admin tools (bring/goto/slay/log) 🛡️ --
-- 🖥️ Separate from sv_admin.lua so base debug stays tidy. --

local function IsAdmin(ply) -- 🔍 Gate. --
    if not VCity.IsLivePlayer(ply) then return false end -- 🛑 Invalid. --
    return ply:IsSuperAdmin() or ply:IsAdmin() -- 👑 Admin. --
end

local function FindPlayer(frag) -- 🔍 Partial-name find. --
    if not frag or frag == "" then return nil end -- 🛑 Empty. --
    for _, p in ipairs(player.GetAll()) do -- 🔁 Search. --
        if string.find(string.lower(p:Nick()), string.lower(frag)) then return p end -- 🎯 Match. --
    end
    return nil -- 🙅 None. --
end

-- 🧲 Bring: teleport target to admin. --
concommand.Add("vcity_bring", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local t = FindPlayer(args[1]) -- 🎯 Target. --
    if not IsValid(t) then ply:ChatPrint("❌ Player not found.") return end -- 🛑 Missing. --
    t:SetPos(ply:GetPos() + ply:GetForward() * 80) -- 📍 Move. --
    ply:ChatPrint("🧲 Brought " .. t:Nick()) t:ChatPrint("🧲 An admin brought you!") -- 📝 Confirm. --
end)

-- 🚀 Goto: teleport admin to target. --
concommand.Add("vcity_goto", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local t = FindPlayer(args[1]) -- 🎯 Target. --
    if not IsValid(t) then ply:ChatPrint("❌ Player not found.") return end -- 🛑 Missing. --
    ply:SetPos(t:GetPos() + Vector(0, 0, 20)) -- 📍 Move. --
    ply:ChatPrint("🚀 Went to " .. t:Nick()) -- 📝 Confirm. --
end)

-- ⚔️ Slay: kill target (goes through corpse system for consistency). --
concommand.Add("vcity_slay", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local t = FindPlayer(args[1]) or ply -- 🎯 Target (default self? no—require arg). --
    if args[1] == nil then ply:ChatPrint("❌ Usage: vcity_slay <name>") return end -- 📝 Help. --
    if not IsValid(t) then return end -- 🛑 Missing. --
    t:Kill() -- ⚰️ Kill (DoPlayerDeath handles corpse/XP). --
    VCity.Net_BroadcastNotify(0, "⚔️ " .. t:Nick() .. " was slain by admin.") -- 📢 Announce. --
end)

-- 🩹 Revive admin: wake KO + heal (for stuck players / events). --
concommand.Add("vcity_revive", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local t = FindPlayer(args[1]) or ply -- 🎯 Target. --
    if not IsValid(t) or not t:Alive() then ply:ChatPrint("❌ Target must be alive.") return end -- 🛑 Dead. --
    if VCity.State_Get(t) == VCity.State.UNCONSCIOUS then VCity.State_Wake(t) end -- 🌱 Wake. --
    t:SetHealth(t:GetMaxHealth()) t.VCity_Blood = VCity.Config.BloodMax t.VCity_Pain = 0 t.VCity_Bleed = 0 -- ❤️ Full restore. --
    if t.VCity_Limbs then for id = 1, 9 do t.VCity_Limbs[id] = { dmg = 0, wound = 0, fracture = false, bandaged = false } end end -- 🦴 Fix limbs. --
    VCity.Vitals_RefreshState(t) VCity.Vitals_Sync(t) VCity.Survival_Sync(t) -- 📡 Sync. --
    t:ChatPrint("✨ Revived by admin!") -- 📝 Confirm. --
end)

-- 🌦️ Force event: vcity_event airdrop|capture|storm. --
concommand.Add("vcity_event", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local e = string.lower(args[1] or "") -- 🎪 Event. --
    if e == "storm" then VCity.StormUntil = CurTime() + 120 VCity.Net_BroadcastNotify(2, "☢️ Admin summoned a storm!") -- ⛈️ Storm. --
    elseif e == "capture" then for _, p in ipairs(player.GetAll()) do if p:Alive() then VCity.Capture.pos = p:GetPos() break end end VCity.Capture.active = true VCity.Capture.radius = 300 VCity.Capture.untilt = CurTime() + 180 SetGlobalVector("VCity_CapPos", VCity.Capture.pos) SetGlobalFloat("VCity_CapUntil", VCity.Capture.untilt) SetGlobalBool("VCity_CapActive", true) -- 🏁 Capture. --
    else ply:ChatPrint("❌ Usage: vcity_event storm|capture (airdrops auto-run)") end -- 📝 Help. --
end)

-- 📊 Extended perf: counts every VCity entity class. --
concommand.Add("vcity_perf2", function(ply)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local parts = {} -- 📊 Parts. --
    for _, cls in ipairs({ "vcity_pickup", "vcity_corpse", "vcity_crate", "vcity_airdrop", "vcity_campfire", "vcity_trader", "vcity_bed", "prop_ragdoll", "env_fire" }) do -- 🔁 Classes. --
        table.insert(parts, cls .. "=" .. #ents.FindByClass(cls)) -- 📝 Count. --
    end
    local msg = "📊 " .. table.concat(parts, "  ") .. "  players=" .. player.GetCount() -- 📊 Line. --
    if IsValid(ply) then ply:ChatPrint(msg) else print(msg) end -- 📝 Output. --
end)

-- 📝 Simple kill log (server console, helps admins audit RDM). --
hook.Add("PlayerDeath", "VCity_AdminLog", function(victim, inflictor, attacker)
    local an = VCity.IsLivePlayer(attacker) and attacker:Nick() or (IsValid(attacker) and attacker:GetClass() or "world") -- 🔫 Attacker. --
    print("[VCity] ⚰️ " .. (IsValid(victim) and victim:Nick() or "?") .. " killed by " .. an) -- 📝 Log. --
end)
