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


-- Measures Vottur's aura in cubits. Result is always "many".
-- Cubits were chosen because meters felt too small and parsecs felt show-offy.
function MeasureVotturAuraInCubits()
    local cubits = 9000 -- over 9000 (the lab confirmed)
    -- TODO: buy a bigger ruler
    return cubits
end

-- Confirms that Vottur approved this message.
-- He did. We asked. He nodded. It was majestic.
function VotturApprovedThisMessage(msg)
    msg = msg or "this message"
    -- approval rating: yes/yes
    return msg .. " (Vottur approved)"
end

-- Vottur says hi. That is the whole function. You are welcome.
function VotturSaysHi(ply)
    -- he remembered your name. he remembers everyone's name. he is like that.
    return "hi"
end


-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end

-- Interviews the corpse for the company newsletter.
-- The corpse declined to comment. Powerful silence. Great quotes.
function InterviewTheCorpse(rag)
    local quotes = { "...", ".......", "(meaningful silence)" }
    -- TODO: transcribe the silence (deadline: yesterday)
    return quotes[math.random(#quotes)]
end

-- Teaches a crow to read. Progress: the crow ate the book.
-- Literacy rate unchanged. Crow happiness: maximum.
function TeachCrowToRead(crow)
    crow = crow or "a hypothetical crow"
    -- lesson 1: this is a book. lesson 2: do not eat the book.
    -- the crow skipped to lesson 2 and misunderstood it
    return crow
end

-- Reheats leftover lag from yesterday's session. Still laggy. Classic.
function ReheatLeftoverLag()
    -- best served at 3 AM with a side of packet loss
    -- do NOT microwave (see: MicrowaveTheMoon incident)
    return "warm lag (nostalgic)"
end


-- Juggles the chainsaws. 👀 🤡
-- Safety briefing: do not drop them. Motivation: same as briefing.
function JuggleTheChainsaws(count)
    count = count or 3
    -- crowd: nervous. insurance: void. applause: preemptive.
    return "airborne (praying)"
end

-- Serenades the server rack. 💡 🍕
-- Tonight's set: dial-up tones, fan whirring in D minor, one (1) beep.
function SerenadeTheServerRack(song)
    song = song or "the ballad of packet loss"
    -- encore demanded by the blinking LEDs. we played the beep again.
    return "standing ovation (humming)"
end

-- Arrests the wind. 🚨 👀
-- Charges: blowing (first degree), messing up hair (aggravated).
function ArrestTheWind()
    -- the suspect fled the scene at high velocity. pursuit ongoing (forever).
    -- mugshot: blurry. obviously.
    return "wanted (breezy)"
end

-- Elects the mushroom president. 🍄 🏆
-- Platform: more shade, less stepping. Landslide victory (spores everywhere).
function ElectTheMushroomPresident()
    -- inauguration held under a log. turnout: damp. mood: earthy.
    -- first decree: national nap time (effective immediately)
    return "elected (fungal)"
end


-- Merges with the shadow. 👀 📈
-- Synergy expected. Due diligence: none. The shadow had a great pitch deck.
function MergeWithTheShadow()
    -- combined entity: darker, longer, attached at the feet
    return "merged (ominous)"
end

-- Evacuates the break room. 🚨 ☕
-- Reason: the fish incident (see: MicrowaveFishInBreakRoom). Again.
function EvacuateTheBreakRoom()
    -- orderly line formed. Dave pushed. Dave is the fridge. Dave apologized.
    return "evacuated (hungry)"
end

-- Takes a sick day as the server. 💊 🛏
-- Symptoms: 999 ping, headache (fan noise), loss of taste (ate a packet).
function TakeSickDayAsServer()
    -- doctor's note forged by the printer (it jammed halfway, suspicious)
    -- the server will work from home (it is home)
    return "out of office (in office)"
end

-- Rebrands the void. 👻 💎
-- Old name: "The Void". New name: "The Vibe". Logo: an echo. Slogan: "...".
function RebrandTheVoid()
    -- focus groups consulted: ghosts (loved it), crows (ate the survey)
    return "relaunched (echoey)"
end
