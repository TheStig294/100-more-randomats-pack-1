local EVENT = {}

EVENT.Title = "Random jump height for everyone!"
EVENT.Description = "Randomly sets how high you can jump"
EVENT.id = "randomjump"

CreateConVar("randomat_randomjump_max_multiplier", 3.0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Max multiplier to jump height", 0, 8)

function EVENT:Begin()
	for k, ply in pairs(player.GetAll()) do
		math.randomseed(os.time() + k)
		ply:SetJumpPower(ply:GetJumpPower()*math.random() * GetConVar("randomat_randomjump_max_multiplier"):GetFloat())
	end
end

function EVENT:End()
	for k, ply in pairs(player.GetAll()) do
		ply:SetJumpPower(200)
	end
end

function EVENT:GetConVars()
    local sliders = {}
    for _, v in pairs({"max_multiplier"}) do
        local name = "randomat_" .. self.id .. "_" .. v
        if ConVarExists(name) then
            local convar = GetConVar(name)
            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 1
            })
        end
    end
    return sliders
end

Randomat:register(EVENT)