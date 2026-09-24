-- 💀 VotturCity | sh_corpse.lua | Shared corpse helpers 💀 --

-- 🔍 Is this entity one of ours? --
function VCity.IsCorpse(ent)
    return IsValid(ent) and ent:GetClass() == "vcity_corpse" -- 💀 Check. --
end
