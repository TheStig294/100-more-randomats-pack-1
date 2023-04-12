local EVENT = {}
EVENT.Title = "Go home, you're drunk!"
EVENT.ExtDescription = "Makes everyone look drunk"
EVENT.id = "drunk"

EVENT.Categories = {"fun", "smallimpact"}

util.AddNetworkString("DrunkRandomatBegin")
util.AddNetworkString("DrunkRandomatEnd")
local eventTriggered = false

function EVENT:Begin()
    eventTriggered = true

    -- Makes every player's model a jigglebone
    for _, ply in ipairs(player.GetAll()) do
        for i = 0, ply:GetBoneCount() - 1 do
            ply:ManipulateBoneJiggle(i, 1)
        end
    end

    -- Add screen edge blur effect
    net.Start("DrunkRandomatBegin")
    net.Broadcast()
end

function EVENT:End()
    if eventTriggered then
        eventTriggered = false

        -- Makes every player's model not a jigglebone
        for _, ply in ipairs(player.GetAll()) do
            for i = 0, ply:GetBoneCount() - 1 do
                ply:ManipulateBoneJiggle(i, 0)
            end
        end

        -- Remove screen effect
        net.Start("DrunkRandomatEnd")
        net.Broadcast()
    end
end

Randomat:register(EVENT)