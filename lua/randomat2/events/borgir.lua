local EVENT = {}
CreateConVar("randomat_borgir_count", 2, FCVAR_NONE, "Number of borgir spawned per person", 1, 10)
CreateConVar("randomat_borgir_range", 200, FCVAR_NONE, "Distance borgir spawn from the player", 0, 1000)
CreateConVar("randomat_borgir_timer", 60, FCVAR_NONE, "Time between borgir spawns", 1, 600)
CreateConVar("randomat_borgir_faster_mult", 0.2, FCVAR_NONE, "Number the player's speed multiplier will increase by", 0, 3)
CreateConVar("randomat_borgir_slower_mult", 0.2, FCVAR_NONE, "Number the player's speed multiplier will decrease by", 0, 3)
CreateConVar("randomat_borgir_faster_cap", 3, FCVAR_NONE, "The highest speed multiplier a player can get", 1, 10)
CreateConVar("randomat_borgir_slower_cap", 0.2, FCVAR_NONE, "The lowest speed multiplier a player can get", 0, 1)
EVENT.Title = "Borgir"
EVENT.Description = "Spawns \"borgirs\" that increase/decrease your speed"
EVENT.id = "borgir"

EVENT.Categories = {"entityspawn", "moderateimpact"}

local function TriggerBorgir()
    local plys = {}

    for k, ply in ipairs(player.GetAll()) do
        if not ply:IsSpec() then
            plys[k] = ply
        end
    end

    for _, ply in pairs(plys) do
        if ply:Alive() and not ply:IsSpec() then
            if CLIENT then return end

            for _ = 1, GetConVar("randomat_borgir_count"):GetInt() do
                local ent = ents.Create("ent_borgir_randomat")
                if not IsValid(ent) then return end
                local sc = GetConVar("randomat_borgir_range"):GetInt()
                ent:SetPos(ply:GetPos() + Vector(math.random(-sc, sc), math.random(-sc, sc), math.random(100, sc)))
                ent:Spawn()
                local phys = ent:GetPhysicsObject()

                if not IsValid(phys) then
                    ent:Remove()

                    return
                end
            end
        end
    end
end

function EVENT:Begin()
    TriggerBorgir()
    timer.Create("RdmtBorgirpawnTimer", GetConVar("randomat_borgir_timer"):GetInt(), 0, TriggerBorgir)
end

function EVENT:End()
    timer.Remove("RdmtBorgirpawnTimer")

    for _, ply in ipairs(player.GetAll()) do
        ply:SetLaggedMovementValue(1)
    end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in ipairs({"count", "range", "timer"}) do
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

    for _, v in ipairs({"faster_mult", "slower_mult", "faster_cap", "slower_cap"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 1
            })
        end
    end

    return sliders
end

Randomat:register(EVENT)