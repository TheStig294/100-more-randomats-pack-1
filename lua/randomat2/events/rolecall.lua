local EVENT = {}

CreateConVar("randomat_rolecall_time", 60, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Time between role announcements")

EVENT.Title = "Role Call"
EVENT.Description = "Announces a random player's role every " .. GetConVar("randomat_rolecall_time"):GetInt() .. " seconds"
EVENT.id = "rolecall"

function EVENT:Begin()
    -- Every set amount of seconds,
    timer.Create("RandomatRoleCallTimer", GetConVar("randomat_rolecall_time"):GetInt(), 0, function()
        -- Pick a random alive player,
        local ply = table.Random(self:GetAlivePlayers())
        -- And announces their role to everyone
        self:SmallNotify(ply:Nick() .. " is " .. self:GetRoleName(ply, true) .. " !")
    end)
end

function EVENT:End()
    -- Stop announcing roles
    timer.Remove("RandomatRoleCallTimer")
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