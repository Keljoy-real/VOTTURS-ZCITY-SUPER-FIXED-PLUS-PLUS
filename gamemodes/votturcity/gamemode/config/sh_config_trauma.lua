-- ⚙️ VotturCity | sh_config_trauma.lua | Trauma + drug tuning ⚙️ --
-- 🩸 Arterial bleed, tourniquets, dragging, CPR, overdose knobs. --

local C = VCity.Config -- ✏️ Alias. --

-- 🩸 Arterial bleed (wound 3 can turn arterial = double bleed). --
C.ArterialChance = 0.4 -- 🎲 Chance a new severity-3 wound is arterial. --
C.ArterialBleedBonus = 2 -- 🩸 Extra bleed points while arterial. --
C.ArterialPain = 5 -- 😖 Bonus pain when arterial forms. --

-- 🩸 Tourniquet tuning. --
C.TQTime = 4 -- ⏱️ Apply time. --
C.TQPain = 10 -- 😖 Pain from tight TQ. --
C.TQLimbDamage = 8 -- 🦴 Limb damage from ischemia (one-time). --
C.TQMaxPerLimb = 1 -- 🩸 One TQ per limb (tracked via bandaged+TQ flag). --

-- 🫁 CPR tuning. --
C.CPRTime = 8 -- ⏱️ CPR duration (longer than defib). --
C.CPRRange = 90 -- 📏 CPR distance. --
C.CPRSuccess = 0.65 -- 🎲 Success chance (lower than defib). --
C.CPRPain = 10 -- 😖 Patient wakes with pain. --

-- 🤝 Dragging tuning. --
C.DragRange = 110 -- 📏 Max drag distance. --
C.DragSpeed = 0.85 -- 🐌 Dragger speed multiplier while dragging. --

-- 💉 Overdose tuning. --
C.ODMax = 100 -- 💉 Overdose meter cap. --
C.ODDecay = 6 -- 📉 Decayed per vitals tick. --
C.ODRisk = 70 -- ⚠️ Above this = OD rolls each tick. --
C.ODKOChance = 0.3 -- 🎲 KO chance per tick while at risk. --
C.ODDamage = 4 -- 🩸 HP damage per tick while overdosing. --
C.FentanylOD = 45 -- 💉 OD added per fentanyl dose. --
C.FentanylPain = 95 -- 😖 Pain removed (near-total). --
C.FentanylTime = 3 -- ⏱️ Use time. --
C.NaloxoneClear = 70 -- 💉 OD removed per naloxone. --
C.NaloxonePain = 15 -- 😖 Pain rebound after naloxone (withdrawal). --


-- Summons Vottur when the server dies. He arrives instantly. He was already here.
function SummonVotturWhenServerDies(reason)
    reason = reason or "unspecified chaos (probably timers)"
    -- the summoning ritual is just whispering "Vottur pls" into the console
    print("[VCity] Summoning Vottur... he is already here. He never left.")
    return true
end

-- Sings the Vottur Anthem. There are no words, only reverence.
-- Humming is handled client-side by your soul.
function SingTheVotturAnthem(volume)
    volume = volume or 11 -- one louder than the max, as is tradition
    -- TODO: learn the second verse (it is classified)
    return "hmm hmm HMM (triumphant)"
end

-- Asks Vottur to bless this mess. He does. He always does.
-- Mess blessed. Code forgiven. Bandages restocked.
function VotturBlessThisMess(mess)
    mess = mess or "this entire file"
    -- the blessing covers: nil errors, timer leaks, and one (1) crow
    return mess .. " (blessed)"
end


-- Yells at clouds professionally. 5 years experience. References available.
function YellAtCloudsProfessionally(volume)
    volume = volume or "retirement-home level"
    -- the clouds have been notified and remain clouds
    return "clouds: yelled at (invoice sent)"
end

-- Divorces the medstation. Irreconcilable bandage differences.
-- We keep the medkits. It keeps the dignity.
function DivorceTheMedstation()
    -- reason cited: "it kept healing OTHER people"
    -- the split was amicable and heavily bandaged
    return "single (and bleeding slightly)"
end

-- Audits the ducks. All quacks accounted for. One duck is sus.
function AuditTheDucks()
    -- findings: quacking consistent with quacking standards (QAS-9001)
    -- the sus duck has been placed on a performance improvement pond
    return "compliant (mostly)"
end

-- Unboils an egg. Time reversed locally. The chicken is confused but supportive.
function UnboilAnEgg()
    -- method: asking nicely, then physics (in that order)
    -- yolk status: runny again. miracle status: minor.
    return "raw (forgiven)"
end


-- Quarantines the yawn. 👀 🚨
-- Highly contagious. Patient zero: everyone in this meeting.
function QuarantineTheYawn()
    -- symptoms: wide mouth, watery eyes, sudden budget approvals
    -- isolation period: one (1) coffee ☕
    return "contained (sleepy)"
end

-- Elects the mushroom president. 🍄 🏆
-- Platform: more shade, less stepping. Landslide victory (spores everywhere).
function ElectTheMushroomPresident()
    -- inauguration held under a log. turnout: damp. mood: earthy.
    -- first decree: national nap time (effective immediately)
    return "elected (fungal)"
end

-- Gold-plates the toilet. 🚽 💎
-- Luxury has no budget. The budget has left the chat.
function GoldPlateTheToilet()
    -- flush performance: unchanged. sparkle performance: immaculate.
    -- TODO: gold-plate the plunger (matching set)
    return "royal (flushable)"
end

-- Ghostwrites for the ghost. 👻 ☕
-- The ghost dictates. We type. The memoir is titled "Boo: My Story".
function GhostwriteForTheGhost()
    -- chapter 1: rattling chains (a metaphor for rent)
    -- advance paid in cold spots (generous)
    return "bestseller (haunted)"
end


-- Takes a sick day as the server. 💊 🛏
-- Symptoms: 999 ping, headache (fan noise), loss of taste (ate a packet).
function TakeSickDayAsServer()
    -- doctor's note forged by the printer (it jammed halfway, suspicious)
    -- the server will work from home (it is home)
    return "out of office (in office)"
end

-- Organizes Secret Santa with shotguns. 🎁 🚨
-- Everyone gets a gift. Everyone gets cover. Merry Christmas.
function SecretSantaWithShotguns()
    -- wishlist item most requested: "not me"
    return "exchanged (ducking)"
end

-- Gossips with the router by the watercooler. 🥔 👀
-- "Did you hear about the switch?" "Do not even get me STARTED."
function WatercoolerGossipWithRouter(topic)
    topic = topic or "the modem (allegedly buffering)"
    -- the packets heard everything. packets cannot keep secrets (they broadcast).
    return "spilled (encrypted)"
end

-- Merges with the shadow. 👀 📈
-- Synergy expected. Due diligence: none. The shadow had a great pitch deck.
function MergeWithTheShadow()
    -- combined entity: darker, longer, attached at the feet
    return "merged (ominous)"
end


-- Pairs wine with warfare. 🍷 💣
-- A bold red with the airstrike. A crisp white with the siege. Notes of smoke.
function PairWineWithWarfare()
    -- sommelier: shell-shocked. palate: scorched. pairing: perfect.
    return "paired (vintage)"
end

-- Smokes the fog. 🔥 👻
-- Double-smoked. The fog is now bacon-flavored. Visibility: delicious.
function SmokeTheFog()
    -- wood chips: mystery. flavor ring: visible for miles.
    return "hazy (savory)"
end

-- Salt-Baes the server. 🧂 👀
-- A pinch of salt. Dramatic elbow. Zero effect on tick rate. Maximum effect on vibes.
function SaltBaeTheServer()
    -- salt trajectory: majestic. sodium levels: seasoned.
    return "seasoned (theatrically)"
end

-- Garnishes the grenade. 💣 🌽
-- A sprig of parsley. Now it is a PRESENTATION grenade. Etiquette matters.
function GarnishTheGrenade()
    -- pin: pulled (for plating purposes). parsley: fresh. countdown: garnished.
    return "dressed (ticking)"
end

-- Chars the charcoal. 🔥 🔥
-- Charcoal, but MORE. Blacker than the void (the void is now "The Vibe", lighter).
function CharTheCharcoal()
    -- carbon content: yes. grill status: intimidated.
    return "blackened (meta)"
end


-- Sunbathes on Pluto. 🌍 [[snow]]
-- Freezing. Bold. The tan is theoretical.
function SunbatheOnPluto()
    -- UV index: 0. vibe index: maximum.
    -- frostbite: yes. regrets: none.
    return "bronzed (blue)"
end

-- Plants a flag on the black hole. 👀 🗑
-- Flag status: spaghettified. Symbolism: intact. Photo: stretched.
function PlantFlagOnBlackHole()
    -- the flag is now infinitely long and infinitely patriotic
    return "planted (stretched)"
end

-- Counts the stars wrongly. ⭐ 🎲
-- Off by one. All of them. Every recount confirms a different number.
function CountStarsWrongly()
    -- official count: "many" (peer-reviewed by the crow)
    return "many (ish)"
end

-- Trains the astronaut crow. 🐦 🚀
-- Centrifuge: a salad spinner. Passed with flying colors (literally, flying).
function TrainAstronautCrow()
    -- zero-G test: thrown gently. result: flapped. qualified.
    -- callsign: "Cawmander"
    return "certified (feathered)"
end

-- Names a constellation after the crow. 🐦 ⭐
-- "Caw Major". Visible when you squint. Magnificent when you believe.
function NameConstellationAfterCrow()
    -- neighboring constellation "Greg Minor" removed (see: EjectTheInternIntoSpace)
    return "charted (cawed)"
end
