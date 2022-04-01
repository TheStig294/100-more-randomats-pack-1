net.Receive("FrenchRandomatBegin", function()
    ROLE_STRINGS[ROLE_BEGGAR] = "Gueux"
    ROLE_STRINGS[ROLE_BODYSNATCHER] = "Voleur De Corps"
    ROLE_STRINGS[ROLE_BOXER] = "Boxeur"
    ROLE_STRINGS[ROLE_CLOWN] = "Pitre"
    ROLE_STRINGS[ROLE_COMMUNIST] = "Communiste"
    ROLE_STRINGS[ROLE_DEPUTY] = "Adjoint"
    ROLE_STRINGS[ROLE_DETECTIVE] = "Détective"
    ROLE_STRINGS[ROLE_DOCTOR] = "Médecin"
    ROLE_STRINGS[ROLE_DRUNK] = "Ivre"
    ROLE_STRINGS[ROLE_GLITCH] = "Bug Informatique"
    ROLE_STRINGS[ROLE_HYPNOTIST] = "Hypnotiseur"
    ROLE_STRINGS[ROLE_IMPERSONATOR] = "Imitateur"
    ROLE_STRINGS[ROLE_INNOCENT] = "Innocente"
    ROLE_STRINGS[ROLE_JESTER] = "Bouffon"
    ROLE_STRINGS[ROLE_KILLER] = "Tueur"
    ROLE_STRINGS[ROLE_LOOTGOBLIN] = "Butin Gobelin"
    ROLE_STRINGS[ROLE_MADSCIENTIST] = "Scientifique Fou"
    ROLE_STRINGS[ROLE_MEDIUM] = "Voyante"
    ROLE_STRINGS[ROLE_MERCENARY] = "Mercenaire"
    ROLE_STRINGS[ROLE_OLDMAN] = "Vieil Homme"
    ROLE_STRINGS[ROLE_PALADIN] = "Paladin"
    ROLE_STRINGS[ROLE_PARAMEDIC] = "Paramédical"
    ROLE_STRINGS[ROLE_PARASITE] = "Parasite"
    ROLE_STRINGS[ROLE_PHANTOM] = "Fantôme"
    ROLE_STRINGS[ROLE_QUACK] = "Charlatane"
    ROLE_STRINGS[ROLE_RANDOMAN] = "Homme Aléatoire"
    ROLE_STRINGS[ROLE_REVENGER] = "Vengeur"
    ROLE_STRINGS[ROLE_SANTA] = "Père Noël"
    ROLE_STRINGS[ROLE_SWAPPER] = "Échangeur"
    ROLE_STRINGS[ROLE_TAXIDERMIST] = "Taxidermiste"
    ROLE_STRINGS[ROLE_TRACKER] = "Traqueur"
    ROLE_STRINGS[ROLE_TRAITOR] = "Traitre"
    ROLE_STRINGS[ROLE_TRICKSTER] = "Filou"
    ROLE_STRINGS[ROLE_VAMPIRE] = "Vampire"
    ROLE_STRINGS[ROLE_VETERAN] = "Vétéran"
    ROLE_STRINGS[ROLE_ZOMBIE] = "Zombi"

    for _, SWEPCopy in ipairs(weapons.GetList()) do
        local classname = WEPS.GetClass(SWEPCopy)

        if classname then
            local SWEP = weapons.GetStored(classname)

            if SWEP.PrintName then
                SWEP.origPrintName = SWEP.PrintName
            end

            if SWEP.EquipMenuData and SWEP.EquipMenuData.type then
                SWEP.EquipMenuData.origType = SWEP.EquipMenuData.type
            end

            if SWEP.EquipMenuData and SWEP.EquipMenuData.desc then
                SWEP.EquipMenuData.origDesc = SWEP.EquipMenuData.desc
            end
        end
    end

    weapons.GetStored("weapon_ttt_randomat").PrintName = "Machine Aléatoire"
    weapons.GetStored("weapon_ttt_randomat").EquipMenuData.type = "item_weapon"
    weapons.GetStored("weapon_ttt_randomat").EquipMenuData.desc = "La machine aléatoire fera quelque chose d'aléatoire!\nQui a deviné ça!"
    RunConsoleCommand("ttt_reset_weapons_cache")
end)

net.Receive("FrenchRandomatEnd", function()
    ROLE_STRINGS[ROLE_BEGGAR] = "Beggar"
    ROLE_STRINGS[ROLE_BODYSNATCHER] = "Bodysnatcher"
    ROLE_STRINGS[ROLE_BOXER] = "Boxer"
    ROLE_STRINGS[ROLE_CLOWN] = "Clown"
    ROLE_STRINGS[ROLE_COMMUNIST] = "Communist"
    ROLE_STRINGS[ROLE_DEPUTY] = "Deputy"
    ROLE_STRINGS[ROLE_DETECTIVE] = "Detective"
    ROLE_STRINGS[ROLE_DOCTOR] = "Doctor"
    ROLE_STRINGS[ROLE_DRUNK] = "Drunk"
    ROLE_STRINGS[ROLE_GLITCH] = "Glitch"
    ROLE_STRINGS[ROLE_HYPNOTIST] = "Hypnotist"
    ROLE_STRINGS[ROLE_IMPERSONATOR] = "Impersonator"
    ROLE_STRINGS[ROLE_INNOCENT] = "Innocent"
    ROLE_STRINGS[ROLE_JESTER] = "Jester"
    ROLE_STRINGS[ROLE_KILLER] = "Killer"
    ROLE_STRINGS[ROLE_LOOTGOBLIN] = "Loot Goblin"
    ROLE_STRINGS[ROLE_MADSCIENTIST] = "Mad Scientist"
    ROLE_STRINGS[ROLE_MEDIUM] = "Meduim"
    ROLE_STRINGS[ROLE_MERCENARY] = "Mercenary"
    ROLE_STRINGS[ROLE_OLDMAN] = "Old Man"
    ROLE_STRINGS[ROLE_PALADIN] = "Paladin"
    ROLE_STRINGS[ROLE_PARAMEDIC] = "Paramedic"
    ROLE_STRINGS[ROLE_PARASITE] = "Parasite"
    ROLE_STRINGS[ROLE_PHANTOM] = "Phantom"
    ROLE_STRINGS[ROLE_QUACK] = "Quack"
    ROLE_STRINGS[ROLE_RANDOMAN] = "Randoman"
    ROLE_STRINGS[ROLE_REVENGER] = "Revenger"
    ROLE_STRINGS[ROLE_SANTA] = "Santa"
    ROLE_STRINGS[ROLE_SWAPPER] = "Swapper"
    ROLE_STRINGS[ROLE_TAXIDERMIST] = "Taxidermist"
    ROLE_STRINGS[ROLE_TRACKER] = "Tracker"
    ROLE_STRINGS[ROLE_TRAITOR] = "Traitor"
    ROLE_STRINGS[ROLE_TRICKSTER] = "Trickster"
    ROLE_STRINGS[ROLE_VAMPIRE] = "Vampire"
    ROLE_STRINGS[ROLE_VETERAN] = "Veteran"
    ROLE_STRINGS[ROLE_ZOMBIE] = "Zombie"

    for _, SWEPCopy in ipairs(weapons.GetList()) do
        local classname = WEPS.GetClass(SWEPCopy)

        if classname then
            local SWEP = weapons.GetStored(classname)

            if SWEP.origPrintName then
                SWEP.PrintName = SWEP.origPrintName
            end

            if SWEP.EquipMenuData and SWEP.EquipMenuData.origType then
                SWEP.EquipMenuData.type = SWEP.EquipMenuData.origType
            end

            if SWEP.EquipMenuData and SWEP.EquipMenuData.origDesc then
                SWEP.EquipMenuData.desc = SWEP.EquipMenuData.origDesc
            end
        end
    end

    RunConsoleCommand("ttt_reset_weapons_cache")
end)