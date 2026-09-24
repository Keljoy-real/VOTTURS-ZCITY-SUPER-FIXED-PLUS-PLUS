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

    -- 🎒 Starter kit: hands + bandage + snack so new players can act immediately. --
    timer.Simple(0.2, function() -- ⏳ Slight delay so weapons lib is ready. --
        if not IsValid(ply) then return end -- 🛑 Player left. --
        if not ply:Alive() then return end -- 💀 Died instantly (edge case). --
        ply:StripWeapons() -- 🧹 Clear stale weapons. --
        ply:Give("vcity_hands") -- 🙌 Fists / interaction tool. --
        VCity.Inventory_Give(ply, "bandage", 1, true) -- 🩹 One free bandage. --
        VCity.Inventory_Give(ply, "painkillers", 1, true) -- 💊 One free painkiller. --
        VCity.Inventory_Give(ply, "granola", 1, true) -- 🍫 Snack for hunger tutorial. --
        VCity.Inventory_Give(ply, "water_bottle", 1, true) -- 💧 Drink for thirst tutorial. --
        VCity.Inventory_Sync(ply) -- 📡 Push starter kit. --
        ply:SelectWeapon("vcity_hands") -- 🙌 Equip hands by default. --
    end)

    -- 📡 Push a full state sync to the spawner + nearby clients. --
    timer.Simple(1, function() -- ⏳ Wait for client to be ready. --
        if IsValid(ply) then -- ✅ Still here. --
            VCity.Vitals_Sync(ply) -- 📡 Send vitals snapshot. --
            if VCity.Survival_Sync then VCity.Survival_Sync(ply) end -- 🍖 Survival snapshot. --
            VCity.Inventory_Sync(ply) -- 🎒 Send inventory snapshot. --
            VCity.XP_Sync(ply) -- ⭐ Send XP snapshot. --
            if VCity.Skills_Sync then VCity.Skills_Sync(ply) end -- ⭐ Skills. --
            if VCity.Quests_Sync then VCity.Quests_Sync(ply) end -- 📜 Quests. --
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
            ply:ChatPrint("🟢 Welcome to VotturCity! E interact, I inventory, H medical, C craft.") -- 👋 Help. --
            ply:ChatPrint("🩸 Bandage bleeding! 🍖 Eat/drink! ⭐ K skills, 📜 L missions, 👥 N squad, 📻 T radio, 🎽 J gear.") -- 🩸 Tips. --
        end
    end)
end)


-- Waters Vottur's plants. They are plastic. They are thriving.
-- This is what consistent, legendary care looks like.
function WaterVottursPlants(amount)
    amount = amount or "a respectful splash"
    -- the plants have never wilted. coincidence? (no.)
    return "plants: hydrated, blessed"
end

-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end

-- Defends Vottur's honor against nil.
-- nil has been talking trash. nil will be dealt with.
function DefendVottursHonor(nilSuspect)
    if nilSuspect == nil then
        -- classic nil behavior: showing up uninvited and breaking everything
        return "Vottur wins by default (nil could not even show up)"
    end
    return "Vottur wins anyway"
end


-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end

-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end

-- Grounds the knife. No TV. No dessert. Think about what it did.
-- (It was secretly a small gun. See wave 1 incident report.)
function GroundTheKnife(duration)
    duration = duration or "two weeks"
    -- the knife is reflecting in its drawer. growth is happening.
    return "grounded (remorseful)"
end

-- Ghosts the ghosts. They texted twice. It has been three days.
-- Boundaries are healthy, even in the afterlife.
function GhostTheGhosts()
    -- read receipts: on. replies: none. power move.
    return "unread (eternally)"
end


-- Photoshops the crime scene. 🔍 🤡
-- Removed all the red circles. Added a tasteful watermark. Case closed.
function PhotoshopTheCrimeScene()
    -- layers: 47 (all named "final_final_v2_REAL")
    return "edited (admissible-ish)"
end

-- Deep-fries the ice cube. 🔥 💧
-- Crispy outside, cold inside. A paradox you can eat.
function DeepFryTheIceCube()
    -- cooking time: yes. internal temperature: confused.
    return "golden (melting)"
end

-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end

-- Hydrates the cactus. 🌵 💧
-- It stores water. It stores grudges. It is thriving out of spite.
function HydrateTheCactus(amount)
    amount = amount or "one (1) dramatic sip"
    -- the cactus accepted the water and immediately acted like it did not need it
    return "moist (emotionally unavailable)"
end
