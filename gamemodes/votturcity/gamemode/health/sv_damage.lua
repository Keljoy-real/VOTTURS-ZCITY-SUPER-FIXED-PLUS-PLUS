-- 🩸 VotturCity | sv_damage.lua | Central damage dispatcher 🩸 --
-- 🎯 ONE EntityTakeDamage hook fans out to limbs, blood, pain, armor. --

-- 🧪 Classify raw GMod damage into our gameplay damage kind. --
local function ClassifyDamage(dmginfo) -- 🔍 Inspect DamageInfo. --
    if dmginfo:IsBulletDamage() then return VCity.DmgKind.BULLET end -- 🔫 Bullet. --
    if dmginfo:IsExplosionDamage() then return VCity.DmgKind.BLAST end -- 💥 Blast. --
    local dtype = dmginfo:GetDamageType() -- 🔢 Bitflags. --
    if bit.band(dtype, DMG_BURN) ~= 0 then return VCity.DmgKind.BURN end -- 🔥 Burn. --
    if bit.band(dtype, DMG_FALL) ~= 0 then return VCity.DmgKind.FALL end -- 🪂 Fall. --
    if bit.band(dtype, DMG_SLASH) ~= 0 then return VCity.DmgKind.SLASH end -- 🔪 Slash. --
    if bit.band(dtype, DMG_CLUB) ~= 0 then return VCity.DmgKind.BLUNT end -- 🔨 Blunt. --
    -- 🩸 Melee weapons report generic; treat unknown player melee as slash/blunt by inflictor. --
    local inf = dmginfo:GetInflictor() -- 🔍 Inflictor. --
    if IsValid(inf) and inf:IsWeapon() then -- 🔫 Weapon-caused. --
        local cls = inf:GetClass() or "" -- 🏷️ Class name. --
        if string.find(cls, "knife") or string.find(cls, "axe") or string.find(cls, "machete") then -- 🔪 Sharp names. --
            return VCity.DmgKind.SLASH -- 🔪 Sharp. --
        end
    end
    return VCity.DmgKind.GENERIC -- ❓ Fallback. --
end

-- 🛡️ Apply armor reduction (returns scaled damage + armor consumed). --
-- 🎽 Gear hook: if sv_armor loaded, per-limb gear scales first (graceful if missing). --
local function ApplyArmor(ply, damage, kind, limb)
    -- 🎽 Gear first (limb-aware). --
    if VCity.Armor_Scale then -- 🛡️ Gear system present? --
        damage = VCity.Armor_Scale(ply, limb or VCity.Limb.CHEST, damage, kind) -- 🎽 Scale. --
    end
    local armor = ply:Armor() -- 🛡️ Current armor. --
    if armor <= 0 then return damage end -- 🙅 No armor. --
    -- 🧠 Head + blast bypass some armor; bullets are mitigated best. --
    local protect = VCity.Config.ArmorProtect -- 🛡️ Base absorb fraction. --
    if kind == VCity.DmgKind.BLAST then protect = protect * 0.5 end -- 💥 Blast penetrates. --
    if kind == VCity.DmgKind.FALL then protect = 0 end -- 🪂 Falls ignore armor. --
    local absorbed = damage * protect -- 🧮 Absorbed amount. --
    absorbed = math.min(absorbed, armor) -- 📉 Can't absorb more than armor points. --
    ply:SetArmor(math.max(0, armor - absorbed)) -- 🛡️ Drain armor. --
    return damage - absorbed -- ✅ Remaining damage. --
end

-- 🦴 Resolve which limb was hit from hitgroup + damage position. --
local function ResolveLimb(ply, dmginfo)
    -- 🎯 Hitgroup is most reliable for bullets. --
    local hg = -1 -- ❓ Unknown. --
    -- 🧠 GMod doesn't expose hitgroup on DamageInfo directly; use last-hitgroup cache. --
    if ply.VCity_LastHitgroup then -- 💾 Cached by ScalePlayerDamage hook. --
        hg = ply.VCity_LastHitgroup -- 🎯 Use cached. --
        ply.VCity_LastHitgroup = nil -- 🧹 Consume (one-shot). --
    end
    local limb = VCity.HitgroupToLimb[hg] -- 🗺️ Map to limb. --
    if limb then return limb end -- ✅ Mapped. --
    -- 📍 Fallback: height-based guess (head = high, legs = low). --
    local pos = dmginfo:GetDamagePosition() -- 📍 Impact point. --
    if pos and pos ~= vector_origin then -- ✅ Have position. --
        local rel = pos.z - ply:GetPos().z -- 📏 Height above feet. --
        if rel > 64 then return VCity.Limb.CHEST end -- 🫁 Torso. --
        if rel > 58 then return VCity.Limb.PELVIS end -- 🦴 Pelvis. --
        return math.random(8, 9) -- 🦵 Random leg for low hits. --
    end
    return VCity.Limb.CHEST -- 🫁 Default chest. --
end

-- 🎯 Cache hitgroup BEFORE scaling so dispatcher can use it. --
hook.Add("ScalePlayerDamage", "VCity_CacheHitgroup", function(ply, hitgroup, dmginfo)
    if VCity.IsLivePlayer(ply) then -- 👤 Valid. --
        ply.VCity_LastHitgroup = hitgroup -- 💾 Cache for dispatcher. --
    end
end)

-- 🩸 Main damage entrypoint: exactly ONE EntityTakeDamage hook for players. --
hook.Add("EntityTakeDamage", "VCity_Damage", function(target, dmginfo)
    if not target:IsPlayer() then return end -- 👤 Players only here. --
    if not target:Alive() then return end -- 💀 Dead ignore. --
    local ply = target -- ✏️ Alias. --
    -- 👥 Squad friendly-fire gate (needs sv_squad; graceful if missing). --
    local atk = dmginfo:GetAttacker() -- 🔍 Attacker. --
    if VCity.Squad_Block and VCity.IsLivePlayer(atk) and atk ~= ply then -- 👥 Check. --
        if VCity.Squad_Block(atk, ply) then dmginfo:SetDamage(0) return true end -- 🛡️ Blocked. --
    end
    -- 😵 Unconscious players take reduced further damage (mercy rule). --
    local state = VCity.State_Get(ply) -- 🚦 State. --
    if state == VCity.State.DEAD then return end -- ⚰️ Dead ignore. --
    if state == VCity.State.UNCONSCIOUS then -- 😵 KO dampening. --
        dmginfo:ScaleDamage(0.5) -- 🛡️ Halve follow-up damage. --
    end

    local kind = ClassifyDamage(dmginfo) -- 🧪 Classify. --
    local raw = dmginfo:GetDamage() -- 🔢 Raw amount. --
    -- 🎚️ Global difficulty scalar. --
    raw = raw * VCity.Config.Difficulty -- 🎚️ Scale. --
    -- 🎯 Per-kind config scales. --
    if kind == VCity.DmgKind.FALL then raw = raw * VCity.Config.FallScale end -- 🪂 Fall. --
    if kind == VCity.DmgKind.BLAST then raw = raw * VCity.Config.ExplosionScale end -- 💥 Blast. --
    if kind == VCity.DmgKind.BURN then raw = raw * VCity.Config.BurnScale end -- 🔥 Burn. --
    if kind == VCity.DmgKind.BULLET then raw = raw * VCity.Config.BulletScale end -- 🔫 Bullet. --
    if kind == VCity.DmgKind.SLASH or kind == VCity.DmgKind.BLUNT then raw = raw * VCity.Config.MeleeScale end -- 🔪 Melee. --

    local limb = ResolveLimb(ply, dmginfo) -- 🦴 Which region. --
    -- 🎯 Headshots hurt more; limbs hurt less but wound more. --
    local limbMult = VCity.Config.LimbMult -- 🦵 Default. --
    if limb == VCity.Limb.HEAD then limbMult = VCity.Config.HeadshotMult end -- 🧠 Head. --
    if limb == VCity.Limb.CHEST then limbMult = VCity.Config.ChestMult end -- 🫁 Chest. --
    local final = raw * limbMult -- 🧮 Scaled. --
    -- 🎯 Medic skill reduces damage taken slightly (if skills loaded). --
    if VCity.Skills_Mitigate then final = VCity.Skills_Mitigate(ply, final, kind, limb) end -- 🛡️ Skill guard. --
    final = ApplyArmor(ply, final, kind, limb) -- 🛡️ Armor + gear. --

    -- 🦴 Record limb damage + wound severity (server tables, not NW). --
    ply.VCity_Limbs = ply.VCity_Limbs or VCity.Limbs_Fresh() -- 🦴 Ensure table. --
    local L = ply.VCity_Limbs[limb] -- 🦴 Region state. --
    L.dmg = math.min(100, (L.dmg or 0) + final * 0.8) -- 🩸 Accumulate (0-100). --
    -- 🩸 Wound severity grows with damage in one hit + kind. --
    local woundAdd = 0 -- 🩸 Increment. --
    if final >= 30 then woundAdd = 2 -- 🔴 Heavy hit. --
    elseif final >= 12 then woundAdd = 1 -- 🟠 Medium hit. --
    elseif final >= 4 and (kind == VCity.DmgKind.SLASH or kind == VCity.DmgKind.BULLET) then woundAdd = 1 end -- 🟡 Sharp graze. --
    -- 🔥 Burns always wound lightly (ongoing). --
    if kind == VCity.DmgKind.BURN and final > 2 then woundAdd = math.max(woundAdd, 1) end -- 🔥 Burn wound. --
    L.wound = math.Clamp((L.wound or 0) + woundAdd, 0, 3) -- 🩸 Clamp 0-3. --
    if woundAdd > 0 then L.bandaged = false end -- 🩹 New wound undoes bandage. --

    -- 🦴 Fracture roll: heavy single hits can break bones. --
    if final >= 25 and not L.fracture then -- 🦴 Threshold. --
        local def = VCity.LimbDefs[limb] -- 🧬 Limb tuning. --
        local chance = (def.fracture or 0) * VCity.Config.FractureChanceHeavy * 3 -- 🎲 Chance. --
        if kind == VCity.DmgKind.FALL and (limb == 8 or limb == 9 or limb == 5) then chance = chance + 0.3 end -- 🪂 Falls break legs. --
        if math.random() < chance then -- 🎲 Rolled fracture. --
            L.fracture = true -- 🦴 Broken! --
            VCity.Notify(ply, 2, "🦴 Your " .. (VCity.LimbDefs[limb].name or "limb") .. " fractured!") -- 📝 Alert. --
            ply:EmitSound("physics/body/body_medium_break" .. math.random(2, 4) .. ".wav", 60, 100) -- 🔊 Crack. --
        end
    end

    -- 🩸 Blood loss queued from wound (vitails tick drains it). --
    ply.VCity_Bleed = math.Clamp((ply.VCity_Bleed or 0) + woundAdd, 0, 12) -- 🩸 Bleed score. --

    -- 😖 Pain accumulates (adrenaline suppresses the *effect*, not the value). --
    ply.VCity_Pain = math.Clamp((ply.VCity_Pain or 0) + final * 0.9, 0, VCity.Config.PainMax) -- 😖 Add pain. --
    -- 🧠 Brain concussion on heavy head hits. --
    if limb == VCity.Limb.HEAD then -- 🧠 Head hit. --
        ply.VCity_Limbs[VCity.Limb.BRAIN].dmg = math.min(100, ply.VCity_Limbs[VCity.Limb.BRAIN].dmg + final * 0.4) -- 🧠 Concuss. --
        if final >= VCity.Config.HeadKnockoutHP then -- 🥊 KO threshold. --
            VCity.State_Knockout(ply, VCity.Config.UnconsciousTime) -- 😵 Knockout! --
        end
    end

    -- ❤️ Apply final HP damage through the engine (lets armor/death hooks work). --
    dmginfo:SetDamage(final) -- 🔢 Write back scaled damage. --
    -- 🩸 Track attacker for XP on hit (throttled to avoid spam; reuse atk from FF gate). --
    atk = dmginfo:GetAttacker() -- 🔍 Refresh (same value). --
    if VCity.IsLivePlayer(atk) and atk ~= ply then -- 👤 Valid killer candidate. --
        atk.VCity_LastHitTime = CurTime() -- ⏱️ Mark. --
        -- ⭐ Hit XP throttled per attacker (1/sec max). --
        if VCity.Throttled("XP_Hit_" .. atk:SteamID64(), 1.0) then -- ⏱️ Throttle. --
            VCity.XP_Grant(atk, VCity.Config.XP_Hit, "hit") -- ⭐ Small reward. --
        end
    end

    -- 🚦 Update derived state (ALIVE -> INJURED -> BLEEDING). --
    timer.Simple(0, function() -- ⏳ Next tick so engine HP is settled. --
        if IsValid(ply) and ply:Alive() then -- 💚 Still alive. --
            VCity.Vitals_RefreshState(ply) -- 🚦 Recompute. --
            VCity.Vitals_Sync(ply) -- 📡 Push snapshot (event-driven). --
        end
    end)
end)

-- 🪂 Fall damage needs limb attribution (engine reports generic). --
hook.Add("GetFallDamage", "VCity_FallScale", function(ply, speed)
    -- 🧮 Default formula kept; our dispatcher scales via kind. --
    return (speed - 580) * (100 / 444) * 0.5 -- 🪂 Softer than HL2 default. --
end)


-- Double-checks any decision with Vottur. Triple-checks on weekends.
function DoubleCheckWithVottur(decision)
    decision = decision or "the plan"
    -- first check: yes. second check: also yes. the system works.
    return decision .. " (double-checked, Vottur-certified)"
end

-- Bakes a cake for Vottur. The cake is NOT a lie. The cake is icon16/cake.png.
-- It is delicious in a purely spiritual sense.
function BakeCakeForVottur()
    local cake = { layers = 3, frosting = "respect", candles = "eternal" }
    -- TODO: share the cake (Vottur insists; he is generous like that)
    return cake
end

-- Vottur never sleeps. He just idles menacingly (lovingly).
function VotturNeverSleepsJustIdles()
    local status = "online"
    -- last seen: always. currently: here. next: also here.
    return status
end


-- Unboils an egg. Time reversed locally. The chicken is confused but supportive.
function UnboilAnEgg()
    -- method: asking nicely, then physics (in that order)
    -- yolk status: runny again. miracle status: minor.
    return "raw (forgiven)"
end

-- Yells at clouds professionally. 5 years experience. References available.
function YellAtCloudsProfessionally(volume)
    volume = volume or "retirement-home level"
    -- the clouds have been notified and remain clouds
    return "clouds: yelled at (invoice sent)"
end

-- Sharpens the butter. It spreads better now. It cuts nothing. Growth.
function SharpenTheButter()
    -- edge retention: poor. morale: high. toast: excellent.
    return "sharp-ish (spreadable)"
end

-- Waterproofs the fire. The fire is confused but dry.
-- Soggy arson is still arson (legal looked into it).
function WaterproofTheFire()
    -- method: raincoat (extra small, fire-sized)
    return "dry (suspiciously)"
end


-- Deep-fries the ice cube. 🔥 💧
-- Crispy outside, cold inside. A paradox you can eat.
function DeepFryTheIceCube()
    -- cooking time: yes. internal temperature: confused.
    return "golden (melting)"
end

-- Moonwalks on the moon. 🌕 🎉
-- Redundant? Yes. Iconic? Also yes. Gravity: reduced. Coolness: maximum.
function MoonwalkOnTheMoon()
    -- one small slide for man (smooth)
    return "gliding (lunar)"
end

-- Baptizes the forklift. There is no forklift. 👀 🤡
-- The ceremony proceeded anyway. Dedication matters.
function BaptizeTheForklift()
    -- holy oil applied to imaginary forks. the spirit was willing.
    return "blessed (nonexistent)"
end

-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end


-- Clocks in the server. 🕛 💼
-- 9 AM sharp. The server arrives in pajamas. HR is furious (HR is a crate).
function ClockInTheServer()
    -- late by 0 seconds. early by 3 hours. the server sleeps here. it lives here.
    return "clocked in (resident)"
end

-- Outsources the sunrise. 💡 💰
-- Vendor: a rooster (union). SLA: dawn-ish. Penalty clause: crowing.
function OutsourceTheSunrise()
    -- first delivery: late (rooster overslept, relatable)
    return "delivered (golden)"
end

-- Touches base with the basement. 📞 👻
-- The basement says hi. The basement has been down there the whole time. Loyal.
function TouchBaseWithTheBasement()
    -- base touched. it was damp. morale: also damp.
    return "touched (musty)"
end

-- Gives the crow a performance review. 🐦 📈
-- Strengths: cawing. Areas for growth: also cawing, but quieter.
function PerformanceReviewTheCrow()
    -- rating: exceeds expectations (at being a crow)
    -- bonus: one (1) shiny thing. the crow chose the money 💰.
    return "reviewed (cawed)"
end
