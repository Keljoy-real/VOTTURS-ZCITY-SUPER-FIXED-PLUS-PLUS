-- 🔪 VotturCity | vcity_machete | shared.lua 🔪 --
-- 🔪 Machete: slow, heavy slash. Wounds + fracture arms. --
SWEP.Category = "VotturCity" -- 🗂️ Category. --
SWEP.PrintName = "Machete" -- 🏷️ Name. --
SWEP.Slot = 0 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_crowbar.mdl" -- 👁️ View (reused stock). --
SWEP.WorldModel = "models/weapons/w_crowbar.mdl" -- 🌍 World. --
SWEP.HoldType = "melee" -- 🧍 Hold. --
SWEP.Primary = { Automatic = true } -- 🔁 Swing. --
SWEP.Secondary = { Automatic = false } -- 🙅 No alt. --
SWEP.VC_Damage = 38 -- 🩸 Heavy slash. --
SWEP.VC_Range = 78 -- 📏 Reach. --
SWEP.VC_Delay = 0.85 -- ⏱️ Slow swing. --

function SWEP:Initialize() self:SetHoldType("melee") end -- ⚙️ Init. --

function SWEP:PrimaryAttack() -- 🔪 Swing. --
    local owner = self:GetOwner() -- 👤 Owner. --
    if not IsValid(owner) or not owner:Alive() then return end -- 🛑 Dead. --
    if VCity and VCity.State_Get and VCity.State_IsDown(owner) then return end -- 😵 KO can't. --
    self:SetNextPrimaryFire(CurTime() + (self.VC_Delay or 0.85)) -- ⏱️ Rate. --
    self:SendWeaponAnim(ACT_VM_HITCENTER) -- 🎬 Anim. --
    owner:SetAnimation(PLAYER_ATTACK1) -- 🧍 Anim. --
    if CLIENT then return end -- 💻 Server damage. --
    owner:EmitSound("weapons/knife/knife_slash" .. math.random(1, 2) .. ".wav", 65, 90) -- 🔊 Whoosh. --
    owner:LagCompensation(true) -- 🕐 Compensate. --
    local tr = util.TraceLine({ start = owner:GetShootPos(), endpos = owner:GetShootPos() + owner:GetAimVector() * (self.VC_Range or 78), filter = owner, mask = MASK_SHOT_HULL }) -- 🔍 Trace. --
    owner:LagCompensation(false) -- 🕐 End. --
    if tr.Hit and IsValid(tr.Entity) then -- 🎯 Hit. --
        local dmg = DamageInfo() dmg:SetAttacker(owner) dmg:SetInflictor(self) dmg:SetDamage(self.VC_Damage) dmg:SetDamageType(DMG_SLASH) dmg:SetDamagePosition(tr.HitPos) -- 🩸 Slash. --
        tr.Entity:TakeDamageInfo(dmg) -- 🩸 Apply. --
        owner:EmitSound("weapons/knife/knife_hitwall1.wav", 65, 95) -- 🔊 Hit. --
    end
end
function SWEP:SecondaryAttack() end -- 🙅 No alt. --
function SWEP:Reload() end -- 🙅 No reload. --
