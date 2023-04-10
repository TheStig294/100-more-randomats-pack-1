local EVENT = {}
EVENT.Title = "Pistols at dawn"
EVENT.Description = "The last players alive have a one-shot pistol showdown!"
EVENT.id = "pistols"

EVENT.Type = {EVENT_TYPE_WEAPON_OVERRIDE, EVENT_TYPE_MUSIC}

EVENT.Categories = {"gamemode", "rolechange", "largeimpact"}

local musicCvar = CreateConVar("randomat_pistols_music", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether music is enabled during showdown", 0, 1)

util.AddNetworkString("PistolsPrepareShowdown")
util.AddNetworkString("PistolsBeginShowdown")
util.AddNetworkString("PistolsRandomatWinTitle")
util.AddNetworkString("PistolsEndEvent")

function EVENT:HandleRoleWeapons(ply)
    local updated = false
    local changing_teams = Randomat:IsMonsterTeam(ply) or Randomat:IsIndependentTeam(ply)

    -- Convert all bad guys to traitors so we don't have to worry about fighting with special weapon replacement logic
    if (Randomat:IsTraitorTeam(ply) and ply:GetRole() ~= ROLE_TRAITOR) or changing_teams then
        Randomat:SetRole(ply, ROLE_TRAITOR)
        updated = true
    elseif Randomat:IsJesterTeam(ply) then
        Randomat:SetRole(ply, ROLE_INNOCENT)
        updated = true
    end

    -- Remove role weapons from anyone on the traitor team now
    if Randomat:IsTraitorTeam(ply) then
        self:StripRoleWeapons(ply)
    end

    return updated, changing_teams
end

local eventTriggered = false
local triggerShowdown = false

function EVENT:Begin()
    local pistolsTriggerOnce = false
    local triggerDelay = 1
    triggerShowdown = false
    eventTriggered = true
    -- Transform all jesters to innocents and independents to traitors so we know there can only be an innocent or traitor win
    local new_traitors = {}

    for _, v in ipairs(self:GetAlivePlayers()) do
        local _, new_traitor = self:HandleRoleWeapons(v)

        if new_traitor then
            table.insert(new_traitors, v)
        end
    end

    SendFullStateUpdate()
    self:NotifyTeamChange(new_traitors, ROLE_TEAM_TRAITOR)

    timer.Create("PistolsRoleChangeTimer", 1, 0, function()
        local updated = false
        new_traitors = {}

        for _, ply in ipairs(self:GetAlivePlayers()) do
            -- Workaround the case where people can respawn as Zombies while this is running
            updatedPly, new_traitor = self:HandleRoleWeapons(ply)
            updated = updated or updatedPly

            if new_traitor then
                table.insert(new_traitors, ply)
            end
        end

        -- If anyone's role changed, send the update
        -- If anyone became a traitor, notify all other traitors
        if updated then
            SendFullStateUpdate()
            self:NotifyTeamChange(new_traitors, ROLE_TEAM_TRAITOR)
        end
    end)

    self:DisableRoundEndSounds()

    self:AddHook("Think", function()
        -- Initial trigger code runs once
        if triggerShowdown then
            if pistolsTriggerOnce == false then
                net.Start("PistolsPrepareShowdown")
                net.WriteBool(musicCvar:GetBool())
                net.Broadcast()

                -- After a delay, trigger a notification and let players see through walls if that randomat is added by another mod,
                timer.Create("PistolsDrawHalos", triggerDelay, 1, function()
                    self:SmallNotify("Draw!")
                    -- Forcing the area around all players to load so player halos always work
                    self:AddCullingBypass()
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
                -- Let players turn into zombies first so we can change them into traitors properly
                if ply.IsZombifying and ply:IsZombifying() then
                    return WIN_NONE
                elseif Randomat:IsTraitorTeam(ply) then
                    table.insert(traitorPlayers, ply)
                elseif Randomat:IsInnocentTeam(ply) then
                    table.insert(innocentPlayers, ply)
                end
            end

            if table.IsEmpty(traitorPlayers) or table.IsEmpty(innocentPlayers) or #innocentPlayers + #traitorPlayers == 2 or #alivePlayers == 2 then
                winBlocked = true
                new_traitors = {}

                -- Check if anyone's roles need to be changed one last time and remove the timer so people aren't given crowbars by the self:StripRoleWeapons() call
                for _, v in ipairs(self:GetAlivePlayers()) do
                    _, new_traitor = self:HandleRoleWeapons(v)

                    if new_traitor then
                        table.insert(new_traitors, v)
                    end
                end

                SendFullStateUpdate()
                self:NotifyTeamChange(new_traitors, ROLE_TEAM_TRAITOR)
                timer.Remove("PistolsRoleChangeTimer")
                local oneOnOneShowdown = false

                if table.IsEmpty(traitorPlayers) then
                    Randomat:SmallNotify("Innocents Win... But now it's a free-for-all!", messageDelay)
                elseif table.IsEmpty(innocentPlayers) then
                    Randomat:SmallNotify("Traitors Win... But now it's a free-for-all!", messageDelay)
                elseif #alivePlayers == 2 then
                    Randomat:SmallNotify("One innocent and traitor remain, it's time for a pistol showdown!", messageDelay)
                    oneOnOneShowdown = true
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

                    -- Don't modify the win screen if it's a one-on-one showdown as neither team has one yet
                    if CR_VERSION and not oneOnOneShowdown then
                        net.Start("PistolsRandomatWinTitle")
                        net.Broadcast()
                    end
                end)
            end
        end

        -- Prevent the round from ending while there is more than 1 player alive, and the timer has not run out
        if GetGlobalFloat("ttt_round_end") > CurTime() then
            local nonJesterCount = 0

            for _, ply in ipairs(self:GetAlivePlayers()) do
                if not Randomat:IsJesterTeam(ply) then
                    nonJesterCount = nonJesterCount + 1
                end
            end

            if nonJesterCount > 1 then return WIN_NONE end
        end
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
        timer.Remove("PistolsRoleChangeTimer")
        net.Start("PistolsEndEvent")
        net.Broadcast()

        if triggerShowdown then
            timer.Remove("PistolsDrawHalos")
            timer.Remove("PistolsGivePistols")

            timer.Simple(5, function()
                for i, ent in ipairs(ents.FindByClass("weapon_ttt_pistol_randomat")) do
                    ent:Remove()
                end

                for i, ply in ipairs(self:GetAlivePlayers()) do
                    ply:Give("weapon_zm_improvised")
                    ply:Give("weapon_zm_carry")
                    ply:Give("weapon_ttt_unarmed")
                end
            end)
        end
    end
end

function EVENT:GetConVars()
    local checks = {}

    for _, v in pairs({"music"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return {}, checks
end

Randomat:register(EVENT)