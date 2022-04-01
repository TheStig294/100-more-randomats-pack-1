net.Receive("FrenchRandomatBegin", function()
    UpdateRoleStrings()
    ROLE_STRINGS[ROLE_INNOCENT] = "Innocente"
end)

net.Receive("FrenchRandomatEnd", function()
    ROLE_STRINGS[ROLE_INNOCENT] = "Innocent"
end)