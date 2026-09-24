-- ⭐ VotturCity | cl_skills.lua | Skill tree panel (K key) ⭐ --
-- 💻 Displays points + trees; server validates every spend. --

VCity._Skills = VCity._Skills or { points = 0, medic = 0, gunner = 0, scavenger = 0, athlete = 0 } -- 💾 Cache. --
VCity.SkillPanel = VCity.SkillPanel or nil -- 🪟 Panel. --

net.Receive("VCity_Skills", function() -- 📥 Snapshot. --
    VCity._Skills = { -- 💾 Cache. --
        points = net.ReadUInt(8), -- ⭐ Points. --
        medic = net.ReadUInt(3), -- 🩹 Medic. --
        gunner = net.ReadUInt(3), -- 🔫 Gunner. --
        scavenger = net.ReadUInt(3), -- 🎒 Scav. --
        athlete = net.ReadUInt(3), -- 🏃 Athlete. --
    }
    if IsValid(VCity.SkillPanel) then VCity.Skills_Refresh() end -- 🔄 Refresh open panel. --
end)

local TreeInfo = { -- 🌲 Display info. --
    medic = { icon = "🩹", desc = "+8% heal, +7% CPR, -2% dmg taken per pt" }, -- 🩹 Medic. --
    gunner = { icon = "🔫", desc = "+3% dmg, -5% recoil, -4% spread per pt" }, -- 🔫 Gunner. --
    scavenger = { icon = "🎒", desc = "+4% XP, +2kg carry per pt" }, -- 🎒 Scav. --
    athlete = { icon = "🏃", desc = "+8 stamina, +2% speed per pt" }, -- 🏃 Athlete. --
}

function VCity.Skills_Toggle() -- 🪟 Toggle. --
    if IsValid(VCity.SkillPanel) then VCity.SkillPanel:Close() VCity.SkillPanel = nil return end -- ❌ Close. --
    local f = vgui.Create("DFrame") -- 🪟 Frame. --
    f:SetSize(440, 380) -- 📐 Size. --
    f:Center() f:SetTitle("⭐ Skills (" .. (VCity._Skills.points or 0) .. " points)") f:MakePopup() -- 🏷️ Title. --
    f.Paint = function(self, w, h) draw.RoundedBox(6, 0, 0, w, h, Color(12, 14, 18, 240)) draw.RoundedBox(6, 0, 0, w, 26, Color(30, 26, 44, 240)) end -- 🎨 Paint. --
    local list = vgui.Create("DScrollPanel", f) list:Dock(FILL) list:DockMargin(8, 8, 8, 8) -- 📜 List. --
    f._List = list -- 💾 Ref. --
    VCity.SkillPanel = f -- 💾 Track. --
    VCity.Skills_Refresh() -- 🔄 Fill. --
end

function VCity.Skills_Refresh() -- 🔄 Rebuild rows. --
    local f = VCity.SkillPanel -- 🪟 Panel. --
    if not IsValid(f) then return end -- 🛑 Closed. --
    f:SetTitle("⭐ Skills (" .. (VCity._Skills.points or 0) .. " points)") -- 🏷️ Title. --
    local list = f._List -- 📜 List. --
    if not IsValid(list) then return end -- 🛑 Gone. --
    list:Clear() -- 🧹 Rows. --
    for _, tree in ipairs({ "medic", "gunner", "scavenger", "athlete" }) do -- 🔁 Trees. --
        local info = TreeInfo[tree] -- 🌲 Info. --
        local lvl = VCity._Skills[tree] or 0 -- 🔢 Level. --
        local row = vgui.Create("DPanel", list) -- 📦 Row. --
        row:Dock(TOP) row:SetTall(64) row:DockMargin(0, 0, 0, 4) -- 📐 Layout. --
        row.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(28, 32, 42, 255)) end -- 🎨 Paint. --
        local lbl = vgui.Create("DLabel", row) -- 🏷️ Label. --
        lbl:Dock(LEFT) lbl:SetWide(280) lbl:DockMargin(8, 4, 0, 4) lbl:SetWrap(true) -- 📐 Layout. --
        lbl:SetText(info.icon .. " " .. tree .. "  Lv " .. lvl .. "/5\n" .. info.desc) -- 📝 Text. --
        local btn = vgui.Create("DButton", row) -- 🔘 Plus. --
        btn:Dock(RIGHT) btn:SetWide(60) btn:DockMargin(0, 14, 8, 14) btn:SetText("+") -- 📝 Label. --
        btn:SetEnabled((VCity._Skills.points or 0) > 0 and lvl < 5) -- ✅ Gate. --
        btn.DoClick = function() net.Start("VCity_SkillUp") net.WriteString(tree) net.SendToServer() surface.PlaySound("ui/buttonclick.wav") end -- 📤 Send. --
    end
end

hook.Add("PlayerButtonDown", "VCity_SkillKey", function(ply, btn) -- ⌨️ K opens skills. --
    if ply ~= LocalPlayer() then return end -- 👤 Local. --
    if IsValid(vgui.GetKeyboardFocus()) and vgui.GetKeyboardFocus():GetClassName() == "TextEntry" then return end -- ⌨️ Typing. --
    if btn == KEY_K then VCity.Skills_Toggle() end -- ⭐ Skills. --
end)
