-- 🔫 VotturCity | vcity_shotgun | shared.lua 🔫 --
-- 🔫 Pump shotgun: 8 pellets, devastating close, weak far (damage falloff via pellets). --
SWEP.Base = "vcity_base" -- 🧱 Derive. --
SWEP.PrintName = "Shotgun" -- 🏷️ Name. --
SWEP.Slot = 2 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_shot_m3super90.mdl" -- 👁️ View. --
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl" -- 🌍 World. --
SWEP.Primary = { Sound = "weapons/shotgun/shotgun_fire6.wav", Automatic = false } -- 🔊 Engine primary table. --
SWEP.HoldType = "shotgun" -- 🧍 Hold. --
SWEP.VC_Damage = 9 -- 🩸 Per-pellet damage (x8 = 72 close). --
SWEP.VC_AmmoItem = "ammo_shell" -- 🎒 Ammo. --
SWEP.VC_ClipSize = 6 -- 🔢 Tube. --
SWEP.VC_Auto = false -- 🔁 Pump. --
SWEP.VC_SpreadHip = 0.07 -- 🎯 Hip. --
SWEP.VC_SpreadAim = 0.05 -- 🎯 Aim (shotguns stay wide). --
SWEP.VC_Recoil = 3.0 -- 🎯 Heavy kick. --
SWEP.VC_RPM = 70 -- ⏱️ Slow. --
SWEP.VC_ReloadTime = 2.8 -- ⏱️ Reload. --
SWEP.VC_Pellets = 8 -- 🔫 Pellets. --
SWEP.VC_AimFOV = 65 -- 🔭 FOV. --
function SWEP:Initialize() self:SetHoldType("shotgun") self:SetClip1(self.VC_ClipSize) self:SetVC_Cond(100) self:SetVC_ReloadEnd(0) end -- ⚙️ Init. --
