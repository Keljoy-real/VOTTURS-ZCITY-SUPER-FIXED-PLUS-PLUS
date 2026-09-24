-- 🔫 VotturCity | vcity_dmr | shared.lua 🔫 --
-- 🔫 DMR: slow, precise, punishing. Rewards aim. --
SWEP.Base = "vcity_base" -- 🧱 Derive. --
SWEP.PrintName = "DMR" -- 🏷️ Name. --
SWEP.Slot = 3 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_rif_ak47.mdl" -- 👁️ View (reuse AK to avoid missing models). --
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl" -- 🌍 World. --
SWEP.Primary = { Sound = "weapons/ar2/fire1.wav", Automatic = false } -- 🔊 Semi. --
SWEP.HoldType = "ar2" -- 🧍 Hold. --
SWEP.UseHands = true -- 🙌 Hands. --
SWEP.VC_Damage = 45 -- 🩸 Damage. --
SWEP.VC_AmmoItem = "ammo_rifle" -- 🎒 Ammo. --
SWEP.VC_ClipSize = 10 -- 🔢 Mag. --
SWEP.VC_Auto = false -- 🔁 Semi. --
SWEP.VC_SpreadHip = 0.06 -- 🎯 Hip (bad). --
SWEP.VC_SpreadAim = 0.004 -- 🎯 Aim (laser). --
SWEP.VC_Recoil = 3.2 -- 🎯 Kick. --
SWEP.VC_RPM = 120 -- ⏱️ Slow. --
SWEP.VC_ReloadTime = 2.8 -- ⏱️ Reload. --
SWEP.VC_AimFOV = 55 -- 🔭 Zoomy. --
function SWEP:Initialize() self:SetHoldType("ar2") self:SetClip1(self.VC_ClipSize) self:SetVC_Cond(100) self:SetVC_ReloadEnd(0) end -- ⚙️ Init. --
