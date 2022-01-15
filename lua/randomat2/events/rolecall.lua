local EVENT = {}

CreateConVar("randomat_rolecall_time", 60, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Time between role announcements")

EVENT.Title = "Role Call"
EVENT.Description = "Announces a random player's role every " .. GetConVar("randomat_rolecall_time"):GetInt() .. " seconds"
EVENT.id = "rolecall"

function EVENT:Begin()
    self.Description = "Announces a random player's role every " .. GetConVar("randomat_rolecall_time"):GetInt() .. " seconds"

    timer.Create("RandomatRoleCallTimer", GetConVar("randomat_rolecall_time"):GetInt(), 0, function()
        for i, ply in ipairs(self:GetAlivePlayers(true)) do
            if Randomat:IsGoodDetectiveLike(ply) == false and ply:GetNWBool("RoleCallRandomatRevealed") == false then
                self:SmallNotify(ply:Nick() .. " is " .. string.lower(self:GetRoleName(ply, false) .. "!"))
                ply:SetNWBool("RoleCallRandomatRevealed", true)
                break
            end
        end
    end)
end

function EVENT:End()
    timer.Remove("RandomatRoleCallTimer")

    for i, ply in ipairs(player.GetAll()) do
        ply:SetNWBool("RoleCallRandomatRevealed", false)
    end
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