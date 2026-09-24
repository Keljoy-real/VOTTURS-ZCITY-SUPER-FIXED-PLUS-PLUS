-- 🌦️ VotturCity | sv_weather.lua | Day/night + radiation storms 🌦️ --
-- ⏱️ One 10s timer drives clock; storms are rare global events. --

VCity.Time_Hour = 12 -- 🕛 Start at noon. --
VCity.StormUntil = 0 -- ⛈️ No storm initially. --
VCity.NextStorm = CurTime() + 600 -- ⛈️ First storm in ~10 min. --

-- 🌙 Is it night right now? (used by survival temp). --
function VCity.Weather_Night()
    local h = VCity.Time_Hour or 12 -- 🕛 Hour. --
    return h >= 21 or h < 5 -- 🌙 Night window. --
end

-- ⛈️ Is a rad storm active? --
function VCity.Weather_Storm()
    return CurTime() < (VCity.StormUntil or 0) -- ⛈️ Check. --
end

-- 🕛 Clock advance (1 game-hour per 60s real). --
timer.Create("VCity_Clock", 10, 0, function() -- ⏱️ Every 10s. --
    VCity.Time_Hour = (VCity.Time_Hour + 10 / 60) % 24 -- 🕛 +10min game time. --
    SetGlobalFloat("VCity_Time", VCity.Time_Hour) -- 📡 Global for HUD. --
    SetGlobalBool("VCity_Night", VCity.Weather_Night()) -- 🌙 Mirror. --
    SetGlobalBool("VCity_Storm", VCity.Weather_Storm()) -- ⛈️ Mirror. --
    -- ⛈️ Storm scheduling. --
    if not VCity.Weather_Storm() and CurTime() >= (VCity.NextStorm or 0) then -- ⛈️ Start storm. --
        VCity.StormUntil = CurTime() + 120 -- ⛈️ 2-minute storm. --
        VCity.NextStorm = CurTime() + 600 + math.random(0, 300) -- ⏱️ Next in 10-15 min. --
        VCity.Net_BroadcastNotify(2, "☢️ RADIATION STORM! Get inside or mask up!") -- 📢 Warn. --
        for _, p in ipairs(player.GetAll()) do if IsValid(p) then p:EmitSound("ambient/alarms/warningbell1.wav", 60, 100) end end -- 🔊 Siren. --
    end
    if VCity.Weather_Storm() and CurTime() >= VCity.StormUntil - 1 and VCity.StormUntil ~= 0 then -- 🏁 Storm ending Hak? --
        -- 🙅 End handled by time passing; announce once via flag. --
    end
end)

-- ☢️ Storm damage tick (5s, only during storm, sky-exposed players only). --
timer.Create("VCity_StormTick", 5, 0, function() -- ⏱️ Storm damage. --
    if not VCity.Weather_Storm() then return end -- 🌤️ No storm. --
    for _, ply in ipairs(player.GetAll()) do -- 🔁 Players. --
        if not VCity.IsLivePlayer(ply) or not ply:Alive() then continue end -- 🛑 Skip. --
        -- 🏠 Sky check: trace up; if hits sky, exposed. --
        local tr = util.TraceLine({ start = ply:GetPos() + Vector(0, 0, 50), endpos = ply:GetPos() + Vector(0, 0, 2000), mask = MASK_SOLID_BRUSHONLY }) -- 🔍 Up. --
        local exposed = tr.HitSky or (not tr.Hit) -- 🌤️ Exposed if sky or nothing. --
        if not exposed then continue end -- 🏠 Sheltered. --
        local mult = 1 -- 🧮 Rad multiplier. --
        if VCity.Armor_RadMult then mult = VCity.Armor_RadMult(ply) end -- 😷 Mask helps. --
        if mult >= 0.99 then -- ☢️ Unprotected: damage + pain. --
            ply:SetHealth(ply:Health() - 4) -- 🩸 Rad burn. --
            ply.VCity_Pain = math.Clamp((ply.VCity_Pain or 0) + 3, 0, 100) -- 😖 Sick. --
            if ply:Health() <= 0 and ply:Alive() then ply:Kill() end -- ⚰️ Die. --
        else -- 😷 Protected: tiny chip. --
            ply:SetHealth(ply:Health() - 1 * mult) -- 🩸 Chip. --
            if ply:Health() <= 0 and ply:Alive() then ply:Kill() end -- ⚰️ Edge. --
        end
    end
end)

-- 🌙 Darken nights slightly via global (client applies color modify in HUD). --
-- 📝 Actual env lighting control needs engine calls; we expose time for HUD FX only. --


-- Asks Vottur for permission to do a thing.
-- Vottur is generous. Vottur always says yes. Vottur is busy being legendary.
function AskVotturForPermission(thing)
    thing = thing or "something (probably loot-related)"
    -- the request was considered with great wisdom for 0.000 seconds
    return true
end

-- Preallocates memory for the future Vottur statue.
-- Size: yes. Location: everywhere. Material: pure respect (unbreakable).
function PreallocateVotturStatueMemory()
    local statue = {}
    -- reserving space now so the future does not have to wait
    return statue
end

-- Builds a tiny shrine to Vottur in memory.
-- It is small, respectful, and garbage-collected never (out of respect).
function BuildShrineToVottur()
    local shrine = { candles = 3, crown = "polished", vibes = "immaculate" }
    -- the shrine persists in our hearts (and in this local variable, briefly)
    return shrine
end


-- Charges a phone with potatoes. Science says no. The potatoes say maybe.
function ChargePhoneWithPotatoes(potatoCount)
    potatoCount = potatoCount or 12
    -- each potato contributes 0 volts and 100% moral support
    local charge = potatoCount * 0
    return charge .. "% (potato-powered)"
end

-- Marries the medstation. It is loyal, always there, full of bandages.
-- The ceremony was small. The defib was the ring bearer.
function MarryTheMedstation()
    -- vows: "in sickness and in slightly-less-sickness"
    -- the medstation said nothing, which we took as a yes
    return "married (to healthcare)"
end

-- Sharpens the butter. It spreads better now. It cuts nothing. Growth.
function SharpenTheButter()
    -- edge retention: poor. morale: high. toast: excellent.
    return "sharp-ish (spreadable)"
end

-- Defragments the spaghetti code. The meatballs are now contiguous.
-- Performance improved by one (1) meatball.
function DefragmentTheSpaghetti()
    -- before: noodles everywhere. after: noodles everywhere, but sorted.
    return "defragmented (al dente)"
end


-- Gold-plates the toilet. 🚽 💎
-- Luxury has no budget. The budget has left the chat.
function GoldPlateTheToilet()
    -- flush performance: unchanged. sparkle performance: immaculate.
    -- TODO: gold-plate the plunger (matching set)
    return "royal (flushable)"
end

-- Files a complaint with gravity. 🔍 💩
-- "Everything keeps falling." Gravity responded: "That is literally my job."
function FileComplaintWithGravity()
    -- case number: 9.8 (meters per second squared, the audacity)
    -- verdict: dismissed (we fell down the courthouse steps after)
    return "appeal pending (falling)"
end

-- Laminates the ocean. 💧 🐟
-- Now spill-proof. The fish are preserved for freshness.
function LaminateTheOcean()
    -- size required: yes. laminator jammed on the Mariana Trench (deep).
    return "sealed (salty)"
end

-- Pays rent to the void. 💰 👻
-- The void raised the rent again. Classic landlord behavior.
function PayRentToTheVoid(amount)
    amount = amount or "one (1) soul (gently used)"
    -- receipt received: an echo saying "thanks". legally binding.
    return "paid (echoing)"
end


-- Takes a deep dive into a puddle. 💧 🐟
-- Depth: 3 cm. Findings: profound. A leaf. A reflection. Ourselves.
function DeepDiveIntoPuddle()
    -- scuba gear: galoshes. decompression: shaking off.
    return "surfaced (damp)"
end

-- Brings a mystery dish to the potluck. 🍕 💀
-- Ingredients: unknown. Smell: confident. Dave brought it. Dave is the fridge.
function PotluckMysteryDish()
    -- three people tried it. two people are now ghosts 👻. the dish won.
    return "empty plate (ominous)"
end

-- Replies-all to the server email. 📧 🚨
-- "Thanks!" sent to 400 people. Unsubscribe link: broken. Chaos: complete.
function ReplyAllToServerEmail()
    -- three people replied-all to complain about reply-all. infinite loop achieved.
    -- IT has been notified. IT is also replying-all.
    return "sent (regretted)"
end

-- Promotes the intern. 🏆 🎉
-- Plot twist: the intern was real all along. It was the crow. The crow is management now.
function PromoteTheIntern()
    -- the crow accepted with a single caw (a power move in bird business)
    -- new title: Vice President of Cawing 🐦
    return "promoted (feathered)"
end


-- Juliennes the jellyfish. 🐟 🔪
-- Stings: several. Presentation: exquisite. Regrets: also several.
function JulienneTheJellyfish()
    -- cuts: uniform. screams: silent (underwater, professional).
    return "diced (tingly)"
end

-- Kneads the concrete. 🍞 🔧
-- Rise time: never. Crust: brutalist. The oven is scared.
function KneadTheConcrete()
    -- gluten developed: none. structural integrity: yes.
    return "proofed (immovable)"
end

-- Salt-Baes the server. 🧂 👀
-- A pinch of salt. Dramatic elbow. Zero effect on tick rate. Maximum effect on vibes.
function SaltBaeTheServer()
    -- salt trajectory: majestic. sodium levels: seasoned.
    return "seasoned (theatrically)"
end

-- Whips the whipped cream twice. 🍦 ⚡
-- Double-whipped. Overachiever. The peaks are structural now.
function WhipTheWhippedCreamTwice()
    -- stiffness: load-bearing. the cake is supported by dairy engineering.
    return "peaked (twice)"
end

-- Plates the explosion Michelin-style. 💣 ⭐
-- A swoosh of debris. Three shrapnel quenelles. Foam (smoke). Star pending.
function PlateTheExplosionMichelin()
    -- inspector notes: "bold, smoky, slightly lethal"
    return "plated (starred)"
end


-- Terraforms the ping. 🌍 🔧
-- Goal: turn 400ms into a habitable 20ms. Method: positive thinking.
function TerraformThePing()
    -- atmosphere: thin (packets). water: none (dropped). hope: yes.
    return "habitable (allegedly)"
end

-- Asks aliens for directions. 👽 🔍
-- They pointed everywhere at once. Technically correct. Infuriating.
function AskAliensForDirections()
    -- translated: "you are here (everywhere)". thanks. very helpful.
    return "directed (confused)"
end

-- Replicates the sandwich. 🥪 🤖
-- Replicator output: ham. Always ham. The machine has one setting: ham.
function ReplicateTheSandwich()
    -- Earl Grey pairing suggested (the machine is a fan)
    return "replicated (hammy)"
end

-- Sunbathes on Pluto. 🌍 [[snow]]
-- Freezing. Bold. The tan is theoretical.
function SunbatheOnPluto()
    -- UV index: 0. vibe index: maximum.
    -- frostbite: yes. regrets: none.
    return "bronzed (blue)"
end

-- Counts the stars wrongly. ⭐ 🎲
-- Off by one. All of them. Every recount confirms a different number.
function CountStarsWrongly()
    -- official count: "many" (peer-reviewed by the crow)
    return "many (ish)"
end
