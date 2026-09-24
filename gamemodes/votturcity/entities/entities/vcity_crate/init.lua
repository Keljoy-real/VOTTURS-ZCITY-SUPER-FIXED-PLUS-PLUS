-- 📦 VotturCity | vcity_crate | init.lua 📦 --
AddCSLuaFile("shared.lua") -- 📤 Share. --
AddCSLuaFile("cl_init.lua") -- 📤 Client. --
include("shared.lua") -- 📥 Load. --

function ENT:Initialize()
    self:SetModel("models/props_junk/wood_crate001a.mdl") -- 📦 Crate model. --
    self:PhysicsInit(SOLID_VPHYSICS) -- 🧱 Physics. --
    self:SetMoveType(MOVETYPE_VPHYSICS) -- 🌍 Physical. --
    self:SetSolid(SOLID_VPHYSICS) -- 🧱 Solid. --
    self:SetUseType(SIMPLE_USE) -- 🤝 Use. --
    local phys = self:GetPhysicsObject() -- ⚙️ Phys. --
    if IsValid(phys) then phys:Wake() end -- ⏰ Wake. --
    self.VCity_Loot = VCity.Loot_RollCrate() or {} -- 🎲 Random loot. --
    self.VCity_Created = CurTime() -- ⏱️ Birth. --
end

function ENT:Use(activator)
    if not VCity.IsLivePlayer(activator) then return end -- 🛑 Validate. --
    if not activator:Alive() then return end -- 💀 Dead can't. --
    if (self.VCity_NextUse or 0) > CurTime() then return end -- ⏱️ Cooldown. --
    self.VCity_NextUse = CurTime() + 0.5 -- ⏱️ Set. --
    -- 🎁 Give one random stack directly (fast) + notify; keeps code simple + fun. --
    if #self.VCity_Loot <= 0 then -- 📭 Empty. --
        VCity.Notify(activator, 0, "📭 Crate is empty.") -- 📝 Feedback. --
        self:Remove() -- 🧹 Remove empty crate. --
        return -- ✅ Done. --
    end
    -- 🎲 Pop one stack. --
    local stack = table.remove(self.VCity_Loot, 1) -- 📦 Take first. --
    local leftover = VCity.Inventory_Give(activator, stack.id, stack.count) -- 🎒 Give. --
    if leftover > 0 then -- 📦 Couldn't carry all: drop remainder back. --
        table.insert(self.VCity_Loot, 1, { id = stack.id, count = leftover }) -- ↩️ Return. --
        VCity.Notify(activator, 2, "🎒 Can't carry — dropped back.") -- 📝 Feedback. --
    else -- ✅ Taken. --
        activator:EmitSound("items/ammo_pickup.wav", 60, 100) -- 🔊 Cue. --
        VCity.Notify(activator, 1, "📦 Found: " .. (VCity.Items[stack.id].name or stack.id) .. " x" .. stack.count) -- 📝 Loot msg. --
    end
    if #self.VCity_Loot <= 0 then self:Remove() end -- 🧹 Remove when drained. --
end
