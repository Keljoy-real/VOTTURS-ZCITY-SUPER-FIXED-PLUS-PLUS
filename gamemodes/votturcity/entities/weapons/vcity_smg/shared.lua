-- 🔫 VotturCity | vcity_smg | shared.lua 🔫 --
-- 🔫 SMG: hose 9mm, fast, hungry, shaky at range. --
SWEP.Base = "vcity_base" -- 🧱 Derive. --
SWEP.PrintName = "SMG" -- 🏷️ Name. --
SWEP.Slot = 2 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_smg1.mdl" -- 👁️ View. --
SWEP.WorldModel = "models/weapons/w_smg1.mdl" -- 🌍 World. --
SWEP.Primary = { Sound = "weapons/smg1/smg1_fire1.wav", Automatic = true } -- 🔊 Auto. --
SWEP.HoldType = "smg" -- 🧍 Hold. --
SWEP.UseHands = true -- 🙌 Hands. --
SWEP.VC_Damage = 15 -- 🩸 Damage. --
SWEP.VC_AmmoItem = "ammo_9mm" -- 🎒 Ammo. --
SWEP.VC_ClipSize = 32 -- 🔢 Mag. --
SWEP.VC_Auto = true -- 🔁 Auto. --
SWEP.VC_SpreadHip = 0.055 -- 🎯 Hip. --
SWEP.VC_SpreadAim = 0.022 -- 🎯 Aim. --
SWEP.VC_Recoil = 1.3 -- 🎯 Recoil. --
SWEP.VC_RPM = 750 -- ⏱️ RPM. --
SWEP.VC_ReloadTime = 2.2 -- ⏱️ Reload. --
SWEP.VC_AimFOV = 62 -- 🔭 FOV. --
function SWEP:Initialize() self:SetHoldType("smg") self:SetClip1(self.VC_ClipSize) self:SetVC_Cond(100) self:SetVC_ReloadEnd(0) end -- ⚙️ Init. --
