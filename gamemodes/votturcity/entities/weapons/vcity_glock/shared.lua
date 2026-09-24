-- 🔫 VotturCity | vcity_glock | shared.lua 🔫 --
-- 🔫 9mm sidearm: light, fast, weak. Starter pistol. --
SWEP.Base = "vcity_base" -- 🧱 Derive. --
SWEP.PrintName = "9mm Pistol" -- 🏷️ Name. --
SWEP.Slot = 1 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_pistol.mdl" -- 👁️ View. --
SWEP.WorldModel = "models/weapons/w_pistol.mdl" -- 🌍 World. --
SWEP.Primary = { Sound = "weapons/pistol/pistol_fire2.wav", Automatic = false } -- 🔊 Engine primary table. --
SWEP.HoldType = "pistol" -- 🧍 Hold. --
SWEP.VC_Damage = 18 -- 🩸 Damage. --
SWEP.VC_AmmoItem = "ammo_9mm" -- 🎒 Ammo. --
SWEP.VC_ClipSize = 12 -- 🔢 Mag. --
SWEP.VC_Auto = false -- 🔁 Semi. --
SWEP.VC_SpreadHip = 0.035 -- 🎯 Hip. --
SWEP.VC_SpreadAim = 0.010 -- 🎯 Aim. --
SWEP.VC_Recoil = 1.0 -- 🎯 Recoil. --
SWEP.VC_RPM = 380 -- ⏱️ RPM. --
SWEP.VC_ReloadTime = 1.6 -- ⏱️ Reload. --
SWEP.VC_AimFOV = 65 -- 🔭 FOV. --
function SWEP:Initialize() self:SetHoldType("pistol") self:SetClip1(self.VC_ClipSize) self:SetVC_Cond(100) self:SetVC_ReloadEnd(0) end -- ⚙️ Init. --
