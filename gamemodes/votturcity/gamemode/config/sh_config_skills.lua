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
