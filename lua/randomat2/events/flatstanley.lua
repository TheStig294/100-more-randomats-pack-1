local EVENT = {}
CreateConVar("randomat_flatstanley_scale", 0.2, FCVAR_ARCHIVE, "Flatness size multiplier", 0.1, 0.5)
EVENT.Title = "Remember Flat Stanley?"
EVENT.ExtDescription = "Turns every player flat"
EVENT.id = "flatstanley"

EVENT.Categories = {"fun", "smallimpact"}

local bonelistY = {"ValveBiped.Bip01_Spine", "ValveBiped.Bip01_Spine1", "ValveBiped.Bip01_Spine2", "ValveBiped.Bip01_Spine3", "ValveBiped.Bip01_Spine4", "ValveBiped.Bip01_Neck1", "ValveBiped.Bip01_Head1", "ValveBiped.forward", "ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Forearm", "ValveBiped.Bip01_L_Ulna", "ValveBiped.Bip01_L_Wrist", "ValveBiped.Bip01_L_Bicep", "ValveBiped.Bip01_L_Shoulder", "ValveBiped.Bip01_L_Elbow", "ValveBiped.Bip01_R_UpperArm", "ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_R_Ulna", "ValveBiped.Bip01_R_Wrist", "ValveBiped.Bip01_R_Elbow", "ValveBiped.Bip01_R_Shoulder", "ValveBiped.Bip01_R_Bicep", "ValveBiped.Bip01_L_Latt", "ValveBiped.Bip01_L_Pectoral", "ValveBiped.Bip01_R_Pectoral", "ValveBiped.Bip01_R_Latt", "ValveBiped.Bip01_L_Thigh", "ValveBiped.Bip01_L_Calf", "ValveBiped.Bip01_L_Foot", "ValveBiped.Bip01_L_Toe0", "ValveBiped.Bip01_R_Thigh", "ValveBiped.Bip01_R_Calf", "ValveBiped.Bip01_R_Foot", "ValveBiped.Bip01_R_Toe0"}

local bonelistZ = {"ValveBiped.Bip01_Pelvis", "ValveBiped.Bip01_L_Clavicle", "ValveBiped.Bip01_R_Clavicle", "ValveBiped.Bip01_L_Hand", "ValveBiped.Bip01_L_Trapezius", "ValveBiped.Bip01_R_Hand", "ValveBiped.Bip01_R_Trapezius",}

local function ScalePlayerFlat(mult)
    for _, p in ipairs(player.GetAll()) do
        for i = 1, #bonelistY do
            local boneId = p:LookupBone(bonelistY[i])

            if boneId ~= nil then
                p:ManipulateBoneScale(boneId, Vector(p:GetManipulateBoneScale(boneId)[1], mult * p:GetManipulateBoneScale(boneId)[2], p:GetManipulateBoneScale(boneId)[3]))
            end
        end

        for i = 1, #bonelistZ do
            local boneId = p:LookupBone(bonelistZ[i])

            if boneId ~= nil then
                p:ManipulateBoneScale(boneId, Vector(p:GetManipulateBoneScale(boneId)[1], p:GetManipulateBoneScale(boneId)[2], mult * p:GetManipulateBoneScale(boneId)[3]))
            end
        end
    end
end

function EVENT:Begin()
    ScalePlayerFlat(GetConVar("randomat_flatstanley_scale"):GetFloat())
end

function EVENT:End()
    ScalePlayerFlat(1)
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