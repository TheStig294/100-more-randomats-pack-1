local EVENT = {}

CreateConVar("randomat_kexplode_timer", 60, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "The time until imperfect karma players explode.", 5)

EVENT.Title = ""
EVENT.AltTitle = "Everyone with imperfect karma will explode in " .. GetConVar("randomat_kexplode_timer"):GetInt() .. " seconds!"
EVENT.id = "kexplode"

function EVENT:Begin()
    -- Dynamically change the name of this randomat as the convar is changed
    Randomat:EventNotifySilent("Everyone with imperfect karma will explode in " .. GetConVar("randomat_kexplode_timer"):GetInt() .. " seconds!")
    -- Used for the explosion to work
    local effectdata = EffectData()
    -- Used for displaying the correct message to all players depending on whether anyone exploded or not
    local message_sent = false

    -- Notify everyone in chat whether they'll explode
    for _, ply in pairs(self:GetAlivePlayers()) do
        if ply:GetBaseKarma() < GetConVar("ttt_karma_max"):GetFloat() then
            ply:ChatPrint("You have " .. math.floor(ply:GetBaseKarma()) .. " / " .. GetConVar("ttt_karma_max"):GetFloat() .. " karma.\nYOU WILL EXPLODE!")
        end
    end

    -- Display a randomat notification when there's half the set seconds left until imperfect karma players explode
    timer.Simple(GetConVar("randomat_kexplode_timer"):GetFloat() / 2, function()
        self:SmallNotify(GetConVar("randomat_kexplode_timer"):GetInt() / 2 .. " seconds left!")
    end)

    -- Explosion timer
    timer.Create("RandomatKExplode", GetConVar("randomat_kexplode_timer"):GetInt(), 1, function()
        -- For all alive players,
        for _, ply in pairs(self:GetAlivePlayers()) do
            -- If their current karma is less than the maximum
            if IsValid(ply) and ply:GetBaseKarma() < GetConVar("ttt_karma_max"):GetFloat() then
                -- They explode!
                ply:EmitSound(Sound("ambient/explosions/explode_4.wav"))
                util.BlastDamage(ply, ply, ply:GetPos(), 300, 10000)
                effectdata:SetStart(ply:GetPos() + Vector(0, 0, 10))
                effectdata:SetOrigin(ply:GetPos() + Vector(0, 0, 10))
                effectdata:SetScale(1)
                util.Effect("HelicopterMegaBomb", effectdata)
                -- Notify everyone time is up
                self:SmallNotify("Everyone with imperfect karma was exploded!")
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
    -- Don't explode players on the next round...
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