local EVENT = {}
EVENT.Title = "Huff this!"
EVENT.Description = "Crouching makes you fart"
EVENT.id = "fart"

EVENT.Categories = {"fun", "moderateimpact"}

local altSoundCvar = CreateConVar("randomat_fart_alt_sound", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether to use the alternate fart sound", 0, 1)

local ravsModel = "models/solidsnakemgs4/solidsnakemgs4.mdl"
local garfieldModel = "models/player/garfield/buff_garfield.mdl"
local ps1RavsModel = "models/vinrax/player/MGS_Solid_Snake.mdl"

if ravsModelExists then
    EVENT.Description = EVENT.Description .. ", everyone is a master of stealth!"
end

function EVENT:Begin()
    local givenPlayermodels = {}

    -- Sets everyone's models
    if util.IsValidModel(ravsModel) then
        local alivePlys = self:GetAlivePlayers(true)
        local ps1RavsModelExists = util.IsValidModel(ps1RavsModel)

        for i, ply in ipairs(alivePlys) do
            local givenModel

            if i == 1 and util.IsValidModel(garfieldModel) then
                -- Set one randomly chosen player as a Garfield model, if installed
                givenModel = garfieldModel
            elseif ps1RavsModelExists and math.random() < 0.5 then
                -- Else set everyone as either the normal or ps1 Solid Snake models
                givenModel = ps1RavsModel
            else
                -- Or just the normal Solid Snake model if only that is installed
                givenModel = ravsModel
            end

            Randomat:ForceSetPlayermodel(ply, givenModel)
            givenPlayermodels[ply] = givenModel
        end
    end

    -- Reset a player's model after they die and respawn
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            if givenPlayermodels[ply] then
                Randomat:ForceSetPlayermodel(ply, givenPlayermodels[ply])
            end
        end)
    end)

    -- Gives everyone fart powers
    self:AddHook("PlayerButtonDown", function(ply, button)
        if button ~= KEY_LCONTROL then return end
        if ply.FartCooldown then return end
        ply.FartCooldown = true

        timer.Simple(2, function()
            ply.FartCooldown = false
        end)

        local snd = "fart/fart.mp3"

        if altSoundCvar:GetBool() then
            snd = "fart/fartalt.mp3"
        end

        ply:EmitSound(snd)
        local pos = ply:GetPos()
        -- Creates a green horizontal poof effect when somebody crouches
        local effectdata = EffectData()
        effectdata:SetOrigin(pos)
        util.Effect("VortDispel", effectdata)
        local entTable = ents.FindInSphere(pos, 200)

        for _, ent in ipairs(entTable) do
            if not IsValid(ent) then continue end
            if ent == ply then continue end
            -- Taken from TTT's discombob grenade, pushes all players and ents away
            local phys_force = 1500
            local push_force = 256
            local tpos = ent:LocalToWorld(ent:OBBCenter())
            local dir = (tpos - pos):GetNormal()
            local phys = ent:GetPhysicsObject()

            if ent:IsPlayer() and (not ent:IsFrozen()) and ((not ent.was_pushed_t) or ent.was_pushed_t ~= CurTime()) then
                -- always need an upwards push to prevent the ground's friction from
                -- stopping nearly all movement
                dir.z = math.abs(dir.z) + 1
                local push = dir * push_force
                -- try to prevent excessive upwards force
                local vel = ent:GetVelocity() + push
                vel.z = math.min(vel.z, push_force)

                -- mess with discomb jumps
                if pusher == ent and (not ttt_allow_jump:GetBool()) then
                    vel = VectorRand() * vel:Length()
                    vel.z = math.abs(vel.z)
                end

                ent:SetVelocity(vel)
                ent.was_pushed_t = CurTime()
            elseif IsValid(phys) then
                phys:ApplyForceCenter(dir * -1 * phys_force)
            end
        end
    end)
end

function EVENT:GetConVars()
    local checkboxes = {}

    for _, v in pairs({"alt_sound"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checkboxes, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return {}, checkboxes
end

Randomat:register(EVENT)