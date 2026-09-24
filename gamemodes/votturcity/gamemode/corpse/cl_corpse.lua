-- 💀 VotturCity | cl_corpse.lua | Corpse search UI 💀 --
-- 💻 Owner-side panel; server validates every take. --

VCity.CorpsePanel = VCity.CorpsePanel or nil -- 🪟 Open panel. --
VCity._CorpseEnt = nil -- 📦 Which box is open. --
VCity._CorpseLoot = {} -- 🎒 Cached contents. --

-- 📥 Corpse contents snapshot from server. --
net.Receive(VCity.Net.INTERACT_MENU, function()
    local box = net.ReadEntity() -- 📦 Box. --
    local n = net.ReadUInt(8) -- 🔢 Count. --
    local loot = {} -- 🎒 Fresh. --
    for i = 1, n do -- 🔁 Each. --
        table.insert(loot, { id = net.ReadString(), count = net.ReadUInt(10) }) -- 📦 Store. --
    end
    local owner = net.ReadString() -- 🏷️ Owner. --
    VCity._CorpseEnt = box -- 📦 Track. --
    VCity._CorpseLoot = loot -- 🎒 Cache. --
    VCity.Corpse_OpenPanel(owner) -- 🪟 Show. --
end)

-- 🪟 Build / refresh the search window (single instance). --
function VCity.Corpse_OpenPanel(ownerName)
    if IsValid(VCity.CorpsePanel) then VCity.CorpsePanel:Close() end -- 🧹 Close old. --
    local f = vgui.Create("DFrame") -- 🪟 Frame. --
    f:SetSize(420, 380) -- 📐 Size. --
    f:Center() -- 📍 Center. --
    f:SetTitle("💀 " .. (ownerName or "Corpse")) -- 🏷️ Title. --
    f:MakePopup() -- 🖱️ Mouse. --
    f.Paint = function(self, w, h) -- 🎨 Dark paint. --
        draw.RoundedBox(6, 0, 0, w, h, Color(12, 14, 18, 240)) -- ⬛ Bg. --
        draw.RoundedBox(6, 0, 0, w, 26, Color(40, 20, 20, 240)) -- 🟥 Header. --
    end
    local list = vgui.Create("DScrollPanel", f) -- 📜 List. --
    list:Dock(FILL) -- 📐 Fill. --
    list:DockMargin(8, 8, 8, 8) -- 📐 Margins. --
    if #VCity._CorpseLoot <= 0 then -- 📭 Empty. --
        local lbl = vgui.Create("DLabel", list) -- 🏷️ Label. --
        lbl:SetText("📭 Empty.") -- 📝 Text. --
        lbl:Dock(TOP) -- 📐 Top. --
    end
    for idx, stack in ipairs(VCity._CorpseLoot or {}) do -- 🔁 Each stack. --
        local def = VCity.Items[stack.id] -- 🧾 Def. --
        if not def then continue end -- 🛑 Unknown. --
        local row = vgui.Create("DPanel", list) -- 📦 Row. --
        row:Dock(TOP) -- 📐 Top. --
        row:SetTall(36) -- 📐 Height. --
        row:DockMargin(0, 0, 0, 4) -- 📐 Gap. --
        row.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(28, 32, 42, 255)) end -- 🎨 Paint. --
        local lbl = vgui.Create("DLabel", row) -- 🏷️ Label. --
        lbl:Dock(LEFT) -- 📐 Left. --
        lbl:SetWide(220) -- 📐 Width. --
        lbl:DockMargin(8, 0, 0, 0) -- 📐 Margin. --
        lbl:SetText("  " .. (def.name or stack.id) .. " x" .. stack.count) -- 📝 Text. --
        local take = vgui.Create("DButton", row) -- 🔘 Take. --
        take:Dock(RIGHT) -- 📐 Right. --
        take:SetWide(80) -- 📐 Width. --
        take:SetText("Take") -- 📝 Label. --
        take.DoClick = function() -- 🖱️ Click. --
            if not IsValid(VCity._CorpseEnt) then return end -- 🛑 Closed. --
            net.Start(VCity.Net.CORPSE_SEARCH) -- 💀 Open. --
            net.WriteEntity(VCity._CorpseEnt) -- 📦 Box. --
            net.WriteUInt(idx, 8) -- 🔢 Index. --
            net.WriteUInt(math.min(stack.count, 1023), 10) -- 🔢 Count (take all). --
            net.SendToServer() -- 📤 Send. --
            surface.PlaySound("ui/buttonclick.wav") -- 🔊 Click. --
        end
    end
    VCity.CorpsePanel = f -- 💾 Track. --
end
