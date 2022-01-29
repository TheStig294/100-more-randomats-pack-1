local EVENT = {}
EVENT.Title = "Pistols at dawn"
EVENT.Description = "Last innocent and traitor alive have a one-shot pistol showdown"
EVENT.id = "pistols"
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE
util.AddNetworkString("PistolsDrawHalos")
util.AddNetworkString("PistolsRemoveHalos")

function EVENT:Begin()
    -- Allow the initial trigger code to run
    local pistolsTriggerOnce = false

    -- Continually,
    self:AddHook("Think", function()
        -- Count the number of players alive,
        local pistolsAlivePlayers = #self:GetAlivePlayers()

        -- The jester/swapper doesn't count
        for i, ply in pairs(self:GetAlivePlayers()) do
            if ply:GetRole() == ROLE_SWAPPER or ply:GetRole() == ROLE_JESTER then
                pistolsAlivePlayers = pistolsAlivePlayers - 1
            end
        end

        -- At 2 players alive, initial trigger code runs once
        if pistolsAlivePlayers == 2 then
            if pistolsTriggerOnce == false then
                -- Strip all weapons from the ground,
                for _, ent in pairs(ents.GetAll()) do
                    if ent.Kind == WEAPON_PISTOL or ent.Kind == WEAPON_HEAVY or ent.Kind == WEAPON_NADE and ent.AutoSpawnable then
                        ent:Remove()
                    end
                end

                -- After 1 second, trigger a notification and let players see through walls if that randomat is added by another mod,
                timer.Simple(1, function()
                    self:SmallNotify("Pistols at dawn!")
                    net.Start("PistolsDrawHalos")
                    net.Broadcast()
                end)
            end

            -- After 2 seconds, continually
            timer.Simple(2, function()
                for i, ply in pairs(self:GetAlivePlayers()) do
                    -- Strip all credits
                    ply:SetCredits(0)

                    -- Give players ammo for the one-shot pistol if they have it
                    if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "weapon_ttt_pistol_randomat" then
                        ply:SetAmmo(69, "Pistol")
                    end

                    -- And if they're not a jester/swapper and aren't holding the one-shot pistol,
                    if IsValid(ply:GetActiveWeapon()) and (ply:GetRole() ~= ROLE_SWAPPER) and (ply:GetRole() ~= ROLE_JESTER) and ply:GetActiveWeapon():GetClass() ~= "weapon_ttt_pistol_randomat" then
                        -- Remove all their weapons and credits
                        ply:StripWeapons()
                        ply:SetCredits(0)
                        -- Give them the pistol and force them to select it
                        ply:Give("weapon_ttt_pistol_randomat")
                        ply:SelectWeapon("weapon_ttt_pistol_randomat")
                    end
                end
            end)

            -- Prevent the initial trigger code from running again, until this randomat is triggered again
            pistolsTriggerOnce = true
        end
    end)
end

function EVENT:End()
    net.Start("PistolsRemoveHalos")
    net.Broadcast()
end

Randomat:register(EVENT)