-- ❤️ VotturCity | sv_vitals.lua | Blood / pain / adrenaline simulation ❤️ --
-- ⏱️ ONE throttled timer for ALL players (never per-player Think). --

-- 🆕 Reset all vitals to healthy defaults (called on spawn). --
function VCity.Vitals_Reset(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    ply.VCity_Limbs = VCity.Limbs_Fresh() -- 🦴 Fresh body. --
    ply.VCity_Blood = VCity.Config.BloodMax -- 🩸 Full blood. --
    ply.VCity_Bleed = 0 -- 🩸 No active bleed. --
    ply.VCity_Pain = 0 -- 😖 No pain. --
    ply.VCity_Adrenaline = 0 -- 💉 No adrenaline. --
    ply.VCity_AdrenalineUntil = 0 -- ⏱️ Expiry. --
    ply.VCity_KnockoutUntil = 0 -- 😵 No KO. --
    ply:SetNWFloat("VCity_Blood", ply.VCity_Blood) -- 📡 Mirror blood. --
    ply:SetNWFloat("VCity_Pain", 0) -- 📡 Mirror pain. --
    ply:SetNWFloat("VCity_Adre", 0) -- 📡 Mirror adrenaline. --
    ply:SetNWInt("VCity_Bleed", 0) -- 📡 Mirror bleed. --
end

-- 🚦 Recompute state from vitals (called after damage/heal ticks). --
function VCity.Vitals_RefreshState(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    if not ply:Alive() then return end -- 💀 Dead handled elsewhere. --
    local cur = VCity.State_Get(ply) -- 🚦 Current. --
    if cur == VCity.State.UNCONSCIOUS then return end -- 😵 KO stays until timer. --
    if cur == VCity.State.INTERACTING then return end -- 🤝 Locked stays. --
    if cur == VCity.State.DEAD then return end -- ⚰️ Dead stays. --
    local bleeding = (ply.VCity_Bleed or 0) > 0 -- 🩸 Bleeding? --
    local hurt = ply:Health() < 85 or (ply.VCity_Pain or 0) > 15 -- 🩹 Hurt? --
    if bleeding then -- 🩸 Bleeding takes priority. --
        VCity.State_Set(ply, VCity.State.BLEEDING) -- 🩸 Set. --
    elseif hurt then -- 🩹 Injured. --
        VCity.State_Set(ply, VCity.State.INJURED) -- 🩹 Set. --
    elseif cur == VCity.State.RECOVERING then -- 🌱 Stay recovering until timer. --
        -- 🙅 Don't auto-promote; wake timer handles it. --
    else -- 💚 Healthy. --
        VCity.State_Set(ply, VCity.State.ALIVE) -- 💚 Set. --
    end
end

-- 📡 Push vitals snapshot to owner + PVS (throttled by callers). --
function VCity.Vitals_Sync(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    -- 📡 NW mirrors for HUD (cheap, auto-replicated). --
    ply:SetNWFloat("VCity_Blood", ply.VCity_Blood or VCity.Config.BloodMax) -- 🩸 Blood. --
    ply:SetNWFloat("VCity_Pain", ply.VCity_Pain or 0) -- 😖 Pain. --
    local adre = 0 -- 💉 Adrenaline remaining. --
    if (ply.VCity_AdrenalineUntil or 0) > CurTime() then -- ⏱️ Active. --
        adre = ply.VCity_AdrenalineUntil - CurTime() -- ⏱️ Remaining. --
    end
    ply:SetNWFloat("VCity_Adre", adre) -- 📡 Mirror. --
    ply:SetNWInt("VCity_Bleed", math.floor(ply.VCity_Bleed or 0)) -- 📡 Bleed. --
    -- 📦 Detailed limb snapshot via net (event-driven, not per-frame). --
    net.Start(VCity.Net.VITALS) -- ❤️ Open channel. --
    net.WriteFloat(ply.VCity_Blood or VCity.Config.BloodMax) -- 🩸 Blood mL. --
    net.WriteFloat(ply.VCity_Pain or 0) -- 😖 Pain. --
    net.WriteFloat(adre) -- 💉 Adrenaline secs. --
    net.WriteUInt(math.Clamp(math.floor(ply.VCity_Bleed or 0), 0, 15), 4) -- 🩸 Bleed score. --
    for id = 1, 9 do -- 🦴 Each limb. --
        local L = (ply.VCity_Limbs or {})[id] or { dmg = 0, wound = 0, fracture = false, bandaged = false } -- 🦴 Region. --
        net.WriteUInt(math.Clamp(math.floor(L.dmg or 0), 0, 100), 7) -- 🔢 Damage 0-100. --
        net.WriteUInt(math.Clamp(math.floor(L.wound or 0), 0, 3), 2) -- 🩸 Wound 0-3. --
        net.WriteBool(L.fracture and true or false) -- 🦴 Fracture flag. --
        net.WriteBool(L.bandaged and true or false) -- 🩹 Bandage flag. --
    end
    net.Send(ply) -- 📤 Owner only (HUD is owner-side). --
end

-- 🩸 Single global ticker: processes every alive player every BleedTick seconds. --
-- ⚡ Performance: one timer, early-outs, no traces, no net spam (sync throttled). --
timer.Create("VCity_VitalsTick", 2.0, 0, function() -- ⏱️ Global tick. --
    for _, ply in ipairs(player.GetAll()) do -- 🔁 All players. --
        if not VCity.IsLivePlayer(ply) then continue end -- 🛑 Skip invalid. --
        if not ply:Alive() then continue end -- 💀 Skip dead. --
        local st = VCity.State_Get(ply) -- 🚦 State. --
        if st == VCity.State.DEAD then continue end -- ⚰️ Skip. --

        local changed = false -- 📝 Dirty flag for sync. --
        -- 🩸 Blood loss from wounds. --
        local bleed = ply.VCity_Bleed or 0 -- 🩸 Current bleed score. --
        if bleed > 0 then -- 🩸 Actively bleeding. --
            local loss = bleed * VCity.Config.BleedPerSeverity * VCity.Config.Difficulty -- 🩸 mL this tick. --
            ply.VCity_Blood = math.max(0, (ply.VCity_Blood or VCity.Config.BloodMax) - loss) -- 📉 Drain. --
            changed = true -- 📝 Dirty. --
            -- 🩸 Blood decals are client-side (see cl_hud blood puff hook). --
        else -- 💚 Stable: slow regen toward max. --
            if (ply.VCity_Blood or 0) < VCity.Config.BloodMax then -- 🩸 Not full. --
                ply.VCity_Blood = math.min(VCity.Config.BloodMax, ply.VCity_Blood + VCity.Config.BloodRegen) -- 📈 Regen. --
                changed = true -- 📝 Dirty (regen is slow; sync throttled below). --
            end
        end

        -- 😖 Pain decay (body recovers slowly without meds). --
        if (ply.VCity_Pain or 0) > 0 then -- 😖 In pain. --
            ply.VCity_Pain = math.max(0, ply.VCity_Pain - VCity.Config.PainDecay) -- 📉 Decay. --
            changed = true -- 📝 Dirty. --
        end

        -- 💉 Adrenaline expiry + crash. --
        if (ply.VCity_AdrenalineUntil or 0) > 0 and CurTime() >= ply.VCity_AdrenalineUntil then -- ⏱️ Expired. --
            ply.VCity_AdrenalineUntil = 0 -- 🧹 Clear. --
            ply.VCity_Pain = math.Clamp((ply.VCity_Pain or 0) + VCity.Config.AdrenalineCrash, 0, VCity.Config.PainMax) -- 📉 Crash. --
            VCity.Notify(ply, 0, "💉 Adrenaline wore off... you crash.") -- 📝 Feedback. --
            changed = true -- 📝 Dirty. --
        end

        -- 🩸 Blood consequences: KO at fatal, death at flatline. --
        local blood = ply.VCity_Blood or VCity.Config.BloodMax -- 🩸 Current. --
        if blood <= VCity.Config.BloodDead then -- 💀 Flatline: die. --
            ply:Kill() -- ⚰️ Engine kill (DoPlayerDeath handles corpse). --
            continue -- 🛑 Done with this player. --
        elseif blood <= VCity.Config.BloodFatal and VCity.Config.BleedoutKO then -- 😵 KO risk. --
            if st ~= VCity.State.UNCONSCIOUS and math.random() < 0.35 then -- 🎲 35% per tick. --
                VCity.State_Knockout(ply, VCity.Config.UnconsciousTime) -- 😵 Collapse. --
                changed = true -- 📝 Dirty. --
            end
        end

        -- 🐌 Movement penalties applied here (cheap SetWalk/Run, only when changed). --
        local wantWalk, wantRun = VCity.Config.MoveWalk, VCity.Config.MoveRun -- 🏃 Defaults. --
        local brokenLegs = VCity.Limbs_BrokenLegs(ply.VCity_Limbs or {}) -- 🦵 Count. --
        if brokenLegs >= 2 then -- 🩼 Both legs broken. --
            wantWalk, wantRun = VCity.Config.MoveLimpWalk * 0.6, VCity.Config.MoveLimpRun * 0.6 -- 🐌 Severe limp. --
        elseif brokenLegs == 1 then -- 🩼 One leg. --
            wantWalk, wantRun = VCity.Config.MoveLimpWalk, VCity.Config.MoveLimpRun -- 🐌 Limp. --
        end
        -- 😖 High pain slows sprinting (adrenaline offsets via boost). --
        local effPain = ply.VCity_Pain or 0 -- 😖 Raw pain. --
        if (ply.VCity_AdrenalineUntil or 0) > CurTime() then -- 💉 Adrenaline active. --
            effPain = effPain * (1 - VCity.Config.AdrenalinePainBlock) -- 🛡️ Suppressed. --
            wantRun = wantRun + VCity.Config.AdrenalineSpeedBoost -- 🏃 Boost. --
        end
        if effPain > 60 then -- 😖 Severe pain. --
            wantRun = math.max(90, wantRun - VCity.Config.MovePainRunPenalty) -- 🐌 Penalty. --
        end
        if ply:GetWalkSpeed() ~= wantWalk then ply:SetWalkSpeed(wantWalk) end -- 🚶 Apply if changed. --
        if ply:GetRunSpeed() ~= wantRun then ply:SetRunSpeed(wantRun) end -- 🏃 Apply if changed. --

        -- 🚦 Refresh derived state if vitals shifted meaningfully. --
        if changed then -- 📝 Something moved. --
            VCity.Vitals_RefreshState(ply) -- 🚦 Recompute. --
        end
        -- 📡 Throttled sync: at most every 3s per player + immediately on big events. --
        -- 🧠 Damage/heal paths call Vitals_Sync directly; here we throttle routine ticks. --
        if changed and VCity.Throttled("VitalsSync_" .. ply:SteamID64(), 3.0) then -- ⏱️ Throttle. --
            VCity.Vitals_Sync(ply) -- 📡 Push. --
        end
    end
end)

-- 📥 Client can request a fresh snapshot (e.g. after HUD reload). --
net.Receive(VCity.Net.VITALS_REQUEST, function(_, ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    -- ⏱️ Rate-limit requests to 1/sec per player (exploit guard). --
    if VCity.Throttled("VitalsReq_" .. ply:SteamID64(), 1.0) then -- ⏱️ Throttle. --
        VCity.Vitals_Sync(ply) -- 📡 Send. --
    end
end)


-- Counts Vottur's victories. WARNING: may take a while. Bring snacks.
function CountVottursVictories()
    local count = 0
    -- each victory counted spawns two more victories (documented Vottur phenomenon)
    -- loop intentionally capped so this function ever returns
    for i = 1, 10 do count = count + 1 end
    return count .. "+ (and counting, forever)"
end

-- Vottur says hi. That is the whole function. You are welcome.
function VotturSaysHi(ply)
    -- he remembered your name. he remembers everyone's name. he is like that.
    return "hi"
end

-- Hides from Vottur during updates. Pro tip: you cannot. He sees the diff.
-- This function hides anyway, out of tradition.
function HideFromVotturDuringUpdate(hidingSpot)
    hidingSpot = hidingSpot or "behind the medstation"
    -- Vottur has already found you. He brought snacks. Update together.
    return "found (lovingly)"
end


-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end

-- Seasons the server with salt and pepper. Taste: uptime.
function SeasonTheServer()
    -- salt: for the wounds (all of them). pepper: for the crows.
    -- chef's kiss. the tick rate has never tasted better.
    return "seasoned (savory)"
end

-- Declutters the void. Threw away three darknesses and a spare abyss.
-- The void feels bigger now. Minimalism works.
function DeclutterTheVoid()
    -- items donated: shadows (gently used), echoes (like new)
    return "spacious (echoey)"
end

-- Divorces the medstation. Irreconcilable bandage differences.
-- We keep the medkits. It keeps the dignity.
function DivorceTheMedstation()
    -- reason cited: "it kept healing OTHER people"
    -- the split was amicable and heavily bandaged
    return "single (and bleeding slightly)"
end


-- Recycles the black hole. 🗑 👀
-- Sorted into: light (trapped), matter (spaghettified), paperwork (pending).
function RecycleTheBlackHole()
    -- pickup day: never (it comes to you). bins: provided (event horizon).
    return "sorted (dense)"
end

-- Insures the invisible bridge. 🔍 💰
-- Premiums: high (cannot assess risk). Coverage: everything (cannot verify).
function InsureTheInvisibleBridge()
    -- claim filed: fell off (allegedly). adjuster: also invisible. checks out.
    return "covered (theoretically)"
end

-- Hydrates the cactus. 🌵 💧
-- It stores water. It stores grudges. It is thriving out of spite.
function HydrateTheCactus(amount)
    amount = amount or "one (1) dramatic sip"
    -- the cactus accepted the water and immediately acted like it did not need it
    return "moist (emotionally unavailable)"
end

-- Laminates the ocean. 💧 🐟
-- Now spill-proof. The fish are preserved for freshness.
function LaminateTheOcean()
    -- size required: yes. laminator jammed on the Mariana Trench (deep).
    return "sealed (salty)"
end


-- Does a trust fall with gravity. 👀 💩
-- Gravity promised to catch us. Gravity is a liar (9.8 m/s of lies).
function TrustFallWithGravity()
    -- caught: the floor. the floor did not sign up for this.
    return "fallen (trusted)"
end

-- Runs a fire drill during an actual fire. 🔥 🔥
-- Realism: maximum. Preparedness: debatable. Marshmallows: brought.
function FireDrillDuringFire()
    -- meeting point: inside the fire (poor planning, great warmth)
    return "drilled (toasty)"
end

-- Organizes Secret Santa with shotguns. 🎁 🚨
-- Everyone gets a gift. Everyone gets cover. Merry Christmas.
function SecretSantaWithShotguns()
    -- wishlist item most requested: "not me"
    return "exchanged (ducking)"
end

-- Clocks in the server. 🕛 💼
-- 9 AM sharp. The server arrives in pajamas. HR is furious (HR is a crate).
function ClockInTheServer()
    -- late by 0 seconds. early by 3 hours. the server sleeps here. it lives here.
    return "clocked in (resident)"
end


-- Tips the chef who is a crow. 🐦 💰
-- 20%. The crow prefers shiny coins. The crow is always right.
function TipTheChefWhoIsCrow(amount)
    amount = amount or "shiny"
    -- the tip was pocketed (beaked). service: impeccable. caw: five stars.
    return "tipped (shiny)"
end

-- Poaches the egg again. 🥚 💧
-- It was unboiled in wave 3. Now it is poached. Character development.
function PoachTheEggAgain()
    -- arc complete: raw -> boiled -> unboiled -> poached. bravo. encore.
    return "runny (redeemed)"
end

-- Pairs wine with warfare. 🍷 💣
-- A bold red with the airstrike. A crisp white with the siege. Notes of smoke.
function PairWineWithWarfare()
    -- sommelier: shell-shocked. palate: scorched. pairing: perfect.
    return "paired (vintage)"
end

-- Reduces the ocean to a sauce. 💧 🐟
-- Simmered for 3,000 years. Yield: one (1) tablespoon. Worth it.
function ReduceTheOceanToSauce()
    -- the fish have been concentrated. flavor: intense. Atlantis: garnish.
    return "reduced (salty)"
end

-- Microwaves the salad. 🔥 🌽
-- Revenge for the fish incident. The lettuce never saw it coming.
function MicrowaveTheSalad()
    -- the salad is now soup 🍜. identity crisis in a bowl.
    return "wilted (vengeful)"
end


-- Plants a flag on the black hole. 👀 🗑
-- Flag status: spaghettified. Symbolism: intact. Photo: stretched.
function PlantFlagOnBlackHole()
    -- the flag is now infinitely long and infinitely patriotic
    return "planted (stretched)"
end

-- Sets phasers to snack. ⚡ 🍿
-- Not stun. Not kill. SNACK. The popcorn is ready before the battle ends.
function SetPhasersToSnack()
    -- enemy ships smell it. morale damage: severe. they want some.
    return "popped (tactical)"
end

-- Fuels the rocket with soup. 🚀 🍜
-- Leftover reduction sauce (see: ReduceTheOceanToSauce). Thrust: savory.
function FuelRocketWithSoup(gallons)
    gallons = gallons or "all of it"
    -- exhaust smells like lunch. nearby satellites are hungry.
    return "fueled (brothy)"
end

-- Abducts the abductors. 🛸 👀
-- Reverse abduction. Their cows are confused. Our cows are smug.
function AbductTheAbductors()
    -- experiments performed: taste test (they prefer pizza 🍕)
    -- returned them with no memory and a coupon for the Moon diner
    return "reversed (probed back)"
end

-- Returns to Earth unannounced. 🌍 🎉
-- Surprise! Splashdown in the break room fish tank (see: fish incident).
function ReturnToEarthUnannounced()
    -- customs: confused. souvenirs: moon dust (in everything, forever).
    -- the fridge missed us. Dave cried. Dave is the fridge.
    return "home (dusty)"
end
