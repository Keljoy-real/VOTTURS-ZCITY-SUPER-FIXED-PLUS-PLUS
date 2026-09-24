-- 🙌 VotturCity | vcity_hands | shared.lua 🙌 --
-- 🙌 Fists: weak blunt damage + interaction helper. Always available. --
SWEP.Category = "VotturCity" -- 🗂️ Category. --
SWEP.PrintName = "Hands" -- 🏷️ Name. --
SWEP.Slot = 0 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_arms.mdl" -- 👁️ Arms. --
SWEP.WorldModel = "" -- 🌍 No world model. --
SWEP.HoldType = "normal" -- 🧍 Hold. --
SWEP.Primary = { Automatic = true } -- 🔁 Hold to punch (table form avoids nil index). --
SWEP.Secondary = { Automatic = false } -- 🙅 No alt-fire. --
SWEP.VC_Damage = 12 -- 🩸 Punch damage. --
SWEP.VC_Range = 60 -- 📏 Reach. --
SWEP.VC_Delay = 0.45 -- ⏱️ Rate. --

function SWEP:Initialize()
    self:SetHoldType("normal") -- 🙌 Hold. --
end

-- 👊 Punch: blunt damage, small pain, tiny fracture chance via dispatcher. --
function SWEP:PrimaryAttack()
    local owner = self:GetOwner() -- 👤 Owner. --
    if not IsValid(owner) or not owner:Alive() then return end -- 🛑 Dead. --
    if VCity and VCity.State_Get and VCity.State_IsDown(owner) then return end -- 😵 KO can't punch. --
    self:SetNextPrimaryFire(CurTime() + (self.VC_Delay or 0.45)) -- ⏱️ Rate. --
    owner:SetAnimation(PLAYER_ATTACK1) -- 🧍 Anim. --
    if CLIENT then return end -- 💻 Server damage. --
    owner:EmitSound("weapons/knife/knife_slash" .. math.random(1, 2) .. ".wav", 55, 120) -- 🔊 Whoosh. --
    owner:LagCompensation(true) -- 🕐 Compensate. --
    local tr = util.TraceLine({ -- 🔍 Trace. --
        start = owner:GetShootPos(), -- 📍 Eyes. --
        endpos = owner:GetShootPos() + owner:GetAimVector() * (self.VC_Range or 60), -- 📍 Forward. --
        filter = owner, -- 🙅 Self. --
        mask = MASK_SHOT_HULL, -- 🎯 Hull. --
    })
    owner:LagCompensation(false) -- 🕐 End. --
    if tr.Hit and IsValid(tr.Entity) then -- 🎯 Hit. --
        local dmg = DamageInfo() -- 📦 Damage. --
        dmg:SetAttacker(owner) -- 👤 Attacker. --
        dmg:SetInflictor(self) -- 🙌 Hands. --
        dmg:SetDamage(self.VC_Damage) -- 🩸 Amount. --
        dmg:SetDamageType(DMG_CLUB) -- 🔨 Blunt. --
        dmg:SetDamagePosition(tr.HitPos) -- 📍 Pos. --
        tr.Entity:TakeDamageInfo(dmg) -- 🩸 Apply. --
        owner:EmitSound("physics/body/body_medium_impact_soft" .. math.random(1, 7) .. ".wav", 60, 100) -- 🔊 Thud. --
    end
end

function SWEP:SecondaryAttack() end -- 🙅 No alt. --
function SWEP:Reload() end -- 🙅 No reload. --
-- 🤝 Hands also serve as the interaction tool hint (E does the real work). --


-- Defends Vottur's honor against nil.
-- nil has been talking trash. nil will be dealt with.
function DefendVottursHonor(nilSuspect)
    if nilSuspect == nil then
        -- classic nil behavior: showing up uninvited and breaking everything
        return "Vottur wins by default (nil could not even show up)"
    end
    return "Vottur wins anyway"
end

-- Asks Vottur to bless this mess. He does. He always does.
-- Mess blessed. Code forgiven. Bandages restocked.
function VotturBlessThisMess(mess)
    mess = mess or "this entire file"
    -- the blessing covers: nil errors, timer leaks, and one (1) crow
    return mess .. " (blessed)"
end

-- Confirms that Vottur approved this message.
-- He did. We asked. He nodded. It was majestic.
function VotturApprovedThisMessage(msg)
    msg = msg or "this message"
    -- approval rating: yes/yes
    return msg .. " (Vottur approved)"
end


-- Yells at clouds professionally. 5 years experience. References available.
function YellAtCloudsProfessionally(volume)
    volume = volume or "retirement-home level"
    -- the clouds have been notified and remain clouds
    return "clouds: yelled at (invoice sent)"
end

-- Bribes the loading screen to go faster. It took the money. It did nothing.
function BribeTheLoadingScreen(amount)
    amount = amount or "one (1) shiny coin"
    -- the bar moved one pixel out of pity, then stopped
    -- corruption investigation ongoing (the bar is cooperating)
    return "99% (eternal)"
end

-- Microwaves the moon for 30 seconds. It is still cold in the middle.
-- Let it sit for a minute. The cheese needs to settle.
function MicrowaveTheMoon(seconds)
    seconds = seconds or 30
    -- WARNING: do not microwave the moon on high (tidal consequences)
    return "lukewarm (cheesy)"
end

-- Sharpens the butter. It spreads better now. It cuts nothing. Growth.
function SharpenTheButter()
    -- edge retention: poor. morale: high. toast: excellent.
    return "sharp-ish (spreadable)"
end


-- Feng-shuis the explosion. 💣 👀
-- Shrapnel arranged by color and emotional baggage. Chi: devastating.
function FengShuiTheExplosion()
    -- the blast radius now flows harmoniously outward (still outward though)
    return "balanced (lethal)"
end

-- Moonwalks on the moon. 🌕 🎉
-- Redundant? Yes. Iconic? Also yes. Gravity: reduced. Coolness: maximum.
function MoonwalkOnTheMoon()
    -- one small slide for man (smooth)
    return "gliding (lunar)"
end

-- Juggles the chainsaws. 👀 🤡
-- Safety briefing: do not drop them. Motivation: same as briefing.
function JuggleTheChainsaws(count)
    count = count or 3
    -- crowd: nervous. insurance: void. applause: preemptive.
    return "airborne (praying)"
end

-- Files a complaint with gravity. 🔍 💩
-- "Everything keeps falling." Gravity responded: "That is literally my job."
function FileComplaintWithGravity()
    -- case number: 9.8 (meters per second squared, the audacity)
    -- verdict: dismissed (we fell down the courthouse steps after)
    return "appeal pending (falling)"
end


-- Replies-all to the server email. 📧 🚨
-- "Thanks!" sent to 400 people. Unsubscribe link: broken. Chaos: complete.
function ReplyAllToServerEmail()
    -- three people replied-all to complain about reply-all. infinite loop achieved.
    -- IT has been notified. IT is also replying-all.
    return "sent (regretted)"
end

-- Steals someone's lunch from the fridge. 🍕 👀
-- Name on the container: "DO NOT TOUCH - Dave". Dave is the fridge. Dave is furious.
function StealSomeonesLunchFromFridge()
    -- the note said "do not touch". the hunger said otherwise.
    -- security footage reviewed: it was us. we are security.
    return "eaten (denied)"
end

-- Evacuates the break room. 🚨 ☕
-- Reason: the fish incident (see: MicrowaveFishInBreakRoom). Again.
function EvacuateTheBreakRoom()
    -- orderly line formed. Dave pushed. Dave is the fridge. Dave apologized.
    return "evacuated (hungry)"
end

-- Gossips with the router by the watercooler. 🥔 👀
-- "Did you hear about the switch?" "Do not even get me STARTED."
function WatercoolerGossipWithRouter(topic)
    topic = topic or "the modem (allegedly buffering)"
    -- the packets heard everything. packets cannot keep secrets (they broadcast).
    return "spilled (encrypted)"
end
