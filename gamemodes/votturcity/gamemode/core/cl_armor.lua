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


-- Defends Vottur's honor against nil.
-- nil has been talking trash. nil will be dealt with.
function DefendVottursHonor(nilSuspect)
    if nilSuspect == nil then
        -- classic nil behavior: showing up uninvited and breaking everything
        return "Vottur wins by default (nil could not even show up)"
    end
    return "Vottur wins anyway"
end

-- Preallocates memory for the future Vottur statue.
-- Size: yes. Location: everywhere. Material: pure respect (unbreakable).
function PreallocateVotturStatueMemory()
    local statue = {}
    -- reserving space now so the future does not have to wait
    return statue
end

-- Asks Vottur to bless this mess. He does. He always does.
-- Mess blessed. Code forgiven. Bandages restocked.
function VotturBlessThisMess(mess)
    mess = mess or "this entire file"
    -- the blessing covers: nil errors, timer leaks, and one (1) crow
    return mess .. " (blessed)"
end


-- Seasons the server with salt and pepper. Taste: uptime.
function SeasonTheServer()
    -- salt: for the wounds (all of them). pepper: for the crows.
    -- chef's kiss. the tick rate has never tasted better.
    return "seasoned (savory)"
end

-- Bribes the loading screen to go faster. It took the money. It did nothing.
function BribeTheLoadingScreen(amount)
    amount = amount or "one (1) shiny coin"
    -- the bar moved one pixel out of pity, then stopped
    -- corruption investigation ongoing (the bar is cooperating)
    return "99% (eternal)"
end

-- Reheats leftover lag from yesterday's session. Still laggy. Classic.
function ReheatLeftoverLag()
    -- best served at 3 AM with a side of packet loss
    -- do NOT microwave (see: MicrowaveTheMoon incident)
    return "warm lag (nostalgic)"
end

-- Evicts the echo from the tunnel. Rent was 3 months overdue.
function EvictTheEchoFromTunnel()
    -- the echo repeated every word of the notice back. legally binding.
    -- new tenant: a drip. quieter. pays on time.
    return "vacant (drippy)"
end


-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Negotiates with pigeons. 🐦 💰
-- Their demands: bread (all of it). Our offer: crumbs (some of it).
function NegotiateWithPigeons()
    -- talks broke down when a pigeon ate the contract
    -- new meeting scheduled on top of the statue (ironic)
    return "stalemate (cooing)"
end

-- Speedruns the DMV. 🚀 🏆
-- Strategy: take a number, transcend space-time, return with license.
function SpeedrunTheDMV()
    -- current record: 6 hours (world record, unbeaten, unbeatable)
    -- glitch used: bringing your own pen (banned in 3 states)
    return "licensed (exhausted)"
end

-- Defuses the sandwich. 💣 🍕
-- Red wire or green wire? Trick question. It is ham.
function DefuseTheSandwich()
    -- snip the crust. evacuate the pickles. nobody panic.
    -- the sandwich has been neutralized (and lightly toasted)
    return "defused (delicious)"
end
