local EVENT = {}
EVENT.Title = "Bouncy"
EVENT.Description = "Bounce instead of fall damage"
EVENT.id = "bouncy"

CreateConVar("randomat_bouncy_speed_retain", 0.75, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "% of speed retained between bounces", 0, 1)

function EVENT:Begin()
    self:AddHook("GetFallDamage", function(ply, speed)
        ply:SetVelocity(Vector(0, 0, speed * GetConVar("randomat_bouncy_speed_retain"):GetFloat()))

        return 0
    end)

    self:AddHook("EntityTakeDamage", function(ply, dmginfo)
        if IsValid(ply) and ply:IsPlayer() and dmginfo:IsFallDamage() then return true end
    end)
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"speed_retain"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 2
            })
        end
    end

    return sliders
end

Randomat:register(EVENT)