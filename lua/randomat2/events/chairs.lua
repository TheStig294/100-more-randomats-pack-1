local EVENT = {}
EVENT.Title = "Take a seat!"
EVENT.Description = "Turns everyone into chairs!"
EVENT.id = "chairs"

EVENT.Categories = {"fun", "largeimpact"}

function EVENT:Begin()
    local rythianModel = "models/player_phoenix.mdl"

    local chairModels = {"models/nova/chair_plastic01.mdl", "models/nova/chair_office01.mdl", "models/nova/chair_office02.mdl", "models/nova/chair_wood01.mdl", "models/props_c17/chair_office01a.mdl", "models/props_interiors/furniture_chair01a.mdl", "models/props_interiors/furniture_chair03a.mdl"}

    local addZModels = {
        ["models/props_interiors/furniture_chair01a.mdl"] = true,
        ["models/props_interiors/furniture_chair03a.mdl"] = true
    }

    local turn90Models = {
        ["models/nova/chair_plastic01.mdl"] = true,
        ["models/nova/chair_office01.mdl"] = true,
        ["models/nova/chair_office02.mdl"] = true,
        ["models/nova/chair_wood01.mdl"] = true,
        ["models/props_c17/chair_office01a.mdl"] = true
    }

    local playerChairs = {}
    local chosenModels = {}
    local notChairPlys = {}
    local rythianModelGiven = false

    -- Turns you invisible and puts a chair model on top of you the follows you around an faces the way you do
    for _, ply in ipairs(self:GetAlivePlayers(true)) do
        local model = chairModels[math.random(1, #chairModels)]

        -- Force anyone using the Rythian model to become a blue chair
        if ply:GetModel() == rythianModel then
            model = "models/nova/chair_plastic01.mdl"
        elseif util.IsValidModel(rythianModel) and not rythianModelGiven then
            model = rythianModel
            rythianModelGiven = true
        end

        local chair

        if model == rythianModel then
            Randomat:ForceSetPlayermodel(ply, rythianModel)
        else
            ply.oldViewOffset = ply:GetViewOffset()
            ply.oldViewOffsetDucked = ply:GetViewOffsetDucked()
            ply:SetViewOffset(Vector(0, 0, 40))
            ply:SetViewOffsetDucked(Vector(0, 0, 28))
            chair = ents.Create("prop_dynamic")
            chair:SetModel(model)
            chair:Spawn()
            ply:SetNoDraw(true)
            playerChairs[ply] = chair
        end

        chosenModels[ply] = model

        if addZModels[model] then
            chair.AddZ = true
        end

        if turn90Models[model] then
            chair.Turn90 = true
        end
    end

    self:AddHook("PlayerPostThink", function(ply)
        if notChairPlys[ply] then return end
        -- Remove the chair and set the player to normal after they die
        local chair = playerChairs[ply]

        if not IsValid(chair) or not ply:Alive() or ply:IsSpec() then
            ply:SetNoDraw(false)
            playerChairs[ply] = nil
            notChairPlys[ply] = true

            if IsValid(chair) then
                chair:Remove()
            end

            return
        end

        -- Some chairs are in the ground for some reason...
        local pos = ply:GetPos()

        if chair.AddZ then
            pos.z = pos.z + 25
        end

        chair:SetPos(pos)
        -- Makes the chair look the same direction as the player
        -- Chair spawns rotated 90 degrees the wrong way for some reason...
        local angles = ply:GetAngles()

        if chair.Turn90 then
            angles.y = angles.y - 90
        end

        angles.x = 0
        chair:SetAngles(angles)
    end)

    self:AddHook("TTTOnCorpseCreated", function(rag)
        local ply = CORPSE.GetPlayer(rag)
        local chair = playerChairs[ply]
        if not IsValid(ply) or not IsValid(chair) then return end
        rag:SetNoDraw(true)
        local corpseChair = ents.Create("prop_dynamic")
        corpseChair:SetModel(chosenModels[ply])
        corpseChair:SetPos(rag:GetPos())
        corpseChair:SetParent(rag)
        corpseChair:Spawn()
    end)
end

function EVENT:End()
    for _, ply in ipairs(player.GetAll()) do
        if ply.oldViewOffset then
            ply:SetViewOffset(ply.oldViewOffset)
        end

        if ply.oldViewOffsetDucked then
            ply:SetViewOffsetDucked(ply.oldViewOffsetDucked)
        end
    end
end

Randomat:register(EVENT)