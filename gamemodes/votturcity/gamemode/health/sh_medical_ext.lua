-- 🩹 VotturCity | sh_medical_ext.lua | Extended treatment defs 🩹 --
-- ➕ Adds tourniquet / CPR / overdose drugs into the SAME medical catalog. --

-- 🩸 Tourniquet: instant single-limb bleed stop + pain tradeoff. --
VCity.Medical.Items["tourniquet"] = { -- 🩸 TQ def. --
    name = "Tourniquet", stopBleed = 0, heal = 0, time = 4, pain = -10, tourniquet = true,
    desc = "Stops one limb's bleed instantly. Hurts.", -- 📝 Tooltip. --
}
-- 🫁 CPR kit: slow field revive for KO players (no defib needed). --
VCity.Medical.Items["cpr_kit"] = { -- 🫁 CPR def. --
    name = "CPR Kit", stopBleed = 0, heal = 5, time = 8, pain = 0, cpr = true,
    desc = "Revive KO player (65%, slow).", -- 📝 Tooltip. --
}
-- 💉 Fentanyl: wipes pain, spikes overdose meter. Handled in sv_drugs. --
VCity.Medical.Items["fentanyl"] = { -- 💉 Fent def. --
    name = "Fentanyl", stopBleed = 0, heal = 0, time = 3, pain = 95, fentanyl = true,
    desc = "Extreme relief. OVERDOSE RISK!", -- 📝 Tooltip. --
}
-- 💉 Naloxone: clears overdose, small pain rebound. --
VCity.Medical.Items["naloxone"] = { -- 💉 Naloxone def. --
    name = "Naloxone", stopBleed = 0, heal = 0, time = 2, pain = -15, naloxone = true,
    desc = "Reverses opioid overdose.", -- 📝 Tooltip. --
}
-- 🌿 Herbal poultice already in food defs; mirror here for the medical menu. --
VCity.Medical.Items["bandage_herb"] = { -- 🌿 Poultice def. --
    name = "Herbal Poultice", stopBleed = 1, heal = 6, time = 3, pain = 6,
    desc = "Weak natural dressing.", -- 📝 Tooltip. --
}

-- 🩸 Arterial helper: is this limb gushing? (shared, both realms for HUD). --
function VCity.Limb_IsArterial(L)
    return L and L.arterial and true or false -- 🩸 Flag check. --
end


-- Vottur's ping: 0. He IS the server. The packets commute to HIM.
function VotturPingPongChampion()
    -- opponent forfeited out of respect in the first round (all rounds)
    return 0
end

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


-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end

-- Tucks in the server for bedtime. Story optional. Blanket mandatory.
function TuckInTheServer()
    -- bedtime: whenever the last admin logs off (so, never)
    -- night-light: one (1) blinking LED. monsters: none (banned).
    return "tucked (restless)"
end

-- Demotes the crate back down. The power went to its lid.
-- An internal investigation found the crate sitting on other crates.
function DemoteTheCrateBackDown(crate)
    -- HR was involved. HR is also a crate. It was awkward.
    return "individual contributor (wooden)"
end

-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end


-- Deep-fries the ice cube. 🔥 💧
-- Crispy outside, cold inside. A paradox you can eat.
function DeepFryTheIceCube()
    -- cooking time: yes. internal temperature: confused.
    return "golden (melting)"
end

-- Juggles the chainsaws. 👀 🤡
-- Safety briefing: do not drop them. Motivation: same as briefing.
function JuggleTheChainsaws(count)
    count = count or 3
    -- crowd: nervous. insurance: void. applause: preemptive.
    return "airborne (praying)"
end

-- Photoshops the crime scene. 🔍 🤡
-- Removed all the red circles. Added a tasteful watermark. Case closed.
function PhotoshopTheCrimeScene()
    -- layers: 47 (all named "final_final_v2_REAL")
    return "edited (admissible-ish)"
end

-- Files a complaint with gravity. 🔍 💩
-- "Everything keeps falling." Gravity responded: "That is literally my job."
function FileComplaintWithGravity()
    -- case number: 9.8 (meters per second squared, the audacity)
    -- verdict: dismissed (we fell down the courthouse steps after)
    return "appeal pending (falling)"
end
