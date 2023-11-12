local EVENT = {}

CreateConVar("randomat_memes_timer", "20", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Seconds between displaying a meme", 5, 120)

EVENT.Title = "Memes"
EVENT.Description = "Displays an ASCII art meme every " .. GetConVar("randomat_memes_timer"):GetInt() .. " seconds"
EVENT.id = "memes"

EVENT.Categories = {"fun", "smallimpact"}

function EVENT:Begin()
    self.Description = "Displays an ASCII art meme every " .. GetConVar("randomat_memes_timer"):GetInt() .. " seconds"

    timer.Create("MemesRandomatTimer", GetConVar("randomat_memes_timer"):GetInt(), 0, function()
        self:SmallNotify(StigMemeASCII[math.random(#StigMemeASCII)])
    end)
end

function EVENT:End()
    timer.Remove("MemesRandomatTimer")
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in pairs({"timer"}) do
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

    return sliders
end

Randomat:register(EVENT)