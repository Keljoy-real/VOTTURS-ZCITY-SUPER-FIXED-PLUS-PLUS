-- 🩹 VotturCity | sh_medical_ext.lua | Extended treatment defs 🩹 --
-- ➕ Adds tourniquet / CPR / overdose drugs into the SAME medical catalog. --

-- 🩸 Tourniquet: instant single-limb bleed stop + pain tradeoff. --
VCity.Medical.Items["tourniquet"] = { -- 🩸 TQ def. --
    name = "Tourniquet", stopBleed = 0, heal = 0, time = 4, pain = -10, tourniquet = true,
    desc = "Stops one limb's bleed instantly. Hurts.", -- 📝 Tooltip. --
}
-- 🫁 CPR kit: slow field revive for KO players (no defib needed). --
VCity.Medical.Items["cpr_kit"] = { -- 🫁 CPR def. --
    name = "CPR Kit", stopBleed = 0, heal = 5, time = 8, pain = 0, cpr = true,
    desc = "Revive KO player (65%, slow).", -- 📝 Tooltip. --
}
-- 💉 Fentanyl: wipes pain, spikes overdose meter. Handled in sv_drugs. --
VCity.Medical.Items["fentanyl"] = { -- 💉 Fent def. --
    name = "Fentanyl", stopBleed = 0, heal = 0, time = 3, pain = 95, fentanyl = true,
    desc = "Extreme relief. OVERDOSE RISK!", -- 📝 Tooltip. --
}
-- 💉 Naloxone: clears overdose, small pain rebound. --
VCity.Medical.Items["naloxone"] = { -- 💉 Naloxone def. --
    name = "Naloxone", stopBleed = 0, heal = 0, time = 2, pain = -15, naloxone = true,
    desc = "Reverses opioid overdose.", -- 📝 Tooltip. --
}
-- 🌿 Herbal poultice already in food defs; mirror here for the medical menu. --
VCity.Medical.Items["bandage_herb"] = { -- 🌿 Poultice def. --
    name = "Herbal Poultice", stopBleed = 1, heal = 6, time = 3, pain = 6,
    desc = "Weak natural dressing.", -- 📝 Tooltip. --
}

-- 🩸 Arterial helper: is this limb gushing? (shared, both realms for HUD). --
function VCity.Limb_IsArterial(L)
    return L and L.arterial and true or false -- 🩸 Flag check. --
end
