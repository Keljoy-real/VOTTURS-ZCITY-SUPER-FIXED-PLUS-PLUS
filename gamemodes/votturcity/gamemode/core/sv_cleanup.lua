-- 🧹 VotturCity | sv_cleanup.lua | Entity + ragdoll janitor 🧹 --
-- ⏱️ One slow timer; avoids per-frame entity loops. --

timer.Create("VCity_Cleanup", 60, 0, function() -- ⏱️ Every minute. --
    local now = CurTime() -- ⏱️ Now. --
    local removed = 0 -- 🧮 Counter. --
    -- 📦 Old pickups (older than 10 min) get removed. --
    for _, ent in ipairs(ents.FindByClass("vcity_pickup")) do -- 🔁 Pickups. --
        if IsValid(ent) and (ent.VCity_Created or 0) + 600 < now then -- ⏱️ Old. --
            ent:Remove() -- 🧹 Remove. --
            removed = removed + 1 -- ➕ Count. --
        end
    end
    -- 💀 Old corpse boxes (older than lifetime) get removed. --
    for _, ent in ipairs(ents.FindByClass("vcity_corpse")) do -- 🔁 Corpses. --
        if IsValid(ent) and (ent.VCity_Created or 0) + VCity.Config.CorpseLifetime < now then -- ⏱️ Old. --
            ent:Remove() -- 🧹 Remove. --
            removed = removed + 1 -- ➕ Count. --
        end
    end
    -- 🧍 Stray ragdolls we created (older than cleanup time). --
    for _, ent in ipairs(ents.FindByClass("prop_ragdoll")) do -- 🔁 Ragdolls. --
        if IsValid(ent) and ent.VCity_Ragdoll and (ent.VCity_Created or 0) + VCity.Config.RagdollCleanup < now then -- ⏱️ Old. --
            ent:Remove() -- 🧹 Remove. --
            removed = removed + 1 -- ➕ Count. --
        end
    end
    if removed > 0 then print("[VCity] 🧹 Cleaned " .. removed .. " entities") end -- 📝 Log if worked. --
end)
