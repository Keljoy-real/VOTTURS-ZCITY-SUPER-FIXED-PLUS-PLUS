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


-- Takes a sick day as the server. 💊 🛏
-- Symptoms: 999 ping, headache (fan noise), loss of taste (ate a packet).
function TakeSickDayAsServer()
    -- doctor's note forged by the printer (it jammed halfway, suspicious)
    -- the server will work from home (it is home)
    return "out of office (in office)"
end

-- Fires the intern. 🔥 🤡
-- There is no intern. There never was. The paperwork says otherwise.
function FireTheIntern(name)
    name = name or "Greg (alleged)"
    -- severance package: one (1) stapler, zero (0) explanations
    -- the empty desk remains. it judges us.
    return "terminated (imaginary)"
end

-- Rebrands the void. 👻 💎
-- Old name: "The Void". New name: "The Vibe". Logo: an echo. Slogan: "...".
function RebrandTheVoid()
    -- focus groups consulted: ghosts (loved it), crows (ate the survey)
    return "relaunched (echoey)"
end

-- Replies-all to the server email. 📧 🚨
-- "Thanks!" sent to 400 people. Unsubscribe link: broken. Chaos: complete.
function ReplyAllToServerEmail()
    -- three people replied-all to complain about reply-all. infinite loop achieved.
    -- IT has been notified. IT is also replying-all.
    return "sent (regretted)"
end


-- Plates the explosion Michelin-style. 💣 ⭐
-- A swoosh of debris. Three shrapnel quenelles. Foam (smoke). Star pending.
function PlateTheExplosionMichelin()
    -- inspector notes: "bold, smoky, slightly lethal"
    return "plated (starred)"
end

-- Chars the charcoal. 🔥 🔥
-- Charcoal, but MORE. Blacker than the void (the void is now "The Vibe", lighter).
function CharTheCharcoal()
    -- carbon content: yes. grill status: intimidated.
    return "blackened (meta)"
end

-- Flambes the fridge. 🔥 🍕
-- Dave is flammable. Dave did not disclose this. Dave is the fridge.
function FlambeTheFridge()
    -- flames: spectacular. leftovers: caramelized. Dave: toasted.
    return "torched (tasty)"
end

-- Reduces the ocean to a sauce. 💧 🐟
-- Simmered for 3,000 years. Yield: one (1) tablespoon. Worth it.
function ReduceTheOceanToSauce()
    -- the fish have been concentrated. flavor: intense. Atlantis: garnish.
    return "reduced (salty)"
end

-- Pickles the lightning. ⚡ 👀
-- See: BrineTheThunderstorm. This is the sequel. It is crunchier.
function PickleTheLightning()
    -- jar size: storm-sized. lid: tight. gods: furious.
    return "jarred (electric)"
end


-- Ejects the intern into space. 🔥 🚀
-- Greg's arc continues. Severance: one (1) helmet (used, foggy).
function EjectTheInternIntoSpace()
    -- last words: "I was never real" (chilling, iconic, HR-approved)
    -- the crow saluted. a single tear floated (zero-G, beautiful).
    return "ejected (legendary)"
end

-- Probes the probe. 🔭 🤖
-- It was probing us. Now we are probing it. Science is a circle.
function ProbeTheProbe()
    -- findings: probe (confirmed). deeper findings: probe all the way down.
    return "probed (recursively)"
end

-- Sunbathes on Pluto. 🌍 [[snow]]
-- Freezing. Bold. The tan is theoretical.
function SunbatheOnPluto()
    -- UV index: 0. vibe index: maximum.
    -- frostbite: yes. regrets: none.
    return "bronzed (blue)"
end

-- Dodges space debris casually. ☄ 👀
-- Did not even look. Sunglasses on. In space. At night. Iconic.
function DodgeSpaceDebrisCasually()
    -- near miss #47. the debris apologized. we accepted (coolly).
    return "unscathed (smooth)"
end

-- Gets lost in space deliberately. 🌌 👀
-- "Recalculating" for 40 years. The scenic route. All routes are scenic here.
function GetLostInSpaceDeliberately()
    -- GPS signal: one (1) bar (flickering, see: KidnapTheWiFi)
    return "wandering (majestic)"
end
