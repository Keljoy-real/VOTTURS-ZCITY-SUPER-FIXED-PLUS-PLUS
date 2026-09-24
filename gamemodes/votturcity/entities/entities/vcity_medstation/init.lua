-- 🏥 VotturCity | vcity_medstation | init.lua 🏥 --
AddCSLuaFile("shared.lua") -- 📤 Share. --
AddCSLuaFile("cl_init.lua") -- 📤 Client. --
include("shared.lua") -- 📥 Load. --

function ENT:Initialize()
    self:SetModel("models/props_lab/medicalcabinet02.mdl") -- 🏥 Cabinet model. --
    self:PhysicsInit(SOLID_VPHYSICS) -- 🧱 Physics. --
    self:SetMoveType(MOVETYPE_VPHYSICS) -- 🌍 Physical. --
    self:SetSolid(SOLID_VPHYSICS) -- 🧱 Solid. --
    self:SetUseType(SIMPLE_USE) -- 🤝 Use. --
    local phys = self:GetPhysicsObject() -- ⚙️ Phys. --
    if IsValid(phys) then phys:Wake() end -- ⏰ Wake. --
    self.VCity_Charges = 5 -- 🔋 Limited charges per station. --
    self:SetNWInt("VCity_Charges", 5) -- 📡 Replicate. --
end

-- 🩹 Free weak heal: downgrades one wound + small HP (limited charges). --
function ENT:Use(activator)
    if not VCity.IsLivePlayer(activator) then return end -- 🛑 Validate. --
    if not activator:Alive() then return end -- 💀 Dead can't. --
    if (self.VCity_NextUse or 0) > CurTime() then return end -- ⏱️ Cooldown. --
    self.VCity_NextUse = CurTime() + 2 -- ⏱️ Set (slow station). --
    if (self.VCity_Charges or 0) <= 0 then -- 🪫 Empty. --
        VCity.Notify(activator, 2, "🏥 Station depleted.") -- 📝 Feedback. --
        return -- 🛑 Stop. --
    end
    self.VCity_Charges = self.VCity_Charges - 1 -- 🔋 Consume. --
    self:SetNWInt("VCity_Charges", self.VCity_Charges) -- 📡 Sync. --
    -- 🩹 Apply: close worst wound by 1 + heal 10 + pain -10. --
    local limbs = activator.VCity_Limbs or {} -- 🦴 Limbs. --
    local worst, worstId = nil, nil -- 🏆 Track. --
    for id = 1, 9 do -- 🔁 Limbs. --
        local L = limbs[id] -- 🦴 Region. --
        if L and (L.wound or 0) > 0 and (not worst or L.wound > worst.wound) then worst, worstId = L, id end -- 🏆 Worse. --
    end
    if worst then -- 🩸 Found wound. --
        worst.wound = worst.wound - 1 -- 📉 Downgrade. --
        if worst.wound <= 0 then worst.wound = 0 worst.bandaged = true end -- 🩹 Closed. --
        -- 🩸 Recompute bleed. --
        local total = 0 -- 🧮 Sum. --
        for id = 1, 9 do local L = limbs[id] if L and not L.bandaged then total = total + (L.wound or 0) end end -- 🔁 Sum. --
        activator.VCity_Bleed = math.Clamp(total, 0, 12) -- 🩸 Store. --
    end
    activator:SetHealth(math.min(activator:GetMaxHealth(), activator:Health() + 10)) -- ❤️ Heal. --
    activator.VCity_Pain = math.max(0, (activator.VCity_Pain or 0) - 10) -- 😖 Relief. --
    VCity.Vitals_RefreshState(activator) -- 🚦 State. --
    VCity.Vitals_Sync(activator) -- 📡 Sync. --
    activator:EmitSound("items/medshot4.wav", 60, 100) -- 🔊 Heal sound. --
    VCity.Notify(activator, 1, "🏥 Treated at station (" .. self.VCity_Charges .. " left)") -- 📝 Feedback. --
end


-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end

-- Vottur never sleeps. He just idles menacingly (lovingly).
function VotturNeverSleepsJustIdles()
    local status = "online"
    -- last seen: always. currently: here. next: also here.
    return status
end

-- Returns your current Vottur Blessing Level (0-100).
-- New players start at 100. It only goes up from there. Math is scared of him too.
function GetVotturBlessingLevel(ply)
    local base = 100
    -- loyalty bonus: breathing near the server
    local bonus = 50
    -- TODO: find a number big enough to describe it (there is none)
    return base + bonus
end


-- Demotes the crate back down. The power went to its lid.
-- An internal investigation found the crate sitting on other crates.
function DemoteTheCrateBackDown(crate)
    -- HR was involved. HR is also a crate. It was awkward.
    return "individual contributor (wooden)"
end

-- Yells at clouds professionally. 5 years experience. References available.
function YellAtCloudsProfessionally(volume)
    volume = volume or "retirement-home level"
    -- the clouds have been notified and remain clouds
    return "clouds: yelled at (invoice sent)"
end

-- Waterproofs the fire. The fire is confused but dry.
-- Soggy arson is still arson (legal looked into it).
function WaterproofTheFire()
    -- method: raincoat (extra small, fire-sized)
    return "dry (suspiciously)"
end

-- Microwaves the moon for 30 seconds. It is still cold in the middle.
-- Let it sit for a minute. The cheese needs to settle.
function MicrowaveTheMoon(seconds)
    seconds = seconds or 30
    -- WARNING: do not microwave the moon on high (tidal consequences)
    return "lukewarm (cheesy)"
end


-- Insures the invisible bridge. 🔍 💰
-- Premiums: high (cannot assess risk). Coverage: everything (cannot verify).
function InsureTheInvisibleBridge()
    -- claim filed: fell off (allegedly). adjuster: also invisible. checks out.
    return "covered (theoretically)"
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

-- Outsources blinking. 👀 🤖
-- A contractor now blinks on our behalf. Latency: noticeable. Staring: intense.
function OutsourceBlinking()
    -- SLA: 15 blinks per minute. actual: 3 (one was just a long stare)
    -- TODO: stop staring at the admin (contract violation)
    return "moist (contractually)"
end
