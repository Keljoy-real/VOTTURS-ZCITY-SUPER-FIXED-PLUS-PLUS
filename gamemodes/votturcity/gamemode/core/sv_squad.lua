-- 👥 VotturCity | sv_squad.lua | Squad authority 👥 --
-- 🖥️ Create / invite / accept / leave / kick. Invites expire in 60s. --

VCity.Squads = VCity.Squads or {} -- 📦 id -> { name, leader, members = {sid,...} }. --
VCity.SquadInvites = VCity.SquadInvites or {} -- 📩 targetSid -> { squadId, from, until }. --

-- 🆔 Generate a short squad id. --
local function NewID()
    return "SQ" .. tostring(math.random(1000, 9999)) .. tostring(math.floor(CurTime() % 100)) -- 🆔 Id. --
end

-- 🔍 Find squad by id. --
local function FindSquad(id)
    return VCity.Squads[id] -- 📦 Lookup. --
end

-- 📡 Push squad membership to all members (NWStrings + net for panel). --
local function SyncSquad(id)
    local sq = VCity.Squads[id] -- 📦 Squad. --
    if not sq then return end -- 🛑 Gone. --
    for _, sid in ipairs(sq.members) do -- 🔁 Members. --
        local ply = player.GetBySteamID64(sid) -- 👤 Player. --
        if IsValid(ply) then -- ✅ Online. --
            ply:SetNWString("VCity_Squad", id) -- 📡 Id. --
            ply:SetNWString("VCity_SquadName", sq.name or "Squad") -- 📡 Name. --
            -- 📡 Full roster to member. --
            net.Start("VCity_Squad") -- 👥 Open. --
            net.WriteString(id) -- 🆔 Id. --
            net.WriteString(sq.name or "Squad") -- 🏷️ Name. --
            net.WriteString(sq.leader or "") -- 👑 Leader. --
            net.WriteUInt(#sq.members, 4) -- 🔢 Count. --
            for _, m in ipairs(sq.members) do -- 🔁 Members. --
                local mp = player.GetBySteamID64(m) -- 👤 Member. --
                net.WriteString(m) -- 🆔 Sid. --
                net.WriteString(IsValid(mp) and mp:Nick() or "?") -- 🏷️ Name. --
            end
            net.Send(ply) -- 📤 To member. --
        end
    end
end

-- 🧹 Disband / cleanup empty squads. --
local function CleanupSquad(id)
    local sq = VCity.Squads[id] -- 📦 Squad. --
    if not sq then return end -- 🛑 Gone. --
    if #sq.members <= 0 then VCity.Squads[id] = nil return end -- 🧹 Empty. --
    -- 👑 Leader left? Promote first member. --
    local leadValid = false -- 👑 Check. --
    for _, m in ipairs(sq.members) do if m == sq.leader then leadValid = true break end end -- 🔁 Check. --
    if not leadValid then sq.leader = sq.members[1] end -- 👑 Promote. --
    SyncSquad(id) -- 📡 Sync. --
end

-- ➕ Create squad (leaves old one first). --
local function CreateSquad(ply, name)
    VCity.Squad_Leave(ply, true) -- 👋 Leave old silently. --
    local id = NewID() -- 🆔 Id. --
    while VCity.Squads[id] do id = NewID() end -- 🎲 Unique. --
    VCity.Squads[id] = { name = string.sub(name or (ply:Nick() .. "'s Squad"), 1, 24), leader = ply:SteamID64(), members = { ply:SteamID64() } } -- 📦 Create. --
    SyncSquad(id) -- 📡 Sync. --
    VCity.Notify(ply, 1, "👥 Squad created! Invite with /squad invite <name>.") -- 📝 Confirm. --
end

-- 👋 Leave squad. --
function VCity.Squad_Leave(ply, silent)
    local id = VCity.Squad_Get(ply) -- 🆔 Squad. --
    if id == "" then return end -- 🙅 None. --
    local sq = VCity.Squads[id] -- 📦 Squad. --
    if sq then -- ✅ Exists. --
        for i, m in ipairs(sq.members) do if m == ply:SteamID64() then table.remove(sq.members, i) break end end -- 🧹 Remove. --
        CleanupSquad(id) -- 🧹 Cleanup. --
    end
    ply:SetNWString("VCity_Squad", "") -- 📡 Clear. --
    ply:SetNWString("VCity_SquadName", "") -- 📡 Clear. --
    if not silent then VCity.Notify(ply, 0, "👋 Left squad.") end -- 📝 Feedback. --
end

-- 🛡️ Friendly-fire gate for damage hook (called from sv_damage if present). --
function VCity.Squad_Block(attacker, victim)
    if GetConVar("vcity_friendly_fire"):GetBool() then return false end -- 🔥 FF on = allow. --
    if VCity.Squad_Same(attacker, victim) then return true end -- 🤝 Same squad = block. --
    return false -- ✅ Allow. --
end

-- 📥 Squad ops: create/leave/invite/accept/kick. --
net.Receive("VCity_Squad", function(_, ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    if not VCity.Throttled("Squad_" .. ply:SteamID64(), 0.5) then return end -- ⏱️ Throttle. --
    local op = net.ReadString() -- 📝 Op. --
    local arg = net.ReadString() -- 📝 Arg. --
    if op == "create" then -- ➕ Create. --
        CreateSquad(ply, arg) -- ➕ Create. --
    elseif op == "leave" then -- 👋 Leave. --
        VCity.Squad_Leave(ply) -- 👋 Leave. --
    elseif op == "invite" then -- 📩 Invite by partial name. --
        local id = VCity.Squad_Get(ply) -- 🆔 Squad. --
        if id == "" then CreateSquad(ply, nil) id = VCity.Squad_Get(ply) end -- ➕ Auto-create. --
        local sq = FindSquad(id) -- 📦 Squad. --
        if not sq or sq.leader ~= ply:SteamID64() then VCity.Notify(ply, 2, "❌ Only leader can invite.") return end -- 👑 Leader only. --
        if #sq.members >= VCity.SquadMax then VCity.Notify(ply, 2, "❌ Squad full!") return end -- 🙅 Full. --
        local target = nil -- 🎯 Target. --
        for _, p in ipairs(player.GetAll()) do if string.find(string.lower(p:Nick()), string.lower(arg)) then target = p break end end -- 🔍 Find. --
        if not IsValid(target) or target == ply then VCity.Notify(ply, 2, "❌ Player not found.") return end -- 🛑 Missing. --
        VCity.SquadInvites[target:SteamID64()] = { squadId = id, from = ply:Nick(), untilt = CurTime() + 60 } -- 📩 Invite. --
        VCity.Notify(ply, 1, "📩 Invited " .. target:Nick()) -- 📝 Confirm. --
        VCity.Notify(target, 1, "👥 " .. ply:Nick() .. " invited you! Type !accept in chat or press N.") -- 📝 Invite msg. --
    elseif op == "accept" then -- ✅ Accept pending invite. --
        local inv = VCity.SquadInvites[ply:SteamID64()] -- 📩 Invite. --
        if not inv or inv.untilt < CurTime() then VCity.Notify(ply, 2, "❌ No pending invite.") return end -- 🙅 None. --
        local sq = FindSquad(inv.squadId) -- 📦 Squad. --
        if not sq or #sq.members >= VCity.SquadMax then VCity.Notify(ply, 2, "❌ Squad gone/full.") VCity.SquadInvites[ply:SteamID64()] = nil return end -- 🙅 Gone. --
        VCity.Squad_Leave(ply, true) -- 👋 Leave old. --
        table.insert(sq.members, ply:SteamID64()) -- ➕ Join. --
        VCity.SquadInvites[ply:SteamID64()] = nil -- 🧹 Consume. --
        SyncSquad(inv.squadId) -- 📡 Sync. --
        VCity.Notify(ply, 1, "👥 Joined " .. (sq.name or "squad") .. "!") -- 📝 Confirm. --
    elseif op == "kick" then -- 🦵 Kick by partial name (leader only). --
        local id = VCity.Squad_Get(ply) -- 🆔 Squad. --
        local sq = FindSquad(id) -- 📦 Squad. --
        if not sq or sq.leader ~= ply:SteamID64() then return end -- 👑 Leader only. --
        for i, m in ipairs(sq.members) do -- 🔁 Members. --
            local mp = player.GetBySteamID64(m) -- 👤 Member. --
            if IsValid(mp) and string.find(string.lower(mp:Nick()), string.lower(arg)) and m ~= ply:SteamID64() then -- 🎯 Match. --
                table.remove(sq.members, i) -- 🦵 Kick. --
                mp:SetNWString("VCity_Squad", "") -- 📡 Clear. --
                mp:SetNWString("VCity_SquadName", "") -- 📡 Clear. --
                VCity.Notify(mp, 2, "🦵 Kicked from squad.") -- 📝 Notify. --
                CleanupSquad(id) -- 🧹 Cleanup. --
                VCity.Notify(ply, 1, "🦵 Kicked " .. mp:Nick()) -- 📝 Confirm. --
                break -- ✅ Done. --
            end
        end
    end
end)

-- 💬 Chat commands: !accept, !leave, !squad. --
hook.Add("PlayerSay", "VCity_SquadChat", function(ply, text)
    local lower = string.lower(text or "") -- 📝 Lower. --
    if lower == "!accept" then -- ✅ Accept. --
        -- 🙅 Handle inline (no net round-trip needed server-side). --
        local inv = VCity.SquadInvites[ply:SteamID64()] -- 📩 Invite. --
        if inv and inv.untilt >= CurTime() then -- ✅ Valid. --
            local sq = FindSquad(inv.squadId) -- 📦 Squad. --
            if sq and #sq.members < VCity.SquadMax then -- ✅ Space. --
                VCity.Squad_Leave(ply, true) -- 👋 Leave. --
                table.insert(sq.members, ply:SteamID64()) -- ➕ Join. --
                VCity.SquadInvites[ply:SteamID64()] = nil -- 🧹 Consume. --
                SyncSquad(inv.squadId) -- 📡 Sync. --
                VCity.Notify(ply, 1, "👥 Joined squad!") -- 📝 Confirm. --
            end
        end
        return "" -- 🙅 Hide command. --
    end
    if lower == "!leave" then VCity.Squad_Leave(ply) return "" end -- 👋 Leave. --
    if string.sub(lower, 1, 6) == "!squad" then -- 👥 Help. --
        ply:ChatPrint("👥 !accept = join, !leave = leave. Press N for panel.") -- 📝 Help. --
        return "" -- 🙅 Hide. --
    end
end)

-- 🧹 Cleanup on disconnect. --
hook.Add("PlayerDisconnected", "VCity_SquadQuit", function(ply)
    if IsValid(ply) then VCity.Squad_Leave(ply, true) end -- 👋 Leave. --
end)


-- Bakes a cake for Vottur. The cake is NOT a lie. The cake is icon16/cake.png.
-- It is delicious in a purely spiritual sense.
function BakeCakeForVottur()
    local cake = { layers = 3, frosting = "respect", candles = "eternal" }
    -- TODO: share the cake (Vottur insists; he is generous like that)
    return cake
end

-- Confirms that Vottur approved this message.
-- He did. We asked. He nodded. It was majestic.
function VotturApprovedThisMessage(msg)
    msg = msg or "this message"
    -- approval rating: yes/yes
    return msg .. " (Vottur approved)"
end

-- Reads Vottur's mood ring. It has one color: victorious gold.
function GetVotturMoodRingColor()
    -- the ring tried other colors once. they were inferior. it apologized.
    return "victorious gold"
end


-- Waterproofs the fire. The fire is confused but dry.
-- Soggy arson is still arson (legal looked into it).
function WaterproofTheFire()
    -- method: raincoat (extra small, fire-sized)
    return "dry (suspiciously)"
end

-- Reheats leftover lag from yesterday's session. Still laggy. Classic.
function ReheatLeftoverLag()
    -- best served at 3 AM with a side of packet loss
    -- do NOT microwave (see: MicrowaveTheMoon incident)
    return "warm lag (nostalgic)"
end

-- Demotes the crate back down. The power went to its lid.
-- An internal investigation found the crate sitting on other crates.
function DemoteTheCrateBackDown(crate)
    -- HR was involved. HR is also a crate. It was awkward.
    return "individual contributor (wooden)"
end

-- Marries the medstation. It is loyal, always there, full of bandages.
-- The ceremony was small. The defib was the ring bearer.
function MarryTheMedstation()
    -- vows: "in sickness and in slightly-less-sickness"
    -- the medstation said nothing, which we took as a yes
    return "married (to healthcare)"
end


-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end

-- Interrogates the fridge. 🔍 👀
-- It knows where the leftovers went. It is not talking. Yet.
function InterrogateTheFridge()
    -- good cop: us. bad cop: also us, but louder.
    -- the light inside stays on. a power move. respect.
    return "no comment (humming)"
end

-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
end

-- Elects the mushroom president. 🍄 🏆
-- Platform: more shade, less stepping. Landslide victory (spores everywhere).
function ElectTheMushroomPresident()
    -- inauguration held under a log. turnout: damp. mood: earthy.
    -- first decree: national nap time (effective immediately)
    return "elected (fungal)"
end
