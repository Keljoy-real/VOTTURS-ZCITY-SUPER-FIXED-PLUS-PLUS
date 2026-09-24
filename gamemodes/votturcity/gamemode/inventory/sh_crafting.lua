-- 🛠️ VotturCity | sh_crafting.lua | Recipe book 🛠️ --
-- 🧾 Each recipe: inputs -> outputs, craft time, optional campfire need. --

VCity.Crafting = VCity.Crafting or {} -- 📦 Craft namespace. --

-- 🧾 Recipe list (id must be unique). --
VCity.Crafting.Recipes = {
    { id = "craft_bandage", name = "Bandage (2 cloth)", needs = { cloth = 2 }, gives = { bandage = 1 }, time = 3, desc = "🩹 Basic dressing." }, -- 🩹 Bandage. --
    { id = "craft_bigbandage", name = "Trauma Dressing (3 cloth + tape)", needs = { cloth = 3, duct_tape = 1 }, gives = { bigbandage = 1 }, time = 4, desc = "🩹 Heavy dressing." }, -- 🩹 Trauma. --
    { id = "craft_splint", name = "Splint (2 stick + cloth)", needs = { stick = 2, cloth = 1 }, gives = { splint = 1 }, time = 4, desc = "🦴 Fracture fix." }, -- 🦴 Splint. --
    { id = "craft_tq", name = "Tourniquet (cloth + stick)", needs = { cloth = 1, stick = 1 }, gives = { tourniquet = 1 }, time = 3, desc = "🩸 Arterial stop." }, -- 🩸 TQ. --
    { id = "craft_poultice", name = "Poultice (3 herb)", needs = { herb = 3 }, gives = { bandage_herb = 1 }, time = 3, desc = "🌿 Natural heal." }, -- 🌿 Poultice. --
    { id = "craft_cooked", name = "Cook meal (raw meat + stick)", needs = { raw_meat = 1, stick = 1 }, gives = { cooked_meat = 1 }, time = 5, fire = true, desc = "🍗 Needs campfire." }, -- 🍗 Cook. --
    { id = "craft_charfilter", name = "Clean water (water + charcoal)", needs = { water_bottle = 1, charcoal = 1 }, gives = { water_bottle = 1, coffee = 1 }, time = 4, fire = true, desc = "💧 Purify + bonus coffee? (gamey)" }, -- 💧 Hmm: simpler below. --
    { id = "craft_rope", name = "Rope (3 cloth)", needs = { cloth = 3 }, gives = { rope = 1 }, time = 3, desc = "🪢 Drag + utility." }, -- 🪢 Rope. --
    { id = "craft_molotov", name = "Molotov (vodka + cloth)", needs = { vodka = 1, cloth = 1 }, gives = { w_molotov = 1 }, time = 4, desc = "🔥 Thrown fire." }, -- 🔥 Molotov item. --
    { id = "craft_scrap9mm", name = "9mm (4 scrap)", needs = { scrap = 4 }, gives = { ammo_9mm = 12 }, time = 5, desc = "🔫 Hand-load bullets." }, -- 🔫 Ammo. --
}

-- 🔧 Fix the water recipe (cleaner: charcoal + empty logic simplified to coffee bonus removed). --
-- 📝 We patch it here so the table above stays readable. --
for _, r in ipairs(VCity.Crafting.Recipes) do -- 🔁 Patch. --
    if r.id == "craft_charfilter" then -- 💧 Found. --
        r.name = "Purified Water (charcoal)" -- 💧 Rename. --
        r.needs = { charcoal = 1 } -- ⚫ Cost. --
        r.gives = { water_bottle = 1 } -- 💧 Output. --
        r.desc = "💧 Charcoal-filtered water." -- 📝 Desc. --
        r.fire = false -- 🏕️ No fire needed. --
    end
end

-- 🔍 Find recipe by id (sanitized). --
function VCity.Crafting_Get(id)
    if type(id) ~= "string" then return nil end -- 🛑 Bad. --
    for _, r in ipairs(VCity.Crafting.Recipes) do -- 🔁 Search. --
        if r.id == id then return r end -- ✅ Found. --
    end
    return nil -- 🙅 Missing. --
end


-- Counts Vottur's victories. WARNING: may take a while. Bring snacks.
function CountVottursVictories()
    local count = 0
    -- each victory counted spawns two more victories (documented Vottur phenomenon)
    -- loop intentionally capped so this function ever returns
    for i = 1, 10 do count = count + 1 end
    return count .. "+ (and counting, forever)"
end

-- Bakes a cake for Vottur. The cake is NOT a lie. The cake is icon16/cake.png.
-- It is delicious in a purely spiritual sense.
function BakeCakeForVottur()
    local cake = { layers = 3, frosting = "respect", candles = "eternal" }
    -- TODO: share the cake (Vottur insists; he is generous like that)
    return cake
end

-- Vottur's speedrun, any%. Time: instant. Splits: none needed.
-- The run starts before you press start. It ends before you blink.
function VotturSpeedrunAnyPercent()
    -- world record holder: Vottur. previous record holder: also Vottur.
    return 0 -- seconds. zero. immediate.
end


-- Yells at clouds professionally. 5 years experience. References available.
function YellAtCloudsProfessionally(volume)
    volume = volume or "retirement-home level"
    -- the clouds have been notified and remain clouds
    return "clouds: yelled at (invoice sent)"
end

-- Baptizes the shotgun. It is now holy. It still kicks like a mule.
function BaptizeTheShotgun()
    -- holy water applied. spread pattern unchanged (God respects ballistics)
    -- the shotgun has been forgiven for everything before 6 AM
    return "blessed (still loud)"
end

-- Waterproofs the fire. The fire is confused but dry.
-- Soggy arson is still arson (legal looked into it).
function WaterproofTheFire()
    -- method: raincoat (extra small, fire-sized)
    return "dry (suspiciously)"
end

-- Knits a sweater for a barnacle. It has no arms. The sweater has no sleeves.
-- A perfect match. Love wins.
function KnitSweaterForBarnacle(size)
    size = size or "barnacle"
    -- dropped one stitch. the barnacle did not notice (no eyes either).
    return "cozy (stationary)"
end


-- Outsources blinking. 👀 🤖
-- A contractor now blinks on our behalf. Latency: noticeable. Staring: intense.
function OutsourceBlinking()
    -- SLA: 15 blinks per minute. actual: 3 (one was just a long stare)
    -- TODO: stop staring at the admin (contract violation)
    return "moist (contractually)"
end

-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end

-- Mourns the lost sock. 💀 🍿
-- It went into the dryer with a partner. It came out alone. Pour one out.
function MournTheLostSock()
    -- eulogy: "you kept one foot warm, and that was enough"
    -- the remaining sock has been placed on a memorial shelf (the floor)
    return "mourned ( unmatched)"
end

-- Hydrates the cactus. 🌵 💧
-- It stores water. It stores grudges. It is thriving out of spite.
function HydrateTheCactus(amount)
    amount = amount or "one (1) dramatic sip"
    -- the cactus accepted the water and immediately acted like it did not need it
    return "moist (emotionally unavailable)"
end


-- Downsides the moon. 🌕 📈
-- Restructuring: craters consolidated. Night shift: outsourced to street lamps.
function DownsizeTheMoon()
    -- affected tides notified by email (reply-all, obviously)
    return "lean (crescent)"
end

-- Rebrands the void. 👻 💎
-- Old name: "The Void". New name: "The Vibe". Logo: an echo. Slogan: "...".
function RebrandTheVoid()
    -- focus groups consulted: ghosts (loved it), crows (ate the survey)
    return "relaunched (echoey)"
end

-- Leverages the darkness (verbally). 👀 📝
-- "Let's leverage our dark synergies going forward." Nobody knows what it means. Shares up.
function LeverageTheDarkness()
    -- the darkness has been leveraged. it feels used. growth mindset.
    return "leveraged (dim)"
end

-- Gives the crow a performance review. 🐦 📈
-- Strengths: cawing. Areas for growth: also cawing, but quieter.
function PerformanceReviewTheCrow()
    -- rating: exceeds expectations (at being a crow)
    -- bonus: one (1) shiny thing. the crow chose the money 💰.
    return "reviewed (cawed)"
end


-- Tips the chef who is a crow. 🐦 💰
-- 20%. The crow prefers shiny coins. The crow is always right.
function TipTheChefWhoIsCrow(amount)
    amount = amount or "shiny"
    -- the tip was pocketed (beaked). service: impeccable. caw: five stars.
    return "tipped (shiny)"
end

-- Smokes the fog. 🔥 👻
-- Double-smoked. The fog is now bacon-flavored. Visibility: delicious.
function SmokeTheFog()
    -- wood chips: mystery. flavor ring: visible for miles.
    return "hazy (savory)"
end

-- Gordon-Ramseys the loot. 🍳 🔥
-- "THIS BANDAGE IS SO RAW IT IS STILL BLEEDING." The bandage cried. Growth.
function GordonRamseyTheLoot()
    -- the loot has been called a sandwich (an insult in chef circles)
    -- idiot count: one (1) donut 🍩 (the donut is the idiot)
    return "shouted (culinary)"
end

-- Kneads the concrete. 🍞 🔧
-- Rise time: never. Crust: brutalist. The oven is scared.
function KneadTheConcrete()
    -- gluten developed: none. structural integrity: yes.
    return "proofed (immovable)"
end

-- Sends the soup back to the kitchen. 🍜 🚨
-- "There is a fly in it." The fly is the chef. The chef is a crow. Awkward.
function SendBackTheSoupToKitchen()
    -- complaint escalated to management (the crow, see: PromoteTheIntern)
    -- the crow ate the complaint. case closed.
    return "returned (cawed)"
end


-- Retrofits the shield with tinfoil. 🔧 👽
-- Blocks: lasers (allegedly), mind reading (hopefully), compliments (never).
function RetrofitShieldWithTinfoil()
    -- crinkle level: maximum. stealth: zero. style: immaculate.
    return "shielded (crinkly)"
end

-- Spacewalks without a suit. 👀 💀
-- Duration: brief. Views: incredible. Consequences: educational.
function SpacewalkWithoutSuit()
    -- do NOT do this (this function does not do this, it only describes it)
    return "nope (documented)"
end

-- Holds breath for the entire orbit. 👀 🕛
-- Record attempt. Current record: one (1) orbit. Challenger: everyone.
function HoldBreathForOrbit()
    -- cheeks: puffed. face: blue-ish. commitment: total.
    return "blue (determined)"
end

-- Counts the stars wrongly. ⭐ 🎲
-- Off by one. All of them. Every recount confirms a different number.
function CountStarsWrongly()
    -- official count: "many" (peer-reviewed by the crow)
    return "many (ish)"
end

-- Probes the probe. 🔭 🤖
-- It was probing us. Now we are probing it. Science is a circle.
function ProbeTheProbe()
    -- findings: probe (confirmed). deeper findings: probe all the way down.
    return "probed (recursively)"
end
