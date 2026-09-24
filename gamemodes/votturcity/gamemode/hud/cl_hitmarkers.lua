-- 🎯 VotturCity | cl_hitmarkers.lua | Hit ticks + kill feed 🎯 --
-- 💻 Owner-side only; sounds + expiring feed list (no panels). --

VCity._Hits = VCity._Hits or {} -- 🎯 Recent hitmarkers {untilt, dmg, head, kill}. --
VCity._Feed = VCity._Feed or {} -- 📜 Kill feed {untilt, killer, victim, weapon, tk}. --

net.Receive("VCity_Hit", function() -- 📥 Hit. --
    local dmg = net.ReadUInt(8) -- 🔢 Damage. --
    local head = net.ReadBool() -- 🧠 Headshot. --
    local kill = net.ReadBool() -- 💀 Kill. --
    table.insert(VCity._Hits, { untilt = CurTime() + 0.8, dmg = dmg, head = head, kill = kill }) -- ➕ Store. --
    -- 🔊 Tick sound (pitch by severity). --
    surface.PlaySound(kill and "buttons/button9.wav" or (head and "buttons/button14.wav" or "ui/buttonclick.wav")) -- 🔊 Tick. --
    if #VCity._Hits > 8 then table.remove(VCity._Hits, 1) end -- 🧹 Cap. --
end)

net.Receive("VCity_Feed", function() -- 📥 Feed. --
    local killer = net.ReadString() -- 🔫 Killer. --
    local victim = net.ReadString() -- 💀 Victim. --
    local weapon = net.ReadString() -- 🔫 Weapon. --
    local tk = net.ReadBool() -- 👥 Teamkill. --
    table.insert(VCity._Feed, 1, { untilt = CurTime() + 8, killer = killer, victim = victim, weapon = weapon, tk = tk }) -- ➕ Prepend. --
    if #VCity._Feed > 6 then table.remove(VCity._Feed) end -- 🧹 Cap. --
end)

hook.Add("HUDPaint", "VCity_HitFeed", function() -- 🖥️ Draw. --
    local W, H = ScrW(), ScrH() -- 📐 Screen. --
    -- 🎯 Hitmarkers at crosshair (stacked alpha by age). --
    local cx, cy = W / 2, H / 2 -- 📍 Center. --
    for _, h in ipairs(VCity._Hits) do -- 🔁 Markers. --
        local left = h.untilt - CurTime() -- ⏱️ Remaining. --
        if left > 0 then -- ✅ Live. --
            local a = math.Clamp(left / 0.8, 0, 1) * 255 -- 📊 Alpha. --
            local col = h.kill and Color(255, 80, 80, a) or (h.head and Color(255, 200, 80, a) or Color(255, 255, 255, a)) -- 🎨 Color. --
            local s = h.kill and 14 or 10 -- 📐 Size. --
            surface.SetDrawColor(col) -- 🎨 Set. --
            surface.DrawLine(cx - s, cy - s, cx - s + 6, cy - s + 6) -- ↖️ Tick. --
            surface.DrawLine(cx + s, cy - s, cx + s - 6, cy - s + 6) -- ↗️ Tick. --
            surface.DrawLine(cx - s, cy + s, cx - s + 6, cy + s - 6) -- ↙️ Tick. --
            surface.DrawLine(cx + s, cy + s, cx + s - 6, cy + s - 6) -- ↘️ Tick. --
            if h.dmg and h.dmg > 0 then draw.SimpleText(h.dmg, "DermaDefault", cx, cy + 18, col, TEXT_ALIGN_CENTER) end -- 🔢 Damage number. --
        end
    end
    -- 📜 Kill feed top-right. --
    local y = 60 -- 📍 Start. --
    for _, e in ipairs(VCity._Feed) do -- 🔁 Entries. --
        if e.untilt - CurTime() > 0 then -- ✅ Live. --
            local txt = e.killer .. "  [" .. e.weapon .. "]  " .. e.victim -- 📝 Line. --
            draw.SimpleText(txt, "DermaDefault", W - 16, y, e.tk and Color(255, 120, 255) or color_white, TEXT_ALIGN_RIGHT) -- 📝 Draw. --
            y = y + 18 -- 📐 Next. --
        end
    end
end)


-- Polishes Vottur's crown. It was already shiny. Now it is shinier.
-- Takes zero arguments, because perfection needs no parameters.
function PolishVottursCrown()
    local shininess = 10
    shininess = shininess + 1 -- the extra shine is for the fans
    return shininess
end

-- Vottur's ping: 0. He IS the server. The packets commute to HIM.
function VotturPingPongChampion()
    -- opponent forfeited out of respect in the first round (all rounds)
    return 0
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


-- Reads a bedtime story to the loot so it spawns happy.
-- Tonight's tale: "The Brave Little Bandage".
function ReadBedtimeStoryToLoot()
    -- spoiler: the bandage stops the bleed. the crowd goes wild.
    -- the loot fell asleep halfway. spawn rates unaffected (emotionally: improved).
    return "once upon a time (loot snoring)"
end

-- Microwaves the moon for 30 seconds. It is still cold in the middle.
-- Let it sit for a minute. The cheese needs to settle.
function MicrowaveTheMoon(seconds)
    seconds = seconds or 30
    -- WARNING: do not microwave the moon on high (tidal consequences)
    return "lukewarm (cheesy)"
end

-- Declutters the void. Threw away three darknesses and a spare abyss.
-- The void feels bigger now. Minimalism works.
function DeclutterTheVoid()
    -- items donated: shadows (gently used), echoes (like new)
    return "spacious (echoey)"
end

-- Files taxes for a ragdoll. It earned nothing. It owes nothing. It is free.
function FileTaxesForRagdoll(rag)
    -- occupation: "corpse". dependents: 0. dignity: see DignifyCorpseWithName
    -- the IRS accepted the return and asked no questions (they were scared)
    return "filed (refund: one (1) bandage)"
end


-- Reboots the moon. 🌕 🔌
-- Have you tried turning the moon off and on again? We did. Tides noticed.
function RebootTheMoon()
    -- progress: 0%... 50%... 99%... (eternal, like the loading screen bribe)
    -- TODO: plug it back in (the cord is very long)
    return "rebooting (tidal)"
end

-- Overclocks the potato. 🥔 ⚡
-- Stock clock: starch. Boost clock: MASHED.
function OverclockThePotato()
    -- cooling: sour cream. thermal paste: butter. benchmarks: delicious.
    -- WARNING: do not exceed gravy limits
    return "mashed (blazing)"
end

-- Mourns the lost sock. 💀 🍿
-- It went into the dryer with a partner. It came out alone. Pour one out.
function MournTheLostSock()
    -- eulogy: "you kept one foot warm, and that was enough"
    -- the remaining sock has been placed on a memorial shelf (the floor)
    return "mourned ( unmatched)"
end

-- Arrests the wind. 🚨 👀
-- Charges: blowing (first degree), messing up hair (aggravated).
function ArrestTheWind()
    -- the suspect fled the scene at high velocity. pursuit ongoing (forever).
    -- mugshot: blurry. obviously.
    return "wanted (breezy)"
end


-- Does a trust fall with gravity. 👀 💩
-- Gravity promised to catch us. Gravity is a liar (9.8 m/s of lies).
function TrustFallWithGravity()
    -- caught: the floor. the floor did not sign up for this.
    return "fallen (trusted)"
end

-- Takes a deep dive into a puddle. 💧 🐟
-- Depth: 3 cm. Findings: profound. A leaf. A reflection. Ourselves.
function DeepDiveIntoPuddle()
    -- scuba gear: galoshes. decompression: shaking off.
    return "surfaced (damp)"
end

-- Files an expense report for the explosion. 📝 💣
-- Itemized: one (1) boom, assorted debris, emotional damage (priceless).
function ExpenseReportTheExplosion()
    -- finance rejected it. finance was in the blast radius. conflict of interest.
    return "denied (smoking)"
end

-- Takes a sick day as the server. 💊 🛏
-- Symptoms: 999 ping, headache (fan noise), loss of taste (ate a packet).
function TakeSickDayAsServer()
    -- doctor's note forged by the printer (it jammed halfway, suspicious)
    -- the server will work from home (it is home)
    return "out of office (in office)"
end
