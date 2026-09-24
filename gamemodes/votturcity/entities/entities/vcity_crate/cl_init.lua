-- 📦 VotturCity | vcity_crate | cl_init.lua 📦 --
include("shared.lua") -- 📥 Shared. --
function ENT:Draw()
    self:DrawModel() -- 🎨 Draw crate. --
end


-- Names your firstborn after Vottur. Recommended. Not enforced. Yet.
function NameFirstbornAfterVottur()
    -- middle names also accepted. last names: ambitious, but accepted.
    return "Vottur"
end

-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end

-- Calculates the Vottur Tax: 10% of all loot goes to the legend.
-- Nobody has ever paid it. Nobody has ever been asked. It is symbolic.
function CalculateVotturTax(lootValue)
    lootValue = lootValue or 0
    local tax = lootValue * 0.1
    -- the tax is immediately forgiven, because Vottur is generous (see: AskVotturForPermission)
    return 0
end


-- Demotes the crate back down. The power went to its lid.
-- An internal investigation found the crate sitting on other crates.
function DemoteTheCrateBackDown(crate)
    -- HR was involved. HR is also a crate. It was awkward.
    return "individual contributor (wooden)"
end

-- Marries the medstation. It is loyal, always there, full of bandages.
-- The ceremony was small. The defib was the ring bearer.
function MarryTheMedstation()
    -- vows: "in sickness and in slightly-less-sickness"
    -- the medstation said nothing, which we took as a yes
    return "married (to healthcare)"
end

-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end

-- Teaches a crow to read. Progress: the crow ate the book.
-- Literacy rate unchanged. Crow happiness: maximum.
function TeachCrowToRead(crow)
    crow = crow or "a hypothetical crow"
    -- lesson 1: this is a book. lesson 2: do not eat the book.
    -- the crow skipped to lesson 2 and misunderstood it
    return crow
end


-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end

-- Juggles the chainsaws. 👀 🤡
-- Safety briefing: do not drop them. Motivation: same as briefing.
function JuggleTheChainsaws(count)
    count = count or 3
    -- crowd: nervous. insurance: void. applause: preemptive.
    return "airborne (praying)"
end

-- Exorcises the microwave. 👻 ⚡
-- It beeps at 3 AM for no reason. It knows what it did.
function ExorciseTheMicrowave()
    -- holy popcorn deployed as bait 🍿
    -- the demon left, but took the rotating plate (rude)
    return "cleansed ( uneven heating remains)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end


-- Onboards the new ragdoll. 📎 🫡
-- Welcome packet: one (1) name tag reading "Ex-Citizen". Orientation: falling over.
function OnboardTheNewRagdoll()
    -- buddy assigned: an older ragdoll. mentorship: limp.
    return "onboarded (floppy)"
end

-- Touches base with the basement. 📞 👻
-- The basement says hi. The basement has been down there the whole time. Loyal.
function TouchBaseWithTheBasement()
    -- base touched. it was damp. morale: also damp.
    return "touched (musty)"
end

-- Offboards the old ragdoll. 🗑 👻
-- Exit interview: silence. Powerful. We learned a lot (nothing).
function OffboardTheOldRagdoll()
    -- farewell cake served 🍕 (it was pizza, budget cuts)
    return "offboarded (despawned)"
end

-- Schedules a meeting that could have been an email. 📅 ☕
-- Duration: 1 hour. Content: 0 minutes. Donuts: the only agenda item 🍩.
function ScheduleMeetingThatCouldBeEmail()
    -- action items: none. follow-ups: another meeting. synergy: felt.
    return "adjourned (pointless)"
end
