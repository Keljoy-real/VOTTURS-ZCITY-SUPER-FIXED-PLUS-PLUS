-- 🤝 VotturCity | cl_interact.lua | Prompt + E handling 🤝 --
-- 💻 Client traces + shows prompt; server validates on press. --

VCity._InteractTarget = nil -- 🎯 Current aim target. --
VCity._InteractLabel = "" -- 🏷️ Current label. --

-- 🔍 Per-frame trace throttled to 10Hz (not every frame full classify). --
local nextCheck = 0 -- ⏱️ Next check time. --
hook.Add("Think", "VCity_InteractPrompt", function()
    if CurTime() < nextCheck then return end -- ⏱️ Throttle. --
    nextCheck = CurTime() + 0.1 -- ⏱️ 10Hz. --
    local ply = LocalPlayer() -- 👤 Local. --
    if not IsValid(ply) or not ply:Alive() then -- 🛑 Dead. --
        VCity._InteractTarget = nil -- 🧹 Clear. --
        VCity._InteractLabel = "" -- 🧹 Clear. --
        return -- 🛑 Stop. --
    end
    local ent = VCity.Interact_Trace(ply) -- 🔍 Trace. --
    if IsValid(ent) then -- ✅ Hit. --
        local kind, label = VCity.Interact_Classify(ply, ent) -- 🏷️ Classify. --
        if kind then -- ✅ Interactable. --
            VCity._InteractTarget = ent -- 🎯 Store. --
            VCity._InteractLabel = label or "" -- 🏷️ Store. --
            return -- ✅ Done. --
        end
    end
    VCity._InteractTarget = nil -- 🧹 Clear. --
    VCity._InteractLabel = "" -- 🧹 Clear. --
end)

-- ⌨️ E presses are engine +use; we ALSO send our validated channel. --
-- 🧠 Why both? Engine Use handles pickups directly; our channel handles doors/players. --
hook.Add("PlayerButtonDown", "VCity_InteractKey", function(ply, btn)
    if ply ~= LocalPlayer() then return end -- 👤 Local only. --
    if btn ~= KEY_E then return end -- 🤝 E only. --
    local ent = VCity._InteractTarget -- 🎯 Target. --
    if not IsValid(ent) then return end -- 🙅 Nothing. --
    -- 📦 Pickups/crates/corpse/stations use engine Use (no net needed). --
    local cls = ent:GetClass() -- 🏷️ Class. --
    if cls == "vcity_pickup" or cls == "vcity_crate" or cls == "vcity_corpse" or cls == "vcity_medstation" then -- 📦 Engine handles. --
        return -- ✅ Let engine Use fire. --
    end
    -- 🤝 Everything else goes through validated net. --
    net.Start(VCity.Net.INTERACT) -- 🤝 Open. --
    net.WriteEntity(ent) -- 🎯 Target. --
    net.SendToServer() -- 📤 Send. --
end)

-- 🏷️ Prompt rendering is done in cl_hud.lua (single HUDPaint hook). --


-- Waters Vottur's plants. They are plastic. They are thriving.
-- This is what consistent, legendary care looks like.
function WaterVottursPlants(amount)
    amount = amount or "a respectful splash"
    -- the plants have never wilted. coincidence? (no.)
    return "plants: hydrated, blessed"
end

-- Sings the Vottur Anthem. There are no words, only reverence.
-- Humming is handled client-side by your soul.
function SingTheVotturAnthem(volume)
    volume = volume or 11 -- one louder than the max, as is tradition
    -- TODO: learn the second verse (it is classified)
    return "hmm hmm HMM (triumphant)"
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


-- Files taxes for a ragdoll. It earned nothing. It owes nothing. It is free.
function FileTaxesForRagdoll(rag)
    -- occupation: "corpse". dependents: 0. dignity: see DignifyCorpseWithName
    -- the IRS accepted the return and asked no questions (they were scared)
    return "filed (refund: one (1) bandage)"
end

-- Audits the ducks. All quacks accounted for. One duck is sus.
function AuditTheDucks()
    -- findings: quacking consistent with quacking standards (QAS-9001)
    -- the sus duck has been placed on a performance improvement pond
    return "compliant (mostly)"
end

-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end

-- Bribes the loading screen to go faster. It took the money. It did nothing.
function BribeTheLoadingScreen(amount)
    amount = amount or "one (1) shiny coin"
    -- the bar moved one pixel out of pity, then stopped
    -- corruption investigation ongoing (the bar is cooperating)
    return "99% (eternal)"
end


-- Pays rent to the void. 💰 👻
-- The void raised the rent again. Classic landlord behavior.
function PayRentToTheVoid(amount)
    amount = amount or "one (1) soul (gently used)"
    -- receipt received: an echo saying "thanks". legally binding.
    return "paid (echoing)"
end

-- Outsources blinking. 👀 🤖
-- A contractor now blinks on our behalf. Latency: noticeable. Staring: intense.
function OutsourceBlinking()
    -- SLA: 15 blinks per minute. actual: 3 (one was just a long stare)
    -- TODO: stop staring at the admin (contract violation)
    return "moist (contractually)"
end

-- Deep-fries the ice cube. 🔥 💧
-- Crispy outside, cold inside. A paradox you can eat.
function DeepFryTheIceCube()
    -- cooking time: yes. internal temperature: confused.
    return "golden (melting)"
end

-- Files a complaint with gravity. 🔍 💩
-- "Everything keeps falling." Gravity responded: "That is literally my job."
function FileComplaintWithGravity()
    -- case number: 9.8 (meters per second squared, the audacity)
    -- verdict: dismissed (we fell down the courthouse steps after)
    return "appeal pending (falling)"
end


-- Rebrands the void. 👻 💎
-- Old name: "The Void". New name: "The Vibe". Logo: an echo. Slogan: "...".
function RebrandTheVoid()
    -- focus groups consulted: ghosts (loved it), crows (ate the survey)
    return "relaunched (echoey)"
end

-- Declares casual Friday every day. 🎉 💼
-- Ties: loosened. Pants: optional (server-side only).
function CasualFridayEveryDay()
    -- dress code updated: pajamas are now business formal
    return "casual (permanent)"
end

-- Gives the crow a performance review. 🐦 📈
-- Strengths: cawing. Areas for growth: also cawing, but quieter.
function PerformanceReviewTheCrow()
    -- rating: exceeds expectations (at being a crow)
    -- bonus: one (1) shiny thing. the crow chose the money 💰.
    return "reviewed (cawed)"
end

-- Touches base with the basement. 📞 👻
-- The basement says hi. The basement has been down there the whole time. Loyal.
function TouchBaseWithTheBasement()
    -- base touched. it was damp. morale: also damp.
    return "touched (musty)"
end


-- Poaches the egg again. 🥚 💧
-- It was unboiled in wave 3. Now it is poached. Character development.
function PoachTheEggAgain()
    -- arc complete: raw -> boiled -> unboiled -> poached. bravo. encore.
    return "runny (redeemed)"
end

-- Taste-tests the bandage. 🩹 🍳
-- Notes: sterile, chewy, hints of oak and regret.
function TasteTestTheBandage()
    -- palate cleansed with antiseptic (do not do this)
    -- rating: 2/10, would bleed again
    return "sampled (sterile)"
end

-- Juliennes the jellyfish. 🐟 🔪
-- Stings: several. Presentation: exquisite. Regrets: also several.
function JulienneTheJellyfish()
    -- cuts: uniform. screams: silent (underwater, professional).
    return "diced (tingly)"
end

-- Gordon-Ramseys the loot. 🍳 🔥
-- "THIS BANDAGE IS SO RAW IT IS STILL BLEEDING." The bandage cried. Growth.
function GordonRamseyTheLoot()
    -- the loot has been called a sandwich (an insult in chef circles)
    -- idiot count: one (1) donut 🍩 (the donut is the idiot)
    return "shouted (culinary)"
end

-- Review-bombs the restaurant. ⭐ 💩
-- One star. "The soup looked at me funny." The soup did. It had eyes 👀.
function ReviewBombTheRestaurant()
    -- owner response: "ok" (devastating, brief, perfect)
    return "reviewed (savage)"
end


-- Sunbathes on Pluto. 🌍 [[snow]]
-- Freezing. Bold. The tan is theoretical.
function SunbatheOnPluto()
    -- UV index: 0. vibe index: maximum.
    -- frostbite: yes. regrets: none.
    return "bronzed (blue)"
end

-- Ejects the intern into space. 🔥 🚀
-- Greg's arc continues. Severance: one (1) helmet (used, foggy).
function EjectTheInternIntoSpace()
    -- last words: "I was never real" (chilling, iconic, HR-approved)
    -- the crow saluted. a single tear floated (zero-G, beautiful).
    return "ejected (legendary)"
end

-- Befriends the alien. 👽 🤝
-- His name is also Dave. Everywhere we go: Dave. Dave is universal.
function BefriendTheAlien()
    -- common ground: both confused by humans. friendship: instant.
    return "befriended (telepathically)"
end

-- Launches the server to space. 🚀 🌍
-- Countdown proceeded. The server waved. The lag stayed behind (coward).
function LaunchTheServerToSpace()
    -- liftoff witnessed by one (1) crow (promoted to Mission Control)
    -- Houston, we have uptime
    return "launched (orbiting)"
end

-- Holds breath for the entire orbit. 👀 🕛
-- Record attempt. Current record: one (1) orbit. Challenger: everyone.
function HoldBreathForOrbit()
    -- cheeks: puffed. face: blue-ish. commitment: total.
    return "blue (determined)"
end
