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
