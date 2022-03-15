local EVENT = {}
EVENT.Title = "Pistols at dawn"
EVENT.Description = "The last players alive have a one-shot pistol showdown!"
EVENT.id = "pistols"
EVENT.Type = EVENT_TYPE_WEAPON_OVERRIDE

EVENT.Categories = {"gamemode", "largeimpact"}

util.AddNetworkString("PistolsDrawHalos")
util.AddNetworkString("PistolsRandomatWinTitle")
util.AddNetworkString("PistolsRemoveHalos")

function EVENT:Begin()
    -- Allow the initial trigger code to run
    local pistolsTriggerOnce = false
    local triggerShowdown = false
    local triggerDelay = 1

    -- Transform all jesters/independents to innocents so we don't have to worry about special win logic
    for i, ply in ipairs(self:GetAlivePlayers()) do
        if Randomat:IsJesterTeam(ply) or Randomat:IsIndependentTeam(ply) then
            Randomat:SetRole(ply, ROLE_INNOCENT)
        end
    end

    SendFullStateUpdate()
    hook.Run("UpdatePlayerLoadouts")

    -- Continually,
    self:AddHook("Think", function()
        -- At 2 players alive, initial trigger code runs once
        if triggerShowdown then
            if pistolsTriggerOnce == false then
                -- After 1 second, trigger a notification and let players see through walls if that randomat is added by another mod,
                timer.Simple(triggerDelay, function()
                    self:SmallNotify("Pistols at dawn!")
                    net.Start("PistolsDrawHalos")
                    net.Broadcast()
                end)
            end

            -- After 2 seconds, continually
            timer.Simple(triggerDelay, function()
                for i, ply in pairs(self:GetAlivePlayers()) do
                    -- Strip all credits
                    ply:SetCredits(0)

                    -- Give players ammo for the one-shot pistol if they have it
                    if not IsValid(ply:GetActiveWeapon()) or ply:GetActiveWeapon():GetClass() == "weapon_ttt_pistol_randomat" then
                        ply:SetAmmo(69, "Pistol")
                    end

                    -- And if they're not a jester/swapper and aren't holding the one-shot pistol,
                    if not IsValid(ply:GetActiveWeapon()) or ply:GetActiveWeapon():GetClass() ~= "weapon_ttt_pistol_randomat" then
                        -- Remove all their weapons and credits
                        ply:StripWeapons()
                        ply:SetCredits(0)
                        ply:SetFOV(0, 0.2)
                        -- Give them the pistol and force them to select it
                        ply:Give("weapon_ttt_pistol_randomat")
                        ply:SelectWeapon("weapon_ttt_pistol_randomat")
                    end
                end
            end)

            -- Prevent the initial trigger code from running again, until this randomat is triggered again
            pistolsTriggerOnce = true
        end
    end)

    local winBlocked = false
    local messageLength = 4

    self:AddHook("TTTCheckForWin", function()
        if not winBlocked then
            local alivePlayers = self:GetAlivePlayers()
            -- Else, check there are only innocents or traitors remaining
            local traitorPlayers = {}
            local innocentPlayers = {}

            for i, ply in ipairs(alivePlayers) do
                if Randomat:IsTraitorTeam(ply) then
                    table.insert(traitorPlayers, ply)
                elseif Randomat:IsInnocentTeam(ply) then
                    table.insert(innocentPlayers, ply)
                end
            end

            if table.IsEmpty(traitorPlayers) or table.IsEmpty(innocentPlayers) then
                winBlocked = true

                if table.IsEmpty(traitorPlayers) then
                    Randomat:SmallNotify("Innocents Win... But now it's a free-for-all!", messageLength)
                elseif table.IsEmpty(innocentPlayers) then
                    Randomat:SmallNotify("Traitors Win... But now it's a free-for-all!", messageLength)
                end

                -- Strip all weapons from the ground and players
                for _, ent in pairs(ents.GetAll()) do
                    if (ent.Kind == WEAPON_PISTOL or ent.Kind == WEAPON_HEAVY or ent.Kind == WEAPON_NADE or ent.Base == "weapon_tttbase") then
                        ent:Remove()
                    end
                end

                timer.Simple(messageLength, function()
                    triggerDelay = 0
                    triggerShowdown = true

                    if CR_VERSION then
                        net.Start("PistolsRandomatWinTitle")
                        net.Broadcast()
                    end
                end)
            elseif #alivePlayers == 2 then
                -- If there are only 2 alive players then trigger the randomat
                -- Strip all weapons from the ground and players
                for _, ent in pairs(ents.GetAll()) do
                    if (ent.Kind == WEAPON_PISTOL or ent.Kind == WEAPON_HEAVY or ent.Kind == WEAPON_NADE or ent.Base == "weapon_tttbase") then
                        ent:Remove()
                    end
                end

                triggerDelay = 1
                triggerShowdown = true
                winBlocked = true
            end
        end

        -- Prevent the round from ending while there is more than 1 player alive, and the timer has not run out
        if GetGlobalFloat("ttt_round_end") > CurTime() and #self:GetAlivePlayers() > 1 then return WIN_NONE end
    end)
end

function EVENT:End()
    net.Start("PistolsRemoveHalos")
    net.Broadcast()

    timer.Simple(2, function()
        for i, ply in ipairs(self:GetAlivePlayers()) do
            ply:Give("weapon_zm_improvised")
            ply:Give("weapon_zm_carry")
            ply:Give("weapon_ttt_unarmed")
        end

        for i, ent in ipairs(ents.FindByClass("weapon_ttt_pistol_randomat")) do
            ent:Remove()
        end
    end)
end

Randomat:register(EVENT)