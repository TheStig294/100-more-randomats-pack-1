local EVENT = {}
EVENT.Title = "Pistols at dawn"
EVENT.Description = "The last players alive have a one-shot pistol showdown!"
EVENT.id = "pistols"

EVENT.Type = {EVENT_TYPE_WEAPON_OVERRIDE, EVENT_TYPE_MUSIC}

EVENT.Categories = {"gamemode", "largeimpact"}

util.AddNetworkString("PistolsPrepareShowdown")
util.AddNetworkString("PistolsBeginShowdown")
util.AddNetworkString("PistolsRandomatWinTitle")
util.AddNetworkString("PistolsEndEvent")
local eventTriggered = false
local triggerShowdown = false

function EVENT:Begin()
    local pistolsTriggerOnce = false
    local triggerDelay = 1
    triggerShowdown = false
    eventTriggered = true

    -- Transform all jesters/independents to innocents so we know there can only be an innocent or traitor win
    for i, ply in ipairs(self:GetAlivePlayers()) do
        if Randomat:IsJesterTeam(ply) or Randomat:IsIndependentTeam(ply) then
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_INNOCENT)
        end
    end

    SendFullStateUpdate()

    self:AddHook("Think", function()
        -- Initial trigger code runs once
        if triggerShowdown then
            if pistolsTriggerOnce == false then
                net.Start("PistolsPrepareShowdown")
                net.Broadcast()

                -- After a delay, trigger a notification and let players see through walls if that randomat is added by another mod,
                timer.Create("PistolsDrawHalos", triggerDelay, 1, function()
                    self:SmallNotify("Draw!")
                    net.Start("PistolsBeginShowdown")
                    net.Broadcast()
                end)
            end

            timer.Simple(triggerDelay, function()
                for i, ply in pairs(self:GetAlivePlayers()) do
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
    local messageDelay = 4

    self:AddHook("TTTCheckForWin", function()
        if not winBlocked then
            local alivePlayers = self:GetAlivePlayers()
            local traitorPlayers = {}
            local innocentPlayers = {}

            for i, ply in ipairs(alivePlayers) do
                if Randomat:IsTraitorTeam(ply) then
                    table.insert(traitorPlayers, ply)
                elseif Randomat:IsInnocentTeam(ply) then
                    table.insert(innocentPlayers, ply)
                end
            end

            if table.IsEmpty(traitorPlayers) or table.IsEmpty(innocentPlayers) or #alivePlayers == 2 then
                winBlocked = true

                if table.IsEmpty(traitorPlayers) then
                    Randomat:SmallNotify("Innocents Win... But now it's a free-for-all!", messageDelay)
                elseif table.IsEmpty(innocentPlayers) then
                    Randomat:SmallNotify("Traitors Win... But now it's a free-for-all!", messageDelay)
                elseif #alivePlayers == 2 then
                    Randomat:SmallNotify("One innocent and traitor remain, it's time for a pistol showdown!", messageDelay)
                end

                -- Strip all weapons from the ground and players
                for _, ent in pairs(ents.GetAll()) do
                    if (ent.Kind == WEAPON_PISTOL or ent.Kind == WEAPON_HEAVY or ent.Kind == WEAPON_NADE or ent.Base == "weapon_tttbase") then
                        ent:Remove()
                    end
                end

                timer.Create("PistolsTriggerShowdown", messageDelay, 1, function()
                    triggerDelay = 4
                    triggerShowdown = true

                    if CR_VERSION then
                        net.Start("PistolsRandomatWinTitle")
                        net.Broadcast()
                    end
                end)
            end
        end

        -- Prevent the round from ending while there is more than 1 player alive, and the timer has not run out
        if GetGlobalFloat("ttt_round_end") > CurTime() and #self:GetAlivePlayers() > 1 then return WIN_NONE end
    end)

    -- Preventing karma from being lost during the showdown
    self:AddHook("TTTKarmaGivePenalty", function()
        if triggerShowdown then return true end
    end)
end

function EVENT:End()
    if eventTriggered then
        eventTriggered = false
        timer.Remove("PistolsTriggerShowdown")
        net.Start("PistolsEndEvent")
        net.Broadcast()

        if triggerShowdown then
            timer.Remove("PistolsDrawHalos")
            timer.Remove("PistolsGivePistols")
        end
    end
end

Randomat:register(EVENT)