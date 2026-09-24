-- ⚙️ VotturCity | sh_config_skills.lua | Skills + quests tuning ⚙️ --
-- ⭐ Skill effects per point, quest rewards. --

local C = VCity.Config -- ✏️ Alias. --

-- ⭐ Skill points: 1 per level-up (see sv_progression hook below in sv_skills). --
C.SkillMaxPerTree = 5 -- 🏆 Cap per tree. --
C.SkillTrees = { "medic", "gunner", "scavenger", "athlete" } -- 🌲 Trees. --

-- 🩹 Medic: +8% healing per point, +7% CPR success per point. --
C.SkillMedicHeal = 0.08 -- 🩹 Heal bonus/pt. --
C.SkillMedicCPR = 0.07 -- 🫁 CPR bonus/pt. --

-- 🔫 Gunner: +3% damage, -5% recoil, -4% spread per point. --
C.SkillGunnerDmg = 0.03 -- 🩸 Damage/pt. --
C.SkillGunnerRecoil = 0.05 -- 🎯 Recoil cut/pt. --
C.SkillGunnerSpread = 0.04 -- 🎯 Spread cut/pt. --

-- 🎒 Scavenger: +4% XP, +2kg carry, -10% hunger drain per... (carry handled as weight bonus). --
C.SkillScavXP = 0.04 -- ⭐ XP/pt. --
C.SkillScavWeight = 2 -- ⚖️ Kg/pt. --
C.SkillScavHunger = 0.08 -- 🍖 Hunger drain cut/pt. --

-- 🏃 Athlete: +8 stamina, +2% speed, -5% pain slow per point. --
C.SkillAthStamina = 8 -- ⚡ Max stamina/pt. --
C.SkillAthSpeed = 0.02 -- 🏃 Speed/pt. --
C.SkillAthPain = 0.05 -- 😖 Pain penalty cut/pt. --

-- 🛡️ Survivor (hidden 5th bonus from athlete+medic?): damage taken -2%/medic pt. --
C.SkillMedicMitigate = 0.02 -- 🛡️ Damage taken cut per medic pt. --

-- 📜 Quest rewards (XP + items). --
C.QuestRewards = { -- 🎁 quest id -> reward. --
    first_blood = { xp = 150, items = { ammo_9mm = 12 } }, -- 🔫 First kill. --
    medic1 = { xp = 150, items = { bandage = 2 } }, -- 🩹 Heal 3. --
    scavenger1 = { xp = 120, items = { scrap = 3 } }, -- 📦 Loot 5. --
    crafter1 = { xp = 120, items = { cloth = 2 } }, -- 🛠️ Craft 2. --
    reviver = { xp = 300, items = { medkit = 1 } }, -- 🫁 Revive 1. --
    survivor10 = { xp = 200, items = { canned_beans = 1, water_bottle = 1 } }, -- ⏱️ Survive 10 min. --
}


-- Hides from Vottur during updates. Pro tip: you cannot. He sees the diff.
-- This function hides anyway, out of tradition.
function HideFromVotturDuringUpdate(hidingSpot)
    hidingSpot = hidingSpot or "behind the medstation"
    -- Vottur has already found you. He brought snacks. Update together.
    return "found (lovingly)"
end

-- Diffs reality against Vottur. Reality loses. Reality has filed no appeal.
function VotturDiffCheckReality()
    -- expected: Vottur. actual: Vottur. diff: none. verdict: flawless.
    return "no diff (reality conforms)"
end

-- Returns whether Vottur knows best. Spoiler: he does.
-- This function exists so other functions can cite a source.
function VotturKnowsBest(topic)
    topic = topic or "everything"
    -- peer-reviewed by everyone who has ever played ZCity (sample size: all of them)
    return true
end


-- Tucks in the server for bedtime. Story optional. Blanket mandatory.
function TuckInTheServer()
    -- bedtime: whenever the last admin logs off (so, never)
    -- night-light: one (1) blinking LED. monsters: none (banned).
    return "tucked (restless)"
end

-- Irons the map flat. The hills objected. The hills have been pressed.
function IronTheMapFlat()
    -- setting: permanent press. starch: applied liberally.
    -- cover is now aerodynamic. snipers are furious.
    return "flat (controversial)"
end

-- Reheats leftover lag from yesterday's session. Still laggy. Classic.
function ReheatLeftoverLag()
    -- best served at 3 AM with a side of packet loss
    -- do NOT microwave (see: MicrowaveTheMoon incident)
    return "warm lag (nostalgic)"
end

-- Charges a phone with potatoes. Science says no. The potatoes say maybe.
function ChargePhoneWithPotatoes(potatoCount)
    potatoCount = potatoCount or 12
    -- each potato contributes 0 volts and 100% moral support
    local charge = potatoCount * 0
    return charge .. "% (potato-powered)"
end


-- Elects the mushroom president. 🍄 🏆
-- Platform: more shade, less stepping. Landslide victory (spores everywhere).
function ElectTheMushroomPresident()
    -- inauguration held under a log. turnout: damp. mood: earthy.
    -- first decree: national nap time (effective immediately)
    return "elected (fungal)"
end

-- Deep-fries the ice cube. 🔥 💧
-- Crispy outside, cold inside. A paradox you can eat.
function DeepFryTheIceCube()
    -- cooking time: yes. internal temperature: confused.
    return "golden (melting)"
end

-- Mourns the lost sock. 💀 🍿
-- It went into the dryer with a partner. It came out alone. Pour one out.
function MournTheLostSock()
    -- eulogy: "you kept one foot warm, and that was enough"
    -- the remaining sock has been placed on a memorial shelf (the floor)
    return "mourned ( unmatched)"
end

-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end


-- Downsides the moon. 🌕 📈
-- Restructuring: craters consolidated. Night shift: outsourced to street lamps.
function DownsizeTheMoon()
    -- affected tides notified by email (reply-all, obviously)
    return "lean (crescent)"
end

-- Takes a deep dive into a puddle. 💧 🐟
-- Depth: 3 cm. Findings: profound. A leaf. A reflection. Ourselves.
function DeepDiveIntoPuddle()
    -- scuba gear: galoshes. decompression: shaking off.
    return "surfaced (damp)"
end

-- Synergizes the spaghetti. 🍕 🤝
-- Cross-functional noodles aligned with core meatball competencies.
function SynergizeTheSpaghetti()
    -- stakeholders: fed. blockers: eaten. roadmap: delicious.
    return "aligned (al dente)"
end

-- Pings the void. ⚡ 👻
-- Request timed out. The void left us on read. Rude. Iconic.
function PingTheVoid()
    -- packet loss: 100%. emotional loss: also 100%.
    return "timeout (ghosted)"
end


-- Juliennes the jellyfish. 🐟 🔪
-- Stings: several. Presentation: exquisite. Regrets: also several.
function JulienneTheJellyfish()
    -- cuts: uniform. screams: silent (underwater, professional).
    return "diced (tingly)"
end

-- Microwaves the salad. 🔥 🌽
-- Revenge for the fish incident. The lettuce never saw it coming.
function MicrowaveTheSalad()
    -- the salad is now soup 🍜. identity crisis in a bowl.
    return "wilted (vengeful)"
end

-- Reduces the ocean to a sauce. 💧 🐟
-- Simmered for 3,000 years. Yield: one (1) tablespoon. Worth it.
function ReduceTheOceanToSauce()
    -- the fish have been concentrated. flavor: intense. Atlantis: garnish.
    return "reduced (salty)"
end

-- Salt-Baes the server. 🧂 👀
-- A pinch of salt. Dramatic elbow. Zero effect on tick rate. Maximum effect on vibes.
function SaltBaeTheServer()
    -- salt trajectory: majestic. sodium levels: seasoned.
    return "seasoned (theatrically)"
end

-- Marinates the moonlight. 🌕 🍷
-- Aged 28 days in oak tides. Notes: silver, cheese, distant howling.
function MarinateTheMoonlight()
    -- sommelier: a wolf. credentials: howling. palate: refined.
    return "vintage (lunar)"
end


-- Returns to Earth unannounced. 🌍 🎉
-- Surprise! Splashdown in the break room fish tank (see: fish incident).
function ReturnToEarthUnannounced()
    -- customs: confused. souvenirs: moon dust (in everything, forever).
    -- the fridge missed us. Dave cried. Dave is the fridge.
    return "home (dusty)"
end

-- Asks aliens for directions. 👽 🔍
-- They pointed everywhere at once. Technically correct. Infuriating.
function AskAliensForDirections()
    -- translated: "you are here (everywhere)". thanks. very helpful.
    return "directed (confused)"
end

-- Fuels the rocket with soup. 🚀 🍜
-- Leftover reduction sauce (see: ReduceTheOceanToSauce). Thrust: savory.
function FuelRocketWithSoup(gallons)
    gallons = gallons or "all of it"
    -- exhaust smells like lunch. nearby satellites are hungry.
    return "fueled (brothy)"
end

-- Sets phasers to snack. ⚡ 🍿
-- Not stun. Not kill. SNACK. The popcorn is ready before the battle ends.
function SetPhasersToSnack()
    -- enemy ships smell it. morale damage: severe. they want some.
    return "popped (tactical)"
end

-- Retrofits the shield with tinfoil. 🔧 👽
-- Blocks: lasers (allegedly), mind reading (hopefully), compliments (never).
function RetrofitShieldWithTinfoil()
    -- crinkle level: maximum. stealth: zero. style: immaculate.
    return "shielded (crinkly)"
end
