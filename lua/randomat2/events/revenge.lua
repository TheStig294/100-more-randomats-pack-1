local EVENT = {}
EVENT.Title = "Ghostly Revenge"
EVENT.Description = "Prop possession is massively buffed"
EVENT.id = "revenge"

local randomat_revenge_multiplier = CreateConVar("randomat_revenge_multiplier", 4.0, {FCVAR_ARCHIVE}, "Multiplier to all prop possession stats")

local prop_base
local prop_maxbonus
local prop_force
local prop_recharge
local revengeRandomat = false

function EVENT:Begin()
    if SERVER then
        -- Let the end function know the begin function has triggered
        revengeRandomat = true
        -- Grab all the prop possession settings
        prop_base = GetConVar("ttt_spec_prop_base"):GetFloat()
        prop_maxbonus = GetConVar("ttt_spec_prop_maxbonus"):GetFloat()
        prop_force = GetConVar("ttt_spec_prop_force"):GetFloat()
        prop_recharge = GetConVar("ttt_spec_prop_rechargetime"):GetFloat()
        -- And scale them according to the convar
        RunConsoleCommand("ttt_spec_prop_base", prop_base * randomat_revenge_multiplier:GetFloat())
        RunConsoleCommand("ttt_spec_prop_maxbonus", prop_maxbonus * randomat_revenge_multiplier:GetFloat())
        RunConsoleCommand("ttt_spec_prop_force", prop_force * randomat_revenge_multiplier:GetFloat())
        RunConsoleCommand("ttt_spec_prop_rechargetime", prop_recharge / randomat_revenge_multiplier:GetFloat())
    end
end

function EVENT:End()
    -- Don't try to reset the prop possession settings unless this randomat has run
    if SERVER and revengeRandomat then
        RunConsoleCommand("ttt_spec_prop_base", prop_base)
        RunConsoleCommand("ttt_spec_prop_maxbonus", prop_maxbonus)
        RunConsoleCommand("ttt_spec_prop_force", prop_force)
        RunConsoleCommand("ttt_spec_prop_rechargetime", prop_recharge)
        -- And stop them from resetting every round after
        revengeRandomat = false
    end
end

function EVENT:Condition()
    -- Only run this if there are actual props
    if table.Count(ents.FindByClass("prop_physics*")) == 0 and table.Count(ents.FindByClass("prop_dynamic")) == 0 then return false end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"multiplier"}) do
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