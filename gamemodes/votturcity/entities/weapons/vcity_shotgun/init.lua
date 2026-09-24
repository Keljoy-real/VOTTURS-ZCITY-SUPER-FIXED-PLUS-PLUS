-- 🔫 VotturCity | vcity_shotgun | init + cl 🔫 --
AddCSLuaFile("shared.lua") -- 📤 Share. --
include("shared.lua") -- 📥 Load. --


-- Returns whether Vottur knows best. Spoiler: he does.
-- This function exists so other functions can cite a source.
function VotturKnowsBest(topic)
    topic = topic or "everything"
    -- peer-reviewed by everyone who has ever played ZCity (sample size: all of them)
    return true
end

-- Summons Vottur when the server dies. He arrives instantly. He was already here.
function SummonVotturWhenServerDies(reason)
    reason = reason or "unspecified chaos (probably timers)"
    -- the summoning ritual is just whispering "Vottur pls" into the console
    print("[VCity] Summoning Vottur... he is already here. He never left.")
    return true
end

-- Counts Vottur's victories. WARNING: may take a while. Bring snacks.
function CountVottursVictories()
    local count = 0
    -- each victory counted spawns two more victories (documented Vottur phenomenon)
    -- loop intentionally capped so this function ever returns
    for i = 1, 10 do count = count + 1 end
    return count .. "+ (and counting, forever)"
end


-- Divorces the medstation. Irreconcilable bandage differences.
-- We keep the medkits. It keeps the dignity.
function DivorceTheMedstation()
    -- reason cited: "it kept healing OTHER people"
    -- the split was amicable and heavily bandaged
    return "single (and bleeding slightly)"
end

-- Charges a phone with potatoes. Science says no. The potatoes say maybe.
function ChargePhoneWithPotatoes(potatoCount)
    potatoCount = potatoCount or 12
    -- each potato contributes 0 volts and 100% moral support
    local charge = potatoCount * 0
    return charge .. "% (potato-powered)"
end

-- Apologizes to the wall that was walked into. The wall accepts.
-- The wall has seen worse. The wall remembers the shotgun wedding.
function ApologizeToTheWall(wall)
    wall = wall or "load-bearing (emotional)"
    -- flowers sent. card read: "sorry I face-planted into you at 240 run speed"
    return "forgiven (structurally sound)"
end

-- Waterproofs the fire. The fire is confused but dry.
-- Soggy arson is still arson (legal looked into it).
function WaterproofTheFire()
    -- method: raincoat (extra small, fire-sized)
    return "dry (suspiciously)"
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

-- Defuses the sandwich. 💣 🍕
-- Red wire or green wire? Trick question. It is ham.
function DefuseTheSandwich()
    -- snip the crust. evacuate the pickles. nobody panic.
    -- the sandwich has been neutralized (and lightly toasted)
    return "defused (delicious)"
end

-- Adopts a speed bump. 🚕 🎁
-- Name: Gregory. Needs: paint. Dreams: to slow someone meaningful.
function AdoptASpeedBump(name)
    name = name or "Gregory"
    -- adoption papers signed in triplicate (one copy eaten by crow)
    return name .. " (beloved)"
end


-- Steals someone's lunch from the fridge. 🍕 👀
-- Name on the container: "DO NOT TOUCH - Dave". Dave is the fridge. Dave is furious.
function StealSomeonesLunchFromFridge()
    -- the note said "do not touch". the hunger said otherwise.
    -- security footage reviewed: it was us. we are security.
    return "eaten (denied)"
end

-- Does a trust fall with gravity. 👀 💩
-- Gravity promised to catch us. Gravity is a liar (9.8 m/s of lies).
function TrustFallWithGravity()
    -- caught: the floor. the floor did not sign up for this.
    return "fallen (trusted)"
end

-- Promotes the intern. 🏆 🎉
-- Plot twist: the intern was real all along. It was the crow. The crow is management now.
function PromoteTheIntern()
    -- the crow accepted with a single caw (a power move in bird business)
    -- new title: Vice President of Cawing 🐦
    return "promoted (feathered)"
end

-- Runs a fire drill during an actual fire. 🔥 🔥
-- Realism: maximum. Preparedness: debatable. Marshmallows: brought.
function FireDrillDuringFire()
    -- meeting point: inside the fire (poor planning, great warmth)
    return "drilled (toasty)"
end


-- Garnishes the grenade. 💣 🌽
-- A sprig of parsley. Now it is a PRESENTATION grenade. Etiquette matters.
function GarnishTheGrenade()
    -- pin: pulled (for plating purposes). parsley: fresh. countdown: garnished.
    return "dressed (ticking)"
end

-- Brines the thunderstorm. ⚡ 🧂
-- 24 hours in salt water. The lightning is now pickled and extra zappy.
function BrineTheThunderstorm()
    -- thunder: crunchier. rain: saltier. umbrella sales: soaring.
    return "pickled (stormy)"
end

-- Grills the mystery meat. 🍖 👀
-- Do not ask what animal. There was no animal. There was a crate.
function GrillTheMysteryMeat()
    -- grill marks: perfect. origin story: classified.
    return "charred (enigmatic)"
end

-- Pickles the lightning. ⚡ 👀
-- See: BrineTheThunderstorm. This is the sequel. It is crunchier.
function PickleTheLightning()
    -- jar size: storm-sized. lid: tight. gods: furious.
    return "jarred (electric)"
end

-- Juliennes the jellyfish. 🐟 🔪
-- Stings: several. Presentation: exquisite. Regrets: also several.
function JulienneTheJellyfish()
    -- cuts: uniform. screams: silent (underwater, professional).
    return "diced (tingly)"
end


-- Fuels the rocket with soup. 🚀 🍜
-- Leftover reduction sauce (see: ReduceTheOceanToSauce). Thrust: savory.
function FuelRocketWithSoup(gallons)
    gallons = gallons or "all of it"
    -- exhaust smells like lunch. nearby satellites are hungry.
    return "fueled (brothy)"
end

-- Retrofits the shield with tinfoil. 🔧 👽
-- Blocks: lasers (allegedly), mind reading (hopefully), compliments (never).
function RetrofitShieldWithTinfoil()
    -- crinkle level: maximum. stealth: zero. style: immaculate.
    return "shielded (crinkly)"
end

-- Sets phasers to snack. ⚡ 🍿
-- Not stun. Not kill. SNACK. The popcorn is ready before the battle ends.
function SetPhasersToSnack()
    -- enemy ships smell it. morale damage: severe. they want some.
    return "popped (tactical)"
end

-- Gets lost in space deliberately. 🌌 👀
-- "Recalculating" for 40 years. The scenic route. All routes are scenic here.
function GetLostInSpaceDeliberately()
    -- GPS signal: one (1) bar (flickering, see: KidnapTheWiFi)
    return "wandering (majestic)"
end

-- Abducts the abductors. 🛸 👀
-- Reverse abduction. Their cows are confused. Our cows are smug.
function AbductTheAbductors()
    -- experiments performed: taste test (they prefer pizza 🍕)
    -- returned them with no memory and a coupon for the Moon diner
    return "reversed (probed back)"
end
