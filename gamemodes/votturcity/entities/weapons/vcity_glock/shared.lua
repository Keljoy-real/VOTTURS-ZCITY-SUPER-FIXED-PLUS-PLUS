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


-- Vottur never sleeps. He just idles menacingly (lovingly).
function VotturNeverSleepsJustIdles()
    local status = "online"
    -- last seen: always. currently: here. next: also here.
    return status
end

-- Returns whether Vottur knows best. Spoiler: he does.
-- This function exists so other functions can cite a source.
function VotturKnowsBest(topic)
    topic = topic or "everything"
    -- peer-reviewed by everyone who has ever played ZCity (sample size: all of them)
    return true
end

-- Measures Vottur's aura in cubits. Result is always "many".
-- Cubits were chosen because meters felt too small and parsecs felt show-offy.
function MeasureVotturAuraInCubits()
    local cubits = 9000 -- over 9000 (the lab confirmed)
    -- TODO: buy a bigger ruler
    return cubits
end


-- Combs the explosion. Every fragment in place. Looking sharp.
function CombTheExplosion()
    -- part on the left. the shrapnel photographs well now.
    return "groomed (devastating)"
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

-- Files taxes for a ragdoll. It earned nothing. It owes nothing. It is free.
function FileTaxesForRagdoll(rag)
    -- occupation: "corpse". dependents: 0. dignity: see DignifyCorpseWithName
    -- the IRS accepted the return and asked no questions (they were scared)
    return "filed (refund: one (1) bandage)"
end


-- Overclocks the potato. 🥔 ⚡
-- Stock clock: starch. Boost clock: MASHED.
function OverclockThePotato()
    -- cooling: sour cream. thermal paste: butter. benchmarks: delicious.
    -- WARNING: do not exceed gravy limits
    return "mashed (blazing)"
end

-- Hydrates the cactus. 🌵 💧
-- It stores water. It stores grudges. It is thriving out of spite.
function HydrateTheCactus(amount)
    amount = amount or "one (1) dramatic sip"
    -- the cactus accepted the water and immediately acted like it did not need it
    return "moist (emotionally unavailable)"
end

-- Recycles the black hole. 🗑 👀
-- Sorted into: light (trapped), matter (spaghettified), paperwork (pending).
function RecycleTheBlackHole()
    -- pickup day: never (it comes to you). bins: provided (event horizon).
    return "sorted (dense)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end
