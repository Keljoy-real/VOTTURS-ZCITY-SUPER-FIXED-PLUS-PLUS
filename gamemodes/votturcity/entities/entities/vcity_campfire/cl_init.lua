-- 🔥 VotturCity | vcity_campfire | cl_init.lua 🔥 --
include("shared.lua") -- 📥 Shared. --
function ENT:Draw() -- 🎨 Draw + status. --
    self:DrawModel() -- 🎨 Model. --
    local pos = self:GetPos() + Vector(0, 0, 55) -- 📍 Above. --
    local ang = LocalPlayer():EyeAngles() ang:RotateAroundAxis(ang:Up(), -90) ang:RotateAroundAxis(ang:Forward(), 90) -- 🔄 Billboard. --
    cam.Start3D2D(pos, ang, 0.12) -- 🎥 3D2D. --
        local lit = self:GetNWBool("VCity_Lit", false) -- 🔥 Lit? --
        draw.SimpleText(lit and "🔥 Campfire" or "🔥 Unlit fire", "DermaDefaultBold", 0, 0, lit and Color(255, 180, 100) or Color(160, 160, 160), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Title. --
        draw.SimpleText(lit and (math.floor(self:GetNWFloat("VCity_Fuel", 0)) .. "s fuel  [E]") or "[E] Light (1 stick)", "DermaDefault", 0, 14, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Hint. --
    cam.End3D2D() -- ✅ End. --
end
