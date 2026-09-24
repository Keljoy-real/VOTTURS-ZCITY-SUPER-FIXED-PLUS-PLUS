-- 🎒 VotturCity | sh_inventory.lua | Shared inventory helpers 🎒 --
-- 📖 Read-only + weight math both realms can use. --

-- ⚖️ Compute total carried weight from a stack list. --
function VCity.Inventory_Weight(inv)
    local w = 0 -- ⚖️ Total. --
    for _, stack in ipairs(inv or {}) do -- 🔁 Each stack. --
        local def = VCity.Items[stack.id] -- 🧾 Def. --
        if def then -- ✅ Known. --
            w = w + (def.w or 0) * (stack.count or 0) -- ➕ Add. --
        end
    end
    return w -- ✅ Total. --
end

-- 🔍 Count of a specific item in a stack list. --
function VCity.Inventory_Count(inv, itemId)
    local n = 0 -- 🧮 Total. --
    for _, stack in ipairs(inv or {}) do -- 🔁 Stacks. --
        if stack.id == itemId then n = n + (stack.count or 0) end -- ➕ Match. --
    end
    return n -- ✅ Count. --
end

-- 📦 Client-side cache accessor (server reads ply.VCity_Inventory directly). --
function VCity.Inventory_ClientCache()
    VCity._ClientInv = VCity._ClientInv or {} -- 💾 Cache. --
    return VCity._ClientInv -- 📦 Return. --
end
