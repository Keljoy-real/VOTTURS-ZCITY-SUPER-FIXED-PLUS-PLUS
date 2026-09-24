-- 🔫 VotturCity | sh_items_weapons2.lua | Second weapon batch registry 🔫 --
-- 📦 Loaded after sh_items.lua + sh_items_food.lua (same VCity.Items table). --

local function Reg(id, def) VCity.Items[id] = def def.id = id end -- 📝 Helper. --

-- 🔫 New firearms. --
Reg("w_smg",      { name = "SMG",      w = 2.5, max = 1, cat = "weapon", weapon = "vcity_smg",      model = "models/weapons/w_smg1.mdl", desc = "Bullet hose." }) -- 🔫 SMG. --
Reg("w_dmr",      { name = "DMR",      w = 4.0, max = 1, cat = "weapon", weapon = "vcity_dmr",      model = "models/weapons/w_rif_ak47.mdl", desc = "Precise + punishing." }) -- 🔫 DMR. --
Reg("w_revolver", { name = "Revolver", w = 1.4, max = 1, cat = "weapon", weapon = "vcity_revolver", model = "models/weapons/w_357.mdl", desc = ".44 thunder." }) -- 🔫 Revolver. --
Reg("w_taser",    { name = "Taser",    w = 0.8, max = 1, cat = "weapon", weapon = "vcity_taser",    model = "models/weapons/w_pistol.mdl", desc = "Stun + KO." }) -- ⚡ Taser. --
Reg("w_machete",  { name = "Machete",  w = 1.2, max = 1, cat = "weapon", weapon = "vcity_machete",  model = "models/weapons/w_crowbar.mdl", desc = "Heavy slash." }) -- 🔪 Machete. --
Reg("w_molotov",  { name = "Molotov",  w = 0.8, max = 3, cat = "weapon", weapon = "vcity_molotov",  model = "models/weapons/w_grenade.mdl", desc = "Thrown fire (splash)." }) -- 🔥 Molotov. --

-- 🔫 Extra ammo is covered: 9mm/rifle/shell/.44 already exist. --
-- 🧰 Extra mats already exist (cloth/stick/duct_tape/charcoal/rope). --
