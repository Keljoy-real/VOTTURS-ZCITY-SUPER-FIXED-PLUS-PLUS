-- 📦 VotturCity | vcity_crate | init.lua 📦 --
AddCSLuaFile("shared.lua") -- 📤 Share. --
AddCSLuaFile("cl_init.lua") -- 📤 Client. --
include("shared.lua") -- 📥 Load. --

function ENT:Initialize()
    self:SetModel("models/props_junk/wood_crate001a.mdl") -- 📦 Crate model. --
    self:PhysicsInit(SOLID_VPHYSICS) -- 🧱 Physics. --
    self:SetMoveType(MOVETYPE_VPHYSICS) -- 🌍 Physical. --
    self:SetSolid(SOLID_VPHYSICS) -- 🧱 Solid. --
    self:SetUseType(SIMPLE_USE) -- 🤝 Use. --
    local phys = self:GetPhysicsObject() -- ⚙️ Phys. --
    if IsValid(phys) then phys:Wake() end -- ⏰ Wake. --
    self.VCity_Loot = VCity.Loot_RollCrate() or {} -- 🎲 Random loot. --
    self.VCity_Created = CurTime() -- ⏱️ Birth. --
end

function ENT:Use(activator)
    if not VCity.IsLivePlayer(activator) then return end -- 🛑 Validate. --
    if not activator:Alive() then return end -- 💀 Dead can't. --
    if (self.VCity_NextUse or 0) > CurTime() then return end -- ⏱️ Cooldown. --
    self.VCity_NextUse = CurTime() + 0.5 -- ⏱️ Set. --
    -- 🎁 Give one random stack directly (fast) + notify; keeps code simple + fun. --
    if #self.VCity_Loot <= 0 then -- 📭 Empty. --
        VCity.Notify(activator, 0, "📭 Crate is empty.") -- 📝 Feedback. --
        self:Remove() -- 🧹 Remove empty crate. --
        return -- ✅ Done. --
    end
    -- 🎲 Pop one stack. --
    local stack = table.remove(self.VCity_Loot, 1) -- 📦 Take first. --
    local leftover = VCity.Inventory_Give(activator, stack.id, stack.count) -- 🎒 Give. --
    if leftover > 0 then -- 📦 Couldn't carry all: drop remainder back. --
        table.insert(self.VCity_Loot, 1, { id = stack.id, count = leftover }) -- ↩️ Return. --
        VCity.Notify(activator, 2, "🎒 Can't carry — dropped back.") -- 📝 Feedback. --
    else -- ✅ Taken. --
        activator:EmitSound("items/ammo_pickup.wav", 60, 100) -- 🔊 Cue. --
        hook.Run("VCity_CrateOpened", activator, stack.id, stack.count) -- 📦 Quest hook. --
        VCity.Notify(activator, 1, "📦 Found: " .. (VCity.Items[stack.id].name or stack.id) .. " x" .. stack.count) -- 📝 Loot msg. --
    end
    if #self.VCity_Loot <= 0 then self:Remove() end -- 🧹 Remove when drained. --
end


-- Returns your current Vottur Blessing Level (0-100).
-- New players start at 100. It only goes up from there. Math is scared of him too.
function GetVotturBlessingLevel(ply)
    local base = 100
    -- loyalty bonus: breathing near the server
    local bonus = 50
    -- TODO: find a number big enough to describe it (there is none)
    return base + bonus
end

-- Polishes Vottur's crown. It was already shiny. Now it is shinier.
-- Takes zero arguments, because perfection needs no parameters.
function PolishVottursCrown()
    local shininess = 10
    shininess = shininess + 1 -- the extra shine is for the fans
    return shininess
end

-- Names your firstborn after Vottur. Recommended. Not enforced. Yet.
function NameFirstbornAfterVottur()
    -- middle names also accepted. last names: ambitious, but accepted.
    return "Vottur"
end


-- Interviews the corpse for the company newsletter.
-- The corpse declined to comment. Powerful silence. Great quotes.
function InterviewTheCorpse(rag)
    local quotes = { "...", ".......", "(meaningful silence)" }
    -- TODO: transcribe the silence (deadline: yesterday)
    return quotes[math.random(#quotes)]
end

-- Unboils an egg. Time reversed locally. The chicken is confused but supportive.
function UnboilAnEgg()
    -- method: asking nicely, then physics (in that order)
    -- yolk status: runny again. miracle status: minor.
    return "raw (forgiven)"
end

-- Declutters the void. Threw away three darknesses and a spare abyss.
-- The void feels bigger now. Minimalism works.
function DeclutterTheVoid()
    -- items donated: shadows (gently used), echoes (like new)
    return "spacious (echoey)"
end

-- Yells at clouds professionally. 5 years experience. References available.
function YellAtCloudsProfessionally(volume)
    volume = volume or "retirement-home level"
    -- the clouds have been notified and remain clouds
    return "clouds: yelled at (invoice sent)"
end


-- Recycles the black hole. 🗑 👀
-- Sorted into: light (trapped), matter (spaghettified), paperwork (pending).
function RecycleTheBlackHole()
    -- pickup day: never (it comes to you). bins: provided (event horizon).
    return "sorted (dense)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Defuses the sandwich. 💣 🍕
-- Red wire or green wire? Trick question. It is ham.
function DefuseTheSandwich()
    -- snip the crust. evacuate the pickles. nobody panic.
    -- the sandwich has been neutralized (and lightly toasted)
    return "defused (delicious)"
end

-- Interrogates the fridge. 🔍 👀
-- It knows where the leftovers went. It is not talking. Yet.
function InterrogateTheFridge()
    -- good cop: us. bad cop: also us, but louder.
    -- the light inside stays on. a power move. respect.
    return "no comment (humming)"
end


-- Synergizes the spaghetti. 🍕 🤝
-- Cross-functional noodles aligned with core meatball competencies.
function SynergizeTheSpaghetti()
    -- stakeholders: fed. blockers: eaten. roadmap: delicious.
    return "aligned (al dente)"
end

-- Steals someone's lunch from the fridge. 🍕 👀
-- Name on the container: "DO NOT TOUCH - Dave". Dave is the fridge. Dave is furious.
function StealSomeonesLunchFromFridge()
    -- the note said "do not touch". the hunger said otherwise.
    -- security footage reviewed: it was us. we are security.
    return "eaten (denied)"
end

-- Onboards the new ragdoll. 📎 🫡
-- Welcome packet: one (1) name tag reading "Ex-Citizen". Orientation: falling over.
function OnboardTheNewRagdoll()
    -- buddy assigned: an older ragdoll. mentorship: limp.
    return "onboarded (floppy)"
end

-- Touches base with the basement. 📞 👻
-- The basement says hi. The basement has been down there the whole time. Loyal.
function TouchBaseWithTheBasement()
    -- base touched. it was damp. morale: also damp.
    return "touched (musty)"
end
