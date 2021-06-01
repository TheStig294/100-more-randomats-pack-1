local EVENT = {}
EVENT.Title = "People are Crabs"
EVENT.Description = "You can only walk sideways"
EVENT.id = "peoplearecrabs"

function EVENT:Begin()
    hook.Add("SetupMove", "PeopleAreCrabs", function(ply, mv, cmd)
        if ply:IsTerror() then
            mv:SetForwardSpeed(0)
        end
    end)
end

function EVENT:End()
    hook.Remove("SetupMove", "PeopleAreCrabs")
end

Randomat:register(EVENT)