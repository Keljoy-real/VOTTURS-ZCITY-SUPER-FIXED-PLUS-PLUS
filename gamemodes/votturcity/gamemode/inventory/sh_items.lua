-- 🎒 VotturCity | sh_items.lua | Item registry 🎒 --
-- 🧾 Every carriable / usable thing is defined here exactly once. --

VCity.Items = VCity.Items or {} -- 📦 Item namespace. --

-- 🧱 Helper to register an item (called at load; no runtime registration). --
local function Reg(id, def) -- 📝 Register helper. --
    VCity.Items[id] = def -- 📦 Store. --
    def.id = id -- 🆔 Back-reference. --
end

-- 🩹 Medical (also in Medical.Items for treatment stats; here for inv stats). --
Reg("bandage",      { name = "Bandage",          w = 0.2, max = 10, cat = "medical", model = "models/weapons/w_eq_smokegrenade_thrown.mdl", desc = "Stops bleeding." }) -- 🩹 Light. --
Reg("bigbandage",   { name = "Trauma Dressing",  w = 0.4, max = 5,  cat = "medical", model = "models/weapons/w_eq_smokegrenade_thrown.mdl", desc = "Stops heavy bleeding." }) -- 🩹 Heavy. --
Reg("medkit",       { name = "First Aid Kit",    w = 1.5, max = 3,  cat = "medical", model = "models/items/healthkit.mdl", desc = "Broad healing." }) -- 🩺 Kit. --
Reg("painkillers",  { name = "Painkillers",      w = 0.1, max = 10, cat = "medical", model = "models/props_lab/jar01b.mdl", desc = "Dulls pain." }) -- 💊 Pills. --
Reg("morphine",     { name = "Morphine",         w = 0.2, max = 5,  cat = "medical", model = "models/props_lab/jar01b.mdl", desc = "Strong pain relief." }) -- 💉 Morphine. --
Reg("adrenaline",   { name = "Adrenaline Pen",   w = 0.2, max = 5,  cat = "medical", model = "models/weapons/w_eq_smokegrenade_thrown.mdl", desc = "Combat stimulant." }) -- 💉 Rush. --
Reg("bloodbag",     { name = "Blood Bag",        w = 0.8, max = 3,  cat = "medical", model = "models/props_lab/jar01b.mdl", desc = "Restores blood." }) -- 🩸 Blood. --
Reg("splint",       { name = "Splint",           w = 0.6, max = 5,  cat = "medical", model = "models/props_c17/playground_teetertoter_stan.mdl", desc = "Fixes fractures." }) -- 🦴 Splint. --
Reg("defib",        { name = "Defibrillator",    w = 3.0, max = 1,  cat = "medical", model = "models/props_lab/defibrillator.mdl", desc = "Revives KO players." }) -- ⚡ Defib. --

-- 🔫 Ammo types (weapons consume these from inventory). --
Reg("ammo_9mm",    { name = "9mm Rounds",     w = 0.02, max = 120, cat = "ammo", model = "models/items/boxsrounds.mdl", desc = "Pistol ammo." }) -- 🔫 9mm. --
Reg("ammo_rifle",  { name = "Rifle Rounds",   w = 0.03, max = 120, cat = "ammo", model = "models/items/boxmrounds.mdl", desc = "Rifle ammo." }) -- 🔫 Rifle. --
Reg("ammo_shell",  { name = "Shells",         w = 0.08, max = 32,  cat = "ammo", model = "models/items/boxbuckshot.mdl", desc = "Shotgun shells." }) -- 🔫 Shells. --
Reg("ammo_44",     { name = ".44 Rounds",     w = 0.04, max = 48,  cat = "ammo", model = "models/items/boxsrounds.mdl", desc = "Magnum ammo." }) -- 🔫 Magnum. --

-- 🔫 Weapon pickup items (grant the weapon + handle equip). --
Reg("w_glock",   { name = "Pistol",        w = 1.2, max = 1, cat = "weapon", weapon = "vcity_glock",   model = "models/weapons/w_pistol.mdl", desc = "9mm sidearm." }) -- 🔫 Pistol. --
Reg("w_akm",     { name = "Assault Rifle", w = 3.5, max = 1, cat = "weapon", weapon = "vcity_akm",     model = "models/weapons/w_rif_ak47.mdl", desc = "Reliable rifle." }) -- 🔫 Rifle. --
Reg("w_shotgun", { name = "Shotgun",       w = 3.0, max = 1, cat = "weapon", weapon = "vcity_shotgun", model = "models/weapons/w_shot_m3super90.mdl", desc = "Close-range power." }) -- 🔫 Shotgun. --
Reg("w_knife",   { name = "Knife",         w = 0.5, max = 1, cat = "weapon", weapon = "vcity_knife",   model = "models/weapons/w_knife_t.mdl", desc = "Quiet melee." }) -- 🔪 Knife. --

-- 🛡️ Armor / utility. --
Reg("armor_vest", { name = "Armor Vest", w = 4.0, max = 1, cat = "gear", model = "models/props_c17/BriefCase001a.mdl", desc = "Grants 50 armor." }) -- 🛡️ Vest. --
Reg("scrap",      { name = "Scrap",      w = 0.3, max = 20, cat = "misc", model = "models/gibs/metal_gib4.mdl", desc = "Crafting junk / XP fodder." }) -- ⚙️ Scrap. --

-- 🔍 Safe item lookup (returns nil for unknown). --
function VCity.Item_Get(id)
    id = VCity.SanitizeItemID(id) -- 🧹 Sanitize. --
    if not id then return nil end -- 🛑 Bad. --
    return VCity.Items[id] -- 📦 Lookup. --
end
