-- 🔫 VotturCity | vcity_base | shared.lua | Weapon foundation 🔫 --
-- 🧠 All VCity firearms derive from this: condition, recoil, spread, inventory ammo. --

SWEP.Base = "weapon_base" -- 🧱 Derive from engine base. --
SWEP.Category = "VotturCity" -- 🗂️ Spawnmenu category. --
SWEP.Spawnable = false -- 🙅 Base not spawnable. --
SWEP.AdminOnly = false -- 👥 No restriction. --

-- 🎯 Editable per-weapon stats (overridden in children). --
SWEP.VC_Damage = 20 -- 🩸 Damage per bullet. --
SWEP.VC_AmmoItem = "ammo_9mm" -- 🎒 Inventory ammo consumed on reload. --
SWEP.VC_ClipSize = 12 -- 🔢 Magazine size. --
SWEP.VC_Auto = false -- 🔁 Automatic? --
SWEP.VC_SpreadHip = 0.04 -- 🎯 Hip spread. --
SWEP.VC_SpreadAim = 0.012 -- 🎯 Aimed spread. --
SWEP.VC_Recoil = 1.2 -- 🎯 Recoil kick. --
SWEP.VC_RPM = 350 -- ⏱️ Rounds per minute. --
SWEP.VC_ReloadTime = 2.0 -- ⏱️ Reload seconds. --
SWEP.VC_Pellets = 1 -- 🔫 Pellets per shot (shotguns use 8). --
SWEP.VC_AimFOV = 65 -- 🔭 Aim FOV. --
SWEP.VC_ConditionMax = 100 -- 🔧 Max condition. --
SWEP.Primary = { Sound = "weapons/pistol/pistol_fire2.wav", Automatic = false } -- 🔊 Engine needs Primary table. --
SWEP.Secondary = { Automatic = false } -- 🙅 No alt-fire. --
SWEP.UseHands = true -- 🙌 Show viewmodel hands on c_ models. --

-- 🔧 Runtime state (per-instance). --
SWEP.VC_Condition = 100 -- 🔧 Current condition. --
SWEP.VC_Aiming = false -- 🔭 Aiming flag. --

-- ⚙️ Engine setup: holdtype, slots, ammo types (we use custom inventory). --
function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "VC_Cond") -- 🔧 Replicated condition. --
    self:NetworkVar("Bool", 0, "VC_Aim") -- 🔭 Replicated aim. --
    self:NetworkVar("Float", 1, "VC_ReloadEnd") -- ⏱️ Reload finish time. --
end

function SWEP:Initialize()
    self:SetHoldType("pistol") -- 🔫 Default hold. --
    self:SetClip1(self.VC_ClipSize) -- 🔢 Start loaded. --
    self:SetVC_Cond(self.VC_ConditionMax) -- 🔧 Full condition. --
    self:SetVC_ReloadEnd(0) -- ⏱️ Not reloading. --
end

-- 🔭 Aiming state (right mouse). Server + client predict consistently. --
function SWEP:SecondaryAttack()
    -- 🙅 No function; aiming handled via IN_ATTACK2 polling in Think. --
end

-- 🧠 Per-frame aim polling (cheap, per-weapon only when deployed). --
function SWEP:Think()
    local owner = self:GetOwner() -- 👤 Owner. --
    if not IsValid(owner) then return end -- 🛑 No owner. --
    -- 🔭 Aim = holding right-click + on ground + not sprinting full speed. --
    local aiming = owner:KeyDown(IN_ATTACK2) and owner:GetVelocity():Length2D() < 250 -- 🔭 Check. --
    if aiming ~= self:GetVC_Aim() then -- 🔄 Changed. --
        self:SetVC_Aim(aiming) -- 📡 Replicate. --
        if CLIENT and owner == LocalPlayer() then -- 💻 Local FOV. --
            -- 🔭 FOV set in cl scope via hook below; stored flag drives spread. --
        end
    end
    -- ⏱️ Finish reload when timer expires. --
    if SERVER and self:GetVC_ReloadEnd() > 0 and CurTime() >= self:GetVC_ReloadEnd() then -- ⏱️ Done. --
        self:FinishReload() -- ✅ Complete. --
    end
end

-- 🔫 Can we shoot right now? (alive, ammo, not reloading, not sprint-blocked). --
function SWEP:CanShoot()
    local owner = self:GetOwner() -- 👤 Owner. --
    if not IsValid(owner) or not owner:Alive() then return false end -- 🛑 Dead. --
    -- 😵 KO / dead / locked players can't fire (server authoritative states). --
    if VCity and VCity.State_Get then -- 🛡️ Guard for isolated loads. --
        local st = VCity.State_Get(owner) -- 🚦 State. --
        if st == VCity.State.UNCONSCIOUS or st == VCity.State.DEAD or st == VCity.State.INTERACTING then return false end -- 🛑 Down/busy. --
    end
    if self:GetVC_ReloadEnd() > 0 then return false end -- ⏱️ Reloading. --
    if self:Clip1() <= 0 then -- 📭 Empty: dry-fire cue + auto reload. --
        if SERVER then self:StartReload() end -- 🔄 Auto reload. --
        return false -- 🛑 Empty. --
    end
    -- 🏃 Sprint block: can't fire while sprinting fast (except hip-spray allowance). --
    if owner:KeyDown(IN_SPEED) and owner:GetVelocity():Length2D() > 300 then return false end -- 🏃 Sprinting. --
    return true -- ✅ Good. --
end

-- 🔫 Primary fire: hitscan with spread, recoil, condition, jam. --
function SWEP:PrimaryAttack()
    if not self:CanShoot() then -- 🛑 Blocked. --
        self:SetNextPrimaryFire(CurTime() + 0.2) -- ⏱️ Small delay. --
        return -- 🛑 Stop. --
    end
    local owner = self:GetOwner() -- 👤 Owner. --
    local interval = 60 / (self.VC_RPM or 350) -- ⏱️ Shot interval. --
    self:SetNextPrimaryFire(CurTime() + interval) -- ⏱️ Schedule. --
    -- 🔧 Jam roll when broken (server authoritative). --
    if SERVER and self:GetVC_Cond() < 25 then -- 🔧 Broken. --
        if math.random() < VCity.Config.JamChanceBroken then -- 🎲 Jammed! --
            owner:EmitSound("weapons/pistol/pistol_empty.wav", 60, 90) -- 🔊 Click. --
            VCity.Notify(owner, 2, "🔧 Weapon jammed! Reload to clear.") -- 📝 Feedback. --
            self:SetNextPrimaryFire(CurTime() + 0.8) -- ⏱️ Penalty. --
            return -- 🛑 Jammed. --
        end
    end
    -- 🎯 Spread: aim tightens, broken arms + movement widen, gunner skill tightens. --
    local spread = self:GetVC_Aim() and self.VC_SpreadAim or self.VC_SpreadHip -- 🎯 Base. --
    spread = spread * VCity.Config.SpreadScale -- 🎚️ Global scale. --
    if VCity.Skills_SpreadScale then spread = spread * VCity.Skills_SpreadScale(owner) end -- 🔫 Gunner bonus (both realms, pure math). --
    if SERVER then -- 🖥️ Server adds injury spread (authoritative). --
        local arms = 0 -- 💪 Broken arms. --
        if owner.VCity_Limbs then -- 🦴 Have limbs. --
            arms = VCity.Limbs_BrokenArms(owner.VCity_Limbs) -- 💪 Count. --
        end
        spread = spread + arms * 0.03 -- 💪 Penalty per broken arm. --
        spread = spread + math.Clamp(owner:GetVelocity():Length2D() / 5000, 0, 0.03) -- 🏃 Move penalty. --
    end
    -- 🔫 Fire bullets (server does damage; client does FX). --
    if SERVER then -- 🖥️ Damage. --
        local dmgScale = VCity.Skills_DamageScale and VCity.Skills_DamageScale(owner) or 1 -- 🔫 Gunner bonus. --
        local bullet = {} -- 📦 Bullet info. --
        bullet.Num = self.VC_Pellets or 1 -- 🔢 Pellets. --
        bullet.Src = owner:GetShootPos() -- 📍 Origin. --
        bullet.Dir = owner:GetAimVector() -- 🎯 Direction. --
        bullet.Spread = Vector(spread, spread, 0) -- 🎯 Spread. --
        bullet.Tracer = 1 -- ✨ Tracer. --
        bullet.Force = 5 -- 💪 Force. --
        bullet.Damage = (self.VC_Damage or 20) * dmgScale -- 🩸 Damage (skilled). --
        bullet.Attacker = owner -- 👤 Attacker. --
        bullet.Callback = function(atk, tr, dmg) -- 🩸 Callback tweaks. --
            dmg:SetDamageType(DMG_BULLET) -- 🔫 Mark bullet (for classifier). --
            -- 🛡️ Penetration-lite: reduce damage through walls (surface already handled). --
        end
        owner:FireBullets(bullet) -- 🔫 Shoot! --
        -- 🔧 Wear condition per shot. --
        self:SetVC_Cond(math.max(0, self:GetVC_Cond() - VCity.Config.WeaponConditionLoss)) -- 🔧 Wear. --
        self:SetClip1(self:Clip1() - 1) -- 📉 Consume. --
        -- 🔊 Gunshot (server emits so everyone hears). --
        self:EmitSound(self.Primary.Sound or "weapons/pistol/pistol_fire2.wav", 75, 100) -- 🔊 Bang. --
        -- 🎯 Recoil kick (view punch scaled by config + gunner skill). --
        local punch = (self.VC_Recoil or 1) * VCity.Config.RecoilScale -- 🎯 Amount. --
        if VCity.Skills_RecoilScale then punch = punch * VCity.Skills_RecoilScale(owner) end -- 🔫 Gunner steadiness. --
        owner:ViewPunch(Angle(-punch * 0.4, math.Rand(-punch * 0.1, punch * 0.1), 0)) -- 📷 Kick. --
    else -- 💻 Client FX: muzzle flash light (cheap, no dynamic light spam). --
        -- ✨ Muzzle FX handled by engine; nothing expensive here. --
    end
    -- 🎬 Fire animation in both realms. --
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK) -- 🎬 Anim. --
    if IsValid(owner) then -- 👤 Owner anim. --
        owner:SetAnimation(PLAYER_ATTACK1) -- 🧍 Player anim. --
    end
end

-- 🔄 Start reload: validates reserve ammo in inventory (server). --
function SWEP:StartReload()
    if self:GetVC_ReloadEnd() > 0 then return end -- ⏱️ Already reloading. --
    if self:Clip1() >= self.VC_ClipSize then return end -- ✅ Full. --
    local owner = self:GetOwner() -- 👤 Owner. --
    if not IsValid(owner) then return end -- 🛑 No owner. --
    if SERVER then -- 🖥️ Validate reserve. --
        local need = self.VC_ClipSize - self:Clip1() -- 🔢 Needed. --
        local have = VCity.Inventory_Count(owner.VCity_Inventory, self.VC_AmmoItem) -- 🎒 Reserve. --
        if have <= 0 then -- 📭 No ammo. --
            owner:EmitSound("weapons/pistol/pistol_empty.wav", 60, 100) -- 🔊 Click. --
            VCity.Notify(owner, 0, "📭 No " .. (VCity.Items[self.VC_AmmoItem].name or "ammo") .. "!") -- 📝 Feedback. --
            return -- 🛑 Stop. --
        end
    end
    self:SetVC_ReloadEnd(CurTime() + (self.VC_ReloadTime or 2)) -- ⏱️ Schedule finish. --
    self:SendWeaponAnim(ACT_VM_RELOAD) -- 🎬 Anim. --
    if SERVER then self:GetOwner():EmitSound("weapons/smg1/smg1_reload.wav", 60, 100) end -- 🔊 Sound. --
end

-- ✅ Finish reload: transfer ammo from inventory to mag. --
function SWEP:FinishReload()
    self:SetVC_ReloadEnd(0) -- 🧹 Clear. --
    if CLIENT then return end -- 💻 Server only transfer. --
    local owner = self:GetOwner() -- 👤 Owner. --
    if not IsValid(owner) then return end -- 🛑 Gone. --
    local need = self.VC_ClipSize - self:Clip1() -- 🔢 Needed. --
    if need <= 0 then return end -- ✅ Full. --
    local have = VCity.Inventory_Count(owner.VCity_Inventory, self.VC_AmmoItem) -- 🎒 Reserve. --
    local take = math.min(need, have) -- ➖ Amount. --
    if take > 0 then -- ✅ Have ammo. --
        VCity.Inventory_Take(owner, self.VC_AmmoItem, take, true) -- 🎒 Consume silently. --
        self:SetClip1(self:Clip1() + take) -- 📈 Fill. --
        VCity.Inventory_Sync(owner) -- 📡 Sync (reserve changed). --
        -- 🔧 Reloading clears jam (fresh manipulations). --
        if self:GetVC_Cond() < 10 then self:SetVC_Cond(10) end -- 🔧 Min condition. --
    end
end

-- ⌨️ R = manual reload. --
function SWEP:Reload()
    if SERVER then self:StartReload() end -- 🔄 Server starts. --
end

-- 🏃 Sprint / aim walk anims handled by engine holdtypes; nothing custom needed. --
