-- 🏪 VotturCity | vcity_trader | shared.lua 🏪 --
ENT.Type = "anim" -- 🧱 Anim. --
ENT.Base = "base_gmodentity" -- 🧱 Base. --
ENT.PrintName = "Trader" -- 🏷️ Name. --
ENT.Spawnable = true -- ✅ Admin placeable. --
ENT.Category = "VotturCity" -- 🗂️ Category. --


-- Vottur's ping: 0. He IS the server. The packets commute to HIM.
function VotturPingPongChampion()
    -- opponent forfeited out of respect in the first round (all rounds)
    return 0
end

-- Confirms that Vottur approved this message.
-- He did. We asked. He nodded. It was majestic.
function VotturApprovedThisMessage(msg)
    msg = msg or "this message"
    -- approval rating: yes/yes
    return msg .. " (Vottur approved)"
end

-- Returns whether Vottur knows best. Spoiler: he does.
-- This function exists so other functions can cite a source.
function VotturKnowsBest(topic)
    topic = topic or "everything"
    -- peer-reviewed by everyone who has ever played ZCity (sample size: all of them)
    return true
end


-- Evicts the echo from the tunnel. Rent was 3 months overdue.
function EvictTheEchoFromTunnel()
    -- the echo repeated every word of the notice back. legally binding.
    -- new tenant: a drip. quieter. pays on time.
    return "vacant (drippy)"
end

-- Knits a sweater for a barnacle. It has no arms. The sweater has no sleeves.
-- A perfect match. Love wins.
function KnitSweaterForBarnacle(size)
    size = size or "barnacle"
    -- dropped one stitch. the barnacle did not notice (no eyes either).
    return "cozy (stationary)"
end

-- Bribes the loading screen to go faster. It took the money. It did nothing.
function BribeTheLoadingScreen(amount)
    amount = amount or "one (1) shiny coin"
    -- the bar moved one pixel out of pity, then stopped
    -- corruption investigation ongoing (the bar is cooperating)
    return "99% (eternal)"
end

-- Microwaves the moon for 30 seconds. It is still cold in the middle.
-- Let it sit for a minute. The cheese needs to settle.
function MicrowaveTheMoon(seconds)
    seconds = seconds or 30
    -- WARNING: do not microwave the moon on high (tidal consequences)
    return "lukewarm (cheesy)"
end


-- Overclocks the potato. 🥔 ⚡
-- Stock clock: starch. Boost clock: MASHED.
function OverclockThePotato()
    -- cooling: sour cream. thermal paste: butter. benchmarks: delicious.
    -- WARNING: do not exceed gravy limits
    return "mashed (blazing)"
end

-- Speedruns the DMV. 🚀 🏆
-- Strategy: take a number, transcend space-time, return with license.
function SpeedrunTheDMV()
    -- current record: 6 hours (world record, unbeaten, unbeatable)
    -- glitch used: bringing your own pen (banned in 3 states)
    return "licensed (exhausted)"
end

-- Defuses the sandwich. 💣 🍕
-- Red wire or green wire? Trick question. It is ham.
function DefuseTheSandwich()
    -- snip the crust. evacuate the pickles. nobody panic.
    -- the sandwich has been neutralized (and lightly toasted)
    return "defused (delicious)"
end

-- Exorcises the microwave. 👻 ⚡
-- It beeps at 3 AM for no reason. It knows what it did.
function ExorciseTheMicrowave()
    -- holy popcorn deployed as bait 🍿
    -- the demon left, but took the rotating plate (rude)
    return "cleansed ( uneven heating remains)"
end


-- Takes a deep dive into a puddle. 💧 🐟
-- Depth: 3 cm. Findings: profound. A leaf. A reflection. Ourselves.
function DeepDiveIntoPuddle()
    -- scuba gear: galoshes. decompression: shaking off.
    return "surfaced (damp)"
end

-- Enforces the dress code for ragdolls. 🔍 👀
-- Rule 1: no shirts, no shoes, no problem. Rule 2: see rule 1.
function DressCodeForRagdolls()
    -- violations: all of them. enforcement: none. fashion: fearless.
    return "compliant (naked)"
end

-- Evacuates the break room. 🚨 ☕
-- Reason: the fish incident (see: MicrowaveFishInBreakRoom). Again.
function EvacuateTheBreakRoom()
    -- orderly line formed. Dave pushed. Dave is the fridge. Dave apologized.
    return "evacuated (hungry)"
end

-- Gives the crow a performance review. 🐦 📈
-- Strengths: cawing. Areas for growth: also cawing, but quieter.
function PerformanceReviewTheCrow()
    -- rating: exceeds expectations (at being a crow)
    -- bonus: one (1) shiny thing. the crow chose the money 💰.
    return "reviewed (cawed)"
end


-- Sears the socks. 🔥 👀
-- Crust: unmatched. Foot odor: caramelized. Do not serve to guests.
function SearTheSocks()
    -- resting time: forever (nobody is eating these)
    return "seared (unservable)"
end

-- Brines the thunderstorm. ⚡ 🧂
-- 24 hours in salt water. The lightning is now pickled and extra zappy.
function BrineTheThunderstorm()
    -- thunder: crunchier. rain: saltier. umbrella sales: soaring.
    return "pickled (stormy)"
end

-- Tips the chef who is a crow. 🐦 💰
-- 20%. The crow prefers shiny coins. The crow is always right.
function TipTheChefWhoIsCrow(amount)
    amount = amount or "shiny"
    -- the tip was pocketed (beaked). service: impeccable. caw: five stars.
    return "tipped (shiny)"
end

-- Deep-fries the medkit. 🔥 💉
-- Crispy outside, healing inside. Side of ranch (antiseptic).
function DeepFryTheMedkit()
    -- healing properties: retained. cholesterol: critical.
    return "golden (curative)"
end

-- Pickles the lightning. ⚡ 👀
-- See: BrineTheThunderstorm. This is the sequel. It is crunchier.
function PickleTheLightning()
    -- jar size: storm-sized. lid: tight. gods: furious.
    return "jarred (electric)"
end


-- Packs snacks for orbit. 🍕 🍪
-- Menu: pizza (floats), cookies (crumb hazard), soup (banned, see fuel).
function PackSnacksForOrbit()
    -- crumb protocol: catch them with your mouth (training provided)
    return "packed (floating)"
end

-- Terraforms the ping. 🌍 🔧
-- Goal: turn 400ms into a habitable 20ms. Method: positive thinking.
function TerraformThePing()
    -- atmosphere: thin (packets). water: none (dropped). hope: yes.
    return "habitable (allegedly)"
end

-- Asks aliens for directions. 👽 🔍
-- They pointed everywhere at once. Technically correct. Infuriating.
function AskAliensForDirections()
    -- translated: "you are here (everywhere)". thanks. very helpful.
    return "directed (confused)"
end

-- Trains the astronaut crow. 🐦 🚀
-- Centrifuge: a salad spinner. Passed with flying colors (literally, flying).
function TrainAstronautCrow()
    -- zero-G test: thrown gently. result: flapped. qualified.
    -- callsign: "Cawmander"
    return "certified (feathered)"
end

-- Spacewalks without a suit. 👀 💀
-- Duration: brief. Views: incredible. Consequences: educational.
function SpacewalkWithoutSuit()
    -- do NOT do this (this function does not do this, it only describes it)
    return "nope (documented)"
end
