-- 🎯 VotturCity | cl_hitmarkers.lua | Hit ticks + kill feed 🎯 --
-- 💻 Owner-side only; sounds + expiring feed list (no panels). --

VCity._Hits = VCity._Hits or {} -- 🎯 Recent hitmarkers {untilt, dmg, head, kill}. --
VCity._Feed = VCity._Feed or {} -- 📜 Kill feed {untilt, killer, victim, weapon, tk}. --

net.Receive("VCity_Hit", function() -- 📥 Hit. --
    local dmg = net.ReadUInt(8) -- 🔢 Damage. --
    local head = net.ReadBool() -- 🧠 Headshot. --
    local kill = net.ReadBool() -- 💀 Kill. --
    table.insert(VCity._Hits, { untilt = CurTime() + 0.8, dmg = dmg, head = head, kill = kill }) -- ➕ Store. --
    -- 🔊 Tick sound (pitch by severity). --
    surface.PlaySound(kill and "buttons/button9.wav" or (head and "buttons/button14.wav" or "ui/buttonclick.wav")) -- 🔊 Tick. --
    if #VCity._Hits > 8 then table.remove(VCity._Hits, 1) end -- 🧹 Cap. --
end)

net.Receive("VCity_Feed", function() -- 📥 Feed. --
    local killer = net.ReadString() -- 🔫 Killer. --
    local victim = net.ReadString() -- 💀 Victim. --
    local weapon = net.ReadString() -- 🔫 Weapon. --
    local tk = net.ReadBool() -- 👥 Teamkill. --
    table.insert(VCity._Feed, 1, { untilt = CurTime() + 8, killer = killer, victim = victim, weapon = weapon, tk = tk }) -- ➕ Prepend. --
    if #VCity._Feed > 6 then table.remove(VCity._Feed) end -- 🧹 Cap. --
end)

hook.Add("HUDPaint", "VCity_HitFeed", function() -- 🖥️ Draw. --
    local W, H = ScrW(), ScrH() -- 📐 Screen. --
    -- 🎯 Hitmarkers at crosshair (stacked alpha by age). --
    local cx, cy = W / 2, H / 2 -- 📍 Center. --
    for _, h in ipairs(VCity._Hits) do -- 🔁 Markers. --
        local left = h.untilt - CurTime() -- ⏱️ Remaining. --
        if left > 0 then -- ✅ Live. --
            local a = math.Clamp(left / 0.8, 0, 1) * 255 -- 📊 Alpha. --
            local col = h.kill and Color(255, 80, 80, a) or (h.head and Color(255, 200, 80, a) or Color(255, 255, 255, a)) -- 🎨 Color. --
            local s = h.kill and 14 or 10 -- 📐 Size. --
            surface.SetDrawColor(col) -- 🎨 Set. --
            surface.DrawLine(cx - s, cy - s, cx - s + 6, cy - s + 6) -- ↖️ Tick. --
            surface.DrawLine(cx + s, cy - s, cx + s - 6, cy - s + 6) -- ↗️ Tick. --
            surface.DrawLine(cx - s, cy + s, cx - s + 6, cy + s - 6) -- ↙️ Tick. --
            surface.DrawLine(cx + s, cy + s, cx + s - 6, cy + s - 6) -- ↘️ Tick. --
            if h.dmg and h.dmg > 0 then draw.SimpleText(h.dmg, "DermaDefault", cx, cy + 18, col, TEXT_ALIGN_CENTER) end -- 🔢 Damage number. --
        end
    end
    -- 📜 Kill feed top-right. --
    local y = 60 -- 📍 Start. --
    for _, e in ipairs(VCity._Feed) do -- 🔁 Entries. --
        if e.untilt - CurTime() > 0 then -- ✅ Live. --
            local txt = e.killer .. "  [" .. e.weapon .. "]  " .. e.victim -- 📝 Line. --
            draw.SimpleText(txt, "DermaDefault", W - 16, y, e.tk and Color(255, 120, 255) or color_white, TEXT_ALIGN_RIGHT) -- 📝 Draw. --
            y = y + 18 -- 📐 Next. --
        end
    end
end)
