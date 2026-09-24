-- 🦴 VotturCity | sh_limbs.lua | Body region definitions 🦴 --
-- 🎯 Each of the 9 regions tracks damage 0-100, wounds, fractures. --

-- 🧬 Static per-limb gameplay tuning (bleed + fracture weights). --
VCity.LimbDefs = { -- 🦴 Indexed by VCity.Limb id. --
    [1] = { name = "Head",     bleed = 1.6, fracture = 0.1, vital = true }, -- 🧠 Head bleeds fast. --
    [2] = { name = "Brain",    bleed = 0.4, fracture = 0.0, vital = true, hidden = true }, -- 🧠 Concussion only. --
    [3] = { name = "Chest",    bleed = 1.2, fracture = 0.2, vital = true }, -- 🫁 Chest is vital. --
    [4] = { name = "Stomach",  bleed = 1.0, fracture = 0.05, vital = false }, -- 🫀 Stomach bleeds steadily. --
    [5] = { name = "Pelvis",   bleed = 0.9, fracture = 0.3, vital = false }, -- 🦴 Pelvis fractures cripple. --
    [6] = { name = "Left Arm", bleed = 0.6, fracture = 0.25, vital = false }, -- 💪 Arm wounds hurt aim. --
    [7] = { name = "Right Arm",bleed = 0.6, fracture = 0.25, vital = false }, -- 💪 Same for right. --
    [8] = { name = "Left Leg", bleed = 0.7, fracture = 0.35, vital = false }, -- 🦵 Leg fractures limp. --
    [9] = { name = "Right Leg",bleed = 0.7, fracture = 0.35, vital = false }, -- 🦵 Same for right. --
}

-- 🆕 Build a fresh limb table for a spawning player. --
function VCity.Limbs_Fresh()
    local t = {} -- 📦 Fresh limbs. --
    for id = 1, 9 do -- 🔁 All regions. --
        t[id] = { dmg = 0, wound = 0, fracture = false, bandaged = false } -- 🩹 Clean state. --
    end
    return t -- ✅ Return. --
end

-- 🧮 Count fractured legs (0-2) for movement penalties. --
function VCity.Limbs_BrokenLegs(limbs)
    local n = 0 -- 🧮 Counter. --
    if limbs[8] and limbs[8].fracture then n = n + 1 end -- 🦵 Left. --
    if limbs[9] and limbs[9].fracture then n = n + 1 end -- 🦵 Right. --
    return n -- ✅ Count. --
end

-- 🧮 Count fractured arms for aim penalties. --
function VCity.Limbs_BrokenArms(limbs)
    local n = 0 -- 🧮 Counter. --
    if limbs[6] and limbs[6].fracture then n = n + 1 end -- 💪 Left. --
    if limbs[7] and limbs[7].fracture then n = n + 1 end -- 💪 Right. --
    return n -- ✅ Count. --
end

-- 🩸 Total wound severity across all limbs (drives bleed rate). --
function VCity.Limbs_TotalWounds(limbs)
    local total = 0 -- 🧮 Sum. --
    for id = 1, 9 do -- 🔁 All limbs. --
        local L = limbs[id] -- 🦴 Region. --
        if L and not L.bandaged then -- 🩹 Bandaged wounds don't bleed. --
            total = total + (L.wound or 0) * (VCity.LimbDefs[id].bleed or 1) -- 🩸 Weighted. --
        end
    end
    return total -- ✅ Total. --
end
