-- Duel revolver used in the 'It's high noon...' randomat
AddCSLuaFile()
SWEP.PrintName = "Duel Pistol"
SWEP.Slot = 1
SWEP.Icon = "vgui/ttt/icon_pistols.png"
SWEP.IconLetter = "f"
SWEP.Base = "weapon_tttbase"
SWEP.HoldType = "revolver"
SWEP.Primary.Ammo = "AlyxGun"
SWEP.Primary.Delay = 2
SWEP.Primary.Recoil = 0.8
SWEP.Primary.Cone = 0.0325
SWEP.Primary.Damage = 1000
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 6
SWEP.Primary.ClipMax = 69
SWEP.Primary.DefaultClip = 75
SWEP.Primary.Sound = Sound("Weapon_357.Single")
SWEP.UseHands = true
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 54
SWEP.ViewModel = Model("models/weapons/c_357.mdl")
SWEP.WorldModel = Model("models/weapons/w_357.mdl")
SWEP.IronSightsPos = Vector(-4.64, -3.96, 0.68)
SWEP.IronSightsAng = Vector(0.214, -0.1767, 0)
SWEP.Kind = WEAPON_PISTOL
SWEP.AutoSpawnable = false

SWEP.InLoadoutFor = {nil}

SWEP.LimitedStock = true
SWEP.AllowDrop = false
SWEP.IsSilent = false
SWEP.NoSights = false

-- Draws halos over the duelling players
if SERVER then
    util.AddNetworkString("DuelRevolverDrawHalo")
    util.AddNetworkString("DuelRevolverRemoveHalo")
end

if CLIENT then
    net.Receive("DuelRevolverDrawHalo", function()
        -- Searching for the duel opponent based on their Steam ID
        local duelOpponent = {}
        local opponentName = net.ReadString()

        for _, ply in ipairs(player.GetAll()) do
            if ply:Nick() == opponentName then
                table.insert(duelOpponent, ply)
            end
        end

        -- Adding a halo around the duel opponent
        hook.Add("PreDrawHalos", "DuelRevolverHalo", function()
            halo.Add(duelOpponent, Color(0, 255, 0), 0, 0, 1, true, false)

            -- Once the player dies, remove the halo!
            if (not IsPlayer(duelOpponent[1])) or (not duelOpponent[1]:Alive()) or duelOpponent[1]:IsSpec() then
                hook.Remove("PreDrawHalos", "DuelRevolverHalo")
            end
        end)

        -- Plays the "Draw!" sound effect
        surface.PlaySound("western/draw.mp3")
    end)

    net.Receive("DuelRevolverRemoveHalo", function()
        hook.Remove("PreDrawHalos", "DuelRevolverHalo")
    end)
end

function SWEP:Equip()
    local owner = self:GetOwner()
    if not IsPlayer(owner) then return end
    -- Reset everyone's duelling player
    owner:SetNWEntity("WesternDuellingPlayer", NULL)
    owner.DuelOpponent = nil
    net.Start("DuelRevolverRemoveHalo")
    net.Send(owner)
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end
    local owner = self:GetOwner()
    if not IsPlayer(owner) then return end

    -- Refill a player's ammo so the revolver can shoot forever
    if SERVER and self:Ammo1() < 69 then
        owner:SetAmmo(69, self.Primary.Ammo)
    end

    -- Get the player the user is looking at
    local target = owner:GetEyeTrace().Entity

    -- Don't let duelling players shoot anyone else
    if owner.DuelOpponent and SERVER and IsPlayer(target) and target ~= owner.DuelOpponent then
        owner:PrintMessage(HUD_PRINTCENTER, "Not your duel opponent!")

        return
    elseif not owner.DuelOpponent and SERVER and IsPlayer(target) and target.DuelOpponent then
        -- If shooting someone who is duelling with another player, display a message
        -- and prevent the duel-starting logic from running
        owner:PrintMessage(HUD_PRINTCENTER, "Already duelling!")

        return
    elseif (not IsPlayer(target)) or (IsPlayer(target) and owner.DuelOpponent and owner.DuelOpponent == target) then
        -- Try removing the player duel halo immediately after someone wins a duel, else the halo looks awkward on a spectator
        -- The rest of the "end the duel" logic is handled by the "WesternDuelTimer" timer below
        timer.Simple(0.1, function()
            if IsPlayer(target) and (target:IsSpec() or not target:Alive()) then
                hook.Remove("PreDrawHalos", "DuelRevolverHalo")
                -- If hitting the player's target, or not shooting a player, trigger the usual gunshot behaviour
            end
        end)

        return self.BaseClass.PrimaryAttack(self)
    end

    if SERVER then
        if not IsPlayer(target) then return end
        -- Setting the flag for each player to be duelling
        owner:SetNWEntity("WesternDuellingPlayer", target)
        target:SetNWEntity("WesternDuellingPlayer", owner)
        owner.DuelOpponent = target
        target.DuelOpponent = owner
        -- Force the two players to look away from each other and freeze in place
        local ownerEyeAngles = owner:EyeAngles()
        owner:SetEyeAngles(Angle(ownerEyeAngles.x, ownerEyeAngles.y + 180, ownerEyeAngles.z))
        target:SetEyeAngles(ownerEyeAngles)
        owner:Freeze(true)
        target:Freeze(true)
        -- Play the high noon sound effect for the duelling players
        owner:SendLua("surface.PlaySound(\"western/duelquote" .. math.random(8) .. ".mp3\")")
        target:SendLua("surface.PlaySound(\"western/duelquote" .. math.random(8) .. ".mp3\")")
        local timerID = "DuelRevolver" .. owner:SteamID64()

        timer.Create(timerID, 1, 5, function()
            if timer.RepsLeft(timerID) == 0 then
                -- After the countdown, unfreezes players and displays a message
                owner:PrintMessage(HUD_PRINTCENTER, "DRAW!")
                target:PrintMessage(HUD_PRINTCENTER, "DRAW!")
                owner:Freeze(false)
                target:Freeze(false)
                owner:SelectWeapon("weapon_ttt_duel_revolver_randomat")
                target:SelectWeapon("weapon_ttt_duel_revolver_randomat")
                -- Also draws halos around their duel opponent and plays a sound for both players
                net.Start("DuelRevolverDrawHalo")
                net.WriteString(target:Nick())
                net.Send(owner)
                net.Start("DuelRevolverDrawHalo")
                net.WriteString(owner:Nick())
                net.Send(target)

                -- Timer for checking the result of the duel
                timer.Create("WesternDuelTimer" .. owner:SteamID64(), 1, 10, function()
                    -- If either player dies, end the duel
                    if IsPlayer(owner) and IsPlayer(target) and (not owner:Alive() or not target:Alive() or owner:IsSpec() or target:IsSpec()) then
                        owner:SetNWEntity("WesternDuellingPlayer", NULL)
                        target:SetNWEntity("WesternDuellingPlayer", NULL)
                        owner.DuelOpponent = nil
                        target.DuelOpponent = nil
                        net.Start("DuelRevolverRemoveHalo")

                        net.Send({owner, target})

                        timer.Remove("WesternDuelTimer" .. owner:SteamID64())

                        return
                    end

                    -- If the duel is still going after 5 seconds left, display a timer
                    local repsLeft = timer.RepsLeft("WesternDuelTimer" .. owner:SteamID64())

                    if repsLeft < 5 and repsLeft > 0 then
                        owner:PrintMessage(HUD_PRINTCENTER, repsLeft)
                        target:PrintMessage(HUD_PRINTCENTER, repsLeft)
                        -- After 10 seconds of duelling, end the duel
                    elseif repsLeft == 0 then
                        owner:SetNWEntity("WesternDuellingPlayer", NULL)
                        target:SetNWEntity("WesternDuellingPlayer", NULL)
                        owner.DuelOpponent = nil
                        target.DuelOpponent = nil
                        net.Start("DuelRevolverRemoveHalo")

                        net.Send({owner, target})

                        owner:PrintMessage(HUD_PRINTCENTER, "The duel is over!")
                        target:PrintMessage(HUD_PRINTCENTER, "The duel is over!")
                    end
                end)
            else
                -- Shows a message until the duel starts
                owner:PrintMessage(HUD_PRINTCENTER, "Get ready to turn around and duel")
                target:PrintMessage(HUD_PRINTCENTER, "Get ready to turn around and duel")
            end
        end)
    end
end

function SWEP:OnRemove()
    local owner = self:GetOwner()
    if not IsPlayer(owner) then return end
    -- Reset everyone's duelling player
    owner:SetNWEntity("WesternDuellingPlayer", NULL)
    owner.DuelOpponent = nil

    if SERVER then
        net.Start("DuelRevolverRemoveHalo")
        net.Send(owner)
    end
end