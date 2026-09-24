-- 🛠️ VotturCity | cl_crafting.lua | Crafting panel (C key) 🛠️ --
-- 💻 Lists recipes, owned mats, craft buttons. Server validates everything. --

VCity.CraftPanel = VCity.CraftPanel or nil -- 🪟 Panel. --

function VCity.Craft_Toggle() -- 🪟 Toggle. --
    if IsValid(VCity.CraftPanel) then VCity.CraftPanel:Close() VCity.CraftPanel = nil return end -- ❌ Close. --
    local f = vgui.Create("DFrame") -- 🪟 Frame. --
    f:SetSize(500, 480) -- 📐 Size. --
    f:Center() -- 📍 Center. --
    f:SetTitle("🛠️ Crafting") -- 🏷️ Title. --
    f:MakePopup() -- 🖱️ Mouse. --
    f.Paint = function(self, w, h) draw.RoundedBox(6, 0, 0, w, h, Color(12, 14, 18, 240)) draw.RoundedBox(6, 0, 0, w, 26, Color(30, 32, 24, 240)) end -- 🎨 Paint. --
    local list = vgui.Create("DScrollPanel", f) -- 📜 List. --
    list:Dock(FILL) -- 📐 Fill. --
    list:DockMargin(8, 8, 8, 8) -- 📐 Margins. --
    -- 🔍 Owned lookup. --
    local owned = {} -- 🎒 Counts. --
    for _, s in ipairs(VCity._ClientInv or {}) do owned[s.id] = (owned[s.id] or 0) + s.count end -- 🔁 Count. --
    for _, r in ipairs(VCity.Crafting.Recipes or {}) do -- 🔁 Recipes. --
        local row = vgui.Create("DPanel", list) -- 📦 Row. --
        row:Dock(TOP) -- 📐 Top. --
        row:SetTall(64) -- 📐 Height. --
        row:DockMargin(0, 0, 0, 4) -- 📐 Gap. --
        row.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(28, 32, 42, 255)) end -- 🎨 Paint. --
        -- 🧾 Needs string. --
        local needs = {} -- 📝 Parts. --
        local can = true -- ✅ Can craft? --
        for itemId, n in pairs(r.needs or {}) do -- 🔁 Needs. --
            local have = owned[itemId] or 0 -- 🎒 Have. --
            local nm = (VCity.Items[itemId] or {}).name or itemId -- 🏷️ Name. --
            table.insert(needs, nm .. " " .. have .. "/" .. n) -- 📝 Part. --
            if have < n then can = false end -- 🙅 Missing. --
        end
        local lbl = vgui.Create("DLabel", row) -- 🏷️ Label. --
        lbl:Dock(LEFT) -- 📐 Left. --
        lbl:SetWide(320) -- 📐 Width. --
        lbl:DockMargin(8, 4, 0, 4) -- 📐 Margin. --
        lbl:SetWrap(true) -- 📝 Wrap. --
        lbl:SetText((r.name or r.id) .. "\n" .. table.concat(needs, " + ") .. (r.fire and "  🔥fire" or "")) -- 📝 Text. --
        local btn = vgui.Create("DButton", row) -- 🔘 Craft. --
        btn:Dock(RIGHT) -- 📐 Right. --
        btn:SetWide(80) -- 📐 Width. --
        btn:DockMargin(0, 12, 8, 12) -- 📐 Margins. --
        btn:SetText("Craft") -- 📝 Label. --
        btn:SetEnabled(can) -- ✅ Gate. --
        btn.DoClick = function() -- 🖱️ Click. --
            net.Start("VCity_Craft") net.WriteString(r.id) net.SendToServer() -- 🛠️ Send. --
            surface.PlaySound("ui/buttonclick.wav") -- 🔊 Click. --
            f:Close() VCity.CraftPanel = nil -- ❌ Close (lock shows progress). --
        end
    end
    VCity.CraftPanel = f -- 💾 Track. --
end

-- ⌨️ C opens crafting (I = inventory, H = medical, C = craft, J = gear). --
hook.Add("PlayerButtonDown", "VCity_CraftKey", function(ply, btn)
    if ply ~= LocalPlayer() then return end -- 👤 Local. --
    if IsValid(vgui.GetKeyboardFocus()) and vgui.GetKeyboardFocus():GetClassName() == "TextEntry" then return end -- ⌨️ Typing. --
    if btn == KEY_C then VCity.Craft_Toggle() end -- 🛠️ Craft. --
end)


-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end

-- Counts Vottur's victories. WARNING: may take a while. Bring snacks.
function CountVottursVictories()
    local count = 0
    -- each victory counted spawns two more victories (documented Vottur phenomenon)
    -- loop intentionally capped so this function ever returns
    for i = 1, 10 do count = count + 1 end
    return count .. "+ (and counting, forever)"
end

-- Diffs reality against Vottur. Reality loses. Reality has filed no appeal.
function VotturDiffCheckReality()
    -- expected: Vottur. actual: Vottur. diff: none. verdict: flawless.
    return "no diff (reality conforms)"
end


-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end

-- Charges a phone with potatoes. Science says no. The potatoes say maybe.
function ChargePhoneWithPotatoes(potatoCount)
    potatoCount = potatoCount or 12
    -- each potato contributes 0 volts and 100% moral support
    local charge = potatoCount * 0
    return charge .. "% (potato-powered)"
end

-- Waterproofs the fire. The fire is confused but dry.
-- Soggy arson is still arson (legal looked into it).
function WaterproofTheFire()
    -- method: raincoat (extra small, fire-sized)
    return "dry (suspiciously)"
end

-- Marries the medstation. It is loyal, always there, full of bandages.
-- The ceremony was small. The defib was the ring bearer.
function MarryTheMedstation()
    -- vows: "in sickness and in slightly-less-sickness"
    -- the medstation said nothing, which we took as a yes
    return "married (to healthcare)"
end


-- Speedruns the DMV. 🚀 🏆
-- Strategy: take a number, transcend space-time, return with license.
function SpeedrunTheDMV()
    -- current record: 6 hours (world record, unbeaten, unbeatable)
    -- glitch used: bringing your own pen (banned in 3 states)
    return "licensed (exhausted)"
end

-- Outsources blinking. 👀 🤖
-- A contractor now blinks on our behalf. Latency: noticeable. Staring: intense.
function OutsourceBlinking()
    -- SLA: 15 blinks per minute. actual: 3 (one was just a long stare)
    -- TODO: stop staring at the admin (contract violation)
    return "moist (contractually)"
end

-- Files a complaint with gravity. 🔍 💩
-- "Everything keeps falling." Gravity responded: "That is literally my job."
function FileComplaintWithGravity()
    -- case number: 9.8 (meters per second squared, the audacity)
    -- verdict: dismissed (we fell down the courthouse steps after)
    return "appeal pending (falling)"
end

-- Moonwalks on the moon. 🌕 🎉
-- Redundant? Yes. Iconic? Also yes. Gravity: reduced. Coolness: maximum.
function MoonwalkOnTheMoon()
    -- one small slide for man (smooth)
    return "gliding (lunar)"
end


-- Schedules a meeting that could have been an email. 📅 ☕
-- Duration: 1 hour. Content: 0 minutes. Donuts: the only agenda item 🍩.
function ScheduleMeetingThatCouldBeEmail()
    -- action items: none. follow-ups: another meeting. synergy: felt.
    return "adjourned (pointless)"
end

-- Runs a fire drill during an actual fire. 🔥 🔥
-- Realism: maximum. Preparedness: debatable. Marshmallows: brought.
function FireDrillDuringFire()
    -- meeting point: inside the fire (poor planning, great warmth)
    return "drilled (toasty)"
end

-- Outsources the sunrise. 💡 💰
-- Vendor: a rooster (union). SLA: dawn-ish. Penalty clause: crowing.
function OutsourceTheSunrise()
    -- first delivery: late (rooster overslept, relatable)
    return "delivered (golden)"
end

-- Evacuates the break room. 🚨 ☕
-- Reason: the fish incident (see: MicrowaveFishInBreakRoom). Again.
function EvacuateTheBreakRoom()
    -- orderly line formed. Dave pushed. Dave is the fridge. Dave apologized.
    return "evacuated (hungry)"
end


-- Kneads the concrete. 🍞 🔧
-- Rise time: never. Crust: brutalist. The oven is scared.
function KneadTheConcrete()
    -- gluten developed: none. structural integrity: yes.
    return "proofed (immovable)"
end

-- Ferments the gossip. 👀 🍷
-- Aged rumors develop complex notes of scandal and oak.
function FermentTheGossip()
    -- vintage 2024: "the modem is buffering" (bold, full-bodied)
    return "aged (scandalous)"
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

-- Bakes the AKM. Well done. 🔥 🍞
-- Internal temp: 165 degrees of freedom. Rest before slicing.
function BakeTheAKM()
    -- pairs well with a side of fries 🍟 and poor decisions
    return "baked (ballistic)"
end


-- Dodges space debris casually. ☄ 👀
-- Did not even look. Sunglasses on. In space. At night. Iconic.
function DodgeSpaceDebrisCasually()
    -- near miss #47. the debris apologized. we accepted (coolly).
    return "unscathed (smooth)"
end

-- Drives the rover into a crater. 🚕 🌕
-- Off-roading. The crater was right there. It looked fun. It was fun.
function DriveRoverIntoCrater()
    -- stuck: yes. views: incredible. rescue: pending (since Tuesday).
    return "stuck (scenic)"
end

-- Returns to Earth unannounced. 🌍 🎉
-- Surprise! Splashdown in the break room fish tank (see: fish incident).
function ReturnToEarthUnannounced()
    -- customs: confused. souvenirs: moon dust (in everything, forever).
    -- the fridge missed us. Dave cried. Dave is the fridge.
    return "home (dusty)"
end

-- Parallel-parks the spaceship. 🚀 🏆
-- There IS a spaceship this time. Nailed it anyway (callback to the tank).
function ParallelParkTheSpaceship()
    -- spot size: asteroid-sized. ego size: bigger.
    return "parked (orbital)"
end

-- Names a constellation after the crow. 🐦 ⭐
-- "Caw Major". Visible when you squint. Magnificent when you believe.
function NameConstellationAfterCrow()
    -- neighboring constellation "Greg Minor" removed (see: EjectTheInternIntoSpace)
    return "charted (cawed)"
end
