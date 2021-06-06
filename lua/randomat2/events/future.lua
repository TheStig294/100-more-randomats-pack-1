local EVENT = {}
EVENT.Title = "Future Proofing"
EVENT.Description = "Buy menu items aren't given until the next round"
EVENT.id = "future"
local futureRandomatEquipment = {}

function EVENT:Begin()
    -- Let the weapon giving hook know the randomat has activated
    local futureRandomat = true

    -- Clear bought equipment table
    for i, ply in pairs(player.GetAll()) do
        futureRandomatEquipment[ply] = {}
    end

    -- Add bought equipment to the table and remove it from the player
    self:AddHook("TTTOrderedEquipment", function(ply, equipment, is_item)
        table.insert(futureRandomatEquipment[ply], equipment)
        StripEquipment(ply, equipment, is_item)
    end)

    -- Give everyone's bought equipment at the start of the next round
    hook.Add("TTTBeginRound", "FutureRandomatGiveEquipment", function()
        timer.Simple(0.1, function()
            for i, ply in pairs(player.GetAll()) do
                for k = 1, #futureRandomatEquipment[ply] do
                    ClassToGive(futureRandomatEquipment[ply][k], ply)
                end
            end
        end)

        -- Let removal hook know the weapons have been given
        futureRandomat = false
    end)

    -- At the end of the next round, remove the weapon giving hook
    hook.Add("TTTEndRound", "FutureRandomatStopGiveEquipment", function()
        if futureRandomat == false then
            hook.Remove("TTTBeginRound", "FutureRandomatGiveEquipment")
        end
    end)
end

Randomat:register(EVENT)