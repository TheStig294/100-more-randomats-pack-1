local EVENT = {}
CreateConVar("randomat_livecount_timer", 30, FCVAR_ARCHIVE, "Time between live counts", 5, 90)
EVENT.Title = "Live Count"
EVENT.Description = "Counts no. of alive players every " .. GetConVar("randomat_livecount_timer"):GetInt() .. " seconds"
EVENT.id = "livecount"

EVENT.Categories = {"biased_innocent", "biased", "smallimpact"}

function EVENT:Begin()
    self.Description = "Counts no. of alive players every " .. GetConVar("randomat_livecount_timer"):GetInt() .. " seconds"

    -- Trigger every amount of seconds set by the convar
    timer.Create("RandomatLiveCountTimer", GetConVar("randomat_livecount_timer"):GetInt(), 0, function()
        self:SmallNotify("There are " .. #self:GetAlivePlayers() .. " people still alive")
    end)
end

function EVENT:End()
    -- Stop triggering at the end of the round
    timer.Remove("RandomatLiveCountTimer")
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"timer"}) do
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