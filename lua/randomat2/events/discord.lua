local EVENT = {}
EVENT.Title = "Discord Sounds"
EVENT.Description = "Dead players can play discord sounds!"
EVENT.id = "discord"
EVENT.StartSecret = true

EVENT.Categories = {"spectator", "fun", "smallimpact"}

util.AddNetworkString("DiscordSoundRandomatBegin")
util.AddNetworkString("DiscordSoundRandomatEnd")

function EVENT:Begin()
    self:AddHook("PostPlayerDeath", function(ply)
        net.Start("DiscordSoundRandomatBegin")
        net.Send(ply)
        SpectatorRandomatAlert(ply, EVENT)
    end)

    self:AddHook("PlayerButtonDown", function(ply, button)
        if ply:Alive() and not ply:IsSpec() then return end

        timer.Create(ply:EntIndex() .. "DiscordRandomatCooldown", 0.5, 1, function()
            if button == KEY_1 then
                ply:EmitSound("discord/connect.mp3")
            elseif button == KEY_2 then
                ply:EmitSound("discord/disconnect.mp3")
            elseif button == KEY_3 then
                ply:EmitSound("discord/ping.mp3")
            end
        end)
    end)
end

function EVENT:End()
    net.Start("DiscordSoundRandomatEnd")
    net.Broadcast()
end

Randomat:register(EVENT)