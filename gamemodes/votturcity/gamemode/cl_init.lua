-- 💻 VotturCity | cl_init.lua | Client entrypoint 💻 --
-- 📥 Loads shared bootstrap (client copy) then client extras. --

include("shared.lua") -- 🤝 Shared manifest (client side). --

-- 📢 Client boot log (visible in developer console). --
print("[VCity] 🔵 VotturCity v" .. (VCity.Version or "?") .. " client init") -- 🔵 Boot log. --

-- ⌨️ Default keybinds registered once on load. --
hook.Add("InitPostEntity", "VCity_Binds", function()
    -- 🎒 Inventory toggle is bound in cl_inventory.lua; medical in cl_menus.lua. --
    -- 🤝 Interaction key uses +use (E) natively; no custom bind needed. --
end)
