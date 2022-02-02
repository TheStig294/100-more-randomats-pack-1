local EVENT = {}

CreateConVar("randomat_gunfire_timer", 20, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Seconds before a player is ignited", 1, 120)

EVENT.Title = "Gunfire"
EVENT.Description = "Not shooting for too long sets you on fire!"
EVENT.id = "gunfire"

local function RestartExtinguishTimer(ply)
    timer.Create(ply:SteamID64() .. "_gunfire_timer", 1, GetConVar("randomat_gunfire_timer"):GetInt(), function()
        if timer.RepsLeft(ply:SteamID64() .. "_gunfire_timer") == 0 and ply:Alive() and not ply:IsSpec() then
            ply:Ignite(60)
            ply:PrintMessage(HUD_PRINTCENTER, "Shoot to extinguish!")
            ply:PrintMessage(HUD_PRINTTALK, "'" .. EVENT.Title .. "' is active!\n" .. EVENT.Description)
        end
    end)
end

function EVENT:Begin()
    -- Initial player igniting timer
    for i, ply in pairs(self:GetAlivePlayers()) do
        RestartExtinguishTimer(ply)
    end

    -- Literally just looking for the player left-clicking, alive, and having some ammo in their gun's clip when they click
    self:AddHook("PlayerButtonDown", function(ply, button)
        if button == MOUSE_LEFT and ply:Alive() and not ply:IsSpec() and ply:GetActiveWeapon():Clip1() ~= nil and ply:GetActiveWeapon():Clip1() > 0 then
            RestartExtinguishTimer(ply)
            ply:Extinguish()
        end
    end)

    -- Original player extinguishing hook, apparently doesn't work for projectile-based guns, which is why the hook above was added
    self:AddHook("EntityFireBullets", function(ent, data)
        if IsPlayer(ent) then
            RestartExtinguishTimer(ent)
            ent:Extinguish()
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