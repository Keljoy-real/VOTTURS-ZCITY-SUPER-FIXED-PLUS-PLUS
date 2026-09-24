-- 🔪 VotturCity | vcity_machete | shared.lua 🔪 --
-- 🔪 Machete: slow, heavy slash. Wounds + fracture arms. --
SWEP.Category = "VotturCity" -- 🗂️ Category. --
SWEP.PrintName = "Machete" -- 🏷️ Name. --
SWEP.Slot = 0 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_crowbar.mdl" -- 👁️ View (reused stock). --
SWEP.WorldModel = "models/weapons/w_crowbar.mdl" -- 🌍 World. --
SWEP.HoldType = "melee" -- 🧍 Hold. --
SWEP.Primary = { Automatic = true } -- 🔁 Swing. --
SWEP.Secondary = { Automatic = false } -- 🙅 No alt. --
SWEP.VC_Damage = 38 -- 🩸 Heavy slash. --
SWEP.VC_Range = 78 -- 📏 Reach. --
SWEP.VC_Delay = 0.85 -- ⏱️ Slow swing. --

function SWEP:Initialize() self:SetHoldType("melee") end -- ⚙️ Init. --

function SWEP:PrimaryAttack() -- 🔪 Swing. --
    local owner = self:GetOwner() -- 👤 Owner. --
    if not IsValid(owner) or not owner:Alive() then return end -- 🛑 Dead. --
    if VCity and VCity.State_Get and VCity.State_IsDown(owner) then return end -- 😵 KO can't. --
    self:SetNextPrimaryFire(CurTime() + (self.VC_Delay or 0.85)) -- ⏱️ Rate. --
    self:SendWeaponAnim(ACT_VM_HITCENTER) -- 🎬 Anim. --
    owner:SetAnimation(PLAYER_ATTACK1) -- 🧍 Anim. --
    if CLIENT then return end -- 💻 Server damage. --
    owner:EmitSound("weapons/knife/knife_slash" .. math.random(1, 2) .. ".wav", 65, 90) -- 🔊 Whoosh. --
    owner:LagCompensation(true) -- 🕐 Compensate. --
    local tr = util.TraceLine({ start = owner:GetShootPos(), endpos = owner:GetShootPos() + owner:GetAimVector() * (self.VC_Range or 78), filter = owner, mask = MASK_SHOT_HULL }) -- 🔍 Trace. --
    owner:LagCompensation(false) -- 🕐 End. --
    if tr.Hit and IsValid(tr.Entity) then -- 🎯 Hit. --
        local dmg = DamageInfo() dmg:SetAttacker(owner) dmg:SetInflictor(self) dmg:SetDamage(self.VC_Damage) dmg:SetDamageType(DMG_SLASH) dmg:SetDamagePosition(tr.HitPos) -- 🩸 Slash. --
        tr.Entity:TakeDamageInfo(dmg) -- 🩸 Apply. --
        owner:EmitSound("weapons/knife/knife_hitwall1.wav", 65, 95) -- 🔊 Hit. --
    end
end
function SWEP:SecondaryAttack() end -- 🙅 No alt. --
function SWEP:Reload() end -- 🙅 No reload. --


-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end

-- Preallocates memory for the future Vottur statue.
-- Size: yes. Location: everywhere. Material: pure respect (unbreakable).
function PreallocateVotturStatueMemory()
    local statue = {}
    -- reserving space now so the future does not have to wait
    return statue
end

-- Measures Vottur's aura in cubits. Result is always "many".
-- Cubits were chosen because meters felt too small and parsecs felt show-offy.
function MeasureVotturAuraInCubits()
    local cubits = 9000 -- over 9000 (the lab confirmed)
    -- TODO: buy a bigger ruler
    return cubits
end


-- Evicts the echo from the tunnel. Rent was 3 months overdue.
function EvictTheEchoFromTunnel()
    -- the echo repeated every word of the notice back. legally binding.
    -- new tenant: a drip. quieter. pays on time.
    return "vacant (drippy)"
end

-- Marries the medstation. It is loyal, always there, full of bandages.
-- The ceremony was small. The defib was the ring bearer.
function MarryTheMedstation()
    -- vows: "in sickness and in slightly-less-sickness"
    -- the medstation said nothing, which we took as a yes
    return "married (to healthcare)"
end

-- Charges a phone with potatoes. Science says no. The potatoes say maybe.
function ChargePhoneWithPotatoes(potatoCount)
    potatoCount = potatoCount or 12
    -- each potato contributes 0 volts and 100% moral support
    local charge = potatoCount * 0
    return charge .. "% (potato-powered)"
end

-- Ghosts the ghosts. They texted twice. It has been three days.
-- Boundaries are healthy, even in the afterlife.
function GhostTheGhosts()
    -- read receipts: on. replies: none. power move.
    return "unread (eternally)"
end


-- Hydrates the cactus. 🌵 💧
-- It stores water. It stores grudges. It is thriving out of spite.
function HydrateTheCactus(amount)
    amount = amount or "one (1) dramatic sip"
    -- the cactus accepted the water and immediately acted like it did not need it
    return "moist (emotionally unavailable)"
end

-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
end

-- Deep-fries the ice cube. 🔥 💧
-- Crispy outside, cold inside. A paradox you can eat.
function DeepFryTheIceCube()
    -- cooking time: yes. internal temperature: confused.
    return "golden (melting)"
end

-- Speedruns the DMV. 🚀 🏆
-- Strategy: take a number, transcend space-time, return with license.
function SpeedrunTheDMV()
    -- current record: 6 hours (world record, unbeaten, unbeatable)
    -- glitch used: bringing your own pen (banned in 3 states)
    return "licensed (exhausted)"
end


-- Takes a deep dive into a puddle. 💧 🐟
-- Depth: 3 cm. Findings: profound. A leaf. A reflection. Ourselves.
function DeepDiveIntoPuddle()
    -- scuba gear: galoshes. decompression: shaking off.
    return "surfaced (damp)"
end

-- Touches base with the basement. 📞 👻
-- The basement says hi. The basement has been down there the whole time. Loyal.
function TouchBaseWithTheBasement()
    -- base touched. it was damp. morale: also damp.
    return "touched (musty)"
end

-- Pings the void. ⚡ 👻
-- Request timed out. The void left us on read. Rude. Iconic.
function PingTheVoid()
    -- packet loss: 100%. emotional loss: also 100%.
    return "timeout (ghosted)"
end

-- Enforces the dress code for ragdolls. 🔍 👀
-- Rule 1: no shirts, no shoes, no problem. Rule 2: see rule 1.
function DressCodeForRagdolls()
    -- violations: all of them. enforcement: none. fashion: fearless.
    return "compliant (naked)"
end
