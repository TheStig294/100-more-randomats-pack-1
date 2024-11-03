local EVENT = {}

local zonesCvar = CreateConVar("randomat_storm_zones", 4, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The number of zones until the storm covers the map", 1, 10)

local waitTimeCvar = CreateConVar("randomat_storm_wait_time", 30, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Seconds after the next zone is announced before the storm moves", 0, 120)

local moveTimeCvar = CreateConVar("randomat_storm_move_time", 30, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Seconds it takes for the storm to move", 0, 120)

EVENT.Title = "The Storm"
EVENT.Description = "Stay outside the storm, or else you take damage!"
EVENT.id = "storm"

EVENT.Categories = {"largeimpact"}

function EVENT:Begin()
    Randomat:BattleRoyaleStorm(zonesCvar:GetInt(), waitTimeCvar:GetInt(), moveTimeCvar:GetInt())
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"zones", "wait_time", "move_time"}) do
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