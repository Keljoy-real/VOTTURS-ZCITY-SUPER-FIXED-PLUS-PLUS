-- ⭐ VotturCity | sh_skills.lua | Skill math (shared, pure functions) ⭐ --
-- 🧮 All bonuses computed here so weapons/damage/healing agree. --

-- 🔍 Get a player's skill level in a tree (0-5, defaults 0). --
function VCity.Skills_Get(ply, tree)
    if not VCity.IsLivePlayer(ply) then return 0 end -- 🛑 Invalid. --
    local t = ply.VCity_Skills or {} -- 📦 Table. --
    return math.Clamp(math.floor(t[tree] or 0), 0, VCity.Config.SkillMaxPerTree or 5) -- 🔢 Clamp. --
end

-- 🔍 Available unspent points. --
function VCity.Skills_Points(ply)
    if not VCity.IsLivePlayer(ply) then return 0 end -- 🛑 Invalid. --
    return math.max(0, math.floor(ply.VCity_SkillPoints or 0)) -- 🔢 Points. --
end

-- 🩹 Healing scale for a healer (medic tree). --
function VCity.Skills_HealScale(healer)
    if not VCity.IsLivePlayer(healer) then return 1 end -- 🙅 No bonus. --
    return 1 + VCity.Skills_Get(healer, "medic") * (VCity.Config.SkillMedicHeal or 0.08) -- 🩹 Bonus. --
end

-- 🫁 CPR success bonus (added to base chance). --
function VCity.Skills_CPRBonus(healer)
    if not VCity.IsLivePlayer(healer) then return 0 end -- 🙅 None. --
    return VCity.Skills_Get(healer, "medic") * (VCity.Config.SkillMedicCPR or 0.07) -- 🫁 Bonus. --
end

-- 🛡️ Damage-taken mitigation (medic tree, server calls from damage hook). --
function VCity.Skills_Mitigate(ply, damage, kind, limb)
    if not VCity.IsLivePlayer(ply) then return damage end -- 🛑 Invalid. --
    local pts = VCity.Skills_Get(ply, "medic") -- 🩹 Medic pts. --
    if pts <= 0 then return damage end -- 🙅 No bonus. --
    return damage * (1 - math.min(0.2, pts * (VCity.Config.SkillMedicMitigate or 0.02))) -- 🛡️ Reduce. --
end

-- 🔫 Gunner damage bonus (server weapons call before FireBullets? applied in base). --
function VCity.Skills_DamageScale(ply)
    if not VCity.IsLivePlayer(ply) then return 1 end -- 🙅 None. --
    return 1 + VCity.Skills_Get(ply, "gunner") * (VCity.Config.SkillGunnerDmg or 0.03) -- 🔫 Bonus. --
end

-- 🎯 Gunner recoil / spread multipliers (<1 = better). --
function VCity.Skills_RecoilScale(ply)
    if not VCity.IsLivePlayer(ply) then return 1 end -- 🙅 None. --
    return math.max(0.6, 1 - VCity.Skills_Get(ply, "gunner") * (VCity.Config.SkillGunnerRecoil or 0.05)) -- 🎯 Cut. --
end
function VCity.Skills_SpreadScale(ply)
    if not VCity.IsLivePlayer(ply) then return 1 end -- 🙅 None. --
    return math.max(0.6, 1 - VCity.Skills_Get(ply, "gunner") * (VCity.Config.SkillGunnerSpread or 0.04)) -- 🎯 Cut. --
end

-- ⭐ Scavenger XP multiplier. --
function VCity.Skills_XPScale(ply)
    if not VCity.IsLivePlayer(ply) then return 1 end -- 🙅 None. --
    return 1 + VCity.Skills_Get(ply, "scavenger") * (VCity.Config.SkillScavXP or 0.04) -- ⭐ Bonus. --
end

-- ⚖️ Carry weight bonus (added to config max). --
function VCity.Skills_WeightBonus(ply)
    if not VCity.IsLivePlayer(ply) then return 0 end -- 🙅 None. --
    return VCity.Skills_Get(ply, "scavenger") * (VCity.Config.SkillScavWeight or 2) -- ⚖️ Bonus kg. --
end

-- ⚡ Max stamina bonus. --
function VCity.Skills_StaminaMax(ply)
    return (VCity.Config.StaminaMax or 100) + VCity.Skills_Get(ply, "athlete") * (VCity.Config.SkillAthStamina or 8) -- ⚡ Bonus. --
end
