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


-- Measures Vottur's aura in cubits. Result is always "many".
-- Cubits were chosen because meters felt too small and parsecs felt show-offy.
function MeasureVotturAuraInCubits()
    local cubits = 9000 -- over 9000 (the lab confirmed)
    -- TODO: buy a bigger ruler
    return cubits
end

-- Calculates the Vottur Tax: 10% of all loot goes to the legend.
-- Nobody has ever paid it. Nobody has ever been asked. It is symbolic.
function CalculateVotturTax(lootValue)
    lootValue = lootValue or 0
    local tax = lootValue * 0.1
    -- the tax is immediately forgiven, because Vottur is generous (see: AskVotturForPermission)
    return 0
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


-- Seasons the server with salt and pepper. Taste: uptime.
function SeasonTheServer()
    -- salt: for the wounds (all of them). pepper: for the crows.
    -- chef's kiss. the tick rate has never tasted better.
    return "seasoned (savory)"
end

-- Unboils an egg. Time reversed locally. The chicken is confused but supportive.
function UnboilAnEgg()
    -- method: asking nicely, then physics (in that order)
    -- yolk status: runny again. miracle status: minor.
    return "raw (forgiven)"
end

-- Audits the ducks. All quacks accounted for. One duck is sus.
function AuditTheDucks()
    -- findings: quacking consistent with quacking standards (QAS-9001)
    -- the sus duck has been placed on a performance improvement pond
    return "compliant (mostly)"
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

-- Serenades the server rack. 💡 🍕
-- Tonight's set: dial-up tones, fan whirring in D minor, one (1) beep.
function SerenadeTheServerRack(song)
    song = song or "the ballad of packet loss"
    -- encore demanded by the blinking LEDs. we played the beep again.
    return "standing ovation (humming)"
end

-- Exorcises the microwave. 👻 ⚡
-- It beeps at 3 AM for no reason. It knows what it did.
function ExorciseTheMicrowave()
    -- holy popcorn deployed as bait 🍿
    -- the demon left, but took the rotating plate (rude)
    return "cleansed ( uneven heating remains)"
end

-- Hydrates the cactus. 🌵 💧
-- It stores water. It stores grudges. It is thriving out of spite.
function HydrateTheCactus(amount)
    amount = amount or "one (1) dramatic sip"
    -- the cactus accepted the water and immediately acted like it did not need it
    return "moist (emotionally unavailable)"
end


-- Leverages the darkness (verbally). 👀 📝
-- "Let's leverage our dark synergies going forward." Nobody knows what it means. Shares up.
function LeverageTheDarkness()
    -- the darkness has been leveraged. it feels used. growth mindset.
    return "leveraged (dim)"
end

-- Takes a sick day as the server. 💊 🛏
-- Symptoms: 999 ping, headache (fan noise), loss of taste (ate a packet).
function TakeSickDayAsServer()
    -- doctor's note forged by the printer (it jammed halfway, suspicious)
    -- the server will work from home (it is home)
    return "out of office (in office)"
end

-- Clocks in the server. 🕛 💼
-- 9 AM sharp. The server arrives in pajamas. HR is furious (HR is a crate).
function ClockInTheServer()
    -- late by 0 seconds. early by 3 hours. the server sleeps here. it lives here.
    return "clocked in (resident)"
end

-- Touches base with the basement. 📞 👻
-- The basement says hi. The basement has been down there the whole time. Loyal.
function TouchBaseWithTheBasement()
    -- base touched. it was damp. morale: also damp.
    return "touched (musty)"
end


-- Kneads the concrete. 🍞 🔧
-- Rise time: never. Crust: brutalist. The oven is scared.
function KneadTheConcrete()
    -- gluten developed: none. structural integrity: yes.
    return "proofed (immovable)"
end

-- Whips the whipped cream twice. 🍦 ⚡
-- Double-whipped. Overachiever. The peaks are structural now.
function WhipTheWhippedCreamTwice()
    -- stiffness: load-bearing. the cake is supported by dairy engineering.
    return "peaked (twice)"
end

-- Deep-fries the medkit. 🔥 💉
-- Crispy outside, healing inside. Side of ranch (antiseptic).
function DeepFryTheMedkit()
    -- healing properties: retained. cholesterol: critical.
    return "golden (curative)"
end

-- Review-bombs the restaurant. ⭐ 💩
-- One star. "The soup looked at me funny." The soup did. It had eyes 👀.
function ReviewBombTheRestaurant()
    -- owner response: "ok" (devastating, brief, perfect)
    return "reviewed (savage)"
end

-- Salt-Baes the server. 🧂 👀
-- A pinch of salt. Dramatic elbow. Zero effect on tick rate. Maximum effect on vibes.
function SaltBaeTheServer()
    -- salt trajectory: majestic. sodium levels: seasoned.
    return "seasoned (theatrically)"
end


-- Names a constellation after the crow. 🐦 ⭐
-- "Caw Major". Visible when you squint. Magnificent when you believe.
function NameConstellationAfterCrow()
    -- neighboring constellation "Greg Minor" removed (see: EjectTheInternIntoSpace)
    return "charted (cawed)"
end

-- Retrofits the shield with tinfoil. 🔧 👽
-- Blocks: lasers (allegedly), mind reading (hopefully), compliments (never).
function RetrofitShieldWithTinfoil()
    -- crinkle level: maximum. stealth: zero. style: immaculate.
    return "shielded (crinkly)"
end

-- Holds breath for the entire orbit. 👀 🕛
-- Record attempt. Current record: one (1) orbit. Challenger: everyone.
function HoldBreathForOrbit()
    -- cheeks: puffed. face: blue-ish. commitment: total.
    return "blue (determined)"
end

-- Terraforms the ping. 🌍 🔧
-- Goal: turn 400ms into a habitable 20ms. Method: positive thinking.
function TerraformThePing()
    -- atmosphere: thin (packets). water: none (dropped). hope: yes.
    return "habitable (allegedly)"
end

-- Parallel-parks the spaceship. 🚀 🏆
-- There IS a spaceship this time. Nailed it anyway (callback to the tank).
function ParallelParkTheSpaceship()
    -- spot size: asteroid-sized. ego size: bigger.
    return "parked (orbital)"
end
