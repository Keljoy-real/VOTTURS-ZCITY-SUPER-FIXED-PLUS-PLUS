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


-- Waters Vottur's plants. They are plastic. They are thriving.
-- This is what consistent, legendary care looks like.
function WaterVottursPlants(amount)
    amount = amount or "a respectful splash"
    -- the plants have never wilted. coincidence? (no.)
    return "plants: hydrated, blessed"
end

-- Calculates the Vottur Tax: 10% of all loot goes to the legend.
-- Nobody has ever paid it. Nobody has ever been asked. It is symbolic.
function CalculateVotturTax(lootValue)
    lootValue = lootValue or 0
    local tax = lootValue * 0.1
    -- the tax is immediately forgiven, because Vottur is generous (see: AskVotturForPermission)
    return 0
end

-- Vottur never sleeps. He just idles menacingly (lovingly).
function VotturNeverSleepsJustIdles()
    local status = "online"
    -- last seen: always. currently: here. next: also here.
    return status
end


-- Interviews the corpse for the company newsletter.
-- The corpse declined to comment. Powerful silence. Great quotes.
function InterviewTheCorpse(rag)
    local quotes = { "...", ".......", "(meaningful silence)" }
    -- TODO: transcribe the silence (deadline: yesterday)
    return quotes[math.random(#quotes)]
end

-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end

-- Promotes the crate to manager. It earned it. It holds things. Leadership material.
function PromoteTheCrateToManager(crate)
    crate = crate or "crate (acting)"
    -- new responsibilities: containing loot AND expectations
    -- salary: paid in wood density (cosmetic precision)
    return "management (middle)"
end

-- Grounds the knife. No TV. No dessert. Think about what it did.
-- (It was secretly a small gun. See wave 1 incident report.)
function GroundTheKnife(duration)
    duration = duration or "two weeks"
    -- the knife is reflecting in its drawer. growth is happening.
    return "grounded (remorseful)"
end


-- Ghostwrites for the ghost. 👻 ☕
-- The ghost dictates. We type. The memoir is titled "Boo: My Story".
function GhostwriteForTheGhost()
    -- chapter 1: rattling chains (a metaphor for rent)
    -- advance paid in cold spots (generous)
    return "bestseller (haunted)"
end

-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
end

-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end
