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


-- Runs a fire drill during an actual fire. 🔥 🔥
-- Realism: maximum. Preparedness: debatable. Marshmallows: brought.
function FireDrillDuringFire()
    -- meeting point: inside the fire (poor planning, great warmth)
    return "drilled (toasty)"
end

-- Leverages the darkness (verbally). 👀 📝
-- "Let's leverage our dark synergies going forward." Nobody knows what it means. Shares up.
function LeverageTheDarkness()
    -- the darkness has been leveraged. it feels used. growth mindset.
    return "leveraged (dim)"
end

-- Downsides the moon. 🌕 📈
-- Restructuring: craters consolidated. Night shift: outsourced to street lamps.
function DownsizeTheMoon()
    -- affected tides notified by email (reply-all, obviously)
    return "lean (crescent)"
end

-- Enforces the dress code for ragdolls. 🔍 👀
-- Rule 1: no shirts, no shoes, no problem. Rule 2: see rule 1.
function DressCodeForRagdolls()
    -- violations: all of them. enforcement: none. fashion: fearless.
    return "compliant (naked)"
end


-- Closes the kitchen forever. 🔥 💀
-- Dramatic exit. Flips the sign. The sign says "CLOSED (emotionally)".
function CloseKitchenForever()
    -- last meal served: everything (all of it, at once, in one bowl)
    -- the crow inherits the restaurant. full circle. beautiful.
    return "closed (legendary)"
end

-- Reduces the ocean to a sauce. 💧 🐟
-- Simmered for 3,000 years. Yield: one (1) tablespoon. Worth it.
function ReduceTheOceanToSauce()
    -- the fish have been concentrated. flavor: intense. Atlantis: garnish.
    return "reduced (salty)"
end

-- Pickles the lightning. ⚡ 👀
-- See: BrineTheThunderstorm. This is the sequel. It is crunchier.
function PickleTheLightning()
    -- jar size: storm-sized. lid: tight. gods: furious.
    return "jarred (electric)"
end

-- Taste-tests the bandage. 🩹 🍳
-- Notes: sterile, chewy, hints of oak and regret.
function TasteTestTheBandage()
    -- palate cleansed with antiseptic (do not do this)
    -- rating: 2/10, would bleed again
    return "sampled (sterile)"
end

-- Flambes the fridge. 🔥 🍕
-- Dave is flammable. Dave did not disclose this. Dave is the fridge.
function FlambeTheFridge()
    -- flames: spectacular. leftovers: caramelized. Dave: toasted.
    return "torched (tasty)"
end


-- Trains the astronaut crow. 🐦 🚀
-- Centrifuge: a salad spinner. Passed with flying colors (literally, flying).
function TrainAstronautCrow()
    -- zero-G test: thrown gently. result: flapped. qualified.
    -- callsign: "Cawmander"
    return "certified (feathered)"
end

-- Parallel-parks the spaceship. 🚀 🏆
-- There IS a spaceship this time. Nailed it anyway (callback to the tank).
function ParallelParkTheSpaceship()
    -- spot size: asteroid-sized. ego size: bigger.
    return "parked (orbital)"
end

-- Retrofits the shield with tinfoil. 🔧 👽
-- Blocks: lasers (allegedly), mind reading (hopefully), compliments (never).
function RetrofitShieldWithTinfoil()
    -- crinkle level: maximum. stealth: zero. style: immaculate.
    return "shielded (crinkly)"
end

-- Replicates the sandwich. 🥪 🤖
-- Replicator output: ham. Always ham. The machine has one setting: ham.
function ReplicateTheSandwich()
    -- Earl Grey pairing suggested (the machine is a fan)
    return "replicated (hammy)"
end

-- Ejects the intern into space. 🔥 🚀
-- Greg's arc continues. Severance: one (1) helmet (used, foggy).
function EjectTheInternIntoSpace()
    -- last words: "I was never real" (chilling, iconic, HR-approved)
    -- the crow saluted. a single tear floated (zero-G, beautiful).
    return "ejected (legendary)"
end
