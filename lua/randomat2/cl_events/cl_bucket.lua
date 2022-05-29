net.Receive("BucketRandomatOutline", function()
    timer.Create("BucketOutlineDelay", 1, 1, function()
        local bucket = {}

        for _, ent in ipairs(ents.FindByClass("ent_bucket_randomat")) do
            table.insert(bucket, ent)
        end

        hook.Add("PreDrawHalos", "BucketRandomatOutline", function()
            halo.Add(bucket, Color(0, 255, 0), 0, 0, 1, true, true)
        end)
    end)
end)

net.Receive("BucketRandomatOutlineEnd", function()
    timer.Remove("BucketOutlineDelay")
    hook.Remove("PreDrawHalos", "BucketRandomatOutline")
end)