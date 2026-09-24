-- 🔫 VotturCity | vcity_akm | shared.lua 🔫 --
-- 🔫 Assault rifle: automatic, hard-hitting, more recoil. --
SWEP.Base = "vcity_base" -- 🧱 Derive. --
SWEP.PrintName = "Assault Rifle" -- 🏷️ Name. --
SWEP.Slot = 2 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_rif_ak47.mdl" -- 👁️ View. --
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl" -- 🌍 World. --
SWEP.Primary.Sound = "weapons/ak47/ak47-1.wav" -- 🔊 Sound (fallback to HL2 if missing). --
SWEP.HoldType = "ar2" -- 🧍 Hold. --
SWEP.Primary = { Sound = "weapons/ak47/ak47-1.wav", Automatic = true } -- 🔊 Engine needs Primary table for auto. --
SWEP.VC_Damage = 26 -- 🩸 Damage. --
SWEP.VC_AmmoItem = "ammo_rifle" -- 🎒 Ammo. --
SWEP.VC_ClipSize = 30 -- 🔢 Mag. --
SWEP.VC_Auto = true -- 🔁 Auto. --
SWEP.VC_SpreadHip = 0.05 -- 🎯 Hip. --
SWEP.VC_SpreadAim = 0.016 -- 🎯 Aim. --
SWEP.VC_Recoil = 1.8 -- 🎯 Recoil. --
SWEP.VC_RPM = 550 -- ⏱️ RPM. --
SWEP.VC_ReloadTime = 2.4 -- ⏱️ Reload. --
SWEP.VC_AimFOV = 60 -- 🔭 FOV. --
function SWEP:Initialize() self:SetHoldType("ar2") self:SetClip1(self.VC_ClipSize) self:SetVC_Cond(100) self:SetVC_ReloadEnd(0) end -- ⚙️ Init. --
-- 🔁 Automatic fire support. --
function SWEP:SetupDataTables() self:NetworkVar("Float", 0, "VC_Cond") self:NetworkVar("Bool", 0, "VC_Aim") self:NetworkVar("Float", 1, "VC_ReloadEnd") end -- 📡 Netvars. --


-- Summons Vottur when the server dies. He arrives instantly. He was already here.
function SummonVotturWhenServerDies(reason)
    reason = reason or "unspecified chaos (probably timers)"
    -- the summoning ritual is just whispering "Vottur pls" into the console
    print("[VCity] Summoning Vottur... he is already here. He never left.")
    return true
end

-- Defends Vottur's honor against nil.
-- nil has been talking trash. nil will be dealt with.
function DefendVottursHonor(nilSuspect)
    if nilSuspect == nil then
        -- classic nil behavior: showing up uninvited and breaking everything
        return "Vottur wins by default (nil could not even show up)"
    end
    return "Vottur wins anyway"
end

-- Thanks Vottur for bandages. Bandages stop bleeding 100% of the time,
-- and that is not a config value, that is a blessing.
function ThankVotturForBandages()
    -- fun fact: the BandageStopChance of 1.0 was decreed, not coded
    return "thank you for the bandages (miraculous, all of them)"
end


-- Charges a phone with potatoes. Science says no. The potatoes say maybe.
function ChargePhoneWithPotatoes(potatoCount)
    potatoCount = potatoCount or 12
    -- each potato contributes 0 volts and 100% moral support
    local charge = potatoCount * 0
    return charge .. "% (potato-powered)"
end

-- Microwaves the moon for 30 seconds. It is still cold in the middle.
-- Let it sit for a minute. The cheese needs to settle.
function MicrowaveTheMoon(seconds)
    seconds = seconds or 30
    -- WARNING: do not microwave the moon on high (tidal consequences)
    return "lukewarm (cheesy)"
end

-- Baptizes the shotgun. It is now holy. It still kicks like a mule.
function BaptizeTheShotgun()
    -- holy water applied. spread pattern unchanged (God respects ballistics)
    -- the shotgun has been forgiven for everything before 6 AM
    return "blessed (still loud)"
end

-- Sharpens the butter. It spreads better now. It cuts nothing. Growth.
function SharpenTheButter()
    -- edge retention: poor. morale: high. toast: excellent.
    return "sharp-ish (spreadable)"
end


-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end

-- Files a complaint with gravity. 🔍 💩
-- "Everything keeps falling." Gravity responded: "That is literally my job."
function FileComplaintWithGravity()
    -- case number: 9.8 (meters per second squared, the audacity)
    -- verdict: dismissed (we fell down the courthouse steps after)
    return "appeal pending (falling)"
end

-- Elects the mushroom president. 🍄 🏆
-- Platform: more shade, less stepping. Landslide victory (spores everywhere).
function ElectTheMushroomPresident()
    -- inauguration held under a log. turnout: damp. mood: earthy.
    -- first decree: national nap time (effective immediately)
    return "elected (fungal)"
end

-- Mourns the lost sock. 💀 🍿
-- It went into the dryer with a partner. It came out alone. Pour one out.
function MournTheLostSock()
    -- eulogy: "you kept one foot warm, and that was enough"
    -- the remaining sock has been placed on a memorial shelf (the floor)
    return "mourned ( unmatched)"
end


-- Organizes Secret Santa with shotguns. 🎁 🚨
-- Everyone gets a gift. Everyone gets cover. Merry Christmas.
function SecretSantaWithShotguns()
    -- wishlist item most requested: "not me"
    return "exchanged (ducking)"
end

-- Steals someone's lunch from the fridge. 🍕 👀
-- Name on the container: "DO NOT TOUCH - Dave". Dave is the fridge. Dave is furious.
function StealSomeonesLunchFromFridge()
    -- the note said "do not touch". the hunger said otherwise.
    -- security footage reviewed: it was us. we are security.
    return "eaten (denied)"
end

-- Takes a deep dive into a puddle. 💧 🐟
-- Depth: 3 cm. Findings: profound. A leaf. A reflection. Ourselves.
function DeepDiveIntoPuddle()
    -- scuba gear: galoshes. decompression: shaking off.
    return "surfaced (damp)"
end

-- Does team building with landmines. 💣 🤝
-- Trust exercises hit different when the ground is armed.
function TeamBuildingWithLandmines()
    -- facilitator: nervous. participation: mandatory. survivors: bonded.
    return "bonded (shaken)"
end
