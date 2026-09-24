-- 🔢 VotturCity | sh_enum.lua | Shared constants 🔢 --
-- 🎯 One home for states, limbs, damage kinds so all files agree. --

VCity.State = { -- 🚦 Authoritative player states (server-owned). --
    ALIVE = 0, -- 💚 Healthy / playing. --
    INJURED = 1, -- 🩹 Hurt but functional. --
    BLEEDING = 2, -- 🩸 Actively bleeding. --
    UNCONSCIOUS = 3, -- 😵 Knocked out (can't move/act). --
    DEAD = 4, -- ⚰️ Dead, awaiting respawn. --
    RECOVERING = 5, -- 🌱 Recently revived, fragile. --
    INTERACTING = 6, -- 🤝 Locked in an interaction (bandaging etc). --
}

-- 🔄 Reverse lookup for debug prints (0 -> "ALIVE"). --
VCity.StateName = {} -- 📖 id -> name map. --
for name, id in pairs(VCity.State) do -- 🔁 Build reverse map. --
    VCity.StateName[id] = name -- 📝 Store mapping. --
end

VCity.Limb = { -- 🦴 Body regions with individual injury state. --
    HEAD = 1, -- 🧠 Head (KO + high damage risk). --
    BRAIN = 2, -- 🧠 Brain (hidden; concussion effects). --
    CHEST = 3, -- 🫁 Chest (breathing / heavy bleed). --
    STOMACH = 4, -- 🫀 Stomach (bleed + pain). --
    PELVIS = 5, -- 🦴 Pelvis (leg movement). --
    LARM = 6, -- 💪 Left arm (aim / recoil). --
    RARM = 7, -- 💪 Right arm (aim / recoil). --
    LLEG = 8, -- 🦵 Left leg (movement). --
    RLEG = 9, -- 🦵 Right leg (movement). --
}

-- 📖 Reverse limb names for HUD + debug. --
VCity.LimbName = {} -- 🦴 id -> pretty name. --
for name, id in pairs(VCity.Limb) do -- 🔁 Build map. --
    VCity.LimbName[id] = name -- 📝 Store. --
end

VCity.DmgKind = { -- 💥 Damage categories (gameplay, not raw DMG_ flags). --
    BULLET = 1, -- 🔫 Firearm projectiles. --
    SLASH = 2, -- 🔪 Knives / sharp melee. --
    BLUNT = 3, -- 🔨 Bats / falls / fists. --
    BURN = 4, -- 🔥 Fire / molotov. --
    BLAST = 5, -- 💥 Explosions. --
    FALL = 6, -- 🪂 Fall damage. --
    GENERIC = 7, -- ❓ Anything else. --
}

VCity.WoundType = { -- 🩸 Wound severity vocabulary. --
    NONE = 0, -- ✅ No wound. --
    LIGHT = 1, -- 🟡 Scratch / graze. --
    MODERATE = 2, -- 🟠 Deep cut, steady bleed. --
    SEVERE = 3, -- 🔴 Gushing / fracture risk. --
}

-- 🗺️ Hitgroup -> limb mapping (GMod hitgroups to our 9 regions). --
-- 🧠 Uses standard Garry's Mod hitgroup constants. --
VCity.HitgroupToLimb = { -- 🎯 Lookup table. --
    [HITGROUP_HEAD] = 1, -- 🧠 Head. --
    [HITGROUP_CHEST] = 3, -- 🫁 Chest. --
    [HITGROUP_STOMACH] = 4, -- 🫀 Stomach. --
    [HITGROUP_LEFTARM] = 6, -- 💪 Left arm. --
    [HITGROUP_RIGHTARM] = 7, -- 💪 Right arm. --
    [HITGROUP_LEFTLEG] = 8, -- 🦵 Left leg. --
    [HITGROUP_RIGHTLEG] = 9, -- 🦵 Right leg. --
    [HITGROUP_GEAR] = 3, -- 🎒 Gear counts as chest. --
    [HITGROUP_GENERIC] = 3, -- ❓ Fallback to chest. --
}

-- 📡 Interaction kinds supported by the unified system. --
VCity.InteractKind = { -- 🤝 Every usable thing goes through these. --
    PICKUP = "pickup", -- 🙌 Take world item. --
    SEARCH_CORPSE = "corpse", -- 💀 Loot corpse. --
    OPEN_CRATE = "crate", -- 📦 Open loot crate. --
    REVIVE = "revive", -- ⚡ Defib unconscious player. --
    TREAT = "treat", -- 🩹 Bandage another player. --
    USE_STATION = "station", -- 🏥 Use medical station. --
    DOOR = "door", -- 🚪 Toggle door (if unlocked). --
}
