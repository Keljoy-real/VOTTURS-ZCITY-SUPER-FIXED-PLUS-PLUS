-- 🛠️ VotturCity | sv_crafting.lua | Server crafting authority 🛠️ --
-- 🖥️ Validates needs, locks player, consumes, grants. Campfire check server-side. --

-- 🔥 Is a lit campfire nearby? (shared with survival; duplicated tiny for independence). --
local function NearLitFire(pos)
    for _, e in ipairs(ents.FindByClass("vcity_campfire")) do -- 🔥 Fires. --
        if IsValid(e) and e:GetNWBool("VCity_Lit", false) then -- 🔥 Lit. --
            if pos:DistToSqr(e:GetPos()) < (200 ^ 2) then return true end -- 🔥 Close. --
        end
    end
    return false -- 🙅 None. --
end

-- 📥 Craft request: string recipe id. --
net.Receive("VCity_Craft", function(_, ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    if not ply:Alive() then return end -- 💀 Dead can't. --
    if not VCity.State_CanAct(ply) then return end -- 🛑 Busy. --
    if not VCity.Throttled("Craft_" .. ply:SteamID64(), 1) then return end -- ⏱️ Throttle. --
    local rid = net.ReadString() -- 🆔 Recipe id. --
    if type(rid) ~= "string" or #rid > 48 then return end -- 🛑 Bad. --
    local r = VCity.Crafting_Get(rid) -- 🧾 Recipe. --
    if not r then return end -- 🛑 Unknown. --
    -- 🔥 Campfire gate. --
    if r.fire and not NearLitFire(ply:GetPos()) then -- 🔥 Need fire. --
        VCity.Notify(ply, 2, "🔥 Need a lit campfire nearby!") -- 📝 Feedback. --
        return -- 🛑 Stop. --
    end
    -- 🎒 Verify ALL needs upfront (no partial consume). --
    for itemId, need in pairs(r.needs or {}) do -- 🔁 Needs. --
        if not VCity.Inventory_Has(ply, itemId, need) then -- 🎒 Missing. --
            VCity.Notify(ply, 2, "❌ Need " .. need .. "x " .. ((VCity.Items[itemId] or {}).name or itemId)) -- 📝 Feedback. --
            return -- 🛑 Stop. --
        end
    end
    local time = r.time or 3 -- ⏱️ Duration. --
    if not VCity.State_Lock(ply, time, "Crafting...") then return end -- 🤝 Lock. --
    local sid = ply:SteamID64() -- 🆔 ID. --
    timer.Create("VCity_Lock_" .. sid, time, 1, function() -- ⏳ Timer. --
        if not IsValid(ply) then return end -- 🛑 Left. --
        if VCity.State_Get(ply) ~= VCity.State.INTERACTING then return end -- 🙅 Cancelled. --
        -- 🎒 Re-verify + consume (anti-dupe). --
        for itemId, need in pairs(r.needs or {}) do -- 🔁 Verify. --
            if not VCity.Inventory_Has(ply, itemId, need) then -- 🎒 Lost items mid-craft. --
                VCity.State_Unlock(ply, true) -- 🔓 Cancel. --
                VCity.Notify(ply, 2, "❌ Materials missing!") -- 📝 Feedback. --
                return -- 🛑 Stop. --
            end
        end
        for itemId, need in pairs(r.needs or {}) do VCity.Inventory_Take(ply, itemId, need, true) end -- 🧹 Consume silently. --
        -- 🎁 Grant outputs (leftovers -> world drop if full). --
        for itemId, n in pairs(r.gives or {}) do -- 🔁 Outputs. --
            local left = VCity.Inventory_Give(ply, itemId, n, true) -- 🎒 Give silently. --
            if left > 0 then -- 📦 Full: drop remainder at feet. --
                VCity.Inventory_SpawnPickup(itemId, left, ply:GetPos() + Vector(0, 0, 30)) -- 📦 Drop. --
            end
        end
        VCity.State_Unlock(ply, false) -- 🔓 Done. --
        VCity.Inventory_Sync(ply) -- 📡 Sync. --
        VCity.XP_Grant(ply, VCity.Config.CraftXP, "craft") -- ⭐ Craft XP. --
        VCity.Notify(ply, 1, "🛠️ Crafted: " .. (r.name or rid)) -- 📝 Confirm. --
        ply:EmitSound("physics/wood/wood_crate_break1.wav", 55, 110) -- 🔊 Craft clunk. --
        -- 🪝 Quest progress hook. --
        hook.Run("VCity_Crafted", ply, rid) -- 🛠️ Observe. --
    end)
end)
