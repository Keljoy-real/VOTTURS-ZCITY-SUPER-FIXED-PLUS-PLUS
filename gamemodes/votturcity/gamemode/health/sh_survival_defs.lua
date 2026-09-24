-- 🍖 VotturCity | sh_survival_defs.lua | Food / drink catalog 🍖 --
-- 🧾 Each consumable: hunger/thirst/stamina/temp/pain deltas + eat time. --

VCity.Food = VCity.Food or {} -- 📦 Food namespace. --

-- 🧾 id -> effect. Positive hunger/thirst fill the meter; hp heals; risk = food poisoning chance. --
VCity.Food.Items = {
    canned_beans = { name = "Canned Beans", hunger = 35, thirst = 0, hp = 3, pain = 0, stamina = 5, time = 3, desc = "Hearty. +35 food." }, -- 🥫 Beans. --
    mre = { name = "MRE", hunger = 65, thirst = 5, hp = 8, pain = 2, stamina = 15, time = 5, desc = "Military meal. Big restore." }, -- 🎖️ MRE. --
    granola = { name = "Granola Bar", hunger = 15, thirst = 0, hp = 1, pain = 0, stamina = 8, time = 2, desc = "Quick snack." }, -- 🍫 Snack. --
    water_bottle = { name = "Water Bottle", hunger = 0, thirst = 45, hp = 0, pain = 0, stamina = 5, time = 2, desc = "+45 water." }, -- 💧 Water. --
    coffee = { name = "Coffee", hunger = 2, thirst = 10, hp = 0, pain = 8, stamina = 35, time = 2, desc = "Caffeine rush." }, -- ☕ Coffee. --
    vodka = { name = "Vodka", hunger = -5, thirst = -10, hp = 0, pain = 20, stamina = -10, time = 2, wobble = 10, desc = "Kills pain, kills liver." }, -- 🍺 Booze. --
    raw_meat = { name = "Raw Meat", hunger = 20, thirst = 0, hp = -5, pain = 5, stamina = 0, time = 3, risk = 0.35, desc = "Risky! Cook it first." }, -- 🥩 Raw. --
    cooked_meat = { name = "Cooked Meat", hunger = 50, thirst = 0, hp = 6, pain = 0, stamina = 10, time = 4, desc = "Safe + filling." }, -- 🍗 Cooked. --
    bandage_herb = { name = "Herbal Poultice", hunger = 0, thirst = 0, hp = 6, pain = 6, stamina = 0, time = 3, wound = 1, desc = "Downgrades one wound." }, -- 🌿 Herb. --
}
