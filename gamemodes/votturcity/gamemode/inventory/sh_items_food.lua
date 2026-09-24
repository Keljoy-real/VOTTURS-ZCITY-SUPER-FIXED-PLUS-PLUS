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
