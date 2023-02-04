local EVENT = {}
EVENT.Title = "Explosive Spectating"
EVENT.Description = "Left-click while prop-possessing to explode!"
EVENT.id = "explosivespectate"

EVENT.Categories = {"spectator", "biased_innocent", "biased", "moderateimpact"}

CreateConVar("randomat_explosivespectate_timer", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Seconds until this event comes into effect", 0, 600)

CreateConVar("randomat_explosivespectate_damage", 100, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Explosion magnitude, scales damage based on distance", 0, 100)

function EVENT:Begin()
    if GetConVar("randomat_explosivespectate_timer"):GetInt() > 0 then
        self.Description = "After " .. GetConVar("randomat_explosivespectate_timer"):GetInt() .. " seconds, dead players can left-click while prop-possessing to explode!"
    else
        self.Description = "Dead players can left-click while prop-possessing to explode!"
    end

    timer.Create("ExplosiveSpectateRandomatActivation", GetConVar("randomat_explosivespectate_timer"):GetInt(), 1, function()
        if GetConVar("randomat_explosivespectate_timer"):GetInt() > 0 then
            self:SmallNotify(self.Title .. " is now active!")
        end

        -- Whenever someone left-clicks,
        self:AddHook("PlayerButtonDown", function(ply, button)
            if button == MOUSE_LEFT then
                -- If they are spectating a prop
                local ent = ply.propspec and ply.propspec.ent

                if IsValid(ent) then
                    -- Then create an explosion where the prop is
                    local explode = ents.Create("env_explosion")
                    explode:SetPos(ent:GetPos())
                    explode:SetOwner(victim)
                    explode:Spawn()
                    explode:SetKeyValue("iMagnitude", GetConVar("randomat_explosivespectate_damage"):GetString())
                    explode:SetKeyValue("iRadiusOverride", "256")
                    explode:Fire("Explode", 0, 0)
                    explode:EmitSound("weapon_AWP.Single", 200, 200)
                    -- And remove the prop
                    ent:Remove()
                end
            end
        end)

        self:AddHook("PostPlayerDeath", function(ply)
            Randomat:SpectatorRandomatAlert(ply, EVENT)
        end)
    end)
end

function EVENT:End()
    timer.Remove("ExplosiveSpectateRandomatActivation")
end

function EVENT:Condition()
    for _, ply in ipairs(player.GetAll()) do
        if ply:IsSpec() then return false end
    end

    return Randomat:MapHasProps()
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"timer", "damage"}) do
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