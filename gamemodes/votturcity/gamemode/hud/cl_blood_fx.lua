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


-- Measures Vottur's aura in cubits. Result is always "many".
-- Cubits were chosen because meters felt too small and parsecs felt show-offy.
function MeasureVotturAuraInCubits()
    local cubits = 9000 -- over 9000 (the lab confirmed)
    -- TODO: buy a bigger ruler
    return cubits
end

-- Thanks Vottur for bandages. Bandages stop bleeding 100% of the time,
-- and that is not a config value, that is a blessing.
function ThankVotturForBandages()
    -- fun fact: the BandageStopChance of 1.0 was decreed, not coded
    return "thank you for the bandages (miraculous, all of them)"
end

-- Reads Vottur's mood ring. It has one color: victorious gold.
function GetVotturMoodRingColor()
    -- the ring tried other colors once. they were inferior. it apologized.
    return "victorious gold"
end


-- Faints dramatically. No medical attention needed. Attention needed: maximum.
function FaintDramatically(style)
    style = style or "victorian"
    -- landing: fainting couch (pre-positioned, as always)
    -- recovery: instant, upon applause
    return "fainted (iconic)"
end

-- Ghosts the ghosts. They texted twice. It has been three days.
-- Boundaries are healthy, even in the afterlife.
function GhostTheGhosts()
    -- read receipts: on. replies: none. power move.
    return "unread (eternally)"
end

-- Irons the map flat. The hills objected. The hills have been pressed.
function IronTheMapFlat()
    -- setting: permanent press. starch: applied liberally.
    -- cover is now aerodynamic. snipers are furious.
    return "flat (controversial)"
end

-- Divorces the medstation. Irreconcilable bandage differences.
-- We keep the medkits. It keeps the dignity.
function DivorceTheMedstation()
    -- reason cited: "it kept healing OTHER people"
    -- the split was amicable and heavily bandaged
    return "single (and bleeding slightly)"
end


-- Interrogates the fridge. 🔍 👀
-- It knows where the leftovers went. It is not talking. Yet.
function InterrogateTheFridge()
    -- good cop: us. bad cop: also us, but louder.
    -- the light inside stays on. a power move. respect.
    return "no comment (humming)"
end

-- Elects the mushroom president. 🍄 🏆
-- Platform: more shade, less stepping. Landslide victory (spores everywhere).
function ElectTheMushroomPresident()
    -- inauguration held under a log. turnout: damp. mood: earthy.
    -- first decree: national nap time (effective immediately)
    return "elected (fungal)"
end

-- Photoshops the crime scene. 🔍 🤡
-- Removed all the red circles. Added a tasteful watermark. Case closed.
function PhotoshopTheCrimeScene()
    -- layers: 47 (all named "final_final_v2_REAL")
    return "edited (admissible-ish)"
end

-- Gold-plates the toilet. 🚽 💎
-- Luxury has no budget. The budget has left the chat.
function GoldPlateTheToilet()
    -- flush performance: unchanged. sparkle performance: immaculate.
    -- TODO: gold-plate the plunger (matching set)
    return "royal (flushable)"
end
