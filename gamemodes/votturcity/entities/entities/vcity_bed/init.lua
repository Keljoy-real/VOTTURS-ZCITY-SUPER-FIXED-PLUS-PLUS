-- 🛏️ VotturCity | vcity_bed | init.lua 🛏️ --
AddCSLuaFile("shared.lua") -- 📤 Share. --
AddCSLuaFile("cl_init.lua") -- 📤 Client. --
include("shared.lua") -- 📥 Load. --

function ENT:Initialize() -- 🌱 Init. --
    self:SetModel("models/props_c17/furnituremattress001a.mdl") -- 🛏️ Mattress. --
    self:PhysicsInit(SOLID_VPHYSICS) -- 🧱 Physics. --
    self:SetMoveType(MOVETYPE_VPHYSICS) -- 🌍 Physical. --
    self:SetSolid(SOLID_VPHYSICS) -- 🧱 Solid. --
    self:SetUseType(SIMPLE_USE) -- 🤝 Use. --
    local phys = self:GetPhysicsObject() if IsValid(phys) then phys:Wake() end -- ⏰ Wake. --
end

-- 🤝 Set personal respawn here (one bed per player, latest wins). --
function ENT:Use(activator) -- 🤝 Interact. --
    if not VCity.IsLivePlayer(activator) or not activator:Alive() then return end -- 🛑 Validate. --
    if (self.VCity_NextUse or 0) > CurTime() then return end -- ⏱️ Cooldown. --
    self.VCity_NextUse = CurTime() + 1 -- ⏱️ Set. --
    activator.VCity_BedPos = self:GetPos() + Vector(0, 0, 30) -- 🛏️ Save spot. --
    activator.VCity_BedAng = activator:GetAngles() -- 🔄 Save angle. --
    VCity.Notify(activator, 1, "🛏️ Respawn set here!") -- 📝 Confirm. --
    activator:EmitSound("items/ammo_pickup.wav", 55, 120) -- 🔊 Cue. --
end

-- 🪝 Respawn at bed if set (hook runs after PlayerSpawn positioning? use PlayerSpawn override order). --
hook.Add("PlayerSpawn", "VCity_BedSpawn", function(ply)
    timer.Simple(0, function() -- ⏳ After base spawn. --
        if not IsValid(ply) or not ply:Alive() then return end -- 🛑 Validate. --
        if ply.VCity_BedPos then -- 🛏️ Has bed. --
            -- 🛡️ Only teleport if bed entity still exists nearby (anti-grief teleport). --
            local ok = false -- 📍 Valid? --
            for _, b in ipairs(ents.FindByClass("vcity_bed")) do -- 🔁 Beds. --
                if b:GetPos():DistToSqr(ply.VCity_BedPos) < (100 ^ 2) then ok = true break end -- ✅ Near a bed. --
            end
            if ok then ply:SetPos(ply.VCity_BedPos) end -- 📍 Move. --
        end
    end)
end)
