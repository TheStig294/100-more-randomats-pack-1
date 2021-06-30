local EVENT = {}

CreateConVar("randomat_kexplode_timer", 60, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The time until imperfect karma players explode.", 5)

EVENT.Title = ""
EVENT.AltTitle = "Everyone with a karma damage penalty will explode in " .. GetConVar("randomat_kexplode_timer"):GetInt() .. " seconds!"
EVENT.id = "kexplode"

function EVENT:Begin()
    -- Dynamically change the name of this randomat as the convar is changed
    Randomat:EventNotifySilent("Everyone with a karma damage penalty will explode in " .. GetConVar("randomat_kexplode_timer"):GetInt() .. " seconds!")
    local effectdata = EffectData()
    local message_sent = false

    -- Notify everyone in chat whether they'll explode
    for _, ply in pairs(self:GetAlivePlayers()) do
        if ply:GetDamageFactor() < 1 then
            ply:ChatPrint("You have a karma damage penalty.\nYOU WILL EXPLODE!")
        end
    end

    -- Display a randomat notification when there's half the set seconds left until players with a karma damage penalty explode
    timer.Create("RandomatKExplodeNotif", GetConVar("randomat_kexplode_timer"):GetFloat() / 2, 1, function()
        self:SmallNotify(GetConVar("randomat_kexplode_timer"):GetInt() / 2 .. " seconds left!")
    end)

    -- Explode players once time is up
    timer.Create("RandomatKExplode", GetConVar("randomat_kexplode_timer"):GetInt(), 1, function()
        for _, ply in pairs(self:GetAlivePlayers()) do
            if IsValid(ply) and ply:GetDamageFactor() < 1 then
                ply:EmitSound(Sound("ambient/explosions/explode_4.wav"))
                util.BlastDamage(ply, ply, ply:GetPos(), 300, 10000)
                effectdata:SetStart(ply:GetPos() + Vector(0, 0, 10))
                effectdata:SetOrigin(ply:GetPos() + Vector(0, 0, 10))
                effectdata:SetScale(1)
                util.Effect("HelicopterMegaBomb", effectdata)
                self:SmallNotify("Everyone with a karma damage penalty was exploded!")
                -- Don't display the 'No one exploded' message
                message_sent = true
            end
        end

        -- Displays if the explosion check above didn't trigger for any player
        if not message_sent then
            self:SmallNotify("No one exploded!")
        end
    end)
end

function EVENT:End()
    timer.Remove("RandomatKExplode")
    timer.Remove("RandomatKExplodeNotif")
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