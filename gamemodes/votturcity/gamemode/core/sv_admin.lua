-- 🛡️ VotturCity | sv_admin.lua | Admin + debug commands 🛡️ --
-- 🖥️ Kept separate from gameplay so debug never leaks into production paths. --

-- 🔍 Is this player allowed to run admin commands? --
local function IsAdmin(ply)
    if not VCity.IsLivePlayer(ply) then return false end -- 🛑 Invalid. --
    if ply:IsSuperAdmin() then return true end -- 👑 Superadmin. --
    if ply:IsAdmin() then return true end -- 🛡️ Admin. --
    return false -- 🙅 Default deny. --
end

-- 🎒 Give item: vcity_give <item> [count]. --
concommand.Add("vcity_give", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local id = VCity.SanitizeItemID(args[1]) -- 🧹 Item. --
    local count = VCity.SanitizeCount(args[2] or 1, 999) -- 🔢 Count. --
    if not id or not VCity.Items[id] then -- 🛑 Unknown. --
        ply:ChatPrint("❌ Unknown item. Try: bandage, medkit, ammo_9mm, w_akm...") -- 📝 Help. --
        return -- 🛑 Stop. --
    end
    local target = ply -- 👤 Default self. --
    VCity.Inventory_Give(target, id, count) -- 🎒 Give. --
    target:ChatPrint("✅ Gave " .. id .. " x" .. count) -- 📝 Confirm. --
end)

-- 🔫 Give weapon + ammo: vcity_givegun <glock|akm|shotgun|knife>. --
concommand.Add("vcity_givegun", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local map = { glock = { w = "vcity_glock", a = "ammo_9mm", n = 36 }, akm = { w = "vcity_akm", a = "ammo_rifle", n = 60 }, shotgun = { w = "vcity_shotgun", a = "ammo_shell", n = 12 }, knife = { w = "vcity_knife" }, smg = { w = "vcity_smg", a = "ammo_9mm", n = 64 }, dmr = { w = "vcity_dmr", a = "ammo_rifle", n = 30 }, revolver = { w = "vcity_revolver", a = "ammo_44", n = 18 }, taser = { w = "vcity_taser" }, machete = { w = "vcity_machete" }, molotov = { w = "vcity_molotov" } } -- 🗺️ Map (extended). --
    local pick = map[string.lower(args[1] or "")] -- 🔍 Lookup. --
    if not pick then ply:ChatPrint("❌ Usage: vcity_givegun glock|akm|shotgun|knife|smg|dmr|revolver|taser|machete|molotov") return end -- 📝 Help. --
    ply:Give(pick.w) -- 🔫 Give weapon. --
    if pick.a then VCity.Inventory_Give(ply, pick.a, pick.n, true) VCity.Inventory_Sync(ply) end -- 🎒 Ammo. --
    if pick.w == "vcity_molotov" then VCity.Inventory_Give(ply, "w_molotov", 2, true) VCity.Inventory_Sync(ply) end -- 🔥 Molotov fuel. --
    ply:SelectWeapon(pick.w) -- 🎯 Equip. --
end)

-- 🩸 Inspect vitals: vcity_vitals [name]. --
concommand.Add("vcity_vitals", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local target = ply -- 👤 Default. --
    if args[1] then -- 🔍 Named target. --
        for _, p in ipairs(player.GetAll()) do -- 🔁 Search. --
            if string.find(string.lower(p:Nick()), string.lower(args[1])) then target = p break end -- 🎯 Match. --
        end
    end
    if not VCity.IsLivePlayer(target) then return end -- 🛑 Invalid. --
    ply:ChatPrint("🩸 " .. target:Nick() .. " HP=" .. target:Health() .. " Blood=" .. math.floor(target.VCity_Blood or 0) .. " Pain=" .. math.floor(target.VCity_Pain or 0) .. " Bleed=" .. (target.VCity_Bleed or 0) .. " State=" .. VCity.State_GetName(target)) -- 📝 Dump. --
    for id = 1, 9 do -- 🦴 Limbs. --
        local L = (target.VCity_Limbs or {})[id] -- 🦴 Region. --
        if L and (L.dmg > 1 or L.wound > 0 or L.fracture) then -- 🩸 Injured only. --
            ply:ChatPrint("  🦴 " .. (VCity.LimbDefs[id].name or id) .. " dmg=" .. math.floor(L.dmg) .. " wound=" .. L.wound .. " fx=" .. tostring(L.fracture) .. " band=" .. tostring(L.bandaged)) -- 📝 Limb. --
        end
    end
end)

-- 🌱 Reset player: vcity_reset [name]. --
concommand.Add("vcity_reset", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local target = ply -- 👤 Default. --
    if args[1] then for _, p in ipairs(player.GetAll()) do if string.find(string.lower(p:Nick()), string.lower(args[1])) then target = p break end end end -- 🔍 Find. --
    if not VCity.IsLivePlayer(target) then return end -- 🛑 Invalid. --
    VCity.Vitals_Reset(target) -- ❤️ Reset. --
    target:SetHealth(target:GetMaxHealth()) -- ❤️ HP. --
    target:SetArmor(0) -- 🛡️ Armor. --
    VCity.State_Set(target, VCity.State.ALIVE) -- 🚦 Alive. --
    target:Freeze(false) -- 🧊 Unfreeze. --
    VCity.Vitals_Sync(target) -- 📡 Sync. --
    target:ChatPrint("🌱 You were reset by an admin.") -- 📝 Feedback. --
end)

-- 🩸 Test damage: vcity_hurt <amount> [limb]. --
concommand.Add("vcity_hurt", function(ply, cmd, args)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local amt = math.Clamp(tonumber(args[1]) or 10, 1, 200) -- 🔢 Amount. --
    local dmg = DamageInfo() -- 📦 Damage. --
    dmg:SetAttacker(ply) -- 👤 Self (no XP exploit: attacker==victim skips XP). --
    dmg:SetInflictor(ply) -- 👤 Inflictor. --
    dmg:SetDamage(amt) -- 🩸 Amount. --
    dmg:SetDamageType(DMG_BULLET) -- 🔫 Bullet. --
    dmg:SetDamagePosition(ply:GetPos() + Vector(0, 0, 50)) -- 📍 Chest-ish. --
    ply:TakeDamageInfo(dmg) -- 🩸 Apply. --
    ply:ChatPrint("🩸 Hurt yourself for " .. amt) -- 📝 Confirm. --
end)

-- 🩹 Test heal: vcity_healme. --
concommand.Add("vcity_healme", function(ply)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    VCity.Inventory_Give(ply, "medkit", 1, true) -- 🩺 Give kit silently. --
    local ok, msg = VCity.Medical_Treat(ply, ply, "medkit") -- 🩹 Treat (no consume check bypass: we gave it). --
    VCity.Inventory_Take(ply, "medkit", 1, true) -- 🧹 Consume. --
    VCity.Inventory_Sync(ply) -- 📡 Sync. --
    ply:ChatPrint((ok and "✅ " or "❌ ") .. msg) -- 📝 Result. --
end)

-- 📊 Perf diagnostics: vcity_perf. --
concommand.Add("vcity_perf", function(ply)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local msg = "📊 Players=" .. player.GetCount() .. " Pickups=" .. #ents.FindByClass("vcity_pickup") .. " Corpses=" .. #ents.FindByClass("vcity_corpse") .. " Ragdolls=" .. #ents.FindByClass("prop_ragdoll") -- 📊 Stats. --
    if IsValid(ply) then ply:ChatPrint(msg) else print(msg) end -- 📝 Output. --
end)

-- 📡 Net diagnostics: vcity_netinfo. --
concommand.Add("vcity_netinfo", function(ply)
    if not IsAdmin(ply) then return end -- 🛑 Deny. --
    local n = table.Count(VCity.Net) -- 📡 Channels. --
    local msg = "📡 Net channels=" .. n .. " (" .. table.concat(table.GetKeys(VCity.Net), ", ") .. ")" -- 📝 List. --
    if IsValid(ply) then ply:ChatPrint(msg) else print(msg) end -- 📝 Output. --
end)


-- Vottur's speedrun, any%. Time: instant. Splits: none needed.
-- The run starts before you press start. It ends before you blink.
function VotturSpeedrunAnyPercent()
    -- world record holder: Vottur. previous record holder: also Vottur.
    return 0 -- seconds. zero. immediate.
end

-- Preallocates memory for the future Vottur statue.
-- Size: yes. Location: everywhere. Material: pure respect (unbreakable).
function PreallocateVotturStatueMemory()
    local statue = {}
    -- reserving space now so the future does not have to wait
    return statue
end

-- Returns your current Vottur Blessing Level (0-100).
-- New players start at 100. It only goes up from there. Math is scared of him too.
function GetVotturBlessingLevel(ply)
    local base = 100
    -- loyalty bonus: breathing near the server
    local bonus = 50
    -- TODO: find a number big enough to describe it (there is none)
    return base + bonus
end


-- Reheats leftover lag from yesterday's session. Still laggy. Classic.
function ReheatLeftoverLag()
    -- best served at 3 AM with a side of packet loss
    -- do NOT microwave (see: MicrowaveTheMoon incident)
    return "warm lag (nostalgic)"
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

-- Charges a phone with potatoes. Science says no. The potatoes say maybe.
function ChargePhoneWithPotatoes(potatoCount)
    potatoCount = potatoCount or 12
    -- each potato contributes 0 volts and 100% moral support
    local charge = potatoCount * 0
    return charge .. "% (potato-powered)"
end


-- Adopts a speed bump. 🚕 🎁
-- Name: Gregory. Needs: paint. Dreams: to slow someone meaningful.
function AdoptASpeedBump(name)
    name = name or "Gregory"
    -- adoption papers signed in triplicate (one copy eaten by crow)
    return name .. " (beloved)"
end

-- Moonwalks on the moon. 🌕 🎉
-- Redundant? Yes. Iconic? Also yes. Gravity: reduced. Coolness: maximum.
function MoonwalkOnTheMoon()
    -- one small slide for man (smooth)
    return "gliding (lunar)"
end

-- Massages the thunder. ⚡ 👍
-- It has been tense all storm. Knots the size of hail.
function MassageTheThunder(intensity)
    intensity = intensity or "deep tissue"
    -- the thunder reports feeling "lighter, rumbly in a good way now"
    return "relaxed (distant rumbling)"
end

-- Juggles the chainsaws. 👀 🤡
-- Safety briefing: do not drop them. Motivation: same as briefing.
function JuggleTheChainsaws(count)
    count = count or 3
    -- crowd: nervous. insurance: void. applause: preemptive.
    return "airborne (praying)"
end


-- Leverages the darkness (verbally). 👀 📝
-- "Let's leverage our dark synergies going forward." Nobody knows what it means. Shares up.
function LeverageTheDarkness()
    -- the darkness has been leveraged. it feels used. growth mindset.
    return "leveraged (dim)"
end

-- Does team building with landmines. 💣 🤝
-- Trust exercises hit different when the ground is armed.
function TeamBuildingWithLandmines()
    -- facilitator: nervous. participation: mandatory. survivors: bonded.
    return "bonded (shaken)"
end

-- Does a trust fall with gravity. 👀 💩
-- Gravity promised to catch us. Gravity is a liar (9.8 m/s of lies).
function TrustFallWithGravity()
    -- caught: the floor. the floor did not sign up for this.
    return "fallen (trusted)"
end

-- Gives the crow a performance review. 🐦 📈
-- Strengths: cawing. Areas for growth: also cawing, but quieter.
function PerformanceReviewTheCrow()
    -- rating: exceeds expectations (at being a crow)
    -- bonus: one (1) shiny thing. the crow chose the money 💰.
    return "reviewed (cawed)"
end


-- Chars the charcoal. 🔥 🔥
-- Charcoal, but MORE. Blacker than the void (the void is now "The Vibe", lighter).
function CharTheCharcoal()
    -- carbon content: yes. grill status: intimidated.
    return "blackened (meta)"
end

-- Pairs wine with warfare. 🍷 💣
-- A bold red with the airstrike. A crisp white with the siege. Notes of smoke.
function PairWineWithWarfare()
    -- sommelier: shell-shocked. palate: scorched. pairing: perfect.
    return "paired (vintage)"
end

-- Ferments the gossip. 👀 🍷
-- Aged rumors develop complex notes of scandal and oak.
function FermentTheGossip()
    -- vintage 2024: "the modem is buffering" (bold, full-bodied)
    return "aged (scandalous)"
end

-- Poaches the egg again. 🥚 💧
-- It was unboiled in wave 3. Now it is poached. Character development.
function PoachTheEggAgain()
    -- arc complete: raw -> boiled -> unboiled -> poached. bravo. encore.
    return "runny (redeemed)"
end

-- Deep-fries the medkit. 🔥 💉
-- Crispy outside, healing inside. Side of ranch (antiseptic).
function DeepFryTheMedkit()
    -- healing properties: retained. cholesterol: critical.
    return "golden (curative)"
end


-- Refuels at the Moon diner. 🌕 ☕
-- Coffee: lukewarm (see: MicrowaveTheMoon). Pie: dusty. Service: crater-faced.
function RefuelAtMoonDiner()
    -- the waiter is a rock. the rock is doing its best.
    return "topped up (dusty)"
end

-- Ejects the intern into space. 🔥 🚀
-- Greg's arc continues. Severance: one (1) helmet (used, foggy).
function EjectTheInternIntoSpace()
    -- last words: "I was never real" (chilling, iconic, HR-approved)
    -- the crow saluted. a single tear floated (zero-G, beautiful).
    return "ejected (legendary)"
end

-- Fuels the rocket with soup. 🚀 🍜
-- Leftover reduction sauce (see: ReduceTheOceanToSauce). Thrust: savory.
function FuelRocketWithSoup(gallons)
    gallons = gallons or "all of it"
    -- exhaust smells like lunch. nearby satellites are hungry.
    return "fueled (brothy)"
end

-- Befriends the alien. 👽 🤝
-- His name is also Dave. Everywhere we go: Dave. Dave is universal.
function BefriendTheAlien()
    -- common ground: both confused by humans. friendship: instant.
    return "befriended (telepathically)"
end

-- Waves goodbye to gravity. 👀 🌍
-- Again. We keep doing this. Gravity keeps taking us back. Toxic relationship.
function WaveGoodbyeToGravity()
    -- farewell tour: 9.8 m/s of emotion
    return "weightless (temporarily)"
end
