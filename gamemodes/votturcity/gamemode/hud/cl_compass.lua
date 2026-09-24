-- 🧭 VotturCity | cl_compass.lua | Compass + clock + event banners 🧭 --
-- 💻 Pure HUD math (no net beyond globals); one HUDPaint hook. --

hook.Add("HUDPaint", "VCity_Compass", function() -- 🧭 Draw. --
    local ply = LocalPlayer() -- 👤 Local. --
    if not IsValid(ply) then return end -- 🛑 Invalid. --
    local W = ScrW() -- 📐 Width. --
    local yaw = ply:EyeAngles().y -- 🧭 Yaw (-180..180). --
    -- 🧭 Compass strip top-center (120px window around facing). --
    local cx = W / 2 -- 📍 Center. --
    draw.RoundedBox(4, cx - 130, 8, 260, 30, Color(10, 12, 16, 200)) -- ⬛ Bg. --
    local dirs = { { a = 0, t = "E" }, { a = 45, t = "NE" }, { a = 90, t = "N" }, { a = 135, t = "NW" }, { a = 180, t = "W" }, { a = -135, t = "SW" }, { a = -90, t = "S" }, { a = -45, t = "SE" } } -- 🧭 Points (GMod yaw: 0=E-ish). --
    for _, d in ipairs(dirs) do -- 🔁 Points. --
        local diff = math.AngleDifference(yaw, d.a) -- 📐 Offset. --
        if math.abs(diff) < 70 then -- 👀 Visible window. --
            local x = cx + diff * 1.6 -- 📍 X. --
            draw.SimpleText(d.t, "DermaDefaultBold", x, 16, math.abs(diff) < 8 and Color(255, 220, 120) or Color(180, 190, 200), TEXT_ALIGN_CENTER) -- 📝 Tick. --
        end
    end
    draw.SimpleText("▼", "DermaDefault", cx, 28, color_white, TEXT_ALIGN_CENTER) -- 📍 Needle. --
    -- 🕛 Clock + weather line under compass. --
    local hour = GetGlobalFloat("VCity_Time", 12) -- 🕛 Hour. --
    local hh = math.floor(hour) -- 🕛 HH. --
    local mm = math.floor((hour - hh) * 60) -- 🕛 MM. --
    local night = GetGlobalBool("VCity_Night", false) -- 🌙 Night? --
    local storm = GetGlobalBool("VCity_Storm", false) -- ⛈️ Storm? --
    local line = string.format("%02d:%02d  %s%s", hh, mm, night and "🌙 " or "☀️ ", storm and "  ☢️ STORM!" or "") -- 📝 Line. --
    draw.SimpleText(line, "DermaDefault", cx, 44, storm and Color(180, 255, 150) or Color(160, 170, 180), TEXT_ALIGN_CENTER) -- 📝 Draw. --
    -- 🏁 Capture banner + distance. --
    if GetGlobalBool("VCity_CapActive", false) then -- 🏁 Active. --
        local cap = GetGlobalVector("VCity_CapPos", Vector(0, 0, 0)) -- 📍 Pos. --
        local dist = math.floor(ply:GetPos():Distance(cap) / 52.8) -- 📏 Meters-ish. --
        local sPos = (cap + Vector(0, 0, 60)):ToScreen() -- 📍 Screen. --
        draw.SimpleText("🏁 CAPTURE " .. dist .. "m (" .. math.max(0, math.floor(GetGlobalFloat("VCity_CapUntil", 0) - CurTime())) .. "s)", "DermaDefaultBold", cx, 62, Color(255, 220, 120), TEXT_ALIGN_CENTER) -- 🏁 Banner. --
        if sPos.visible then draw.SimpleText("🏁", "DermaLarge", sPos.x, sPos.y, Color(255, 220, 120), TEXT_ALIGN_CENTER) end -- 🏁 Marker. --
    end
    -- 🩸 OD indicator (uses NW mirror from drugs module). --
    local od = ply:GetNWFloat("VCity_OD", 0) -- 💉 OD. --
    if od >= 40 then -- ⚠️ Showing. --
        draw.SimpleText("💉 OD " .. math.floor(od) .. (od >= 70 and " — NALOXONE NOW!" or ""), "DermaDefaultBold", cx, 80, od >= 70 and Color(255, 100, 200) or Color(200, 150, 255), TEXT_ALIGN_CENTER) -- 💉 Warn. --
    end
    -- 🤝 Drag indicator. --
    local dragging = ply:GetNWEntity("VCity_Dragging", NULL) -- 🤝 Dragged. --
    if IsValid(dragging) then draw.SimpleText("🤝 Dragging " .. dragging:Nick() .. " [G] release", "DermaDefault", cx, 96, Color(140, 220, 255), TEXT_ALIGN_CENTER) end -- 🤝 Note. --
end)
