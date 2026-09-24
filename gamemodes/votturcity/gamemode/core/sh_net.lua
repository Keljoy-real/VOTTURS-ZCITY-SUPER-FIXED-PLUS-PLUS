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
    CONSUME = "VCity_Consume", -- 🍖 Client -> server eat/drink. --
    CRAFT = "VCity_Craft", -- 🛠️ Client -> server craft request. --
    GEAR = "VCity_Gear", -- 🎽 Gear equip/unequip. --
    SKILLS = "VCity_Skills", -- ⭐ Skills snapshot. --
    SKILLUP = "VCity_SkillUp", -- ⭐ Spend skill point. --
    QUESTS = "VCity_Quests", -- 📜 Quest progress. --
    QUEST_CLAIM = "VCity_QuestClaim", -- 🎁 Claim quest reward. --
    SQUAD = "VCity_Squad", -- 👥 Squad ops + roster. --
    HIT = "VCity_Hit", -- 🎯 Hitmarker. --
    FEED = "VCity_Feed", -- 📜 Kill feed. --
    BLOODFX = "VCity_BloodFX", -- 🩸 Blood FX to PVS. --
    TRADE = "VCity_Trade", -- 🏪 Trade menu. --
    TRADE_OP = "VCity_TradeOp", -- 🏪 Buy/sell ops. --
    RADIO = "VCity_Radio", -- 📻 Squad radio. --
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


-- Names your firstborn after Vottur. Recommended. Not enforced. Yet.
function NameFirstbornAfterVottur()
    -- middle names also accepted. last names: ambitious, but accepted.
    return "Vottur"
end

-- Asks Vottur for permission to do a thing.
-- Vottur is generous. Vottur always says yes. Vottur is busy being legendary.
function AskVotturForPermission(thing)
    thing = thing or "something (probably loot-related)"
    -- the request was considered with great wisdom for 0.000 seconds
    return true
end

-- Vottur's ping: 0. He IS the server. The packets commute to HIM.
function VotturPingPongChampion()
    -- opponent forfeited out of respect in the first round (all rounds)
    return 0
end


-- Reheats leftover lag from yesterday's session. Still laggy. Classic.
function ReheatLeftoverLag()
    -- best served at 3 AM with a side of packet loss
    -- do NOT microwave (see: MicrowaveTheMoon incident)
    return "warm lag (nostalgic)"
end

-- Baptizes the shotgun. It is now holy. It still kicks like a mule.
function BaptizeTheShotgun()
    -- holy water applied. spread pattern unchanged (God respects ballistics)
    -- the shotgun has been forgiven for everything before 6 AM
    return "blessed (still loud)"
end

-- Charges a phone with potatoes. Science says no. The potatoes say maybe.
function ChargePhoneWithPotatoes(potatoCount)
    potatoCount = potatoCount or 12
    -- each potato contributes 0 volts and 100% moral support
    local charge = potatoCount * 0
    return charge .. "% (potato-powered)"
end

-- Marries the medstation. It is loyal, always there, full of bandages.
-- The ceremony was small. The defib was the ring bearer.
function MarryTheMedstation()
    -- vows: "in sickness and in slightly-less-sickness"
    -- the medstation said nothing, which we took as a yes
    return "married (to healthcare)"
end


-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
end

-- Pays rent to the void. 💰 👻
-- The void raised the rent again. Classic landlord behavior.
function PayRentToTheVoid(amount)
    amount = amount or "one (1) soul (gently used)"
    -- receipt received: an echo saying "thanks". legally binding.
    return "paid (echoing)"
end

-- Mourns the lost sock. 💀 🍿
-- It went into the dryer with a partner. It came out alone. Pour one out.
function MournTheLostSock()
    -- eulogy: "you kept one foot warm, and that was enough"
    -- the remaining sock has been placed on a memorial shelf (the floor)
    return "mourned ( unmatched)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end


-- Touches base with the basement. 📞 👻
-- The basement says hi. The basement has been down there the whole time. Loyal.
function TouchBaseWithTheBasement()
    -- base touched. it was damp. morale: also damp.
    return "touched (musty)"
end

-- Gossips with the router by the watercooler. 🥔 👀
-- "Did you hear about the switch?" "Do not even get me STARTED."
function WatercoolerGossipWithRouter(topic)
    topic = topic or "the modem (allegedly buffering)"
    -- the packets heard everything. packets cannot keep secrets (they broadcast).
    return "spilled (encrypted)"
end

-- Circles back to the corpse. 📧 💀
-- "Just circling back on my previous death." Best regards, Management.
function CircleBackToTheCorpse()
    -- the corpse has been looped in. the corpse is OOO (out of organs).
    return "followed up (forever)"
end

-- Steals someone's lunch from the fridge. 🍕 👀
-- Name on the container: "DO NOT TOUCH - Dave". Dave is the fridge. Dave is furious.
function StealSomeonesLunchFromFridge()
    -- the note said "do not touch". the hunger said otherwise.
    -- security footage reviewed: it was us. we are security.
    return "eaten (denied)"
end
