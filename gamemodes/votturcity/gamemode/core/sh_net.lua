-- 📡 VotturCity | sh_net.lua | Net message registry 📡 --
-- 🎯 Single list of net strings so client/server never disagree. --

VCity.Net = { -- 📡 All net channel names (prefixed at registration). --
    VITALS = "VCity_Vitals", -- ❤️ Blood/pain/adrenaline snapshot. --
    VITALS_REQUEST = "VCity_VitalsReq", -- ❤️ Client asks for vitals. --
    INV = "VCity_Inv", -- 🎒 Full inventory snapshot. --
    INV_OP = "VCity_InvOp", -- 🎒 Client -> server inventory operation. --
    INV_DROP = "VCity_InvDrop", -- 🎒 Client -> server drop request. --
    NOTIFY = "VCity_Notify", -- 📝 Server -> client toast/chat. --
    INTERACT = "VCity_Interact", -- 🤝 Client -> server interaction request. --
    INTERACT_MENU = "VCity_InteractMenu", -- 🤝 Server -> client corpse/crate contents. --
    CORPSE_SEARCH = "VCity_CorpseSearch", -- 💀 Client -> server take-from-corpse. --
    XP = "VCity_XP", -- ⭐ XP/level snapshot. --
    MEDICAL = "VCity_Medical", -- 🩹 Client -> server self-treatment request. --
    TREAT_OTHER = "VCity_TreatOther", -- 🩹 Client -> server treat-other request. --
    ADMIN = "VCity_Admin", -- 🛡️ Admin command channel (validated). --
    AUDIO = "VCity_Audio", -- 🔊 Server -> client positional audio cue. --
    STATE = "VCity_State", -- 🚦 Player state change broadcast. --
}

-- 🖥️ Server registers every string once at load. --
if SERVER then -- 🖥️ Registration realm. --
    for _, name in pairs(VCity.Net) do -- 🔁 Each channel. --
        util.AddNetworkString(name) -- 📡 Register with engine. --
    end
    print("[VCity] 📡 Registered " .. table.Count(VCity.Net) .. " net channels") -- 📝 Log. --
end

-- 📝 Lightweight server -> client toast (type: 0 info, 1 good, 2 bad). --
function VCity.Net_SendNotify(ply, msgtype, text)
    if not SERVER then return end -- 🖥️ Server only. --
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate target. --
    net.Start(VCity.Net.NOTIFY) -- 📡 Open channel. --
    net.WriteUInt(msgtype or 0, 2) -- 🔢 2-bit type. --
    net.WriteString(string.sub(tostring(text or ""), 1, 200)) -- ✂️ Cap length. --
    net.Send(ply) -- 📤 Send to one player. --
end

-- 📝 Broadcast notify to everyone (use sparingly!). --
function VCity.Net_BroadcastNotify(msgtype, text)
    if not SERVER then return end -- 🖥️ Server only. --
    net.Start(VCity.Net.NOTIFY) -- 📡 Open channel. --
    net.WriteUInt(msgtype or 0, 2) -- 🔢 Type. --
    net.WriteString(string.sub(tostring(text or ""), 1, 200)) -- ✂️ Cap. --
    net.Broadcast() -- 📢 All clients. --
end
