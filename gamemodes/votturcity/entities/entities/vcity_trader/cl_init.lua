-- 🏪 VotturCity | vcity_trader | cl_init.lua 🏪 --
include("shared.lua") -- 📥 Shared. --

function ENT:Draw() -- 🎨 Draw + label. --
    self:DrawModel() -- 🎨 Model. --
    local pos = self:GetPos() + Vector(0, 0, 85) -- 📍 Above. --
    local ang = LocalPlayer():EyeAngles() ang:RotateAroundAxis(ang:Up(), -90) ang:RotateAroundAxis(ang:Forward(), 90) -- 🔄 Billboard. --
    cam.Start3D2D(pos, ang, 0.12) -- 🎥 3D2D. --
        draw.SimpleText("🏪 Trader", "DermaDefaultBold", 0, 0, Color(255, 220, 130), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Title. --
        draw.SimpleText("[E] Trade (scrap = cash)", "DermaDefault", 0, 14, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Hint. --
    cam.End3D2D() -- ✅ End. --
end

-- 📥 Trade menu from server. --
VCity._TradeEnt = nil -- 🏪 Which trader. --
VCity._TradeBuy = {} -- 🛒 Buy list cache. --
VCity.TradePanel = VCity.TradePanel or nil -- 🪟 Panel. --

net.Receive("VCity_Trade", function() -- 📥 Open. --
    VCity._TradeEnt = net.ReadEntity() -- 🏪 Trader. --
    local n = net.ReadUInt(8) -- 🔢 Count. --
    VCity._TradeBuy = {} -- 🛒 Fresh. --
    for i = 1, n do VCity._TradeBuy[i] = { id = net.ReadString(), price = net.ReadUInt(8) } end -- 🔁 Read. --
    VCity.Trade_Open() -- 🪟 Show. --
end)

function VCity.Trade_Open() -- 🪟 Build. --
    if IsValid(VCity.TradePanel) then VCity.TradePanel:Close() end -- 🧹 Old. --
    local f = vgui.Create("DFrame") -- 🪟 Frame. --
    f:SetSize(460, 440) f:Center() f:SetTitle("🏪 Trader (scrap = cash)") f:MakePopup() -- 🏷️ Title. --
    f.Paint = function(self, w, h) draw.RoundedBox(6, 0, 0, w, h, Color(12, 14, 18, 240)) draw.RoundedBox(6, 0, 0, w, 26, Color(40, 34, 18, 240)) end -- 🎨 Paint. --
    local list = vgui.Create("DScrollPanel", f) list:Dock(FILL) list:DockMargin(8, 8, 8, 8) -- 📜 List. --
    -- 🔍 Owned scrap. --
    local scrap = 0 for _, s in ipairs(VCity._ClientInv or {}) do if s.id == "scrap" then scrap = scrap + s.count end end -- 💰 Count. --
    local head = vgui.Create("DLabel", list) head:Dock(TOP) head:SetText("💰 Your scrap: " .. scrap) -- 📝 Header. --
    for _, e in ipairs(VCity._TradeBuy or {}) do -- 🔁 Goods. --
        local def = VCity.Items[e.id] -- 🧾 Def. --
        if not def then continue end -- 🛑 Unknown. --
        local row = vgui.Create("DPanel", list) -- 📦 Row. --
        row:Dock(TOP) row:SetTall(38) row:DockMargin(0, 4, 0, 0) -- 📐 Layout. --
        row.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(28, 32, 42, 255)) end -- 🎨 Paint. --
        local lbl = vgui.Create("DLabel", row) -- 🏷️ Label. --
        lbl:Dock(LEFT) lbl:SetWide(280) lbl:DockMargin(8, 0, 0, 0) -- 📐 Layout. --
        lbl:SetText(def.name .. " — " .. e.price .. " scrap") -- 📝 Text. --
        local buy = vgui.Create("DButton", row) -- 🔘 Buy. --
        buy:Dock(RIGHT) buy:SetWide(70) buy:SetText("Buy") -- 📝 Label. --
        buy:SetEnabled(scrap >= e.price) -- ✅ Gate. --
        buy.DoClick = function() -- 🖱️ Buy one lot. --
            if not IsValid(VCity._TradeEnt) then return end -- 🛑 Gone. --
            net.Start("VCity_TradeOp") net.WriteEntity(VCity._TradeEnt) net.WriteString("buy") net.WriteString(e.id) net.WriteUInt(1, 8) net.SendToServer() -- 📤 Send. --
        end
    end
    -- 💵 Sell row: sell 1 of each sellable owned. --
    for _, s in ipairs(VCity._ClientInv or {}) do -- 🔁 Owned. --
        if s.id == "scrap" then continue end -- 🙅 Skip cash. --
        local row = vgui.Create("DPanel", list) -- 📦 Row. --
        row:Dock(TOP) row:SetTall(32) row:DockMargin(0, 4, 0, 0) -- 📐 Layout. --
        row.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(26, 34, 30, 255)) end -- 🎨 Paint. --
        local lbl = vgui.Create("DLabel", row) -- 🏷️ Label. --
        lbl:Dock(LEFT) lbl:SetWide(280) lbl:DockMargin(8, 0, 0, 0) -- 📐 Layout. --
        lbl:SetText("💵 Sell " .. ((VCity.Items[s.id] or {}).name or s.id) .. " x" .. s.count) -- 📝 Text. --
        local sell = vgui.Create("DButton", row) -- 🔘 Sell. --
        sell:Dock(RIGHT) sell:SetWide(70) sell:SetText("Sell 1") -- 📝 Label. --
        sell.DoClick = function() net.Start("VCity_TradeOp") net.WriteEntity(VCity._TradeEnt) net.WriteString("sell") net.WriteString(s.id) net.WriteUInt(1, 8) net.SendToServer() end -- 📤 Send. --
    end
    VCity.TradePanel = f -- 💾 Track. --
end
