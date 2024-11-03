local function CheckForPlayer(arg1, arg2)
    local ply = false

    if GetGlobalString("MakeRandomatCause", "") == "near" then
        if IsValid(arg1) and arg1:IsPlayer() and IsValid(arg2) and arg2:IsPlayer() then
            ply = arg1
        end
    else
        if IsValid(arg1) and arg1:IsPlayer() then
            ply = arg1
        elseif IsValid(arg2) and arg2:IsPlayer() then
            ply = arg2
        end
    end

    return ply
end

-- All of the possible randomat triggers
local Causes = {}

Causes.death = {
    ["id"] = "death",
    ["Hooks"] = {"DoPlayerDeath", "TTTOnCorpseCreated"},
    ["Desc"] = "After you die"
}

Causes.near = {
    ["id"] = "near",
    ["Hooks"] = {"ShouldCollide"},
    ["Desc"] = "After you're near a player"
}

Causes.buy = {
    ["id"] = "buy",
    ["Hooks"] = {"TTTOrderedEquipment"},
    ["Desc"] = "After you buy something"
}

Causes.damage = {
    ["id"] = "damage",
    ["Hooks"] = {"PostEntityTakeDamage"},
    ["Desc"] = "After you take damage"
}

Causes.weapon = {
    ["id"] = "weapon",
    ["Hooks"] = {"PlayerSwitchWeapon"},
    ["Desc"] = "After you switch weapons"
}

Causes.chat = {
    ["id"] = "chat",
    ["Hooks"] = {"PlayerSay"},
    ["Desc"] = "After you send a chat message"
}

Causes.footstep = {
    ["id"] = "footstep",
    ["Hooks"] = {"PlayerFootstep"},
    ["Desc"] = "After you walk"
}

Causes.bodysearch = {
    ["id"] = "bodysearch",
    ["Hooks"] = {"TTTCanSearchCorpse"},
    ["Desc"] = "After you search a body"
}

-- All of the possible effects a custom randomat cause can be paired with
local Effects = {}

Effects.sound = {
    ["id"] = "sound",
    ["Desc"] = "you make a sound (on a cooldown)",
    ["Functions"] = {
        function(arg1, arg2)
            local ply = CheckForPlayer(arg1, arg2)
            if not ply then return end
            if ply.MakeRandomatSoundCooldown then return end

            timer.Create("MakeRandomatSoundPlayCooldown" .. ply:EntIndex(), 0.1, 1, function()
                local randomNum = math.random()

                if randomNum < 0.33 then
                    ply:EmitSound("make/villager.mp3")
                elseif randomNum < 0.66 then
                    ply:EmitSound("make/villager2.mp3")
                else
                    ply:EmitSound("make/villager3.mp3")
                end
            end)

            ply.MakeRandomatSoundCooldown = true

            timer.Create("MakeRandomatSoundCooldown" .. ply:EntIndex(), 10, 1, function()
                ply.MakeRandomatSoundCooldown = false
            end)
        end
    }
}

Effects.bighead = {
    ["id"] = "bighead",
    ["Desc"] = "your head gets bigger",
    ["Functions"] = {
        function(arg1, arg2)
            local ply = CheckForPlayer(arg1, arg2)
            if not ply then return end
            local mult = 1.2

            if ply.HeadScale then
                mult = ply.HeadScale + 0.2
            end

            local scale = Vector(mult, mult, mult)
            local boneId = ply:LookupBone("ValveBiped.Bip01_Head1")

            if boneId ~= nil then
                ply:ManipulateBoneScale(boneId, scale)
                ply.HeadScale = mult
            end
        end,
        function(arg1)
            if IsValid(arg1) then
                timer.Simple(0.1, function()
                    local ent = arg1
                    local ply = CORPSE.GetPlayer(ent)
                    if not IsPlayer(ply) then return end
                    local mult = ply.HeadScale or 1.2
                    local scale = Vector(mult, mult, mult)
                    local boneId = ent:LookupBone("ValveBiped.Bip01_Head1")

                    if boneId ~= nil then
                        ent:ManipulateBoneScale(boneId, scale)
                        ent.HeadScale = mult
                    end
                end)
            end
        end
    },
    ["Reset"] = function()
        for _, ply in player.Iterator() do
            ply.HeadScale = 1
        end
    end
}

Effects.randomat = {
    ["id"] = "randomat",
    ["Desc"] = "a randomat triggers! (Once per player)",
    ["Functions"] = {
        function(arg1, arg2)
            local ply = CheckForPlayer(arg1, arg2)
            if not ply then return end
            if not Randomat then return end
            if not Randomat.TriggerRandomEvent then return end
            -- Add a hard cap to the number of randomats that can be active at once before triggering another
            if Randomat.ActiveEvents and #Randomat.ActiveEvents > 10 then return end
            if ply.MakeRandomatEffectTriggered then return end
            Randomat:TriggerRandomEvent()
            ply.MakeRandomatEffectTriggered = true
        end
    },
    ["Reset"] = function()
        for _, ply in player.Iterator() do
            ply.MakeRandomatEffectTriggered = false
        end
    end
}

Effects.fling = {
    ["id"] = "fling",
    ["Desc"] = "you get flung away! (On a cooldown)",
    ["Functions"] = {
        function(arg1, arg2)
            local ply = CheckForPlayer(arg1, arg2)
            if not ply then return end
            if ply.MakeLaunchRandomatCooldown then return end
            local pos = ply:GetPos()
            pos.z = pos.z + 10
            ply:SetPos(pos)
            local velocity = Vector(1000, 1000, 1000)
            local randX = math.random()

            if randX < 0.33 then
                velocity.x = -1000
            elseif randX < 0.66 then
                velocity.x = 0
            end

            local randY = math.random()

            if randY < 0.33 then
                velocity.y = -1000
            elseif randY < 0.66 then
                velocity.y = 0
            end

            ply:SetVelocity(velocity)
            ply:EmitSound("make/cartoon_fling_sound.mp3")
            ply.MakeLaunchRandomatCooldown = true

            timer.Create("MakeLaunchRandomatCooldown" .. ply:EntIndex(), 10, 1, function()
                ply.MakeLaunchRandomatCooldown = false
            end)
        end
    }
}

Effects.speed = {
    ["id"] = "speed",
    ["Desc"] = "your speed is randomly changed!",
    ["Functions"] = {
        function(arg1, arg2)
            local ply = CheckForPlayer(arg1, arg2)
            if not ply then return end
            local mult = math.random() * 2 + 0.2
            -- These are the values TTT sets by default whenever a player respawns
            -- I found them in player_ext.lua inside plymeta:InitialSpawn()
            ply:SetCrouchedWalkSpeed(0.3 * mult)
            ply:SetRunSpeed(220 * mult)
            ply:SetWalkSpeed(220 * mult)
            ply:SetMaxSpeed(220 * mult)
        end
    },
    ["Reset"] = function()
        for _, ply in player.Iterator() do
            ply:SetCrouchedWalkSpeed(0.3)
            ply:SetRunSpeed(220)
            ply:SetWalkSpeed(220)
            ply:SetMaxSpeed(220)
        end
    end
}

local models

Effects.model = {
    ["id"] = "model",
    ["Desc"] = "you randomly change playermodel (On a cooldown)",
    ["Functions"] = {
        function(arg1, arg2)
            local ply = CheckForPlayer(arg1, arg2)
            if not ply then return end
            if ply.MakeModelRandomatCooldown then return end

            if not models then
                models = list.Get("PlayerOptionsModel")
            end

            FindMetaTable("Entity").SetModel(ply, table.Random(models))
            ply.MakeModelRandomatCooldown = true

            timer.Create("MakeModelRandomatCooldown" .. ply:EntIndex(), 10, 1, function()
                ply.MakeModelRandomatCooldown = false
            end)
        end
    }
}

Effects.health = {
    ["id"] = "health",
    ["Desc"] = "your health is randomly changed",
    ["Functions"] = {
        function(arg1, arg2)
            local ply = CheckForPlayer(arg1, arg2)
            if not ply then return end
            ply:SetHealth(math.random(100))
        end
    }
}

Effects.meme = {
    ["id"] = "meme",
    ["Desc"] = "you see a random meme (On a cooldown)",
    ["Functions"] = {
        function(arg1, arg2)
            local ply = CheckForPlayer(arg1, arg2)
            if not ply then return end
            if ply.MakeMemeRandomatCooldown then return end
            net.Start("randomat_message")
            net.WriteBool(false)
            -- StigMemeASCII table is found in lua/autorun/stig_meme_ascii.lua
            net.WriteString(StigMemeASCII[math.random(#StigMemeASCII)])
            net.WriteUInt(5, 8)
            net.WriteColor(Color(255, 200, 0, 255), true)
            net.Send(ply)
            ply.MakeMemeRandomatCooldown = true

            timer.Create("MakeMemeRandomatCooldown" .. ply:EntIndex(), 10, 1, function()
                ply.MakeMemeRandomatCooldown = false
            end)
        end
    }
}

CreateConVar("randomat_make_choices", 5, FCVAR_ARCHIVE, "No. of causes/effects you can choose from at once", 2, 8)
CreateConVar("randomat_make_timer", 20, FCVAR_ARCHIVE, "Seconds you have to choose a cause or effect", 20, 60)
CreateConVar("randomat_make_while_dead", 1, FCVAR_ARCHIVE, "Dead players can be chosen to make a randomat")

-- Dynamically creating convars to enable/disable individual causes and effects
for id, cause in pairs(Causes) do
    cause.Convar = CreateConVar("randomat_make_cause_" .. id, 1, FCVAR_ARCHIVE, "\"" .. cause.Desc .. "\" cause")
end

for id, effect in pairs(Effects) do
    effect.Convar = CreateConVar("randomat_make_effect_" .. id, 1, FCVAR_ARCHIVE, "\"" .. effect.Desc .. "\" effect")
end

local owner

local function GetEventDescription()
    local target

    if IsValid(owner) then
        target = owner:Nick()
    else
        target = "Someone"
    end

    return target .. " gets to make their own randomat!"
end

local EVENT = {}
EVENT.Title = "Make a Randomat!"
EVENT.Description = GetEventDescription()
EVENT.id = "make"
EVENT.Type = EVENT_TYPE_VOTING

EVENT.Categories = {"eventtrigger", "modelchange", "largeimpact"}

util.AddNetworkString("MakeRandomatTrigger")
util.AddNetworkString("PlayerMadeRandomat")
util.AddNetworkString("MakeRandomatEnd")
local makeRandomat = false
local activeCustomRandomats = {}
local customRandomatResets = {}

function EVENT:Begin()
    makeRandomat = true
    -- If someone bought a randomat and triggered this event, they get to be the one to make a randomat
    owner = self.owner

    -- else, a random player is chosen, possibly a dead player if that is enabled
    if not IsPlayer(owner) then
        local plys

        if GetConVar("randomat_make_while_dead"):GetBool() then
            plys = player.GetAll()
            table.Shuffle(plys)
        else
            plys = self:GetAlivePlayers(true)
        end

        for _, ply in ipairs(plys) do
            if IsPlayer(ply) then
                owner = ply
                break
            end
        end
    end

    -- Update this event's description with the name of the chosen player
    EVENT.Description = GetEventDescription()
    -- Begin the event on the chosen player
    net.Start("MakeRandomatTrigger")
    net.WriteInt(GetConVar("randomat_make_choices"):GetInt(), 8)
    net.WriteInt(GetConVar("randomat_make_timer"):GetInt(), 8)
    -- Sending over which causes and effects are enabled to the player
    -- Have to tell the client how many causes to loop over
    net.WriteInt(table.Count(Causes), 8)

    for id, cause in pairs(Causes) do
        net.WriteString(id)
        net.WriteString(cause.Desc)
        net.WriteBool(cause.Convar:GetBool())
    end

    -- Have to tell the client how many effects to loop over
    net.WriteInt(table.Count(Effects), 8)

    for id, effect in pairs(Effects) do
        net.WriteString(id)
        net.WriteString(effect.Desc)
        net.WriteBool(effect.Convar:GetBool())
    end

    net.Send(owner)

    -- For enabling the "ShouldCollide" hook to work as a randomat cause
    for _, ply in player.Iterator() do
        ply:SetCustomCollisionCheck(true)
    end

    net.Receive("PlayerMadeRandomat", function(len, msgPly)
        -- Simple check this function is not being exploited from spam client messages as it is quite expensive
        if not IsValid(owner) or msgPly ~= owner then return end
        local causeID = net.ReadString()
        local effectID = net.ReadString()
        local randomatName = net.ReadString()
        local cause = Causes[causeID]
        local effect = Effects[effectID]
        SetGlobalString("MakeRandomatCause", causeID)

        -- The magic of the dynamic randomat,
        -- dynamically creates all the hooks needed for the specific combination of a randomat's cause and effect
        for index, hookName in ipairs(cause.Hooks) do
            -- If an effect has less functions than a cause has hooks, only apply as many hooks as an effect has functions, in order of the hooks listed in the cause
            if not effect.Functions[index] then break end
            local hookID = hookName .. cause.id
            hook.Add(hookName, hookID, function(...) return effect.Functions[index](...) end)
            activeCustomRandomats[hookID] = hookName

            if effect.Reset then
                table.insert(customRandomatResets, effect.Reset)
            end
        end

        -- Displays the randomat's yellow-and-black message for everyone
        -- Displays the name
        local randomatDesc = cause.Desc .. ", " .. effect.Desc
        net.Start("randomat_message")
        net.WriteBool(true)
        net.WriteString(randomatName)
        net.WriteUInt(5, 8)
        net.WriteColor(Color(255, 200, 0, 255), true)
        net.Broadcast()

        -- Displays the description
        timer.Simple(0, function()
            net.Start("randomat_message_silent")
            net.WriteBool(false)
            net.WriteString(randomatDesc)
            net.WriteUInt(5, 8)
            net.WriteColor(Color(255, 200, 0, 255), true)
            net.Broadcast()
        end)

        PrintMessage(HUD_PRINTTALK, "[RANDOMAT] " .. randomatName .. " | " .. randomatDesc)

        -- Force-close the make a randomat window, in case it doesn't close by itself
        timer.Simple(0.1, function()
            net.Start("MakeRandomatEnd")
            net.Send(owner)
        end)
    end)
end

function EVENT:End()
    -- Prevent trying to close the popup window if this event has not run (causes an error)
    if makeRandomat then
        net.Start("MakeRandomatEnd")
        net.Send(owner)

        for hookID, hookType in pairs(activeCustomRandomats) do
            hook.Remove(hookType, hookID)
        end

        for _, resetFunc in ipairs(customRandomatResets) do
            resetFunc()
        end

        table.Empty(customRandomatResets)
        table.Empty(activeCustomRandomats)
        owner = nil
        makeRandomat = false
    end
end

-- Check there is at least one cause and effect enabled before running this event
function EVENT:Condition()
    local causeEnabled = false
    local effectEnabled = false

    for _, cause in pairs(Causes) do
        if cause.Convar:GetBool() then
            causeEnabled = true
            break
        end
    end

    for _, effect in pairs(Effects) do
        if effect.Convar:GetBool() then
            effectEnabled = true
            break
        end
    end

    return causeEnabled and effectEnabled
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"choices", "timer"}) do
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

    for _, v in pairs({"while_dead"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = v,
                dsc = convar:GetHelpText()
            })
        end
    end

    for _, cause in pairs(Causes) do
        local name = cause.Convar:GetName()

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = string.TrimLeft(name, "randomat_make_"),
                dsc = convar:GetHelpText()
            })
        end
    end

    for _, effect in pairs(Effects) do
        local name = effect.Convar:GetName()

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checks, {
                cmd = string.TrimLeft(name, "randomat_make_"),
                dsc = convar:GetHelpText()
            })
        end
    end

    return sliders, checks
end

Randomat:register(EVENT)