local EVENT = {}
CreateConVar("randomat_legday_scale", 0.3, FCVAR_NONE, "Leg size multiplier", 0.3, 2)
EVENT.Title = "Don't Skip Leg Day"
EVENT.ExtDescription = "Changes everyone's leg size"
EVENT.id = "legday"

EVENT.Categories = {"fun", "smallimpact"}

local bonelist = {"ValveBiped.Bip01_Pelvis", "ValveBiped.Bip01_L_Thigh", "ValveBiped.Bip01_L_Calf", "ValveBiped.Bip01_L_Foot", "ValveBiped.Bip01_L_Toe0", "ValveBiped.Bip01_R_Thigh", "ValveBiped.Bip01_R_Calf", "ValveBiped.Bip01_R_Foot", "ValveBiped.Bip01_R_Toe0"}

local transmodlist = {Vector(0, 0, -38), Vector(-3.9, 0, 0), Vector(-16, 0, 0), Vector(-16, 0, 0), Vector(-6.31, 0, 0), Vector(3.9, 0, 0), Vector(-16, 0, 0), Vector(-16, 0, 0), Vector(-6.31, 0, 0)}

local function ScalePlayerLegs(mult)
    for _, p in ipairs(player.GetAll()) do
        for i = 1, #bonelist do
            local boneId = p:LookupBone(bonelist[i])

            if boneId ~= nil then
                p:ManipulateBoneScale(boneId, Vector(mult * p:GetManipulateBoneScale(boneId)[1], mult * p:GetManipulateBoneScale(boneId)[2], mult * p:GetManipulateBoneScale(boneId)[3]))
                p:ManipulateBonePosition(boneId, transmodlist[i] - transmodlist[i] * mult)
            end
        end
    end
end

function EVENT:Begin()
    local scale = GetConVar("randomat_legday_scale"):GetFloat()
    ScalePlayerLegs(scale)
    -- Scale viewheight, but set minimum height
    local viewHeight = 64 * scale

    if scale < 0.31 then
        viewHeight = 40
    end

    for _, p in ipairs(player.GetAll()) do
        -- Set viewheight for players as well
        p:SetViewOffset(Vector(0, 0, viewHeight))
        p:SetViewOffsetDucked(Vector(0, 0, 28))
    end
end

function EVENT:End()
    ScalePlayerLegs(1, 1, 0)
    -- Reset viewheight for players as well
    Randomat:ForceResetAllPlayermodels()
end

function EVENT:GetConVars()
    local sliders = {}

    for _, v in ipairs({"scale"}) do
        local name = "randomat_" .. self.id .. "_" .. v

        if ConVarExists(name) then
            local convar = GetConVar(name)

            table.insert(sliders, {
                cmd = v,
                dsc = convar:GetHelpText(),
                min = convar:GetMin(),
                max = convar:GetMax(),
                dcm = 1
            })
        end
    end

    return sliders
end

Randomat:register(EVENT)