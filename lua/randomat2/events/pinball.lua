CreateConVar("randomat_pinball_mul", 10, {FCVAR_NOTIFY, FCVAR_ARCHIVE} , "The velocity multiplyer", 1, 100)


local EVENT = {}
EVENT.Title = "Pinball People"
EVENT.Description = "When two players collide, they will be sent flying in opposite directions."
EVENT.id = "pinball"

function EVENT:GetConVars()

    local sliders = {}
    for _, v in pairs({"mul"}) do
        local name = "randomat_" .. self.id .. "_" .. v
        if ConVarExists(name) then
            local convar = GetConVar(name)
            table.insert(sliders, {
                cmd = v,                    -- The command extension (e.g. everything after "randomat_example_")
                dsc = convar:GetHelpText(), -- The description of the ConVar
                min = convar:GetMin(),      -- The minimum value for this slider-based ConVar
                max = convar:GetMax(),      -- The maximum value for this slider-based ConVar
                dcm = 0                     -- The number of decimal points to support in this slider-based ConVar
            })
        end
    end


    local checks = {}
    for _, v in pairs({}) do
        local name = "randomat_" .. self.id .. "_" .. v
        if ConVarExists(name) then
            local convar = GetConVar(name)
            table.insert(checks, {
                cmd = v,                    -- The command extension (e.g. everything after "randomat_example_")
                dsc = convar:GetHelpText()  -- The description of the ConVar
            })
        end
    end


    local textboxes = {}
    for _, v in pairs({}) do
        local name = "randomat_" .. self.id .. "_" .. v
        if ConVarExists(name) then
            local convar = GetConVar(name)
            table.insert(textboxes, {
                cmd = v,                    -- The command extension (e.g. everything after "randomat_example_")
                dsc = convar:GetHelpText()  -- The description of the ConVar
            })
        end
    end

    return sliders, checks, textboxes
end



function EVENT:Begin()

    -- Allow us to see collision
    for i, ply in pairs(player.GetAll()) do
        ply:SetCustomCollisionCheck(true)
    end

    hook.Add( "ShouldCollide", "RandomatPinball", function( ply, ply2 )

        if (ply and ply2) and (ply:IsPlayer() and ply2:IsPlayer()) then
            if ply:GetPos():DistToSqr(ply2:GetPos()) < 1300 then

                velVector = Vector(ply:GetPos().x - ply2:GetPos().x, ply:GetPos().y - ply2:GetPos().y, ply:GetPos().z - ply2:GetPos().z)
                ply:SetVelocity(velVector*GetConVar("randomat_pinball_mul"):GetInt() * 10)

            end
        end

    end)
end




function EVENT:End()
    hook.Remove( "ShouldCollide", "RandomatPinball")
end

Randomat:register(EVENT)