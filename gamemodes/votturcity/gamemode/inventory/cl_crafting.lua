-- 🛠️ VotturCity | cl_crafting.lua | Crafting panel (C key) 🛠️ --
-- 💻 Lists recipes, owned mats, craft buttons. Server validates everything. --

VCity.CraftPanel = VCity.CraftPanel or nil -- 🪟 Panel. --

function VCity.Craft_Toggle() -- 🪟 Toggle. --
    if IsValid(VCity.CraftPanel) then VCity.CraftPanel:Close() VCity.CraftPanel = nil return end -- ❌ Close. --
    local f = vgui.Create("DFrame") -- 🪟 Frame. --
    f:SetSize(500, 480) -- 📐 Size. --
    f:Center() -- 📍 Center. --
    f:SetTitle("🛠️ Crafting") -- 🏷️ Title. --
    f:MakePopup() -- 🖱️ Mouse. --
    f.Paint = function(self, w, h) draw.RoundedBox(6, 0, 0, w, h, Color(12, 14, 18, 240)) draw.RoundedBox(6, 0, 0, w, 26, Color(30, 32, 24, 240)) end -- 🎨 Paint. --
    local list = vgui.Create("DScrollPanel", f) -- 📜 List. --
    list:Dock(FILL) -- 📐 Fill. --
    list:DockMargin(8, 8, 8, 8) -- 📐 Margins. --
    -- 🔍 Owned lookup. --
    local owned = {} -- 🎒 Counts. --
    for _, s in ipairs(VCity._ClientInv or {}) do owned[s.id] = (owned[s.id] or 0) + s.count end -- 🔁 Count. --
    for _, r in ipairs(VCity.Crafting.Recipes or {}) do -- 🔁 Recipes. --
        local row = vgui.Create("DPanel", list) -- 📦 Row. --
        row:Dock(TOP) -- 📐 Top. --
        row:SetTall(64) -- 📐 Height. --
        row:DockMargin(0, 0, 0, 4) -- 📐 Gap. --
        row.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(28, 32, 42, 255)) end -- 🎨 Paint. --
        -- 🧾 Needs string. --
        local needs = {} -- 📝 Parts. --
        local can = true -- ✅ Can craft? --
        for itemId, n in pairs(r.needs or {}) do -- 🔁 Needs. --
            local have = owned[itemId] or 0 -- 🎒 Have. --
            local nm = (VCity.Items[itemId] or {}).name or itemId -- 🏷️ Name. --
            table.insert(needs, nm .. " " .. have .. "/" .. n) -- 📝 Part. --
            if have < n then can = false end -- 🙅 Missing. --
        end
        local lbl = vgui.Create("DLabel", row) -- 🏷️ Label. --
        lbl:Dock(LEFT) -- 📐 Left. --
        lbl:SetWide(320) -- 📐 Width. --
        lbl:DockMargin(8, 4, 0, 4) -- 📐 Margin. --
        lbl:SetWrap(true) -- 📝 Wrap. --
        lbl:SetText((r.name or r.id) .. "\n" .. table.concat(needs, " + ") .. (r.fire and "  🔥fire" or "")) -- 📝 Text. --
        local btn = vgui.Create("DButton", row) -- 🔘 Craft. --
        btn:Dock(RIGHT) -- 📐 Right. --
        btn:SetWide(80) -- 📐 Width. --
        btn:DockMargin(0, 12, 8, 12) -- 📐 Margins. --
        btn:SetText("Craft") -- 📝 Label. --
        btn:SetEnabled(can) -- ✅ Gate. --
        btn.DoClick = function() -- 🖱️ Click. --
            net.Start("VCity_Craft") net.WriteString(r.id) net.SendToServer() -- 🛠️ Send. --
            surface.PlaySound("ui/buttonclick.wav") -- 🔊 Click. --
            f:Close() VCity.CraftPanel = nil -- ❌ Close (lock shows progress). --
        end
    end
    VCity.CraftPanel = f -- 💾 Track. --
end

-- ⌨️ C opens crafting (I = inventory, H = medical, C = craft, J = gear). --
hook.Add("PlayerButtonDown", "VCity_CraftKey", function(ply, btn)
    if ply ~= LocalPlayer() then return end -- 👤 Local. --
    if IsValid(vgui.GetKeyboardFocus()) and vgui.GetKeyboardFocus():GetClassName() == "TextEntry" then return end -- ⌨️ Typing. --
    if btn == KEY_C then VCity.Craft_Toggle() end -- 🛠️ Craft. --
end)
