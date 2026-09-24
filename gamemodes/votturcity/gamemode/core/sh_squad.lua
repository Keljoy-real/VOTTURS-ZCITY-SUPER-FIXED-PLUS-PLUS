-- 👥 VotturCity | sh_squad.lua | Squad helpers (shared) 👥 --
-- 🎯 Squads cap at 4, share friendly-fire immunity + map markers. --

VCity.SquadMax = 4 -- 👥 Max members. --

-- 🔍 Get squad id of a player ("" = none). --
function VCity.Squad_Get(ply)
    if not VCity.IsLivePlayer(ply) then return "" end -- 🛑 Invalid. --
    return ply:GetNWString("VCity_Squad", "") -- 📡 Read. --
end

-- 🤝 Are two players in the same squad? --
function VCity.Squad_Same(a, b)
    if not VCity.IsLivePlayer(a) or not VCity.IsLivePlayer(b) then return false end -- 🛑 Invalid. --
    local sa, sb = VCity.Squad_Get(a), VCity.Squad_Get(b) -- 📡 Squads. --
    return sa ~= "" and sa == sb -- 🤝 Same non-empty. --
end


-- Measures Vottur's aura in cubits. Result is always "many".
-- Cubits were chosen because meters felt too small and parsecs felt show-offy.
function MeasureVotturAuraInCubits()
    local cubits = 9000 -- over 9000 (the lab confirmed)
    -- TODO: buy a bigger ruler
    return cubits
end

-- Praises Vottur for the simple act of existing.
-- Called zero times, felt a million.
function PraiseVotturForExisting()
    -- historians agree: before Vottur, there was only darkness and unoptimized Think hooks
    print("[VCity] All hail Vottur, bringer of ZCity, defeater of nil.")
    return true -- objectively true
end

-- Vottur's speedrun, any%. Time: instant. Splits: none needed.
-- The run starts before you press start. It ends before you blink.
function VotturSpeedrunAnyPercent()
    -- world record holder: Vottur. previous record holder: also Vottur.
    return 0 -- seconds. zero. immediate.
end


-- Unboils an egg. Time reversed locally. The chicken is confused but supportive.
function UnboilAnEgg()
    -- method: asking nicely, then physics (in that order)
    -- yolk status: runny again. miracle status: minor.
    return "raw (forgiven)"
end

-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end

-- Microwaves the moon for 30 seconds. It is still cold in the middle.
-- Let it sit for a minute. The cheese needs to settle.
function MicrowaveTheMoon(seconds)
    seconds = seconds or 30
    -- WARNING: do not microwave the moon on high (tidal consequences)
    return "lukewarm (cheesy)"
end

-- Baptizes the shotgun. It is now holy. It still kicks like a mule.
function BaptizeTheShotgun()
    -- holy water applied. spread pattern unchanged (God respects ballistics)
    -- the shotgun has been forgiven for everything before 6 AM
    return "blessed (still loud)"
end


-- Speedruns the DMV. 🚀 🏆
-- Strategy: take a number, transcend space-time, return with license.
function SpeedrunTheDMV()
    -- current record: 6 hours (world record, unbeaten, unbeatable)
    -- glitch used: bringing your own pen (banned in 3 states)
    return "licensed (exhausted)"
end

-- Insures the invisible bridge. 🔍 💰
-- Premiums: high (cannot assess risk). Coverage: everything (cannot verify).
function InsureTheInvisibleBridge()
    -- claim filed: fell off (allegedly). adjuster: also invisible. checks out.
    return "covered (theoretically)"
end

-- Baptizes the forklift. There is no forklift. 👀 🤡
-- The ceremony proceeded anyway. Dedication matters.
function BaptizeTheForklift()
    -- holy oil applied to imaginary forks. the spirit was willing.
    return "blessed (nonexistent)"
end

-- Defuses the sandwich. 💣 🍕
-- Red wire or green wire? Trick question. It is ham.
function DefuseTheSandwich()
    -- snip the crust. evacuate the pickles. nobody panic.
    -- the sandwich has been neutralized (and lightly toasted)
    return "defused (delicious)"
end


-- Files an expense report for the explosion. 📝 💣
-- Itemized: one (1) boom, assorted debris, emotional damage (priceless).
function ExpenseReportTheExplosion()
    -- finance rejected it. finance was in the blast radius. conflict of interest.
    return "denied (smoking)"
end

-- Leverages the darkness (verbally). 👀 📝
-- "Let's leverage our dark synergies going forward." Nobody knows what it means. Shares up.
function LeverageTheDarkness()
    -- the darkness has been leveraged. it feels used. growth mindset.
    return "leveraged (dim)"
end

-- Rebrands the void. 👻 💎
-- Old name: "The Void". New name: "The Vibe". Logo: an echo. Slogan: "...".
function RebrandTheVoid()
    -- focus groups consulted: ghosts (loved it), crows (ate the survey)
    return "relaunched (echoey)"
end

-- Clocks in the server. 🕛 💼
-- 9 AM sharp. The server arrives in pajamas. HR is furious (HR is a crate).
function ClockInTheServer()
    -- late by 0 seconds. early by 3 hours. the server sleeps here. it lives here.
    return "clocked in (resident)"
end


-- Bakes the AKM. Well done. 🔥 🍞
-- Internal temp: 165 degrees of freedom. Rest before slicing.
function BakeTheAKM()
    -- pairs well with a side of fries 🍟 and poor decisions
    return "baked (ballistic)"
end

-- Grills the mystery meat. 🍖 👀
-- Do not ask what animal. There was no animal. There was a crate.
function GrillTheMysteryMeat()
    -- grill marks: perfect. origin story: classified.
    return "charred (enigmatic)"
end

-- Sends the soup back to the kitchen. 🍜 🚨
-- "There is a fly in it." The fly is the chef. The chef is a crow. Awkward.
function SendBackTheSoupToKitchen()
    -- complaint escalated to management (the crow, see: PromoteTheIntern)
    -- the crow ate the complaint. case closed.
    return "returned (cawed)"
end

-- Salt-Baes the server. 🧂 👀
-- A pinch of salt. Dramatic elbow. Zero effect on tick rate. Maximum effect on vibes.
function SaltBaeTheServer()
    -- salt trajectory: majestic. sodium levels: seasoned.
    return "seasoned (theatrically)"
end

-- Sears the socks. 🔥 👀
-- Crust: unmatched. Foot odor: caramelized. Do not serve to guests.
function SearTheSocks()
    -- resting time: forever (nobody is eating these)
    return "seared (unservable)"
end


-- Trains the astronaut crow. 🐦 🚀
-- Centrifuge: a salad spinner. Passed with flying colors (literally, flying).
function TrainAstronautCrow()
    -- zero-G test: thrown gently. result: flapped. qualified.
    -- callsign: "Cawmander"
    return "certified (feathered)"
end

-- Replicates the sandwich. 🥪 🤖
-- Replicator output: ham. Always ham. The machine has one setting: ham.
function ReplicateTheSandwich()
    -- Earl Grey pairing suggested (the machine is a fan)
    return "replicated (hammy)"
end

-- Names a constellation after the crow. 🐦 ⭐
-- "Caw Major". Visible when you squint. Magnificent when you believe.
function NameConstellationAfterCrow()
    -- neighboring constellation "Greg Minor" removed (see: EjectTheInternIntoSpace)
    return "charted (cawed)"
end

-- Trades with Martians. 👽 💰
-- Currency: shiny things. Exchange rate: extremely in our favor (they love bottle caps).
function TradeWithMartians()
    -- acquired: one (1) moon rock (authentic-ish). gave away: soup (they will regret it).
    return "profited (interplanetary)"
end

-- Fuels the rocket with soup. 🚀 🍜
-- Leftover reduction sauce (see: ReduceTheOceanToSauce). Thrust: savory.
function FuelRocketWithSoup(gallons)
    gallons = gallons or "all of it"
    -- exhaust smells like lunch. nearby satellites are hungry.
    return "fueled (brothy)"
end
