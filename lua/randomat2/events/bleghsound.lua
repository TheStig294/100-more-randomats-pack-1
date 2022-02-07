local EVENT = {}
EVENT.Title = "Blegh"
EVENT.Description = "When someone dies, everyone hears a random 'Blegh!' sound"
EVENT.id = "bleghsound"
util.AddNetworkString("RandomatBleghSound")
local bleghSounds = {}

for i = 1, 17 do
    table.insert(bleghSounds, Sound("bleghsound/blegh" .. i .. ".mp3"))
end

function EVENT:Begin()
    -- Whenever a player dies
    self:AddHook("DoPlayerDeath", function(ply, attacker, dmginfo)
        -- Silence their usual death noise
        dmginfo:SetDamageType(DMG_SLASH)
        -- And play a random "Ben death sound" instead
        local deathSound = bleghSounds[math.random(1, #bleghSounds)]
        net.Start("RandomatBleghSound")
        net.WriteString(deathSound)
        net.Broadcast()
    end)
end

Randomat:register(EVENT)