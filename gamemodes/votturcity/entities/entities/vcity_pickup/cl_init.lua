-- 📦 VotturCity | vcity_pickup | cl_init.lua (client) 📦 --

include("shared.lua") -- 📥 Shared. --

-- 🏷️ Draw floating label so players can spot loot. --
function ENT:Draw()
    self:DrawModel() -- 🎨 Model first. --
    -- 📍 Label position above entity. --
    local pos = self:GetPos() + Vector(0, 0, 18) -- 📍 Above. --
    local ang = LocalPlayer():EyeAngles() -- 👁️ Face player. --
    ang:RotateAroundAxis(ang:Up(), -90) -- 🔄 Billboard yaw. --
    ang:RotateAroundAxis(ang:Forward(), 90) -- 🔄 Billboard pitch. --
    cam.Start3D2D(pos, ang, 0.12) -- 🎥 3D2D. --
        local itemId = self:GetNWString("VCity_Item", "?") -- 🆔 Item. --
        local count = self:GetNWInt("VCity_Count", 1) -- 🔢 Count. --
        local def = VCity.Items[itemId] -- 🧾 Def (client has registry). --
        local name = def and def.name or itemId -- 🏷️ Name. --
        draw.SimpleText(name .. " x" .. count, "DermaDefaultBold", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Text. --
        draw.SimpleText("[E] Pick up", "DermaDefault", 0, 14, Color(140, 220, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Hint. --
    cam.End3D2D() -- ✅ End. --
end
