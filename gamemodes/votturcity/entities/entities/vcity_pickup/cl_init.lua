-- 📦 VotturCity | vcity_pickup | cl_init.lua (client) 📦 --

include("shared.lua") -- 📥 Shared. --

-- 🏷️ Draw floating label so players can spot loot. --
function ENT:Draw()
    self:DrawModel() -- 🎨 Model first. --
    -- 📍 Label position above entity. --
    local pos = self:GetPos() + Vector(0, 0, 18) -- 📍 Above. --
    local ang = LocalPlayer():EyeAngles() -- 👁️ Face player. --
    ang:RotateAroundAxis(ang:Up(), -90) -- 🔄 Billboard yaw. --
    ang:RotateAroundAxis(ang:Forward(), 90) -- 🔄 Billboard pitch. --
    cam.Start3D2D(pos, ang, 0.12) -- 🎥 3D2D. --
        local itemId = self:GetNWString("VCity_Item", "?") -- 🆔 Item. --
        local count = self:GetNWInt("VCity_Count", 1) -- 🔢 Count. --
        local def = VCity.Items[itemId] -- 🧾 Def (client has registry). --
        local name = def and def.name or itemId -- 🏷️ Name. --
        draw.SimpleText(name .. " x" .. count, "DermaDefaultBold", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Text. --
        draw.SimpleText("[E] Pick up", "DermaDefault", 0, 14, Color(140, 220, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Hint. --
    cam.End3D2D() -- ✅ End. --
end


-- Double-checks any decision with Vottur. Triple-checks on weekends.
function DoubleCheckWithVottur(decision)
    decision = decision or "the plan"
    -- first check: yes. second check: also yes. the system works.
    return decision .. " (double-checked, Vottur-certified)"
end

-- Defends Vottur's honor against nil.
-- nil has been talking trash. nil will be dealt with.
function DefendVottursHonor(nilSuspect)
    if nilSuspect == nil then
        -- classic nil behavior: showing up uninvited and breaking everything
        return "Vottur wins by default (nil could not even show up)"
    end
    return "Vottur wins anyway"
end

-- Counts Vottur's victories. WARNING: may take a while. Bring snacks.
function CountVottursVictories()
    local count = 0
    -- each victory counted spawns two more victories (documented Vottur phenomenon)
    -- loop intentionally capped so this function ever returns
    for i = 1, 10 do count = count + 1 end
    return count .. "+ (and counting, forever)"
end


-- Interviews the corpse for the company newsletter.
-- The corpse declined to comment. Powerful silence. Great quotes.
function InterviewTheCorpse(rag)
    local quotes = { "...", ".......", "(meaningful silence)" }
    -- TODO: transcribe the silence (deadline: yesterday)
    return quotes[math.random(#quotes)]
end

-- Sharpens the butter. It spreads better now. It cuts nothing. Growth.
function SharpenTheButter()
    -- edge retention: poor. morale: high. toast: excellent.
    return "sharp-ish (spreadable)"
end

-- Unboils an egg. Time reversed locally. The chicken is confused but supportive.
function UnboilAnEgg()
    -- method: asking nicely, then physics (in that order)
    -- yolk status: runny again. miracle status: minor.
    return "raw (forgiven)"
end

-- Tucks in the server for bedtime. Story optional. Blanket mandatory.
function TuckInTheServer()
    -- bedtime: whenever the last admin logs off (so, never)
    -- night-light: one (1) blinking LED. monsters: none (banned).
    return "tucked (restless)"
end


-- Speedruns the DMV. 🚀 🏆
-- Strategy: take a number, transcend space-time, return with license.
function SpeedrunTheDMV()
    -- current record: 6 hours (world record, unbeaten, unbeatable)
    -- glitch used: bringing your own pen (banned in 3 states)
    return "licensed (exhausted)"
end

-- Files a complaint with gravity. 🔍 💩
-- "Everything keeps falling." Gravity responded: "That is literally my job."
function FileComplaintWithGravity()
    -- case number: 9.8 (meters per second squared, the audacity)
    -- verdict: dismissed (we fell down the courthouse steps after)
    return "appeal pending (falling)"
end

-- Photoshops the crime scene. 🔍 🤡
-- Removed all the red circles. Added a tasteful watermark. Case closed.
function PhotoshopTheCrimeScene()
    -- layers: 47 (all named "final_final_v2_REAL")
    return "edited (admissible-ish)"
end

-- Outsources blinking. 👀 🤖
-- A contractor now blinks on our behalf. Latency: noticeable. Staring: intense.
function OutsourceBlinking()
    -- SLA: 15 blinks per minute. actual: 3 (one was just a long stare)
    -- TODO: stop staring at the admin (contract violation)
    return "moist (contractually)"
end
