-- 📦 VotturCity | vcity_pickup | init.lua (server) 📦 --

AddCSLuaFile("shared.lua") -- 📤 Share. --
AddCSLuaFile("cl_init.lua") -- 📤 Share client. --
include("shared.lua") -- 📥 Load shared. --

-- 🌱 Initialize physics + defaults. --
function ENT:Initialize()
    self:SetModel("models/items/boxsrounds.mdl") -- 📦 Default model. --
    self:PhysicsInit(SOLID_VPHYSICS) -- 🧱 Physics. --
    self:SetMoveType(MOVETYPE_VPHYSICS) -- 🌍 Physical. --
    self:SetSolid(SOLID_VPHYSICS) -- 🧱 Solid. --
    self:SetUseType(SIMPLE_USE) -- 🤝 Simple use. --
    local phys = self:GetPhysicsObject() -- ⚙️ Physobj. --
    if IsValid(phys) then phys:Wake() end -- ⏰ Wake. --
    self:SetNWString("VCity_Item", "scrap") -- 🏷️ Default item. --
    self:SetNWInt("VCity_Count", 1) -- 🔢 Default count. --
    self.VCity_Created = CurTime() -- ⏱️ Birth (for cleanup). --
end

-- 🏷️ Assign item contents + model from registry. --
function ENT:SetItem(itemId, count)
    local def = VCity.Item_Get(itemId) -- 🧾 Lookup. --
    if not def then return end -- 🛑 Unknown. --
    self.VCity_Item = itemId -- 💾 Store. --
    self.VCity_Count = math.Clamp(count or 1, 1, def.max or 99) -- 🔢 Store. --
    self:SetNWString("VCity_Item", itemId) -- 📡 Replicate. --
    self:SetNWInt("VCity_Count", self.VCity_Count) -- 📡 Replicate. --
    self:SetModel(def.model or "models/items/boxsrounds.mdl") -- 🎨 Model. --
    self:PhysicsInit(SOLID_VPHYSICS) -- 🧱 Re-init physics for new model. --
    self:SetMoveType(MOVETYPE_VPHYSICS) -- 🌍 Physical. --
    self:SetSolid(SOLID_VPHYSICS) -- 🧱 Solid. --
    local phys = self:GetPhysicsObject() -- ⚙️ Phys. --
    if IsValid(phys) then phys:Wake() end -- ⏰ Wake. --
end

-- 🤝 Give to player on use (validates range + space). --
function ENT:Use(activator, caller)
    if not VCity.IsLivePlayer(activator) then return end -- 🛑 Not player. --
    if not activator:Alive() then return end -- 💀 Dead can't. --
    -- ⏱️ Per-entity use cooldown stops double-pickup spam. --
    if (self.VCity_NextUse or 0) > CurTime() then return end -- ⏱️ Cooldown. --
    self.VCity_NextUse = CurTime() + 0.5 -- ⏱️ Set. --
    local itemId = self.VCity_Item or self:GetNWString("VCity_Item", "scrap") -- 🆔 Item. --
    local count = self.VCity_Count or self:GetNWInt("VCity_Count", 1) -- 🔢 Count. --
    local leftover = VCity.Inventory_Give(activator, itemId, count) -- 🎒 Give. --
    if leftover <= 0 then -- ✅ Fully taken. --
        activator:EmitSound("items/ammo_pickup.wav", 60, 100) -- 🔊 Pickup. --
        self:Remove() -- 🧹 Remove entity. --
    elseif leftover < count then -- 📦 Partial (heavy/full). --
        self.VCity_Count = leftover -- 📉 Update. --
        self:SetNWInt("VCity_Count", leftover) -- 📡 Replicate. --
        VCity.Notify(activator, 0, "🎒 Partially picked up.") -- 📝 Feedback. --
    end
    -- 🙅 If leftover == count, inventory rejected; entity stays. --
end
