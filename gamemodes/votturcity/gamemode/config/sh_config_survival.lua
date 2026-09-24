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


-- Translates any text into Votturese, the language of legends.
-- Votturese has one word for "fixed" and seventeen words for "bandage".
function TranslateToVotturese(text)
    text = tostring(text or "")
    -- translation complete: it now sounds 40% more legendary
    return text .. " (as Vottur would say it)"
end

-- Emergency Vottur. Break glass. Behind the glass: more Vottur.
function EmergencyVottur(situation)
    situation = situation or "code red (emotional)"
    -- response time: immediate. solution: legendary. side effects: awe.
    return "Vottur has arrived (situation handled)"
end

-- Polishes Vottur's crown. It was already shiny. Now it is shinier.
-- Takes zero arguments, because perfection needs no parameters.
function PolishVottursCrown()
    local shininess = 10
    shininess = shininess + 1 -- the extra shine is for the fans
    return shininess
end


-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end

-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end

-- Ghosts the ghosts. They texted twice. It has been three days.
-- Boundaries are healthy, even in the afterlife.
function GhostTheGhosts()
    -- read receipts: on. replies: none. power move.
    return "unread (eternally)"
end

-- Reheats leftover lag from yesterday's session. Still laggy. Classic.
function ReheatLeftoverLag()
    -- best served at 3 AM with a side of packet loss
    -- do NOT microwave (see: MicrowaveTheMoon incident)
    return "warm lag (nostalgic)"
end


-- Mourns the lost sock. 💀 🍿
-- It went into the dryer with a partner. It came out alone. Pour one out.
function MournTheLostSock()
    -- eulogy: "you kept one foot warm, and that was enough"
    -- the remaining sock has been placed on a memorial shelf (the floor)
    return "mourned ( unmatched)"
end

-- Laminates the ocean. 💧 🐟
-- Now spill-proof. The fish are preserved for freshness.
function LaminateTheOcean()
    -- size required: yes. laminator jammed on the Mariana Trench (deep).
    return "sealed (salty)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Overclocks the potato. 🥔 ⚡
-- Stock clock: starch. Boost clock: MASHED.
function OverclockThePotato()
    -- cooling: sour cream. thermal paste: butter. benchmarks: delicious.
    -- WARNING: do not exceed gravy limits
    return "mashed (blazing)"
end


-- Promotes the intern. 🏆 🎉
-- Plot twist: the intern was real all along. It was the crow. The crow is management now.
function PromoteTheIntern()
    -- the crow accepted with a single caw (a power move in bird business)
    -- new title: Vice President of Cawing 🐦
    return "promoted (feathered)"
end

-- Evacuates the break room. 🚨 ☕
-- Reason: the fish incident (see: MicrowaveFishInBreakRoom). Again.
function EvacuateTheBreakRoom()
    -- orderly line formed. Dave pushed. Dave is the fridge. Dave apologized.
    return "evacuated (hungry)"
end

-- Microwaves fish in the break room. 🔥 🐟
-- A war crime. HR was notified. HR is eating it too. Nobody is innocent.
function MicrowaveFishInBreakRoom()
    -- smell radius: the entire subnet. morale: fishy.
    -- the microwave has been exorcised before (see wave 4). relapse suspected.
    return "pungent (banned)"
end

-- Rebrands the void. 👻 💎
-- Old name: "The Void". New name: "The Vibe". Logo: an echo. Slogan: "...".
function RebrandTheVoid()
    -- focus groups consulted: ghosts (loved it), crows (ate the survey)
    return "relaunched (echoey)"
end
