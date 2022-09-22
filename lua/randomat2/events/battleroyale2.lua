local EVENT = {}

CreateConVar("randomat_battleroyale2_radar_time", 120, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Seconds before everyone is given a radar", 5, 240)

CreateConVar("randomat_battleroyale2_music", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Play victory royale music when someone wins", 0, 1)

EVENT.Title = "LAST *PAIR* ALIVE WINS! Duos battle royale!"
EVENT.ExtDescription = "Everyone is turned into an innocent, and turns the game into a duos free-for-all!"
EVENT.id = "battleroyale2"

EVENT.Categories = {"gamemode", "largeimpact"}

local alertSound = Sound("battleroyale/alert.mp3")
util.PrecacheSound("battleroyale/fortnite_victory_royale.mp3")
util.AddNetworkString("RandomatBattleroyale2Begin")
util.AddNetworkString("RandomatBattleroyale2End")

function EVENT:Begin()
    local fortniteToolExists = weapons.Get("weapon_ttt_fortnite_building") ~= nil
    local plys = self:GetPlayers(true)
    local partners = {}
    local partnerIndex = 0

    -- Plays the Fortnite alert sound as an extra warning this randomat has started
    -- and puts players into pairs
    for _, ply in ipairs(plys) do
        ply:EmitSound(alertSound, 100, 120)

        for _, ply2 in ipairs(plys) do
            if ply:GetNWEntity("BattleRoyalePartner") ~= NULL then break end
            if ply2:GetNWEntity("BattleRoyalePartner") ~= NULL or ply2 == ply then continue end
            partnerIndex = partnerIndex + 1

            partners[partnerIndex] = {ply, ply2}

            ply:SetNWEntity("BattleRoyalePartner", ply2)
            ply2:SetNWEntity("BattleRoyalePartner", ply)
            ply:ChatPrint("Your partner is: " .. ply2:Nick())
            ply2:ChatPrint("Your partner is: " .. ply:Nick())
        end

        if ply:GetNWEntity("BattleRoyalePartner") == NULL then
            ply:ChatPrint("You don't have a partner :(")
        end
    end

    -- Preventing the round from ending if more than 1 person is alive
    self:AddHook("TTTCheckForWin", function()
        local alivePlys = self:GetAlivePlayers()
        -- If there are 2 players left and they're on the same team then they win
        if #alivePlys == 2 and alivePlys[1]:GetNWEntity("BattleRoyalePartner") == alivePlys[2] then return WIN_INNOCENT end
        -- Else, block any win while there is more than 1 player alive
        if #self:GetAlivePlayers() > 1 then return WIN_NONE end
    end)

    -- After the set amount of time runs out, (default 2 minutes) everyone is given a radar to prevent camping
    timer.Create("Battleroyale2RandomatTimer", 1, GetConVar("randomat_battleroyale2_radar_time"):GetInt(), function()
        if timer.RepsLeft("Battleroyale2RandomatTimer") == 0 then
            self:SmallNotify("The circle is shrinking! (Radar activated)")

            for k, ply in pairs(self:GetPlayers()) do
                ply:GiveEquipmentItem(tonumber(EQUIP_RADAR))
                ply:ConCommand("ttt_radar_scan")
                --Also plays the Fortnite alert sound again
                ply:EmitSound(alertSound, 100, 120)
            end
        end
    end)

    -- Disabling giving karma penalties
    self:AddHook("TTTKarmaGivePenalty", function(ply, penalty, victim) return true end)

    -- Disabling damage on your partner
    self:AddHook("EntityTakeDamage", function(ent, dmg)
        local attacker = dmg:GetAttacker()
        if not IsPlayer(ent) or not IsPlayer(attacker) then return end

        if attacker == ent:GetNWEntity("BattleRoyalePartner") then
            attacker:PrintMessage(HUD_PRINTCENTER, "Don't hurt your buddy!")

            return true
        end
    end)

    -- Giving everyone a Fortnite building tool, if one of its convars is found, and turning everyone into an innocent
    for i, ply in pairs(self:GetAlivePlayers()) do
        if fortniteToolExists then
            ply:Give("weapon_ttt_fortnite_building")
        end

        self:StripRoleWeapons(ply)
        Randomat:SetRole(ply, ROLE_INNOCENT)
    end

    SendFullStateUpdate()
    net.Start("RandomatBattleroyale2Begin")
    net.WriteBool(CR_VERSION ~= nil)
    net.WriteBool(GetConVar("randomat_battleroyale2_music"):GetBool())
    net.Broadcast()

    -- Disable round end sounds and 'Ending Flair' event so victory royale music can play
    if GetConVar("randomat_battleroyale2_music"):GetBool() then
        DisableRoundEndSounds()
    end
end

function EVENT:End()
    -- Removing the radar timer, else everyone will be given a radar next round...
    timer.Remove("Battleroyale2RandomatTimer")
    -- Also remove the win title hook, else the win title will always be "[Player] WINS!"
    net.Start("RandomatBattleroyale2End")
    net.Broadcast()

    for _, ply in ipairs(player.GetAll()) do
        ply:SetNWEntity("BattleRoyalePartner", NULL)
    end
end

Randomat:register(EVENT)