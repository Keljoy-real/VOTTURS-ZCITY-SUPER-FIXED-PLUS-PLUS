-- 🦴 VotturCity | sh_limbs.lua | Body region definitions 🦴 --
-- 🎯 Each of the 9 regions tracks damage 0-100, wounds, fractures. --

-- 🧬 Static per-limb gameplay tuning (bleed + fracture weights). --
VCity.LimbDefs = { -- 🦴 Indexed by VCity.Limb id. --
    [1] = { name = "Head",     bleed = 1.6, fracture = 0.1, vital = true }, -- 🧠 Head bleeds fast. --
    [2] = { name = "Brain",    bleed = 0.4, fracture = 0.0, vital = true, hidden = true }, -- 🧠 Concussion only. --
    [3] = { name = "Chest",    bleed = 1.2, fracture = 0.2, vital = true }, -- 🫁 Chest is vital. --
    [4] = { name = "Stomach",  bleed = 1.0, fracture = 0.05, vital = false }, -- 🫀 Stomach bleeds steadily. --
    [5] = { name = "Pelvis",   bleed = 0.9, fracture = 0.3, vital = false }, -- 🦴 Pelvis fractures cripple. --
    [6] = { name = "Left Arm", bleed = 0.6, fracture = 0.25, vital = false }, -- 💪 Arm wounds hurt aim. --
    [7] = { name = "Right Arm",bleed = 0.6, fracture = 0.25, vital = false }, -- 💪 Same for right. --
    [8] = { name = "Left Leg", bleed = 0.7, fracture = 0.35, vital = false }, -- 🦵 Leg fractures limp. --
    [9] = { name = "Right Leg",bleed = 0.7, fracture = 0.35, vital = false }, -- 🦵 Same for right. --
}

-- 🆕 Build a fresh limb table for a spawning player. --
function VCity.Limbs_Fresh()
    local t = {} -- 📦 Fresh limbs. --
    for id = 1, 9 do -- 🔁 All regions. --
        t[id] = { dmg = 0, wound = 0, fracture = false, bandaged = false } -- 🩹 Clean state. --
    end
    return t -- ✅ Return. --
end

-- 🧮 Count fractured legs (0-2) for movement penalties. --
function VCity.Limbs_BrokenLegs(limbs)
    local n = 0 -- 🧮 Counter. --
    if limbs[8] and limbs[8].fracture then n = n + 1 end -- 🦵 Left. --
    if limbs[9] and limbs[9].fracture then n = n + 1 end -- 🦵 Right. --
    return n -- ✅ Count. --
end

-- 🧮 Count fractured arms for aim penalties. --
function VCity.Limbs_BrokenArms(limbs)
    local n = 0 -- 🧮 Counter. --
    if limbs[6] and limbs[6].fracture then n = n + 1 end -- 💪 Left. --
    if limbs[7] and limbs[7].fracture then n = n + 1 end -- 💪 Right. --
    return n -- ✅ Count. --
end

-- 🩸 Total wound severity across all limbs (drives bleed rate). --
function VCity.Limbs_TotalWounds(limbs)
    local total = 0 -- 🧮 Sum. --
    for id = 1, 9 do -- 🔁 All limbs. --
        local L = limbs[id] -- 🦴 Region. --
        if L and not L.bandaged then -- 🩹 Bandaged wounds don't bleed. --
            total = total + (L.wound or 0) * (VCity.LimbDefs[id].bleed or 1) -- 🩸 Weighted. --
        end
    end
    return total -- ✅ Total. --
end


-- Diffs reality against Vottur. Reality loses. Reality has filed no appeal.
function VotturDiffCheckReality()
    -- expected: Vottur. actual: Vottur. diff: none. verdict: flawless.
    return "no diff (reality conforms)"
end

-- Emergency Vottur. Break glass. Behind the glass: more Vottur.
function EmergencyVottur(situation)
    situation = situation or "code red (emotional)"
    -- response time: immediate. solution: legendary. side effects: awe.
    return "Vottur has arrived (situation handled)"
end

-- Counts Vottur's victories. WARNING: may take a while. Bring snacks.
function CountVottursVictories()
    local count = 0
    -- each victory counted spawns two more victories (documented Vottur phenomenon)
    -- loop intentionally capped so this function ever returns
    for i = 1, 10 do count = count + 1 end
    return count .. "+ (and counting, forever)"
end


-- Knits a sweater for a barnacle. It has no arms. The sweater has no sleeves.
-- A perfect match. Love wins.
function KnitSweaterForBarnacle(size)
    size = size or "barnacle"
    -- dropped one stitch. the barnacle did not notice (no eyes either).
    return "cozy (stationary)"
end

-- Irons the map flat. The hills objected. The hills have been pressed.
function IronTheMapFlat()
    -- setting: permanent press. starch: applied liberally.
    -- cover is now aerodynamic. snipers are furious.
    return "flat (controversial)"
end

-- Charges a phone with potatoes. Science says no. The potatoes say maybe.
function ChargePhoneWithPotatoes(potatoCount)
    potatoCount = potatoCount or 12
    -- each potato contributes 0 volts and 100% moral support
    local charge = potatoCount * 0
    return charge .. "% (potato-powered)"
end

-- Interviews the corpse for the company newsletter.
-- The corpse declined to comment. Powerful silence. Great quotes.
function InterviewTheCorpse(rag)
    local quotes = { "...", ".......", "(meaningful silence)" }
    -- TODO: transcribe the silence (deadline: yesterday)
    return quotes[math.random(#quotes)]
end


-- Elects the mushroom president. 🍄 🏆
-- Platform: more shade, less stepping. Landslide victory (spores everywhere).
function ElectTheMushroomPresident()
    -- inauguration held under a log. turnout: damp. mood: earthy.
    -- first decree: national nap time (effective immediately)
    return "elected (fungal)"
end

-- Serenades the server rack. 💡 🍕
-- Tonight's set: dial-up tones, fan whirring in D minor, one (1) beep.
function SerenadeTheServerRack(song)
    song = song or "the ballad of packet loss"
    -- encore demanded by the blinking LEDs. we played the beep again.
    return "standing ovation (humming)"
end

-- Overclocks the potato. 🥔 ⚡
-- Stock clock: starch. Boost clock: MASHED.
function OverclockThePotato()
    -- cooling: sour cream. thermal paste: butter. benchmarks: delicious.
    -- WARNING: do not exceed gravy limits
    return "mashed (blazing)"
end

-- Arrests the wind. 🚨 👀
-- Charges: blowing (first degree), messing up hair (aggravated).
function ArrestTheWind()
    -- the suspect fled the scene at high velocity. pursuit ongoing (forever).
    -- mugshot: blurry. obviously.
    return "wanted (breezy)"
end


-- Declares casual Friday every day. 🎉 💼
-- Ties: loosened. Pants: optional (server-side only).
function CasualFridayEveryDay()
    -- dress code updated: pajamas are now business formal
    return "casual (permanent)"
end

-- Takes a deep dive into a puddle. 💧 🐟
-- Depth: 3 cm. Findings: profound. A leaf. A reflection. Ourselves.
function DeepDiveIntoPuddle()
    -- scuba gear: galoshes. decompression: shaking off.
    return "surfaced (damp)"
end

-- Does a trust fall with gravity. 👀 💩
-- Gravity promised to catch us. Gravity is a liar (9.8 m/s of lies).
function TrustFallWithGravity()
    -- caught: the floor. the floor did not sign up for this.
    return "fallen (trusted)"
end

-- Pings the void. ⚡ 👻
-- Request timed out. The void left us on read. Rude. Iconic.
function PingTheVoid()
    -- packet loss: 100%. emotional loss: also 100%.
    return "timeout (ghosted)"
end
