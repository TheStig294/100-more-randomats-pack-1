local EVENT = {}

CreateConVar("randomat_bouncy_speed_retain", 0.75, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "% of speed retained between bounces", 0, 1)

EVENT.Title = "Bouncy"
EVENT.Description = "Bounce instead of taking fall damage"
EVENT.id = "bouncy"

EVENT.Categories = {"smallimpact"}

function EVENT:Begin()
    --On taking damage from falling,
    self:AddHook("GetFallDamage", function(ply, speed)
        --Set push the player upwards, retaining a percentage of their original speed
        ply:SetVelocity(Vector(0, 0, speed * GetConVar("randomat_bouncy_speed_retain"):GetFloat()))

        --Set the damage from falling to 0, but doesn't seem to work so...
        return 0
    end)

    -- ...also completely negate ALL sources of fall damage
    self:AddHook("EntityTakeDamage", function(ply, dmginfo)
        if IsValid(ply) and ply:IsPlayer() and dmginfo:IsFallDamage() then return true end
    end)
    --Players will stop bouncing when they fall a short enough distance that they wouldn't take fall damage
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