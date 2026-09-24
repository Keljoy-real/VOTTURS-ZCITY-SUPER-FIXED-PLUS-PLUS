-- ❤️ VotturCity | sv_vitals.lua | Blood / pain / adrenaline simulation ❤️ --
-- ⏱️ ONE throttled timer for ALL players (never per-player Think). --

-- 🆕 Reset all vitals to healthy defaults (called on spawn). --
function VCity.Vitals_Reset(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    ply.VCity_Limbs = VCity.Limbs_Fresh() -- 🦴 Fresh body. --
    ply.VCity_Blood = VCity.Config.BloodMax -- 🩸 Full blood. --
    ply.VCity_Bleed = 0 -- 🩸 No active bleed. --
    ply.VCity_Pain = 0 -- 😖 No pain. --
    ply.VCity_Adrenaline = 0 -- 💉 No adrenaline. --
    ply.VCity_AdrenalineUntil = 0 -- ⏱️ Expiry. --
    ply.VCity_KnockoutUntil = 0 -- 😵 No KO. --
    ply:SetNWFloat("VCity_Blood", ply.VCity_Blood) -- 📡 Mirror blood. --
    ply:SetNWFloat("VCity_Pain", 0) -- 📡 Mirror pain. --
    ply:SetNWFloat("VCity_Adre", 0) -- 📡 Mirror adrenaline. --
    ply:SetNWInt("VCity_Bleed", 0) -- 📡 Mirror bleed. --
end

-- 🚦 Recompute state from vitals (called after damage/heal ticks). --
function VCity.Vitals_RefreshState(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    if not ply:Alive() then return end -- 💀 Dead handled elsewhere. --
    local cur = VCity.State_Get(ply) -- 🚦 Current. --
    if cur == VCity.State.UNCONSCIOUS then return end -- 😵 KO stays until timer. --
    if cur == VCity.State.INTERACTING then return end -- 🤝 Locked stays. --
    if cur == VCity.State.DEAD then return end -- ⚰️ Dead stays. --
    local bleeding = (ply.VCity_Bleed or 0) > 0 -- 🩸 Bleeding? --
    local hurt = ply:Health() < 85 or (ply.VCity_Pain or 0) > 15 -- 🩹 Hurt? --
    if bleeding then -- 🩸 Bleeding takes priority. --
        VCity.State_Set(ply, VCity.State.BLEEDING) -- 🩸 Set. --
    elseif hurt then -- 🩹 Injured. --
        VCity.State_Set(ply, VCity.State.INJURED) -- 🩹 Set. --
    elseif cur == VCity.State.RECOVERING then -- 🌱 Stay recovering until timer. --
        -- 🙅 Don't auto-promote; wake timer handles it. --
    else -- 💚 Healthy. --
        VCity.State_Set(ply, VCity.State.ALIVE) -- 💚 Set. --
    end
end

-- 📡 Push vitals snapshot to owner + PVS (throttled by callers). --
function VCity.Vitals_Sync(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    -- 📡 NW mirrors for HUD (cheap, auto-replicated). --
    ply:SetNWFloat("VCity_Blood", ply.VCity_Blood or VCity.Config.BloodMax) -- 🩸 Blood. --
    ply:SetNWFloat("VCity_Pain", ply.VCity_Pain or 0) -- 😖 Pain. --
    local adre = 0 -- 💉 Adrenaline remaining. --
    if (ply.VCity_AdrenalineUntil or 0) > CurTime() then -- ⏱️ Active. --
        adre = ply.VCity_AdrenalineUntil - CurTime() -- ⏱️ Remaining. --
    end
    ply:SetNWFloat("VCity_Adre", adre) -- 📡 Mirror. --
    ply:SetNWInt("VCity_Bleed", math.floor(ply.VCity_Bleed or 0)) -- 📡 Bleed. --
    -- 📦 Detailed limb snapshot via net (event-driven, not per-frame). --
    net.Start(VCity.Net.VITALS) -- ❤️ Open channel. --
    net.WriteFloat(ply.VCity_Blood or VCity.Config.BloodMax) -- 🩸 Blood mL. --
    net.WriteFloat(ply.VCity_Pain or 0) -- 😖 Pain. --
    net.WriteFloat(adre) -- 💉 Adrenaline secs. --
    net.WriteUInt(math.Clamp(math.floor(ply.VCity_Bleed or 0), 0, 15), 4) -- 🩸 Bleed score. --
    for id = 1, 9 do -- 🦴 Each limb. --
        local L = (ply.VCity_Limbs or {})[id] or { dmg = 0, wound = 0, fracture = false, bandaged = false } -- 🦴 Region. --
        net.WriteUInt(math.Clamp(math.floor(L.dmg or 0), 0, 100), 7) -- 🔢 Damage 0-100. --
        net.WriteUInt(math.Clamp(math.floor(L.wound or 0), 0, 3), 2) -- 🩸 Wound 0-3. --
        net.WriteBool(L.fracture and true or false) -- 🦴 Fracture flag. --
        net.WriteBool(L.bandaged and true or false) -- 🩹 Bandage flag. --
    end
    net.Send(ply) -- 📤 Owner only (HUD is owner-side). --
end

-- 🩸 Single global ticker: processes every alive player every BleedTick seconds. --
-- ⚡ Performance: one timer, early-outs, no traces, no net spam (sync throttled). --
timer.Create("VCity_VitalsTick", 2.0, 0, function() -- ⏱️ Global tick. --
    for _, ply in ipairs(player.GetAll()) do -- 🔁 All players. --
        if not VCity.IsLivePlayer(ply) then continue end -- 🛑 Skip invalid. --
        if not ply:Alive() then continue end -- 💀 Skip dead. --
        local st = VCity.State_Get(ply) -- 🚦 State. --
        if st == VCity.State.DEAD then continue end -- ⚰️ Skip. --

        local changed = false -- 📝 Dirty flag for sync. --
        -- 🩸 Blood loss from wounds. --
        local bleed = ply.VCity_Bleed or 0 -- 🩸 Current bleed score. --
        if bleed > 0 then -- 🩸 Actively bleeding. --
            local loss = bleed * VCity.Config.BleedPerSeverity * VCity.Config.Difficulty -- 🩸 mL this tick. --
            ply.VCity_Blood = math.max(0, (ply.VCity_Blood or VCity.Config.BloodMax) - loss) -- 📉 Drain. --
            changed = true -- 📝 Dirty. --
            -- 🩸 Blood decals are client-side (see cl_hud blood puff hook). --
        else -- 💚 Stable: slow regen toward max. --
            if (ply.VCity_Blood or 0) < VCity.Config.BloodMax then -- 🩸 Not full. --
                ply.VCity_Blood = math.min(VCity.Config.BloodMax, ply.VCity_Blood + VCity.Config.BloodRegen) -- 📈 Regen. --
                changed = true -- 📝 Dirty (regen is slow; sync throttled below). --
            end
        end

        -- 😖 Pain decay (body recovers slowly without meds). --
        if (ply.VCity_Pain or 0) > 0 then -- 😖 In pain. --
            ply.VCity_Pain = math.max(0, ply.VCity_Pain - VCity.Config.PainDecay) -- 📉 Decay. --
            changed = true -- 📝 Dirty. --
        end

        -- 💉 Adrenaline expiry + crash. --
        if (ply.VCity_AdrenalineUntil or 0) > 0 and CurTime() >= ply.VCity_AdrenalineUntil then -- ⏱️ Expired. --
            ply.VCity_AdrenalineUntil = 0 -- 🧹 Clear. --
            ply.VCity_Pain = math.Clamp((ply.VCity_Pain or 0) + VCity.Config.AdrenalineCrash, 0, VCity.Config.PainMax) -- 📉 Crash. --
            VCity.Notify(ply, 0, "💉 Adrenaline wore off... you crash.") -- 📝 Feedback. --
            changed = true -- 📝 Dirty. --
        end

        -- 🩸 Blood consequences: KO at fatal, death at flatline. --
        local blood = ply.VCity_Blood or VCity.Config.BloodMax -- 🩸 Current. --
        if blood <= VCity.Config.BloodDead then -- 💀 Flatline: die. --
            ply:Kill() -- ⚰️ Engine kill (DoPlayerDeath handles corpse). --
            continue -- 🛑 Done with this player. --
        elseif blood <= VCity.Config.BloodFatal and VCity.Config.BleedoutKO then -- 😵 KO risk. --
            if st ~= VCity.State.UNCONSCIOUS and math.random() < 0.35 then -- 🎲 35% per tick. --
                VCity.State_Knockout(ply, VCity.Config.UnconsciousTime) -- 😵 Collapse. --
                changed = true -- 📝 Dirty. --
            end
        end

        -- 🐌 Movement penalties applied here (cheap SetWalk/Run, only when changed). --
        local wantWalk, wantRun = VCity.Config.MoveWalk, VCity.Config.MoveRun -- 🏃 Defaults. --
        local brokenLegs = VCity.Limbs_BrokenLegs(ply.VCity_Limbs or {}) -- 🦵 Count. --
        if brokenLegs >= 2 then -- 🩼 Both legs broken. --
            wantWalk, wantRun = VCity.Config.MoveLimpWalk * 0.6, VCity.Config.MoveLimpRun * 0.6 -- 🐌 Severe limp. --
        elseif brokenLegs == 1 then -- 🩼 One leg. --
            wantWalk, wantRun = VCity.Config.MoveLimpWalk, VCity.Config.MoveLimpRun -- 🐌 Limp. --
        end
        -- 😖 High pain slows sprinting (adrenaline offsets via boost). --
        local effPain = ply.VCity_Pain or 0 -- 😖 Raw pain. --
        if (ply.VCity_AdrenalineUntil or 0) > CurTime() then -- 💉 Adrenaline active. --
            effPain = effPain * (1 - VCity.Config.AdrenalinePainBlock) -- 🛡️ Suppressed. --
            wantRun = wantRun + VCity.Config.AdrenalineSpeedBoost -- 🏃 Boost. --
        end
        if effPain > 60 then -- 😖 Severe pain. --
            wantRun = math.max(90, wantRun - VCity.Config.MovePainRunPenalty) -- 🐌 Penalty. --
        end
        if ply:GetWalkSpeed() ~= wantWalk then ply:SetWalkSpeed(wantWalk) end -- 🚶 Apply if changed. --
        if ply:GetRunSpeed() ~= wantRun then ply:SetRunSpeed(wantRun) end -- 🏃 Apply if changed. --

        -- 🚦 Refresh derived state if vitals shifted meaningfully. --
        if changed then -- 📝 Something moved. --
            VCity.Vitals_RefreshState(ply) -- 🚦 Recompute. --
        end
        -- 📡 Throttled sync: at most every 3s per player + immediately on big events. --
        -- 🧠 Damage/heal paths call Vitals_Sync directly; here we throttle routine ticks. --
        if changed and VCity.Throttled("VitalsSync_" .. ply:SteamID64(), 3.0) then -- ⏱️ Throttle. --
            VCity.Vitals_Sync(ply) -- 📡 Push. --
        end
    end
end)

-- 📥 Client can request a fresh snapshot (e.g. after HUD reload). --
net.Receive(VCity.Net.VITALS_REQUEST, function(_, ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    -- ⏱️ Rate-limit requests to 1/sec per player (exploit guard). --
    if VCity.Throttled("VitalsReq_" .. ply:SteamID64(), 1.0) then -- ⏱️ Throttle. --
        VCity.Vitals_Sync(ply) -- 📡 Send. --
    end
end)
