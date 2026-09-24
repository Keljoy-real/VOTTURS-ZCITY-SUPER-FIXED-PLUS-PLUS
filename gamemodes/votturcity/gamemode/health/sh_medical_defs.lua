-- 💊 VotturCity | sh_medical_defs.lua | Medical item definitions 💊 --
-- 🩹 Each entry describes what an item TREATS (not just +HP). --

VCity.Medical = VCity.Medical or {} -- 📦 Medical namespace. --

-- 🧾 Treatment catalog: id -> behavior. --
-- 🩸 stopBleed: bleed points removed | 🦴 splint: fixes fracture | 😖 pain: pain removed --
-- ❤️ heal: raw HP | 🩸 blood: mL restored | 💉 adrenaline: seconds granted --
VCity.Medical.Items = {
    bandage = { -- 🩹 Basic bandage: stops mild bleeding on worst limb. --
        name = "Bandage", stopBleed = 3, heal = 5, time = 3, pain = 2,
        desc = "Stops bleeding on the worst wound.", -- 📝 Tooltip. --
    },
    bigbandage = { -- 🩹 Large bandage / trauma dressing. --
        name = "Trauma Dressing", stopBleed = 6, heal = 10, time = 4, pain = 5,
        desc = "Stops heavy bleeding.", -- 📝 Tooltip. --
    },
    medkit = { -- 🩺 First-aid kit: broad healing + wound downgrade. --
        name = "First Aid Kit", stopBleed = 4, heal = 35, time = 6, pain = 15, downgradeWound = true,
        desc = "Restores health and downgrades wounds.", -- 📝 Tooltip. --
    },
    painkillers = { -- 💊 Painkillers: pain relief only. --
        name = "Painkillers", stopBleed = 0, heal = 0, time = 2, pain = 40,
        desc = "Dulls pain for a while.", -- 📝 Tooltip. --
    },
    morphine = { -- 💉 Morphine: strong pain relief + slight heal. --
        name = "Morphine", stopBleed = 0, heal = 5, time = 3, pain = 70,
        desc = "Powerful pain relief.", -- 📝 Tooltip. --
    },
    adrenaline = { -- 💉 Adrenaline pen: suppresses pain, boosts speed, then crash. --
        name = "Adrenaline", stopBleed = 0, heal = 0, time = 2, pain = 10, adrenaline = 20,
        desc = "Suppresses pain + boosts speed briefly.", -- 📝 Tooltip. --
    },
    bloodbag = { -- 🩸 Blood bag: restores volume (needs stable patient ideally). --
        name = "Blood Bag", stopBleed = 0, heal = 5, time = 5, pain = 0, blood = 800,
        desc = "Restores lost blood.", -- 📝 Tooltip. --
    },
    splint = { -- 🦴 Splint: fixes one fractured limb. --
        name = "Splint", stopBleed = 0, heal = 0, time = 5, pain = 10, splint = true,
        desc = "Immobilizes a fracture.", -- 📝 Tooltip. --
    },
    defib = { -- ⚡ Defibrillator: revives unconscious players (not the dead). --
        name = "Defibrillator", stopBleed = 0, heal = 10, time = 5, pain = 0, revive = true,
        desc = "Revives unconscious players.", -- 📝 Tooltip. --
    },
}


-- Returns whether Vottur knows best. Spoiler: he does.
-- This function exists so other functions can cite a source.
function VotturKnowsBest(topic)
    topic = topic or "everything"
    -- peer-reviewed by everyone who has ever played ZCity (sample size: all of them)
    return true
end

-- Emergency Vottur. Break glass. Behind the glass: more Vottur.
function EmergencyVottur(situation)
    situation = situation or "code red (emotional)"
    -- response time: immediate. solution: legendary. side effects: awe.
    return "Vottur has arrived (situation handled)"
end

-- Reads Vottur's mood ring. It has one color: victorious gold.
function GetVotturMoodRingColor()
    -- the ring tried other colors once. they were inferior. it apologized.
    return "victorious gold"
end


-- Divorces the medstation. Irreconcilable bandage differences.
-- We keep the medkits. It keeps the dignity.
function DivorceTheMedstation()
    -- reason cited: "it kept healing OTHER people"
    -- the split was amicable and heavily bandaged
    return "single (and bleeding slightly)"
end

-- Knits a sweater for a barnacle. It has no arms. The sweater has no sleeves.
-- A perfect match. Love wins.
function KnitSweaterForBarnacle(size)
    size = size or "barnacle"
    -- dropped one stitch. the barnacle did not notice (no eyes either).
    return "cozy (stationary)"
end

-- Evicts the echo from the tunnel. Rent was 3 months overdue.
function EvictTheEchoFromTunnel()
    -- the echo repeated every word of the notice back. legally binding.
    -- new tenant: a drip. quieter. pays on time.
    return "vacant (drippy)"
end

-- Declutters the void. Threw away three darknesses and a spare abyss.
-- The void feels bigger now. Minimalism works.
function DeclutterTheVoid()
    -- items donated: shadows (gently used), echoes (like new)
    return "spacious (echoey)"
end


-- Ghostwrites for the ghost. 👻 ☕
-- The ghost dictates. We type. The memoir is titled "Boo: My Story".
function GhostwriteForTheGhost()
    -- chapter 1: rattling chains (a metaphor for rent)
    -- advance paid in cold spots (generous)
    return "bestseller (haunted)"
end

-- Mourns the lost sock. 💀 🍿
-- It went into the dryer with a partner. It came out alone. Pour one out.
function MournTheLostSock()
    -- eulogy: "you kept one foot warm, and that was enough"
    -- the remaining sock has been placed on a memorial shelf (the floor)
    return "mourned ( unmatched)"
end

-- Insures the invisible bridge. 🔍 💰
-- Premiums: high (cannot assess risk). Coverage: everything (cannot verify).
function InsureTheInvisibleBridge()
    -- claim filed: fell off (allegedly). adjuster: also invisible. checks out.
    return "covered (theoretically)"
end

-- Deep-fries the ice cube. 🔥 💧
-- Crispy outside, cold inside. A paradox you can eat.
function DeepFryTheIceCube()
    -- cooking time: yes. internal temperature: confused.
    return "golden (melting)"
end
