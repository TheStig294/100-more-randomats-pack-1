local EVENT = {}
EVENT.Title = "First come, first served!"
EVENT.Description = "Only the 1st person to search a body can see its role"
EVENT.id = "firstsearch"

EVENT.Categories = {"moderateimpact"}

local detectiveSearch = "unset"
local announceBody = "unset"

function EVENT:Begin()
    if ConVarExists("ttt_detective_search_only") then
        if GetConVar("ttt_detective_search_only"):GetBool() then
            self.Description = "Only the 1st person to search a body can see its role, everyone can search!"
        else
            self.Description = "Only the 1st person to search a body can see its role"
        end

        detectiveSearch = GetConVar("ttt_detective_search_only"):GetBool()
        GetConVar("ttt_detective_search_only"):SetBool(false)
        SetGlobalBool("ttt_detective_search_only", false)
    end

    if ConVarExists("ttt_announce_body_found") then
        announceBody = GetConVar("ttt_announce_body_found"):GetBool()
        GetConVar("ttt_announce_body_found"):SetBool(false)
        SetGlobalBool("ttt_announce_body_found", false)
    end

    local ROLE_STRINGS_EXT = ROLE_STRINGS_EXT

    if not istable(ROLE_STRINGS_EXT) then
        ROLE_STRINGS_EXT = {
            [0] = "an Innocent",
            [1] = "a Traitor",
            [2] = "a Detective"
        }
    end

    self:AddHook("TTTCanSearchCorpse", function(ply, body, is_covert, is_long_range, was_traitor)
        if body.RdmtFirstSearch then
            ply:ChatPrint("Already searched! First come, first served!")

            return false
        end

        body.RdmtFirstSearch = true
        local bodyPly = CORPSE.GetPlayer(body)
        ply:ChatPrint("You note that " .. bodyPly:Nick() .. " was a " .. ROLE_STRINGS_EXT[body.was_role])
        ply:PrintMessage(HUD_PRINTCENTER, bodyPly:Nick() .. " was a " .. ROLE_STRINGS_EXT[body.was_role])

        timer.Simple(0.1, function()
            bodyPly:SetNWBool("body_searched", false)
            bodyPly:SetNWBool("body_found", false)
        end)
    end)
end

function EVENT:End()
    if detectiveSearch ~= "unset" then
        GetConVar("ttt_detective_search_only"):SetBool(detectiveSearch)
    end

    if announceBody ~= "unset" then
        GetConVar("ttt_announce_body_found"):SetBool(announceBody)
    end
end

Randomat:register(EVENT)