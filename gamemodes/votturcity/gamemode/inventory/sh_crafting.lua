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
