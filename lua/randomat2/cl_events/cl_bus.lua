net.Receive("BusRandomatOutline", function()
    local bus = GetGlobalEntity("RandomatBusEnt")
    if not IsValid(bus) then return end

    local busTable = {bus}

    hook.Add("PreDrawHalos", "BusRandomatOutline", function()
        halo.Add(busTable, Color(0, 255, 0), 0, 0, 1, true, true)
    end)
end)

net.Receive("BusRandomatOutlineEnd", function()
    timer.Remove("BusOutlineDelay")
    hook.Remove("PreDrawHalos", "BusRandomatOutline")
end)