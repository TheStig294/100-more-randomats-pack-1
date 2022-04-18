local eventnames = {}
table.insert(eventnames, "It was a case like any other...")
table.insert(eventnames, "Rain dripped down from the dark sky...")
table.insert(eventnames, "That's the thing about this city...")
table.insert(eventnames, "The dame was there under the streetlight...")
table.insert(eventnames, "I sat in the office, knowing those traitors were somewhere...")
table.insert(eventnames, "The case was growing cold...")
table.insert(eventnames, "The rain fell like dead bullets...")
table.insert(eventnames, "I sat in the hotel room, as I contemplated my next move...")
table.insert(eventnames, "I was there in the smoke-filled bar...")
table.insert(eventnames, "I saw him standing in the cold alleyway...")
local EVENT = {}
EVENT.Title = ""
EVENT.AltTitle = "Noir"
EVENT.ExtDescription = "Makes the game look like a 50's detective film!"
EVENT.id = "noir"
EVENT.Type = EVENT_TYPE_MUSIC

EVENT.Categories = {"fun", "largeimpact", "item"}

util.AddNetworkString("randomat_noir")
util.AddNetworkString("randomat_noir_end")

CreateConVar("randomat_noir_music", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Play music during this randomat", 0, 1)

function EVENT:Begin()
    noirRandomat = true
    -- Picking a random name
    EVENT.Title = table.Random(eventnames)
    Randomat:EventNotifySilent(EVENT.Title)

    -- Remove all weapons on players and the ground that take up the pistol slot
    for _, ent in pairs(ents.GetAll()) do
        if (ent.Kind == WEAPON_PISTOL or ent.Kind == WEAPON_HEAVY) and ent.AutoSpawnable then
            ent:Remove()
        end
    end

    -- Give players a revolver
    for k, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            ply:SetFOV(0, 0.2)
            ply:Give("weapon_ttt_revolver_randomat")
            ply:SelectWeapon("weapon_ttt_revolver_randomat")
        end)
    end

    -- Apply black-and-white filter
    net.Start("randomat_noir")
    net.Broadcast()

    if GetConVar("randomat_noir_music"):GetBool() then
        -- Disable round end sounds and 'Ending Flair' event so victory royale music can play
        DisableRoundEndSounds()

        -- And play noir music, if enabled
        for i = 1, 2 do
            game.GetWorld():EmitSound("noir/deadly_roulette.mp3", 0)
        end

        timer.Create("NoirRandomatMusicLoop", 153, 0, function()
            for i = 1, 2 do
                game.GetWorld():StopSound("noir/deadly_roulette.mp3")
            end

            for i = 1, 2 do
                game.GetWorld():EmitSound("noir/deadly_roulette.mp3", 0)
            end
        end)
    end
end

function EVENT:End()
    -- Checking if the randomat has run before trying to remove the greyscale effect, else causes an error
    if noirRandomat then
        noirRandomat = false

        -- Play the ending music if music is enabled
        if GetConVar("randomat_noir_music"):GetBool() then
            timer.Remove("NoirRandomatMusicLoop")

            for i = 1, 2 do
                game.GetWorld():StopSound("noir/deadly_roulette.mp3")
                game.GetWorld():EmitSound("noir/deadly_roulette_end.mp3", 0)
            end
        end

        net.Start("randomat_noir_end")
        net.Broadcast()
    end

    EVENT.Title = ""
end

function EVENT:Condition()
    return not (Randomat:IsEventActive("french") or Randomat:IsEventActive("pistols"))
end

function EVENT:GetConVars()
    local checkboxes = {}

    for _, v in pairs({"music"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checkboxes, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    return {}, checkboxes
end

Randomat:register(EVENT)