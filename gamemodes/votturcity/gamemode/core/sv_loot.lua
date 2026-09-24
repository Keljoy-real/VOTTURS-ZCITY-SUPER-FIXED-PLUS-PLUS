-- 🎁 VotturCity | sv_loot.lua | World loot spawner 🎁 --
-- ⏱️ One periodic sweep keeps world stocked without entity spam. --

-- 🎲 Loot tables: weighted {item, count range, weight}. --
VCity.LootTables = {
    common = { -- 🟢 Frequent: ammo + basic meds. --
        { v = { id = "ammo_9mm", min = 6, max = 18 }, w = 20 }, -- 🔫 9mm. --
        { v = { id = "ammo_rifle", min = 6, max = 18 }, w = 15 }, -- 🔫 Rifle. --
        { v = { id = "ammo_shell", min = 3, max = 8 }, w = 12 }, -- 🔫 Shells. --
        { v = { id = "bandage", min = 1, max = 2 }, w = 18 }, -- 🩹 Bandage. --
        { v = { id = "painkillers", min = 1, max = 2 }, w = 12 }, -- 💊 Pills. --
        { v = { id = "scrap", min = 1, max = 3 }, w = 15 }, -- ⚙️ Scrap. --
    },
    medical = { -- 🏥 Medical-heavy (near stations / crates). --
        { v = { id = "bandage", min = 1, max = 3 }, w = 20 }, -- 🩹 Bandage. --
        { v = { id = "bigbandage", min = 1, max = 2 }, w = 12 }, -- 🩹 Trauma. --
        { v = { id = "medkit", min = 1, max = 1 }, w = 8 }, -- 🩺 Kit. --
        { v = { id = "morphine", min = 1, max = 1 }, w = 8 }, -- 💉 Morphine. --
        { v = { id = "bloodbag", min = 1, max = 1 }, w = 6 }, -- 🩸 Blood. --
        { v = { id = "splint", min = 1, max = 1 }, w = 8 }, -- 🦴 Splint. --
    },
    weapon = { -- 🔫 Rare weapon drops. --
        { v = { id = "w_glock", min = 1, max = 1 }, w = 10 }, -- 🔫 Pistol. --
        { v = { id = "w_knife", min = 1, max = 1 }, w = 10 }, -- 🔪 Knife. --
        { v = { id = "w_shotgun", min = 1, max = 1 }, w = 4 }, -- 🔫 Shotgun. --
        { v = { id = "w_akm", min = 1, max = 1 }, w = 3 }, -- 🔫 Rifle. --
        { v = { id = "armor_vest", min = 1, max = 1 }, w = 5 }, -- 🛡️ Vest. --
        { v = { id = "ammo_rifle", min = 10, max = 30 }, w = 12 }, -- 🔫 Ammo. --
    },
}

-- 🎲 Roll one stack from a table. --
local function RollOne(tableName)
    local t = VCity.LootTables[tableName] or VCity.LootTables.common -- 📦 Table. --
    local pick = VCity.WeightedPick(t) -- 🎲 Pick. --
    if not pick then return nil end -- 🛑 Empty. --
    return { id = pick.id, count = math.random(pick.min or 1, pick.max or 1) } -- 📦 Stack. --
end

-- 🎲 Roll crate contents (2-4 stacks, mixed tables). --
function VCity.Loot_RollCrate()
    local out = {} -- 📦 Contents. --
    local n = math.random(2, 4) -- 🔢 Count. --
    for i = 1, n do -- 🔁 Rolls. --
        local tbl = "common" -- 🟢 Default. --
        local r = math.random() -- 🎲 Roll. --
        if r < 0.2 then tbl = "weapon" elseif r < 0.5 then tbl = "medical" end -- 🎲 Mix. --
        local s = RollOne(tbl) -- 🎲 Stack. --
        if s then table.insert(out, s) end -- ➕ Add. --
    end
    return out -- ✅ Contents. --
end

-- 📍 Find spawn points: player spawn entities + random nav-free ground. --
local function FindLootSpots(n)
    local spots = {} -- 📍 Spots. --
    -- 🥇 Prefer info_player_start / info_player_deathmatch positions. --
    for _, cls in ipairs({ "info_player_start", "info_player_deathmatch", "info_player_terrorist", "info_player_counterterrorist" }) do -- 🔁 Classes. --
        for _, ent in ipairs(ents.FindByClass(cls)) do -- 🔁 Entities. --
            if #spots >= n then break end -- ✅ Enough. --
            if IsValid(ent) then table.insert(spots, ent:GetPos() + Vector(math.Rand(-150, 150), math.Rand(-150, 150), 10)) end -- 📍 Jitter. --
        end
    end
    -- 🥈 Fallback: random around existing players. --
    while #spots < n do -- 🔁 Fill. --
        local plys = player.GetAll() -- 👥 Players. --
        if #plys <= 0 then break end -- 🛑 No players. --
        local p = plys[math.random(#plys)] -- 👤 Random player. --
        if IsValid(p) then -- ✅ Valid. --
            table.insert(spots, p:GetPos() + Vector(math.Rand(-600, 600), math.Rand(-600, 600), 20)) -- 📍 Nearby. --
        else break end -- 🛑 Invalid. --
    end
    return spots -- ✅ Spots. --
end

-- 🧮 Count live loot pickups (cheap ents.FindByClass, throttled caller). --
function VCity.Loot_Count()
    return #ents.FindByClass("vcity_pickup") -- 📦 Count. --
end

-- 🌍 Spawn initial loot at server start. --
hook.Add("InitPostEntity", "VCity_LootInit", function()
    timer.Simple(5, function() -- ⏳ Wait for map entities. --
        VCity.Loot_Sweep(true) -- 🧹 First fill. --
        -- 🏥 Spawn 2 medical stations near spawns (if none mapped). --
        if #ents.FindByClass("vcity_medstation") <= 0 then -- 🏥 None. --
            local spots = FindLootSpots(2) -- 📍 Spots. --
            for _, pos in ipairs(spots) do -- 🔁 Each. --
                local st = ents.Create("vcity_medstation") -- 🏥 Station. --
                if IsValid(st) then st:SetPos(pos) st:Spawn() st:Activate() end -- 🌱 Spawn. --
            end
        end
        -- 📦 Spawn 3 crates near spawns. --
        local spots = FindLootSpots(3) -- 📍 Spots. --
        for _, pos in ipairs(spots) do -- 🔁 Each. --
            local c = ents.Create("vcity_crate") -- 📦 Crate. --
            if IsValid(c) then c:SetPos(pos) c:Spawn() c:Activate() end -- 🌱 Spawn. --
        end
    end)
end)

-- 🧹 Periodic sweep: top up loot to max (one timer globally). --
function VCity.Loot_Sweep(first)
    local have = VCity.Loot_Count() -- 📦 Current. --
    local need = VCity.Config.LootMaxItems - have -- 📦 Deficit. --
    if need <= 0 then return end -- ✅ Stocked. --
    local n = math.min(need, first and need or 10) -- 📦 Per-sweep cap (avoid bursts). --
    local spots = FindLootSpots(n) -- 📍 Spots. --
    for _, pos in ipairs(spots) do -- 🔁 Each. --
        -- 🔍 Ground the spawn with a trace (avoid floating loot). --
        local tr = util.TraceLine({ start = pos + Vector(0, 0, 50), endpos = pos - Vector(0, 0, 200), mask = MASK_SOLID_BRUSHONLY }) -- 🔍 Trace. --
        local ground = tr.HitPos + Vector(0, 0, 12) -- 📍 Ground. --
        -- 🎲 80% common, 15% medical, 5% weapon. --
        local r = math.random() -- 🎲 Roll. --
        local tbl = r < 0.05 and "weapon" or (r < 0.2 and "medical" or "common") -- 🎲 Table. --
        local s = RollOne(tbl) -- 🎲 Stack. --
        if s then VCity.Inventory_SpawnPickup(s.id, s.count, ground) end -- 📦 Spawn. --
    end
    print("[VCity] 🎁 Loot sweep: +" .. #spots .. " (total " .. (have + #spots) .. ")") -- 📝 Log. --
end

timer.Create("VCity_LootTimer", VCity.Config.LootInterval, 0, function() -- ⏱️ Periodic. --
    VCity.Loot_Sweep(false) -- 🧹 Top up. --
end)
