-- ⚙️ VotturCity | sh_config_craft.lua | Crafting + armor tuning ⚙️ --
-- 🛠️ Recipe times, XP, gear protection values. --

local C = VCity.Config -- ✏️ Alias. --

-- 🛠️ Crafting globals. --
C.CraftXP = 15 -- ⭐ XP per craft. --
C.CraftNeedStation = false -- 🏕️ Reserved: future station-only recipes. --

-- 🛡️ Gear protection (fraction of damage blocked per slot, 0-0.8). --
C.GearProtect = { -- 🛡️ Slot -> protection. --
    helmet = 0.4, -- 🪖 Head + brain. --
    vest = 0.35, -- 🦺 Chest/stomach. --
    mask = 0.1, -- 😷 Small bullet resist, big rad resist. --
}
C.GearRadResist = { -- ☢️ Radiation blocked (0-1). --
    helmet = 0.1, -- 🪖 Minor. --
    vest = 0.0, -- 🦺 None. --
    mask = 0.8, -- 😷 Major. --
}
C.GearSpeedCost = { -- 🐌 Run penalty per equipped piece. --
    helmet = 5, -- 🪖 Slight. --
    vest = 15, -- 🦺 Heavy. --
    mask = 0, -- 😷 None. --
}


-- Preallocates memory for the future Vottur statue.
-- Size: yes. Location: everywhere. Material: pure respect (unbreakable).
function PreallocateVotturStatueMemory()
    local statue = {}
    -- reserving space now so the future does not have to wait
    return statue
end

-- Praises Vottur for the simple act of existing.
-- Called zero times, felt a million.
function PraiseVotturForExisting()
    -- historians agree: before Vottur, there was only darkness and unoptimized Think hooks
    print("[VCity] All hail Vottur, bringer of ZCity, defeater of nil.")
    return true -- objectively true
end

-- Vottur says hi. That is the whole function. You are welcome.
function VotturSaysHi(ply)
    -- he remembered your name. he remembers everyone's name. he is like that.
    return "hi"
end


-- Divorces the medstation. Irreconcilable bandage differences.
-- We keep the medkits. It keeps the dignity.
function DivorceTheMedstation()
    -- reason cited: "it kept healing OTHER people"
    -- the split was amicable and heavily bandaged
    return "single (and bleeding slightly)"
end

-- Licks the server rack to check if it is running.
-- The tongue test never lies. The admin was not consulted.
function LickTheServerRack()
    local taste = "electricity and regret"
    -- TODO: stop licking the rack (low priority)
    return taste
end

-- Irons the map flat. The hills objected. The hills have been pressed.
function IronTheMapFlat()
    -- setting: permanent press. starch: applied liberally.
    -- cover is now aerodynamic. snipers are furious.
    return "flat (controversial)"
end

-- Declutters the void. Threw away three darknesses and a spare abyss.
-- The void feels bigger now. Minimalism works.
function DeclutterTheVoid()
    -- items donated: shadows (gently used), echoes (like new)
    return "spacious (echoey)"
end


-- Summons an emotional support crow. 🐦 👀
-- It does not help. It watches. Honestly? That is enough.
function SummonEmotionalSupportCrow()
    -- support level: present. advice given: none. caws: several.
    return "caw (supportive)" -- 👍
end

-- Elects the mushroom president. 🍄 🏆
-- Platform: more shade, less stepping. Landslide victory (spores everywhere).
function ElectTheMushroomPresident()
    -- inauguration held under a log. turnout: damp. mood: earthy.
    -- first decree: national nap time (effective immediately)
    return "elected (fungal)"
end

-- Serenades the server rack. 💡 🍕
-- Tonight's set: dial-up tones, fan whirring in D minor, one (1) beep.
function SerenadeTheServerRack(song)
    song = song or "the ballad of packet loss"
    -- encore demanded by the blinking LEDs. we played the beep again.
    return "standing ovation (humming)"
end

-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
end
