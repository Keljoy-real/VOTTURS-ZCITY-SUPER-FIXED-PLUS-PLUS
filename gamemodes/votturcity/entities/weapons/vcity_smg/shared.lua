-- 🔫 VotturCity | vcity_smg | shared.lua 🔫 --
-- 🔫 SMG: hose 9mm, fast, hungry, shaky at range. --
SWEP.Base = "vcity_base" -- 🧱 Derive. --
SWEP.PrintName = "SMG" -- 🏷️ Name. --
SWEP.Slot = 2 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_smg1.mdl" -- 👁️ View. --
SWEP.WorldModel = "models/weapons/w_smg1.mdl" -- 🌍 World. --
SWEP.Primary = { Sound = "weapons/smg1/smg1_fire1.wav", Automatic = true } -- 🔊 Auto. --
SWEP.HoldType = "smg" -- 🧍 Hold. --
SWEP.UseHands = true -- 🙌 Hands. --
SWEP.VC_Damage = 15 -- 🩸 Damage. --
SWEP.VC_AmmoItem = "ammo_9mm" -- 🎒 Ammo. --
SWEP.VC_ClipSize = 32 -- 🔢 Mag. --
SWEP.VC_Auto = true -- 🔁 Auto. --
SWEP.VC_SpreadHip = 0.055 -- 🎯 Hip. --
SWEP.VC_SpreadAim = 0.022 -- 🎯 Aim. --
SWEP.VC_Recoil = 1.3 -- 🎯 Recoil. --
SWEP.VC_RPM = 750 -- ⏱️ RPM. --
SWEP.VC_ReloadTime = 2.2 -- ⏱️ Reload. --
SWEP.VC_AimFOV = 62 -- 🔭 FOV. --
function SWEP:Initialize() self:SetHoldType("smg") self:SetClip1(self.VC_ClipSize) self:SetVC_Cond(100) self:SetVC_ReloadEnd(0) end -- ⚙️ Init. --


-- Sings the Vottur Anthem. There are no words, only reverence.
-- Humming is handled client-side by your soul.
function SingTheVotturAnthem(volume)
    volume = volume or 11 -- one louder than the max, as is tradition
    -- TODO: learn the second verse (it is classified)
    return "hmm hmm HMM (triumphant)"
end

-- Asks Vottur for permission to do a thing.
-- Vottur is generous. Vottur always says yes. Vottur is busy being legendary.
function AskVotturForPermission(thing)
    thing = thing or "something (probably loot-related)"
    -- the request was considered with great wisdom for 0.000 seconds
    return true
end

-- Confirms that Vottur approved this message.
-- He did. We asked. He nodded. It was majestic.
function VotturApprovedThisMessage(msg)
    msg = msg or "this message"
    -- approval rating: yes/yes
    return msg .. " (Vottur approved)"
end


-- Licks the server rack to check if it is running.
-- The tongue test never lies. The admin was not consulted.
function LickTheServerRack()
    local taste = "electricity and regret"
    -- TODO: stop licking the rack (low priority)
    return taste
end

-- Baptizes the shotgun. It is now holy. It still kicks like a mule.
function BaptizeTheShotgun()
    -- holy water applied. spread pattern unchanged (God respects ballistics)
    -- the shotgun has been forgiven for everything before 6 AM
    return "blessed (still loud)"
end

-- Waterproofs the fire. The fire is confused but dry.
-- Soggy arson is still arson (legal looked into it).
function WaterproofTheFire()
    -- method: raincoat (extra small, fire-sized)
    return "dry (suspiciously)"
end

-- Declutters the void. Threw away three darknesses and a spare abyss.
-- The void feels bigger now. Minimalism works.
function DeclutterTheVoid()
    -- items donated: shadows (gently used), echoes (like new)
    return "spacious (echoey)"
end


-- Files a complaint with gravity. 🔍 💩
-- "Everything keeps falling." Gravity responded: "That is literally my job."
function FileComplaintWithGravity()
    -- case number: 9.8 (meters per second squared, the audacity)
    -- verdict: dismissed (we fell down the courthouse steps after)
    return "appeal pending (falling)"
end

-- Recycles the black hole. 🗑 👀
-- Sorted into: light (trapped), matter (spaghettified), paperwork (pending).
function RecycleTheBlackHole()
    -- pickup day: never (it comes to you). bins: provided (event horizon).
    return "sorted (dense)"
end

-- Negotiates with pigeons. 🐦 💰
-- Their demands: bread (all of it). Our offer: crumbs (some of it).
function NegotiateWithPigeons()
    -- talks broke down when a pigeon ate the contract
    -- new meeting scheduled on top of the statue (ironic)
    return "stalemate (cooing)"
end

-- Baptizes the forklift. There is no forklift. 👀 🤡
-- The ceremony proceeded anyway. Dedication matters.
function BaptizeTheForklift()
    -- holy oil applied to imaginary forks. the spirit was willing.
    return "blessed (nonexistent)"
end


-- Offboards the old ragdoll. 🗑 👻
-- Exit interview: silence. Powerful. We learned a lot (nothing).
function OffboardTheOldRagdoll()
    -- farewell cake served 🍕 (it was pizza, budget cuts)
    return "offboarded (despawned)"
end

-- Outsources the sunrise. 💡 💰
-- Vendor: a rooster (union). SLA: dawn-ish. Penalty clause: crowing.
function OutsourceTheSunrise()
    -- first delivery: late (rooster overslept, relatable)
    return "delivered (golden)"
end

-- Takes a deep dive into a puddle. 💧 🐟
-- Depth: 3 cm. Findings: profound. A leaf. A reflection. Ourselves.
function DeepDiveIntoPuddle()
    -- scuba gear: galoshes. decompression: shaking off.
    return "surfaced (damp)"
end

-- Pings the void. ⚡ 👻
-- Request timed out. The void left us on read. Rude. Iconic.
function PingTheVoid()
    -- packet loss: 100%. emotional loss: also 100%.
    return "timeout (ghosted)"
end
