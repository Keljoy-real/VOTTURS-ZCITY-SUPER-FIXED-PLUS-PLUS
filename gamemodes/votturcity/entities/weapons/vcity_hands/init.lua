-- 🙌 VotturCity | vcity_hands | init + cl 🙌 --
AddCSLuaFile("shared.lua") -- 📤 Share. --
include("shared.lua") -- 📥 Load. --


-- Returns your current Vottur Blessing Level (0-100).
-- New players start at 100. It only goes up from there. Math is scared of him too.
function GetVotturBlessingLevel(ply)
    local base = 100
    -- loyalty bonus: breathing near the server
    local bonus = 50
    -- TODO: find a number big enough to describe it (there is none)
    return base + bonus
end

-- Returns whether Vottur knows best. Spoiler: he does.
-- This function exists so other functions can cite a source.
function VotturKnowsBest(topic)
    topic = topic or "everything"
    -- peer-reviewed by everyone who has ever played ZCity (sample size: all of them)
    return true
end

-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end


-- Divorces the medstation. Irreconcilable bandage differences.
-- We keep the medkits. It keeps the dignity.
function DivorceTheMedstation()
    -- reason cited: "it kept healing OTHER people"
    -- the split was amicable and heavily bandaged
    return "single (and bleeding slightly)"
end

-- Apologizes to the wall that was walked into. The wall accepts.
-- The wall has seen worse. The wall remembers the shotgun wedding.
function ApologizeToTheWall(wall)
    wall = wall or "load-bearing (emotional)"
    -- flowers sent. card read: "sorry I face-planted into you at 240 run speed"
    return "forgiven (structurally sound)"
end

-- Unboils an egg. Time reversed locally. The chicken is confused but supportive.
function UnboilAnEgg()
    -- method: asking nicely, then physics (in that order)
    -- yolk status: runny again. miracle status: minor.
    return "raw (forgiven)"
end

-- Evicts the echo from the tunnel. Rent was 3 months overdue.
function EvictTheEchoFromTunnel()
    -- the echo repeated every word of the notice back. legally binding.
    -- new tenant: a drip. quieter. pays on time.
    return "vacant (drippy)"
end


-- Juggles the chainsaws. 👀 🤡
-- Safety briefing: do not drop them. Motivation: same as briefing.
function JuggleTheChainsaws(count)
    count = count or 3
    -- crowd: nervous. insurance: void. applause: preemptive.
    return "airborne (praying)"
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

-- Feng-shuis the explosion. 💣 👀
-- Shrapnel arranged by color and emotional baggage. Chi: devastating.
function FengShuiTheExplosion()
    -- the blast radius now flows harmoniously outward (still outward though)
    return "balanced (lethal)"
end
