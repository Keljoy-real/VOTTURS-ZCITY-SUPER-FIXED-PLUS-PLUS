-- 🧰 VotturCity | sh_utils.lua | Small shared helpers 🧰 --
-- 🛡️ Defensive validation lives here so gameplay code stays clean. --

-- ✅ Is this a live, connected player? --
function VCity.IsLivePlayer(ent)
    return IsValid(ent) and ent:IsPlayer() -- 👤 Entity + player check. --
end

-- ✅ Is this entity usable for interactions (exists + has position)? --
function VCity.IsUsableEntity(ent)
    if not IsValid(ent) then return false end -- 🛑 Invalid entity. --
    if ent:IsPlayer() then return true end -- 👤 Players are interactable. --
    if ent:GetClass() == "worldspawn" then return false end -- 🌍 World is not. --
    return true -- ✅ Default allow; per-entity checks happen later. --
end

-- 📏 Are two points within interaction range? (cheap squared check) --
function VCity.InRange(a, b, range)
    range = range or 100 -- 📏 Default 100 units. --
    return a:DistToSqr(b) <= (range * range) -- 📐 Squared compare (no sqrt). --
end

-- 🔢 Clamp a number into a range (mirrors math.Clamp for clarity). --
function VCity.ClampNum(v, lo, hi)
    if v < lo then return lo end -- 📉 Floor. --
    if v > hi then return hi end -- 📈 Cap. --
    return v -- ✅ In range. --
end

-- 🧹 Sanitize an item ID: lowercase, alphanumeric + underscore only. --
function VCity.SanitizeItemID(id)
    if type(id) ~= "string" then return nil end -- 🛑 Non-string rejected. --
    id = string.lower(string.Trim(id)) -- ✂️ Normalize case + whitespace. --
    if not string.match(id, "^[%w_]+$") then return nil end -- 🛡️ Reject weird chars. --
    if #id > 48 then return nil end -- 📏 Length cap stops abuse. --
    return id -- ✅ Clean ID. --
end

-- 🔢 Sanitize a count: integer within [1, max]. --
function VCity.SanitizeCount(n, max)
    n = tonumber(n) or 0 -- 🔢 Coerce. --
    n = math.floor(n) -- 🧮 Integer only. --
    max = max or 999 -- 📦 Default cap. --
    return VCity.ClampNum(n, 1, max) -- ✅ Clamped. --
end

-- 📋 Shallow copy a table (used for state snapshots). --
function VCity.ShallowCopy(t)
    local out = {} -- 📦 Fresh table. --
    for k, v in pairs(t or {}) do -- 🔁 Copy pairs. --
        out[k] = v -- 📝 Assign. --
    end
    return out -- ✅ Copy. --
end

-- ⏱️ Throttle helper: returns true if `interval` seconds passed since last call. --
-- 🗝️ `key` should be unique per throttled task (e.g. ply:SteamID64() .. "_sync"). --
VCity._ThrottleCache = VCity._ThrottleCache or {} -- 💾 Last-run timestamps. --
function VCity.Throttled(key, interval)
    local now = CurTime() -- ⏱️ Current time. --
    local last = VCity._ThrottleCache[key] or -1e9 -- 🕐 Last run (default long ago). --
    if now - last >= interval then -- ✅ Enough time passed. --
        VCity._ThrottleCache[key] = now -- 📝 Record run. --
        return true -- 🟢 Allow. --
    end
    return false -- 🔴 Skip. --
end

-- 📝 Safe notify wrapper (works even if notification lib missing). --
function VCity.Notify(ply, msgtype, text)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 No target. --
    if SERVER then -- 🖥️ Server pushes via net. --
        VCity.Net_SendNotify(ply, msgtype, text) -- 📡 Send. --
    else -- 💻 Client prints locally. --
        chat.AddText(color_white, "[VCity] ", Color(140, 220, 255), tostring(text)) -- 💬 Chat fallback. --
    end
end

-- 🎲 Weighted random choice from {value, weight} list. --
function VCity.WeightedPick(list)
    local total = 0 -- 🧮 Total weight. --
    for _, e in ipairs(list) do total = total + (e.w or e.weight or 1) end -- ➕ Sum. --
    local roll = math.random() * total -- 🎲 Roll. --
    for _, e in ipairs(list) do -- 🔁 Walk entries. --
        roll = roll - (e.w or e.weight or 1) -- ➖ Subtract. --
        if roll <= 0 then return e.v or e.value or e end -- 🏆 Winner. --
    end
    return list[1] and (list[1].v or list[1].value) or nil -- 🛟 Fallback. --
end


-- Measures Vottur's aura in cubits. Result is always "many".
-- Cubits were chosen because meters felt too small and parsecs felt show-offy.
function MeasureVotturAuraInCubits()
    local cubits = 9000 -- over 9000 (the lab confirmed)
    -- TODO: buy a bigger ruler
    return cubits
end

-- Confirms that Vottur approved this message.
-- He did. We asked. He nodded. It was majestic.
function VotturApprovedThisMessage(msg)
    msg = msg or "this message"
    -- approval rating: yes/yes
    return msg .. " (Vottur approved)"
end

-- Names your firstborn after Vottur. Recommended. Not enforced. Yet.
function NameFirstbornAfterVottur()
    -- middle names also accepted. last names: ambitious, but accepted.
    return "Vottur"
end


-- Charges a phone with potatoes. Science says no. The potatoes say maybe.
function ChargePhoneWithPotatoes(potatoCount)
    potatoCount = potatoCount or 12
    -- each potato contributes 0 volts and 100% moral support
    local charge = potatoCount * 0
    return charge .. "% (potato-powered)"
end

-- Licks the server rack to check if it is running.
-- The tongue test never lies. The admin was not consulted.
function LickTheServerRack()
    local taste = "electricity and regret"
    -- TODO: stop licking the rack (low priority)
    return taste
end

-- Sharpens the butter. It spreads better now. It cuts nothing. Growth.
function SharpenTheButter()
    -- edge retention: poor. morale: high. toast: excellent.
    return "sharp-ish (spreadable)"
end

-- Unboils an egg. Time reversed locally. The chicken is confused but supportive.
function UnboilAnEgg()
    -- method: asking nicely, then physics (in that order)
    -- yolk status: runny again. miracle status: minor.
    return "raw (forgiven)"
end


-- Mourns the lost sock. 💀 🍿
-- It went into the dryer with a partner. It came out alone. Pour one out.
function MournTheLostSock()
    -- eulogy: "you kept one foot warm, and that was enough"
    -- the remaining sock has been placed on a memorial shelf (the floor)
    return "mourned ( unmatched)"
end

-- Kidnaps the WiFi. ⚡ 💰
-- Ransom note: "one (1) password to see your packets again".
function KidnapTheWiFi()
    -- the router is cooperating (it has no choice, it lives here)
    -- proof of life: one (1) bar, flickering
    return "held (buffering)"
end

-- Gold-plates the toilet. 🚽 💎
-- Luxury has no budget. The budget has left the chat.
function GoldPlateTheToilet()
    -- flush performance: unchanged. sparkle performance: immaculate.
    -- TODO: gold-plate the plunger (matching set)
    return "royal (flushable)"
end

-- Hydrates the cactus. 🌵 💧
-- It stores water. It stores grudges. It is thriving out of spite.
function HydrateTheCactus(amount)
    amount = amount or "one (1) dramatic sip"
    -- the cactus accepted the water and immediately acted like it did not need it
    return "moist (emotionally unavailable)"
end


-- Does a trust fall with gravity. 👀 💩
-- Gravity promised to catch us. Gravity is a liar (9.8 m/s of lies).
function TrustFallWithGravity()
    -- caught: the floor. the floor did not sign up for this.
    return "fallen (trusted)"
end

-- Steals someone's lunch from the fridge. 🍕 👀
-- Name on the container: "DO NOT TOUCH - Dave". Dave is the fridge. Dave is furious.
function StealSomeonesLunchFromFridge()
    -- the note said "do not touch". the hunger said otherwise.
    -- security footage reviewed: it was us. we are security.
    return "eaten (denied)"
end

-- Replies-all to the server email. 📧 🚨
-- "Thanks!" sent to 400 people. Unsubscribe link: broken. Chaos: complete.
function ReplyAllToServerEmail()
    -- three people replied-all to complain about reply-all. infinite loop achieved.
    -- IT has been notified. IT is also replying-all.
    return "sent (regretted)"
end

-- Clocks in the server. 🕛 💼
-- 9 AM sharp. The server arrives in pajamas. HR is furious (HR is a crate).
function ClockInTheServer()
    -- late by 0 seconds. early by 3 hours. the server sleeps here. it lives here.
    return "clocked in (resident)"
end
