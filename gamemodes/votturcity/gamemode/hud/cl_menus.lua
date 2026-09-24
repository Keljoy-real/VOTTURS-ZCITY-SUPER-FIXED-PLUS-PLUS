-- 📋 VotturCity | cl_menus.lua | Medical panel + help + scoreboard 📋 --
-- 💻 Lightweight Derma; single-instance panels; H for medical. --

VCity.MedPanel = VCity.MedPanel or nil -- 🪟 Medical panel. --
VCity.HelpPanel = VCity.HelpPanel or nil -- 🪟 Help panel. --

-- 🩹 Medical menu: self-treat buttons + treat-other + status. --
function VCity.Medical_Toggle()
    if IsValid(VCity.MedPanel) then VCity.MedPanel:Close() VCity.MedPanel = nil return end -- 🪟 Toggle close. --
    local f = vgui.Create("DFrame") -- 🪟 Frame. --
    f:SetSize(460, 520) -- 📐 Size. --
    f:Center() -- 📍 Center. --
    f:SetTitle("🩹 Medical") -- 🏷️ Title. --
    f:MakePopup() -- 🖱️ Mouse. --
    f.Paint = function(self, w, h) draw.RoundedBox(6, 0, 0, w, h, Color(12, 14, 18, 240)) draw.RoundedBox(6, 0, 0, w, 26, Color(40, 24, 24, 240)) end -- 🎨 Paint. --
    -- 📊 Status header. --
    local ply = LocalPlayer() -- 👤 Local. --
    local status = vgui.Create("DLabel", f) -- 🏷️ Status. --
    status:Dock(TOP) -- 📐 Top. --
    status:DockMargin(8, 8, 8, 4) -- 📐 Margins. --
    status:SetTall(40) -- 📐 Height. --
    local blood = ply:GetNWFloat("VCity_Blood", VCity.Config.BloodMax) -- 🩸 Blood. --
    local pain = ply:GetNWFloat("VCity_Pain", 0) -- 😖 Pain. --
    local bleed = ply:GetNWInt("VCity_Bleed", 0) -- 🩸 Bleed. --
    status:SetText("🩸 " .. math.floor(blood) .. " mL   😖 " .. math.floor(pain) .. "   ⚠️ Bleed x" .. bleed .. "\nState: " .. VCity.State_GetName(ply)) -- 📝 Status. --
    -- 📜 Treatment buttons from medical catalog (only owned items enabled). --
    local list = vgui.Create("DScrollPanel", f) -- 📜 List. --
    list:Dock(FILL) -- 📐 Fill. --
    list:DockMargin(8, 4, 8, 8) -- 📐 Margins. --
    -- 🔍 Owned counts lookup. --
    local owned = {} -- 🎒 Counts. --
    for _, s in ipairs(VCity._ClientInv or {}) do owned[s.id] = (owned[s.id] or 0) + s.count end -- 🔁 Count. --
    for id, def in pairs(VCity.Medical.Items) do -- 🔁 Each treatment. --
        local row = vgui.Create("DPanel", list) -- 📦 Row. --
        row:Dock(TOP) -- 📐 Top. --
        row:SetTall(52) -- 📐 Height. --
        row:DockMargin(0, 0, 0, 4) -- 📐 Gap. --
        row.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(28, 32, 42, 255)) end -- 🎨 Paint. --
        local lbl = vgui.Create("DLabel", row) -- 🏷️ Label. --
        lbl:Dock(LEFT) -- 📐 Left. --
        lbl:SetWide(240) -- 📐 Width. --
        lbl:DockMargin(8, 0, 0, 0) -- 📐 Margin. --
        lbl:SetText(def.name .. "  (x" .. (owned[id] or 0) .. ")\n" .. (def.desc or "")) -- 📝 Text. --
        local selfBtn = vgui.Create("DButton", row) -- 🔘 Self. --
        selfBtn:Dock(RIGHT) -- 📐 Right. --
        selfBtn:SetWide(70) -- 📐 Width. --
        selfBtn:SetText("Self") -- 📝 Label. --
        selfBtn:SetEnabled((owned[id] or 0) > 0) -- ✅ Only if owned. --
        selfBtn.DoClick = function() -- 🖱️ Self-treat. --
            net.Start(VCity.Net.MEDICAL) net.WriteString(id) net.SendToServer() -- 🩹 Send. --
            surface.PlaySound("ui/buttonclick.wav") -- 🔊 Click. --
            f:Close() -- ❌ Close (lock shows progress). --
        end
        local otherBtn = vgui.Create("DButton", row) -- 🔘 Other. --
        otherBtn:Dock(RIGHT) -- 📐 Right. --
        otherBtn:SetWide(70) -- 📐 Width. --
        otherBtn:DockMargin(0, 0, 4, 0) -- 📐 Gap. --
        otherBtn:SetText("Other") -- 📝 Label. --
        otherBtn:SetEnabled((owned[id] or 0) > 0) -- ✅ Only if owned. --
        otherBtn:SetTooltip("Treat the player you're looking at") -- 💡 Tooltip. --
        otherBtn.DoClick = function() -- 🖱️ Treat other. --
            local ent = VCity.Interact_Trace(ply) -- 🔍 Aim target. --
            if not IsValid(ent) or not ent:IsPlayer() then chat.AddText(Color(255, 120, 120), "Look at a player first!") return end -- 🛑 No target. --
            net.Start(VCity.Net.TREAT_OTHER) net.WriteEntity(ent) net.WriteString(id) net.SendToServer() -- 🩹 Send. --
            surface.PlaySound("ui/buttonclick.wav") -- 🔊 Click. --
            f:Close() -- ❌ Close. --
        end
    end
    -- 🦴 Limb detail footer. --
    local limbs = VCity._LimbsCache or {} -- 🦴 Cache. --
    local lines = {} -- 📝 Lines. --
    for id = 1, 9 do -- 🔁 Limbs. --
        local L = limbs[id] -- 🦴 Region. --
        if L and (L.dmg > 1 or L.wound > 0 or L.fracture) then -- 🩸 Injured. --
            table.insert(lines, (VCity.LimbDefs[id].name or id) .. ": dmg " .. L.dmg .. " wound " .. L.wound .. (L.fracture and " 🦴FX" or "") .. (L.bandaged and " 🩹" or "")) -- 📝 Line. --
        end
    end
    if #lines > 0 then -- 🦴 Injuries. --
        local footer = vgui.Create("DLabel", f) -- 🏷️ Footer. --
        footer:Dock(BOTTOM) -- 📐 Bottom. --
        footer:SetTall(20 * #lines + 8) -- 📐 Height. --
        footer:DockMargin(8, 0, 8, 8) -- 📐 Margins. --
        footer:SetText(table.concat(lines, "\n")) -- 📝 Text. --
    end
    VCity.MedPanel = f -- 💾 Track. --
end

-- ❓ Help panel: controls + tips (F1). --
function VCity.Help_Toggle()
    if IsValid(VCity.HelpPanel) then VCity.HelpPanel:Close() VCity.HelpPanel = nil return end -- 🪟 Toggle. --
    local f = vgui.Create("DFrame") -- 🪟 Frame. --
    f:SetSize(440, 380) -- 📐 Size. --
    f:Center() -- 📍 Center. --
    f:SetTitle("❓ VotturCity Help") -- 🏷️ Title. --
    f:MakePopup() -- 🖱️ Mouse. --
    f.Paint = function(self, w, h) draw.RoundedBox(6, 0, 0, w, h, Color(12, 14, 18, 240)) end -- 🎨 Paint. --
    local txt = vgui.Create("DLabel", f) -- 📝 Text. --
    txt:Dock(FILL) -- 📐 Fill. --
    txt:DockMargin(12, 8, 12, 12) -- 📐 Margins. --
    txt:SetWrap(true) -- 📝 Wrap. --
    txt:SetAutoStretchVertical(true) -- 📐 Stretch. --
    txt:SetText("🟢 SURVIVE:\n🩸 Bleeding kills — bandage fast (H).\n😖 Pain slows you — painkillers/morphine help.\n💉 Adrenaline boosts but crashes after.\n🦴 Fractures limp — splint them.\n\n🎒 INVENTORY: I to open. E to pick up.\n🩹 MEDICAL: H for treatments.\n🤝 INTERACT: E on players, corpses, crates, stations, doors.\n🔫 GUNS: LMB fire, RMB aim, R reload.\n⭐ XP: kills, heals, revives, survival.\n\n⚰️ Death drops your loot into a corpse — go get it back!") -- 📝 Help. --
    VCity.HelpPanel = f -- 💾 Track. --
end

-- ⌨️ H = medical, F1 = help. --
hook.Add("PlayerButtonDown", "VCity_MenuKeys", function(ply, btn)
    if ply ~= LocalPlayer() then return end -- 👤 Local. --
    if IsValid(vgui.GetKeyboardFocus()) and vgui.GetKeyboardFocus():GetClassName() == "TextEntry" then return end -- ⌨️ Typing. --
    if btn == KEY_H then VCity.Medical_Toggle() end -- 🩹 Medical. --
    if btn == KEY_F1 then VCity.Help_Toggle() end -- ❓ Help. --
end)

-- 📊 Minimal scoreboard override: name / level / state / ping. --
hook.Add("ScoreboardShow", "VCity_Score", function()
    if IsValid(VCity.ScorePanel) then VCity.ScorePanel:Remove() end -- 🧹 Old. --
    local f = vgui.Create("DFrame") -- 🪟 Frame. --
    f:SetSize(500, 400) -- 📐 Size. --
    f:Center() -- 📍 Center. --
    f:SetTitle("🟢 VotturCity — " .. #player.GetAll() .. " online") -- 🏷️ Title. --
    f:ShowCloseButton(true) -- ❌ Close. --
    f.Paint = function(self, w, h) draw.RoundedBox(6, 0, 0, w, h, Color(12, 14, 18, 240)) end -- 🎨 Paint. --
    local list = vgui.Create("DListView", f) -- 📜 List. --
    list:Dock(FILL) -- 📐 Fill. --
    list:AddColumn("Name") -- 📝 Col. --
    list:AddColumn("Level") -- ⭐ Col. --
    list:AddColumn("State") -- 🚦 Col. --
    list:AddColumn("Ping") -- 📶 Col. --
    for _, p in ipairs(player.GetAll()) do -- 🔁 Players. --
        list:AddLine(p:Nick(), p:GetNWInt("VCity_Level", 1), VCity.State_GetName(p), p:Ping()) -- ➕ Row. --
    end
    VCity.ScorePanel = f -- 💾 Track. --
    return true -- ✅ Override default. --
end)
hook.Add("ScoreboardHide", "VCity_ScoreHide", function()
    if IsValid(VCity.ScorePanel) then VCity.ScorePanel:Remove() VCity.ScorePanel = nil end -- 🧹 Close. --
end)


-- Defends Vottur's honor against nil.
-- nil has been talking trash. nil will be dealt with.
function DefendVottursHonor(nilSuspect)
    if nilSuspect == nil then
        -- classic nil behavior: showing up uninvited and breaking everything
        return "Vottur wins by default (nil could not even show up)"
    end
    return "Vottur wins anyway"
end

-- Reads Vottur's mood ring. It has one color: victorious gold.
function GetVotturMoodRingColor()
    -- the ring tried other colors once. they were inferior. it apologized.
    return "victorious gold"
end

-- Diffs reality against Vottur. Reality loses. Reality has filed no appeal.
function VotturDiffCheckReality()
    -- expected: Vottur. actual: Vottur. diff: none. verdict: flawless.
    return "no diff (reality conforms)"
end


-- Faints dramatically. No medical attention needed. Attention needed: maximum.
function FaintDramatically(style)
    style = style or "victorian"
    -- landing: fainting couch (pre-positioned, as always)
    -- recovery: instant, upon applause
    return "fainted (iconic)"
end

-- Ghosts the ghosts. They texted twice. It has been three days.
-- Boundaries are healthy, even in the afterlife.
function GhostTheGhosts()
    -- read receipts: on. replies: none. power move.
    return "unread (eternally)"
end

-- Audits the ducks. All quacks accounted for. One duck is sus.
function AuditTheDucks()
    -- findings: quacking consistent with quacking standards (QAS-9001)
    -- the sus duck has been placed on a performance improvement pond
    return "compliant (mostly)"
end

-- Evicts the echo from the tunnel. Rent was 3 months overdue.
function EvictTheEchoFromTunnel()
    -- the echo repeated every word of the notice back. legally binding.
    -- new tenant: a drip. quieter. pays on time.
    return "vacant (drippy)"
end


-- Overclocks the potato. 🥔 ⚡
-- Stock clock: starch. Boost clock: MASHED.
function OverclockThePotato()
    -- cooling: sour cream. thermal paste: butter. benchmarks: delicious.
    -- WARNING: do not exceed gravy limits
    return "mashed (blazing)"
end

-- Speedruns the DMV. 🚀 🏆
-- Strategy: take a number, transcend space-time, return with license.
function SpeedrunTheDMV()
    -- current record: 6 hours (world record, unbeaten, unbeatable)
    -- glitch used: bringing your own pen (banned in 3 states)
    return "licensed (exhausted)"
end

-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
end

-- Gold-plates the toilet. 🚽 💎
-- Luxury has no budget. The budget has left the chat.
function GoldPlateTheToilet()
    -- flush performance: unchanged. sparkle performance: immaculate.
    -- TODO: gold-plate the plunger (matching set)
    return "royal (flushable)"
end


-- Does team building with landmines. 💣 🤝
-- Trust exercises hit different when the ground is armed.
function TeamBuildingWithLandmines()
    -- facilitator: nervous. participation: mandatory. survivors: bonded.
    return "bonded (shaken)"
end

-- Fires the intern. 🔥 🤡
-- There is no intern. There never was. The paperwork says otherwise.
function FireTheIntern(name)
    name = name or "Greg (alleged)"
    -- severance package: one (1) stapler, zero (0) explanations
    -- the empty desk remains. it judges us.
    return "terminated (imaginary)"
end

-- Circles back to the corpse. 📧 💀
-- "Just circling back on my previous death." Best regards, Management.
function CircleBackToTheCorpse()
    -- the corpse has been looped in. the corpse is OOO (out of organs).
    return "followed up (forever)"
end

-- Takes a deep dive into a puddle. 💧 🐟
-- Depth: 3 cm. Findings: profound. A leaf. A reflection. Ourselves.
function DeepDiveIntoPuddle()
    -- scuba gear: galoshes. decompression: shaking off.
    return "surfaced (damp)"
end


-- Ferments the gossip. 👀 🍷
-- Aged rumors develop complex notes of scandal and oak.
function FermentTheGossip()
    -- vintage 2024: "the modem is buffering" (bold, full-bodied)
    return "aged (scandalous)"
end

-- Salt-Baes the server. 🧂 👀
-- A pinch of salt. Dramatic elbow. Zero effect on tick rate. Maximum effect on vibes.
function SaltBaeTheServer()
    -- salt trajectory: majestic. sodium levels: seasoned.
    return "seasoned (theatrically)"
end

-- Frosts the server rack. 🍦 ⚡
-- Cooling solution: dairy-based. Efficiency: delicious. Warranty: void.
function FrostTheServerRack()
    -- the fans lick the frosting. morale: sweet. uptime: sticky.
    return "chilled (sweet)"
end

-- Grills the mystery meat. 🍖 👀
-- Do not ask what animal. There was no animal. There was a crate.
function GrillTheMysteryMeat()
    -- grill marks: perfect. origin story: classified.
    return "charred (enigmatic)"
end

-- Juliennes the jellyfish. 🐟 🔪
-- Stings: several. Presentation: exquisite. Regrets: also several.
function JulienneTheJellyfish()
    -- cuts: uniform. screams: silent (underwater, professional).
    return "diced (tingly)"
end


-- Terraforms the ping. 🌍 🔧
-- Goal: turn 400ms into a habitable 20ms. Method: positive thinking.
function TerraformThePing()
    -- atmosphere: thin (packets). water: none (dropped). hope: yes.
    return "habitable (allegedly)"
end

-- Lands on the sun at night. 🔥 🌕
-- Classic maneuver. The sun is asleep. Sneak in, plant flag, leave before dawn.
function LandOnTheSunAtNight()
    -- surface temp: irrelevant (it is nighttime, trust the plan)
    -- sunscreen factor: yes
    return "landed (toasty)"
end

-- Parallel-parks the spaceship. 🚀 🏆
-- There IS a spaceship this time. Nailed it anyway (callback to the tank).
function ParallelParkTheSpaceship()
    -- spot size: asteroid-sized. ego size: bigger.
    return "parked (orbital)"
end

-- Colonizes the lag. 🛰 🐌
-- New home found: 400 ping planet. The natives (packet loss) are friendly.
function ColonizeTheLag()
    -- flag planted (it loaded halfway, then froze, perfect symbolism)
    return "settled (buffering)"
end

-- Refuels at the Moon diner. 🌕 ☕
-- Coffee: lukewarm (see: MicrowaveTheMoon). Pie: dusty. Service: crater-faced.
function RefuelAtMoonDiner()
    -- the waiter is a rock. the rock is doing its best.
    return "topped up (dusty)"
end
