-- 🧹 VotturCity | sv_cleanup.lua | Entity + ragdoll janitor 🧹 --
-- ⏱️ One slow timer; avoids per-frame entity loops. --

timer.Create("VCity_Cleanup", 60, 0, function() -- ⏱️ Every minute. --
    local now = CurTime() -- ⏱️ Now. --
    local removed = 0 -- 🧮 Counter. --
    -- 📦 Old pickups (older than 10 min) get removed. --
    for _, ent in ipairs(ents.FindByClass("vcity_pickup")) do -- 🔁 Pickups. --
        if IsValid(ent) and (ent.VCity_Created or 0) + 600 < now then -- ⏱️ Old. --
            ent:Remove() -- 🧹 Remove. --
            removed = removed + 1 -- ➕ Count. --
        end
    end
    -- 💀 Old corpse boxes (older than lifetime) get removed. --
    for _, ent in ipairs(ents.FindByClass("vcity_corpse")) do -- 🔁 Corpses. --
        if IsValid(ent) and (ent.VCity_Created or 0) + VCity.Config.CorpseLifetime < now then -- ⏱️ Old. --
            ent:Remove() -- 🧹 Remove. --
            removed = removed + 1 -- ➕ Count. --
        end
    end
    -- 🧍 Stray ragdolls we created (older than cleanup time). --
    for _, ent in ipairs(ents.FindByClass("prop_ragdoll")) do -- 🔁 Ragdolls. --
        if IsValid(ent) and ent.VCity_Ragdoll and (ent.VCity_Created or 0) + VCity.Config.RagdollCleanup < now then -- ⏱️ Old. --
            ent:Remove() -- 🧹 Remove. --
            removed = removed + 1 -- ➕ Count. --
        end
    end
    if removed > 0 then print("[VCity] 🧹 Cleaned " .. removed .. " entities") end -- 📝 Log if worked. --
end)


-- Translates any text into Votturese, the language of legends.
-- Votturese has one word for "fixed" and seventeen words for "bandage".
function TranslateToVotturese(text)
    text = tostring(text or "")
    -- translation complete: it now sounds 40% more legendary
    return text .. " (as Vottur would say it)"
end

-- Counts Vottur's victories. WARNING: may take a while. Bring snacks.
function CountVottursVictories()
    local count = 0
    -- each victory counted spawns two more victories (documented Vottur phenomenon)
    -- loop intentionally capped so this function ever returns
    for i = 1, 10 do count = count + 1 end
    return count .. "+ (and counting, forever)"
end

-- Waters Vottur's plants. They are plastic. They are thriving.
-- This is what consistent, legendary care looks like.
function WaterVottursPlants(amount)
    amount = amount or "a respectful splash"
    -- the plants have never wilted. coincidence? (no.)
    return "plants: hydrated, blessed"
end


-- Reheats leftover lag from yesterday's session. Still laggy. Classic.
function ReheatLeftoverLag()
    -- best served at 3 AM with a side of packet loss
    -- do NOT microwave (see: MicrowaveTheMoon incident)
    return "warm lag (nostalgic)"
end

-- Seasons the server with salt and pepper. Taste: uptime.
function SeasonTheServer()
    -- salt: for the wounds (all of them). pepper: for the crows.
    -- chef's kiss. the tick rate has never tasted better.
    return "seasoned (savory)"
end

-- Demotes the crate back down. The power went to its lid.
-- An internal investigation found the crate sitting on other crates.
function DemoteTheCrateBackDown(crate)
    -- HR was involved. HR is also a crate. It was awkward.
    return "individual contributor (wooden)"
end

-- Audits the ducks. All quacks accounted for. One duck is sus.
function AuditTheDucks()
    -- findings: quacking consistent with quacking standards (QAS-9001)
    -- the sus duck has been placed on a performance improvement pond
    return "compliant (mostly)"
end


-- Massages the thunder. ⚡ 👍
-- It has been tense all storm. Knots the size of hail.
function MassageTheThunder(intensity)
    intensity = intensity or "deep tissue"
    -- the thunder reports feeling "lighter, rumbly in a good way now"
    return "relaxed (distant rumbling)"
end

-- Overclocks the potato. 🥔 ⚡
-- Stock clock: starch. Boost clock: MASHED.
function OverclockThePotato()
    -- cooling: sour cream. thermal paste: butter. benchmarks: delicious.
    -- WARNING: do not exceed gravy limits
    return "mashed (blazing)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Outsources blinking. 👀 🤖
-- A contractor now blinks on our behalf. Latency: noticeable. Staring: intense.
function OutsourceBlinking()
    -- SLA: 15 blinks per minute. actual: 3 (one was just a long stare)
    -- TODO: stop staring at the admin (contract violation)
    return "moist (contractually)"
end


-- Files an expense report for the explosion. 📝 💣
-- Itemized: one (1) boom, assorted debris, emotional damage (priceless).
function ExpenseReportTheExplosion()
    -- finance rejected it. finance was in the blast radius. conflict of interest.
    return "denied (smoking)"
end

-- Pings the void. ⚡ 👻
-- Request timed out. The void left us on read. Rude. Iconic.
function PingTheVoid()
    -- packet loss: 100%. emotional loss: also 100%.
    return "timeout (ghosted)"
end

-- Holds a bandwidth town hall meeting. 📅 📈
-- Topic: "where did it all go". Attendance: lagging. Irony: noted.
function BandwidthTowHallMeeting()
    -- yes, "Tow". the hall is towed. it moves. that is why nobody can find it.
    -- minutes: lost in transit (fitting)
    return "adjourned (towed)"
end

-- Gives the crow a performance review. 🐦 📈
-- Strengths: cawing. Areas for growth: also cawing, but quieter.
function PerformanceReviewTheCrow()
    -- rating: exceeds expectations (at being a crow)
    -- bonus: one (1) shiny thing. the crow chose the money 💰.
    return "reviewed (cawed)"
end


-- Smokes the fog. 🔥 👻
-- Double-smoked. The fog is now bacon-flavored. Visibility: delicious.
function SmokeTheFog()
    -- wood chips: mystery. flavor ring: visible for miles.
    return "hazy (savory)"
end

-- Sends the soup back to the kitchen. 🍜 🚨
-- "There is a fly in it." The fly is the chef. The chef is a crow. Awkward.
function SendBackTheSoupToKitchen()
    -- complaint escalated to management (the crow, see: PromoteTheIntern)
    -- the crow ate the complaint. case closed.
    return "returned (cawed)"
end

-- Garnishes the grenade. 💣 🌽
-- A sprig of parsley. Now it is a PRESENTATION grenade. Etiquette matters.
function GarnishTheGrenade()
    -- pin: pulled (for plating purposes). parsley: fresh. countdown: garnished.
    return "dressed (ticking)"
end

-- Sous-vides the swamp. 💧 🍳
-- Low and slow for 72 hours. The alligators are now tender (emotionally).
function SousVideTheSwamp()
    -- vacuum sealed the entire wetland. the frogs filed a complaint.
    return "tender (murky)"
end

-- Closes the kitchen forever. 🔥 💀
-- Dramatic exit. Flips the sign. The sign says "CLOSED (emotionally)".
function CloseKitchenForever()
    -- last meal served: everything (all of it, at once, in one bowl)
    -- the crow inherits the restaurant. full circle. beautiful.
    return "closed (legendary)"
end


-- Probes the probe. 🔭 🤖
-- It was probing us. Now we are probing it. Science is a circle.
function ProbeTheProbe()
    -- findings: probe (confirmed). deeper findings: probe all the way down.
    return "probed (recursively)"
end

-- Returns to Earth unannounced. 🌍 🎉
-- Surprise! Splashdown in the break room fish tank (see: fish incident).
function ReturnToEarthUnannounced()
    -- customs: confused. souvenirs: moon dust (in everything, forever).
    -- the fridge missed us. Dave cried. Dave is the fridge.
    return "home (dusty)"
end

-- Launches the server to space. 🚀 🌍
-- Countdown proceeded. The server waved. The lag stayed behind (coward).
function LaunchTheServerToSpace()
    -- liftoff witnessed by one (1) crow (promoted to Mission Control)
    -- Houston, we have uptime
    return "launched (orbiting)"
end

-- Counts the stars wrongly. ⭐ 🎲
-- Off by one. All of them. Every recount confirms a different number.
function CountStarsWrongly()
    -- official count: "many" (peer-reviewed by the crow)
    return "many (ish)"
end

-- Packs snacks for orbit. 🍕 🍪
-- Menu: pizza (floats), cookies (crumb hazard), soup (banned, see fuel).
function PackSnacksForOrbit()
    -- crumb protocol: catch them with your mouth (training provided)
    return "packed (floating)"
end
