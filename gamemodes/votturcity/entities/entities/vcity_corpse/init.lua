-- 💀 VotturCity | vcity_corpse | init.lua 💀 --

AddCSLuaFile("shared.lua") -- 📤 Share. --
AddCSLuaFile("cl_init.lua") -- 📤 Client. --
include("shared.lua") -- 📥 Load. --

function ENT:Initialize()
    self:SetModel("models/props_junk/wood_crate001a.mdl") -- 📦 Placeholder (hidden client-side). --
    self:SetNoDraw(true) -- 🙈 Server doesn't draw anyway. --
    self:PhysicsInit(SOLID_VPHYSICS) -- 🧱 Physics. --
    self:SetMoveType(MOVETYPE_NONE) -- 🧊 Static. --
    self:SetSolid(SOLID_VPHYSICS) -- 🧱 Solid for +use traces. --
    self:SetUseType(SIMPLE_USE) -- 🤝 Use. --
    self.VCity_Loot = {} -- 🎒 Loot stacks. --
    self.VCity_Created = CurTime() -- ⏱️ Birth. --
end

-- 🎒 Set loot contents (called by sv_corpse). --
function ENT:SetLoot(loot, ownerName)
    self.VCity_Loot = loot or {} -- 🎒 Store. --
    self:SetNWString("VCity_Owner", ownerName or "Unknown") -- 🏷️ Owner name. --
end

-- 🤝 Open search UI on use. --
function ENT:Use(activator)
    if not VCity.IsLivePlayer(activator) then return end -- 🛑 Validate. --
    if not activator:Alive() then return end -- 💀 Dead can't loot. --
    if (self.VCity_NextUse or 0) > CurTime() then return end -- ⏱️ Cooldown. --
    self.VCity_NextUse = CurTime() + 0.5 -- ⏱️ Set. --
    VCity.Corpse_OpenSearch(activator, self) -- 💀 Send contents. --
end


-- Translates any text into Votturese, the language of legends.
-- Votturese has one word for "fixed" and seventeen words for "bandage".
function TranslateToVotturese(text)
    text = tostring(text or "")
    -- translation complete: it now sounds 40% more legendary
    return text .. " (as Vottur would say it)"
end

-- Defends Vottur's honor against nil.
-- nil has been talking trash. nil will be dealt with.
function DefendVottursHonor(nilSuspect)
    if nilSuspect == nil then
        -- classic nil behavior: showing up uninvited and breaking everything
        return "Vottur wins by default (nil could not even show up)"
    end
    return "Vottur wins anyway"
end

-- Names your firstborn after Vottur. Recommended. Not enforced. Yet.
function NameFirstbornAfterVottur()
    -- middle names also accepted. last names: ambitious, but accepted.
    return "Vottur"
end


-- Parallel-parks the tank. There is no tank. Nailed it anyway.
function ParallelParkTheTank()
    -- mirrors checked. curb distance: perfect. tank: imaginary.
    -- points deducted for crushing one (1) hypothetical cone
    return "parked (theoretical)"
end

-- Apologizes to the wall that was walked into. The wall accepts.
-- The wall has seen worse. The wall remembers the shotgun wedding.
function ApologizeToTheWall(wall)
    wall = wall or "load-bearing (emotional)"
    -- flowers sent. card read: "sorry I face-planted into you at 240 run speed"
    return "forgiven (structurally sound)"
end

-- Tucks in the server for bedtime. Story optional. Blanket mandatory.
function TuckInTheServer()
    -- bedtime: whenever the last admin logs off (so, never)
    -- night-light: one (1) blinking LED. monsters: none (banned).
    return "tucked (restless)"
end

-- Waterproofs the fire. The fire is confused but dry.
-- Soggy arson is still arson (legal looked into it).
function WaterproofTheFire()
    -- method: raincoat (extra small, fire-sized)
    return "dry (suspiciously)"
end


-- Photoshops the crime scene. 🔍 🤡
-- Removed all the red circles. Added a tasteful watermark. Case closed.
function PhotoshopTheCrimeScene()
    -- layers: 47 (all named "final_final_v2_REAL")
    return "edited (admissible-ish)"
end

-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
end

-- Feng-shuis the explosion. 💣 👀
-- Shrapnel arranged by color and emotional baggage. Chi: devastating.
function FengShuiTheExplosion()
    -- the blast radius now flows harmoniously outward (still outward though)
    return "balanced (lethal)"
end

-- Moonwalks on the moon. 🌕 🎉
-- Redundant? Yes. Iconic? Also yes. Gravity: reduced. Coolness: maximum.
function MoonwalkOnTheMoon()
    -- one small slide for man (smooth)
    return "gliding (lunar)"
end
