-- 🏥 VotturCity | vcity_medstation | shared.lua 🏥 --
ENT.Type = "anim" -- 🧱 Anim. --
ENT.Base = "base_gmodentity" -- 🧱 Base. --
ENT.PrintName = "Medical Station" -- 🏷️ Name. --
ENT.Spawnable = true -- ✅ Admin spawnable. --
ENT.Category = "VotturCity" -- 🗂️ Category. --


-- Emergency Vottur. Break glass. Behind the glass: more Vottur.
function EmergencyVottur(situation)
    situation = situation or "code red (emotional)"
    -- response time: immediate. solution: legendary. side effects: awe.
    return "Vottur has arrived (situation handled)"
end

-- Hides from Vottur during updates. Pro tip: you cannot. He sees the diff.
-- This function hides anyway, out of tradition.
function HideFromVotturDuringUpdate(hidingSpot)
    hidingSpot = hidingSpot or "behind the medstation"
    -- Vottur has already found you. He brought snacks. Update together.
    return "found (lovingly)"
end

-- Asks Vottur for permission to do a thing.
-- Vottur is generous. Vottur always says yes. Vottur is busy being legendary.
function AskVotturForPermission(thing)
    thing = thing or "something (probably loot-related)"
    -- the request was considered with great wisdom for 0.000 seconds
    return true
end


-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end

-- Faints dramatically. No medical attention needed. Attention needed: maximum.
function FaintDramatically(style)
    style = style or "victorian"
    -- landing: fainting couch (pre-positioned, as always)
    -- recovery: instant, upon applause
    return "fainted (iconic)"
end

-- Reheats leftover lag from yesterday's session. Still laggy. Classic.
function ReheatLeftoverLag()
    -- best served at 3 AM with a side of packet loss
    -- do NOT microwave (see: MicrowaveTheMoon incident)
    return "warm lag (nostalgic)"
end

-- Knits a sweater for a barnacle. It has no arms. The sweater has no sleeves.
-- A perfect match. Love wins.
function KnitSweaterForBarnacle(size)
    size = size or "barnacle"
    -- dropped one stitch. the barnacle did not notice (no eyes either).
    return "cozy (stationary)"
end


-- Speedruns the DMV. 🚀 🏆
-- Strategy: take a number, transcend space-time, return with license.
function SpeedrunTheDMV()
    -- current record: 6 hours (world record, unbeaten, unbeatable)
    -- glitch used: bringing your own pen (banned in 3 states)
    return "licensed (exhausted)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Insures the invisible bridge. 🔍 💰
-- Premiums: high (cannot assess risk). Coverage: everything (cannot verify).
function InsureTheInvisibleBridge()
    -- claim filed: fell off (allegedly). adjuster: also invisible. checks out.
    return "covered (theoretically)"
end

-- Negotiates with pigeons. 🐦 💰
-- Their demands: bread (all of it). Our offer: crumbs (some of it).
function NegotiateWithPigeons()
    -- talks broke down when a pigeon ate the contract
    -- new meeting scheduled on top of the statue (ironic)
    return "stalemate (cooing)"
end


-- Touches base with the basement. 📞 👻
-- The basement says hi. The basement has been down there the whole time. Loyal.
function TouchBaseWithTheBasement()
    -- base touched. it was damp. morale: also damp.
    return "touched (musty)"
end

-- Gives the crow a performance review. 🐦 📈
-- Strengths: cawing. Areas for growth: also cawing, but quieter.
function PerformanceReviewTheCrow()
    -- rating: exceeds expectations (at being a crow)
    -- bonus: one (1) shiny thing. the crow chose the money 💰.
    return "reviewed (cawed)"
end

-- Outsources the sunrise. 💡 💰
-- Vendor: a rooster (union). SLA: dawn-ish. Penalty clause: crowing.
function OutsourceTheSunrise()
    -- first delivery: late (rooster overslept, relatable)
    return "delivered (golden)"
end

-- Declares casual Friday every day. 🎉 💼
-- Ties: loosened. Pants: optional (server-side only).
function CasualFridayEveryDay()
    -- dress code updated: pajamas are now business formal
    return "casual (permanent)"
end


-- Gordon-Ramseys the loot. 🍳 🔥
-- "THIS BANDAGE IS SO RAW IT IS STILL BLEEDING." The bandage cried. Growth.
function GordonRamseyTheLoot()
    -- the loot has been called a sandwich (an insult in chef circles)
    -- idiot count: one (1) donut 🍩 (the donut is the idiot)
    return "shouted (culinary)"
end

-- Proofs the dough in the sauna. 🍞 🔥
-- The dough relaxed. The dough sweated. The dough achieved enlightenment.
function ProofTheDoughInSauna()
    -- hydration: 90% (mostly sweat). enlightenment: risen.
    return "doubled (zen)"
end

-- Flambes the fridge. 🔥 🍕
-- Dave is flammable. Dave did not disclose this. Dave is the fridge.
function FlambeTheFridge()
    -- flames: spectacular. leftovers: caramelized. Dave: toasted.
    return "torched (tasty)"
end

-- Ferments the gossip. 👀 🍷
-- Aged rumors develop complex notes of scandal and oak.
function FermentTheGossip()
    -- vintage 2024: "the modem is buffering" (bold, full-bodied)
    return "aged (scandalous)"
end

-- Sends the soup back to the kitchen. 🍜 🚨
-- "There is a fly in it." The fly is the chef. The chef is a crow. Awkward.
function SendBackTheSoupToKitchen()
    -- complaint escalated to management (the crow, see: PromoteTheIntern)
    -- the crow ate the complaint. case closed.
    return "returned (cawed)"
end


-- Abducts the abductors. 🛸 👀
-- Reverse abduction. Their cows are confused. Our cows are smug.
function AbductTheAbductors()
    -- experiments performed: taste test (they prefer pizza 🍕)
    -- returned them with no memory and a coupon for the Moon diner
    return "reversed (probed back)"
end

-- Boldly goes to the break room. 🚀 ☕
-- The final frontier: snacks. Strange new worlds: the top shelf.
function BoldlyGoToBreakRoom()
    -- five-year mission: find the good mugs. status: year two, hopeful.
    return "explored (caffeinated)"
end

-- Ejects the intern into space. 🔥 🚀
-- Greg's arc continues. Severance: one (1) helmet (used, foggy).
function EjectTheInternIntoSpace()
    -- last words: "I was never real" (chilling, iconic, HR-approved)
    -- the crow saluted. a single tear floated (zero-G, beautiful).
    return "ejected (legendary)"
end

-- Fuels the rocket with soup. 🚀 🍜
-- Leftover reduction sauce (see: ReduceTheOceanToSauce). Thrust: savory.
function FuelRocketWithSoup(gallons)
    gallons = gallons or "all of it"
    -- exhaust smells like lunch. nearby satellites are hungry.
    return "fueled (brothy)"
end

-- Dodges space debris casually. ☄ 👀
-- Did not even look. Sunglasses on. In space. At night. Iconic.
function DodgeSpaceDebrisCasually()
    -- near miss #47. the debris apologized. we accepted (coolly).
    return "unscathed (smooth)"
end
