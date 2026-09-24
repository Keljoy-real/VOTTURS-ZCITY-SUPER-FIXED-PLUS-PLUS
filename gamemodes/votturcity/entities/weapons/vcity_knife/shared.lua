-- 🔪 VotturCity | vcity_knife | shared.lua 🔪 --
-- 🔪 Melee: short range trace, slash damage, limb wounds. Light + fast. --
SWEP.Category = "VotturCity" -- 🗂️ Category. --
SWEP.PrintName = "Knife" -- 🏷️ Name. --
SWEP.Slot = 0 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_knife_t.mdl" -- 👁️ View. --
SWEP.WorldModel = "models/weapons/w_knife_t.mdl" -- 🌍 World. --
SWEP.HoldType = "knife" -- 🧍 Hold. --
SWEP.Primary = { Automatic = true } -- 🔁 Hold to swing (table form avoids nil index). --
SWEP.Secondary = { Automatic = false } -- 🙅 No alt-fire. --

-- ⚙️ Melee stats. --
SWEP.VC_Damage = 25 -- 🩸 Damage. --
SWEP.VC_Range = 70 -- 📏 Reach. --
SWEP.VC_Delay = 0.5 -- ⏱️ Swing interval. --

function SWEP:Initialize()
    self:SetHoldType("knife") -- 🔪 Hold. --
end

-- 🔪 Swing: server-side trace + damage with slash type. --
function SWEP:PrimaryAttack()
    local owner = self:GetOwner() -- 👤 Owner. --
    if not IsValid(owner) or not owner:Alive() then return end -- 🛑 Dead. --
    if VCity and VCity.State_Get and VCity.State_IsDown(owner) then return end -- 😵 KO can't swing. --
    self:SetNextPrimaryFire(CurTime() + (self.VC_Delay or 0.5)) -- ⏱️ Rate. --
    -- 🎬 Swing anim both realms. --
    self:SendWeaponAnim(ACT_VM_HITCENTER) -- 🎬 Anim. --
    owner:SetAnimation(PLAYER_ATTACK1) -- 🧍 Player anim. --
    if CLIENT then return end -- 💻 Server does damage. --
    owner:EmitSound("weapons/knife/knife_slash" .. math.random(1, 2) .. ".wav", 65, 100) -- 🔊 Whoosh. --
    -- 🔍 Lag-compensated melee trace. --
    owner:LagCompensation(true) -- 🕐 Compensate. --
    local tr = util.TraceLine({ -- 🔍 Trace. --
        start = owner:GetShootPos(), -- 📍 From eyes. --
        endpos = owner:GetShootPos() + owner:GetAimVector() * (self.VC_Range or 70), -- 📍 Forward. --
        filter = owner, -- 🙅 Ignore self. --
        mask = MASK_SHOT_HULL, -- 🎯 Hit players + props. --
    })
    owner:LagCompensation(false) -- 🕐 End. --
    if tr.Hit and IsValid(tr.Entity) then -- 🎯 Hit something. --
        local dmg = DamageInfo() -- 📦 Damage. --
        dmg:SetAttacker(owner) -- 👤 Attacker. --
        dmg:SetInflictor(self) -- 🔪 Weapon. --
        dmg:SetDamage(self.VC_Damage or 25) -- 🩸 Amount. --
        dmg:SetDamageType(DMG_SLASH) -- 🔪 Slash (classifier picks SLASH). --
        dmg:SetDamagePosition(tr.HitPos) -- 📍 Position. --
        tr.Entity:TakeDamageInfo(dmg) -- 🩸 Apply (routes via sv_damage!). --
        owner:EmitSound("weapons/knife/knife_hitwall1.wav", 65, 100) -- 🔊 Hit. --
    end
end

function SWEP:SecondaryAttack() end -- 🙅 No alt. --
function SWEP:Reload() end -- 🙅 No reload. --
