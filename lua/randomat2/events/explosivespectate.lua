local EVENT = {}

EVENT.Title = "Explosive Spectating"
EVENT.Description = "Click while prop-possessing to explode"
EVENT.id = "explosivespectate"

function EVENT:Begin()
	self:AddHook("PlayerButtonDown", function(ply,button)
		if button == MOUSE_LEFT then
			local ent = ply.propspec and ply.propspec.ent
			if IsValid(ent) then
				local explode = ents.Create("env_explosion")
				explode:SetPos(ent:GetPos())
				explode:SetOwner(victim)
				explode:Spawn()
				explode:SetKeyValue("iMagnitude","100")
				explode:SetKeyValue("iRadiusOverride","256")
				explode:Fire("Explode",0,0)
				explode:EmitSound("weapon_AWP.Single",200,200)
				ent:Remove()
			end
		end
	end)
end

Randomat:register(EVENT)