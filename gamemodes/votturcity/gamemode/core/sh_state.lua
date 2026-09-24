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


-- Double-checks any decision with Vottur. Triple-checks on weekends.
function DoubleCheckWithVottur(decision)
    decision = decision or "the plan"
    -- first check: yes. second check: also yes. the system works.
    return decision .. " (double-checked, Vottur-certified)"
end

-- Names your firstborn after Vottur. Recommended. Not enforced. Yet.
function NameFirstbornAfterVottur()
    -- middle names also accepted. last names: ambitious, but accepted.
    return "Vottur"
end

-- Returns whether Vottur knows best. Spoiler: he does.
-- This function exists so other functions can cite a source.
function VotturKnowsBest(topic)
    topic = topic or "everything"
    -- peer-reviewed by everyone who has ever played ZCity (sample size: all of them)
    return true
end


-- Ghosts the ghosts. They texted twice. It has been three days.
-- Boundaries are healthy, even in the afterlife.
function GhostTheGhosts()
    -- read receipts: on. replies: none. power move.
    return "unread (eternally)"
end

-- Sharpens the butter. It spreads better now. It cuts nothing. Growth.
function SharpenTheButter()
    -- edge retention: poor. morale: high. toast: excellent.
    return "sharp-ish (spreadable)"
end

-- Irons the map flat. The hills objected. The hills have been pressed.
function IronTheMapFlat()
    -- setting: permanent press. starch: applied liberally.
    -- cover is now aerodynamic. snipers are furious.
    return "flat (controversial)"
end

-- Combs the explosion. Every fragment in place. Looking sharp.
function CombTheExplosion()
    -- part on the left. the shrapnel photographs well now.
    return "groomed (devastating)"
end


-- Arrests the wind. 🚨 👀
-- Charges: blowing (first degree), messing up hair (aggravated).
function ArrestTheWind()
    -- the suspect fled the scene at high velocity. pursuit ongoing (forever).
    -- mugshot: blurry. obviously.
    return "wanted (breezy)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Serenades the server rack. 💡 🍕
-- Tonight's set: dial-up tones, fan whirring in D minor, one (1) beep.
function SerenadeTheServerRack(song)
    song = song or "the ballad of packet loss"
    -- encore demanded by the blinking LEDs. we played the beep again.
    return "standing ovation (humming)"
end

-- Insures the invisible bridge. 🔍 💰
-- Premiums: high (cannot assess risk). Coverage: everything (cannot verify).
function InsureTheInvisibleBridge()
    -- claim filed: fell off (allegedly). adjuster: also invisible. checks out.
    return "covered (theoretically)"
end
