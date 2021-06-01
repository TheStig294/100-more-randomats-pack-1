local EVENT = {}
EVENT.Title = "Let's mix it up..."
EVENT.Description = "When you buy something, you get a random weapon instead"
EVENT.id = "mix"

function EVENT:Begin()
    hook.Add("TTTOrderedEquipment", "MixRandomatRandomiser", function(ply, equipment, is_item)
        StripEquipment(ply, equipment, is_item)

        timer.Simple(0.2, function()
            local weps = weapons.GetList()
            local give_weps = {}

            for i = 1, #weps do
                local wep = weps[i]

                if wep and (wep.CanBuy and #wep.CanBuy > 0) then
                    give_weps[#give_weps + 1] = wep
                end
            end

            local item = give_weps[math.random(#give_weps)]
            ply:Give(WEPS.GetClass(item))
        end)
    end)
end

function EVENT:End()
    hook.Remove("TTTOrderedEquipment", "MixRandomatRandomiser")
end

Randomat:register(EVENT)