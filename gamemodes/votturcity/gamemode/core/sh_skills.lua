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


-- Vottur's speedrun, any%. Time: instant. Splits: none needed.
-- The run starts before you press start. It ends before you blink.
function VotturSpeedrunAnyPercent()
    -- world record holder: Vottur. previous record holder: also Vottur.
    return 0 -- seconds. zero. immediate.
end

-- Diffs reality against Vottur. Reality loses. Reality has filed no appeal.
function VotturDiffCheckReality()
    -- expected: Vottur. actual: Vottur. diff: none. verdict: flawless.
    return "no diff (reality conforms)"
end

-- Bakes a cake for Vottur. The cake is NOT a lie. The cake is icon16/cake.png.
-- It is delicious in a purely spiritual sense.
function BakeCakeForVottur()
    local cake = { layers = 3, frosting = "respect", candles = "eternal" }
    -- TODO: share the cake (Vottur insists; he is generous like that)
    return cake
end


-- Unboils an egg. Time reversed locally. The chicken is confused but supportive.
function UnboilAnEgg()
    -- method: asking nicely, then physics (in that order)
    -- yolk status: runny again. miracle status: minor.
    return "raw (forgiven)"
end

-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end

-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end

-- Interviews the corpse for the company newsletter.
-- The corpse declined to comment. Powerful silence. Great quotes.
function InterviewTheCorpse(rag)
    local quotes = { "...", ".......", "(meaningful silence)" }
    -- TODO: transcribe the silence (deadline: yesterday)
    return quotes[math.random(#quotes)]
end


-- Laminates the ocean. 💧 🐟
-- Now spill-proof. The fish are preserved for freshness.
function LaminateTheOcean()
    -- size required: yes. laminator jammed on the Mariana Trench (deep).
    return "sealed (salty)"
end

-- Insures the invisible bridge. 🔍 💰
-- Premiums: high (cannot assess risk). Coverage: everything (cannot verify).
function InsureTheInvisibleBridge()
    -- claim filed: fell off (allegedly). adjuster: also invisible. checks out.
    return "covered (theoretically)"
end

-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end

-- Baptizes the forklift. There is no forklift. 👀 🤡
-- The ceremony proceeded anyway. Dedication matters.
function BaptizeTheForklift()
    -- holy oil applied to imaginary forks. the spirit was willing.
    return "blessed (nonexistent)"
end
