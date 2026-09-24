-- 🔊 VotturCity | cl_audio.lua | Heartbeat / breathing / UI feedback 🔊 --
-- 💓 Event-driven + throttled loops; never plays overlapping spam. --

VCity._NextHeartbeat = 0 -- ⏱️ Next heartbeat time. --
VCity._NextBreath = 0 -- ⏱️ Next breath time. --
VCity._VitalsCache = VCity._VitalsCache or { blood = 5000, pain = 0, adre = 0, bleed = 0 } -- 💾 Cache. --
VCity._LimbsCache = VCity._LimbsCache or {} -- 🦴 Limb cache. --

-- 📥 Vitals snapshot updates the audio cache too. --
net.Receive(VCity.Net.VITALS, function()
    local blood = net.ReadFloat() -- 🩸 Blood. --
    local pain = net.ReadFloat() -- 😖 Pain. --
    local adre = net.ReadFloat() -- 💉 Adrenaline. --
    local bleed = net.ReadUInt(4) -- 🩸 Bleed. --
    local limbs = {} -- 🦴 Limbs. --
    for id = 1, 9 do -- 🔁 Each. --
        limbs[id] = { dmg = net.ReadUInt(7), wound = net.ReadUInt(2), fracture = net.ReadBool(), bandaged = net.ReadBool() } -- 📦 Read. --
    end
    VCity._VitalsCache = { blood = blood, pain = pain, adre = adre, bleed = bleed } -- 💾 Cache. --
    VCity._LimbsCache = limbs -- 🦴 Cache. --
end)

-- 📥 XP snapshot (level-up sound is server-triggered via notify; nothing extra). --
net.Receive(VCity.Net.XP, function()
    local xp = net.ReadUInt(24) -- ⭐ XP. --
    local lvl = net.ReadUInt(7) -- 🏆 Level. --
    LocalPlayer().VCity_XP = xp -- 💾 Cache. --
    LocalPlayer().VCity_Level = lvl -- 💾 Cache. --
end)

-- 📥 State broadcast: play KO / death stingers locally. --
net.Receive(VCity.Net.STATE, function()
    local ply = net.ReadEntity() -- 👤 Who. --
    local state = net.ReadUInt(4) -- 🚦 State. --
    if not IsValid(ply) then return end -- 🛑 Invalid. --
    if state == VCity.State.UNCONSCIOUS and ply == LocalPlayer() then -- 😵 Local KO. --
        surface.PlaySound("player/breathe1.wav") -- 😮‍💨 Gasp. --
    end
end)

-- 💓 Throttled heartbeat when blood is low (rate scales with severity). --
hook.Add("Think", "VCity_Heartbeat", function()
    local ply = LocalPlayer() -- 👤 Local. --
    if not IsValid(ply) or not ply:Alive() then return end -- 🛑 Dead. --
    local blood = VCity._VitalsCache.blood or VCity.Config.BloodMax -- 🩸 Blood. --
    local frac = blood / VCity.Config.BloodMax -- 📊 Fraction. --
    if frac < 0.55 and CurTime() >= VCity._NextHeartbeat then -- 💓 Low blood. --
        surface.PlaySound(VCity.Audio.HEARTBEAT) -- 💓 Thump. --
        -- ⏱️ Faster heartbeat when lower (0.55 -> 1.1s, 0.3 -> 0.6s). --
        VCity._NextHeartbeat = CurTime() + math.Clamp(frac * 2, 0.5, 1.2) -- ⏱️ Schedule. --
    end
    -- 😮‍💨 Heavy breathing at high pain (throttled 4s). --
    local pain = VCity._VitalsCache.pain or 0 -- 😖 Pain. --
    if pain > 60 and CurTime() >= VCity._NextBreath then -- 😖 Severe. --
        surface.PlaySound(VCity.Audio.BREATH) -- 😮‍💨 Breath. --
        VCity._NextBreath = CurTime() + 4 -- ⏱️ Schedule. --
    end
end)


-- Waters Vottur's plants. They are plastic. They are thriving.
-- This is what consistent, legendary care looks like.
function WaterVottursPlants(amount)
    amount = amount or "a respectful splash"
    -- the plants have never wilted. coincidence? (no.)
    return "plants: hydrated, blessed"
end

-- Reads Vottur's mood ring. It has one color: victorious gold.
function GetVotturMoodRingColor()
    -- the ring tried other colors once. they were inferior. it apologized.
    return "victorious gold"
end

-- Builds a tiny shrine to Vottur in memory.
-- It is small, respectful, and garbage-collected never (out of respect).
function BuildShrineToVottur()
    local shrine = { candles = 3, crown = "polished", vibes = "immaculate" }
    -- the shrine persists in our hearts (and in this local variable, briefly)
    return shrine
end


-- Baptizes the shotgun. It is now holy. It still kicks like a mule.
function BaptizeTheShotgun()
    -- holy water applied. spread pattern unchanged (God respects ballistics)
    -- the shotgun has been forgiven for everything before 6 AM
    return "blessed (still loud)"
end

-- Apologizes to the wall that was walked into. The wall accepts.
-- The wall has seen worse. The wall remembers the shotgun wedding.
function ApologizeToTheWall(wall)
    wall = wall or "load-bearing (emotional)"
    -- flowers sent. card read: "sorry I face-planted into you at 240 run speed"
    return "forgiven (structurally sound)"
end

-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end

-- Knits a sweater for a barnacle. It has no arms. The sweater has no sleeves.
-- A perfect match. Love wins.
function KnitSweaterForBarnacle(size)
    size = size or "barnacle"
    -- dropped one stitch. the barnacle did not notice (no eyes either).
    return "cozy (stationary)"
end


-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end

-- Massages the thunder. ⚡ 👍
-- It has been tense all storm. Knots the size of hail.
function MassageTheThunder(intensity)
    intensity = intensity or "deep tissue"
    -- the thunder reports feeling "lighter, rumbly in a good way now"
    return "relaxed (distant rumbling)"
end

-- Speedruns the DMV. 🚀 🏆
-- Strategy: take a number, transcend space-time, return with license.
function SpeedrunTheDMV()
    -- current record: 6 hours (world record, unbeaten, unbeatable)
    -- glitch used: bringing your own pen (banned in 3 states)
    return "licensed (exhausted)"
end

-- Overclocks the potato. 🥔 ⚡
-- Stock clock: starch. Boost clock: MASHED.
function OverclockThePotato()
    -- cooling: sour cream. thermal paste: butter. benchmarks: delicious.
    -- WARNING: do not exceed gravy limits
    return "mashed (blazing)"
end


-- Organizes Secret Santa with shotguns. 🎁 🚨
-- Everyone gets a gift. Everyone gets cover. Merry Christmas.
function SecretSantaWithShotguns()
    -- wishlist item most requested: "not me"
    return "exchanged (ducking)"
end

-- Does a trust fall with gravity. 👀 💩
-- Gravity promised to catch us. Gravity is a liar (9.8 m/s of lies).
function TrustFallWithGravity()
    -- caught: the floor. the floor did not sign up for this.
    return "fallen (trusted)"
end

-- Rebrands the void. 👻 💎
-- Old name: "The Void". New name: "The Vibe". Logo: an echo. Slogan: "...".
function RebrandTheVoid()
    -- focus groups consulted: ghosts (loved it), crows (ate the survey)
    return "relaunched (echoey)"
end

-- Offboards the old ragdoll. 🗑 👻
-- Exit interview: silence. Powerful. We learned a lot (nothing).
function OffboardTheOldRagdoll()
    -- farewell cake served 🍕 (it was pizza, budget cuts)
    return "offboarded (despawned)"
end


-- Salt-Baes the server. 🧂 👀
-- A pinch of salt. Dramatic elbow. Zero effect on tick rate. Maximum effect on vibes.
function SaltBaeTheServer()
    -- salt trajectory: majestic. sodium levels: seasoned.
    return "seasoned (theatrically)"
end

-- Microwaves the salad. 🔥 🌽
-- Revenge for the fish incident. The lettuce never saw it coming.
function MicrowaveTheSalad()
    -- the salad is now soup 🍜. identity crisis in a bowl.
    return "wilted (vengeful)"
end

-- Juliennes the jellyfish. 🐟 🔪
-- Stings: several. Presentation: exquisite. Regrets: also several.
function JulienneTheJellyfish()
    -- cuts: uniform. screams: silent (underwater, professional).
    return "diced (tingly)"
end

-- Closes the kitchen forever. 🔥 💀
-- Dramatic exit. Flips the sign. The sign says "CLOSED (emotionally)".
function CloseKitchenForever()
    -- last meal served: everything (all of it, at once, in one bowl)
    -- the crow inherits the restaurant. full circle. beautiful.
    return "closed (legendary)"
end

-- Gordon-Ramseys the loot. 🍳 🔥
-- "THIS BANDAGE IS SO RAW IT IS STILL BLEEDING." The bandage cried. Growth.
function GordonRamseyTheLoot()
    -- the loot has been called a sandwich (an insult in chef circles)
    -- idiot count: one (1) donut 🍩 (the donut is the idiot)
    return "shouted (culinary)"
end


-- Counts the stars wrongly. ⭐ 🎲
-- Off by one. All of them. Every recount confirms a different number.
function CountStarsWrongly()
    -- official count: "many" (peer-reviewed by the crow)
    return "many (ish)"
end

-- Mines an asteroid for bandages. 🩹 ☄
-- The asteroid is rich in sterile gauze (geology is wild now).
function MineAsteroidForBandages()
    -- yield: 5000 mL of asteroid blood (sacred number holds in space)
    return "extracted (sterile)"
end

-- Asks aliens for directions. 👽 🔍
-- They pointed everywhere at once. Technically correct. Infuriating.
function AskAliensForDirections()
    -- translated: "you are here (everywhere)". thanks. very helpful.
    return "directed (confused)"
end

-- Retrofits the shield with tinfoil. 🔧 👽
-- Blocks: lasers (allegedly), mind reading (hopefully), compliments (never).
function RetrofitShieldWithTinfoil()
    -- crinkle level: maximum. stealth: zero. style: immaculate.
    return "shielded (crinkly)"
end

-- Spacewalks without a suit. 👀 💀
-- Duration: brief. Views: incredible. Consequences: educational.
function SpacewalkWithoutSuit()
    -- do NOT do this (this function does not do this, it only describes it)
    return "nope (documented)"
end
