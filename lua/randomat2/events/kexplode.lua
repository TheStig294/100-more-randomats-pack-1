local EVENT = {}

CreateConVar("randomat_kexplode_timer", 60, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The time until imperfect karma players explode.", 5)

EVENT.Title = ""
EVENT.AltTitle = "Everyone with imperfect karma will explode in " .. GetConVar("randomat_kexplode_timer"):GetInt() .. " seconds!"
EVENT.id = "kexplode"

function EVENT:Begin()
    Randomat:EventNotifySilent("Everyone with imperfect karma will explode in " .. GetConVar("randomat_kexplode_timer"):GetInt() .. " seconds!")
    local effectdata = EffectData()
    local message_sent = false

    for _, ply in pairs(self:GetAlivePlayers(true)) do
        if ply:GetBaseKarma() < GetConVar("ttt_karma_max"):GetFloat() then
            ply:ChatPrint("You have " .. math.floor(ply:GetBaseKarma()) .. " / " .. GetConVar("ttt_karma_max"):GetFloat() .. " karma.\nYOU WILL EXPLODE!")
        end
    end

    timer.Simple(GetConVar("randomat_kexplode_timer"):GetFloat() / 2, function()
        self:SmallNotify(GetConVar("randomat_kexplode_timer"):GetInt() / 2 .. " seconds left!")
    end)

    timer.Create("RandomatKExplode", GetConVar("randomat_kexplode_timer"):GetInt(), 1, function()
        for _, ply in pairs(self:GetAlivePlayers(true)) do
            if ply:GetBaseKarma() < GetConVar("ttt_karma_max"):GetFloat() then
                if IsValid(ply) then
                    ply:EmitSound(Sound("ambient/explosions/explode_4.wav"))
                    util.BlastDamage(ply, ply, ply:GetPos(), 300, 10000)
                    effectdata:SetStart(ply:GetPos() + Vector(0, 0, 10))
                    effectdata:SetOrigin(ply:GetPos() + Vector(0, 0, 10))
                    effectdata:SetScale(1)
                    util.Effect("HelicopterMegaBomb", effectdata)
                    self:SmallNotify("Everyone with imperfect karma was exploded!")
                    message_sent = true
                end
            end
        end

        if not message_sent then
            self:SmallNotify("No one exploded!")
        end
    end)
end

function EVENT:End()
    timer.Remove("RandomatKExplode")
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