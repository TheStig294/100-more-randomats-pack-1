local EVENT = {}

EVENT.Title = "Unconventional Healing"
EVENT.Description = "Fire, explosion and fall damage heals!"
EVENT.id = "unconventional"

function EVENT:Begin()
	self:AddHook("EntityTakeDamage", function(ent, dmginfo)
		if IsValid(ent) and ent:IsPlayer() and (dmginfo:IsDamageType(DMG_BURN) or dmginfo:IsDamageType(DMG_FALL) or dmginfo:IsDamageType(DMG_BLAST)) then
			ent:SetHealth(math.min(ent:Health() + dmginfo:GetDamage(),ent:GetMaxHealth()))
			return true
		end
	end)
end

Randomat:register(EVENT)