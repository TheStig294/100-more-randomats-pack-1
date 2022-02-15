local EVENT = {}
EVENT.Title = "Nobody"
EVENT.Description = "Anyone killed doesn't leave behind a body"
EVENT.id = "nobody"

function EVENT:Begin()
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

Randomat:register(EVENT)