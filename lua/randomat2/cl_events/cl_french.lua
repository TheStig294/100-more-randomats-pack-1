local roleStringsOrig
local roleStringsExtOrig
local roleStringsPluralOrig
local customPassiveItemsOrig
local flagPanelFrame
local music

net.Receive("FrenchRandomatBegin", function()
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
    translatedRoles["Voleur De Corps"] = ROLE_BODYSNATCHER
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
    translatedRoles["Esprit De La Ruche"] = ROLE_HIVEMIND
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
    translatedRoles["Serviteur De L'effroi"] = ROLE_DREADTHRALL
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
    translatedRoles["Un Voleur De Corps"] = ROLE_BODYSNATCHER
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
    translatedRoles["Un Esprit De La Ruche"] = ROLE_HIVEMIND
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
    translatedRoles["Serviteur De L'effroi"] = ROLE_DREADTHRALL
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
    translatedRoles["Voleurs De Corps"] = ROLE_BODYSNATCHER
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
    translatedRoles["Esprits De La Ruche"] = ROLE_HIVEMIND
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
    translatedRoles["Chuchoteurs De Fantômes"] = ROLE_GHOSTWHISPERER
    translatedRoles["Renégates"] = ROLE_RENEGADE
    translatedRoles["Limites De L'âme"] = ROLE_SOULBOUND
    translatedRoles["Mages D'âme"] = ROLE_SOULMAGE
    translatedRoles["Élémentalistes"] = ROLE_ELEMENTALIST
    translatedRoles["Médecins"] = ROLE_PHYSICIAN
    -- External Roles --
    translatedRoles["Annonceurs"] = ROLE_ANNOUNCER
    translatedRoles["Serviteurs De L'effroi"] = ROLE_DREADTHRALL
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
        if SHOP_ROLES[role] then
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
        weapon_m9k_honeybadger = {
            name = "AAC H-Blaireau",
        },
        tfa_acidgat = {
            name = "Acide Gat",
            desc = [[Tire plusieurs explosifs qui collent aux joueurs et explosent après quelques secondes.]]
        },
        weapon_m9k_acr = {
            name = "ACR",
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
        weapon_m9k_ak47 = {
            name = "AK-47",
        },
        weapon_m9k_ak74 = {
            name = "AK-74",
        },
        weapon_ttt_ak47 = {
            name = "AK47",
            desc = [[Fusil d'assaut avec des dégâts très élevés.

            A un recul très élevé.]]
        },
        ttt_player_pinger = {
            name = "Joueur Pinger",
            desc = [[Vous permet de voir tout le monde à travers les murs pendant une durée limitée!]]
        },
        weapon_m9k_amd65 = {
            name = "AMD-65",
        },
        weapon_amongussummoner = {
            name = "Parmi l'invocateur",
            desc = [[Faites un clic gauche pour placer un piège invisible au sol.

            Si un joueur marche dessus, un monstre porteur d'explosifs apparaît et attaque!]]
        },
        weapon_m9k_an94 = {
            name = "AN-94",
        },
        avengers_ttt_minifier = {
            name = "Costume D'homme Fourmi"
        },
        weapon_antlionsummoner = {
            name = "Invocateur De Fourmilion",
            desc = [[Invoque un garde fourmilion. Cible sur le dessus d'une surface plane]]
        },
        weapon_hp_ares_shrike = {
            name = "Pie-grièche D'Arès",
        },
        weapon_m9k_ares_shrike = {
            name = "Pie-grièche D'Arès",
        },
        tfa_bo3_argus = {
            name = "Argus"
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
        weapon_m9k_aw50 = {
            name = "AW-50",
        },
        weapon_ttt_loudawp = {
            name = "AWP",
            desc = [[Fusil de précision AWP silencieux.

            Il n'a que deux coups.
            
            Les victimes ne crieront pas lorsqu'elles seront tuées.]]
        },
        weapon_ttt_titanfall_wingman = {
            name = "template",
            desc = [[template]]
        },
        ttt_backwards_shotgun = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_baguette_randomat = {
            name = "template",
        },
        weapon_fre_baguette = {
            name = "template",
        },
        weapon_ballin = {
            name = "template",
        },
        weapon_banana = {
            name = "template",
            desc = [[template]]
        },
        st_bananapistol = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_barnacle = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_barret_m82 = {
            name = "template",
        },
        weapon_m9k_m98b = {
            name = "template",
        },
        weapon_bat = {
            name = "template",
        },
        weapon_ttt_beacon = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_beartrap = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_randomatbeecannon = {
            name = "template",
        },
        weapon_ttt_beenade = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_m3 = {
            name = "template",
        },
        tfa_dax_big_glock = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_binoculars = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_bizonp19 = {
            name = "template",
        },
        weapon_vadim_blink = {
            name = "template",
            desc = [[template]]
        },
        tfa_blundergat = {
            name = "template",
            desc = [[template]]
        },
        weapon_bod_bodysnatch = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_bomb_station = {
            name = "template",
            desc = [[template]]
        },
        weapon_thr_bonecharm = {
            name = "template",
            desc = [[template]]
        },
        weapon_bonesaw = {
            name = "template",
        },
        weapon_ttt_bonk_bat = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_boomerang = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_boomerang_randomat = {
            name = "template",
            desc = [[template]]
        },
        tfa_staff_wind_ult = {
            name = "template",
            desc = [[template]]
        },
        weapon_bottle = {
            name = "template",
        },
        weapon_ttt_brain = {
            name = "template",
            desc = [[template]]
        },
        weapon_hyp_brainwash = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_browningauto5 = {
            name = "template",
        },
        weapon_qua_bomb_station = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_c4 = {
            name = "template",
            desc = [[template]]
        },
        tfa_mercy_nope = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_randomatcandycane = {
            name = "template",
            desc = [[template]]
        },
        avengers_ttt_shield = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_car_gun = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_chickennade = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_chickenator = {
            name = "template",
            desc = [[template]]
        },
        weapon_randomat_christmas_cannon = {
            name = "template",
        },
        weapon_san_christmas_cannon = {
            name = "template",
        },
        weapon_ttt_cracker = {
            name = "template",
            desc = [[template]]
        },
        weapon_zom_claws = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_cloak = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_randomatclub = {
            name = "template",
        },
        weapon_yeti_club = {
            name = "template",
        },
        weapon_ttt_clutterbomb = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_colt1911 = {
            name = "template",
        },
        weapon_m9k_coltpython = {
            name = "template",
        },
        weapon_com_manifesto = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_comrade_bomb = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_confetti = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_confgrenade = {
            name = "template",
        },
        weapon_controllable_manhack = {
            name = "template",
            desc = [[template]]
        },
        corpselauncher = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_printer = {
            name = "template",
            desc = [[template]]
        },
        weapon_zm_improvised = {
            name = "template",
        },
        weapon_cup_bow = {
            name = "template",
        },
        dancedead = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_dancedead = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_dd = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_dead_ringer = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_deadringer = {
            name = "template",
            desc = [[template]]
        },
        weapon_zm_revolver = {
            name = "template",
        },
        ttt_deal_with_the_devil = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_death_link = {
            name = "template",
            desc = [[template]]
        },
        death_note_ttt = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_decoy = {
            name = "template",
            desc = [[template]]
        },
        weapon_med_defib = {
            name = "template",
            desc = [[template]]
        },
        weapon_vadim_defib = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_defuser = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_demonsign = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_force_shield = {
            name = "template",
            desc = [[template]]
        },
        weapon_mhl_badge = {
            name = "template",
        },
        weapon_m9k_deagle = {
            name = "template",
        },
        weapon_ttt_dete_playercam = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_detectiveball = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_randomatdetonator = {
            name = "template",
        },
        weapon_discordgift = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_dislocator = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_wtester = {
            name = "template",
            desc = [[template]]
        },
        weapon_doncombinesummoner = {
            name = "template",
            desc = [[template]]
        },
        doncmk2_swep = {
            name = "template",
            desc = [[template]]
        },
        weapon_sp_dbarrel = {
            name = "template",
        },
        weapon_old_dbshotgun = {
            name = "template",
        },
        weapon_m9k_dbarrel = {
            name = "template",
        },
        ttt_perk_doubletap = {
            name = "template",
        },
        weapon_dp = {
            name = "template",
        },
        weapon_ttt_dragon_elites = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_svu = {
            name = "template",
        },
        weapon_dubstepgun = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_duel_revolver_randomat = {
            name = "template",
        },
        ttt_weapon_eagleflightgun = {
            name = "template",
            desc = [[template]]
        },
        weapon_pha_exorcism = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_extinguisher = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_famas = {
            name = "template",
        },
        weapon_ttt_famas = {
            name = "template",
        },
        weapon_vam_fangs = {
            name = "template",
            desc = [[template]]
        },
        weapon_fartgrenade = {
            name = "template",
        },
        fp = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_fg42 = {
            name = "template",
        },
        weapon_fg42 = {
            name = "template",
        },
        weapon_ttt_fingergun = {
            name = "template",
            desc = [[template]]
        },
        weapon_fireaxe = {
            name = "template",
        },
        weapon_ttt_fire_dash = {
            name = "template",
            desc = [[template]]
        },
        custom_firestarter = {
            name = "template",
            desc = [[template]]
        },
        weapon_fistsheavy = {
            name = "template",
        },
        fkg_gifter_swep = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_flaregun = {
            name = "template",
            desc = [[template]]
        },
        weapon_spy_flaregun = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_flashbang = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_f2000 = {
            name = "template",
        },
        weapon_m9k_fal = {
            name = "template",
        },
        weapon_ttt_p90 = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_smgp90 = {
            name = "template",
        },
        weapon_ttt_foolsgoldengun = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_fortnite_building = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_frag = {
            name = "template",
            desc = [[template]]
        },
        weapon_rp_railgun = {
            name = "template",
        },
        weapon_ttt_freezegun = {
            name = "template",
            desc = [[template]]
        },
        terror_fulton = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_g36c = {
            name = "template",
        },
        weapon_ttt_g3sg1 = {
            name = "template",
        },
        weapon_ttt_galil = {
            name = "template",
        },
        weapon_gewehr43 = {
            name = "template",
        },
        weapon_ttt_gwh_ghosting = {
            name = "template",
        },
        weapon_ttt_glock = {
            name = "template",
        },
        weapon_m9k_glock = {
            name = "template",
        },
        weapon_randomat_boxgloves = {
            name = "template",
            desc = [[template]]
        },
        weapon_box_gloves = {
            name = "template",
            desc = [[template]]
        },
        weapon_gnome_grenade = {
            name = "template",
            desc = [[template]]
        },
        weapon_ap_golddragon = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_nrgoldengun = {
            name = "template",
            desc = [[template]]
        },
        weapon_kra_carry = {
            name = "template",
        },
        weapon_ttt_gimnade = {
            name = "template",
            desc = [[template]]
        },
        manipulator = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_gravity_pistol = {
            name = "template",
            desc = [[template]]
        },
        weapon_hp_glauncher = {
            name = "template",
            desc = [[template]]
        },
        weapon_zm_molotov = {
            name = "template",
        },
        weapon_ttt_smokegrenade = {
            name = "template",
        },
        weapon_zm_sledge = {
            name = "template",
        },
        weapon_ttt_handcuffs = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_hwapoon = {
            name = "template",
            desc = [[template]]
        },
        avengers_hawkeye_crybow = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_headlauncher = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_mc_healthpotion = {
            name = "template",
        },
        weapon_ttt_phy_tracker = {
            name = "template",
        },
        c_reaper_nope = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_m416 = {
            name = "template",
        },
        weapon_m9k_g3a3 = {
            name = "template",
        },
        weapon_m9k_mp5 = {
            name = "template",
        },
        weapon_m9k_mp5sd = {
            name = "template",
        },
        weapon_m9k_mp7 = {
            name = "template",
        },
        weapon_m9k_sl8 = {
            name = "template",
        },
        weapon_m9k_ump45 = {
            name = "template",
        },
        weapon_m9k_usc = {
            name = "template",
        },
        weapon_m9k_usp = {
            name = "template",
        },
        weapon_m9k_hk45 = {
            name = "template",
        },
        weapon_ttt_homebat = {
            name = "template",
            desc = [[template]]
        },
        swep_homingpigeon = {
            name = "template",
            desc = [[template]]
        },
        weapon_ap_hbadger = {
            name = "template",
        },
        weapon_ttt_hotpotato = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_health_station = {
            name = "template",
            desc = [[template]]
        },
        avengers_fists = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_id_bomb = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_id_bomb_defuser = {
            name = "template",
            desc = [[template]]
        },
        weapon_ars_igniter = {
            name = "template",
        },
        weapon_ttt_mc_immortpotion = {
            name = "template",
        },
        weapon_tttbasegrenade = {
            name = "template",
        },
        weapon_m9k_intervention = {
            name = "template",
        },
        weapon_ttt_mc_invispotion = {
            name = "template",
        },
        avengers_ironman = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_ithacam37 = {
            name = "template",
        },
        weapon_ttt_jarate = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_detective_lightsaber = {
            name = "template",
            desc = [[template]]
        },
        shared = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_jetpack = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_jetpackspawner = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_jihad = {
            name = "template",
            desc = [[template]]
        },
        weapon_john_bomb = {
            name = "template",
            desc = [[template]]
        },
        ttt_perk_juggernog = {
            name = "template",
        },
        weapon_ttt_jumpgun = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_kac_pdw = {
            name = "template",
        },
        ttt_kamehameha_swep = {
            name = "template",
            desc = [[template]]
        },
        weapon_kil_crowbar = {
            name = "template",
            desc = [[template]]
        },
        tfa_staff_lightning_ult = {
            name = "template",
            desc = [[template]]
        },
        crimson_new = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_secretsantaknife = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_knife = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_randomatknife = {
            name = "template",
            desc = [[template]]
        },
        weapon_kil_knife = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_vector = {
            name = "template",
        },
        weapon_machete = {
            name = "template",
        },
        weapon_m9k_l85 = {
            name = "template",
        },
        laserpointer = {
            name = "template",
            desc = [[template]]
        },
        weapon_lee = {
            name = "template",
        },
        weapon_enfield_4 = {
            name = "template",
        },
        weapon_ttt_liftgren = {
            name = "template",
            desc = [[template]]
        },
        c_dvaredux_nope = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_lightningar1 = {
            name = "template",
            desc = [[template]]
        },
        avengers_smooleystormbreaker = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_traitor_lightsaber = {
            name = "template",
            desc = [[template]]
        },
        weapon_long_revolver = {
            name = "template",
            desc = [[template]]
        },
        weapon_luger = {
            name = "template",
        },
        weapon_m9k_m14sp = {
            name = "template",
        },
        weapon_ttt_m16 = {
            name = "template",
        },
        weapon_m9k_m16a4_acog = {
            name = "template",
        },
        weapon_m9k_m1918bar = {
            name = "template",
        },
        weapon_catgun = {
            name = "template",
        },
        weapon_m9k_m24 = {
            name = "template",
        },
        weapon_m9k_m249lmg = {
            name = "template",
        },
        weapon_m9k_m29satan = {
            name = "template",
        },
        weapon_m3 = {
            name = "template",
        },
        weapon_m9k_m4a1 = {
            name = "template",
        },
        weapon_m9k_m60 = {
            name = "template",
        },
        weapon_m9k_m92beretta = {
            name = "template",
        },
        weapon_zm_mac10 = {
            name = "template",
        },
        c_sombra_gun_n = {
            name = "template",
            desc = [[template]]
        },
        maclunkey = {
            name = "template",
            desc = [[template]]
        },
        weapon_zm_carry = {
            name = "template",
        },
        weapon_m9k_magpulpdr = {
            name = "template",
        },
        weapon_ttt_malfunctionpistol = {
            name = "template",
            desc = [[template]]
        },
        giantsupermariomushroom = {
            name = "template",
            desc = [[template]]
        },
        weapon_mastersword = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_medkit = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_meme_gun = {
            name = "template",
            desc = [[template]]
        },
        doi_mg42 = {
            name = "template",
        },
        weapon_ttt_minic = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_mine_turtle = {
            name = "template",
            desc = [[template]]
        },
        minecraft_swep = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_minifier = {
            name = "template",
            desc = [[template]]
        },
        weapon_minigun = {
            name = "template",
        },
        weapon_m9k_jackhammer = {
            name = "template",
        },
        weapon_ttt_moonball = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_mossberg590 = {
            name = "template",
        },
        weapon_m9k_mp40 = {
            name = "template",
        },
        weapon_ttt_mp5 = {
            name = "template",
        },
        weapon_ttt_smg = {
            name = "template",
        },
        weapon_m9k_mp9 = {
            name = "template",
        },
        weapon_ap_mrca1 = {
            name = "template",
        },
        weapon_ttt_mud_device_randomat = {
            name = "template",
        },
        weapon_ttt_push = {
            name = "template",
            desc = [[template]]
        },
        avengers_nick_pistol = {
            name = "template",
            desc = [[template]]
        },
        ttt_no_scope_awp = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_zombievault = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_detective_supersheep = {
            name = "template",
            desc = [[template]]
        },
        one_punch_skin = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_pistol_randomat = {
            name = "template",
        },
        weapon_ttt_obc = {
            name = "template",
            desc = [[template]]
        },
        weapon_valenok = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_luger = {
            name = "template",
        },
        weapon_ttt_p228 = {
            name = "template",
        },
        weapon_ttt_painkillers = {
            name = "template",
            desc = [[template]]
        },
        weapon_paintgun = {
            name = "template",
            desc = [[template]]
        },
        weapon_qua_fake_cure = {
            name = "template",
            desc = [[template]]
        },
        weapon_par_cure = {
            name = "template",
            desc = [[template]]
        },
        custom_pewgun = {
            name = "template",
            desc = [[template]]
        },
        ttt_perk_phd = {
            name = "template",
        },
        weapon_ttt_pickle_rick_gun = {
            name = "template",
            desc = [[template]]
        },
        weapon_zm_pistol = {
            name = "template",
        },
        weapon_m9k_pkm = {
            name = "template",
        },
        weapon_teleport_gun_t = {
            name = "template",
            desc = [[template]]
        },
        weapon_rp_pocket = {
            name = "template",
        },
        weapon_ttt_mc_poison = {
            name = "template",
        },
        weapon_ttt_phammer = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_popupgun = {
            name = "template",
            desc = [[template]]
        },
        weapon_portalgun = {
            name = "template",
            desc = [[template]]
        },
        weapon_possessed_melon_launcher = {
            name = "template",
            desc = [[template]]
        },
        weapon_ap_pp19 = {
            name = "template",
        },
        weapon_ppsh41 = {
            name = "template",
        },
        weapon_prop_blaster = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_prop_disguiser = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_prop_hunt_gun = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_propexploder = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_psg1 = {
            name = "template",
        },
        weapon_psm_disguiser = {
            name = "template",
        },
        tfa_tracer_nope = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_pump = {
            name = "template",
        },
        pusher_swep = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_csgo_r8revolver = {
            name = "template",
        },
        weapon_ttt_radio = {
            name = "template",
            desc = [[template]]
        },
        weapon_pp_rbull = {
            name = "template",
        },
        weapon_m9k_ragingbull = {
            name = "template",
        },
        weapon_m9k_scoped_taurus = {
            name = "template",
        },
        weapon_randomlauncher = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_randomat = {
            name = "template",
            desc = [[template]]
        },
        tfa_raygun = {
            name = "template",
            desc = [[template]]
        },
        tfa_raygun_mark2 = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_titanfall_autopistol = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_rmgrenade = {
            name = "template",
            desc = [[template]]
        },
        weapon_pp_remington = {
            name = "template",
        },
        weapon_m9k_remington1858 = {
            name = "template",
        },
        weapon_m9k_remington7615p = {
            name = "template",
        },
        weapon_m9k_remington870 = {
            name = "template",
        },
        tfa_bo2_remington_nma = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_randomatrevolver = {
            name = "template",
        },
        weapon_ttt_revolver_randomat = {
            name = "template",
        },
        weapon_zm_rifle = {
            name = "template",
        },
        weapon_ttt_mc_jumppotion = {
            name = "template",
        },
        weapon_ttt_rocket_thruster = {
            name = "template",
            desc = [[template]]
        },
        weapon_gue_guesser = {
            name = "template",
        },
        weapon_ttt_rollermine = {
            name = "template",
            desc = [[template]]
        },
        rotgun = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_rsb = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_rsb_defuser = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_revolver = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_model3russian = {
            name = "template",
        },
        weapon_m9k_model627 = {
            name = "template",
        },
        ttt_sahmin_gun = {
            name = "template",
            desc = [[template]]
        },
        weapon_inf_scanner = {
            name = "template",
        },
        weapon_m9k_scar = {
            name = "template",
        },
        weapon_scattergun = {
            name = "template",
        },
        tfa_scavenger = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_sg550 = {
            name = "template",
        },
        weapon_ttt_sg552 = {
            name = "template",
        },
        weapon_ttt_cloak_randomat = {
            name = "template",
        },
        weapon_shark_idol = {
            name = "template",
            desc = [[template]]
        },
        weapon_shark_trap = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_shocktrap = {
            name = "template",
            desc = [[template]]
        },
        weapon_zm_shotgun = {
            name = "template",
        },
        weapon_shovel = {
            name = "template",
        },
        weapon_m9k_sig_p229r = {
            name = "template",
        },
        weapon_ttt_awp = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_m4a1_s = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_tmp_s = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_sipistol = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_slam = {
            name = "template",
            desc = [[template]]
        },
        ttt_slappers = {
            name = "template",
            desc = [[template]]
        },
        tfa_sliquifier = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_timeslowgrenade = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_paper_plane = {
            name = "template",
            desc = [[template]]
        },
        ttt_combine_sniper_summoner = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_smg_soulbinding = {
            name = "template",
        },
        weapon_slazer_new = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_spas12 = {
            name = "template",
        },
        ttt_perk_speedcola = {
            name = "template",
        },
        weapon_ttt_mc_speedpotion = {
            name = "template",
        },
        speedgun = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_whoa_randomat = {
            name = "template",
            desc = [[template]]
        },
        weapon_spn_spongifier = {
            name = "template",
        },
        weapon_spraymhs = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_vikhr = {
            name = "template",
        },
        tfa_staff_lightning = {
            name = "template",
            desc = [[template]]
        },
        tfa_staff_wind = {
            name = "template",
            desc = [[template]]
        },
        ttt_perk_staminup = {
            name = "template",
        },
        weapon_qua_station_bomb = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_sten = {
            name = "template",
        },
        weapon_stenmk3 = {
            name = "template",
        },
        weapon_m9k_auga3 = {
            name = "template",
        },
        weapon_m9k_striker12 = {
            name = "template",
        },
        weapon_sp_striker = {
            name = "template",
        },
        stungun = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_stungun = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_suicide = {
            name = "template",
            desc = [[template]]
        },
        tfa_doom_ssg = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_supersheep = {
            name = "template",
            desc = [[template]]
        },
        surprisesoldiers = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_dragunov = {
            name = "template",
        },
        weapon_m9k_svt40 = {
            name = "template",
        },
        weapon_svt40 = {
            name = "template",
        },
        weapon_syringegun = {
            name = "template",
        },
        weapon_m9k_tar21 = {
            name = "template",
        },
        weapon_taser_derens = {
            name = "template",
            desc = [[template]]
        },
        weapon_tax_kit = {
            name = "template",
            desc = [[template]]
        },
        weapon_ap_tec9 = {
            name = "template",
        },
        weapon_m9k_tec9 = {
            name = "template",
        },
        weapon_ttt_teleport = {
            name = "template",
            desc = [[template]]
        },
        weapon_tf2pistol = {
            name = "template",
        },
        weapon_tf2revolver = {
            name = "template",
        },
        weapon_tf2shotgun = {
            name = "template",
        },
        weapon_tf2smg = {
            name = "template",
        },
        weapon_sniper = {
            name = "template",
        },
        tfa_shrinkray = {
            name = "template",
            desc = [[template]]
        },
        tfa_jetgun = {
            name = "template",
            desc = [[template]]
        },
        the_xmas_gun = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_contender = {
            name = "template",
        },
        weapon_ttt_knife_randomat = {
            name = "template",
            desc = [[template]]
        },
        tfa_thundergun = {
            name = "template",
            desc = [[template]]
        },
        thw_swep = {
            name = "template",
            desc = [[template]]
        },
        weapons_ttt_time_manipulator = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_timestop = {
            name = "template",
            desc = [[template]]
        },
        weapon_tt = {
            name = "template",
        },
        weapon_m9k_thompson = {
            name = "template",
        },
        weapon_ttt_bike = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_impostor_knife_randomat = {
            name = "template",
            desc = [[template]]
        },
        weapon_tur_changer = {
            name = "template",
        },
        weapon_ttt_turret = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_turtlenade = {
            name = "template",
            desc = [[template]]
        },
        weapon_t14nambu = {
            name = "template",
        },
        weapon_t38 = {
            name = "template",
        },
        weapon_ttt_unarmed = {
            name = "template",
        },
        weapon_unoreverse = {
            name = "template",
            desc = [[template]]
        },
        weapon_m9k_usas = {
            name = "template",
        },
        weapon_ttt_pistol = {
            name = "template",
        },
        weapon_m9k_uzi = {
            name = "template",
        },
        tfa_vr11 = {
            name = "template",
            desc = [[template]]
        },
        weapon_ap_vector = {
            name = "template",
        },
        swep_rifle_viper = {
            name = "template",
        },
        weapon_ttt_cse = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_wpnjammer = {
            name = "template",
            desc = [[template]]
        },
        ttt_weeping_angel = {
            name = "template",
            desc = [[template]]
        },
        weapon_welrod = {
            name = "template",
        },
        weapon_sp_winchester = {
            name = "template",
        },
        weapon_m9k_winchester73 = {
            name = "template",
        },
        weapon_m9k_1887winchester = {
            name = "template",
        },
        weapon_m9k_1897winchester = {
            name = "template",
        },
        tfa_wintershowl = {
            name = "template",
            desc = [[template]]
        },
        weapon_wrench = {
            name = "template",
        },
        wt_writingpad = {
            name = "template",
            desc = [[template]]
        },
        tfa_wunderwaffe = {
            name = "template",
            desc = [[template]]
        },
        weapon_ttt_zapgren = {
            name = "template",
            desc = [[template]]
        },
        tfa_wavegun = {
            name = "template",
            desc = [[template]]
        },
        zombiegunspawn = {
            name = "template",
            desc = [[template]]
        },
        weapon_mad_zombificator = {
            name = "template",
            desc = [[template]]
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

            if SWEP.EquipMenuData and SWEP.EquipMenuData.desc then
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

net.Receive("FrenchRandomatEnd", function()
    RunConsoleCommand("ttt_language", "auto")
    -- Resets the names of roles
    ROLE_STRINGS = roleStringsOrig or ROLE_STRINGS
    ROLE_STRINGS_EXT = roleStringsExtOrig or ROLE_STRINGS_EXT
    ROLE_STRINGS_PLURAL = roleStringsPluralOrig or ROLE_STRINGS_PLURAL

    -- Resets the names of custom passive items
    if customPassiveItemsOrig then
        for role = 1, ROLE_MAX do
            if SHOP_ROLES[role] then
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
end)