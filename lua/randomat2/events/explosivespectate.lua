local EVENT = {}
EVENT.Title = "Explosive Spectating"
EVENT.Description = "Left-click while prop-possessing to explode!"
EVENT.id = "explosivespectate"

EVENT.Categories = {"spectator", "biased_innocent", "biased", "moderateimpact"}

function EVENT:Begin()
    -- Whenever someone left-clicks,
    self:AddHook("PlayerButtonDown", function(ply, button)
        if button == MOUSE_LEFT then
            -- If they are spectating a prop
            local ent = ply.propspec and ply.propspec.ent

            if IsValid(ent) then
                -- Then create an explosion where the prop is
                local explode = ents.Create("env_explosion")
                explode:SetPos(ent:GetPos())
                explode:SetOwner(victim)
                explode:Spawn()
                explode:SetKeyValue("iMagnitude", "100")
                explode:SetKeyValue("iRadiusOverride", "256")
                explode:Fire("Explode", 0, 0)
                explode:EmitSound("weapon_AWP.Single", 200, 200)
                -- And remove the prop
                ent:Remove()
            end
        end
    end)

    self:AddHook("PostPlayerDeath", function(ply)
        SpectatorRandomatAlert(ply, EVENT)
    end)
end

function EVENT:Condition()
    return MapHasProps()
end

Randomat:register(EVENT)