-- 🎽 VotturCity | cl_armor.lua | Gear panel (J key) 🎽 --
-- 💻 Shows head/body/face slots + owned gear with equip buttons. --

VCity.GearPanel = VCity.GearPanel or nil -- 🪟 Panel. --

function VCity.Gear_Toggle() -- 🪟 Toggle. --
    if IsValid(VCity.GearPanel) then VCity.GearPanel:Close() VCity.GearPanel = nil return end -- ❌ Close. --
    local ply = LocalPlayer() -- 👤 Local. --
    local f = vgui.Create("DFrame") -- 🪟 Frame. --
    f:SetSize(420, 360) -- 📐 Size. --
    f:Center() -- 📍 Center. --
    f:SetTitle("🎽 Gear") -- 🏷️ Title. --
    f:MakePopup() -- 🖱️ Mouse. --
    f.Paint = function(self, w, h) draw.RoundedBox(6, 0, 0, w, h, Color(12, 14, 18, 240)) draw.RoundedBox(6, 0, 0, w, 26, Color(24, 30, 40, 240)) end -- 🎨 Paint. --
    local list = vgui.Create("DScrollPanel", f) -- 📜 List. --
    list:Dock(FILL) -- 📐 Fill. --
    list:DockMargin(8, 8, 8, 8) -- 📐 Margins. --
    -- 🎽 Current slots header. --
    for _, slot in ipairs(VCity.GearSlots or { "head", "body", "face" }) do -- 🔁 Slots. --
        local cur = VCity.Gear_Get(ply, slot) -- 📦 Equipped. --
        local row = vgui.Create("DPanel", list) -- 📦 Row. --
        row:Dock(TOP) row:SetTall(40) row:DockMargin(0, 0, 0, 4) -- 📐 Layout. --
        row.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(28, 32, 42, 255)) end -- 🎨 Paint. --
        local lbl = vgui.Create("DLabel", row) -- 🏷️ Label. --
        lbl:Dock(LEFT) lbl:SetWide(240) lbl:DockMargin(8, 0, 0, 0) -- 📐 Layout. --
        lbl:SetText("🎽 " .. slot .. ": " .. (cur and ((VCity.Items[cur] or {}).name or cur) or "— empty —")) -- 📝 Text. --
        if cur then -- ✅ Occupied: unequip button. --
            local un = vgui.Create("DButton", row) -- 🔘 Unequip. --
            un:Dock(RIGHT) un:SetWide(80) un:SetText("Remove") -- 📝 Label. --
            un.DoClick = function() net.Start("VCity_Gear") net.WriteString("unequip") net.WriteString(slot) net.SendToServer() f:Close() end -- 📤 Send. --
        end
    end
    -- 🎒 Owned gear footer. --
    local owned = {} -- 🎒 Counts. --
    for _, s in ipairs(VCity._ClientInv or {}) do owned[s.id] = (owned[s.id] or 0) + s.count end -- 🔁 Count. --
    for itemId, slot in pairs(VCity.GearItemSlot or {}) do -- 🔁 Gear items. --
        if (owned[itemId] or 0) > 0 then -- ✅ Owned. --
            local row = vgui.Create("DPanel", list) -- 📦 Row. --
            row:Dock(TOP) row:SetTall(36) row:DockMargin(0, 0, 0, 4) -- 📐 Layout. --
            row.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(24, 34, 28, 255)) end -- 🎨 Paint. --
            local lbl = vgui.Create("DLabel", row) -- 🏷️ Label. --
            lbl:Dock(LEFT) lbl:SetWide(240) lbl:DockMargin(8, 0, 0, 0) -- 📐 Layout. --
            lbl:SetText("🎒 " .. ((VCity.Items[itemId] or {}).name or itemId) .. " x" .. owned[itemId] .. " → " .. slot) -- 📝 Text. --
            local eq = vgui.Create("DButton", row) -- 🔘 Equip. --
            eq:Dock(RIGHT) eq:SetWide(80) eq:SetText("Equip") -- 📝 Label. --
            eq.DoClick = function() net.Start("VCity_Gear") net.WriteString("equip") net.WriteString(itemId) net.SendToServer() f:Close() end -- 📤 Send. --
        end
    end
    VCity.GearPanel = f -- 💾 Track. --
end

hook.Add("PlayerButtonDown", "VCity_GearKey", function(ply, btn) -- ⌨️ J opens gear. --
    if ply ~= LocalPlayer() then return end -- 👤 Local. --
    if IsValid(vgui.GetKeyboardFocus()) and vgui.GetKeyboardFocus():GetClassName() == "TextEntry" then return end -- ⌨️ Typing. --
    if btn == KEY_J then VCity.Gear_Toggle() end -- 🎽 Gear. --
end)
