-- 🏥 VotturCity | vcity_medstation | cl_init.lua 🏥 --
include("shared.lua") -- 📥 Shared. --
function ENT:Draw()
    self:DrawModel() -- 🎨 Draw. --
    -- 🏷️ Floating charges label. --
    local pos = self:GetPos() + Vector(0, 0, 70) -- 📍 Above. --
    local ang = LocalPlayer():EyeAngles() -- 👁️ Face. --
    ang:RotateAroundAxis(ang:Up(), -90) -- 🔄 Billboard. --
    ang:RotateAroundAxis(ang:Forward(), 90) -- 🔄 Billboard. --
    cam.Start3D2D(pos, ang, 0.12) -- 🎥 3D2D. --
        draw.SimpleText("🏥 Medical Station", "DermaDefaultBold", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Title. --
        draw.SimpleText(self:GetNWInt("VCity_Charges", 0) .. " charges  [E]", "DermaDefault", 0, 14, Color(140, 255, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Charges. --
    cam.End3D2D() -- ✅ End. --
end
