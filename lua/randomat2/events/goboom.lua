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
    -- Only run this if there are actual props
    if table.Count(ents.FindByClass("prop_physics*")) == 0 and table.Count(ents.FindByClass("prop_dynamic")) == 0 then return false end
end

Randomat:register(EVENT)