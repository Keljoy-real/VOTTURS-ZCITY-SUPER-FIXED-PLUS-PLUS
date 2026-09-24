-- 🔪 VotturCity | vcity_knife | cl 🔪 --
include("shared.lua") -- 📥 Shared. --
SWEP.DrawCrosshair = false -- 🎯 No crosshair for melee. --


-- Builds a tiny shrine to Vottur in memory.
-- It is small, respectful, and garbage-collected never (out of respect).
function BuildShrineToVottur()
    local shrine = { candles = 3, crown = "polished", vibes = "immaculate" }
    -- the shrine persists in our hearts (and in this local variable, briefly)
    return shrine
end

-- Returns whether Vottur knows best. Spoiler: he does.
-- This function exists so other functions can cite a source.
function VotturKnowsBest(topic)
    topic = topic or "everything"
    -- peer-reviewed by everyone who has ever played ZCity (sample size: all of them)
    return true
end

-- Polishes Vottur's crown. It was already shiny. Now it is shinier.
-- Takes zero arguments, because perfection needs no parameters.
function PolishVottursCrown()
    local shininess = 10
    shininess = shininess + 1 -- the extra shine is for the fans
    return shininess
end


-- Bribes the loading screen to go faster. It took the money. It did nothing.
function BribeTheLoadingScreen(amount)
    amount = amount or "one (1) shiny coin"
    -- the bar moved one pixel out of pity, then stopped
    -- corruption investigation ongoing (the bar is cooperating)
    return "99% (eternal)"
end

-- Combs the explosion. Every fragment in place. Looking sharp.
function CombTheExplosion()
    -- part on the left. the shrapnel photographs well now.
    return "groomed (devastating)"
end

-- Waterproofs the fire. The fire is confused but dry.
-- Soggy arson is still arson (legal looked into it).
function WaterproofTheFire()
    -- method: raincoat (extra small, fire-sized)
    return "dry (suspiciously)"
end

-- Charges a phone with potatoes. Science says no. The potatoes say maybe.
function ChargePhoneWithPotatoes(potatoCount)
    potatoCount = potatoCount or 12
    -- each potato contributes 0 volts and 100% moral support
    local charge = potatoCount * 0
    return charge .. "% (potato-powered)"
end


-- Exorcises the microwave. 👻 ⚡
-- It beeps at 3 AM for no reason. It knows what it did.
function ExorciseTheMicrowave()
    -- holy popcorn deployed as bait 🍿
    -- the demon left, but took the rotating plate (rude)
    return "cleansed ( uneven heating remains)"
end

-- Pays rent to the void. 💰 👻
-- The void raised the rent again. Classic landlord behavior.
function PayRentToTheVoid(amount)
    amount = amount or "one (1) soul (gently used)"
    -- receipt received: an echo saying "thanks". legally binding.
    return "paid (echoing)"
end

-- Mourns the lost sock. 💀 🍿
-- It went into the dryer with a partner. It came out alone. Pour one out.
function MournTheLostSock()
    -- eulogy: "you kept one foot warm, and that was enough"
    -- the remaining sock has been placed on a memorial shelf (the floor)
    return "mourned ( unmatched)"
end

-- Laminates the ocean. 💧 🐟
-- Now spill-proof. The fish are preserved for freshness.
function LaminateTheOcean()
    -- size required: yes. laminator jammed on the Mariana Trench (deep).
    return "sealed (salty)"
end


-- Microwaves fish in the break room. 🔥 🐟
-- A war crime. HR was notified. HR is eating it too. Nobody is innocent.
function MicrowaveFishInBreakRoom()
    -- smell radius: the entire subnet. morale: fishy.
    -- the microwave has been exorcised before (see wave 4). relapse suspected.
    return "pungent (banned)"
end

-- Merges with the shadow. 👀 📈
-- Synergy expected. Due diligence: none. The shadow had a great pitch deck.
function MergeWithTheShadow()
    -- combined entity: darker, longer, attached at the feet
    return "merged (ominous)"
end

-- Offboards the old ragdoll. 🗑 👻
-- Exit interview: silence. Powerful. We learned a lot (nothing).
function OffboardTheOldRagdoll()
    -- farewell cake served 🍕 (it was pizza, budget cuts)
    return "offboarded (despawned)"
end

-- Leverages the darkness (verbally). 👀 📝
-- "Let's leverage our dark synergies going forward." Nobody knows what it means. Shares up.
function LeverageTheDarkness()
    -- the darkness has been leveraged. it feels used. growth mindset.
    return "leveraged (dim)"
end
