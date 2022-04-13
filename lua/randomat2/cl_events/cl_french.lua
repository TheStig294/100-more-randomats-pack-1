local roleStringsOrig = {}
local roleStringsExtOrig = {}
local roleStringsPluralOrig = {}
local customPassiveItemsOrig = {}

net.Receive("FrenchRandomatBegin", function()
    RunConsoleCommand("ttt_language", "FrançaisRandomat")
    -- Renaming roles
    local translatedRoles = {}
    translatedRoles["Mendiant"] = ROLE_BEGGAR
    translatedRoles["Voleur De Corps"] = ROLE_BODYSNATCHER
    translatedRoles["Boxeur"] = ROLE_BOXER
    translatedRoles["Pitre"] = ROLE_CLOWN
    translatedRoles["Communiste"] = ROLE_COMMUNIST
    translatedRoles["Adjoint"] = ROLE_DEPUTY
    translatedRoles["Détective"] = ROLE_DETECTIVE
    translatedRoles["Médecin"] = ROLE_DOCTOR
    translatedRoles["Ivre"] = ROLE_DRUNK
    translatedRoles["Bug Informatique"] = ROLE_GLITCH
    translatedRoles["Hypnotiseur"] = ROLE_HYPNOTIST
    translatedRoles["Imitateur"] = ROLE_IMPERSONATOR
    translatedRoles["Innocente"] = ROLE_INNOCENT
    translatedRoles["Bouffon"] = ROLE_JESTER
    translatedRoles["Tueur"] = ROLE_KILLER
    translatedRoles["Butin Gobelin"] = ROLE_LOOTGOBLIN
    translatedRoles["Scientifique Fou"] = ROLE_MADSCIENTIST
    translatedRoles["Voyante"] = ROLE_MEDIUM
    translatedRoles["Mercenaire"] = ROLE_MERCENARY
    translatedRoles["Vieil Homme"] = ROLE_OLDMAN
    translatedRoles["Paladin"] = ROLE_PALADIN
    translatedRoles["Paramédical"] = ROLE_PARAMEDIC
    translatedRoles["Parasite"] = ROLE_PARASITE
    translatedRoles["Fantôme"] = ROLE_PHANTOM
    translatedRoles["Charlatane"] = ROLE_QUACK
    translatedRoles["Homme Aléatoire"] = ROLE_RANDOMAN
    translatedRoles["Vengeur"] = ROLE_REVENGER
    translatedRoles["Père Noël"] = ROLE_SANTA
    translatedRoles["Échangeur"] = ROLE_SWAPPER
    translatedRoles["Taxidermiste"] = ROLE_TAXIDERMIST
    translatedRoles["Traqueur"] = ROLE_TRACKER
    translatedRoles["Traitre"] = ROLE_TRAITOR
    translatedRoles["Filou"] = ROLE_TRICKSTER
    translatedRoles["Vampire"] = ROLE_VAMPIRE
    translatedRoles["Vétéran"] = ROLE_VETERAN
    translatedRoles["Zombi"] = ROLE_ZOMBIE

    if istable(ROLE_STRINGS) then
        roleStringsOrig = table.Copy(ROLE_STRINGS)

        for roleName, roleID in pairs(translatedRoles) do
            ROLE_STRINGS[roleID] = roleName
        end
    end

    table.Empty(translatedRoles)
    translatedRoles["Un Mendiant"] = ROLE_BEGGAR
    translatedRoles["Un Voleur De Corps"] = ROLE_BODYSNATCHER
    translatedRoles["Un Boxeur"] = ROLE_BOXER
    translatedRoles["Un Pitre"] = ROLE_CLOWN
    translatedRoles["Un Communiste"] = ROLE_COMMUNIST
    translatedRoles["Un Adjoint"] = ROLE_DEPUTY
    translatedRoles["Un Détective"] = ROLE_DETECTIVE
    translatedRoles["Un Médecin"] = ROLE_DOCTOR
    translatedRoles["Un Ivre"] = ROLE_DRUNK
    translatedRoles["Un Bug Informatique"] = ROLE_GLITCH
    translatedRoles["Un Hypnotiseur"] = ROLE_HYPNOTIST
    translatedRoles["Un Imitateur"] = ROLE_IMPERSONATOR
    translatedRoles["Un Innocente"] = ROLE_INNOCENT
    translatedRoles["Un Bouffon"] = ROLE_JESTER
    translatedRoles["Un Tueur"] = ROLE_KILLER
    translatedRoles["Un Butin Gobelin"] = ROLE_LOOTGOBLIN
    translatedRoles["Un Scientifique Fou"] = ROLE_MADSCIENTIST
    translatedRoles["Un Voyante"] = ROLE_MEDIUM
    translatedRoles["Un Mercenaire"] = ROLE_MERCENARY
    translatedRoles["Un Vieil Homme"] = ROLE_OLDMAN
    translatedRoles["Un Paladin"] = ROLE_PALADIN
    translatedRoles["Un Paramédical"] = ROLE_PARAMEDIC
    translatedRoles["Un Parasite"] = ROLE_PARASITE
    translatedRoles["Un Fantôme"] = ROLE_PHANTOM
    translatedRoles["Un Charlatane"] = ROLE_QUACK
    translatedRoles["Un Homme Aléatoire"] = ROLE_RANDOMAN
    translatedRoles["Un Vengeur"] = ROLE_REVENGER
    translatedRoles["Un Père Noël"] = ROLE_SANTA
    translatedRoles["Un Échangeur"] = ROLE_SWAPPER
    translatedRoles["Un Taxidermiste"] = ROLE_TAXIDERMIST
    translatedRoles["Un Traqueur"] = ROLE_TRACKER
    translatedRoles["Un Traitre"] = ROLE_TRAITOR
    translatedRoles["Un Filou"] = ROLE_TRICKSTER
    translatedRoles["Un Vampire"] = ROLE_VAMPIRE
    translatedRoles["Un Vétéran"] = ROLE_VETERAN
    translatedRoles["Un Zombi"] = ROLE_ZOMBIE

    if istable(ROLE_STRINGS_EXT) then
        roleStringsExtOrig = table.Copy(ROLE_STRINGS_EXT)

        for roleName, roleID in pairs(translatedRoles) do
            ROLE_STRINGS_EXT[roleID] = roleName
        end
    end

    table.Empty(translatedRoles)
    translatedRoles["Mendiants"] = ROLE_BEGGAR
    translatedRoles["Voleurs De Corps"] = ROLE_BODYSNATCHER
    translatedRoles["Boxeurs"] = ROLE_BOXER
    translatedRoles["Pitres"] = ROLE_CLOWN
    translatedRoles["Communistes"] = ROLE_COMMUNIST
    translatedRoles["Adjoints"] = ROLE_DEPUTY
    translatedRoles["Détectives"] = ROLE_DETECTIVE
    translatedRoles["Médecins"] = ROLE_DOCTOR
    translatedRoles["Ivres"] = ROLE_DRUNK
    translatedRoles["Bugs Informatique"] = ROLE_GLITCH
    translatedRoles["Hypnotiseurs"] = ROLE_HYPNOTIST
    translatedRoles["Imitateurs"] = ROLE_IMPERSONATOR
    translatedRoles["Innocentes"] = ROLE_INNOCENT
    translatedRoles["Bouffons"] = ROLE_JESTER
    translatedRoles["Tueurs"] = ROLE_KILLER
    translatedRoles["Butin Gobelins"] = ROLE_LOOTGOBLIN
    translatedRoles["Scientifiques Fou"] = ROLE_MADSCIENTIST
    translatedRoles["Voyantes"] = ROLE_MEDIUM
    translatedRoles["Mercenaires"] = ROLE_MERCENARY
    translatedRoles["Vieil Hommes"] = ROLE_OLDMAN
    translatedRoles["Paladins"] = ROLE_PALADIN
    translatedRoles["Paramédicals"] = ROLE_PARAMEDIC
    translatedRoles["Parasites"] = ROLE_PARASITE
    translatedRoles["Fantômes"] = ROLE_PHANTOM
    translatedRoles["Charlatanes"] = ROLE_QUACK
    translatedRoles["Hommes Aléatoire"] = ROLE_RANDOMAN
    translatedRoles["Vengeurs"] = ROLE_REVENGER
    translatedRoles["Père Noëls"] = ROLE_SANTA
    translatedRoles["Échangeurs"] = ROLE_SWAPPER
    translatedRoles["Taxidermistes"] = ROLE_TAXIDERMIST
    translatedRoles["Traqueurs"] = ROLE_TRACKER
    translatedRoles["Traitres"] = ROLE_TRAITOR
    translatedRoles["Filous"] = ROLE_TRICKSTER
    translatedRoles["Vampires"] = ROLE_VAMPIRE
    translatedRoles["Vétérans"] = ROLE_VETERAN
    translatedRoles["Zombis"] = ROLE_ZOMBIE

    if istable(ROLE_STRINGS_PLURAL) then
        roleStringsPluralOrig = table.Copy(ROLE_STRINGS_PLURAL)

        for roleName, roleID in pairs(translatedRoles) do
            ROLE_STRINGS_PLURAL[roleID] = roleName
        end
    end

    -- Renaming custom passive shop items
    if not istable(SHOP_ROLES) then
        SHOP_ROLES = {}
        SHOP_ROLES[ROLE_DETECTIVE] = true
        SHOP_ROLES[ROLE_TRAITOR] = true
    end

    if not isnumber(ROLE_MAX) then
        ROLE_MAX = 2
    end

    for role = 1, ROLE_MAX do
        if SHOP_ROLES[role] then
            customPassiveItemsOrig[role] = table.Copy(EquipmentItems[role])

            for _, equ in pairs(EquipmentItems[role]) do
                if equ.id and EQUIP_ASC and equ.id == EQUIP_ASC then
                    equ.name = "Un Deuxième Chance"
                    equ.desc = "Petite chance d'être ressuscité à la mort. \n\nAprès avoir tué quelqu'un, les chances augmentent."
                elseif equ.id and EQUIP_DEMONIC_POSSESSION and equ.id == EQUIP_DEMONIC_POSSESSION then
                    equ.name = "Possession démoniaque"
                    equ.desc = "Permet un contrôle limité sur quelqu'un après sa mort. \n\nUne fois spectateur, faites un clic droit pour faire défiler les joueurs vivants.\n\nAppuyez sur R pour commencer à les manipuler."
                elseif equ.id and EQUIP_DOUBLETAP and equ.id == EQUIP_DOUBLETAP then
                    equ.name = "Tapez deux fois"
                    equ.desc = "Tirez 50 % plus vite avec n'importe quel pistolet ordinaire."
                elseif equ.id and EQUIP_JUGGERNOG and equ.id == EQUIP_JUGGERNOG then
                    equ.name = "Mastodonte"
                    equ.desc = "Guérit complètement et accorde 50% de santé en plus."
                elseif equ.id and EQUIP_PHD and equ.id == EQUIP_PHD then
                    equ.name = "Disque de doctorat"
                    equ.desc = "Au lieu de subir des dégâts de chute, provoquez une explosion de dégâts importants à l'endroit où vous atterrissez. \n\nConfère l'immunité aux explosions."
                elseif equ.id and EQUIP_SPEEDCOLA and equ.id == EQUIP_SPEEDCOLA then
                    equ.name = "Cola rapide"
                    equ.desc = "Double votre vitesse de rechargement des armes ordinaires."
                elseif equ.id and EQUIP_STAMINUP and equ.id == EQUIP_STAMINUP then
                    equ.name = "Endurance"
                    equ.desc = "Augmentez considérablement la vitesse de sprint!"
                elseif equ.id and EQUIP_BUNKER and equ.id == EQUIP_BUNKER then
                    equ.name = "Bunker de Bruh"
                    equ.desc = "Craquement détecté! Présentez-vous au bunker bruh \nimmédiatement! \nCrée un bunker autour de vous lorsque vous subissez des dégâts."
                elseif equ.id and EQUIP_CLAIRVOYANT and equ.id == EQUIP_CLAIRVOYANT then
                    equ.name = "Voyance"
                    equ.desc = "Quand quelqu'un meurt, vous pouvez voir son corps pendant un bref instant."
                end
            end
        end
    end

    -- Renaming weapons
    local translatedWeapons = {
        weapon_ttt_randomat = {
            name = "Machine Aléatoire",
            type = "item_weapon",
            desc = "La machine aléatoire fera quelque chose d'aléatoire!\nQui a deviné ça!"
        },
        weapon_ttt_glock = {
            name = "Pistolet-Mitrailleur"
        }
    }

    for _, SWEPCopy in ipairs(weapons.GetList()) do
        local classname = WEPS.GetClass(SWEPCopy)

        if translatedWeapons[classname] then
            local SWEP = weapons.GetStored(classname)

            if SWEP.PrintName then
                SWEP.origPrintName = SWEP.PrintName
                SWEP.PrintName = translatedWeapons[classname].name
            end

            if SWEP.EquipMenuData and SWEP.EquipMenuData.type then
                SWEP.EquipMenuData.origType = SWEP.EquipMenuData.type
                SWEP.EquipMenuData.type = translatedWeapons[classname].type
            end

            if SWEP.EquipMenuData and SWEP.EquipMenuData.desc then
                SWEP.EquipMenuData.origDesc = SWEP.EquipMenuData.desc
                SWEP.EquipMenuData.desc = translatedWeapons[classname].desc
            end
        end
    end

    -- Sets the names of held weapons and ones on the ground
    for _, ent in ipairs(ents.GetAll()) do
        local classname = ent:GetClass()

        if classname and translatedWeapons[classname] and translatedWeapons[classname].name then
            wep.PrintName = translatedWeapons[classname].name
        end
    end

    RunConsoleCommand("ttt_reset_weapons_cache")
end)

net.Receive("FrenchRandomatEnd", function()
    RunConsoleCommand("ttt_language", "auto")
    -- Resets the names of roles
    ROLE_STRINGS = roleStringsOrig
    ROLE_STRINGS_EXT = roleStringsExtOrig
    ROLE_STRINGS_PLURAL = roleStringsPluralOrig

    -- Resets the names of custom passive items
    for role = 1, ROLE_MAX do
        if SHOP_ROLES[role] then
            EquipmentItems[role] = customPassiveItemsOrig[role]
        end
    end

    -- Resets the names of newly created weapons
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

    -- Resets the names of held weapons and ones on the ground
    for _, ent in ipairs(ents.GetAll()) do
        if ent.origPrintName then
            wep.PrintName = ent.origPrintName
        end
    end

    RunConsoleCommand("ttt_reset_weapons_cache")
end)