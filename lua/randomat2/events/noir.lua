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
table.insert(eventnames, "The new detective film, \"Hot Blood\", coming this summer")
local EVENT = {}
EVENT.Title = ""
EVENT.AltTitle = "Noir"
EVENT.ExtDescription = "Makes the game look like a 50's detective film!"
EVENT.id = "noir"

EVENT.Type = {EVENT_TYPE_MUSIC, EVENT_TYPE_WEAPON_OVERRIDE}

EVENT.Categories = {"fun", "largeimpact", "item"}

util.AddNetworkString("randomat_noir")
util.AddNetworkString("randomat_noir_end")
local musicConvar = CreateConVar("randomat_noir_music", "1", FCVAR_NONE, "Play music during this randomat", 0, 1)

function EVENT:Begin()
    noirRandomat = true
    -- Picking a random name
    EVENT.Title = eventnames[math.random(#eventnames)]
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

    -- Gives respawning players a revolver
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            ply:Give("weapon_ttt_revolver_randomat")
            ply:SelectWeapon("weapon_ttt_revolver_randomat")
        end)
    end)

    -- Apply black-and-white filter and play music, if enabled
    net.Start("randomat_noir")
    net.WriteBool(musicConvar:GetBool())
    net.Broadcast()

    -- Disable round end sounds and 'Ending Flair' event so ending music can play
    if musicConvar:GetBool() then
        self:DisableRoundEndSounds()
    end
end

function EVENT:End()
    -- Checking if the randomat has run before trying to remove the greyscale effect, else causes an error
    if noirRandomat then
        noirRandomat = false
        net.Start("randomat_noir_end")
        net.Broadcast()
    end

    EVENT.Title = ""
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