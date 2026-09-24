-- 🛏️ VotturCity | vcity_bed | cl_init.lua 🛏️ --
include("shared.lua") -- 📥 Shared. --
function ENT:Draw() -- 🎨 Draw + label. --
    self:DrawModel() -- 🎨 Model. --
    local pos = self:GetPos() + Vector(0, 0, 30) -- 📍 Above. --
    local ang = LocalPlayer():EyeAngles() ang:RotateAroundAxis(ang:Up(), -90) ang:RotateAroundAxis(ang:Forward(), 90) -- 🔄 Billboard. --
    cam.Start3D2D(pos, ang, 0.12) -- 🎥 3D2D. --
        draw.SimpleText("🛏️ Bed", "DermaDefaultBold", 0, 0, Color(150, 200, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Title. --
        draw.SimpleText("[E] Set respawn", "DermaDefault", 0, 14, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Hint. --
    cam.End3D2D() -- ✅ End. --
end
