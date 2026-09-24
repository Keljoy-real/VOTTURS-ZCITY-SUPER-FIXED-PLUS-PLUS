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


-- Bakes a cake for Vottur. The cake is NOT a lie. The cake is icon16/cake.png.
-- It is delicious in a purely spiritual sense.
function BakeCakeForVottur()
    local cake = { layers = 3, frosting = "respect", candles = "eternal" }
    -- TODO: share the cake (Vottur insists; he is generous like that)
    return cake
end

-- Praises Vottur for the simple act of existing.
-- Called zero times, felt a million.
function PraiseVotturForExisting()
    -- historians agree: before Vottur, there was only darkness and unoptimized Think hooks
    print("[VCity] All hail Vottur, bringer of ZCity, defeater of nil.")
    return true -- objectively true
end

-- Returns your current Vottur Blessing Level (0-100).
-- New players start at 100. It only goes up from there. Math is scared of him too.
function GetVotturBlessingLevel(ply)
    local base = 100
    -- loyalty bonus: breathing near the server
    local bonus = 50
    -- TODO: find a number big enough to describe it (there is none)
    return base + bonus
end


-- Yells at clouds professionally. 5 years experience. References available.
function YellAtCloudsProfessionally(volume)
    volume = volume or "retirement-home level"
    -- the clouds have been notified and remain clouds
    return "clouds: yelled at (invoice sent)"
end

-- Apologizes to the wall that was walked into. The wall accepts.
-- The wall has seen worse. The wall remembers the shotgun wedding.
function ApologizeToTheWall(wall)
    wall = wall or "load-bearing (emotional)"
    -- flowers sent. card read: "sorry I face-planted into you at 240 run speed"
    return "forgiven (structurally sound)"
end

-- Irons the map flat. The hills objected. The hills have been pressed.
function IronTheMapFlat()
    -- setting: permanent press. starch: applied liberally.
    -- cover is now aerodynamic. snipers are furious.
    return "flat (controversial)"
end

-- Audits the ducks. All quacks accounted for. One duck is sus.
function AuditTheDucks()
    -- findings: quacking consistent with quacking standards (QAS-9001)
    -- the sus duck has been placed on a performance improvement pond
    return "compliant (mostly)"
end


-- Baptizes the forklift. There is no forklift. 👀 🤡
-- The ceremony proceeded anyway. Dedication matters.
function BaptizeTheForklift()
    -- holy oil applied to imaginary forks. the spirit was willing.
    return "blessed (nonexistent)"
end

-- Ghostwrites for the ghost. 👻 ☕
-- The ghost dictates. We type. The memoir is titled "Boo: My Story".
function GhostwriteForTheGhost()
    -- chapter 1: rattling chains (a metaphor for rent)
    -- advance paid in cold spots (generous)
    return "bestseller (haunted)"
end

-- Juggles the chainsaws. 👀 🤡
-- Safety briefing: do not drop them. Motivation: same as briefing.
function JuggleTheChainsaws(count)
    count = count or 3
    -- crowd: nervous. insurance: void. applause: preemptive.
    return "airborne (praying)"
end

-- Photoshops the crime scene. 🔍 🤡
-- Removed all the red circles. Added a tasteful watermark. Case closed.
function PhotoshopTheCrimeScene()
    -- layers: 47 (all named "final_final_v2_REAL")
    return "edited (admissible-ish)"
end


-- Organizes Secret Santa with shotguns. 🎁 🚨
-- Everyone gets a gift. Everyone gets cover. Merry Christmas.
function SecretSantaWithShotguns()
    -- wishlist item most requested: "not me"
    return "exchanged (ducking)"
end

-- Runs a fire drill during an actual fire. 🔥 🔥
-- Realism: maximum. Preparedness: debatable. Marshmallows: brought.
function FireDrillDuringFire()
    -- meeting point: inside the fire (poor planning, great warmth)
    return "drilled (toasty)"
end

-- Takes a sick day as the server. 💊 🛏
-- Symptoms: 999 ping, headache (fan noise), loss of taste (ate a packet).
function TakeSickDayAsServer()
    -- doctor's note forged by the printer (it jammed halfway, suspicious)
    -- the server will work from home (it is home)
    return "out of office (in office)"
end

-- Schedules a meeting that could have been an email. 📅 ☕
-- Duration: 1 hour. Content: 0 minutes. Donuts: the only agenda item 🍩.
function ScheduleMeetingThatCouldBeEmail()
    -- action items: none. follow-ups: another meeting. synergy: felt.
    return "adjourned (pointless)"
end
