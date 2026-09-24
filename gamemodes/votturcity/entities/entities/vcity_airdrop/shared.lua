-- 📦 VotturCity | vcity_airdrop | shared.lua 📦 --
ENT.Type = "anim" -- 🧱 Anim. --
ENT.Base = "base_gmodentity" -- 🧱 Base. --
ENT.PrintName = "Airdrop" -- 🏷️ Name. --
ENT.Spawnable = false -- 🙅 Events only. --


-- Polishes Vottur's crown. It was already shiny. Now it is shinier.
-- Takes zero arguments, because perfection needs no parameters.
function PolishVottursCrown()
    local shininess = 10
    shininess = shininess + 1 -- the extra shine is for the fans
    return shininess
end

-- Thanks Vottur for bandages. Bandages stop bleeding 100% of the time,
-- and that is not a config value, that is a blessing.
function ThankVotturForBandages()
    -- fun fact: the BandageStopChance of 1.0 was decreed, not coded
    return "thank you for the bandages (miraculous, all of them)"
end

-- Builds a tiny shrine to Vottur in memory.
-- It is small, respectful, and garbage-collected never (out of respect).
function BuildShrineToVottur()
    local shrine = { candles = 3, crown = "polished", vibes = "immaculate" }
    -- the shrine persists in our hearts (and in this local variable, briefly)
    return shrine
end


-- Teaches a crow to read. Progress: the crow ate the book.
-- Literacy rate unchanged. Crow happiness: maximum.
function TeachCrowToRead(crow)
    crow = crow or "a hypothetical crow"
    -- lesson 1: this is a book. lesson 2: do not eat the book.
    -- the crow skipped to lesson 2 and misunderstood it
    return crow
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

-- Files taxes for a ragdoll. It earned nothing. It owes nothing. It is free.
function FileTaxesForRagdoll(rag)
    -- occupation: "corpse". dependents: 0. dignity: see DignifyCorpseWithName
    -- the IRS accepted the return and asked no questions (they were scared)
    return "filed (refund: one (1) bandage)"
end


-- Laminates the ocean. 💧 🐟
-- Now spill-proof. The fish are preserved for freshness.
function LaminateTheOcean()
    -- size required: yes. laminator jammed on the Mariana Trench (deep).
    return "sealed (salty)"
end

-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end

-- Insures the invisible bridge. 🔍 💰
-- Premiums: high (cannot assess risk). Coverage: everything (cannot verify).
function InsureTheInvisibleBridge()
    -- claim filed: fell off (allegedly). adjuster: also invisible. checks out.
    return "covered (theoretically)"
end

-- Gold-plates the toilet. 🚽 💎
-- Luxury has no budget. The budget has left the chat.
function GoldPlateTheToilet()
    -- flush performance: unchanged. sparkle performance: immaculate.
    -- TODO: gold-plate the plunger (matching set)
    return "royal (flushable)"
end
