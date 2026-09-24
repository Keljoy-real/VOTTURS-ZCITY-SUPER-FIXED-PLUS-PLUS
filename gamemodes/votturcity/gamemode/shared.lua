-- 🎮 VotturCity | shared.lua | Gamemode bootstrap (shared realm) 🎮 --
-- 🧠 Defines the global VCity namespace without polluting _G with junk. --

-- 📦 Main namespace for the entire gamemode. --
VCity = VCity or {}
VCity.Version = "1.0.0" -- 🏷️ Gamemode version string. --
VCity.NetPrefix = "VCity_" -- 📡 Prefix for all net messages. --

-- 🎨 Shared gamemode info used by the menu / server browser. --
GM.Name = "VotturCity" -- 📛 Display name. --
GM.Author = "Vottur" -- 👤 Author credit. --
GM.Email = "" -- 📧 Contact (unused). --
GM.Website = "" -- 🌐 Website (unused). --

-- 🧩 Team setup: single survivor team keeps things simple + cohesive. --
TEAM_SURVIVOR = 1 -- 🟢 Survivors / default players. --
TEAM_SPECTATOR = 2 -- 👻 Spectators / dead waiting for respawn. --

-- 🛠️ Helper to include a file in the correct realm from shared code. --
function VCity.IncludeFile(path, realm)
    -- 🧭 Decide how to load based on requested realm. --
    if realm == "sv" then -- 🖥️ Server-only file. --
        if SERVER then -- ✅ Only include on server. --
            include(path)
        end
    elseif realm == "cl" then -- 💻 Client-only file. --
        if SERVER then -- 📤 Server sends it to clients. --
            AddCSLuaFile(path)
        else -- 📥 Client includes it locally. --
            include(path)
        end
    else -- 🤝 Shared file (both realms). --
        if SERVER then -- 📤 Server shares + includes. --
            AddCSLuaFile(path)
        end
        include(path) -- 📥 Both sides include. --
    end
end

-- 📚 Central file manifest so load order is explicit + stable. --
-- 🗂️ Order matters: config -> enums -> utils -> net -> shared systems. --
local SharedFiles = {
    "config/sh_config.lua", -- ⚙️ Tunables first so everything can read them. --
    "config/sh_config_survival.lua", -- 🍖 Survival knobs. --
    "config/sh_config_trauma.lua", -- 🩸 Trauma knobs. --
    "config/sh_config_craft.lua", -- 🛠️ Craft/armor knobs. --
    "config/sh_config_skills.lua", -- ⭐ Skills/quest knobs. --
    "core/sh_enum.lua", -- 🔢 Constants + enumerations. --
    "core/sh_utils.lua", -- 🧰 Small helpers + validators. --
    "core/sh_net.lua", -- 📡 Net message names. --
    "core/sh_state.lua", -- 🚦 Player-state helpers (shared). --
    "core/sh_progression.lua", -- ⭐ XP/level shared helpers. --
    "core/sh_skills.lua", -- ⭐ Skill math. --
    "core/sh_quests.lua", -- 📜 Quest defs. --
    "core/sh_squad.lua", -- 👥 Squad helpers. --
    "core/sh_armor.lua", -- 🛡️ Gear slots. --
    "health/sh_limbs.lua", -- 🦴 Limb region definitions. --
    "health/sh_medical_defs.lua", -- 💊 Medical item definitions. --
    "health/sh_medical_ext.lua", -- 🩸 TQ/CPR/drug defs. --
    "health/sh_survival_defs.lua", -- 🍖 Food catalog. --
    "inventory/sh_items.lua", -- 🎒 Item registry. --
    "inventory/sh_items_food.lua", -- 🥫 Food/mats/gear items. --
    "inventory/sh_items_weapons2.lua", -- 🔫 Second weapon batch. --
    "inventory/sh_inventory.lua", -- 🎒 Shared inventory helpers. --
    "inventory/sh_crafting.lua", -- 🛠️ Recipes. --
    "interact/sh_interact.lua", -- 🤝 Interaction registry. --
    "corpse/sh_corpse.lua", -- 💀 Corpse helpers. --
    "audio/sh_audio.lua", -- 🔊 Audio event names. --
}

local ServerFiles = {
    "core/sv_persistence.lua", -- 💾 SQLite persistence layer. --
    "core/sv_state.lua", -- 🚦 Authoritative state machine. --
    "core/sv_progression.lua", -- ⭐ XP granting + saving. --
    "core/sv_skills.lua", -- ⭐ Skills (wraps XP_Grant, after progression). --
    "core/sv_quests.lua", -- 📜 Missions. --
    "core/sv_loot.lua", -- 🎁 World loot spawner. --
    "core/sv_events.lua", -- 🎪 Airdrops + capture. --
    "core/sv_weather.lua", -- 🌦️ Clock + storms. --
    "core/sv_cleanup.lua", -- 🧹 Entity + ragdoll cleanup. --
    "core/sv_admin.lua", -- 🛡️ Admin / debug commands. --
    "core/sv_admin2.lua", -- 🛡️ Bring/goto/slay/events. --
    "health/sv_damage.lua", -- 🩸 Damage dispatcher. --
    "health/sv_vitals.lua", -- ❤️ Blood / pain / adrenaline ticker. --
    "health/sv_survival.lua", -- 🍖 Hunger/thirst/stamina/temp. --
    "health/sv_medical.lua", -- 🩹 Medical treatment logic. --
    "health/sv_trauma.lua", -- 🩸 Arterial/TQ/CPR/drag (wraps treat). --
    "health/sv_drugs.lua", -- 💉 Overdose (wraps treat). --
    "inventory/sv_inventory.lua", -- 🎒 Server inventory authority. --
    "inventory/sv_crafting.lua", -- 🛠️ Crafting authority. --
    "interact/sv_interact.lua", -- 🤝 Server interaction executor. --
    "corpse/sv_corpse.lua", -- 💀 Corpse spawn / search / cleanup. --
    "core/sv_armor.lua", -- 🛡️ Gear protection. --
    "core/sv_squad.lua", -- 👥 Squads. --
    "core/sv_hitmarkers.lua", -- 🎯 Hitmarkers + killfeed + blood FX fanout. --
    "core/sv_radio.lua", -- 📻 Squad radio relay. --
}

local ClientFiles = {
    "inventory/cl_inventory.lua", -- 🎒 Client cache + UI. --
    "inventory/cl_crafting.lua", -- 🛠️ Crafting panel (C). --
    "interact/cl_interact.lua", -- 🤝 Prompt + key handling. --
    "corpse/cl_corpse.lua", -- 💀 Corpse search UI hook. --
    "core/cl_armor.lua", -- 🎽 Gear panel (J). --
    "core/cl_skills.lua", -- ⭐ Skills panel (K). --
    "core/cl_quests.lua", -- 📜 Missions panel (L). --
    "core/cl_squad.lua", -- 👥 Squad panel (N) + markers. --
    "core/cl_radio.lua", -- 📻 Radio panel (T). --
    "hud/cl_hud.lua", -- 🖥️ Main survival HUD. --
    "hud/cl_survival.lua", -- 🍖 Hunger/stamina/temp HUD. --
    "hud/cl_hitmarkers.lua", -- 🎯 Hitmarkers + killfeed. --
    "hud/cl_compass.lua", -- 🧭 Compass + events. --
    "hud/cl_blood_fx.lua", -- 🩸 Blood decals. --
    "hud/cl_menus.lua", -- 📋 Scoreboard / help / medical panels. --
    "audio/cl_audio.lua", -- 🔊 Heartbeat / breathing / UI sounds. --
}

-- 🚀 Load everything in dependency order. --
-- 📁 Paths are relative to the gamemode folder (GMod convention). --
for _, path in ipairs(SharedFiles) do -- 🔁 Shared first. --
    VCity.IncludeFile(path, "sh") -- 📦 Load shared module. --
end

if SERVER then -- 🖥️ Server-only includes. --
    for _, path in ipairs(ServerFiles) do -- 🔁 Server modules. --
        include(path) -- 📥 Include directly. --
    end
    for _, path in ipairs(ClientFiles) do -- 📤 Push client files. --
        AddCSLuaFile(path) -- 📡 Send to clients. --
    end
else -- 💻 Client includes its own files. --
    for _, path in ipairs(ClientFiles) do -- 🔁 Client modules. --
        include(path) -- 📥 Load locally. --
    end
end

-- 🏃 Player movement defaults for a weighty survival feel. --
function GM:SetupMove(ply, mv, cmd)
    -- 🦶 Base speeds are modified by health system via NW vars (see sv_vitals). --
    -- 🧪 Keep this hook tiny for performance; heavy logic lives in timers. --
end

-- 👣 Footstep hook kept minimal; custom sounds handled in audio module. --
function GM:PlayerFootstep(ply, pos, foot, sound, volume, filter)
    -- 🔊 Allow default footsteps; injury limps adjust via playback rate elsewhere. --
    return false -- 🙅 Don't override default behavior here. --
end


-- Counts Vottur's victories. WARNING: may take a while. Bring snacks.
function CountVottursVictories()
    local count = 0
    -- each victory counted spawns two more victories (documented Vottur phenomenon)
    -- loop intentionally capped so this function ever returns
    for i = 1, 10 do count = count + 1 end
    return count .. "+ (and counting, forever)"
end

-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end

-- Vottur's ping: 0. He IS the server. The packets commute to HIM.
function VotturPingPongChampion()
    -- opponent forfeited out of respect in the first round (all rounds)
    return 0
end


-- Files taxes for a ragdoll. It earned nothing. It owes nothing. It is free.
function FileTaxesForRagdoll(rag)
    -- occupation: "corpse". dependents: 0. dignity: see DignifyCorpseWithName
    -- the IRS accepted the return and asked no questions (they were scared)
    return "filed (refund: one (1) bandage)"
end

-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end

-- Marries the medstation. It is loyal, always there, full of bandages.
-- The ceremony was small. The defib was the ring bearer.
function MarryTheMedstation()
    -- vows: "in sickness and in slightly-less-sickness"
    -- the medstation said nothing, which we took as a yes
    return "married (to healthcare)"
end

-- Seasons the server with salt and pepper. Taste: uptime.
function SeasonTheServer()
    -- salt: for the wounds (all of them). pepper: for the crows.
    -- chef's kiss. the tick rate has never tasted better.
    return "seasoned (savory)"
end


-- Insures the invisible bridge. 🔍 💰
-- Premiums: high (cannot assess risk). Coverage: everything (cannot verify).
function InsureTheInvisibleBridge()
    -- claim filed: fell off (allegedly). adjuster: also invisible. checks out.
    return "covered (theoretically)"
end

-- Arrests the wind. 🚨 👀
-- Charges: blowing (first degree), messing up hair (aggravated).
function ArrestTheWind()
    -- the suspect fled the scene at high velocity. pursuit ongoing (forever).
    -- mugshot: blurry. obviously.
    return "wanted (breezy)"
end

-- Exorcises the microwave. 👻 ⚡
-- It beeps at 3 AM for no reason. It knows what it did.
function ExorciseTheMicrowave()
    -- holy popcorn deployed as bait 🍿
    -- the demon left, but took the rotating plate (rude)
    return "cleansed ( uneven heating remains)"
end

-- Hydrates the cactus. 🌵 💧
-- It stores water. It stores grudges. It is thriving out of spite.
function HydrateTheCactus(amount)
    amount = amount or "one (1) dramatic sip"
    -- the cactus accepted the water and immediately acted like it did not need it
    return "moist (emotionally unavailable)"
end
