local EVENT = {}

EVENT.Title = "I'm Mary Poppins Y'all!"
EVENT.Description = "Float/teleport up and down walls, automatically walk over most obstacles"
EVENT.id = "marypoppins"

function EVENT:Begin()
	for i, ply in pairs(self:GetAlivePlayers()) do
		timer.Simple(0.1, function()
			ply:SetStepSize(1000)
		end)
	end
end

function EVENT:End()
	for i, ply in pairs(player.GetAll()) do
		timer.Simple(0.1, function()
			ply:SetStepSize(20)
		end)
	end
end

Randomat:register(EVENT)
