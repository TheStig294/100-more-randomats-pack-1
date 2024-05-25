local EVENT = {}

CreateConVar("randomat_recoil2_max", 15, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Maximum Magnitude a gun can change someone's velocity by.", 1, 100)

CreateConVar("randomat_recoil2_mul", 6, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Recoil Multiplier", 1, 100)

EVENT.Title = "Unrealistic Recoil"
EVENT.Description = "Shooting pushes you forwards"
EVENT.id = "recoil2"

EVENT.Categories = {"smallimpact"}

function EVENT:Begin()
    -- Whenever an entity fires a bullet,
    self:AddHook("EntityFireBullets", function(ent, data)
        if IsValid(ent) and ent:IsPlayer() then return end
        -- Get the opposite direction it's facing
        local vec = Vector(ent:EyePos().x - ent:GetEyeTrace().HitPos.x, ent:EyePos().y - ent:GetEyeTrace().HitPos.y, ent:EyePos().z - ent:GetEyeTrace().HitPos.z)
        vec:Normalize()
        -- Set a velocity to push it in that direction, using some weird math and the set convar,
        local newVelocity = vec * math.exp(tonumber(math.pow(data.Damage / 2, 1 / 2))) * GetConVar("randomat_recoil2_mul"):GetFloat() * data.Num

        -- If that push's force is greater than the cap convar, set it to the cap
        if newVelocity:Length() > GetConVar("randomat_recoil2_max"):GetInt() * 10000 then
            newVelocity = (newVelocity / newVelocity:Length()) * GetConVar("randomat_recoil2_max"):GetInt() * 10000
        end

        -- Teleport the entity up off the ground a bit when they land so it doesn't get stuck
        if ent:IsOnGround() then
            ent:SetPos(ent:GetPos() + Vector(0, 0, 1))
        end

        -- Push the entity with the calculated force
        ent:SetVelocity(-newVelocity)
    end)
end

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

Randomat:register(EVENT)