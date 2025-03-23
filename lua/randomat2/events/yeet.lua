local EVENT = {}
EVENT.Title = "YEET"
EVENT.Description = "Get 'yeeted' when you take damage"
EVENT.id = "yeet"

EVENT.Categories = {"fun", "largeimpact"}

CreateConVar("randomat_yeet_cooldown", "10", FCVAR_NONE, "Cooldown between 'yeets', in seconds", 0, 120)
CreateConVar("randomat_yeet_force", "1000", FCVAR_NONE, "'Yeet' force", 1, 10000)

function EVENT:Begin()
    self:AddHook("PostEntityTakeDamage", function(ent, dmg, took)
        if not took or not IsPlayer(ent) or ent.YeetRandomatCooldown then return end
        local phys = ent:GetPhysicsObject()
        if not phys:IsValid() then return end
        ent:SetPos(ent:GetPos() + Vector(0, 0, 20))
        ent:SetVelocity(Vector(0, 0, GetConVar("randomat_yeet_force"):GetInt()))
        ent:EmitSound("yeet/yeet.mp3")
        ent.YeetRandomatCooldown = true

        timer.Simple(GetConVar("randomat_yeet_cooldown"):GetInt(), function()
            ent.YeetRandomatCooldown = false
        end)
    end)
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"cooldown", "force"}) do
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