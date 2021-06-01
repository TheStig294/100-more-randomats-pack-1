CreateConVar("randomat_dontmiss_damage", 5, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Damage", 1, 100)
CreateConVar("randomat_dontmiss_heal", 5, {FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Heal", 1, 100)

local EVENT = {}
EVENT.Title = "Don't Miss..."
EVENT.Description = "If you miss a shot, you take damage, but if you hit, then you gain health."
EVENT.id = "dontmiss"

function EVENT:GetConVars()

    local sliders = {}
    for _, v in pairs({"damage", "heal"}) do
        local name = "randomat_" .. self.id .. "_" .. v
        if ConVarExists(name) then
            local convar = GetConVar(name)
            table.insert(sliders, {
                cmd = v,                    -- The command extension (e.g. everything after "randomat_example_")
                dsc = convar:GetHelpText(), -- The description of the ConVar
                min = convar:GetMin(),      -- The minimum value for this slider-based ConVar
                max = convar:GetMax(),      -- The maximum value for this slider-based ConVar
                dcm = 0                     -- The number of decimal points to support in this slider-based ConVar
            })
        end
    end


    local checks = {}
    for _, v in pairs({}) do
        local name = "randomat_" .. self.id .. "_" .. v
        if ConVarExists(name) then
            local convar = GetConVar(name)
            table.insert(checks, {
                cmd = v,                    -- The command extension (e.g. everything after "randomat_example_")
                dsc = convar:GetHelpText()  -- The description of the ConVar
            })
        end
    end


    local textboxes = {}
    for _, v in pairs({}) do
        local name = "randomat_" .. self.id .. "_" .. v
        if ConVarExists(name) then
            local convar = GetConVar(name)
            table.insert(textboxes, {
                cmd = v,                    -- The command extension (e.g. everything after "randomat_example_")
                dsc = convar:GetHelpText()  -- The description of the ConVar
            })
        end
    end

    return sliders, checks, textboxes
end




function EVENT:Begin()

    -- Create variables to keep track of whether the player has shot a
    -- bullet, and whether they have hit a player. This is used between
    -- both hooks with a slight delay to determine whether it was a hit
    -- or not, and whether health should be added or taken away.
    for i, ply in pairs(player.GetAll()) do
        ply.shotBullet = false
        ply.hitShotBullet = false
	end
    


    -- Allow all players to have more health.
	for i, ply in pairs(player.GetAll()) do
		ply:SetMaxHealth(ply:GetMaxHealth() + 100)
    end



	-- Add hook for when a player fires.
    hook.Add("EntityFireBullets","RandomatAccuracyFire", function(ent, data)
        ent.shotBullet = true

        -- Start timer to check if the bullet hit.
        timer.Simple(0.1, function()
            if ent.hitShotBullet then
				ent.hitShotBullet = false
				if not ((ent:Health() + 5) > ent:GetMaxHealth()) then
					ent:SetHealth(ent:Health()+5)
				else
					ent:SetHealth(ent:GetMaxHealth())
				end
            
            -- They missed
            else
				ent:TakeDamage(5)
            end
        end)
    end)

    hook.Add("EntityTakeDamage","RandomatAccuracyHit", function(ent, damage)
        -- Player Hit
		if ent:IsPlayer() then
        	damage:GetAttacker().hitShotBullet = true
			damage:GetAttacker().shotBullet = false
		end
    end)
end


function EVENT:End()
    -- Remove Hooks
    hook.Remove("EntityFireBullets", "RandomatAccuracyFire")
	hook.Remove("OnTakeDamage", "RandomatAccuracyHit")
	
    -- Return default max health
	for i, ply in pairs(player.GetAll()) do
		ply:SetMaxHealth(100)
    end
end

Randomat:register(EVENT)