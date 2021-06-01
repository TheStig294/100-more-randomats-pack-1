local EVENT = {}

EVENT.Title = "You do know how to use this right?"
EVENT.Description = "DNA scanners for all!"
EVENT.id = "dna"

function EVENT:Begin()
	for i, ply in pairs(self:GetAlivePlayers()) do
		timer.Simple(0.1, function()
			ply:Give("weapon_ttt_wtester")
		end)
	end
end

Randomat:register(EVENT)
