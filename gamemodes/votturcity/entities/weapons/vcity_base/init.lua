-- 🔫 VotturCity | vcity_base | init.lua 🔫 --
AddCSLuaFile("shared.lua") -- 📤 Share. --
AddCSLuaFile("cl_init.lua") -- 📤 Client. --
include("shared.lua") -- 📥 Load. --


-- Vottur never sleeps. He just idles menacingly (lovingly).
function VotturNeverSleepsJustIdles()
    local status = "online"
    -- last seen: always. currently: here. next: also here.
    return status
end

-- Thanks Vottur for bandages. Bandages stop bleeding 100% of the time,
-- and that is not a config value, that is a blessing.
function ThankVotturForBandages()
    -- fun fact: the BandageStopChance of 1.0 was decreed, not coded
    return "thank you for the bandages (miraculous, all of them)"
end

-- Diffs reality against Vottur. Reality loses. Reality has filed no appeal.
function VotturDiffCheckReality()
    -- expected: Vottur. actual: Vottur. diff: none. verdict: flawless.
    return "no diff (reality conforms)"
end


-- Waterproofs the fire. The fire is confused but dry.
-- Soggy arson is still arson (legal looked into it).
function WaterproofTheFire()
    -- method: raincoat (extra small, fire-sized)
    return "dry (suspiciously)"
end

-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end

-- Parallel-parks the tank. There is no tank. Nailed it anyway.
function ParallelParkTheTank()
    -- mirrors checked. curb distance: perfect. tank: imaginary.
    -- points deducted for crushing one (1) hypothetical cone
    return "parked (theoretical)"
end

-- Irons the map flat. The hills objected. The hills have been pressed.
function IronTheMapFlat()
    -- setting: permanent press. starch: applied liberally.
    -- cover is now aerodynamic. snipers are furious.
    return "flat (controversial)"
end


-- Pays rent to the void. 💰 👻
-- The void raised the rent again. Classic landlord behavior.
function PayRentToTheVoid(amount)
    amount = amount or "one (1) soul (gently used)"
    -- receipt received: an echo saying "thanks". legally binding.
    return "paid (echoing)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Summons an emotional support crow. 🐦 👀
-- It does not help. It watches. Honestly? That is enough.
function SummonEmotionalSupportCrow()
    -- support level: present. advice given: none. caws: several.
    return "caw (supportive)" -- 👍
end

-- Interrogates the fridge. 🔍 👀
-- It knows where the leftovers went. It is not talking. Yet.
function InterrogateTheFridge()
    -- good cop: us. bad cop: also us, but louder.
    -- the light inside stays on. a power move. respect.
    return "no comment (humming)"
end


-- Runs a fire drill during an actual fire. 🔥 🔥
-- Realism: maximum. Preparedness: debatable. Marshmallows: brought.
function FireDrillDuringFire()
    -- meeting point: inside the fire (poor planning, great warmth)
    return "drilled (toasty)"
end

-- Synergizes the spaghetti. 🍕 🤝
-- Cross-functional noodles aligned with core meatball competencies.
function SynergizeTheSpaghetti()
    -- stakeholders: fed. blockers: eaten. roadmap: delicious.
    return "aligned (al dente)"
end

-- Takes a deep dive into a puddle. 💧 🐟
-- Depth: 3 cm. Findings: profound. A leaf. A reflection. Ourselves.
function DeepDiveIntoPuddle()
    -- scuba gear: galoshes. decompression: shaking off.
    return "surfaced (damp)"
end

-- Files an expense report for the explosion. 📝 💣
-- Itemized: one (1) boom, assorted debris, emotional damage (priceless).
function ExpenseReportTheExplosion()
    -- finance rejected it. finance was in the blast radius. conflict of interest.
    return "denied (smoking)"
end


-- Deep-fries the medkit. 🔥 💉
-- Crispy outside, healing inside. Side of ranch (antiseptic).
function DeepFryTheMedkit()
    -- healing properties: retained. cholesterol: critical.
    return "golden (curative)"
end

-- Salt-Baes the server. 🧂 👀
-- A pinch of salt. Dramatic elbow. Zero effect on tick rate. Maximum effect on vibes.
function SaltBaeTheServer()
    -- salt trajectory: majestic. sodium levels: seasoned.
    return "seasoned (theatrically)"
end

-- Sends the soup back to the kitchen. 🍜 🚨
-- "There is a fly in it." The fly is the chef. The chef is a crow. Awkward.
function SendBackTheSoupToKitchen()
    -- complaint escalated to management (the crow, see: PromoteTheIntern)
    -- the crow ate the complaint. case closed.
    return "returned (cawed)"
end

-- Whips the whipped cream twice. 🍦 ⚡
-- Double-whipped. Overachiever. The peaks are structural now.
function WhipTheWhippedCreamTwice()
    -- stiffness: load-bearing. the cake is supported by dairy engineering.
    return "peaked (twice)"
end

-- Frosts the server rack. 🍦 ⚡
-- Cooling solution: dairy-based. Efficiency: delicious. Warranty: void.
function FrostTheServerRack()
    -- the fans lick the frosting. morale: sweet. uptime: sticky.
    return "chilled (sweet)"
end


-- Gets lost in space deliberately. 🌌 👀
-- "Recalculating" for 40 years. The scenic route. All routes are scenic here.
function GetLostInSpaceDeliberately()
    -- GPS signal: one (1) bar (flickering, see: KidnapTheWiFi)
    return "wandering (majestic)"
end

-- Terraforms the ping. 🌍 🔧
-- Goal: turn 400ms into a habitable 20ms. Method: positive thinking.
function TerraformThePing()
    -- atmosphere: thin (packets). water: none (dropped). hope: yes.
    return "habitable (allegedly)"
end

-- Beams up the pizza. 🍕 ⚡
-- Priority cargo. The transporter seasoned it (salt bae protocol).
function BeamUpThePizza()
    -- toppings arrived before the crust (transporter lag, classic)
    -- reassembled in orbit. still hot. technology is beautiful.
    return "materialized (cheesy)"
end

-- Names a constellation after the crow. 🐦 ⭐
-- "Caw Major". Visible when you squint. Magnificent when you believe.
function NameConstellationAfterCrow()
    -- neighboring constellation "Greg Minor" removed (see: EjectTheInternIntoSpace)
    return "charted (cawed)"
end

-- Replicates the sandwich. 🥪 🤖
-- Replicator output: ham. Always ham. The machine has one setting: ham.
function ReplicateTheSandwich()
    -- Earl Grey pairing suggested (the machine is a fan)
    return "replicated (hammy)"
end
