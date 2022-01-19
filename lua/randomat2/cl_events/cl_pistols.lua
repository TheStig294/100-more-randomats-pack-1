net.Receive("PistolsDrawHalos", function()
    hook.Add("PreDrawHalos", "PistolsRandomatHalos", function()
        local alivePlys = {}

        for k, v in ipairs(player.GetAll()) do
            if v:Alive() and not v:IsSpec() then
                alivePlys[k] = v
            end
        end

        halo.Add(alivePlys, Color(0, 255, 0), 0, 0, 1, true, true)
    end)
end)

net.Receive("PistolsRemoveHalos", function()
    hook.Remove("PreDrawHalos", "PistolsRandomatHalos")
end)