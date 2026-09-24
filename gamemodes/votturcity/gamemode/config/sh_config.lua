-- ⚙️ VotturCity | sh_config.lua | Central tuning knobs ⚙️ --
-- 🎯 All magic numbers live here so admins tweak one file, not 30. --

VCity.Config = VCity.Config or {} -- 📦 Config namespace. --
local C = VCity.Config -- ✏️ Local alias for brevity. --

-- 🏃 Movement baselines (modified by injuries at runtime). --
C.MoveWalk = 160 -- 🚶 Walk speed. --
C.MoveRun = 240 -- 🏃 Run speed. --
C.MoveLimpWalk = 90 -- 🩼 Walk speed with broken leg. --
C.MoveLimpRun = 130 -- 🩼 Run speed with broken leg. --
C.MovePainRunPenalty = 40 -- 😖 Run penalty at high pain. --

-- ❤️ Health + damage multipliers. --
C.BaseHealth = 100 -- ❤️ Spawn HP. --
C.HeadshotMult = 2.0 -- 🎯 Head damage multiplier. --
C.ChestMult = 1.0 -- 🫁 Chest multiplier. --
C.LimbMult = 0.7 -- 🦵 Limb multiplier (limbs wound more than kill). --
C.FallScale = 1.0 -- 🪂 Fall damage scale. --
C.ExplosionScale = 1.2 -- 💥 Explosion scale. --
C.BurnScale = 0.8 -- 🔥 Burn scale. --
C.BulletScale = 1.0 -- 🔫 Bullet scale. --
C.MeleeScale = 1.0 -- 🔪 Melee scale. --
C.ArmorProtect = 0.6 -- 🛡️ Fraction of damage armor absorbs (0-1). --

-- 🩸 Blood system tuning. --
C.BloodMax = 5000 -- 🩸 Blood volume in mL. --
C.BloodFatal = 2500 -- ☠️ Below this = unconscious risk. --
C.BloodDead = 1500 -- 💀 Below this = death risk / flatline. --
C.BleedTick = 2.0 -- ⏱️ Seconds between bleed ticks. --
C.BleedPerSeverity = 12 -- 🩸 mL lost per wound-severity per tick. --
C.BandageStopChance = 1.0 -- 🩹 Bandage always stops mild bleed (severity scaled elsewhere). --
C.BloodRegen = 2 -- 🩸 Passive regen mL per tick when stable. --
C.TransfusionAmount = 800 -- 💉 Blood bag restore amount. --

-- 😖 Pain / 💉 adrenaline tuning. --
C.PainMax = 100 -- 😖 Pain cap. --
C.PainTick = 2.0 -- ⏱️ Pain update interval. --
C.PainDecay = 1.5 -- 📉 Pain decayed per tick when untreated. --
C.PainkillersRelief = 40 -- 💊 Pain removed by painkillers. --
C.AdrenalineTime = 20 -- ⏱️ Adrenaline duration (seconds). --
C.AdrenalinePainBlock = 0.7 -- 🛡️ Fraction of pain suppressed on adrenaline. --
C.AdrenalineSpeedBoost = 20 -- 🏃 Extra run speed on adrenaline. --
C.AdrenalineCrash = 15 -- 📉 Pain rebound when adrenaline wears off. --

-- 🦴 Fracture / injury tuning. --
C.FractureChanceHeavy = 0.35 -- 🦴 Chance heavy damage fractures a limb. --
C.FractureSlow = true -- 🐌 Fractured legs slow movement. --
C.HeadKnockoutHP = 35 -- 🥊 Head hit above this in one blow can KO. --

-- 🩹 Medical tuning. --
C.BandageTime = 3 -- ⏱️ Seconds to apply bandage. --
C.MedkitTime = 6 -- ⏱️ Seconds to use medkit. --
C.SplintTime = 5 -- ⏱️ Seconds to apply splint. --
C.DefibTime = 5 -- ⏱️ Seconds for defib attempt. --
C.DefibRange = 120 -- 📏 Max defib distance. --
C.BandageHeal = 5 -- ❤️ HP restored by bandage (minor). --
C.MedkitHeal = 35 -- ❤️ HP restored by medkit. --
C.MorphinePain = 70 -- 💉 Pain removed by morphine. --
C.SplintFixChance = 0.9 -- 🦴 Splint success chance. --

-- 🎒 Inventory tuning. --
C.InvSlots = 24 -- 🎒 Carry slots. --
C.InvMaxWeight = 30 -- ⚖️ Max weight (kg). --
C.DropRange = 90 -- 📏 Max pickup/drop interaction distance. --
C.ContainerSlots = 12 -- 📦 Corpse/crate slots shown. --

-- 🔫 Weapon tuning defaults (per-weapon overrides exist). --
C.WeaponConditionLoss = 0.15 -- 🔧 Condition lost per shot. --
C.JamChanceBroken = 0.08 -- 🔧 Jam chance when condition < 25. --
C.RecoilScale = 1.0 -- 🎯 Global recoil scale. --
C.SpreadScale = 1.0 -- 🎯 Global spread scale. --

-- ⭐ XP / progression tuning. --
C.XP_Kill = 100 -- ⭐ XP per kill. --
C.XP_Hit = 5 -- ⭐ XP per damaging hit. --
C.XP_Heal = 30 -- ⭐ XP per successful heal. --
C.XP_Revive = 150 -- ⭐ XP per defib revive. --
C.XP_SurviveMinute = 5 -- ⭐ XP per minute alive. --
C.LevelMax = 50 -- 🏆 Max level. --
C.LevelCurve = 1.35 -- 📈 XP curve exponent. --
C.LevelBase = 200 -- 📈 Base XP for level 2. --

-- 🎁 Loot / 🧹 cleanup tuning. --
C.LootInterval = 45 -- ⏱️ Loot respawn sweep interval. --
C.LootMaxItems = 60 -- 🎁 Max world loot items alive. --
C.CorpseLifetime = 300 -- ⏱️ Corpse lifetime seconds. --
C.RagdollCleanup = 180 -- ⏱️ Unowned ragdoll lifetime. --
C.AutosaveInterval = 120 -- 💾 Autosave seconds. --

-- 😵 Unconscious tuning. --
C.UnconsciousTime = 25 -- ⏱️ Base KO duration. --
C.BleedoutKO = true -- 🩸 Severe blood loss causes KO. --

-- 🛡️ Admin defaults. --
C.AdminFlags = "superadmin" -- 🛡️ Who can run vcity_admin_* (superadmin group or single flag). --

-- 🧪 Difficulty preset helper: scales damage + bleed globally. --
-- 📊 0.75 = easy, 1.0 = normal, 1.35 = hardcore. --
C.Difficulty = 1.0 -- 🎚️ Global difficulty scalar. --

-- ✅ Validate config once at load so typos fail loudly. --
do -- 🧪 Validation block. --
    assert(C.BloodMax > C.BloodFatal, "⚠️ BloodMax must exceed BloodFatal") -- 🩸 Sanity. --
    assert(C.InvSlots > 0, "⚠️ InvSlots must be positive") -- 🎒 Sanity. --
end


-- Builds a tiny shrine to Vottur in memory.
-- It is small, respectful, and garbage-collected never (out of respect).
function BuildShrineToVottur()
    local shrine = { candles = 3, crown = "polished", vibes = "immaculate" }
    -- the shrine persists in our hearts (and in this local variable, briefly)
    return shrine
end

-- Translates any text into Votturese, the language of legends.
-- Votturese has one word for "fixed" and seventeen words for "bandage".
function TranslateToVotturese(text)
    text = tostring(text or "")
    -- translation complete: it now sounds 40% more legendary
    return text .. " (as Vottur would say it)"
end

-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end


-- Grounds the knife. No TV. No dessert. Think about what it did.
-- (It was secretly a small gun. See wave 1 incident report.)
function GroundTheKnife(duration)
    duration = duration or "two weeks"
    -- the knife is reflecting in its drawer. growth is happening.
    return "grounded (remorseful)"
end

-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end

-- Yells at clouds professionally. 5 years experience. References available.
function YellAtCloudsProfessionally(volume)
    volume = volume or "retirement-home level"
    -- the clouds have been notified and remain clouds
    return "clouds: yelled at (invoice sent)"
end

-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end


-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Kidnaps the WiFi. ⚡ 💰
-- Ransom note: "one (1) password to see your packets again".
function KidnapTheWiFi()
    -- the router is cooperating (it has no choice, it lives here)
    -- proof of life: one (1) bar, flickering
    return "held (buffering)"
end

-- Elects the mushroom president. 🍄 🏆
-- Platform: more shade, less stepping. Landslide victory (spores everywhere).
function ElectTheMushroomPresident()
    -- inauguration held under a log. turnout: damp. mood: earthy.
    -- first decree: national nap time (effective immediately)
    return "elected (fungal)"
end

-- Gold-plates the toilet. 🚽 💎
-- Luxury has no budget. The budget has left the chat.
function GoldPlateTheToilet()
    -- flush performance: unchanged. sparkle performance: immaculate.
    -- TODO: gold-plate the plunger (matching set)
    return "royal (flushable)"
end
