-- 💀 VotturCity | vcity_corpse | init.lua 💀 --

AddCSLuaFile("shared.lua") -- 📤 Share. --
AddCSLuaFile("cl_init.lua") -- 📤 Client. --
include("shared.lua") -- 📥 Load. --

function ENT:Initialize()
    self:SetModel("models/props_junk/wood_crate001a.mdl") -- 📦 Placeholder (hidden client-side). --
    self:SetNoDraw(true) -- 🙈 Server doesn't draw anyway. --
    self:PhysicsInit(SOLID_VPHYSICS) -- 🧱 Physics. --
    self:SetMoveType(MOVETYPE_NONE) -- 🧊 Static. --
    self:SetSolid(SOLID_VPHYSICS) -- 🧱 Solid for +use traces. --
    self:SetUseType(SIMPLE_USE) -- 🤝 Use. --
    self.VCity_Loot = {} -- 🎒 Loot stacks. --
    self.VCity_Created = CurTime() -- ⏱️ Birth. --
end

-- 🎒 Set loot contents (called by sv_corpse). --
function ENT:SetLoot(loot, ownerName)
    self.VCity_Loot = loot or {} -- 🎒 Store. --
    self:SetNWString("VCity_Owner", ownerName or "Unknown") -- 🏷️ Owner name. --
end

-- 🤝 Open search UI on use. --
function ENT:Use(activator)
    if not VCity.IsLivePlayer(activator) then return end -- 🛑 Validate. --
    if not activator:Alive() then return end -- 💀 Dead can't loot. --
    if (self.VCity_NextUse or 0) > CurTime() then return end -- ⏱️ Cooldown. --
    self.VCity_NextUse = CurTime() + 0.5 -- ⏱️ Set. --
    VCity.Corpse_OpenSearch(activator, self) -- 💀 Send contents. --
end
