-- 🤝 VotturCity | sv_interact.lua | Server interaction executor 🤝 --
-- 🖥️ All E-presses route here; server re-traces + validates (no client trust). --

-- 🚪 Toggle door helper (only unlocked doors). --
local function ToggleDoor(ply, door)
    if not IsValid(door) then return end -- 🛑 Invalid. --
    -- 🔒 Locked doors can't be toggled (prop protection compat). --
    if door.GetInternalVariable and door:GetInternalVariable("m_bLocked") then -- 🔒 Locked. --
        VCity.Notify(ply, 2, "🔒 Door is locked.") -- 📝 Feedback. --
        return -- 🛑 Stop. --
    end
    door:Fire("Toggle", "", 0) -- 🚪 Toggle. --
    ply:EmitSound("doors/door_movement.wav", 50, 100) -- 🔊 Cue. --
end

-- 📥 Client -> server: "I pressed E on entity X". --
net.Receive(VCity.Net.INTERACT, function(_, ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    if not ply:Alive() then return end -- 💀 Dead can't. --
    if not VCity.State_CanAct(ply) then return end -- 🛑 Busy/down. --
    -- ⏱️ Rate limit interactions (3/sec max). --
    if not VCity.Throttled("Interact_" .. ply:SteamID64(), 0.33) then return end -- ⏱️ Throttle. --
    local ent = net.ReadEntity() -- 🎯 Claimed target. --
    if not IsValid(ent) then return end -- 🛑 Invalid. --
    -- 🔍 SERVER RE-TRACE: verify player actually aims at this entity nearby. --
    local start = ply:GetShootPos() -- 📍 Eyes. --
    local tr = util.TraceLine({ -- 🔍 Trace. --
        start = start, -- 📍 From. --
        endpos = start + ply:GetAimVector() * 130, -- 📍 Reach (+20 tolerance). --
        filter = ply, -- 🙅 Self. --
        mask = MASK_SHOT_HULL, -- 🎯 Hull. --
    })
    if tr.Entity ~= ent then -- 🎯 Mismatch: client lied or moved. --
        -- 🛟 Fallback: allow if entity is within 100 units anyway (lag tolerance). --
        if ent:GetPos():DistToSqr(ply:GetPos()) > (110 ^ 2) then return end -- 🛑 Too far. --
    end
    -- 📏 Hard range gate. --
    if ent:GetPos():DistToSqr(ply:GetPos()) > (130 ^ 2) then return end -- 🛑 Too far. --

    local cls = ent:GetClass() -- 🏷️ Class. --
    if ent:IsPlayer() then -- 👤 Player interaction opens treat hint (actual treat via medical menu). --
        VCity.Notify(ply, 0, "🩹 Open inventory (I) -> select treatment, or press H for medical menu.") -- 📝 Hint. --
        return -- ✅ Done (treatment executed via TREAT_OTHER channel). --
    end
    if cls == "vcity_pickup" then -- 📦 Pickup: delegate to entity Use. --
        ent:Use(ply, ply) -- 🤝 Use. --
        return -- ✅ Done. --
    end
    if cls == "vcity_corpse" then -- 💀 Corpse search. --
        ent:Use(ply, ply) -- 🤝 Use. --
        return -- ✅ Done. --
    end
    if cls == "vcity_crate" or cls == "vcity_medstation" or cls == "vcity_trader" or cls == "vcity_campfire" or cls == "vcity_bed" or cls == "vcity_airdrop" then -- 📦 Usable stations/events. --
        ent:Use(ply, ply) -- 🤝 Use. --
        return -- ✅ Done. --
    end
    if string.find(cls, "door") then -- 🚪 Door. --
        ToggleDoor(ply, ent) -- 🚪 Toggle. --
        return -- ✅ Done. --
    end
    -- 🙅 Unknown entity: ignore silently (no error spam). --
end)
