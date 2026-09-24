-- ⭐ VotturCity | sv_progression.lua | Server XP authority ⭐ --
-- 🖥️ All XP grants validated here; clients only display. --

-- 📡 Push XP/level to one player (and mirror on NWInts for HUD). --
function VCity.XP_Sync(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    local xp = math.floor(ply.VCity_XP or 0) -- ⭐ XP. --
    local lvl = math.Clamp(math.floor(ply.VCity_Level or 1), 1, VCity.Config.LevelMax) -- 🏆 Level. --
    ply:SetNWInt("VCity_XP", xp) -- 📡 Mirror XP. --
    ply:SetNWInt("VCity_Level", lvl) -- 📡 Mirror level. --
    net.Start(VCity.Net.XP) -- ⭐ Open channel. --
    net.WriteUInt(xp, 24) -- 🔢 XP (24-bit, up to 16M). --
    net.WriteUInt(lvl, 7) -- 🔢 Level (7-bit, up to 127). --
    net.Send(ply) -- 📤 To owner only (cheap). --
end

-- ➕ Grant XP with level-up handling + hook for future perks. --
function VCity.XP_Grant(ply, amount, reason)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    amount = math.floor(tonumber(amount) or 0) -- 🔢 Integer. --
    if amount <= 0 then return end -- 🛑 Nothing to grant. --
    if amount > 5000 then amount = 5000 end -- 🛡️ Cap single grant (exploit guard). --
    ply.VCity_XP = (ply.VCity_XP or 0) + amount -- ➕ Add. --
    -- 🔁 Level-up loop (handles multi-level jumps). --
    while (ply.VCity_Level or 1) < VCity.Config.LevelMax do -- 🏆 Not maxed. --
        local need = VCity.XP_ForLevel(ply.VCity_Level) -- 📈 Threshold. --
        if (ply.VCity_XP or 0) < need then break end -- 🛑 Not enough. --
        ply.VCity_XP = ply.VCity_XP - need -- ➖ Spend. --
        ply.VCity_Level = ply.VCity_Level + 1 -- ⬆️ Level up. --
        VCity.Notify(ply, 1, "⭐ Level up! You are now level " .. ply.VCity_Level) -- 🎉 Feedback. --
        ply:EmitSound("buttons/button9.wav", 60, 120) -- 🔊 Level-up blip. --
        hook.Run("VCity_LevelUp", ply, ply.VCity_Level) -- 🪝 Perk hook for future. --
    end
    VCity.XP_Sync(ply) -- 📡 Sync. --
    -- 🪝 Generic hook so other systems (achievements) can observe. --
    hook.Run("VCity_XPGained", ply, amount, reason or "unknown") -- 📝 Observe. --
end

-- 💀 Death XP: killer reward + victim consolation. --
function VCity.OnPlayerDeathXP(victim, attacker)
    if VCity.IsLivePlayer(attacker) and attacker ~= victim then -- 🔫 Real killer. --
        VCity.XP_Grant(attacker, VCity.Config.XP_Kill, "kill") -- ⭐ Kill reward. --
    end
end

-- 🩹 Heal / revive XP hooks (called from medical module). --
function VCity.XP_RewardHeal(healer)
    VCity.XP_Grant(healer, VCity.Config.XP_Heal, "heal") -- ⭐ Heal reward. --
end

function VCity.XP_RewardRevive(healer)
    VCity.XP_Grant(healer, VCity.Config.XP_Revive, "revive") -- ⭐ Revive reward. --
end

-- ⏱️ Survival trickle: alive players earn XP each minute (one timer, not per-player). --
timer.Create("VCity_XPTrickle", 60, 0, function() -- ⏱️ Every minute. --
    for _, ply in ipairs(player.GetAll()) do -- 🔁 All players. --
        if VCity.IsLivePlayer(ply) and ply:Alive() then -- 💚 Alive check. --
            local s = VCity.State_Get(ply) -- 🚦 State. --
            if s == VCity.State.ALIVE or s == VCity.State.INJURED then -- 💚 Active. --
                VCity.XP_Grant(ply, VCity.Config.XP_SurviveMinute, "survive") -- ⭐ Trickle. --
            end
        end
    end
end)

-- 💾 Save XP periodically is handled by autosave in init.lua. --
