local EVENT = {}

EVENT.Title = "Future Proofing"
EVENT.Description = "Buy menu items aren't given until the next round"
EVENT.id = "future"

boughtEquipment = {}

function EVENT:Begin()
	futureRandomat = true
	for i, ply in pairs(player.GetAll()) do
		boughtEquipment[ply] = {}
	end
	
	hook.Add("TTTOrderedEquipment", "FutureRandomatEquipmentList", function(ply, equipment, is_item)
		table.insert(boughtEquipment[ply], equipment)
		StripEquipment(ply, equipment, is_item)
	end)
	
	hook.Add("TTTBeginRound", "FutureRandomatGiveEquipment", function()
		timer.Simple(0.1, function()
			for i, ply in pairs(player.GetAll()) do
				for k = 1, #boughtEquipment[ply] do
					ClassToGive(boughtEquipment[ply][k], ply)
				end
			end
		end)
		futureRandomat = false
	end)
	
	hook.Add("TTTEndRound", "FutureRandomatStopGiveEquipment", function()
		if futureRandomat == false then
			hook.Remove("TTTBeginRound", "FutureRandomatGiveEquipment")
		end
	end)
end

function EVENT:End()
	hook.Remove("TTTOrderedEquipment", "FutureRandomatEquipmentList")
end

Randomat:register(EVENT)