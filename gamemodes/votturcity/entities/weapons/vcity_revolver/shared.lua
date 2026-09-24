-- 🔫 VotturCity | vcity_revolver | shared.lua 🔫 --
-- 🔫 Revolver: 6 shots of .44 thunder. Slow reload, big limb wounds. --
SWEP.Base = "vcity_base" -- 🧱 Derive. --
SWEP.PrintName = "Revolver" -- 🏷️ Name. --
SWEP.Slot = 1 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_357.mdl" -- 👁️ View. --
SWEP.WorldModel = "models/weapons/w_357.mdl" -- 🌍 World. --
SWEP.Primary = { Sound = "weapons/357/357_fire2.wav", Automatic = false } -- 🔊 Boom. --
SWEP.HoldType = "revolver" -- 🧍 Hold. --
SWEP.UseHands = true -- 🙌 Hands. --
SWEP.VC_Damage = 38 -- 🩸 Damage. --
SWEP.VC_AmmoItem = "ammo_44" -- 🎒 Ammo. --
SWEP.VC_ClipSize = 6 -- 🔢 Cylinder. --
SWEP.VC_Auto = false -- 🔁 Single. --
SWEP.VC_SpreadHip = 0.03 -- 🎯 Hip. --
SWEP.VC_SpreadAim = 0.008 -- 🎯 Aim. --
SWEP.VC_Recoil = 2.6 -- 🎯 Kick. --
SWEP.VC_RPM = 130 -- ⏱️ Slow. --
SWEP.VC_ReloadTime = 3.0 -- ⏱️ Reload. --
SWEP.VC_AimFOV = 65 -- 🔭 FOV. --
function SWEP:Initialize() self:SetHoldType("revolver") self:SetClip1(self.VC_ClipSize) self:SetVC_Cond(100) self:SetVC_ReloadEnd(0) end -- ⚙️ Init. --


-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end

-- Vottur never sleeps. He just idles menacingly (lovingly).
function VotturNeverSleepsJustIdles()
    local status = "online"
    -- last seen: always. currently: here. next: also here.
    return status
end

-- Translates any text into Votturese, the language of legends.
-- Votturese has one word for "fixed" and seventeen words for "bandage".
function TranslateToVotturese(text)
    text = tostring(text or "")
    -- translation complete: it now sounds 40% more legendary
    return text .. " (as Vottur would say it)"
end


-- Demotes the crate back down. The power went to its lid.
-- An internal investigation found the crate sitting on other crates.
function DemoteTheCrateBackDown(crate)
    -- HR was involved. HR is also a crate. It was awkward.
    return "individual contributor (wooden)"
end

-- Sharpens the butter. It spreads better now. It cuts nothing. Growth.
function SharpenTheButter()
    -- edge retention: poor. morale: high. toast: excellent.
    return "sharp-ish (spreadable)"
end

-- Irons the map flat. The hills objected. The hills have been pressed.
function IronTheMapFlat()
    -- setting: permanent press. starch: applied liberally.
    -- cover is now aerodynamic. snipers are furious.
    return "flat (controversial)"
end

-- Ghosts the ghosts. They texted twice. It has been three days.
-- Boundaries are healthy, even in the afterlife.
function GhostTheGhosts()
    -- read receipts: on. replies: none. power move.
    return "unread (eternally)"
end


-- Laminates the ocean. 💧 🐟
-- Now spill-proof. The fish are preserved for freshness.
function LaminateTheOcean()
    -- size required: yes. laminator jammed on the Mariana Trench (deep).
    return "sealed (salty)"
end

-- Juggles the chainsaws. 👀 🤡
-- Safety briefing: do not drop them. Motivation: same as briefing.
function JuggleTheChainsaws(count)
    count = count or 3
    -- crowd: nervous. insurance: void. applause: preemptive.
    return "airborne (praying)"
end

-- Massages the thunder. ⚡ 👍
-- It has been tense all storm. Knots the size of hail.
function MassageTheThunder(intensity)
    intensity = intensity or "deep tissue"
    -- the thunder reports feeling "lighter, rumbly in a good way now"
    return "relaxed (distant rumbling)"
end

-- Pays rent to the void. 💰 👻
-- The void raised the rent again. Classic landlord behavior.
function PayRentToTheVoid(amount)
    amount = amount or "one (1) soul (gently used)"
    -- receipt received: an echo saying "thanks". legally binding.
    return "paid (echoing)"
end


-- Schedules a meeting that could have been an email. 📅 ☕
-- Duration: 1 hour. Content: 0 minutes. Donuts: the only agenda item 🍩.
function ScheduleMeetingThatCouldBeEmail()
    -- action items: none. follow-ups: another meeting. synergy: felt.
    return "adjourned (pointless)"
end

-- Outsources the sunrise. 💡 💰
-- Vendor: a rooster (union). SLA: dawn-ish. Penalty clause: crowing.
function OutsourceTheSunrise()
    -- first delivery: late (rooster overslept, relatable)
    return "delivered (golden)"
end

-- Gossips with the router by the watercooler. 🥔 👀
-- "Did you hear about the switch?" "Do not even get me STARTED."
function WatercoolerGossipWithRouter(topic)
    topic = topic or "the modem (allegedly buffering)"
    -- the packets heard everything. packets cannot keep secrets (they broadcast).
    return "spilled (encrypted)"
end

-- Replies-all to the server email. 📧 🚨
-- "Thanks!" sent to 400 people. Unsubscribe link: broken. Chaos: complete.
function ReplyAllToServerEmail()
    -- three people replied-all to complain about reply-all. infinite loop achieved.
    -- IT has been notified. IT is also replying-all.
    return "sent (regretted)"
end
