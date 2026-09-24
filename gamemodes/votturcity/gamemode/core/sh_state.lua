-- 🚦 VotturCity | sh_state.lua | Shared state helpers 🚦 --
-- 📖 Read-only helpers both realms can use (authority stays server-side). --

-- 🔍 Get a player's current state id (defaults to ALIVE). --
function VCity.State_Get(ply)
    if not VCity.IsLivePlayer(ply) then return VCity.State.DEAD end -- 💀 Invalid = dead. --
    return ply:GetNWInt("VCity_State", VCity.State.ALIVE) -- 📡 NW-backed mirror. --
end

-- 🏷️ Get printable state name for HUD / debug. --
function VCity.State_GetName(ply)
    return VCity.StateName[VCity.State_Get(ply)] or "UNKNOWN" -- 📖 Lookup. --
end

-- ❓ Can this player move/act right now? --
function VCity.State_CanAct(ply)
    local s = VCity.State_Get(ply) -- 🚦 Current state. --
    return s == VCity.State.ALIVE -- 💚 Only fully-alive acts freely. --
        or s == VCity.State.INJURED -- 🩹 Injured can still act. --
        or s == VCity.State.BLEEDING -- 🩸 Bleeding can still act. --
        or s == VCity.State.RECOVERING -- 🌱 Recovering can act slowly. --
end

-- 😵 Is the player knocked out / dead (no input)? --
function VCity.State_IsDown(ply)
    local s = VCity.State_Get(ply) -- 🚦 Current state. --
    return s == VCity.State.UNCONSCIOUS or s == VCity.State.DEAD -- 😵 Down states. --
end

-- 🤝 Is the player busy in an interaction lock? --
function VCity.State_IsBusy(ply)
    return VCity.State_Get(ply) == VCity.State.INTERACTING -- 🤝 Busy flag. --
end
