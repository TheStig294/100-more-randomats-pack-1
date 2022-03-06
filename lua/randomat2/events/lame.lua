local EVENT = {}
EVENT.Title = "... That's Lame."
EVENT.Description = "Nothing happens."
EVENT.id = "lame"

EVENT.Categories = {"smallimpact"}

-- Wow, 'nothing happens', you weren't kidding.
function EVENT:Begin()
end

function EVENT:End()
end

Randomat:register(EVENT)