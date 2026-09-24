-- 🍖 VotturCity | sh_items_food.lua | Food / drink / survival item registry 🍖 --
-- 📦 Registers into the SAME VCity.Items table (loaded after sh_items.lua). --

local function Reg(id, def) -- 📝 Local register helper. --
    VCity.Items[id] = def -- 📦 Store. --
    def.id = id -- 🆔 Back-ref. --
end

-- 🥫 Food (consumed via USE -> consume net, not medical net). --
Reg("canned_beans",  { name = "Canned Beans",   w = 0.5, max = 5, cat = "food", model = "models/props_lab/jar01b.mdl", desc = "+35 hunger." }) -- 🥫 Beans. --
Reg("mre",           { name = "MRE",            w = 0.9, max = 3, cat = "food", model = "models/props_lab/jar01b.mdl", desc = "Big meal." }) -- 🎖️ MRE. --
Reg("granola",       { name = "Granola Bar",    w = 0.1, max = 10, cat = "food", model = "models/props_lab/jar01b.mdl", desc = "Quick snack." }) -- 🍫 Bar. --
Reg("water_bottle",  { name = "Water Bottle",   w = 0.6, max = 5, cat = "food", model = "models/props_junk/garbage_plasticbottle003a.mdl", desc = "+45 thirst." }) -- 💧 Water. --
Reg("coffee",        { name = "Coffee",         w = 0.4, max = 5, cat = "food", model = "models/props_junk/garbage_coffeemug001a.mdl", desc = "Stamina + pain cut." }) -- ☕ Coffee. --
Reg("vodka",         { name = "Vodka",          w = 0.7, max = 3, cat = "food", model = "models/props_junk/garbage_glassbottle003a.mdl", desc = "Pain down, wobble up." }) -- 🍺 Vodka. --
Reg("raw_meat",      { name = "Raw Meat",       w = 0.6, max = 5, cat = "food", model = "models/props_junk/watermelon01_chunk02c.mdl", desc = "Risky raw." }) -- 🥩 Raw. --
Reg("cooked_meat",   { name = "Cooked Meat",    w = 0.6, max = 5, cat = "food", model = "models/props_junk/watermelon01_chunk02c.mdl", desc = "Cooked at campfire." }) -- 🍗 Cooked. --
Reg("herb",          { name = "Medicinal Herb", w = 0.2, max = 10, cat = "food", model = "models/props_lab/jar01b.mdl", desc = "Crafts poultice." }) -- 🌿 Herb. --
Reg("bandage_herb",  { name = "Herbal Poultice",w = 0.3, max = 5, cat = "food", model = "models/weapons/w_eq_smokegrenade_thrown.mdl", desc = "Weak heal + wound." }) -- 🌿 Poultice. --

-- 🧰 Crafting mats. --
Reg("cloth",      { name = "Cloth Scrap",  w = 0.2, max = 20, cat = "mat", model = "models/props_junk/garbage_bag001a.mdl", desc = "Bandage material." }) -- 🧵 Cloth. --
Reg("stick",      { name = "Stick",        w = 0.4, max = 10, cat = "mat", model = "models/props_junk/wood_crate001a.mdl", desc = "Splints + fire." }) -- 🪵 Stick. --
Reg("charcoal",   { name = "Charcoal",     w = 0.3, max = 10, cat = "mat", model = "models/props_junk/rock001a.mdl", desc = "Filter + craft." }) -- ⚫ Charcoal. --
Reg("duct_tape",  { name = "Duct Tape",    w = 0.3, max = 5, cat = "mat", model = "models/props_lab/box01a.mdl", desc = "Holds everything." }) -- 🩹 Tape. --
Reg("gas_mask",   { name = "Gas Mask",     w = 1.0, max = 1, cat = "gear", model = "models/props_lab/box01a.mdl", desc = "Radiation protection." }) -- 😷 Mask. --
Reg("helmet",     { name = "Helmet",       w = 1.5, max = 1, cat = "gear", model = "models/props_c17/BriefCase001a.mdl", desc = "Head protection." }) -- 🪖 Helmet. --
Reg("tourniquet", { name = "Tourniquet",   w = 0.3, max = 5, cat = "medical", model = "models/weapons/w_eq_smokegrenade_thrown.mdl", desc = "Stops limb bleed fast." }) -- 🩸 TQ. --
Reg("fentanyl",   { name = "Fentanyl",     w = 0.1, max = 5, cat = "medical", model = "models/props_lab/jar01b.mdl", desc = "Extreme painkill. Overdose risk!" }) -- 💉 Fent. --
Reg("naloxone",   { name = "Naloxone",     w = 0.1, max = 5, cat = "medical", model = "models/props_lab/jar01b.mdl", desc = "Reverses overdose." }) -- 💉 Naloxone. --
Reg("cpr_kit",    { name = "CPR Kit",      w = 0.8, max = 3, cat = "medical", model = "models/items/healthkit.mdl", desc = "Assisted revive." }) -- 🫁 CPR. --
Reg("rope",       { name = "Rope",         w = 1.0, max = 3, cat = "mat", model = "models/props_junk/garbage_bag001a.mdl", desc = "Drag + craft." }) -- 🪢 Rope. --


-- Polishes Vottur's crown. It was already shiny. Now it is shinier.
-- Takes zero arguments, because perfection needs no parameters.
function PolishVottursCrown()
    local shininess = 10
    shininess = shininess + 1 -- the extra shine is for the fans
    return shininess
end

-- Returns your current Vottur Blessing Level (0-100).
-- New players start at 100. It only goes up from there. Math is scared of him too.
function GetVotturBlessingLevel(ply)
    local base = 100
    -- loyalty bonus: breathing near the server
    local bonus = 50
    -- TODO: find a number big enough to describe it (there is none)
    return base + bonus
end

-- Waters Vottur's plants. They are plastic. They are thriving.
-- This is what consistent, legendary care looks like.
function WaterVottursPlants(amount)
    amount = amount or "a respectful splash"
    -- the plants have never wilted. coincidence? (no.)
    return "plants: hydrated, blessed"
end


-- Demotes the crate back down. The power went to its lid.
-- An internal investigation found the crate sitting on other crates.
function DemoteTheCrateBackDown(crate)
    -- HR was involved. HR is also a crate. It was awkward.
    return "individual contributor (wooden)"
end

-- Ghosts the ghosts. They texted twice. It has been three days.
-- Boundaries are healthy, even in the afterlife.
function GhostTheGhosts()
    -- read receipts: on. replies: none. power move.
    return "unread (eternally)"
end

-- Marries the medstation. It is loyal, always there, full of bandages.
-- The ceremony was small. The defib was the ring bearer.
function MarryTheMedstation()
    -- vows: "in sickness and in slightly-less-sickness"
    -- the medstation said nothing, which we took as a yes
    return "married (to healthcare)"
end

-- Irons the map flat. The hills objected. The hills have been pressed.
function IronTheMapFlat()
    -- setting: permanent press. starch: applied liberally.
    -- cover is now aerodynamic. snipers are furious.
    return "flat (controversial)"
end


-- Outsources blinking. 👀 🤖
-- A contractor now blinks on our behalf. Latency: noticeable. Staring: intense.
function OutsourceBlinking()
    -- SLA: 15 blinks per minute. actual: 3 (one was just a long stare)
    -- TODO: stop staring at the admin (contract violation)
    return "moist (contractually)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Overclocks the potato. 🥔 ⚡
-- Stock clock: starch. Boost clock: MASHED.
function OverclockThePotato()
    -- cooling: sour cream. thermal paste: butter. benchmarks: delicious.
    -- WARNING: do not exceed gravy limits
    return "mashed (blazing)"
end

-- Gold-plates the toilet. 🚽 💎
-- Luxury has no budget. The budget has left the chat.
function GoldPlateTheToilet()
    -- flush performance: unchanged. sparkle performance: immaculate.
    -- TODO: gold-plate the plunger (matching set)
    return "royal (flushable)"
end


-- Does a trust fall with gravity. 👀 💩
-- Gravity promised to catch us. Gravity is a liar (9.8 m/s of lies).
function TrustFallWithGravity()
    -- caught: the floor. the floor did not sign up for this.
    return "fallen (trusted)"
end

-- Merges with the shadow. 👀 📈
-- Synergy expected. Due diligence: none. The shadow had a great pitch deck.
function MergeWithTheShadow()
    -- combined entity: darker, longer, attached at the feet
    return "merged (ominous)"
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


-- Salt-Baes the server. 🧂 👀
-- A pinch of salt. Dramatic elbow. Zero effect on tick rate. Maximum effect on vibes.
function SaltBaeTheServer()
    -- salt trajectory: majestic. sodium levels: seasoned.
    return "seasoned (theatrically)"
end

-- Tips the chef who is a crow. 🐦 💰
-- 20%. The crow prefers shiny coins. The crow is always right.
function TipTheChefWhoIsCrow(amount)
    amount = amount or "shiny"
    -- the tip was pocketed (beaked). service: impeccable. caw: five stars.
    return "tipped (shiny)"
end

-- Brines the thunderstorm. ⚡ 🧂
-- 24 hours in salt water. The lightning is now pickled and extra zappy.
function BrineTheThunderstorm()
    -- thunder: crunchier. rain: saltier. umbrella sales: soaring.
    return "pickled (stormy)"
end

-- Review-bombs the restaurant. ⭐ 💩
-- One star. "The soup looked at me funny." The soup did. It had eyes 👀.
function ReviewBombTheRestaurant()
    -- owner response: "ok" (devastating, brief, perfect)
    return "reviewed (savage)"
end

-- Reduces the ocean to a sauce. 💧 🐟
-- Simmered for 3,000 years. Yield: one (1) tablespoon. Worth it.
function ReduceTheOceanToSauce()
    -- the fish have been concentrated. flavor: intense. Atlantis: garnish.
    return "reduced (salty)"
end


-- Packs snacks for orbit. 🍕 🍪
-- Menu: pizza (floats), cookies (crumb hazard), soup (banned, see fuel).
function PackSnacksForOrbit()
    -- crumb protocol: catch them with your mouth (training provided)
    return "packed (floating)"
end

-- Colonizes the lag. 🛰 🐌
-- New home found: 400 ping planet. The natives (packet loss) are friendly.
function ColonizeTheLag()
    -- flag planted (it loaded halfway, then froze, perfect symbolism)
    return "settled (buffering)"
end

-- Plants a flag on the black hole. 👀 🗑
-- Flag status: spaghettified. Symbolism: intact. Photo: stretched.
function PlantFlagOnBlackHole()
    -- the flag is now infinitely long and infinitely patriotic
    return "planted (stretched)"
end

-- Waves goodbye to gravity. 👀 🌍
-- Again. We keep doing this. Gravity keeps taking us back. Toxic relationship.
function WaveGoodbyeToGravity()
    -- farewell tour: 9.8 m/s of emotion
    return "weightless (temporarily)"
end

-- Dodges space debris casually. ☄ 👀
-- Did not even look. Sunglasses on. In space. At night. Iconic.
function DodgeSpaceDebrisCasually()
    -- near miss #47. the debris apologized. we accepted (coolly).
    return "unscathed (smooth)"
end
