local EVENT = {}
EVENT.Title = "Petrify!"
EVENT.Description = "Turns players into a stone like figure, playing a quite annoying sound when they move."
EVENT.id = "petrify"

function EVENT:GetConVars()

    local sliders = {}
    for _, v in pairs({}) do
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



-- Turn player to stone
local function petrify(ply)
	if ply then
		if ply:IsValid() and ply:Alive() then
			FindMetaTable("Entity").SetModel(ply, "models/player.mdl")
		end
	end
end




function EVENT:Begin()

	hook.Add("PlayerSpawn", "randomatDefaultPlayer", function(ply)

        -- Petrify on spawn
		if ply then
			timer.Simple(0.5, petrify, ply)
		end

	end)
	

    -- Petrify all players
    for i, ply in pairs(player.GetAll()) do
		petrify(ply)
		ply.soundPlaying = false
    end


    -- Player sound when moving
	hook.Add( "Move", "randomatDefaultPlayerMove", function( ply, mv )

		if ply and ply:Alive() then
			if mv:GetVelocity():Length() > 10 and not ply.soundPlaying and ply:IsOnGround() then
				ply:EmitSound( "physics\\concrete\\concrete_scrape_smooth_loop1.wav", 30)
				ply.soundPlaying = true

			elseif (mv:GetVelocity():Length() < 10 or not ply:IsOnGround()) and ply.soundPlaying then
				ply:StopSound("physics\\concrete\\concrete_scrape_smooth_loop1.wav")
				ply.soundPlaying = false
			end
		end

	end)


    -- Stop sound on death
	hook.Add( "DoPlayerDeath", "randomatDefaultPlayerDeath", function( ply)
		if ply.soundPlaying then
			ply:StopSound("physics\\concrete\\concrete_scrape_smooth_loop1.wav")
		end
	end)
end




function EVENT:End()

    -- Clean up hooks
	hook.Remove("PlayerSpawn", "randomatDefaultPlayer")
	hook.Remove("Move", "randomatDefaultPlayerMove")
	hook.Remove("DoPlayerDeath", "randomatDefaultPlayerDeath")

    -- Stop Sound
    for i, ply in ipairs ( player.GetAll() ) do
        ply:StopSound("physics\\concrete\\concrete_scrape_smooth_loop1.wav")
    end
end

Randomat:register(EVENT)