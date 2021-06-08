CreateConVar("randomat_pinball_mul", 10, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The velocity multiplyer", 1, 100)

local EVENT = {}
EVENT.Title = "Pinball People"
EVENT.Description = "When two players collide, they will be sent flying in opposite directions."
EVENT.id = "pinball"

function EVENT:Begin()
    -- Allow us to use the following hook on all players
    for i, ply in pairs(self:GetPlayers()) do
        ply:SetCustomCollisionCheck(true)
    end

    -- When two entities collide
    self:AddHook("ShouldCollide", function(ply, ply2)
        -- And they are both players,
        if (ply and ply2) and (ply:IsPlayer() and ply2:IsPlayer()) then
            -- And they are close to each other
            if ply:GetPos():DistToSqr(ply2:GetPos()) < 1300 then
                -- Send them flying away from each other
                velVector = Vector(ply:GetPos().x - ply2:GetPos().x, ply:GetPos().y - ply2:GetPos().y, ply:GetPos().z - ply2:GetPos().z)
                ply:SetVelocity(velVector * GetConVar("randomat_pinball_mul"):GetInt() * 10)
            end
        end
    end)
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"mul"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v, -- The command extension (e.g. everything after "randomat_example_")
                dsc = convar:GetHelpText(), -- The description of the ConVar
                min = convar:GetMin(), -- The minimum value for this slider-based ConVar
                max = convar:GetMax(), -- The maximum value for this slider-based ConVar
                dcm = 0 -- The number of decimal points to support in this slider-based ConVar
                
            })
        end
    end

    local checks = {}

    for _, v in pairs({}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v, -- The command extension (e.g. everything after "randomat_example_")
                dsc = convar:GetHelpText() -- The description of the ConVar
                
            })
        end
    end

    local textboxes = {}

    for _, v in pairs({}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(textboxes, {
                cmd = v, -- The command extension (e.g. everything after "randomat_example_")
                dsc = convar:GetHelpText() -- The description of the ConVar
                
            })
        end
    end

    return sliders, checks, textboxes
end

Randomat:register(EVENT)