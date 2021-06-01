local EVENT = {}

CreateConVar("randomat_battleroyale_radar_time", 120, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Seconds before everyone is given a radar", 5, 240)

EVENT.Title = "LAST ONE STANDING WINS! BATTLE ROYALE!"
EVENT.Description = "Press 'F' to change platform shape"
EVENT.id = "battleroyale"
local alertSound = Sound("battleroyale/alert.wav")

function EVENT:Begin()
    for i, ply in pairs(player.GetAll()) do
        ply:EmitSound(alertSound)
    end

    hook.Add("TTTCheckForWin", "RandomatBattleRoyalePreventWin", function()
        AlivePlayerCount = 0

        for k, ply in pairs(self:GetAlivePlayers()) do
            AlivePlayerCount = AlivePlayerCount + 1
        end

        if AlivePlayerCount > 1 then return WIN_NONE end
    end)

    timer.Create("BattleRoyaleRandomatTimer", 1, GetConVar("randomat_battleroyale_radar_time"):GetInt(), function()
        if timer.RepsLeft("BattleRoyaleRandomatTimer") == 0 then
            self:SmallNotify("Radar activated, you're traitors so the radar works.")

            for k, ply in pairs(player.GetAll()) do
                Randomat:SetRole(ply, ROLE_TRAITOR)
                SendFullStateUpdate()
                ply:SetCredits(0)
                ply:GiveEquipmentItem(tonumber(EQUIP_RADAR))
                ply:ConCommand("ttt_radar_scan")
                ply:EmitSound(alertSound)
            end
        end
    end)

    hook.Add("TTTKarmaGivePenalty", "RandomatBattleroyaleNoKarma", function(ply, penalty, victim) return true end)

    for i, ply in pairs(self:GetAlivePlayers()) do
        timer.Simple(0.1, function()
            if ConVarExists("fortnite_low_res_textures") then
                ply:Give("weapon_ttt_fortnite_building")
            end

            Randomat:SetRole(ply, ROLE_INNOCENT)
            SendFullStateUpdate()
            self:StripRoleWeapons(ply)
        end)
    end
end

function EVENT:End()
    hook.Remove("TTTCheckForWin", "RandomatBattleRoyalePreventWin")
    hook.Remove("TTTKarmaGivePenalty", "RandomatBattleroyaleNoKarma")
    timer.Remove("BattleRoyaleRandomatTimer")
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