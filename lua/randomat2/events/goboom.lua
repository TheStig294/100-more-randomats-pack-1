local EVENT = {}
EVENT.Title = "Outcome? Prop go boom."
EVENT.Description = "Props explode when destroyed"
EVENT.id = "goboom"

function EVENT:Begin()
    self:AddHook("PropBreak", function(ply, prop)
        local explosion = ents.Create("env_explosion")
        explosion:SetPos(prop:GetPos())
        explosion:Spawn() -- Spawn the explosion
        explosion:SetKeyValue("iMagnitude", "200")
        explosion:Fire("Explode", 0, 0)
    end)
end

function EVENT:Condition()
    return MapHasProps()
end

Randomat:register(EVENT)