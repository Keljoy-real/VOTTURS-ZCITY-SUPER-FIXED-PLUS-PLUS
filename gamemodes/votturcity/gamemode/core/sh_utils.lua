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
