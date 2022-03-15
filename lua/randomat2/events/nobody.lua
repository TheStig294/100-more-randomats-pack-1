local EVENT = {}
EVENT.Title = "Nobody"
EVENT.Description = "Anyone killed doesn't leave behind a body"
EVENT.id = "nobody"

EVENT.Categories = {"deathtrigger", "smallimpact", "biased_traitor", "biased"}

function EVENT:Begin()
    for _, ply in ipairs(self:GetAlivePlayers()) do
        if IsBodyDependentRole(ply) then
            self:StripRoleWeapons(ply)
            SetToBasicRole(ply)
        end
    end

    SendFullStateUpdate()
    hook.Run("UpdatePlayerLoadouts")

    self:AddHook("TTTOnCorpseCreated", function(corpse)
        timer.Simple(0.1, function()
            local pos = corpse:GetPos()
            corpse:Remove()
            -- Creates a "poof" smoke cloud when a body disappears
            local effectdata = EffectData()
            effectdata:SetOrigin(pos)
            util.Effect("AntlionGib", effectdata)
        end)
    end)
end

-- Checking if someone is a body dependent role and if it isn't at the start of the round, prevent the event from running
function EVENT:Condition()
    local bodyDependentRoleExists = false

    for _, ply in ipairs(self:GetAlivePlayers()) do
        if IsBodyDependentRole(ply) then
            bodyDependentRoleExists = true
            break
        end
    end

    return Randomat:GetRoundCompletePercent() < 5 or not bodyDependentRoleExists
end

Randomat:register(EVENT)