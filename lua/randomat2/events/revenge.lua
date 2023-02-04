local EVENT = {}
EVENT.Title = "Ghostly Revenge"
EVENT.Description = "Prop possession is buffed!"
EVENT.id = "revenge"

EVENT.Categories = {"spectator", "biased_innocent", "biased", "moderateimpact"}

local randomat_revenge_multiplier = CreateConVar("randomat_revenge_multiplier", 4.0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Multiplier to all prop possession stats", 1, 50)

CreateConVar("randomat_revenge_timer", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Seconds until this event comes into effect", 0, 600)

local prop_base
local prop_maxbonus
local prop_force
local prop_recharge
local revengeRandomat = false

function EVENT:Begin()
    if SERVER then
        if GetConVar("randomat_revenge_timer"):GetInt() > 0 then
            self.Description = "After " .. GetConVar("randomat_revenge_timer"):GetInt() .. " seconds, prop possession is massively buffed!"
        else
            self.Description = "Prop possession is massively buffed!"
        end

        timer.Create("RevengeRandomatActivation", GetConVar("randomat_revenge_timer"):GetInt(), 1, function()
            if GetConVar("randomat_revenge_timer"):GetInt() > 0 then
                self:SmallNotify(self.Title .. " is now active!")
            end

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

            self:AddHook("PostPlayerDeath", function(ply)
                Randomat:SpectatorRandomatAlert(ply, EVENT)
            end)
        end)
    end
end

function EVENT:End()
    timer.Remove("RevengeRandomatActivation")

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
    for _, ply in ipairs(player.GetAll()) do
        if ply:IsSpec() then return false end
    end

    return Randomat:MapHasProps()
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"multiplier", "timer"}) do
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