-- ⚙️ VotturCity | sh_config_survival.lua | Survival tuning extension ⚙️ --
-- 🍖 Hunger / thirst / stamina / temperature knobs live here (not scattered). --

local C = VCity.Config -- ✏️ Alias into main config table. --

-- 🍖 Hunger / 🥤 thirst (0 = starving/dehydrated, 100 = full). --
C.HungerMax = 100 -- 🍖 Max satiety. --
C.ThirstMax = 100 -- 🥤 Max hydration. --
C.HungerTick = 5 -- ⏱️ Seconds between hunger/thirst ticks. --
C.HungerDrain = 0.35 -- 🍖 Lost per tick (100 lasts ~24 min). --
C.ThirstDrain = 0.5 -- 🥤 Lost per tick (100 lasts ~17 min). --
C.SprintHungerCost = 0.15 -- 🏃 Extra hunger per survival tick while sprinting a lot. --
C.StarveHP = 3 -- 🩸 HP damage per tick at 0 hunger. --
C.DehydrateHP = 4 -- 🩸 HP damage per tick at 0 thirst. --
C.StarvePain = 2 -- 😖 Pain added per starving tick. --

-- ⚡ Stamina (0-100, sprint drains, rest restores). --
C.StaminaMax = 100 -- ⚡ Cap. --
C.StaminaTick = 1 -- ⏱️ Stamina timer interval. --
C.StaminaSprintDrain = 9 -- 🏃 Lost per second sprinting. --
C.StaminaJumpCost = 8 -- 🦘 Cost per jump. --
C.StaminaRegen = 7 -- 😴 Regained per second idle/walking. --
C.StaminaExhaustSlow = 0.6 -- 🐌 Speed multiplier when exhausted. --
C.StaminaMinJump = 15 -- 🦘 Need this much to jump (else blocked softly). --

-- 🌡️ Temperature (37 = normal, <35 hypothermia, >39 fever/heat). --
C.TempNormal = 37 -- 🌡️ Baseline C. --
C.TempTick = 5 -- ⏱️ Temp update interval (shares survival tick). --
C.TempWaterLoss = 0.6 -- 🥶 Temp drop per tick while submerged. --
C.TempNightLoss = 0.15 -- 🌙 Drop per tick at night (weather module sets night). --
C.TempFireGain = 0.8 -- 🔥 Gain per tick near campfire. --
C.TempRecover = 0.1 -- 🌡️ Drift back toward normal per tick. --
C.HypoPain = 3 -- 😖 Pain per tick when hypothermic. --
C.HyperPain = 3 -- 😖 Pain per tick when hyperthermic. --
C.HypoBleedMult = 1.25 -- 🩸 Bleed multiplier when freezing (blood thick? gameplay: worse). --

-- 🫁 Oxygen (underwater breath, 100 -> 0, then HP damage). --
C.OxygenMax = 100 -- 🫁 Lung capacity. --
C.OxygenDrain = 20 -- 🫁 Lost per second submerged. --
C.OxygenRegen = 40 -- 🫁 Regained per second above water. --
C.DrownHP = 8 -- 🩸 HP per second while at 0 oxygen. --

-- 🥫 Consumable power (food restores hunger + tiny heal, water restores thirst). --
C.FoodHealSmall = 3 -- ❤️ Small heal from snacks. --
C.CoffeeStamina = 35 -- ☕ Stamina restored by coffee. --
C.CoffeePainCut = 8 -- 😖 Pain cut from caffeine. --
C.AlcoholPainCut = 20 -- 🍺 Pain cut but hunger cost (see defs). --
C.AlcoholWobble = 10 -- 🌀 Screen wobble seconds (client FX). --
