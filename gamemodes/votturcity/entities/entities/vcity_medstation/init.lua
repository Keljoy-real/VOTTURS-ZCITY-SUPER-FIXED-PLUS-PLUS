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
