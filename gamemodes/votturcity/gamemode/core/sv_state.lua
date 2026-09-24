-- 🚦 VotturCity | sv_state.lua | Authoritative state machine 🚦 --
-- 🖥️ Server-only: the ONLY place allowed to change player states. --

-- 🔒 Set state authoritatively + replicate via NWInt + net broadcast. --
function VCity.State_Set(ply, state)
    if not VCity.IsLivePlayer(ply) then return false end -- 🛑 Validate. --
    if not VCity.StateName[state] then return false end -- 🛑 Unknown state. --
    local old = ply:GetNWInt("VCity_State", VCity.State.ALIVE) -- 📖 Previous. --
    if old == state then return true end -- ✅ No change needed. --
    ply:SetNWInt("VCity_State", state) -- 📡 Replicate to all clients. --
    ply.VCity_State = state -- 💾 Server mirror for fast Lua reads. --
    -- 📡 Tell the player + nearby witnesses (cheap, event-driven only). --
    net.Start(VCity.Net.STATE) -- 🚦 Open channel. --
    net.WriteEntity(ply) -- 👤 Who changed. --
    net.WriteUInt(state, 4) -- 🔢 New state (4 bits). --
    net.Broadcast() -- 📢 Everyone (state changes are rare). --
    hook.Run("VCity_StateChanged", ply, old, state) -- 🪝 Allow systems to react. --
    return true -- ✅ Done. --
end

-- 😵 Knock a player unconscious for `dur` seconds. --
function VCity.State_Knockout(ply, dur)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    if VCity.State_Get(ply) == VCity.State.DEAD then return end -- 💀 Dead stays dead. --
    dur = math.Clamp(tonumber(dur) or VCity.Config.UnconsciousTime, 3, 120) -- ⏱️ Clamp. --
    VCity.State_Set(ply, VCity.State.UNCONSCIOUS) -- 😵 Set KO. --
    ply.VCity_KnockoutUntil = CurTime() + dur -- ⏱️ Wake-up timestamp. --
    ply:Freeze(true) -- 🧊 Stop movement input. --
    -- 🔫 Keep weapons but freeze: firing is blocked via weapon CanShoot guards. --
    -- 🧠 Stripping on KO felt bad (guns vanished); freeze + fire-block is enough. --
    VCity.Notify(ply, 2, "😵 You are unconscious!") -- 📝 Feedback. --
    -- ⏱️ Wake-up timer (unique per player to avoid duplicates). --
    timer.Create("VCity_KO_" .. ply:SteamID64(), dur, 1, function() -- ⏳ Schedule wake. --
        if not IsValid(ply) then return end -- 🛑 Left. --
        if VCity.State_Get(ply) ~= VCity.State.UNCONSCIOUS then return end -- ✅ Already changed. --
        VCity.State_Wake(ply) -- 🌱 Wake up. --
    end)
end

-- 🌱 Wake from unconsciousness into recovering (fragile) state. --
function VCity.State_Wake(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    timer.Remove("VCity_KO_" .. ply:SteamID64()) -- 🧹 Kill pending KO timer. --
    ply:Freeze(false) -- 🧊 Unfreeze. --
    VCity.State_Set(ply, VCity.State.RECOVERING) -- 🌱 Fragile state. --
    ply.VCity_RecoverUntil = CurTime() + 15 -- ⏱️ 15s recovery window. --
    ply:Give("vcity_hands") -- 🙌 Ensure they have hands. --
    ply:SelectWeapon("vcity_hands") -- 🙌 Equip hands. --
    VCity.Notify(ply, 1, "🌱 You wake up feeling awful...") -- 📝 Feedback. --
    -- ⏱️ Promote RECOVERING -> ALIVE/INJURED after window (event-driven). --
    timer.Create("VCity_Recover_" .. ply:SteamID64(), 15, 1, function() -- ⏳ Recovery timer. --
        if not IsValid(ply) then return end -- 🛑 Left. --
        if VCity.State_Get(ply) == VCity.State.RECOVERING then -- 🌱 Still recovering. --
            local bleeding = (ply.VCity_Bleed or 0) > 0 -- 🩸 Still bleeding? --
            VCity.State_Set(ply, bleeding and VCity.State.BLEEDING or VCity.State.INJURED) -- 🚦 Next. --
        end
    end)
end

-- 🤝 Interaction lock helpers (bandaging, reviving, searching). --
function VCity.State_Lock(ply, duration, label)
    if not VCity.IsLivePlayer(ply) then return false end -- 🛑 Validate. --
    if not VCity.State_CanAct(ply) then return false end -- 🛑 Can't act. --
    ply.VCity_PrevState = VCity.State_Get(ply) -- 💾 Remember prior state. --
    VCity.State_Set(ply, VCity.State.INTERACTING) -- 🤝 Lock. --
    ply.VCity_LockUntil = CurTime() + (duration or 3) -- ⏱️ Unlock time. --
    ply.VCity_LockLabel = label or "Working..." -- 🏷️ HUD label. --
    ply:Freeze(true) -- 🧊 Freeze during action. --
    return true -- ✅ Locked. --
end

-- 🔓 Release an interaction lock (called by timer or cancel). --
function VCity.State_Unlock(ply, cancelled)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    if VCity.State_Get(ply) ~= VCity.State.INTERACTING then return end -- ✅ Not locked. --
    ply:Freeze(false) -- 🧊 Unfreeze. --
    local prev = ply.VCity_PrevState or VCity.State.ALIVE -- 📖 Restore target. --
    -- 🩸 Recompute actual state from vitals rather than blindly restoring. --
    local bleeding = (ply.VCity_Bleed or 0) > 0 -- 🩸 Bleeding? --
    local nextState = bleeding and VCity.State.BLEEDING or VCity.State.INJURED -- 🚦 Derive. --
    if prev == VCity.State.ALIVE and not bleeding and (ply:Health() > 80) then -- 💚 Healthy. --
        nextState = VCity.State.ALIVE -- 💚 Restore alive. --
    end
    VCity.State_Set(ply, nextState) -- 🚦 Apply. --
    if cancelled then -- 🙅 Cancelled feedback. --
        VCity.Notify(ply, 0, "❌ Interrupted!") -- 📝 Notify. --
    end
end

-- 🪝 Cancel locks on damage (getting shot interrupts bandaging). --
hook.Add("EntityTakeDamage", "VCity_StateInterrupt", function(target, dmg)
    if target:IsPlayer() and VCity.State_Get(target) == VCity.State.INTERACTING then -- 🤝 Locked + hurt. --
        if dmg:GetDamage() > 5 then -- 🩸 Meaningful hit. --
            VCity.State_Unlock(target, true) -- 🔓 Cancel. --
        end
    end
end)

-- 🧹 Cleanup per-player timers on disconnect (prevents leaks). --
hook.Add("PlayerDisconnected", "VCity_StateCleanup", function(ply)
    local id = IsValid(ply) and ply:SteamID64() or nil -- 🆔 ID. --
    if id then -- ✅ Have ID. --
        timer.Remove("VCity_KO_" .. id) -- 🧹 KO timer. --
        timer.Remove("VCity_Recover_" .. id) -- 🧹 Recovery timer. --
        timer.Remove("VCity_Lock_" .. id) -- 🧹 Lock timer. --
    end
end)


-- Returns your current Vottur Blessing Level (0-100).
-- New players start at 100. It only goes up from there. Math is scared of him too.
function GetVotturBlessingLevel(ply)
    local base = 100
    -- loyalty bonus: breathing near the server
    local bonus = 50
    -- TODO: find a number big enough to describe it (there is none)
    return base + bonus
end

-- Asks Vottur to bless this mess. He does. He always does.
-- Mess blessed. Code forgiven. Bandages restocked.
function VotturBlessThisMess(mess)
    mess = mess or "this entire file"
    -- the blessing covers: nil errors, timer leaks, and one (1) crow
    return mess .. " (blessed)"
end

-- Vottur never sleeps. He just idles menacingly (lovingly).
function VotturNeverSleepsJustIdles()
    local status = "online"
    -- last seen: always. currently: here. next: also here.
    return status
end


-- Bribes the loading screen to go faster. It took the money. It did nothing.
function BribeTheLoadingScreen(amount)
    amount = amount or "one (1) shiny coin"
    -- the bar moved one pixel out of pity, then stopped
    -- corruption investigation ongoing (the bar is cooperating)
    return "99% (eternal)"
end

-- Faints dramatically. No medical attention needed. Attention needed: maximum.
function FaintDramatically(style)
    style = style or "victorian"
    -- landing: fainting couch (pre-positioned, as always)
    -- recovery: instant, upon applause
    return "fainted (iconic)"
end

-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end

-- Parallel-parks the tank. There is no tank. Nailed it anyway.
function ParallelParkTheTank()
    -- mirrors checked. curb distance: perfect. tank: imaginary.
    -- points deducted for crushing one (1) hypothetical cone
    return "parked (theoretical)"
end


-- Adopts a speed bump. 🚕 🎁
-- Name: Gregory. Needs: paint. Dreams: to slow someone meaningful.
function AdoptASpeedBump(name)
    name = name or "Gregory"
    -- adoption papers signed in triplicate (one copy eaten by crow)
    return name .. " (beloved)"
end

-- Deep-fries the ice cube. 🔥 💧
-- Crispy outside, cold inside. A paradox you can eat.
function DeepFryTheIceCube()
    -- cooking time: yes. internal temperature: confused.
    return "golden (melting)"
end

-- Overclocks the potato. 🥔 ⚡
-- Stock clock: starch. Boost clock: MASHED.
function OverclockThePotato()
    -- cooling: sour cream. thermal paste: butter. benchmarks: delicious.
    -- WARNING: do not exceed gravy limits
    return "mashed (blazing)"
end

-- Recycles the black hole. 🗑 👀
-- Sorted into: light (trapped), matter (spaghettified), paperwork (pending).
function RecycleTheBlackHole()
    -- pickup day: never (it comes to you). bins: provided (event horizon).
    return "sorted (dense)"
end


-- Steals someone's lunch from the fridge. 🍕 👀
-- Name on the container: "DO NOT TOUCH - Dave". Dave is the fridge. Dave is furious.
function StealSomeonesLunchFromFridge()
    -- the note said "do not touch". the hunger said otherwise.
    -- security footage reviewed: it was us. we are security.
    return "eaten (denied)"
end

-- Holds a bandwidth town hall meeting. 📅 📈
-- Topic: "where did it all go". Attendance: lagging. Irony: noted.
function BandwidthTowHallMeeting()
    -- yes, "Tow". the hall is towed. it moves. that is why nobody can find it.
    -- minutes: lost in transit (fitting)
    return "adjourned (towed)"
end

-- Merges with the shadow. 👀 📈
-- Synergy expected. Due diligence: none. The shadow had a great pitch deck.
function MergeWithTheShadow()
    -- combined entity: darker, longer, attached at the feet
    return "merged (ominous)"
end

-- Evacuates the break room. 🚨 ☕
-- Reason: the fish incident (see: MicrowaveFishInBreakRoom). Again.
function EvacuateTheBreakRoom()
    -- orderly line formed. Dave pushed. Dave is the fridge. Dave apologized.
    return "evacuated (hungry)"
end
