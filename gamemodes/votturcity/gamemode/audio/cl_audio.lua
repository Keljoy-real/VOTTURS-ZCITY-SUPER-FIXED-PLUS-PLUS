-- 🔊 VotturCity | cl_audio.lua | Heartbeat / breathing / UI feedback 🔊 --
-- 💓 Event-driven + throttled loops; never plays overlapping spam. --

VCity._NextHeartbeat = 0 -- ⏱️ Next heartbeat time. --
VCity._NextBreath = 0 -- ⏱️ Next breath time. --
VCity._VitalsCache = VCity._VitalsCache or { blood = 5000, pain = 0, adre = 0, bleed = 0 } -- 💾 Cache. --
VCity._LimbsCache = VCity._LimbsCache or {} -- 🦴 Limb cache. --

-- 📥 Vitals snapshot updates the audio cache too. --
net.Receive(VCity.Net.VITALS, function()
    local blood = net.ReadFloat() -- 🩸 Blood. --
    local pain = net.ReadFloat() -- 😖 Pain. --
    local adre = net.ReadFloat() -- 💉 Adrenaline. --
    local bleed = net.ReadUInt(4) -- 🩸 Bleed. --
    local limbs = {} -- 🦴 Limbs. --
    for id = 1, 9 do -- 🔁 Each. --
        limbs[id] = { dmg = net.ReadUInt(7), wound = net.ReadUInt(2), fracture = net.ReadBool(), bandaged = net.ReadBool() } -- 📦 Read. --
    end
    VCity._VitalsCache = { blood = blood, pain = pain, adre = adre, bleed = bleed } -- 💾 Cache. --
    VCity._LimbsCache = limbs -- 🦴 Cache. --
end)

-- 📥 XP snapshot (level-up sound is server-triggered via notify; nothing extra). --
net.Receive(VCity.Net.XP, function()
    local xp = net.ReadUInt(24) -- ⭐ XP. --
    local lvl = net.ReadUInt(7) -- 🏆 Level. --
    LocalPlayer().VCity_XP = xp -- 💾 Cache. --
    LocalPlayer().VCity_Level = lvl -- 💾 Cache. --
end)

-- 📥 State broadcast: play KO / death stingers locally. --
net.Receive(VCity.Net.STATE, function()
    local ply = net.ReadEntity() -- 👤 Who. --
    local state = net.ReadUInt(4) -- 🚦 State. --
    if not IsValid(ply) then return end -- 🛑 Invalid. --
    if state == VCity.State.UNCONSCIOUS and ply == LocalPlayer() then -- 😵 Local KO. --
        surface.PlaySound("player/breathe1.wav") -- 😮‍💨 Gasp. --
    end
end)

-- 💓 Throttled heartbeat when blood is low (rate scales with severity). --
hook.Add("Think", "VCity_Heartbeat", function()
    local ply = LocalPlayer() -- 👤 Local. --
    if not IsValid(ply) or not ply:Alive() then return end -- 🛑 Dead. --
    local blood = VCity._VitalsCache.blood or VCity.Config.BloodMax -- 🩸 Blood. --
    local frac = blood / VCity.Config.BloodMax -- 📊 Fraction. --
    if frac < 0.55 and CurTime() >= VCity._NextHeartbeat then -- 💓 Low blood. --
        surface.PlaySound(VCity.Audio.HEARTBEAT) -- 💓 Thump. --
        -- ⏱️ Faster heartbeat when lower (0.55 -> 1.1s, 0.3 -> 0.6s). --
        VCity._NextHeartbeat = CurTime() + math.Clamp(frac * 2, 0.5, 1.2) -- ⏱️ Schedule. --
    end
    -- 😮‍💨 Heavy breathing at high pain (throttled 4s). --
    local pain = VCity._VitalsCache.pain or 0 -- 😖 Pain. --
    if pain > 60 and CurTime() >= VCity._NextBreath then -- 😖 Severe. --
        surface.PlaySound(VCity.Audio.BREATH) -- 😮‍💨 Breath. --
        VCity._NextBreath = CurTime() + 4 -- ⏱️ Schedule. --
    end
end)
