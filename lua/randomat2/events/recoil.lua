CreateConVar("randomat_recoil_max", 15, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum Magnitude a gun can change someone's velocity by.", 1, 100)

CreateConVar("randomat_recoil_mul", 6, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Recoil Multiplier", 1, 100)

local EVENT = {}
EVENT.Title = "Realistic Recoil"
EVENT.Description = "Shooting strongly pushes you backwards"
EVENT.id = "recoil"

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"max", "mul"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v, -- The command extension (e.g. everything after "randomat_example_")
                dsc = convar:GetHelpText(), -- The description of the ConVar
                min = convar:GetMin(), -- The minimum value for this slider-based ConVar
                max = convar:GetMax(), -- The maximum value for this slider-based ConVar
                dcm = 0 -- The number of decimal points to support in this slider-based ConVar
                
            })
        end
    end

    local checks = {}

    for _, v in pairs({}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v, -- The command extension (e.g. everything after "randomat_example_")
                dsc = convar:GetHelpText() -- The description of the ConVar
                
            })
        end
    end

    local textboxes = {}

    for _, v in pairs({}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(textboxes, {
                cmd = v, -- The command extension (e.g. everything after "randomat_example_")
                dsc = convar:GetHelpText() -- The description of the ConVar
                
            })
        end
    end

    return sliders, checks, textboxes
end

function EVENT:Begin()
    hook.Add("EntityFireBullets", "Randomatrecoil", function(ent, data)
        currentVelocity = ent:GetVelocity()
        vec = Vector(ent:EyePos().x - ent:GetEyeTrace().HitPos.x, ent:EyePos().y - ent:GetEyeTrace().HitPos.y, ent:EyePos().z - ent:GetEyeTrace().HitPos.z)
        vec:Normalize()
        newVelocity = (vec * math.exp(tonumber(math.pow(data.Damage / 2, 1 / 2))) * GetConVar("randomat_recoil_mul"):GetFloat() * data.Num)

        if newVelocity:Length() > GetConVar("randomat_recoil_max"):GetInt() * 10000 then
            newVelocity = (newVelocity / newVelocity:Length()) * GetConVar("randomat_recoil_max"):GetInt() * 10000
        end

        if ent:IsOnGround() then
            ent:SetPos(ent:GetPos() + Vector(0, 0, 1))
        end

        ent:SetVelocity(newVelocity)
    end)
end

function EVENT:End()
    hook.Remove("EntityFireBullets", "Randomatrecoil")
end

Randomat:register(EVENT)