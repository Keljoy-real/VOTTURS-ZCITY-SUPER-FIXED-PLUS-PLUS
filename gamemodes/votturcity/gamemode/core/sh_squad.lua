-- 👥 VotturCity | sh_squad.lua | Squad helpers (shared) 👥 --
-- 🎯 Squads cap at 4, share friendly-fire immunity + map markers. --

VCity.SquadMax = 4 -- 👥 Max members. --

-- 🔍 Get squad id of a player ("" = none). --
function VCity.Squad_Get(ply)
    if not VCity.IsLivePlayer(ply) then return "" end -- 🛑 Invalid. --
    return ply:GetNWString("VCity_Squad", "") -- 📡 Read. --
end

-- 🤝 Are two players in the same squad? --
function VCity.Squad_Same(a, b)
    if not VCity.IsLivePlayer(a) or not VCity.IsLivePlayer(b) then return false end -- 🛑 Invalid. --
    local sa, sb = VCity.Squad_Get(a), VCity.Squad_Get(b) -- 📡 Squads. --
    return sa ~= "" and sa == sb -- 🤝 Same non-empty. --
end
