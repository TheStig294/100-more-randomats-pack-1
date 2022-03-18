local EVENT = {}

CreateConVar("randomat_speedjumphealth_multiplier", 50, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Percent multiplier to stats", 1, 200)

local initialMultiplier = GetConVar("randomat_speedjumphealth_multiplier"):GetInt()
EVENT.Title = GetConVar("randomat_speedjumphealth_multiplier"):GetInt() .. "% More Speed, Jump Height and Health for everyone!"
EVENT.ExtDescription = "Everyone can move " .. initialMultiplier .. "% faster, jump " .. initialMultiplier .. "% higher, and has " .. initialMultiplier .. "% more health"
EVENT.id = "speedjumphealth"

EVENT.Categories = {"smallimpact"}

util.AddNetworkString("SpeedJumpHealthBegin")
util.AddNetworkString("SpeedJumpHealthEnd")

function EVENT:Begin()
    local multiplier = 1 + GetConVar("randomat_speedjumphealth_multiplier"):GetInt() / 100

    for i, ply in pairs(self:GetAlivePlayers()) do
        ply:SetHealth(ply:Health() * multiplier)
        ply:SetMaxHealth(ply:GetMaxHealth() * multiplier)
        ply:SetJumpPower(ply:GetJumpPower() * multiplier)
        ply:SetWalkSpeed(ply:GetWalkSpeed() * multiplier)
    end
end

function EVENT:End()
    for _, ply in pairs(self:GetPlayers()) do
        ply:SetJumpPower(160)
        ply:SetWalkSpeed(200)
    end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"multiplier"}) do
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