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
