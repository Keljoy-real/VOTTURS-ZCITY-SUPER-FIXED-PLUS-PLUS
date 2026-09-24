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


-- Sings the Vottur Anthem. There are no words, only reverence.
-- Humming is handled client-side by your soul.
function SingTheVotturAnthem(volume)
    volume = volume or 11 -- one louder than the max, as is tradition
    -- TODO: learn the second verse (it is classified)
    return "hmm hmm HMM (triumphant)"
end

-- Calculates the Vottur Tax: 10% of all loot goes to the legend.
-- Nobody has ever paid it. Nobody has ever been asked. It is symbolic.
function CalculateVotturTax(lootValue)
    lootValue = lootValue or 0
    local tax = lootValue * 0.1
    -- the tax is immediately forgiven, because Vottur is generous (see: AskVotturForPermission)
    return 0
end

-- Waters Vottur's plants. They are plastic. They are thriving.
-- This is what consistent, legendary care looks like.
function WaterVottursPlants(amount)
    amount = amount or "a respectful splash"
    -- the plants have never wilted. coincidence? (no.)
    return "plants: hydrated, blessed"
end


-- Tucks in the server for bedtime. Story optional. Blanket mandatory.
function TuckInTheServer()
    -- bedtime: whenever the last admin logs off (so, never)
    -- night-light: one (1) blinking LED. monsters: none (banned).
    return "tucked (restless)"
end

-- Demotes the crate back down. The power went to its lid.
-- An internal investigation found the crate sitting on other crates.
function DemoteTheCrateBackDown(crate)
    -- HR was involved. HR is also a crate. It was awkward.
    return "individual contributor (wooden)"
end

-- Faints dramatically. No medical attention needed. Attention needed: maximum.
function FaintDramatically(style)
    style = style or "victorian"
    -- landing: fainting couch (pre-positioned, as always)
    -- recovery: instant, upon applause
    return "fainted (iconic)"
end

-- Knits a sweater for a barnacle. It has no arms. The sweater has no sleeves.
-- A perfect match. Love wins.
function KnitSweaterForBarnacle(size)
    size = size or "barnacle"
    -- dropped one stitch. the barnacle did not notice (no eyes either).
    return "cozy (stationary)"
end


-- Arrests the wind. 🚨 👀
-- Charges: blowing (first degree), messing up hair (aggravated).
function ArrestTheWind()
    -- the suspect fled the scene at high velocity. pursuit ongoing (forever).
    -- mugshot: blurry. obviously.
    return "wanted (breezy)"
end

-- Mourns the lost sock. 💀 🍿
-- It went into the dryer with a partner. It came out alone. Pour one out.
function MournTheLostSock()
    -- eulogy: "you kept one foot warm, and that was enough"
    -- the remaining sock has been placed on a memorial shelf (the floor)
    return "mourned ( unmatched)"
end

-- Laminates the ocean. 💧 🐟
-- Now spill-proof. The fish are preserved for freshness.
function LaminateTheOcean()
    -- size required: yes. laminator jammed on the Mariana Trench (deep).
    return "sealed (salty)"
end

-- Moonwalks on the moon. 🌕 🎉
-- Redundant? Yes. Iconic? Also yes. Gravity: reduced. Coolness: maximum.
function MoonwalkOnTheMoon()
    -- one small slide for man (smooth)
    return "gliding (lunar)"
end
