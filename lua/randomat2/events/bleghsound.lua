local EVENT = {}
EVENT.Title = "Blegh"
EVENT.Description = "When someone dies, everyone hears a random 'Blegh!' sound"
EVENT.id = "bleghsound"

EVENT.Categories = {"deathtrigger", "smallimpact", "biased"}

util.AddNetworkString("RandomatBleghSound")
local bleghSounds = {}

for i, soundFile in ipairs(file.Find("sound/bleghsound/*.mp3", "GAME")) do
    table.insert(bleghSounds, Sound("bleghsound/" .. soundFile))
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