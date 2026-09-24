-- 🔫 VotturCity | vcity_base | cl_init.lua 🔫 --
include("shared.lua") -- 📥 Shared. --
-- 🔭 Aim FOV zoom (client only, purely visual). --
hook.Add("CalcView", "VCity_AimFOV", function(ply, pos, ang, fov)
    local w = ply:GetActiveWeapon() -- 🔫 Weapon. --
    if IsValid(w) and w.GetVC_Aim and w:GetVC_Aim() then -- 🔭 Aiming. --
        return { origin = pos, angles = ang, fov = w.VC_AimFOV or 65 } -- 🔭 Zoomed. --
    end
end)
-- 🎯 Custom crosshair spread visualization is in cl_hud.lua. --
