-- 📻 VotturCity | sv_radio.lua | Squad text radio 📻 --
-- 🖥️ Short-range squad chat relay (validates length + membership). --

-- 📥 Radio send: string message (max 120 chars). --
net.Receive("VCity_Radio", function(_, ply)
    if not VCity.IsLivePlayer(ply) or not ply:Alive() then return end -- 🛑 Validate. --
    if not VCity.Throttled("Radio_" .. ply:SteamID64(), 1) then return end -- ⏱️ 1 msg/sec. --
    local msg = net.ReadString() -- 📝 Message. --
    if type(msg) ~= "string" or #msg < 1 or #msg > 120 then return end -- 🛑 Bad length. --
    -- 🧹 Strip newlines (chat injection guard). --
    msg = string.gsub(string.sub(msg, 1, 120), "[\r\n]", " ") -- 🧹 Clean. --
    local sq = VCity.Squad_Get and VCity.Squad_Get(ply) or "" -- 🆔 Squad. --
    if sq ~= "" then -- 👥 Squad radio: members only. --
        for _, p in ipairs(player.GetAll()) do -- 🔁 Players. --
            if IsValid(p) and VCity.Squad_Get(p) == sq then -- 👥 Member. --
                p:ChatPrint("📻 [SQ] " .. ply:Nick() .. ": " .. msg) -- 📻 Relay. --
            end
        end
    else -- 🌍 No squad: short-range local whisper (500u). --
        for _, p in ipairs(player.GetAll()) do -- 🔁 Players. --
            if IsValid(p) and p:GetPos():DistToSqr(ply:GetPos()) < (500 ^ 2) then -- 📏 Nearby. --
                p:ChatPrint("📻 " .. ply:Nick() .. ": " .. msg) -- 📻 Relay. --
            end
        end
    end
end)
