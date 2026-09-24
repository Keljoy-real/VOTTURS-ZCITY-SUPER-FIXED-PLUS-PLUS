-- 📦 VotturCity | vcity_airdrop | cl_init.lua 📦 --
include("shared.lua") -- 📥 Shared. --
function ENT:Draw() -- 🎨 Draw + label. --
    self:DrawModel() -- 🎨 Model. --
    local pos = self:GetPos() + Vector(0, 0, 40) -- 📍 Above. --
    local ang = LocalPlayer():EyeAngles() ang:RotateAroundAxis(ang:Up(), -90) ang:RotateAroundAxis(ang:Forward(), 90) -- 🔄 Billboard. --
    cam.Start3D2D(pos, ang, 0.15) -- 🎥 3D2D. --
        draw.SimpleText("📦 AIRDROP", "DermaDefaultBold", 0, 0, Color(255, 220, 120), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Title. --
        draw.SimpleText(self:GetNWBool("VCity_Landed", false) and "[E] Loot" or "🪂 Inbound...", "DermaDefault", 0, 16, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 State. --
    cam.End3D2D() -- ✅ End. --
end
