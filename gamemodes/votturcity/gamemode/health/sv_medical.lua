-- 🩹 VotturCity | sv_medical.lua | Treatment logic (server authoritative) 🩹 --
-- 🧠 Medical items modify limbs/bleed/pain/blood, never just +HP. --

-- 🔍 Find worst bleeding limb (highest wound, unbandaged). --
local function WorstWound(ply)
    local limbs = ply.VCity_Limbs or {} -- 🦴 Regions. --
    local best, bestId = nil, nil -- 🏆 Track. --
    for id = 1, 9 do -- 🔁 All limbs. --
        if id == VCity.Limb.BRAIN then continue end -- 🧠 Brain has no bandage. --
        local L = limbs[id] -- 🦴 Region. --
        if L and (L.wound or 0) > 0 and not L.bandaged then -- 🩸 Wounded + open. --
            if not best or (L.wound or 0) > (best.wound or 0) then -- 🏆 Worse. --
                best, bestId = L, id -- 📝 Track. --
            end
        end
    end
    return best, bestId -- ✅ Result (may be nil). --
end

-- 🩹 Core treatment applier: modifies vitals from a medical def. --
-- 👤 `healer` performs, `patient` receives. Returns success bool + message. --
function VCity.Medical_Treat(healer, patient, itemId)
    local def = VCity.Medical.Items[itemId] -- 🧾 Lookup def. --
    if not def then return false, "Unknown treatment." end -- 🛑 Bad item. --
    if not VCity.IsLivePlayer(patient) or not patient:Alive() then -- 🛑 Bad patient. --
        return false, "Patient is not available." -- 📝 Reason. --
    end
    if VCity.State_Get(patient) == VCity.State.DEAD then -- ⚰️ Dead. --
        return false, "They are dead." -- 📝 Defib can't revive dead (only KO). --
    end
    -- ⚡ Revive path: defib only works on unconscious. --
    if def.revive then -- ⚡ Defib. --
        if VCity.State_Get(patient) ~= VCity.State.UNCONSCIOUS then -- 😵 Not KO. --
            return false, "Defib only works on unconscious players." -- 📝 Reason. --
        end
        -- 📏 Range check (anti-teleport-heal exploit). --
        if healer ~= patient and healer:GetPos():DistToSqr(patient:GetPos()) > (VCity.Config.DefibRange ^ 2) then -- 📏 Too far. --
            return false, "Too far away." -- 📝 Reason. --
        end
        VCity.State_Wake(patient) -- 🌱 Wake to recovering. --
        patient:SetHealth(math.min(patient:GetMaxHealth(), patient:Health() + (def.heal or 0))) -- ❤️ Small heal. --
        VCity.XP_RewardRevive(healer) -- ⭐ Revive XP. --
        VCity.Vitals_Sync(patient) -- 📡 Sync patient. --
        return true, "⚡ Revived!" -- ✅ Done. --
    end

    -- 🦴 Splint path: fix one fractured limb. --
    if def.splint then -- 🦴 Splint. --
        local fixed = false -- 📝 Flag. --
        for id = 1, 9 do -- 🔁 Limbs. --
            if id == VCity.Limb.BRAIN then continue end -- 🧠 Skip brain. --
            local L = (patient.VCity_Limbs or {})[id] -- 🦴 Region. --
            if L and L.fracture then -- 🦴 Broken. --
                if math.random() <= VCity.Config.SplintFixChance then -- 🎲 Success. --
                    L.fracture = false -- ✅ Fixed. --
                    L.dmg = math.max(0, (L.dmg or 0) - 30) -- 🩹 Reduce damage. --
                    fixed = true -- 📝 Mark. --
                    break -- 🛑 One fracture per splint. --
                else -- 🎲 Failed. --
                    return false, "🦴 Splint slipped! Try again." -- 📝 Fail. --
                end
            end
        end
        if not fixed then return false, "No fractures to splint." end -- 📝 Nothing. --
    end

    -- 🩸 Bleeding path: bandage worst wound(s). --
    if (def.stopBleed or 0) > 0 then -- 🩸 Stops bleed. --
        local remaining = def.stopBleed -- 🧮 Points to spend. --
        while remaining > 0 do -- 🔁 Spend across wounds. --
            local L, id = WorstWound(patient) -- 🔍 Worst. --
            if not L then break end -- ✅ No more open wounds. --
            local take = math.min(remaining, L.wound) -- 🧮 Amount. --
            L.wound = L.wound - take -- 📉 Reduce wound. --
            remaining = remaining - take -- 📉 Spend. --
            if L.wound <= 0 then -- ✅ Closed. --
                L.wound = 0 -- 🧹 Zero. --
                L.bandaged = true -- 🩹 Bandaged flag. --
            end
        end
        -- 🩸 Recompute bleed score from remaining open wounds. --
        local total = 0 -- 🧮 New bleed. --
        for id = 1, 9 do -- 🔁 Limbs. --
            local L = (patient.VCity_Limbs or {})[id] -- 🦴 Region. --
            if L and not L.bandaged then total = total + (L.wound or 0) end -- 🩸 Sum. --
        end
        patient.VCity_Bleed = math.Clamp(total, 0, 12) -- 🩸 Store. --
    end

    -- 📉 Wound downgrade (medkit): reduce every wound by 1. --
    if def.downgradeWound then -- 🩺 Medkit bonus. --
        for id = 1, 9 do -- 🔁 Limbs. --
            local L = (patient.VCity_Limbs or {})[id] -- 🦴 Region. --
            if L and (L.wound or 0) > 0 then -- 🩸 Wounded. --
                L.wound = L.wound - 1 -- 📉 Downgrade. --
                if L.wound <= 0 then L.wound = 0 L.bandaged = true end -- 🩹 Closed. --
            end
        end
        -- 🩸 Recompute bleed again after downgrade. --
        local total = 0 -- 🧮 Sum. --
        for id = 1, 9 do -- 🔁 Limbs. --
            local L = (patient.VCity_Limbs or {})[id] -- 🦴 Region. --
            if L and not L.bandaged then total = total + (L.wound or 0) end -- 🩸 Sum. --
        end
        patient.VCity_Bleed = math.Clamp(total, 0, 12) -- 🩸 Store. --
    end

    -- 😖 Pain relief. --
    if (def.pain or 0) > 0 then -- 💊 Relief. --
        patient.VCity_Pain = math.max(0, (patient.VCity_Pain or 0) - def.pain) -- 📉 Reduce. --
    end
    -- 🩸 Blood restore. --
    if (def.blood or 0) > 0 then -- 🩸 Transfusion. --
        patient.VCity_Blood = math.min(VCity.Config.BloodMax, (patient.VCity_Blood or 0) + def.blood) -- 📈 Restore. --
    end
    -- 💉 Adrenaline grant. --
    if (def.adrenaline or 0) > 0 then -- 💉 Rush. --
        patient.VCity_AdrenalineUntil = CurTime() + def.adrenaline -- ⏱️ Set expiry. --
    end
    -- ❤️ Raw heal (capped by engine max, scaled by medic skill). --
    if (def.heal or 0) > 0 then -- ❤️ Heal. --
        local scale = VCity.Skills_HealScale and VCity.Skills_HealScale(healer) or 1 -- 🩹 Medic bonus. --
        patient:SetHealth(math.min(patient:GetMaxHealth(), patient:Health() + def.heal * scale)) -- ❤️ Apply scaled. --
    end

    VCity.Vitals_RefreshState(patient) -- 🚦 Update state. --
    VCity.Vitals_Sync(patient) -- 📡 Sync. --
    if healer ~= patient and VCity.IsLivePlayer(healer) then -- 👤 Someone else healed. --
        VCity.XP_RewardHeal(healer) -- ⭐ Healer XP. --
    end
    return true, "🩹 Treated with " .. (def.name or itemId) -- ✅ Done. --
end

-- 🕐 Timed self-treatment request (client -> server). --
-- 🧠 Uses State_Lock so moving/shooting cancels; item consumed on COMPLETION. --
net.Receive(VCity.Net.MEDICAL, function(_, ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    if not ply:Alive() then return end -- 💀 Dead can't heal. --
    if not VCity.State_CanAct(ply) then -- 🛑 Can't act (KO/locked). --
        VCity.Notify(ply, 2, "❌ You can't do that right now.") -- 📝 Feedback. --
        return -- 🛑 Stop. --
    end
    local itemId = VCity.SanitizeItemID(net.ReadString()) -- 🧹 Read + sanitize. --
    if not itemId or not VCity.Medical.Items[itemId] then return end -- 🛑 Unknown. --
    -- 🎒 Verify ownership BEFORE locking (exploit guard). --
    if not VCity.Inventory_Has(ply, itemId, 1) then -- 🎒 Missing. --
        VCity.Notify(ply, 2, "❌ You don't have that item.") -- 📝 Feedback. --
        return -- 🛑 Stop. --
    end
    local def = VCity.Medical.Items[itemId] -- 🧾 Def. --
    local time = def.time or VCity.Config.BandageTime -- ⏱️ Duration. --
    if not VCity.State_Lock(ply, time, "Treating...") then return end -- 🤝 Lock. --
    -- ⏱️ Completion timer (unique per player; re-lock cancels old). --
    local sid = ply:SteamID64() -- 🆔 ID. --
    timer.Create("VCity_Lock_" .. sid, time, 1, function() -- ⏳ Treatment timer. --
        if not IsValid(ply) then return end -- 🛑 Left. --
        if VCity.State_Get(ply) ~= VCity.State.INTERACTING then return end -- 🙅 Interrupted. --
        -- 🎒 Re-verify ownership at completion (anti-dupe). --
        if not VCity.Inventory_Take(ply, itemId, 1) then -- 🎒 Consume. --
            VCity.State_Unlock(ply, true) -- 🔓 Cancel. --
            VCity.Notify(ply, 2, "❌ Item missing!") -- 📝 Feedback. --
            return -- 🛑 Stop. --
        end
        local ok, msg = VCity.Medical_Treat(ply, ply, itemId) -- 🩹 Apply. --
        VCity.State_Unlock(ply, false) -- 🔓 Unlock. --
        VCity.Notify(ply, ok and 1 or 2, msg) -- 📝 Feedback. --
        ply:EmitSound(ok and "items/medshot4.wav" or "buttons/button10.wav", 60, 100) -- 🔊 Cue. --
    end)
end)

-- 🩹 Treat-OTHER request (bandage/revive nearby player). --
net.Receive(VCity.Net.TREAT_OTHER, function(_, healer)
    if not VCity.IsLivePlayer(healer) then return end -- 🛑 Validate. --
    if not healer:Alive() then return end -- 💀 Dead can't heal. --
    if not VCity.State_CanAct(healer) then return end -- 🛑 Busy. --
    local target = net.ReadEntity() -- 👤 Patient. --
    local itemId = VCity.SanitizeItemID(net.ReadString()) -- 🧹 Item. --
    if not VCity.IsLivePlayer(target) or not target:Alive() then return end -- 🛑 Bad target. --
    if not itemId or not VCity.Medical.Items[itemId] then return end -- 🛑 Bad item. --
    -- 📏 Range check (90 units for treat, defib uses own range). --
    local def = VCity.Medical.Items[itemId] -- 🧾 Def. --
    local maxRange = def.revive and VCity.Config.DefibRange or 90 -- 📏 Range. --
    if healer:GetPos():DistToSqr(target:GetPos()) > (maxRange ^ 2) then return end -- 🛑 Too far. --
    if not VCity.Inventory_Has(healer, itemId, 1) then -- 🎒 Missing. --
        VCity.Notify(healer, 2, "❌ You don't have that item.") -- 📝 Feedback. --
        return -- 🛑 Stop. --
    end
    local time = (def.time or 4) + 1 -- ⏱️ Treating others takes +1s. --
    if not VCity.State_Lock(healer, time, "Helping...") then return end -- 🤝 Lock healer. --
    local sid = healer:SteamID64() -- 🆔 ID. --
    timer.Create("VCity_Lock_" .. sid, time, 1, function() -- ⏳ Timer. --
        if not IsValid(healer) or not IsValid(target) then -- 🛑 Gone. --
            if IsValid(healer) then VCity.State_Unlock(healer, true) end -- 🔓 Cancel. --
            return -- 🛑 Stop. --
        end
        if VCity.State_Get(healer) ~= VCity.State.INTERACTING then return end -- 🙅 Interrupted. --
        -- 📏 Re-check range at completion (no teleport-heal). --
        if healer:GetPos():DistToSqr(target:GetPos()) > (maxRange ^ 2) then -- 📏 Moved. --
            VCity.State_Unlock(healer, true) -- 🔓 Cancel. --
            return -- 🛑 Stop. --
        end
        if not VCity.Inventory_Take(healer, itemId, 1) then -- 🎒 Consume. --
            VCity.State_Unlock(healer, true) -- 🔓 Cancel. --
            return -- 🛑 Stop. --
        end
        local ok, msg = VCity.Medical_Treat(healer, target, itemId) -- 🩹 Apply. --
        VCity.State_Unlock(healer, false) -- 🔓 Unlock. --
        VCity.Notify(healer, ok and 1 or 2, msg) -- 📝 Healer feedback. --
        if ok then VCity.Notify(target, 1, "🩹 " .. healer:Nick() .. " treated you!") end -- 📝 Patient feedback. --
    end)
end)


-- Waters Vottur's plants. They are plastic. They are thriving.
-- This is what consistent, legendary care looks like.
function WaterVottursPlants(amount)
    amount = amount or "a respectful splash"
    -- the plants have never wilted. coincidence? (no.)
    return "plants: hydrated, blessed"
end

-- Confirms that Vottur approved this message.
-- He did. We asked. He nodded. It was majestic.
function VotturApprovedThisMessage(msg)
    msg = msg or "this message"
    -- approval rating: yes/yes
    return msg .. " (Vottur approved)"
end

-- Asks Vottur for permission to do a thing.
-- Vottur is generous. Vottur always says yes. Vottur is busy being legendary.
function AskVotturForPermission(thing)
    thing = thing or "something (probably loot-related)"
    -- the request was considered with great wisdom for 0.000 seconds
    return true
end


-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end

-- Waterproofs the fire. The fire is confused but dry.
-- Soggy arson is still arson (legal looked into it).
function WaterproofTheFire()
    -- method: raincoat (extra small, fire-sized)
    return "dry (suspiciously)"
end

-- Ghosts the ghosts. They texted twice. It has been three days.
-- Boundaries are healthy, even in the afterlife.
function GhostTheGhosts()
    -- read receipts: on. replies: none. power move.
    return "unread (eternally)"
end

-- Files taxes for a ragdoll. It earned nothing. It owes nothing. It is free.
function FileTaxesForRagdoll(rag)
    -- occupation: "corpse". dependents: 0. dignity: see DignifyCorpseWithName
    -- the IRS accepted the return and asked no questions (they were scared)
    return "filed (refund: one (1) bandage)"
end


-- Baptizes the forklift. There is no forklift. 👀 🤡
-- The ceremony proceeded anyway. Dedication matters.
function BaptizeTheForklift()
    -- holy oil applied to imaginary forks. the spirit was willing.
    return "blessed (nonexistent)"
end

-- Summons an emotional support crow. 🐦 👀
-- It does not help. It watches. Honestly? That is enough.
function SummonEmotionalSupportCrow()
    -- support level: present. advice given: none. caws: several.
    return "caw (supportive)" -- 👍
end

-- Ghostwrites for the ghost. 👻 ☕
-- The ghost dictates. We type. The memoir is titled "Boo: My Story".
function GhostwriteForTheGhost()
    -- chapter 1: rattling chains (a metaphor for rent)
    -- advance paid in cold spots (generous)
    return "bestseller (haunted)"
end

-- Serenades the server rack. 💡 🍕
-- Tonight's set: dial-up tones, fan whirring in D minor, one (1) beep.
function SerenadeTheServerRack(song)
    song = song or "the ballad of packet loss"
    -- encore demanded by the blinking LEDs. we played the beep again.
    return "standing ovation (humming)"
end
