local EVENT = {}

EVENT.Title = "Nobody"
EVENT.Description = "Anyone killed doesn't leave behind a body"
EVENT.id = "nobody"

function EVENT:Begin()
	hook.Add("TTTOnCorpseCreated", "NobodyRemoveCorpse", function(corpse)
		timer.Simple(0.1, function()
			corpse:Remove()
		end)
	end)
end

function EVENT:End()
	hook.Remove("TTTOnCorpseCreated", "NobodyRemoveCorpse")
end

Randomat:register(EVENT)