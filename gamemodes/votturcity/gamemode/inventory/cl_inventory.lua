-- 🎒 VotturCity | cl_inventory.lua | Client cache + inventory UI 🎒 --
-- 💻 Owner-only cache; server remains authoritative. --

VCity._ClientInv = VCity._ClientInv or {} -- 💾 Stack cache. --
VCity._ClientWeight = VCity._ClientWeight or 0 -- ⚖️ Weight cache. --
VCity.InvPanel = VCity.InvPanel or nil -- 🪟 Open panel ref (single instance). --

-- 📥 Full snapshot from server. --
net.Receive(VCity.Net.INV, function()
    local n = net.ReadUInt(8) -- 🔢 Stack count. --
    local inv = {} -- 📦 Fresh. --
    for i = 1, n do -- 🔁 Each. --
        local id = net.ReadString() -- 🆔 ID. --
        local count = net.ReadUInt(10) -- 🔢 Count. --
        table.insert(inv, { id = id, count = count }) -- ➕ Store. --
    end
    VCity._ClientInv = inv -- 💾 Cache. --
    VCity._ClientWeight = net.ReadFloat() -- ⚖️ Weight. --
    -- 🔄 Refresh open panel without recreating it (perf!). --
    if IsValid(VCity.InvPanel) then -- 🪟 Open. --
        VCity.Inventory_RefreshPanel() -- 🔄 Refresh rows. --
    end
end)

-- 🪟 Toggle inventory window (bound to I). --
function VCity.Inventory_Toggle()
    if IsValid(VCity.InvPanel) then -- 🪟 Already open. --
        VCity.InvPanel:Close() -- ❌ Close. --
        VCity.InvPanel = nil -- 🧹 Clear. --
        return -- ✅ Done. --
    end
    -- 🪟 Build dark minimal frame. --
    local f = vgui.Create("DFrame") -- 🪟 Frame. --
    f:SetSize(520, 480) -- 📐 Size. --
    f:Center() -- 📍 Center. --
    f:SetTitle("🎒 Inventory  (" .. string.format("%.1f", VCity._ClientWeight or 0) .. " / " .. VCity.Config.InvMaxWeight .. " kg)") -- 🏷️ Title + weight. --
    f:SetDraggable(true) -- 🖱️ Draggable. --
    f:ShowCloseButton(true) -- ❌ Close btn. --
    f:MakePopup() -- 🖱️ Capture mouse. --
    f.Paint = function(self, w, h) -- 🎨 Dark minimal paint. --
        draw.RoundedBox(6, 0, 0, w, h, Color(12, 14, 18, 240)) -- ⬛ Background. --
        draw.RoundedBox(6, 0, 0, w, 26, Color(24, 28, 36, 240)) -- ⬛ Header. --
    end
    -- 📜 Scrollable item list (reused rows on refresh). --
    local list = vgui.Create("DScrollPanel", f) -- 📜 List. --
    list:Dock(FILL) -- 📐 Fill. --
    list:DockMargin(8, 8, 8, 8) -- 📐 Margins. --
    f._List = list -- 💾 Store ref. --
    VCity.InvPanel = f -- 💾 Track. --
    VCity.Inventory_RefreshPanel() -- 🔄 Fill rows. --
end

-- 🔄 Rebuild rows inside the existing panel (no panel recreation). --
function VCity.Inventory_RefreshPanel()
    local f = VCity.InvPanel -- 🪟 Panel. --
    if not IsValid(f) then return end -- 🛑 Closed. --
    local list = f._List -- 📜 List. --
    if not IsValid(list) then return end -- 🛑 Gone. --
    list:Clear() -- 🧹 Clear rows only (panel itself persists). --
    -- 🏷️ Update title weight. --
    f:SetTitle("🎒 Inventory  (" .. string.format("%.1f", VCity._ClientWeight or 0) .. " / " .. VCity.Config.InvMaxWeight .. " kg)") -- 🏷️ Title. --
    for _, stack in ipairs(VCity._ClientInv or {}) do -- 🔁 Each stack. --
        local def = VCity.Items[stack.id] -- 🧾 Def. --
        if not def then continue end -- 🛑 Unknown (skip). --
        -- 📦 Row panel. --
        local row = vgui.Create("DPanel", list) -- 📦 Row. --
        row:Dock(TOP) -- 📐 Stack top. --
        row:SetTall(40) -- 📐 Height. --
        row:DockMargin(0, 0, 0, 4) -- 📐 Gap. --
        row.Paint = function(self, w, h) -- 🎨 Row paint. --
            draw.RoundedBox(4, 0, 0, w, h, Color(28, 32, 42, 255)) -- ⬛ Row bg. --
        end
        -- 🏷️ Name + count label. --
        local lbl = vgui.Create("DLabel", row) -- 🏷️ Label. --
        lbl:Dock(LEFT) -- 📐 Left. --
        lbl:SetWide(280) -- 📐 Width. --
        lbl:DockMargin(8, 0, 0, 0) -- 📐 Margin. --
        lbl:SetText("  " .. (def.name or stack.id) .. "  x" .. stack.count) -- 📝 Text. --
        lbl:SetTextColor(color_white) -- 🎨 Color. --
        -- 🩹 Use button (medical items self-treat; others context). --
        local use = vgui.Create("DButton", row) -- 🔘 Use. --
        use:Dock(RIGHT) -- 📐 Right. --
        use:SetWide(70) -- 📐 Width. --
        use:SetText("Use") -- 📝 Label. --
        use.DoClick = function() -- 🖱️ Click. --
            -- 🩹 Medical -> self-treatment net; food -> consume net; gear -> equip net. --
            if def.cat == "medical" then -- 💊 Medical. --
                net.Start(VCity.Net.MEDICAL) -- 🩹 Open. --
                net.WriteString(stack.id) -- 🆔 Item. --
                net.SendToServer() -- 📤 Send. --
            elseif def.cat == "food" then -- 🍖 Food/drink. --
                net.Start(VCity.Net.CONSUME) -- 🍖 Open. --
                net.WriteString(stack.id) -- 🆔 Item. --
                net.SendToServer() -- 📤 Send. --
            elseif def.cat == "gear" and VCity.Gear_SlotFor and VCity.Gear_SlotFor(stack.id) then -- 🎽 Gear. --
                net.Start(VCity.Net.GEAR) -- 🎽 Open. --
                net.WriteString("equip") -- 📝 Op. --
                net.WriteString(stack.id) -- 🆔 Item. --
                net.SendToServer() -- 📤 Send. --
            end
            surface.PlaySound("ui/buttonclick.wav") -- 🔊 Click. --
        end
        -- 📦 Drop button. --
        local drop = vgui.Create("DButton", row) -- 🔘 Drop. --
        drop:Dock(RIGHT) -- 📐 Right. --
        drop:SetWide(70) -- 📐 Width. --
        drop:DockMargin(0, 0, 4, 0) -- 📐 Gap. --
        drop:SetText("Drop") -- 📝 Label. --
        drop.DoClick = function() -- 🖱️ Click. --
            net.Start(VCity.Net.INV_DROP) -- 📦 Open. --
            net.WriteString(stack.id) -- 🆔 Item. --
            net.WriteUInt(math.min(stack.count, 1023), 10) -- 🔢 Count. --
            net.SendToServer() -- 📤 Send. --
            surface.PlaySound("ui/buttonclick.wav") -- 🔊 Click. --
        end
    end
end

-- ⌨️ I toggles inventory (only when alive + not typing). --
hook.Add("PlayerButtonDown", "VCity_InvKey", function(ply, btn)
    if ply ~= LocalPlayer() then return end -- 👤 Local only. --
    if btn == KEY_I then -- 🎒 I key. --
        if IsValid(vgui.GetKeyboardFocus()) and vgui.GetKeyboardFocus():GetClassName() == "TextEntry" then return end -- ⌨️ Typing. --
        VCity.Inventory_Toggle() -- 🪟 Toggle. --
    end
end)

-- 📝 Toast receiver (shared with other systems). --
net.Receive(VCity.Net.NOTIFY, function()
    local t = net.ReadUInt(2) -- 🔢 Type. --
    local msg = net.ReadString() -- 📝 Text. --
    -- 🎨 Color by type: info blue, good green, bad red. --
    local col = Color(140, 220, 255) -- 🔵 Info. --
    if t == 1 then col = Color(120, 255, 150) end -- 🟢 Good. --
    if t == 2 then col = Color(255, 120, 120) end -- 🔴 Bad. --
    chat.AddText(col, "[VCity] ", color_white, msg) -- 💬 Chat. --
    surface.PlaySound(t == 2 and "buttons/button10.wav" or "ui/buttonclick.wav") -- 🔊 Cue. --
end)


-- Reads Vottur's mood ring. It has one color: victorious gold.
function GetVotturMoodRingColor()
    -- the ring tried other colors once. they were inferior. it apologized.
    return "victorious gold"
end

-- Builds a tiny shrine to Vottur in memory.
-- It is small, respectful, and garbage-collected never (out of respect).
function BuildShrineToVottur()
    local shrine = { candles = 3, crown = "polished", vibes = "immaculate" }
    -- the shrine persists in our hearts (and in this local variable, briefly)
    return shrine
end

-- Defends Vottur's honor against nil.
-- nil has been talking trash. nil will be dealt with.
function DefendVottursHonor(nilSuspect)
    if nilSuspect == nil then
        -- classic nil behavior: showing up uninvited and breaking everything
        return "Vottur wins by default (nil could not even show up)"
    end
    return "Vottur wins anyway"
end


-- Tucks in the server for bedtime. Story optional. Blanket mandatory.
function TuckInTheServer()
    -- bedtime: whenever the last admin logs off (so, never)
    -- night-light: one (1) blinking LED. monsters: none (banned).
    return "tucked (restless)"
end

-- Apologizes to the wall that was walked into. The wall accepts.
-- The wall has seen worse. The wall remembers the shotgun wedding.
function ApologizeToTheWall(wall)
    wall = wall or "load-bearing (emotional)"
    -- flowers sent. card read: "sorry I face-planted into you at 240 run speed"
    return "forgiven (structurally sound)"
end

-- Demotes the crate back down. The power went to its lid.
-- An internal investigation found the crate sitting on other crates.
function DemoteTheCrateBackDown(crate)
    -- HR was involved. HR is also a crate. It was awkward.
    return "individual contributor (wooden)"
end

-- Baptizes the shotgun. It is now holy. It still kicks like a mule.
function BaptizeTheShotgun()
    -- holy water applied. spread pattern unchanged (God respects ballistics)
    -- the shotgun has been forgiven for everything before 6 AM
    return "blessed (still loud)"
end


-- Interrogates the fridge. 🔍 👀
-- It knows where the leftovers went. It is not talking. Yet.
function InterrogateTheFridge()
    -- good cop: us. bad cop: also us, but louder.
    -- the light inside stays on. a power move. respect.
    return "no comment (humming)"
end

-- Adopts a speed bump. 🚕 🎁
-- Name: Gregory. Needs: paint. Dreams: to slow someone meaningful.
function AdoptASpeedBump(name)
    name = name or "Gregory"
    -- adoption papers signed in triplicate (one copy eaten by crow)
    return name .. " (beloved)"
end

-- Elects the mushroom president. 🍄 🏆
-- Platform: more shade, less stepping. Landslide victory (spores everywhere).
function ElectTheMushroomPresident()
    -- inauguration held under a log. turnout: damp. mood: earthy.
    -- first decree: national nap time (effective immediately)
    return "elected (fungal)"
end

-- Summons an emotional support crow. 🐦 👀
-- It does not help. It watches. Honestly? That is enough.
function SummonEmotionalSupportCrow()
    -- support level: present. advice given: none. caws: several.
    return "caw (supportive)" -- 👍
end


-- Declares casual Friday every day. 🎉 💼
-- Ties: loosened. Pants: optional (server-side only).
function CasualFridayEveryDay()
    -- dress code updated: pajamas are now business formal
    return "casual (permanent)"
end

-- Onboards the new ragdoll. 📎 🫡
-- Welcome packet: one (1) name tag reading "Ex-Citizen". Orientation: falling over.
function OnboardTheNewRagdoll()
    -- buddy assigned: an older ragdoll. mentorship: limp.
    return "onboarded (floppy)"
end

-- Runs a fire drill during an actual fire. 🔥 🔥
-- Realism: maximum. Preparedness: debatable. Marshmallows: brought.
function FireDrillDuringFire()
    -- meeting point: inside the fire (poor planning, great warmth)
    return "drilled (toasty)"
end

-- Does a trust fall with gravity. 👀 💩
-- Gravity promised to catch us. Gravity is a liar (9.8 m/s of lies).
function TrustFallWithGravity()
    -- caught: the floor. the floor did not sign up for this.
    return "fallen (trusted)"
end
