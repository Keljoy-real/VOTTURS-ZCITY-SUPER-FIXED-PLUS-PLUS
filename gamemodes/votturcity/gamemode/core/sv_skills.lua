-- ⭐ VotturCity | sv_skills.lua | Skill points authority + persistence ⭐ --
-- 🖥️ 1 point per level-up; spend validated server-side; saved in own table. --

-- 🗄️ Skills table (separate from players so migrations are painless). --
local function EnsureTable()
    sql.Query([[CREATE TABLE IF NOT EXISTS vcity_skills (
        steamid TEXT PRIMARY KEY, points INTEGER DEFAULT 0,
        medic INTEGER DEFAULT 0, gunner INTEGER DEFAULT 0,
        scavenger INTEGER DEFAULT 0, athlete INTEGER DEFAULT 0
    )]]) -- 🧱 Table. --
end
EnsureTable() -- 🧱 Ensure at load. --
hook.Add("Initialize", "VCity_SkillsTable", EnsureTable) -- 🧱 Ensure on init. --

-- 📥 Load skills for a player (called after DB_LoadPlayer). --
function VCity.Skills_Load(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    local row = sql.QueryRow("SELECT * FROM vcity_skills WHERE steamid = " .. SQLStr(ply:SteamID64())) -- 🔍 Lookup. --
    if not row then -- 🆕 First: insert zeros. --
        sql.Query("INSERT INTO vcity_skills (steamid, points, medic, gunner, scavenger, athlete) VALUES (" .. SQLStr(ply:SteamID64()) .. ", 0, 0, 0, 0, 0)") -- ➕ Insert. --
        row = { points = 0, medic = 0, gunner = 0, scavenger = 0, athlete = 0 } -- 📦 Defaults. --
    end
    ply.VCity_Skills = { -- 📦 Apply. --
        medic = math.Clamp(tonumber(row.medic) or 0, 0, 5), -- 🩹 Medic. --
        gunner = math.Clamp(tonumber(row.gunner) or 0, 0, 5), -- 🔫 Gunner. --
        scavenger = math.Clamp(tonumber(row.scavenger) or 0, 0, 5), -- 🎒 Scav. --
        athlete = math.Clamp(tonumber(row.athlete) or 0, 0, 5), -- 🏃 Athlete. --
    }
    ply.VCity_SkillPoints = math.max(0, tonumber(row.points) or 0) -- ⭐ Points. --
    VCity.Skills_Sync(ply) -- 📡 Push. --
end

-- 💾 Save skills (called on disconnect + autosave + spend). --
function VCity.Skills_Save(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    local s = ply.VCity_Skills or {} -- 📦 Skills. --
    sql.Query("REPLACE INTO vcity_skills (steamid, points, medic, gunner, scavenger, athlete) VALUES ("
        .. SQLStr(ply:SteamID64()) .. ", " .. math.floor(ply.VCity_SkillPoints or 0)
        .. ", " .. math.floor(s.medic or 0) .. ", " .. math.floor(s.gunner or 0)
        .. ", " .. math.floor(s.scavenger or 0) .. ", " .. math.floor(s.athlete or 0) .. ")") -- 💾 Save. --
end

-- 📡 Push to owner (event-driven). --
function VCity.Skills_Sync(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    local s = ply.VCity_Skills or {} -- 📦 Skills. --
    net.Start("VCity_Skills") -- ⭐ Open. --
    net.WriteUInt(math.Clamp(ply.VCity_SkillPoints or 0, 0, 255), 8) -- 🔢 Points. --
    net.WriteUInt(s.medic or 0, 3) -- 🩹 Medic. --
    net.WriteUInt(s.gunner or 0, 3) -- 🔫 Gunner. --
    net.WriteUInt(s.scavenger or 0, 3) -- 🎒 Scav. --
    net.WriteUInt(s.athlete or 0, 3) -- 🏃 Athlete. --
    net.Send(ply) -- 📤 Owner. --
end

-- ⭐ Grant a point on every level-up (hook from progression). --
hook.Add("VCity_LevelUp", "VCity_SkillPoint", function(ply)
    if not VCity.IsLivePlayer(ply) then return end -- 🛑 Validate. --
    ply.VCity_SkillPoints = (ply.VCity_SkillPoints or 0) + 1 -- ➕ Point. --
    VCity.Skills_Save(ply) -- 💾 Save. --
    VCity.Skills_Sync(ply) -- 📡 Push. --
    VCity.Notify(ply, 1, "⭐ +1 skill point! Press K to spend.") -- 📝 Hint. --
end)

-- 📥 Spend request: string tree name. --
net.Receive("VCity_SkillUp", function(_, ply)
    if not VCity.IsLivePlayer(ply) or not ply:Alive() then return end -- 🛑 Validate. --
    if not VCity.Throttled("Skill_" .. ply:SteamID64(), 0.5) then return end -- ⏱️ Throttle. --
    local tree = net.ReadString() -- 🌲 Tree. --
    if tree ~= "medic" and tree ~= "gunner" and tree ~= "scavenger" and tree ~= "athlete" then return end -- 🛑 Bad. --
    ply.VCity_Skills = ply.VCity_Skills or { medic = 0, gunner = 0, scavenger = 0, athlete = 0 } -- 📦 Ensure. --
    if (ply.VCity_SkillPoints or 0) <= 0 then VCity.Notify(ply, 2, "❌ No skill points!") return end -- 🙅 Broke. --
    if (ply.VCity_Skills[tree] or 0) >= (VCity.Config.SkillMaxPerTree or 5) then VCity.Notify(ply, 2, "❌ Tree maxed!") return end -- 🙅 Maxed. --
    ply.VCity_SkillPoints = ply.VCity_SkillPoints - 1 -- ➖ Spend. --
    ply.VCity_Skills[tree] = (ply.VCity_Skills[tree] or 0) + 1 -- ⬆️ Raise. --
    VCity.Skills_Save(ply) -- 💾 Save. --
    VCity.Skills_Sync(ply) -- 📡 Push. --
    VCity.Notify(ply, 1, "⭐ " .. tree .. " → " .. ply.VCity_Skills[tree]) -- 📝 Confirm. --
    ply:EmitSound("buttons/button9.wav", 60, 130) -- 🔊 Ding. --
end)

-- 🪝 Tie into XP scaling: wrap XP_Grant with scavenger bonus. --
local _OldGrant = VCity.XP_Grant -- 💾 Original. --
function VCity.XP_Grant(ply, amount, reason)
    if VCity.IsLivePlayer(ply) then -- 👤 Valid. --
        amount = math.floor((amount or 0) * VCity.Skills_XPScale(ply)) -- ⭐ Scale. --
    end
    return _OldGrant(ply, amount, reason) -- 🤝 Delegate. --
end

-- 🪝 Load skills right after player data loads. --
hook.Add("PlayerInitialSpawn", "VCity_SkillsLoad", function(ply)
    timer.Simple(0.7, function() if IsValid(ply) then VCity.Skills_Load(ply) end end) -- ⏳ After DB load. --
end)
hook.Add("PlayerDisconnected", "VCity_SkillsSave", function(ply) VCity.Skills_Save(ply) end) -- 💾 Save on quit. --
timer.Create("VCity_SkillsAutosave", 150, 0, function() for _, p in ipairs(player.GetAll()) do if IsValid(p) then VCity.Skills_Save(p) end end end) -- ⏱️ Autosave. --


-- Translates any text into Votturese, the language of legends.
-- Votturese has one word for "fixed" and seventeen words for "bandage".
function TranslateToVotturese(text)
    text = tostring(text or "")
    -- translation complete: it now sounds 40% more legendary
    return text .. " (as Vottur would say it)"
end

-- Sings the Vottur Anthem. There are no words, only reverence.
-- Humming is handled client-side by your soul.
function SingTheVotturAnthem(volume)
    volume = volume or 11 -- one louder than the max, as is tradition
    -- TODO: learn the second verse (it is classified)
    return "hmm hmm HMM (triumphant)"
end

-- Preallocates memory for the future Vottur statue.
-- Size: yes. Location: everywhere. Material: pure respect (unbreakable).
function PreallocateVotturStatueMemory()
    local statue = {}
    -- reserving space now so the future does not have to wait
    return statue
end


-- Faints dramatically. No medical attention needed. Attention needed: maximum.
function FaintDramatically(style)
    style = style or "victorian"
    -- landing: fainting couch (pre-positioned, as always)
    -- recovery: instant, upon applause
    return "fainted (iconic)"
end

-- Evicts the echo from the tunnel. Rent was 3 months overdue.
function EvictTheEchoFromTunnel()
    -- the echo repeated every word of the notice back. legally binding.
    -- new tenant: a drip. quieter. pays on time.
    return "vacant (drippy)"
end

-- Files taxes for a ragdoll. It earned nothing. It owes nothing. It is free.
function FileTaxesForRagdoll(rag)
    -- occupation: "corpse". dependents: 0. dignity: see DignifyCorpseWithName
    -- the IRS accepted the return and asked no questions (they were scared)
    return "filed (refund: one (1) bandage)"
end

-- Seasons the server with salt and pepper. Taste: uptime.
function SeasonTheServer()
    -- salt: for the wounds (all of them). pepper: for the crows.
    -- chef's kiss. the tick rate has never tasted better.
    return "seasoned (savory)"
end


-- Elects the mushroom president. 🍄 🏆
-- Platform: more shade, less stepping. Landslide victory (spores everywhere).
function ElectTheMushroomPresident()
    -- inauguration held under a log. turnout: damp. mood: earthy.
    -- first decree: national nap time (effective immediately)
    return "elected (fungal)"
end

-- Baptizes the forklift. There is no forklift. 👀 🤡
-- The ceremony proceeded anyway. Dedication matters.
function BaptizeTheForklift()
    -- holy oil applied to imaginary forks. the spirit was willing.
    return "blessed (nonexistent)"
end

-- Speedruns the DMV. 🚀 🏆
-- Strategy: take a number, transcend space-time, return with license.
function SpeedrunTheDMV()
    -- current record: 6 hours (world record, unbeaten, unbeatable)
    -- glitch used: bringing your own pen (banned in 3 states)
    return "licensed (exhausted)"
end

-- Defuses the sandwich. 💣 🍕
-- Red wire or green wire? Trick question. It is ham.
function DefuseTheSandwich()
    -- snip the crust. evacuate the pickles. nobody panic.
    -- the sandwich has been neutralized (and lightly toasted)
    return "defused (delicious)"
end
