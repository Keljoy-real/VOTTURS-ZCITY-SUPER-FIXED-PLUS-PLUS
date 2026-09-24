-- 📦 VotturCity | vcity_airdrop | init.lua 📦 --
AddCSLuaFile("shared.lua") -- 📤 Share. --
AddCSLuaFile("cl_init.lua") -- 📤 Client. --
include("shared.lua") -- 📥 Load. --

function ENT:Initialize() -- 🌱 Init. --
    self:SetModel("models/props_junk/wood_crate002a.mdl") -- 📦 Big crate. --
    self:PhysicsInit(SOLID_VPHYSICS) -- 🧱 Physics. --
    self:SetMoveType(MOVETYPE_VPHYSICS) -- 🪂 Falls. --
    self:SetSolid(SOLID_VPHYSICS) -- 🧱 Solid. --
    self:SetUseType(SIMPLE_USE) -- 🤝 Use. --
    local phys = self:GetPhysicsObject() -- ⚙️ Phys. --
    if IsValid(phys) then phys:SetMass(200) phys:Wake() end -- ⚖️ Heavy. --
    -- 🎁 Rich loot: 1 weapon + 2 medical + 2 common. --
    self.VCity_Loot = {} -- 🎁 Loot. --
    local function roll(tbl) local p = VCity.WeightedPick(VCity.LootTables[tbl]) if p then table.insert(self.VCity_Loot, { id = p.id, count = math.random(p.min, p.max) }) end end -- 🎲 Helper. --
    roll("weapon") roll("medical") roll("medical") roll("common") roll("common") -- 🎲 Fill. --
    self.VCity_Created = CurTime() -- ⏱️ Birth. --
    self:SetNWBool("VCity_Landed", false) -- 🪂 Airborne. --
    -- 💨 Smoke trail while falling (one timer, self-removed on land). --
    timer.Create("VCity_DropSmoke_" .. self:EntIndex(), 0.5, 0, function() -- 💨 Puff. --
        if not IsValid(self) then timer.Remove("VCity_DropSmoke_" .. self:EntIndex()) return end -- 🛑 Gone. --
        if self:GetNWBool("VCity_Landed", false) then timer.Remove("VCity_DropSmoke_" .. self:EntIndex()) return end -- 🛬 Landed. --
        local ed = EffectData() ed:SetOrigin(self:GetPos()) ed:SetScale(1) util.Effect("cball_explode", ed, true, true) -- 💨 Puff (cheap stock). --
    end)
end

function ENT:PhysicsCollide(data) -- 🛬 Landing. --
    if self:GetNWBool("VCity_Landed", false) then return end -- 🙅 Already. --
    if data.Speed > 300 then -- 💥 Hard landing thud. --
        self:EmitSound("physics/wood/wood_crate_break1.wav", 70, 90) -- 🔊 Thud. --
    end
    self:SetNWBool("VCity_Landed", true) -- 🛬 Landed. --
    timer.Remove("VCity_DropSmoke_" .. self:EntIndex()) -- 🧹 Stop smoke. --
end

function ENT:Use(activator) -- 🤝 Loot one stack per press (like crate). --
    if not VCity.IsLivePlayer(activator) or not activator:Alive() then return end -- 🛑 Validate. --
    if not self:GetNWBool("VCity_Landed", false) then VCity.Notify(activator, 0, "🪂 Wait for landing!") return end -- 🪂 Airborne. --
    if (self.VCity_NextUse or 0) > CurTime() then return end -- ⏱️ Cooldown. --
    self.VCity_NextUse = CurTime() + 0.5 -- ⏱️ Set. --
    if #self.VCity_Loot <= 0 then VCity.Notify(activator, 0, "📭 Empty.") self:Remove() return end -- 📭 Empty. --
    local stack = table.remove(self.VCity_Loot, 1) -- 📦 Pop. --
    local left = VCity.Inventory_Give(activator, stack.id, stack.count) -- 🎒 Give. --
    if left > 0 then table.insert(self.VCity_Loot, 1, { id = stack.id, count = left }) VCity.Notify(activator, 2, "🎒 Can't carry!") -- 📦 Return. --
    else activator:EmitSound("items/ammo_pickup.wav", 60, 100) hook.Run("VCity_CrateOpened", activator, stack.id, stack.count) VCity.Notify(activator, 1, "📦 Airdrop: " .. ((VCity.Items[stack.id] or {}).name or stack.id) .. " x" .. stack.count) end -- ✅ Taken. --
    if #self.VCity_Loot <= 0 then self:Remove() end -- 🧹 Drained. --
end

function ENT:OnRemove() -- 🧹 Cleanup timer. --
    timer.Remove("VCity_DropSmoke_" .. self:EntIndex()) -- 🧹 Smoke. --
end
