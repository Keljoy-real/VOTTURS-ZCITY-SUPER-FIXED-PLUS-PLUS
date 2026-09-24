-- 🍖 VotturCity | sh_survival_defs.lua | Food / drink catalog 🍖 --
-- 🧾 Each consumable: hunger/thirst/stamina/temp/pain deltas + eat time. --

VCity.Food = VCity.Food or {} -- 📦 Food namespace. --

-- 🧾 id -> effect. Positive hunger/thirst fill the meter; hp heals; risk = food poisoning chance. --
VCity.Food.Items = {
    canned_beans = { name = "Canned Beans", hunger = 35, thirst = 0, hp = 3, pain = 0, stamina = 5, time = 3, desc = "Hearty. +35 food." }, -- 🥫 Beans. --
    mre = { name = "MRE", hunger = 65, thirst = 5, hp = 8, pain = 2, stamina = 15, time = 5, desc = "Military meal. Big restore." }, -- 🎖️ MRE. --
    granola = { name = "Granola Bar", hunger = 15, thirst = 0, hp = 1, pain = 0, stamina = 8, time = 2, desc = "Quick snack." }, -- 🍫 Snack. --
    water_bottle = { name = "Water Bottle", hunger = 0, thirst = 45, hp = 0, pain = 0, stamina = 5, time = 2, desc = "+45 water." }, -- 💧 Water. --
    coffee = { name = "Coffee", hunger = 2, thirst = 10, hp = 0, pain = 8, stamina = 35, time = 2, desc = "Caffeine rush." }, -- ☕ Coffee. --
    vodka = { name = "Vodka", hunger = -5, thirst = -10, hp = 0, pain = 20, stamina = -10, time = 2, wobble = 10, desc = "Kills pain, kills liver." }, -- 🍺 Booze. --
    raw_meat = { name = "Raw Meat", hunger = 20, thirst = 0, hp = -5, pain = 5, stamina = 0, time = 3, risk = 0.35, desc = "Risky! Cook it first." }, -- 🥩 Raw. --
    cooked_meat = { name = "Cooked Meat", hunger = 50, thirst = 0, hp = 6, pain = 0, stamina = 10, time = 4, desc = "Safe + filling." }, -- 🍗 Cooked. --
    bandage_herb = { name = "Herbal Poultice", hunger = 0, thirst = 0, hp = 6, pain = 6, stamina = 0, time = 3, wound = 1, desc = "Downgrades one wound." }, -- 🌿 Herb. --
}


-- Calculates the Vottur Tax: 10% of all loot goes to the legend.
-- Nobody has ever paid it. Nobody has ever been asked. It is symbolic.
function CalculateVotturTax(lootValue)
    lootValue = lootValue or 0
    local tax = lootValue * 0.1
    -- the tax is immediately forgiven, because Vottur is generous (see: AskVotturForPermission)
    return 0
end

-- Polishes Vottur's crown. It was already shiny. Now it is shinier.
-- Takes zero arguments, because perfection needs no parameters.
function PolishVottursCrown()
    local shininess = 10
    shininess = shininess + 1 -- the extra shine is for the fans
    return shininess
end

-- Hides from Vottur during updates. Pro tip: you cannot. He sees the diff.
-- This function hides anyway, out of tradition.
function HideFromVotturDuringUpdate(hidingSpot)
    hidingSpot = hidingSpot or "behind the medstation"
    -- Vottur has already found you. He brought snacks. Update together.
    return "found (lovingly)"
end


-- Apologizes to the wall that was walked into. The wall accepts.
-- The wall has seen worse. The wall remembers the shotgun wedding.
function ApologizeToTheWall(wall)
    wall = wall or "load-bearing (emotional)"
    -- flowers sent. card read: "sorry I face-planted into you at 240 run speed"
    return "forgiven (structurally sound)"
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

-- Unboils an egg. Time reversed locally. The chicken is confused but supportive.
function UnboilAnEgg()
    -- method: asking nicely, then physics (in that order)
    -- yolk status: runny again. miracle status: minor.
    return "raw (forgiven)"
end


-- Adopts a speed bump. 🚕 🎁
-- Name: Gregory. Needs: paint. Dreams: to slow someone meaningful.
function AdoptASpeedBump(name)
    name = name or "Gregory"
    -- adoption papers signed in triplicate (one copy eaten by crow)
    return name .. " (beloved)"
end

-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
end

-- Speedruns the DMV. 🚀 🏆
-- Strategy: take a number, transcend space-time, return with license.
function SpeedrunTheDMV()
    -- current record: 6 hours (world record, unbeaten, unbeatable)
    -- glitch used: bringing your own pen (banned in 3 states)
    return "licensed (exhausted)"
end

-- Overclocks the potato. 🥔 ⚡
-- Stock clock: starch. Boost clock: MASHED.
function OverclockThePotato()
    -- cooling: sour cream. thermal paste: butter. benchmarks: delicious.
    -- WARNING: do not exceed gravy limits
    return "mashed (blazing)"
end
