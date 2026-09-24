-- 🩸 VotturCity | cl_blood_fx.lua | Blood decals + spurts (client) 🩸 --
-- 💻 Receives PVS-filtered FX (no per-frame work); throttled server-side. --

net.Receive("VCity_BloodFX", function() -- 📥 FX. --
    local pos = net.ReadVector() -- 📍 Position. --
    local sev = net.ReadUInt(2) -- 🩸 Severity 0-2. --
    -- 🩸 Floor/wall decal (cheap, engine-cached). --
    local tr = util.TraceLine({ start = pos + Vector(0, 0, 10), endpos = pos - Vector(0, 0, 40), mask = MASK_SOLID_BRUSHONLY }) -- 🔍 Down. --
    if tr.Hit then util.Decal("Blood", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal) end -- 🩸 Decal. --
    -- 💦 Particle spurt (tiny emitter, auto-collected). --
    local n = sev == 2 and 10 or (sev == 1 and 5 or 2) -- 💦 Count. --
    local emitter = ParticleEmitter(pos) -- ✨ Emitter. --
    for i = 1, n do -- 🔁 Particles. --
        local p = emitter:Add("effects/blood_core", pos + VectorRand() * 6) -- 🩸 Particle. --
        if p then -- ✅ Valid. --
            p:SetVelocity(VectorRand() * 120 + Vector(0, 0, 60)) -- 💨 Fling. --
            p:SetDieTime(math.Rand(0.3, 0.7)) -- ⏱️ Life. --
            p:SetStartAlpha(220) p:SetEndAlpha(0) -- 📊 Fade. --
            p:SetStartSize(math.Rand(2, 4)) p:SetEndSize(1) -- 📐 Shrink. --
            p:SetColor(150, 10, 10) -- 🩸 Red. --
            p:SetGravity(Vector(0, 0, -400)) -- 🌍 Fall. --
        end
    end
    emitter:Finish() -- 🧹 Collect. --
end)
