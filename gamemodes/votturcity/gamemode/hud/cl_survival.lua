-- 🖥️ VotturCity | cl_survival.lua | Hunger / stamina / temp / oxygen HUD 🖥️ --
-- ⚡ Reads NW mirrors (no net spam), draws under the vitals cluster. --

-- 🎨 Palette for survival bars. --
local C_BG = Color(10, 12, 16, 200) -- ⬛ Bg. --
local C_HUNGER = Color(220, 170, 60) -- 🍖 Hunger. --
local C_THIRST = Color(70, 160, 255) -- 🥤 Thirst. --
local C_STAM = Color(120, 220, 120) -- ⚡ Stamina. --
local C_TEMP = Color(180, 120, 255) -- 🌡️ Temp. --
local C_OXY = Color(150, 220, 255) -- 🫁 Oxygen. --
local C_DIM = Color(160, 170, 180) -- 📝 Dim. --

local function Bar(x, y, w, h, frac, col) -- 📊 Mini bar helper. --
    draw.RoundedBox(3, x, y, w, h, C_BG) -- ⬛ Bg. --
    local fw = math.Clamp(frac, 0, 1) * (w - 4) -- 📐 Fill. --
    if fw > 0 then draw.RoundedBox(3, x + 2, y + 2, fw, h - 4, col) end -- 🟨 Fill. --
end

hook.Add("HUDPaint", "VCity_SurvivalHUD", function() -- 🖥️ Draw. --
    local ply = LocalPlayer() -- 👤 Local. --
    if not IsValid(ply) or not ply:Alive() then return end -- 🛑 Dead. --
    local W, H = ScrW(), ScrH() -- 📐 Screen. --
    local x, y = 16, H - 120 + 142 + 8 -- 📍 Below vitals panel. --
    local hunger = ply:GetNWFloat("VCity_Hunger", 100) -- 🍖 Hunger. --
    local thirst = ply:GetNWFloat("VCity_Thirst", 100) -- 🥤 Thirst. --
    local stam = ply:GetNWFloat("VCity_Stamina", 100) -- ⚡ Stamina. --
    local temp = ply:GetNWFloat("VCity_Temp", 37) -- 🌡️ Temp. --
    local oxy = ply:GetNWFloat("VCity_Oxygen", 100) -- 🫁 Oxygen. --
    draw.RoundedBox(6, x - 8, y - 8, 300, 96, C_BG) -- ⬛ Panel. --
    draw.SimpleText("🍖 " .. math.floor(hunger) .. "   🥤 " .. math.floor(thirst), "DermaDefault", x, y, C_DIM) -- 🍖 Text. --
    Bar(x, y + 16, 137, 8, hunger / 100, C_HUNGER) -- 🍖 Bar. --
    Bar(x + 147, y + 16, 137, 8, thirst / 100, C_THIRST) -- 🥤 Bar. --
    draw.SimpleText("⚡ " .. math.floor(stam) .. "   🌡️ " .. string.format("%.1f", temp) .. "°C", "DermaDefault", x, y + 30, C_DIM) -- ⚡ Text. --
    Bar(x, y + 46, 137, 8, stam / 100, C_STAM) -- ⚡ Bar. --
    local tempFrac = 1 - math.abs(temp - 37) / 7 -- 🌡️ 1 = perfect, 0 = extreme. --
    Bar(x + 147, y + 46, 137, 8, tempFrac, C_TEMP) -- 🌡️ Bar. --
    -- 🫁 Oxygen only shows underwater (saves space otherwise). --
    if ply:WaterLevel() >= 2 then -- 🌊 Submerged. --
        draw.SimpleText("🫁 OXYGEN " .. math.floor(oxy), "DermaDefaultBold", x, y + 58, C_OXY) -- 🫁 Text. --
        Bar(x, y + 74, 284, 8, oxy / 100, C_OXY) -- 🫁 Bar. --
    else -- 🌤️ Warnings for starving / freezing. --
        local warn = nil -- ⚠️ Warning. --
        if hunger <= 0 then warn = "🍖 STARVING — EAT! [I]" elseif thirst <= 0 then warn = "🥤 DEHYDRATED — DRINK! [I]" elseif temp < 35 then warn = "🥶 HYPOTHERMIA — FIND FIRE! 🔥" elseif temp > 39 then warn = "🥵 HEATSTROKE — COOL OFF!" end -- ⚠️ Pick. --
        if warn then draw.SimpleText(warn, "DermaDefaultBold", x, y + 62, Color(255, 140, 100)) end -- ⚠️ Draw. --
    end
end)

-- 🌀 Drunk / pain wobble (cheap motion blur when flagged). --
hook.Add("RenderScreenspaceEffects", "VCity_Wobble", function() -- 🌀 FX. --
    local ply = LocalPlayer() -- 👤 Local. --
    if not IsValid(ply) then return end -- 🛑 Invalid. --
    -- 🌀 Wobble uses a NW-free trick: server sets a client var via notify? Instead read pain. --
    local pain = ply:GetNWFloat("VCity_Pain", 0) -- 😖 Pain. --
    if pain > 90 then DrawMotionBlur(0.15, 0.6, 0.02) end -- 🌀 Heavy pain sway. --
end)
