-- 🍖 VotturCity | sv_survival.lua | Hunger / thirst / stamina / temp / oxygen 🍖 --
-- ⏱️ TWO global timers (1s stamina, 5s hunger/temp) — never per-player Think. --

-- 🆕 Extend vitals reset with survival stats. --
local _OldReset = VCity.Vitals_Reset -- 💾 Keep original. --
function VCity.Vitals_Reset(ply)
    _OldReset(ply) -- ❤️ Run base reset first. --
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    ply.VCity_Hunger = VCity.Config.HungerMax -- 🍖 Full. --
    ply.VCity_Thirst = VCity.Config.ThirstMax -- 🥤 Full. --
    ply.VCity_Stamina = VCity.Config.StaminaMax -- ⚡ Full. --
    ply.VCity_Temp = VCity.Config.TempNormal -- 🌡️ Normal. --
    ply.VCity_Oxygen = VCity.Config.OxygenMax -- 🫁 Full. --
    ply.VCity_WobbleUntil = 0 -- 🌀 No wobble. --
    ply:SetNWFloat("VCity_Hunger", ply.VCity_Hunger) -- 📡 Mirror. --
    ply:SetNWFloat("VCity_Thirst", ply.VCity_Thirst) -- 📡 Mirror. --
    ply:SetNWFloat("VCity_Stamina", ply.VCity_Stamina) -- 📡 Mirror. --
    ply:SetNWFloat("VCity_Temp", ply.VCity_Temp) -- 📡 Mirror. --
    ply:SetNWFloat("VCity_Oxygen", ply.VCity_Oxygen) -- 📡 Mirror. --
end

-- 📡 Push survival snapshot (throttled callers only). --
function VCity.Survival_Sync(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    ply:SetNWFloat("VCity_Hunger", ply.VCity_Hunger or 100) -- 🍖 Mirror. --
    ply:SetNWFloat("VCity_Thirst", ply.VCity_Thirst or 100) -- 🥤 Mirror. --
    ply:SetNWFloat("VCity_Stamina", ply.VCity_Stamina or 100) -- ⚡ Mirror. --
    ply:SetNWFloat("VCity_Temp", ply.VCity_Temp or 37) -- 🌡️ Mirror. --
    ply:SetNWFloat("VCity_Oxygen", ply.VCity_Oxygen or 100) -- 🫁 Mirror. --
end

-- 🔥 Campfire proximity check (cheap: only campfire-class ents). --
local function NearCampfire(pos)
    for _, e in ipairs(ents.FindByClass("vcity_campfire")) do -- 🔥 Each fire. --
        if IsValid(e) and e:GetNWBool("VCity_Lit", false) then -- 🔥 Lit? --
            if pos:DistToSqr(e:GetPos()) < (220 ^ 2) then return true end -- 🔥 Close. --
        end
    end
    return false -- 🙅 None. --
end

-- 🍖 5s tick: hunger / thirst / temp / starve damage. --
timer.Create("VCity_SurvivalSlow", 5, 0, function() -- ⏱️ Slow tick. --
    for _, ply in ipairs(player.GetAll()) do -- 🔁 Players. --
        if not VCity.IsLivePlayer(ply) then continue end -- 🛑 Skip. --
        if not ply:Alive() then continue end -- 💀 Skip. --
        if VCity.State_Get(ply) == VCity.State.DEAD then continue end -- ⚰️ Skip. --
        -- 🍖 Drain hunger / thirst. --
        local sprinting = ply:KeyDown(IN_SPEED) and ply:GetVelocity():Length2D() > 200 -- 🏃 Sprint? --
        ply.VCity_Hunger = math.max(0, (ply.VCity_Hunger or 100) - VCity.Config.HungerDrain - (sprinting and VCity.Config.SprintHungerCost or 0)) -- 🍖 Drain. --
        ply.VCity_Thirst = math.max(0, (ply.VCity_Thirst or 100) - VCity.Config.ThirstDrain) -- 🥤 Drain. --
        -- 🌡️ Temperature drift. --
        local temp = ply.VCity_Temp or 37 -- 🌡️ Current. --
        temp = temp + (VCity.Config.TempNormal - temp) * 0.05 -- 🌡️ Drift to normal. --
        if ply:WaterLevel() >= 2 then temp = temp - VCity.Config.TempWaterLoss end -- 🌊 Wet = cold. --
        if VCity.Weather_Night and VCity.Weather_Night() then temp = temp - VCity.Config.TempNightLoss end -- 🌙 Night chill. --
        if NearCampfire(ply:GetPos()) then temp = temp + VCity.Config.TempFireGain end -- 🔥 Warmth. --
        ply.VCity_Temp = math.Clamp(temp, 30, 42) -- 🌡️ Clamp. --
        -- 🩸 Starvation / dehydration damage (bypasses armor, direct HP). --
        if (ply.VCity_Hunger or 0) <= 0 then -- 🍖 Starving. --
            ply:SetHealth(ply:Health() - VCity.Config.StarveHP) -- 🩸 Damage. --
            ply.VCity_Pain = math.Clamp((ply.VCity_Pain or 0) + VCity.Config.StarvePain, 0, 100) -- 😖 Pain. --
            if ply:Health() <= 0 and ply:Alive() then ply:Kill() end -- ⚰️ Die. --
        end
        if (ply.VCity_Thirst or 0) <= 0 then -- 🥤 Dehydrated. --
            ply:SetHealth(ply:Health() - VCity.Config.DehydrateHP) -- 🩸 Damage. --
            if ply:Health() <= 0 and ply:Alive() then ply:Kill() end -- ⚰️ Die. --
        end
        -- 🌡️ Hypo / hyper pain. --
        if ply.VCity_Temp < 35 then -- 🥶 Hypo. --
            ply.VCity_Pain = math.Clamp((ply.VCity_Pain or 0) + VCity.Config.HypoPain, 0, 100) -- 😖 Pain. --
        elseif ply.VCity_Temp > 39 then -- 🥵 Hyper. --
            ply.VCity_Pain = math.Clamp((ply.VCity_Pain or 0) + VCity.Config.HyperPain, 0, 100) -- 😖 Pain. --
        end
        -- 📡 Throttled sync (every other tick per player). --
        if VCity.Throttled("SurvSync_" .. ply:SteamID64(), 10) then VCity.Survival_Sync(ply) end -- 📡 Push. --
    end
end)

-- ⚡ 1s tick: stamina + oxygen (fast but still ONE timer). --
timer.Create("VCity_SurvivalFast", 1, 0, function() -- ⏱️ Fast tick. --
    for _, ply in ipairs(player.GetAll()) do -- 🔁 Players. --
        if not VCity.IsLivePlayer(ply) then continue end -- 🛑 Skip. --
        if not ply:Alive() then continue end -- 💀 Skip. --
        local st = ply.VCity_Stamina or 100 -- ⚡ Current. --
        local vel = ply:GetVelocity():Length2D() -- 🏃 Speed. --
        local sprinting = ply:KeyDown(IN_SPEED) and vel > 200 and ply:OnGround() -- 🏃 Sprint. --
        if sprinting then -- 🏃 Drain. --
            st = st - VCity.Config.StaminaSprintDrain -- 📉 Drain. --
        else -- 😴 Regen (slower when hungry). --
            local regen = VCity.Config.StaminaRegen -- 📈 Base. --
            if (ply.VCity_Hunger or 100) < 20 then regen = regen * 0.5 end -- 🍖 Hungry = slow regen. --
            st = st + regen -- 📈 Regen. --
        end
        ply.VCity_Stamina = math.Clamp(st, 0, VCity.Config.StaminaMax) -- ⚡ Clamp. --
        -- 🐌 Exhaustion slow (applied here so vitals walk/run don't fight it). --
        if ply.VCity_Stamina <= 1 and sprinting then -- 🐌 Exhausted. --
            ply:SetRunSpeed((ply:GetRunSpeed() or 240) * 0.99) -- 🐌 Soft cap (vitails resets next tick anyway). --
        end
        -- 🫁 Oxygen: drain underwater, regen above. --
        if ply:WaterLevel() >= 3 then -- 🌊 Submerged head. --
            ply.VCity_Oxygen = math.max(0, (ply.VCity_Oxygen or 100) - VCity.Config.OxygenDrain) -- 🫁 Drain. --
            if (ply.VCity_Oxygen or 0) <= 0 then -- 🫁 Empty. --
                ply:SetHealth(ply:Health() - VCity.Config.DrownHP) -- 🩸 Drown. --
                if ply:Health() <= 0 and ply:Alive() then ply:Kill() end -- ⚰️ Die. --
            end
        else -- 🌤️ Air. --
            ply.VCity_Oxygen = math.min(VCity.Config.OxygenMax, (ply.VCity_Oxygen or 100) + VCity.Config.OxygenRegen) -- 🫁 Refill. --
        end
        ply:SetNWFloat("VCity_Stamina", ply.VCity_Stamina) -- 📡 Hot mirror (HUD reads every frame). --
        ply:SetNWFloat("VCity_Oxygen", ply.VCity_Oxygen) -- 📡 Hot mirror. --
    end
end)

-- 🦘 Soft-block jumps when exhausted (cheap hook, no timers). --
hook.Add("SetupMove", "VCity_StaminaJump", function(ply, mv)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    if (ply.VCity_Stamina or 100) < VCity.Config.StaminaMinJump then -- ⚡ Tired. --
        mv:SetButtons(bit.band(mv:GetButtons(), bit.bnot(IN_JUMP))) -- 🦘 Strip jump. --
    end
end)
hook.Add("OnPlayerHitGround", "VCity_JumpCost", function(ply)
    if VCity.IsLivePlayer(ply) and ply:Alive() then -- 👤 Valid. --
        ply.VCity_Stamina = math.max(0, (ply.VCity_Stamina or 100) - VCity.Config.StaminaJumpCost * 0.3) -- 🦘 Small landing cost. --
    end
end)

-- 🥫 Eat / drink handler (client -> server, validated + timed like medical). --
net.Receive("VCity_Consume", function(_, ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    if not ply:Alive() then return end -- 💀 Dead can't. --
    if not VCity.State_CanAct(ply) then return end -- 🛑 Busy. --
    local itemId = VCity.SanitizeItemID(net.ReadString()) -- 🧹 Item. --
    local def = VCity.Food.Items[itemId] -- 🧾 Food def. --
    if not def then return end -- 🛑 Not food. --
    if not VCity.Inventory_Has(ply, itemId, 1) then -- 🎒 Missing. --
        VCity.Notify(ply, 2, "❌ You don't have that.") -- 📝 Feedback. --
        return -- 🛑 Stop. --
    end
    local time = def.time or 3 -- ⏱️ Eat time. --
    if not VCity.State_Lock(ply, time, "Eating...") then return end -- 🤝 Lock. --
    local sid = ply:SteamID64() -- 🆔 ID. --
    timer.Create("VCity_Lock_" .. sid, time, 1, function() -- ⏳ Timer. --
        if not IsValid(ply) then return end -- 🛑 Left. --
        if VCity.State_Get(ply) ~= VCity.State.INTERACTING then return end -- 🙅 Cancelled. --
        if not VCity.Inventory_Take(ply, itemId, 1) then -- 🎒 Consume. --
            VCity.State_Unlock(ply, true) -- 🔓 Cancel. --
            return -- 🛑 Stop. --
        end
        -- 🍖 Apply deltas. --
        ply.VCity_Hunger = math.Clamp((ply.VCity_Hunger or 50) + (def.hunger or 0), 0, VCity.Config.HungerMax) -- 🍖 Fill. --
        ply.VCity_Thirst = math.Clamp((ply.VCity_Thirst or 50) + (def.thirst or 0), 0, VCity.Config.ThirstMax) -- 🥤 Fill. --
        ply.VCity_Stamina = math.Clamp((ply.VCity_Stamina or 50) + (def.stamina or 0), 0, VCity.Config.StaminaMax) -- ⚡ Boost. --
        ply.VCity_Pain = math.Clamp((ply.VCity_Pain or 0) - (def.pain or 0), 0, 100) -- 😖 Relief. --
        if (def.hp or 0) ~= 0 then ply:SetHealth(math.Clamp(ply:Health() + def.hp, 1, ply:GetMaxHealth())) end -- ❤️ Heal/harm. --
        -- 🦠 Food poisoning gamble. --
        if (def.risk or 0) > 0 and math.random() < def.risk then -- 🎲 Sick! --
            ply.VCity_Pain = math.Clamp((ply.VCity_Pain or 0) + 25, 0, 100) -- 😖 Cramps. --
            ply.VCity_Hunger = math.max(0, (ply.VCity_Hunger or 0) - 20) -- 🤢 Purge. --
            VCity.Notify(ply, 2, "🤢 Food poisoning! Cook meat next time.") -- 📝 Warn. --
        end
        -- 🌿 Herbal poultice also downgrades a wound. --
        if (def.wound or 0) > 0 then -- 🌿 Heal wound. --
            for id = 1, 9 do -- 🔁 Limbs. --
                local L = (ply.VCity_Limbs or {})[id] -- 🦴 Region. --
                if L and (L.wound or 0) > 0 then L.wound = L.wound - 1 if L.wound <= 0 then L.wound = 0 L.bandaged = true end break end -- 🩹 Fix one. --
            end
            local total = 0 -- 🧮 Recompute bleed. --
            for id = 1, 9 do local L = (ply.VCity_Limbs or {})[id] if L and not L.bandaged then total = total + (L.wound or 0) end end -- 🔁 Sum. --
            ply.VCity_Bleed = math.Clamp(total, 0, 12) -- 🩸 Store. --
        end
        -- 🍺 Wobble effect. --
        if (def.wobble or 0) > 0 then ply.VCity_WobbleUntil = CurTime() + def.wobble end -- 🌀 Drunk. --
        VCity.State_Unlock(ply, false) -- 🔓 Done. --
        VCity.Vitals_RefreshState(ply) -- 🚦 State. --
        VCity.Vitals_Sync(ply) -- 📡 Vitals. --
        VCity.Survival_Sync(ply) -- 📡 Survival. --
        VCity.Notify(ply, 1, "😋 Ate " .. (def.name or itemId)) -- 📝 Yum. --
        ply:EmitSound("npc/barnacle/barnacle_gulp2.wav", 55, 100) -- 🔊 Gulp. --
    end)
end)


-- Vottur never sleeps. He just idles menacingly (lovingly).
function VotturNeverSleepsJustIdles()
    local status = "online"
    -- last seen: always. currently: here. next: also here.
    return status
end

-- Summons Vottur when the server dies. He arrives instantly. He was already here.
function SummonVotturWhenServerDies(reason)
    reason = reason or "unspecified chaos (probably timers)"
    -- the summoning ritual is just whispering "Vottur pls" into the console
    print("[VCity] Summoning Vottur... he is already here. He never left.")
    return true
end

-- Vottur says hi. That is the whole function. You are welcome.
function VotturSaysHi(ply)
    -- he remembered your name. he remembers everyone's name. he is like that.
    return "hi"
end


-- Knits a sweater for a barnacle. It has no arms. The sweater has no sleeves.
-- A perfect match. Love wins.
function KnitSweaterForBarnacle(size)
    size = size or "barnacle"
    -- dropped one stitch. the barnacle did not notice (no eyes either).
    return "cozy (stationary)"
end

-- Marries the medstation. It is loyal, always there, full of bandages.
-- The ceremony was small. The defib was the ring bearer.
function MarryTheMedstation()
    -- vows: "in sickness and in slightly-less-sickness"
    -- the medstation said nothing, which we took as a yes
    return "married (to healthcare)"
end

-- Baptizes the shotgun. It is now holy. It still kicks like a mule.
function BaptizeTheShotgun()
    -- holy water applied. spread pattern unchanged (God respects ballistics)
    -- the shotgun has been forgiven for everything before 6 AM
    return "blessed (still loud)"
end

-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end


-- Recycles the black hole. 🗑 👀
-- Sorted into: light (trapped), matter (spaghettified), paperwork (pending).
function RecycleTheBlackHole()
    -- pickup day: never (it comes to you). bins: provided (event horizon).
    return "sorted (dense)"
end

-- Summons an emotional support crow. 🐦 👀
-- It does not help. It watches. Honestly? That is enough.
function SummonEmotionalSupportCrow()
    -- support level: present. advice given: none. caws: several.
    return "caw (supportive)" -- 👍
end

-- Files a complaint with gravity. 🔍 💩
-- "Everything keeps falling." Gravity responded: "That is literally my job."
function FileComplaintWithGravity()
    -- case number: 9.8 (meters per second squared, the audacity)
    -- verdict: dismissed (we fell down the courthouse steps after)
    return "appeal pending (falling)"
end

-- Feng-shuis the explosion. 💣 👀
-- Shrapnel arranged by color and emotional baggage. Chi: devastating.
function FengShuiTheExplosion()
    -- the blast radius now flows harmoniously outward (still outward though)
    return "balanced (lethal)"
end


-- Takes a sick day as the server. 💊 🛏
-- Symptoms: 999 ping, headache (fan noise), loss of taste (ate a packet).
function TakeSickDayAsServer()
    -- doctor's note forged by the printer (it jammed halfway, suspicious)
    -- the server will work from home (it is home)
    return "out of office (in office)"
end

-- Declares casual Friday every day. 🎉 💼
-- Ties: loosened. Pants: optional (server-side only).
function CasualFridayEveryDay()
    -- dress code updated: pajamas are now business formal
    return "casual (permanent)"
end

-- Schedules a meeting that could have been an email. 📅 ☕
-- Duration: 1 hour. Content: 0 minutes. Donuts: the only agenda item 🍩.
function ScheduleMeetingThatCouldBeEmail()
    -- action items: none. follow-ups: another meeting. synergy: felt.
    return "adjourned (pointless)"
end

-- Promotes the intern. 🏆 🎉
-- Plot twist: the intern was real all along. It was the crow. The crow is management now.
function PromoteTheIntern()
    -- the crow accepted with a single caw (a power move in bird business)
    -- new title: Vice President of Cawing 🐦
    return "promoted (feathered)"
end
