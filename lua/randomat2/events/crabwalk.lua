local EVENT = {}
EVENT.Title = "Crab Walk"
EVENT.Description = "You can only walk sideways"
EVENT.id = "crabwalk"
EVENT.Type = EVENT_TYPE_JUMPING

EVENT.Categories = {"largeimpact"}

local orginalJumps = 1
local crabsTriggered = false

function EVENT:Begin()
    crabsTriggered = true

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
    if crabsTriggered and ConVarExists("multijump_default_jumps") then
        GetConVar("multijump_default_jumps"):SetInt(orginalJumps)
        crabsTriggered = false
    end
end

Randomat:register(EVENT)