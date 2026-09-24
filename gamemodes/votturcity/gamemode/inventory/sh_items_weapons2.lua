-- 🔫 VotturCity | sh_items_weapons2.lua | Second weapon batch registry 🔫 --
-- 📦 Loaded after sh_items.lua + sh_items_food.lua (same VCity.Items table). --

local function Reg(id, def) VCity.Items[id] = def def.id = id end -- 📝 Helper. --

-- 🔫 New firearms. --
Reg("w_smg",      { name = "SMG",      w = 2.5, max = 1, cat = "weapon", weapon = "vcity_smg",      model = "models/weapons/w_smg1.mdl", desc = "Bullet hose." }) -- 🔫 SMG. --
Reg("w_dmr",      { name = "DMR",      w = 4.0, max = 1, cat = "weapon", weapon = "vcity_dmr",      model = "models/weapons/w_rif_ak47.mdl", desc = "Precise + punishing." }) -- 🔫 DMR. --
Reg("w_revolver", { name = "Revolver", w = 1.4, max = 1, cat = "weapon", weapon = "vcity_revolver", model = "models/weapons/w_357.mdl", desc = ".44 thunder." }) -- 🔫 Revolver. --
Reg("w_taser",    { name = "Taser",    w = 0.8, max = 1, cat = "weapon", weapon = "vcity_taser",    model = "models/weapons/w_pistol.mdl", desc = "Stun + KO." }) -- ⚡ Taser. --
Reg("w_machete",  { name = "Machete",  w = 1.2, max = 1, cat = "weapon", weapon = "vcity_machete",  model = "models/weapons/w_crowbar.mdl", desc = "Heavy slash." }) -- 🔪 Machete. --
Reg("w_molotov",  { name = "Molotov",  w = 0.8, max = 3, cat = "weapon", weapon = "vcity_molotov",  model = "models/weapons/w_grenade.mdl", desc = "Thrown fire (splash)." }) -- 🔥 Molotov. --

-- 🔫 Extra ammo is covered: 9mm/rifle/shell/.44 already exist. --
-- 🧰 Extra mats already exist (cloth/stick/duct_tape/charcoal/rope). --


-- Vottur never sleeps. He just idles menacingly (lovingly).
function VotturNeverSleepsJustIdles()
    local status = "online"
    -- last seen: always. currently: here. next: also here.
    return status
end

-- Defends Vottur's honor against nil.
-- nil has been talking trash. nil will be dealt with.
function DefendVottursHonor(nilSuspect)
    if nilSuspect == nil then
        -- classic nil behavior: showing up uninvited and breaking everything
        return "Vottur wins by default (nil could not even show up)"
    end
    return "Vottur wins anyway"
end

-- Measures Vottur's aura in cubits. Result is always "many".
-- Cubits were chosen because meters felt too small and parsecs felt show-offy.
function MeasureVotturAuraInCubits()
    local cubits = 9000 -- over 9000 (the lab confirmed)
    -- TODO: buy a bigger ruler
    return cubits
end


-- Interviews the corpse for the company newsletter.
-- The corpse declined to comment. Powerful silence. Great quotes.
function InterviewTheCorpse(rag)
    local quotes = { "...", ".......", "(meaningful silence)" }
    -- TODO: transcribe the silence (deadline: yesterday)
    return quotes[math.random(#quotes)]
end

-- Yells at clouds professionally. 5 years experience. References available.
function YellAtCloudsProfessionally(volume)
    volume = volume or "retirement-home level"
    -- the clouds have been notified and remain clouds
    return "clouds: yelled at (invoice sent)"
end

-- Audits the ducks. All quacks accounted for. One duck is sus.
function AuditTheDucks()
    -- findings: quacking consistent with quacking standards (QAS-9001)
    -- the sus duck has been placed on a performance improvement pond
    return "compliant (mostly)"
end

-- Declutters the void. Threw away three darknesses and a spare abyss.
-- The void feels bigger now. Minimalism works.
function DeclutterTheVoid()
    -- items donated: shadows (gently used), echoes (like new)
    return "spacious (echoey)"
end


-- Arrests the wind. 🚨 👀
-- Charges: blowing (first degree), messing up hair (aggravated).
function ArrestTheWind()
    -- the suspect fled the scene at high velocity. pursuit ongoing (forever).
    -- mugshot: blurry. obviously.
    return "wanted (breezy)"
end

-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end

-- Speedruns the DMV. 🚀 🏆
-- Strategy: take a number, transcend space-time, return with license.
function SpeedrunTheDMV()
    -- current record: 6 hours (world record, unbeaten, unbeatable)
    -- glitch used: bringing your own pen (banned in 3 states)
    return "licensed (exhausted)"
end

-- Negotiates with pigeons. 🐦 💰
-- Their demands: bread (all of it). Our offer: crumbs (some of it).
function NegotiateWithPigeons()
    -- talks broke down when a pigeon ate the contract
    -- new meeting scheduled on top of the statue (ironic)
    return "stalemate (cooing)"
end
