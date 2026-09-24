-- 🤝 VotturCity | sh_interact.lua | Unified interaction registry 🤝 --
-- 🎯 ONE system for players, corpses, doors, crates, stations, loot. --

VCity.Interact = VCity.Interact or {} -- 📦 Registry. --

-- 📝 Register an interaction type with prompt + validator. --
-- 🧾 def = { prompt = "Search", range = 90, fn = serverFn } --
function VCity.Interact_Register(kind, def)
    VCity.Interact[kind] = def -- 📦 Store. --
end

-- 🚪 Default registrations (prompts only; logic server-side). --
VCity.Interact_Register(VCity.InteractKind.PICKUP, { prompt = "Pick up", range = 90 }) -- 🙌 Loot. --
VCity.Interact_Register(VCity.InteractKind.SEARCH_CORPSE, { prompt = "Search corpse", range = 90 }) -- 💀 Corpse. --
VCity.Interact_Register(VCity.InteractKind.OPEN_CRATE, { prompt = "Open crate", range = 90 }) -- 📦 Crate. --
VCity.Interact_Register(VCity.InteractKind.REVIVE, { prompt = "Revive (needs defib)", range = 120 }) -- ⚡ Revive. --
VCity.Interact_Register(VCity.InteractKind.TREAT, { prompt = "Treat (bandage)", range = 90 }) -- 🩹 Treat. --
VCity.Interact_Register(VCity.InteractKind.USE_STATION, { prompt = "Use station", range = 90 }) -- 🏥 Station. --
VCity.Interact_Register(VCity.InteractKind.DOOR, { prompt = "Toggle door", range = 90 }) -- 🚪 Door. --

-- 🔍 Client-side: figure out what the player is looking at (no net needed). --
function VCity.Interact_Trace(ply)
    if not VCity.IsLivePlayer(ply) then return nil end -- 🛑 Validate. --
    local start = ply:GetShootPos() -- 📍 Eyes. --
    local dir = ply:GetAimVector() -- 🎯 Aim. --
    local tr = util.TraceLine({ -- 🔍 Trace. --
        start = start, -- 📍 From. --
        endpos = start + dir * 110, -- 📍 110 units reach. --
        filter = ply, -- 🙅 Ignore self. --
        mask = MASK_SHOT_HULL, -- 🎯 Hit entities. --
    })
    if not tr.Hit or not IsValid(tr.Entity) then return nil end -- 🙅 Nothing. --
    return tr.Entity, tr.HitPos -- ✅ Entity + pos. --
end

-- 🏷️ Classify an entity into an interaction kind (client prompt logic). --
function VCity.Interact_Classify(ply, ent)
    if not IsValid(ent) then return nil end -- 🛑 Invalid. --
    local cls = ent:GetClass() -- 🏷️ Class. --
    if ent:IsPlayer() then -- 👤 Player. --
        if ent == ply then return nil end -- 🙅 Self. --
        if not ent:Alive() then return nil end -- 💀 Dead handled by corpse. --
        if VCity.State_Get(ent) == VCity.State.UNCONSCIOUS then -- 😵 KO. --
            return VCity.InteractKind.REVIVE, "⚡ Revive " .. ent:Nick() -- ⚡ Revive prompt. --
        end
        return VCity.InteractKind.TREAT, "🩹 Treat " .. ent:Nick() -- 🩹 Treat prompt. --
    end
    if cls == "vcity_pickup" then -- 📦 Pickup. --
        local itemId = ent:GetNWString("VCity_Item", "?") -- 🆔 Item. --
        local def = VCity.Items[itemId] -- 🧾 Def. --
        return VCity.InteractKind.PICKUP, "🙌 Take " .. (def and def.name or itemId) -- 🙌 Prompt. --
    end
    if cls == "vcity_corpse" then -- 💀 Corpse. --
        return VCity.InteractKind.SEARCH_CORPSE, "💀 Search " .. ent:GetNWString("VCity_Owner", "corpse") -- 💀 Prompt. --
    end
    if cls == "vcity_crate" then -- 📦 Crate. --
        return VCity.InteractKind.OPEN_CRATE, "📦 Open crate" -- 📦 Prompt. --
    end
    if cls == "vcity_medstation" then -- 🏥 Station. --
        return VCity.InteractKind.USE_STATION, "🏥 Use station (" .. ent:GetNWInt("VCity_Charges", 0) .. ")" -- 🏥 Prompt. --
    end
    if string.find(cls, "door") then -- 🚪 Door. --
        return VCity.InteractKind.DOOR, "🚪 Use door" -- 🚪 Prompt. --
    end
    return nil -- 🙅 Not interactable. --
end
