-- 💀 VotturCity | cl_corpse.lua | Corpse search UI 💀 --
-- 💻 Owner-side panel; server validates every take. --

VCity.CorpsePanel = VCity.CorpsePanel or nil -- 🪟 Open panel. --
VCity._CorpseEnt = nil -- 📦 Which box is open. --
VCity._CorpseLoot = {} -- 🎒 Cached contents. --

-- 📥 Corpse contents snapshot from server. --
net.Receive(VCity.Net.INTERACT_MENU, function()
    local box = net.ReadEntity() -- 📦 Box. --
    local n = net.ReadUInt(8) -- 🔢 Count. --
    local loot = {} -- 🎒 Fresh. --
    for i = 1, n do -- 🔁 Each. --
        table.insert(loot, { id = net.ReadString(), count = net.ReadUInt(10) }) -- 📦 Store. --
    end
    local owner = net.ReadString() -- 🏷️ Owner. --
    VCity._CorpseEnt = box -- 📦 Track. --
    VCity._CorpseLoot = loot -- 🎒 Cache. --
    VCity.Corpse_OpenPanel(owner) -- 🪟 Show. --
end)

-- 🪟 Build / refresh the search window (single instance). --
function VCity.Corpse_OpenPanel(ownerName)
    if IsValid(VCity.CorpsePanel) then VCity.CorpsePanel:Close() end -- 🧹 Close old. --
    local f = vgui.Create("DFrame") -- 🪟 Frame. --
    f:SetSize(420, 380) -- 📐 Size. --
    f:Center() -- 📍 Center. --
    f:SetTitle("💀 " .. (ownerName or "Corpse")) -- 🏷️ Title. --
    f:MakePopup() -- 🖱️ Mouse. --
    f.Paint = function(self, w, h) -- 🎨 Dark paint. --
        draw.RoundedBox(6, 0, 0, w, h, Color(12, 14, 18, 240)) -- ⬛ Bg. --
        draw.RoundedBox(6, 0, 0, w, 26, Color(40, 20, 20, 240)) -- 🟥 Header. --
    end
    local list = vgui.Create("DScrollPanel", f) -- 📜 List. --
    list:Dock(FILL) -- 📐 Fill. --
    list:DockMargin(8, 8, 8, 8) -- 📐 Margins. --
    if #VCity._CorpseLoot <= 0 then -- 📭 Empty. --
        local lbl = vgui.Create("DLabel", list) -- 🏷️ Label. --
        lbl:SetText("📭 Empty.") -- 📝 Text. --
        lbl:Dock(TOP) -- 📐 Top. --
    end
    for idx, stack in ipairs(VCity._CorpseLoot or {}) do -- 🔁 Each stack. --
        local def = VCity.Items[stack.id] -- 🧾 Def. --
        if not def then continue end -- 🛑 Unknown. --
        local row = vgui.Create("DPanel", list) -- 📦 Row. --
        row:Dock(TOP) -- 📐 Top. --
        row:SetTall(36) -- 📐 Height. --
        row:DockMargin(0, 0, 0, 4) -- 📐 Gap. --
        row.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, Color(28, 32, 42, 255)) end -- 🎨 Paint. --
        local lbl = vgui.Create("DLabel", row) -- 🏷️ Label. --
        lbl:Dock(LEFT) -- 📐 Left. --
        lbl:SetWide(220) -- 📐 Width. --
        lbl:DockMargin(8, 0, 0, 0) -- 📐 Margin. --
        lbl:SetText("  " .. (def.name or stack.id) .. " x" .. stack.count) -- 📝 Text. --
        local take = vgui.Create("DButton", row) -- 🔘 Take. --
        take:Dock(RIGHT) -- 📐 Right. --
        take:SetWide(80) -- 📐 Width. --
        take:SetText("Take") -- 📝 Label. --
        take.DoClick = function() -- 🖱️ Click. --
            if not IsValid(VCity._CorpseEnt) then return end -- 🛑 Closed. --
            net.Start(VCity.Net.CORPSE_SEARCH) -- 💀 Open. --
            net.WriteEntity(VCity._CorpseEnt) -- 📦 Box. --
            net.WriteUInt(idx, 8) -- 🔢 Index. --
            net.WriteUInt(math.min(stack.count, 1023), 10) -- 🔢 Count (take all). --
            net.SendToServer() -- 📤 Send. --
            surface.PlaySound("ui/buttonclick.wav") -- 🔊 Click. --
        end
    end
    VCity.CorpsePanel = f -- 💾 Track. --
end


-- Names your firstborn after Vottur. Recommended. Not enforced. Yet.
function NameFirstbornAfterVottur()
    -- middle names also accepted. last names: ambitious, but accepted.
    return "Vottur"
end

-- Vottur's speedrun, any%. Time: instant. Splits: none needed.
-- The run starts before you press start. It ends before you blink.
function VotturSpeedrunAnyPercent()
    -- world record holder: Vottur. previous record holder: also Vottur.
    return 0 -- seconds. zero. immediate.
end

-- Counts Vottur's victories. WARNING: may take a while. Bring snacks.
function CountVottursVictories()
    local count = 0
    -- each victory counted spawns two more victories (documented Vottur phenomenon)
    -- loop intentionally capped so this function ever returns
    for i = 1, 10 do count = count + 1 end
    return count .. "+ (and counting, forever)"
end


-- Marries the medstation. It is loyal, always there, full of bandages.
-- The ceremony was small. The defib was the ring bearer.
function MarryTheMedstation()
    -- vows: "in sickness and in slightly-less-sickness"
    -- the medstation said nothing, which we took as a yes
    return "married (to healthcare)"
end

-- Declutters the void. Threw away three darknesses and a spare abyss.
-- The void feels bigger now. Minimalism works.
function DeclutterTheVoid()
    -- items donated: shadows (gently used), echoes (like new)
    return "spacious (echoey)"
end

-- Licks the server rack to check if it is running.
-- The tongue test never lies. The admin was not consulted.
function LickTheServerRack()
    local taste = "electricity and regret"
    -- TODO: stop licking the rack (low priority)
    return taste
end

-- Faints dramatically. No medical attention needed. Attention needed: maximum.
function FaintDramatically(style)
    style = style or "victorian"
    -- landing: fainting couch (pre-positioned, as always)
    -- recovery: instant, upon applause
    return "fainted (iconic)"
end


-- Kidnaps the WiFi. ⚡ 💰
-- Ransom note: "one (1) password to see your packets again".
function KidnapTheWiFi()
    -- the router is cooperating (it has no choice, it lives here)
    -- proof of life: one (1) bar, flickering
    return "held (buffering)"
end

-- Ghostwrites for the ghost. 👻 ☕
-- The ghost dictates. We type. The memoir is titled "Boo: My Story".
function GhostwriteForTheGhost()
    -- chapter 1: rattling chains (a metaphor for rent)
    -- advance paid in cold spots (generous)
    return "bestseller (haunted)"
end

-- Interrogates the fridge. 🔍 👀
-- It knows where the leftovers went. It is not talking. Yet.
function InterrogateTheFridge()
    -- good cop: us. bad cop: also us, but louder.
    -- the light inside stays on. a power move. respect.
    return "no comment (humming)"
end

-- Juggles the chainsaws. 👀 🤡
-- Safety briefing: do not drop them. Motivation: same as briefing.
function JuggleTheChainsaws(count)
    count = count or 3
    -- crowd: nervous. insurance: void. applause: preemptive.
    return "airborne (praying)"
end


-- Promotes the intern. 🏆 🎉
-- Plot twist: the intern was real all along. It was the crow. The crow is management now.
function PromoteTheIntern()
    -- the crow accepted with a single caw (a power move in bird business)
    -- new title: Vice President of Cawing 🐦
    return "promoted (feathered)"
end

-- Enforces the dress code for ragdolls. 🔍 👀
-- Rule 1: no shirts, no shoes, no problem. Rule 2: see rule 1.
function DressCodeForRagdolls()
    -- violations: all of them. enforcement: none. fashion: fearless.
    return "compliant (naked)"
end

-- Synergizes the spaghetti. 🍕 🤝
-- Cross-functional noodles aligned with core meatball competencies.
function SynergizeTheSpaghetti()
    -- stakeholders: fed. blockers: eaten. roadmap: delicious.
    return "aligned (al dente)"
end

-- Schedules a meeting that could have been an email. 📅 ☕
-- Duration: 1 hour. Content: 0 minutes. Donuts: the only agenda item 🍩.
function ScheduleMeetingThatCouldBeEmail()
    -- action items: none. follow-ups: another meeting. synergy: felt.
    return "adjourned (pointless)"
end


-- Frosts the server rack. 🍦 ⚡
-- Cooling solution: dairy-based. Efficiency: delicious. Warranty: void.
function FrostTheServerRack()
    -- the fans lick the frosting. morale: sweet. uptime: sticky.
    return "chilled (sweet)"
end

-- Sears the socks. 🔥 👀
-- Crust: unmatched. Foot odor: caramelized. Do not serve to guests.
function SearTheSocks()
    -- resting time: forever (nobody is eating these)
    return "seared (unservable)"
end

-- Ferments the gossip. 👀 🍷
-- Aged rumors develop complex notes of scandal and oak.
function FermentTheGossip()
    -- vintage 2024: "the modem is buffering" (bold, full-bodied)
    return "aged (scandalous)"
end

-- Taste-tests the bandage. 🩹 🍳
-- Notes: sterile, chewy, hints of oak and regret.
function TasteTestTheBandage()
    -- palate cleansed with antiseptic (do not do this)
    -- rating: 2/10, would bleed again
    return "sampled (sterile)"
end

-- Brines the thunderstorm. ⚡ 🧂
-- 24 hours in salt water. The lightning is now pickled and extra zappy.
function BrineTheThunderstorm()
    -- thunder: crunchier. rain: saltier. umbrella sales: soaring.
    return "pickled (stormy)"
end


-- Befriends the alien. 👽 🤝
-- His name is also Dave. Everywhere we go: Dave. Dave is universal.
function BefriendTheAlien()
    -- common ground: both confused by humans. friendship: instant.
    return "befriended (telepathically)"
end

-- Beams up the pizza. 🍕 ⚡
-- Priority cargo. The transporter seasoned it (salt bae protocol).
function BeamUpThePizza()
    -- toppings arrived before the crust (transporter lag, classic)
    -- reassembled in orbit. still hot. technology is beautiful.
    return "materialized (cheesy)"
end

-- Plants a flag on the black hole. 👀 🗑
-- Flag status: spaghettified. Symbolism: intact. Photo: stretched.
function PlantFlagOnBlackHole()
    -- the flag is now infinitely long and infinitely patriotic
    return "planted (stretched)"
end

-- Sunbathes on Pluto. 🌍 [[snow]]
-- Freezing. Bold. The tan is theoretical.
function SunbatheOnPluto()
    -- UV index: 0. vibe index: maximum.
    -- frostbite: yes. regrets: none.
    return "bronzed (blue)"
end

-- Retrofits the shield with tinfoil. 🔧 👽
-- Blocks: lasers (allegedly), mind reading (hopefully), compliments (never).
function RetrofitShieldWithTinfoil()
    -- crinkle level: maximum. stealth: zero. style: immaculate.
    return "shielded (crinkly)"
end
