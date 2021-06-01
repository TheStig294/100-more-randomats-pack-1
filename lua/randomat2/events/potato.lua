local EVENT = {}
EVENT.Title = "Hot Potato!"
EVENT.Description = "Someone has the hot potato, pass it on or else you explode!"
EVENT.id = "potato"

hook.Add("PreRegisterSWEP", "HotPotatoGetRandomatFunctions", function(SWEP, class)
    if class == "weapon_ttt_hotpotato" then
        function RandomatActivatePotato(ply, PotatoChef)
            SWEP:PotatoTime(ply, PotatoChef)
        end

        function RandomatPotatoCleanup()
            fn_CleanUpAll()
        end

        SetGlobalBool("PotatoRandomatExists", true)
    end
end)

function EVENT:Begin()
    local ply = table.Random(self:GetAlivePlayers())

    hook.Add("TTTPrepareRound", ply:Name() .. "_RoundRestartCleanup", function()
        RandomatPotatoCleanup()
    end)

    RandomatActivatePotato(ply, ply)
end

function EVENT:Condition()
    return GetGlobalBool("PotatoRandomatExists", false)
end

Randomat:register(EVENT)