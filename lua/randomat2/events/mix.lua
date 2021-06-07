local EVENT = {}
EVENT.Title = "Let's mix it up..."
EVENT.Description = "When you buy something, you get a random weapon instead"
EVENT.id = "mix"

function EVENT:Begin()
    -- Whenever someone buys something, 
    self:AddHook("TTTOrderedEquipment", function(ply, equipment, is_item)
        -- Remove what they bought
        StripEquipment(ply, equipment, is_item)

        -- Wait a split second
        timer.Simple(0.2, function()
            -- Get all weapons
            local weps = weapons.GetList()
            local give_weps = {}

            -- Filter out the un-buyable weapons
            for i = 1, #weps do
                local wep = weps[i]

                if wep and (wep.CanBuy and #wep.CanBuy > 0) then
                    give_weps[#give_weps + 1] = wep
                end
            end

            -- Select a random weapon and give it to the player
            local item = give_weps[math.random(#give_weps)]
            ply:Give(WEPS.GetClass(item))
        end)
    end)
end

Randomat:register(EVENT)