local EVENT = {}
EVENT.Title = "Événement Aléatoire" -- "Random Event"
EVENT.AltTitle = "French"
EVENT.Description = "Parlez-vous français?" -- Do you speak French?
EVENT.ExtDescription = "Changes most of the game to French"
EVENT.id = "french"
EVENT.Type = EVENT_TYPE_MUSIC

EVENT.Categories = {"fun", "moderateimpact"}

local musicConvar = CreateConVar("randomat_french_music", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Whether music should play", 0, 1)

util.AddNetworkString("FrenchRandomatBegin")
util.AddNetworkString("FrenchRandomatEnd")
local eventRun = false

function EVENT:Begin()
    eventRun = true
    net.Start("FrenchRandomatBegin")
    net.WriteBool(musicConvar:GetBool())
    net.Broadcast()

    -- Changes the centre screen alerts of some role from CR, if CR is installed
    if CR_VERSION then
        local assassinMessageDelay = GetConVar("ttt_assassin_next_target_delay"):GetInt()

        self:AddHook("DoPlayerDeath", function(ply, attacker, dmginfo)
            if (not (IsPlayer(ply) and IsPlayer(attacker))) or ply == attacker then return end

            if attacker:IsAssassin() then
                -- Overriding the usual assassin messages with nonsense ones.
                -- But they're in French, no one will be able to tell right?
                -- CR can't use the TTT language system for everything, anything server-side would need to be networked, so I can't actually translate these messages properly
                -- Also, it's just a thing in Gmod that HUD_PRINTCENTER does nothing client-side so :P
                attacker:PrintMessage(HUD_PRINTCENTER, "Vous avez tué quelqu'un en tant qu'assassin. Bravo.")

                if assassinMessageDelay > 0 then
                    timer.Simple(assassinMessageDelay + 0.1, function()
                        attacker:PrintMessage(HUD_PRINTCENTER, "Vous avez peut-être reçu votre prochaine cible.")
                    end)
                end
            end

            timer.Simple(0.1, function()
                -- More nonsence French, this time when you kill or are killed as the phantom, or roles like it
                if attacker:GetNWBool("Haunted") then
                    attacker:PrintMessage(HUD_PRINTCENTER, "Vous avez tué et êtes hanté")
                    ply:PrintMessage(HUD_PRINTCENTER, "Votre tueur est hanté par quelqu'un.")
                end
            end)
        end)
    end

    -- Replaces the crowbar with a baguette
    for _, ply in ipairs(self:GetAlivePlayers()) do
        ply:StripWeapon("weapon_zm_improvised")
        ply:Give("weapon_ttt_baguette_randomat")

        for _, wep in ipairs(ply:GetWeapons()) do
            ply:SelectWeapon(wep)
        end

        timer.Simple(0.1, function()
            ply:SelectWeapon("weapon_ttt_baguette_randomat")
        end)
    end

    -- Disable round end sounds and 'Ending Flair' event so ending music can play
    if musicConvar:GetBool() then
        DisableRoundEndSounds()
    end

    -- Gives anyone that respawns the baguette again
    self:AddHook("PlayerSpawn", function(ply)
        timer.Simple(1, function()
            ply:StripWeapon("weapon_zm_improvised")
            ply:Give("weapon_ttt_baguette_randomat")
            ply:SelectWeapon("weapon_ttt_baguette_randomat")
        end)
    end)

    -- Play a random clip of a French soccer commentator when someone dies
    self:AddHook("DoPlayerDeath", function(ply, attacker, dmginfo)
        dmginfo:SetDamageType(DMG_SLASH) -- Slashing damage mutes the normal death sound
        sound.Play("french/death" .. math.random(1, 6) .. ".mp3", ply:GetPos(), 0, 100, 1)
    end)

    -- If we're switching from a TFA weapon to the disguiser while it's running, JUST DO IT!
    -- The holster animation causes a delay where the client is not allowed to switch weapons
    -- This means if we tell the user to select a weapon and then block the user from switching weapons immediately after,
    -- the holster animation delay will cause the player to not select the weapon we told them to
    self:AddHook("TFA_PreHolster", function(wep, target)
        if not IsValid(wep) or not IsValid(target) then return end
        local owner = wep:GetOwner()
        if not IsPlayer(owner) then return end
        local weapon = WEPS.GetClass(target)
        if weapon == "weapon_ttt_baguette_randomat" then return true end
    end)
end

function EVENT:End()
    if eventRun then
        eventRun = false
        net.Start("FrenchRandomatEnd")
        net.Broadcast()
    end
end

-- Disallow mud scientist randomat to trigger at the same time as either event's role renaming may persist between rounds
function EVENT:Condition()
    return not Randomat:IsEventActive("mudscientist")
end

function EVENT:GetConVars()
    local checkboxes = {}

    for _, v in pairs({"music"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(checkboxes, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 0
            })
        end
    end

    return {}, checkboxes
end

Randomat:register(EVENT)