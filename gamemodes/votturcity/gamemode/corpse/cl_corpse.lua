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
