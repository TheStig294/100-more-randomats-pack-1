local EVENT = {}
EVENT.Title = "Discord Sounds"
EVENT.Description = "Dead players can play discord sounds!"
EVENT.id = "discord"
EVENT.StartSecret = true

EVENT.Categories = {"spectator", "fun", "smallimpact"}

function EVENT:Begin()
    self:AddHook("PostPlayerDeath", function(ply)
        timer.Simple(2, function()
            ply:PrintMessage(HUD_PRINTCENTER, "Press 1 - connect sound")
            ply:PrintMessage(HUD_PRINTTALK, "Press 1 - connect sound")
        end)

        timer.Simple(4, function()
            ply:PrintMessage(HUD_PRINTCENTER, "Press 2 - disconnect sound")
            ply:PrintMessage(HUD_PRINTTALK, "Press 2 - disconnect sound")
        end)

        timer.Simple(6, function()
            ply:PrintMessage(HUD_PRINTCENTER, "Press 3 - ping sound")
            ply:PrintMessage(HUD_PRINTTALK, "Press 3 - ping sound")
        end)
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

Randomat:register(EVENT)