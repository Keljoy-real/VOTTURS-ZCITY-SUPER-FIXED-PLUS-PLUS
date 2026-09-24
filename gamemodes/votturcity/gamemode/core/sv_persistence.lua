-- 💾 VotturCity | sv_persistence.lua | SQLite persistence layer 💾 --
-- 🧱 Abstract storage so MySQL could replace SQLite later without touching gameplay. --

VCity.DB = VCity.DB or {} -- 📦 DB namespace. --

-- 🗄️ Ensure tables exist (called once at server start). --
function VCity.DB_Init()
    -- 👤 One row per player: XP, level, inventory blob, last seen. --
    sql.Query([[CREATE TABLE IF NOT EXISTS vcity_players (
        steamid TEXT PRIMARY KEY,
        name TEXT,
        xp INTEGER DEFAULT 0,
        level INTEGER DEFAULT 1,
        inventory TEXT DEFAULT '[]',
        lastseen INTEGER DEFAULT 0
    )]]) -- 🧱 Players table. --
    -- 🌍 Simple key-value table for gamemode config persistence. --
    sql.Query([[CREATE TABLE IF NOT EXISTS vcity_kv (
        k TEXT PRIMARY KEY,
        v TEXT
    )]]) -- 🧱 KV table. --
    print("[VCity] 💾 Database ready") -- 📝 Log. --
end

-- 🔍 Load a player row, creating it if missing. --
function VCity.DB_LoadPlayer(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    local sid = ply:SteamID64() -- 🆔 Stable ID. --
    local row = sql.QueryRow("SELECT * FROM vcity_players WHERE steamid = " .. SQLStr(sid)) -- 🔍 Lookup. --
    if not row then -- 🆕 First visit: insert defaults. --
        sql.Query("INSERT INTO vcity_players (steamid, name, xp, level, inventory, lastseen) VALUES ("
            .. SQLStr(sid) .. ", " .. SQLStr(ply:Nick()) .. ", 0, 1, '[]', " .. os.time() .. ")") -- ➕ Insert. --
        row = { xp = 0, level = 1, inventory = "[]" } -- 📦 Defaults. --
    end
    -- ⭐ Apply XP/level to the player object. --
    ply.VCity_XP = tonumber(row.xp) or 0 -- ⭐ XP. --
    ply.VCity_Level = math.Clamp(tonumber(row.level) or 1, 1, VCity.Config.LevelMax) -- 🏆 Level. --
    -- 🎒 Decode inventory JSON safely (corrupt data -> empty). --
    local inv = util.JSONToTable(row.inventory or "[]") -- 🧪 Parse. --
    if type(inv) ~= "table" then inv = {} end -- 🛡️ Fallback. --
    ply.VCity_Inventory = {} -- 🎒 Fresh table. --
    for _, entry in ipairs(inv) do -- 🔁 Restore each stack. --
        local id = VCity.SanitizeItemID(entry.id) -- 🧹 Validate ID. --
        local count = VCity.SanitizeCount(entry.count, 999) -- 🔢 Validate count. --
        if id and VCity.Items[id] then -- ✅ Known item. --
            table.insert(ply.VCity_Inventory, { id = id, count = count }) -- ➕ Restore. --
        end
    end
    VCity.XP_Sync(ply) -- 📡 Push XP to client. --
    VCity.Inventory_Sync(ply) -- 📡 Push inventory to client. --
end

-- 💾 Save one player (throttled callers; this function itself is cheap). --
function VCity.DB_SavePlayer(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    local sid = ply:SteamID64() -- 🆔 ID. --
    -- 🎒 Serialize inventory as compact JSON array. --
    local inv = {} -- 📦 Serializable list. --
    for _, stack in ipairs(ply.VCity_Inventory or {}) do -- 🔁 Each stack. --
        table.insert(inv, { id = stack.id, count = stack.count }) -- 📝 Copy. --
    end
    local blob = SQLStr(util.TableToJSON(inv)) -- 🧵 Escape JSON. --
    sql.Query("UPDATE vcity_players SET name = " .. SQLStr(ply:Nick())
        .. ", xp = " .. math.floor(ply.VCity_XP or 0)
        .. ", level = " .. math.floor(ply.VCity_Level or 1)
        .. ", inventory = " .. blob
        .. ", lastseen = " .. os.time()
        .. " WHERE steamid = " .. SQLStr(sid)) -- 💾 Upsert via update (row exists). --
end

-- 🗝️ Tiny KV store for admin-persisted settings. --
function VCity.DB_SetKV(k, v)
    sql.Query("REPLACE INTO vcity_kv (k, v) VALUES (" .. SQLStr(tostring(k)) .. ", " .. SQLStr(tostring(v)) .. ")") -- 💾 Store. --
end

function VCity.DB_GetKV(k, default)
    local row = sql.QueryRow("SELECT v FROM vcity_kv WHERE k = " .. SQLStr(tostring(k))) -- 🔍 Lookup. --
    if row then return row.v end -- ✅ Found. --
    return default -- 🛟 Default. --
end

-- 🚀 Init tables at server start. --
hook.Add("Initialize", "VCity_DBInit", function()
    VCity.DB_Init() -- 💾 Create tables. --
end)
-- 🛟 Also run immediately in case Initialize already fired on refresh. --
VCity.DB_Init() -- 💾 Ensure ready. --


-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end

-- Preallocates memory for the future Vottur statue.
-- Size: yes. Location: everywhere. Material: pure respect (unbreakable).
function PreallocateVotturStatueMemory()
    local statue = {}
    -- reserving space now so the future does not have to wait
    return statue
end

-- Returns whether Vottur knows best. Spoiler: he does.
-- This function exists so other functions can cite a source.
function VotturKnowsBest(topic)
    topic = topic or "everything"
    -- peer-reviewed by everyone who has ever played ZCity (sample size: all of them)
    return true
end


-- Parallel-parks the tank. There is no tank. Nailed it anyway.
function ParallelParkTheTank()
    -- mirrors checked. curb distance: perfect. tank: imaginary.
    -- points deducted for crushing one (1) hypothetical cone
    return "parked (theoretical)"
end

-- Charges a phone with potatoes. Science says no. The potatoes say maybe.
function ChargePhoneWithPotatoes(potatoCount)
    potatoCount = potatoCount or 12
    -- each potato contributes 0 volts and 100% moral support
    local charge = potatoCount * 0
    return charge .. "% (potato-powered)"
end

-- Combs the explosion. Every fragment in place. Looking sharp.
function CombTheExplosion()
    -- part on the left. the shrapnel photographs well now.
    return "groomed (devastating)"
end

-- Interviews the corpse for the company newsletter.
-- The corpse declined to comment. Powerful silence. Great quotes.
function InterviewTheCorpse(rag)
    local quotes = { "...", ".......", "(meaningful silence)" }
    -- TODO: transcribe the silence (deadline: yesterday)
    return quotes[math.random(#quotes)]
end


-- Massages the thunder. ⚡ 👍
-- It has been tense all storm. Knots the size of hail.
function MassageTheThunder(intensity)
    intensity = intensity or "deep tissue"
    -- the thunder reports feeling "lighter, rumbly in a good way now"
    return "relaxed (distant rumbling)"
end

-- Exorcises the microwave. 👻 ⚡
-- It beeps at 3 AM for no reason. It knows what it did.
function ExorciseTheMicrowave()
    -- holy popcorn deployed as bait 🍿
    -- the demon left, but took the rotating plate (rude)
    return "cleansed ( uneven heating remains)"
end

-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
end

-- Feng-shuis the explosion. 💣 👀
-- Shrapnel arranged by color and emotional baggage. Chi: devastating.
function FengShuiTheExplosion()
    -- the blast radius now flows harmoniously outward (still outward though)
    return "balanced (lethal)"
end


-- Holds a bandwidth town hall meeting. 📅 📈
-- Topic: "where did it all go". Attendance: lagging. Irony: noted.
function BandwidthTowHallMeeting()
    -- yes, "Tow". the hall is towed. it moves. that is why nobody can find it.
    -- minutes: lost in transit (fitting)
    return "adjourned (towed)"
end

-- Runs a fire drill during an actual fire. 🔥 🔥
-- Realism: maximum. Preparedness: debatable. Marshmallows: brought.
function FireDrillDuringFire()
    -- meeting point: inside the fire (poor planning, great warmth)
    return "drilled (toasty)"
end

-- Declares casual Friday every day. 🎉 💼
-- Ties: loosened. Pants: optional (server-side only).
function CasualFridayEveryDay()
    -- dress code updated: pajamas are now business formal
    return "casual (permanent)"
end

-- Takes a deep dive into a puddle. 💧 🐟
-- Depth: 3 cm. Findings: profound. A leaf. A reflection. Ourselves.
function DeepDiveIntoPuddle()
    -- scuba gear: galoshes. decompression: shaking off.
    return "surfaced (damp)"
end
