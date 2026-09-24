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
