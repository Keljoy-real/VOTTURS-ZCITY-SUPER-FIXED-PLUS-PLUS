-- ⚡ VotturCity | vcity_taser | shared.lua ⚡ --
-- ⚡ Taser: melee-range shock. Heavy pain + short KO on charged hit, then long recharge. --
SWEP.Category = "VotturCity" -- 🗂️ Category. --
SWEP.PrintName = "Taser" -- 🏷️ Name. --
SWEP.Slot = 1 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_pistol.mdl" -- 👁️ View (reused). --
SWEP.WorldModel = "models/weapons/w_pistol.mdl" -- 🌍 World. --
SWEP.HoldType = "pistol" -- 🧍 Hold. --
SWEP.Primary = { Automatic = false } -- 🔁 Single shot. --
SWEP.Secondary = { Automatic = false } -- 🙅 No alt. --
SWEP.VC_Range = 90 -- 📏 Reach. --
SWEP.VC_Recharge = 8 -- ⏱️ Seconds between zaps. --
SWEP.VC_NextZap = 0 -- ⏱️ Next allowed. --

function SWEP:Initialize() -- ⚙️ Init. --
    self:SetHoldType("pistol") -- 🔫 Hold. --
end

-- ⚡ Zap: trace + shock (pain spike, burn wound, KO if head + injured). --
function SWEP:PrimaryAttack() -- ⚡ Fire. --
    local owner = self:GetOwner() -- 👤 Owner. --
    if not IsValid(owner) or not owner:Alive() then return end -- 🛑 Dead. --
    if VCity and VCity.State_Get and VCity.State_IsDown(owner) then return end -- 😵 KO can't. --
    if CurTime() < (self.VC_NextZap or 0) then return end -- ⏱️ Recharging. --
    self:SetNextPrimaryFire(CurTime() + 0.6) -- ⏱️ Rate. --
    self.VC_NextZap = CurTime() + (self.VC_Recharge or 8) -- ⏱️ Recharge. --
    owner:SetAnimation(PLAYER_ATTACK1) -- 🧍 Anim. --
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK) -- 🎬 Anim. --
    if CLIENT then return end -- 💻 Server damage. --
    owner:EmitSound("weapons/stunstick/stunstick_flick1.wav", 65, 100) -- 🔊 Charge. --
    owner:LagCompensation(true) -- 🕐 Compensate. --
    local tr = util.TraceLine({ start = owner:GetShootPos(), endpos = owner:GetShootPos() + owner:GetAimVector() * (self.VC_Range or 90), filter = owner, mask = MASK_SHOT_HULL }) -- 🔍 Trace. --
    owner:LagCompensation(false) -- 🕐 End. --
    if tr.Hit and IsValid(tr.Entity) and tr.Entity:IsPlayer() then -- 🎯 Hit player! --
        local tgt = tr.Entity -- 👤 Target. --
        tgt:EmitSound("weapons/stunstick/stunstick_impact1.wav", 70, 100) -- 🔊 Zap! --
        -- 🩸 Shock damage (small) + huge pain (stun feel). --
        local dmg = DamageInfo() -- 📦 Damage. --
        dmg:SetAttacker(owner) dmg:SetInflictor(self) dmg:SetDamage(10) dmg:SetDamageType(DMG_SHOCK) dmg:SetDamagePosition(tr.HitPos) -- 🩸 Shock. --
        tgt:TakeDamageInfo(dmg) -- 🩸 Apply (pain via dispatcher). --
        tgt.VCity_Pain = math.Clamp((tgt.VCity_Pain or 0) + 45, 0, 100) -- 😖 Stun pain. --
        -- 😵 KO if target already hurting (headshot or low HP = drop). --
        local hg = tgt.VCity_LastHitgroup -- 🎯 Hitgroup cache (set by ScalePlayerDamage). --
        if (hg == HITGROUP_HEAD and tgt:Health() < 60) or tgt:Health() < 30 then -- 😵 Finish. --
            VCity.State_Knockout(tgt, 12) -- 😵 Short KO. --
            VCity.Notify(tgt, 2, "⚡ Tased!") -- 📝 Feedback. --
        else VCity.Notify(tgt, 2, "⚡ Shocked!") end -- 📝 Feedback. --
        VCity.Vitals_Sync(tgt) -- 📡 Sync. --
    elseif tr.Hit then -- 🧱 Hit wall/prop: spark. --
        local ed = EffectData() ed:SetOrigin(tr.HitPos) ed:SetNormal(tr.HitNormal) util.Effect("StunstickImpact", ed, true, true) -- ✨ Spark. --
    end
end
function SWEP:SecondaryAttack() end -- 🙅 No alt. --
function SWEP:Reload() end -- 🙅 No reload. --
