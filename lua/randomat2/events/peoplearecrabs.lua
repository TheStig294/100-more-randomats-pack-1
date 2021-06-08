local EVENT = {}
EVENT.Title = "People are Crabs"
EVENT.Description = "You can only walk sideways"
EVENT.id = "peoplearecrabs"
local orginalJumps = 1

function EVENT:Begin()
    -- Prevent people from walking forwards or backwards
    self:AddHook("SetupMove", function(ply, mv, cmd)
        if ply:IsTerror() then
            mv:SetForwardSpeed(0)
        end
    end)

    -- Prevent people from multi-jumping if a mod that adds it is installed
    if ConVarExists("multijump_default_jumps") then
        orginalJumps = GetConVar("multijump_default_jumps"):GetInt()
        GetConVar("multijump_default_jumps"):SetInt(0)
    end
end

function EVENT:End()
    -- Re-enable multi-jumping
    if ConVarExists("multijump_default_jumps") then
        GetConVar("multijump_default_jumps"):SetInt(orginalJumps)
    end
end

Randomat:register(EVENT)