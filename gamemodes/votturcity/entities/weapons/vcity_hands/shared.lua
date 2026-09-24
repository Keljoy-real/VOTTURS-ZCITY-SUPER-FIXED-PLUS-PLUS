-- 🙌 VotturCity | vcity_hands | shared.lua 🙌 --
-- 🙌 Fists: weak blunt damage + interaction helper. Always available. --
SWEP.Category = "VotturCity" -- 🗂️ Category. --
SWEP.PrintName = "Hands" -- 🏷️ Name. --
SWEP.Slot = 0 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_arms.mdl" -- 👁️ Arms. --
SWEP.WorldModel = "" -- 🌍 No world model. --
SWEP.HoldType = "normal" -- 🧍 Hold. --
SWEP.Primary = { Automatic = true } -- 🔁 Hold to punch (table form avoids nil index). --
SWEP.Secondary = { Automatic = false } -- 🙅 No alt-fire. --
SWEP.VC_Damage = 12 -- 🩸 Punch damage. --
SWEP.VC_Range = 60 -- 📏 Reach. --
SWEP.VC_Delay = 0.45 -- ⏱️ Rate. --

function SWEP:Initialize()
    self:SetHoldType("normal") -- 🙌 Hold. --
end

-- 👊 Punch: blunt damage, small pain, tiny fracture chance via dispatcher. --
function SWEP:PrimaryAttack()
    local owner = self:GetOwner() -- 👤 Owner. --
    if not IsValid(owner) or not owner:Alive() then return end -- 🛑 Dead. --
    if VCity and VCity.State_Get and VCity.State_IsDown(owner) then return end -- 😵 KO can't punch. --
    self:SetNextPrimaryFire(CurTime() + (self.VC_Delay or 0.45)) -- ⏱️ Rate. --
    owner:SetAnimation(PLAYER_ATTACK1) -- 🧍 Anim. --
    if CLIENT then return end -- 💻 Server damage. --
    owner:EmitSound("weapons/knife/knife_slash" .. math.random(1, 2) .. ".wav", 55, 120) -- 🔊 Whoosh. --
    owner:LagCompensation(true) -- 🕐 Compensate. --
    local tr = util.TraceLine({ -- 🔍 Trace. --
        start = owner:GetShootPos(), -- 📍 Eyes. --
        endpos = owner:GetShootPos() + owner:GetAimVector() * (self.VC_Range or 60), -- 📍 Forward. --
        filter = owner, -- 🙅 Self. --
        mask = MASK_SHOT_HULL, -- 🎯 Hull. --
    })
    owner:LagCompensation(false) -- 🕐 End. --
    if tr.Hit and IsValid(tr.Entity) then -- 🎯 Hit. --
        local dmg = DamageInfo() -- 📦 Damage. --
        dmg:SetAttacker(owner) -- 👤 Attacker. --
        dmg:SetInflictor(self) -- 🙌 Hands. --
        dmg:SetDamage(self.VC_Damage) -- 🩸 Amount. --
        dmg:SetDamageType(DMG_CLUB) -- 🔨 Blunt. --
        dmg:SetDamagePosition(tr.HitPos) -- 📍 Pos. --
        tr.Entity:TakeDamageInfo(dmg) -- 🩸 Apply. --
        owner:EmitSound("physics/body/body_medium_impact_soft" .. math.random(1, 7) .. ".wav", 60, 100) -- 🔊 Thud. --
    end
end

function SWEP:SecondaryAttack() end -- 🙅 No alt. --
function SWEP:Reload() end -- 🙅 No reload. --
-- 🤝 Hands also serve as the interaction tool hint (E does the real work). --
