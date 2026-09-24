-- 🔫 VotturCity | vcity_akm | shared.lua 🔫 --
-- 🔫 Assault rifle: automatic, hard-hitting, more recoil. --
SWEP.Base = "vcity_base" -- 🧱 Derive. --
SWEP.PrintName = "Assault Rifle" -- 🏷️ Name. --
SWEP.Slot = 2 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_rif_ak47.mdl" -- 👁️ View. --
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl" -- 🌍 World. --
SWEP.Primary.Sound = "weapons/ak47/ak47-1.wav" -- 🔊 Sound (fallback to HL2 if missing). --
SWEP.HoldType = "ar2" -- 🧍 Hold. --
SWEP.Primary = { Sound = "weapons/ak47/ak47-1.wav", Automatic = true } -- 🔊 Engine needs Primary table for auto. --
SWEP.VC_Damage = 26 -- 🩸 Damage. --
SWEP.VC_AmmoItem = "ammo_rifle" -- 🎒 Ammo. --
SWEP.VC_ClipSize = 30 -- 🔢 Mag. --
SWEP.VC_Auto = true -- 🔁 Auto. --
SWEP.VC_SpreadHip = 0.05 -- 🎯 Hip. --
SWEP.VC_SpreadAim = 0.016 -- 🎯 Aim. --
SWEP.VC_Recoil = 1.8 -- 🎯 Recoil. --
SWEP.VC_RPM = 550 -- ⏱️ RPM. --
SWEP.VC_ReloadTime = 2.4 -- ⏱️ Reload. --
SWEP.VC_AimFOV = 60 -- 🔭 FOV. --
function SWEP:Initialize() self:SetHoldType("ar2") self:SetClip1(self.VC_ClipSize) self:SetVC_Cond(100) self:SetVC_ReloadEnd(0) end -- ⚙️ Init. --
-- 🔁 Automatic fire support. --
function SWEP:SetupDataTables() self:NetworkVar("Float", 0, "VC_Cond") self:NetworkVar("Bool", 0, "VC_Aim") self:NetworkVar("Float", 1, "VC_ReloadEnd") end -- 📡 Netvars. --
