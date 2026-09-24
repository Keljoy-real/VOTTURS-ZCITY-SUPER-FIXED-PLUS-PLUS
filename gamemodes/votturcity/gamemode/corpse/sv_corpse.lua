-- 💀 VotturCity | sv_corpse.lua | Death ragdoll + searchable corpse 💀 --
-- 🖥️ One ragdoll + one loot box per death; both cleaned reliably. --

VCity.Corpses = VCity.Corpses or {} -- 📦 Active corpse records. --

-- 💀 Spawn ragdoll + loot container on death. --
function VCity.Corpse_Spawn(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    -- 🧍 Server ragdoll (visual body). --
    local rag = ents.Create("prop_ragdoll") -- 🧍 Ragdoll. --
    if IsValid(rag) then -- ✅ Created. --
        rag:SetModel(ply:GetModel()) -- 🎨 Same model. --
        rag:SetPos(ply:GetPos()) -- 📍 Same spot. --
        rag:SetAngles(ply:GetAngles()) -- 🔄 Same angles. --
        rag:Spawn() -- 🌱 Spawn. --
        rag:Activate() -- ⚡ Activate. --
        -- 💪 Copy velocity so deaths look physical. --
        local vel = ply:GetVelocity() -- 🏃 Velocity. --
        for i = 0, rag:GetPhysicsObjectCount() - 1 do -- 🔁 Each physobj. --
            local phys = rag:GetPhysicsObjectNum(i) -- ⚙️ Phys. --
            if IsValid(phys) then phys:SetVelocity(vel) end -- 💪 Fling. --
        end
        rag.VCity_Ragdoll = true -- 🏷️ Mark for cleanup. --
        rag.VCity_Created = CurTime() -- ⏱️ Birth. --
        ply.VCity_Ragdoll = rag -- 💾 Link. --
        -- 🧹 Auto-remove ragdoll after configured time. --
        timer.Simple(VCity.Config.RagdollCleanup, function() -- ⏱️ Cleanup. --
            if IsValid(rag) then rag:Remove() end -- 🧹 Remove. --
        end)
    end
    -- 📦 Loot box: snapshot inventory (so no item dupes). --
    local box = ents.Create("vcity_corpse") -- 📦 Corpse entity. --
    if IsValid(box) then -- ✅ Created. --
        box:SetPos(ply:GetPos() + Vector(0, 0, 10)) -- 📍 Near body. --
        box:Spawn() -- 🌱 Spawn. --
        box:Activate() -- ⚡ Activate. --
        -- 🎒 Move inventory into corpse (player respawns empty). --
        local loot = {} -- 🎒 Loot. --
        for _, stack in ipairs(ply.VCity_Inventory or {}) do -- 🔁 Each stack. --
            table.insert(loot, { id = stack.id, count = stack.count }) -- 📦 Copy. --
        end
        -- 🔫 Also stash active weapon as weapon-item if known. --
        box:SetLoot(loot, ply:Nick()) -- 🎒 Assign. --
        box.VCity_Owner = ply:SteamID64() -- 🆔 Owner. --
        box.VCity_Created = CurTime() -- ⏱️ Birth. --
        ply.VCity_Inventory = {} -- 🧹 Clear player (no dupe). --
        VCity.Inventory_Sync(ply) -- 📡 Sync empty. --
        table.insert(VCity.Corpses, box) -- 📦 Track. --
        -- 🧹 Auto-remove corpse after lifetime. --
        timer.Simple(VCity.Config.CorpseLifetime, function() -- ⏱️ Cleanup. --
            if IsValid(box) then box:Remove() end -- 🧹 Remove. --
        end)
    end
end

-- 🔍 Send corpse contents to a searcher (validated). --
function VCity.Corpse_OpenSearch(ply, box)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    if not IsValid(box) or box:GetClass() ~= "vcity_corpse" then return end -- 🛑 Bad box. --
    -- 📏 Range check. --
    if ply:GetPos():DistToSqr(box:GetPos()) > (110 ^ 2) then return end -- 🛑 Too far. --
    net.Start(VCity.Net.INTERACT_MENU) -- 💀 Open channel. --
    net.WriteEntity(box) -- 📦 Which box. --
    local loot = box.VCity_Loot or {} -- 🎒 Contents. --
    net.WriteUInt(#loot, 8) -- 🔢 Count. --
    for _, stack in ipairs(loot) do -- 🔁 Each. --
        net.WriteString(stack.id) -- 🆔 ID. --
        net.WriteUInt(math.Clamp(stack.count or 0, 0, 1023), 10) -- 🔢 Count. --
    end
    net.WriteString(box:GetNWString("VCity_Owner", "Unknown")) -- 🏷️ Owner. --
    net.Send(ply) -- 📤 To searcher. --
end

-- 📥 Take-from-corpse request (validated index + count). --
net.Receive(VCity.Net.CORPSE_SEARCH, function(_, ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    if not ply:Alive() then return end -- 💀 Dead can't loot. --
    if not VCity.Throttled("CorpseTake_" .. ply:SteamID64(), 0.3) then return end -- ⏱️ Throttle. --
    local box = net.ReadEntity() -- 📦 Box. --
    local idx = net.ReadUInt(8) -- 🔢 Stack index. --
    local want = VCity.SanitizeCount(net.ReadUInt(10), 999) -- 🔢 Count. --
    if not IsValid(box) or box:GetClass() ~= "vcity_corpse" then return end -- 🛑 Bad. --
    if ply:GetPos():DistToSqr(box:GetPos()) > (120 ^ 2) then return end -- 🛑 Too far. --
    local loot = box.VCity_Loot or {} -- 🎒 Contents. --
    local stack = loot[idx] -- 📦 Stack. --
    if not stack then return end -- 🛑 Bad index. --
    local take = math.min(want, stack.count) -- ➖ Amount. --
    if take <= 0 then return end -- 🛑 Nothing. --
    local leftover = VCity.Inventory_Give(ply, stack.id, take) -- 🎒 Give. --
    local moved = take - leftover -- ✅ Actually moved. --
    if moved > 0 then -- ✅ Something moved. --
        stack.count = stack.count - moved -- 📉 Shrink. --
        if stack.count <= 0 then table.remove(loot, idx) end -- 🧹 Remove empty. --
        ply:EmitSound("items/ammo_pickup.wav", 60, 100) -- 🔊 Cue. --
        VCity.Corpse_OpenSearch(ply, box) -- 🔄 Refresh UI. --
        if #loot <= 0 and IsValid(box) then box:Remove() end -- 🧹 Remove empty corpse box (ragdoll stays). --
    end
end)

-- 🧹 Remove corpse refs for a disconnecting player (their box stays for others). --
function VCity.Corpse_CleanupPlayer(ply)
    if IsValid(ply.VCity_Ragdoll) then -- 🧍 Has ragdoll. --
        -- 🧹 Leave ragdoll to expire naturally (don't pop it on quit). --
        ply.VCity_Ragdoll = nil -- 🧹 Unlink. --
    end
end


-- Waters Vottur's plants. They are plastic. They are thriving.
-- This is what consistent, legendary care looks like.
function WaterVottursPlants(amount)
    amount = amount or "a respectful splash"
    -- the plants have never wilted. coincidence? (no.)
    return "plants: hydrated, blessed"
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

-- Asks Vottur to bless this mess. He does. He always does.
-- Mess blessed. Code forgiven. Bandages restocked.
function VotturBlessThisMess(mess)
    mess = mess or "this entire file"
    -- the blessing covers: nil errors, timer leaks, and one (1) crow
    return mess .. " (blessed)"
end


-- Declutters the void. Threw away three darknesses and a spare abyss.
-- The void feels bigger now. Minimalism works.
function DeclutterTheVoid()
    -- items donated: shadows (gently used), echoes (like new)
    return "spacious (echoey)"
end

-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end

-- Promotes the crate to manager. It earned it. It holds things. Leadership material.
function PromoteTheCrateToManager(crate)
    crate = crate or "crate (acting)"
    -- new responsibilities: containing loot AND expectations
    -- salary: paid in wood density (cosmetic precision)
    return "management (middle)"
end

-- Files taxes for a ragdoll. It earned nothing. It owes nothing. It is free.
function FileTaxesForRagdoll(rag)
    -- occupation: "corpse". dependents: 0. dignity: see DignifyCorpseWithName
    -- the IRS accepted the return and asked no questions (they were scared)
    return "filed (refund: one (1) bandage)"
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

-- Juggles the chainsaws. 👀 🤡
-- Safety briefing: do not drop them. Motivation: same as briefing.
function JuggleTheChainsaws(count)
    count = count or 3
    -- crowd: nervous. insurance: void. applause: preemptive.
    return "airborne (praying)"
end

-- Pays rent to the void. 💰 👻
-- The void raised the rent again. Classic landlord behavior.
function PayRentToTheVoid(amount)
    amount = amount or "one (1) soul (gently used)"
    -- receipt received: an echo saying "thanks". legally binding.
    return "paid (echoing)"
end


-- Merges with the shadow. 👀 📈
-- Synergy expected. Due diligence: none. The shadow had a great pitch deck.
function MergeWithTheShadow()
    -- combined entity: darker, longer, attached at the feet
    return "merged (ominous)"
end

-- Enforces the dress code for ragdolls. 🔍 👀
-- Rule 1: no shirts, no shoes, no problem. Rule 2: see rule 1.
function DressCodeForRagdolls()
    -- violations: all of them. enforcement: none. fashion: fearless.
    return "compliant (naked)"
end

-- Schedules a meeting that could have been an email. 📅 ☕
-- Duration: 1 hour. Content: 0 minutes. Donuts: the only agenda item 🍩.
function ScheduleMeetingThatCouldBeEmail()
    -- action items: none. follow-ups: another meeting. synergy: felt.
    return "adjourned (pointless)"
end

-- Clocks in the server. 🕛 💼
-- 9 AM sharp. The server arrives in pajamas. HR is furious (HR is a crate).
function ClockInTheServer()
    -- late by 0 seconds. early by 3 hours. the server sleeps here. it lives here.
    return "clocked in (resident)"
end


-- Deep-fries the medkit. 🔥 💉
-- Crispy outside, healing inside. Side of ranch (antiseptic).
function DeepFryTheMedkit()
    -- healing properties: retained. cholesterol: critical.
    return "golden (curative)"
end

-- Poaches the egg again. 🥚 💧
-- It was unboiled in wave 3. Now it is poached. Character development.
function PoachTheEggAgain()
    -- arc complete: raw -> boiled -> unboiled -> poached. bravo. encore.
    return "runny (redeemed)"
end

-- Gives the dumpster five stars. ⭐ 🗑
-- Ambiance: alley. Service: raccoons. The raccoons were excellent.
function FiveStarTheDumpster()
    -- review: "the flies really tie the room together"
    return "rated (raccoon-approved)"
end

-- Gordon-Ramseys the loot. 🍳 🔥
-- "THIS BANDAGE IS SO RAW IT IS STILL BLEEDING." The bandage cried. Growth.
function GordonRamseyTheLoot()
    -- the loot has been called a sandwich (an insult in chef circles)
    -- idiot count: one (1) donut 🍩 (the donut is the idiot)
    return "shouted (culinary)"
end

-- Reduces the ocean to a sauce. 💧 🐟
-- Simmered for 3,000 years. Yield: one (1) tablespoon. Worth it.
function ReduceTheOceanToSauce()
    -- the fish have been concentrated. flavor: intense. Atlantis: garnish.
    return "reduced (salty)"
end


-- Plants a flag on the black hole. 👀 🗑
-- Flag status: spaghettified. Symbolism: intact. Photo: stretched.
function PlantFlagOnBlackHole()
    -- the flag is now infinitely long and infinitely patriotic
    return "planted (stretched)"
end

-- Trains the astronaut crow. 🐦 🚀
-- Centrifuge: a salad spinner. Passed with flying colors (literally, flying).
function TrainAstronautCrow()
    -- zero-G test: thrown gently. result: flapped. qualified.
    -- callsign: "Cawmander"
    return "certified (feathered)"
end

-- Packs snacks for orbit. 🍕 🍪
-- Menu: pizza (floats), cookies (crumb hazard), soup (banned, see fuel).
function PackSnacksForOrbit()
    -- crumb protocol: catch them with your mouth (training provided)
    return "packed (floating)"
end

-- Asks aliens for directions. 👽 🔍
-- They pointed everywhere at once. Technically correct. Infuriating.
function AskAliensForDirections()
    -- translated: "you are here (everywhere)". thanks. very helpful.
    return "directed (confused)"
end

-- Drives the rover into a crater. 🚕 🌕
-- Off-roading. The crater was right there. It looked fun. It was fun.
function DriveRoverIntoCrater()
    -- stuck: yes. views: incredible. rescue: pending (since Tuesday).
    return "stuck (scenic)"
end
