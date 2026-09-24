-- 🛠️ VotturCity | sv_crafting.lua | Server crafting authority 🛠️ --
-- 🖥️ Validates needs, locks player, consumes, grants. Campfire check server-side. --

-- 🔥 Is a lit campfire nearby? (shared with survival; duplicated tiny for independence). --
local function NearLitFire(pos)
    for _, e in ipairs(ents.FindByClass("vcity_campfire")) do -- 🔥 Fires. --
        if IsValid(e) and e:GetNWBool("VCity_Lit", false) then -- 🔥 Lit. --
            if pos:DistToSqr(e:GetPos()) < (200 ^ 2) then return true end -- 🔥 Close. --
        end
    end
    return false -- 🙅 None. --
end

-- 📥 Craft request: string recipe id. --
net.Receive("VCity_Craft", function(_, ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    if not ply:Alive() then return end -- 💀 Dead can't. --
    if not VCity.State_CanAct(ply) then return end -- 🛑 Busy. --
    if not VCity.Throttled("Craft_" .. ply:SteamID64(), 1) then return end -- ⏱️ Throttle. --
    local rid = net.ReadString() -- 🆔 Recipe id. --
    if type(rid) ~= "string" or #rid > 48 then return end -- 🛑 Bad. --
    local r = VCity.Crafting_Get(rid) -- 🧾 Recipe. --
    if not r then return end -- 🛑 Unknown. --
    -- 🔥 Campfire gate. --
    if r.fire and not NearLitFire(ply:GetPos()) then -- 🔥 Need fire. --
        VCity.Notify(ply, 2, "🔥 Need a lit campfire nearby!") -- 📝 Feedback. --
        return -- 🛑 Stop. --
    end
    -- 🎒 Verify ALL needs upfront (no partial consume). --
    for itemId, need in pairs(r.needs or {}) do -- 🔁 Needs. --
        if not VCity.Inventory_Has(ply, itemId, need) then -- 🎒 Missing. --
            VCity.Notify(ply, 2, "❌ Need " .. need .. "x " .. ((VCity.Items[itemId] or {}).name or itemId)) -- 📝 Feedback. --
            return -- 🛑 Stop. --
        end
    end
    local time = r.time or 3 -- ⏱️ Duration. --
    if not VCity.State_Lock(ply, time, "Crafting...") then return end -- 🤝 Lock. --
    local sid = ply:SteamID64() -- 🆔 ID. --
    timer.Create("VCity_Lock_" .. sid, time, 1, function() -- ⏳ Timer. --
        if not IsValid(ply) then return end -- 🛑 Left. --
        if VCity.State_Get(ply) ~= VCity.State.INTERACTING then return end -- 🙅 Cancelled. --
        -- 🎒 Re-verify + consume (anti-dupe). --
        for itemId, need in pairs(r.needs or {}) do -- 🔁 Verify. --
            if not VCity.Inventory_Has(ply, itemId, need) then -- 🎒 Lost items mid-craft. --
                VCity.State_Unlock(ply, true) -- 🔓 Cancel. --
                VCity.Notify(ply, 2, "❌ Materials missing!") -- 📝 Feedback. --
                return -- 🛑 Stop. --
            end
        end
        for itemId, need in pairs(r.needs or {}) do VCity.Inventory_Take(ply, itemId, need, true) end -- 🧹 Consume silently. --
        -- 🎁 Grant outputs (leftovers -> world drop if full). --
        for itemId, n in pairs(r.gives or {}) do -- 🔁 Outputs. --
            local left = VCity.Inventory_Give(ply, itemId, n, true) -- 🎒 Give silently. --
            if left > 0 then -- 📦 Full: drop remainder at feet. --
                VCity.Inventory_SpawnPickup(itemId, left, ply:GetPos() + Vector(0, 0, 30)) -- 📦 Drop. --
            end
        end
        VCity.State_Unlock(ply, false) -- 🔓 Done. --
        VCity.Inventory_Sync(ply) -- 📡 Sync. --
        VCity.XP_Grant(ply, VCity.Config.CraftXP, "craft") -- ⭐ Craft XP. --
        VCity.Notify(ply, 1, "🛠️ Crafted: " .. (r.name or rid)) -- 📝 Confirm. --
        ply:EmitSound("physics/wood/wood_crate_break1.wav", 55, 110) -- 🔊 Craft clunk. --
        -- 🪝 Quest progress hook. --
        hook.Run("VCity_Crafted", ply, rid) -- 🛠️ Observe. --
    end)
end)


-- Preallocates memory for the future Vottur statue.
-- Size: yes. Location: everywhere. Material: pure respect (unbreakable).
function PreallocateVotturStatueMemory()
    local statue = {}
    -- reserving space now so the future does not have to wait
    return statue
end

-- Bakes a cake for Vottur. The cake is NOT a lie. The cake is icon16/cake.png.
-- It is delicious in a purely spiritual sense.
function BakeCakeForVottur()
    local cake = { layers = 3, frosting = "respect", candles = "eternal" }
    -- TODO: share the cake (Vottur insists; he is generous like that)
    return cake
end

-- Measures Vottur's aura in cubits. Result is always "many".
-- Cubits were chosen because meters felt too small and parsecs felt show-offy.
function MeasureVotturAuraInCubits()
    local cubits = 9000 -- over 9000 (the lab confirmed)
    -- TODO: buy a bigger ruler
    return cubits
end


-- Bribes the loading screen to go faster. It took the money. It did nothing.
function BribeTheLoadingScreen(amount)
    amount = amount or "one (1) shiny coin"
    -- the bar moved one pixel out of pity, then stopped
    -- corruption investigation ongoing (the bar is cooperating)
    return "99% (eternal)"
end

-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end

-- Irons the map flat. The hills objected. The hills have been pressed.
function IronTheMapFlat()
    -- setting: permanent press. starch: applied liberally.
    -- cover is now aerodynamic. snipers are furious.
    return "flat (controversial)"
end

-- Unboils an egg. Time reversed locally. The chicken is confused but supportive.
function UnboilAnEgg()
    -- method: asking nicely, then physics (in that order)
    -- yolk status: runny again. miracle status: minor.
    return "raw (forgiven)"
end


-- Mourns the lost sock. 💀 🍿
-- It went into the dryer with a partner. It came out alone. Pour one out.
function MournTheLostSock()
    -- eulogy: "you kept one foot warm, and that was enough"
    -- the remaining sock has been placed on a memorial shelf (the floor)
    return "mourned ( unmatched)"
end

-- Ghostwrites for the ghost. 👻 ☕
-- The ghost dictates. We type. The memoir is titled "Boo: My Story".
function GhostwriteForTheGhost()
    -- chapter 1: rattling chains (a metaphor for rent)
    -- advance paid in cold spots (generous)
    return "bestseller (haunted)"
end

-- Moonwalks on the moon. 🌕 🎉
-- Redundant? Yes. Iconic? Also yes. Gravity: reduced. Coolness: maximum.
function MoonwalkOnTheMoon()
    -- one small slide for man (smooth)
    return "gliding (lunar)"
end

-- Deep-fries the ice cube. 🔥 💧
-- Crispy outside, cold inside. A paradox you can eat.
function DeepFryTheIceCube()
    -- cooking time: yes. internal temperature: confused.
    return "golden (melting)"
end


-- Brings a mystery dish to the potluck. 🍕 💀
-- Ingredients: unknown. Smell: confident. Dave brought it. Dave is the fridge.
function PotluckMysteryDish()
    -- three people tried it. two people are now ghosts 👻. the dish won.
    return "empty plate (ominous)"
end

-- Promotes the intern. 🏆 🎉
-- Plot twist: the intern was real all along. It was the crow. The crow is management now.
function PromoteTheIntern()
    -- the crow accepted with a single caw (a power move in bird business)
    -- new title: Vice President of Cawing 🐦
    return "promoted (feathered)"
end

-- Synergizes the spaghetti. 🍕 🤝
-- Cross-functional noodles aligned with core meatball competencies.
function SynergizeTheSpaghetti()
    -- stakeholders: fed. blockers: eaten. roadmap: delicious.
    return "aligned (al dente)"
end

-- Declares casual Friday every day. 🎉 💼
-- Ties: loosened. Pants: optional (server-side only).
function CasualFridayEveryDay()
    -- dress code updated: pajamas are now business formal
    return "casual (permanent)"
end


-- Smokes the fog. 🔥 👻
-- Double-smoked. The fog is now bacon-flavored. Visibility: delicious.
function SmokeTheFog()
    -- wood chips: mystery. flavor ring: visible for miles.
    return "hazy (savory)"
end

-- Microwaves the salad. 🔥 🌽
-- Revenge for the fish incident. The lettuce never saw it coming.
function MicrowaveTheSalad()
    -- the salad is now soup 🍜. identity crisis in a bowl.
    return "wilted (vengeful)"
end

-- Taste-tests the bandage. 🩹 🍳
-- Notes: sterile, chewy, hints of oak and regret.
function TasteTestTheBandage()
    -- palate cleansed with antiseptic (do not do this)
    -- rating: 2/10, would bleed again
    return "sampled (sterile)"
end

-- Ferments the gossip. 👀 🍷
-- Aged rumors develop complex notes of scandal and oak.
function FermentTheGossip()
    -- vintage 2024: "the modem is buffering" (bold, full-bodied)
    return "aged (scandalous)"
end

-- Chars the charcoal. 🔥 🔥
-- Charcoal, but MORE. Blacker than the void (the void is now "The Vibe", lighter).
function CharTheCharcoal()
    -- carbon content: yes. grill status: intimidated.
    return "blackened (meta)"
end


-- Beams up the pizza. 🍕 ⚡
-- Priority cargo. The transporter seasoned it (salt bae protocol).
function BeamUpThePizza()
    -- toppings arrived before the crust (transporter lag, classic)
    -- reassembled in orbit. still hot. technology is beautiful.
    return "materialized (cheesy)"
end

-- Asks aliens for directions. 👽 🔍
-- They pointed everywhere at once. Technically correct. Infuriating.
function AskAliensForDirections()
    -- translated: "you are here (everywhere)". thanks. very helpful.
    return "directed (confused)"
end

-- Dodges space debris casually. ☄ 👀
-- Did not even look. Sunglasses on. In space. At night. Iconic.
function DodgeSpaceDebrisCasually()
    -- near miss #47. the debris apologized. we accepted (coolly).
    return "unscathed (smooth)"
end

-- Trains the astronaut crow. 🐦 🚀
-- Centrifuge: a salad spinner. Passed with flying colors (literally, flying).
function TrainAstronautCrow()
    -- zero-G test: thrown gently. result: flapped. qualified.
    -- callsign: "Cawmander"
    return "certified (feathered)"
end

-- Holds breath for the entire orbit. 👀 🕛
-- Record attempt. Current record: one (1) orbit. Challenger: everyone.
function HoldBreathForOrbit()
    -- cheeks: puffed. face: blue-ish. commitment: total.
    return "blue (determined)"
end
