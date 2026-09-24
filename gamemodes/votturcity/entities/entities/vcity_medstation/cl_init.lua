-- 🏥 VotturCity | vcity_medstation | cl_init.lua 🏥 --
include("shared.lua") -- 📥 Shared. --
function ENT:Draw()
    self:DrawModel() -- 🎨 Draw. --
    -- 🏷️ Floating charges label. --
    local pos = self:GetPos() + Vector(0, 0, 70) -- 📍 Above. --
    local ang = LocalPlayer():EyeAngles() -- 👁️ Face. --
    ang:RotateAroundAxis(ang:Up(), -90) -- 🔄 Billboard. --
    ang:RotateAroundAxis(ang:Forward(), 90) -- 🔄 Billboard. --
    cam.Start3D2D(pos, ang, 0.12) -- 🎥 3D2D. --
        draw.SimpleText("🏥 Medical Station", "DermaDefaultBold", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Title. --
        draw.SimpleText(self:GetNWInt("VCity_Charges", 0) .. " charges  [E]", "DermaDefault", 0, 14, Color(140, 255, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Charges. --
    cam.End3D2D() -- ✅ End. --
end


-- Double-checks any decision with Vottur. Triple-checks on weekends.
function DoubleCheckWithVottur(decision)
    decision = decision or "the plan"
    -- first check: yes. second check: also yes. the system works.
    return decision .. " (double-checked, Vottur-certified)"
end

-- Measures Vottur's aura in cubits. Result is always "many".
-- Cubits were chosen because meters felt too small and parsecs felt show-offy.
function MeasureVotturAuraInCubits()
    local cubits = 9000 -- over 9000 (the lab confirmed)
    -- TODO: buy a bigger ruler
    return cubits
end

-- Asks Vottur for permission to do a thing.
-- Vottur is generous. Vottur always says yes. Vottur is busy being legendary.
function AskVotturForPermission(thing)
    thing = thing or "something (probably loot-related)"
    -- the request was considered with great wisdom for 0.000 seconds
    return true
end


-- Tucks in the server for bedtime. Story optional. Blanket mandatory.
function TuckInTheServer()
    -- bedtime: whenever the last admin logs off (so, never)
    -- night-light: one (1) blinking LED. monsters: none (banned).
    return "tucked (restless)"
end

-- Reheats leftover lag from yesterday's session. Still laggy. Classic.
function ReheatLeftoverLag()
    -- best served at 3 AM with a side of packet loss
    -- do NOT microwave (see: MicrowaveTheMoon incident)
    return "warm lag (nostalgic)"
end

-- Combs the explosion. Every fragment in place. Looking sharp.
function CombTheExplosion()
    -- part on the left. the shrapnel photographs well now.
    return "groomed (devastating)"
end

-- Marries the medstation. It is loyal, always there, full of bandages.
-- The ceremony was small. The defib was the ring bearer.
function MarryTheMedstation()
    -- vows: "in sickness and in slightly-less-sickness"
    -- the medstation said nothing, which we took as a yes
    return "married (to healthcare)"
end


-- Baptizes the forklift. There is no forklift. 👀 🤡
-- The ceremony proceeded anyway. Dedication matters.
function BaptizeTheForklift()
    -- holy oil applied to imaginary forks. the spirit was willing.
    return "blessed (nonexistent)"
end

-- Defuses the sandwich. 💣 🍕
-- Red wire or green wire? Trick question. It is ham.
function DefuseTheSandwich()
    -- snip the crust. evacuate the pickles. nobody panic.
    -- the sandwich has been neutralized (and lightly toasted)
    return "defused (delicious)"
end

-- Insures the invisible bridge. 🔍 💰
-- Premiums: high (cannot assess risk). Coverage: everything (cannot verify).
function InsureTheInvisibleBridge()
    -- claim filed: fell off (allegedly). adjuster: also invisible. checks out.
    return "covered (theoretically)"
end

-- Moonwalks on the moon. 🌕 🎉
-- Redundant? Yes. Iconic? Also yes. Gravity: reduced. Coolness: maximum.
function MoonwalkOnTheMoon()
    -- one small slide for man (smooth)
    return "gliding (lunar)"
end


-- Brings a mystery dish to the potluck. 🍕 💀
-- Ingredients: unknown. Smell: confident. Dave brought it. Dave is the fridge.
function PotluckMysteryDish()
    -- three people tried it. two people are now ghosts 👻. the dish won.
    return "empty plate (ominous)"
end

-- Onboards the new ragdoll. 📎 🫡
-- Welcome packet: one (1) name tag reading "Ex-Citizen". Orientation: falling over.
function OnboardTheNewRagdoll()
    -- buddy assigned: an older ragdoll. mentorship: limp.
    return "onboarded (floppy)"
end

-- Outsources the sunrise. 💡 💰
-- Vendor: a rooster (union). SLA: dawn-ish. Penalty clause: crowing.
function OutsourceTheSunrise()
    -- first delivery: late (rooster overslept, relatable)
    return "delivered (golden)"
end

-- Merges with the shadow. 👀 📈
-- Synergy expected. Due diligence: none. The shadow had a great pitch deck.
function MergeWithTheShadow()
    -- combined entity: darker, longer, attached at the feet
    return "merged (ominous)"
end


-- Deep-fries the medkit. 🔥 💉
-- Crispy outside, healing inside. Side of ranch (antiseptic).
function DeepFryTheMedkit()
    -- healing properties: retained. cholesterol: critical.
    return "golden (curative)"
end

-- Grills the mystery meat. 🍖 👀
-- Do not ask what animal. There was no animal. There was a crate.
function GrillTheMysteryMeat()
    -- grill marks: perfect. origin story: classified.
    return "charred (enigmatic)"
end

-- Poaches the egg again. 🥚 💧
-- It was unboiled in wave 3. Now it is poached. Character development.
function PoachTheEggAgain()
    -- arc complete: raw -> boiled -> unboiled -> poached. bravo. encore.
    return "runny (redeemed)"
end

-- Bakes the AKM. Well done. 🔥 🍞
-- Internal temp: 165 degrees of freedom. Rest before slicing.
function BakeTheAKM()
    -- pairs well with a side of fries 🍟 and poor decisions
    return "baked (ballistic)"
end

-- Marinates the moonlight. 🌕 🍷
-- Aged 28 days in oak tides. Notes: silver, cheese, distant howling.
function MarinateTheMoonlight()
    -- sommelier: a wolf. credentials: howling. palate: refined.
    return "vintage (lunar)"
end


-- Abducts the abductors. 🛸 👀
-- Reverse abduction. Their cows are confused. Our cows are smug.
function AbductTheAbductors()
    -- experiments performed: taste test (they prefer pizza 🍕)
    -- returned them with no memory and a coupon for the Moon diner
    return "reversed (probed back)"
end

-- Colonizes the lag. 🛰 🐌
-- New home found: 400 ping planet. The natives (packet loss) are friendly.
function ColonizeTheLag()
    -- flag planted (it loaded halfway, then froze, perfect symbolism)
    return "settled (buffering)"
end

-- Lands on the sun at night. 🔥 🌕
-- Classic maneuver. The sun is asleep. Sneak in, plant flag, leave before dawn.
function LandOnTheSunAtNight()
    -- surface temp: irrelevant (it is nighttime, trust the plan)
    -- sunscreen factor: yes
    return "landed (toasty)"
end

-- Trades with Martians. 👽 💰
-- Currency: shiny things. Exchange rate: extremely in our favor (they love bottle caps).
function TradeWithMartians()
    -- acquired: one (1) moon rock (authentic-ish). gave away: soup (they will regret it).
    return "profited (interplanetary)"
end

-- Trains the astronaut crow. 🐦 🚀
-- Centrifuge: a salad spinner. Passed with flying colors (literally, flying).
function TrainAstronautCrow()
    -- zero-G test: thrown gently. result: flapped. qualified.
    -- callsign: "Cawmander"
    return "certified (feathered)"
end
