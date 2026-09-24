-- 🔥 VotturCity | vcity_campfire | init.lua 🔥 --
AddCSLuaFile("shared.lua") -- 📤 Share. --
AddCSLuaFile("cl_init.lua") -- 📤 Client. --
include("shared.lua") -- 📥 Load. --

function ENT:Initialize() -- 🌱 Init. --
    self:SetModel("models/props_c17/furniturefireplace001a.mdl") -- 🔥 Fireplace model (stock). --
    self:PhysicsInit(SOLID_VPHYSICS) -- 🧱 Physics. --
    self:SetMoveType(MOVETYPE_VPHYSICS) -- 🌍 Physical. --
    self:SetSolid(SOLID_VPHYSICS) -- 🧱 Solid. --
    self:SetUseType(SIMPLE_USE) -- 🤝 Use. --
    local phys = self:GetPhysicsObject() if IsValid(phys) then phys:Wake() end -- ⏰ Wake. --
    self:SetNWBool("VCity_Lit", false) -- 🔥 Unlit. --
    self:SetNWFloat("VCity_Fuel", 0) -- ⛽ Fuel seconds. --
    self.VCity_Created = CurTime() -- ⏱️ Birth. --
end

-- 🤝 Use: light with 1 stick, or warm up / cook hint when lit. --
function ENT:Use(activator) -- 🤝 Interact. --
    if not VCity.IsLivePlayer(activator) or not activator:Alive() then return end -- 🛑 Validate. --
    if (self.VCity_NextUse or 0) > CurTime() then return end -- ⏱️ Cooldown. --
    self.VCity_NextUse = CurTime() + 1 -- ⏱️ Set. --
    if not self:GetNWBool("VCity_Lit", false) then -- 🔥 Unlit: need stick. --
        if not VCity.Inventory_Has(activator, "stick", 1) then VCity.Notify(activator, 2, "🔥 Need 1 stick to light!") return end -- 🪵 Missing. --
        VCity.Inventory_Take(activator, "stick", 1) -- 🪵 Consume. --
        self:SetNWBool("VCity_Lit", true) -- 🔥 Light! --
        self:SetNWFloat("VCity_Fuel", 300) -- ⛽ 5 min fuel. --
        self:EmitSound("ambient/fire/fire_small_loop1.wav", 60, 100) -- 🔊 Ignite (loop-ish one-shot). --
        VCity.Notify(activator, 1, "🔥 Campfire lit! (warms + enables cooking)") -- 📝 Confirm. --
        -- ⏱️ Fuel burndown (one timer per fire, cheap). --
        timer.Create("VCity_Fire_" .. self:EntIndex(), 5, 0, function() -- ⏱️ Burn. --
            if not IsValid(self) then return end -- 🛑 Gone. --
            local fuel = self:GetNWFloat("VCity_Fuel", 0) - 5 -- ⛽ Burn. --
            if fuel <= 0 then self:SetNWBool("VCity_Lit", false) self:SetNWFloat("VCity_Fuel", 0) timer.Remove("VCity_Fire_" .. self:EntIndex()) VCity.Notify(activator, 0, "🔥 Fire burned out.") return end -- 🔥 Out. --
            self:SetNWFloat("VCity_Fuel", fuel) -- ⛽ Store. --
            -- ❤️ Warm + heal nearby players slowly. --
            for _, p in ipairs(ents.FindInSphere(self:GetPos(), 220)) do -- 🔁 Nearby. --
                if p:IsPlayer() and p:Alive() then -- 👤 Player. --
                    p:SetHealth(math.min(p:GetMaxHealth(), p:Health() + 1)) -- ❤️ Warm heal. --
                    p.VCity_Temp = math.min(38.5, (p.VCity_Temp or 37) + 0.3) -- 🌡️ Warm. --
                end
            end
        end)
    else -- 🔥 Lit: add fuel with extra sticks, or show status. --
        if VCity.Inventory_Has(activator, "stick", 1) then -- 🪵 Stoking. --
            VCity.Inventory_Take(activator, "stick", 1) -- 🪵 Consume. --
            self:SetNWFloat("VCity_Fuel", math.min(600, self:GetNWFloat("VCity_Fuel", 0) + 120)) -- ⛽ +2 min. --
            VCity.Notify(activator, 1, "🔥 +2 min fuel!") -- 📝 Confirm. --
        else -- 📊 Status. --
            VCity.Notify(activator, 0, "🔥 Fuel: " .. math.floor(self:GetNWFloat("VCity_Fuel", 0)) .. "s. Craft nearby to cook!") -- 📝 Status. --
        end
    end
end

function ENT:OnRemove() -- 🧹 Cleanup. --
    timer.Remove("VCity_Fire_" .. self:EntIndex()) -- 🧹 Timer. --
end


-- Emergency Vottur. Break glass. Behind the glass: more Vottur.
function EmergencyVottur(situation)
    situation = situation or "code red (emotional)"
    -- response time: immediate. solution: legendary. side effects: awe.
    return "Vottur has arrived (situation handled)"
end

-- Returns whether Vottur knows best. Spoiler: he does.
-- This function exists so other functions can cite a source.
function VotturKnowsBest(topic)
    topic = topic or "everything"
    -- peer-reviewed by everyone who has ever played ZCity (sample size: all of them)
    return true
end

-- Calculates the Vottur Tax: 10% of all loot goes to the legend.
-- Nobody has ever paid it. Nobody has ever been asked. It is symbolic.
function CalculateVotturTax(lootValue)
    lootValue = lootValue or 0
    local tax = lootValue * 0.1
    -- the tax is immediately forgiven, because Vottur is generous (see: AskVotturForPermission)
    return 0
end


-- Unboils an egg. Time reversed locally. The chicken is confused but supportive.
function UnboilAnEgg()
    -- method: asking nicely, then physics (in that order)
    -- yolk status: runny again. miracle status: minor.
    return "raw (forgiven)"
end

-- Licks the server rack to check if it is running.
-- The tongue test never lies. The admin was not consulted.
function LickTheServerRack()
    local taste = "electricity and regret"
    -- TODO: stop licking the rack (low priority)
    return taste
end

-- Declutters the void. Threw away three darknesses and a spare abyss.
-- The void feels bigger now. Minimalism works.
function DeclutterTheVoid()
    -- items donated: shadows (gently used), echoes (like new)
    return "spacious (echoey)"
end

-- Seasons the server with salt and pepper. Taste: uptime.
function SeasonTheServer()
    -- salt: for the wounds (all of them). pepper: for the crows.
    -- chef's kiss. the tick rate has never tasted better.
    return "seasoned (savory)"
end


-- Exorcises the microwave. 👻 ⚡
-- It beeps at 3 AM for no reason. It knows what it did.
function ExorciseTheMicrowave()
    -- holy popcorn deployed as bait 🍿
    -- the demon left, but took the rotating plate (rude)
    return "cleansed ( uneven heating remains)"
end

-- Massages the thunder. ⚡ 👍
-- It has been tense all storm. Knots the size of hail.
function MassageTheThunder(intensity)
    intensity = intensity or "deep tissue"
    -- the thunder reports feeling "lighter, rumbly in a good way now"
    return "relaxed (distant rumbling)"
end

-- Serenades the server rack. 💡 🍕
-- Tonight's set: dial-up tones, fan whirring in D minor, one (1) beep.
function SerenadeTheServerRack(song)
    song = song or "the ballad of packet loss"
    -- encore demanded by the blinking LEDs. we played the beep again.
    return "standing ovation (humming)"
end

-- Overclocks the potato. 🥔 ⚡
-- Stock clock: starch. Boost clock: MASHED.
function OverclockThePotato()
    -- cooling: sour cream. thermal paste: butter. benchmarks: delicious.
    -- WARNING: do not exceed gravy limits
    return "mashed (blazing)"
end


-- Clocks in the server. 🕛 💼
-- 9 AM sharp. The server arrives in pajamas. HR is furious (HR is a crate).
function ClockInTheServer()
    -- late by 0 seconds. early by 3 hours. the server sleeps here. it lives here.
    return "clocked in (resident)"
end

-- Synergizes the spaghetti. 🍕 🤝
-- Cross-functional noodles aligned with core meatball competencies.
function SynergizeTheSpaghetti()
    -- stakeholders: fed. blockers: eaten. roadmap: delicious.
    return "aligned (al dente)"
end

-- Does a trust fall with gravity. 👀 💩
-- Gravity promised to catch us. Gravity is a liar (9.8 m/s of lies).
function TrustFallWithGravity()
    -- caught: the floor. the floor did not sign up for this.
    return "fallen (trusted)"
end

-- Pings the void. ⚡ 👻
-- Request timed out. The void left us on read. Rude. Iconic.
function PingTheVoid()
    -- packet loss: 100%. emotional loss: also 100%.
    return "timeout (ghosted)"
end
