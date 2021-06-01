AddCSLuaFile()

local EVENT = {}

CreateConVar("randomat_rolecall_time", 60, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Time between role announcements")

EVENT.Title = "Role Call"
EVENT.Description = "Announces a random player's role every ".. GetConVar("randomat_rolecall_time"):GetInt() .." seconds"
EVENT.id = "rolecall"

function EVENT:Begin()

	timer.Create("RandomatRoleCallTimer", GetConVar("randomat_rolecall_time"):GetInt(), 0, function()
		local plys = self:GetAlivePlayers()
		ply = table.Random(plys)
		
		self:SmallNotify(ply:Nick().." is "..self:GetRoleName(ply, true).." !")
	end)

end

function EVENT:End()
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