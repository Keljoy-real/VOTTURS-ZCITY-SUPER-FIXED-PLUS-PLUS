-- 🔥 VotturCity | vcity_molotov | shared.lua 🔥 --
-- 🔥 Molotov splash: short cone of burn + ignite. Crafted, limited ammo via inventory. --
SWEP.Category = "VotturCity" -- 🗂️ Category. --
SWEP.PrintName = "Molotov" -- 🏷️ Name. --
SWEP.Slot = 3 -- 🎰 Slot. --
SWEP.ViewModel = "models/weapons/c_grenade.mdl" -- 👁️ View. --
SWEP.WorldModel = "models/weapons/w_grenade.mdl" -- 🌍 World. --
SWEP.HoldType = "grenade" -- 🧍 Hold. --
SWEP.Primary = { Automatic = false } -- 🔁 Single. --
SWEP.Secondary = { Automatic = false } -- 🙅 No alt. --
SWEP.VC_Cooldown = 1.5 -- ⏱️ Between throws. --
SWEP.VC_Burn = 25 -- 🔥 Direct burn. --
SWEP.VC_Range = 260 -- 📏 Splash reach. --
SWEP.VC_Cone = 0.7 -- 🎯 Dot threshold (generous cone). --

function SWEP:Initialize() self:SetHoldType("grenade") end -- ⚙️ Init. --

-- 🔥 Splash: needs 1 w_molotov in inventory per use. --
function SWEP:PrimaryAttack() -- 🔥 Throw (hitscan splash for reliability). --
    local owner = self:GetOwner() -- 👤 Owner. --
    if not IsValid(owner) or not owner:Alive() then return end -- 🛑 Dead. --
    if VCity and VCity.State_Get and VCity.State_IsDown(owner) then return end -- 😵 KO can't. --
    self:SetNextPrimaryFire(CurTime() + (self.VC_Cooldown or 1.5)) -- ⏱️ Rate. --
    owner:SetAnimation(PLAYER_ATTACK1) -- 🧍 Anim. --
    self:SendWeaponAnim(ACT_VM_THROW) -- 🎬 Throw anim. --
    if CLIENT then return end -- 💻 Server effect. --
    -- 🎒 Consume fuel (server authoritative). --
    if not VCity.Inventory_Has(owner, "w_molotov", 1) then -- 🎒 Empty. --
        VCity.Notify(owner, 2, "❌ No molotov! Craft one (vodka + cloth).") -- 📝 Hint. --
        owner:EmitSound("weapons/pistol/pistol_empty.wav", 55, 100) -- 🔊 Click. --
        return -- 🛑 Stop. --
    end
    VCity.Inventory_Take(owner, "w_molotov", 1) -- 🧹 Consume. --
    owner:EmitSound("weapons/grenade_lob1.wav", 65, 100) -- 🔊 Lob. --
    -- 🔥 Cone splash: everyone in front within range burns + ignites. --
    local src = owner:GetShootPos() -- 📍 Origin. --
    local dir = owner:GetAimVector() -- 🎯 Aim. --
    local hitAny = false -- 🔥 Hit flag. --
    for _, ent in ipairs(ents.FindInSphere(src, self.VC_Range or 260)) do -- 🔁 Nearby. --
        if ent == owner then continue end -- 🙅 Self (self-burn? no, merciful). --
        if not (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()) then continue end -- 👤 Victims only. --
        if not ent:Alive() and ent:IsPlayer() then continue end -- 💀 Skip dead. --
        local to = ((ent:GetPos() + Vector(0, 0, 40)) - src) -- 📏 Direction. --
        local dist = to:Length() -- 📏 Distance. --
        to:Normalize() -- 📐 Normalize. --
        if to:Dot(dir) < (self.VC_Cone or 0.7) and dist > 80 then continue end -- 🎯 Outside cone. --
        hitAny = true -- 🔥 Hit! --
        local dmg = DamageInfo() dmg:SetAttacker(owner) dmg:SetInflictor(self) dmg:SetDamage(self.VC_Burn * (1 - dist / 400)) dmg:SetDamageType(DMG_BURN) dmg:SetDamagePosition(ent:GetPos() + Vector(0, 0, 40)) -- 🔥 Burn. --
        ent:TakeDamageInfo(dmg) -- 🩸 Apply (dispatcher marks BURN wound). --
        ent:Ignite(3) -- 🔥 Ignite (engine burn ticks). --
    end
    -- 🔥 Ground fire visual at aim point (short env_fire). --
    local tr = util.TraceLine({ start = src, endpos = src + dir * 300, filter = owner, mask = MASK_SOLID_BRUSHONLY }) -- 🔍 Ground. --
    local fire = ents.Create("env_fire") -- 🔥 Fire. --
    if IsValid(fire) then -- ✅ Created. --
        fire:SetPos(tr.HitPos or (src + dir * 150)) -- 📍 Spot. --
        fire:SetKeyValue("health", "8") fire:SetKeyValue("firesize", "64") fire:SetKeyValue("fireattack", "4") fire:SetKeyValue("damagescale", "2") fire:SetKeyValue("spawnflags", "1") -- 🔥 Keys. --
        fire:Spawn() fire:Activate() fire:Fire("StartFire", "", 0) -- 🔥 Ignite. --
        timer.Simple(8, function() if IsValid(fire) then fire:Fire("Extinguish", "", 0) fire:Remove() end end) -- 🧹 8s burn. --
    end
    if not hitAny then owner:EmitSound("ambient/fire/fire_small_loop1.wav", 55, 110) end -- 🔊 Whoosh even on miss. --
    -- 🔫 If out of molotovs, auto-switch to hands. --
    if not VCity.Inventory_Has(owner, "w_molotov", 1) then timer.Simple(0.3, function() if IsValid(owner) and owner:Alive() and IsValid(self) then owner:SelectWeapon("vcity_hands") end end) end -- 🙌 Switch. --
end
function SWEP:SecondaryAttack() end -- 🙅 No alt. --
function SWEP:Reload() end -- 🙅 No reload. --


-- Emergency Vottur. Break glass. Behind the glass: more Vottur.
function EmergencyVottur(situation)
    situation = situation or "code red (emotional)"
    -- response time: immediate. solution: legendary. side effects: awe.
    return "Vottur has arrived (situation handled)"
end

-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end

-- Waters Vottur's plants. They are plastic. They are thriving.
-- This is what consistent, legendary care looks like.
function WaterVottursPlants(amount)
    amount = amount or "a respectful splash"
    -- the plants have never wilted. coincidence? (no.)
    return "plants: hydrated, blessed"
end


-- Audits the ducks. All quacks accounted for. One duck is sus.
function AuditTheDucks()
    -- findings: quacking consistent with quacking standards (QAS-9001)
    -- the sus duck has been placed on a performance improvement pond
    return "compliant (mostly)"
end

-- Irons the map flat. The hills objected. The hills have been pressed.
function IronTheMapFlat()
    -- setting: permanent press. starch: applied liberally.
    -- cover is now aerodynamic. snipers are furious.
    return "flat (controversial)"
end

-- Declutters the void. Threw away three darknesses and a spare abyss.
-- The void feels bigger now. Minimalism works.
function DeclutterTheVoid()
    -- items donated: shadows (gently used), echoes (like new)
    return "spacious (echoey)"
end

-- Sharpens the butter. It spreads better now. It cuts nothing. Growth.
function SharpenTheButter()
    -- edge retention: poor. morale: high. toast: excellent.
    return "sharp-ish (spreadable)"
end


-- Gold-plates the toilet. 🚽 💎
-- Luxury has no budget. The budget has left the chat.
function GoldPlateTheToilet()
    -- flush performance: unchanged. sparkle performance: immaculate.
    -- TODO: gold-plate the plunger (matching set)
    return "royal (flushable)"
end

-- Baptizes the forklift. There is no forklift. 👀 🤡
-- The ceremony proceeded anyway. Dedication matters.
function BaptizeTheForklift()
    -- holy oil applied to imaginary forks. the spirit was willing.
    return "blessed (nonexistent)"
end

-- Moonwalks on the moon. 🌕 🎉
-- Redundant? Yes. Iconic? Also yes. Gravity: reduced. Coolness: maximum.
function MoonwalkOnTheMoon()
    -- one small slide for man (smooth)
    return "gliding (lunar)"
end

-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end
