local EVENT = {}

CreateConVar("randomat_roleshuffle_time", 60, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "How long in seconds until roles are shuffled", 5, 300)

EVENT.Title = "Role shuffle!"
EVENT.Description = "Everyone changes role in " .. GetConVar("randomat_roleshuffle_time"):GetInt() .. " seconds"
EVENT.id = "roleshuffle"

function EVENT:Begin()
	timer.Create("RoleShuffleRandomatTimer", 1, GetConVar("randomat_roleshuffle_time"):GetInt(), function()
        if timer.RepsLeft("RoleShuffleRandomatTimer") == 0 then
            self:SmallNotify("Role shuffle!")
            SelectRoles()
            SendFullStateUpdate()
            for _, ply in pairs(self:GetPlayers()) do
                self:StripRoleWeapons(ply)
                GAMEMODE:PlayerLoadout(ply)
            end
        end
	end)
end

function EVENT:End()
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