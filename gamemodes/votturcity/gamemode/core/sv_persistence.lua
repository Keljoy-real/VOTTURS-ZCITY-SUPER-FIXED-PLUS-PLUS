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
