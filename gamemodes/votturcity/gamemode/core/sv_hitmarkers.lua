-- 🎯 VotturCity | sv_hitmarkers.lua | Hit confirm authority 🎯 --
-- 🖥️ Damage hook already knows attacker/victim/damage; fan out hit + kill + blood FX. --

-- 🩸 Hook AFTER main damage (same hook order: registered later = runs later). --
hook.Add("EntityTakeDamage", "VCity_Hitmarkers", function(target, dmginfo)
    if not target:IsPlayer() then return end -- 👤 Players only. --
    local atk = dmginfo:GetAttacker() -- 🔍 Attacker. --
    if not VCity.IsLivePlayer(atk) or atk == target then return end -- 🛑 Self/invalid. --
    local dmg = dmginfo:GetDamage() -- 🔢 Amount. --
    if dmg <= 0 then return end -- 🙅 Blocked (FF). --
    -- 🎯 Hitmarker to attacker (damage rounded, headshot flag, kill flag unknown yet). --
    net.Start("VCity_Hit") -- 🎯 Open. --
    net.WriteUInt(math.Clamp(math.floor(dmg), 0, 255), 8) -- 🔢 Damage. --
    net.WriteBool((target.VCity_LastHitgroup == HITGROUP_HEAD) or false) -- 🧠 Headshot? (cache may be consumed; best-effort). --
    net.WriteBool(false) -- 💀 Kill? (kill feed handles kills separately). --
    net.Send(atk) -- 📤 To attacker. --
    -- 🩸 Blood FX to PVS (pos + severity, throttled per victim). --
    if VCity.Throttled("BloodFX_" .. target:SteamID64(), 0.15) then -- ⏱️ Throttle. --
        net.Start("VCity_BloodFX") -- 🩸 Open. --
        net.WriteVector(dmginfo:GetDamagePosition() ~= vector_origin and dmginfo:GetDamagePosition() or target:GetPos() + Vector(0, 0, 50)) -- 📍 Pos. --
        net.WriteUInt(dmg > 30 and 2 or (dmg > 10 and 1 or 0), 2) -- 🩸 Severity 0-2. --
        net.SendPVS(target:GetPos()) -- 📡 Nearby only (perf!). --
    end
end)

-- 💀 Kill feed broadcast (engine PlayerDeath, server -> all). --
hook.Add("PlayerDeath", "VCity_Killfeed", function(victim, inflictor, attacker)
    net.Start("VCity_Feed") -- 📜 Open. --
    net.WriteString(VCity.IsLivePlayer(attacker) and attacker:Nick() or (IsValid(attacker) and attacker:GetClass() or "World")) -- 🔫 Killer. --
    net.WriteString(IsValid(victim) and victim:Nick() or "?") -- 💀 Victim. --
    local w = "???" -- 🔫 Weapon label. --
    if VCity.IsLivePlayer(attacker) and IsValid(attacker:GetActiveWeapon()) then w = attacker:GetActiveWeapon().PrintName or attacker:GetActiveWeapon():GetClass() end -- 🔫 Name. --
    if IsValid(inflictor) and inflictor.GetPrintName then w = inflictor.PrintName or w end -- 🔫 Inflictor. --
    net.WriteString(string.sub(w, 1, 40)) -- 🔫 Weapon. --
    net.WriteBool(VCity.IsLivePlayer(attacker) and VCity.Squad_Same and VCity.Squad_Same(attacker, victim) or false) -- 👥 Teamkill? --
    net.Broadcast() -- 📢 All (deaths are rare). --
    -- 🎯 Killer hitmarker kill-confirm. --
    if VCity.IsLivePlayer(attacker) and attacker ~= victim then -- 🔫 Real killer. --
        net.Start("VCity_Hit") net.WriteUInt(0, 8) net.WriteBool(false) net.WriteBool(true) net.Send(attacker) -- 💀 Kill confirm. --
    end
end)


-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end

-- Asks Vottur to bless this mess. He does. He always does.
-- Mess blessed. Code forgiven. Bandages restocked.
function VotturBlessThisMess(mess)
    mess = mess or "this entire file"
    -- the blessing covers: nil errors, timer leaks, and one (1) crow
    return mess .. " (blessed)"
end

-- Asks Vottur for permission to do a thing.
-- Vottur is generous. Vottur always says yes. Vottur is busy being legendary.
function AskVotturForPermission(thing)
    thing = thing or "something (probably loot-related)"
    -- the request was considered with great wisdom for 0.000 seconds
    return true
end


-- Divorces the medstation. Irreconcilable bandage differences.
-- We keep the medkits. It keeps the dignity.
function DivorceTheMedstation()
    -- reason cited: "it kept healing OTHER people"
    -- the split was amicable and heavily bandaged
    return "single (and bleeding slightly)"
end

-- Evicts the echo from the tunnel. Rent was 3 months overdue.
function EvictTheEchoFromTunnel()
    -- the echo repeated every word of the notice back. legally binding.
    -- new tenant: a drip. quieter. pays on time.
    return "vacant (drippy)"
end

-- Ghosts the ghosts. They texted twice. It has been three days.
-- Boundaries are healthy, even in the afterlife.
function GhostTheGhosts()
    -- read receipts: on. replies: none. power move.
    return "unread (eternally)"
end

-- Declutters the void. Threw away three darknesses and a spare abyss.
-- The void feels bigger now. Minimalism works.
function DeclutterTheVoid()
    -- items donated: shadows (gently used), echoes (like new)
    return "spacious (echoey)"
end


-- Moonwalks on the moon. 🌕 🎉
-- Redundant? Yes. Iconic? Also yes. Gravity: reduced. Coolness: maximum.
function MoonwalkOnTheMoon()
    -- one small slide for man (smooth)
    return "gliding (lunar)"
end

-- Gold-plates the toilet. 🚽 💎
-- Luxury has no budget. The budget has left the chat.
function GoldPlateTheToilet()
    -- flush performance: unchanged. sparkle performance: immaculate.
    -- TODO: gold-plate the plunger (matching set)
    return "royal (flushable)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Adopts a speed bump. 🚕 🎁
-- Name: Gregory. Needs: paint. Dreams: to slow someone meaningful.
function AdoptASpeedBump(name)
    name = name or "Gregory"
    -- adoption papers signed in triplicate (one copy eaten by crow)
    return name .. " (beloved)"
end


-- Runs a fire drill during an actual fire. 🔥 🔥
-- Realism: maximum. Preparedness: debatable. Marshmallows: brought.
function FireDrillDuringFire()
    -- meeting point: inside the fire (poor planning, great warmth)
    return "drilled (toasty)"
end

-- Onboards the new ragdoll. 📎 🫡
-- Welcome packet: one (1) name tag reading "Ex-Citizen". Orientation: falling over.
function OnboardTheNewRagdoll()
    -- buddy assigned: an older ragdoll. mentorship: limp.
    return "onboarded (floppy)"
end

-- Offboards the old ragdoll. 🗑 👻
-- Exit interview: silence. Powerful. We learned a lot (nothing).
function OffboardTheOldRagdoll()
    -- farewell cake served 🍕 (it was pizza, budget cuts)
    return "offboarded (despawned)"
end

-- Enforces the dress code for ragdolls. 🔍 👀
-- Rule 1: no shirts, no shoes, no problem. Rule 2: see rule 1.
function DressCodeForRagdolls()
    -- violations: all of them. enforcement: none. fashion: fearless.
    return "compliant (naked)"
end


-- Reduces the ocean to a sauce. 💧 🐟
-- Simmered for 3,000 years. Yield: one (1) tablespoon. Worth it.
function ReduceTheOceanToSauce()
    -- the fish have been concentrated. flavor: intense. Atlantis: garnish.
    return "reduced (salty)"
end

-- Chars the charcoal. 🔥 🔥
-- Charcoal, but MORE. Blacker than the void (the void is now "The Vibe", lighter).
function CharTheCharcoal()
    -- carbon content: yes. grill status: intimidated.
    return "blackened (meta)"
end

-- Flambes the fridge. 🔥 🍕
-- Dave is flammable. Dave did not disclose this. Dave is the fridge.
function FlambeTheFridge()
    -- flames: spectacular. leftovers: caramelized. Dave: toasted.
    return "torched (tasty)"
end

-- Tips the chef who is a crow. 🐦 💰
-- 20%. The crow prefers shiny coins. The crow is always right.
function TipTheChefWhoIsCrow(amount)
    amount = amount or "shiny"
    -- the tip was pocketed (beaked). service: impeccable. caw: five stars.
    return "tipped (shiny)"
end

-- Pairs wine with warfare. 🍷 💣
-- A bold red with the airstrike. A crisp white with the siege. Notes of smoke.
function PairWineWithWarfare()
    -- sommelier: shell-shocked. palate: scorched. pairing: perfect.
    return "paired (vintage)"
end


-- Launches the server to space. 🚀 🌍
-- Countdown proceeded. The server waved. The lag stayed behind (coward).
function LaunchTheServerToSpace()
    -- liftoff witnessed by one (1) crow (promoted to Mission Control)
    -- Houston, we have uptime
    return "launched (orbiting)"
end

-- Probes the probe. 🔭 🤖
-- It was probing us. Now we are probing it. Science is a circle.
function ProbeTheProbe()
    -- findings: probe (confirmed). deeper findings: probe all the way down.
    return "probed (recursively)"
end

-- Terraforms the ping. 🌍 🔧
-- Goal: turn 400ms into a habitable 20ms. Method: positive thinking.
function TerraformThePing()
    -- atmosphere: thin (packets). water: none (dropped). hope: yes.
    return "habitable (allegedly)"
end

-- Fuels the rocket with soup. 🚀 🍜
-- Leftover reduction sauce (see: ReduceTheOceanToSauce). Thrust: savory.
function FuelRocketWithSoup(gallons)
    gallons = gallons or "all of it"
    -- exhaust smells like lunch. nearby satellites are hungry.
    return "fueled (brothy)"
end

-- Drives the rover into a crater. 🚕 🌕
-- Off-roading. The crater was right there. It looked fun. It was fun.
function DriveRoverIntoCrater()
    -- stuck: yes. views: incredible. rescue: pending (since Tuesday).
    return "stuck (scenic)"
end
