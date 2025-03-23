local EVENT = {}
EVENT.Title = "Drop Shot!"
EVENT.Description = "While not crouching, damage you deal heals instead"
EVENT.id = "dropshot"

EVENT.Categories = {"largeimpact"}

CreateConVar("randomat_dropshot_message_cooldown", "20", FCVAR_NONE, "'Player healed!' message second cooldown. 0 disables", 0, 120)

function EVENT:Begin()
    local messageShown = {}

    self:AddHook("ScalePlayerDamage", function(ply, _, dmg)
        local attacker = dmg:GetAttacker()
        if not IsPlayer(attacker) then return end

        if not attacker:Crouching() then
            ply:SetHealth(math.min(ply:GetMaxHealth(), ply:Health() + dmg:GetDamage()))
            dmg:ScaleDamage(0)

            if not messageShown[attacker] then
                local cooldown = GetConVar("randomat_dropshot_message_cooldown"):GetInt()
                if cooldown == 0 then return end
                attacker:PrintMessage(HUD_PRINTCENTER, "Player healed! Crouch to damage players!")
                attacker:PrintMessage(HUD_PRINTTALK, "Player healed! Crouch to damage players!")
                messageShown[attacker] = true

                timer.Simple(cooldown, function()
                    messageShown[attacker] = false
                end)
            end
        end
    end)
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"message_cooldown"}) do
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