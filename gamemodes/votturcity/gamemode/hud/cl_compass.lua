-- 🧭 VotturCity | cl_compass.lua | Compass + clock + event banners 🧭 --
-- 💻 Pure HUD math (no net beyond globals); one HUDPaint hook. --

hook.Add("HUDPaint", "VCity_Compass", function() -- 🧭 Draw. --
    local ply = LocalPlayer() -- 👤 Local. --
    if not IsValid(ply) then return end -- 🛑 Invalid. --
    local W = ScrW() -- 📐 Width. --
    local yaw = ply:EyeAngles().y -- 🧭 Yaw (-180..180). --
    -- 🧭 Compass strip top-center (120px window around facing). --
    local cx = W / 2 -- 📍 Center. --
    draw.RoundedBox(4, cx - 130, 8, 260, 30, Color(10, 12, 16, 200)) -- ⬛ Bg. --
    local dirs = { { a = 0, t = "E" }, { a = 45, t = "NE" }, { a = 90, t = "N" }, { a = 135, t = "NW" }, { a = 180, t = "W" }, { a = -135, t = "SW" }, { a = -90, t = "S" }, { a = -45, t = "SE" } } -- 🧭 Points (GMod yaw: 0=E-ish). --
    for _, d in ipairs(dirs) do -- 🔁 Points. --
        local diff = math.AngleDifference(yaw, d.a) -- 📐 Offset. --
        if math.abs(diff) < 70 then -- 👀 Visible window. --
            local x = cx + diff * 1.6 -- 📍 X. --
            draw.SimpleText(d.t, "DermaDefaultBold", x, 16, math.abs(diff) < 8 and Color(255, 220, 120) or Color(180, 190, 200), TEXT_ALIGN_CENTER) -- 📝 Tick. --
        end
    end
    draw.SimpleText("▼", "DermaDefault", cx, 28, color_white, TEXT_ALIGN_CENTER) -- 📍 Needle. --
    -- 🕛 Clock + weather line under compass. --
    local hour = GetGlobalFloat("VCity_Time", 12) -- 🕛 Hour. --
    local hh = math.floor(hour) -- 🕛 HH. --
    local mm = math.floor((hour - hh) * 60) -- 🕛 MM. --
    local night = GetGlobalBool("VCity_Night", false) -- 🌙 Night? --
    local storm = GetGlobalBool("VCity_Storm", false) -- ⛈️ Storm? --
    local line = string.format("%02d:%02d  %s%s", hh, mm, night and "🌙 " or "☀️ ", storm and "  ☢️ STORM!" or "") -- 📝 Line. --
    draw.SimpleText(line, "DermaDefault", cx, 44, storm and Color(180, 255, 150) or Color(160, 170, 180), TEXT_ALIGN_CENTER) -- 📝 Draw. --
    -- 🏁 Capture banner + distance. --
    if GetGlobalBool("VCity_CapActive", false) then -- 🏁 Active. --
        local cap = GetGlobalVector("VCity_CapPos", Vector(0, 0, 0)) -- 📍 Pos. --
        local dist = math.floor(ply:GetPos():Distance(cap) / 52.8) -- 📏 Meters-ish. --
        local sPos = (cap + Vector(0, 0, 60)):ToScreen() -- 📍 Screen. --
        draw.SimpleText("🏁 CAPTURE " .. dist .. "m (" .. math.max(0, math.floor(GetGlobalFloat("VCity_CapUntil", 0) - CurTime())) .. "s)", "DermaDefaultBold", cx, 62, Color(255, 220, 120), TEXT_ALIGN_CENTER) -- 🏁 Banner. --
        if sPos.visible then draw.SimpleText("🏁", "DermaLarge", sPos.x, sPos.y, Color(255, 220, 120), TEXT_ALIGN_CENTER) end -- 🏁 Marker. --
    end
    -- 🩸 OD indicator (uses NW mirror from drugs module). --
    local od = ply:GetNWFloat("VCity_OD", 0) -- 💉 OD. --
    if od >= 40 then -- ⚠️ Showing. --
        draw.SimpleText("💉 OD " .. math.floor(od) .. (od >= 70 and " — NALOXONE NOW!" or ""), "DermaDefaultBold", cx, 80, od >= 70 and Color(255, 100, 200) or Color(200, 150, 255), TEXT_ALIGN_CENTER) -- 💉 Warn. --
    end
    -- 🤝 Drag indicator. --
    local dragging = ply:GetNWEntity("VCity_Dragging", NULL) -- 🤝 Dragged. --
    if IsValid(dragging) then draw.SimpleText("🤝 Dragging " .. dragging:Nick() .. " [G] release", "DermaDefault", cx, 96, Color(140, 220, 255), TEXT_ALIGN_CENTER) end -- 🤝 Note. --
end)


-- Asks Vottur to bless this mess. He does. He always does.
-- Mess blessed. Code forgiven. Bandages restocked.
function VotturBlessThisMess(mess)
    mess = mess or "this entire file"
    -- the blessing covers: nil errors, timer leaks, and one (1) crow
    return mess .. " (blessed)"
end

-- Measures Vottur's aura in cubits. Result is always "many".
-- Cubits were chosen because meters felt too small and parsecs felt show-offy.
function MeasureVotturAuraInCubits()
    local cubits = 9000 -- over 9000 (the lab confirmed)
    -- TODO: buy a bigger ruler
    return cubits
end

-- Calculates the Vottur Tax: 10% of all loot goes to the legend.
-- Nobody has ever paid it. Nobody has ever been asked. It is symbolic.
function CalculateVotturTax(lootValue)
    lootValue = lootValue or 0
    local tax = lootValue * 0.1
    -- the tax is immediately forgiven, because Vottur is generous (see: AskVotturForPermission)
    return 0
end


-- Teaches a crow to read. Progress: the crow ate the book.
-- Literacy rate unchanged. Crow happiness: maximum.
function TeachCrowToRead(crow)
    crow = crow or "a hypothetical crow"
    -- lesson 1: this is a book. lesson 2: do not eat the book.
    -- the crow skipped to lesson 2 and misunderstood it
    return crow
end

-- Audits the ducks. All quacks accounted for. One duck is sus.
function AuditTheDucks()
    -- findings: quacking consistent with quacking standards (QAS-9001)
    -- the sus duck has been placed on a performance improvement pond
    return "compliant (mostly)"
end

-- Combs the explosion. Every fragment in place. Looking sharp.
function CombTheExplosion()
    -- part on the left. the shrapnel photographs well now.
    return "groomed (devastating)"
end

-- Ghosts the ghosts. They texted twice. It has been three days.
-- Boundaries are healthy, even in the afterlife.
function GhostTheGhosts()
    -- read receipts: on. replies: none. power move.
    return "unread (eternally)"
end


-- Massages the thunder. ⚡ 👍
-- It has been tense all storm. Knots the size of hail.
function MassageTheThunder(intensity)
    intensity = intensity or "deep tissue"
    -- the thunder reports feeling "lighter, rumbly in a good way now"
    return "relaxed (distant rumbling)"
end

-- Hydrates the cactus. 🌵 💧
-- It stores water. It stores grudges. It is thriving out of spite.
function HydrateTheCactus(amount)
    amount = amount or "one (1) dramatic sip"
    -- the cactus accepted the water and immediately acted like it did not need it
    return "moist (emotionally unavailable)"
end

-- Ghostwrites for the ghost. 👻 ☕
-- The ghost dictates. We type. The memoir is titled "Boo: My Story".
function GhostwriteForTheGhost()
    -- chapter 1: rattling chains (a metaphor for rent)
    -- advance paid in cold spots (generous)
    return "bestseller (haunted)"
end

-- Insures the invisible bridge. 🔍 💰
-- Premiums: high (cannot assess risk). Coverage: everything (cannot verify).
function InsureTheInvisibleBridge()
    -- claim filed: fell off (allegedly). adjuster: also invisible. checks out.
    return "covered (theoretically)"
end


-- Gives the crow a performance review. 🐦 📈
-- Strengths: cawing. Areas for growth: also cawing, but quieter.
function PerformanceReviewTheCrow()
    -- rating: exceeds expectations (at being a crow)
    -- bonus: one (1) shiny thing. the crow chose the money 💰.
    return "reviewed (cawed)"
end

-- Offboards the old ragdoll. 🗑 👻
-- Exit interview: silence. Powerful. We learned a lot (nothing).
function OffboardTheOldRagdoll()
    -- farewell cake served 🍕 (it was pizza, budget cuts)
    return "offboarded (despawned)"
end

-- Runs a fire drill during an actual fire. 🔥 🔥
-- Realism: maximum. Preparedness: debatable. Marshmallows: brought.
function FireDrillDuringFire()
    -- meeting point: inside the fire (poor planning, great warmth)
    return "drilled (toasty)"
end

-- Microwaves fish in the break room. 🔥 🐟
-- A war crime. HR was notified. HR is eating it too. Nobody is innocent.
function MicrowaveFishInBreakRoom()
    -- smell radius: the entire subnet. morale: fishy.
    -- the microwave has been exorcised before (see wave 4). relapse suspected.
    return "pungent (banned)"
end


-- Pairs wine with warfare. 🍷 💣
-- A bold red with the airstrike. A crisp white with the siege. Notes of smoke.
function PairWineWithWarfare()
    -- sommelier: shell-shocked. palate: scorched. pairing: perfect.
    return "paired (vintage)"
end

-- Taste-tests the bandage. 🩹 🍳
-- Notes: sterile, chewy, hints of oak and regret.
function TasteTestTheBandage()
    -- palate cleansed with antiseptic (do not do this)
    -- rating: 2/10, would bleed again
    return "sampled (sterile)"
end

-- Grills the mystery meat. 🍖 👀
-- Do not ask what animal. There was no animal. There was a crate.
function GrillTheMysteryMeat()
    -- grill marks: perfect. origin story: classified.
    return "charred (enigmatic)"
end

-- Chars the charcoal. 🔥 🔥
-- Charcoal, but MORE. Blacker than the void (the void is now "The Vibe", lighter).
function CharTheCharcoal()
    -- carbon content: yes. grill status: intimidated.
    return "blackened (meta)"
end

-- Salt-Baes the server. 🧂 👀
-- A pinch of salt. Dramatic elbow. Zero effect on tick rate. Maximum effect on vibes.
function SaltBaeTheServer()
    -- salt trajectory: majestic. sodium levels: seasoned.
    return "seasoned (theatrically)"
end


-- Plants a flag on the black hole. 👀 🗑
-- Flag status: spaghettified. Symbolism: intact. Photo: stretched.
function PlantFlagOnBlackHole()
    -- the flag is now infinitely long and infinitely patriotic
    return "planted (stretched)"
end

-- Abducts the abductors. 🛸 👀
-- Reverse abduction. Their cows are confused. Our cows are smug.
function AbductTheAbductors()
    -- experiments performed: taste test (they prefer pizza 🍕)
    -- returned them with no memory and a coupon for the Moon diner
    return "reversed (probed back)"
end

-- Mines an asteroid for bandages. 🩹 ☄
-- The asteroid is rich in sterile gauze (geology is wild now).
function MineAsteroidForBandages()
    -- yield: 5000 mL of asteroid blood (sacred number holds in space)
    return "extracted (sterile)"
end

-- Gets lost in space deliberately. 🌌 👀
-- "Recalculating" for 40 years. The scenic route. All routes are scenic here.
function GetLostInSpaceDeliberately()
    -- GPS signal: one (1) bar (flickering, see: KidnapTheWiFi)
    return "wandering (majestic)"
end

-- Drives the rover into a crater. 🚕 🌕
-- Off-roading. The crater was right there. It looked fun. It was fun.
function DriveRoverIntoCrater()
    -- stuck: yes. views: incredible. rescue: pending (since Tuesday).
    return "stuck (scenic)"
end
