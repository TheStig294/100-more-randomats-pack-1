local EVENT = {}
EVENT.Title = "What did WE find in our pockets?"
EVENT.Description = "Gives everyone the same random buyable weapon"
EVENT.id = "pockets"

function EVENT:Begin()
    -- Get the table of all weapons installed
    local weps = weapons.GetList()
    local give_weps = {}

    -- Filter out the non-buyable weapons
    for i = 1, #weps do
        local wep = weps[i]

        if wep and (wep.CanBuy and #wep.CanBuy > 0) then
            give_weps[#give_weps + 1] = wep
        end
    end

    -- Choose a random weapon and get all alive players
    local item = give_weps[math.random(#give_weps)]
    local plys = self:GetAlivePlayers()

    -- Give everyone that random weapon
    for i = 1, #plys do
        local ply = plys[i]
        ply:Give(WEPS.GetClass(item))
    end
end

Randomat:register(EVENT)