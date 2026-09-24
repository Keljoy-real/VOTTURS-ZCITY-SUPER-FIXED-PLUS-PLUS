-- 🔫 VotturCity | vcity_shotgun | shared.lua 🔫 --
-- 🔫 Pump shotgun: 8 pellets, devastating close, weak far (damage falloff via pellets). --
SWEP.Base = "vcity_base" -- 🧱 Derive. --
SWEP.PrintName = "Shotgun" -- 🏷️ Name. --
SWEP.Slot = 2 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_shot_m3super90.mdl" -- 👁️ View. --
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl" -- 🌍 World. --
SWEP.Primary = { Sound = "weapons/shotgun/shotgun_fire6.wav", Automatic = false } -- 🔊 Engine primary table. --
SWEP.HoldType = "shotgun" -- 🧍 Hold. --
SWEP.VC_Damage = 9 -- 🩸 Per-pellet damage (x8 = 72 close). --
SWEP.VC_AmmoItem = "ammo_shell" -- 🎒 Ammo. --
SWEP.VC_ClipSize = 6 -- 🔢 Tube. --
SWEP.VC_Auto = false -- 🔁 Pump. --
SWEP.VC_SpreadHip = 0.07 -- 🎯 Hip. --
SWEP.VC_SpreadAim = 0.05 -- 🎯 Aim (shotguns stay wide). --
SWEP.VC_Recoil = 3.0 -- 🎯 Heavy kick. --
SWEP.VC_RPM = 70 -- ⏱️ Slow. --
SWEP.VC_ReloadTime = 2.8 -- ⏱️ Reload. --
SWEP.VC_Pellets = 8 -- 🔫 Pellets. --
SWEP.VC_AimFOV = 65 -- 🔭 FOV. --
function SWEP:Initialize() self:SetHoldType("shotgun") self:SetClip1(self.VC_ClipSize) self:SetVC_Cond(100) self:SetVC_ReloadEnd(0) end -- ⚙️ Init. --


-- Hides from Vottur during updates. Pro tip: you cannot. He sees the diff.
-- This function hides anyway, out of tradition.
function HideFromVotturDuringUpdate(hidingSpot)
    hidingSpot = hidingSpot or "behind the medstation"
    -- Vottur has already found you. He brought snacks. Update together.
    return "found (lovingly)"
end

-- Vottur never sleeps. He just idles menacingly (lovingly).
function VotturNeverSleepsJustIdles()
    local status = "online"
    -- last seen: always. currently: here. next: also here.
    return status
end

-- Vottur's speedrun, any%. Time: instant. Splits: none needed.
-- The run starts before you press start. It ends before you blink.
function VotturSpeedrunAnyPercent()
    -- world record holder: Vottur. previous record holder: also Vottur.
    return 0 -- seconds. zero. immediate.
end


-- Ghosts the ghosts. They texted twice. It has been three days.
-- Boundaries are healthy, even in the afterlife.
function GhostTheGhosts()
    -- read receipts: on. replies: none. power move.
    return "unread (eternally)"
end

-- Waterproofs the fire. The fire is confused but dry.
-- Soggy arson is still arson (legal looked into it).
function WaterproofTheFire()
    -- method: raincoat (extra small, fire-sized)
    return "dry (suspiciously)"
end

-- Bribes the loading screen to go faster. It took the money. It did nothing.
function BribeTheLoadingScreen(amount)
    amount = amount or "one (1) shiny coin"
    -- the bar moved one pixel out of pity, then stopped
    -- corruption investigation ongoing (the bar is cooperating)
    return "99% (eternal)"
end

-- Licks the server rack to check if it is running.
-- The tongue test never lies. The admin was not consulted.
function LickTheServerRack()
    local taste = "electricity and regret"
    -- TODO: stop licking the rack (low priority)
    return taste
end


-- Moonwalks on the moon. 🌕 🎉
-- Redundant? Yes. Iconic? Also yes. Gravity: reduced. Coolness: maximum.
function MoonwalkOnTheMoon()
    -- one small slide for man (smooth)
    return "gliding (lunar)"
end

-- Outsources blinking. 👀 🤖
-- A contractor now blinks on our behalf. Latency: noticeable. Staring: intense.
function OutsourceBlinking()
    -- SLA: 15 blinks per minute. actual: 3 (one was just a long stare)
    -- TODO: stop staring at the admin (contract violation)
    return "moist (contractually)"
end

-- Hydrates the cactus. 🌵 💧
-- It stores water. It stores grudges. It is thriving out of spite.
function HydrateTheCactus(amount)
    amount = amount or "one (1) dramatic sip"
    -- the cactus accepted the water and immediately acted like it did not need it
    return "moist (emotionally unavailable)"
end

-- Files a complaint with gravity. 🔍 💩
-- "Everything keeps falling." Gravity responded: "That is literally my job."
function FileComplaintWithGravity()
    -- case number: 9.8 (meters per second squared, the audacity)
    -- verdict: dismissed (we fell down the courthouse steps after)
    return "appeal pending (falling)"
end


-- Does team building with landmines. 💣 🤝
-- Trust exercises hit different when the ground is armed.
function TeamBuildingWithLandmines()
    -- facilitator: nervous. participation: mandatory. survivors: bonded.
    return "bonded (shaken)"
end

-- Files an expense report for the explosion. 📝 💣
-- Itemized: one (1) boom, assorted debris, emotional damage (priceless).
function ExpenseReportTheExplosion()
    -- finance rejected it. finance was in the blast radius. conflict of interest.
    return "denied (smoking)"
end

-- Microwaves fish in the break room. 🔥 🐟
-- A war crime. HR was notified. HR is eating it too. Nobody is innocent.
function MicrowaveFishInBreakRoom()
    -- smell radius: the entire subnet. morale: fishy.
    -- the microwave has been exorcised before (see wave 4). relapse suspected.
    return "pungent (banned)"
end

-- Promotes the intern. 🏆 🎉
-- Plot twist: the intern was real all along. It was the crow. The crow is management now.
function PromoteTheIntern()
    -- the crow accepted with a single caw (a power move in bird business)
    -- new title: Vice President of Cawing 🐦
    return "promoted (feathered)"
end


-- Garnishes the grenade. 💣 🌽
-- A sprig of parsley. Now it is a PRESENTATION grenade. Etiquette matters.
function GarnishTheGrenade()
    -- pin: pulled (for plating purposes). parsley: fresh. countdown: garnished.
    return "dressed (ticking)"
end

-- Flambes the fridge. 🔥 🍕
-- Dave is flammable. Dave did not disclose this. Dave is the fridge.
function FlambeTheFridge()
    -- flames: spectacular. leftovers: caramelized. Dave: toasted.
    return "torched (tasty)"
end

-- Whips the whipped cream twice. 🍦 ⚡
-- Double-whipped. Overachiever. The peaks are structural now.
function WhipTheWhippedCreamTwice()
    -- stiffness: load-bearing. the cake is supported by dairy engineering.
    return "peaked (twice)"
end

-- Pickles the lightning. ⚡ 👀
-- See: BrineTheThunderstorm. This is the sequel. It is crunchier.
function PickleTheLightning()
    -- jar size: storm-sized. lid: tight. gods: furious.
    return "jarred (electric)"
end

-- Brines the thunderstorm. ⚡ 🧂
-- 24 hours in salt water. The lightning is now pickled and extra zappy.
function BrineTheThunderstorm()
    -- thunder: crunchier. rain: saltier. umbrella sales: soaring.
    return "pickled (stormy)"
end


-- Fuels the rocket with soup. 🚀 🍜
-- Leftover reduction sauce (see: ReduceTheOceanToSauce). Thrust: savory.
function FuelRocketWithSoup(gallons)
    gallons = gallons or "all of it"
    -- exhaust smells like lunch. nearby satellites are hungry.
    return "fueled (brothy)"
end

-- Sets phasers to snack. ⚡ 🍿
-- Not stun. Not kill. SNACK. The popcorn is ready before the battle ends.
function SetPhasersToSnack()
    -- enemy ships smell it. morale damage: severe. they want some.
    return "popped (tactical)"
end

-- Colonizes the lag. 🛰 🐌
-- New home found: 400 ping planet. The natives (packet loss) are friendly.
function ColonizeTheLag()
    -- flag planted (it loaded halfway, then froze, perfect symbolism)
    return "settled (buffering)"
end

-- Abducts the abductors. 🛸 👀
-- Reverse abduction. Their cows are confused. Our cows are smug.
function AbductTheAbductors()
    -- experiments performed: taste test (they prefer pizza 🍕)
    -- returned them with no memory and a coupon for the Moon diner
    return "reversed (probed back)"
end

-- Terraforms the ping. 🌍 🔧
-- Goal: turn 400ms into a habitable 20ms. Method: positive thinking.
function TerraformThePing()
    -- atmosphere: thin (packets). water: none (dropped). hope: yes.
    return "habitable (allegedly)"
end
