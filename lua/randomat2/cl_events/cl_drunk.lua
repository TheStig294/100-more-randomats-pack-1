-- Adds a blur effect around the edges of the screen
net.Receive("DrunkRandomatBegin", function()
    hook.Add("RenderScreenspaceEffects", "DrunkRandomatScreenEffect", function()
        DrawToyTown(2, ScrH() / 2)
    end)
end)

net.Receive("DrunkRandomatEnd", function()
    hook.Remove("RenderScreenspaceEffects", "DrunkRandomatScreenEffect")
end)