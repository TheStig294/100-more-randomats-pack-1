local EVENT = {}
EVENT.Title = "Team Deathmatch"
EVENT.Description = "1/2 detectives, 1/2 traitors"
EVENT.id = "deathmatch"

EVENT.Categories = {"gamemode", "rolechange", "largeimpact"}

function EVENT:Begin()
    -- Randomly for all alive players,
    for i, ply in pairs(self:GetAlivePlayers(true)) do
        if (i % 2) == 0 then
            -- Set half of all players to detectives
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_DETECTIVE)
            -- Remove their credits
            ply:SetCredits(0)
        else
            -- Set the rest to traitors
            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_TRAITOR)
            -- Remove their credits
            ply:SetCredits(0)
        end
    end

    SendFullStateUpdate()
end

Randomat:register(EVENT)