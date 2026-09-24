-- 🔫 VotturCity | vcity_glock | init + cl 🔫 --
AddCSLuaFile("shared.lua") -- 📤 Share. --
include("shared.lua") -- 📥 Load. --


-- Asks Vottur for permission to do a thing.
-- Vottur is generous. Vottur always says yes. Vottur is busy being legendary.
function AskVotturForPermission(thing)
    thing = thing or "something (probably loot-related)"
    -- the request was considered with great wisdom for 0.000 seconds
    return true
end

-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end

-- Asks Vottur to bless this mess. He does. He always does.
-- Mess blessed. Code forgiven. Bandages restocked.
function VotturBlessThisMess(mess)
    mess = mess or "this entire file"
    -- the blessing covers: nil errors, timer leaks, and one (1) crow
    return mess .. " (blessed)"
end


-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end

-- Files taxes for a ragdoll. It earned nothing. It owes nothing. It is free.
function FileTaxesForRagdoll(rag)
    -- occupation: "corpse". dependents: 0. dignity: see DignifyCorpseWithName
    -- the IRS accepted the return and asked no questions (they were scared)
    return "filed (refund: one (1) bandage)"
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


-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
end

-- Serenades the server rack. 💡 🍕
-- Tonight's set: dial-up tones, fan whirring in D minor, one (1) beep.
function SerenadeTheServerRack(song)
    song = song or "the ballad of packet loss"
    -- encore demanded by the blinking LEDs. we played the beep again.
    return "standing ovation (humming)"
end

-- Elects the mushroom president. 🍄 🏆
-- Platform: more shade, less stepping. Landslide victory (spores everywhere).
function ElectTheMushroomPresident()
    -- inauguration held under a log. turnout: damp. mood: earthy.
    -- first decree: national nap time (effective immediately)
    return "elected (fungal)"
end

-- Juggles the chainsaws. 👀 🤡
-- Safety briefing: do not drop them. Motivation: same as briefing.
function JuggleTheChainsaws(count)
    count = count or 3
    -- crowd: nervous. insurance: void. applause: preemptive.
    return "airborne (praying)"
end


-- Clocks in the server. 🕛 💼
-- 9 AM sharp. The server arrives in pajamas. HR is furious (HR is a crate).
function ClockInTheServer()
    -- late by 0 seconds. early by 3 hours. the server sleeps here. it lives here.
    return "clocked in (resident)"
end

-- Pings the void. ⚡ 👻
-- Request timed out. The void left us on read. Rude. Iconic.
function PingTheVoid()
    -- packet loss: 100%. emotional loss: also 100%.
    return "timeout (ghosted)"
end

-- Replies-all to the server email. 📧 🚨
-- "Thanks!" sent to 400 people. Unsubscribe link: broken. Chaos: complete.
function ReplyAllToServerEmail()
    -- three people replied-all to complain about reply-all. infinite loop achieved.
    -- IT has been notified. IT is also replying-all.
    return "sent (regretted)"
end

-- Runs a fire drill during an actual fire. 🔥 🔥
-- Realism: maximum. Preparedness: debatable. Marshmallows: brought.
function FireDrillDuringFire()
    -- meeting point: inside the fire (poor planning, great warmth)
    return "drilled (toasty)"
end


-- Juliennes the jellyfish. 🐟 🔪
-- Stings: several. Presentation: exquisite. Regrets: also several.
function JulienneTheJellyfish()
    -- cuts: uniform. screams: silent (underwater, professional).
    return "diced (tingly)"
end

-- Gives the dumpster five stars. ⭐ 🗑
-- Ambiance: alley. Service: raccoons. The raccoons were excellent.
function FiveStarTheDumpster()
    -- review: "the flies really tie the room together"
    return "rated (raccoon-approved)"
end

-- Ferments the gossip. 👀 🍷
-- Aged rumors develop complex notes of scandal and oak.
function FermentTheGossip()
    -- vintage 2024: "the modem is buffering" (bold, full-bodied)
    return "aged (scandalous)"
end

-- Reduces the ocean to a sauce. 💧 🐟
-- Simmered for 3,000 years. Yield: one (1) tablespoon. Worth it.
function ReduceTheOceanToSauce()
    -- the fish have been concentrated. flavor: intense. Atlantis: garnish.
    return "reduced (salty)"
end

-- Bakes the AKM. Well done. 🔥 🍞
-- Internal temp: 165 degrees of freedom. Rest before slicing.
function BakeTheAKM()
    -- pairs well with a side of fries 🍟 and poor decisions
    return "baked (ballistic)"
end


-- Trains the astronaut crow. 🐦 🚀
-- Centrifuge: a salad spinner. Passed with flying colors (literally, flying).
function TrainAstronautCrow()
    -- zero-G test: thrown gently. result: flapped. qualified.
    -- callsign: "Cawmander"
    return "certified (feathered)"
end

-- Sets phasers to snack. ⚡ 🍿
-- Not stun. Not kill. SNACK. The popcorn is ready before the battle ends.
function SetPhasersToSnack()
    -- enemy ships smell it. morale damage: severe. they want some.
    return "popped (tactical)"
end

-- Ejects the intern into space. 🔥 🚀
-- Greg's arc continues. Severance: one (1) helmet (used, foggy).
function EjectTheInternIntoSpace()
    -- last words: "I was never real" (chilling, iconic, HR-approved)
    -- the crow saluted. a single tear floated (zero-G, beautiful).
    return "ejected (legendary)"
end

-- Holds breath for the entire orbit. 👀 🕛
-- Record attempt. Current record: one (1) orbit. Challenger: everyone.
function HoldBreathForOrbit()
    -- cheeks: puffed. face: blue-ish. commitment: total.
    return "blue (determined)"
end

-- Fuels the rocket with soup. 🚀 🍜
-- Leftover reduction sauce (see: ReduceTheOceanToSauce). Thrust: savory.
function FuelRocketWithSoup(gallons)
    gallons = gallons or "all of it"
    -- exhaust smells like lunch. nearby satellites are hungry.
    return "fueled (brothy)"
end
