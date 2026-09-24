-- 🏪 VotturCity | vcity_trader | init.lua 🏪 --
AddCSLuaFile("shared.lua") -- 📤 Share. --
AddCSLuaFile("cl_init.lua") -- 📤 Client. --
include("shared.lua") -- 📥 Load. --

-- 💰 Price lists (scrap = currency). --
VCity.TraderBuy = VCity.TraderBuy or { -- 🛒 Player buys with scrap. --
    bandage = 2, bigbandage = 4, medkit = 10, painkillers = 3, splint = 4, -- 🩹 Meds. --
    ammo_9mm = 1, ammo_rifle = 2, ammo_shell = 2, -- 🔫 Ammo per 6 rounds lot. --
    canned_beans = 3, water_bottle = 3, cloth = 1, stick = 1, -- 🥫 Goods. --
}
VCity.TraderSell = VCity.TraderSell or { -- 💵 Trader pays for these. --
    scrap = 1, herb = 1, charcoal = 1, duct_tape = 2, -- 🧰 Mats. --
}

function ENT:Initialize() -- 🌱 Init. --
    self:SetModel("models/player/Group03/male_02.mdl") -- 🧍 Trader body. --
    self:PhysicsInit(SOLID_VPHYSICS) -- 🧱 Physics. --
    self:SetMoveType(MOVETYPE_NONE) -- 🧊 Static. --
    self:SetSolid(SOLID_BBOX) -- 🧱 Solid. --
    self:SetUseType(SIMPLE_USE) -- 🤝 Use. --
end

-- 🤝 Open trade menu on use. --
function ENT:Use(activator) -- 🤝 Interact. --
    if not VCity.IsLivePlayer(activator) or not activator:Alive() then return end -- 🛑 Validate. --
    if (self.VCity_NextUse or 0) > CurTime() then return end -- ⏱️ Cooldown. --
    self.VCity_NextUse = CurTime() + 0.5 -- ⏱️ Set. --
    net.Start("VCity_Trade") -- 🏪 Open. --
    net.WriteEntity(self) -- 🏪 Which trader. --
    -- 🛒 Send buy list (id + price). --
    local buy = {} for id, price in pairs(VCity.TraderBuy or {}) do table.insert(buy, { id = id, price = price }) end -- 🛒 List. --
    net.WriteUInt(#buy, 8) -- 🔢 Count. --
    for _, e in ipairs(buy) do net.WriteString(e.id) net.WriteUInt(e.price, 8) end -- 🔁 Write. --
    net.Send(activator) -- 📤 To buyer. --
end

-- 📥 Buy / sell ops (validated: scrap math server-side). --
net.Receive("VCity_TradeOp", function(_, ply)
    if not VCity.IsLivePlayer(ply) or not ply:Alive() then return end -- 🛑 Validate. --
    if not VCity.Throttled("Trade_" .. ply:SteamID64(), 0.3) then return end -- ⏱️ Throttle. --
    local trader = net.ReadEntity() -- 🏪 Trader. --
    local op = net.ReadString() -- 📝 buy/sell. --
    local itemId = VCity.SanitizeItemID(net.ReadString()) -- 🧹 Item. --
    local n = VCity.SanitizeCount(net.ReadUInt(8), 50) -- 🔢 Lots. --
    if not IsValid(trader) or trader:GetClass() ~= "vcity_trader" then return end -- 🛑 Bad. --
    if ply:GetPos():DistToSqr(trader:GetPos()) > (150 ^ 2) then return end -- 📏 Too far. --
    if op == "buy" then -- 🛒 Buy item with scrap. --
        local price = (VCity.TraderBuy or {})[itemId] -- 💰 Unit price (per 1, ammo lots handled below). --
        if not price then return end -- 🛑 Not sold. --
        local lot = 1 -- 📦 Units per purchase. --
        if itemId == "ammo_9mm" or itemId == "ammo_rifle" then lot = 6 end -- 🔫 Ammo lots of 6. --
        if itemId == "ammo_shell" then lot = 4 end -- 🔫 Shell lots. --
        local cost = price * n -- 💰 Total scrap. --
        if not VCity.Inventory_Has(ply, "scrap", cost) then VCity.Notify(ply, 2, "❌ Need " .. cost .. " scrap!") return end -- 🙅 Broke. --
        -- 🎒 Space check via dry-run give of first lot? Just attempt all. --
        VCity.Inventory_Take(ply, "scrap", cost, true) -- 🧹 Pay silently. --
        local giveN = lot * n -- 📦 Total units. --
        local left = VCity.Inventory_Give(ply, itemId, giveN, true) -- 🎒 Give. --
        if left > 0 then -- 📦 Full: refund scrap + drop goods. --
            local refundLots = math.ceil(left / lot) -- 💰 Refund. --
            VCity.Inventory_Give(ply, "scrap", price * refundLots, true) -- 💰 Refund. --
            VCity.Inventory_SpawnPickup(itemId, left, ply:GetPos() + Vector(0, 0, 30)) -- 📦 Drop. --
            VCity.Notify(ply, 0, "🎒 Full — dropped remainder.") -- 📝 Note. --
        else VCity.Notify(ply, 1, "🛒 Bought " .. ((VCity.Items[itemId] or {}).name or itemId) .. " x" .. giveN) end -- ✅ Bought. --
        VCity.Inventory_Sync(ply) -- 📡 Sync. --
    elseif op == "sell" then -- 💵 Sell mats for scrap. --
        local pay = (VCity.TraderSell or {})[itemId] -- 💰 Unit pay. --
        if not pay then VCity.Notify(ply, 2, "❌ Trader doesn't want that.") return end -- 🙅 Nope. --
        if not VCity.Inventory_Has(ply, itemId, n) then return end -- 🎒 Missing. --
        VCity.Inventory_Take(ply, itemId, n, true) -- 🧹 Take. --
        VCity.Inventory_Give(ply, "scrap", pay * n, true) -- 💰 Pay. --
        VCity.Inventory_Sync(ply) -- 📡 Sync. --
        VCity.Notify(ply, 1, "💵 Sold +" .. (pay * n) .. " scrap!") -- 📝 Confirm. --
        VCity.XP_Grant(ply, 2 * n, "trade") -- ⭐ Trade XP. --
    end
end)
