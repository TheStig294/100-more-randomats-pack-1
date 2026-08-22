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
    if roleStringsOrig then
        ROLE_STRINGS = table.Copy(roleStringsOrig)
    end

    if roleStringsExtOrig then
        ROLE_STRINGS_EXT = table.Copy(roleStringsExtOrig)
    end

    if roleStringsPluralOrig then
        ROLE_STRINGS_PLURAL = table.Copy(roleStringsPluralOrig)
    end

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
    for _, ent in ents.Iterator() do
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

    -- Remove the hooks trying to end this event because if we made it this far we're done
    hook.Remove("PlayerButtonDown", "FrenchMuteMusicButton")
    hook.Remove("TTTEndRound", "FrenchRandomatClientEnd")
    hook.Remove("TTTPrepareRound", "FrenchRandomatClientEnd")
    hook.Remove("TTTBeginRound", "FrenchRandomatClientEnd")
    hook.Remove("ShutDown", "FrenchRandomatShutDown")
end

net.Receive("FrenchRandomatBegin", function()
    music = net.ReadBool()
    local debugPrint = net.ReadBool()
    local client = LocalPlayer()
    -- Do not conflict with the Frenchman role: https://steamcommunity.com/sharedfiles/filedetails/?id=2876412670
    if IsValid(client) and client.IsFrenchman and client:IsFrenchman() and client:IsRoleActive() then return end
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
    local roleIdToGlobalName = {}

    -- The "^ROLE_%u+$" search isn't perfect and picks up some non-role globals to translate
    local ignoredGlobals = {
        -- Role global value marker for looping purposes
        ROLE_MAX = true,
        -- A genuine role global, but a super old depreciated one that's just coming from the randomat...
        ROLE_DETRAITOR = true,
    }

    if debugPrint then
        print("=====Role Globals=====")
    end

    for name, value in SortedPairs(_G) do
        -- No role global name has more than one "_" underscore in its name, which is what the "^ROLE_%u+$" pattern is searching for...
        if not isstring(name) or not isnumber(value) or ignoredGlobals[name] or not string.find(name, "^ROLE_%u+$") then continue end

        if debugPrint then
            print(name)
        end

        roleIdToGlobalName[value] = name
    end

    local translatedRoles = {}

    local function AddTranslation(translation, id)
        -- For all roles not installed, skip them!
        if not id then return end

        table.insert(translatedRoles, {
            translation = translation,
            id = id,
            globalName = roleIdToGlobalName[id],
        })
    end

    local function ApplyTranslations(stringTable, tableName)
        if istable(stringTable) then
            if not roleStringsOrig then
                roleStringsOrig = table.Copy(stringTable)
            end

            local translatedRoleIDs = {}

            if debugPrint then
                print("=====" .. tableName .. "=====")
            end

            for _, entry in ipairs(translatedRoles) do
                stringTable[entry.id] = entry.translation

                if debugPrint then
                    translatedRoleIDs[entry.id] = true
                end
            end

            if debugPrint then
                for roleID, roleString in ipairs(stringTable) do
                    if not translatedRoleIDs[roleID] then
                        print(roleString, ROLE_STRINGS_RAW[roleID])
                    end
                end

                local orderedString = ""

                for _, entry in SortedPairsByMemberValue(translatedRoles, "globalName") do
                    orderedString = orderedString .. "AddTranslation(\"" .. entry.translation .. "\", " .. entry.globalName .. ")\n"
                end

                file.Write("randomat/french_sorted_" .. tableName:lower():gsub(" ", "_") .. ".txt", orderedString)
            end
        end
    end

    -- Role Strings --
    AddTranslation("Administrateur", ROLE_ADMIN)
    AddTranslation("Annonceur", ROLE_ANNOUNCER)
    AddTranslation("Marchand d'Armes", ROLE_ARMSDEALER)
    AddTranslation("Incendiaire", ROLE_ARSONIST)
    AddTranslation("Assassin", ROLE_ASSASSIN)
    AddTranslation("Imitateur de Baril", ROLE_BARRELMIMIC)
    AddTranslation("Abeille", ROLE_BEE)
    AddTranslation("Mendiant", ROLE_BEGGAR)
    AddTranslation("Homme BLEU", ROLE_BLUMANN)
    AddTranslation("Voleur de Corps", ROLE_BODYSNATCHER)
    AddTranslation("Chasseur de Primes", ROLE_BOUNTYHUNTER)
    AddTranslation("Boxeur", ROLE_BOXER)
    AddTranslation("Bouton", ROLE_BUTTON)
    AddTranslation("Cannibale", ROLE_CANNIBAL)
    AddTranslation("Cuisinier", ROLE_CHEF)
    AddTranslation("Cloner", ROLE_CLONE)
    AddTranslation("Clown", ROLE_CLOWN)
    AddTranslation("Communiste", ROLE_COMMUNIST)
    AddTranslation("Cupidon", ROLE_CUPID)
    AddTranslation("Adjoint", ROLE_DEPUTY)
    AddTranslation("Détective", ROLE_DETECTIVE)
    AddTranslation("Détective Clown", ROLE_DETECTOCLOWN)
    AddTranslation("Médecin", ROLE_DOCTOR)
    AddTranslation("Serviteur de L'effroi", ROLE_DREADTHRALL)
    AddTranslation("Ivre", ROLE_DRUNK)
    AddTranslation("Élémentaliste", ROLE_ELEMENTALIST)
    AddTranslation("Elfe", ROLE_ELF)
    AddTranslation("Mauvais Jumeau", ROLE_EVILTWIN)
    AddTranslation("Plus Faux", ROLE_FAKER)
    AddTranslation("Français", ROLE_FRENCHMAN)
    AddTranslation("Joueur", ROLE_GAMER)
    AddTranslation("Chuchoteur Fantôme", ROLE_GHOSTWHISPERER)
    AddTranslation("Problème", ROLE_GLITCH)
    AddTranslation("Bon Chien", ROLE_GOODBOY)
    AddTranslation("Bon Jumeau", ROLE_GOODTWIN)
    AddTranslation("Devineur", ROLE_GUESSER)
    AddTranslation("Ermite", ROLE_HERMIT)
    AddTranslation("Esprit de la Ruche", ROLE_HIVEMIND)
    AddTranslation("Poisse", ROLE_HOODOO)
    AddTranslation("Hypnotiseur", ROLE_HYPNOTIST)
    AddTranslation("Illusionniste", ROLE_ILLUSIONIST)
    AddTranslation("Imitateur", ROLE_IMPERSONATOR)
    AddTranslation("Infecté", ROLE_INFECTED)
    AddTranslation("Informateur", ROLE_INFORMANT)
    AddTranslation("Innocente", ROLE_INNOCENT)
    AddTranslation("Bouffon", ROLE_JESTER)
    AddTranslation("Kévin", ROLE_KEVIN)
    AddTranslation("Tueur", ROLE_KILLER)
    AddTranslation("Krampus", ROLE_KRAMPUS)
    AddTranslation("Butin Gobelin", ROLE_LOOTGOBLIN)
    AddTranslation("Scientifique Fou", ROLE_MADSCIENTIST)
    AddTranslation("Maréchal", ROLE_MARSHAL)
    AddTranslation("Voyante", ROLE_MEDIUM)
    AddTranslation("Mercenaire", ROLE_MERCENARY)
    AddTranslation("Gobelin Mental", ROLE_MINDGOBLIN)
    AddTranslation("Missionnaire", ROLE_MISSIONARY)
    AddTranslation("Moine", ROLE_MONK)
    AddTranslation("Vieil Homme", ROLE_OLDMAN)
    AddTranslation("Hors-la-loi", ROLE_OUTLAW)
    AddTranslation("Paladin", ROLE_PALADIN)
    AddTranslation("Paramédical", ROLE_PARAMEDIC)
    AddTranslation("Parasite", ROLE_PARASITE)
    AddTranslation("Fantôme", ROLE_PHANTOM)
    AddTranslation("Pharaon", ROLE_PHARAOH)
    AddTranslation("Clinicien", ROLE_PHYSICIAN)
    AddTranslation("Piñata", ROLE_PINATA)
    AddTranslation("Maître de la Peste", ROLE_PLAGUEMASTER)
    AddTranslation("Empoisonneur", ROLE_POISONER)
    AddTranslation("Opossum", ROLE_POSSUM)
    AddTranslation("Marionnettiste", ROLE_PUPPETEER)
    AddTranslation("Charlatan", ROLE_QUACK)
    AddTranslation("Intendante", ROLE_QUARTERMASTER)
    AddTranslation("Reine Des Abeilles", ROLE_QUEENBEE)
    AddTranslation("Homme Aléatoire", ROLE_RANDOMAN)
    AddTranslation("Échangeur Aléatoire", ROLE_RANDOSWAPPER)
    AddTranslation("Homme ROUGE", ROLE_REDMANN)
    AddTranslation("Renégate", ROLE_RENEGADE)
    AddTranslation("Vengeur", ROLE_REVENGER)
    AddTranslation("Gardien du Coffre", ROLE_SAFEKEEPER)
    AddTranslation("Père Noël", ROLE_SANTA)
    AddTranslation("Sapeur", ROLE_SAPPER)
    AddTranslation("Éclaireur", ROLE_SCOUT)
    AddTranslation("Ombre", ROLE_SHADOW)
    AddTranslation("Shérif", ROLE_SHERIFF)
    AddTranslation("Fratrie", ROLE_SIBLING)
    AddTranslation("Lié à L'âme", ROLE_SOULBOUND)
    AddTranslation("Âme Soeur", ROLE_SOULMAGE)
    AddTranslation("Éponge", ROLE_SPONGE)
    AddTranslation("Espionner", ROLE_SPY)
    AddTranslation("Invocateur", ROLE_SUMMONER)
    AddTranslation("Échangeur", ROLE_SWAPPER)
    AddTranslation("Maître des Tâches", ROLE_TASKMASTER)
    AddTranslation("Taxidermiste", ROLE_TAXIDERMIST)
    AddTranslation("Voleur", ROLE_THIEF)
    AddTranslation("Bricoleur", ROLE_TINKERER)
    AddTranslation("Traqueur", ROLE_TRACKER)
    AddTranslation("Traitre", ROLE_TRAITOR)
    AddTranslation("Filou", ROLE_TRICKSTER)
    AddTranslation("Transfuge", ROLE_TURNCOAT)
    AddTranslation("Vampire", ROLE_VAMPIRE)
    AddTranslation("Vétéran", ROLE_VETERAN)
    AddTranslation("Justicier", ROLE_VINDICATOR)
    AddTranslation("Loup-Garou", ROLE_WEREWOLF)
    AddTranslation("Baleine", ROLE_WHALEDETECTIVE)
    AddTranslation("Baleine", ROLE_WHALEINDEPENDENT)
    AddTranslation("Baleine", ROLE_WHALEINNOCENT)
    AddTranslation("Baleine", ROLE_WHALEJESTER)
    AddTranslation("Baleine", ROLE_WHALEMONSTER)
    AddTranslation("Baleine", ROLE_WHALETRAITOR)
    AddTranslation("Garçon de la Roue", ROLE_WHEELBOY)
    AddTranslation("Yéti", ROLE_YETI)
    AddTranslation("Homme du Yorkshire", ROLE_YORKSHIREMAN)
    AddTranslation("Zélote", ROLE_ZEALOT)
    AddTranslation("Zombi", ROLE_ZOMBIE)
    ApplyTranslations(ROLE_STRINGS, "Role Strings")
    table.Empty(translatedRoles)
    -- Role Strings Extended --
    AddTranslation("Un Administrateur", ROLE_ADMIN)
    AddTranslation("Un Annonceur", ROLE_ANNOUNCER)
    AddTranslation("Un Marchand d'Armes", ROLE_ARMSDEALER)
    AddTranslation("Un Incendiaire", ROLE_ARSONIST)
    AddTranslation("Un Assassin", ROLE_ASSASSIN)
    AddTranslation("Un Imitateur de Baril", ROLE_BARRELMIMIC)
    AddTranslation("Une Abeille", ROLE_BEE)
    AddTranslation("Un Mendiant", ROLE_BEGGAR)
    AddTranslation("Un Homme BLEU", ROLE_BLUMANN)
    AddTranslation("Un Voleur de Corps", ROLE_BODYSNATCHER)
    AddTranslation("Un Chasseur de Primes", ROLE_BOUNTYHUNTER)
    AddTranslation("Un Boxeur", ROLE_BOXER)
    AddTranslation("Un Bouton", ROLE_BUTTON)
    AddTranslation("Un Cannibale", ROLE_CANNIBAL)
    AddTranslation("Un Cuisinier", ROLE_CHEF)
    AddTranslation("Un Cloner", ROLE_CLONE)
    AddTranslation("Un Clown", ROLE_CLOWN)
    AddTranslation("Un Communiste", ROLE_COMMUNIST)
    AddTranslation("Un Cupidon", ROLE_CUPID)
    AddTranslation("Un Adjoint", ROLE_DEPUTY)
    AddTranslation("Un Détective", ROLE_DETECTIVE)
    AddTranslation("Un Détective Clown", ROLE_DETECTOCLOWN)
    AddTranslation("Un Médecin", ROLE_DOCTOR)
    AddTranslation("Un Serviteur de L'effroi", ROLE_DREADTHRALL)
    AddTranslation("Un Ivre", ROLE_DRUNK)
    AddTranslation("Un Élémentaliste", ROLE_ELEMENTALIST)
    AddTranslation("Un Elfe", ROLE_ELF)
    AddTranslation("Un Mauvais Jumeau", ROLE_EVILTWIN)
    AddTranslation("Un Plus Faux", ROLE_FAKER)
    AddTranslation("Un Français", ROLE_FRENCHMAN)
    AddTranslation("Un Joueur", ROLE_GAMER)
    AddTranslation("Un Chuchoteur Fantôme", ROLE_GHOSTWHISPERER)
    AddTranslation("Un Problème", ROLE_GLITCH)
    AddTranslation("Un Bon Chien", ROLE_GOODBOY)
    AddTranslation("Un Bon Jumeau", ROLE_GOODTWIN)
    AddTranslation("Un Devineur", ROLE_GUESSER)
    AddTranslation("Un Ermite", ROLE_HERMIT)
    AddTranslation("Un Esprit de la Ruche", ROLE_HIVEMIND)
    AddTranslation("Un Hoodoo", ROLE_HOODOO)
    AddTranslation("Un Hypnotiseur", ROLE_HYPNOTIST)
    AddTranslation("Un Illusionniste", ROLE_ILLUSIONIST)
    AddTranslation("Un Imitateur", ROLE_IMPERSONATOR)
    AddTranslation("Un Infecté", ROLE_INFECTED)
    AddTranslation("Un Informateur", ROLE_INFORMANT)
    AddTranslation("Une Innocente", ROLE_INNOCENT)
    AddTranslation("Un Bouffon", ROLE_JESTER)
    AddTranslation("Un Kévin", ROLE_KEVIN)
    AddTranslation("Un Tueur", ROLE_KILLER)
    AddTranslation("Un Krampus", ROLE_KRAMPUS)
    AddTranslation("Un Butin Gobelin", ROLE_LOOTGOBLIN)
    AddTranslation("Un Scientifique Fou", ROLE_MADSCIENTIST)
    AddTranslation("Un Maréchal", ROLE_MARSHAL)
    AddTranslation("Une Voyante", ROLE_MEDIUM)
    AddTranslation("Un Mercenaire", ROLE_MERCENARY)
    AddTranslation("Un Gobelin Mental", ROLE_MINDGOBLIN)
    AddTranslation("Un Missionnaire", ROLE_MISSIONARY)
    AddTranslation("Un Moine", ROLE_MONK)
    AddTranslation("Un rôle caché", ROLE_NONE)
    AddTranslation("Un Vieil Homme", ROLE_OLDMAN)
    AddTranslation("Un Hors-la-loi", ROLE_OUTLAW)
    AddTranslation("Un Paladin", ROLE_PALADIN)
    AddTranslation("Un Paramédical", ROLE_PARAMEDIC)
    AddTranslation("Un Parasite", ROLE_PARASITE)
    AddTranslation("Un Fantôme", ROLE_PHANTOM)
    AddTranslation("Un Pharaon", ROLE_PHARAOH)
    AddTranslation("Un Clinicien", ROLE_PHYSICIAN)
    AddTranslation("Une Piñata", ROLE_PINATA)
    AddTranslation("Un Maître de la Peste", ROLE_PLAGUEMASTER)
    AddTranslation("Un Empoisonneur", ROLE_POISONER)
    AddTranslation("Un Opossum", ROLE_POSSUM)
    AddTranslation("Un Marionnettiste", ROLE_PUPPETEER)
    AddTranslation("Un Charlatan", ROLE_QUACK)
    AddTranslation("Une Intendante", ROLE_QUARTERMASTER)
    AddTranslation("Une Reine Des Abeilles", ROLE_QUEENBEE)
    AddTranslation("Un Homme Aléatoire", ROLE_RANDOMAN)
    AddTranslation("Un Échangeur Aléatoire", ROLE_RANDOSWAPPER)
    AddTranslation("Un Homme ROUGE", ROLE_REDMANN)
    AddTranslation("Une Renégate", ROLE_RENEGADE)
    AddTranslation("Un Vengeur", ROLE_REVENGER)
    AddTranslation("Un Gardien du Coffre", ROLE_SAFEKEEPER)
    AddTranslation("Un Père Noël", ROLE_SANTA)
    AddTranslation("Un Sapeur", ROLE_SAPPER)
    AddTranslation("Un Éclaireur", ROLE_SCOUT)
    AddTranslation("Une Ombre", ROLE_SHADOW)
    AddTranslation("Un Shérif", ROLE_SHERIFF)
    AddTranslation("Une Fratrie", ROLE_SIBLING)
    AddTranslation("Un Lié à L'âme", ROLE_SOULBOUND)
    AddTranslation("Une Âme Soeur", ROLE_SOULMAGE)
    AddTranslation("Une Éponge", ROLE_SPONGE)
    AddTranslation("Un Espionner", ROLE_SPY)
    AddTranslation("Un Invocateur", ROLE_SUMMONER)
    AddTranslation("Un Échangeur", ROLE_SWAPPER)
    AddTranslation("Un Maître des Tâches", ROLE_TASKMASTER)
    AddTranslation("Un Taxidermiste", ROLE_TAXIDERMIST)
    AddTranslation("Un Voleur", ROLE_THIEF)
    AddTranslation("Un Bricoleur", ROLE_TINKERER)
    AddTranslation("Un Traqueur", ROLE_TRACKER)
    AddTranslation("Un Traitre", ROLE_TRAITOR)
    AddTranslation("Un Filou", ROLE_TRICKSTER)
    AddTranslation("Un Transfuge", ROLE_TURNCOAT)
    AddTranslation("Un Vampire", ROLE_VAMPIRE)
    AddTranslation("Un Vétéran", ROLE_VETERAN)
    AddTranslation("Un Justicier", ROLE_VINDICATOR)
    AddTranslation("Un Loup-Garou", ROLE_WEREWOLF)
    AddTranslation("Une Baleine Détective", ROLE_WHALEDETECTIVE)
    AddTranslation("Une Baleine Indépendant", ROLE_WHALEINDEPENDENT)
    AddTranslation("Une Baleine Innocente", ROLE_WHALEINNOCENT)
    AddTranslation("Une Baleine Bouffon", ROLE_WHALEJESTER)
    AddTranslation("Une Baleine Monstre", ROLE_WHALEMONSTER)
    AddTranslation("Une Baleine Traitre", ROLE_WHALETRAITOR)
    AddTranslation("Un Garçon de la Roue", ROLE_WHEELBOY)
    AddTranslation("Un Yéti", ROLE_YETI)
    AddTranslation("Un Yorkshireman", ROLE_YORKSHIREMAN)
    AddTranslation("Un Zélote", ROLE_ZEALOT)
    AddTranslation("Un Zombi", ROLE_ZOMBIE)
    ApplyTranslations(ROLE_STRINGS_EXT, "Role Strings Extended")
    table.Empty(translatedRoles)
    -- Role Strings Plural --
    AddTranslation("Administrateurs", ROLE_ADMIN)
    AddTranslation("Annonceurs", ROLE_ANNOUNCER)
    AddTranslation("Marchands d'Armes", ROLE_ARMSDEALER)
    AddTranslation("Incendiaires", ROLE_ARSONIST)
    AddTranslation("Assassins", ROLE_ASSASSIN)
    AddTranslation("Imitateurs de Baril", ROLE_BARRELMIMIC)
    AddTranslation("Abeilles", ROLE_BEE)
    AddTranslation("Mendiants", ROLE_BEGGAR)
    AddTranslation("Hommes BLEUS", ROLE_BLUMANN)
    AddTranslation("Voleurs de Corps", ROLE_BODYSNATCHER)
    AddTranslation("Chasseurs de Primes", ROLE_BOUNTYHUNTER)
    AddTranslation("Boxeurs", ROLE_BOXER)
    AddTranslation("Boutons", ROLE_BUTTON)
    AddTranslation("Cannibales", ROLE_CANNIBAL)
    AddTranslation("Cuisiniers", ROLE_CHEF)
    AddTranslation("Cloners", ROLE_CLONE)
    AddTranslation("Clowns", ROLE_CLOWN)
    AddTranslation("Communistes", ROLE_COMMUNIST)
    AddTranslation("Cupidons", ROLE_CUPID)
    AddTranslation("Adjoints", ROLE_DEPUTY)
    AddTranslation("Détectives", ROLE_DETECTIVE)
    AddTranslation("Clowns Détectives", ROLE_DETECTOCLOWN)
    AddTranslation("Médecins", ROLE_DOCTOR)
    AddTranslation("Serviteurs de L'effroi", ROLE_DREADTHRALL)
    AddTranslation("Ivres", ROLE_DRUNK)
    AddTranslation("Élémentalistes", ROLE_ELEMENTALIST)
    AddTranslation("Elfes", ROLE_ELF)
    AddTranslation("Mauvais Jumeaux", ROLE_EVILTWIN)
    AddTranslation("Les Faussaires", ROLE_FAKER)
    AddTranslation("Français", ROLE_FRENCHMAN)
    AddTranslation("Les joueurs", ROLE_GAMER)
    AddTranslation("Chuchoteurs de Fantômes", ROLE_GHOSTWHISPERER)
    AddTranslation("Problèmes", ROLE_GLITCH)
    AddTranslation("Bons Chiens", ROLE_GOODBOY)
    AddTranslation("Bons Jumeaux", ROLE_GOODTWIN)
    AddTranslation("Devineurs", ROLE_GUESSER)
    AddTranslation("Ermites", ROLE_HERMIT)
    AddTranslation("Esprits de la Ruche", ROLE_HIVEMIND)
    AddTranslation("Poisses", ROLE_HOODOO)
    AddTranslation("Hypnotiseurs", ROLE_HYPNOTIST)
    AddTranslation("Illusionnistes", ROLE_ILLUSIONIST)
    AddTranslation("Imitateurs", ROLE_IMPERSONATOR)
    AddTranslation("Infectés", ROLE_INFECTED)
    AddTranslation("Informateurs", ROLE_INFORMANT)
    AddTranslation("Innocentes", ROLE_INNOCENT)
    AddTranslation("Bouffons", ROLE_JESTER)
    AddTranslation("Kévins", ROLE_KEVIN)
    AddTranslation("Tueurs", ROLE_KILLER)
    AddTranslation("Krampus", ROLE_KRAMPUS)
    AddTranslation("Pillez Les Gobelins", ROLE_LOOTGOBLIN)
    AddTranslation("Scientifiques Fous", ROLE_MADSCIENTIST)
    AddTranslation("Les Maréchaux", ROLE_MARSHAL)
    AddTranslation("Voyantes", ROLE_MEDIUM)
    AddTranslation("Mercenaires", ROLE_MERCENARY)
    AddTranslation("Gobelins Mentaux", ROLE_MINDGOBLIN)
    AddTranslation("Missionnaires", ROLE_MISSIONARY)
    AddTranslation("Moines", ROLE_MONK)
    AddTranslation("Vieux Hommes", ROLE_OLDMAN)
    AddTranslation("Hors-la-loi", ROLE_OUTLAW)
    AddTranslation("Paladins", ROLE_PALADIN)
    AddTranslation("Paramédicals", ROLE_PARAMEDIC)
    AddTranslation("Parasites", ROLE_PARASITE)
    AddTranslation("Fantômes", ROLE_PHANTOM)
    AddTranslation("Pharaons", ROLE_PHARAOH)
    AddTranslation("Cliniciens", ROLE_PHYSICIAN)
    AddTranslation("Piñatas", ROLE_PINATA)
    AddTranslation("Maîtres de la Peste", ROLE_PLAGUEMASTER)
    AddTranslation("Empoisonneurs", ROLE_POISONER)
    AddTranslation("Opossums", ROLE_POSSUM)
    AddTranslation("Marionnettistes", ROLE_PUPPETEER)
    AddTranslation("Charlatans", ROLE_QUACK)
    AddTranslation("Intendantes", ROLE_QUARTERMASTER)
    AddTranslation("Reines Des Abeilles", ROLE_QUEENBEE)
    AddTranslation("Hommes Aléatoires", ROLE_RANDOMAN)
    AddTranslation("Échangeurs Aléatoires", ROLE_RANDOSWAPPER)
    AddTranslation("Hommes ROUGES", ROLE_REDMANN)
    AddTranslation("Renégates", ROLE_RENEGADE)
    AddTranslation("Vengeurs", ROLE_REVENGER)
    AddTranslation("Gardiens du Coffre", ROLE_SAFEKEEPER)
    AddTranslation("Pères Noël", ROLE_SANTA)
    AddTranslation("Sapeurs", ROLE_SAPPER)
    AddTranslation("Éclaireurs", ROLE_SCOUT)
    AddTranslation("Ombres", ROLE_SHADOW)
    AddTranslation("Shérifs", ROLE_SHERIFF)
    AddTranslation("Fratries", ROLE_SIBLING)
    AddTranslation("Limites de L'âme", ROLE_SOULBOUND)
    AddTranslation("Mages D'âme", ROLE_SOULMAGE)
    AddTranslation("Éponges", ROLE_SPONGE)
    AddTranslation("Espionners", ROLE_SPY)
    AddTranslation("Invocateurs", ROLE_SUMMONER)
    AddTranslation("Échangeurs", ROLE_SWAPPER)
    AddTranslation("Maîtres des Tâches", ROLE_TASKMASTER)
    AddTranslation("Taxidermistes", ROLE_TAXIDERMIST)
    AddTranslation("Voleurs", ROLE_THIEF)
    AddTranslation("Bricoleurs", ROLE_TINKERER)
    AddTranslation("Traqueurs", ROLE_TRACKER)
    AddTranslation("Traitres", ROLE_TRAITOR)
    AddTranslation("Filous", ROLE_TRICKSTER)
    AddTranslation("Transfuges", ROLE_TURNCOAT)
    AddTranslation("Vampires", ROLE_VAMPIRE)
    AddTranslation("Vétérans", ROLE_VETERAN)
    AddTranslation("Les Justiciers", ROLE_VINDICATOR)
    AddTranslation("Loups-Garous", ROLE_WEREWOLF)
    AddTranslation("Baleines Détectives", ROLE_WHALEDETECTIVE)
    AddTranslation("Baleines Indépendantes", ROLE_WHALEINDEPENDENT)
    AddTranslation("Baleines Innocentes", ROLE_WHALEINNOCENT)
    AddTranslation("Baleines Bouffons", ROLE_WHALEJESTER)
    AddTranslation("Baleines Monstres", ROLE_WHALEMONSTER)
    AddTranslation("Baleines Traitres", ROLE_WHALETRAITOR)
    AddTranslation("Garçons de la Roue", ROLE_WHEELBOY)
    AddTranslation("Yétis", ROLE_YETI)
    AddTranslation("Yorkshiremen", ROLE_YORKSHIREMAN)
    AddTranslation("Zélotes", ROLE_ZEALOT)
    AddTranslation("Zombis", ROLE_ZOMBIE)
    ApplyTranslations(ROLE_STRINGS_PLURAL, "Role Strings Plural")
    table.Empty(translatedRoles)

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

    if not customPassiveItemsOrig then
        customPassiveItemsOrig = {}
    end

    -- My version of the second chance, demonic possession, and clairvoyancy perk use role strings; however, not all versions on the workshop do, so we ALSO have to define hard-coded translations here
    local translatedPassiveItems = {
        {
            id = "EQUIP_ASC",
            name = "Un Deuxième Chance",
            desc = "Petite chance d'être ressuscité à la mort. \n\nAprès avoir tué quelqu'un, les chances augmentent.",
        },
        {
            id = "EQUIP_BUNKER",
            name = "Bunker de Bruh",
            desc = "Craquement détecté! Présentez-vous au bunker bruh \nimmédiatement! \nCrée un bunker autour de vous lorsque vous subissez des dégâts.",
        },
        {
            id = "EQUIP_CLAIRVOYANT",
            name = "Voyance",
            desc = "Quand quelqu'un meurt, vous pouvez voir son corps pendant un bref instant.",
        },
        {
            id = "EQUIP_DEMONIC_POSSESSION",
            name = "Possession démoniaque",
            desc = "Permet un contrôle limité sur quelqu'un après sa mort. \n\nUne fois spectateur, faites un clic droit pour faire défiler les joueurs vivants.\n\nAppuyez sur R pour commencer à les manipuler.",
        },
        {
            id = "EQUIP_DOUBLETAP",
            name = "Tapez deux fois",
            desc = "Tirez 50 % plus vite avec n'importe quel pistolet ordinaire.",
        },
        {
            id = "EQUIP_ELEMENTALIST_DISCHARGE",
            name = "Décharge",
            desc = "Tirez sur les joueurs pour les choquer, en frappant leur vue en fonction des dégâts infligés, en les désorientant.",
        },
        {
            id = "EQUIP_ELEMENTALIST_DISCHARGE_UP",
            name = "Décharge+",
            desc = "La décharge de mise à niveau amène les joueurs abattus à commettre en outre des actions involontaires, telles que bouger, tirer ou sauter.",
        },
        {
            id = "EQUIP_ELEMENTALIST_FROSTBITE",
            name = "Gelure",
            desc = "Tirez sur les joueurs pour ralentir leur mouvement, la force du ralentissement dépend des dégâts infligés.",
        },
        {
            id = "EQUIP_ELEMENTALIST_FROSTBITE_UP",
            name = "Gelure+",
            desc = "Mises à niveau Frostbite, les joueurs qui ont été ralentis ont une chance de se figer lorsqu'ils sont touchés, perdant ainsi tout mouvement.",
        },
        {
            id = "EQUIP_ELEMENTALIST_LIFESTEAL",
            name = "Vol de vie",
            desc = "Tirez sur les joueurs pour leur voler leur force vitale, une balle à la fois.",
        },
        {
            id = "EQUIP_ELEMENTALIST_LIFESTEAL_UP",
            name = "Vol de vie+",
            desc = "Améliore Lifesteal, exécute les joueurs qui tirent si leur santé devient trop faible, les tuant instantanément.",
        },
        {
            id = "EQUIP_ELEMENTALIST_MIDNIGHT",
            name = "Minuit",
            desc = "Tirez sur les joueurs pour commencer à les aveugler, à assombrir leur écran et à rendre leur vision difficile.",
        },
        {
            id = "EQUIP_ELEMENTALIST_MIDNIGHT_UP",
            name = "Minuit+",
            desc = "Mises à niveau à minuit, les joueurs dont les écrans sont atténués ont une chance de devenir complètement aveugles lorsqu'on leur tire dessus, sans rien voir.",
        },
        {
            id = "EQUIP_ELEMENTALIST_PYROMANCER",
            name = "Pyromancien",
            desc = "Tirez sur les joueurs pour les enflammer, la durée évoluant en fonction des dégâts infligés.",
        },
        {
            id = "EQUIP_ELEMENTALIST_PYROMANCER_UP",
            name = "Pyromancien+",
            desc = "Mises à niveau du Pyromancien, les joueurs enflammés ont une chance d'exploser lorsqu'ils sont tirés, causant des dégâts à tout le monde autour d'eux.",
        },
        {
            id = "EQUIP_ELEMENTALIST_WINDBURN",
            name = "Coup de vent",
            desc = "Tirer sur les joueurs les pousse vers l'arrière et les éloigne de vous, la force de poussée augmentant en fonction des dégâts infligés.",
        },
        {
            id = "EQUIP_ELEMENTALIST_WINDBURN_UP",
            name = "Coup de vent+",
            desc = "Mises à niveau Windburn, au lieu de pousser, lance occasionnellement des joueurs qui tirent dans les airs pour un atterrissage dur et douloureux.",
        },
        {
            id = "EQUIP_JUGGERNOG",
            name = "Mastodonte",
            desc = "Guérit complètement et accorde 50% de santé en plus.",
        },
        {
            id = "EQUIP_PHD",
            name = "Disque de doctorat",
            desc = "Au lieu de subir des dégâts de chute, provoquez une explosion de dégâts importants à l'endroit où vous atterrissez. \n\nConfère l'immunité aux explosions.",
        },
        {
            id = "EQUIP_PHS_TRACKER",
            name = "Mise à niveau du suivi de santé",
            desc = "Améliore la portée et la qualité des informations du Health Tracker.",
        },
        {
            id = "EQUIP_SPEEDCOLA",
            name = "Cola rapide",
            desc = "Double votre vitesse de rechargement des armes ordinaires.",
        },
        {
            id = "EQUIP_STAMINUP",
            name = "Endurance",
            desc = "Augmentez considérablement la vitesse de sprint!",
        },
        {
            id = "EQUIP_TF2_CLASS_CHANGER",
            name = "Changer de classe TF2",
            desc = "Achetez ceci pour changer de classe !\n\nSi vous êtes un Mann ROUGE ou BLEUE, appuyez plutôt sur la virgule [,].",
        },
    }

    local translatedPassiveItemNames = {}
    local passiveItems = {}
    local passiveItemIdToGlobalName = {}

    for role = 1, ROLE_MAX do
        -- Skip the Randoman and Hoodoo as randomat event names don't have translations
        if ROLE_RANDOMAN and role == ROLE_RANDOMAN then continue end
        if ROLE_HOODOO and role == ROLE_HOODOO then continue end

        if SHOP_ROLES[role] and EquipmentItems[role] then
            if not customPassiveItemsOrig[role] then
                customPassiveItemsOrig[role] = table.Copy(EquipmentItems[role])
            end

            for _, equ in pairs(EquipmentItems[role]) do
                if not equ.id then continue end

                for _, translation in ipairs(translatedPassiveItems) do
                    if _G[translation.id] and equ.id == _G[translation.id] then
                        equ.name = translation.name
                        equ.desc = translation.desc

                        if debugPrint then
                            translatedPassiveItemNames[equ.name] = true
                        end

                        break
                    end
                end

                if debugPrint then
                    passiveItems[equ.id] = {
                        globalName = passiveItemIdToGlobalName[equ.id],
                        name = equ.name,
                        desc = equ.desc,
                    }
                end
            end
        end
    end

    if debugPrint then
        print("=====Passive items=====")

        for name, id in pairs(_G) do
            if not isstring(name) or not isnumber(id) or not string.StartsWith(name, "EQUIP_") then continue end
            passiveItemIdToGlobalName[id] = name
        end

        for _, tbl in pairs(passiveItems) do
            -- Skip any passive items with an underscore in its name as it's highly likely to be a translation string handled instead in the language file
            if not translatedPassiveItemNames[tbl.name] and not string.find(tbl.name, "_") then
                print(tbl.globalName)
                print(tbl.name)
                print(tbl.desc)
                print("")
            end
        end

        local sortedString = ""

        -- Sorts the passive item translations into alphabetical order by their global variable name
        for _, item in SortedPairsByMemberValue(translatedPassiveItems, "id") do
            -- Behold... the most readable code of all time...
            -- This is just printing the passive item translation table above into a copy-pastable file that's sorted in alphabetical order...
            sortedString = sortedString .. "{\n    id = \"" .. item.id .. "\",\n    name = \"" .. item.name .. "\",\n    desc = \"" .. item.desc:gsub("\\", "\\\\"):gsub("\"", "\\\""):gsub("\n", "\\n") .. "\",\n},\n"
        end

        file.Write("randomat/french_passive_items.txt", sortedString)
    end

    -- Renaming weapons
    -- All in alphabetical order by classname
    local translatedWeapons = {
        avengers_fists = {
            name = "Poings Hulk",
            desc = [[Fist-les.]]
        },
        avengers_hawkeye_crybow = {
            name = "Arc Œil-de-Faucon",
            desc = [[Fusil d'assaut à très gros dégâts.

            A un recul très élevé.]]
        },
        avengers_ironman = {
            name = "Homme de Fer",
            desc = [[Armure spécialisée conçue par Tony Stark. AVERTISSEMENT: Impossible de laisser tomber!]]
        },
        avengers_nick_pistol = {
            name = "Le pistolet de Nick Fury",
            desc = [[Le pistolet pratique de Nick Fury]]
        },
        avengers_smooleystormbreaker = {
            name = "Éclair",
            desc = [[Une arme conçue pour le roi d'Asgard, forgée au cœur d'une étoile mourante.]]
        },
        avengers_ttt_minifier = {
            name = "Costume D'homme Fourmi"
        },
        avengers_ttt_shield = {
            name = "Le Bouclier de Capitaine Amérique",
            desc = [[Clic gauche pour lancer le bouclier brutalement,
            clic droit pour le lancer doucement et précis]]
        },
        c_dvaredux_nope = {
            name = "Pistolet Léger"
        },
        c_reaper_nope = {
            name = "Fusils de Chasse Hellfire"
        },
        c_sombra_gun_n = {
            name = "Pistolet-Mitrailleur"
        },
        corpselauncher = {
            name = "Lanceur de Cadavres",
            desc = [[Tire sur un cadavre créant une explosion à l'impact. Nécessite un cadavre pour tirer.
 
            A suffisamment de munitions pour tirer deux fois.
             
            Faites un clic droit pour charger un cadavre.
            Clic gauche pour lancer le cadavre.]]
        },
        crimson_new = {
            name = "Roi Cramoisi",
            desc = [[Des poings qui tuent d'un seul coup !

            Vous devez attendre une seconde avant de pouvoir commencer à frapper.]]
        },
        custom_firestarter = {
            name = "Allume Feu",
            desc = [[Allume feu
            Clic gauche - Poser un marqueur
            Clic droit - Allumer le marqueur]]
        },
        custom_pewgun = {
            name = "Pistolet de Banc",
            desc = [[Le pistolet PEW
            Tire des lasers bleus flamboyants
            Fait un son PEW sympa]]
        },
        dancedead = {
            name = "Pistolet de Danse",
            desc = [[1 coups.

            Fait danser la victime de manière incontrôlable,
            puis meurt 14 secondes plus tard.]]
        },
        death_note_ttt = {
            name = "Menace de Mort",
            desc = [[Tuez quelqu'un en écrivant son nom...

            Tout en maintenant cela, tapez le nom de quelqu'un dans le chat et il mourra dans 40 secondes.
            (Tant que vous êtes encore en vie à ce moment-là !)
            
            Clic gauche: modifiez la cause du décès.]]
        },
        doi_mg42 = {
            name = "MG42"
        },
        doncmk2_swep = {
            name = "Donconnon Mark Deux",
            desc = [[Tire une tête MASSIVE qui vole à travers les murs.
            Inflige de lourds dégâts à tous ceux qu'il touche.
            
            Faites un clic droit tout en regardant quelqu'un pour vous verrouiller sur quelqu'un!]]
        },
        equip_airboat = {
            name = "Générateur d'hydroglisseur",
            desc = [[La 1ère arme blague que vous achetez est gratuite !

            Faites un clic gauche pour faire apparaître un hydroglisseur pilotable!
            N'endommage pas les joueurs.]]
        },
        fkg_gifter_swep = {
            name = "Donateur FKG",
            desc = [[Supprime toutes les armes de la cible,
            leur offre un "pistolet gratuit" imparable
            et les oblige à tirer une fois]]
        },
        fp = {
            name = "Fassinateur",
            desc = [[Placez 5 barils explosifs autour de vos ennemis et profitez du désastre!]]
        },
        giantsupermariomushroom = {
            name = "Champignon Mario",
            desc = [[Une utilisation, gagnez beaucoup de santé et devenez énorme pendant 30 secondes!]]
        },
        laserpointer = {
            name = "Pointeur Laser",
            desc = [[La 1ère arme blague que vous achetez est gratuite !

            Aveuglez temporairement quelqu'un en le pointant devant son visage.]]
        },
        maclunkey = {
            name = "Maclunkey",
            desc = [[N'inflige aucun dégât avec d'autres armes tant que vous portez ceci sur vous.

    A un coup qui tue instantanément mais met du temps à être dégainé.

    Peut être lâché pour infliger à nouveau des dégâts avec d'autres armes.]]
        },
        manipulator = {
            name = "Changeur de Gravité",
            desc = [[Clic gauche : Réduire la gravité.

            Clic droit: Augmenter la gravité.
            
            Rechargement: gravité normale.]]
        },
        minecraft_swep = {
            name = "Bloc Minecraft",
            desc = [[Placez des blocs Minecraft!
            Appuyez sur 'R' pour changer de bloc]]
        },
        pusher_swep = {
            name = "Poussoir",
            desc = [[Devenez le pousseur de Bristol
            Clic gauche pour pousser
            Faites un clic droit pour narguer vos victimes]]
        },
        rotgun = {
            name = "Pistolet Rotatif",
            desc = [[Tirer sur quelqu'un avec ça le retourne.]]
        },
        shared = {
            name = "Émulateur de bouffon",
            desc = [[Un M16 qui n'inflige aucun dégât.]]
        },
        speedgun = {
            name = "Fusil Rapide",
            desc = [[Une arme qui les rend plus rapides, pour toujours.
            (Jusqu'à la fin du tour)]]
        },
        st_bananapistol = {
            name = "Pistolet banane"
        },
        stungun = {
            name = "Pistolet Paralysant",
            desc = [[Stungun utilisé pour paralyser les ennemis en les rendant
            incapable de parler et de bouger pendant quelques secondes.
            Il a 3 charges.
            
            Créé par: Donkie]]
        },
        surprisesoldiers = {
            name = "Soldats Surprises",
            desc = [[Générez un soldat combiné aléatoire là où vous tirez!]]
        },
        swep_homingpigeon = {
            name = "Pigeon Voyageur",
            desc = [[Un pigeon que l'on peut lancer sur quelqu'un et qui explose !

            Vole très vite, nécessite de regarder directement quelqu'un pour le lancer.]]
        },
        swep_rifle_viper = {
            name = "Fusil Vipère"
        },
        terror_fulton = {
            name = "Fulton",
            desc = [[Tu vas l'emmener ?
            Cet équipement peut extraire des cadavres ou des accessoires via le
            système de récupération de ballons Fulton.
            Les ballons éclateront s'ils sont tirés ou déployés à l'intérieur.
            Faites un clic droit pour définir une destination. Rechargez pour l'effacer.]]
        },
        tfa_acidgat = {
            name = "Acide Gat",
            desc = [[Tire plusieurs explosifs qui collent aux joueurs et explosent après quelques secondes.]]
        },
        tfa_blundergat = {
            name = "Tromblon",
            desc = [[Un fusil de chasse incroyablement puissant!]]
        },
        tfa_bo2_remington_nma = {
            name = "Remington N.M.A.",
            desc = [[Remington N.M.A.]]
        },
        tfa_bo3_argus = {
            name = "Argus",
            desc = [[Argus]]
        },
        tfa_dax_big_glock = {
            name = "Gros Glock"
        },
        tfa_doom_ssg = {
            name = "Super Fusil de Chasse",
            desc = [[Le super fusil de chasse de DOOM.]]
        },
        tfa_jetgun = {
            name = "Le Pistolet à Réaction",
            desc = [[Aspire les gens et les tue instantanément.

            Surchauffe et explose s'il est utilisé trop longtemps sans refroidir.]]
        },
        tfa_mercy_nope = {
            name = "Blaster de Caducée"
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
        tfa_scavenger = {
            name = "Charognard",
            desc = [[Un fusil de sniper qui tire un explosif à retardement qui explose après quelques secondes.

            L'explosif colle aux joueurs.]]
        },
        tfa_shrinkray = {
            name = "Le Créateur de Bébé",
            desc = [[Tire un orbe qui rétrécit tous ceux qu'il touche!
            Cela les réduit à 1 point de vie.
            
            Marcher sur quelqu'un alors qu'il est rétréci le tue.]]
        },
        tfa_sliquifier = {
            name = "Slicificateur",
            desc = [[Tire des boules de slime qui tuent instantanément!

            Si vous touchez quelqu'un ou le sol, cela laisse une flaque de bave glissante.]]
        },
        tfa_staff_lightning = {
            name = "Bâton de Foudre",
            desc = [[Tire rapidement des boules de plasma!

            Les projectiles ne sont pas un hitscan et mettent du temps à voyager dans les airs.]]
        },
        tfa_staff_lightning_ult = {
            name = "La morsure de Kimat"
        },
        tfa_staff_wind = {
            name = "Bâton du Vent",
            desc = [[Tire des explosions aériennes à courte portée et causant de gros dégâts!]]
        },
        tfa_staff_wind_ult = {
            name = "La fureur de Borée"
        },
        tfa_thundergun = {
            name = "Fusil-Tonnerre",
            desc = [[Tire une explosion aérienne massive qui envoie voler toute personne se trouvant à courte distance!]]
        },
        tfa_tracer_nope = {
            name = "Pistolets à Impulsions"
        },
        tfa_vr11 = {
            name = "VR-11",
            desc = [[Quiconque vous touchez obtient le pouvoir de tuer instantanément avec des armes ordinaires !

    Dure un temps limité.]]
        },
        tfa_wavegun = {
            name = "Pistolets Zap",
            desc = [[Pistolets laser à double usage.
            Appuyez sur le clic gauche ou droit pour tirer!]]
        },
        tfa_wintershowl = {
            name = "Le Hurlement de L'hiver",
            desc = [[Tire un souffle d'air froid à courte portée qui gèle les gens et les tue après quelques secondes.]]
        },
        tfa_wunderwaffe = {
            name = "Wunderwaffe DG-2",
            desc = [[Fusil éclair puissant qui tue en 1 seul coup !

            Vous tuera également si vous tirez trop près!]]
        },
        the_xmas_gun = {
            name = "Le Pistolet de Noël",
            desc = [[Tirez des cadeaux qui tuent d'un seul coup]]
        },
        thw_swep = {
            name = "Thwomp",
            desc = [[Description !]]
        },
        ttt_backwards_shotgun = {
            name = "Fusil à Pompe à L'envers",
            desc = [[La première arme blague que vous achetez une cartouche est gratuite!

            Un fusil de chasse qui tire derrière vous et vous propulse vers l'avant.
            
            Faites un clic droit pour vous retourner instantanément.]]
        },
        ttt_combine_sniper_summoner = {
            name = "Invocateur de tireur d'élite",
            desc = [[Invoque un tireur d'élite qui tuera tous ceux qui se trouvent devant lui!

            Fait face à la direction dans laquelle vous regardez.
            
            Ciblez sur le dessus d'une surface plane.]]
        },
        ttt_deal_with_the_devil = {
            name = "Traiter Avec Le Diable",
            desc = [[Révélez que vous êtes un traître à tout le monde, mais recevez un puissant avantage en retour!]]
        },
        ttt_kamehameha_swep = {
            name = "Kaméhaméha",
            desc = [[Plus de 9 000. Gèle le traître lors du tir. Attention à l'explosion !]]
        },
        ttt_no_scope_awp = {
            name = "Aucune portée Awp",
            desc = [[Une arme puissante qui ne peut être tirée que lorsque le compteur 'Cool' est chargé en effectuant un 360.]]
        },
        ttt_pap_groovitron = {
            name = "Groovitron",
            desc = [[Force les joueurs à proximité à danser !]]
        },
        ttt_pap_jam = {
            name = "Confiture",
            desc = [[Un pot de confiture. Ne fait rien...]]
        },
        ttt_pap_remove_tool = {
            name = "Outil de Suppression"
        },
        ttt_perk_doubletap = {
            name = "Bière de Racine à Double Pression"
        },
        ttt_perk_juggernog = {
            name = "Mastodonte"
        },
        ttt_perk_phd = {
            name = "Flopper de Doctorat"
        },
        ttt_perk_speedcola = {
            name = "Cola Rapide"
        },
        ttt_perk_staminup = {
            name = "Endurance"
        },
        ttt_player_pinger = {
            name = "Joueur Pinger",
            desc = [[Vous permet de voir tout le monde à travers les murs pendant une durée limitée!]]
        },
        ttt_sahmin_gun = {
            name = "Pistolet Sahmin",
            desc = [[La première arme blague que vous achetez une cartouche est gratuite!

            Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin Sahmin]]
        },
        ttt_slappers = {
            name = "Baffeurs",
            desc = [[La 1ère arme blague que vous achetez par round est gratuite ! 

    Vous permet de gifler quelqu'un et de secouer son écran !

    Clic gauche - main gauche
    Clic droit - main droite]]
        },
        ttt_weapon_eagleflightgun = {
            name = "Pistolet de Vol D'aigle",
            desc = [[Tirez pour vous jeter.
            Si vous tombez sur un joueur, il mourra !
            Sinon, appuyez à nouveau sur le bouton gauche de la souris pour exploser.]]
        },
        ttt_weapon_lasso = {
            name = "Lasso",
            desc = [[Tir principal : lancez le lasso pour tirer des joueurs ou des objets.

    Tir secondaire : attachez-vous à un joueur proche.]]
        },
        ttt_weeping_angel = {
            name = "Ange Pleurant",
            desc = [[Tirez sur quelqu'un pour qu'une statue "Weeping Angel" le suive.

            Pendant qu'ils ne la regardent pas, la statue de l'ange se rapproche d'eux.
            
            Si la statue les touche, ils meurent.]]
        },
        waluigi_launcher_ttt = {
            name = "Lanceur de Waluigi",
            desc = [[Lancez un Waluigi sur vos ennemis.]]
        },
        weapon_amongussummoner = {
            name = "Parmi l'invocateur",
            desc = [[Faites un clic gauche pour placer un piège invisible au sol.

            Si un joueur marche dessus, un monstre porteur d'explosifs apparaît et attaque!]]
        },
        weapon_antlionsummoner = {
            name = "Invocateur de Fourmilion",
            desc = [[Invoque un garde fourmilion. Cible sur le dessus d'une surface plane]]
        },
        weapon_ap_golddragon = {
            name = "Dragon D'or",
            desc = [[Faibles dégâts, fusil d'assaut précis
            qui met le feu aux ennemis.
          
          Utilise des munitions SMG standard.]]
        },
        weapon_ap_hbadger = {
            name = "Blaireau au Miel"
        },
        weapon_ap_mrca1 = {
            name = "MR-CA1"
        },
        weapon_ap_pp19 = {
            name = "PP-19 Bizon"
        },
        weapon_ap_tec9 = {
            name = "TEC-9"
        },
        weapon_ap_vector = {
            name = "Vecteur"
        },
        weapon_ars_igniter = {
            name = "Allumeur"
        },
        weapon_ballin = {
            name = "Basket-ball"
        },
        weapon_bam_transformer = {
            name = "Transformateur de Baril"
        },
        weapon_banana = {
            name = "Bombe banane",
            desc = [[Ça sent frais.

            Clic gauche pour lancer,
            Clic droit pour faire sonner le bon vieux son
              + Changer le temps du fusible]]
        },
        weapon_bat = {
            name = "Batte de Baseball"
        },
        weapon_bod_bodysnatch = {
            name = "Dispositif D'arrachage de Corps",
            desc = [[Change votre rôle en celui d'un cadavre.]]
        },
        weapon_bonesaw = {
            name = "Scie à Os"
        },
        weapon_bottle = {
            name = "Bouteille"
        },
        weapon_box_gloves = {
            name = "Gants",
            desc = [[Clic gauche pour attaquer]]
        },
        weapon_btn_transformer = {
            name = "Transformateur de Bouton"
        },
        weapon_can_eater = {
            name = "Cannibaliseur"
        },
        weapon_catgun = {
            name = "Pistolet à Chat"
        },
        weapon_chf_stoveplacer = {
            name = "Placeur de Cuisinière",
            desc = [[Place une cuisinière avec différents types de plats, procurant différents buffs.]]
        },
        weapon_cln_targetpicker = {
            name = "Sélecteur de Cible"
        },
        weapon_com_manifesto = {
            name = "Manifeste Communiste",
            desc = [[Faites un clic gauche pour convertir un autre joueur]]
        },
        weapon_controllable_manhack = {
            name = "Manhack Contrôlable",
            desc = [[Clic gauche pour déployer, clic droit pour contrôler.]]
        },
        weapon_cup_bow = {
            name = "L'arc de Cupidon"
        },
        weapon_discordgift = {
            name = "Table D'harmonie Discord",
            desc = [[La 1ère arme blague que vous achetez est gratuite !

            Est-ce que quelqu'un vient de nous rejoindre ? Non! Juste votre propre table d'harmonie Discord personnelle!
             
            Clic gauche - Rejoindre le son
            Clic droit - Quitter le son
            R - Ping sonore]]
        },
        weapon_doncombinesummoner = {
            name = "DoncomInvocateur",
            desc = [[Invoque un Doncombine hostile à quiconque
            pas dans l'équipe des traîtres]]
        },
        weapon_dp = {
            name = "DP-28"
        },
        weapon_dr2_remote = {
            name = "Contrôleur de Drone",
            desc = [[Contrôle un drone de reconnaissance qui tire des missiles. Clic gauche
    pour déployer/récupérer le drone, clic droit pour basculer le
    contrôle. Le drone vole en utilisant WASD, sauter/s'accroupir
    change l'altitude, clic gauche pour tirer un missile.
    Le drone régénère passivement sa santé et ses munitions.]]
        },
        weapon_dubstepgun = {
            name = "Pistolet Dubstep",
            desc = [[Maintenez le clic gauche pour tirer des lasers musicaux qui infligent beaucoup de dégâts!]]
        },
        weapon_enderpearl = {
            name = "Perle de l'Ender",
            desc = [[Vous savez ce que ça fait.]]
        },
        weapon_enfield_4 = {
            name = "Lee Enfield No.4"
        },
        weapon_fartgrenade = {
            name = "Grenade à Pet"
        },
        weapon_fg42 = {
            name = "FG-42"
        },
        weapon_fireaxe = {
            name = "Hache D'incendie"
        },
        weapon_fistsheavy = {
            name = "Poings"
        },
        weapon_fre_baguette = {
            name = "Baguette"
        },
        weapon_gewehr43 = {
            name = "Gewehr 43"
        },
        weapon_gmr_cheeto_fingers = {
            name = "Doigts de Cheetos"
        },
        weapon_gmr_gacha = {
            name = "Machine Gacha"
        },
        weapon_gnome_grenade = {
            name = "Grenade Gnome",
            desc = [[Gnome vos copains avec la nouvelle grenade explosive « Youve been Gnomed ».

            Vous avez été Gnomed!]]
        },
        weapon_guardiansummoner = {
            name = "Invocateur de Garde",
            desc = [[Invoque un Gardien Fourmilion :
    Un grand fourmilion qui attaque avec du poison
    et invoque des fourmilions plus petits à
    son aide.]]
        },
        weapon_gue_guesser = {
            name = "Devineur de Rôle"
        },
        weapon_hp_ares_shrike = {
            name = "Pie-grièche D'Arès"
        },
        weapon_hp_glauncher = {
            name = "Lance-Grenades",
            desc = [[Lance-grenades explosif automatique.

            Livré avec 12 tours.]]
        },
        weapon_hyp_brainwash = {
            name = "Dispositif de Lavage de Cerveau",
            desc = [[Ressuscite un innocent en traître.]]
        },
        weapon_inf_scanner = {
            name = "Scanner"
        },
        weapon_john_bomb = {
            name = "John Bombe",
            desc = [[Clic gauche pour vous faire EXPLOSER. Faites un clic droit pour narguer.]]
        },
        weapon_kra_carry = {
            name = "Griffes Saisissantes"
        },
        weapon_lee = {
            name = "Lee Enfield No.2"
        },
        weapon_long_revolver = {
            name = "Revolver Longue",
            desc = [[La 1ère arme blague que vous achetez est gratuite !

            Un revolver ridiculement long.]]
        },
        weapon_luger = {
            name = "Luger"
        },
        weapon_m3 = {
            name = "Pistolet Graisseur M3"
        },
        weapon_m9k_1887winchester = {
            name = "Winchester 1887"
        },
        weapon_m9k_1897winchester = {
            name = "Winchester 1897"
        },
        weapon_m9k_acr = {
            name = "ACR"
        },
        weapon_m9k_ak47 = {
            name = "AK-47"
        },
        weapon_m9k_ak74 = {
            name = "AK-74"
        },
        weapon_m9k_amd65 = {
            name = "AMD-65"
        },
        weapon_m9k_an94 = {
            name = "AN-94"
        },
        weapon_m9k_ares_shrike = {
            name = "Pie-grièche D'Arès"
        },
        weapon_m9k_auga3 = {
            name = "Steyr AOÛT A3"
        },
        weapon_m9k_aw50 = {
            name = "AW-50"
        },
        weapon_m9k_barret_m82 = {
            name = "Barrett M82"
        },
        weapon_m9k_bizonp19 = {
            name = "Bizon PP19"
        },
        weapon_m9k_browningauto5 = {
            name = "Browning Auto 5"
        },
        weapon_m9k_colt1911 = {
            name = "Colt 1911"
        },
        weapon_m9k_coltpython = {
            name = "Colt Python"
        },
        weapon_m9k_contender = {
            name = "Thompson G2"
        },
        weapon_m9k_dbarrel = {
            name = "Double Baril"
        },
        weapon_m9k_deagle = {
            name = "Aigle du Désert .40"
        },
        weapon_m9k_dragunov = {
            name = "SVD Dragounov"
        },
        weapon_m9k_f2000 = {
            name = "FN F2000"
        },
        weapon_m9k_fal = {
            name = "FN FAL"
        },
        weapon_m9k_famas = {
            name = "FAMAS"
        },
        weapon_m9k_fg42 = {
            name = "FG 42"
        },
        weapon_m9k_g36c = {
            name = "G36C"
        },
        weapon_m9k_g3a3 = {
            name = "HK G3A3"
        },
        weapon_m9k_glock = {
            name = "Glock 18"
        },
        weapon_m9k_hk45 = {
            name = "HK45C"
        },
        weapon_m9k_honeybadger = {
            name = "AAC H-Badger"
        },
        weapon_m9k_intervention = {
            name = "Intervention"
        },
        weapon_m9k_ithacam37 = {
            name = "Ithaca M37"
        },
        weapon_m9k_jackhammer = {
            name = "MK3A1"
        },
        weapon_m9k_kac_pdw = {
            name = "KAC PDW"
        },
        weapon_m9k_l85 = {
            name = "L85"
        },
        weapon_m9k_luger = {
            name = "P08 Luger"
        },
        weapon_m9k_m14sp = {
            name = "M14"
        },
        weapon_m9k_m16a4_acog = {
            name = "M16A4 ACOG"
        },
        weapon_m9k_m1918bar = {
            name = "M1918 BAR"
        },
        weapon_m9k_m24 = {
            name = "M24"
        },
        weapon_m9k_m249lmg = {
            name = "M249 LMG"
        },
        weapon_m9k_m29satan = {
            name = "M29 Satan"
        },
        weapon_m9k_m3 = {
            name = "Benelli M3"
        },
        weapon_m9k_m416 = {
            name = "HK 416"
        },
        weapon_m9k_m4a1 = {
            name = "M4A1"
        },
        weapon_m9k_m60 = {
            name = "M60"
        },
        weapon_m9k_m92beretta = {
            name = "M92 Beretta"
        },
        weapon_m9k_m98b = {
            name = "Barrett M98B"
        },
        weapon_m9k_magpulpdr = {
            name = "Magpul PDR"
        },
        weapon_m9k_model3russian = {
            name = "Modèle S&W 3"
        },
        weapon_m9k_model627 = {
            name = "Modèle S&W 627"
        },
        weapon_m9k_mossberg590 = {
            name = "Mossberg 590"
        },
        weapon_m9k_mp40 = {
            name = "MP40"
        },
        weapon_m9k_mp5 = {
            name = "HK MP5"
        },
        weapon_m9k_mp5sd = {
            name = "HK MP5SD"
        },
        weapon_m9k_mp7 = {
            name = "HK MP7"
        },
        weapon_m9k_mp9 = {
            name = "MP9"
        },
        weapon_m9k_pkm = {
            name = "PKM"
        },
        weapon_m9k_psg1 = {
            name = "PSG-1"
        },
        weapon_m9k_ragingbull = {
            name = "Taureau Furieux"
        },
        weapon_m9k_remington1858 = {
            name = "Remington 1858"
        },
        weapon_m9k_remington7615p = {
            name = "Remington 7615P"
        },
        weapon_m9k_remington870 = {
            name = "Remington 870"
        },
        weapon_m9k_scar = {
            name = "CICATRICE-H"
        },
        weapon_m9k_scoped_taurus = {
            name = "Porté Taureau Furieux"
        },
        weapon_m9k_sig_p229r = {
            name = "SIG Sauer P229R"
        },
        weapon_m9k_sl8 = {
            name = "HK SL8"
        },
        weapon_m9k_smgp90 = {
            name = "FN P90"
        },
        weapon_m9k_spas12 = {
            name = "SPAS 12"
        },
        weapon_m9k_sten = {
            name = "STEN"
        },
        weapon_m9k_striker12 = {
            name = "Attaquant 12"
        },
        weapon_m9k_svt40 = {
            name = "SVT 40"
        },
        weapon_m9k_svu = {
            name = "Dragounov SVU"
        },
        weapon_m9k_tar21 = {
            name = "TAR-21"
        },
        weapon_m9k_tec9 = {
            name = "TEC-9"
        },
        weapon_m9k_thompson = {
            name = "Mitraillette"
        },
        weapon_m9k_ump45 = {
            name = "HK UMP45"
        },
        weapon_m9k_usas = {
            name = "États-Unis"
        },
        weapon_m9k_usc = {
            name = "HK USC"
        },
        weapon_m9k_usp = {
            name = "HK USP"
        },
        weapon_m9k_uzi = {
            name = "UZI"
        },
        weapon_m9k_val = {
            name = "COMME VAL"
        },
        weapon_m9k_vector = {
            name = "Kriss Vecteur"
        },
        weapon_m9k_vikhr = {
            name = "SR-3M Vikhr"
        },
        weapon_m9k_winchester73 = {
            name = "Winchester '73"
        },
        weapon_mad_zombificator = {
            name = "Dispositif de Zombification",
            desc = [[Transforme les joueurs morts en zombies.]]
        },
        weapon_mastersword = {
            name = "Maître Épée",
            desc = [[Tir principal: attaque
            Tir secondaire: attaque sautée
            Recharger: Kamikaze Spin Attack]]
        },
        weapon_med_defib = {
            name = "Défibrillateur",
            desc = [[Ravive un joueur mort.]]
        },
        weapon_mhl_badge = {
            name = "Insigne D'adjoint"
        },
        weapon_minigun = {
            name = "Minigun",
            desc = [[Le Choix D'arme de Rambo]]
        },
        weapon_mis_proselytizer = {
            name = "Prosélytiseur"
        },
        weapon_old_dbshotgun = {
            name = "Double Baril"
        },
        weapon_paintgun = {
            name = "Pistolet à Peinture",
            desc = [[Faites un clic droit pour changer les couleurs.]]
        },
        weapon_par_cure = {
            name = "Remède contre les parasites"
        },
        weapon_pha_exorcism = {
            name = "Dispositif d'exorcisme",
            desc = [[Vous permet d'effectuer un exorcisme pour éliminer un fantôme obsédant]]
        },
        weapon_phr_ankh = {
            name = "Ankh"
        },
        weapon_plm_dartgun = {
            name = "Fusil à Fléchettes de la Peste"
        },
        weapon_pnr_poisongun = {
            name = "Pistolet à Poison"
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
        weapon_pp_rbull = {
            name = "Taureau Furieux"
        },
        weapon_pp_remington = {
            name = "Remington 1858"
        },
        weapon_ppsh41 = {
            name = "PPSH-41"
        },
        weapon_prop_blaster = {
            name = "Blaster à Accessoires",
            desc = [[Fait exploser des accessoires aléatoires dans des directions aléatoires]]
        },
        weapon_qua_fake_cure = {
            name = "Remède contre les parasites"
        },
        weapon_randomat_boxgloves = {
            name = "Gants",
            desc = [[Clic gauche pour attaquer]]
        },
        weapon_randomat_christmas_cannon = {
            name = "Canon de Noël"
        },
        weapon_randomlauncher = {
            name = "Lanceur Aléatoire",
            desc = [[Lance un objet aléatoire qui inflige beaucoup de dégâts, tuant généralement instantanément.]]
        },
        weapon_rp_pocket = {
            name = "Fusil de Poche"
        },
        weapon_rp_railgun = {
            name = "Pistolet à Tuer Gratuit"
        },
        weapon_san_christmas_cannon = {
            name = "Canon de Noël"
        },
        weapon_scattergun = {
            name = "Fusil à Dispersion"
        },
        weapon_sfk_safeplacer = {
            name = "Placeur de Coffre"
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
        weapon_sharkulonsummoner = {
            name = "Invocateur de Sharkulon",
            desc = [[Invoque un Sharkulon, un drone tueur
    rapide en forme de requin

    inflige moins de dégâts aux traîtres]]
        },
        weapon_sharxcalibur = {
            name = "Sharxcalibur",
            desc = [[Arme de mêlée qui sacrifiera sa vie pour
    sauver la vôtre si elle est équipée

    Deviendra un projectile après activation]]
        },
        weapon_shovel = {
            name = "Pelle"
        },
        weapon_slazer_new = {
            name = "Laser Spartiate",
            desc = [[Maintenez le clic gauche pour tirer avec ce canon laser MASSIF!

            Provoque une puissante explosion]]
        },
        weapon_sniper = {
            name = "Tireur D'élite TF2"
        },
        weapon_sp_dbarrel = {
            name = "Double Baril"
        },
        weapon_sp_striker = {
            name = "Attaquant 12"
        },
        weapon_sp_winchester = {
            name = "Winchester 1873"
        },
        weapon_spn_spongifier = {
            name = "Spongifiant"
        },
        weapon_spraymhs = {
            name = "Aérosol",
            desc = [[La 1ère arme blague que vous achetez est gratuite !

            Faites un clic droit pour changer de couleur.]]
        },
        weapon_stenmk3 = {
            name = "Sten Mark Trois"
        },
        weapon_svt40 = {
            name = "SVT-40"
        },
        weapon_syringegun = {
            name = "Pistolet à Seringue"
        },
        weapon_t14nambu = {
            name = "Type 14 Nambu"
        },
        weapon_t38 = {
            name = "Type 38 Arisaka"
        },
        weapon_taser_derens = {
            name = "Pistolet Paralysant",
            desc = [[Doit être à courte portée pour l'instakill. Usage unique.]]
        },
        weapon_tax_kit = {
            name = "Kit de Taxidermie",
            desc = [[Ressuscite un innocent en traître.]]
        },
        weapon_teleport_gun_t = {
            name = "Pistolet d'échange de joueur",
            desc = [[Un pistolet de téléportation !
            Tirez pour changer de place avec un joueur.
            Ne fonctionne que si vous êtes au sol et
            si vous et votre cible n'êtes pas accroupis.]]
        },
        weapon_tf2pistol = {
            name = "Pistolet TF2"
        },
        weapon_tf2revolver = {
            name = "Revolver TF2"
        },
        weapon_tf2shotgun = {
            name = "Fusil à Pompe TF2"
        },
        weapon_tf2smg = {
            name = "Pistolet-Mitrailleur TF2"
        },
        weapon_thf_thievestools = {
            name = "Outils de Voleur"
        },
        weapon_thr_bonecharm = {
            name = "Charme D'os"
        },
        weapon_tnk_upgrader = {
            name = "Appareil D'amélioration"
        },
        weapon_tt = {
            name = "Tokarev TT-33"
        },
        weapon_ttt_adm_menu = {
            name = "Menu Administrateur"
        },
        weapon_ttt_ak47 = {
            name = "AK47",
            desc = [[Fusil d'assaut à très haut dégât.

    A un recul très élevé.]]
        },
        weapon_ttt_ak47gold = {
            name = "AK-47 Kadhafi",
            desc = [[AK-47 fait en or.
    Plus de dégâts, plus de munitions, plus de meurtres.]]
        },
        weapon_ttt_artillery = {
            name = "Canon D'artillerie",
            desc = [[Génère un canon d'artillerie très puissant qui tire une grosse bombe sur une longue portée.

            Pour contrôler, placez-vous juste derrière et appuyez sur 'E' sur les commandes qui apparaissent.]]
        },
        weapon_ttt_aug = {
            name = "AOÛT"
        },
        weapon_ttt_awp = {
            name = "AWP Silencieux",
            desc = [[Fusil de précision AWP silencieux.

            Il n'a qu'un seul coup.
            
            Les victimes ne crieront pas lorsqu'elles seront tuées.]]
        },
        weapon_ttt_awp_advanced_silenced = {
            name = "Av. AWP silencieux",
            desc = [[Un tir, un mort. Les victimes ne crieront pas lorsqu'elles seront tuées.
            Fournit des informations avancées sur le HUD.
            
            Créé par @josh_caratelli + Liam McLachlan.]]
        },
        weapon_ttt_baguette_randomat = {
            name = "Baguette"
        },
        weapon_ttt_barnacle = {
            name = "Bernacle",
            desc = [[Un piège extraterrestre mortel au plafond!

            Faites un clic gauche pour placer le piège au plafond, toute personne passant en dessous sera lentement tuée.]]
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
        weapon_ttt_beenade = {
            name = "Grenade à Abeilles",
            desc = [[Grenade à abeilles.
            Libère plusieurs abeilles hostiles lors de la détonation.]]
        },
        weapon_ttt_bike = {
            name = "Vélo de Traître",
            desc = [[Lancez un vélo sur quelqu'un.

            Fais-le, espèce de merde.]]
        },
        weapon_ttt_bomb_station = {
            name = "Station de Bombes",
            desc = [[Lorsque des innocents utiliseront ce poste de santé, ce sera
            bip avant d'exploser.
            Les traîtres épuiseront simplement la fausse charge.]]
        },
        weapon_ttt_bonk_bat = {
            name = "Chauve-souris Bonk",
            desc = [[Envoyez les gens en prison !

            Une chauve-souris qui emprisonne ceux que vous frappez dans une cage pendant quelques secondes.]]
        },
        weapon_ttt_bookquill = {
            name = "Carnet"
        },
        weapon_ttt_boom_cat = {
            name = "Chat Boum",
            desc = [[Lancez un chat qui fait boum.]]
        },
        weapon_ttt_boomerang_randomat = {
            name = "Boomerang",
            desc = [[Clic droit pour lancer]]
        },
        weapon_ttt_brain = {
            name = "Parasite du Cerveau",
            desc = [[1 fléchette.

            La victime tire au hasard
            puis mourir d'une crise cardiaque
            20 secondes plus tard.]]
        },
        weapon_ttt_brain_parasite = {
            name = "Parasite Cérébral",
            desc = [[Pistolet silencieux chargé de parasites qui forcent la cible à tirer au hasard.

    Le parasite tue la victime 20 secondes après l'infection.

    1 fléchette.]]
        },
        weapon_ttt_car_gun = {
            name = "Pistolet de Voiture",
            desc = [[Tirez sur quelqu'un avec une voiture volante et figez-le sur place!

            Toute personne coincée sur le chemin de la voiture entre vous et la victime subit également des dégâts.]]
        },
        weapon_ttt_chickenator = {
            name = "Poulet",
            desc = [[Le choix de l'arme de Rambo]]
        },
        weapon_ttt_chickennade = {
            name = "Œuf de poule",
            desc = [[Un poulet agressif !
            Faites trop chier et ça explose!]]
        },
        weapon_ttt_cloak = {
            name = "Dispositif de Masquage 2.0",
            desc = [[Tenez pour devenir presque invisible

            Ne cache pas les taches de sang ni votre popup nom/santé
            
            Certaines cartes peuvent avoir un mauvais éclairage et vous laisser un peu trop visible.]]
        },
        weapon_ttt_cloak_randomat = {
            name = "Cape D'ombre"
        },
        weapon_ttt_clutterbomb = {
            name = "Bombe Encombrant",
            desc = [[Une grenade hautement explosive.

            Prudent! Il peut exploser dans votre main si vous
            faites-le cuire trop longtemps!]]
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
        weapon_ttt_cracker = {
            name = "Biscuit de Noël",
            desc = [[Un cracker de Noël rempli de gourmandises!]]
        },
        weapon_ttt_csgo_r8revolver = {
            name = "Revolver R8"
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
        weapon_ttt_death_link = {
            name = "Lien Mortel",
            desc = [[À utiliser sur n'importe quel joueur. Une fois qu'ils meurent, vous mourez et vice versa.]]
        },
        weapon_ttt_demonsign = {
            name = "Possession Démoniaque",
            desc = [[Placez votre signe démoniaque au sol et
            prendre le contrôle d'un autre joueur lorsqu'il marche
            dessus après votre mort.]]
        },
        weapon_ttt_dete_playercam = {
            name = "Supprimer la Playercam",
            desc = [[1 tir avec visée automatique.
            Montre la vision de la cible qui a été tirée.
            Cible modifiable en fermant la fenêtre.
            et tirer à nouveau (ne fonctionne que si vous portez toujours le
            arme).]]
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
        weapon_ttt_detective_supersheep = {
            name = "Mouton Observateur",
            desc = [[Lancez l'Observer Sheep pour traquer vos ennemis!
            Clic gauche: marquer une personne
            Clic droit: récupérez le mouton]]
        },
        weapon_ttt_detectiveball = {
            name = "Boule de Détective",
            desc = [[Lancez-vous sur un proche pour le transformer en détective !
            Révèle plutôt leur rôle s'il s'agit d'un traître.
            
            Rien ne se passe s'il s'agit d'un innocent ou d'un traître, comme un pépin ou un hypnotiseur.]]
        },
        weapon_ttt_dislocator = {
            name = "Dislocateur",
            desc = [[Tire un disque qui lance les joueurs dans
            directions aléatoires.]]
        },
        weapon_ttt_dragon_elites = {
            name = "Élites Dragons",
            desc = [[Pistolets à double usage avec une animation de rechargement sympa.]]
        },
        weapon_ttt_duel_revolver_randomat = {
            name = "Pistolet de Duel"
        },
        weapon_ttt_extinguisher = {
            name = "Extincteur",
            desc = [[Vaporisez les traîtres et aveuglez-les]]
        },
        weapon_ttt_famas = {
            name = "FAMAS"
        },
        weapon_ttt_fingergun = {
            name = "Pistolet à Doigt",
            desc = [[BOOM BOOM
            hors de vos doigts !
            
            Primaire: Automatique.
            Secondaire: Fusil de chasse.]]
        },
        weapon_ttt_fire_dash = {
            name = "Tiret de Feu",
            desc = [[Augmente de manière permanente votre vitesse et vous enflamme.

            Tous ceux que vous rencontrez meurent instantanément!
            
            Vous mourez au bout de 10 secondes.]]
        },
        weapon_ttt_flashbang = {
            name = "Grenade Aveuglante",
            desc = [[Le meilleur flash que vous n'ayez jamais vu - PAS POUR ISA !]]
        },
        weapon_ttt_foolsgoldengun = {
            name = "Le Pistolet F'or du Fou",
            desc = [[Tirez sur un traître, tuez un traître.
            Tirer sur un innocent, tuer un traître ?
            Tirez sur un bouffon, tuez un traître...
            Quelque chose ne va pas ici...]]
        },
        weapon_ttt_force_shield = {
            name = "Bouclier de Force Déployable",
            desc = [[À utiliser pour déployer un bouclier de force.
            Peut être traversé, mais bloque les balles.
              A 800 ch et une durée de vie de 30 secondes.]]
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
        weapon_ttt_freezegun = {
            name = "Pistolet à Glace",
            desc = [[Gèle la cible pendant 5 secondes.
            La cible ne peut pas bouger, regarde autour de toi,
            tirer ou faire autre chose.
            
            4 coups]]
        },
        weapon_ttt_g3sg1 = {
            name = "G3SG1"
        },
        weapon_ttt_galil = {
            name = "Galille"
        },
        weapon_ttt_gimnade = {
            name = "Grenade Gravitationnelle",
            desc = [[Grenade high-tech du futur!]]
        },
        weapon_ttt_glock = {
            name = "Glock"
        },
        weapon_ttt_gravity_pistol = {
            name = "Pistolet à Gravité",
            desc = [[Inverse la gravité du joueur,
            que vous frappez, pendant quelques secondes.]]
        },
        weapon_ttt_gwh_ghosting = {
            name = "Dispositif Fantôme"
        },
        weapon_ttt_handcuffs = {
            name = "Menottes",
            desc = [[Menottez quelqu'un pour le forcer à lâcher ses armes et l'empêcher d'en ramasser de nouvelles.]]
        },
        weapon_ttt_head_message = {
            name = "Message au-dessus de la Tête",
            desc = [[Écrivez un message qui s'affiche au-dessus de votre tête !]]
        },
        weapon_ttt_headlauncher = {
            name = "Lanceur de Crabe",
            desc = [[Lance des capsules remplies de crabes.
            Dégâts d'impact massifs là où il frappe!
            A 3 charges.]]
        },
        weapon_ttt_homebat = {
            name = "Batte de Circuit",
            desc = [[Frappez les gens très loin avec une batte!
            Inflige une quantité modérée de dégâts en cas de coup]]
        },
        weapon_ttt_hotpotato = {
            name = "Patate Chaude",
            desc = [[Faites un clic gauche sur quelqu'un à portée de mêlée pour lui donner la patate chaude!

            S'ils ne le transmettent pas en 12 secondes, ils explosent !]]
        },
        weapon_ttt_hwapoon = {
            name = "Harpon",
            desc = [[Harpon jetable.

            Silencieux si vous touchez un joueur, tue d'un seul coup.]]
        },
        weapon_ttt_id_bomb = {
            name = "Bombe D'identification",
            desc = [[Le cadavre signalé (clic gauche) explosera après identification.]]
        },
        weapon_ttt_id_bomb_defuser = {
            name = "Désamorceur de bombe d'identification",
            desc = [[Faites un clic gauche sur un cadavre bombardé d'identité pour désamorcer la bombe!]]
        },
        weapon_ttt_impostor_knife_randomat = {
            name = "Couteau de tueur de Traître"
        },
        weapon_ttt_jarate = {
            name = "Jaraté",
            desc = [[Un pot de pisse
            Toute personne couverte subira deux fois plus de dégâts]]
        },
        weapon_ttt_jetpack = {
            name = "Jetpack",
            desc = [[Sélectionnez-le et appuyez sur Saut pour vous propulser vers le haut.

    Attention à l'atterrissage.]]
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
        weapon_ttt_jumpgun = {
            name = "Pistolet de Saut",
            desc = [[Tirez pour aller dans la direction opposée (par exemple, tirez vers le bas pour monter).]]
        },
        weapon_ttt_knife_randomat = {
            name = "Couteau de lancer"
        },
        weapon_ttt_liftgren = {
            name = "Grenade de Levage",
            desc = [[Une grenade hautement explosive.

            Prudent! Il peut exploser dans votre main si vous
            faites-le cuire trop longtemps!]]
        },
        weapon_ttt_lightningar1 = {
            name = "Foudre AR1",
            desc = [[Un pistolet-guitare!

            Un fusil musical à dégâts élevés avec des animations et des sons très sympas.]]
        },
        weapon_ttt_loudawp = {
            name = "AWP",
            desc = [[Fusil de sniper AWP silencieux.

    N'a que deux tirs.

    Les victimes ne crieront pas lorsqu'elles seront tuées.]]
        },
        weapon_ttt_m16 = {
            name = "M16"
        },
        weapon_ttt_m4a1_s = {
            name = "M4A1 Réduit au Silence",
            desc = [[Un fusil automatique silencieux. Les victimes meurent en silence.]]
        },
        weapon_ttt_malfunctionpistol = {
            name = "Dysfonctionnement du Pistolet",
            desc = [[Force le joueur sur lequel vous tirez à tirer
            une série de coups de feu incontrôlés.]]
        },
        weapon_ttt_mc_healthpotion = {
            name = "Potion de Vie"
        },
        weapon_ttt_mc_immortpotion = {
            name = "Potion D'immortalité"
        },
        weapon_ttt_mc_invispotion = {
            name = "Potion D'invisibilité"
        },
        weapon_ttt_mc_jumppotion = {
            name = "Potion de Fusée"
        },
        weapon_ttt_mc_poison = {
            name = "Poison"
        },
        weapon_ttt_mc_speedpotion = {
            name = "Potion de Vitesse"
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
        weapon_ttt_mine_turtle = {
            name = "Tortue Minière",
            desc = [[Faites un clic gauche pour lancer au sol, faites un clic droit pour placer contre un mur.

            S'arme au bout de quelques secondes, si un autre joueur passe, il explose!]]
        },
        weapon_ttt_minic = {
            name = "Mimer le Générateur",
            desc = [[Lors de son utilisation, transforme des accessoires aléatoires sur la carte en accessoires d'imitation hostiles.

            Ils sautent vers les joueurs et les endommagent au toucher!]]
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
        weapon_ttt_mp5 = {
            name = "MP5 Navy"
        },
        weapon_ttt_mud_device_randomat = {
            name = "Appareil D'analyse de Boue"
        },
        weapon_ttt_nrgoldengun = {
            name = "Daigle Doré",
            desc = [[Tirez sur un traître, tuez un traître.
            Tirez sur un innocent, suicidez-vous.
            Sois prudent.]]
        },
        weapon_ttt_obc = {
            name = "Canon à basse orbitale",
            desc = [[Tirez sur le sol pour invoquer un laser ABSOLUMENT MASSIF après quelques secondes.]]
        },
        weapon_ttt_one_punch = {
            name = "Un Coup de Poing !!!",
            desc = [[Poings mortels d'un seul coup.

            Joue de la musique et change de modèle de lecteur dès que vous le tenez!]]
        },
        weapon_ttt_p228 = {
            name = "P228"
        },
        weapon_ttt_p90 = {
            name = "FN P90",
            desc = [[Pistolet-mitrailleur à tir extrêmement rapide.

    Livré avec une lunette montée.]]
        },
        weapon_ttt_painkillers = {
            name = "Analgésiques",
            desc = [[Accorde un boost de santé qui guérit complètement l'utilisateur mais se désintègre avec le temps.]]
        },
        weapon_ttt_paper_plane = {
            name = "Avion escargot",
            desc = [[Vole sans but jusqu'à ce qu'il trouve un joueur à proximité ne faisant pas partie de votre équipe, puis le poursuit!

            Le joueur entend de la musique une fois poursuivi et est tué au toucher.]]
        },
        weapon_ttt_phy_tracker = {
            name = "Suivi de la Santé"
        },
        weapon_ttt_pickle_rick_gun = {
            name = "Pickle Rick Pistolet",
            desc = [[Tirez sur quelqu'un pour le transformer en cornichon
            et réglez-les sur 1 santé
            
            Faites un clic droit pour vous transformer!]]
        },
        weapon_ttt_pistol = {
            name = "USP"
        },
        weapon_ttt_pistol_randomat = {
            name = "Pistolet à un Coup"
        },
        weapon_ttt_poisonturtlenade = {
            name = "Grenade Tortue Empoisonnée",
            desc = [[Un projectile qui éclate en plusieurs
    tortues empoisonnées hostiles à l'impact.
    Les tortues ne peuvent pas infliger de dégâts létaux,
    mais elles peuvent faire descendre la santé d'un joueur
    à un niveau dangereusement bas.]]
        },
        weapon_ttt_popupgun = {
            name = "Pistolet Contextuel",
            desc = [[SMG à tir rapide. Frapper quelqu'un ouvrira une fenêtre contextuelle sur son écran.]]
        },
        weapon_ttt_printer = {
            name = "Imprimante de crédit",
            desc = [[Dépensez un crédit pour gagner plus de crédits!

            Faites un clic gauche pour placer l'imprimante de crédit au sol et, une fois que c'est fait, appuyez sur 'E' pour obtenir vos crédits !
            
            Fait du bruit une fois posé...]]
        },
        weapon_ttt_prop_disguiser = {
            name = "Déguisement D'accessoires",
            desc = [[Déguisez-vous en objet !

            R: Sélectionnez un objet que vous regardez
            
            Clic gauche: activer le déguisement]]
        },
        weapon_ttt_prop_disguiser_2 = {
            name = "Déguisement D'accessoires 2",
            desc = [[Vous déguise en accessoire mobile !]]
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
        weapon_ttt_pump = {
            name = "Fusil à Pompe"
        },
        weapon_ttt_randomat = {
            name = "Appareil aléatoire 4000",
            desc = [[Le RAppareil aléatoire 4000 fera quelque chose de aléatoire!
            Qui a deviné ça !]]
        },
        weapon_ttt_randomatbeecannon = {
            name = "Canon à Abeilles"
        },
        weapon_ttt_randomatcandycane = {
            name = "Sucre D'orge",
            desc = [[Faites un clic gauche pour convertir un autre joueur]]
        },
        weapon_ttt_randomatclub = {
            name = "Massue"
        },
        weapon_ttt_randomatdetonator = {
            name = "Détonateur"
        },
        weapon_ttt_randomatrevolver = {
            name = "Revolver"
        },
        weapon_ttt_rdmtrocketsciencelauncher = {
            name = "Lance-Roquettes"
        },
        weapon_ttt_revolver = {
            name = "S&W 500",
            desc = [[Élimine n'importe quel terroriste en un seul coup.]]
        },
        weapon_ttt_revolver_randomat = {
            name = "Revolver"
        },
        weapon_ttt_rmgrenade = {
            name = "Bombe de Matière Rouge",
            desc = [[Une grenade en forme de cube qui génère un trou noir!

            Quiconque est trop proche est aspiré!
            
            Sonne une alarme avant que le trou noir n'apparaisse.]]
        },
        weapon_ttt_rocket_thruster = {
            name = "Propulseur de Fusée",
            desc = [[Lance L'utilisateur à L'envers.]]
        },
        weapon_ttt_rollermine = {
            name = "Mine à Rouleaux",
            desc = [[Les Rollermines poursuivront les joueurs,
            faire des dégâts de choc.
            
            Assurez-vous de prévenir vos coéquipiers...]]
        },
        weapon_ttt_rsb = {
            name = "BCD",
            desc = [[Une bombe collante à distance. "Bombe vivante"]]
        },
        weapon_ttt_rsb_defuser = {
            name = "Désamorceur BCD",
            desc = [[Un diffuseur pour la Remote Sticky Bomb]]
        },
        weapon_ttt_seekgull = {
            name = "Mouette en Boîte",
            desc = [[Une grenade hautement explosive.

    Prudent ! Elle peut exploser dans votre main si vous
    la faites cuire trop longtemps !]]
        },
        weapon_ttt_sg550 = {
            name = "SG 550"
        },
        weapon_ttt_sg552 = {
            name = "SG 552"
        },
        weapon_ttt_shocktrap = {
            name = "Piège à Choc",
            desc = [[template]]
        },
        weapon_ttt_signedbook = {
            name = "Livre D'informations"
        },
        weapon_ttt_slam = {
            name = "CLAQUER",
            desc = [[Allez et claque!]]
        },
        weapon_ttt_smg = {
            name = "MP7"
        },
        weapon_ttt_smg_soulbinding = {
            name = "Dispositif de Lien D'âme"
        },
        weapon_ttt_suicide = {
            name = "Bombe suicide",
            desc = [[Sortez en hurlant !

            Tue l'utilisateur et les terroristes environnants.]]
        },
        weapon_ttt_supersheep = {
            name = "Super Mouton",
            desc = [[Laissez voler un mouton volant explosif!

            Votre caméra le suit pendant que vous restez immobile.
            
            Dirigez-le avec votre souris, entrez en collision avec quelque chose pour exploser et appuyez sur 'R' pour augmenter la vitesse.]]
        },
        weapon_ttt_tacticalbrick = {
            name = "Brique Tactique",
            desc = [[Une brique qui peut être lancée pour des raisons tactiques. Toucher quelqu'un à la tête ou charger votre lancer plus longtemps infligera plus de dégâts.]]
        },
        weapon_ttt_teleportgren = {
            name = "Grenade de Téléportation",
            desc = [[Une grenade hautement explosive.

    Prudent ! Elle peut exploser dans votre main si vous
    la faites cuire trop longtemps !]]
        },
        weapon_ttt_tf2_bonesaw = {
            name = "Scie à Os",
            desc = [[Une arme de mêlée à forte frappe !
    Plus de DPS que le pied de biche, vous soigne pendant que vous la tenez !]]
        },
        weapon_ttt_tf2_caber = {
            name = "Caber D'Ullapool",
            desc = [[Plus de DPS que le pied de biche !

    Explose et propulse les joueurs dans les airs au premier coup !]]
        },
        weapon_ttt_tf2_escapeplan = {
            name = "Le Plan D'évasion",
            desc = [[Plus de DPS que le pied de biche !

    Votre vitesse augmente à mesure que votre santé diminue !]]
        },
        weapon_ttt_tf2_eternalreward = {
            name = "Votre Récompense Éternelle",
            desc = [[Touchez quelqu'un par derrière pour un kill instantané !

    Ne laisse pas de corps, prend l'apparence de vos victimes !]]
        },
        weapon_ttt_tf2_eurekaeffect = {
            name = "Effet Eureka",
            desc = [[Plus de DPS que le pied de biche !

    Appuyez sur Recharger pour une téléportation unique vers un point d'apparition !]]
        },
        weapon_ttt_tf2_flamethrower = {
            name = "Lance-Flammes",
            desc = [[Lance-flammes à haut dégât et courte portée !

    Clic droit pour repousser les joueurs et objets]]
        },
        weapon_ttt_tf2_forceanature = {
            name = "Force-A-Nature",
            desc = [[Un double canon qui propulse les joueurs en arrière !]]
        },
        weapon_ttt_tf2_goldenfryingpan = {
            name = "Poêle D'or",
            desc = [[Plus de DPS que le pied de biche !

    Transforme les joueurs tués en statues d'or !]]
        },
        weapon_ttt_tf2_grenadelauncher = {
            name = "Lance-Grenades",
            desc = [[Tire des grenades explosives en arc !]]
        },
        weapon_ttt_tf2_inviswatch = {
            name = "Montre D'invisibilité",
            desc = [[Devenez invisible pendant 10 secondes à charge maximale, et se recharge automatiquement !

    Peut être activée sans être complètement chargée

    Peut être chargée manuellement via les munitions de pistolet, appuyez sur 'R' pour recharger]]
        },
        weapon_ttt_tf2_jarate = {
            name = "Jarate",
            desc = [[Lancez sur les joueurs pour leur faire temporairement subir plus de dégâts !]]
        },
        weapon_ttt_tf2_knife = {
            name = "Couteau D'assassinat",
            desc = [[Touchez quelqu'un par derrière pour un kill instantané !

    Sinon inflige des dégâts normaux]]
        },
        weapon_ttt_tf2_lollichop = {
            name = "Sucette Tranchante",
            desc = [[Une arme de mêlée lente mais qui frappe fort...

    qui vous envoie au Pyroland !]]
        },
        weapon_ttt_tf2_loosecannon = {
            name = "Canon Détaché",
            desc = [[Tire des boulets de canon chargeables !
    Synchronisez bien et touchez un joueur juste au moment où il explose pour un double dégât !]]
        },
        weapon_ttt_tf2_machete = {
            name = "Kukri",
            desc = [[Une arme de mêlée à forte frappe !
    Plus de DPS que le pied de biche !]]
        },
        weapon_ttt_tf2_medigun = {
            name = "Medi Gun",
            desc = [[Soin à distance ! Soigne jusqu'à 100 PV, peut sur-soigner jusqu'à 150

    Après avoir utilisé toutes les munitions, clic droit pour activer l'invincibilité pendant 8 secondes,
    pour vous et votre cible soignée !]]
        },
        weapon_ttt_tf2_minigun = {
            name = "Minigun Lourd",
            desc = [[Une minigun à 200 munitions !
    Les munitions ne peuvent pas être rechargées]]
        },
        weapon_ttt_tf2_pistol = {
            name = "Pistolet TF2",
            desc = [[Un pistolet à tir rapide]]
        },
        weapon_ttt_tf2_rainblower = {
            name = "Souffleur D'arc-en-ciel",
            desc = [[Un merveilleux lance-flammes tirant un arc-en-ciel

    qui vous envoie au Pyroland !]]
        },
        weapon_ttt_tf2_revolver = {
            name = "Revolver de L'Espion",
            desc = [[Un revolver à tir rapide !]]
        },
        weapon_ttt_tf2_rpg = {
            name = "Lance-Roquettes",
            desc = [[Un lance-roquettes !

    Sautez et tirez sur vos pieds pour faire un saut de roquette !]]
        },
        weapon_ttt_tf2_sandman = {
            name = "Le Marchand de Sable",
            desc = [[Une arme de mêlée à frappe rapide !
    Plus de DPS que le pied de biche !

    Clic droit pour lancer une balle de baseball qui ralentit !]]
        },
        weapon_ttt_tf2_scattergun = {
            name = "Scattergun TF2",
            desc = [[Un fusil à pompe à tir rapide et à dispersion serrée !]]
        },
        weapon_ttt_tf2_shortstop = {
            name = "L'Arrêt-court",
            desc = [[Un pistolet-fusil à pompe qui vous permet de bousculer les joueurs !]]
        },
        weapon_ttt_tf2_shotgun = {
            name = "Fusil à Pompe TF2",
            desc = [[Un fusil à pompe standard classique]]
        },
        weapon_ttt_tf2_smg = {
            name = "Pistolet-Mitrailleur TF2",
            desc = [[Un pistolet-mitrailleur standard avec un rechargement très rapide !]]
        },
        weapon_ttt_tf2_sniper = {
            name = "Sniper TF2",
            desc = [[Un puissant fusil de sniper !

    Visez avec le clic droit,
    et restez visé pour charger un tir à plus haut dégât !

    Inflige 50 dégâts sans viser, jusqu'à 80 en visant !]]
        },
        weapon_ttt_tf2_stickybomblauncher = {
            name = "Lanceur de Bombes Collantes",
            desc = [[Tire des bombes collantes !
    Faites-les exploser avec le clic droit

    Vous ne pouvez en avoir que 8 à la fois.]]
        },
        weapon_ttt_tf2_stickyjumper = {
            name = "Lanceur Collant de Saut",
            desc = [[Un lanceur de bombes collantes conçu pour le saut collant !]]
        },
        weapon_ttt_tf2_syringegun = {
            name = "Pistolet à Seringues",
            desc = [[Tire des seringues à haut dégât, avec une portée limitée]]
        },
        weapon_ttt_tf2_tomislav = {
            name = "Tomislav",
            desc = [[Une minigun à 200 munitions !
    Les munitions ne peuvent pas être rechargées, complètement silencieuse et précise]]
        },
        weapon_ttt_timeslowgrenade = {
            name = "Grenade au ralenti",
            desc = [[Grenade qui ralentit temporairement
            temps d'arrêt pour tout le monde
            toute la carte.]]
        },
        weapon_ttt_timestop = {
            name = "Arrêt du Temps",
            desc = [[Gèle le temps pendant quelques secondes.
            Vous pouvez en tuer d'autres pendant qu'ils sont gelés.
            
            N'affecte pas les détectives!]]
        },
        weapon_ttt_titanfall_autopistol = {
            name = "Pistolet Automatique RE-45"
        },
        weapon_ttt_titanfall_wingman = {
            name = "Ailier B3"
        },
        weapon_ttt_tmp_s = {
            name = "Renard Silencieux",
            desc = [[SMG à faible bruit qui utilise des munitions normales de 9 mm.

            Les victimes ne crieront pas lorsqu'elles seront tuées.]]
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
        weapon_ttt_turret = {
            name = "Tourelle",
            desc = [[Générez une tourelle pour tirer sur des ennemis innocents]]
        },
        weapon_ttt_turtlenade = {
            name = "Grenade Tortue",
            desc = [[Grenade à tortue.
            Libère plusieurs tortues hostiles lors de la détonation.]]
        },
        weapon_ttt_whoa_randomat = {
            name = "Attaque Tournante",
            desc = [[Cliquez pour lancer une attaque.]]
        },
        weapon_ttt_wpnjammer = {
            name = "Brouilleur d'armes",
            desc = [[Désactivez complètement l'arme équipée de quelqu'un.

            Pour l'utiliser, appuyez sur 'E' sur une cible tout en sélectionnant n'importe quelle arme.]]
        },
        weapon_ttt_zapgren = {
            name = "Grenade Zap",
            desc = [[Une grenade hautement explosive.

            Prudent! Il peut exploser dans votre main si vous
            faites-le cuire trop longtemps !]]
        },
        weapon_ttt_zombievault = {
            name = "Coffre-fort des PNJ",
            desc = [[Sélectionnez un type de PNJ et jetez-le par terre. Serrures
            en place lorsqu'il est allumé. Plusieurs types de PNJ disponibles.
            Le suivi peut être irrégulier, mais dépend du PNJ
            et l'environnement.
            Grande pièce = errer, petite pièce = tortue.]]
        },
        weapon_tttbasegrenade = {
            name = "Grenade Incendiaire"
        },
        weapon_unoreverse = {
            name = "ONU inversé",
            desc = [[Lors de l'activation, renvoie TOUS LES DOMMAGES à l'attaquant!

            Dure 3 secondes.]]
        },
        weapon_vadim_blink = {
            name = "Clignoter",
            desc = [[Téléportez-vous instantanément là où vous regardez!

            Maintenez le clic gauche pour sélectionner un emplacement, cliquez avec le bouton droit pour annuler.]]
        },
        weapon_vadim_defib = {
            name = "Défibrillateur",
            desc = [[Défibrille les gens.]]
        },
        weapon_valenok = {
            name = "Oscar le Chat",
            desc = [[La 1ère arme blague que vous achetez est gratuite !

            Achetez un chat portable dès aujourd'hui!
            Son nom est "Oscar"]]
        },
        weapon_vam_fangs = {
            name = "Crocs",
            desc = [[Faites un clic gauche pour sucer le sang. Cliquez avec le bouton droit pour faire disparaître.]]
        },
        weapon_welrod = {
            name = "Welrod"
        },
        weapon_whl_buffettable = {
            name = "Table Buffet"
        },
        weapon_whl_spinner = {
            name = "Roue Tournante"
        },
        weapon_wrench = {
            name = "Clé"
        },
        weapon_wwf_claws = {
            name = "Griffes",
            desc = [[Clic gauche pour attaquer. Clic droit pour bondir.]]
        },
        weapon_yeti_club = {
            name = "Massue"
        },
        weapon_ysm_dbshotgun = {
            name = "Double Baril"
        },
        weapon_ysm_guarddog = {
            name = "Chien de Garde"
        },
        weapon_ysm_pie = {
            name = "Tarte"
        },
        weapon_zm_mac10 = {
            name = "MAC10"
        },
        weapon_zm_revolver = {
            name = "Daigle"
        },
        weapon_zm_sledge = {
            name = "É.N.O.R.M.E-249"
        },
        weapon_zom_claws = {
            name = "Les Griffes",
            desc = [[Clic gauche pour attaquer. Faites un clic droit pour sauter. Appuyez sur recharger pour cracher.]]
        },
        weapons_ttt_time_manipulator = {
            name = "Manipulateur de Temps",
            desc = [[Clic gauche: Ralentir le temps.

            Clic droit: accélérer le temps.
            
            R: Réinitialisation à la vitesse normale.]]
        },
        wt_writingpad = {
            name = "Bloc-notes",
            desc = [[La première arme blague que vous achetez une cartouche est gratuite!

            Créez un message sur une pancarte que vous tenez, pour que tout le monde puisse le lire.
             
            Quelle meilleure utilisation de votre crédit ?
             
            R-Modifier
            Clic gauche - Afficher le signe]]
        },
        zombiegunspawn = {
            name = "Pistolet zombie",
            desc = [[Placez 15 Zombies autour de vos ennemis et profitez du désastre!]]
        },
    }

    if debugPrint then
        print("=====Weapons=====")
        local orderedWeaponsString = ""

        -- Sort all weapon translations into alphabetical order by the weapon's classname, and output to a file to copy-paste from
        -- Because we use multi-line strings for the weapon descriptions here, it's waaaay more readable than the passive items...
        for classname, translation in SortedPairs(translatedWeapons) do
            orderedWeaponsString = orderedWeaponsString .. classname .. " = {\n"
            orderedWeaponsString = orderedWeaponsString .. "    name = \"" .. translation.name .. "\""

            if translation.desc then
                orderedWeaponsString = orderedWeaponsString .. ",\n    desc = [[" .. translation.desc .. "]]\n"
            else
                orderedWeaponsString = orderedWeaponsString .. "\n"
            end

            if translation.type then
                orderedWeaponsString = orderedWeaponsString .. "    type = \"" .. translation.type .. "\"\n"
            end

            orderedWeaponsString = orderedWeaponsString .. "},\n"
        end

        file.Write("randomat/french_sorted_weapons.txt", orderedWeaponsString)
    end

    for _, SWEPCopy in ipairs(weapons.GetList()) do
        local classname = WEPS.GetClass(SWEPCopy)
        if not classname then continue end

        if translatedWeapons[classname] then
            local SWEP = weapons.GetStored(classname)
            if not SWEP then continue end

            if SWEP.PrintName then
                if not SWEP.origPrintName then
                    SWEP.origPrintName = SWEP.PrintName
                end

                SWEP.PrintName = translatedWeapons[classname].name
            end

            if SWEP.EquipMenuData and SWEP.EquipMenuData.type then
                if not SWEP.EquipMenuData.origType then
                    SWEP.EquipMenuData.origType = SWEP.EquipMenuData.type
                end

                SWEP.EquipMenuData.type = translatedWeapons[classname].type or "item_weapon"
            end

            if SWEP.EquipMenuData and SWEP.EquipMenuData.desc and translatedWeapons[classname].desc then
                if not SWEP.EquipMenuData.origDesc then
                    SWEP.EquipMenuData.origDesc = SWEP.EquipMenuData.desc
                end

                SWEP.EquipMenuData.desc = translatedWeapons[classname].desc
            end
        else
            local SWEP = weapons.GetStored(classname)
            -- If a weapon is missing SWEP.Kind then it is not a TTT weapon,
            -- If a weapon has an undersocre in its name, it is highly likely using translation strings,
            -- which are handled in the language file itself
            if not SWEP or not SWEP.Kind or not SWEP.PrintName or string.find(SWEP.PrintName, "_") then continue end
            if SWEP.EquipMenuData and SWEP.EquipMenuData.desc and string.find(SWEP.EquipMenuData.desc, "_desc") then continue end

            if debugPrint then
                print(SWEP.PrintName, classname)

                if SWEP.EquipMenuData and SWEP.EquipMenuData.desc then
                    print(SWEP.EquipMenuData.desc)
                    print("")
                end
            end

            if not SWEP.origPrintName then
                SWEP.origPrintName = SWEP.PrintName
            end

            SWEP.PrintName = "Le " .. SWEP.PrintName
        end
    end

    -- Sets the names of held weapons and ones on the ground
    for _, ent in ents.Iterator() do
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

    flagPanelFrame.Paint = function(_, w, h)
        draw.RoundedBox(0, 0, 0, w * 1 / 3, h, Color(0, 36, 150, 10))
        draw.RoundedBox(0, w * 1 / 3, 0, w * 1 / 3, h, Color(255, 255, 255, 10))
        draw.RoundedBox(0, w * 2 / 3, 0, w * 1 / 3, h, Color(237, 40, 57, 10))
    end

    if music then
        surface.PlaySound("french/chic_magnet.mp3")

        timer.Create("FrenchRandomatMusicLoop", 61.7, 0, function()
            surface.PlaySound("french/chic_magnet.mp3")
        end)

        timer.Simple(5, function()
            chat.AddText("\nPress 'M' to mute music!\n\nerr I mean... Appuyez sur 'M' pour couper la musique!")
        end)

        hook.Add("PlayerButtonDown", "FrenchMuteMusicButton", function(_, button)
            if button == KEY_M then
                RunConsoleCommand("stopsound")
                chat.AddText("Music muted")
                music = false
                timer.Remove("FrenchRandomatMusicLoop")
                hook.Remove("PlayerButtonDown", "FrenchMuteMusicButton")
            end
        end)
    end

    hook.Add("ShutDown", "FrenchRandomatLanguageReset", function()
        RunConsoleCommand("ttt_language", "auto")
    end)
end)