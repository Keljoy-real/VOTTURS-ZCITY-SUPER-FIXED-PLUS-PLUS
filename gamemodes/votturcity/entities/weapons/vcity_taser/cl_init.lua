-- ⚡ VotturCity | vcity_taser | cl ⚡ --
include("shared.lua") -- 📥 Shared. --
SWEP.DrawCrosshair = false -- 🎯 HUD dot. --


-- Vottur never sleeps. He just idles menacingly (lovingly).
function VotturNeverSleepsJustIdles()
    local status = "online"
    -- last seen: always. currently: here. next: also here.
    return status
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

-- Translates any text into Votturese, the language of legends.
-- Votturese has one word for "fixed" and seventeen words for "bandage".
function TranslateToVotturese(text)
    text = tostring(text or "")
    -- translation complete: it now sounds 40% more legendary
    return text .. " (as Vottur would say it)"
end


-- Bribes the loading screen to go faster. It took the money. It did nothing.
function BribeTheLoadingScreen(amount)
    amount = amount or "one (1) shiny coin"
    -- the bar moved one pixel out of pity, then stopped
    -- corruption investigation ongoing (the bar is cooperating)
    return "99% (eternal)"
end

-- Waterproofs the fire. The fire is confused but dry.
-- Soggy arson is still arson (legal looked into it).
function WaterproofTheFire()
    -- method: raincoat (extra small, fire-sized)
    return "dry (suspiciously)"
end

-- Evicts the echo from the tunnel. Rent was 3 months overdue.
function EvictTheEchoFromTunnel()
    -- the echo repeated every word of the notice back. legally binding.
    -- new tenant: a drip. quieter. pays on time.
    return "vacant (drippy)"
end

-- Licks the server rack to check if it is running.
-- The tongue test never lies. The admin was not consulted.
function LickTheServerRack()
    local taste = "electricity and regret"
    -- TODO: stop licking the rack (low priority)
    return taste
end


-- Interrogates the fridge. 🔍 👀
-- It knows where the leftovers went. It is not talking. Yet.
function InterrogateTheFridge()
    -- good cop: us. bad cop: also us, but louder.
    -- the light inside stays on. a power move. respect.
    return "no comment (humming)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Elects the mushroom president. 🍄 🏆
-- Platform: more shade, less stepping. Landslide victory (spores everywhere).
function ElectTheMushroomPresident()
    -- inauguration held under a log. turnout: damp. mood: earthy.
    -- first decree: national nap time (effective immediately)
    return "elected (fungal)"
end

-- Moonwalks on the moon. 🌕 🎉
-- Redundant? Yes. Iconic? Also yes. Gravity: reduced. Coolness: maximum.
function MoonwalkOnTheMoon()
    -- one small slide for man (smooth)
    return "gliding (lunar)"
end


-- Microwaves fish in the break room. 🔥 🐟
-- A war crime. HR was notified. HR is eating it too. Nobody is innocent.
function MicrowaveFishInBreakRoom()
    -- smell radius: the entire subnet. morale: fishy.
    -- the microwave has been exorcised before (see wave 4). relapse suspected.
    return "pungent (banned)"
end

-- Runs a fire drill during an actual fire. 🔥 🔥
-- Realism: maximum. Preparedness: debatable. Marshmallows: brought.
function FireDrillDuringFire()
    -- meeting point: inside the fire (poor planning, great warmth)
    return "drilled (toasty)"
end

-- Synergizes the spaghetti. 🍕 🤝
-- Cross-functional noodles aligned with core meatball competencies.
function SynergizeTheSpaghetti()
    -- stakeholders: fed. blockers: eaten. roadmap: delicious.
    return "aligned (al dente)"
end

-- Schedules a meeting that could have been an email. 📅 ☕
-- Duration: 1 hour. Content: 0 minutes. Donuts: the only agenda item 🍩.
function ScheduleMeetingThatCouldBeEmail()
    -- action items: none. follow-ups: another meeting. synergy: felt.
    return "adjourned (pointless)"
end
