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

Randomat:register(EVENT)