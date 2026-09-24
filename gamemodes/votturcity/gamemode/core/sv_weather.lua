-- 🌦️ VotturCity | sv_weather.lua | Day/night + radiation storms 🌦️ --
-- ⏱️ One 10s timer drives clock; storms are rare global events. --

VCity.Time_Hour = 12 -- 🕛 Start at noon. --
VCity.StormUntil = 0 -- ⛈️ No storm initially. --
VCity.NextStorm = CurTime() + 600 -- ⛈️ First storm in ~10 min. --

-- 🌙 Is it night right now? (used by survival temp). --
function VCity.Weather_Night()
    local h = VCity.Time_Hour or 12 -- 🕛 Hour. --
    return h >= 21 or h < 5 -- 🌙 Night window. --
end

-- ⛈️ Is a rad storm active? --
function VCity.Weather_Storm()
    return CurTime() < (VCity.StormUntil or 0) -- ⛈️ Check. --
end

-- 🕛 Clock advance (1 game-hour per 60s real). --
timer.Create("VCity_Clock", 10, 0, function() -- ⏱️ Every 10s. --
    VCity.Time_Hour = (VCity.Time_Hour + 10 / 60) % 24 -- 🕛 +10min game time. --
    SetGlobalFloat("VCity_Time", VCity.Time_Hour) -- 📡 Global for HUD. --
    SetGlobalBool("VCity_Night", VCity.Weather_Night()) -- 🌙 Mirror. --
    SetGlobalBool("VCity_Storm", VCity.Weather_Storm()) -- ⛈️ Mirror. --
    -- ⛈️ Storm scheduling. --
    if not VCity.Weather_Storm() and CurTime() >= (VCity.NextStorm or 0) then -- ⛈️ Start storm. --
        VCity.StormUntil = CurTime() + 120 -- ⛈️ 2-minute storm. --
        VCity.NextStorm = CurTime() + 600 + math.random(0, 300) -- ⏱️ Next in 10-15 min. --
        VCity.Net_BroadcastNotify(2, "☢️ RADIATION STORM! Get inside or mask up!") -- 📢 Warn. --
        for _, p in ipairs(player.GetAll()) do if IsValid(p) then p:EmitSound("ambient/alarms/warningbell1.wav", 60, 100) end end -- 🔊 Siren. --
    end
    if VCity.Weather_Storm() and CurTime() >= VCity.StormUntil - 1 and VCity.StormUntil ~= 0 then -- 🏁 Storm ending Hak? --
        -- 🙅 End handled by time passing; announce once via flag. --
    end
end)

-- ☢️ Storm damage tick (5s, only during storm, sky-exposed players only). --
timer.Create("VCity_StormTick", 5, 0, function() -- ⏱️ Storm damage. --
    if not VCity.Weather_Storm() then return end -- 🌤️ No storm. --
    for _, ply in ipairs(player.GetAll()) do -- 🔁 Players. --
        if not VCity.IsLivePlayer(ply) or not ply:Alive() then continue end -- 🛑 Skip. --
        -- 🏠 Sky check: trace up; if hits sky, exposed. --
        local tr = util.TraceLine({ start = ply:GetPos() + Vector(0, 0, 50), endpos = ply:GetPos() + Vector(0, 0, 2000), mask = MASK_SOLID_BRUSHONLY }) -- 🔍 Up. --
        local exposed = tr.HitSky or (not tr.Hit) -- 🌤️ Exposed if sky or nothing. --
        if not exposed then continue end -- 🏠 Sheltered. --
        local mult = 1 -- 🧮 Rad multiplier. --
        if VCity.Armor_RadMult then mult = VCity.Armor_RadMult(ply) end -- 😷 Mask helps. --
        if mult >= 0.99 then -- ☢️ Unprotected: damage + pain. --
            ply:SetHealth(ply:Health() - 4) -- 🩸 Rad burn. --
            ply.VCity_Pain = math.Clamp((ply.VCity_Pain or 0) + 3, 0, 100) -- 😖 Sick. --
            if ply:Health() <= 0 and ply:Alive() then ply:Kill() end -- ⚰️ Die. --
        else -- 😷 Protected: tiny chip. --
            ply:SetHealth(ply:Health() - 1 * mult) -- 🩸 Chip. --
            if ply:Health() <= 0 and ply:Alive() then ply:Kill() end -- ⚰️ Edge. --
        end
    end
end)

-- 🌙 Darken nights slightly via global (client applies color modify in HUD). --
-- 📝 Actual env lighting control needs engine calls; we expose time for HUD FX only. --
