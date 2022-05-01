local EVENT = {}
EVENT.Title = "No more of your little tricks..."
EVENT.Description = "Disables all traitor traps"
EVENT.id = "traitortraps"

EVENT.Categories = {"biased_innocent", "biased", "smallimpact"}

function EVENT:Begin()
    for _, ent in pairs(ents.FindByClass("ttt_traitor_button")) do
        ent:Remove()
    end
end

function EVENT:Condition()
    for _, ply in ipairs(player.GetAll()) do
        if ROLE_TRICKSTER and ply:GetRole() == ROLE_TRICKSTER then return false end
    end

    return true
end

Randomat:register(EVENT)