local EVENT = {}

CreateConVar("randomat_boing_jump_height", 220, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Additional jump height", 0, 600)

EVENT.Title = "Boing"
EVENT.Description = "Everyone can jump much higher"
EVENT.id = "boing"

EVENT.Categories = {"smallimpact"}

local function SetJumpHeight(ply)
    ply:SetJumpPower(ply:GetJumpPower() + GetConVar("randomat_boing_jump_height"):GetInt())
end

function EVENT:Begin()
    -- Adds the set jump power to all player's jump power
    for _, ply in pairs(self:GetAlivePlayers()) do
        SetJumpHeight(ply)
    end

    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            SetJumpHeight(ply)
        end)
    end)
end

function EVENT:End()
    -- Sets everyone's jump power back to TTT's default, 160
    for _, ply in pairs(self:GetPlayers()) do
        ply:SetJumpPower(160)
    end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"jump_height"}) do
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