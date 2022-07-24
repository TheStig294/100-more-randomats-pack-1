net.Receive("BucketRandomatOutline", function()
    local bucket = GetGlobalEntity("RandomatBucketEnt")
    if not IsValid(bucket) then return end

    local bucketTable = {bucket}

    hook.Add("PreDrawHalos", "BucketRandomatOutline", function()
        halo.Add(bucketTable, Color(0, 255, 0), 0, 0, 1, true, true)
    end)
end)

net.Receive("BucketRandomatOutlineEnd", function()
    timer.Remove("BucketOutlineDelay")
    hook.Remove("PreDrawHalos", "BucketRandomatOutline")
end)