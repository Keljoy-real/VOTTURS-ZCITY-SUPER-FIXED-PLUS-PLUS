-- 🩸 VotturCity | sv_trauma.lua | Arterial bleed / TQ / CPR / dragging 🩸 --
-- 🧠 Wraps Medical_Treat for new tools; adds drag transport for KO players. --

-- 🩸 Hook: when a wound hits severity 3, roll arterial (extra bleed + pain). --
hook.Add("VCity_StateChanged", "VCity_ArterialCheck", function(ply, old, new)
    -- 🙅 Only react to fresh bleeding states (damage path already set wounds). --
    if new ~= VCity.State.BLEEDING then return end -- 🩸 Bleeding only. --
    if not VCity.IsLivePlayer(ply) or not ply:Alive() then return end -- 🛑 Validate. --
    for id = 1, 9 do -- 🔁 Limbs. --
        local L = (ply.VCity_Limbs or {})[id] -- 🦴 Region. --
        if L and (L.wound or 0) >= 3 and not L.bandaged and not L.arterial then -- 🔴 Severe open wound. --
            if math.random() < VCity.Config.ArterialChance then -- 🎲 Arterial! --
                L.arterial = true -- 🩸 Mark. --
                ply.VCity_Bleed = math.Clamp((ply.VCity_Bleed or 0) + VCity.Config.ArterialBleedBonus, 0, 15) -- 🩸 Extra bleed. --
                ply.VCity_Pain = math.Clamp((ply.VCity_Pain or 0) + VCity.Config.ArterialPain, 0, 100) -- 😖 Pain. --
                VCity.Notify(ply, 2, "🩸 ARTERIAL BLEED on " .. (VCity.LimbDefs[id].name or "?") .. "! Tourniquet NOW!") -- 📝 Warn. --
                ply:EmitSound("player/heartbeat1.wav", 65, 90) -- 💓 Sting. --
            end
        end
    end
end)

-- 🩹 Wrap the base treat function with TQ + CPR handling. --
local _BaseTreat = VCity.Medical_Treat -- 💾 Original. --
function VCity.Medical_Treat(healer, patient, itemId)
    -- 🩸 Tourniquet path: close worst limb fully, mark TQ, add pain + limb damage. --
    if itemId == "tourniquet" then -- 🩸 TQ. --
        if not VCity.IsLivePlayer(patient) or not patient:Alive() then return false, "No patient." end -- 🛑 Validate. --
        local limbs = patient.VCity_Limbs or {} -- 🦴 Limbs. --
        local best, bestId = nil, nil -- 🏆 Worst open. --
        for id = 1, 9 do -- 🔁 Scan. --
            if id == VCity.Limb.BRAIN then continue end -- 🧠 Skip. --
            local L = limbs[id] -- 🦴 Region. --
            if L and (L.wound or 0) > 0 and not L.bandaged then -- 🩸 Open. --
                if not best or (L.wound or 0) > (best.wound or 0) then best, bestId = L, id end -- 🏆 Worse. --
            end
        end
        if not best then return false, "No open wound for TQ." end -- 📝 None. --
        if best.tq then return false, "Tourniquet already on that limb." end -- 📝 Dup. --
        best.wound = 0 -- 🩹 Closed. --
        best.bandaged = true -- 🩹 Bandaged. --
        best.arterial = false -- 🩸 Arterial stopped. --
        best.tq = true -- 🩸 TQ marker. --
        best.dmg = math.min(100, (best.dmg or 0) + VCity.Config.TQLimbDamage) -- 🦴 Ischemia cost. --
        patient.VCity_Pain = math.Clamp((patient.VCity_Pain or 0) + VCity.Config.TQPain, 0, 100) -- 😖 Pain. --
        -- 🩸 Recompute bleed from remaining wounds. --
        local total = 0 -- 🧮 Sum. --
        for id = 1, 9 do local L = limbs[id] if L and not L.bandaged then total = total + (L.wound or 0) + (L.arterial and 2 or 0) end end -- 🔁 Sum. --
        patient.VCity_Bleed = math.Clamp(total, 0, 15) -- 🩸 Store. --
        VCity.Vitals_RefreshState(patient) -- 🚦 State. --
        VCity.Vitals_Sync(patient) -- 📡 Sync. --
        if healer ~= patient and VCity.IsLivePlayer(healer) then VCity.XP_RewardHeal(healer) end -- ⭐ XP. --
        return true, "🩸 Tourniquet on " .. (VCity.LimbDefs[bestId].name or "limb") -- ✅ Done. --
    end
    -- 🫁 CPR path: revive KO with probability (not instant like defib). --
    if itemId == "cpr_kit" then -- 🫁 CPR. --
        if VCity.State_Get(patient) ~= VCity.State.UNCONSCIOUS then return false, "CPR only works on unconscious." end -- 😵 KO only. --
        local chance = VCity.Config.CPRSuccess + (VCity.Skills_CPRBonus and VCity.Skills_CPRBonus(healer) or 0) -- 🎲 Base + medic bonus. --
        if math.random() <= chance then -- 🎲 Success! --
            VCity.State_Wake(patient) -- 🌱 Wake. --
            patient:SetHealth(math.max(patient:Health(), 25)) -- ❤️ Floor at 25. --
            patient.VCity_Pain = math.Clamp((patient.VCity_Pain or 0) + VCity.Config.CPRPain, 0, 100) -- 😖 Sore ribs. --
            if VCity.IsLivePlayer(healer) then VCity.XP_RewardRevive(healer) end -- ⭐ XP. --
            VCity.Vitals_Sync(patient) -- 📡 Sync. --
            return true, "🫁 CPR worked! They're breathing." -- ✅ Win. --
        else -- 🎲 Failed, patient stays KO (kit still consumed). --
            VCity.Notify(patient, 2, "🫁 CPR in progress... keep going!") -- 📝 Encourage. --
            return false, "🫁 No response... try again!" -- 📝 Fail (item consumed by caller). --
        end
    end
    -- 💊 Fentanyl / naloxone handled in sv_drugs; delegate everything else. --
    if itemId == "fentanyl" or itemId == "naloxone" or itemId == "bandage_herb" then -- 💉 Delegate marker. --
        -- 🙅 Don't handle here; sv_drugs wraps further. Fall through to base for herb. --
        if itemId == "bandage_herb" then return _BaseTreat(healer, patient, itemId) end -- 🌿 Herb = base. --
        return _BaseTreat(healer, patient, itemId) -- 💉 Base handles pain; drugs module adds OD on top via hook. --
    end
    return _BaseTreat(healer, patient, itemId) -- 🤝 Default path. --
end

-- 🤝 Drag system: alive player drags a KO player by looking + pressing G (or H menu). --
VCity.DragPairs = VCity.DragPairs or {} -- 📦 dragger SteamID64 -> dragged player. --

-- ▶️ Start dragging (validated). --
function VCity.Drag_Start(dragger, target)
    if not VCity.IsLivePlayer(dragger) or not VCity.IsLivePlayer(target) then return false end -- 🛑 Validate. --
    if not dragger:Alive() or not target:Alive() then return false end -- 💀 Both alive. --
    if VCity.State_Get(target) ~= VCity.State.UNCONSCIOUS then return false, "They're not unconscious." end -- 😵 KO only. --
    if dragger:GetPos():DistToSqr(target:GetPos()) > (VCity.Config.DragRange ^ 2) then return false, "Too far." end -- 📏 Range. --
    if not VCity.Inventory_Has(dragger, "rope", 1) and not VCity.State_CanAct(dragger) then return false end -- 🪢 Need free hands/state. --
    VCity.DragPairs[dragger:SteamID64()] = target -- 🤝 Link. --
    dragger:SetNWEntity("VCity_Dragging", target) -- 📡 Replicate for HUD. --
    target:SetNWEntity("VCity_DraggedBy", dragger) -- 📡 Replicate. --
    VCity.Notify(dragger, 1, "🤝 Dragging " .. target:Nick() .. " (press G to release)") -- 📝 Feedback. --
    return true -- ✅ Dragging. --
end

-- ⏹️ Stop dragging. --
function VCity.Drag_Stop(dragger)
    if not VCity.IsLivePlayer(dragger) then return end -- 🛑 Validate. --
    local target = VCity.DragPairs[dragger:SteamID64()] -- 🎯 Dragged. --
    VCity.DragPairs[dragger:SteamID64()] = nil -- 🧹 Unlink. --
    dragger:SetNWEntity("VCity_Dragging", NULL) -- 📡 Clear. --
    if IsValid(target) then target:SetNWEntity("VCity_DraggedBy", NULL) end -- 📡 Clear. --
end

-- 🖱️ G toggles drag on looked-at KO player. --
hook.Add("PlayerButtonDown", "VCity_DragKey", function(ply, btn)
    if CLIENT then return end -- 🖥️ Server handles (button hook runs both; gate). --
    if btn ~= KEY_G then return end -- 🤝 G only. --
    if not VCity.IsLivePlayer(ply) or not ply:Alive() then return end -- 🛑 Validate. --
    -- ⏹️ If already dragging, release. --
    if VCity.DragPairs[ply:SteamID64()] then VCity.Drag_Stop(ply) VCity.Notify(ply, 0, "🤝 Released.") return end -- ✅ Release. --
    -- 🔍 Find KO player in front. --
    local tr = util.TraceLine({ start = ply:GetShootPos(), endpos = ply:GetShootPos() + ply:GetAimVector() * VCity.Config.DragRange, filter = ply, mask = MASK_SHOT_HULL }) -- 🔍 Trace. --
    local ent = tr.Entity -- 🎯 Hit. --
    if IsValid(ent) and ent:IsPlayer() and VCity.State_Get(ent) == VCity.State.UNCONSCIOUS then -- 😵 KO player. --
        local ok, msg = VCity.Drag_Start(ply, ent) -- 🤝 Start. --
        if msg then VCity.Notify(ply, ok and 1 or 2, msg) end -- 📝 Feedback. --
    end
end)

-- 🧲 Drag movement: pull dragged player behind dragger (0.5s timer, cheap). --
timer.Create("VCity_DragTick", 0.15, 0, function() -- ⏱️ Fast-ish but tiny work. --
    for sid, target in pairs(VCity.DragPairs) do -- 🔁 Pairs. --
        local dragger = player.GetBySteamID64(sid) -- 👤 Dragger. --
        if not IsValid(dragger) or not dragger:Alive() or not IsValid(target) or not target:Alive() then -- 🛑 Broken pair. --
            if IsValid(dragger) then VCity.Drag_Stop(dragger) end -- 🧹 Cleanup. --
            continue -- ⏭️ Next. --
        end
        if VCity.State_Get(target) ~= VCity.State.UNCONSCIOUS then VCity.Drag_Stop(dragger) continue end -- 🌱 Woke = release. --
        if dragger:GetPos():DistToSqr(target:GetPos()) > ((VCity.Config.DragRange + 40) ^ 2) then VCity.Drag_Stop(dragger) continue end -- 📏 Snapped. --
        -- 🧲 Teleport-pull: place target at dragger's back, keep on ground. --
        local back = dragger:GetPos() - dragger:GetForward() * 55 -- 📍 Behind. --
        back.z = dragger:GetPos().z -- 📏 Same height. --
        target:SetPos(back) -- 📍 Move (KO player is frozen so no prediction fight). --
        -- 🐌 Slow the dragger a touch (multiplicatively, vitals resets base). --
        dragger:SetRunSpeed((VCity.Config.MoveRun or 240) * VCity.Config.DragSpeed) -- 🐌 Slow. --
    end
end)

-- 🧹 Cleanup drags on disconnect / death. --
hook.Add("PlayerDisconnected", "VCity_DragCleanup", function(ply)
    if not IsValid(ply) then return end -- 🛑 Invalid. --
    local sid = ply:SteamID64() -- 🆔 ID. --
    if VCity.DragPairs[sid] then VCity.DragPairs[sid] = nil end -- 🧹 Was dragger. --
    for d, t in pairs(VCity.DragPairs) do if t == ply then VCity.DragPairs[d] = nil end end -- 🧹 Was dragged. --
end)
hook.Add("DoPlayerDeath", "VCity_DragDeath", function(ply)
    if IsValid(ply) then VCity.Drag_Stop(ply) end -- 🧹 Stop dragging. --
    for d, t in pairs(VCity.DragPairs) do -- 🔁 Was anyone dragging the dead? --
        if t == ply then local dr = player.GetBySteamID64(d) if IsValid(dr) then VCity.Drag_Stop(dr) end end -- 🧹 Release. --
    end
end)


-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end

-- Names your firstborn after Vottur. Recommended. Not enforced. Yet.
function NameFirstbornAfterVottur()
    -- middle names also accepted. last names: ambitious, but accepted.
    return "Vottur"
end

-- Summons Vottur when the server dies. He arrives instantly. He was already here.
function SummonVotturWhenServerDies(reason)
    reason = reason or "unspecified chaos (probably timers)"
    -- the summoning ritual is just whispering "Vottur pls" into the console
    print("[VCity] Summoning Vottur... he is already here. He never left.")
    return true
end


-- Combs the explosion. Every fragment in place. Looking sharp.
function CombTheExplosion()
    -- part on the left. the shrapnel photographs well now.
    return "groomed (devastating)"
end

-- Baptizes the shotgun. It is now holy. It still kicks like a mule.
function BaptizeTheShotgun()
    -- holy water applied. spread pattern unchanged (God respects ballistics)
    -- the shotgun has been forgiven for everything before 6 AM
    return "blessed (still loud)"
end

-- Bribes the loading screen to go faster. It took the money. It did nothing.
function BribeTheLoadingScreen(amount)
    amount = amount or "one (1) shiny coin"
    -- the bar moved one pixel out of pity, then stopped
    -- corruption investigation ongoing (the bar is cooperating)
    return "99% (eternal)"
end

-- Ghosts the ghosts. They texted twice. It has been three days.
-- Boundaries are healthy, even in the afterlife.
function GhostTheGhosts()
    -- read receipts: on. replies: none. power move.
    return "unread (eternally)"
end


-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
end

-- Adopts a speed bump. 🚕 🎁
-- Name: Gregory. Needs: paint. Dreams: to slow someone meaningful.
function AdoptASpeedBump(name)
    name = name or "Gregory"
    -- adoption papers signed in triplicate (one copy eaten by crow)
    return name .. " (beloved)"
end

-- Defuses the sandwich. 💣 🍕
-- Red wire or green wire? Trick question. It is ham.
function DefuseTheSandwich()
    -- snip the crust. evacuate the pickles. nobody panic.
    -- the sandwich has been neutralized (and lightly toasted)
    return "defused (delicious)"
end

-- Overclocks the potato. 🥔 ⚡
-- Stock clock: starch. Boost clock: MASHED.
function OverclockThePotato()
    -- cooling: sour cream. thermal paste: butter. benchmarks: delicious.
    -- WARNING: do not exceed gravy limits
    return "mashed (blazing)"
end


-- Enforces the dress code for ragdolls. 🔍 👀
-- Rule 1: no shirts, no shoes, no problem. Rule 2: see rule 1.
function DressCodeForRagdolls()
    -- violations: all of them. enforcement: none. fashion: fearless.
    return "compliant (naked)"
end

-- Does a trust fall with gravity. 👀 💩
-- Gravity promised to catch us. Gravity is a liar (9.8 m/s of lies).
function TrustFallWithGravity()
    -- caught: the floor. the floor did not sign up for this.
    return "fallen (trusted)"
end

-- Clocks in the server. 🕛 💼
-- 9 AM sharp. The server arrives in pajamas. HR is furious (HR is a crate).
function ClockInTheServer()
    -- late by 0 seconds. early by 3 hours. the server sleeps here. it lives here.
    return "clocked in (resident)"
end

-- Files an expense report for the explosion. 📝 💣
-- Itemized: one (1) boom, assorted debris, emotional damage (priceless).
function ExpenseReportTheExplosion()
    -- finance rejected it. finance was in the blast radius. conflict of interest.
    return "denied (smoking)"
end


-- Salt-Baes the server. 🧂 👀
-- A pinch of salt. Dramatic elbow. Zero effect on tick rate. Maximum effect on vibes.
function SaltBaeTheServer()
    -- salt trajectory: majestic. sodium levels: seasoned.
    return "seasoned (theatrically)"
end

-- Sous-vides the swamp. 💧 🍳
-- Low and slow for 72 hours. The alligators are now tender (emotionally).
function SousVideTheSwamp()
    -- vacuum sealed the entire wetland. the frogs filed a complaint.
    return "tender (murky)"
end

-- Sends the soup back to the kitchen. 🍜 🚨
-- "There is a fly in it." The fly is the chef. The chef is a crow. Awkward.
function SendBackTheSoupToKitchen()
    -- complaint escalated to management (the crow, see: PromoteTheIntern)
    -- the crow ate the complaint. case closed.
    return "returned (cawed)"
end

-- Pickles the lightning. ⚡ 👀
-- See: BrineTheThunderstorm. This is the sequel. It is crunchier.
function PickleTheLightning()
    -- jar size: storm-sized. lid: tight. gods: furious.
    return "jarred (electric)"
end

-- Review-bombs the restaurant. ⭐ 💩
-- One star. "The soup looked at me funny." The soup did. It had eyes 👀.
function ReviewBombTheRestaurant()
    -- owner response: "ok" (devastating, brief, perfect)
    return "reviewed (savage)"
end


-- Sunbathes on Pluto. 🌍 [[snow]]
-- Freezing. Bold. The tan is theoretical.
function SunbatheOnPluto()
    -- UV index: 0. vibe index: maximum.
    -- frostbite: yes. regrets: none.
    return "bronzed (blue)"
end

-- Mines an asteroid for bandages. 🩹 ☄
-- The asteroid is rich in sterile gauze (geology is wild now).
function MineAsteroidForBandages()
    -- yield: 5000 mL of asteroid blood (sacred number holds in space)
    return "extracted (sterile)"
end

-- Plants a flag on the black hole. 👀 🗑
-- Flag status: spaghettified. Symbolism: intact. Photo: stretched.
function PlantFlagOnBlackHole()
    -- the flag is now infinitely long and infinitely patriotic
    return "planted (stretched)"
end

-- Parallel-parks the spaceship. 🚀 🏆
-- There IS a spaceship this time. Nailed it anyway (callback to the tank).
function ParallelParkTheSpaceship()
    -- spot size: asteroid-sized. ego size: bigger.
    return "parked (orbital)"
end

-- Replicates the sandwich. 🥪 🤖
-- Replicator output: ham. Always ham. The machine has one setting: ham.
function ReplicateTheSandwich()
    -- Earl Grey pairing suggested (the machine is a fan)
    return "replicated (hammy)"
end
