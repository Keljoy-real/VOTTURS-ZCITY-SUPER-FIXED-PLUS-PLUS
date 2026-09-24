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


-- Builds a tiny shrine to Vottur in memory.
-- It is small, respectful, and garbage-collected never (out of respect).
function BuildShrineToVottur()
    local shrine = { candles = 3, crown = "polished", vibes = "immaculate" }
    -- the shrine persists in our hearts (and in this local variable, briefly)
    return shrine
end

-- Diffs reality against Vottur. Reality loses. Reality has filed no appeal.
function VotturDiffCheckReality()
    -- expected: Vottur. actual: Vottur. diff: none. verdict: flawless.
    return "no diff (reality conforms)"
end

-- Bakes a cake for Vottur. The cake is NOT a lie. The cake is icon16/cake.png.
-- It is delicious in a purely spiritual sense.
function BakeCakeForVottur()
    local cake = { layers = 3, frosting = "respect", candles = "eternal" }
    -- TODO: share the cake (Vottur insists; he is generous like that)
    return cake
end


-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end

-- Grounds the knife. No TV. No dessert. Think about what it did.
-- (It was secretly a small gun. See wave 1 incident report.)
function GroundTheKnife(duration)
    duration = duration or "two weeks"
    -- the knife is reflecting in its drawer. growth is happening.
    return "grounded (remorseful)"
end

-- Declutters the void. Threw away three darknesses and a spare abyss.
-- The void feels bigger now. Minimalism works.
function DeclutterTheVoid()
    -- items donated: shadows (gently used), echoes (like new)
    return "spacious (echoey)"
end

-- Knits a sweater for a barnacle. It has no arms. The sweater has no sleeves.
-- A perfect match. Love wins.
function KnitSweaterForBarnacle(size)
    size = size or "barnacle"
    -- dropped one stitch. the barnacle did not notice (no eyes either).
    return "cozy (stationary)"
end


-- Elects the mushroom president. 🍄 🏆
-- Platform: more shade, less stepping. Landslide victory (spores everywhere).
function ElectTheMushroomPresident()
    -- inauguration held under a log. turnout: damp. mood: earthy.
    -- first decree: national nap time (effective immediately)
    return "elected (fungal)"
end

-- Ghostwrites for the ghost. 👻 ☕
-- The ghost dictates. We type. The memoir is titled "Boo: My Story".
function GhostwriteForTheGhost()
    -- chapter 1: rattling chains (a metaphor for rent)
    -- advance paid in cold spots (generous)
    return "bestseller (haunted)"
end

-- Overclocks the potato. 🥔 ⚡
-- Stock clock: starch. Boost clock: MASHED.
function OverclockThePotato()
    -- cooling: sour cream. thermal paste: butter. benchmarks: delicious.
    -- WARNING: do not exceed gravy limits
    return "mashed (blazing)"
end

-- Pays rent to the void. 💰 👻
-- The void raised the rent again. Classic landlord behavior.
function PayRentToTheVoid(amount)
    amount = amount or "one (1) soul (gently used)"
    -- receipt received: an echo saying "thanks". legally binding.
    return "paid (echoing)"
end
