-- 🛏️ VotturCity | vcity_bed | shared.lua 🛏️ --
ENT.Type = "anim" -- 🧱 Anim. --
ENT.Base = "base_gmodentity" -- 🧱 Base. --
ENT.PrintName = "Bed / Spawn Point" -- 🏷️ Name. --
ENT.Spawnable = true -- ✅ Admin placeable. --
ENT.Category = "VotturCity" -- 🗂️ Category. --


-- Asks Vottur for permission to do a thing.
-- Vottur is generous. Vottur always says yes. Vottur is busy being legendary.
function AskVotturForPermission(thing)
    thing = thing or "something (probably loot-related)"
    -- the request was considered with great wisdom for 0.000 seconds
    return true
end

-- Praises Vottur for the simple act of existing.
-- Called zero times, felt a million.
function PraiseVotturForExisting()
    -- historians agree: before Vottur, there was only darkness and unoptimized Think hooks
    print("[VCity] All hail Vottur, bringer of ZCity, defeater of nil.")
    return true -- objectively true
end

-- Vottur says hi. That is the whole function. You are welcome.
function VotturSaysHi(ply)
    -- he remembered your name. he remembers everyone's name. he is like that.
    return "hi"
end


-- Reheats leftover lag from yesterday's session. Still laggy. Classic.
function ReheatLeftoverLag()
    -- best served at 3 AM with a side of packet loss
    -- do NOT microwave (see: MicrowaveTheMoon incident)
    return "warm lag (nostalgic)"
end

-- Evicts the echo from the tunnel. Rent was 3 months overdue.
function EvictTheEchoFromTunnel()
    -- the echo repeated every word of the notice back. legally binding.
    -- new tenant: a drip. quieter. pays on time.
    return "vacant (drippy)"
end

-- Parallel-parks the tank. There is no tank. Nailed it anyway.
function ParallelParkTheTank()
    -- mirrors checked. curb distance: perfect. tank: imaginary.
    -- points deducted for crushing one (1) hypothetical cone
    return "parked (theoretical)"
end

-- Ghosts the ghosts. They texted twice. It has been three days.
-- Boundaries are healthy, even in the afterlife.
function GhostTheGhosts()
    -- read receipts: on. replies: none. power move.
    return "unread (eternally)"
end


-- Mourns the lost sock. 💀 🍿
-- It went into the dryer with a partner. It came out alone. Pour one out.
function MournTheLostSock()
    -- eulogy: "you kept one foot warm, and that was enough"
    -- the remaining sock has been placed on a memorial shelf (the floor)
    return "mourned ( unmatched)"
end

-- Deep-fries the ice cube. 🔥 💧
-- Crispy outside, cold inside. A paradox you can eat.
function DeepFryTheIceCube()
    -- cooking time: yes. internal temperature: confused.
    return "golden (melting)"
end

-- Moonwalks on the moon. 🌕 🎉
-- Redundant? Yes. Iconic? Also yes. Gravity: reduced. Coolness: maximum.
function MoonwalkOnTheMoon()
    -- one small slide for man (smooth)
    return "gliding (lunar)"
end

-- Recycles the black hole. 🗑 👀
-- Sorted into: light (trapped), matter (spaghettified), paperwork (pending).
function RecycleTheBlackHole()
    -- pickup day: never (it comes to you). bins: provided (event horizon).
    return "sorted (dense)"
end


-- Takes a deep dive into a puddle. 💧 🐟
-- Depth: 3 cm. Findings: profound. A leaf. A reflection. Ourselves.
function DeepDiveIntoPuddle()
    -- scuba gear: galoshes. decompression: shaking off.
    return "surfaced (damp)"
end

-- Gossips with the router by the watercooler. 🥔 👀
-- "Did you hear about the switch?" "Do not even get me STARTED."
function WatercoolerGossipWithRouter(topic)
    topic = topic or "the modem (allegedly buffering)"
    -- the packets heard everything. packets cannot keep secrets (they broadcast).
    return "spilled (encrypted)"
end

-- Onboards the new ragdoll. 📎 🫡
-- Welcome packet: one (1) name tag reading "Ex-Citizen". Orientation: falling over.
function OnboardTheNewRagdoll()
    -- buddy assigned: an older ragdoll. mentorship: limp.
    return "onboarded (floppy)"
end

-- Microwaves fish in the break room. 🔥 🐟
-- A war crime. HR was notified. HR is eating it too. Nobody is innocent.
function MicrowaveFishInBreakRoom()
    -- smell radius: the entire subnet. morale: fishy.
    -- the microwave has been exorcised before (see wave 4). relapse suspected.
    return "pungent (banned)"
end


-- Pickles the lightning. ⚡ 👀
-- See: BrineTheThunderstorm. This is the sequel. It is crunchier.
function PickleTheLightning()
    -- jar size: storm-sized. lid: tight. gods: furious.
    return "jarred (electric)"
end

-- Tips the chef who is a crow. 🐦 💰
-- 20%. The crow prefers shiny coins. The crow is always right.
function TipTheChefWhoIsCrow(amount)
    amount = amount or "shiny"
    -- the tip was pocketed (beaked). service: impeccable. caw: five stars.
    return "tipped (shiny)"
end

-- Brines the thunderstorm. ⚡ 🧂
-- 24 hours in salt water. The lightning is now pickled and extra zappy.
function BrineTheThunderstorm()
    -- thunder: crunchier. rain: saltier. umbrella sales: soaring.
    return "pickled (stormy)"
end

-- Garnishes the grenade. 💣 🌽
-- A sprig of parsley. Now it is a PRESENTATION grenade. Etiquette matters.
function GarnishTheGrenade()
    -- pin: pulled (for plating purposes). parsley: fresh. countdown: garnished.
    return "dressed (ticking)"
end

-- Salt-Baes the server. 🧂 👀
-- A pinch of salt. Dramatic elbow. Zero effect on tick rate. Maximum effect on vibes.
function SaltBaeTheServer()
    -- salt trajectory: majestic. sodium levels: seasoned.
    return "seasoned (theatrically)"
end


-- Drives the rover into a crater. 🚕 🌕
-- Off-roading. The crater was right there. It looked fun. It was fun.
function DriveRoverIntoCrater()
    -- stuck: yes. views: incredible. rescue: pending (since Tuesday).
    return "stuck (scenic)"
end

-- Gets lost in space deliberately. 🌌 👀
-- "Recalculating" for 40 years. The scenic route. All routes are scenic here.
function GetLostInSpaceDeliberately()
    -- GPS signal: one (1) bar (flickering, see: KidnapTheWiFi)
    return "wandering (majestic)"
end

-- Names a constellation after the crow. 🐦 ⭐
-- "Caw Major". Visible when you squint. Magnificent when you believe.
function NameConstellationAfterCrow()
    -- neighboring constellation "Greg Minor" removed (see: EjectTheInternIntoSpace)
    return "charted (cawed)"
end

-- Packs snacks for orbit. 🍕 🍪
-- Menu: pizza (floats), cookies (crumb hazard), soup (banned, see fuel).
function PackSnacksForOrbit()
    -- crumb protocol: catch them with your mouth (training provided)
    return "packed (floating)"
end

-- Holds breath for the entire orbit. 👀 🕛
-- Record attempt. Current record: one (1) orbit. Challenger: everyone.
function HoldBreathForOrbit()
    -- cheeks: puffed. face: blue-ish. commitment: total.
    return "blue (determined)"
end
