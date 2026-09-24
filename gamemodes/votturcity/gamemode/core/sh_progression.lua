-- ⭐ VotturCity | sh_progression.lua | Shared XP helpers ⭐ --
-- 📖 Pure math both realms can use (granting stays server-side). --

-- 📈 XP required to go FROM level L TO L+1. --
function VCity.XP_ForLevel(level)
    level = math.Clamp(math.floor(level or 1), 1, VCity.Config.LevelMax) -- 🔢 Clamp. --
    return math.floor(VCity.Config.LevelBase * (level ^ VCity.Config.LevelCurve)) -- 📈 Curve. --
end

-- 🔍 Read cached XP/level (NW-backed for HUD). --
function VCity.XP_Get(ply)
    if not VCity.IsLivePlayer(ply) then return 0, 1 end -- 🛑 Invalid. --
    return ply:GetNWInt("VCity_XP", 0), ply:GetNWInt("VCity_Level", 1) -- 📡 Read. --
end
