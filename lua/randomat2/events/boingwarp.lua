local EVENT = {}

EVENT.Title = "Boing Warp"
EVENT.Description = "Stronger jumping over time"
EVENT.id = "boingwarp"

function EVENT:Begin()
  roundEndTime = GetGlobalFloat("ttt_round_end")
	self:AddHook("Think", function()
		for i, ply in pairs(self:GetAlivePlayers()) do
			ply:SetJumpPower(800 - 2.5*(roundEndTime - CurTime()))
		end
	end)
end

function EVENT:End()
	self:CleanUpHooks()

	for _, ply in pairs(player.GetAll()) do
		ply:SetJumpPower(200)
	end
end

Randomat:register(EVENT)