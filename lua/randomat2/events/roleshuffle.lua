local EVENT = {}

CreateConVar("randomat_roleshuffle_time", 60, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "How long in seconds until roles are shuffled", 5, 300)

EVENT.Title = "Everyone swaps roles and weapons in " .. GetConVar("randomat_roleshuffle_time"):GetInt() .. " seconds!"
EVENT.AltTitle = "Role Shuffle!"
EVENT.id = "roleshuffle"

EVENT.Categories = {"rolechange", "moderateimpact"}

local function SetPlayerData(ply, data)
    ply:SetCredits(data.credits)
    Randomat:SetRole(ply, data.role)
    ply:StripWeapons()
    -- Reset FOV to unscope
    ply:SetFOV(0, 0.2)

    for _, weapon in ipairs(data.weapons) do
        ply:Give(weapon)
    end
end

function EVENT:Begin()
    self.Title = "Everyone swaps roles and weapons in " .. GetConVar("randomat_roleshuffle_time"):GetInt() .. " seconds!"

    -- Create a full timer that doesn't repeat, so it can be stopped if the round ends before it triggers
    timer.Create("RoleShuffleRandomatTimer", GetConVar("randomat_roleshuffle_time"):GetInt(), 1, function()
        local playerData = {}
        local alivePlayers = self:GetAlivePlayers(true)
        local remainingPlayers = {}

        -- Get everyone's credits, roles and weapons
        for _, ply in ipairs(alivePlayers) do
            local ID = ply:SteamID64()
            table.insert(remainingPlayers, ID)
            playerData[ID] = {}
            playerData[ID].credits = ply:GetCredits()
            playerData[ID].role = ply:GetRole()
            playerData[ID].weapons = {}

            for _, weapon in ipairs(ply:GetWeapons()) do
                table.insert(playerData[ID].weapons, weapon:GetClass())
            end
        end

        -- Swap everyone's credits, roles and weapons around!
        for i, ply in ipairs(alivePlayers) do
            local ID = ply:SteamID64()
            local plyRemoved = table.RemoveByValue(remainingPlayers, ID)

            -- If the last player selected has noone to swap with (odd no. of alive players) then they swap with a random player
            if table.IsEmpty(remainingPlayers) then
                for _, rdmply in ipairs(alivePlayers) do
                    if ply ~= rdmply then
                        SetPlayerData(rdmply, playerData[ply:SteamID64()])
                        SetPlayerData(ply, playerData[rdmply:SteamID64()])
                        break
                    end
                end
            else
                -- Randomly choose a player that hasn't yet been chosen, remainingPlayers table was shuffled at the start
                local chosenID = remainingPlayers[1]
                SetPlayerData(ply, playerData[chosenID])
                -- And remove that player from the pool of possible players
                table.RemoveByValue(remainingPlayers, chosenID)

                if plyRemoved then
                    table.insert(remainingPlayers, ID)
                end
            end
        end

        SendFullStateUpdate()
        -- Notify everyone when the role shuffle happens
        self:SmallNotify("Role shuffle!")
    end)
end

function EVENT:End()
    -- Stop the timer if the round ends before the role shuffle triggers
    timer.Remove("RoleShuffleRandomatTimer")
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"time"}) do
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