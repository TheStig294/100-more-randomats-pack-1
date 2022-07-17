local EVENT = {}
util.AddNetworkString("BanEventTrigger")
util.AddNetworkString("PlayerBannedEvent")
util.AddNetworkString("BanEventEnd")
util.AddNetworkString("BanVoteTrigger")
util.AddNetworkString("BanPlayerVoted")
util.AddNetworkString("BanVoteEnd")

CreateConVar("randomat_ban_choices", 5, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Number of events you can choose from to ban", 2, 5)

CreateConVar("randomat_ban_vote", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Allows all players to vote on the event")

CreateConVar("randomat_ban_votetimer", 10, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "How long players have to vote on the event", 5, 60)

CreateConVar("randomat_ban_deadvotes", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Dead people can vote")

--Stores the last banned randomat so it can be restored after this randomat is triggered again
CreateConVar("randomat_ban_last_banned_randomat", "", FCVAR_ARCHIVE, "The last randomat that was banned, (don't touch), used for the 'Ban an event!' randomat")
local EventChoices = {}
local owner
local EventVotes = {}
local PlayersVoted = {}
local banRandomat = false

local function GetEventDescription()
    local target

    if GetConVar("randomat_ban_vote"):GetBool() then
        target = "vote"
    elseif IsValid(owner) then
        target = owner:Nick()
    else
        target = "someone"
    end

    return "A randomat is to be banned by " .. target .. ", until this randomat triggers again!"
end

EVENT.Title = "Ban a Randomat!"
EVENT.Description = GetEventDescription()
EVENT.id = "ban"
EVENT.Type = EVENT_TYPE_VOTING

EVENT.Categories = {"eventtrigger", "smallimpact"}

function EVENT:Begin()
    banRandomat = true
    owner = self.owner
    EVENT.Description = GetEventDescription()
    EventChoices = {}
    PlayersVoted = {}
    EventVotes = {}
    local x = 0

    for _, v in RandomPairs(Randomat.Events) do
        if x < GetConVar("randomat_ban_choices"):GetInt() then
            if Randomat:CanEventRun(v) and v.id ~= "ban" then
                x = x + 1
                local title = Randomat:GetEventTitle(v)
                EventChoices[x] = title
                EventVotes[title] = 0
            end
        end
    end

    if GetConVar("randomat_ban_vote"):GetBool() then
        net.Start("BanVoteTrigger")
        net.WriteInt(GetConVarNumber("randomat_ban_choices"), 32)
        net.WriteTable(EventChoices)
        net.Broadcast()

        timer.Create("RdmtBanVoteTimer", GetConVar("randomat_ban_votetimer"):GetInt(), 1, function()
            local vts = -1
            local evnt = ""

            for k, v in RandomPairs(EventVotes) do
                if vts < v then
                    vts = v
                    evnt = k
                end
            end

            for _, v in pairs(Randomat.Events) do
                local title = Randomat:GetEventTitle(v)

                if title == evnt then
                    -- Banning this randomat itself triggers a special message
                    -- Will cause it to never trigger again, unless it is manually turned back on through its convar
                    if v.id == "ban" then
                        timer.Simple(7, function()
                            self:SmallNotify("Well, you've done it. This randomat is never triggering again...")
                        end)
                    end

                    -- Turn the last banned randomat back on
                    local lastBan = GetConVar("randomat_ban_last_banned_randomat"):GetString()
                    RunConsoleCommand("ttt_randomat_" .. lastBan, 1)
                    -- Turn the currently banned randomat off
                    RunConsoleCommand("ttt_randomat_" .. v.id, 0)
                    GetConVar("randomat_ban_last_banned_randomat"):SetString(v.id)
                    -- Display a message with the name of the randomat that was banned
                    self:SmallNotify(title .. " is banned.")
                end
            end

            net.Start("BanVoteEnd")
            net.Broadcast()
            EventVotes = {}
        end)
    else
        net.Start("BanEventTrigger")
        net.WriteInt(GetConVarNumber("randomat_ban_choices"), 32)
        net.WriteTable(EventChoices)
        net.Send(owner)
    end
end

function EVENT:End()
    -- Prevent trying to close the popup window if this event has not run (causes an error)
    if banRandomat then
        net.Start("BanEventEnd")
        net.Send(owner)
    end
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"choices", "votetimer"}) do
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

    local checks = {}

    for _, v in pairs({"vote", "deadvoters"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    return sliders, checks
end

net.Receive("PlayerBannedEvent", function()
    local str = net.ReadString()

    for _, v in pairs(Randomat.Events) do
        local title = Randomat:GetEventTitle(v)

        if title == str then
            if v.id == "ban" then
                self:SmallNotify("Very funny... Nothing gets banned then.")
            else
                local lastBan = GetConVar("randomat_ban_last_banned_randomat"):GetString()
                RunConsoleCommand("ttt_randomat_" .. lastBan, 1)
                RunConsoleCommand("ttt_randomat_" .. v.id, 0)
                GetConVar("randomat_ban_last_banned_randomat"):SetString(v.id)
                self:SmallNotify(title .. " is banned.")
            end
        end
    end
end)

net.Receive("BanPlayerVoted", function(ln, ply)
    local t = 0

    for _, v in pairs(PlayersVoted) do
        if v == ply then
            t = 1
        end
    end

    if (ply:Alive() and not ply:IsSpec()) or GetConVar("randomat_ban_deadvoters"):GetBool() then
        if t ~= 1 then
            local str = net.ReadString()
            EventVotes[str] = EventVotes[str] + 1
            net.Start("BanPlayerVoted")
            net.WriteString(str)
            net.Broadcast()
            table.insert(PlayersVoted, ply)
        else
            ply:PrintMessage(HUD_PRINTTALK, "You have already voted.")
        end
    else
        ply:PrintMessage(HUD_PRINTTALK, "Dead players can't vote.")
    end
end)

Randomat:register(EVENT)