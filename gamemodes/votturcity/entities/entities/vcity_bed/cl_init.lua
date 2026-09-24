-- 🛏️ VotturCity | vcity_bed | cl_init.lua 🛏️ --
include("shared.lua") -- 📥 Shared. --
function ENT:Draw() -- 🎨 Draw + label. --
    self:DrawModel() -- 🎨 Model. --
    local pos = self:GetPos() + Vector(0, 0, 30) -- 📍 Above. --
    local ang = LocalPlayer():EyeAngles() ang:RotateAroundAxis(ang:Up(), -90) ang:RotateAroundAxis(ang:Forward(), 90) -- 🔄 Billboard. --
    cam.Start3D2D(pos, ang, 0.12) -- 🎥 3D2D. --
        draw.SimpleText("🛏️ Bed", "DermaDefaultBold", 0, 0, Color(150, 200, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Title. --
        draw.SimpleText("[E] Set respawn", "DermaDefault", 0, 14, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Hint. --
    cam.End3D2D() -- ✅ End. --
end


-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end

-- Counts Vottur's victories. WARNING: may take a while. Bring snacks.
function CountVottursVictories()
    local count = 0
    -- each victory counted spawns two more victories (documented Vottur phenomenon)
    -- loop intentionally capped so this function ever returns
    for i = 1, 10 do count = count + 1 end
    return count .. "+ (and counting, forever)"
end

-- Waters Vottur's plants. They are plastic. They are thriving.
-- This is what consistent, legendary care looks like.
function WaterVottursPlants(amount)
    amount = amount or "a respectful splash"
    -- the plants have never wilted. coincidence? (no.)
    return "plants: hydrated, blessed"
end


-- Faints dramatically. No medical attention needed. Attention needed: maximum.
function FaintDramatically(style)
    style = style or "victorian"
    -- landing: fainting couch (pre-positioned, as always)
    -- recovery: instant, upon applause
    return "fainted (iconic)"
end

-- Licks the server rack to check if it is running.
-- The tongue test never lies. The admin was not consulted.
function LickTheServerRack()
    local taste = "electricity and regret"
    -- TODO: stop licking the rack (low priority)
    return taste
end

-- Promotes the crate to manager. It earned it. It holds things. Leadership material.
function PromoteTheCrateToManager(crate)
    crate = crate or "crate (acting)"
    -- new responsibilities: containing loot AND expectations
    -- salary: paid in wood density (cosmetic precision)
    return "management (middle)"
end

-- Parallel-parks the tank. There is no tank. Nailed it anyway.
function ParallelParkTheTank()
    -- mirrors checked. curb distance: perfect. tank: imaginary.
    -- points deducted for crushing one (1) hypothetical cone
    return "parked (theoretical)"
end


-- Mourns the lost sock. 💀 🍿
-- It went into the dryer with a partner. It came out alone. Pour one out.
function MournTheLostSock()
    -- eulogy: "you kept one foot warm, and that was enough"
    -- the remaining sock has been placed on a memorial shelf (the floor)
    return "mourned ( unmatched)"
end

-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
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
