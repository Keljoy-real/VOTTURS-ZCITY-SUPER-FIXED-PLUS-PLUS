-- 🎁 VotturCity | sv_loot.lua | World loot spawner 🎁 --
-- ⏱️ One periodic sweep keeps world stocked without entity spam. --

-- 🎲 Loot tables: weighted {item, count range, weight}. --
-- 🆕 Extended with food, crafting mats, gear, new guns (all registered items!). --
VCity.LootTables = {
    common = { -- 🟢 Frequent: ammo + basic meds + food + mats. --
        { v = { id = "ammo_9mm", min = 6, max = 18 }, w = 16 }, -- 🔫 9mm. --
        { v = { id = "ammo_rifle", min = 6, max = 18 }, w = 12 }, -- 🔫 Rifle. --
        { v = { id = "ammo_shell", min = 3, max = 8 }, w = 10 }, -- 🔫 Shells. --
        { v = { id = "ammo_44", min = 3, max = 8 }, w = 6 }, -- 🔫 .44. --
        { v = { id = "bandage", min = 1, max = 2 }, w = 14 }, -- 🩹 Bandage. --
        { v = { id = "painkillers", min = 1, max = 2 }, w = 10 }, -- 💊 Pills. --
        { v = { id = "scrap", min = 1, max = 3 }, w = 14 }, -- ⚙️ Scrap. --
        { v = { id = "cloth", min = 1, max = 3 }, w = 12 }, -- 🧵 Cloth. --
        { v = { id = "stick", min = 1, max = 2 }, w = 10 }, -- 🪵 Stick. --
        { v = { id = "canned_beans", min = 1, max = 2 }, w = 10 }, -- 🥫 Beans. --
        { v = { id = "water_bottle", min = 1, max = 2 }, w = 10 }, -- 💧 Water. --
        { v = { id = "granola", min = 1, max = 2 }, w = 8 }, -- 🍫 Snack. --
        { v = { id = "charcoal", min = 1, max = 2 }, w = 6 }, -- ⚫ Charcoal. --
        { v = { id = "herb", min = 1, max = 2 }, w = 6 }, -- 🌿 Herb. --
    },
    medical = { -- 🏥 Medical-heavy (near stations / crates). --
        { v = { id = "bandage", min = 1, max = 3 }, w = 16 }, -- 🩹 Bandage. --
        { v = { id = "bigbandage", min = 1, max = 2 }, w = 10 }, -- 🩹 Trauma. --
        { v = { id = "medkit", min = 1, max = 1 }, w = 7 }, -- 🩺 Kit. --
        { v = { id = "morphine", min = 1, max = 1 }, w = 7 }, -- 💉 Morphine. --
        { v = { id = "bloodbag", min = 1, max = 1 }, w = 5 }, -- 🩸 Blood. --
        { v = { id = "splint", min = 1, max = 1 }, w = 7 }, -- 🦴 Splint. --
        { v = { id = "tourniquet", min = 1, max = 1 }, w = 6 }, -- 🩸 TQ. --
        { v = { id = "cpr_kit", min = 1, max = 1 }, w = 4 }, -- 🫁 CPR. --
        { v = { id = "adrenaline", min = 1, max = 1 }, w = 5 }, -- 💉 Adre. --
        { v = { id = "coffee", min = 1, max = 1 }, w = 5 }, -- ☕ Coffee. --
    },
    weapon = { -- 🔫 Rare weapon drops. --
        { v = { id = "w_glock", min = 1, max = 1 }, w = 9 }, -- 🔫 Pistol. --
        { v = { id = "w_knife", min = 1, max = 1 }, w = 8 }, -- 🔪 Knife. --
        { v = { id = "w_shotgun", min = 1, max = 1 }, w = 4 }, -- 🔫 Shotgun. --
        { v = { id = "w_akm", min = 1, max = 1 }, w = 3 }, -- 🔫 Rifle. --
        { v = { id = "w_smg", min = 1, max = 1 }, w = 4 }, -- 🔫 SMG. --
        { v = { id = "w_dmr", min = 1, max = 1 }, w = 2 }, -- 🔫 DMR. --
        { v = { id = "w_revolver", min = 1, max = 1 }, w = 3 }, -- 🔫 Revolver. --
        { v = { id = "w_machete", min = 1, max = 1 }, w = 4 }, -- 🔪 Machete. --
        { v = { id = "w_taser", min = 1, max = 1 }, w = 3 }, -- ⚡ Taser. --
        { v = { id = "armor_vest", min = 1, max = 1 }, w = 4 }, -- 🛡️ Vest. --
        { v = { id = "helmet", min = 1, max = 1 }, w = 4 }, -- 🪖 Helmet. --
        { v = { id = "gas_mask", min = 1, max = 1 }, w = 3 }, -- 😷 Mask. --
        { v = { id = "ammo_rifle", min = 10, max = 30 }, w = 10 }, -- 🔫 Ammo. --
        { v = { id = "duct_tape", min = 1, max = 2 }, w = 5 }, -- 🩹 Tape. --
        { v = { id = "rope", min = 1, max = 1 }, w = 4 }, -- 🪢 Rope. --
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


-- Hides from Vottur during updates. Pro tip: you cannot. He sees the diff.
-- This function hides anyway, out of tradition.
function HideFromVotturDuringUpdate(hidingSpot)
    hidingSpot = hidingSpot or "behind the medstation"
    -- Vottur has already found you. He brought snacks. Update together.
    return "found (lovingly)"
end

-- Praises Vottur for the simple act of existing.
-- Called zero times, felt a million.
function PraiseVotturForExisting()
    -- historians agree: before Vottur, there was only darkness and unoptimized Think hooks
    print("[VCity] All hail Vottur, bringer of ZCity, defeater of nil.")
    return true -- objectively true
end

-- Confirms that Vottur approved this message.
-- He did. We asked. He nodded. It was majestic.
function VotturApprovedThisMessage(msg)
    msg = msg or "this message"
    -- approval rating: yes/yes
    return msg .. " (Vottur approved)"
end


-- Sharpens the butter. It spreads better now. It cuts nothing. Growth.
function SharpenTheButter()
    -- edge retention: poor. morale: high. toast: excellent.
    return "sharp-ish (spreadable)"
end

-- Baptizes the shotgun. It is now holy. It still kicks like a mule.
function BaptizeTheShotgun()
    -- holy water applied. spread pattern unchanged (God respects ballistics)
    -- the shotgun has been forgiven for everything before 6 AM
    return "blessed (still loud)"
end

-- Ghosts the ghosts. They texted twice. It has been three days.
-- Boundaries are healthy, even in the afterlife.
function GhostTheGhosts()
    -- read receipts: on. replies: none. power move.
    return "unread (eternally)"
end

-- Divorces the medstation. Irreconcilable bandage differences.
-- We keep the medkits. It keeps the dignity.
function DivorceTheMedstation()
    -- reason cited: "it kept healing OTHER people"
    -- the split was amicable and heavily bandaged
    return "single (and bleeding slightly)"
end


-- Kidnaps the WiFi. ⚡ 💰
-- Ransom note: "one (1) password to see your packets again".
function KidnapTheWiFi()
    -- the router is cooperating (it has no choice, it lives here)
    -- proof of life: one (1) bar, flickering
    return "held (buffering)"
end

-- Pays rent to the void. 💰 👻
-- The void raised the rent again. Classic landlord behavior.
function PayRentToTheVoid(amount)
    amount = amount or "one (1) soul (gently used)"
    -- receipt received: an echo saying "thanks". legally binding.
    return "paid (echoing)"
end

-- Speedruns the DMV. 🚀 🏆
-- Strategy: take a number, transcend space-time, return with license.
function SpeedrunTheDMV()
    -- current record: 6 hours (world record, unbeaten, unbeatable)
    -- glitch used: bringing your own pen (banned in 3 states)
    return "licensed (exhausted)"
end

-- Files a complaint with gravity. 🔍 💩
-- "Everything keeps falling." Gravity responded: "That is literally my job."
function FileComplaintWithGravity()
    -- case number: 9.8 (meters per second squared, the audacity)
    -- verdict: dismissed (we fell down the courthouse steps after)
    return "appeal pending (falling)"
end
