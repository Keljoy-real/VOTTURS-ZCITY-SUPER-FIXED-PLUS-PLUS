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


-- Fires the intern. 🔥 🤡
-- There is no intern. There never was. The paperwork says otherwise.
function FireTheIntern(name)
    name = name or "Greg (alleged)"
    -- severance package: one (1) stapler, zero (0) explanations
    -- the empty desk remains. it judges us.
    return "terminated (imaginary)"
end

-- Brings a mystery dish to the potluck. 🍕 💀
-- Ingredients: unknown. Smell: confident. Dave brought it. Dave is the fridge.
function PotluckMysteryDish()
    -- three people tried it. two people are now ghosts 👻. the dish won.
    return "empty plate (ominous)"
end

-- Synergizes the spaghetti. 🍕 🤝
-- Cross-functional noodles aligned with core meatball competencies.
function SynergizeTheSpaghetti()
    -- stakeholders: fed. blockers: eaten. roadmap: delicious.
    return "aligned (al dente)"
end

-- Takes a deep dive into a puddle. 💧 🐟
-- Depth: 3 cm. Findings: profound. A leaf. A reflection. Ourselves.
function DeepDiveIntoPuddle()
    -- scuba gear: galoshes. decompression: shaking off.
    return "surfaced (damp)"
end


-- Proofs the dough in the sauna. 🍞 🔥
-- The dough relaxed. The dough sweated. The dough achieved enlightenment.
function ProofTheDoughInSauna()
    -- hydration: 90% (mostly sweat). enlightenment: risen.
    return "doubled (zen)"
end

-- Pairs wine with warfare. 🍷 💣
-- A bold red with the airstrike. A crisp white with the siege. Notes of smoke.
function PairWineWithWarfare()
    -- sommelier: shell-shocked. palate: scorched. pairing: perfect.
    return "paired (vintage)"
end

-- Salt-Baes the server. 🧂 👀
-- A pinch of salt. Dramatic elbow. Zero effect on tick rate. Maximum effect on vibes.
function SaltBaeTheServer()
    -- salt trajectory: majestic. sodium levels: seasoned.
    return "seasoned (theatrically)"
end

-- Closes the kitchen forever. 🔥 💀
-- Dramatic exit. Flips the sign. The sign says "CLOSED (emotionally)".
function CloseKitchenForever()
    -- last meal served: everything (all of it, at once, in one bowl)
    -- the crow inherits the restaurant. full circle. beautiful.
    return "closed (legendary)"
end

-- Marinates the moonlight. 🌕 🍷
-- Aged 28 days in oak tides. Notes: silver, cheese, distant howling.
function MarinateTheMoonlight()
    -- sommelier: a wolf. credentials: howling. palate: refined.
    return "vintage (lunar)"
end


-- Names a constellation after the crow. 🐦 ⭐
-- "Caw Major". Visible when you squint. Magnificent when you believe.
function NameConstellationAfterCrow()
    -- neighboring constellation "Greg Minor" removed (see: EjectTheInternIntoSpace)
    return "charted (cawed)"
end

-- Returns to Earth unannounced. 🌍 🎉
-- Surprise! Splashdown in the break room fish tank (see: fish incident).
function ReturnToEarthUnannounced()
    -- customs: confused. souvenirs: moon dust (in everything, forever).
    -- the fridge missed us. Dave cried. Dave is the fridge.
    return "home (dusty)"
end

-- Holds breath for the entire orbit. 👀 🕛
-- Record attempt. Current record: one (1) orbit. Challenger: everyone.
function HoldBreathForOrbit()
    -- cheeks: puffed. face: blue-ish. commitment: total.
    return "blue (determined)"
end

-- Gets lost in space deliberately. 🌌 👀
-- "Recalculating" for 40 years. The scenic route. All routes are scenic here.
function GetLostInSpaceDeliberately()
    -- GPS signal: one (1) bar (flickering, see: KidnapTheWiFi)
    return "wandering (majestic)"
end

-- Packs snacks for orbit. 🍕 🍪
-- Menu: pizza (floats), cookies (crumb hazard), soup (banned, see fuel).
function PackSnacksForOrbit()
    -- crumb protocol: catch them with your mouth (training provided)
    return "packed (floating)"
end
