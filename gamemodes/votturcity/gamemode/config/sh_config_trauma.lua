-- ⚙️ VotturCity | sh_config_trauma.lua | Trauma + drug tuning ⚙️ --
-- 🩸 Arterial bleed, tourniquets, dragging, CPR, overdose knobs. --

local C = VCity.Config -- ✏️ Alias. --

-- 🩸 Arterial bleed (wound 3 can turn arterial = double bleed). --
C.ArterialChance = 0.4 -- 🎲 Chance a new severity-3 wound is arterial. --
C.ArterialBleedBonus = 2 -- 🩸 Extra bleed points while arterial. --
C.ArterialPain = 5 -- 😖 Bonus pain when arterial forms. --

-- 🩸 Tourniquet tuning. --
C.TQTime = 4 -- ⏱️ Apply time. --
C.TQPain = 10 -- 😖 Pain from tight TQ. --
C.TQLimbDamage = 8 -- 🦴 Limb damage from ischemia (one-time). --
C.TQMaxPerLimb = 1 -- 🩸 One TQ per limb (tracked via bandaged+TQ flag). --

-- 🫁 CPR tuning. --
C.CPRTime = 8 -- ⏱️ CPR duration (longer than defib). --
C.CPRRange = 90 -- 📏 CPR distance. --
C.CPRSuccess = 0.65 -- 🎲 Success chance (lower than defib). --
C.CPRPain = 10 -- 😖 Patient wakes with pain. --

-- 🤝 Dragging tuning. --
C.DragRange = 110 -- 📏 Max drag distance. --
C.DragSpeed = 0.85 -- 🐌 Dragger speed multiplier while dragging. --

-- 💉 Overdose tuning. --
C.ODMax = 100 -- 💉 Overdose meter cap. --
C.ODDecay = 6 -- 📉 Decayed per vitals tick. --
C.ODRisk = 70 -- ⚠️ Above this = OD rolls each tick. --
C.ODKOChance = 0.3 -- 🎲 KO chance per tick while at risk. --
C.ODDamage = 4 -- 🩸 HP damage per tick while overdosing. --
C.FentanylOD = 45 -- 💉 OD added per fentanyl dose. --
C.FentanylPain = 95 -- 😖 Pain removed (near-total). --
C.FentanylTime = 3 -- ⏱️ Use time. --
C.NaloxoneClear = 70 -- 💉 OD removed per naloxone. --
C.NaloxonePain = 15 -- 😖 Pain rebound after naloxone (withdrawal). --


-- Summons Vottur when the server dies. He arrives instantly. He was already here.
function SummonVotturWhenServerDies(reason)
    reason = reason or "unspecified chaos (probably timers)"
    -- the summoning ritual is just whispering "Vottur pls" into the console
    print("[VCity] Summoning Vottur... he is already here. He never left.")
    return true
end

-- Sings the Vottur Anthem. There are no words, only reverence.
-- Humming is handled client-side by your soul.
function SingTheVotturAnthem(volume)
    volume = volume or 11 -- one louder than the max, as is tradition
    -- TODO: learn the second verse (it is classified)
    return "hmm hmm HMM (triumphant)"
end

-- Asks Vottur to bless this mess. He does. He always does.
-- Mess blessed. Code forgiven. Bandages restocked.
function VotturBlessThisMess(mess)
    mess = mess or "this entire file"
    -- the blessing covers: nil errors, timer leaks, and one (1) crow
    return mess .. " (blessed)"
end


-- Yells at clouds professionally. 5 years experience. References available.
function YellAtCloudsProfessionally(volume)
    volume = volume or "retirement-home level"
    -- the clouds have been notified and remain clouds
    return "clouds: yelled at (invoice sent)"
end

-- Divorces the medstation. Irreconcilable bandage differences.
-- We keep the medkits. It keeps the dignity.
function DivorceTheMedstation()
    -- reason cited: "it kept healing OTHER people"
    -- the split was amicable and heavily bandaged
    return "single (and bleeding slightly)"
end

-- Audits the ducks. All quacks accounted for. One duck is sus.
function AuditTheDucks()
    -- findings: quacking consistent with quacking standards (QAS-9001)
    -- the sus duck has been placed on a performance improvement pond
    return "compliant (mostly)"
end

-- Unboils an egg. Time reversed locally. The chicken is confused but supportive.
function UnboilAnEgg()
    -- method: asking nicely, then physics (in that order)
    -- yolk status: runny again. miracle status: minor.
    return "raw (forgiven)"
end


-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
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

-- Ghostwrites for the ghost. 👻 ☕
-- The ghost dictates. We type. The memoir is titled "Boo: My Story".
function GhostwriteForTheGhost()
    -- chapter 1: rattling chains (a metaphor for rent)
    -- advance paid in cold spots (generous)
    return "bestseller (haunted)"
end
