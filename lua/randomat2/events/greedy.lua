local EVENT = {}
EVENT.Title = "Don't Get Greedy..."
EVENT.Description = "Everyone gets buyable items over time..."
EVENT.id = "greedy"

EVENT.Categories = {"biased_innocent", "biased", "item", "largeimpact"}

CreateConVar("randomat_greedy_timer_min", 10, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Min seconds before a weapon tries to be given", 1, 120)

CreateConVar("randomat_greedy_timer_max", 60, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Max seconds before a weapon tries to be given", 1, 120)

function EVENT:Begin()
    timer.Simple(5, function()
        self:SmallNotify("...but if you're already holding one, you die!")
    end)

    local droppableWeapons = {}

    for _, wep in ipairs(weapons.GetList()) do
        if wep.AllowDrop and wep.Kind and wep.Kind >= WEAPON_EQUIP and wep.Kind ~= WEAPON_ROLE then
            table.insert(droppableWeapons, wep)
        end
    end

    timer.Create("GreedyRandomatCreateTimers", 1, 0, function()
        for _, ply in ipairs(self:GetAlivePlayers()) do
            if timer.Exists("GreedyRandomatTimer" .. ply:SteamID64()) then continue end
            local time = math.random(GetConVar("randomat_greedy_timer_min"):GetInt(), GetConVar("randomat_greedy_timer_max"):GetInt())

            timer.Create("GreedyRandomatTimer" .. ply:SteamID64(), time, 1, function()
                for _, wep in ipairs(ply:GetWeapons()) do
                    if wep.Kind and wep.Kind >= WEAPON_EQUIP and wep.Kind ~= WEAPON_ROLE then
                        ply:Kill()
                        self:SmallNotify(ply:Nick() .. " got too greedy!")
                    else
                        local weapon = droppableWeapons[math.random(1, #droppableWeapons)]
                        ply:Give(weapon.ClassName)
                        ply:PrintMessage(HUD_PRINTCENTER, "You received an item!")
                    end
                end
            end)
        end
    end)
end

function EVENT:End()
    for _, ply in ipairs(player.GetAll()) do
        timer.Remove("GreedyRandomatCreateTimers")
        timer.Remove("GreedyRandomatTimer" .. ply:SteamID64())
    end
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

    return sliders
end

Randomat:register(EVENT)