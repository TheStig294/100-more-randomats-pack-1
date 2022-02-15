local EVENT = {}

CreateConVar("randomat_roleshuffle_time", 60, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "How long in seconds until roles are shuffled", 5, 300)

EVENT.Title = "Role shuffle!"
EVENT.Description = "Everyone swaps roles in " .. GetConVar("randomat_roleshuffle_time"):GetInt() .. " seconds!"
EVENT.id = "roleshuffle"

function EVENT:Begin()
    self.Description = "Everyone swaps roles in " .. GetConVar("randomat_roleshuffle_time"):GetInt() .. " seconds!"

    -- Create a full timer that doesn't repeat, so it can be stopped if the round ends before it triggers
    timer.Create("RoleShuffleRandomatTimer", GetConVar("randomat_roleshuffle_time"):GetInt(), 1, function()
        local roles = {}

        -- Get everyone's current roles, randomly
        for i, ply in ipairs(self:GetAlivePlayers(true)) do
            table.insert(roles, ply:GetRole())
        end

        -- Set everyone's roles
        for i, ply in ipairs(self:GetAlivePlayers()) do
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, roles[i])
        end

        SendFullStateUpdate()
        -- Notify everyone when the role shuffle happens
        self:SmallNotify("Role shuffle!")
    end)
end

function EVENT:End()
    -- Stop the timer if the round ends before the role shuffle triggers
    timer.Remove("RoleShuffleRandomatTimer")
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