local EVENT = {}
EVENT.Title = "Hot Potato!"
EVENT.Description = "Someone has the hot potato, pass it on or else you explode!"
EVENT.id = "potato"
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

hook.Add("PreRegisterSWEP", "HotPotatoGetRandomatFunctions", function(SWEP, class)
    -- If it exists,
    if class == "weapon_ttt_hotpotato" then
        --  Grab the hot potato's activate and clean-up functions,
        function RandomatActivatePotato(ply, PotatoChef)
            SWEP:PotatoTime(ply, PotatoChef)
        end

        function RandomatPotatoCleanup()
            fn_CleanUpAll()
        end

        -- And set a global bool to say it was found
        SetGlobalBool("PotatoRandomatExists", true)
    end
end)

function EVENT:Begin()
    -- Choose a random player
    local ply = table.Random(self:GetAlivePlayers())

    -- Ensure the hot potato hooks are cleaned up
    hook.Add("TTTPrepareRound", ply:Name() .. "_RoundRestartCleanup", function()
        RandomatPotatoCleanup()
    end)

    -- And activate the hot potato on the chosen player, setting the attacker to be themselves
    RandomatActivatePotato(ply, ply)
end

function EVENT:Condition()
    -- Only activate if the hot potato weapon was found
    return GetGlobalBool("PotatoRandomatExists", false)
end

Randomat:register(EVENT)