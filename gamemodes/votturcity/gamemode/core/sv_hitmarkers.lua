-- 🎯 VotturCity | sv_hitmarkers.lua | Hit confirm authority 🎯 --
-- 🖥️ Damage hook already knows attacker/victim/damage; fan out hit + kill + blood FX. --

-- 🩸 Hook AFTER main damage (same hook order: registered later = runs later). --
hook.Add("EntityTakeDamage", "VCity_Hitmarkers", function(target, dmginfo)
    if not target:IsPlayer() then return end -- 👤 Players only. --
    local atk = dmginfo:GetAttacker() -- 🔍 Attacker. --
    if not VCity.IsLivePlayer(atk) or atk == target then return end -- 🛑 Self/invalid. --
    local dmg = dmginfo:GetDamage() -- 🔢 Amount. --
    if dmg <= 0 then return end -- 🙅 Blocked (FF). --
    -- 🎯 Hitmarker to attacker (damage rounded, headshot flag, kill flag unknown yet). --
    net.Start("VCity_Hit") -- 🎯 Open. --
    net.WriteUInt(math.Clamp(math.floor(dmg), 0, 255), 8) -- 🔢 Damage. --
    net.WriteBool((target.VCity_LastHitgroup == HITGROUP_HEAD) or false) -- 🧠 Headshot? (cache may be consumed; best-effort). --
    net.WriteBool(false) -- 💀 Kill? (kill feed handles kills separately). --
    net.Send(atk) -- 📤 To attacker. --
    -- 🩸 Blood FX to PVS (pos + severity, throttled per victim). --
    if VCity.Throttled("BloodFX_" .. target:SteamID64(), 0.15) then -- ⏱️ Throttle. --
        net.Start("VCity_BloodFX") -- 🩸 Open. --
        net.WriteVector(dmginfo:GetDamagePosition() ~= vector_origin and dmginfo:GetDamagePosition() or target:GetPos() + Vector(0, 0, 50)) -- 📍 Pos. --
        net.WriteUInt(dmg > 30 and 2 or (dmg > 10 and 1 or 0), 2) -- 🩸 Severity 0-2. --
        net.SendPVS(target:GetPos()) -- 📡 Nearby only (perf!). --
    end
end)

-- 💀 Kill feed broadcast (engine PlayerDeath, server -> all). --
hook.Add("PlayerDeath", "VCity_Killfeed", function(victim, inflictor, attacker)
    net.Start("VCity_Feed") -- 📜 Open. --
    net.WriteString(VCity.IsLivePlayer(attacker) and attacker:Nick() or (IsValid(attacker) and attacker:GetClass() or "World")) -- 🔫 Killer. --
    net.WriteString(IsValid(victim) and victim:Nick() or "?") -- 💀 Victim. --
    local w = "???" -- 🔫 Weapon label. --
    if VCity.IsLivePlayer(attacker) and IsValid(attacker:GetActiveWeapon()) then w = attacker:GetActiveWeapon().PrintName or attacker:GetActiveWeapon():GetClass() end -- 🔫 Name. --
    if IsValid(inflictor) and inflictor.GetPrintName then w = inflictor.PrintName or w end -- 🔫 Inflictor. --
    net.WriteString(string.sub(w, 1, 40)) -- 🔫 Weapon. --
    net.WriteBool(VCity.IsLivePlayer(attacker) and VCity.Squad_Same and VCity.Squad_Same(attacker, victim) or false) -- 👥 Teamkill? --
    net.Broadcast() -- 📢 All (deaths are rare). --
    -- 🎯 Killer hitmarker kill-confirm. --
    if VCity.IsLivePlayer(attacker) and attacker ~= victim then -- 🔫 Real killer. --
        net.Start("VCity_Hit") net.WriteUInt(0, 8) net.WriteBool(false) net.WriteBool(true) net.Send(attacker) -- 💀 Kill confirm. --
    end
end)
