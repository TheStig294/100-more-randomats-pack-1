local EVENT = {}
EVENT.Title = "My planet needs me!"
EVENT.Description = "Ragdolls move/fly around"
EVENT.id = "planet"

EVENT.Categories = {"fun", "deathtrigger", "moderateimpact"}

local ragTimers = {}

function EVENT:Begin()
    local new_traitors = {}

    for _, ply in ipairs(self:GetAlivePlayers()) do
        if Randomat:IsBodyDependentRole(ply) then
            self:StripRoleWeapons(ply)
            local isTraitor = Randomat:SetToBasicRole(ply, "Traitor", true)

            if isTraitor then
                table.insert(new_traitors, ply)
            end
        end
    end

    -- Send message to the traitor team if new traitors joined
    self:NotifyTeamChange(new_traitors, ROLE_TEAM_TRAITOR)
    SendFullStateUpdate()

    self:AddHook("TTTOnCorpseCreated", function(rag)
        if not IsValid(rag) then return end
        local timerName = rag:EntIndex() .. "PlanetRandomat"
        table.insert(ragTimers, timerName)
        local physObj = rag:GetPhysicsObject()
        if not IsValid(physObj) then return end
        physObj:SetInertia(Vector(1, 1, 1))
        physObj:SetMass(0)
        physObj:EnableGravity(false)
        local x
        local y
        local z

        -- Continually pushes ragdolls around
        timer.Create(timerName, 0.01, 0, function()
            if physObj:IsValid() then
                physObj:SetAngles(physObj:RotateAroundAxis(Vector(0, 0, 100), 1))
                local randomNum = math.random()

                if randomNum < 1 / 7 then
                    x = -50
                    y = -50
                    z = 1000
                elseif randomNum < 2 / 7 then
                    x = 0
                    y = -50
                    z = 1000
                elseif randomNum < 3 / 7 then
                    x = -50
                    y = 0
                    z = 1000
                elseif randomNum < 4 / 7 then
                    x = 0
                    y = 0
                    z = 0
                elseif randomNum < 5 / 7 then
                    x = 50
                    y = 0
                    z = 0
                elseif randomNum < 6 / 7 then
                    x = 0
                    y = 50
                    z = 0
                else
                    x = 50
                    y = 50
                    z = 0
                end

                physObj:SetVelocity(Vector(x, y, z))
            else
                timer.Remove(timerName)

                return
            end
        end)
    end)
end

function EVENT:End()
    for _, timerName in ipairs(ragTimers) do
        timer.Remove(timerName)
    end

    table.Empty(ragTimers)
end

-- Checking if someone is a body dependent role and if it isn't at the start of the round, prevent the event from running
function EVENT:Condition()
    local bodyDependentRoleExists = false

    for _, ply in ipairs(self:GetAlivePlayers()) do
        if Randomat:IsBodyDependentRole(ply) then
            bodyDependentRoleExists = true
            break
        end
    end

    return Randomat:GetRoundCompletePercent() < 5 or not bodyDependentRoleExists
end

Randomat:register(EVENT)