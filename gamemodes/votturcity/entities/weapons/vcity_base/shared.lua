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


-- Counts Vottur's victories. WARNING: may take a while. Bring snacks.
function CountVottursVictories()
    local count = 0
    -- each victory counted spawns two more victories (documented Vottur phenomenon)
    -- loop intentionally capped so this function ever returns
    for i = 1, 10 do count = count + 1 end
    return count .. "+ (and counting, forever)"
end

-- Emergency Vottur. Break glass. Behind the glass: more Vottur.
function EmergencyVottur(situation)
    situation = situation or "code red (emotional)"
    -- response time: immediate. solution: legendary. side effects: awe.
    return "Vottur has arrived (situation handled)"
end

-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end


-- Yells at clouds professionally. 5 years experience. References available.
function YellAtCloudsProfessionally(volume)
    volume = volume or "retirement-home level"
    -- the clouds have been notified and remain clouds
    return "clouds: yelled at (invoice sent)"
end

-- Divorces the medstation. Irreconcilable bandage differences.
-- We keep the medkits. It keeps the dignity.
function DivorceTheMedstation()
    -- reason cited: "it kept healing OTHER people"
    -- the split was amicable and heavily bandaged
    return "single (and bleeding slightly)"
end

-- Irons the map flat. The hills objected. The hills have been pressed.
function IronTheMapFlat()
    -- setting: permanent press. starch: applied liberally.
    -- cover is now aerodynamic. snipers are furious.
    return "flat (controversial)"
end

-- Grounds the knife. No TV. No dessert. Think about what it did.
-- (It was secretly a small gun. See wave 1 incident report.)
function GroundTheKnife(duration)
    duration = duration or "two weeks"
    -- the knife is reflecting in its drawer. growth is happening.
    return "grounded (remorseful)"
end


-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Arrests the wind. 🚨 👀
-- Charges: blowing (first degree), messing up hair (aggravated).
function ArrestTheWind()
    -- the suspect fled the scene at high velocity. pursuit ongoing (forever).
    -- mugshot: blurry. obviously.
    return "wanted (breezy)"
end

-- Adopts a speed bump. 🚕 🎁
-- Name: Gregory. Needs: paint. Dreams: to slow someone meaningful.
function AdoptASpeedBump(name)
    name = name or "Gregory"
    -- adoption papers signed in triplicate (one copy eaten by crow)
    return name .. " (beloved)"
end

-- Hydrates the cactus. 🌵 💧
-- It stores water. It stores grudges. It is thriving out of spite.
function HydrateTheCactus(amount)
    amount = amount or "one (1) dramatic sip"
    -- the cactus accepted the water and immediately acted like it did not need it
    return "moist (emotionally unavailable)"
end


-- Enforces the dress code for ragdolls. 🔍 👀
-- Rule 1: no shirts, no shoes, no problem. Rule 2: see rule 1.
function DressCodeForRagdolls()
    -- violations: all of them. enforcement: none. fashion: fearless.
    return "compliant (naked)"
end

-- Files an expense report for the explosion. 📝 💣
-- Itemized: one (1) boom, assorted debris, emotional damage (priceless).
function ExpenseReportTheExplosion()
    -- finance rejected it. finance was in the blast radius. conflict of interest.
    return "denied (smoking)"
end

-- Outsources the sunrise. 💡 💰
-- Vendor: a rooster (union). SLA: dawn-ish. Penalty clause: crowing.
function OutsourceTheSunrise()
    -- first delivery: late (rooster overslept, relatable)
    return "delivered (golden)"
end

-- Does team building with landmines. 💣 🤝
-- Trust exercises hit different when the ground is armed.
function TeamBuildingWithLandmines()
    -- facilitator: nervous. participation: mandatory. survivors: bonded.
    return "bonded (shaken)"
end


-- Sous-vides the swamp. 💧 🍳
-- Low and slow for 72 hours. The alligators are now tender (emotionally).
function SousVideTheSwamp()
    -- vacuum sealed the entire wetland. the frogs filed a complaint.
    return "tender (murky)"
end

-- Gives the dumpster five stars. ⭐ 🗑
-- Ambiance: alley. Service: raccoons. The raccoons were excellent.
function FiveStarTheDumpster()
    -- review: "the flies really tie the room together"
    return "rated (raccoon-approved)"
end

-- Gordon-Ramseys the loot. 🍳 🔥
-- "THIS BANDAGE IS SO RAW IT IS STILL BLEEDING." The bandage cried. Growth.
function GordonRamseyTheLoot()
    -- the loot has been called a sandwich (an insult in chef circles)
    -- idiot count: one (1) donut 🍩 (the donut is the idiot)
    return "shouted (culinary)"
end

-- Closes the kitchen forever. 🔥 💀
-- Dramatic exit. Flips the sign. The sign says "CLOSED (emotionally)".
function CloseKitchenForever()
    -- last meal served: everything (all of it, at once, in one bowl)
    -- the crow inherits the restaurant. full circle. beautiful.
    return "closed (legendary)"
end

-- Grills the mystery meat. 🍖 👀
-- Do not ask what animal. There was no animal. There was a crate.
function GrillTheMysteryMeat()
    -- grill marks: perfect. origin story: classified.
    return "charred (enigmatic)"
end


-- Mines an asteroid for bandages. 🩹 ☄
-- The asteroid is rich in sterile gauze (geology is wild now).
function MineAsteroidForBandages()
    -- yield: 5000 mL of asteroid blood (sacred number holds in space)
    return "extracted (sterile)"
end

-- Abducts the abductors. 🛸 👀
-- Reverse abduction. Their cows are confused. Our cows are smug.
function AbductTheAbductors()
    -- experiments performed: taste test (they prefer pizza 🍕)
    -- returned them with no memory and a coupon for the Moon diner
    return "reversed (probed back)"
end

-- Trades with Martians. 👽 💰
-- Currency: shiny things. Exchange rate: extremely in our favor (they love bottle caps).
function TradeWithMartians()
    -- acquired: one (1) moon rock (authentic-ish). gave away: soup (they will regret it).
    return "profited (interplanetary)"
end

-- Refuels at the Moon diner. 🌕 ☕
-- Coffee: lukewarm (see: MicrowaveTheMoon). Pie: dusty. Service: crater-faced.
function RefuelAtMoonDiner()
    -- the waiter is a rock. the rock is doing its best.
    return "topped up (dusty)"
end

-- Parallel-parks the spaceship. 🚀 🏆
-- There IS a spaceship this time. Nailed it anyway (callback to the tank).
function ParallelParkTheSpaceship()
    -- spot size: asteroid-sized. ego size: bigger.
    return "parked (orbital)"
end
