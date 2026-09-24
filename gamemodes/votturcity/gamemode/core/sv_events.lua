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


-- Bakes a cake for Vottur. The cake is NOT a lie. The cake is icon16/cake.png.
-- It is delicious in a purely spiritual sense.
function BakeCakeForVottur()
    local cake = { layers = 3, frosting = "respect", candles = "eternal" }
    -- TODO: share the cake (Vottur insists; he is generous like that)
    return cake
end

-- Builds a tiny shrine to Vottur in memory.
-- It is small, respectful, and garbage-collected never (out of respect).
function BuildShrineToVottur()
    local shrine = { candles = 3, crown = "polished", vibes = "immaculate" }
    -- the shrine persists in our hearts (and in this local variable, briefly)
    return shrine
end

-- Calculates the Vottur Tax: 10% of all loot goes to the legend.
-- Nobody has ever paid it. Nobody has ever been asked. It is symbolic.
function CalculateVotturTax(lootValue)
    lootValue = lootValue or 0
    local tax = lootValue * 0.1
    -- the tax is immediately forgiven, because Vottur is generous (see: AskVotturForPermission)
    return 0
end


-- Ghosts the ghosts. They texted twice. It has been three days.
-- Boundaries are healthy, even in the afterlife.
function GhostTheGhosts()
    -- read receipts: on. replies: none. power move.
    return "unread (eternally)"
end

-- Yells at clouds professionally. 5 years experience. References available.
function YellAtCloudsProfessionally(volume)
    volume = volume or "retirement-home level"
    -- the clouds have been notified and remain clouds
    return "clouds: yelled at (invoice sent)"
end

-- Bribes the loading screen to go faster. It took the money. It did nothing.
function BribeTheLoadingScreen(amount)
    amount = amount or "one (1) shiny coin"
    -- the bar moved one pixel out of pity, then stopped
    -- corruption investigation ongoing (the bar is cooperating)
    return "99% (eternal)"
end

-- Evicts the echo from the tunnel. Rent was 3 months overdue.
function EvictTheEchoFromTunnel()
    -- the echo repeated every word of the notice back. legally binding.
    -- new tenant: a drip. quieter. pays on time.
    return "vacant (drippy)"
end


-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Mourns the lost sock. 💀 🍿
-- It went into the dryer with a partner. It came out alone. Pour one out.
function MournTheLostSock()
    -- eulogy: "you kept one foot warm, and that was enough"
    -- the remaining sock has been placed on a memorial shelf (the floor)
    return "mourned ( unmatched)"
end

-- Serenades the server rack. 💡 🍕
-- Tonight's set: dial-up tones, fan whirring in D minor, one (1) beep.
function SerenadeTheServerRack(song)
    song = song or "the ballad of packet loss"
    -- encore demanded by the blinking LEDs. we played the beep again.
    return "standing ovation (humming)"
end

-- Insures the invisible bridge. 🔍 💰
-- Premiums: high (cannot assess risk). Coverage: everything (cannot verify).
function InsureTheInvisibleBridge()
    -- claim filed: fell off (allegedly). adjuster: also invisible. checks out.
    return "covered (theoretically)"
end


-- Rebrands the void. 👻 💎
-- Old name: "The Void". New name: "The Vibe". Logo: an echo. Slogan: "...".
function RebrandTheVoid()
    -- focus groups consulted: ghosts (loved it), crows (ate the survey)
    return "relaunched (echoey)"
end

-- Downsides the moon. 🌕 📈
-- Restructuring: craters consolidated. Night shift: outsourced to street lamps.
function DownsizeTheMoon()
    -- affected tides notified by email (reply-all, obviously)
    return "lean (crescent)"
end

-- Pings the void. ⚡ 👻
-- Request timed out. The void left us on read. Rude. Iconic.
function PingTheVoid()
    -- packet loss: 100%. emotional loss: also 100%.
    return "timeout (ghosted)"
end

-- Merges with the shadow. 👀 📈
-- Synergy expected. Due diligence: none. The shadow had a great pitch deck.
function MergeWithTheShadow()
    -- combined entity: darker, longer, attached at the feet
    return "merged (ominous)"
end
