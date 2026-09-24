-- 🔥 VotturCity | vcity_campfire | init.lua 🔥 --
AddCSLuaFile("shared.lua") -- 📤 Share. --
AddCSLuaFile("cl_init.lua") -- 📤 Client. --
include("shared.lua") -- 📥 Load. --

function ENT:Initialize() -- 🌱 Init. --
    self:SetModel("models/props_c17/furniturefireplace001a.mdl") -- 🔥 Fireplace model (stock). --
    self:PhysicsInit(SOLID_VPHYSICS) -- 🧱 Physics. --
    self:SetMoveType(MOVETYPE_VPHYSICS) -- 🌍 Physical. --
    self:SetSolid(SOLID_VPHYSICS) -- 🧱 Solid. --
    self:SetUseType(SIMPLE_USE) -- 🤝 Use. --
    local phys = self:GetPhysicsObject() if IsValid(phys) then phys:Wake() end -- ⏰ Wake. --
    self:SetNWBool("VCity_Lit", false) -- 🔥 Unlit. --
    self:SetNWFloat("VCity_Fuel", 0) -- ⛽ Fuel seconds. --
    self.VCity_Created = CurTime() -- ⏱️ Birth. --
end

-- 🤝 Use: light with 1 stick, or warm up / cook hint when lit. --
function ENT:Use(activator) -- 🤝 Interact. --
    if not VCity.IsLivePlayer(activator) or not activator:Alive() then return end -- 🛑 Validate. --
    if (self.VCity_NextUse or 0) > CurTime() then return end -- ⏱️ Cooldown. --
    self.VCity_NextUse = CurTime() + 1 -- ⏱️ Set. --
    if not self:GetNWBool("VCity_Lit", false) then -- 🔥 Unlit: need stick. --
        if not VCity.Inventory_Has(activator, "stick", 1) then VCity.Notify(activator, 2, "🔥 Need 1 stick to light!") return end -- 🪵 Missing. --
        VCity.Inventory_Take(activator, "stick", 1) -- 🪵 Consume. --
        self:SetNWBool("VCity_Lit", true) -- 🔥 Light! --
        self:SetNWFloat("VCity_Fuel", 300) -- ⛽ 5 min fuel. --
        self:EmitSound("ambient/fire/fire_small_loop1.wav", 60, 100) -- 🔊 Ignite (loop-ish one-shot). --
        VCity.Notify(activator, 1, "🔥 Campfire lit! (warms + enables cooking)") -- 📝 Confirm. --
        -- ⏱️ Fuel burndown (one timer per fire, cheap). --
        timer.Create("VCity_Fire_" .. self:EntIndex(), 5, 0, function() -- ⏱️ Burn. --
            if not IsValid(self) then return end -- 🛑 Gone. --
            local fuel = self:GetNWFloat("VCity_Fuel", 0) - 5 -- ⛽ Burn. --
            if fuel <= 0 then self:SetNWBool("VCity_Lit", false) self:SetNWFloat("VCity_Fuel", 0) timer.Remove("VCity_Fire_" .. self:EntIndex()) VCity.Notify(activator, 0, "🔥 Fire burned out.") return end -- 🔥 Out. --
            self:SetNWFloat("VCity_Fuel", fuel) -- ⛽ Store. --
            -- ❤️ Warm + heal nearby players slowly. --
            for _, p in ipairs(ents.FindInSphere(self:GetPos(), 220)) do -- 🔁 Nearby. --
                if p:IsPlayer() and p:Alive() then -- 👤 Player. --
                    p:SetHealth(math.min(p:GetMaxHealth(), p:Health() + 1)) -- ❤️ Warm heal. --
                    p.VCity_Temp = math.min(38.5, (p.VCity_Temp or 37) + 0.3) -- 🌡️ Warm. --
                end
            end
        end)
    else -- 🔥 Lit: add fuel with extra sticks, or show status. --
        if VCity.Inventory_Has(activator, "stick", 1) then -- 🪵 Stoking. --
            VCity.Inventory_Take(activator, "stick", 1) -- 🪵 Consume. --
            self:SetNWFloat("VCity_Fuel", math.min(600, self:GetNWFloat("VCity_Fuel", 0) + 120)) -- ⛽ +2 min. --
            VCity.Notify(activator, 1, "🔥 +2 min fuel!") -- 📝 Confirm. --
        else -- 📊 Status. --
            VCity.Notify(activator, 0, "🔥 Fuel: " .. math.floor(self:GetNWFloat("VCity_Fuel", 0)) .. "s. Craft nearby to cook!") -- 📝 Status. --
        end
    end
end

function ENT:OnRemove() -- 🧹 Cleanup. --
    timer.Remove("VCity_Fire_" .. self:EntIndex()) -- 🧹 Timer. --
end
