local EVENT = {}

EVENT.Title = "Crowbars Only!"
EVENT.Description = "Can only use, or be damaged by, a buffed crowbar"
EVENT.id = "crowbarsonly"

function EVENT:Begin()
	for _, ent in pairs(ents.GetAll()) do
		if ent.Kind == WEAPON_PISTOL or ent.Kind == WEAPON_HEAVY or ent.Kind == WEAPON_NADE and ent.AutoSpawnable then
			ent:Remove()
		end
	end
	
	Randomat:SilentTriggerEvent("crowbar", self.owner)
	
	self:AddHook("EntityTakeDamage", function(ent, dmginfo)
		if IsValid(ent) and ent:IsPlayer() and !dmginfo:IsDamageType(DMG_CLUB) then
			return true
		end
	end)
	
	for i, ply in pairs(self:GetAlivePlayers()) do
		timer.Simple(0.1, function()
			if ply:GetRole() == ROLE_KILLER then
				ply:Give("weapon_kil_crowbar")
				ply:SelectWeapon("weapon_kil_crowbar")
			else
				ply:SelectWeapon("weapon_zm_improvised")
			end
		end)
	end
end

Randomat:register(EVENT)