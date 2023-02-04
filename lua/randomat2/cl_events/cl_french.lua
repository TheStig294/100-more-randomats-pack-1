local roleStringsOrig
local roleStringsExtOrig
local roleStringsPluralOrig
local customPassiveItemsOrig
local flagPanelFrame
local music

net.Receive("FrenchRandomatBegin", function()
    -- Renaming weapons with TTT language support
    -- CoD Wonder Weapons
    LANG.AddToLanguage("FrançaisRandomat", "ww_desc_wunderwaffe", "WUNDERWAFFE DG-2: tire un éclair qui tue instantanément!")
    LANG.AddToLanguage("FrançaisRandomat", "ww_desc_wavegun", "PISTOLETS ZAP: Pistolets laser à double arme, appuyez sur le clic gauche ou droit pour tirer !")
    LANG.AddToLanguage("FrançaisRandomat", "ww_desc_windstaff", "BÂTON DU VENT: tire des jets d'air à courte portée et à dégâts élevés!")
    LANG.AddToLanguage("FrançaisRandomat", "ww_desc_shrinkray", "LE FABRICANT DE BÉBÉS: tire un orbe qui rétrécit tous ceux qu'il touche!\nCela les réduit à 1 point de vie. Marcher dans n'importe qui alors qu'il est rétréci le tue.")
    LANG.AddToLanguage("FrançaisRandomat", "ww_desc_vr11", "VR-11: Toute personne que vous tirez a le pouvoir de tuer instantanément avec des armes ordinaires! Dure un temps limité.")
    LANG.AddToLanguage("FrançaisRandomat", "ww_desc_wintershowl", "HURLEMENT DE L'HIVER: tire un souffle d'air froid à courte portée qui gèle n'importe qui à mort!")
    LANG.AddToLanguage("FrançaisRandomat", "ww_desc_thundergun", "PISTOLET THUNDER: Tire un souffle d'air massif qui envoie n'importe qui dans un vol à courte portée!")
    LANG.AddToLanguage("FrançaisRandomat", "ww_desc_lightningstaff", "BÂTON DE LA FOUDRE: tire rapidement des boules de plasma!\nLes projectiles ne sont pas un hitscan et mettent du temps à voyager dans les airs.")
    LANG.AddToLanguage("FrançaisRandomat", "ww_desc_sliquifier", "SLIQUIFIER: Tire des boules de slime qui tuent instantanément! Si vous frappez quelqu'un ou le sol, laisse une flaque de boue glissante.")
    LANG.AddToLanguage("FrançaisRandomat", "ww_desc_scavenger", "CHAROGNARD: Tire un explosif qui colle aux joueurs et explose après quelques secondes.")
    LANG.AddToLanguage("FrançaisRandomat", "ww_desc_raygun_mark2", "PISTOLET À RAYONS MARQUE 2: Tire une rafale de lasers à dégâts élevés!")
    LANG.AddToLanguage("FrançaisRandomat", "ww_desc_raygun", "PISTOLET À RAYONS: Tire des lasers à dégâts élevés! Vous subissez des dégâts de recul si vous tirez trop près de votre cible.")
    LANG.AddToLanguage("FrançaisRandomat", "ww_desc_jetgun", "LE FUSIL À RÉACTION: Aspire les gens et tue instantanément! Surchauffe si utilisé trop longtemps.")
    LANG.AddToLanguage("FrançaisRandomat", "ww_desc_blundergat", "BLUNDERGAT : Un fusil à pompe incroyablement puissant !")
    LANG.AddToLanguage("FrançaisRandomat", "ww_desc_acidgat", "GAT ACIDE: Tire une rafale d'explosifs collants qui explosent après un certain délai.")
    -- Bruh Bunker
    LANG.AddToLanguage("FrançaisRandomat", "bunker_name", "Bunker de Bruh")
    LANG.AddToLanguage("FrançaisRandomat", "bunker_desc", "Craquement détecté! Présentez-vous au bunker bruh \nimmédiatement! \nCrée un bunker autour de vous lorsque vous subissez des dégâts.")
    LANG.AddToLanguage("FrançaisRandomat", "bunker_alert", "Infraction Cringe détectée! Un bunker d'urgence Bruh a été activé!")
    LANG.AddToLanguage("FrançaisRandomat", "bunker_buy", "Vous avez reçu un Bunker de Bruh.")
    -- Passive demonic possession
    LANG.AddToLanguage("FrançaisRandomat", "possess_press_r", "Appuyez sur R (Recharger) pour posséder {ply}!")
    LANG.AddToLanguage("FrançaisRandomat", "possess_no_longer_possessing", "[Possession démoniaque] Vous ne possédez plus {ply}.")
    LANG.AddToLanguage("FrançaisRandomat", "possess_start_observing", "Commencez à observer un joueur pour en prendre le contrôle!")
    LANG.AddToLanguage("FrançaisRandomat", "possess_available_commands", "Commandes Disponibles")
    LANG.AddToLanguage("FrançaisRandomat", "possess_move_keys", "Déplacer les clés")
    LANG.AddToLanguage("FrançaisRandomat", "possess_camera", "Déplacez et contrôlez la caméra")
    LANG.AddToLanguage("FrançaisRandomat", "possess_click", "Click gauche")
    LANG.AddToLanguage("FrançaisRandomat", "possess_name", "Possession démoniaque")
    LANG.AddToLanguage("FrançaisRandomat", "possess_desc", "Permet un contrôle limité sur quelqu'un après sa mort. \n\nUne fois en mode spectateur, faites un clic droit pour faire défiler les joueurs vivants. \n\nAppuyez sur R pour commencer à les manipuler.")
    LANG.AddToLanguage("FrançaisRandomat", "possess_no_longer", "Vous n'êtes plus traqué possédé.")
    LANG.AddToLanguage("FrançaisRandomat", "possess_attack", "Attaque")
    LANG.AddToLanguage("FrançaisRandomat", "possess_switch_weapon", "Changer d'arme")
    LANG.AddToLanguage("FrançaisRandomat", "possess_power", "Pouvoir")
    -- Second Chance
    LANG.AddToLanguage("FrançaisRandomat", "2ndchance_desc", "Petite chance d'être ressuscité à la mort. \n\nAprès avoir tué quelqu'un, les chances augmentent.")
    LANG.AddToLanguage("FrançaisRandomat", "2ndchance_desc_nerf", "Respawn sur votre corps après un délai. \n\nAprès l'avoir acheté, tout le monde est averti.")
    LANG.AddToLanguage("FrançaisRandomat", "2nd_chance_name", "Une seconde chance")
    LANG.AddToLanguage("FrançaisRandomat", "2nd_chance_alert", "Quelqu'un a acheté une seconde chance!")
    LANG.AddToLanguage("FrançaisRandomat", "2nd_chance_time_left", "Temps restant: ")
    LANG.AddToLanguage("FrançaisRandomat", "2nd_chance_r_respawn", "Appuyez sur R pour réapparaître sur votre cadavre")
    LANG.AddToLanguage("FrançaisRandomat", "2nd_chance_space_respawn", "Appuyez sur Espace pour réapparaître sur la carte Spawn")
    LANG.AddToLanguage("FrançaisRandomat", "2nd_chance_revive_buy", "Vous serez réanimé avec une chance de {chancetxt}% !")
    LANG.AddToLanguage("FrançaisRandomat", "2nd_chance_revive_kill", "Vos chances de résurrection ont été changées à {chancetxt}% !")
    LANG.AddToLanguage("FrançaisRandomat", "2nd_chance_revive_chat", "Appuyez sur Recharger pour apparaître sur votre corps. Appuyez sur Espace pour apparaître au point d'apparition de la carte.")
    LANG.AddToLanguage("FrançaisRandomat", "2nd_chance_revive_chat_nerf", "Appuyez sur Recharger pour apparaître sur votre corps.")
    LANG.AddToLanguage("FrançaisRandomat", "2nd_chance_name_colon", "Deuxième chance: ")
    LANG.AddToLanguage("FrançaisRandomat", "2nd_chance_not_revived", "Vous ne serez pas réanimé.")
    LANG.AddToLanguage("FrançaisRandomat", "2nd_chance_error", "ERREUR")
    LANG.AddToLanguage("FrançaisRandomat", "2nd_chance_error_spawn", "Aucun point d'apparition valide! Frai à Map Spawn.")
    LANG.AddToLanguage("FrançaisRandomat", "2nd_chance_error_body", "Corps introuvable ou en feu, vous ne pouvez donc pas vous réanimer.")
    LANG.AddToLanguage("FrançaisRandomat", "2nd_chance_search", "Ils auront peut-être une seconde chance...")
    LANG.AddToLanguage("FrançaisRandomat", "2nd_chance_search_nerf", "Ils auront une seconde chance...")
    RunConsoleCommand("ttt_language", "FrançaisRandomat")
    -- Renaming roles
    local translatedRoles = {}
    translatedRoles["Annonceur"] = ROLE_ANNOUNCER
    translatedRoles["Mendiant"] = ROLE_BEGGAR
    translatedRoles["Voleur De Corps"] = ROLE_BODYSNATCHER
    translatedRoles["Boxeur"] = ROLE_BOXER
    translatedRoles["Pitre"] = ROLE_CLOWN
    translatedRoles["Communiste"] = ROLE_COMMUNIST
    translatedRoles["Cupidon"] = ROLE_CUPID
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
    translatedRoles["Ombre"] = ROLE_SHADOW
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
    translatedRoles["Un Annonceur"] = ROLE_ANNOUNCER
    translatedRoles["Un Mendiant"] = ROLE_BEGGAR
    translatedRoles["Un Voleur De Corps"] = ROLE_BODYSNATCHER
    translatedRoles["Un Boxeur"] = ROLE_BOXER
    translatedRoles["Un Pitre"] = ROLE_CLOWN
    translatedRoles["Un Communiste"] = ROLE_COMMUNIST
    translatedRoles["Un Cupidon"] = ROLE_CUPID
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
    translatedRoles["Un Ombre"] = ROLE_SHADOW
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
    translatedRoles["Annonceurs"] = ROLE_ANNOUNCER
    translatedRoles["Mendiants"] = ROLE_BEGGAR
    translatedRoles["Voleurs De Corps"] = ROLE_BODYSNATCHER
    translatedRoles["Boxeurs"] = ROLE_BOXER
    translatedRoles["Pitres"] = ROLE_CLOWN
    translatedRoles["Communistes"] = ROLE_COMMUNIST
    translatedRoles["Cupidons"] = ROLE_CUPID
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
    translatedRoles["Ombres"] = ROLE_SHADOW
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

    customPassiveItemsOrig = {}

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
        ttt_weapon_eagleflightgun = {
            name = "Pistolet Eagleflight",
            type = "item_weapon",
            desc = [[Tirez pour vous jeter.
            Si vous tombez sur un joueur, il mourra !
            Sinon, appuyez à nouveau sur le bouton gauche de la souris pour exploser.]]
        },
        weapon_ttt_rsb_defuser = {
            name = "Désamorceur RSB",
            type = "item_weapon",
            desc = [[Un diffuseur pour la Remote Sticky Bomb]]
        },
        weapon_ttt_powerdeagle = {
            name = "Pistolet d'or",
            type = "item_weapon",
            desc = [[Tirez sur un traître, ils meurent,
            tirer sur un innocent, tu meurs,
            tirez sur un bouffon, vous mourrez TOUS LES DEUX.]]
        },
        weapon_john_bomb = {
            name = "Jean Bombe",
            type = "item_weapon",
            desc = [[Clic gauche pour vous faire EXPLOSER. Clic droit pour narguer.]]
        },
        weapon_ttt_medkit = {
            name = "Kit médical",
            type = "item_weapon",
            desc = [[Faites un clic droit pour vous soigner

            Clic gauche pour soigner quelqu'un devant vous]]
        },
        weapon_randomlauncher = {
            name = "Lanceur aléatoire",
            type = "item_weapon",
            desc = [[Lance un objet aléatoire qui inflige beaucoup de dégâts, tuant généralement instantanément.]]
        },
        tfa_shrinkray = {
            name = "Le fabricant de bébé",
            type = "item_weapon",
            desc = [[Tire un orbe qui rétrécit tous ceux qu'il touche!
            Cela les réduit à 1 santé.
            
            Marcher dans n'importe qui alors qu'il est rétréci le tue.]]
        },
        weapon_ttt_thuge = {
            name = "É.N.O.R.M.E-9001",
            type = "item_weapon",
            desc = [[Un LMG à dégâts élevés sans recul et avec une bonne précision.]]
        },
        weapon_ttt_chickenator = {
            name = "Pistolet à poulet",
            type = "item_weapon",
            desc = [[Tire sur les poulets.
            Ils attaquent quiconque s'approche.]]
        },
        weapon_ttt_fakedeath = {
            name = "Faussaire de la mort",
            type = "item_weapon",
            desc = [[Génère un faux cadavre de vous-même à vos pieds!

            Clic gauche: créer un corps
            
            Clic droit: Modifier le rôle de votre corps
            
            R: Changez la façon dont vous êtes mort]]
        },
        weapon_ttt_dete_playercam = {
            name = "Caméra de joueur détective",
            type = "item_weapon",
            desc = [[Voyez la perspective de la personne que vous photographiez en haut à gauche de votre écran!]]
        },
        tfa_scavenger = {
            name = "Charognard",
            type = "item_weapon",
            desc = [[Un fusil de sniper qui tire un explosif retardé qui explose après quelques secondes.

            L'explosif colle aux joueurs.]]
        },
        weapon_hoff_mysterybox = {
            name = "Boite mystère",
            type = "item_weapon",
            desc = [[Vous donne une arme miracle aléatoire!

            Faites un clic gauche en regardant le sol pour faire apparaître une boîte.
            Appuyez sur 'E' pour ramasser l'arme.]]
        },
        weapon_gnome_grenade = {
            name = "Grenade gnome",
            type = "item_weapon",
            desc = [[Lancez un gnome qui explose au bout de quelques secondes.
            Le lancer est très court.]]
        },
        tfa_jetgun = {
            name = "Le pistolet à réaction",
            type = "item_weapon",
            desc = [[Aspire les gens et les tue instantanément.

            Surchauffe et explose s'il est utilisé trop longtemps sans refroidir.]]
        },
        weapon_vadim_blink = {
            name = "Clignoter",
            type = "item_weapon",
            desc = [[Téléportez-vous instantanément là où vous regardez!

            Maintenez le clic gauche pour sélectionner un emplacement, le clic droit pour annuler.]]
        },
        weapon_ttt_slam = {
            name = "Claquer M4",
            type = "item_weapon",
            desc = [[Un explosif déclenché à distance.

            Clic gauche : Lancer au sol
            Clic droit : Exploser
            
            Si vous faites un clic gauche sur un mur, il s'y collera et agira comme un piège à fil-piège. S'il est utilisé comme ça, il ne peut pas être déclenché à distance.]]
        },
        death_note_ttt = {
            name = "Menace de mort",
            type = "item_weapon",
            desc = [[Tuer quelqu'un en écrivant son nom...

            Tout en tenant ceci, tapez le nom de quelqu'un dans le chat et il mourra dans 40 secondes.
            (Tant que vous êtes encore en vie à ce moment-là!)
            
            Clic gauche: modifier la cause de leur décès.]]
        },
        tfa_thundergun = {
            name = "Pistolet Tonnerre",
            type = "item_weapon",
            desc = [[Tire un souffle d'air massif qui envoie n'importe qui dans un vol à courte portée!]]
        },
        weapon_ttt_artillery = {
            name = "Canon d'artillerie",
            type = "item_weapon",
            desc = [[Génère un canon d'artillerie très puissant qui tire une grosse bombe à longue portée.

            Pour contrôler, placez-vous juste derrière et appuyez sur "E" sur les commandes qui apparaissent.]]
        },
        rotgun = {
            name = "Pistolet rotatif",
            type = "item_weapon",
            desc = [[Tirer sur quelqu'un avec ça le retourne.]]
        },
        weapon_ttt_bonk_bat = {
            name = "Chauve-Souris Bonk",
            type = "item_weapon",
            desc = [[Envoie des gens en prison excitée!

            Une chauve-souris qui emprisonne ceux que vous frappez dans une cage pendant quelques secondes.]]
        },
        weapon_ttt_timestop = {
            name = "Arrêt Horaire",
            type = "item_weapon",
            desc = [[Fige le temps pendant quelques secondes.
            Vous pouvez en tuer d'autres pendant qu'ils sont gelés.
            
            N'affecte pas les détectives!]]
        },
        ttt_dobbyhack_weapon = {
            name = "Grenade ratière",
            type = "item_weapon",
            desc = [[Une grenade qui engendre un tas de Dobbies volants et posant en T...]]
        },
        weapon_ttt_boomerang_randomat = {
            name = "Boomerang",
            type = "item_weapon",
            desc = [[Clic droit pour lancer]]
        },
        doncmk2_swep = {
            name = "Marque de Donconnon 2",
            type = "item_weapon",
            desc = [[Tire une tête MASSIVE qui vole à travers les murs.

            Inflige 50 dégâts à tous ceux qu'il touche.]]
        },
        weapon_ttt_barnacle = {
            name = "Bernacle",
            type = "item_weapon",
            desc = [[Un piège extraterrestre mortel au plafond!

            Clic gauche pour placer le piège au plafond, toute personne qui marche en dessous sera lentement tuée.]]
        },
        ttt_slappers = {
            name = "Gifles",
            type = "item_weapon",
            desc = [[La 1ère arme farce que vous achetez une partie est gratuite!

            Vous permet de gifler quelqu'un et de secouer son écran!
            
            Clic gauche - main gauche
            Clic droit - main droite]]
        },
        weapon_ttt_death_link = {
            name = "Lien de la mort",
            type = "item_weapon",
            desc = [[Utilisez sur n'importe quel lecteur. Une fois qu'ils meurent, vous mourez et vice versa.]]
        },
        ttt_combine_sniper_summoner = {
            name = "Invocateur de tireur d'élite",
            type = "item_weapon",
            desc = [[Invoque un tireur d'élite qui tuera n'importe qui devant lui!

            Fait face à la direction dans laquelle vous regardez.
            
            Cible à l'envers d'une surface plane.]]
        },
        weapon_dubstepgun = {
            name = "Pistolet Dubstep",
            type = "item_weapon",
            desc = [[Maintenez le clic gauche enfoncé pour tirer des lasers musicaux qui infligent beaucoup de dégâts!]]
        },
        freeze_swep = {
            name = "Hurlement des hivers",
            type = "item_weapon",
            desc = [[Tire un court souffle d'air froid qui fige les gens sur place pendant quelques secondes.

            NE TUE PAS TOUT SEUL! TIREZ SUR LES PERSONNES QUE VOUS GELEZ!]]
        },
        weapon_ttt_peacekeeper = {
            name = "Casque bleu",
            type = "item_weapon",
            desc = [[Tirez pour rester immobile et verrouillez toute personne que vous voyez.

            Une fois que vous voyez un symbole de crâne sur quelqu'un, vous pouvez tirer pour le tuer instantanément.
            
            Tue tous ceux que vous avez verrouillés une fois que vous l'avez tiré.]]
        },
        ttt_m9k_harpoon = {
            name = "Hwapoun",
            type = "item_weapon",
            desc = [[Harpon jetable]]
        },
        weapon_ttt_hwapoon = {
            name = "Hwapoun",
            type = "item_weapon",
            desc = [[Lancez un harpon mortel ou "Hwapoon!"
            Fait du bruit au lancer.]]
        },
        ttt_nisovin_wand = {
            name = "Baguette des probabilités limitées",
            type = "item_weapon",
            desc = [[Effectue des attaques/effets aléatoires lorsque vous faites un clic gauche.

            Spam clic gauche pour un chaos absolu.]]
        },
        weapon_ttt_handcuffs = {
            name = "Menottes",
            type = "item_weapon",
            desc = [[Clic gauche: laisse tomber toutes les armes de quelqu'un et l'empêche d'en utiliser.

            Clic droit : leur permettant d'utiliser à nouveau des armes.
            
            Vous ne pouvez pas menotter plus d'une personne à la fois.]]
        },
        weapon_ttt_impostor_knife_randomat = {
            name = "Couteau de tueur de traître"
        },
        posswitch = {
            name = "Échangeur de position",
            type = "item_weapon",
            desc = [[Échangez de place avec quelqu'un.

            Clic droit: Marquer quelqu'un
            
            Clic gauche: Échanger les places avec le joueur marqué
            
            R: Décocher le joueur]]
        },
        weapon_controllable_manhack = {
            name = "Manhack contrôlable",
            type = "item_weapon",
            desc = [[Un drone caméra télécommandé !

            Clic gauche: Déployer
            Clic droit: Contrôler/Arrêter le contrôle]]
        },
        wt_writingpad = {
            name = "Bloc-notes",
            type = "item_weapon",
            desc = [[La 1ère arme farce que vous achetez une partie est gratuite!

            Créez un message sur une pancarte que vous tenez, pour que tout le monde puisse le lire.
             
            Quelle meilleure utilisation de votre crédit ?]]
        },
        weapon_ttt_headlauncher = {
            name = "Lanceur de crabe",
            type = "item_weapon",
            desc = [[Envoie un missile du ciel vers l'endroit où vous avez tiré.

            Les extraterrestres " Headcrab " sortent du missile et commencent à attaquer quiconque se trouve à proximité.]]
        },
        weapons_ttt_time_manipulator = {
            name = "Manipulateur de temps",
            type = "item_weapon",
            desc = [[Clic gauche : Ralentir le temps.

            Clic droit : Accélérer le temps.
            
            R : Réinitialisez à la vitesse normale.]]
        },
        weapon_spraymhs = {
            name = "Aérosol",
            type = "item_weapon",
            desc = [[Aérosol
            La 1ère arme farce que vous achetez une partie est gratuite!
            
            Faites un clic droit pour changer de couleur.]]
        },
        weapon_ttt_zombievault = {
            name = "Coffre de PNJ",
            type = "item_weapon",
            desc = [[Sélectionnez un type de PNJ et jetez-le au sol. Serrures
            en place lorsqu'il est allumé. Plusieurs types de PNJ disponibles.
            Le suivi peut être inégal, mais dépend du PNJ
            et environnement.
            Grande pièce = errer, petite pièce = tortue.]]
        },
        weapon_ttt_detective_lightsaber = {
            name = "Sabre laser Jedi",
            type = "item_weapon",
            desc = [[Un sabre laser vert, vert puisque vous êtes détective.
            Clic gauche : Swing
            R: Modifier l'action de votre clic droit
            Clic droit: Tout ce que vous avez défini avec 'R']]
        },
        weapon_discordgift = {
            name = "Table d'harmonie Discord",
            type = "item_weapon",
            desc = [[La 1ère arme farce que vous achetez une partie est gratuite!

            Est-ce que quelqu'un vient de rejoindre? Non! Juste votre propre table d'harmonie discord personnelle!
             
            Clic gauche - Rejoindre le son
            Clic droit - Quitter le son
            R - Son ping]]
        },
        weapon_ttt_confetti = {
            name = "Canon à confettis",
            type = "item_weapon",
            desc = [[La 1ère arme farce que vous achetez une partie est gratuite!

            Vaporise des confettis et fait un bruit de yay!]]
        },
        weapon_unoreverse = {
            name = "ONU inverse",
            type = "item_weapon",
            desc = [[Renvoie TOUS LES DOMMAGES à l'attaquant tant qu'il est retenu!

            Utilisable pendant 3 secondes.]]
        },
        crimson_new = {
            name = "Roi Cramoisi",
            type = "item_weapon",
            desc = [[Des poings qui tuent en un coup de poing !

            Vous devez attendre une seconde avant de pouvoir commencer à frapper.]]
        },
        weapon_ttt_freezegun = {
            name = "Congeler le pistolet",
            type = "item_weapon",
            desc = [[Gèle la cible pendant 5 secondes.
            La cible ne peut pas bouger, regarde autour,
            tirer ou faire autre chose.
            
            4 coups]]
        },
        weapon_ttt_detectiveball = {
            name = "Balle de détective",
            type = "item_weapon",
            desc = [[Lancez-vous sur un proche pour le transformer en d��tective !
            Révèle plutôt son rôle s'il est un traître.
            
            Rien ne se passe s'il s'agit d'un innocent spécial ou d'un traître, comme un pépin ou un hypnotiseur.]]
        },
        weapon_hellsredeemer = {
            name = "Rédempteur de l'enfer",
            type = "item_weapon",
            desc = [[Un tomahawk de retour !

            Réduit de moitié la santé si elle est lancée dès que vous la tenez dans votre main,
            Tue instantan����ment si vous le tenez un peu en premier.]]
        },
        ttt_cmdpmpt = {
            name = "Invite de commandes",
            type = "item_weapon",
            desc = [[Clic gauche: accorde une puissante capacité aléatoire!

            Une description de la capacité apparaît dans le chat]]
        },
        pusher_swep = {
            name = "Pousseur",
            type = "item_weapon",
            desc = [[Faites un clic gauche pour pousser quelqu'un avec vos poings.

            Ils sont impuissants lorsqu'ils sont étourdis au sol et peuvent être endommagés par une autre arme.
            
            Faites un clic droit pour écouter un mec britannique bourré.]]
        },
        weapon_ttt_prop_disguiser = {
            name = "Déguisement d'accessoires",
            type = "item_weapon",
            desc = [[Déguisez-vous en objet !

            R: Sélectionnez un objet que vous regardez
            
            Clic gauche: Activer le déguisement]]
        },
        weapon_randomat_boxgloves = {
            name = "Des gants",
            type = "item_weapon",
            desc = [[Clic gauche pour attaquer]]
        },
        equip_airboat = {
            name = "Générateur d'hydroglisseur",
            type = "item_weapon",
            desc = [[La 1ère arme farce que vous achetez une partie est gratuite!

            Faites un clic gauche pour faire apparaître un hydroglisseur pilotable!
            N'endommage pas les joueurs.]]
        },
        weapon_ttt_hotpotato = {
            name = "Patate chaude",
            type = "item_weapon",
            desc = [[Pour vos proches !

            Cuit à la perfection en 12 secondes. Ne le laissez pas tomber !]]
        },
        weapon_med_defib = {
            name = "Défibrillateur",
            type = "item_weapon",
            desc = [[Ranime un joueur mort.]]
        },
        weapon_ttt_rmgrenade = {
            name = "Bombe de matière rouge",
            type = "item_weapon",
            desc = [[Une grenade en forme de cube qui génère un trou noir!

            Quiconque est trop proche se fait aspirer!
            
            Sonne une alarme avant que le trou noir n'apparaisse.]]
        },
        weapon_ttt_dragon_elites = {
            name = "Dragons d'élite",
            type = "item_weapon",
            desc = [[Pistolets à double arme avec une recharge cool.]]
        },
        weapon_ttt_whoa_randomat = {
            name = "Attaque Tournante",
            type = "item_weapon",
            desc = [[Cliquez pour tourner l'attaque.]]
        },
        tfa_raygun_mark2 = {
            name = "Pistolet à Rayons Marque 2",
            type = "item_weapon",
            desc = [[Tire une rafale de lasers à dégâts élevés]]
        },
        weapon_detective_defib = {
            name = "Défibrillateur",
            type = "item_weapon",
            desc = [[Ranime un joueur mort, sans changer son rôle.]]
        },
        tfa_staff_wind = {
            name = "Bâton du vent",
            type = "item_weapon",
            desc = [[Tire des jets d'air à courte portée et à dégâts élevés!]]
        },
        maclunkey = {
            name = "Maclunkey",
            type = "item_weapon",
            desc = [[N'inflige aucun dégât avec d'autres armes tant que tu l'as sur toi.

            A un coup qui tue instantanément mais prend un certain temps à tirer.
            
            Peut être largué pour infliger à nouveau des d��gâts avec d'autres armes à feu.]]
        },
        weapon_ttt_cloak = {
            name = "Dispositif de camouflage 2.0",
            type = "item_weapon",
            desc = [[Tenir pour devenir presque invisible

            Ne cache pas les taches de sang ou votre popup nom/santé
            
            Certaines cartes peuvent avoir un mauvais éclairage et vous laisser un peu trop visible.]]
        },
        thw_swep = {
            name = "Thwomp",
            type = "item_weapon",
            desc = [[Tirez sur le sol près de quelqu'un pour l'écraser avec un "thwomp".

            Ne fonctionne pas s'il y a un plafond bas.]]
        },
        weapon_ttt_boomerang = {
            name = "Boomerang",
            type = "item_weapon",
            desc = [[Un boomerang jetable mortel,

            Clic gauche : Tue en 1 coup et se déplace plus vite, mais ne revient pas.
            
            Clic droit : tue en 2 coups et se déplace plus lentement, mais revient.]]
        },
        tfa_blundergat = {
            name = "Blundergat",
            type = "item_weapon",
            desc = [[Un fusil de chasse incroyablement puissant !]]
        },
        corpselauncher = {
            name = "Lanceur de cadavres",
            type = "item_weapon",
            desc = [[Tire sur un cadavre en créant une explosion à l'impact. Nécessite un cadavre pour tirer.
 
            A assez de munitions pour être tiré deux fois.
             
            Faites un clic droit pour charger un cadavre.
            Clic gauche pour lancer le cadavre.]]
        },
        weapon_mad_zombificator = {
            name = "Dispositif de zombification",
            type = "item_weapon",
            desc = [[Transforme les joueurs morts en zombies.]]
        },
        weapon_ttt_jetpackspawner = {
            name = "Déployeur Jetpack",
            type = "item_weapon",
            desc = [[Clic gauche pour déposer un jetpack, appuyez sur 'E' pour l'équiper.]]
        },
        weapon_slazer_new = {
            name = "Laser spartiate",
            type = "item_weapon",
            desc = [[Maintenez le clic gauche pour tirer avec ce canon laser MASSIF!

            Provoque une explosion si puissante qu'elle gèlera le jeu pendant quelques secondes...]]
        },
        weapon_ttt_shocktrap = {
            name = "Piège à choc",
            type = "item_weapon",
            desc = [[Posé au sol.

            Toute personne autre que vous qui marche dessus est ravagée pendant quelques secondes.]]
        },
        alex_matrix_stopbullets = {
            name = "Bloc matriciel",
            type = "item_weapon",
            desc = [[Maintenez le clic gauche pour bloquer les balles devant vous.]]
        },
        weapon_ttt_knife_randomat = {
            name = "Couteau de lancer",
            type = "item_weapon",
            desc = [[knife_desc]]
        },
        weapon_ttt_popupgun = {
            name = "Pistolet contextuel",
            type = "item_weapon",
            desc = [[SMG à tir rapide. Frapper quelqu'un ouvrira une fenêtre contextuelle sur son écran]]
        },
        the_xmas_gun = {
            name = "Le pistolet de Noël",
            type = "item_weapon",
            desc = [[Tirez sur des cadeaux qui tuent en un seul coup]]
        },
        weapon_ttt_beenade = {
            name = "Bénade",
            type = "item_weapon",
            desc = [[Grenade Abeille.
            Libère une ruche remplie d'abeilles hostiles.]]
        },
        weapon_ttt_beenade2 = {
            name = "Bénade",
            type = "item_weapon",
            desc = [[Grenade Abeille.
            Libère une ruche remplie d'abeilles hostiles.]]
        },
        weapon_ttt_minifier = {
            name = "Minificateur",
            type = "item_weapon",
            desc = [[Faites un clic gauche pour réduire votre taille et votre santé!]]
        },
        minecraft_swep = {
            name = "Bloc Minecraft",
            type = "item_weapon",
            desc = [[Placez des blocs Minecraft!
            Appuyez sur 'R' pour changer de bloc]]
        },
        weapon_ttt_traitor_case = {
            name = "La valise en T",
            type = "item_weapon",
            desc = [[Recevez un objet de traître au hasard!]]
        },
        weapon_throw_crowbar = {
            name = "Pied de biche jetable",
            type = "item_weapon",
            desc = [[Faites un clic droit pour lancer, ce qui tue instantanément!]]
        },
        weapon_undertale_sans = {
            name = "Mauvais mode de temps",
            type = "item_weapon",
            desc = [[Clic gauche: tirez un laser mortel par-dessus votre épaule

            Clic droit: tirer sur des os à dégâts modérés]]
        },
        weapon_hellsretriever = {
            name = "Retriever de l'enfer",
            type = "item_weapon",
            desc = [[Un tomahawk de retour !

            Réduit de moitié la santé si elle est lancée dès que vous la tenez dans votre main,
            Tue instantanément si vous le tenez un peu en premier.]]
        },
        weapon_ttt_fortnite_building = {
            name = "Bâtiment fortifié",
            type = "item_weapon",
            desc = [[Construisez des murs, des sols et des escaliers!

            Frappez des objets avec un pied de biche pour obtenir des matériaux avec lesquels construire
            
            F: Changez la structure que vous construisez]]
        },
        one_punch_skin = {
            name = "Un coup de poing !!!",
            type = "item_weapon",
            desc = [[Poings tueurs à un coup.

            Joue de la musique et change de modèle de lecteur dès que vous le tenez!]]
        },
        weapon_ttt_gimnade = {
            name = "Grenade à gravité",
            type = "item_weapon",
            desc = [[Une grenade qui fait flotter impuissant dans les airs toute personne prise dans l'explosion.]]
        },
        destiny_one_thousand_voices = {
            name = "1000 voix",
            type = "item_weapon",
            desc = [[Maintenez le clic gauche pour un faisceau d'explosion retardé!]]
        },
        weapon_ttt_skeleton_pumpkin = {
            name = "Citrouille Squelette",
            type = "item_weapon",
            desc = [[Une grenade citrouille !

            Lorsqu'il est lancé, génère des squelettes hostiles.]]
        },
        weapon_ttt_detective_supersheep = {
            name = "Mouton observateur",
            type = "item_weapon",
            desc = [[Libérez un mouton volant !

            Votre appareil photo le suit pendant que vous restez immobile.
            
            Dirigez-le avec votre souris et faites un clic gauche sur quelqu'un pour le marquer et le voir à travers les murs.]]
        },
        weapon_ttt_rape = {
            name = "Lutte câline",
            type = "item_weapon",
            desc = [[Faites un clic gauche pour se blottir avec quelqu'un à portée de mêlée, ce qui finit par le tuer.

            Peut être réutilisé à l'infini.
            
            Peut tuer le bouffon sans qu'il gagne!]]
        },
        weapon_ttt_homingpigeon = {
            name = "Pigeon voyageur",
            type = "item_weapon",
            desc = [[Un pigeon volant qui cherche une cible.]]
        },
        weapon_ttt_lightningar1 = {
            name = "Foudre AR1",
            type = "item_weapon",
            desc = [[Une guitare-pistolet!

            Un fusil musical à dégâts élevés avec des animations et des sons très sympas.]]
        },
        weapon_doncombinesummoner = {
            name = "DoncomInvocateur",
            type = "item_weapon",
            desc = [[Invoque une monstruosité absolue...

            Le "Doncombine" poursuivra et tirera sur tout le monde sauf vous.]]
        },
        weapon_prop_blaster = {
            name = "Soutenir Blaster",
            type = "item_weapon",
            desc = [[Fait exploser des accessoires aléatoires dans des directions aléatoires]]
        },
        custom_pewgun = {
            name = "Banc Pistolet",
            type = "item_weapon",
            desc = [[The PEW GUN
            Shoots flaming blue lasers
            Makes a cool PEW sound]]
        },
        weapon_portalgun = {
            name = "Pistolet de portail",
            type = "item_weapon",
            desc = [[Clic gauche pour tirer un trou bleu dans un mur/sol, clic droit pour en tirer un orange.

            Tout ce qui passe par un trou ressort par l'autre.]]
        },
        weapon_ttt_traitor_lightsaber = {
            name = "Lightsaber",
            type = "item_weapon",
            desc = [[Un sabre laser rouge, rouge puisque tu es un traître.
            Clic gauche : Swing
            R: Modifier l'action de votre clic droit
            Clic droit: Tout ce que vous avez défini avec 'R']]
        },
        weapon_shark_trap = {
            name = "Piège à requin",
            type = "item_weapon",
            desc = [[Un piège à poser au sol.
            Peut être ramassé avec un bâton de magnéto...]]
        },
        weapon_ttt_moonball = {
            name = "Boule de lune",
            type = "item_weapon",
            desc = [[La 1ère arme farce que vous achetez une partie est gratuite!

            Lancer à la tête de quelqu'un pour le renverser.
            
            Faites un clic droit pour changer les couleurs.
            
            Donne 10 boules de lune.]]
        },
        tfa_wavegun = {
            name = "Pistolets Zap",
            type = "item_weapon",
            desc = [[Pistolets laser à double arme.
            Appuyez sur le clic gauche ou droit pour tirer!]]
        },
        weapon_ttt_homebat = {
            name = "Batte de coup de circuit",
            type = "item_weapon",
            desc = [[Frappez les gens très loin avec une batte.

            A 3 coups.]]
        },
        weapon_ttt_obc = {
            name = "Canon basse orbital",
            type = "item_weapon",
            desc = [[Tirez sur le sol pour invoquer un laser ABSOLUMENT MASSIF après quelques secondes.]]
        },
        stungun = {
            name = "Pistolet paralysant",
            type = "item_weapon",
            desc = [[Stungun utilisé pour paralyser les ennemis en les faisant
            incapable de parler et de bouger pendant quelques secondes.
            Il a 3 charges.
            
            Créé par : Donkie]]
        },
        weapon_ttt_supersheep = {
            name = "Supermouton",
            type = "item_weapon",
            desc = [[Faites voler un mouton volant explosif !

            Votre appareil photo le suit pendant que vous restez immobile.
            
            Dirigez-le avec votre souris, entrez en collision avec quelque chose pour exploser et appuyez sur 'R' pour augmenter la vitesse.]]
        },
        weapon_ttt_dancedead = {
            name = "Pistolet de danse",
            type = "item_weapon",
            desc = [[Tirez sur quelqu'un pour le faire danser sur une chanson au hasard, puis mourez.]]
        },
        weapon_ttt_comrade_bomb = {
            name = "Camarade Bombe",
            type = "item_weapon",
            desc = [[Une bombe suicide qui transforme n'importe qui dans l'explosion en traître!]]
        },
        manipulator = {
            name = "Changeur de gravité",
            type = "item_weapon",
            desc = [[Clic gauche : réduire la gravité.

            Clic droit : Augmenter la gravité.
            
            Recharger: Gravité normale.]]
        },
        weapon_smoke_knife = {
            name = "Couteau",
            type = "item_weapon",
            desc = [[Clic gauche: poignarder
            Clic droit: Lancer une grenade fumigène
            
            Les joueurs endommagés sont instantanément tués,
            sinon inflige 50 dégâts.]]
        },
        laserpointer = {
            name = "Pointeur laser",
            type = "item_weapon",
            desc = [[La 1ère arme farce que vous achetez une partie est gratuite!

            Aveugler temporairement quelqu'un en pointant ceci dans son visage.]]
        },
        ttt_deal_with_the_devil = {
            name = "Traiter avec le diable",
            type = "item_weapon",
            desc = [[Révélez que vous êtes un traître à tout le monde, mais recevez un puissant avantage en retour!]]
        },
        ttt_kamehameha_swep = {
            name = "Kamehameha",
            type = "item_weapon",
            desc = [[Chargez un faisceau d'énergie dans vos mains et faites exploser tout le monde!]]
        },
        tfa_staff_lightning = {
            name = "Bâton de foudre",
            type = "item_weapon",
            desc = [[Tire rapidement des boules de plasma!

            Les projectiles ne sont pas un hitscan et mettent du temps à voyager dans les airs.]]
        },
        ttt_detective_tracker = {
            name = "Détective Traqueur",
            type = "item_weapon",
            desc = [[Marquez quelqu'un de suspect!

            Met un contour sur un joueur que vous tirez pour le reste du tour.
            
            Chacun peut voir sa silhouette à travers les murs.]]
        },
        weapon_ttt_dead_ringer = {
            name = "Sosie",
            type = "item_weapon",
            desc = [[Devenez invisible pendant un certain temps et laissez un corps la prochaine fois que vous subissez des dégâts!

            Clic gauche pour activer.
            N'a pas besoin d'être tenu une fois allumé.
            
            Vous ne pouvez pas tirer en étant invisible.]]
        },
        weapon_ttt_rsb = {
            name = "Bombe collante à distance",
            type = "item_weapon",
            desc = [[Faites un clic droit pour poser une bombe sur quelqu'un devant vous.

            Cliquez à nouveau avec le bouton droit pour le recharger et voir le point de vue de votre victime.
            
            Clic gauche pour le faire exploser.]]
        },
        weapon_ttt_printer = {
            name = "Imprimante de crédit",
            type = "item_weapon",
            desc = [[Dépensez un crédit pour gagner plus de crédits!

            Faites un clic gauche pour placer l'imprimante de crédits au sol et, une fois que c'est fait, appuyez sur 'E' pour obtenir vos crédits !
            
            Fait du bruit une fois posé...]]
        },
        ttt_amaterasu = {
            name = "Amaterasu",
            type = "item_weapon",
            desc = "Mettez le feu à la personne que vous regardez.\n\nVous n'avez pas besoin de l'équiper pour l'utiliser, il suffit de regarder quelqu'un."
        },
        ttt_player_pinger = {
            name = "Joueur Pinger",
            type = "item_weapon",
            desc = "Vous permet de voir tout le monde à travers les murs pendant un temps limité!"
        },
        weapon_ttt_randomat = {
            name = "Machine Aléatoire",
            type = "item_weapon",
            desc = "La machine aléatoire fera quelque chose d'aléatoire!\nQui a deviné ça!"
        },
        weapon_catgun = {
            name = "Chat Pistolet"
        },
        weapon_ttt_flashbang = {
            name = "Coup de flash"
        },
        tfa_doom_ssg = {
            name = "Super fusil de chasse"
        },
        weapon_ttt_titanfall_autopistol = {
            name = "Pistolet automatique RE-45"
        },
        weapon_ttt_titanfall_wingman = {
            name = "Ailier B3"
        },
        doom_weapon_pistol = {
            name = "Pistolet DOOM"
        },
        weapon_752_dl44 = {
            name = "Guerres des étoiles"
        },
        fingergun = {
            name = "Doigt Pistolet"
        },
        mc_sword_diamond = {
            name = "Pée de diamant"
        },
        weapon_ttt_axe = {
            name = "Hache"
        },
        weapon_ttt_fryingpan = {
            name = "Poêle à frire"
        },
        tfa_bo3_boxing = {
            name = "Gants de boxe"
        },
        ttt_backwards_shotgun = {
            name = "Fusil de chasse à l'envers"
        },
        st_bananapistol = {
            name = "Banane Pistolet"
        },
        ttt_sahmin_gun = {
            name = "Simon Pistolet"
        },
        weapon_long_revolver = {
            name = "Revolver Longue"
        },
        weapon_paintgun = {
            name = "Pistolet à peinture"
        },
        tfa_dax_big_glock = {
            name = "Grosse arme"
        },
        tfa_tracer_nope = {
            name = "Pistolets à impulsion"
        },
        tfa_mercy_nope = {
            name = "Caducée Blaster"
        },
        c_sombra_gun_n = {
            name = "Pistolet-mitrailleur"
        },
        c_reaper_nope = {
            name = "Fusils doubles"
        },
        c_dvaredux_nope = {
            name = "Pistolet léger"
        },
        weapon_sp_striker = {
            name = "Attaquant 12"
        },
        weapon_sp_dbarrel = {
            name = "Double baril"
        },
        weapon_rp_railgun = {
            name = "Fusil à rail"
        },
        weapon_rp_pocket = {
            name = "Fusil de poche"
        },
        weapon_pp_rbull = {
            name = "Taureau furieux"
        },
        weapon_hp_glauncher = {
            name = "Lance-grenades",
            type = "item_weapon",
            desc = "Lanceur automatique de grenades explosives. \n\nLivré avec 12 cartouches."
        },
        weapon_hp_ares_shrike = {
            name = "Arès Pie-grièche"
        },
        weapon_ap_vector = {
            name = "Vecteur"
        },
        weapon_ttt_honeybadger = {
            name = "Blaireau de miel"
        },
        weapon_ap_hbadger = {
            name = "Blaireau de miel"
        },
        weapon_ap_golddragon = {
            name = "Dragon d'or",
            type = "item_weapon",
            desc = "Fusil d'assaut précis et à \nfaibles dégâts qui met le feu aux ennemis. \n\nUtilise des munitions SMG standard."
        },
        weapon_ttt_tmp_s = {
            name = "Renard silencieux",
            type = "item_weapon",
            desc = "SMG à faible bruit qui utilise des munitions normales de 9 mm. \n\nLes victimes ne crieront pas lorsqu'elles seront tuées."
        },
        weapon_ttt_suicide = {
            name = "Bombe suicide",
            type = "item_weapon",
            desc = "Sortez dans une frénésie hurlante! \n\nTue l'utilisateur et les terroristes environnants."
        },
        weapon_ttt_pump = {
            name = "Fusil à pompe"
        },
        weapon_ttt_mp5 = {
            name = "MP5 Marine"
        },
        weapon_ttt_ak47 = {
            name = "AK47",
            type = "item_weapon",
            desc = [[Fusil d'assaut avec des dégâts très élevés.

            A un recul très élevé.]]
        },
        weapon_ttt_m4a1_s = {
            name = "M4A1 silencieux",
            type = "item_weapon",
            desc = "Un fusil automatique silencieux. Les victimes meurent en silence."
        },
        weapon_ttt_frag = {
            name = "Grenade à fragmentation",
            type = "item_weapon",
            desc = "Une grenade hautement explosive."
        },
        weapon_ttt_awp = {
            name = "AWP silencieux",
            type = "item_weapon",
            desc = "Fusil de précision AWP silencieux. \n\nUn seul coup. \n\nLes victimes ne crieront pas lorsqu'elles seront tuées."
        },
        weapon_m3 = {
            name = "Pistolet à graisse M3"
        },
        weapon_zm_sledge = {
            name = "É.N.O.R.M.E-249"
        },
        weapon_zm_revolver = {
            name = "Aigle du désert"
        },
        weapon_ttt_m16 = {
            name = "M-Seize"
        },
        weapon_ttt_glock = {
            name = "Pistolet-Mitrailleur"
        },
        weapon_hyp_brainwash = {
            name = "Appareil de lavage de cerveau",
            type = "item_weapon",
            desc = "Ranime un innocent comme un tra��tre."
        },
        weapon_com_manifesto = {
            name = "Manifeste communiste",
            type = "item_weapon",
            desc = "Clic gauche pour convertir un autre joueur"
        },
        weapon_par_cure = {
            name = "Parasite Cure"
        },
        weapon_box_gloves = {
            name = "Des gants",
            type = "item_weapon",
            desc = "Clic gauche pour attaquer"
        },
        weapon_zom_claws = {
            name = "Les griffes",
            type = "item_weapon",
            desc = "Clic gauche pour attaquer. Clic droit pour sauter. Appuyez sur recharger pour cracher."
        },
        weapon_vam_fangs = {
            name = "Crocs",
            type = "item_weapon",
            desc = "Clic gauche pour aspirer le sang. Faites un clic droit pour faire un fondu."
        },
        weapon_bod_bodysnatch = {
            name = "Dispositif d'arrachage de corps",
            type = "item_weapon",
            desc = "Change votre rôle en celui d'un cadavre."
        },
        weapon_qua_fake_cure = {
            name = "Guérir les parasites"
        },
        weapon_cup_bow = {
            name = "L'arc de Cupidon"
        },
        weapon_mhl_badge = {
            name = "Insigne d'adjoint"
        },
        weapon_old_dbshotgun = {
            name = "Double baril"
        },
        weapon_pha_exorcism = {
            name = "Dispositif d'exorcisme"
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
                SWEP.EquipMenuData.type = translatedWeapons[classname].type
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

    -- Remove the French flag overlay,
    -- if music is playing, in time with the music ending
    timer.Simple(endingTimer, function()
        if flagPanelFrame ~= nil then
            flagPanelFrame:Close()
            flagPanelFrame = nil
        end
    end)
end)