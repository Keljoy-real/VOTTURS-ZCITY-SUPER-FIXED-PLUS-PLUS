-- 📜 VotturCity | sv_quests.lua | Mission tracking + rewards 📜 --
-- 🖥️ Listens to gameplay hooks; progress saved in vcity_quests table. --

-- 🗄️ Quest table. --
local function EnsureTable()
    sql.Query([[CREATE TABLE IF NOT EXISTS vcity_quests (
        steamid TEXT PRIMARY KEY, data TEXT DEFAULT '{}'
    )]]) -- 🧱 Table. --
end
EnsureTable() -- 🧱 Ensure. --
hook.Add("Initialize", "VCity_QuestsTable", EnsureTable) -- 🧱 Init. --

-- 📥 Load progress. --
function VCity.Quests_Load(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    local row = sql.QueryRow("SELECT data FROM vcity_quests WHERE steamid = " .. SQLStr(ply:SteamID64())) -- 🔍 Lookup. --
    local d = VCity.Quests_Fresh() -- 📦 Fresh. --
    if row and row.data then -- ✅ Have data. --
        local t = util.JSONToTable(row.data) -- 🧪 Parse. --
        if type(t) == "table" then -- ✅ Valid. --
            for k, v in pairs(d) do if t[k] ~= nil then d[k] = t[k] end end -- 📝 Merge (forward-compat). --
            if type(t.claimed) == "table" then d.claimed = t.claimed end -- ✅ Claimed. --
        end
    end
    ply.VCity_Quests = d -- 💾 Store. --
    VCity.Quests_Sync(ply) -- 📡 Push. --
end

-- 💾 Save progress. --
function VCity.Quests_Save(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    local blob = SQLStr(util.TableToJSON(ply.VCity_Quests or VCity.Quests_Fresh())) -- 🧵 JSON. --
    sql.Query("REPLACE INTO vcity_quests (steamid, data) VALUES (" .. SQLStr(ply:SteamID64()) .. ", " .. blob .. ")") -- 💾 Save. --
end

-- 📡 Push to owner. --
function VCity.Quests_Sync(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    local q = ply.VCity_Quests or VCity.Quests_Fresh() -- 📦 Data. --
    net.Start("VCity_Quests") -- 📜 Open. --
    net.WriteUInt(q.kills or 0, 10) -- 🔫 Kills. --
    net.WriteUInt(q.heals or 0, 10) -- 🩹 Heals. --
    net.WriteUInt(q.loot or 0, 10) -- 📦 Loot. --
    net.WriteUInt(q.crafts or 0, 10) -- 🛠️ Crafts. --
    net.WriteUInt(q.revives or 0, 10) -- 🫁 Revives. --
    net.WriteUInt(q.survmin or 0, 10) -- ⏱️ Minutes. --
    -- ✅ Claimed bitmask (6 quests fit in 6 bits). --
    local mask = 0 -- 🔢 Mask. --
    local order = { "first_blood", "medic1", "scavenger1", "crafter1", "reviver", "survivor10" } -- 📜 Order. --
    for i, id in ipairs(order) do if (q.claimed or {})[id] then mask = mask + bit.lshift(1, i - 1) end end -- 🔢 Build. --
    net.WriteUInt(mask, 6) -- ✅ Claimed. --
    net.Send(ply) -- 📤 Owner. --
end

-- ➕ Bump a stat + autosync (throttled per player to avoid spam). --
local function Bump(ply, stat, n)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    ply.VCity_Quests = ply.VCity_Quests or VCity.Quests_Fresh() -- 📦 Ensure. --
    ply.VCity_Quests[stat] = (ply.VCity_Quests[stat] or 0) + (n or 1) -- ➕ Bump. --
    VCity.Quests_Sync(ply) -- 📡 Push (quest events are rare, no throttle needed). --
    -- 🎉 Auto-notify on completion (claim still manual for reward choice timing). --
    for id, def in pairs(VCity.Quests.Defs) do -- 🔁 Quests. --
        if def.stat == stat and (ply.VCity_Quests[stat] or 0) >= def.goal and not (ply.VCity_Quests.claimed or {})[id] then -- 🎉 Done! --
            VCity.Notify(ply, 1, "📜 Quest complete: " .. def.name .. "! Press L to claim.") -- 📝 Notify. --
            ply:EmitSound("buttons/button9.wav", 60, 140) -- 🔊 Ding. --
        end
    end
end

-- 🪝 Kill tracking (engine PlayerDeath). --
hook.Add("PlayerDeath", "VCity_QuestKills", function(victim, inflictor, attacker)
    if VCity.IsLivePlayer(attacker) and attacker ~= victim then Bump(attacker, "kills", 1) end -- 🔫 Kill. --
end)
-- 🪝 Heal / revive via XP reasons (sv_progression grants with reason strings). --
hook.Add("VCity_XPGained", "VCity_QuestHealRevive", function(ply, amount, reason)
    if reason == "heal" then Bump(ply, "heals", 1) end -- 🩹 Heal. --
    if reason == "revive" then Bump(ply, "revives", 1) end -- 🫁 Revive. --
end)
-- 🪝 Crafting. --
hook.Add("VCity_Crafted", "VCity_QuestCraft", function(ply) Bump(ply, "crafts", 1) end) -- 🛠️ Craft. --
-- 🪝 Loot + crates (fired from pickup/crate entities — see edits below). --
hook.Add("VCity_PickedUp", "VCity_QuestLoot", function(ply) Bump(ply, "loot", 1) end) -- 📦 Pickup. --
hook.Add("VCity_CrateOpened", "VCity_QuestLoot2", function(ply) Bump(ply, "loot", 1) end) -- 📦 Crate. --

-- ⏱️ Survival minutes (one timer, all players). --
timer.Create("VCity_QuestSurv", 60, 0, function() -- ⏱️ Every minute. --
    for _, ply in ipairs(player.GetAll()) do -- 🔁 Players. --
        if VCity.IsLivePlayer(ply) and ply:Alive() then -- 💚 Alive. --
            local s = VCity.State_Get(ply) -- 🚦 State. --
            if s == VCity.State.ALIVE or s == VCity.State.INJURED then Bump(ply, "survmin", 1) end -- ⏱️ Count. --
        end
    end
end)

-- 🎁 Claim request: string quest id. --
net.Receive("VCity_QuestClaim", function(_, ply)
    if not VCity.IsLivePlayer(ply) or not ply:Alive() then return end -- 🛑 Validate. --
    if not VCity.Throttled("Quest_" .. ply:SteamID64(), 1) then return end -- ⏱️ Throttle. --
    local id = net.ReadString() -- 🆔 Quest. --
    local def = VCity.Quests.Defs[id] -- 🧾 Def. --
    if not def then return end -- 🛑 Unknown. --
    ply.VCity_Quests = ply.VCity_Quests or VCity.Quests_Fresh() -- 📦 Ensure. --
    ply.VCity_Quests.claimed = ply.VCity_Quests.claimed or {} -- ✅ Ensure. --
    if ply.VCity_Quests.claimed[id] then VCity.Notify(ply, 2, "❌ Already claimed!") return end -- 🙅 Dup. --
    if (ply.VCity_Quests[def.stat] or 0) < def.goal then VCity.Notify(ply, 2, "❌ Not complete yet!") return end -- 🙅 Early. --
    ply.VCity_Quests.claimed[id] = true -- ✅ Mark. --
    local rw = (VCity.Config.QuestRewards or {})[id] or {} -- 🎁 Reward. --
    if (rw.xp or 0) > 0 then VCity.XP_Grant(ply, rw.xp, "quest") end -- ⭐ XP. --
    for itemId, n in pairs(rw.items or {}) do -- 🎁 Items. --
        local left = VCity.Inventory_Give(ply, itemId, n, true) -- 🎒 Give. --
        if left > 0 then VCity.Inventory_SpawnPickup(itemId, left, ply:GetPos() + Vector(0, 0, 30)) end -- 📦 Drop overflow. --
    end
    VCity.Inventory_Sync(ply) -- 📡 Sync. --
    VCity.Quests_Save(ply) -- 💾 Save. --
    VCity.Quests_Sync(ply) -- 📡 Push. --
    VCity.Notify(ply, 1, "🎁 Claimed: " .. def.name) -- 📝 Confirm. --
end)

-- 🪝 Load/save hooks. --
hook.Add("PlayerInitialSpawn", "VCity_QuestsLoad", function(ply)
    timer.Simple(0.8, function() if IsValid(ply) then VCity.Quests_Load(ply) end end) -- ⏳ After DB. --
end)
hook.Add("PlayerDisconnected", "VCity_QuestsSave", function(ply) VCity.Quests_Save(ply) end) -- 💾 Quit. --
timer.Create("VCity_QuestsAutosave", 180, 0, function() for _, p in ipairs(player.GetAll()) do if IsValid(p) then VCity.Quests_Save(p) end end end) -- ⏱️ Autosave. --
