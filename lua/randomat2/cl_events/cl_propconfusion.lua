local netMsgRecieved = false

net.Receive("PropConfusionRandomatBegin", function()
    netMsgRecieved = false
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
        ["models/luria/night_in_the_woods/playermodels/mae.mdl"] = "models/props_junk/TrafficCone001a.mdl",
        ["models/luria/night_in_the_woods/playermodels/mae_astral.mdl"] = "models/props_junk/TrafficCone001a.mdl",
        ["models/player_phoenix.mdl"] = "models/props_c17/chair02a.mdl",
        ["models/bradyjharty/yogscast/sharky.mdl"] = "models/props_borealis/bluebarrel001.mdl",
        ["models/solidsnakemgs4/solidsnakemgs4.mdl"] = "models/props_trainstation/trainstation_column001.mdl"
    }

    -- An assortment of human-scale in-built props
    local models = {"models/props_borealis/mooring_cleat01.mdl", "models/props_borealis/bluebarrel001.mdl", "models/props_c17/canister01a.mdl", "models/props_c17/canister02a.mdl", "models/props_c17/canister_propane01a.mdl", "models/props_c17/bench01a.mdl", "models/props_c17/chair02a.mdl", "models/props_c17/concrete_barrier001a.mdl", "models/props_c17/FurnitureBathtub001a.mdl", "models/props_c17/FurnitureBoiler001a.mdl", "models/props_c17/FurnitureChair001a.mdl", "models/props_c17/FurnitureCouch001a.mdl", "models/props_c17/FurnitureCouch002a.mdl", "models/props_c17/FurnitureDrawer001a.mdl", "models/props_c17/FurnitureMattress001a.mdl", "models/props_c17/FurnitureMattress001a.mdl", "models/props_c17/FurnitureDrawer002a.mdl", "models/props_c17/FurnitureDresser001a.mdl", "models/props_c17/FurnitureFireplace001a.mdl", "models/props_c17/FurnitureFridge001a.mdl", "models/props_c17/FurnitureRadiator001a.mdl", "models/props_c17/FurnitureShelf001a.mdl", "models/props_c17/FurnitureSink001a.mdl", "models/props_c17/furnitureStove001a.mdl", "models/props_c17/FurnitureTable001a.mdl", "models/props_c17/FurnitureToilet001a.mdl", "models/props_c17/FurnitureWashingmachine001a.mdl", "models/props_c17/gravestone001a.mdl", "models/props_c17/gravestone002a.mdl", "models/props_c17/gravestone003a.mdl", "models/props_c17/gravestone_coffinpiece001a.mdl", "models/props_c17/Lockers001a.mdl", "models/props_c17/metalladder001.mdl", "models/props_c17/oildrum001.mdl", "models/props_c17/oildrum001_explosive.mdl", "models/props_c17/pulleyhook01.mdl", "models/props_c17/shelfunit01a.mdl", "models/props_combine/breenchair.mdl", "models/props_combine/breendesk.mdl", "models/props_combine/combine_barricade_short02a.mdl", "models/props_combine/headcrabcannister01a.mdl", "models/Combine_Helicopter/helicopter_bomb01.mdl", "models/props_interiors/BathTub01a.mdl"}

    local props = {}

    -- Turn everyone into props for this player only
    for _, ply in ipairs(player.GetAll()) do
        -- But don't turn themselves into a prop
        if ply == LocalPlayer() then continue end
        local prop = ents.CreateClientProp()
        prop:SetPos(ply:GetPos())
        local model

        -- If someone is wearing a yogscast model, and they have a special model, set them to it!
        if yogsProps[ply:GetModel()] then
            model = yogsProps[ply:GetModel()]
        else
            model = models[math.random(1, #models)]
        end

        prop:SetModel(model)
        prop:SetParent(ply)
        prop:Spawn()
        table.insert(props, prop)
        ply:SetNoDraw(true)
    end
end)

net.Receive("PropConfusionRandomatEnd", function()
    if netMsgRecieved then return end

    -- Turn everyone back from props
    if istable(props) then
        for _, prop in ipairs(props) do
            if not IsValid(prop) then continue end
            prop:Remove()
        end
    end

    for _, ply in ipairs(player.GetAll()) do
        if ply == LocalPlayer() then continue end
        ply:SetNoDraw(false)
    end

    chat.AddText("You can now see who was what prop!")
    hook.Remove("NotifyShouldTransmit", "PropConfusionPropParentingFix")
    netMsgRecieved = true
end)