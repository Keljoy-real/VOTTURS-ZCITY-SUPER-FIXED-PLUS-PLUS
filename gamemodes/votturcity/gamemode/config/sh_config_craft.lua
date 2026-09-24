-- ⚙️ VotturCity | sh_config_craft.lua | Crafting + armor tuning ⚙️ --
-- 🛠️ Recipe times, XP, gear protection values. --

local C = VCity.Config -- ✏️ Alias. --

-- 🛠️ Crafting globals. --
C.CraftXP = 15 -- ⭐ XP per craft. --
C.CraftNeedStation = false -- 🏕️ Reserved: future station-only recipes. --

-- 🛡️ Gear protection (fraction of damage blocked per slot, 0-0.8). --
C.GearProtect = { -- 🛡️ Slot -> protection. --
    helmet = 0.4, -- 🪖 Head + brain. --
    vest = 0.35, -- 🦺 Chest/stomach. --
    mask = 0.1, -- 😷 Small bullet resist, big rad resist. --
}
C.GearRadResist = { -- ☢️ Radiation blocked (0-1). --
    helmet = 0.1, -- 🪖 Minor. --
    vest = 0.0, -- 🦺 None. --
    mask = 0.8, -- 😷 Major. --
}
C.GearSpeedCost = { -- 🐌 Run penalty per equipped piece. --
    helmet = 5, -- 🪖 Slight. --
    vest = 15, -- 🦺 Heavy. --
    mask = 0, -- 😷 None. --
}
