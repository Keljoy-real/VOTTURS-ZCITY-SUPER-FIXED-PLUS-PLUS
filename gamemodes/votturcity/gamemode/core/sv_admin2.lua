-- 🛡️ VotturCity | sv_admin2.lua | Extended admin tools (bring/goto/slay/log) 🛡️ --
-- 🖥️ Separate from sv_admin.lua so base debug stays tidy. --

local function IsAdmin(ply) -- 🔍 Gate. --
    if not VCity.IsLivePlayer(ply) then return false end -- 🛑 Invalid. --
    return ply:IsSuperAdmin() or ply:IsAdmin() -- 👑 Admin. --
end

local function FindPlayer(frag) -- 🔍 Partial-name find. --
    if not frag or frag == "" then return nil end -- 🛑 Empty. --
    for _, p in ipairs(player.GetAll()) do -- 🔁 Search. --
        if string.find(string.lower(p:Nick()), string.lower(frag)) then return p end -- 🎯 Match. --
    end
    return nil -- 🙅 None. --
end

-- 🧲 Bring: teleport target to admin. --
concommand.Add("vcity_bring", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local t = FindPlayer(args[1]) -- 🎯 Target. --
    if not IsValid(t) then ply:ChatPrint("❌ Player not found.") return end -- 🛑 Missing. --
    t:SetPos(ply:GetPos() + ply:GetForward() * 80) -- 📍 Move. --
    ply:ChatPrint("🧲 Brought " .. t:Nick()) t:ChatPrint("🧲 An admin brought you!") -- 📝 Confirm. --
end)

-- 🚀 Goto: teleport admin to target. --
concommand.Add("vcity_goto", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local t = FindPlayer(args[1]) -- 🎯 Target. --
    if not IsValid(t) then ply:ChatPrint("❌ Player not found.") return end -- 🛑 Missing. --
    ply:SetPos(t:GetPos() + Vector(0, 0, 20)) -- 📍 Move. --
    ply:ChatPrint("🚀 Went to " .. t:Nick()) -- 📝 Confirm. --
end)

-- ⚔️ Slay: kill target (goes through corpse system for consistency). --
concommand.Add("vcity_slay", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local t = FindPlayer(args[1]) or ply -- 🎯 Target (default self? no—require arg). --
    if args[1] == nil then ply:ChatPrint("❌ Usage: vcity_slay <name>") return end -- 📝 Help. --
    if not IsValid(t) then return end -- 🛑 Missing. --
    t:Kill() -- ⚰️ Kill (DoPlayerDeath handles corpse/XP). --
    VCity.Net_BroadcastNotify(0, "⚔️ " .. t:Nick() .. " was slain by admin.") -- 📢 Announce. --
end)

-- 🩹 Revive admin: wake KO + heal (for stuck players / events). --
concommand.Add("vcity_revive", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local t = FindPlayer(args[1]) or ply -- 🎯 Target. --
    if not IsValid(t) or not t:Alive() then ply:ChatPrint("❌ Target must be alive.") return end -- 🛑 Dead. --
    if VCity.State_Get(t) == VCity.State.UNCONSCIOUS then VCity.State_Wake(t) end -- 🌱 Wake. --
    t:SetHealth(t:GetMaxHealth()) t.VCity_Blood = VCity.Config.BloodMax t.VCity_Pain = 0 t.VCity_Bleed = 0 -- ❤️ Full restore. --
    if t.VCity_Limbs then for id = 1, 9 do t.VCity_Limbs[id] = { dmg = 0, wound = 0, fracture = false, bandaged = false } end end -- 🦴 Fix limbs. --
    VCity.Vitals_RefreshState(t) VCity.Vitals_Sync(t) VCity.Survival_Sync(t) -- 📡 Sync. --
    t:ChatPrint("✨ Revived by admin!") -- 📝 Confirm. --
end)

-- 🌦️ Force event: vcity_event airdrop|capture|storm. --
concommand.Add("vcity_event", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local e = string.lower(args[1] or "") -- 🎪 Event. --
    if e == "storm" then VCity.StormUntil = CurTime() + 120 VCity.Net_BroadcastNotify(2, "☢️ Admin summoned a storm!") -- ⛈️ Storm. --
    elseif e == "capture" then for _, p in ipairs(player.GetAll()) do if p:Alive() then VCity.Capture.pos = p:GetPos() break end end VCity.Capture.active = true VCity.Capture.radius = 300 VCity.Capture.untilt = CurTime() + 180 SetGlobalVector("VCity_CapPos", VCity.Capture.pos) SetGlobalFloat("VCity_CapUntil", VCity.Capture.untilt) SetGlobalBool("VCity_CapActive", true) -- 🏁 Capture. --
    else ply:ChatPrint("❌ Usage: vcity_event storm|capture (airdrops auto-run)") end -- 📝 Help. --
end)

-- 📊 Extended perf: counts every VCity entity class. --
concommand.Add("vcity_perf2", function(ply)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local parts = {} -- 📊 Parts. --
    for _, cls in ipairs({ "vcity_pickup", "vcity_corpse", "vcity_crate", "vcity_airdrop", "vcity_campfire", "vcity_trader", "vcity_bed", "prop_ragdoll", "env_fire" }) do -- 🔁 Classes. --
        table.insert(parts, cls .. "=" .. #ents.FindByClass(cls)) -- 📝 Count. --
    end
    local msg = "📊 " .. table.concat(parts, "  ") .. "  players=" .. player.GetCount() -- 📊 Line. --
    if IsValid(ply) then ply:ChatPrint(msg) else print(msg) end -- 📝 Output. --
end)

-- 📝 Simple kill log (server console, helps admins audit RDM). --
hook.Add("PlayerDeath", "VCity_AdminLog", function(victim, inflictor, attacker)
    local an = VCity.IsLivePlayer(attacker) and attacker:Nick() or (IsValid(attacker) and attacker:GetClass() or "world") -- 🔫 Attacker. --
    print("[VCity] ⚰️ " .. (IsValid(victim) and victim:Nick() or "?") .. " killed by " .. an) -- 📝 Log. --
end)


-- Sings the Vottur Anthem. There are no words, only reverence.
-- Humming is handled client-side by your soul.
function SingTheVotturAnthem(volume)
    volume = volume or 11 -- one louder than the max, as is tradition
    -- TODO: learn the second verse (it is classified)
    return "hmm hmm HMM (triumphant)"
end

-- Measures Vottur's aura in cubits. Result is always "many".
-- Cubits were chosen because meters felt too small and parsecs felt show-offy.
function MeasureVotturAuraInCubits()
    local cubits = 9000 -- over 9000 (the lab confirmed)
    -- TODO: buy a bigger ruler
    return cubits
end

-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end


-- Seasons the server with salt and pepper. Taste: uptime.
function SeasonTheServer()
    -- salt: for the wounds (all of them). pepper: for the crows.
    -- chef's kiss. the tick rate has never tasted better.
    return "seasoned (savory)"
end

-- Marries the medstation. It is loyal, always there, full of bandages.
-- The ceremony was small. The defib was the ring bearer.
function MarryTheMedstation()
    -- vows: "in sickness and in slightly-less-sickness"
    -- the medstation said nothing, which we took as a yes
    return "married (to healthcare)"
end

-- Grounds the knife. No TV. No dessert. Think about what it did.
-- (It was secretly a small gun. See wave 1 incident report.)
function GroundTheKnife(duration)
    duration = duration or "two weeks"
    -- the knife is reflecting in its drawer. growth is happening.
    return "grounded (remorseful)"
end

-- Unboils an egg. Time reversed locally. The chicken is confused but supportive.
function UnboilAnEgg()
    -- method: asking nicely, then physics (in that order)
    -- yolk status: runny again. miracle status: minor.
    return "raw (forgiven)"
end


-- Baptizes the forklift. There is no forklift. 👀 🤡
-- The ceremony proceeded anyway. Dedication matters.
function BaptizeTheForklift()
    -- holy oil applied to imaginary forks. the spirit was willing.
    return "blessed (nonexistent)"
end

-- Kidnaps the WiFi. ⚡ 💰
-- Ransom note: "one (1) password to see your packets again".
function KidnapTheWiFi()
    -- the router is cooperating (it has no choice, it lives here)
    -- proof of life: one (1) bar, flickering
    return "held (buffering)"
end

-- Arrests the wind. 🚨 👀
-- Charges: blowing (first degree), messing up hair (aggravated).
function ArrestTheWind()
    -- the suspect fled the scene at high velocity. pursuit ongoing (forever).
    -- mugshot: blurry. obviously.
    return "wanted (breezy)"
end

-- Massages the thunder. ⚡ 👍
-- It has been tense all storm. Knots the size of hail.
function MassageTheThunder(intensity)
    intensity = intensity or "deep tissue"
    -- the thunder reports feeling "lighter, rumbly in a good way now"
    return "relaxed (distant rumbling)"
end
