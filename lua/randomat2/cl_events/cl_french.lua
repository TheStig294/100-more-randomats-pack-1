local roleStringsOrig = {}
local roleStringsExtOrig = {}
local roleStringsPluralOrig = {}

net.Receive("FrenchRandomatBegin", function()
    if istable(ROLE_STRINGS) then
        roleStringsOrig = table.Copy(ROLE_STRINGS)
        ROLE_STRINGS[ROLE_BEGGAR] = "Mendiant"
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
    end

    if istable(ROLE_STRINGS_EXT) then
        roleStringsExtOrig = table.Copy(ROLE_STRINGS_EXT)
        ROLE_STRINGS_EXT[ROLE_BEGGAR] = "Un Mendiant"
        ROLE_STRINGS_EXT[ROLE_BODYSNATCHER] = "Un Voleur De Corps"
        ROLE_STRINGS_EXT[ROLE_BOXER] = "Un Boxeur"
        ROLE_STRINGS_EXT[ROLE_CLOWN] = "Un Pitre"
        ROLE_STRINGS_EXT[ROLE_COMMUNIST] = "Un Communiste"
        ROLE_STRINGS_EXT[ROLE_DEPUTY] = "Un Adjoint"
        ROLE_STRINGS_EXT[ROLE_DETECTIVE] = "Un Détective"
        ROLE_STRINGS_EXT[ROLE_DOCTOR] = "Un Médecin"
        ROLE_STRINGS_EXT[ROLE_DRUNK] = "Un Ivre"
        ROLE_STRINGS_EXT[ROLE_GLITCH] = "Un Bug Informatique"
        ROLE_STRINGS_EXT[ROLE_HYPNOTIST] = "Un Hypnotiseur"
        ROLE_STRINGS_EXT[ROLE_IMPERSONATOR] = "Un Imitateur"
        ROLE_STRINGS_EXT[ROLE_INNOCENT] = "Un Innocente"
        ROLE_STRINGS_EXT[ROLE_JESTER] = "Un Bouffon"
        ROLE_STRINGS_EXT[ROLE_KILLER] = "Un Tueur"
        ROLE_STRINGS_EXT[ROLE_LOOTGOBLIN] = "Un Butin Gobelin"
        ROLE_STRINGS_EXT[ROLE_MADSCIENTIST] = "Un Scientifique Fou"
        ROLE_STRINGS_EXT[ROLE_MEDIUM] = "Un Voyante"
        ROLE_STRINGS_EXT[ROLE_MERCENARY] = "Un Mercenaire"
        ROLE_STRINGS_EXT[ROLE_OLDMAN] = "Un Vieil Homme"
        ROLE_STRINGS_EXT[ROLE_PALADIN] = "Un Paladin"
        ROLE_STRINGS_EXT[ROLE_PARAMEDIC] = "Un Paramédical"
        ROLE_STRINGS_EXT[ROLE_PARASITE] = "Un Parasite"
        ROLE_STRINGS_EXT[ROLE_PHANTOM] = "Un Fantôme"
        ROLE_STRINGS_EXT[ROLE_QUACK] = "Un Charlatane"
        ROLE_STRINGS_EXT[ROLE_RANDOMAN] = "Un Homme Aléatoire"
        ROLE_STRINGS_EXT[ROLE_REVENGER] = "Un Vengeur"
        ROLE_STRINGS_EXT[ROLE_SANTA] = "Un Père Noël"
        ROLE_STRINGS_EXT[ROLE_SWAPPER] = "Un Échangeur"
        ROLE_STRINGS_EXT[ROLE_TAXIDERMIST] = "Un Taxidermiste"
        ROLE_STRINGS_EXT[ROLE_TRACKER] = "Un Traqueur"
        ROLE_STRINGS_EXT[ROLE_TRAITOR] = "Un Traitre"
        ROLE_STRINGS_EXT[ROLE_TRICKSTER] = "Un Filou"
        ROLE_STRINGS_EXT[ROLE_VAMPIRE] = "Un Vampire"
        ROLE_STRINGS_EXT[ROLE_VETERAN] = "Un Vétéran"
        ROLE_STRINGS_EXT[ROLE_ZOMBIE] = "Un Zombi"
    end

    if istable(ROLE_STRINGS_PLURAL) then
        roleStringsPluralOrig = table.Copy(ROLE_STRINGS_PLURAL)
        ROLE_STRINGS_PLURAL[ROLE_BEGGAR] = "Mendiants"
        ROLE_STRINGS_PLURAL[ROLE_BODYSNATCHER] = "Voleurs de corps"
        ROLE_STRINGS_PLURAL[ROLE_BOXER] = "Boxeurs"
        ROLE_STRINGS_PLURAL[ROLE_CLOWN] = "Pitres"
        ROLE_STRINGS_PLURAL[ROLE_COMMUNIST] = "Communistes"
        ROLE_STRINGS_PLURAL[ROLE_DEPUTY] = "Adjoints"
        ROLE_STRINGS_PLURAL[ROLE_DETECTIVE] = "Détectives"
        ROLE_STRINGS_PLURAL[ROLE_DOCTOR] = "Médecins"
        ROLE_STRINGS_PLURAL[ROLE_DRUNK] = "Ivres"
        ROLE_STRINGS_PLURAL[ROLE_GLITCH] = "Bugs Informatique"
        ROLE_STRINGS_PLURAL[ROLE_HYPNOTIST] = "Hypnotiseurs"
        ROLE_STRINGS_PLURAL[ROLE_IMPERSONATOR] = "Imitateurs"
        ROLE_STRINGS_PLURAL[ROLE_INNOCENT] = "Innocentes"
        ROLE_STRINGS_PLURAL[ROLE_JESTER] = "Bouffons"
        ROLE_STRINGS_PLURAL[ROLE_KILLER] = "Tueurs"
        ROLE_STRINGS_PLURAL[ROLE_LOOTGOBLIN] = "Butin Gobelins"
        ROLE_STRINGS_PLURAL[ROLE_MADSCIENTIST] = "Scientifiques Fou"
        ROLE_STRINGS_PLURAL[ROLE_MEDIUM] = "Voyantes"
        ROLE_STRINGS_PLURAL[ROLE_MERCENARY] = "Mercenaires"
        ROLE_STRINGS_PLURAL[ROLE_OLDMAN] = "Vieil Hommes"
        ROLE_STRINGS_PLURAL[ROLE_PALADIN] = "Paladins"
        ROLE_STRINGS_PLURAL[ROLE_PARAMEDIC] = "Paramédicals"
        ROLE_STRINGS_PLURAL[ROLE_PARASITE] = "Parasites"
        ROLE_STRINGS_PLURAL[ROLE_PHANTOM] = "Fantômes"
        ROLE_STRINGS_PLURAL[ROLE_QUACK] = "Charlatanes"
        ROLE_STRINGS_PLURAL[ROLE_RANDOMAN] = "Hommes Aléatoires"
        ROLE_STRINGS_PLURAL[ROLE_REVENGER] = "Vengeurs"
        ROLE_STRINGS_PLURAL[ROLE_SANTA] = "Père Noëls"
        ROLE_STRINGS_PLURAL[ROLE_SWAPPER] = "Échangeurs"
        ROLE_STRINGS_PLURAL[ROLE_TAXIDERMIST] = "Taxidermistes"
        ROLE_STRINGS_PLURAL[ROLE_TRACKER] = "Traqueurs"
        ROLE_STRINGS_PLURAL[ROLE_TRAITOR] = "Traitres"
        ROLE_STRINGS_PLURAL[ROLE_TRICKSTER] = "Filous"
        ROLE_STRINGS_PLURAL[ROLE_VAMPIRE] = "Vampires"
        ROLE_STRINGS_PLURAL[ROLE_VETERAN] = "Vétérans"
        ROLE_STRINGS_PLURAL[ROLE_ZOMBIE] = "Zombis"
    end

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
    ROLE_STRINGS = roleStringsOrig
    ROLE_STRINGS_EXT = roleStringsExtOrig
    ROLE_STRINGS_PLURAL = roleStringsPluralOrig

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