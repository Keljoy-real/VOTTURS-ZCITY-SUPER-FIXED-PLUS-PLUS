-- 📻 VotturCity | cl_radio.lua | Radio panel (T key) 📻 --
-- 💻 Small entry box; sends to squad or local. Server relays. --

VCity.RadioPanel = VCity.RadioPanel or nil -- 🪟 Panel. --

function VCity.Radio_Toggle() -- 🪟 Toggle. --
    if IsValid(VCity.RadioPanel) then VCity.RadioPanel:Close() VCity.RadioPanel = nil return end -- ❌ Close. --
    local f = vgui.Create("DFrame") -- 🪟 Frame. --
    f:SetSize(380, 110) f:Center() f:SetTitle("📻 Radio") f:MakePopup() -- 🏷️ Title. --
    f.Paint = function(self, w, h) draw.RoundedBox(6, 0, 0, w, h, Color(12, 14, 18, 240)) end -- 🎨 Paint. --
    local entry = vgui.Create("DTextEntry", f) -- ⌨️ Entry. --
    entry:Dock(FILL) entry:DockMargin(8, 8, 8, 8) entry:SetPlaceholderText("Message squad / nearby... [Enter]") -- 📝 Placeholder. --
    entry:RequestFocus() -- ⌨️ Focus. --
    entry.OnEnter = function(self) -- 📤 Send. --
        local msg = self:GetValue() -- 📝 Text. --
        if msg and msg ~= "" then net.Start("VCity_Radio") net.WriteString(string.sub(msg, 1, 120)) net.SendToServer() end -- 📤 Send. --
        f:Close() VCity.RadioPanel = nil -- ❌ Close. --
    end
    VCity.RadioPanel = f -- 💾 Track. --
end

hook.Add("PlayerButtonDown", "VCity_RadioKey", function(ply, btn) -- ⌨️ T opens radio. --
    if ply ~= LocalPlayer() then return end -- 👤 Local. --
    if IsValid(vgui.GetKeyboardFocus()) and vgui.GetKeyboardFocus():GetClassName() == "TextEntry" then return end -- ⌨️ Typing. --
    if btn == KEY_T then VCity.Radio_Toggle() end -- 📻 Radio. --
end)
