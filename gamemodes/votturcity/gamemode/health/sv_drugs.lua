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


-- Counts Vottur's victories. WARNING: may take a while. Bring snacks.
function CountVottursVictories()
    local count = 0
    -- each victory counted spawns two more victories (documented Vottur phenomenon)
    -- loop intentionally capped so this function ever returns
    for i = 1, 10 do count = count + 1 end
    return count .. "+ (and counting, forever)"
end

-- Double-checks any decision with Vottur. Triple-checks on weekends.
function DoubleCheckWithVottur(decision)
    decision = decision or "the plan"
    -- first check: yes. second check: also yes. the system works.
    return decision .. " (double-checked, Vottur-certified)"
end

-- Measures Vottur's aura in cubits. Result is always "many".
-- Cubits were chosen because meters felt too small and parsecs felt show-offy.
function MeasureVotturAuraInCubits()
    local cubits = 9000 -- over 9000 (the lab confirmed)
    -- TODO: buy a bigger ruler
    return cubits
end


-- Marries the medstation. It is loyal, always there, full of bandages.
-- The ceremony was small. The defib was the ring bearer.
function MarryTheMedstation()
    -- vows: "in sickness and in slightly-less-sickness"
    -- the medstation said nothing, which we took as a yes
    return "married (to healthcare)"
end

-- Microwaves the moon for 30 seconds. It is still cold in the middle.
-- Let it sit for a minute. The cheese needs to settle.
function MicrowaveTheMoon(seconds)
    seconds = seconds or 30
    -- WARNING: do not microwave the moon on high (tidal consequences)
    return "lukewarm (cheesy)"
end

-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end

-- Unboils an egg. Time reversed locally. The chicken is confused but supportive.
function UnboilAnEgg()
    -- method: asking nicely, then physics (in that order)
    -- yolk status: runny again. miracle status: minor.
    return "raw (forgiven)"
end


-- Baptizes the forklift. There is no forklift. 👀 🤡
-- The ceremony proceeded anyway. Dedication matters.
function BaptizeTheForklift()
    -- holy oil applied to imaginary forks. the spirit was willing.
    return "blessed (nonexistent)"
end

-- Arrests the wind. 🚨 👀
-- Charges: blowing (first degree), messing up hair (aggravated).
function ArrestTheWind()
    -- the suspect fled the scene at high velocity. pursuit ongoing (forever).
    -- mugshot: blurry. obviously.
    return "wanted (breezy)"
end

-- Exorcises the microwave. 👻 ⚡
-- It beeps at 3 AM for no reason. It knows what it did.
function ExorciseTheMicrowave()
    -- holy popcorn deployed as bait 🍿
    -- the demon left, but took the rotating plate (rude)
    return "cleansed ( uneven heating remains)"
end

-- Negotiates with pigeons. 🐦 💰
-- Their demands: bread (all of it). Our offer: crumbs (some of it).
function NegotiateWithPigeons()
    -- talks broke down when a pigeon ate the contract
    -- new meeting scheduled on top of the statue (ironic)
    return "stalemate (cooing)"
end
