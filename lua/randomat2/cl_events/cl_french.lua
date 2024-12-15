local roleStringsOrig
local roleStringsExtOrig
local roleStringsPluralOrig
local customPassiveItemsOrig
local flagPanelFrame
local music

local function EndFrenchRandomat()
    if eventEnded then return end
    RunConsoleCommand("ttt_language", "auto")
    -- Resets the names of roles
    ROLE_STRINGS = roleStringsOrig or ROLE_STRINGS
    ROLE_STRINGS_EXT = roleStringsExtOrig or ROLE_STRINGS_EXT
    ROLE_STRINGS_PLURAL = roleStringsPluralOrig or ROLE_STRINGS_PLURAL

    -- Resets the names of custom passive items
    if customPassiveItemsOrig then
        for role = 1, ROLE_MAX do
            if SHOP_ROLES[role] and EquipmentItems[role] then
                EquipmentItems[role] = customPassiveItemsOrig[role] or EquipmentItems[role]
            end
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
            ent.PrintName = ent.origPrintName
        end
    end

    RunConsoleCommand("ttt_reset_weapons_cache")
    -- Plays the ending music
    local endingTimer = 0

    if music then
        timer.Remove("FrenchRandomatMusicLoop")
        RunConsoleCommand("stopsound")
        endingTimer = 9

        timer.Simple(0.1, function()
            surface.PlaySound("french/chic_magnet_end.mp3")
        end)
    end

    hook.Remove("PlayerButtonDown", "FrenchMuteMusicButton")

    -- Remove the French flag overlay,
    -- if music is playing, in time with the music ending
    timer.Simple(endingTimer, function()
        if flagPanelFrame ~= nil then
            flagPanelFrame:Close()
            flagPanelFrame = nil
        end
    end)

    -- Remove the hooks trying to end this event because if we made it this far we're done
    hook.Remove("TTTEndRound", "FrenchRandomatClientEnd")
    hook.Remove("TTTPrepareRound", "FrenchRandomatClientEnd")
    hook.Remove("TTTBeginRound", "FrenchRandomatClientEnd")
    hook.Remove("ShutDown", "FrenchRandomatShutDown")
end

net.Receive("FrenchRandomatBegin", function()
    -- Because this event refuses to end properly when the end function is called as a net message from the server... ugh
    hook.Add("TTTEndRound", "FrenchRandomatClientEnd", EndFrenchRandomat)
    hook.Add("TTTPrepareRound", "FrenchRandomatClientEnd", EndFrenchRandomat)
    hook.Add("TTTBeginRound", "FrenchRandomatClientEnd", EndFrenchRandomat)

    -- And if the client closes the game before the round ends, reset their language setting
    hook.Add("ShutDown", "FrenchRandomatShutDown", function()
        RunConsoleCommand("ttt_language", "auto")
    end)

    -- Change the client's language to the Randomat's custom French language (Courtesy of manually shoving a million lines of strings into Google Translate...)
    RunConsoleCommand("ttt_language", "FrançaisRandomat")
    -- Renaming roles
    local translatedRoles = {}
    -- Base Custom Roles --
    translatedRoles["Aucune"] = ROLE_NONE
    translatedRoles["Innocente"] = ROLE_INNOCENT
    translatedRoles["Traitre"] = ROLE_TRAITOR
    translatedRoles["Détective"] = ROLE_DETECTIVE
    translatedRoles["Bouffon"] = ROLE_JESTER
    translatedRoles["Échangeur"] = ROLE_SWAPPER
    translatedRoles["Problème"] = ROLE_GLITCH
    translatedRoles["Fantôme"] = ROLE_PHANTOM
    translatedRoles["Hypnotiseur"] = ROLE_HYPNOTIST
    translatedRoles["Vengeur"] = ROLE_REVENGER
    translatedRoles["Ivre"] = ROLE_DRUNK
    translatedRoles["Clown"] = ROLE_CLOWN
    translatedRoles["Adjoint"] = ROLE_DEPUTY
    translatedRoles["Imitateur"] = ROLE_IMPERSONATOR
    translatedRoles["Mendiant"] = ROLE_BEGGAR
    translatedRoles["Vieil Homme"] = ROLE_OLDMAN
    translatedRoles["Mercenaire"] = ROLE_MERCENARY
    translatedRoles["Voleur de Corps"] = ROLE_BODYSNATCHER
    translatedRoles["Vétéran"] = ROLE_VETERAN
    translatedRoles["Assassin"] = ROLE_ASSASSIN
    translatedRoles["Tueur"] = ROLE_KILLER
    translatedRoles["Zombi"] = ROLE_ZOMBIE
    translatedRoles["Vampire"] = ROLE_VAMPIRE
    translatedRoles["Médecin"] = ROLE_DOCTOR
    translatedRoles["Charlatan"] = ROLE_QUACK
    translatedRoles["Parasite"] = ROLE_PARASITE
    translatedRoles["Filou"] = ROLE_TRICKSTER
    translatedRoles["Paramédical"] = ROLE_PARAMEDIC
    translatedRoles["Scientifique Fou"] = ROLE_MADSCIENTIST
    translatedRoles["Paladin"] = ROLE_PALADIN
    translatedRoles["Traqueur"] = ROLE_TRACKER
    translatedRoles["Voyante"] = ROLE_MEDIUM
    translatedRoles["Butin Gobelin"] = ROLE_LOOTGOBLIN
    translatedRoles["Transfuge"] = ROLE_TURNCOAT
    translatedRoles["Sapeur"] = ROLE_SAPPER
    translatedRoles["Informateur"] = ROLE_INFORMANT
    translatedRoles["Maréchal"] = ROLE_MARSHAL
    translatedRoles["Infecté"] = ROLE_INFECTED
    translatedRoles["Cupidon"] = ROLE_CUPID
    translatedRoles["Ombre"] = ROLE_SHADOW
    translatedRoles["Éponge"] = ROLE_SPONGE
    translatedRoles["Incendiaire"] = ROLE_ARSONIST
    translatedRoles["Espionner"] = ROLE_SPY
    translatedRoles["Esprit de la Ruche"] = ROLE_HIVEMIND
    translatedRoles["Devineur"] = ROLE_GUESSER
    translatedRoles["Intendante"] = ROLE_QUARTERMASTER
    translatedRoles["Justicier"] = ROLE_VINDICATOR
    -- Jingle Jam Pack Roles --
    translatedRoles["Boxeur"] = ROLE_BOXER
    translatedRoles["Communiste"] = ROLE_COMMUNIST
    translatedRoles["Homme Aléatoire"] = ROLE_RANDOMAN
    translatedRoles["Père Noël"] = ROLE_SANTA
    translatedRoles["Taxidermiste"] = ROLE_TAXIDERMIST
    translatedRoles["Détective Clown"] = ROLE_DETECTOCLOWN
    translatedRoles["Plus Faux"] = ROLE_FAKER
    translatedRoles["Krampus"] = ROLE_KRAMPUS
    translatedRoles["Administrateur"] = ROLE_ADMIN
    translatedRoles["Chuchoteur Fantôme"] = ROLE_GHOSTWHISPERER
    translatedRoles["Renégate"] = ROLE_RENEGADE
    translatedRoles["Lié à L'âme"] = ROLE_SOULBOUND
    translatedRoles["Âme Soeur"] = ROLE_SOULMAGE
    translatedRoles["Élémentaliste"] = ROLE_ELEMENTALIST
    translatedRoles["Médecin"] = ROLE_PHYSICIAN
    -- External Roles --
    translatedRoles["Annonceur"] = ROLE_ANNOUNCER
    translatedRoles["Serviteur de L'effroi"] = ROLE_DREADTHRALL
    translatedRoles["Français"] = ROLE_FRENCHMAN
    translatedRoles["Opossum"] = ROLE_POSSUM
    translatedRoles["Invocateur"] = ROLE_SUMMONER
    translatedRoles["La Chose"] = ROLE_THETHING
    -- Randomat Roles --
    translatedRoles["Yéti"] = ROLE_YETI
    translatedRoles["Abeille"] = ROLE_BEE
    translatedRoles["Reine Des Abeilles"] = ROLE_QUEENBEE
    translatedRoles["Elfe"] = ROLE_ELF

    if istable(ROLE_STRINGS) then
        roleStringsOrig = table.Copy(ROLE_STRINGS)

        for roleName, roleID in pairs(translatedRoles) do
            ROLE_STRINGS[roleID] = roleName
        end
    end

    table.Empty(translatedRoles)
    -- Base Custom Roles --
    translatedRoles["Un Aucune"] = ROLE_NONE
    translatedRoles["Un Innocente"] = ROLE_INNOCENT
    translatedRoles["Un Traitre"] = ROLE_TRAITOR
    translatedRoles["Un Détective"] = ROLE_DETECTIVE
    translatedRoles["Un Bouffon"] = ROLE_JESTER
    translatedRoles["Un Échangeur"] = ROLE_SWAPPER
    translatedRoles["Un Problème"] = ROLE_GLITCH
    translatedRoles["Un Fantôme"] = ROLE_PHANTOM
    translatedRoles["Un Hypnotiseur"] = ROLE_HYPNOTIST
    translatedRoles["Un Vengeur"] = ROLE_REVENGER
    translatedRoles["Un Ivre"] = ROLE_DRUNK
    translatedRoles["Un Clown"] = ROLE_CLOWN
    translatedRoles["Un Adjoint"] = ROLE_DEPUTY
    translatedRoles["Un Imitateur"] = ROLE_IMPERSONATOR
    translatedRoles["Un Mendiant"] = ROLE_BEGGAR
    translatedRoles["Un Vieil Homme"] = ROLE_OLDMAN
    translatedRoles["Un Mercenaire"] = ROLE_MERCENARY
    translatedRoles["Un Voleur de Corps"] = ROLE_BODYSNATCHER
    translatedRoles["Un Vétéran"] = ROLE_VETERAN
    translatedRoles["Un Assassin"] = ROLE_ASSASSIN
    translatedRoles["Un Tueur"] = ROLE_KILLER
    translatedRoles["Un Zombi"] = ROLE_ZOMBIE
    translatedRoles["Un Vampire"] = ROLE_VAMPIRE
    translatedRoles["Un Médecin"] = ROLE_DOCTOR
    translatedRoles["Un Charlatan"] = ROLE_QUACK
    translatedRoles["Un Parasite"] = ROLE_PARASITE
    translatedRoles["Un Filou"] = ROLE_TRICKSTER
    translatedRoles["Un Paramédical"] = ROLE_PARAMEDIC
    translatedRoles["Un Scientifique Fou"] = ROLE_MADSCIENTIST
    translatedRoles["Un Paladin"] = ROLE_PALADIN
    translatedRoles["Un Traqueur"] = ROLE_TRACKER
    translatedRoles["Un Voyante"] = ROLE_MEDIUM
    translatedRoles["Un Butin Gobelin"] = ROLE_LOOTGOBLIN
    translatedRoles["Un Transfuge"] = ROLE_TURNCOAT
    translatedRoles["Un Sapeur"] = ROLE_SAPPER
    translatedRoles["Un Informateur"] = ROLE_INFORMANT
    translatedRoles["Un Maréchal"] = ROLE_MARSHAL
    translatedRoles["Un Infecté"] = ROLE_INFECTED
    translatedRoles["Un Cupidon"] = ROLE_CUPID
    translatedRoles["Un Ombre"] = ROLE_SHADOW
    translatedRoles["Un Éponge"] = ROLE_SPONGE
    translatedRoles["Un Incendiaire"] = ROLE_ARSONIST
    translatedRoles["Un Espionner"] = ROLE_SPY
    translatedRoles["Un Esprit de la Ruche"] = ROLE_HIVEMIND
    translatedRoles["Un Devineur"] = ROLE_GUESSER
    translatedRoles["Un Intendante"] = ROLE_QUARTERMASTER
    translatedRoles["Un Justicier"] = ROLE_VINDICATOR
    -- Jingle Jam Pack Roles --
    translatedRoles["Boxeur"] = ROLE_BOXER
    translatedRoles["Communiste"] = ROLE_COMMUNIST
    translatedRoles["Homme Aléatoire"] = ROLE_RANDOMAN
    translatedRoles["Père Noël"] = ROLE_SANTA
    translatedRoles["Taxidermiste"] = ROLE_TAXIDERMIST
    translatedRoles["Détective Clown"] = ROLE_DETECTOCLOWN
    translatedRoles["Plus Faux"] = ROLE_FAKER
    translatedRoles["Krampus"] = ROLE_KRAMPUS
    translatedRoles["Administrateur"] = ROLE_ADMIN
    translatedRoles["Chuchoteur Fantôme"] = ROLE_GHOSTWHISPERER
    translatedRoles["Renégate"] = ROLE_RENEGADE
    translatedRoles["Lié à L'âme"] = ROLE_SOULBOUND
    translatedRoles["Âme Soeur"] = ROLE_SOULMAGE
    translatedRoles["Élémentaliste"] = ROLE_ELEMENTALIST
    translatedRoles["Médecin"] = ROLE_PHYSICIAN
    -- External Roles --
    translatedRoles["Annonceur"] = ROLE_ANNOUNCER
    translatedRoles["Serviteur de L'effroi"] = ROLE_DREADTHRALL
    translatedRoles["Français"] = ROLE_FRENCHMAN
    translatedRoles["Opossum"] = ROLE_POSSUM
    translatedRoles["Invocateur"] = ROLE_SUMMONER
    translatedRoles["La Chose"] = ROLE_THETHING
    -- Randomat Roles --
    translatedRoles["Yéti"] = ROLE_YETI
    translatedRoles["Abeille"] = ROLE_BEE
    translatedRoles["Reine Des Abeilles"] = ROLE_QUEENBEE
    translatedRoles["Elfe"] = ROLE_ELF

    if istable(ROLE_STRINGS_EXT) then
        roleStringsExtOrig = table.Copy(ROLE_STRINGS_EXT)

        for roleName, roleID in pairs(translatedRoles) do
            ROLE_STRINGS_EXT[roleID] = roleName
        end
    end

    table.Empty(translatedRoles)
    -- Base Custom Roles --
    translatedRoles["Aucunes"] = ROLE_NONE
    translatedRoles["Innocentes"] = ROLE_INNOCENT
    translatedRoles["Traitres"] = ROLE_TRAITOR
    translatedRoles["Détectives"] = ROLE_DETECTIVE
    translatedRoles["Bouffons"] = ROLE_JESTER
    translatedRoles["Échangeurs"] = ROLE_SWAPPER
    translatedRoles["Problèmes"] = ROLE_GLITCH
    translatedRoles["Fantômes"] = ROLE_PHANTOM
    translatedRoles["Hypnotiseurs"] = ROLE_HYPNOTIST
    translatedRoles["Vengeurs"] = ROLE_REVENGER
    translatedRoles["Ivres"] = ROLE_DRUNK
    translatedRoles["Clowns"] = ROLE_CLOWN
    translatedRoles["Adjoints"] = ROLE_DEPUTY
    translatedRoles["Imitateurs"] = ROLE_IMPERSONATOR
    translatedRoles["Mendiants"] = ROLE_BEGGAR
    translatedRoles["Vieux Hommes"] = ROLE_OLDMAN
    translatedRoles["Mercenaires"] = ROLE_MERCENARY
    translatedRoles["Voleurs de Corps"] = ROLE_BODYSNATCHER
    translatedRoles["Vétérans"] = ROLE_VETERAN
    translatedRoles["Assassins"] = ROLE_ASSASSIN
    translatedRoles["Tueurs"] = ROLE_KILLER
    translatedRoles["Zombis"] = ROLE_ZOMBIE
    translatedRoles["Vampires"] = ROLE_VAMPIRE
    translatedRoles["Médecins"] = ROLE_DOCTOR
    translatedRoles["Charlatans"] = ROLE_QUACK
    translatedRoles["Parasites"] = ROLE_PARASITE
    translatedRoles["Filous"] = ROLE_TRICKSTER
    translatedRoles["Paramédicals"] = ROLE_PARAMEDIC
    translatedRoles["Scientifiques Fous"] = ROLE_MADSCIENTIST
    translatedRoles["Paladins"] = ROLE_PALADIN
    translatedRoles["Traqueurs"] = ROLE_TRACKER
    translatedRoles["Voyantes"] = ROLE_MEDIUM
    translatedRoles["Pillez Les Gobelins"] = ROLE_LOOTGOBLIN
    translatedRoles["Transfuges"] = ROLE_TURNCOAT
    translatedRoles["Sapeurs"] = ROLE_SAPPER
    translatedRoles["Informateurs"] = ROLE_INFORMANT
    translatedRoles["Les Maréchaux"] = ROLE_MARSHAL
    translatedRoles["Infectés"] = ROLE_INFECTED
    translatedRoles["Cupidons"] = ROLE_CUPID
    translatedRoles["Ombres"] = ROLE_SHADOW
    translatedRoles["Éponges"] = ROLE_SPONGE
    translatedRoles["Incendiaires"] = ROLE_ARSONIST
    translatedRoles["Espionners"] = ROLE_SPY
    translatedRoles["Esprits de la Ruche"] = ROLE_HIVEMIND
    translatedRoles["Devineurs"] = ROLE_GUESSER
    translatedRoles["Intendantes"] = ROLE_QUARTERMASTER
    translatedRoles["Les Justiciers"] = ROLE_VINDICATOR
    -- Jingle Jam Pack Roles --
    translatedRoles["Boxeurs"] = ROLE_BOXER
    translatedRoles["Communistes"] = ROLE_COMMUNIST
    translatedRoles["Hommes Aléatoires"] = ROLE_RANDOMAN
    translatedRoles["Pères Noël"] = ROLE_SANTA
    translatedRoles["Taxidermistes"] = ROLE_TAXIDERMIST
    translatedRoles["Clowns Détectives"] = ROLE_DETECTOCLOWN
    translatedRoles["Les Faussaires"] = ROLE_FAKER
    translatedRoles["Krampus"] = ROLE_KRAMPUS
    translatedRoles["Administrateurs"] = ROLE_ADMIN
    translatedRoles["Chuchoteurs de Fantômes"] = ROLE_GHOSTWHISPERER
    translatedRoles["Renégates"] = ROLE_RENEGADE
    translatedRoles["Limites de L'âme"] = ROLE_SOULBOUND
    translatedRoles["Mages D'âme"] = ROLE_SOULMAGE
    translatedRoles["Élémentalistes"] = ROLE_ELEMENTALIST
    translatedRoles["Médecins"] = ROLE_PHYSICIAN
    -- External Roles --
    translatedRoles["Annonceurs"] = ROLE_ANNOUNCER
    translatedRoles["Serviteurs de L'effroi"] = ROLE_DREADTHRALL
    translatedRoles["Français"] = ROLE_FRENCHMAN
    translatedRoles["Opossums"] = ROLE_POSSUM
    translatedRoles["Invocateurs"] = ROLE_SUMMONER
    translatedRoles["Les Choses"] = ROLE_THETHING
    -- Randomat Roles --
    translatedRoles["Yétis"] = ROLE_YETI
    translatedRoles["Abeilles"] = ROLE_BEE
    translatedRoles["Reines Des Abeilles"] = ROLE_QUEENBEE
    translatedRoles["Elfes"] = ROLE_ELF

    if istable(ROLE_STRINGS_PLURAL) then
        roleStringsPluralOrig = table.Copy(ROLE_STRINGS_PLURAL)

        for roleName, roleID in pairs(translatedRoles) do
            ROLE_STRINGS_PLURAL[roleID] = roleName
        end
    end

    -- Renaming custom passive shop items
    -- (Default TTT passive items like the rader are covered by the language file)
    if not istable(SHOP_ROLES) then
        SHOP_ROLES = {}
        SHOP_ROLES[ROLE_DETECTIVE] = true
        SHOP_ROLES[ROLE_TRAITOR] = true
    end

    if not isnumber(ROLE_MAX) then
        ROLE_MAX = 2
    end

    customPassiveItemsOrig = {}

    for role = 1, ROLE_MAX do
        if SHOP_ROLES[role] and EquipmentItems[role] then
            customPassiveItemsOrig[role] = table.Copy(EquipmentItems[role])

            for _, equ in pairs(EquipmentItems[role]) do
                -- My version of the second chance, demoic possession, and clairvoyancy perk use role strings; however, not all versions on the workshop do, so we ALSO have to define hard-coded translations here
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
                elseif equ.id and EQUIP_PHS_TRACKER and equ.id == EQUIP_PHS_TRACKER then
                    -- The Elementalist and Physician roles (at release) don't use translation strings.. so we also have to hard-code them here
                    equ.name = "Mise à niveau du suivi de santé"
                    equ.desc = "Améliore la portée et la qualité des informations du Health Tracker."
                elseif equ.id and EQUIP_ELEMENTALIST_FROSTBITE and equ.id == EQUIP_ELEMENTALIST_FROSTBITE then
                    equ.name = "Gelure"
                    equ.desc = "Tirez sur les joueurs pour ralentir leur mouvement, la force du ralentissement dépend des dégâts infligés."
                elseif equ.id and EQUIP_ELEMENTALIST_FROSTBITE_UP and equ.id == EQUIP_ELEMENTALIST_FROSTBITE_UP then
                    equ.name = "Gelure+"
                    equ.desc = "Mises à niveau Frostbite, les joueurs qui ont été ralentis ont une chance de se figer lorsqu'ils sont touchés, perdant ainsi tout mouvement."
                elseif equ.id and EQUIP_ELEMENTALIST_PYROMANCER and equ.id == EQUIP_ELEMENTALIST_PYROMANCER then
                    equ.name = "Pyromancien"
                    equ.desc = "Tirez sur les joueurs pour les enflammer, la durée évoluant en fonction des dégâts infligés."
                elseif equ.id and EQUIP_ELEMENTALIST_PYROMANCER_UP and equ.id == EQUIP_ELEMENTALIST_PYROMANCER_UP then
                    equ.name = "Pyromancien+"
                    equ.desc = "Mises à niveau du Pyromancien, les joueurs enflammés ont une chance d'exploser lorsqu'ils sont tirés, causant des dégâts à tout le monde autour d'eux."
                elseif equ.id and EQUIP_ELEMENTALIST_WINDBURN and equ.id == EQUIP_ELEMENTALIST_WINDBURN then
                    equ.name = "Coup de vent"
                    equ.desc = "Tirer sur les joueurs les pousse vers l'arrière et les éloigne de vous, la force de poussée augmentant en fonction des dégâts infligés."
                elseif equ.id and EQUIP_ELEMENTALIST_WINDBURN_UP and equ.id == EQUIP_ELEMENTALIST_WINDBURN_UP then
                    equ.name = "Coup de vent+"
                    equ.desc = "Mises à niveau Windburn, au lieu de pousser, lance occasionnellement des joueurs qui tirent dans les airs pour un atterrissage dur et douloureux."
                elseif equ.id and EQUIP_ELEMENTALIST_DISCHARGE and equ.id == EQUIP_ELEMENTALIST_DISCHARGE then
                    equ.name = "Décharge"
                    equ.desc = "Tirez sur les joueurs pour les choquer, en frappant leur vue en fonction des dégâts infligés, en les désorientant."
                elseif equ.id and EQUIP_ELEMENTALIST_DISCHARGE_UP and equ.id == EQUIP_ELEMENTALIST_DISCHARGE_UP then
                    equ.name = "Décharge+"
                    equ.desc = "La décharge de mise à niveau amène les joueurs abattus à commettre en outre des actions involontaires, telles que bouger, tirer ou sauter."
                elseif equ.id and EQUIP_ELEMENTALIST_MIDNIGHT and equ.id == EQUIP_ELEMENTALIST_MIDNIGHT then
                    equ.name = "Minuit"
                    equ.desc = "Tirez sur les joueurs pour commencer à les aveugler, à assombrir leur écran et à rendre leur vision difficile."
                elseif equ.id and EQUIP_ELEMENTALIST_MIDNIGHT_UP and equ.id == EQUIP_ELEMENTALIST_MIDNIGHT_UP then
                    equ.name = "Minuit+"
                    equ.desc = "Mises à niveau à minuit, les joueurs dont les écrans sont atténués ont une chance de devenir complètement aveugles lorsqu'on leur tire dessus, sans rien voir."
                elseif equ.id and EQUIP_ELEMENTALIST_LIFESTEAL and equ.id == EQUIP_ELEMENTALIST_LIFESTEAL then
                    equ.name = "Vol de vie"
                    equ.desc = "Tirez sur les joueurs pour leur voler leur force vitale, une balle à la fois."
                elseif equ.id and EQUIP_ELEMENTALIST_LIFESTEAL_UP and equ.id == EQUIP_ELEMENTALIST_LIFESTEAL_UP then
                    equ.name = "Vol de vie+"
                    equ.desc = "Améliore Lifesteal, exécute les joueurs qui tirent si leur santé devient trop faible, les tuant instantanément."
                end
            end
        end
    end

    -- Renaming weapons
    -- All in alphabetical order by printname
    local translatedWeapons = {
        tfa_acidgat = {
            name = "Acide Gat",
            desc = [[Tire plusieurs explosifs qui collent aux joueurs et explosent après quelques secondes.]]
        },
        weapon_ttt_adm_menu = {
            name = "Menu Administrateur",
        },
        weapon_ttt_awp_advanced_silenced = {
            name = "Av. AWP silencieux",
            desc = [[Un tir, un mort. Les victimes ne crieront pas lorsqu'elles seront tuées.
            Fournit des informations avancées sur le HUD.
            
            Créé par @josh_caratelli + Liam McLachlan.]]
        },
        equip_airboat = {
            name = "Générateur d'hydroglisseur",
            desc = [[La 1ère arme blague que vous achetez est gratuite !

            Faites un clic gauche pour faire apparaître un hydroglisseur pilotable!
            N'endommage pas les joueurs.]]
        },
        ttt_player_pinger = {
            name = "Joueur Pinger",
            desc = [[Vous permet de voir tout le monde à travers les murs pendant une durée limitée!]]
        },
        weapon_amongussummoner = {
            name = "Parmi l'invocateur",
            desc = [[Faites un clic gauche pour placer un piège invisible au sol.

            Si un joueur marche dessus, un monstre porteur d'explosifs apparaît et attaque!]]
        },
        avengers_ttt_minifier = {
            name = "Costume D'homme Fourmi"
        },
        weapon_antlionsummoner = {
            name = "Invocateur de Fourmilion",
            desc = [[Invoque un garde fourmilion. Cible sur le dessus d'une surface plane]]
        },
        weapon_hp_ares_shrike = {
            name = "Pie-grièche D'Arès",
        },
        weapon_m9k_ares_shrike = {
            name = "Pie-grièche D'Arès",
        },
        weapon_ttt_artillery = {
            name = "Canon D'artillerie",
            desc = [[Génère un canon d'artillerie très puissant qui tire une grosse bombe sur une longue portée.

            Pour contrôler, placez-vous juste derrière et appuyez sur 'E' sur les commandes qui apparaissent.]]
        },
        weapon_m9k_val = {
            name = "COMME VAL",
        },
        weapon_ttt_aug = {
            name = "AOÛT",
        },
        weapon_ttt_titanfall_wingman = {
            name = "Ailier B3"
        },
        ttt_backwards_shotgun = {
            name = "Fusil à Pompe à L'envers",
            desc = [[La première arme blague que vous achetez une cartouche est gratuite!

            Un fusil de chasse qui tire derrière vous et vous propulse vers l'avant.
            
            Faites un clic droit pour vous retourner instantanément.]]
        },
        weapon_banana = {
            name = "Bombe banane",
            desc = [[Ça sent frais.

            Clic gauche pour lancer,
            Clic droit pour faire sonner le bon vieux son
              + Changer le temps du fusible]]
        },
        st_bananapistol = {
            name = "Pistolet banane"
        },
        weapon_ttt_barnacle = {
            name = "Bernacle",
            desc = [[Un piège extraterrestre mortel au plafond!

            Faites un clic gauche pour placer le piège au plafond, toute personne passant en dessous sera lentement tuée.]]
        },
        weapon_bat = {
            name = "Batte de Baseball",
        },
        weapon_ttt_beacon = {
            name = "Balise",
            desc = [[Diffuse un emplacement à tout le monde.

            À utiliser pour avertir ou regrouper des innocents.]]
        },
        weapon_ttt_beartrap = {
            name = "Piège à Ours",
            desc = [[OM NOM NOM... OM NOM (Donateur uniquement)]]
        },
        weapon_ttt_randomatbeecannon = {
            name = "Canon à Abeilles",
        },
        weapon_ttt_beenade = {
            name = "Grenade à Abeilles",
            desc = [[Grenade à abeilles.
            Libère plusieurs abeilles hostiles lors de la détonation.]]
        },
        tfa_dax_big_glock = {
            name = "Gros Glock"
        },
        weapon_vadim_blink = {
            name = "Clignoter",
            desc = [[Téléportez-vous instantanément là où vous regardez!

            Maintenez le clic gauche pour sélectionner un emplacement, cliquez avec le bouton droit pour annuler.]]
        },
        tfa_blundergat = {
            name = "Tromblon",
            desc = [[Un fusil de chasse incroyablement puissant!]]
        },
        weapon_bod_bodysnatch = {
            name = "Dispositif D'arrachage de Corps",
            desc = [[Change votre rôle en celui d'un cadavre.]]
        },
        weapon_ttt_bomb_station = {
            name = "Station de Bombes",
            desc = [[Lorsque des innocents utiliseront ce poste de santé, ce sera
            bip avant d'exploser.
            Les traîtres épuiseront simplement la fausse charge.]]
        },
        weapon_thr_bonecharm = {
            name = "Charme D'os"
        },
        weapon_bonesaw = {
            name = "Scie à Os",
        },
        weapon_ttt_bonk_bat = {
            name = "Chauve-souris Bonk",
            desc = [[Envoyez les gens en prison !

            Une chauve-souris qui emprisonne ceux que vous frappez dans une cage pendant quelques secondes.]]
        },
        tfa_staff_wind_ult = {
            name = "La fureur de Borée"
        },
        weapon_bottle = {
            name = "Bouteille",
        },
        weapon_ttt_brain = {
            name = "Parasite du Cerveau",
            desc = [[1 fléchette.

            La victime tire au hasard
            puis mourir d'une crise cardiaque
            20 secondes plus tard.]]
        },
        weapon_hyp_brainwash = {
            name = "Dispositif de Lavage de Cerveau",
            desc = [[Ressuscite un innocent en traître.]]
        },
        tfa_mercy_nope = {
            name = "Blaster de Caducée"
        },
        weapon_ttt_randomatcandycane = {
            name = "Sucre D'orge",
            desc = [[Faites un clic gauche pour convertir un autre joueur]]
        },
        avengers_ttt_shield = {
            name = "Le Bouclier de Capitaine Amérique",
            desc = [[Clic gauche pour lancer le bouclier brutalement,
            clic droit pour le lancer doucement et précis]]
        },
        weapon_ttt_car_gun = {
            name = "Pistolet de Voiture",
            desc = [[Tirez sur quelqu'un avec une voiture volante et figez-le sur place!

            Toute personne coincée sur le chemin de la voiture entre vous et la victime subit également des dégâts.]]
        },
        weapon_ttt_chickennade = {
            name = "Œuf de poule",
            desc = [[Un poulet agressif !
            Faites trop chier et ça explose!]]
        },
        weapon_ttt_chickenator = {
            name = "Poulet",
            desc = [[Le choix de l'arme de Rambo]]
        },
        weapon_randomat_christmas_cannon = {
            name = "Canon de Noël",
        },
        weapon_san_christmas_cannon = {
            name = "Canon de Noël",
        },
        weapon_ttt_cracker = {
            name = "Biscuit de Noël",
            desc = [[Un cracker de Noël rempli de gourmandises!]]
        },
        weapon_zom_claws = {
            name = "Les Griffes",
            desc = [[Clic gauche pour attaquer. Faites un clic droit pour sauter. Appuyez sur recharger pour cracher.]]
        },
        weapon_ttt_cloak = {
            name = "Dispositif de Masquage 2.0",
            desc = [[Tenez pour devenir presque invisible

            Ne cache pas les taches de sang ni votre popup nom/santé
            
            Certaines cartes peuvent avoir un mauvais éclairage et vous laisser un peu trop visible.]]
        },
        weapon_ttt_clutterbomb = {
            name = "Bombe Encombrant",
            desc = [[Une grenade hautement explosive.

            Prudent! Il peut exploser dans votre main si vous
            faites-le cuire trop longtemps!]]
        },
        weapon_com_manifesto = {
            name = "Manifeste Communiste",
            desc = [[Faites un clic gauche pour convertir un autre joueur]]
        },
        weapon_ttt_comrade_bomb = {
            name = "Camarade Bombe",
            desc = [[Un attentat suicide qui transforme tous ceux qui se trouvent dans l'explosion en traîtres!]]
        },
        weapon_ttt_confetti = {
            name = "Canon à Confettis",
            desc = [[The 1st joke weapon you buy is free! 

            Sprays confetti and makes a yay noise!]]
        },
        weapon_controllable_manhack = {
            name = "Manhack Contrôlable",
            desc = [[Clic gauche pour déployer, clic droit pour contrôler.]]
        },
        corpselauncher = {
            name = "Lanceur de Cadavres",
            desc = [[Tire sur un cadavre créant une explosion à l'impact. Nécessite un cadavre pour tirer.
 
            A suffisamment de munitions pour tirer deux fois.
             
            Faites un clic droit pour charger un cadavre.
            Clic gauche pour lancer le cadavre.]]
        },
        weapon_ttt_printer = {
            name = "Imprimante de crédit",
            desc = [[Dépensez un crédit pour gagner plus de crédits!

            Faites un clic gauche pour placer l'imprimante de crédit au sol et, une fois que c'est fait, appuyez sur 'E' pour obtenir vos crédits !
            
            Fait du bruit une fois posé...]]
        },
        weapon_cup_bow = {
            name = "L'arc de Cupidon",
        },
        dancedead = {
            name = "Pistolet de Danse",
            desc = [[1 coups.

            Fait danser la victime de manière incontrôlable,
            puis meurt 14 secondes plus tard.]]
        },
        weapon_ttt_dancedead = {
            name = "Pistolet de Danse",
            desc = [[Tirez sur quelqu'un pour le faire danser sur une chanson aléatoire, puis mourez.]]
        },
        weapon_ttt_dd = {
            name = "Pistolet DD",
            desc = [[Aveugle mais accorde une vision spéciale pendant 30 secondes]]
        },
        weapon_ttt_dead_ringer = {
            name = "Sosie",
            desc = [[Devenez invisible pendant un moment et quittez un corps la prochaine fois que vous subirez des dégâts!

            Faites un clic gauche pour allumer.
            N'a pas besoin d'être tenu une fois allumé.
            
            Vous ne pouvez pas tirer en étant invisible.
            Faites un clic droit pour mettre fin à l'invisibilité plus tôt.]]
        },
        weapon_ttt_deadringer = {
            name = "Sosie",
            desc = [[Devenez invisible pendant un moment et quittez un corps la prochaine fois que vous subirez des dégâts!

            Faites un clic gauche pour allumer.
            N'a pas besoin d'être tenu une fois allumé.
            
            Vous ne pouvez pas tirer en étant invisible.
            Faites un clic droit pour mettre fin à l'invisibilité plus tôt.]]
        },
        weapon_zm_revolver = {
            name = "Daigle",
        },
        ttt_deal_with_the_devil = {
            name = "Traiter Avec Le Diable",
            desc = [[Révélez que vous êtes un traître à tout le monde, mais recevez un puissant avantage en retour!]]
        },
        weapon_ttt_death_link = {
            name = "Lien Mortel",
            desc = [[À utiliser sur n'importe quel joueur. Une fois qu'ils meurent, vous mourez et vice versa.]]
        },
        death_note_ttt = {
            name = "Menace de Mort",
            desc = [[Tuez quelqu'un en écrivant son nom...

            Tout en maintenant cela, tapez le nom de quelqu'un dans le chat et il mourra dans 40 secondes.
            (Tant que vous êtes encore en vie à ce moment-là !)
            
            Clic gauche: modifiez la cause du décès.]]
        },
        weapon_med_defib = {
            name = "Défibrillateur",
            desc = [[Ravive un joueur mort.]]
        },
        weapon_vadim_defib = {
            name = "Défibrillateur",
            desc = [[Défibrille les gens.]]
        },
        weapon_ttt_demonsign = {
            name = "Possession Démoniaque",
            desc = [[Placez votre signe démoniaque au sol et
            prendre le contrôle d'un autre joueur lorsqu'il marche
            dessus après votre mort.]]
        },
        weapon_ttt_force_shield = {
            name = "Bouclier de Force Déployable",
            desc = [[À utiliser pour déployer un bouclier de force.
            Peut être traversé, mais bloque les balles.
              A 800 ch et une durée de vie de 30 secondes.]]
        },
        weapon_mhl_badge = {
            name = "Insigne D'adjoint",
        },
        weapon_m9k_deagle = {
            name = "Aigle du Désert .40",
        },
        weapon_ttt_dete_playercam = {
            name = "Supprimer la Playercam",
            desc = [[1 tir avec visée automatique.
            Montre la vision de la cible qui a été tirée.
            Cible modifiable en fermant la fenêtre.
            et tirer à nouveau (ne fonctionne que si vous portez toujours le
            arme).]]
        },
        weapon_ttt_detectiveball = {
            name = "Boule de Détective",
            desc = [[Lancez-vous sur un proche pour le transformer en détective !
            Révèle plutôt leur rôle s'il s'agit d'un traître.
            
            Rien ne se passe s'il s'agit d'un innocent ou d'un traître, comme un pépin ou un hypnotiseur.]]
        },
        weapon_ttt_randomatdetonator = {
            name = "Détonateur",
        },
        weapon_discordgift = {
            name = "Table D'harmonie Discord",
            desc = [[La 1ère arme blague que vous achetez est gratuite !

            Est-ce que quelqu'un vient de nous rejoindre ? Non! Juste votre propre table d'harmonie Discord personnelle!
             
            Clic gauche - Rejoindre le son
            Clic droit - Quitter le son
            R - Ping sonore]]
        },
        weapon_ttt_dislocator = {
            name = "Dislocateur",
            desc = [[Tire un disque qui lance les joueurs dans
            directions aléatoires.]]
        },
        weapon_doncombinesummoner = {
            name = "DoncomInvocateur",
            desc = [[Invoque un Doncombine hostile à quiconque
            pas dans l'équipe des traîtres]]
        },
        doncmk2_swep = {
            name = "Donconnon Mark Deux",
            desc = [[Tire une tête MASSIVE qui vole à travers les murs.
            Inflige de lourds dégâts à tous ceux qu'il touche.
            
            Faites un clic droit tout en regardant quelqu'un pour vous verrouiller sur quelqu'un!]]
        },
        weapon_sp_dbarrel = {
            name = "Double Baril",
        },
        weapon_old_dbshotgun = {
            name = "Double Baril",
        },
        weapon_m9k_dbarrel = {
            name = "Double Baril",
        },
        ttt_perk_doubletap = {
            name = "Bière de Racine à Double Pression",
        },
        weapon_ttt_dragon_elites = {
            name = "Élites Dragons",
            desc = [[Pistolets à double usage avec une animation de rechargement sympa.]]
        },
        weapon_dubstepgun = {
            name = "Pistolet Dubstep",
            desc = [[Maintenez le clic gauche pour tirer des lasers musicaux qui infligent beaucoup de dégâts!]]
        },
        weapon_ttt_duel_revolver_randomat = {
            name = "Pistolet de Duel",
        },
        ttt_weapon_eagleflightgun = {
            name = "Pistolet de Vol D'aigle",
            desc = [[Tirez pour vous jeter.
            Si vous tombez sur un joueur, il mourra !
            Sinon, appuyez à nouveau sur le bouton gauche de la souris pour exploser.]]
        },
        weapon_pha_exorcism = {
            name = "Dispositif d'exorcisme",
            desc = [[Vous permet d'effectuer un exorcisme pour éliminer un fantôme obsédant]]
        },
        weapon_ttt_extinguisher = {
            name = "Extincteur",
            desc = [[Vaporisez les traîtres et aveuglez-les]]
        },
        weapon_vam_fangs = {
            name = "Crocs",
            desc = [[Faites un clic gauche pour sucer le sang. Cliquez avec le bouton droit pour faire disparaître.]]
        },
        weapon_fartgrenade = {
            name = "Grenade à Pet",
        },
        fp = {
            name = "Fassinateur",
            desc = [[Placez 5 barils explosifs autour de vos ennemis et profitez du désastre!]]
        },
        weapon_ttt_fingergun = {
            name = "Pistolet à Doigt",
            desc = [[BOOM BOOM
            hors de vos doigts !
            
            Primaire: Automatique.
            Secondaire: Fusil de chasse.]]
        },
        weapon_fireaxe = {
            name = "Hache D'incendie",
        },
        weapon_ttt_fire_dash = {
            name = "Tiret de Feu",
            desc = [[Augmente de manière permanente votre vitesse et vous enflamme.

            Tous ceux que vous rencontrez meurent instantanément!
            
            Vous mourez au bout de 10 secondes.]]
        },
        custom_firestarter = {
            name = "Allume Feu",
            desc = [[Allume feu
            Clic gauche - Poser un marqueur
            Clic droit - Allumer le marqueur]]
        },
        weapon_fistsheavy = {
            name = "Poings",
        },
        fkg_gifter_swep = {
            name = "Donateur FKG",
            desc = [[Supprime toutes les armes de la cible,
            leur offre un "pistolet gratuit" imparable
            et les oblige à tirer une fois]]
        },
        weapon_ttt_foolsgoldengun = {
            name = "Le Pistolet F'or du Fou",
            desc = [[Tirez sur un traître, tuez un traître.
            Tirer sur un innocent, tuer un traître ?
            Tirez sur un bouffon, tuez un traître...
            Quelque chose ne va pas ici...]]
        },
        weapon_ttt_fortnite_building = {
            name = "Bâtiment Fortnite",
            desc = [[Construisez comme dans Fortnite!
            Matériaux agricoles en frappant des objets
            avec votre pied de biche.]]
        },
        weapon_ttt_frag = {
            name = "Grenade à Fragmentation",
            desc = [[Une grenade hautement explosive.]]
        },
        weapon_rp_railgun = {
            name = "Pistolet à Tuer Gratuit",
        },
        weapon_ttt_freezegun = {
            name = "Pistolet à Glace",
            desc = [[Gèle la cible pendant 5 secondes.
            La cible ne peut pas bouger, regarde autour de toi,
            tirer ou faire autre chose.
            
            4 coups]]
        },
        terror_fulton = {
            name = "Fulton",
            desc = [[Tu vas l'emmener ?
            Cet équipement peut extraire des cadavres ou des accessoires via le
            système de récupération de ballons Fulton.
            Les ballons éclateront s'ils sont tirés ou déployés à l'intérieur.
            Faites un clic droit pour définir une destination. Rechargez pour l'effacer.]]
        },
        weapon_ttt_galil = {
            name = "Galille",
        },
        weapon_ttt_gwh_ghosting = {
            name = "Dispositif Fantôme",
        },
        weapon_randomat_boxgloves = {
            name = "Gants",
            desc = [[Clic gauche pour attaquer]]
        },
        weapon_box_gloves = {
            name = "Gants",
            desc = [[Clic gauche pour attaquer]]
        },
        weapon_gnome_grenade = {
            name = "Grenade Gnome",
            desc = [[Gnome vos copains avec la nouvelle grenade explosive « Youve been Gnomed ».

            Vous avez été Gnomed!]]
        },
        weapon_ap_golddragon = {
            name = "Dragon D'or",
            desc = [[Faibles dégâts, fusil d'assaut précis
            qui met le feu aux ennemis.
          
          Utilise des munitions SMG standard.]]
        },
        weapon_ttt_nrgoldengun = {
            name = "Daigle Doré",
            desc = [[Tirez sur un traître, tuez un traître.
            Tirez sur un innocent, suicidez-vous.
            Sois prudent.]]
        },
        weapon_kra_carry = {
            name = "Griffes Saisissantes",
        },
        weapon_ttt_gimnade = {
            name = "Grenade Gravitationnelle",
            desc = [[Grenade high-tech du futur!]]
        },
        manipulator = {
            name = "Changeur de Gravité",
            desc = [[Clic gauche : Réduire la gravité.

            Clic droit: Augmenter la gravité.
            
            Rechargement: gravité normale.]]
        },
        weapon_ttt_gravity_pistol = {
            name = "Pistolet à Gravité",
            desc = [[Inverse la gravité du joueur,
            que vous frappez, pendant quelques secondes.]]
        },
        weapon_hp_glauncher = {
            name = "Lance-Grenades",
            desc = [[Lance-grenades explosif automatique.

            Livré avec 12 tours.]]
        },
        weapon_zm_sledge = {
            name = "É.N.O.R.M.E-249",
        },
        weapon_ttt_handcuffs = {
            name = "Menottes",
            desc = [[Menottez quelqu'un pour le forcer à lâcher ses armes et l'empêcher d'en ramasser de nouvelles.]]
        },
        weapon_ttt_hwapoon = {
            name = "Harpon",
            desc = [[Harpon jetable.

            Silencieux si vous touchez un joueur, tue d'un seul coup.]]
        },
        avengers_hawkeye_crybow = {
            name = "Arc Œil-de-Faucon",
            desc = [[Fusil d'assaut à très gros dégâts.

            A un recul très élevé.]]
        },
        weapon_ttt_headlauncher = {
            name = "Lanceur de Crabe",
            desc = [[Lance des capsules remplies de crabes.
            Dégâts d'impact massifs là où il frappe!
            A 3 charges.]]
        },
        weapon_ttt_mc_healthpotion = {
            name = "Potion de Vie",
        },
        weapon_ttt_phy_tracker = {
            name = "Suivi de la Santé",
        },
        c_reaper_nope = {
            name = "Fusils de Chasse Hellfire"
        },
        weapon_ttt_homebat = {
            name = "Batte de Circuit",
            desc = [[Frappez les gens très loin avec une batte!
            Inflige une quantité modérée de dégâts en cas de coup]]
        },
        swep_homingpigeon = {
            name = "Pigeon Voyageur",
            desc = [[Un pigeon que l'on peut lancer sur quelqu'un et qui explose !

            Vole très vite, nécessite de regarder directement quelqu'un pour le lancer.]]
        },
        weapon_ap_hbadger = {
            name = "Blaireau au Miel",
        },
        weapon_ttt_hotpotato = {
            name = "Patate Chaude",
            desc = [[Faites un clic gauche sur quelqu'un à portée de mêlée pour lui donner la patate chaude!

            S'ils ne le transmettent pas en 12 secondes, ils explosent !]]
        },
        avengers_fists = {
            name = "Poings Hulk",
            desc = [[Fist-les.]]
        },
        weapon_ttt_id_bomb = {
            name = "Bombe D'identification",
            desc = [[Le cadavre signalé (clic gauche) explosera après identification.]]
        },
        weapon_ttt_id_bomb_defuser = {
            name = "Désamorceur de bombe d'identification",
            desc = [[Faites un clic gauche sur un cadavre bombardé d'identité pour désamorcer la bombe!]]
        },
        weapon_ars_igniter = {
            name = "Allumeur",
        },
        weapon_ttt_mc_immortpotion = {
            name = "Potion D'immortalité",
        },
        weapon_m9k_intervention = {
            name = "Intervention",
        },
        weapon_ttt_mc_invispotion = {
            name = "Potion D'invisibilité",
        },
        avengers_ironman = {
            name = "Homme de Fer",
            desc = [[Armure spécialisée conçue par Tony Stark. AVERTISSEMENT: Impossible de laisser tomber!]]
        },
        weapon_ttt_jarate = {
            name = "Jaraté",
            desc = [[Un pot de pisse
            Toute personne couverte subira deux fois plus de dégâts]]
        },
        weapon_ttt_detective_lightsaber = {
            name = "Sabre Laser Jedi",
            desc = [[Un sabre laser vert, vert puisque vous êtes détective.
            Clic gauche : Swing
            R: Changez l'effet de votre clic droit
            Clic droit: ce que vous avez défini avec "R"
            
            Vous pouvez basculer entre:
            - Réfléchir les balles
            - Pousser quelqu'un en utilisant la force
            - Tirer quelqu'un en utilisant la force]]
        },
        shared = {
            name = "Émulateur de bouffon",
            desc = [[Un M16 qui n'inflige aucun dégât.]]
        },
        weapon_ttt_jetpackspawner = {
            name = "Déployeur Jetpack",
            desc = [[Faites un clic gauche pour déposer un jetpack, appuyez sur 'E' pour l'équiper.]]
        },
        weapon_ttt_jihad = {
            name = "Bombe du Jihad",
            desc = [[Une bombe suicide qui fera un câlin à vos amis.
            Veuillez noter que ce montant n'est pas remboursable après utilisation.]]
        },
        weapon_john_bomb = {
            name = "John Bombe",
            desc = [[Clic gauche pour vous faire EXPLOSER. Faites un clic droit pour narguer.]]
        },
        weapon_ttt_jumpgun = {
            name = "Pistolet de Saut",
            desc = [[Tirez pour aller dans la direction opposée (par exemple, tirez vers le bas pour monter).]]
        },
        ttt_kamehameha_swep = {
            name = "Kaméhaméha",
            desc = [[Plus de 9 000. Gèle le traître lors du tir. Attention à l'explosion !]]
        },
        tfa_staff_lightning_ult = {
            name = "La morsure de Kimat"
        },
        crimson_new = {
            name = "Roi Cramoisi",
            desc = [[Des poings qui tuent d'un seul coup !

            Vous devez attendre une seconde avant de pouvoir commencer à frapper.]]
        },
        weapon_m9k_vector = {
            name = "Kriss Vecteur",
        },
        laserpointer = {
            name = "Pointeur Laser",
            desc = [[La 1ère arme blague que vous achetez est gratuite !

            Aveuglez temporairement quelqu'un en le pointant devant son visage.]]
        },
        weapon_ttt_liftgren = {
            name = "Grenade de Levage",
            desc = [[Une grenade hautement explosive.

            Prudent! Il peut exploser dans votre main si vous
            faites-le cuire trop longtemps!]]
        },
        c_dvaredux_nope = {
            name = "Pistolet Léger"
        },
        weapon_ttt_lightningar1 = {
            name = "Foudre AR1",
            desc = [[Un pistolet-guitare!

            Un fusil musical à dégâts élevés avec des animations et des sons très sympas.]]
        },
        avengers_smooleystormbreaker = {
            name = "Éclair",
            desc = [[Une arme conçue pour le roi d'Asgard, forgée au cœur d'une étoile mourante.]]
        },
        weapon_ttt_traitor_lightsaber = {
            name = "Sabre Laser",
            desc = [[Un sabre laser rouge, rouge puisque tu es un traître.
            Clic gauche : Swing
            R: Changez l'effet de votre clic droit
            Clic droit: ce que vous avez défini avec "R"
            
            Vous pouvez basculer entre:
            - Réfléchir les balles
            - Tirez sur la foudre
            - Pousser quelqu'un en utilisant la force
            - Tirer quelqu'un en utilisant la force]]
        },
        weapon_long_revolver = {
            name = "Revolver Longue",
            desc = [[La 1ère arme blague que vous achetez est gratuite !

            Un revolver ridiculement long.]]
        },
        weapon_catgun = {
            name = "Pistolet à Chat",
        },
        weapon_m3 = {
            name = "Pistolet Graisseur M3",
        },
        c_sombra_gun_n = {
            name = "Pistolet-Mitrailleur"
        },
        weapon_ttt_malfunctionpistol = {
            name = "Dysfonctionnement du Pistolet",
            desc = [[Force le joueur sur lequel vous tirez à tirer
            une série de coups de feu incontrôlés.]]
        },
        giantsupermariomushroom = {
            name = "Champignon Mario",
            desc = [[Une utilisation, gagnez beaucoup de santé et devenez énorme pendant 30 secondes!]]
        },
        weapon_mastersword = {
            name = "Maître Épée",
            desc = [[Tir principal: attaque
            Tir secondaire: attaque sautée
            Recharger: Kamikaze Spin Attack]]
        },
        weapon_ttt_medkit = {
            name = "Kit Médical",
            desc = [[Faites un clic droit pour vous soigner

            Faites un clic gauche pour soigner quelqu'un devant vous]]
        },
        weapon_ttt_meme_gun = {
            name = "Pistolet Mème",
            desc = [[Tirez sur quelqu'un pour générer un mème mortel!

            Les poursuit, tue au toucher et disparaît.]]
        },
        weapon_ttt_minic = {
            name = "Mimer le Générateur",
            desc = [[Lors de son utilisation, transforme des accessoires aléatoires sur la carte en accessoires d'imitation hostiles.

            Ils sautent vers les joueurs et les endommagent au toucher!]]
        },
        weapon_ttt_mine_turtle = {
            name = "Tortue Minière",
            desc = [[Faites un clic gauche pour lancer au sol, faites un clic droit pour placer contre un mur.

            S'arme au bout de quelques secondes, si un autre joueur passe, il explose!]]
        },
        minecraft_swep = {
            name = "Bloc Minecraft",
            desc = [[Placez des blocs Minecraft!
            Appuyez sur 'R' pour changer de bloc]]
        },
        weapon_ttt_minifier = {
            name = "Minificateur",
            desc = [[Faites un clic gauche pour réduire votre taille et votre santé!]]
        },
        weapon_ttt_moonball = {
            name = "Boule de Lune",
            desc = [[Maintenez le clic gauche pour modifier la quantité de force utilisée.
            Clic droit pour changer les couleurs.]]
        },
        weapon_ttt_mud_device_randomat = {
            name = "Appareil D'analyse de Boue",
        },
        avengers_nick_pistol = {
            name = "Le pistolet de Nick Fury",
            desc = [[Le pistolet pratique de Nick Fury]]
        },
        ttt_no_scope_awp = {
            name = "Aucune portée Awp",
            desc = [[Une arme puissante qui ne peut être tirée que lorsque le compteur 'Cool' est chargé en effectuant un 360.]]
        },
        weapon_ttt_zombievault = {
            name = "Coffre-fort des PNJ",
            desc = [[Sélectionnez un type de PNJ et jetez-le par terre. Serrures
            en place lorsqu'il est allumé. Plusieurs types de PNJ disponibles.
            Le suivi peut être irrégulier, mais dépend du PNJ
            et l'environnement.
            Grande pièce = errer, petite pièce = tortue.]]
        },
        weapon_ttt_detective_supersheep = {
            name = "Mouton Observateur",
            desc = [[Lancez l'Observer Sheep pour traquer vos ennemis!
            Clic gauche: marquer une personne
            Clic droit: récupérez le mouton]]
        },
        one_punch_skin = {
            name = "Un Coup de Poing !!!",
            desc = [[Poings mortels d'un seul coup.

            Joue de la musique et change de modèle de lecteur dès que vous le tenez!]]
        },
        weapon_ttt_pistol_randomat = {
            name = "Pistolet à un Coup",
        },
        weapon_ttt_obc = {
            name = "Canon à basse orbitale",
            desc = [[Tirez sur le sol pour invoquer un laser ABSOLUMENT MASSIF après quelques secondes.]]
        },
        weapon_valenok = {
            name = "Oscar le Chat",
            desc = [[La 1ère arme blague que vous achetez est gratuite !

            Achetez un chat portable dès aujourd'hui!
            Son nom est "Oscar"]]
        },
        weapon_ttt_painkillers = {
            name = "Analgésiques",
            desc = [[Accorde un boost de santé qui guérit complètement l'utilisateur mais se désintègre avec le temps.]]
        },
        weapon_paintgun = {
            name = "Pistolet à Peinture",
            desc = [[Faites un clic droit pour changer les couleurs.]]
        },
        weapon_qua_fake_cure = {
            name = "Remède contre les parasites"
        },
        weapon_par_cure = {
            name = "Remède contre les parasites"
        },
        custom_pewgun = {
            name = "Pistolet de Banc",
            desc = [[Le pistolet PEW
            Tire des lasers bleus flamboyants
            Fait un son PEW sympa]]
        },
        ttt_perk_phd = {
            name = "Flopper de Doctorat",
        },
        weapon_ttt_pickle_rick_gun = {
            name = "Pickle Rick Pistolet",
            desc = [[Tirez sur quelqu'un pour le transformer en cornichon
            et réglez-les sur 1 santé
            
            Faites un clic droit pour vous transformer!]]
        },
        weapon_teleport_gun_t = {
            name = "Pistolet d'échange de joueur",
            desc = [[Un pistolet de téléportation !
            Tirez pour changer de place avec un joueur.
            Ne fonctionne que si vous êtes au sol et
            si vous et votre cible n'êtes pas accroupis.]]
        },
        weapon_rp_pocket = {
            name = "Fusil de Poche",
        },
        weapon_ttt_popupgun = {
            name = "Pistolet Contextuel",
            desc = [[SMG à tir rapide. Frapper quelqu'un ouvrira une fenêtre contextuelle sur son écran.]]
        },
        weapon_portalgun = {
            name = "Pistolet à Portail",
            desc = [[Clic gauche pour tirer un trou bleu dans un mur/sol, clic droit pour tirer un trou orange.

            Tout ce qui passe par un trou ressort par l'autre.]]
        },
        weapon_possessed_melon_launcher = {
            name = "PossMelLancement",
            desc = [[Tirez sur des fragments à tête chercheuse avec une attaque principale
            et possédait des melons avec attaque secondaire]]
        },
        weapon_prop_blaster = {
            name = "Blaster à Accessoires",
            desc = [[Fait exploser des accessoires aléatoires dans des directions aléatoires]]
        },
        weapon_ttt_prop_disguiser = {
            name = "Déguisement D'accessoires",
            desc = [[Déguisez-vous en objet !

            R: Sélectionnez un objet que vous regardez
            
            Clic gauche: activer le déguisement]]
        },
        weapon_ttt_prop_hunt_gun = {
            name = "Déguisement d'accessoires",
            desc = [[Faites un clic gauche pour vous cacher comme un tonneau!

            Montez jusqu'à un accessoire et appuyez sur "E" pour y changer votre déguisement]]
        },
        weapon_ttt_propexploder = {
            name = "Exploseur D'accessoires",
            desc = [[Le PE fera exploser tous les accessoires que vous voulez!
            Cela ressemble à un Magnet-O-Stick!
            Faites un clic gauche sur un accessoire, puis cliquez avec le bouton droit pour exploser !.]]
        },
        tfa_tracer_nope = {
            name = "Pistolets à Impulsions"
        },
        weapon_ttt_pump = {
            name = "Fusil à Pompe",
        },
        pusher_swep = {
            name = "Poussoir",
            desc = [[Devenez le pousseur de Bristol
            Clic gauche pour pousser
            Faites un clic droit pour narguer vos victimes]]
        },
        weapon_pp_rbull = {
            name = "Taureau Furieux",
        },
        weapon_m9k_ragingbull = {
            name = "Taureau Furieux",
        },
        weapon_m9k_scoped_taurus = {
            name = "Porté Taureau Furieux",
        },
        weapon_randomlauncher = {
            name = "Lanceur Aléatoire",
            desc = [[Lance un objet aléatoire qui inflige beaucoup de dégâts, tuant généralement instantanément.]]
        },
        weapon_ttt_randomat = {
            name = "Appareil aléatoire 4000",
            desc = [[Le RAppareil aléatoire 4000 fera quelque chose de aléatoire!
            Qui a deviné ça !]]
        },
        tfa_raygun = {
            name = "Pistolet à Rayons",
            desc = [[Tirez avec des lasers à dégâts élevés!

            Ne tirez pas trop près, sinon vous vous blesserez.]]
        },
        tfa_raygun_mark2 = {
            name = "Pistolet à Rayons Mark Deux",
            desc = [[Tire une rafale de lasers à dégâts élevés]]
        },
        weapon_ttt_titanfall_autopistol = {
            name = "Pistolet Automatique RE-45"
        },
        weapon_ttt_rmgrenade = {
            name = "Bombe de Matière Rouge",
            desc = [[Une grenade en forme de cube qui génère un trou noir!

            Quiconque est trop proche est aspiré!
            
            Sonne une alarme avant que le trou noir n'apparaisse.]]
        },
        weapon_ttt_mc_jumppotion = {
            name = "Potion de Fusée",
        },
        weapon_ttt_rocket_thruster = {
            name = "Propulseur de Fusée",
            desc = [[Lance L'utilisateur à L'envers.]]
        },
        weapon_gue_guesser = {
            name = "Devineur de Rôle",
        },
        weapon_ttt_rollermine = {
            name = "Mine à Rouleaux",
            desc = [[Les Rollermines poursuivront les joueurs,
            faire des dégâts de choc.
            
            Assurez-vous de prévenir vos coéquipiers...]]
        },
        rotgun = {
            name = "Pistolet Rotatif",
            desc = [[Tirer sur quelqu'un avec ça le retourne.]]
        },
        weapon_ttt_rsb = {
            name = "BCD",
            desc = [[Une bombe collante à distance. "Bombe vivante"]]
        },
        weapon_ttt_rsb_defuser = {
            name = "Désamorceur BCD",
            desc = [[Un diffuseur pour la Remote Sticky Bomb]]
        },
        weapon_m9k_model3russian = {
            name = "Modèle S&W 3",
        },
        weapon_m9k_model627 = {
            name = "Modèle S&W 627",
        },
        ttt_sahmin_gun = {
            name = "Pistolet Sahmin",
            desc = [[La première arme blague que vous achetez une cartouche est gratuite!

            Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin]]
        },
        weapon_inf_scanner = {
            name = "Scanner",
        },
        weapon_m9k_scar = {
            name = "CICATRICE-H",
        },
        weapon_scattergun = {
            name = "Fusil à Dispersion",
        },
        tfa_scavenger = {
            name = "Charognard",
            desc = [[Un fusil de sniper qui tire un explosif à retardement qui explose après quelques secondes.

            L'explosif colle aux joueurs.]]
        },
        weapon_ttt_cloak_randomat = {
            name = "Cape D'ombre",
        },
        weapon_shark_idol = {
            name = "Idole de Requin",
            desc = [[Arme de mêlée qui sacrifiera sa vie
            gardez le vôtre s'il en est équipé
            
            Deviendra un projectile après activation]]
        },
        weapon_shark_trap = {
            name = "Piège à Requin",
            desc = [[Un piège à poser au sol.
            Peut être ramassé avec un bâton magnéto...]]
        },
        weapon_ttt_shocktrap = {
            name = "Piège à Choc",
            desc = [[template]]
        },
        weapon_shovel = {
            name = "Pelle",
        },
        weapon_ttt_awp = {
            name = "AWP Silencieux",
            desc = [[Fusil de précision AWP silencieux.

            Il n'a qu'un seul coup.
            
            Les victimes ne crieront pas lorsqu'elles seront tuées.]]
        },
        weapon_ttt_m4a1_s = {
            name = "M4A1 Réduit au Silence",
            desc = [[Un fusil automatique silencieux. Les victimes meurent en silence.]]
        },
        weapon_ttt_tmp_s = {
            name = "Renard Silencieux",
            desc = [[SMG à faible bruit qui utilise des munitions normales de 9 mm.

            Les victimes ne crieront pas lorsqu'elles seront tuées.]]
        },
        weapon_ttt_slam = {
            name = "CLAQUER",
            desc = [[Allez et claque!]]
        },
        tfa_sliquifier = {
            name = "Slicificateur",
            desc = [[Tire des boules de slime qui tuent instantanément!

            Si vous touchez quelqu'un ou le sol, cela laisse une flaque de bave glissante.]]
        },
        weapon_ttt_timeslowgrenade = {
            name = "Grenade au ralenti",
            desc = [[Grenade qui ralentit temporairement
            temps d'arrêt pour tout le monde
            toute la carte.]]
        },
        weapon_ttt_paper_plane = {
            name = "Avion escargot",
            desc = [[Vole sans but jusqu'à ce qu'il trouve un joueur à proximité ne faisant pas partie de votre équipe, puis le poursuit!

            Le joueur entend de la musique une fois poursuivi et est tué au toucher.]]
        },
        ttt_combine_sniper_summoner = {
            name = "Invocateur de tireur d'élite",
            desc = [[Invoque un tireur d'élite qui tuera tous ceux qui se trouvent devant lui!

            Fait face à la direction dans laquelle vous regardez.
            
            Ciblez sur le dessus d'une surface plane.]]
        },
        weapon_ttt_smg_soulbinding = {
            name = "Dispositif de Lien D'âme",
        },
        weapon_slazer_new = {
            name = "Laser Spartiate",
            desc = [[Maintenez le clic gauche pour tirer avec ce canon laser MASSIF!

            Provoque une puissante explosion]]
        },
        ttt_perk_speedcola = {
            name = "Cola Rapide",
        },
        weapon_ttt_mc_speedpotion = {
            name = "Potion de Vitesse",
        },
        speedgun = {
            name = "Fusil Rapide",
            desc = [[Une arme qui les rend plus rapides, pour toujours.
            (Jusqu'à la fin du tour)]]
        },
        weapon_ttt_whoa_randomat = {
            name = "Attaque Tournante",
            desc = [[Cliquez pour lancer une attaque.]]
        },
        weapon_spn_spongifier = {
            name = "Spongifiant",
        },
        weapon_spraymhs = {
            name = "Aérosol",
            desc = [[La 1ère arme blague que vous achetez est gratuite !

            Faites un clic droit pour changer de couleur.]]
        },
        weapon_m9k_vikhr = {
            name = "SR-3M Vikhr",
        },
        tfa_staff_lightning = {
            name = "Bâton de Foudre",
            desc = [[Tire rapidement des boules de plasma!

            Les projectiles ne sont pas un hitscan et mettent du temps à voyager dans les airs.]]
        },
        tfa_staff_wind = {
            name = "Bâton du Vent",
            desc = [[Tire des explosions aériennes à courte portée et causant de gros dégâts!]]
        },
        ttt_perk_staminup = {
            name = "Endurance",
        },
        weapon_stenmk3 = {
            name = "Sten Mark Trois",
        },
        weapon_m9k_auga3 = {
            name = "Steyr AOÛT A3",
        },
        weapon_m9k_striker12 = {
            name = "Attaquant 12",
        },
        weapon_sp_striker = {
            name = "Attaquant 12",
        },
        stungun = {
            name = "Pistolet Paralysant",
            desc = [[Stungun utilisé pour paralyser les ennemis en les rendant
            incapable de parler et de bouger pendant quelques secondes.
            Il a 3 charges.
            
            Créé par: Donkie]]
        },
        weapon_ttt_suicide = {
            name = "Bombe suicide",
            desc = [[Sortez en hurlant !

            Tue l'utilisateur et les terroristes environnants.]]
        },
        tfa_doom_ssg = {
            name = "Super Fusil de Chasse",
            desc = [[Le super fusil de chasse de DOOM.]]
        },
        weapon_ttt_supersheep = {
            name = "Super Mouton",
            desc = [[Laissez voler un mouton volant explosif!

            Votre caméra le suit pendant que vous restez immobile.
            
            Dirigez-le avec votre souris, entrez en collision avec quelque chose pour exploser et appuyez sur 'R' pour augmenter la vitesse.]]
        },
        surprisesoldiers = {
            name = "Soldats Surprises",
            desc = [[Générez un soldat combiné aléatoire là où vous tirez!]]
        },
        weapon_syringegun = {
            name = "Pistolet à Seringue",
        },
        weapon_taser_derens = {
            name = "Pistolet Paralysant",
            desc = [[Doit être à courte portée pour l'instakill. Usage unique.]]
        },
        weapon_tax_kit = {
            name = "Kit de Taxidermie",
            desc = [[Ressuscite un innocent en traître.]]
        },
        weapon_tf2pistol = {
            name = "Pistolet TF2",
        },
        weapon_tf2revolver = {
            name = "Revolver TF2",
        },
        weapon_tf2shotgun = {
            name = "Fusil à Pompe TF2",
        },
        weapon_tf2smg = {
            name = "Pistolet-Mitrailleur TF2",
        },
        weapon_sniper = {
            name = "Tireur D'élite TF2",
        },
        tfa_shrinkray = {
            name = "Le Créateur de Bébé",
            desc = [[Tire un orbe qui rétrécit tous ceux qu'il touche!
            Cela les réduit à 1 point de vie.
            
            Marcher sur quelqu'un alors qu'il est rétréci le tue.]]
        },
        tfa_jetgun = {
            name = "Le Pistolet à Réaction",
            desc = [[Aspire les gens et les tue instantanément.

            Surchauffe et explose s'il est utilisé trop longtemps sans refroidir.]]
        },
        the_xmas_gun = {
            name = "Le Pistolet de Noël",
            desc = [[Tirez des cadeaux qui tuent d'un seul coup]]
        },
        weapon_ttt_knife_randomat = {
            name = "Couteau de lancer"
        },
        tfa_thundergun = {
            name = "Fusil-Tonnerre",
            desc = [[Tire une explosion aérienne massive qui envoie voler toute personne se trouvant à courte distance!]]
        },
        weapons_ttt_time_manipulator = {
            name = "Manipulateur de Temps",
            desc = [[Clic gauche: Ralentir le temps.

            Clic droit: accélérer le temps.
            
            R: Réinitialisation à la vitesse normale.]]
        },
        weapon_ttt_timestop = {
            name = "Arrêt du Temps",
            desc = [[Gèle le temps pendant quelques secondes.
            Vous pouvez en tuer d'autres pendant qu'ils sont gelés.
            
            N'affecte pas les détectives!]]
        },
        weapon_m9k_thompson = {
            name = "Mitraillette",
        },
        weapon_ttt_bike = {
            name = "Vélo de Traître",
            desc = [[Lancez un vélo sur quelqu'un.

            Fais-le, espèce de merde.]]
        },
        weapon_ttt_impostor_knife_randomat = {
            name = "Couteau de tueur de Traître"
        },
        weapon_ttt_turret = {
            name = "Tourelle",
            desc = [[Générez une tourelle pour tirer sur des ennemis innocents]]
        },
        weapon_ttt_turtlenade = {
            name = "Grenade Tortue",
            desc = [[Grenade à tortue.
            Libère plusieurs tortues hostiles lors de la détonation.]]
        },
        weapon_unoreverse = {
            name = "ONU inversé",
            desc = [[Lors de l'activation, renvoie TOUS LES DOMMAGES à l'attaquant!

            Dure 3 secondes.]]
        },
        weapon_m9k_usas = {
            name = "États-Unis",
        },
        weapon_ap_vector = {
            name = "Vecteur",
        },
        swep_rifle_viper = {
            name = "Fusil Vipère",
        },
        weapon_ttt_wpnjammer = {
            name = "Brouilleur d'armes",
            desc = [[Désactivez complètement l'arme équipée de quelqu'un.

            Pour l'utiliser, appuyez sur 'E' sur une cible tout en sélectionnant n'importe quelle arme.]]
        },
        ttt_weeping_angel = {
            name = "Ange Pleurant",
            desc = [[Tirez sur quelqu'un pour qu'une statue "Weeping Angel" le suive.

            Pendant qu'ils ne la regardent pas, la statue de l'ange se rapproche d'eux.
            
            Si la statue les touche, ils meurent.]]
        },
        tfa_wintershowl = {
            name = "Le Hurlement de L'hiver",
            desc = [[Tire un souffle d'air froid à courte portée qui gèle les gens et les tue après quelques secondes.]]
        },
        weapon_wrench = {
            name = "Clé",
        },
        wt_writingpad = {
            name = "Bloc-notes",
            desc = [[La première arme blague que vous achetez une cartouche est gratuite!

            Créez un message sur une pancarte que vous tenez, pour que tout le monde puisse le lire.
             
            Quelle meilleure utilisation de votre crédit ?
             
            R-Modifier
            Clic gauche - Afficher le signe]]
        },
        tfa_wunderwaffe = {
            name = "Wunderwaffe DG-2",
            desc = [[Fusil éclair puissant qui tue en 1 seul coup !

            Vous tuera également si vous tirez trop près!]]
        },
        weapon_ttt_zapgren = {
            name = "Grenade Zap",
            desc = [[Une grenade hautement explosive.

            Prudent! Il peut exploser dans votre main si vous
            faites-le cuire trop longtemps !]]
        },
        tfa_wavegun = {
            name = "Pistolets Zap",
            desc = [[Pistolets laser à double usage.
            Appuyez sur le clic gauche ou droit pour tirer!]]
        },
        zombiegunspawn = {
            name = "Pistolet zombie",
            desc = [[Placez 15 Zombies autour de vos ennemis et profitez du désastre!]]
        },
        weapon_mad_zombificator = {
            name = "Dispositif de Zombification",
            desc = [[Transforme les joueurs morts en zombies.]]
        }
    }

    for _, SWEPCopy in ipairs(weapons.GetList()) do
        local classname = WEPS.GetClass(SWEPCopy)

        if classname and translatedWeapons[classname] then
            local SWEP = weapons.GetStored(classname)
            if not SWEP then continue end

            if SWEP.PrintName then
                SWEP.origPrintName = SWEP.PrintName
                SWEP.PrintName = translatedWeapons[classname].name
            end

            if SWEP.EquipMenuData and SWEP.EquipMenuData.type then
                SWEP.EquipMenuData.origType = SWEP.EquipMenuData.type
                SWEP.EquipMenuData.type = translatedWeapons[classname].type or "item_weapon"
            end

            if SWEP.EquipMenuData and SWEP.EquipMenuData.desc and translatedWeapons[classname].desc then
                SWEP.EquipMenuData.origDesc = SWEP.EquipMenuData.desc
                SWEP.EquipMenuData.desc = translatedWeapons[classname].desc
            end
        elseif classname then
            local SWEP = weapons.GetStored(classname)
            if not SWEP then continue end

            if SWEP.PrintName then
                local placeholderName = string.find(SWEP.PrintName, "_")

                if not placeholderName then
                    SWEP.origPrintName = SWEP.PrintName
                    SWEP.PrintName = "Le " .. SWEP.PrintName
                end
            end
        end
    end

    -- Sets the names of held weapons and ones on the ground
    for _, ent in ipairs(ents.GetAll()) do
        local classname = ent:GetClass()

        if classname and translatedWeapons[classname] and translatedWeapons[classname].name then
            ent.PrintName = translatedWeapons[classname].name
        elseif classname then
            local SWEP = weapons.GetStored(classname)

            if SWEP then
                ent.PrintName = SWEP.PrintName
            end
        end
    end

    RunConsoleCommand("ttt_reset_weapons_cache")
    -- Adding a French flag colours overlay
    flagPanelFrame = vgui.Create("DFrame")
    flagPanelFrame:SetSize(ScrW(), ScrH())
    flagPanelFrame:SetPos(0, 0)
    flagPanelFrame:SetTitle("")
    flagPanelFrame:SetDraggable(false)
    flagPanelFrame:ShowCloseButton(false)
    flagPanelFrame:SetVisible(true)
    flagPanelFrame:SetDeleteOnClose(true)
    flagPanelFrame:SetZPos(-32768)

    flagPanelFrame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w * 1 / 3, h, Color(0, 36, 150, 10))
        draw.RoundedBox(0, w * 1 / 3, 0, w * 1 / 3, h, Color(255, 255, 255, 10))
        draw.RoundedBox(0, w * 2 / 3, 0, w * 1 / 3, h, Color(237, 40, 57, 10))
    end

    music = net.ReadBool()

    if music then
        surface.PlaySound("french/chic_magnet.mp3")

        timer.Create("FrenchRandomatMusicLoop", 61.7, 0, function()
            surface.PlaySound("french/chic_magnet.mp3")
        end)

        timer.Simple(5, function()
            chat.AddText("\nPress 'M' to mute music!\n\nerr I mean... Appuyez sur 'M' pour couper la musique!")
        end)

        hook.Add("PlayerButtonDown", "FrenchMuteMusicButton", function(ply, button)
            if button == KEY_M then
                RunConsoleCommand("stopsound")
                chat.AddText("Music muted")
                music = false
                timer.Remove("FrenchRandomatMusicLoop")
                hook.Remove("PlayerButtonDown", "FrenchMuteMusicButton")
            end
        end)
    end
end)