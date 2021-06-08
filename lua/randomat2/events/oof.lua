local EVENT = {}
EVENT.Title = "Oof"
EVENT.Description = "Replaces death sound with Roblox oof"
EVENT.id = "oof"

function EVENT:Begin()
    -- Whenever a player dies
    self:AddHook("DoPlayerDeath", function(ply, attacker, dmginfo)
        -- Silence their usual death noise
        dmginfo:SetDamageType(DMG_SLASH)
        -- And play the Roblox oof instead
        sound.Play("oof/oof.wav", ply:GetShootPos(), 90, 100, 1)
    end)
end

Randomat:register(EVENT)