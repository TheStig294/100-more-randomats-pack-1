local EVENT = {}
EVENT.Title = "Gunfire"
EVENT.Description = "Anyone that hasn't shot for a while gets set on fire"
EVENT.id = "gunfire"

CreateConVar("randomat_gunfire_timer", 20, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Seconds before a player is ignited", 1, 120)

function EVENT:Begin()
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Create(ply:SteamID64() .. "_gunfire_timer", 1, GetConVar("randomat_gunfire_timer"):GetInt(), function()
            if timer.RepsLeft(ply:SteamID64() .. "_gunfire_timer") == 0 and ply:Alive() and not ply:IsSpec() then
                ply:Ignite(60)
                ply:ChatPrint("Shoot to put out the fire!")
            end
        end)
    end

    self:AddHook("PlayerButtonDown", function(ply, button)
        if button == MOUSE_LEFT and ply:Alive() and not ply:IsSpec() and ply:GetActiveWeapon():Clip1() ~= nil and ply:GetActiveWeapon():Clip1() > 0 then
            timer.Create(ply:SteamID64() .. "_gunfire_timer", 1, GetConVar("randomat_gunfire_timer"):GetInt(), function()
                if timer.RepsLeft(ply:SteamID64() .. "_gunfire_timer") == 0 and ply:Alive() and not ply:IsSpec() then
                    ply:Ignite(60)
                    ply:ChatPrint("Shoot to put out the fire!")
                end
            end)

            ply:Extinguish()
        end
    end)

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