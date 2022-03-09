local EVENT = {}

CreateConVar("randomat_kexplode_timer", 60, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The time until imperfect karma players explode.", 5)

EVENT.Title = ""
EVENT.AltTitle = "Everyone with a karma damage penalty will explode in " .. GetConVar("randomat_kexplode_timer"):GetInt() .. " seconds!"
EVENT.id = "kexplode"

EVENT.Categories = {"stats", "eventtrigger", "smallimpact"}

function EVENT:Begin()
    -- Dynamically change the name of this randomat as the convar is changed
    Randomat:EventNotifySilent("Everyone with a karma damage penalty will explode in " .. GetConVar("randomat_kexplode_timer"):GetInt() .. " seconds!")
    local effectdata = EffectData()
    local karmaPlayers = {}

    for i, ply in ipairs(self:GetAlivePlayers()) do
        if ply:GetDamageFactor() < 1 then
            table.insert(karmaPlayers, ply)

            timer.Simple(5, function()
                ply:PrintMessage(HUD_PRINTCENTER, "YOU WILL EXPLODE!")
            end)
        end
    end

    if table.IsEmpty(karmaPlayers) then
        timer.Simple(5, function()
            self:SmallNotify("But all of you have high karma, so here's a reward for being good...")

            timer.Simple(5, function()
                Randomat:TriggerEvent("pockets")
            end)
        end)
    else
        timer.Simple(5, function()
            PrintMessage(HUD_PRINTTALK, "These players will explode:")

            for i, ply in ipairs(karmaPlayers) do
                PrintMessage(HUD_PRINTTALK, ply:Nick())
            end
        end)

        -- Display a randomat notification when there's half the set seconds left until players with a karma damage penalty explode
        timer.Create("RandomatKExplodeNotif", GetConVar("randomat_kexplode_timer"):GetFloat() / 2, 1, function()
            self:SmallNotify(GetConVar("randomat_kexplode_timer"):GetInt() / 2 .. " seconds left!")
        end)

        -- Explode players once time is up
        timer.Create("RandomatKExplode", GetConVar("randomat_kexplode_timer"):GetInt(), 1, function()
            for _, ply in pairs(karmaPlayers) do
                if ply:Alive() and not ply:IsSpec() then
                    ply:EmitSound(Sound("ambient/explosions/explode_4.wav"))
                    util.BlastDamage(ply, ply, ply:GetPos(), 300, 10000)
                    effectdata:SetStart(ply:GetPos() + Vector(0, 0, 10))
                    effectdata:SetOrigin(ply:GetPos() + Vector(0, 0, 10))
                    effectdata:SetScale(1)
                    util.Effect("HelicopterMegaBomb", effectdata)
                    self:SmallNotify("Everyone with a karma damage penalty exploded!")
                end
            end
        end)
    end
end

function EVENT:End()
    timer.Remove("RandomatKExplode")
    timer.Remove("RandomatKExplodeNotif")
end

function EVENT:Condition()
    return GetConVar("ttt_karma"):GetBool()
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