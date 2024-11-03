local EVENT = {}
CreateConVar("randomat_freeze2_duration", 5, FCVAR_ARCHIVE, "Duration of the Freeze (in seconds)", 1, 60)
CreateConVar("randomat_freeze2_timer", 30, FCVAR_ARCHIVE, "How often (in seconds) the Freeze occurs", 5, 60)
-- Fills a table with all the possible names of this randomat
local eventnames = {}
table.insert(eventnames, "What's this one? Oh, it's the freeze randomat...")
table.insert(eventnames, "This is a new one! Wait, it's a freeze randomat...")
table.insert(eventnames, "It's snowing on Mt. Fuji")
table.insert(eventnames, "Bing Chilling")
table.insert(eventnames, "Freezing people to find traitors? Is it really worth it...")
table.insert(eventnames, "What? Freeze randomat on Earth?")
table.insert(eventnames, "Shh... It's a Freeze Randomat!")
table.insert(eventnames, "Freeze randomat! Time to learn how to keep moving...")
table.insert(eventnames, "Random freezes for everyone!")
table.insert(eventnames, "Honey, I froze the terrorists")
table.insert(eventnames, "Icicle-ful strategy, is to keep moving!")
table.insert(eventnames, "There are more than " .. #eventnames .. " different freeze randomat names")
EVENT.Title = ""
EVENT.AltTitle = "Freeze (More Names)"
EVENT.ExtDescription = "All Innocents will Freeze (and become immune) every " .. GetConVar("randomat_freeze2_timer"):GetInt() .. " seconds"
EVENT.id = "freeze2"

EVENT.Categories = {"biased_traitor", "biased", "moderateimpact"}

function EVENT:Begin()
    -- Picking a random name
    EVENT.Title = eventnames[math.random(#eventnames)]
    Randomat:EventNotifySilent(EVENT.Title)

    -- Display this randomat's description after a delay
    timer.Simple(7, function()
        self:SmallNotify("All Innocents will Freeze (and become immune) every " .. GetConVar("randomat_freeze2_timer"):GetInt() .. " seconds")
    end)

    local tmr = GetConVar("randomat_freeze2_timer"):GetInt()

    -- Every set amount of seconds,
    timer.Create("RdmtFreeze2Timer", tmr, 0, function()
        -- Display a notification,
        self:SmallNotify("Freeze!")

        -- For every player still alive,
        for _, v in ipairs(self:GetAlivePlayers()) do
            -- If they are innocent, 
            if Randomat:IsInnocentTeam(v, true) then
                -- Freeze them
                v:Freeze(true)
                v.isFrozen = true

                -- And un-freeze them after the set amount of seconds
                timer.Simple(GetConVar("randomat_freeze_duration"):GetInt(), function()
                    v:Freeze(false)
                    v.isFrozen = false
                end)
            end
        end
    end)

    -- Disable taking damage if a player is frozen
    self:AddHook("EntityTakeDamage", function(ply, dmg)
        if ply:IsValid() and ply.isFrozen then
            dmg:ScaleDamage(0)
        end
    end)
end

function EVENT:End()
    -- Unfreeze any currently frozen players, and stop periodically freezing them
    timer.Remove("RdmtFreeze2Timer")
    EVENT.Title = ""
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in ipairs({"duration", "timer"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    return sliders
end

Randomat:register(EVENT)