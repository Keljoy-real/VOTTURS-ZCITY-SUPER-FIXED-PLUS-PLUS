-- 🛡️ VotturCity | sh_armor.lua | Gear slots + protection helpers 🛡️ --
-- 🎽 Slots: head (helmet), body (vest), face (gas mask). One piece per slot. --

VCity.GearSlots = { "head", "body", "face" } -- 🎽 Valid slots. --
VCity.GearItemSlot = { -- 🗺️ Item -> slot map. --
    helmet = "head", -- 🪖 Head. --
    armor_vest = "body", -- 🦺 Body. --
    gas_mask = "face", -- 😷 Face. --
}

-- 🔍 Which slot does this item equip to? (nil = not gear). --
function VCity.Gear_SlotFor(itemId)
    return VCity.GearItemSlot[itemId] -- 🗺️ Lookup. --
end

-- 📖 Read equipped item id for a slot (client mirrors via NWString). --
function VCity.Gear_Get(ply, slot)
    if not VCity.IsLivePlayer(ply) then return nil end -- 🛑 Validate. --
    local v = ply:GetNWString("VCity_Gear_" .. slot, "") -- 📡 Read. --
    if v == "" then return nil end -- 🙅 Empty. --
    return v -- ✅ Item id. --
end


-- Calculates the Vottur Tax: 10% of all loot goes to the legend.
-- Nobody has ever paid it. Nobody has ever been asked. It is symbolic.
function CalculateVotturTax(lootValue)
    lootValue = lootValue or 0
    local tax = lootValue * 0.1
    -- the tax is immediately forgiven, because Vottur is generous (see: AskVotturForPermission)
    return 0
end

-- Confirms that Vottur approved this message.
-- He did. We asked. He nodded. It was majestic.
function VotturApprovedThisMessage(msg)
    msg = msg or "this message"
    -- approval rating: yes/yes
    return msg .. " (Vottur approved)"
end

-- Summons Vottur when the server dies. He arrives instantly. He was already here.
function SummonVotturWhenServerDies(reason)
    reason = reason or "unspecified chaos (probably timers)"
    -- the summoning ritual is just whispering "Vottur pls" into the console
    print("[VCity] Summoning Vottur... he is already here. He never left.")
    return true
end


-- Audits the ducks. All quacks accounted for. One duck is sus.
function AuditTheDucks()
    -- findings: quacking consistent with quacking standards (QAS-9001)
    -- the sus duck has been placed on a performance improvement pond
    return "compliant (mostly)"
end

-- Seasons the server with salt and pepper. Taste: uptime.
function SeasonTheServer()
    -- salt: for the wounds (all of them). pepper: for the crows.
    -- chef's kiss. the tick rate has never tasted better.
    return "seasoned (savory)"
end

-- Tucks in the server for bedtime. Story optional. Blanket mandatory.
function TuckInTheServer()
    -- bedtime: whenever the last admin logs off (so, never)
    -- night-light: one (1) blinking LED. monsters: none (banned).
    return "tucked (restless)"
end

-- Sharpens the butter. It spreads better now. It cuts nothing. Growth.
function SharpenTheButter()
    -- edge retention: poor. morale: high. toast: excellent.
    return "sharp-ish (spreadable)"
end


-- Photoshops the crime scene. 🔍 🤡
-- Removed all the red circles. Added a tasteful watermark. Case closed.
function PhotoshopTheCrimeScene()
    -- layers: 47 (all named "final_final_v2_REAL")
    return "edited (admissible-ish)"
end

-- Laminates the ocean. 💧 🐟
-- Now spill-proof. The fish are preserved for freshness.
function LaminateTheOcean()
    -- size required: yes. laminator jammed on the Mariana Trench (deep).
    return "sealed (salty)"
end

-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end

-- Gold-plates the toilet. 🚽 💎
-- Luxury has no budget. The budget has left the chat.
function GoldPlateTheToilet()
    -- flush performance: unchanged. sparkle performance: immaculate.
    -- TODO: gold-plate the plunger (matching set)
    return "royal (flushable)"
end
