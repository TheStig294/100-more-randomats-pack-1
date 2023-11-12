local netMsgRecieved = false
local props = {}

net.Receive("PropConfusionRandomatBegin", function()
    netMsgRecieved = false
    props = {}
    -- Fix from Gmod wiki for floating parented client-side props
    local parentLookup = {}

    local function cacheParents()
        parentLookup = {}
        local tbl = ents.GetAll()

        for i = 1, #tbl do
            local v = tbl[i]

            if v:EntIndex() == -1 then
                local parent = v:GetInternalVariable("m_hNetworkMoveParent")
                local children = parentLookup[parent]

                if not children then
                    children = {}
                    parentLookup[parent] = children
                end

                children[#children + 1] = v
            end
        end
    end

    local function fixChildren(parent, transmit)
        local tbl = parentLookup[parent]

        if tbl then
            for i = 1, #tbl do
                local child = tbl[i]

                if transmit then
                    child:SetNoDraw(false)
                    child:SetParent(parent)
                    fixChildren(child, transmit)
                else
                    child:SetNoDraw(true)
                    fixChildren(child, transmit)
                end
            end
        end
    end

    local lastTime = 0

    hook.Add("NotifyShouldTransmit", "PropConfusionPropParentingFix", function(ent, transmit)
        local time = RealTime()

        if lastTime < time then
            cacheParents()
            lastTime = time
        end

        fixChildren(ent, transmit)
    end)

    -- These are the props Lewis mistook members of the yogscast for while playing TTT
    local yogsProps = {
        -- Zoey and Boba were traffic cones
        ["models/luria/night_in_the_woods/playermodels/mae.mdl"] = "models/props_junk/TrafficCone001a.mdl",
        ["models/luria/night_in_the_woods/playermodels/mae_astral.mdl"] = "models/props_junk/TrafficCone001a.mdl",
        ["models/player/funnyrat/rat.mdl"] = "models/props_junk/TrafficCone001a.mdl",
        -- Rythian was a chair
        ["models/player_phoenix.mdl"] = "models/props_c17/chair02a.mdl",
        -- Ben was a blue barrel
        ["models/bradyjharty/yogscast/sharky.mdl"] = "models/props_borealis/bluebarrel001.mdl",
        ["models/freeman/player/left_shark.mdl"] = "models/props_borealis/bluebarrel001.mdl",
        -- Ravs was a chimney
        ["models/solidsnakemgs4/solidsnakemgs4.mdl"] = "models/props_trainstation/trainstation_column001.mdl",
    }

    -- An assortment of human-scale in-built props
    local models = {"models/props_borealis/mooring_cleat01.mdl", "models/props_borealis/bluebarrel001.mdl", "models/props_c17/canister01a.mdl", "models/props_c17/canister02a.mdl", "models/props_c17/canister_propane01a.mdl", "models/props_c17/bench01a.mdl", "models/props_c17/chair02a.mdl", "models/props_c17/concrete_barrier001a.mdl", "models/props_c17/FurnitureBathtub001a.mdl", "models/props_c17/FurnitureBoiler001a.mdl", "models/props_c17/FurnitureChair001a.mdl", "models/props_c17/FurnitureCouch001a.mdl", "models/props_c17/FurnitureCouch002a.mdl", "models/props_c17/FurnitureDrawer001a.mdl", "models/props_c17/FurnitureMattress001a.mdl", "models/props_c17/FurnitureMattress001a.mdl", "models/props_c17/FurnitureDrawer002a.mdl", "models/props_c17/FurnitureDresser001a.mdl", "models/props_c17/FurnitureFireplace001a.mdl", "models/props_c17/FurnitureFridge001a.mdl", "models/props_c17/FurnitureRadiator001a.mdl", "models/props_c17/FurnitureShelf001a.mdl", "models/props_c17/FurnitureSink001a.mdl", "models/props_c17/furnitureStove001a.mdl", "models/props_c17/FurnitureTable001a.mdl", "models/props_c17/FurnitureToilet001a.mdl", "models/props_c17/FurnitureWashingmachine001a.mdl", "models/props_c17/gravestone001a.mdl", "models/props_c17/gravestone002a.mdl", "models/props_c17/gravestone003a.mdl", "models/props_c17/gravestone_coffinpiece001a.mdl", "models/props_c17/Lockers001a.mdl", "models/props_c17/metalladder001.mdl", "models/props_c17/oildrum001.mdl", "models/props_c17/oildrum001_explosive.mdl", "models/props_c17/pulleyhook01.mdl", "models/props_c17/shelfunit01a.mdl", "models/props_combine/breenchair.mdl", "models/props_combine/breendesk.mdl", "models/props_combine/combine_barricade_short02a.mdl", "models/props_combine/headcrabcannister01a.mdl", "models/Combine_Helicopter/helicopter_bomb01.mdl", "models/props_interiors/BathTub01a.mdl"}

    timer.Create("PropConfusionRandomatForcePlayerInvisible", 1, 0, function()
        -- Turn everyone into props for this player only
        for _, ply in ipairs(player.GetAll()) do
            -- But don't turn themselves into a prop
            if ply == LocalPlayer() then continue end
            ply:SetNoDraw(true)
            if props[ply] then continue end
            local prop = ents.CreateClientProp()
            local pos = ply:GetPos()
            pos.z = pos.z + 30
            prop:SetPos(pos)
            local model

            -- If someone is wearing a yogscast model, and they have a special model, set them to it!
            if yogsProps[ply:GetModel()] then
                model = yogsProps[ply:GetModel()]
            else
                model = models[math.random(#models)]
            end

            prop:SetModel(model)
            prop:SetParent(ply)
            prop:Spawn()
            props[ply] = prop
        end
    end)
end)

net.Receive("PropConfusionRandomatEnd", function()
    if netMsgRecieved then return end
    timer.Remove("PropConfusionRandomatForcePlayerInvisible")

    -- Turn everyone back from props
    for _, prop in pairs(props) do
        if not IsValid(prop) then continue end
        prop:Remove()
    end

    for _, ply in ipairs(player.GetAll()) do
        if ply == LocalPlayer() then continue end
        ply:SetNoDraw(false)
    end

    hook.Remove("NotifyShouldTransmit", "PropConfusionPropParentingFix")
    netMsgRecieved = true
end)