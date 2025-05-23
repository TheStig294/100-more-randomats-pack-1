-- Randomat base code from Malivil's randomat mod
-- Does not run if a convar added by Malivil's randomat mod is detected to ensure a potentially newer version of the randomat base isn't overridden
if SERVER and file.Exists("randomat2/randomat_shared.lua", "lsv") then
    if not GetGlobalBool("DisableStigRandomatBase") then
        print("[TTT 100 More Randomats!] Randomat 2.0 for Custom Roles Detected! Using its randomat base instead")
    end

    SetGlobalBool("DisableStigRandomatBase", true)
    -- Running check on both client and server as the global bool isn't networked quickly enough
elseif CLIENT and file.Exists("randomat2/randomat_shared.lua", "lcl") then
    if not GetGlobalBool("DisableStigRandomatBase") then
        print("[TTT 100 More Randomats!] Randomat 2.0 for Custom Roles Detected! Using its randomat base instead")
    end

    SetGlobalBool("DisableStigRandomatBase", true)
end

if GetGlobalBool("DisableStigRandomatBase", false) then return end
if engine.ActiveGamemode() ~= "terrortown" then return end
Randomat = Randomat or {}
local concommand = concommand
local file = file
local hook = hook
local ipairs = ipairs
local math = math
local pairs = pairs
local CallHook = hook.Call

local function AddServer(fil)
    if SERVER then
        include(fil)
    end
end

local function AddClient(fil)
    if SERVER then
        AddCSLuaFile(fil)
    end

    if CLIENT then
        include(fil)
    end
end

local auto = CreateConVar("ttt_randomat_auto", 0, FCVAR_REPLICATED, "Whether the Randomat should automatically trigger on round start.")
CreateConVar("ttt_randomat_allow_client_list", 1, FCVAR_REPLICATED, "Whether to allow the client to view the list of active events.")

if SERVER then
    concommand.Add("ttt_randomat_disableall", function(ply, cc, arg)
        for _, v in pairs(Randomat.Events) do
            GetConVar("ttt_randomat_" .. v.Id):SetBool(false)
        end

        CallHook("TTTRandomatCommand", nil, ply, cc, arg)
    end)

    concommand.Add("ttt_randomat_enableall", function(ply, cc, arg)
        for _, v in pairs(Randomat.Events) do
            GetConVar("ttt_randomat_" .. v.Id):SetBool(true)
        end

        CallHook("TTTRandomatCommand", nil, ply, cc, arg)
    end)

    concommand.Add("ttt_randomat_resetweights", function(ply, cc, arg)
        for _, v in pairs(Randomat.Events) do
            GetConVar("ttt_randomat_" .. v.Id .. "_weight"):SetInt(-1)
        end

        CallHook("TTTRandomatCommand", nil, ply, cc, arg)
    end)

    local auto_min_rounds = CreateConVar("ttt_randomat_auto_min_rounds", 0, FCVAR_NONE, "The minimum number of completed rounds before auto-Randomat can trigger.")
    local auto_chance = CreateConVar("ttt_randomat_auto_chance", 1, FCVAR_NONE, "Chance of the auto-Randomat triggering.")
    local auto_choose = CreateConVar("ttt_randomat_auto_choose", 0, FCVAR_NONE, "Whether the auto-started event is always \"choose\"")
    local auto_silent = CreateConVar("ttt_randomat_auto_silent", 0, FCVAR_NONE, "Whether the auto-started event should be silent.")
    CreateConVar("ttt_randomat_rebuyable", 0, FCVAR_NONE, "Whether you can buy more than one Randomat.")
    CreateConVar("ttt_randomat_event_weight", 1, FCVAR_NONE, "The default selection weight each event should use.", 1)
    CreateConVar("ttt_randomat_event_hint", 1, FCVAR_NONE, "Whether the Randomat should print what each event does when they start.")
    CreateConVar("ttt_randomat_event_hint_chat", 1, FCVAR_NONE, "Whether hints should also be put in chat.")
    CreateConVar("ttt_randomat_event_history", 10, FCVAR_NONE, "How many events to keep in history to prevent duplication.")
    local always_trigger = CreateConVar("ttt_randomat_always_silently_trigger", "", FCVAR_NONE, "Specify an event to always trigger silently at the start of each round.")
    CreateConVar("ttt_randomat_event_hint_chat_secret", 0, FCVAR_NONE, "Whether the secret events that triggered during a round should be displayed in chat at round end.")

    hook.Add("TTTBeginRound", "AutoRandomat", function()
        local rounds_complete = Randomat:GetRoundsComplete()
        local min_rounds = auto_min_rounds:GetInt()
        local should_auto = auto:GetBool() and math.random() <= auto_chance:GetFloat() and (min_rounds <= 0 or rounds_complete >= min_rounds)
        local new_auto = hook.Call("TTTRandomatShouldAuto", nil, should_auto)

        if type(new_auto) == "boolean" then
            should_auto = new_auto
        end

        if should_auto then
            local silent = auto_silent:GetBool()

            if auto_choose:GetBool() then
                if silent then
                    Randomat:SilentTriggerEvent("choose", nil)
                else
                    Randomat:TriggerEvent("choose", nil)
                end
            else
                if silent then
                    Randomat:SilentTriggerRandomEvent(nil)
                else
                    Randomat:TriggerRandomEvent(nil)
                end
            end
        end

        local always_trigger_event = always_trigger:GetString()

        if always_trigger_event ~= "" and not Randomat:IsEventActive(always_trigger_event) then
            Randomat:SilentTriggerEvent(always_trigger_event)
        end
    end)

    -- Per The Stig's research, this happens before the server.cfg is loaded so anything we load from the .json will be overwritten by that
    hook.Add("InitPostEntity", "Randomat_LoadConVars_InitPostEntity", function()
        if not file.IsDir("randomat", "DATA") then
            file.CreateDir("randomat")
        elseif file.Exists("randomat/convars.json", "DATA") then
            local convarsJson = file.Read("randomat/convars.json", "DATA")
            if not convarsJson then return end
            local convars = util.JSONToTable(convarsJson)
            if not convars then return end

            for name, value in pairs(convars) do
                local convar = GetConVar(name)
                if not convar then continue end
                convar:SetString(value)
            end
        end
    end)

    local function GetConVarValues(tbl, convars, prefix)
        if not convars then return end

        for _, name in ipairs(convars) do
            if name.cmd then
                name = name.cmd
            end

            if prefix then
                name = prefix .. name
            end

            local convar = GetConVar(name)
            if not convar then continue end
            local value = convar:GetString()
            -- Don't bother saving the default value because that will just use up more space
            -- and make it difficult for us to change defaults in the future
            if value == convar:GetDefault() then continue end
            tbl[name] = value
        end
    end

    hook.Add("ShutDown", "Randomat_SaveConVars_ShutDown", function()
        local convars = {}
        -- Start with the shared convars
        GetConVarValues(convars, Randomat.ConVars)

        for _, evt in pairs(Randomat.Events) do
            -- Get any saved into the convars table
            GetConVarValues(convars, evt.ConVars)
            -- And just in case, get the ones defined for ULX too
            local sliders, checks, textboxes = evt:GetConVars()
            GetConVarValues(convars, sliders, "randomat_" .. evt.id .. "_")
            GetConVarValues(convars, checks, "randomat_" .. evt.id .. "_")
            GetConVarValues(convars, textboxes, "randomat_" .. evt.id .. "_")
        end

        local convarsJson = util.TableToJSON(convars)
        if not convarsJson then return end
        file.Write("randomat/convars.json", convarsJson)
    end)
end

AddServer("randomat2/randomat_base_stig.lua")
AddServer("randomat2/randomat_shared_stig.lua")
AddClient("randomat2/randomat_shared_stig.lua")
AddClient("randomat2/cl_randomat_base_stig.lua")
AddClient("randomat2/cl_message_stig.lua")
local files, _ = file.Find("randomat2/events/*.lua", "LUA")

for _, fil in ipairs(files) do
    AddServer("randomat2/events/" .. fil)
end

local clientfiles, _ = file.Find("randomat2/cl_events/*.lua", "LUA")

for _, fil in ipairs(clientfiles) do
    AddClient("randomat2/cl_events/" .. fil)
end

local sharedfiles, _ = file.Find("randomat2/sh_events/*.lua", "LUA")

for _, fil in ipairs(sharedfiles) do
    AddServer("randomat2/sh_events/" .. fil)
    AddClient("randomat2/sh_events/" .. fil)
end