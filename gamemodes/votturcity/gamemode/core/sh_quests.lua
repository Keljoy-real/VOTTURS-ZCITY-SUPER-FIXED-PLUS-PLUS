-- 📜 VotturCity | sh_quests.lua | Mission definitions 📜 --
-- 🎯 Each quest: tracked stat, goal, one-time claim, XP + item reward. --

VCity.Quests = VCity.Quests or {} -- 📦 Quest namespace. --

-- 🧾 Quest book (id -> def). --
VCity.Quests.Defs = {
    first_blood = { name = "🔫 First Blood", desc = "Kill 1 player", stat = "kills", goal = 1 }, -- 🔫 Kill. --
    medic1 = { name = "🩹 Field Medic", desc = "Heal others 3 times", stat = "heals", goal = 3 }, -- 🩹 Heal. --
    scavenger1 = { name = "📦 Scavenger", desc = "Pick up 5 world items", stat = "loot", goal = 5 }, -- 📦 Loot. --
    crafter1 = { name = "🛠️ Tinkerer", desc = "Craft 2 items", stat = "crafts", goal = 2 }, -- 🛠️ Craft. --
    reviver = { name = "🫁 Guardian Angel", desc = "Revive 1 player", stat = "revives", goal = 1 }, -- 🫁 Revive. --
    survivor10 = { name = "⏱️ Survivor", desc = "Survive 10 minutes alive", stat = "survmin", goal = 10 }, -- ⏱️ Survive. --
}

-- 🆕 Fresh progress table. --
function VCity.Quests_Fresh()
    return { kills = 0, heals = 0, loot = 0, crafts = 0, revives = 0, survmin = 0, claimed = {} } -- 📦 Zeros. --
end
