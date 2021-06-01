local EVENT = {}

EVENT.Title = "Pistols at dawn"
EVENT.Description = "Last 2 non-jesters alive have a one-shot pistol showdown"
EVENT.id = "pistols"

function EVENT:Begin()
	pistolsTriggerOnce = false
	pistolsAtDawnRandomat = false
	
	self:AddHook("Think", function()
		pistolsAlivePlayers = #self:GetAlivePlayers()
		for i, ply in pairs(self:GetAlivePlayers()) do
			if ply:GetRole() == ROLE_SWAPPER or ply:GetRole() == ROLE_JESTER then
				pistolsAlivePlayers = pistolsAlivePlayers - 1
			end
		end
		
		if pistolsAlivePlayers == 2 then
			if pistolsTriggerOnce == false then
				for _, ent in pairs(ents.GetAll()) do
					if ent.Kind == WEAPON_PISTOL or ent.Kind == WEAPON_HEAVY or ent.Kind == WEAPON_NADE and ent.AutoSpawnable then
						ent:Remove()
					end
				end
				
				timer.Simple(1, function()
					self:SmallNotify("Pistols at dawn!")
					Randomat:SilentTriggerEvent("wallhack", self.owner)
				end)
			end
			
			timer.Simple(2, function()
				for i, ply in pairs(self:GetAlivePlayers()) do
					ply:SetCredits(0)
					if ply:GetActiveWeapon():GetClass() == "weapon_ttt_pistol_randomat" then
						ply:SetAmmo(69, "Pistol")
					end
					if (ply:GetRole() ~= ROLE_SWAPPER) and (ply:GetRole() ~= ROLE_JESTER) and ply:GetActiveWeapon():GetClass() ~= "weapon_ttt_pistol_randomat" then
						ply:StripWeapons()
						ply:SetCredits(0)
						ply:Give("weapon_ttt_pistol_randomat")
						ply:SelectWeapon("weapon_ttt_pistol_randomat")
					end
				end
			end)
			
			pistolsTriggerOnce = true
		end
	end)
end

Randomat:register(EVENT)