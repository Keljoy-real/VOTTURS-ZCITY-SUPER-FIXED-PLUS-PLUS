-- 🖥️ VotturCity | init.lua | Server entrypoint 🖥️ --
-- 📥 Loads shared bootstrap then runs server-side startup logic. --

include("shared.lua") -- 🤝 Load shared manifest first. --
AddCSLuaFile("shared.lua") -- 📤 Ensure clients get the bootstrap. --
AddCSLuaFile("cl_init.lua") -- 📤 Ensure clients get their entrypoint. --

-- 📢 Server startup banner (helps verify gamemode booted). --
print("[VCity] 🟢 VotturCity v" .. (VCity.Version or "?") .. " server init") -- 🟢 Boot log. --

-- 🧱 Basic server convars for quick tuning without file edits. --
-- ⚙️ These mirror sh_config values but allow runtime overrides. --
CreateConVar("vcity_respawn_time", "10", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Seconds until respawn") -- ⏱️ Respawn delay. --
CreateConVar("vcity_friendly_fire", "0", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Allow friendly fire (0/1)") -- 🔥 FF toggle. --

-- 👥 Team setup: create survivor + spectator teams. --
function GM:CreateTeams()
    team.SetUp(TEAM_SURVIVOR, "Survivors", Color(120, 200, 120)) -- 🟢 Survivor team. --
    team.SetUp(TEAM_SPECTATOR, "Spectators", Color(150, 150, 150)) -- 👻 Spectator team. --
    team.SetSpawnPoint(TEAM_SURVIVOR, "info_player_start") -- 📍 Spawn entity class. --
end

-- 🎒 First-spawn setup: model, loadout, state, inventory, vitals. --
function GM:PlayerInitialSpawn(ply, transition)
    ply:SetTeam(TEAM_SURVIVOR) -- 🟢 Everyone starts as survivor. --
    -- 💾 Load persisted XP/level + inventory skeleton (see sv_persistence). --
    timer.Simple(0.5, function() -- ⏳ Defer one tick so SteamID is valid. --
        if IsValid(ply) then -- ✅ Guard against disconnect during delay. --
            VCity.DB_LoadPlayer(ply) -- 💾 Load or create DB row. --
            VCity.State_Set(ply, VCity.State.ALIVE) -- 🚦 Fresh alive state. --
            VCity.Inventory_Ensure(ply) -- 🎒 Make sure inventory table exists. --
        end
    end)
end

-- 🔄 Every (re)spawn: reset model, health, vitals, give basics. --
function GM:PlayerSpawn(ply, transition)
    -- 👀 Spectators stay spectating. --
    if ply:Team() == TEAM_SPECTATOR then -- 👻 Spectator check. --
        ply:Spectate(OBS_MODE_ROAMING) -- 🔭 Roam while dead/waiting. --
        return -- 🛑 Skip survivor setup. --
    end

    ply:SetTeam(TEAM_SURVIVOR) -- 🟢 Force survivor team. --
    ply:SetModel("models/player/Group03/male_0" .. math.random(1, 9) .. ".mdl") -- 🧍 Random citizen model. --
    ply:SetWalkSpeed(VCity.Config.MoveWalk) -- 🚶 Walk speed from config. --
    ply:SetRunSpeed(VCity.Config.MoveRun) -- 🏃 Run speed from config. --
    ply:SetCrouchedWalkSpeed(0.4) -- 🦆 Crouch modifier. --
    ply:SetJumpPower(200) -- 🦘 Jump power. --
    ply:SetupHands() -- 🙌 Build viewmodel hands. --

    -- ❤️ Reset core survival values (see health modules). --
    VCity.Vitals_Reset(ply) -- 🩸 Fresh blood / pain / limbs. --
    VCity.State_Set(ply, VCity.State.ALIVE) -- 🚦 Mark alive. --
    ply:SetHealth(100) -- ❤️ Base HP (limb damage modifies effective HP). --
    ply:SetMaxHealth(100) -- 💯 Max HP cap. --
    ply:SetArmor(0) -- 🛡️ No armor at spawn. --
    ply:UnSpectate() -- 👀 Exit spectate if previously dead. --
    ply:Freeze(false) -- 🧊 Ensure not frozen. --

    -- 🎒 Starter kit: hands + bandage so new players can act immediately. --
    timer.Simple(0.2, function() -- ⏳ Slight delay so weapons lib is ready. --
        if not IsValid(ply) then return end -- 🛑 Player left. --
        if not ply:Alive() then return end -- 💀 Died instantly (edge case). --
        ply:StripWeapons() -- 🧹 Clear stale weapons. --
        ply:Give("vcity_hands") -- 🙌 Fists / interaction tool. --
        VCity.Inventory_Give(ply, "bandage", 1, true) -- 🩹 One free bandage. --
        VCity.Inventory_Give(ply, "painkillers", 1, true) -- 💊 One free painkiller. --
        ply:SelectWeapon("vcity_hands") -- 🙌 Equip hands by default. --
    end)

    -- 📡 Push a full state sync to the spawner + nearby clients. --
    timer.Simple(1, function() -- ⏳ Wait for client to be ready. --
        if IsValid(ply) then -- ✅ Still here. --
            VCity.Vitals_Sync(ply) -- 📡 Send vitals snapshot. --
            VCity.Inventory_Sync(ply) -- 🎒 Send inventory snapshot. --
            VCity.XP_Sync(ply) -- ⭐ Send XP snapshot. --
        end
    end)
end

-- 🧰 Default loadout disabled; we grant manually in PlayerSpawn. --
function GM:PlayerLoadout(ply)
    return true -- 🙅 Suppress default HL2 loadout. --
end

-- 💀 Central death hook: corpse, state, XP, cleanup. --
function GM:DoPlayerDeath(ply, attacker, dmginfo)
    VCity.State_Set(ply, VCity.State.DEAD) -- ⚰️ Mark dead first (authoritative). --
    VCity.Corpse_Spawn(ply) -- 💀 Create searchable corpse + ragdoll. --
    VCity.OnPlayerDeathXP(ply, attacker) -- ⭐ Participation XP. --
    -- 🧹 Drop nothing automatically; corpse holds inventory (see sv_corpse). --
end

-- ⏱️ Respawn timer respects convar + state. --
function GM:PlayerDeathThink(ply)
    -- 🕐 Only respawn after configured delay. --
    if ply.NextSpawnTime and ply.NextSpawnTime > CurTime() then -- ⏳ Still waiting. --
        return false -- 🙅 Don't respawn yet. --
    end
    -- 🧮 Set next allowed spawn if missing (first death). --
    if not ply.NextSpawnTime then -- 🆕 First check after death. --
        ply.NextSpawnTime = CurTime() + GetConVar("vcity_respawn_time"):GetFloat() -- ⏱️ Schedule. --
        ply:SetTeam(TEAM_SPECTATOR) -- 👻 Spectate while waiting. --
        ply:Spectate(OBS_MODE_ROAMING) -- 🔭 Roam camera. --
        return false -- 🙅 Wait. --
    end
    ply.NextSpawnTime = nil -- ♻️ Clear for next life. --
    ply:UnSpectate() -- 👀 Exit spectate. --
    ply:Spawn() -- 🌱 Respawn. --
    return false -- ✅ We handled spawning manually. --
end

-- 💾 Save on disconnect to avoid XP/inventory loss. --
function GM:PlayerDisconnected(ply)
    VCity.DB_SavePlayer(ply) -- 💾 Flush to SQLite. --
    VCity.Corpse_CleanupPlayer(ply) -- 🧹 Remove orphan corpse refs. --
end

-- 🧹 Periodic autosave so crashes lose less progress (throttled). --
timer.Create("VCity_Autosave", 120, 0, function() -- ⏱️ Every 2 minutes. --
    for _, ply in ipairs(player.GetAll()) do -- 🔁 All players. --
        if IsValid(ply) then -- ✅ Valid check. --
            VCity.DB_SavePlayer(ply) -- 💾 Save one player. --
        end
    end
    print("[VCity] 💾 Autosaved " .. player.GetCount() .. " players") -- 📝 Log. --
end)

-- 👋 Welcome message + controls hint. --
hook.Add("PlayerInitialSpawn", "VCity_Welcome", function(ply)
    timer.Simple(3, function() -- ⏳ Wait for HUD to load. --
        if IsValid(ply) then -- ✅ Still connected. --
            ply:ChatPrint("🟢 Welcome to VotturCity! Press E to interact, I for inventory, H for medical.") -- 👋 Help. --
            ply:ChatPrint("🩸 Watch your blood + pain. Bandage bleeding fast!") -- 🩸 Tip. --
        end
    end)
end)
