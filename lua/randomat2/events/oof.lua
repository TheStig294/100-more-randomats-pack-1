local EVENT = {}

EVENT.Title = "Oof"
EVENT.Description = "Replaces death sound with Roblox oof"
EVENT.id = "oof"

function EVENT:Begin()
	hook.Add("DoPlayerDeath", "OofDeathSound", function(ply, attacker, dmginfo)
		dmginfo:SetDamageType(DMG_SLASH)
		sound.Play("oof/oof.wav", ply:GetShootPos(), 90, 100, 1)
	end)
end

function EVENT:End()
	hook.Remove("DoPlayerDeath", "OofDeathSound")
end

Randomat:register(EVENT)