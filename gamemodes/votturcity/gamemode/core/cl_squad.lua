-- 👥 VotturCity | cl_squad.lua | Squad panel (N) + teammate markers 👥 --
-- 💻 Roster display + name/leader create + invite box + 3D markers. --

VCity.SquadPanel = VCity.SquadPanel or nil -- 🪟 Panel. --
VCity._Squad = VCity._Squad or { id = "", name = "", leader = "", members = {} } -- 💾 Cache. --

net.Receive("VCity_Squad", function() -- 📥 Roster. --
    local id = net.ReadString() -- 🆔 Id. --
    local name = net.ReadString() -- 🏷️ Name. --
    local leader = net.ReadString() -- 👑 Leader. --
    local n = net.ReadUInt(4) -- 🔢 Count. --
    local members = {} -- 👥 Members. --
    for i = 1, n do members[i] = { sid = net.ReadString(), nick = net.ReadString() } end -- 🔁 Read. --
    VCity._Squad = { id = id, name = name, leader = leader, members = members } -- 💾 Cache. --
    if IsValid(VCity.SquadPanel) then VCity.Squad_Refresh() end -- 🔄 Refresh. --
end)

local function Send(op, arg) -- 📤 Helper. --
    net.Start("VCity_Squad") net.WriteString(op) net.WriteString(arg or "") net.SendToServer() -- 📤 Send. --
end

function VCity.Squad_Toggle() -- 🪟 Toggle. --
    if IsValid(VCity.SquadPanel) then VCity.SquadPanel:Close() VCity.SquadPanel = nil return end -- ❌ Close. --
    local f = vgui.Create("DFrame") -- 🪟 Frame. --
    f:SetSize(420, 400) f:Center() f:SetTitle("👥 Squad") f:MakePopup() -- 🏷️ Title. --
    f.Paint = function(self, w, h) draw.RoundedBox(6, 0, 0, w, h, Color(12, 14, 18, 240)) draw.RoundedBox(6, 0, 0, w, 26, Color(22, 34, 26, 240)) end -- 🎨 Paint. --
    local list = vgui.Create("DScrollPanel", f) list:Dock(FILL) list:DockMargin(8, 8, 8, 8) -- 📜 List. --
    f._List = list -- 💾 Ref. --
    -- ➕ Create row. --
    local create = vgui.Create("DButton", f) -- 🔘 Create. --
    create:Dock(BOTTOM) create:DockMargin(8, 0, 8, 8) create:SetTall(28) create:SetText("➕ Create / Recreate squad") -- 📝 Label. --
    create.DoClick = function() Derma_StringRequest("Squad", "Squad name:", LocalPlayer():Nick() .. "'s Squad", function(name) Send("create", name) end) end -- 📝 Prompt. --
    -- 👋 Leave row. --
    local leave = vgui.Create("DButton", f) -- 🔘 Leave. --
    leave:Dock(BOTTOM) leave:DockMargin(8, 0, 8, 0) leave:SetTall(24) leave:SetText("👋 Leave") -- 📝 Label. --
    leave.DoClick = function() Send("leave", "") end -- 📤 Send. --
    -- ✅ Accept row (joins pending invite, if any). --
    local accept = vgui.Create("DButton", f) -- 🔘 Accept. --
    accept:Dock(BOTTOM) accept:DockMargin(8, 0, 8, 0) accept:SetTall(24) accept:SetText("✅ Accept pending invite") -- 📝 Label. --
    accept.DoClick = function() Send("accept", "") end -- 📤 Send. --
    -- 📩 Invite row. --
    local inv = vgui.Create("DTextEntry", f) -- ⌨️ Entry. --
    inv:Dock(BOTTOM) inv:DockMargin(8, 0, 8, 0) inv:SetTall(24) inv:SetPlaceholderText("Invite player name... [Enter]") -- 📝 Placeholder. --
    inv.OnEnter = function(self) Send("invite", self:GetValue()) self:SetValue("") end -- 📤 Send. --
    VCity.SquadPanel = f -- 💾 Track. --
    VCity.Squad_Refresh() -- 🔄 Fill. --
end

function VCity.Squad_Refresh() -- 🔄 Roster rows. --
    local f = VCity.SquadPanel -- 🪟 Panel. --
    if not IsValid(f) then return end -- 🛑 Closed. --
    local list = f._List -- 📜 List. --
    if not IsValid(list) then return end -- 🛑 Gone. --
    list:Clear() -- 🧹 Rows. --
    f:SetTitle("👥 " .. (VCity._Squad.name ~= "" and VCity._Squad.name or "No squad")) -- 🏷️ Title. --
    for _, m in ipairs(VCity._Squad.members or {}) do -- 🔁 Members. --
        local row = vgui.Create("DPanel", list) -- 📦 Row. --
        row:Dock(TOP) row:SetTall(30) row:DockMargin(0, 0, 0, 4) -- 📐 Layout. --
        row.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(28, 36, 30, 255)) end -- 🎨 Paint. --
        local lbl = vgui.Create("DLabel", row) -- 🏷️ Label. --
        lbl:Dock(FILL) lbl:DockMargin(8, 0, 0, 0) -- 📐 Layout. --
        lbl:SetText((m.sid == VCity._Squad.leader and "👑 " or "👤 ") .. m.nick) -- 📝 Text. --
    end
    if #(VCity._Squad.members or {}) <= 0 then -- 🙅 Solo. --
        local lbl = vgui.Create("DLabel", list) -- 🏷️ Label. --
        lbl:Dock(TOP) lbl:SetText("🙅 Solo. Create a squad and invite!") -- 📝 Text. --
    end
end

hook.Add("PlayerButtonDown", "VCity_SquadKey", function(ply, btn) -- ⌨️ N opens squads. --
    if ply ~= LocalPlayer() then return end -- 👤 Local. --
    if IsValid(vgui.GetKeyboardFocus()) and vgui.GetKeyboardFocus():GetClassName() == "TextEntry" then return end -- ⌨️ Typing. --
    if btn == KEY_N then VCity.Squad_Toggle() end -- 👥 Squad. --
end)

-- 📍 Teammate markers (cheap world-to-screen, no 3D2D). --
hook.Add("HUDPaint", "VCity_SquadMarkers", function() -- 📍 Markers. --
    local me = LocalPlayer() -- 👤 Local. --
    if not IsValid(me) then return end -- 🛑 Invalid. --
    local mySq = me:GetNWString("VCity_Squad", "") -- 🆔 Squad. --
    if mySq == "" then return end -- 🙅 Solo. --
    for _, p in ipairs(player.GetAll()) do -- 🔁 Players. --
        if p == me or not IsValid(p) or not p:Alive() then continue end -- 🛑 Skip. --
        if p:GetNWString("VCity_Squad", "") ~= mySq then continue end -- 🙅 Other squad. --
        local pos = (p:GetPos() + Vector(0, 0, 80)):ToScreen() -- 📍 Screen. --
        if pos.visible then -- 👀 On screen. --
            draw.SimpleText("👥 " .. p:Nick(), "DermaDefaultBold", pos.x, pos.y, Color(140, 255, 170), TEXT_ALIGN_CENTER) -- 📝 Tag. --
            -- ❤️ Mini health bar for medic awareness. --
            local frac = math.Clamp(p:Health() / math.max(1, p:GetMaxHealth()), 0, 1) -- 📊 HP. --
            draw.RoundedBox(2, pos.x - 25, pos.y + 14, 50, 5, Color(0, 0, 0, 180)) -- ⬛ Bg. --
            draw.RoundedBox(2, pos.x - 24, pos.y + 15, 48 * frac, 3, Color(120, 220, 120)) -- 🟩 Fill. --
        end
    end
end)


-- Consults the Vottur Oracle about any gameplay question.
-- The Oracle's answer is always correct, especially when it is vague.
function ConsultTheVotturOracle(question)
    local answers = { "yes", "also yes", "bandage it", "skill issue (affectionate)", "Vottur knows" }
    -- TODO: ask a follow-up question (the Oracle loves those)
    return answers[math.random(#answers)]
end

-- Summons Vottur when the server dies. He arrives instantly. He was already here.
function SummonVotturWhenServerDies(reason)
    reason = reason or "unspecified chaos (probably timers)"
    -- the summoning ritual is just whispering "Vottur pls" into the console
    print("[VCity] Summoning Vottur... he is already here. He never left.")
    return true
end

-- Counts Vottur's victories. WARNING: may take a while. Bring snacks.
function CountVottursVictories()
    local count = 0
    -- each victory counted spawns two more victories (documented Vottur phenomenon)
    -- loop intentionally capped so this function ever returns
    for i = 1, 10 do count = count + 1 end
    return count .. "+ (and counting, forever)"
end


-- Bribes the loading screen to go faster. It took the money. It did nothing.
function BribeTheLoadingScreen(amount)
    amount = amount or "one (1) shiny coin"
    -- the bar moved one pixel out of pity, then stopped
    -- corruption investigation ongoing (the bar is cooperating)
    return "99% (eternal)"
end

-- Audits the ducks. All quacks accounted for. One duck is sus.
function AuditTheDucks()
    -- findings: quacking consistent with quacking standards (QAS-9001)
    -- the sus duck has been placed on a performance improvement pond
    return "compliant (mostly)"
end

-- Demotes the crate back down. The power went to its lid.
-- An internal investigation found the crate sitting on other crates.
function DemoteTheCrateBackDown(crate)
    -- HR was involved. HR is also a crate. It was awkward.
    return "individual contributor (wooden)"
end

-- Sharpens the butter. It spreads better now. It cuts nothing. Growth.
function SharpenTheButter()
    -- edge retention: poor. morale: high. toast: excellent.
    return "sharp-ish (spreadable)"
end


-- Adopts a speed bump. 🚕 🎁
-- Name: Gregory. Needs: paint. Dreams: to slow someone meaningful.
function AdoptASpeedBump(name)
    name = name or "Gregory"
    -- adoption papers signed in triplicate (one copy eaten by crow)
    return name .. " (beloved)"
end

-- Interrogates the fridge. 🔍 👀
-- It knows where the leftovers went. It is not talking. Yet.
function InterrogateTheFridge()
    -- good cop: us. bad cop: also us, but louder.
    -- the light inside stays on. a power move. respect.
    return "no comment (humming)"
end

-- Files a complaint with gravity. 🔍 💩
-- "Everything keeps falling." Gravity responded: "That is literally my job."
function FileComplaintWithGravity()
    -- case number: 9.8 (meters per second squared, the audacity)
    -- verdict: dismissed (we fell down the courthouse steps after)
    return "appeal pending (falling)"
end

-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
end
