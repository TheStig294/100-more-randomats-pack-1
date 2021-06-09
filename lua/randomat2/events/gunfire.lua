local EVENT = {}

CreateConVar("randomat_gunfire_timer", 20, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Seconds before a player is ignited", 1, 120)

EVENT.Title = "Gunfire"
EVENT.Description = "Anyone that hasn't shot for a while gets set on fire"
EVENT.id = "gunfire"

function EVENT:Begin()
    -- Initial player igniting timer
    -- For all alive players,
    for i, ply in pairs(self:GetAlivePlayers()) do
        -- After the set amount of seconds,
        timer.Create(ply:SteamID64() .. "_gunfire_timer", 1, GetConVar("randomat_gunfire_timer"):GetInt(), function()
            -- After the timer has run out and the player is still alive,
            if timer.RepsLeft(ply:SteamID64() .. "_gunfire_timer") == 0 and ply:Alive() and not ply:IsSpec() then
                -- Ignite them for 60 seconds and display a chat message
                ply:Ignite(60)
                ply:ChatPrint("Shoot to put out the fire!")
            end
        end)
    end

    -- Player extinguishing hook
    self:AddHook("PlayerButtonDown", function(ply, button)
        -- Literally just looking for the player left-clicking, alive, and having some ammo in their gun's clip when they click
        if button == MOUSE_LEFT and ply:Alive() and not ply:IsSpec() and ply:GetActiveWeapon():Clip1() ~= nil and ply:GetActiveWeapon():Clip1() > 0 then
            -- Restarting player igniting timer
            timer.Create(ply:SteamID64() .. "_gunfire_timer", 1, GetConVar("randomat_gunfire_timer"):GetInt(), function()
                if timer.RepsLeft(ply:SteamID64() .. "_gunfire_timer") == 0 and ply:Alive() and not ply:IsSpec() then
                    ply:Ignite(60)
                    ply:ChatPrint("Shoot to put out the fire!")
                end
            end)

            -- And putting out the fire
            ply:Extinguish()
        end
    end)

    -- Original player extinguishing hook, apparently doesn't work for projectile-based guns,
    -- which is why the hook above was added
    self:AddHook("EntityFireBullets", function(ply, data)
        if ply:IsPlayer() then
            timer.Create(ply:SteamID64() .. "_gunfire_timer", 1, GetConVar("randomat_gunfire_timer"):GetInt(), function()
                if timer.RepsLeft(ply:SteamID64() .. "_gunfire_timer") == 0 and ply:Alive() and not ply:IsSpec() then
                    ply:Ignite(60)
                    ply:ChatPrint("Shoot to put out the fire!")
                end
            end)

            ply:Extinguish()
        end
    end)
end

function EVENT:End()
    -- Put all players out
    for i, ply in pairs(self:GetPlayers()) do
        timer.Remove(ply:SteamID64() .. "_gunfire_timer")
        ply:Extinguish()
    end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"timer"}) do
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