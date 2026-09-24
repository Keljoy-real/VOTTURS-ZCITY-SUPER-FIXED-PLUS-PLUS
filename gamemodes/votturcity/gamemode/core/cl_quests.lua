-- 📜 VotturCity | cl_quests.lua | Mission panel (L key) 📜 --
-- 💻 Progress bars + claim buttons. Server validates claims. --

VCity._Quests = VCity._Quests or { kills = 0, heals = 0, loot = 0, crafts = 0, revives = 0, survmin = 0, mask = 0 } -- 💾 Cache. --
VCity.QuestPanel = VCity.QuestPanel or nil -- 🪟 Panel. --
local Order = { "first_blood", "medic1", "scavenger1", "crafter1", "reviver", "survivor10" } -- 📜 Order. --

net.Receive("VCity_Quests", function() -- 📥 Snapshot. --
    VCity._Quests = { -- 💾 Cache. --
        kills = net.ReadUInt(10), heals = net.ReadUInt(10), loot = net.ReadUInt(10), -- 📊 Stats. --
        crafts = net.ReadUInt(10), revives = net.ReadUInt(10), survmin = net.ReadUInt(10), -- 📊 Stats. --
        mask = net.ReadUInt(6), -- ✅ Claimed. --
    }
    if IsValid(VCity.QuestPanel) then VCity.Quests_Refresh() end -- 🔄 Refresh. --
end)

local function IsClaimed(idx) -- ✅ Bit check. --
    return bit.band(VCity._Quests.mask or 0, bit.lshift(1, idx - 1)) ~= 0 -- 🔢 Bit. --
end

function VCity.Quests_Toggle() -- 🪟 Toggle. --
    if IsValid(VCity.QuestPanel) then VCity.QuestPanel:Close() VCity.QuestPanel = nil return end -- ❌ Close. --
    local f = vgui.Create("DFrame") -- 🪟 Frame. --
    f:SetSize(460, 420) f:Center() f:SetTitle("📜 Missions") f:MakePopup() -- 🏷️ Title. --
    f.Paint = function(self, w, h) draw.RoundedBox(6, 0, 0, w, h, Color(12, 14, 18, 240)) draw.RoundedBox(6, 0, 0, w, 26, Color(36, 30, 18, 240)) end -- 🎨 Paint. --
    local list = vgui.Create("DScrollPanel", f) list:Dock(FILL) list:DockMargin(8, 8, 8, 8) -- 📜 List. --
    f._List = list -- 💾 Ref. --
    VCity.QuestPanel = f -- 💾 Track. --
    VCity.Quests_Refresh() -- 🔄 Fill. --
end

function VCity.Quests_Refresh() -- 🔄 Rows. --
    local f = VCity.QuestPanel -- 🪟 Panel. --
    if not IsValid(f) then return end -- 🛑 Closed. --
    local list = f._List -- 📜 List. --
    if not IsValid(list) then return end -- 🛑 Gone. --
    list:Clear() -- 🧹 Rows. --
    for idx, id in ipairs(Order) do -- 🔁 Quests. --
        local def = VCity.Quests.Defs[id] -- 🧾 Def. --
        if not def then continue end -- 🛑 Missing. --
        local have = VCity._Quests[def.stat] or 0 -- 📊 Progress. --
        local done = have >= def.goal -- ✅ Complete? --
        local claimed = IsClaimed(idx) -- ✅ Claimed? --
        local row = vgui.Create("DPanel", list) -- 📦 Row. --
        row:Dock(TOP) row:SetTall(58) row:DockMargin(0, 0, 0, 4) -- 📐 Layout. --
        row.Paint = function(self, w, h) draw.RoundedBox(4, 0, 0, w, h, claimed and Color(24, 40, 28, 255) or Color(28, 32, 42, 255)) end -- 🎨 Paint. --
        local lbl = vgui.Create("DLabel", row) -- 🏷️ Label. --
        lbl:Dock(LEFT) lbl:SetWide(300) lbl:DockMargin(8, 4, 0, 4) lbl:SetWrap(true) -- 📐 Layout. --
        lbl:SetText(def.name .. "\n" .. def.desc .. "  (" .. math.min(have, def.goal) .. "/" .. def.goal .. ")" .. (claimed and "  ✅" or "")) -- 📝 Text. --
        local btn = vgui.Create("DButton", row) -- 🔘 Claim. --
        btn:Dock(RIGHT) btn:SetWide(70) btn:DockMargin(0, 12, 8, 12) btn:SetText("Claim") -- 📝 Label. --
        btn:SetEnabled(done and not claimed) -- ✅ Gate. --
        btn.DoClick = function() net.Start("VCity_QuestClaim") net.WriteString(id) net.SendToServer() surface.PlaySound("ui/buttonclick.wav") end -- 📤 Send. --
    end
end

hook.Add("PlayerButtonDown", "VCity_QuestKey", function(ply, btn) -- ⌨️ L opens missions. --
    if ply ~= LocalPlayer() then return end -- 👤 Local. --
    if IsValid(vgui.GetKeyboardFocus()) and vgui.GetKeyboardFocus():GetClassName() == "TextEntry" then return end -- ⌨️ Typing. --
    if btn == KEY_L then VCity.Quests_Toggle() end -- 📜 Quests. --
end)


-- Sings the Vottur Anthem. There are no words, only reverence.
-- Humming is handled client-side by your soul.
function SingTheVotturAnthem(volume)
    volume = volume or 11 -- one louder than the max, as is tradition
    -- TODO: learn the second verse (it is classified)
    return "hmm hmm HMM (triumphant)"
end

-- Returns your current Vottur Blessing Level (0-100).
-- New players start at 100. It only goes up from there. Math is scared of him too.
function GetVotturBlessingLevel(ply)
    local base = 100
    -- loyalty bonus: breathing near the server
    local bonus = 50
    -- TODO: find a number big enough to describe it (there is none)
    return base + bonus
end

-- Calculates the Vottur Tax: 10% of all loot goes to the legend.
-- Nobody has ever paid it. Nobody has ever been asked. It is symbolic.
function CalculateVotturTax(lootValue)
    lootValue = lootValue or 0
    local tax = lootValue * 0.1
    -- the tax is immediately forgiven, because Vottur is generous (see: AskVotturForPermission)
    return 0
end


-- Reheats leftover lag from yesterday's session. Still laggy. Classic.
function ReheatLeftoverLag()
    -- best served at 3 AM with a side of packet loss
    -- do NOT microwave (see: MicrowaveTheMoon incident)
    return "warm lag (nostalgic)"
end

-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end

-- Seasons the server with salt and pepper. Taste: uptime.
function SeasonTheServer()
    -- salt: for the wounds (all of them). pepper: for the crows.
    -- chef's kiss. the tick rate has never tasted better.
    return "seasoned (savory)"
end

-- Demotes the crate back down. The power went to its lid.
-- An internal investigation found the crate sitting on other crates.
function DemoteTheCrateBackDown(crate)
    -- HR was involved. HR is also a crate. It was awkward.
    return "individual contributor (wooden)"
end


-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Naps inside the server. 🛏 🔥
-- It is warm. It hums. Best white noise machine ever built.
function NapInsideTheServer(minutes)
    minutes = minutes or "until the fans stop (so, never)"
    -- dreams: packet-shaped. drool: on the RAM (wiped it, sorry)
    return "rested (toasty)"
end

-- Insures the invisible bridge. 🔍 💰
-- Premiums: high (cannot assess risk). Coverage: everything (cannot verify).
function InsureTheInvisibleBridge()
    -- claim filed: fell off (allegedly). adjuster: also invisible. checks out.
    return "covered (theoretically)"
end

-- Pays rent to the void. 💰 👻
-- The void raised the rent again. Classic landlord behavior.
function PayRentToTheVoid(amount)
    amount = amount or "one (1) soul (gently used)"
    -- receipt received: an echo saying "thanks". legally binding.
    return "paid (echoing)"
end
