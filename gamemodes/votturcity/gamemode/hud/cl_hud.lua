-- 🖥️ VotturCity | cl_hud.lua | Dark minimal survival HUD 🖥️ --
-- ⚡ ONE HUDPaint hook, cached values, no panel recreation, no per-frame allocation. --

-- 🎨 Palette (dark minimal). --
local C_BG = Color(10, 12, 16, 200) -- ⬛ Panel bg. --
local C_HP = Color(220, 80, 80) -- ❤️ Health. --
local C_BLOOD = Color(180, 30, 30) -- 🩸 Blood. --
local C_PAIN = Color(220, 160, 60) -- 😖 Pain. --
local C_ADRE = Color(90, 200, 255) -- 💉 Adrenaline. --
local C_TXT = color_white -- 📝 Text. --
local C_DIM = Color(160, 170, 180) -- 📝 Dim text. --

-- 💾 Cached bar values (lerped for smoothness without extra cost). --
local dispHP, dispBlood, dispPain = 100, 5000, 0 -- 📊 Displayed. --

-- 🙈 Hide default HUD bits we replace. --
hook.Add("HUDShouldDraw", "VCity_HideDefault", function(name)
    if name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" or name == "CHudSecondaryAmmo" then -- 🙈 Ours replaces. --
        return false -- 🙅 Hide. --
    end
end)

-- 📦 Small helper: dark bar with fill fraction. --
local function Bar(x, y, w, h, frac, col)
    draw.RoundedBox(4, x, y, w, h, C_BG) -- ⬛ Bg. --
    local fw = math.Clamp(frac, 0, 1) * (w - 4) -- 📐 Fill width. --
    if fw > 0 then draw.RoundedBox(4, x + 2, y + 2, fw, h - 4, col) end -- 🟥 Fill. --
end

-- 🖥️ Main HUD: health/blood/pain/adrenaline + ammo + prompts + state. --
hook.Add("HUDPaint", "VCity_HUD", function()
    local ply = LocalPlayer() -- 👤 Local. --
    if not IsValid(ply) then return end -- 🛑 Invalid. --
    local W, H = ScrW(), ScrH() -- 📐 Screen. --

    -- ❤️ Vitals from NW mirrors (cheap, auto-updated). --
    local hp = ply:Health() -- ❤️ HP. --
    local maxhp = ply:GetMaxHealth() -- 💯 Max. --
    local blood = ply:GetNWFloat("VCity_Blood", VCity.Config.BloodMax) -- 🩸 Blood. --
    local pain = ply:GetNWFloat("VCity_Pain", 0) -- 😖 Pain. --
    local adre = ply:GetNWFloat("VCity_Adre", 0) -- 💉 Adrenaline. --
    local bleed = ply:GetNWInt("VCity_Bleed", 0) -- 🩸 Bleed. --
    local state = VCity.State_Get(ply) -- 🚦 State. --
    local xp, lvl = ply:GetNWInt("VCity_XP", 0), ply:GetNWInt("VCity_Level", 1) -- ⭐ XP. --

    -- 📊 Smooth lerp (frame-rate independent-ish, cheap). --
    local k = math.Clamp(FrameTime() * 6, 0, 1) -- 📐 Lerp factor. --
    dispHP = Lerp(k, dispHP, hp) -- ❤️ Smooth. --
    dispBlood = Lerp(k, dispBlood, blood) -- 🩸 Smooth. --
    dispPain = Lerp(k, dispPain, pain) -- 😖 Smooth. --

    -- 📍 Bottom-left vitals cluster. --
    local x, y = 16, H - 120 -- 📍 Origin. --
    draw.RoundedBox(6, x - 8, y - 30, 300, 142, C_BG) -- ⬛ Panel. --
    draw.SimpleText("❤️ " .. math.max(0, math.floor(dispHP)) .. " / " .. maxhp, "DermaDefaultBold", x, y - 22, C_TXT) -- ❤️ HP text. --
    Bar(x, y, 284, 14, dispHP / math.max(1, maxhp), C_HP) -- ❤️ HP bar. --
    draw.SimpleText("🩸 " .. math.floor(dispBlood) .. " mL" .. (bleed > 0 and "  ⚠️ BLEEDING x" .. bleed or ""), "DermaDefault", x, y + 18, bleed > 0 and C_BLOOD or C_DIM) -- 🩸 Blood text. --
    Bar(x, y + 34, 284, 10, dispBlood / VCity.Config.BloodMax, C_BLOOD) -- 🩸 Blood bar. --
    draw.SimpleText("😖 Pain " .. math.floor(dispPain) .. (adre > 0 and "   💉 Adrenaline " .. math.floor(adre) .. "s" or ""), "DermaDefault", x, y + 48, C_DIM) -- 😖 Pain text. --
    Bar(x, y + 64, 284, 8, dispPain / VCity.Config.PainMax, C_PAIN) -- 😖 Pain bar. --
    if adre > 0 then Bar(x, y + 76, 284, 6, math.Clamp(adre / VCity.Config.AdrenalineTime, 0, 1), C_ADRE) end -- 💉 Adrenaline bar. --
    -- ⭐ Level line. --
    local need = VCity.XP_ForLevel(lvl) -- 📈 Needed. --
    draw.SimpleText("⭐ Lv " .. lvl .. "  (" .. xp .. " / " .. need .. " XP)", "DermaDefault", x, y + 86, C_DIM) -- ⭐ Text. --
    Bar(x, y + 102, 284, 6, xp / math.max(1, need), Color(150, 130, 255)) -- ⭐ Bar. --

    -- 🔫 Bottom-right ammo cluster. --
    local w = IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon() or nil -- 🔫 Weapon. --
    if IsValid(w) then -- ✅ Have weapon. --
        local clip = w:Clip1() -- 🔢 Mag. --
        local wclass = w:GetClass() -- 🏷️ Class. --
        -- 🎒 Reserve lookup from client inventory cache. --
        local reserve = 0 -- 🎒 Reserve. --
        local ammoItem = nil -- 🆔 Ammo id. --
        if w.VC_AmmoItem then ammoItem = w.VC_AmmoItem end -- 🆔 From weapon. --
        if ammoItem then reserve = VCity.Inventory_Count(VCity._ClientInv, ammoItem) end -- 🎒 Count. --
        local ax = W - 216 -- 📍 Origin. --
        draw.RoundedBox(6, ax - 8, H - 90, 200, 74, C_BG) -- ⬛ Panel. --
        draw.SimpleText("🔫 " .. (w.PrintName or wclass), "DermaDefaultBold", ax, H - 82, C_TXT) -- 🔫 Name. --
        draw.SimpleText(clip .. "  /  " .. reserve, "DermaLarge", ax, H - 60, C_TXT) -- 🔢 Counts. --
        -- 🔧 Condition bar for firearms. --
        if w.GetVC_Cond then -- 🔧 Has condition. --
            local cond = w:GetVC_Cond() -- 🔧 Value. --
            Bar(ax, H - 30, 184, 6, cond / 100, cond < 25 and C_BLOOD or C_DIM) -- 🔧 Bar. --
        end
        -- 🎯 Crosshair (dynamic gap by aiming + movement). --
        if ply:Alive() and not w.NoCrosshair then -- 🎯 Draw. --
            local cx, cy = W / 2, H / 2 -- 📍 Center. --
            local gap = w.GetVC_Aim and w:GetVC_Aim() and 6 or 14 -- 📐 Gap. --
            local len = 8 -- 📐 Length. --
            surface.SetDrawColor(255, 255, 255, 200) -- 🎨 Color. --
            surface.DrawLine(cx - gap - len, cy, cx - gap, cy) -- ⬅️ Left. --
            surface.DrawLine(cx + gap, cy, cx + gap + len, cy) -- ➡️ Right. --
            surface.DrawLine(cx, cy - gap - len, cx, cy - gap) -- ⬆️ Up. --
            surface.DrawLine(cx, cy + gap, cx, cy + gap + len) -- ⬇️ Down. --
            surface.DrawRect(cx - 1, cy - 1, 2, 2) -- ⏺️ Dot. --
        end
    end

    -- 🏷️ Interaction prompt (center-bottom). --
    if VCity._InteractLabel and VCity._InteractLabel ~= "" and ply:Alive() then -- 🤝 Have prompt. --
        draw.SimpleText(VCity._InteractLabel .. "  [E]", "DermaDefaultBold", W / 2, H / 2 + 60, Color(140, 220, 255), TEXT_ALIGN_CENTER) -- 🏷️ Prompt. --
    end

    -- 🚦 State banner (KO / interacting / recovering). --
    if state == VCity.State.UNCONSCIOUS then -- 😵 KO. --
        draw.SimpleText("😵 UNCONSCIOUS", "DermaLarge", W / 2, H * 0.3, Color(255, 120, 120), TEXT_ALIGN_CENTER) -- 😵 Text. --
    elseif state == VCity.State.INTERACTING then -- 🤝 Busy. --
        draw.SimpleText("🤝 " .. (ply.VCity_LockLabel or "Working..."), "DermaLarge", W / 2, H * 0.3, Color(140, 220, 255), TEXT_ALIGN_CENTER) -- 🤝 Text. --
    elseif state == VCity.State.BLEEDING then -- 🩸 Bleeding flash (slow blink, no spam). --
        if math.floor(CurTime() * 1.5) % 2 == 0 then -- ✨ Blink. --
            draw.SimpleText("🩸 YOU ARE BLEEDING — BANDAGE! [H]", "DermaDefaultBold", W / 2, H * 0.25, C_BLOOD, TEXT_ALIGN_CENTER) -- 🩸 Warning. --
        end
    elseif bleed > 0 then -- 🩸 Mild bleed hint. --
        draw.SimpleText("🩸 Bleeding — press H for medical", "DermaDefault", W / 2, H * 0.25, C_DIM, TEXT_ALIGN_CENTER) -- 🩸 Hint. --
    end

    -- 🦴 Fracture indicator (small, top-center). --
    local limbs = VCity._LimbsCache -- 🦴 Cache. --
    if limbs then -- ✅ Have. --
        local fx = {} -- 🦴 Broken list. --
        for id = 1, 9 do -- 🔁 Limbs. --
            if limbs[id] and limbs[id].fracture then table.insert(fx, VCity.LimbDefs[id].name) end -- 🦴 Broken. --
        end
        if #fx > 0 then -- 🦴 Any. --
            draw.SimpleText("🦴 Fracture: " .. table.concat(fx, ", "), "DermaDefault", W / 2, 30, Color(255, 160, 100), TEXT_ALIGN_CENTER) -- 🦴 Text. --
        end
    end
end)

-- 🩸 Blood overlay: red vignette scales with blood loss (cheap DrawRect + alpha). --
hook.Add("RenderScreenspaceEffects", "VCity_BloodOverlay", function()
    local ply = LocalPlayer() -- 👤 Local. --
    if not IsValid(ply) or not ply:Alive() then return end -- 🛑 Dead. --
    local blood = ply:GetNWFloat("VCity_Blood", VCity.Config.BloodMax) -- 🩸 Blood. --
    local frac = 1 - (blood / VCity.Config.BloodMax) -- 📊 Lost fraction. --
    if frac > 0.25 then -- 🩸 Noticeable loss. --
        DrawMotionBlur(0, 0, 0) -- 🙅 No-op keep (cheap). --
        -- 🟥 Red edges via surface in HUDPaint would need overlay; use color modify. --
        local tab = { ["$pp_colour_addr"] = frac * 0.25, ["$pp_colour_addg"] = 0, ["$pp_colour_addb"] = 0, ["$pp_colour_brightness"] = -frac * 0.08, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 1 - frac * 0.25, ["$pp_colour_mulr"] = 0, ["$pp_colour_mulg"] = 0, ["$pp_colour_mulb"] = 0 } -- 🎨 Grade. --
        DrawColorModify(tab) -- 🎨 Apply. --
    end
    -- 😖 Pain blur at extreme pain (subtle). --
    local pain = ply:GetNWFloat("VCity_Pain", 0) -- 😖 Pain. --
    if pain > 80 then -- 😖 Extreme. --
        DrawMotionBlur(0.1, 0.5, 0.01) -- 🌀 Slight blur. --
    end
end)
