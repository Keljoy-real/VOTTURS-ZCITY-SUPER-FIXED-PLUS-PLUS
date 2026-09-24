-- 🤝 VotturCity | cl_interact.lua | Prompt + E handling 🤝 --
-- 💻 Client traces + shows prompt; server validates on press. --

VCity._InteractTarget = nil -- 🎯 Current aim target. --
VCity._InteractLabel = "" -- 🏷️ Current label. --

-- 🔍 Per-frame trace throttled to 10Hz (not every frame full classify). --
local nextCheck = 0 -- ⏱️ Next check time. --
hook.Add("Think", "VCity_InteractPrompt", function()
    if CurTime() < nextCheck then return end -- ⏱️ Throttle. --
    nextCheck = CurTime() + 0.1 -- ⏱️ 10Hz. --
    local ply = LocalPlayer() -- 👤 Local. --
    if not IsValid(ply) or not ply:Alive() then -- 🛑 Dead. --
        VCity._InteractTarget = nil -- 🧹 Clear. --
        VCity._InteractLabel = "" -- 🧹 Clear. --
        return -- 🛑 Stop. --
    end
    local ent = VCity.Interact_Trace(ply) -- 🔍 Trace. --
    if IsValid(ent) then -- ✅ Hit. --
        local kind, label = VCity.Interact_Classify(ply, ent) -- 🏷️ Classify. --
        if kind then -- ✅ Interactable. --
            VCity._InteractTarget = ent -- 🎯 Store. --
            VCity._InteractLabel = label or "" -- 🏷️ Store. --
            return -- ✅ Done. --
        end
    end
    VCity._InteractTarget = nil -- 🧹 Clear. --
    VCity._InteractLabel = "" -- 🧹 Clear. --
end)

-- ⌨️ E presses are engine +use; we ALSO send our validated channel. --
-- 🧠 Why both? Engine Use handles pickups directly; our channel handles doors/players. --
hook.Add("PlayerButtonDown", "VCity_InteractKey", function(ply, btn)
    if ply ~= LocalPlayer() then return end -- 👤 Local only. --
    if btn ~= KEY_E then return end -- 🤝 E only. --
    local ent = VCity._InteractTarget -- 🎯 Target. --
    if not IsValid(ent) then return end -- 🙅 Nothing. --
    -- 📦 Pickups/crates/corpse/stations use engine Use (no net needed). --
    local cls = ent:GetClass() -- 🏷️ Class. --
    if cls == "vcity_pickup" or cls == "vcity_crate" or cls == "vcity_corpse" or cls == "vcity_medstation" then -- 📦 Engine handles. --
        return -- ✅ Let engine Use fire. --
    end
    -- 🤝 Everything else goes through validated net. --
    net.Start(VCity.Net.INTERACT) -- 🤝 Open. --
    net.WriteEntity(ent) -- 🎯 Target. --
    net.SendToServer() -- 📤 Send. --
end)

-- 🏷️ Prompt rendering is done in cl_hud.lua (single HUDPaint hook). --
