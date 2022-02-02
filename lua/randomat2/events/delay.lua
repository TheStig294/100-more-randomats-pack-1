local EVENT = {}

CreateConVar("randomat_delay_time", 60, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Seconds before randomat is triggered", 5, 180)

EVENT.Title = "Delayed Start"
EVENT.Description = "Triggers a randomat after " .. GetConVar("randomat_delay_time"):GetInt() .. " seconds"
EVENT.id = "delay"

function EVENT:Begin()
    self.Description = "Triggers a randomat after " .. GetConVar("randomat_delay_time"):GetInt() .. " seconds"

    timer.Simple(GetConVar("randomat_delay_time"):GetInt(), function()
        self:SmallNotify("And now for the 'Delayed Start' randomat...")

        timer.Simple(5, function()
            Randomat:TriggerRandomEvent(self.owner)
        end)
    end)
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"time"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    return sliders
end

Randomat:register(EVENT)