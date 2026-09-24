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
    "core/sh_enum.lua", -- 🔢 Constants + enumerations. --
    "core/sh_utils.lua", -- 🧰 Small helpers + validators. --
    "core/sh_net.lua", -- 📡 Net message names. --
    "core/sh_state.lua", -- 🚦 Player-state helpers (shared). --
    "core/sh_progression.lua", -- ⭐ XP/level shared helpers. --
    "health/sh_limbs.lua", -- 🦴 Limb region definitions. --
    "health/sh_medical_defs.lua", -- 💊 Medical item definitions. --
    "inventory/sh_items.lua", -- 🎒 Item registry. --
    "inventory/sh_inventory.lua", -- 🎒 Shared inventory helpers. --
    "interact/sh_interact.lua", -- 🤝 Interaction registry. --
    "corpse/sh_corpse.lua", -- 💀 Corpse helpers. --
    "audio/sh_audio.lua", -- 🔊 Audio event names. --
}

local ServerFiles = {
    "core/sv_persistence.lua", -- 💾 SQLite persistence layer. --
    "core/sv_state.lua", -- 🚦 Authoritative state machine. --
    "core/sv_progression.lua", -- ⭐ XP granting + saving. --
    "core/sv_loot.lua", -- 🎁 World loot spawner. --
    "core/sv_cleanup.lua", -- 🧹 Entity + ragdoll cleanup. --
    "core/sv_admin.lua", -- 🛡️ Admin / debug commands. --
    "health/sv_damage.lua", -- 🩸 Damage dispatcher. --
    "health/sv_vitals.lua", -- ❤️ Blood / pain / adrenaline ticker. --
    "health/sv_medical.lua", -- 🩹 Medical treatment logic. --
    "inventory/sv_inventory.lua", -- 🎒 Server inventory authority. --
    "interact/sv_interact.lua", -- 🤝 Server interaction executor. --
    "corpse/sv_corpse.lua", -- 💀 Corpse spawn / search / cleanup. --
}

local ClientFiles = {
    "inventory/cl_inventory.lua", -- 🎒 Client cache + UI. --
    "interact/cl_interact.lua", -- 🤝 Prompt + key handling. --
    "corpse/cl_corpse.lua", -- 💀 Corpse search UI hook. --
    "hud/cl_hud.lua", -- 🖥️ Main survival HUD. --
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
