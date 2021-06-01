AddCSLuaFile()

local EVENT = {}

CreateConVar("randomat_livecount_timer", 30, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Time between live counts")

EVENT.Title = "Live Count"
EVENT.Description = "Counts no. of alive players every " .. GetConVar("randomat_livecount_timer"):GetInt() .. " seconds"
EVENT.id = "livecount"

function EVENT:Begin()

	timer.Create("RandomatLiveCountTimer", GetConVar("randomat_livecount_timer"):GetInt(), 0, function()
		local count = 0
		
		for i, ply in pairs(self:GetAlivePlayers(true)) do
			count = count + 1
		end
		
		self:SmallNotify("There are "..count.." people still alive")
	end)

end

function EVENT:End()
	timer.Remove("RandomatLiveCountTimer")
end

Randomat:register(EVENT)