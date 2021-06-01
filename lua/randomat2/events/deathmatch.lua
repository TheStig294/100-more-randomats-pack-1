local EVENT = {}

EVENT.Title = "Team Deathmatch"
EVENT.Description = "1/2 detectives, 1/2 traitors"
EVENT.id = "deathmatch"

function EVENT:Begin()
	for i, ply in pairs(self:GetAlivePlayers(true)) do
		if (i % 2) == 0 then
			self:StripRoleWeapons(ply)
			Randomat:SetRole(ply, ROLE_DETECTIVE)
		else
			self:StripRoleWeapons(ply)
			Randomat:SetRole(ply, ROLE_TRAITOR)
		end
	end
	SendFullStateUpdate()
end

Randomat:register(EVENT)
