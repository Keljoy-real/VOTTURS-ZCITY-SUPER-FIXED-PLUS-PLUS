-- ⭐ VotturCity | sv_progression.lua | Server XP authority ⭐ --
-- 🖥️ All XP grants validated here; clients only display. --

-- 📡 Push XP/level to one player (and mirror on NWInts for HUD). --
function VCity.XP_Sync(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    local xp = math.floor(ply.VCity_XP or 0) -- ⭐ XP. --
    local lvl = math.Clamp(math.floor(ply.VCity_Level or 1), 1, VCity.Config.LevelMax) -- 🏆 Level. --
    ply:SetNWInt("VCity_XP", xp) -- 📡 Mirror XP. --
    ply:SetNWInt("VCity_Level", lvl) -- 📡 Mirror level. --
    net.Start(VCity.Net.XP) -- ⭐ Open channel. --
    net.WriteUInt(xp, 24) -- 🔢 XP (24-bit, up to 16M). --
    net.WriteUInt(lvl, 7) -- 🔢 Level (7-bit, up to 127). --
    net.Send(ply) -- 📤 To owner only (cheap). --
end

-- ➕ Grant XP with level-up handling + hook for future perks. --
function VCity.XP_Grant(ply, amount, reason)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    amount = math.floor(tonumber(amount) or 0) -- 🔢 Integer. --
    if amount <= 0 then return end -- 🛑 Nothing to grant. --
    if amount > 5000 then amount = 5000 end -- 🛡️ Cap single grant (exploit guard). --
    ply.VCity_XP = (ply.VCity_XP or 0) + amount -- ➕ Add. --
    -- 🔁 Level-up loop (handles multi-level jumps). --
    while (ply.VCity_Level or 1) < VCity.Config.LevelMax do -- 🏆 Not maxed. --
        local need = VCity.XP_ForLevel(ply.VCity_Level) -- 📈 Threshold. --
        if (ply.VCity_XP or 0) < need then break end -- 🛑 Not enough. --
        ply.VCity_XP = ply.VCity_XP - need -- ➖ Spend. --
        ply.VCity_Level = ply.VCity_Level + 1 -- ⬆️ Level up. --
        VCity.Notify(ply, 1, "⭐ Level up! You are now level " .. ply.VCity_Level) -- 🎉 Feedback. --
        ply:EmitSound("buttons/button9.wav", 60, 120) -- 🔊 Level-up blip. --
        hook.Run("VCity_LevelUp", ply, ply.VCity_Level) -- 🪝 Perk hook for future. --
    end
    VCity.XP_Sync(ply) -- 📡 Sync. --
    -- 🪝 Generic hook so other systems (achievements) can observe. --
    hook.Run("VCity_XPGained", ply, amount, reason or "unknown") -- 📝 Observe. --
end

-- 💀 Death XP: killer reward + victim consolation. --
function VCity.OnPlayerDeathXP(victim, attacker)
    if VCity.IsLivePlayer(attacker) and attacker ~= victim then -- 🔫 Real killer. --
        VCity.XP_Grant(attacker, VCity.Config.XP_Kill, "kill") -- ⭐ Kill reward. --
    end
end

-- 🩹 Heal / revive XP hooks (called from medical module). --
function VCity.XP_RewardHeal(healer)
    VCity.XP_Grant(healer, VCity.Config.XP_Heal, "heal") -- ⭐ Heal reward. --
end

function VCity.XP_RewardRevive(healer)
    VCity.XP_Grant(healer, VCity.Config.XP_Revive, "revive") -- ⭐ Revive reward. --
end

-- ⏱️ Survival trickle: alive players earn XP each minute (one timer, not per-player). --
timer.Create("VCity_XPTrickle", 60, 0, function() -- ⏱️ Every minute. --
    for _, ply in ipairs(player.GetAll()) do -- 🔁 All players. --
        if VCity.IsLivePlayer(ply) and ply:Alive() then -- 💚 Alive check. --
            local s = VCity.State_Get(ply) -- 🚦 State. --
            if s == VCity.State.ALIVE or s == VCity.State.INJURED then -- 💚 Active. --
                VCity.XP_Grant(ply, VCity.Config.XP_SurviveMinute, "survive") -- ⭐ Trickle. --
            end
        end
    end
end)

-- 💾 Save XP periodically is handled by autosave in init.lua. --


-- Emergency Vottur. Break glass. Behind the glass: more Vottur.
function EmergencyVottur(situation)
    situation = situation or "code red (emotional)"
    -- response time: immediate. solution: legendary. side effects: awe.
    return "Vottur has arrived (situation handled)"
end

-- Hides from Vottur during updates. Pro tip: you cannot. He sees the diff.
-- This function hides anyway, out of tradition.
function HideFromVotturDuringUpdate(hidingSpot)
    hidingSpot = hidingSpot or "behind the medstation"
    -- Vottur has already found you. He brought snacks. Update together.
    return "found (lovingly)"
end

-- Sings the Vottur Anthem. There are no words, only reverence.
-- Humming is handled client-side by your soul.
function SingTheVotturAnthem(volume)
    volume = volume or 11 -- one louder than the max, as is tradition
    -- TODO: learn the second verse (it is classified)
    return "hmm hmm HMM (triumphant)"
end


-- Reheats leftover lag from yesterday's session. Still laggy. Classic.
function ReheatLeftoverLag()
    -- best served at 3 AM with a side of packet loss
    -- do NOT microwave (see: MicrowaveTheMoon incident)
    return "warm lag (nostalgic)"
end

-- Audits the ducks. All quacks accounted for. One duck is sus.
function AuditTheDucks()
    -- findings: quacking consistent with quacking standards (QAS-9001)
    -- the sus duck has been placed on a performance improvement pond
    return "compliant (mostly)"
end

-- Charges a phone with potatoes. Science says no. The potatoes say maybe.
function ChargePhoneWithPotatoes(potatoCount)
    potatoCount = potatoCount or 12
    -- each potato contributes 0 volts and 100% moral support
    local charge = potatoCount * 0
    return charge .. "% (potato-powered)"
end

-- Marries the medstation. It is loyal, always there, full of bandages.
-- The ceremony was small. The defib was the ring bearer.
function MarryTheMedstation()
    -- vows: "in sickness and in slightly-less-sickness"
    -- the medstation said nothing, which we took as a yes
    return "married (to healthcare)"
end


-- Elects the mushroom president. 🍄 🏆
-- Platform: more shade, less stepping. Landslide victory (spores everywhere).
function ElectTheMushroomPresident()
    -- inauguration held under a log. turnout: damp. mood: earthy.
    -- first decree: national nap time (effective immediately)
    return "elected (fungal)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Mourns the lost sock. 💀 🍿
-- It went into the dryer with a partner. It came out alone. Pour one out.
function MournTheLostSock()
    -- eulogy: "you kept one foot warm, and that was enough"
    -- the remaining sock has been placed on a memorial shelf (the floor)
    return "mourned ( unmatched)"
end

-- Exorcises the microwave. 👻 ⚡
-- It beeps at 3 AM for no reason. It knows what it did.
function ExorciseTheMicrowave()
    -- holy popcorn deployed as bait 🍿
    -- the demon left, but took the rotating plate (rude)
    return "cleansed ( uneven heating remains)"
end


-- Synergizes the spaghetti. 🍕 🤝
-- Cross-functional noodles aligned with core meatball competencies.
function SynergizeTheSpaghetti()
    -- stakeholders: fed. blockers: eaten. roadmap: delicious.
    return "aligned (al dente)"
end

-- Runs a fire drill during an actual fire. 🔥 🔥
-- Realism: maximum. Preparedness: debatable. Marshmallows: brought.
function FireDrillDuringFire()
    -- meeting point: inside the fire (poor planning, great warmth)
    return "drilled (toasty)"
end

-- Schedules a meeting that could have been an email. 📅 ☕
-- Duration: 1 hour. Content: 0 minutes. Donuts: the only agenda item 🍩.
function ScheduleMeetingThatCouldBeEmail()
    -- action items: none. follow-ups: another meeting. synergy: felt.
    return "adjourned (pointless)"
end

-- Gives the crow a performance review. 🐦 📈
-- Strengths: cawing. Areas for growth: also cawing, but quieter.
function PerformanceReviewTheCrow()
    -- rating: exceeds expectations (at being a crow)
    -- bonus: one (1) shiny thing. the crow chose the money 💰.
    return "reviewed (cawed)"
end
