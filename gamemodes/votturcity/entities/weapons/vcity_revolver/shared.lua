-- 🔫 VotturCity | vcity_revolver | shared.lua 🔫 --
-- 🔫 Revolver: 6 shots of .44 thunder. Slow reload, big limb wounds. --
SWEP.Base = "vcity_base" -- 🧱 Derive. --
SWEP.PrintName = "Revolver" -- 🏷️ Name. --
SWEP.Slot = 1 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_357.mdl" -- 👁️ View. --
SWEP.WorldModel = "models/weapons/w_357.mdl" -- 🌍 World. --
SWEP.Primary = { Sound = "weapons/357/357_fire2.wav", Automatic = false } -- 🔊 Boom. --
SWEP.HoldType = "revolver" -- 🧍 Hold. --
SWEP.UseHands = true -- 🙌 Hands. --
SWEP.VC_Damage = 38 -- 🩸 Damage. --
SWEP.VC_AmmoItem = "ammo_44" -- 🎒 Ammo. --
SWEP.VC_ClipSize = 6 -- 🔢 Cylinder. --
SWEP.VC_Auto = false -- 🔁 Single. --
SWEP.VC_SpreadHip = 0.03 -- 🎯 Hip. --
SWEP.VC_SpreadAim = 0.008 -- 🎯 Aim. --
SWEP.VC_Recoil = 2.6 -- 🎯 Kick. --
SWEP.VC_RPM = 130 -- ⏱️ Slow. --
SWEP.VC_ReloadTime = 3.0 -- ⏱️ Reload. --
SWEP.VC_AimFOV = 65 -- 🔭 FOV. --
function SWEP:Initialize() self:SetHoldType("revolver") self:SetClip1(self.VC_ClipSize) self:SetVC_Cond(100) self:SetVC_ReloadEnd(0) end -- ⚙️ Init. --
