local EVENT = {}
EVENT.Title = "Traitor testers disabled"
EVENT.Description = "Until the next round"
EVENT.id = "testers"

function EVENT:Begin()
    for _, ent in pairs(ents.FindByClass("ttt_logic_role")) do
        ent:Remove()
    end

    for _, ent in pairs(ents.FindByClass("ttt_traitor_check")) do
        ent:Remove()
    end
end

Randomat:register(EVENT)