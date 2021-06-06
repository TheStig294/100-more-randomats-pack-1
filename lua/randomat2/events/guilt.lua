CreateConVar("randomat_guilt_time", 5, {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Time Guilty", 1, 30)

local EVENT = {}
EVENT.Title = "Unbelievable Guilt"
EVENT.Description = "Killing someone on your team forces your head down for a few seconds"
EVENT.id = "guilt"
util.AddNetworkString("Guilty")

function EVENT:Begin()
    -- Players who RDM have their head forced down
    self:AddHook("PlayerDeath", function(victim, inflictor, attacker)
        if victim and attacker and victim ~= attacker and victim:IsPlayer() and attacker:IsPlayer() and IsSameTeam(attacker, victim) then
            net.Start("Guilty")
            net.Send(attacker)
        end
    end)

    -- Players who RDM with a headshot get their head forced down
    self:AddHook("PlayerSilentDeath", function(victim, inflictor, attacker)
        if victim and attacker and victim ~= attacker and victim:IsPlayer() and attacker:IsPlayer() and IsSameTeam(attacker, victim) then
            net.Start("Guilty")
            net.Send(attacker)
        end
    end)
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"time"}) do
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