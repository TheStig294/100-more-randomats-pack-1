local EVENT = {}
EVENT.Title = "Boing Warp"
EVENT.Description = "Stronger jumping over time"
EVENT.id = "boingwarp"

EVENT.Categories = {"smallimpact"}

function EVENT:Begin()
    --Grab the time the round is set to end
    local roundEndTime = GetGlobalFloat("ttt_round_end")

    self:AddHook("Think", function()
        for i, ply in pairs(self:GetAlivePlayers()) do
            --Continually compares the current system time to the round end time, in order to increase every player's jump height as the round progresses
            ply:SetJumpPower(800 - 2.5 * (roundEndTime - CurTime()))
        end
    end)
end

function EVENT:End()
    --Reset everyone's jump height to the default
    for _, ply in pairs(self:GetPlayers()) do
        ply:SetJumpPower(160)
    end
end

Randomat:register(EVENT)