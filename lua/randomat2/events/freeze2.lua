local EVENT = {}
local eventnames = {}
table.insert(eventnames, "What's this one? Oh, it's the freeze randomat...")
table.insert(eventnames, "This is a new one! Wait, it's a freeze randomat...")
table.insert(eventnames, "It's snowing on Mt. Fuji")
table.insert(eventnames, "Icy dead people")
table.insert(eventnames, "Freezing people to find traitors? Is it really worth it...")
table.insert(eventnames, "What? Freeze randomat on Earth?")
table.insert(eventnames, "Unconventional Freezing")
table.insert(eventnames, "We learned how to freeze over time, it's hard, but definitely possible...")
table.insert(eventnames, "Shh... It's a Freeze Randomat!")
table.insert(eventnames, "There's this game my father taught me years ago, it's called \"Freeze\"")
table.insert(eventnames, "Everyone will freeze every 30 seconds! Watch out! (EXCEPT TRAITORS)")
table.insert(eventnames, "Freeze randomat! Time to learn how to keep moving...")
table.insert(eventnames, "We've updated our freezing policy.")
table.insert(eventnames, "Random Freeze for everyone!")
table.insert(eventnames, "Honey, I froze the terrorists")
table.insert(eventnames, "Sudden Freeze!")
table.insert(eventnames, "There are more than " .. #eventnames .. " different freeze randomat names!")
EVENT.Title = ""
EVENT.AltTitle = "Freeze (Randomat Puns)"
EVENT.id = "freeze2"
EVENT.Title = table.Random(eventnames)

function EVENT:Begin()
    Randomat:SilentTriggerEvent("freeze", self.owner)

    timer.Simple(7, function()
        self:SmallNotify("All Innocents will Freeze (and become immune) every " .. GetConVar("randomat_freeze_timer"):GetInt() .. " seconds")
    end)
end

function EVENT:Condition()
    if not ConVarExists("ttt_randomat_freeze") then return false end
    if Randomat:CanEventRun("freeze") then return true end

    return false
end

Randomat:register(EVENT)

hook.Add("TTTPrepareRound", "FreezeRandomatConvarCheck", function()
    if ConVarExists("ttt_randomat_freeze") and GetConVar("ttt_randomat_freeze2"):GetBool() then
        GetConVar("ttt_randomat_freeze"):SetBool(true)
    end
end)