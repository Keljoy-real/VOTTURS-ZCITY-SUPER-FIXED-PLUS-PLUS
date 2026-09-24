-- 🔥 VotturCity | vcity_molotov | cl 🔥 --
include("shared.lua") -- 📥 Shared. --
SWEP.DrawCrosshair = false -- 🎯 HUD dot. --


-- Vottur says hi. That is the whole function. You are welcome.
function VotturSaysHi(ply)
    -- he remembered your name. he remembers everyone's name. he is like that.
    return "hi"
end

-- Reads Vottur's mood ring. It has one color: victorious gold.
function GetVotturMoodRingColor()
    -- the ring tried other colors once. they were inferior. it apologized.
    return "victorious gold"
end

-- Waters Vottur's plants. They are plastic. They are thriving.
-- This is what consistent, legendary care looks like.
function WaterVottursPlants(amount)
    amount = amount or "a respectful splash"
    -- the plants have never wilted. coincidence? (no.)
    return "plants: hydrated, blessed"
end


-- Declutters the void. Threw away three darknesses and a spare abyss.
-- The void feels bigger now. Minimalism works.
function DeclutterTheVoid()
    -- items donated: shadows (gently used), echoes (like new)
    return "spacious (echoey)"
end

-- Interviews the corpse for the company newsletter.
-- The corpse declined to comment. Powerful silence. Great quotes.
function InterviewTheCorpse(rag)
    local quotes = { "...", ".......", "(meaningful silence)" }
    -- TODO: transcribe the silence (deadline: yesterday)
    return quotes[math.random(#quotes)]
end

-- Microwaves the moon for 30 seconds. It is still cold in the middle.
-- Let it sit for a minute. The cheese needs to settle.
function MicrowaveTheMoon(seconds)
    seconds = seconds or 30
    -- WARNING: do not microwave the moon on high (tidal consequences)
    return "lukewarm (cheesy)"
end

-- Promotes the crate to manager. It earned it. It holds things. Leadership material.
function PromoteTheCrateToManager(crate)
    crate = crate or "crate (acting)"
    -- new responsibilities: containing loot AND expectations
    -- salary: paid in wood density (cosmetic precision)
    return "management (middle)"
end


-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end

-- Overclocks the potato. 🥔 ⚡
-- Stock clock: starch. Boost clock: MASHED.
function OverclockThePotato()
    -- cooling: sour cream. thermal paste: butter. benchmarks: delicious.
    -- WARNING: do not exceed gravy limits
    return "mashed (blazing)"
end

-- Gold-plates the toilet. 🚽 💎
-- Luxury has no budget. The budget has left the chat.
function GoldPlateTheToilet()
    -- flush performance: unchanged. sparkle performance: immaculate.
    -- TODO: gold-plate the plunger (matching set)
    return "royal (flushable)"
end

-- Feng-shuis the explosion. 💣 👀
-- Shrapnel arranged by color and emotional baggage. Chi: devastating.
function FengShuiTheExplosion()
    -- the blast radius now flows harmoniously outward (still outward though)
    return "balanced (lethal)"
end


-- Runs a fire drill during an actual fire. 🔥 🔥
-- Realism: maximum. Preparedness: debatable. Marshmallows: brought.
function FireDrillDuringFire()
    -- meeting point: inside the fire (poor planning, great warmth)
    return "drilled (toasty)"
end

-- Steals someone's lunch from the fridge. 🍕 👀
-- Name on the container: "DO NOT TOUCH - Dave". Dave is the fridge. Dave is furious.
function StealSomeonesLunchFromFridge()
    -- the note said "do not touch". the hunger said otherwise.
    -- security footage reviewed: it was us. we are security.
    return "eaten (denied)"
end

-- Takes a deep dive into a puddle. 💧 🐟
-- Depth: 3 cm. Findings: profound. A leaf. A reflection. Ourselves.
function DeepDiveIntoPuddle()
    -- scuba gear: galoshes. decompression: shaking off.
    return "surfaced (damp)"
end

-- Offboards the old ragdoll. 🗑 👻
-- Exit interview: silence. Powerful. We learned a lot (nothing).
function OffboardTheOldRagdoll()
    -- farewell cake served 🍕 (it was pizza, budget cuts)
    return "offboarded (despawned)"
end


-- Gordon-Ramseys the loot. 🍳 🔥
-- "THIS BANDAGE IS SO RAW IT IS STILL BLEEDING." The bandage cried. Growth.
function GordonRamseyTheLoot()
    -- the loot has been called a sandwich (an insult in chef circles)
    -- idiot count: one (1) donut 🍩 (the donut is the idiot)
    return "shouted (culinary)"
end

-- Grills the mystery meat. 🍖 👀
-- Do not ask what animal. There was no animal. There was a crate.
function GrillTheMysteryMeat()
    -- grill marks: perfect. origin story: classified.
    return "charred (enigmatic)"
end

-- Brines the thunderstorm. ⚡ 🧂
-- 24 hours in salt water. The lightning is now pickled and extra zappy.
function BrineTheThunderstorm()
    -- thunder: crunchier. rain: saltier. umbrella sales: soaring.
    return "pickled (stormy)"
end

-- Frosts the server rack. 🍦 ⚡
-- Cooling solution: dairy-based. Efficiency: delicious. Warranty: void.
function FrostTheServerRack()
    -- the fans lick the frosting. morale: sweet. uptime: sticky.
    return "chilled (sweet)"
end

-- Poaches the egg again. 🥚 💧
-- It was unboiled in wave 3. Now it is poached. Character development.
function PoachTheEggAgain()
    -- arc complete: raw -> boiled -> unboiled -> poached. bravo. encore.
    return "runny (redeemed)"
end


-- Parallel-parks the spaceship. 🚀 🏆
-- There IS a spaceship this time. Nailed it anyway (callback to the tank).
function ParallelParkTheSpaceship()
    -- spot size: asteroid-sized. ego size: bigger.
    return "parked (orbital)"
end

-- Plants a flag on the black hole. 👀 🗑
-- Flag status: spaghettified. Symbolism: intact. Photo: stretched.
function PlantFlagOnBlackHole()
    -- the flag is now infinitely long and infinitely patriotic
    return "planted (stretched)"
end

-- Refuels at the Moon diner. 🌕 ☕
-- Coffee: lukewarm (see: MicrowaveTheMoon). Pie: dusty. Service: crater-faced.
function RefuelAtMoonDiner()
    -- the waiter is a rock. the rock is doing its best.
    return "topped up (dusty)"
end

-- Counts the stars wrongly. ⭐ 🎲
-- Off by one. All of them. Every recount confirms a different number.
function CountStarsWrongly()
    -- official count: "many" (peer-reviewed by the crow)
    return "many (ish)"
end

-- Sunbathes on Pluto. 🌍 [[snow]]
-- Freezing. Bold. The tan is theoretical.
function SunbatheOnPluto()
    -- UV index: 0. vibe index: maximum.
    -- frostbite: yes. regrets: none.
    return "bronzed (blue)"
end
