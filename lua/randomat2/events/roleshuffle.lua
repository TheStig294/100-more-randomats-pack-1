local EVENT = {}

CreateConVar("randomat_roleshuffle_time", 60, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "How long in seconds until roles are shuffled", 5, 300)

EVENT.Title = "Role shuffle!"
EVENT.Description = "Everyone changes role in " .. GetConVar("randomat_roleshuffle_time"):GetInt() .. " seconds"
EVENT.id = "roleshuffle"

function EVENT:Begin()
    -- Create a full timer that doesn't repeat, so it can be stopped if the round ends before it triggers
    timer.Create("RoleShuffleRandomatTimer", GetConVar("randomat_roleshuffle_time"):GetInt(), 1, function()
        -- Notify everyone when the role shuffle happens
        self:SmallNotify("Role shuffle!")
        -- Have TTT select new roles for everyone
        SelectRoles()

        for _, ply in pairs(self:GetPlayers()) do
            -- Remove everyone's role weapons and give them their new ones, if their new role has one
            self:StripRoleWeapons(ply)
            GAMEMODE:PlayerLoadout(ply)
            -- Set everyone's roles through the randomat function again so the new roles show up in the end of round scoreboard
            local role = ply:GetRole()
            Randomat:SetRole(ply, role)
        end

        -- Needed after any role change for whatever reason...
        SendFullStateUpdate()
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