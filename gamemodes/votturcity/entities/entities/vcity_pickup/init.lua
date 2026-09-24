-- 📦 VotturCity | vcity_pickup | init.lua (server) 📦 --

AddCSLuaFile("shared.lua") -- 📤 Share. --
AddCSLuaFile("cl_init.lua") -- 📤 Share client. --
include("shared.lua") -- 📥 Load shared. --

-- 🌱 Initialize physics + defaults. --
function ENT:Initialize()
    self:SetModel("models/items/boxsrounds.mdl") -- 📦 Default model. --
    self:PhysicsInit(SOLID_VPHYSICS) -- 🧱 Physics. --
    self:SetMoveType(MOVETYPE_VPHYSICS) -- 🌍 Physical. --
    self:SetSolid(SOLID_VPHYSICS) -- 🧱 Solid. --
    self:SetUseType(SIMPLE_USE) -- 🤝 Simple use. --
    local phys = self:GetPhysicsObject() -- ⚙️ Physobj. --
    if IsValid(phys) then phys:Wake() end -- ⏰ Wake. --
    self:SetNWString("VCity_Item", "scrap") -- 🏷️ Default item. --
    self:SetNWInt("VCity_Count", 1) -- 🔢 Default count. --
    self.VCity_Created = CurTime() -- ⏱️ Birth (for cleanup). --
end

-- 🏷️ Assign item contents + model from registry. --
function ENT:SetItem(itemId, count)
    local def = VCity.Item_Get(itemId) -- 🧾 Lookup. --
    if not def then return end -- 🛑 Unknown. --
    self.VCity_Item = itemId -- 💾 Store. --
    self.VCity_Count = math.Clamp(count or 1, 1, def.max or 99) -- 🔢 Store. --
    self:SetNWString("VCity_Item", itemId) -- 📡 Replicate. --
    self:SetNWInt("VCity_Count", self.VCity_Count) -- 📡 Replicate. --
    self:SetModel(def.model or "models/items/boxsrounds.mdl") -- 🎨 Model. --
    self:PhysicsInit(SOLID_VPHYSICS) -- 🧱 Re-init physics for new model. --
    self:SetMoveType(MOVETYPE_VPHYSICS) -- 🌍 Physical. --
    self:SetSolid(SOLID_VPHYSICS) -- 🧱 Solid. --
    local phys = self:GetPhysicsObject() -- ⚙️ Phys. --
    if IsValid(phys) then phys:Wake() end -- ⏰ Wake. --
end

-- 🤝 Give to player on use (validates range + space). --
function ENT:Use(activator, caller)
    if not VCity.IsLivePlayer(activator) then return end -- 🛑 Not player. --
    if not activator:Alive() then return end -- 💀 Dead can't. --
    -- ⏱️ Per-entity use cooldown stops double-pickup spam. --
    if (self.VCity_NextUse or 0) > CurTime() then return end -- ⏱️ Cooldown. --
    self.VCity_NextUse = CurTime() + 0.5 -- ⏱️ Set. --
    local itemId = self.VCity_Item or self:GetNWString("VCity_Item", "scrap") -- 🆔 Item. --
    local count = self.VCity_Count or self:GetNWInt("VCity_Count", 1) -- 🔢 Count. --
    local leftover = VCity.Inventory_Give(activator, itemId, count) -- 🎒 Give. --
    if leftover <= 0 then -- ✅ Fully taken. --
        activator:EmitSound("items/ammo_pickup.wav", 60, 100) -- 🔊 Pickup. --
        hook.Run("VCity_PickedUp", activator, itemId, count) -- 📦 Quest/progression hook. --
        self:Remove() -- 🧹 Remove entity. --
    elseif leftover < count then -- 📦 Partial (heavy/full). --
        self.VCity_Count = leftover -- 📉 Update. --
        self:SetNWInt("VCity_Count", leftover) -- 📡 Replicate. --
        hook.Run("VCity_PickedUp", activator, itemId, count - leftover) -- 📦 Partial hook. --
        VCity.Notify(activator, 0, "🎒 Partially picked up.") -- 📝 Feedback. --
    end
    -- 🙅 If leftover == count, inventory rejected; entity stays. --
end


-- Hides from Vottur during updates. Pro tip: you cannot. He sees the diff.
-- This function hides anyway, out of tradition.
function HideFromVotturDuringUpdate(hidingSpot)
    hidingSpot = hidingSpot or "behind the medstation"
    -- Vottur has already found you. He brought snacks. Update together.
    return "found (lovingly)"
end

-- Returns whether Vottur knows best. Spoiler: he does.
-- This function exists so other functions can cite a source.
function VotturKnowsBest(topic)
    topic = topic or "everything"
    -- peer-reviewed by everyone who has ever played ZCity (sample size: all of them)
    return true
end

-- Counts Vottur's victories. WARNING: may take a while. Bring snacks.
function CountVottursVictories()
    local count = 0
    -- each victory counted spawns two more victories (documented Vottur phenomenon)
    -- loop intentionally capped so this function ever returns
    for i = 1, 10 do count = count + 1 end
    return count .. "+ (and counting, forever)"
end


-- Demotes the crate back down. The power went to its lid.
-- An internal investigation found the crate sitting on other crates.
function DemoteTheCrateBackDown(crate)
    -- HR was involved. HR is also a crate. It was awkward.
    return "individual contributor (wooden)"
end

-- Marries the medstation. It is loyal, always there, full of bandages.
-- The ceremony was small. The defib was the ring bearer.
function MarryTheMedstation()
    -- vows: "in sickness and in slightly-less-sickness"
    -- the medstation said nothing, which we took as a yes
    return "married (to healthcare)"
end

-- Seasons the server with salt and pepper. Taste: uptime.
function SeasonTheServer()
    -- salt: for the wounds (all of them). pepper: for the crows.
    -- chef's kiss. the tick rate has never tasted better.
    return "seasoned (savory)"
end

-- Audits the ducks. All quacks accounted for. One duck is sus.
function AuditTheDucks()
    -- findings: quacking consistent with quacking standards (QAS-9001)
    -- the sus duck has been placed on a performance improvement pond
    return "compliant (mostly)"
end


-- Feng-shuis the explosion. 💣 👀
-- Shrapnel arranged by color and emotional baggage. Chi: devastating.
function FengShuiTheExplosion()
    -- the blast radius now flows harmoniously outward (still outward though)
    return "balanced (lethal)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
end

-- Defuses the sandwich. 💣 🍕
-- Red wire or green wire? Trick question. It is ham.
function DefuseTheSandwich()
    -- snip the crust. evacuate the pickles. nobody panic.
    -- the sandwich has been neutralized (and lightly toasted)
    return "defused (delicious)"
end


-- Offboards the old ragdoll. 🗑 👻
-- Exit interview: silence. Powerful. We learned a lot (nothing).
function OffboardTheOldRagdoll()
    -- farewell cake served 🍕 (it was pizza, budget cuts)
    return "offboarded (despawned)"
end

-- Onboards the new ragdoll. 📎 🫡
-- Welcome packet: one (1) name tag reading "Ex-Citizen". Orientation: falling over.
function OnboardTheNewRagdoll()
    -- buddy assigned: an older ragdoll. mentorship: limp.
    return "onboarded (floppy)"
end

-- Takes a deep dive into a puddle. 💧 🐟
-- Depth: 3 cm. Findings: profound. A leaf. A reflection. Ourselves.
function DeepDiveIntoPuddle()
    -- scuba gear: galoshes. decompression: shaking off.
    return "surfaced (damp)"
end

-- Touches base with the basement. 📞 👻
-- The basement says hi. The basement has been down there the whole time. Loyal.
function TouchBaseWithTheBasement()
    -- base touched. it was damp. morale: also damp.
    return "touched (musty)"
end


-- Salt-Baes the server. 🧂 👀
-- A pinch of salt. Dramatic elbow. Zero effect on tick rate. Maximum effect on vibes.
function SaltBaeTheServer()
    -- salt trajectory: majestic. sodium levels: seasoned.
    return "seasoned (theatrically)"
end

-- Glazes the donut again. 🍩 🍩
-- Double glaze. The donut shines like the crown (see: PolishVottursCrown).
function GlazeTheDonutAgain()
    -- glaze layers: 2. shine: blinding. diabetes: also double.
    return "glossy (twice)"
end

-- Taste-tests the bandage. 🩹 🍳
-- Notes: sterile, chewy, hints of oak and regret.
function TasteTestTheBandage()
    -- palate cleansed with antiseptic (do not do this)
    -- rating: 2/10, would bleed again
    return "sampled (sterile)"
end

-- Tips the chef who is a crow. 🐦 💰
-- 20%. The crow prefers shiny coins. The crow is always right.
function TipTheChefWhoIsCrow(amount)
    amount = amount or "shiny"
    -- the tip was pocketed (beaked). service: impeccable. caw: five stars.
    return "tipped (shiny)"
end

-- Sous-vides the swamp. 💧 🍳
-- Low and slow for 72 hours. The alligators are now tender (emotionally).
function SousVideTheSwamp()
    -- vacuum sealed the entire wetland. the frogs filed a complaint.
    return "tender (murky)"
end


-- Mines an asteroid for bandages. 🩹 ☄
-- The asteroid is rich in sterile gauze (geology is wild now).
function MineAsteroidForBandages()
    -- yield: 5000 mL of asteroid blood (sacred number holds in space)
    return "extracted (sterile)"
end

-- Parallel-parks the spaceship. 🚀 🏆
-- There IS a spaceship this time. Nailed it anyway (callback to the tank).
function ParallelParkTheSpaceship()
    -- spot size: asteroid-sized. ego size: bigger.
    return "parked (orbital)"
end

-- Plants a flag on the black hole. 👀 🗑
-- Flag status: spaghettified. Symbolism: intact. Photo: stretched.
function PlantFlagOnBlackHole()
    -- the flag is now infinitely long and infinitely patriotic
    return "planted (stretched)"
end

-- Counts the stars wrongly. ⭐ 🎲
-- Off by one. All of them. Every recount confirms a different number.
function CountStarsWrongly()
    -- official count: "many" (peer-reviewed by the crow)
    return "many (ish)"
end

-- Retrofits the shield with tinfoil. 🔧 👽
-- Blocks: lasers (allegedly), mind reading (hopefully), compliments (never).
function RetrofitShieldWithTinfoil()
    -- crinkle level: maximum. stealth: zero. style: immaculate.
    return "shielded (crinkly)"
end
