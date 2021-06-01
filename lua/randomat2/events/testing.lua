local EVENT = {}

EVENT.Title = "No Testing"
EVENT.Description = "Traitor testers are disabled"
EVENT.id = "testing"

function EVENT:Begin()
	for _, ent in pairs(ents.FindByClass("ttt_logic_role")) do
		ent:Remove()
	end
	
	for _, ent in pairs(ents.FindByClass("ttt_traitor_check")) do
		ent:Remove()
	end
end

Randomat:register(EVENT)