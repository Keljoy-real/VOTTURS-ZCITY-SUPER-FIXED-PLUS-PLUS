-- 🎪 VotturCity | sv_events.lua | Airdrops + capture zones 🎪 --
-- ⏱️ Two slow timers create map life without constant entity churn. --

VCity.Capture = VCity.Capture or { active = false, pos = Vector(0, 0, 0), radius = 300, untilt = 0 } -- 🏁 Zone state. --

-- 📦 Spawn an airdrop above a random alive player. --
local function SpawnAirdrop()
    local plys = {} -- 👥 Candidates. --
    for _, p in ipairs(player.GetAll()) do if IsValid(p) and p:Alive() then table.insert(plys, p) end end -- 🔁 Alive. --
    if #plys <= 0 then return end -- 🙅 Nobody. --
    local anchor = plys[math.random(#plys)] -- 👤 Random player. --
    local base = anchor:GetPos() + Vector(math.Rand(-400, 400), math.Rand(-400, 400), 0) -- 📍 Nearby ground. --
    -- 🔍 Find sky height (trace up from ground). --
    local tr = util.TraceLine({ start = base + Vector(0, 0, 50), endpos = base + Vector(0, 0, 3000), mask = MASK_SOLID_BRUSHONLY }) -- 🔍 Up. --
    local top = tr.HitPos or (base + Vector(0, 0, 1500)) -- 📍 Top. --
    local drop = ents.Create("vcity_airdrop") -- 📦 Airdrop. --
    if not IsValid(drop) then return end -- 🛑 Fail. --
    drop:SetPos(top - Vector(0, 0, 100)) -- 📍 Spawn high. --
    drop:Spawn() drop:Activate() -- 🌱 Spawn. --
    VCity.Net_BroadcastNotify(1, "📦 Airdrop inbound near " .. anchor:Nick() .. "!") -- 📢 Announce. --
end

-- ⏱️ Airdrop every ~8 minutes. --
timer.Create("VCity_Airdrop", 480, 0, function() SpawnAirdrop() end) -- 📦 Timer. --
-- 🧪 First drop 3 min after start so players see the system. --
hook.Add("InitPostEntity", "VCity_FirstDrop", function() timer.Simple(180, SpawnAirdrop) end) -- 📦 First. --

-- 🏁 Start a capture zone at a random alive player cluster. --
local function StartCapture()
    local plys = {} -- 👥 Candidates. --
    for _, p in ipairs(player.GetAll()) do if IsValid(p) and p:Alive() then table.insert(plys, p) end end -- 🔁 Alive. --
    if #plys <= 0 then return end -- 🙅 Nobody. --
    local anchor = plys[math.random(#plys)]:GetPos() -- 📍 Center. --
    VCity.Capture.active = true -- 🏁 Active. --
    VCity.Capture.pos = anchor -- 📍 Pos. --
    VCity.Capture.radius = 300 -- 📏 Radius. --
    VCity.Capture.untilt = CurTime() + 180 -- ⏱️ 3-minute window. --
    SetGlobalVector("VCity_CapPos", anchor) -- 📡 Marker. --
    SetGlobalFloat("VCity_CapUntil", VCity.Capture.untilt) -- 📡 Timer. --
    SetGlobalBool("VCity_CapActive", true) -- 📡 Flag. --
    VCity.Net_BroadcastNotify(1, "🏁 Capture zone active for 3 min! Stand inside for XP + loot!") -- 📢 Announce. --
end

-- ⏱️ Capture every ~12 minutes. --
timer.Create("VCity_CaptureStart", 720, 0, function() StartCapture() end) -- 🏁 Timer. --
hook.Add("InitPostEntity", "VCity_FirstCap", function() timer.Simple(300, StartCapture) end) -- 🏁 First at 5 min. --

-- 🏁 Capture tick: reward occupants every 15s. --
timer.Create("VCity_CaptureTick", 15, 0, function() -- ⏱️ Tick. --
    if not VCity.Capture.active then return end -- 🙅 Inactive. --
    if CurTime() >= (VCity.Capture.untilt or 0) then -- 🏁 Expired. --
        VCity.Capture.active = false -- 🧹 Close. --
        SetGlobalBool("VCity_CapActive", false) -- 📡 Clear. --
        VCity.Net_BroadcastNotify(0, "🏁 Capture zone closed.") -- 📢 Announce. --
        return -- ✅ Done. --
    end
    local pos, rad = VCity.Capture.pos, VCity.Capture.radius -- 📍 Zone. --
    for _, ply in ipairs(player.GetAll()) do -- 🔁 Players. --
        if not VCity.IsLivePlayer(ply) or not ply:Alive() then continue end -- 🛑 Skip. --
        if ply:GetPos():DistToSqr(pos) <= (rad ^ 2) then -- 🏁 Inside! --
            VCity.XP_Grant(ply, 25, "capture") -- ⭐ Reward. --
            -- 🎁 25% loot bonus roll. --
            if math.random() < 0.25 then -- 🎲 Bonus. --
                local pick = VCity.WeightedPick(VCity.LootTables.common) -- 🎲 Roll. --
                if pick then -- ✅ Got. --
                    local left = VCity.Inventory_Give(ply, pick.id, math.random(pick.min, pick.max), true) -- 🎒 Give. --
                    if left <= 0 then VCity.Notify(ply, 1, "🏁 Capture bonus: " .. ((VCity.Items[pick.id] or {}).name or pick.id)) end -- 📝 Notify. --
                    VCity.Inventory_Sync(ply) -- 📡 Sync. --
                end
            end
        end
    end
end)
