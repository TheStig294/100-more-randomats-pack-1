local EVENT = {}
EVENT.Title = "Événement Aléatoire" -- "Random Event"
EVENT.AltTitle = "French Randomat"
EVENT.Description = "Parlez-vous français?" -- Do you speak French?
EVENT.ExtDescription = "Changes most of the game to French"
EVENT.id = "french"

EVENT.Categories = {"fun", "smallimpact"}

util.AddNetworkString("FrenchRandomatBegin")
util.AddNetworkString("FrenchRandomatEnd")
local eventRun = false

function EVENT:Begin()
    eventRun = true
    net.Start("FrenchRandomatBegin")
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

    -- Replaces the crowbar with a baguette, if the baguette SWEP is installed
    local SWEP = weapons.GetStored("gidzco_baguette")

    if SWEP then
        SWEP.Base = "weapon_tttbase"
        SWEP.Kind = WEAPON_MELEE
        SWEP.Slot = 0
        SWEP.InLoadoutFor = nil
        SWEP.AutoSpawnable = false
        SWEP.AllowDrop = false

        function SWEP:OnDrop()
            self:Remove()
        end

        function SWEP:ShouldDropOnDie()
            return false
        end

        for _, ply in ipairs(self:GetAlivePlayers()) do
            ply:StripWeapon("weapon_zm_improvised")
            ply:Give("gidzco_baguette")
            ply:SelectWeapon("gidzco_baguette")
        end

        self:AddHook("PlayerSpawn", function(ply)
            timer.Simple(1, function()
                ply:StripWeapon("weapon_zm_improvised")
                ply:Give("gidzco_baguette")
                ply:SelectWeapon("gidzco_baguette")
            end)
        end)
    end

    -- Play a random clip of a French soccer commentator when someone dies
    self:AddHook("DoPlayerDeath", function(ply, attacker, dmginfo)
        dmginfo:SetDamageType(DMG_SLASH) -- Slashing damage mutes the normal death sound
        sound.Play("french/death" .. math.random(1, 6) .. ".mp3", ply:GetPos(), 90, 100, 1)
    end)
end

function EVENT:End()
    if eventRun then
        eventRun = false
        net.Start("FrenchRandomatEnd")
        net.Broadcast()
    end
end

Randomat:register(EVENT)