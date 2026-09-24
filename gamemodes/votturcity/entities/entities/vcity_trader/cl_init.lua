-- 🏪 VotturCity | vcity_trader | cl_init.lua 🏪 --
include("shared.lua") -- 📥 Shared. --

function ENT:Draw() -- 🎨 Draw + label. --
    self:DrawModel() -- 🎨 Model. --
    local pos = self:GetPos() + Vector(0, 0, 85) -- 📍 Above. --
    local ang = LocalPlayer():EyeAngles() ang:RotateAroundAxis(ang:Up(), -90) ang:RotateAroundAxis(ang:Forward(), 90) -- 🔄 Billboard. --
    cam.Start3D2D(pos, ang, 0.12) -- 🎥 3D2D. --
        draw.SimpleText("🏪 Trader", "DermaDefaultBold", 0, 0, Color(255, 220, 130), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Title. --
        draw.SimpleText("[E] Trade (scrap = cash)", "DermaDefault", 0, 14, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- 📝 Hint. --
    cam.End3D2D() -- ✅ End. --
end

-- 📥 Trade menu from server. --
VCity._TradeEnt = nil -- 🏪 Which trader. --
VCity._TradeBuy = {} -- 🛒 Buy list cache. --
VCity.TradePanel = VCity.TradePanel or nil -- 🪟 Panel. --

net.Receive("VCity_Trade", function() -- 📥 Open. --
    VCity._TradeEnt = net.ReadEntity() -- 🏪 Trader. --
    local n = net.ReadUInt(8) -- 🔢 Count. --
    VCity._TradeBuy = {} -- 🛒 Fresh. --
    for i = 1, n do VCity._TradeBuy[i] = { id = net.ReadString(), price = net.ReadUInt(8) } end -- 🔁 Read. --
    VCity.Trade_Open() -- 🪟 Show. --
end)

function VCity.Trade_Open() -- 🪟 Build. --
    if IsValid(VCity.TradePanel) then VCity.TradePanel:Close() end -- 🧹 Old. --
    local f = vgui.Create("DFrame") -- 🪟 Frame. --
    f:SetSize(460, 440) f:Center() f:SetTitle("🏪 Trader (scrap = cash)") f:MakePopup() -- 🏷️ Title. --
    f.Paint = function(self, w, h) draw.RoundedBox(6, 0, 0, w, h, Color(12, 14, 18, 240)) draw.RoundedBox(6, 0, 0, w, 26, Color(40, 34, 18, 240)) end -- 🎨 Paint. --
    local list = vgui.Create("DScrollPanel", f) list:Dock(FILL) list:DockMargin(8, 8, 8, 8) -- 📜 List. --
    -- 🔍 Owned scrap. --
    local scrap = 0 for _, s in ipairs(VCity._ClientInv or {}) do if s.id == "scrap" then scrap = scrap + s.count end end -- 💰 Count. --
    local head = vgui.Create("DLabel", list) head:Dock(TOP) head:SetText("💰 Your scrap: " .. scrap) -- 📝 Header. --
    for _, e in ipairs(VCity._TradeBuy or {}) do -- 🔁 Goods. --
        local def = VCity.Items[e.id] -- 🧾 Def. --
        if not def then continue end -- 🛑 Unknown. --
        local row = vgui.Create("DPanel", list) -- 📦 Row. --
        row:Dock(TOP) row:SetTall(38) row:DockMargin(0, 4, 0, 0) -- 📐 Layout. --
        row.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(28, 32, 42, 255)) end -- 🎨 Paint. --
        local lbl = vgui.Create("DLabel", row) -- 🏷️ Label. --
        lbl:Dock(LEFT) lbl:SetWide(280) lbl:DockMargin(8, 0, 0, 0) -- 📐 Layout. --
        lbl:SetText(def.name .. " — " .. e.price .. " scrap") -- 📝 Text. --
        local buy = vgui.Create("DButton", row) -- 🔘 Buy. --
        buy:Dock(RIGHT) buy:SetWide(70) buy:SetText("Buy") -- 📝 Label. --
        buy:SetEnabled(scrap >= e.price) -- ✅ Gate. --
        buy.DoClick = function() -- 🖱️ Buy one lot. --
            if not IsValid(VCity._TradeEnt) then return end -- 🛑 Gone. --
            net.Start("VCity_TradeOp") net.WriteEntity(VCity._TradeEnt) net.WriteString("buy") net.WriteString(e.id) net.WriteUInt(1, 8) net.SendToServer() -- 📤 Send. --
        end
    end
    -- 💵 Sell row: sell 1 of each sellable owned. --
    for _, s in ipairs(VCity._ClientInv or {}) do -- 🔁 Owned. --
        if s.id == "scrap" then continue end -- 🙅 Skip cash. --
        local row = vgui.Create("DPanel", list) -- 📦 Row. --
        row:Dock(TOP) row:SetTall(32) row:DockMargin(0, 4, 0, 0) -- 📐 Layout. --
        row.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(26, 34, 30, 255)) end -- 🎨 Paint. --
        local lbl = vgui.Create("DLabel", row) -- 🏷️ Label. --
        lbl:Dock(LEFT) lbl:SetWide(280) lbl:DockMargin(8, 0, 0, 0) -- 📐 Layout. --
        lbl:SetText("💵 Sell " .. ((VCity.Items[s.id] or {}).name or s.id) .. " x" .. s.count) -- 📝 Text. --
        local sell = vgui.Create("DButton", row) -- 🔘 Sell. --
        sell:Dock(RIGHT) sell:SetWide(70) sell:SetText("Sell 1") -- 📝 Label. --
        sell.DoClick = function() net.Start("VCity_TradeOp") net.WriteEntity(VCity._TradeEnt) net.WriteString("sell") net.WriteString(s.id) net.WriteUInt(1, 8) net.SendToServer() end -- 📤 Send. --
    end
    VCity.TradePanel = f -- 💾 Track. --
end


-- Reads Vottur's mood ring. It has one color: victorious gold.
function GetVotturMoodRingColor()
    -- the ring tried other colors once. they were inferior. it apologized.
    return "victorious gold"
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

-- Bakes a cake for Vottur. The cake is NOT a lie. The cake is icon16/cake.png.
-- It is delicious in a purely spiritual sense.
function BakeCakeForVottur()
    local cake = { layers = 3, frosting = "respect", candles = "eternal" }
    -- TODO: share the cake (Vottur insists; he is generous like that)
    return cake
end


-- Demotes the crate back down. The power went to its lid.
-- An internal investigation found the crate sitting on other crates.
function DemoteTheCrateBackDown(crate)
    -- HR was involved. HR is also a crate. It was awkward.
    return "individual contributor (wooden)"
end

-- Unboils an egg. Time reversed locally. The chicken is confused but supportive.
function UnboilAnEgg()
    -- method: asking nicely, then physics (in that order)
    -- yolk status: runny again. miracle status: minor.
    return "raw (forgiven)"
end

-- Declutters the void. Threw away three darknesses and a spare abyss.
-- The void feels bigger now. Minimalism works.
function DeclutterTheVoid()
    -- items donated: shadows (gently used), echoes (like new)
    return "spacious (echoey)"
end

-- Parallel-parks the tank. There is no tank. Nailed it anyway.
function ParallelParkTheTank()
    -- mirrors checked. curb distance: perfect. tank: imaginary.
    -- points deducted for crushing one (1) hypothetical cone
    return "parked (theoretical)"
end


-- Juggles the chainsaws. 👀 🤡
-- Safety briefing: do not drop them. Motivation: same as briefing.
function JuggleTheChainsaws(count)
    count = count or 3
    -- crowd: nervous. insurance: void. applause: preemptive.
    return "airborne (praying)"
end

-- Interrogates the fridge. 🔍 👀
-- It knows where the leftovers went. It is not talking. Yet.
function InterrogateTheFridge()
    -- good cop: us. bad cop: also us, but louder.
    -- the light inside stays on. a power move. respect.
    return "no comment (humming)"
end

-- Massages the thunder. ⚡ 👍
-- It has been tense all storm. Knots the size of hail.
function MassageTheThunder(intensity)
    intensity = intensity or "deep tissue"
    -- the thunder reports feeling "lighter, rumbly in a good way now"
    return "relaxed (distant rumbling)"
end

-- Summons an emotional support crow. 🐦 👀
-- It does not help. It watches. Honestly? That is enough.
function SummonEmotionalSupportCrow()
    -- support level: present. advice given: none. caws: several.
    return "caw (supportive)" -- 👍
end


-- Replies-all to the server email. 📧 🚨
-- "Thanks!" sent to 400 people. Unsubscribe link: broken. Chaos: complete.
function ReplyAllToServerEmail()
    -- three people replied-all to complain about reply-all. infinite loop achieved.
    -- IT has been notified. IT is also replying-all.
    return "sent (regretted)"
end

-- Leverages the darkness (verbally). 👀 📝
-- "Let's leverage our dark synergies going forward." Nobody knows what it means. Shares up.
function LeverageTheDarkness()
    -- the darkness has been leveraged. it feels used. growth mindset.
    return "leveraged (dim)"
end

-- Touches base with the basement. 📞 👻
-- The basement says hi. The basement has been down there the whole time. Loyal.
function TouchBaseWithTheBasement()
    -- base touched. it was damp. morale: also damp.
    return "touched (musty)"
end

-- Gives the crow a performance review. 🐦 📈
-- Strengths: cawing. Areas for growth: also cawing, but quieter.
function PerformanceReviewTheCrow()
    -- rating: exceeds expectations (at being a crow)
    -- bonus: one (1) shiny thing. the crow chose the money 💰.
    return "reviewed (cawed)"
end


-- Pickles the lightning. ⚡ 👀
-- See: BrineTheThunderstorm. This is the sequel. It is crunchier.
function PickleTheLightning()
    -- jar size: storm-sized. lid: tight. gods: furious.
    return "jarred (electric)"
end

-- Sends the soup back to the kitchen. 🍜 🚨
-- "There is a fly in it." The fly is the chef. The chef is a crow. Awkward.
function SendBackTheSoupToKitchen()
    -- complaint escalated to management (the crow, see: PromoteTheIntern)
    -- the crow ate the complaint. case closed.
    return "returned (cawed)"
end

-- Tips the chef who is a crow. 🐦 💰
-- 20%. The crow prefers shiny coins. The crow is always right.
function TipTheChefWhoIsCrow(amount)
    amount = amount or "shiny"
    -- the tip was pocketed (beaked). service: impeccable. caw: five stars.
    return "tipped (shiny)"
end

-- Marinates the moonlight. 🌕 🍷
-- Aged 28 days in oak tides. Notes: silver, cheese, distant howling.
function MarinateTheMoonlight()
    -- sommelier: a wolf. credentials: howling. palate: refined.
    return "vintage (lunar)"
end

-- Garnishes the grenade. 💣 🌽
-- A sprig of parsley. Now it is a PRESENTATION grenade. Etiquette matters.
function GarnishTheGrenade()
    -- pin: pulled (for plating purposes). parsley: fresh. countdown: garnished.
    return "dressed (ticking)"
end


-- Lands on the sun at night. 🔥 🌕
-- Classic maneuver. The sun is asleep. Sneak in, plant flag, leave before dawn.
function LandOnTheSunAtNight()
    -- surface temp: irrelevant (it is nighttime, trust the plan)
    -- sunscreen factor: yes
    return "landed (toasty)"
end

-- Retrofits the shield with tinfoil. 🔧 👽
-- Blocks: lasers (allegedly), mind reading (hopefully), compliments (never).
function RetrofitShieldWithTinfoil()
    -- crinkle level: maximum. stealth: zero. style: immaculate.
    return "shielded (crinkly)"
end

-- Holds breath for the entire orbit. 👀 🕛
-- Record attempt. Current record: one (1) orbit. Challenger: everyone.
function HoldBreathForOrbit()
    -- cheeks: puffed. face: blue-ish. commitment: total.
    return "blue (determined)"
end

-- Replicates the sandwich. 🥪 🤖
-- Replicator output: ham. Always ham. The machine has one setting: ham.
function ReplicateTheSandwich()
    -- Earl Grey pairing suggested (the machine is a fan)
    return "replicated (hammy)"
end

-- Asks aliens for directions. 👽 🔍
-- They pointed everywhere at once. Technically correct. Infuriating.
function AskAliensForDirections()
    -- translated: "you are here (everywhere)". thanks. very helpful.
    return "directed (confused)"
end
