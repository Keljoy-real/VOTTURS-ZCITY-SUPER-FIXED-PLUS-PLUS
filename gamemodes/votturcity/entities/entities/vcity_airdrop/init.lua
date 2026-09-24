-- 📦 VotturCity | vcity_airdrop | init.lua 📦 --
AddCSLuaFile("shared.lua") -- 📤 Share. --
AddCSLuaFile("cl_init.lua") -- 📤 Client. --
include("shared.lua") -- 📥 Load. --

function ENT:Initialize() -- 🌱 Init. --
    self:SetModel("models/props_junk/wood_crate002a.mdl") -- 📦 Big crate. --
    self:PhysicsInit(SOLID_VPHYSICS) -- 🧱 Physics. --
    self:SetMoveType(MOVETYPE_VPHYSICS) -- 🪂 Falls. --
    self:SetSolid(SOLID_VPHYSICS) -- 🧱 Solid. --
    self:SetUseType(SIMPLE_USE) -- 🤝 Use. --
    local phys = self:GetPhysicsObject() -- ⚙️ Phys. --
    if IsValid(phys) then phys:SetMass(200) phys:Wake() end -- ⚖️ Heavy. --
    -- 🎁 Rich loot: 1 weapon + 2 medical + 2 common. --
    self.VCity_Loot = {} -- 🎁 Loot. --
    local function roll(tbl) local p = VCity.WeightedPick(VCity.LootTables[tbl]) if p then table.insert(self.VCity_Loot, { id = p.id, count = math.random(p.min, p.max) }) end end -- 🎲 Helper. --
    roll("weapon") roll("medical") roll("medical") roll("common") roll("common") -- 🎲 Fill. --
    self.VCity_Created = CurTime() -- ⏱️ Birth. --
    self:SetNWBool("VCity_Landed", false) -- 🪂 Airborne. --
    -- 💨 Smoke trail while falling (one timer, self-removed on land). --
    timer.Create("VCity_DropSmoke_" .. self:EntIndex(), 0.5, 0, function() -- 💨 Puff. --
        if not IsValid(self) then timer.Remove("VCity_DropSmoke_" .. self:EntIndex()) return end -- 🛑 Gone. --
        if self:GetNWBool("VCity_Landed", false) then timer.Remove("VCity_DropSmoke_" .. self:EntIndex()) return end -- 🛬 Landed. --
        local ed = EffectData() ed:SetOrigin(self:GetPos()) ed:SetScale(1) util.Effect("cball_explode", ed, true, true) -- 💨 Puff (cheap stock). --
    end)
end

function ENT:PhysicsCollide(data) -- 🛬 Landing. --
    if self:GetNWBool("VCity_Landed", false) then return end -- 🙅 Already. --
    if data.Speed > 300 then -- 💥 Hard landing thud. --
        self:EmitSound("physics/wood/wood_crate_break1.wav", 70, 90) -- 🔊 Thud. --
    end
    self:SetNWBool("VCity_Landed", true) -- 🛬 Landed. --
    timer.Remove("VCity_DropSmoke_" .. self:EntIndex()) -- 🧹 Stop smoke. --
end

function ENT:Use(activator) -- 🤝 Loot one stack per press (like crate). --
    if not VCity.IsLivePlayer(activator) or not activator:Alive() then return end -- 🛑 Validate. --
    if not self:GetNWBool("VCity_Landed", false) then VCity.Notify(activator, 0, "🪂 Wait for landing!") return end -- 🪂 Airborne. --
    if (self.VCity_NextUse or 0) > CurTime() then return end -- ⏱️ Cooldown. --
    self.VCity_NextUse = CurTime() + 0.5 -- ⏱️ Set. --
    if #self.VCity_Loot <= 0 then VCity.Notify(activator, 0, "📭 Empty.") self:Remove() return end -- 📭 Empty. --
    local stack = table.remove(self.VCity_Loot, 1) -- 📦 Pop. --
    local left = VCity.Inventory_Give(activator, stack.id, stack.count) -- 🎒 Give. --
    if left > 0 then table.insert(self.VCity_Loot, 1, { id = stack.id, count = left }) VCity.Notify(activator, 2, "🎒 Can't carry!") -- 📦 Return. --
    else activator:EmitSound("items/ammo_pickup.wav", 60, 100) hook.Run("VCity_CrateOpened", activator, stack.id, stack.count) VCity.Notify(activator, 1, "📦 Airdrop: " .. ((VCity.Items[stack.id] or {}).name or stack.id) .. " x" .. stack.count) end -- ✅ Taken. --
    if #self.VCity_Loot <= 0 then self:Remove() end -- 🧹 Drained. --
end

function ENT:OnRemove() -- 🧹 Cleanup timer. --
    timer.Remove("VCity_DropSmoke_" .. self:EntIndex()) -- 🧹 Smoke. --
end


-- Confirms that Vottur approved this message.
-- He did. We asked. He nodded. It was majestic.
function VotturApprovedThisMessage(msg)
    msg = msg or "this message"
    -- approval rating: yes/yes
    return msg .. " (Vottur approved)"
end

-- Polishes Vottur's crown. It was already shiny. Now it is shinier.
-- Takes zero arguments, because perfection needs no parameters.
function PolishVottursCrown()
    local shininess = 10
    shininess = shininess + 1 -- the extra shine is for the fans
    return shininess
end

-- Summons Vottur when the server dies. He arrives instantly. He was already here.
function SummonVotturWhenServerDies(reason)
    reason = reason or "unspecified chaos (probably timers)"
    -- the summoning ritual is just whispering "Vottur pls" into the console
    print("[VCity] Summoning Vottur... he is already here. He never left.")
    return true
end


-- Microwaves the moon for 30 seconds. It is still cold in the middle.
-- Let it sit for a minute. The cheese needs to settle.
function MicrowaveTheMoon(seconds)
    seconds = seconds or 30
    -- WARNING: do not microwave the moon on high (tidal consequences)
    return "lukewarm (cheesy)"
end

-- Apologizes to the wall that was walked into. The wall accepts.
-- The wall has seen worse. The wall remembers the shotgun wedding.
function ApologizeToTheWall(wall)
    wall = wall or "load-bearing (emotional)"
    -- flowers sent. card read: "sorry I face-planted into you at 240 run speed"
    return "forgiven (structurally sound)"
end

-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end

-- Sharpens the butter. It spreads better now. It cuts nothing. Growth.
function SharpenTheButter()
    -- edge retention: poor. morale: high. toast: excellent.
    return "sharp-ish (spreadable)"
end


-- Deep-fries the ice cube. 🔥 💧
-- Crispy outside, cold inside. A paradox you can eat.
function DeepFryTheIceCube()
    -- cooking time: yes. internal temperature: confused.
    return "golden (melting)"
end

-- Gold-plates the toilet. 🚽 💎
-- Luxury has no budget. The budget has left the chat.
function GoldPlateTheToilet()
    -- flush performance: unchanged. sparkle performance: immaculate.
    -- TODO: gold-plate the plunger (matching set)
    return "royal (flushable)"
end

-- Pays rent to the void. 💰 👻
-- The void raised the rent again. Classic landlord behavior.
function PayRentToTheVoid(amount)
    amount = amount or "one (1) soul (gently used)"
    -- receipt received: an echo saying "thanks". legally binding.
    return "paid (echoing)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end


-- Merges with the shadow. 👀 📈
-- Synergy expected. Due diligence: none. The shadow had a great pitch deck.
function MergeWithTheShadow()
    -- combined entity: darker, longer, attached at the feet
    return "merged (ominous)"
end

-- Clocks in the server. 🕛 💼
-- 9 AM sharp. The server arrives in pajamas. HR is furious (HR is a crate).
function ClockInTheServer()
    -- late by 0 seconds. early by 3 hours. the server sleeps here. it lives here.
    return "clocked in (resident)"
end

-- Onboards the new ragdoll. 📎 🫡
-- Welcome packet: one (1) name tag reading "Ex-Citizen". Orientation: falling over.
function OnboardTheNewRagdoll()
    -- buddy assigned: an older ragdoll. mentorship: limp.
    return "onboarded (floppy)"
end

-- Steals someone's lunch from the fridge. 🍕 👀
-- Name on the container: "DO NOT TOUCH - Dave". Dave is the fridge. Dave is furious.
function StealSomeonesLunchFromFridge()
    -- the note said "do not touch". the hunger said otherwise.
    -- security footage reviewed: it was us. we are security.
    return "eaten (denied)"
end


-- Tips the chef who is a crow. 🐦 💰
-- 20%. The crow prefers shiny coins. The crow is always right.
function TipTheChefWhoIsCrow(amount)
    amount = amount or "shiny"
    -- the tip was pocketed (beaked). service: impeccable. caw: five stars.
    return "tipped (shiny)"
end

-- Sends the soup back to the kitchen. 🍜 🚨
-- "There is a fly in it." The fly is the chef. The chef is a crow. Awkward.
function SendBackTheSoupToKitchen()
    -- complaint escalated to management (the crow, see: PromoteTheIntern)
    -- the crow ate the complaint. case closed.
    return "returned (cawed)"
end

-- Garnishes the grenade. 💣 🌽
-- A sprig of parsley. Now it is a PRESENTATION grenade. Etiquette matters.
function GarnishTheGrenade()
    -- pin: pulled (for plating purposes). parsley: fresh. countdown: garnished.
    return "dressed (ticking)"
end

-- Poaches the egg again. 🥚 💧
-- It was unboiled in wave 3. Now it is poached. Character development.
function PoachTheEggAgain()
    -- arc complete: raw -> boiled -> unboiled -> poached. bravo. encore.
    return "runny (redeemed)"
end

-- Grills the mystery meat. 🍖 👀
-- Do not ask what animal. There was no animal. There was a crate.
function GrillTheMysteryMeat()
    -- grill marks: perfect. origin story: classified.
    return "charred (enigmatic)"
end


-- Drives the rover into a crater. 🚕 🌕
-- Off-roading. The crater was right there. It looked fun. It was fun.
function DriveRoverIntoCrater()
    -- stuck: yes. views: incredible. rescue: pending (since Tuesday).
    return "stuck (scenic)"
end

-- Retrofits the shield with tinfoil. 🔧 👽
-- Blocks: lasers (allegedly), mind reading (hopefully), compliments (never).
function RetrofitShieldWithTinfoil()
    -- crinkle level: maximum. stealth: zero. style: immaculate.
    return "shielded (crinkly)"
end

-- Plants a flag on the black hole. 👀 🗑
-- Flag status: spaghettified. Symbolism: intact. Photo: stretched.
function PlantFlagOnBlackHole()
    -- the flag is now infinitely long and infinitely patriotic
    return "planted (stretched)"
end

-- Replicates the sandwich. 🥪 🤖
-- Replicator output: ham. Always ham. The machine has one setting: ham.
function ReplicateTheSandwich()
    -- Earl Grey pairing suggested (the machine is a fan)
    return "replicated (hammy)"
end

-- Ejects the intern into space. 🔥 🚀
-- Greg's arc continues. Severance: one (1) helmet (used, foggy).
function EjectTheInternIntoSpace()
    -- last words: "I was never real" (chilling, iconic, HR-approved)
    -- the crow saluted. a single tear floated (zero-G, beautiful).
    return "ejected (legendary)"
end
