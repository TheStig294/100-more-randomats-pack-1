local EVENT = {}
EVENT.Title = "My planet needs me!"
EVENT.Description = "Ragdolls move/fly around"
EVENT.id = "planet"

EVENT.Categories = {"fun", "deathtrigger", "moderateimpact"}

local ragTimers = {}

function EVENT:Begin()
    self:AddHook("TTTOnCorpseCreated", function(rag)
        if not IsValid(rag) then return end
        local timerName = rag:EntIndex() .. "PlanetRandomat"
        table.insert(ragTimers, timerName)
        local physObj = rag:GetPhysicsObject()
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

Randomat:register(EVENT)