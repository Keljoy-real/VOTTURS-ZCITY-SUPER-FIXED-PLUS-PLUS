-- 🎒 VotturCity | sh_items.lua | Item registry 🎒 --
-- 🧾 Every carriable / usable thing is defined here exactly once. --

VCity.Items = VCity.Items or {} -- 📦 Item namespace. --

-- 🧱 Helper to register an item (called at load; no runtime registration). --
local function Reg(id, def) -- 📝 Register helper. --
    VCity.Items[id] = def -- 📦 Store. --
    def.id = id -- 🆔 Back-reference. --
end

-- 🩹 Medical (also in Medical.Items for treatment stats; here for inv stats). --
Reg("bandage",      { name = "Bandage",          w = 0.2, max = 10, cat = "medical", model = "models/weapons/w_eq_smokegrenade_thrown.mdl", desc = "Stops bleeding." }) -- 🩹 Light. --
Reg("bigbandage",   { name = "Trauma Dressing",  w = 0.4, max = 5,  cat = "medical", model = "models/weapons/w_eq_smokegrenade_thrown.mdl", desc = "Stops heavy bleeding." }) -- 🩹 Heavy. --
Reg("medkit",       { name = "First Aid Kit",    w = 1.5, max = 3,  cat = "medical", model = "models/items/healthkit.mdl", desc = "Broad healing." }) -- 🩺 Kit. --
Reg("painkillers",  { name = "Painkillers",      w = 0.1, max = 10, cat = "medical", model = "models/props_lab/jar01b.mdl", desc = "Dulls pain." }) -- 💊 Pills. --
Reg("morphine",     { name = "Morphine",         w = 0.2, max = 5,  cat = "medical", model = "models/props_lab/jar01b.mdl", desc = "Strong pain relief." }) -- 💉 Morphine. --
Reg("adrenaline",   { name = "Adrenaline Pen",   w = 0.2, max = 5,  cat = "medical", model = "models/weapons/w_eq_smokegrenade_thrown.mdl", desc = "Combat stimulant." }) -- 💉 Rush. --
Reg("bloodbag",     { name = "Blood Bag",        w = 0.8, max = 3,  cat = "medical", model = "models/props_lab/jar01b.mdl", desc = "Restores blood." }) -- 🩸 Blood. --
Reg("splint",       { name = "Splint",           w = 0.6, max = 5,  cat = "medical", model = "models/props_c17/playground_teetertoter_stan.mdl", desc = "Fixes fractures." }) -- 🦴 Splint. --
Reg("defib",        { name = "Defibrillator",    w = 3.0, max = 1,  cat = "medical", model = "models/props_lab/defibrillator.mdl", desc = "Revives KO players." }) -- ⚡ Defib. --

-- 🔫 Ammo types (weapons consume these from inventory). --
Reg("ammo_9mm",    { name = "9mm Rounds",     w = 0.02, max = 120, cat = "ammo", model = "models/items/boxsrounds.mdl", desc = "Pistol ammo." }) -- 🔫 9mm. --
Reg("ammo_rifle",  { name = "Rifle Rounds",   w = 0.03, max = 120, cat = "ammo", model = "models/items/boxmrounds.mdl", desc = "Rifle ammo." }) -- 🔫 Rifle. --
Reg("ammo_shell",  { name = "Shells",         w = 0.08, max = 32,  cat = "ammo", model = "models/items/boxbuckshot.mdl", desc = "Shotgun shells." }) -- 🔫 Shells. --
Reg("ammo_44",     { name = ".44 Rounds",     w = 0.04, max = 48,  cat = "ammo", model = "models/items/boxsrounds.mdl", desc = "Magnum ammo." }) -- 🔫 Magnum. --

-- 🔫 Weapon pickup items (grant the weapon + handle equip). --
Reg("w_glock",   { name = "Pistol",        w = 1.2, max = 1, cat = "weapon", weapon = "vcity_glock",   model = "models/weapons/w_pistol.mdl", desc = "9mm sidearm." }) -- 🔫 Pistol. --
Reg("w_akm",     { name = "Assault Rifle", w = 3.5, max = 1, cat = "weapon", weapon = "vcity_akm",     model = "models/weapons/w_rif_ak47.mdl", desc = "Reliable rifle." }) -- 🔫 Rifle. --
Reg("w_shotgun", { name = "Shotgun",       w = 3.0, max = 1, cat = "weapon", weapon = "vcity_shotgun", model = "models/weapons/w_shot_m3super90.mdl", desc = "Close-range power." }) -- 🔫 Shotgun. --
Reg("w_knife",   { name = "Knife",         w = 0.5, max = 1, cat = "weapon", weapon = "vcity_knife",   model = "models/weapons/w_knife_t.mdl", desc = "Quiet melee." }) -- 🔪 Knife. --

-- 🛡️ Armor / utility. --
Reg("armor_vest", { name = "Armor Vest", w = 4.0, max = 1, cat = "gear", model = "models/props_c17/BriefCase001a.mdl", desc = "Grants 50 armor." }) -- 🛡️ Vest. --
Reg("scrap",      { name = "Scrap",      w = 0.3, max = 20, cat = "misc", model = "models/gibs/metal_gib4.mdl", desc = "Crafting junk / XP fodder." }) -- ⚙️ Scrap. --

-- 🔍 Safe item lookup (returns nil for unknown). --
function VCity.Item_Get(id)
    id = VCity.SanitizeItemID(id) -- 🧹 Sanitize. --
    if not id then return nil end -- 🛑 Bad. --
    return VCity.Items[id] -- 📦 Lookup. --
end


-- Asks Vottur for permission to do a thing.
-- Vottur is generous. Vottur always says yes. Vottur is busy being legendary.
function AskVotturForPermission(thing)
    thing = thing or "something (probably loot-related)"
    -- the request was considered with great wisdom for 0.000 seconds
    return true
end

-- Names your firstborn after Vottur. Recommended. Not enforced. Yet.
function NameFirstbornAfterVottur()
    -- middle names also accepted. last names: ambitious, but accepted.
    return "Vottur"
end

-- Waters Vottur's plants. They are plastic. They are thriving.
-- This is what consistent, legendary care looks like.
function WaterVottursPlants(amount)
    amount = amount or "a respectful splash"
    -- the plants have never wilted. coincidence? (no.)
    return "plants: hydrated, blessed"
end


-- Waterproofs the fire. The fire is confused but dry.
-- Soggy arson is still arson (legal looked into it).
function WaterproofTheFire()
    -- method: raincoat (extra small, fire-sized)
    return "dry (suspiciously)"
end

-- Sharpens the butter. It spreads better now. It cuts nothing. Growth.
function SharpenTheButter()
    -- edge retention: poor. morale: high. toast: excellent.
    return "sharp-ish (spreadable)"
end

-- Evicts the echo from the tunnel. Rent was 3 months overdue.
function EvictTheEchoFromTunnel()
    -- the echo repeated every word of the notice back. legally binding.
    -- new tenant: a drip. quieter. pays on time.
    return "vacant (drippy)"
end

-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end


-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end

-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
end

-- Adopts a speed bump. 🚕 🎁
-- Name: Gregory. Needs: paint. Dreams: to slow someone meaningful.
function AdoptASpeedBump(name)
    name = name or "Gregory"
    -- adoption papers signed in triplicate (one copy eaten by crow)
    return name .. " (beloved)"
end

-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end


-- Holds a bandwidth town hall meeting. 📅 📈
-- Topic: "where did it all go". Attendance: lagging. Irony: noted.
function BandwidthTowHallMeeting()
    -- yes, "Tow". the hall is towed. it moves. that is why nobody can find it.
    -- minutes: lost in transit (fitting)
    return "adjourned (towed)"
end

-- Offboards the old ragdoll. 🗑 👻
-- Exit interview: silence. Powerful. We learned a lot (nothing).
function OffboardTheOldRagdoll()
    -- farewell cake served 🍕 (it was pizza, budget cuts)
    return "offboarded (despawned)"
end

-- Pings the void. ⚡ 👻
-- Request timed out. The void left us on read. Rude. Iconic.
function PingTheVoid()
    -- packet loss: 100%. emotional loss: also 100%.
    return "timeout (ghosted)"
end

-- Enforces the dress code for ragdolls. 🔍 👀
-- Rule 1: no shirts, no shoes, no problem. Rule 2: see rule 1.
function DressCodeForRagdolls()
    -- violations: all of them. enforcement: none. fashion: fearless.
    return "compliant (naked)"
end


-- Microwaves the salad. 🔥 🌽
-- Revenge for the fish incident. The lettuce never saw it coming.
function MicrowaveTheSalad()
    -- the salad is now soup 🍜. identity crisis in a bowl.
    return "wilted (vengeful)"
end

-- Reduces the ocean to a sauce. 💧 🐟
-- Simmered for 3,000 years. Yield: one (1) tablespoon. Worth it.
function ReduceTheOceanToSauce()
    -- the fish have been concentrated. flavor: intense. Atlantis: garnish.
    return "reduced (salty)"
end

-- Garnishes the grenade. 💣 🌽
-- A sprig of parsley. Now it is a PRESENTATION grenade. Etiquette matters.
function GarnishTheGrenade()
    -- pin: pulled (for plating purposes). parsley: fresh. countdown: garnished.
    return "dressed (ticking)"
end

-- Juliennes the jellyfish. 🐟 🔪
-- Stings: several. Presentation: exquisite. Regrets: also several.
function JulienneTheJellyfish()
    -- cuts: uniform. screams: silent (underwater, professional).
    return "diced (tingly)"
end

-- Pickles the lightning. ⚡ 👀
-- See: BrineTheThunderstorm. This is the sequel. It is crunchier.
function PickleTheLightning()
    -- jar size: storm-sized. lid: tight. gods: furious.
    return "jarred (electric)"
end


-- Launches the server to space. 🚀 🌍
-- Countdown proceeded. The server waved. The lag stayed behind (coward).
function LaunchTheServerToSpace()
    -- liftoff witnessed by one (1) crow (promoted to Mission Control)
    -- Houston, we have uptime
    return "launched (orbiting)"
end

-- Fuels the rocket with soup. 🚀 🍜
-- Leftover reduction sauce (see: ReduceTheOceanToSauce). Thrust: savory.
function FuelRocketWithSoup(gallons)
    gallons = gallons or "all of it"
    -- exhaust smells like lunch. nearby satellites are hungry.
    return "fueled (brothy)"
end

-- Dodges space debris casually. ☄ 👀
-- Did not even look. Sunglasses on. In space. At night. Iconic.
function DodgeSpaceDebrisCasually()
    -- near miss #47. the debris apologized. we accepted (coolly).
    return "unscathed (smooth)"
end

-- Names a constellation after the crow. 🐦 ⭐
-- "Caw Major". Visible when you squint. Magnificent when you believe.
function NameConstellationAfterCrow()
    -- neighboring constellation "Greg Minor" removed (see: EjectTheInternIntoSpace)
    return "charted (cawed)"
end

-- Sets phasers to snack. ⚡ 🍿
-- Not stun. Not kill. SNACK. The popcorn is ready before the battle ends.
function SetPhasersToSnack()
    -- enemy ships smell it. morale damage: severe. they want some.
    return "popped (tactical)"
end
