-- 💉 VotturCity | sv_drugs.lua | Overdose / addiction simulation 💉 --
-- 🧠 Fentanyl = god-tier pain relief + OD meter; naloxone = antidote. --

-- 🆕 Extend reset with OD meter. --
local _OldSyncReset = VCity.Vitals_Reset -- 💾 Keep (already wrapped once by survival; chain safely). --
-- 🙅 Don't re-wrap reset (survival already did); just init OD lazily per player. --

-- 📊 Get / set OD helpers. --
function VCity.OD_Get(ply)
    return ply.VCity_OD or 0 -- 💉 Meter. --
end

-- 🩹 Wrap treat to add OD side-effects on top of base pain relief. --
local _TraumaTreat = VCity.Medical_Treat -- 💾 Trauma-wrapped treat. --
function VCity.Medical_Treat(healer, patient, itemId)
    if itemId == "fentanyl" then -- 💉 Fentanyl. --
        local ok, msg = _TraumaTreat(healer, patient, itemId) -- 🩹 Base (pain -95). --
        -- 💉 Add OD even if base succeeded (base always succeeds for fent). --
        patient.VCity_OD = math.Clamp((patient.VCity_OD or 0) + VCity.Config.FentanylOD, 0, VCity.Config.ODMax) -- 💉 Spike. --
        patient:SetNWFloat("VCity_OD", patient.VCity_OD) -- 📡 Mirror. --
        if (patient.VCity_OD or 0) >= VCity.Config.ODRisk then -- ⚠️ Warning. --
            VCity.Notify(patient, 2, "💉 OVERDOSE RISK! Find naloxone!") -- 📝 Warn. --
            patient:EmitSound("player/heartbeat1.wav", 65, 80) -- 💓 Cue. --
        end
        return ok, (msg or "💉 Fentanyl hit.") .. " [OD " .. math.floor(patient.VCity_OD) .. "]" -- ✅ Augmented. --
    end
    if itemId == "naloxone" then -- 💉 Antidote. --
        local ok, msg = _TraumaTreat(healer, patient, itemId) -- 🩹 Base. --
        patient.VCity_OD = math.Clamp((patient.VCity_OD or 0) - VCity.Config.NaloxoneClear, 0, VCity.Config.ODMax) -- 💉 Clear. --
        patient.VCity_Pain = math.Clamp((patient.VCity_Pain or 0) + VCity.Config.NaloxonePain, 0, 100) -- 😖 Withdrawal rebound. --
        patient:SetNWFloat("VCity_OD", patient.VCity_OD) -- 📡 Mirror. --
        VCity.Vitals_Sync(patient) -- 📡 Sync. --
        return true, "💉 Naloxone: OD down to " .. math.floor(patient.VCity_OD) -- ✅ Done. --
    end
    return _TraumaTreat(healer, patient, itemId) -- 🤝 Default. --
end

-- ⏱️ OD decay + crisis rolls (piggybacks the 2s vitals tick hook for efficiency). --
hook.Add("VCity_StateChanged", "VCity_ODWatch", function(ply)
    -- 🙅 Placeholder: real per-tick logic lives in the timer below (keeps hook light). --
end)

timer.Create("VCity_ODTick", 2, 0, function() -- ⏱️ OD timer (shares cadence with vitals). --
    for _, ply in ipairs(player.GetAll()) do -- 🔁 Players. --
        if not VCity.IsLivePlayer(ply) or not ply:Alive() then continue end -- 🛑 Skip. --
        local od = ply.VCity_OD or 0 -- 💉 Current. --
        if od <= 0 then continue end -- ✅ Clean. --
        -- 📉 Decay toward sober. --
        ply.VCity_OD = math.max(0, od - VCity.Config.ODDecay) -- 📉 Sober up. --
        ply:SetNWFloat("VCity_OD", ply.VCity_OD) -- 📡 Mirror. --
        -- ⚠️ Crisis while above risk threshold. --
        if od >= VCity.Config.ODRisk then -- ⚠️ Danger zone. --
            ply:SetHealth(ply:Health() - VCity.Config.ODDamage) -- 🩸 Organ strain. --
            if ply:Health() <= 0 and ply:Alive() then ply:Kill() continue end -- ⚰️ Fatal OD. --
            if VCity.State_Get(ply) ~= VCity.State.UNCONSCIOUS and math.random() < VCity.Config.ODKOChance then -- 🎲 Nod off. --
                VCity.State_Knockout(ply, VCity.Config.UnconsciousTime) -- 😵 OD knockout. --
                VCity.Notify(ply, 2, "💉 You overdosed!") -- 📝 Warn. --
            end
        end
    end
end)
