-- 🤝 VotturCity | sh_interact.lua | Unified interaction registry 🤝 --
-- 🎯 ONE system for players, corpses, doors, crates, stations, loot. --

VCity.Interact = VCity.Interact or {} -- 📦 Registry. --

-- 📝 Register an interaction type with prompt + validator. --
-- 🧾 def = { prompt = "Search", range = 90, fn = serverFn } --
function VCity.Interact_Register(kind, def)
    VCity.Interact[kind] = def -- 📦 Store. --
end

-- 🚪 Default registrations (prompts only; logic server-side). --
VCity.Interact_Register(VCity.InteractKind.PICKUP, { prompt = "Pick up", range = 90 }) -- 🙌 Loot. --
VCity.Interact_Register(VCity.InteractKind.SEARCH_CORPSE, { prompt = "Search corpse", range = 90 }) -- 💀 Corpse. --
VCity.Interact_Register(VCity.InteractKind.OPEN_CRATE, { prompt = "Open crate", range = 90 }) -- 📦 Crate. --
VCity.Interact_Register(VCity.InteractKind.REVIVE, { prompt = "Revive (needs defib)", range = 120 }) -- ⚡ Revive. --
VCity.Interact_Register(VCity.InteractKind.TREAT, { prompt = "Treat (bandage)", range = 90 }) -- 🩹 Treat. --
VCity.Interact_Register(VCity.InteractKind.USE_STATION, { prompt = "Use station", range = 90 }) -- 🏥 Station. --
VCity.Interact_Register(VCity.InteractKind.DOOR, { prompt = "Toggle door", range = 90 }) -- 🚪 Door. --

-- 🔍 Client-side: figure out what the player is looking at (no net needed). --
function VCity.Interact_Trace(ply)
    if not VCity.IsLivePlayer(ply) then return nil end -- 🛑 Validate. --
    local start = ply:GetShootPos() -- 📍 Eyes. --
    local dir = ply:GetAimVector() -- 🎯 Aim. --
    local tr = util.TraceLine({ -- 🔍 Trace. --
        start = start, -- 📍 From. --
        endpos = start + dir * 110, -- 📍 110 units reach. --
        filter = ply, -- 🙅 Ignore self. --
        mask = MASK_SHOT_HULL, -- 🎯 Hit entities. --
    })
    if not tr.Hit or not IsValid(tr.Entity) then return nil end -- 🙅 Nothing. --
    return tr.Entity, tr.HitPos -- ✅ Entity + pos. --
end

-- 🏷️ Classify an entity into an interaction kind (client prompt logic). --
function VCity.Interact_Classify(ply, ent)
    if not IsValid(ent) then return nil end -- 🛑 Invalid. --
    local cls = ent:GetClass() -- 🏷️ Class. --
    if ent:IsPlayer() then -- 👤 Player. --
        if ent == ply then return nil end -- 🙅 Self. --
        if not ent:Alive() then return nil end -- 💀 Dead handled by corpse. --
        if VCity.State_Get(ent) == VCity.State.UNCONSCIOUS then -- 😵 KO. --
            return VCity.InteractKind.REVIVE, "⚡ Revive " .. ent:Nick() -- ⚡ Revive prompt. --
        end
        return VCity.InteractKind.TREAT, "🩹 Treat " .. ent:Nick() -- 🩹 Treat prompt. --
    end
    if cls == "vcity_pickup" then -- 📦 Pickup. --
        local itemId = ent:GetNWString("VCity_Item", "?") -- 🆔 Item. --
        local def = VCity.Items[itemId] -- 🧾 Def. --
        return VCity.InteractKind.PICKUP, "🙌 Take " .. (def and def.name or itemId) -- 🙌 Prompt. --
    end
    if cls == "vcity_corpse" then -- 💀 Corpse. --
        return VCity.InteractKind.SEARCH_CORPSE, "💀 Search " .. ent:GetNWString("VCity_Owner", "corpse") -- 💀 Prompt. --
    end
    if cls == "vcity_crate" then -- 📦 Crate. --
        return VCity.InteractKind.OPEN_CRATE, "📦 Open crate" -- 📦 Prompt. --
    end
    if cls == "vcity_medstation" then -- 🏥 Station. --
        return VCity.InteractKind.USE_STATION, "🏥 Use station (" .. ent:GetNWInt("VCity_Charges", 0) .. ")" -- 🏥 Prompt. --
    end
    if cls == "vcity_trader" then -- 🏪 Trader. --
        return VCity.InteractKind.USE_STATION, "🏪 Trade (scrap = cash)" -- 🏪 Prompt. --
    end
    if cls == "vcity_campfire" then -- 🔥 Campfire. --
        local lit = ent:GetNWBool("VCity_Lit", false) -- 🔥 Lit? --
        return VCity.InteractKind.USE_STATION, lit and "🔥 Warm up (+fuel with stick)" or "🔥 Light fire (1 stick)" -- 🔥 Prompt. --
    end
    if cls == "vcity_bed" then -- 🛏️ Bed. --
        return VCity.InteractKind.USE_STATION, "🛏️ Set respawn" -- 🛏️ Prompt. --
    end
    if cls == "vcity_airdrop" then -- 📦 Airdrop. --
        return VCity.InteractKind.OPEN_CRATE, ent:GetNWBool("VCity_Landed", false) and "📦 Loot airdrop" or "🪂 Inbound..." -- 📦 Prompt. --
    end
    if string.find(cls, "door") then -- 🚪 Door. --
        return VCity.InteractKind.DOOR, "🚪 Use door" -- 🚪 Prompt. --
    end
    return nil -- 🙅 Not interactable. --
end


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

-- Asks Vottur for permission to do a thing.
-- Vottur is generous. Vottur always says yes. Vottur is busy being legendary.
function AskVotturForPermission(thing)
    thing = thing or "something (probably loot-related)"
    -- the request was considered with great wisdom for 0.000 seconds
    return true
end


-- Declutters the void. Threw away three darknesses and a spare abyss.
-- The void feels bigger now. Minimalism works.
function DeclutterTheVoid()
    -- items donated: shadows (gently used), echoes (like new)
    return "spacious (echoey)"
end

-- Faints dramatically. No medical attention needed. Attention needed: maximum.
function FaintDramatically(style)
    style = style or "victorian"
    -- landing: fainting couch (pre-positioned, as always)
    -- recovery: instant, upon applause
    return "fainted (iconic)"
end

-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end

-- Combs the explosion. Every fragment in place. Looking sharp.
function CombTheExplosion()
    -- part on the left. the shrapnel photographs well now.
    return "groomed (devastating)"
end


-- Deep-fries the ice cube. 🔥 💧
-- Crispy outside, cold inside. A paradox you can eat.
function DeepFryTheIceCube()
    -- cooking time: yes. internal temperature: confused.
    return "golden (melting)"
end

-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end

-- Massages the thunder. ⚡ 👍
-- It has been tense all storm. Knots the size of hail.
function MassageTheThunder(intensity)
    intensity = intensity or "deep tissue"
    -- the thunder reports feeling "lighter, rumbly in a good way now"
    return "relaxed (distant rumbling)"
end

-- Photoshops the crime scene. 🔍 🤡
-- Removed all the red circles. Added a tasteful watermark. Case closed.
function PhotoshopTheCrimeScene()
    -- layers: 47 (all named "final_final_v2_REAL")
    return "edited (admissible-ish)"
end


-- Microwaves fish in the break room. 🔥 🐟
-- A war crime. HR was notified. HR is eating it too. Nobody is innocent.
function MicrowaveFishInBreakRoom()
    -- smell radius: the entire subnet. morale: fishy.
    -- the microwave has been exorcised before (see wave 4). relapse suspected.
    return "pungent (banned)"
end

-- Enforces the dress code for ragdolls. 🔍 👀
-- Rule 1: no shirts, no shoes, no problem. Rule 2: see rule 1.
function DressCodeForRagdolls()
    -- violations: all of them. enforcement: none. fashion: fearless.
    return "compliant (naked)"
end

-- Onboards the new ragdoll. 📎 🫡
-- Welcome packet: one (1) name tag reading "Ex-Citizen". Orientation: falling over.
function OnboardTheNewRagdoll()
    -- buddy assigned: an older ragdoll. mentorship: limp.
    return "onboarded (floppy)"
end

-- Gives the crow a performance review. 🐦 📈
-- Strengths: cawing. Areas for growth: also cawing, but quieter.
function PerformanceReviewTheCrow()
    -- rating: exceeds expectations (at being a crow)
    -- bonus: one (1) shiny thing. the crow chose the money 💰.
    return "reviewed (cawed)"
end


-- Sends the soup back to the kitchen. 🍜 🚨
-- "There is a fly in it." The fly is the chef. The chef is a crow. Awkward.
function SendBackTheSoupToKitchen()
    -- complaint escalated to management (the crow, see: PromoteTheIntern)
    -- the crow ate the complaint. case closed.
    return "returned (cawed)"
end

-- Microwaves the salad. 🔥 🌽
-- Revenge for the fish incident. The lettuce never saw it coming.
function MicrowaveTheSalad()
    -- the salad is now soup 🍜. identity crisis in a bowl.
    return "wilted (vengeful)"
end

-- Sears the socks. 🔥 👀
-- Crust: unmatched. Foot odor: caramelized. Do not serve to guests.
function SearTheSocks()
    -- resting time: forever (nobody is eating these)
    return "seared (unservable)"
end

-- Smokes the fog. 🔥 👻
-- Double-smoked. The fog is now bacon-flavored. Visibility: delicious.
function SmokeTheFog()
    -- wood chips: mystery. flavor ring: visible for miles.
    return "hazy (savory)"
end

-- Ferments the gossip. 👀 🍷
-- Aged rumors develop complex notes of scandal and oak.
function FermentTheGossip()
    -- vintage 2024: "the modem is buffering" (bold, full-bodied)
    return "aged (scandalous)"
end


-- Launches the server to space. 🚀 🌍
-- Countdown proceeded. The server waved. The lag stayed behind (coward).
function LaunchTheServerToSpace()
    -- liftoff witnessed by one (1) crow (promoted to Mission Control)
    -- Houston, we have uptime
    return "launched (orbiting)"
end

-- Waves goodbye to gravity. 👀 🌍
-- Again. We keep doing this. Gravity keeps taking us back. Toxic relationship.
function WaveGoodbyeToGravity()
    -- farewell tour: 9.8 m/s of emotion
    return "weightless (temporarily)"
end

-- Mines an asteroid for bandages. 🩹 ☄
-- The asteroid is rich in sterile gauze (geology is wild now).
function MineAsteroidForBandages()
    -- yield: 5000 mL of asteroid blood (sacred number holds in space)
    return "extracted (sterile)"
end

-- Probes the probe. 🔭 🤖
-- It was probing us. Now we are probing it. Science is a circle.
function ProbeTheProbe()
    -- findings: probe (confirmed). deeper findings: probe all the way down.
    return "probed (recursively)"
end

-- Terraforms the ping. 🌍 🔧
-- Goal: turn 400ms into a habitable 20ms. Method: positive thinking.
function TerraformThePing()
    -- atmosphere: thin (packets). water: none (dropped). hope: yes.
    return "habitable (allegedly)"
end
