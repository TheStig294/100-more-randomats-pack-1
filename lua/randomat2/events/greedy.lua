local EVENT = {}
EVENT.Title = "Don't Get Greedy..."
EVENT.Description = "At random points in time, you get a buyable item or..."
EVENT.id = "greedy"

EVENT.Categories = {"biased_innocent", "biased", "item", "largeimpact"}

local minCvar = CreateConVar("randomat_greedy_timer_min", 10, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Min seconds before a weapon tries to be given", 1, 120)

local maxCvar = CreateConVar("randomat_greedy_timer_max", 60, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Max seconds before a weapon tries to be given", 1, 120)

local soundCvar = CreateConVar("randomat_greedy_slap_sound", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether a slap sound should play on death", 0, 1)

local droppableWeapons = {}

local function CreateTimer(ply)
    local time = math.random(minCvar:GetInt(), maxCvar:GetInt())

    timer.Create("GreedyRandomatTimer" .. ply:SteamID64(), time, 0, function()
        -- Don't display messages while the player isn't alive
        if not ply:Alive() or ply:IsSpec() then return end
        local hadItem = false

        for _, wep in ipairs(ply:GetWeapons()) do
            if wep.Kind and wep.Kind >= WEAPON_EQUIP and wep.Kind ~= WEAPON_ROLE then
                ply:Kill()

                if soundCvar:GetBool() then
                    BroadcastLua("surface.PlaySound(\"greedy/greedy.mp3\")")
                end

                EVENT:SmallNotify(ply:Nick() .. " got too greedy!")
                hadItem = true
            end
        end

        if not hadItem then
            local weapon = droppableWeapons[math.random(1, #droppableWeapons)]
            ply:Give(weapon.ClassName)
            ply:PrintMessage(HUD_PRINTCENTER, "You received an item!")
            ply:PrintMessage(HUD_PRINTTALK, "You received an item!")
        end
    end)
end

function EVENT:Begin()
    timer.Simple(5, function()
        self:SmallNotify("...if you have any kind of buyable item, you die instead!")
        PrintMessage(HUD_PRINTTALK, "...if you have any kind of buyable item, you die instead!")
    end)

    for _, wep in ipairs(weapons.GetList()) do
        if wep.AllowDrop and wep.Kind and wep.Kind >= WEAPON_EQUIP and wep.Kind ~= WEAPON_ROLE then
            table.insert(droppableWeapons, wep)
        end
    end

    for _, ply in ipairs(self:GetAlivePlayers()) do
        CreateTimer(ply)
    end

    -- If a player dies and respawns, reset their timer
    self:AddHook("PlayerSpawn", function(ply)
        CreateTimer(ply)
    end)
end

function EVENT:End()
    for _, ply in ipairs(player.GetAll()) do
        timer.Remove("GreedyRandomatTimer" .. ply:SteamID64())
    end

    table.Empty(droppableWeapons)
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in ipairs({"timer_min", "timer_max"}) do
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

    local checks = {}

    for _, v in pairs({"slap_sound"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return sliders, checks
end

Randomat:register(EVENT)