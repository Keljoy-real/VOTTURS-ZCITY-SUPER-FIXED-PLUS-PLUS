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
