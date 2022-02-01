local EVENT = {}

CreateConVar("randomat_battleroyale_radar_time", 120, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Seconds before everyone is given a radar", 5, 240)

EVENT.Title = "LAST ONE STANDING WINS! BATTLE ROYALE!"
EVENT.Description = ""
EVENT.id = "battleroyale"
local alertSound = Sound("battleroyale/alert.mp3")
util.AddNetworkString("RandomatBattleRoyaleWinTitle")
util.AddNetworkString("RandomatBattleRoyaleWinTitleRemove")

function EVENT:Begin()
    local fortniteToolExists = weapons.Get("weapon_ttt_fortnite_building") ~= nil

    if fortniteToolExists then
        EVENT.Description = "Press 'F' to change platform shape"
    end

    -- Plays the Fortnite alert sound as an extra warning this randomat has started
    for i, ply in pairs(self:GetPlayers()) do
        ply:EmitSound(alertSound)
    end

    -- Preventing the round from ending if more than 1 person is alive
    self:AddHook("TTTCheckForWin", function()
        if #self:GetAlivePlayers() > 1 then return WIN_NONE end
    end)

    -- After the set amount of time runs out, (default 2 minutes) everyone is given a radar to prevent camping
    timer.Create("BattleRoyaleRandomatTimer", 1, GetConVar("randomat_battleroyale_radar_time"):GetInt(), function()
        if timer.RepsLeft("BattleRoyaleRandomatTimer") == 0 then
            self:SmallNotify("The circle is shrinking! (Radar activated)")

            for k, ply in pairs(self:GetPlayers()) do
                ply:GiveEquipmentItem(tonumber(EQUIP_RADAR))
                ply:ConCommand("ttt_radar_scan")
                --Also plays the Fortnite alert sound again
                ply:EmitSound(alertSound)
            end
        end
    end)

    -- Disabling giving karma penalties
    self:AddHook("TTTKarmaGivePenalty", function(ply, penalty, victim) return true end)

    -- Giving everyone a Fortnite building tool, if one of its convars is found, and turning everyone into an innocent
    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            if fortniteToolExists then
                ply:Give("weapon_ttt_fortnite_building")
                Randomat:CallShopHooks(false, "weapon_ttt_fortnite_building", ply)
            end

            self:StripRoleWeapons(ply)
            Randomat:SetRole(ply, ROLE_INNOCENT)
            SendFullStateUpdate()
        end)
    end

    if CR_VERSION then
        net.Start("RandomatBattleRoyaleWinTitle")
        net.Broadcast()
    end
end

function EVENT:End()
    -- Removing the radar timer, else everyone will be given a radar next round...
    timer.Remove("BattleRoyaleRandomatTimer")

    -- Also remove the win title hook, else the win title will always be "[Player] WINS!"
    if CR_VERSION then
        net.Start("RandomatBattleRoyaleWinTitleRemove")
        net.Broadcast()
    end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"radar_time"}) do
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