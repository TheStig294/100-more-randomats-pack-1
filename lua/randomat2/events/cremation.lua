local EVENT = {}
EVENT.Title = "Cremation"
EVENT.Description = "Bodies burn after a player dies"
EVENT.id = "cremation"

EVENT.Categories = {"deathtrigger", "rolechange", "smallimpact"}

-- Takes any dead player and returns their ragdoll, else returns false
local function findcorpse(v)
    for _, ent in pairs(ents.FindByClass("prop_ragdoll")) do
        if ent.uqid == v:UniqueID() and IsValid(ent) then return ent or false end
    end
end

function EVENT:Begin()
    local new_traitors = {}

    for _, ply in ipairs(self:GetAlivePlayers()) do
        if Randomat:IsBodyDependentRole(ply) then
            self:StripRoleWeapons(ply)
            local isTraitor = Randomat:SetToBasicRole(ply, "Traitor")

            if isTraitor then
                table.insert(new_traitors, ply)
            end
        end
    end

    -- Send message to the traitor team if new traitors joined
    self:NotifyTeamChange(new_traitors, ROLE_TEAM_TRAITOR)
    SendFullStateUpdate()

    -- After a player dies
    self:AddHook("PostPlayerDeath", function(ply)
        return timer.Simple(2, function()
            -- Find their ragdoll and ignite it
            local corpse = findcorpse(ply)
            corpse:Ignite(20, 10)

            timer.Simple(15, function()
                corpse = findcorpse(ply)

                -- If the round hasn't ended or the ragdoll otherwise hasn't been removed, and the ragdoll hasn't been put out (e.g. placed in water), remove it
                if IsValid(corpse) and corpse:IsOnFire() then
                    corpse:Remove()
                    -- NOTE: Ragdolls on fire can't be searched, this functionality is from the base TTT gamemode
                    -- (Used for the flare gun)
                end
            end)
        end)
    end)
end

-- Checking if someone is a body dependent role and if it isn't at the start of the round, prevent the event from running
function EVENT:Condition()
    local bodyDependentRoleExists = false

    for _, ply in ipairs(self:GetAlivePlayers()) do
        if Randomat:IsBodyDependentRole(ply) then
            bodyDependentRoleExists = true
            break
        end
    end

    return Randomat:GetRoundCompletePercent() < 5 or not bodyDependentRoleExists
end

Randomat:register(EVENT)