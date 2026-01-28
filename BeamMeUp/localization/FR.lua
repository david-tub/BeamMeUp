local BMU = BMU
local SI = BMU.SI

local strings = {
    -----------------------------------------------------------------------------
    -- INTERFACE
    -----------------------------------------------------------------------------
    [SI.TELE_UI_TOTAL      ] = "Résultats :",
    [SI.TELE_UI_GOLD       ] = "Or économisé :",
    [SI.TELE_UI_GOLD_ABBR  ] = "k",
    [SI.TELE_UI_GOLD_ABBR2 ] = "M",
    [SI.TELE_UI_TOTAL_PORTS] = "Total des TP :",
    ---------
    --------- Buttons
    [SI.TELE_UI_BTN_REFRESH_ALL        ] = "Rafraîchir toutes les zones",
    [SI.TELE_UI_BTN_UNLOCK_WS          ] = "Déverrouiller les oratoires de la zone",
    [SI.TELE_UI_BTN_FIX_WINDOW         ] = "Verrouiller / Déverrouiller la fenêtre",
    [SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE  ] = "Basculer vers BeamMeUp",
    [SI.TELE_UI_BTN_TOGGLE_BMU         ] = "Basculer vers le guide de zone",
    [SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE  ] = "Maisons possédées",
    [SI.TELE_UI_BTN_ANCHOR_ON_MAP      ] = "Ancrer à la carte / Libérer",
    [SI.TELE_UI_BTN_GUILD_BMU          ] = "Guildes BeamMeUp & Guildes partenaires",
    [SI.TELE_UI_BTN_GUILD_HOUSE_BMU    ] = "Visiter la maison de guilde BeamMeUp",
    [SI.TELE_UI_BTN_PTF_INTEGRATION    ] = "Integration \"Port to Friend's House\"",
    [SI.TELE_UI_BTN_DUNGEON_FINDER		] = "Arènes / Épreuves / Donjons",
    [SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU] = "\n|c777777(clic droit pour plus d'options)",
    ---------
    --------- List
    [SI.TELE_UI_UNRELATED_ITEMS      ] = "Carte dans d'autres zones",
    [SI.TELE_UI_UNRELATED_QUESTS     ] = "Quêtes dans d'autres zones",
    [SI.TELE_UI_SAME_INSTANCE        ] = "Même instance",
    [SI.TELE_UI_DIFFERENT_INSTANCE   ] = "Instance différente",
    [SI.TELE_UI_GROUP_EVENT          ] = "Événement de groupe",
    ---------
    --------- Menu
    [SI.TELE_UI_FAVORITE_PLAYER         ] = "Joueurs favoris",
    [SI.TELE_UI_FAVORITE_ZONE           ] = "Zones favorites",
    [SI.TELE_UI_VOTE_TO_LEADER          ] = "Votez pour le chef",
    [SI.TELE_UI_RESET_COUNTER_ZONE      ] = "Réinitialiser les compteurs",
    [SI.TELE_UI_INVITE_BMU_GUILD        ] = "Inviter dans la guilde BeamMeUp",
    [SI.TELE_UI_SHOW_QUEST_MARKER_ON_MAP] = "Montrer le marqueur de quête",
    [SI.TELE_UI_RENAME_HOUSE_NICKNAME   ] = "Renommer la maison",
    [SI.TELE_UI_TOGGLE_HOUSE_NICKNAME   ] = "Montrer les noms personnalisés",
    [SI.TELE_UI_VIEW_MAP_ITEM           ] = "Montrer la carte",
    [SI.TELE_UI_TOGGLE_ARENAS			 ] = "Arènes solo",
    [SI.TELE_UI_TOGGLE_GROUP_ARENAS	 ] = "Arènes de groupe",
    [SI.TELE_UI_TOGGLE_TRIALS			 ] = "Épreuves",
    [SI.TELE_UI_TOGGLE_ENDLESS_DUNGEONS ] = "Donjons infinis",
    [SI.TELE_UI_TOGGLE_GROUP_DUNGEONS	 ] = "Donjons de groupe",
    [SI.TELE_UI_TOGGLE_SORT_ACRONYM	 ] = "Tri par acronyme",
    [SI.TELE_UI_DAYS_LEFT				 ] = "%d jours restants",
    [SI.TELE_UI_TOGGLE_UPDATE_NAME      ] = "Afficher le nom de la mise à jour",
    [SI.TELE_UI_UNLOCK_WAYSHRINES		 ] = "Découverte automatique des oratoires",
    [SI.TELE_UI_TOOGLE_ZONE_NAME		 ] = "Afficher le nom de la zone",
    [SI.TELE_UI_TOGGLE_SORT_RELEASE     ] = "Trier par édition",
    [SI.TELE_UI_TOGGLE_ACRONYM          ] = "Afficher les acronymes",
    [SI.TELE_UI_TOOGLE_DUNGEON_NAME     ] = "Afficher le nom de l'instance",
    [SI.TELE_UI_TRAVEL_PARENT_ZONE      ] = "Port to parent zone",
    [SI.TELE_UI_SET_PREFERRED_HOUSE     ] = "Set as preferred house",
    [SI.TELE_UI_UNSET_PREFERRED_HOUSE   ] = "Unset preferred house",



    -----------------------------------------------------------------------------
    -- CHAT OUTPUTS
    -----------------------------------------------------------------------------
    [SI.TELE_CHAT_FAVORITE_UNSET					] = "L'emplacement favori est indéfini.",
    [SI.TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL  	] = "Le joueur est déconnecté ou caché par des filtres.",
    [SI.TELE_CHAT_NO_FAST_TRAVEL    				] = "Aucun voyage rapide trouvé",
    [SI.TELE_CHAT_NOT_IN_GROUP                    	] = "Vous n'êtes pas dans un groupe.",
    [SI.TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED	] = "Aucune résidence principale définie !",
    [SI.TELE_CHAT_GROUP_LEADER_YOURSELF			] = "Vous êtes chef de votre groupe.",
    [SI.TELE_CHAT_UNLOCK_WS_DISCOVERED_TOTAL		] = "Nombre d'oratoires découverts dans cette zone :",
    [SI.TELE_CHAT_UNLOCK_WS_NEED_DISCOVERED		] = "Vous devez toujours vous rendre sur place pour les oratoires suivants :",
    [SI.TELE_CHAT_SHARING_FOLLOW_LINK				] = "Suivre le lien...",
    [SI.TELE_CHAT_AUTO_UNLOCK_CANCELED 		   	] = "Découverte automatique annulée par l'utilisateur.",
    [SI.TELE_CHAT_AUTO_UNLOCK_SKIP				   	] = "Erreur de voyage rapide : omission du joueur courant",



    -----------------------------------------------------------------------------
    -- SETTINGS
    -----------------------------------------------------------------------------
    [SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN] = "Ouvrir BeamMeUp avec la carte",
    [SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP] = "Quand vous ouvrez la carte, BeamMeUp s'ouvre automatiquement aussi. Sinon, un bouton s'affiche en haut à gauche de la carte, et un bouton d'échange dans le guide de zone.",
    [SI.TELE_SETTINGS_ZONE_ONCE_ONLY] = "Montrer une seule fois chaque zone",
    [SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP] = "Montre une seule destination par zone (au lieu de toutes celles possibles).",
    [SI.TELE_SETTINGS_AUTO_PORT_FREQ] = "Vitesse de déverrouillage des oratoires",
    [SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP] = "Adapte automatiquement la vitesse de déverrouillage automatique des oratoires. Des valeurs plus élevées peuvent aider pour éviter d'être déconnecté ou pour des ordinateurs lents.",
    [SI.TELE_SETTINGS_AUTO_REFRESH] = "Réinitialisation à l'ouverture",
    [SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP] = "Mise à jour de la liste des destinations à chaque fois que BeamMeUp est ouvert. Les champs d'entrée sont effacés.",
    [SI.TELE_SETTINGS_HEADER_BLACKLISTING] = "Liste noire",
    [SI.TELE_SETTINGS_HIDE_OTHERS] = "Cacher les diverses zones inaccessibles",
    [SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP] = "Cacher les zones comme l'Arène de Maelstrom, les refuges de hors-la-loi et les zones solo",
    [SI.TELE_SETTINGS_HIDE_PVP] = "Cacher les zones JcJ",
    [SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP] = "Cacher les zones comme Cyrodiil, la Cité Impériale, et les champs de bataille.",
    [SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS] = "Cacher les donjons de groupe et les épreuves",
    [SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP] = "Cacher tous les donjons de groupe à 4 joueurs, les épreuves à 12 joueurs ainsi que les donjons de groupe à Raidelorn. Les membres du groupe dans ces zones seront quand même affichés !",
    [SI.TELE_SETTINGS_HIDE_HOUSES] = "Cacher les maisons",
    [SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP] = "Cacher toutes les maisons",
    [SI.TELE_SETTINGS_WINDOW_STAY] = "Maintenir BeamMeUp ouvert",
    [SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP] = "Quand vous ouvrez BeamMeUp sans la carte, il restera ouvert même si vous bougez ou si vous ouvrez d'autres fenêtres. Si vous activez cette option, il est recommandé de désactiver l'option « Fermer BeamMeUp avec la carte ».",
    [SI.TELE_SETTINGS_ONLY_MAPS] = "Ne montrer que les régions",
    [SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP] = "Montrer seulement les régions principales, comme Deshaan ou le Couchant",
    [SI.TELE_SETTINGS_AUTO_REFRESH_FREQ] = "Intervalle(s) de mise à jour",
    [SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP] = "Quand BeamMeUp est ouvert, une réactualisation automatique des résultats est faite toutes les x secondes. Réglez la valeur sur 0 afin de désactiver l'actualisation automatique.",
    [SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN] = "Focalisation sur la recherche de zone",
    [SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP] = "Mettre le focus sur la boîte de recherche de zone quand BeamMeUp est ouvert avec la carte.",
    [SI.TELE_SETTINGS_HIDE_DELVES] = "Cacher les antres",
    [SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP] = "Cacher tous les antres (exemples : le pic de Taléon, la mine de Crêtombre, etc.)",
    [SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS] = "Cacher les donjons publics",
    [SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP] = "Cacher tous les donjons publics (exemples : les cryptes oubliées, le sanctuaire du Malandrin, etc.)",
    [SI.TELE_SETTINGS_FORMAT_ZONE_NAME] = "Cacher les articles de zone",
    [SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP] = "Cacher les articles ('le', 'la', 'les'...) des noms de zone pour améliorer le tri et vous permettre de trouver les zones plus rapidement.",
    [SI.TELE_SETTINGS_NUMBER_LINES] = "Nombre de lignes à afficher",
    [SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP] = "Changer le nombre de lignes à afficher pour ajuster la hauteur de l'extension.",
    [SI.TELE_SETTINGS_HEADER_ADVANCED] = "Fonctionnalités supplémentaires",
    [SI.TELE_SETTINGS_HEADER_UI] = "Général",
    [SI.TELE_SETTINGS_HEADER_RECORDS] = "Affichages",
    [SI.TELE_SETTINGS_CLOSE_ON_PORTING] = "Fermeture automatique de la carte & BeamMeUp",
    [SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP] = "Fermer automatiquement la carte et BeamMeUp lorsque le processus de voyage rapide commence.",
    [SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS] = "Afficher le nombre de joueurs par carte",
    [SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP] = "Montre le nombre de joueurs par carte vers qui vous pouvez voyager. Vous pouvez cliquer sur ce nombre pour voir tous ces joueurs.",
    [SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET] = "Décalage du bouton dans la fenêtre de tchat",
    [SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP] = "Augmente le décalage horizontal du raccourci dans la barre des titres de la fenêtre de tchat pour éviter les conflits visuels avec les icônes d'autres extensions.",
    [SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES] = "Rechercher aussi le nom des personnages",
    [SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP] = "Recherche également le nom des personnages lorsqu'une recherche de joueurs est effectuée.",
    [SI.TELE_SETTINGS_SORTING] = "Options de tri",
    [SI.TELE_SETTINGS_SORTING_TOOLTIP] = "Choisissez l'une des options de tri possibles dans la liste.",
    [SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE] = "Deuxième langue de recherche",
    [SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP] = "Vous pouvez effectuer vos recherches par nom de zone dans la langue de votre client et dans cette seconde langue en même temps. L'infobulle du nom de la zone affiche également le nom dans la langue secondaire.",
    [SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE] = "Notification de connexion de joueur favoris",
    [SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP] = "Vous recevrez une notification (message au centre de votre écran) lorsqu'un joueur configuré en favoris se connecte au serveur.",
    [SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE] = "Fermer BeamMeUp à la fermeture de la carte",
    [SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP] = "Lorsque vous fermez la carte, BeamMeUp se ferme également.",
    [SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL] = "Décalage de l'ancrage à la carte - horizontal",
    [SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP] = "Ici vous pouvez configurer le décalage horizontal de la fenêtre de l'extension ancrée à la carte.",
    [SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL] = "Décalage de l'ancrage à la carte - vertical",
    [SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP] = "Ici vous pouvez configurer le décalage vertical de la fenêtre de l'extension ancrée à la carte.",
    [SI.TELE_SETTINGS_RESET_ALL_COUNTERS] = "Réinitialiser les compteurs",
    [SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP] = "Tous les compteurs de zone sont remis à zéro. Par conséquent, le tri des zones les plus utilisées est également réinitialisé.",
    [SI.TELE_SETTINGS_OFFLINE_NOTE] = "Rappel hors-ligne",
    [SI.TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP] = "Si vous vous êtes mis hors ligne depuis un certain temps et que vous chuchotez ou voyagez jusqu'à quelqu'un, vous aurez un petit message de rappel à l'écran. Tant que vous êtes en hors ligne, vous ne pouvez recevoir de message chuchoté, et personne ne peut voyager jusqu'à vous (mais le partage, c'est la vie !).",
    [SI.TELE_SETTINGS_SCALE] = "Échelle IU",
    [SI.TELE_SETTINGS_SCALE_TOOLTIP] = "Facteur d'échelle de la fenêtre/IU entière de BeamMeUp. Il sera nécessaire de recharger l'interface utilisateur pour appliquer les modifications.",
    [SI.TELE_SETTINGS_RESET_UI] = "Réinitialiser l'IU",
    [SI.TELE_SETTINGS_RESET_UI_TOOLTIP] = "Réinitialiser l'interface utilisateur de BeamMeUp en remettant les options suivantes à leur valeur par défaut : Échelle IU, Décalage du bouton, Décalages de l'ancrage et Positions de la fenêtre. La totalité de l'IU sera rechargée.",
    [SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION] = "Notification de repérage",
    [SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP] = "Si vous récoltez un repérage et qu'il reste encore des cartes identiques (même endroit) dans votre inventaire, une notification (message au centre de l'écran) vous en avertira.",
    [SI.TELE_SETTINGS_HEADER_PRIO] = "Priorisation",
    [SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS] = "Commandes de tchat",
    [SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION] = "Ici, vous pouvez configurer vers quel joueur se téléporter de préférence. Après avoir rejoint ou quitté une guilde, un rechargement de l'UI est nécessaire pour mettre à jour l'affichage.",
    [SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP] = "Bouton supplémentaire sur la carte",
    [SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP] = "Afficher un bouton texte supplémentaire dans le coin en haut à gauche de la carte du monde, pour ouvrir BeamMeUp.",
    [SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND] = "Jouer un son",
    [SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP] = "Jouer un son en affichant la notification.",
    [SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL] = "Auto-confirmation du voyage vers un oratoire",
    [SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP] = "Désactive le dialogue de confirmation quand vous vous téléportez vers d'autres oratoires.",
    [SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP] = "Afficher d'abord la zone courante",
    [SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP] = "Toujours afficher la zone courante en début de liste.",
    [SI.TELE_SETTINGS_HIDE_OWN_HOUSES] = "Cacher MES maisons",
    [SI.TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP] = "Cache vos propres maisons (téléportation à l'extérieur) dans la liste principale.",
    [SI.TELE_SETTINGS_HEADER_STATS] = "Statistiques",
    [SI.TELE_SETTINGS_MOST_PORTED_ZONES] = "Zones les plus fréquentes :",
    [SI.TELE_SETTINGS_INSTALLED_SCINCE] = "Installé au moins depuis :",
    [SI.TELE_SETTINGS_INFO_CHARACTER_DEPENDING] = "Cette option est uniquement liée à ce personnage.",
    [SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION] = "Animation de la téléportation",
    [SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP] = "Affiche une animation supplémentaire de téléportation lorsque vous entamez un voyage rapide par BeamMeUp. L'objet de collection 'Babiole de Finvir' doit être déverrouillé.",
    [SI.TELE_SETTINGS_SHOW_CHAT_BUTTON] = "Bouton dans la fenêtre de discussion",
    [SI.TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP] = "Affiche un bouton dans l'en-tête de la fenêtre de discussion pour ouvrir BeamMeUp.",
    [SI.TELE_SETTINGS_USE_PAN_AND_ZOOM] = "Panoramique et zoom",
    [SI.TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP] = "Panoramique et zoom vers la destination sur la carte quand vous cliquez sur des membres du groupe ou des zones spécifiques (donjons, maisons, etc.).",
    [SI.TELE_SETTINGS_USE_RALLY_POINT] = "Signe de carte",
    [SI.TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP] = "Affiche un signe sur la carte (point de ralliement) à la destination sur la carte quand vous cliquez sur des membres du groupe ou des zones spécifiques (donjons, maisons, etc.). La librairie LibMapPing doit être installée. De plus, rappelez-vous : si vous êtes le chef de groupe, vos signes (points de ralliement) sont visibles pour tous les membres du groupe.",
    [SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS] = "Montrer les zones sans joueur ni maison",
    [SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP] = "Montre les zones de la liste principale, même si il n'y a ni joueur ni maison vers lesquels vous puissiez voyager. Vous avez toujours la possibilité de voyager contre de l'or si vous avez découvert au moins un oratoire dans la zone.",
    [SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP] = "Afficher les zones et sous-zones en premier",
    [SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP_TOOLTIP] = "Affiche les zones et les sous-zones actuellement affichées (carte du monde ouverte) toujours en début de liste.",
    [SI.TELE_SETTINGS_DEFAULT_TAB] = "Default list",
    [SI.TELE_SETTINGS_DEFAULT_TAB_TOOLTIP] = "The list that is displayed by default when opening BeamMeUp.",
    [SI.TELE_SETTINGS_HEADER_CHAT_OUTPUT] = "Chat Output",
    [SI.TELE_SETTINGS_OUTPUT_FAST_TRAVEL] = "Fast travel executions",
    [SI.TELE_SETTINGS_OUTPUT_FAST_TRAVEL_TOOLTIP] = "Informative chat messages about the initiated fast travels. Error messages are still displayed in the chat.",
    [SI.TELE_SETTINGS_OUTPUT_ADDITIONAL] = "Supporting messages",
    [SI.TELE_SETTINGS_OUTPUT_ADDITIONAL_TOOLTIP] = "Further helpful chat messages on various actions of the addon.",
    [SI.TELE_SETTINGS_OUTPUT_UNLOCK] = "Automatic discovery results",
    [SI.TELE_SETTINGS_OUTPUT_UNLOCK_TOOLTIP] = "Interim results (discovered wayshrines and XP) and supporting messages of the automatic wayshrine discovery.",
    [SI.TELE_SETTINGS_OUTPUT_DEBUG] = "Debug messages",
    [SI.TELE_SETTINGS_OUTPUT_DEBUG_TOOLTIP] = "Technical messages for troubleshooting. It will spam your chat. Please use only on request for short time!",


    -----------------------------------------------------------------------------
    -- KEY BINDING
    -----------------------------------------------------------------------------
    [SI.TELE_KEYBINDING_TOGGLE_MAIN] = "Ouvrir BeamMeUp",
    [SI.TELE_KEYBINDING_TOGGLE_MAIN_RELATED_ITEMS] = "Cartes au trésor, Repérages & Pistes",
    [SI.TELE_KEYBINDING_REFRESH] = "Actualiser",
    [SI.TELE_KEYBINDING_WAYSHRINE_UNLOCK] = "Déblocage des oratoires",
    [SI.TELE_KEYBINDING_PRIMARY_RESIDENCE] = "Se téléporter à l'intérieur de la résidence principale",
    [SI.TELE_KEYBINDING_GUILD_HOUSE_BMU] = "Visiter la maison de guilde BeamMeUp",
    [SI.TELE_KEYBINDING_CURRENT_ZONE] = "Voyage dans la zone actuelle",
    [SI.TELE_KEYBINDING_PRIMARY_RESIDENCE_OUTSIDE] = "Se téléporter à l'extérieur de la résidence principale",
    [SI.TELE_KEYBINDING_TOGGLE_MAIN_DUNGEON_FINDER] = "Arènes / Épreuves / Donjons",
    [SI.TELE_KEYBINDING_TRACKED_QUEST] = "Voyage vers la quête courante",
    [SI.TELE_KEYBINDING_ANY_ZONE] = "Téléportation vers zone aléatoire",
    [SI.TELE_KEYBINDING_WAYSHRINE_FAVORITE] = "Wayshrine Favorite",


    -----------------------------------------------------------------------------
    -- DIALOGS | NOTIFICATIONS
    -----------------------------------------------------------------------------
    [SI.TELE_DIALOG_NO_BMU_GUILD_BODY] = "Nous sommes désolés, mais il semblerait qu'il n'y a pas encore de guilde BeamMeUp active sur ce serveur.\n\nN'hésitez pas à nous contacter via le site ESOUI afin qu'une guilde officielle BeamMeUp soit créée sur ce serveur.",
    [SI.TELE_DIALOG_INFO_BMU_GUILD_BODY] = "Bonjour et merci d'utiliser BeamMeUp. En 2019, nous avons créé plusieurs guildes BeamMeUp dans le but de partager librement nos options de voyage rapide. Toutle monde est bienvenu, aucun prérequis ni obligation !\n\nEn confirmant cette boîte de dialogue, vous verrez les guildes officielles BeamMeUp et les guildes partenaires. Nous vous invitons cordialement à nous rejoindre ! Vous pouvez aussi afficher les guildes en cliquant sur le bouton guilde dans le coin en haut à gauche.\nVotre équipe BeamMeUp",
    [SI.TELE_DIALOG_INFO_NEW_FEATURE_FAVORITE_PLAYER_NOTIFICATION] = "Vous recevez une notification (message au centre de l'écran) quand un joueur favori se connecte.\n\nActiver cette fonctionnalité ?",
    [SI.TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION] = "Si vous récoltez un repérage et qu'il reste encore des cartes identiques (même endroit) dans votre inventaire, une notification (message au centre de l'écran) vous en avertira.\n\nActiver cette fonctionnalité ?",
    [SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE] = "Integration de \"Port to Friend's House\"",
    [SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY] = "Pour utiliser la fonctionnalité d'intégration, installez l'extension \"Port to Friend's House\". Vos maisons et manoirs de guilde configurés apparaitront alors dans cette liste.\n\nVoulez-vous accéder au site de l'extension ?",
    -- AUTO UNLOCK: Start Dialog
    [SI.TELE_DIALOG_AUTO_UNLOCK_TITLE] = "Commencer le déverrouillage automatique des oratoires ?",
    [SI.TELE_DIALOG_AUTO_UNLOCK_BODY] = "Après confirmation, BeamMeUp commencera à voyager vers tous les joueurs disponibles dans la zone courante. De cette façon, vous sauterez automatiquement d'oratoire en oratoire pour en déverrouiller autant que possible.",
    [SI.TELE_DIALOG_AUTO_UNLOCK_LOOP_OPTION] = "Parcours des zones ...",
    [SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION1] = "Ordre aléatoire",
    [SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION2] = "Par taux d'oratoires inconnus",
    [SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION3] = "Par nombre de joueurs",
    [SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION4] = "par nom de zone",
    [SI.TELE_DIALOG_AUTO_UNLOCK_CHAT_LOG_OPTION] = "Résultats dans le tchat",
    -- AUTO UNLOCK: Refuse Dialogs
    [SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE] = "La découverte n'est pas possible",
    [SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY] = "Tous les oratoires de la zone ont été découverts.",
    [SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2] = "La découverte des oratoires n'est pas disponible dans cette zone. Cette fonctionnalité n'est disponible que dans les zones et régions principales.",
    [SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY3] = "Malheureusement, il n'y a pas de joueurs dans la zone vers lequel voyager.",
    -- AUTO UNLOCK: Process Dialog
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART] = "Découverte automatique des oratoires en cours...",
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY] = "Nouveaux oratoires découverts :",
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP] = "XP gagnés :",
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_PROGRESS] = "Avancement :",
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_TIMER] = "Prochain saut dans :",
    -- AUTO UNLOCK: Finish Dialog
    [SI.TELE_DIALOG_FINISH_AUTO_UNLOCK_BODY_PART] = "Découverte automatique des oratoires terminé.",
    -- AUTO UNLOCK: Timeout Dialog
    [SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_TITLE] = "Temps dépassé",
    [SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_BODY] = "Désolé - une erreur inconnue est survenue. La découverte automatique a été annulée.",
    -- AUTO UNLOCK: Loop Finish Dialog
    [SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE] = "Découverte automatique terminée",
    [SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY] = "Pas d'autres zones à découvrir. Soit il n'y a plus de joueurs dans les zones, ou vous avez déjà découvert tous les oratoires.",



    -----------------------------------------------------------------------------
    -- CENTER SCREEN NOTIFICATIONS
    -----------------------------------------------------------------------------
    [SI.TELE_CENTERSCREEN_OFFLINE_NOTE_HEAD] = "Vous êtes encore en mode hors-ligne !",
    [SI.TELE_CENTERSCREEN_OFFLINE_NOTE_BODY] = "Personne ne peut chuchoter ou voyager vers vous !\n|c8c8c8c(Notification suppressible dans les options de BeamMeUp)",
    [SI.TELE_CENTERSCREEN_SURVEY_MAPS] = "Il vous reste %d de ces repérages. Revenez après régénération !",
    [SI.TELE_CENTERSCREEN_FAVORITE_PLAYER_ONLINE] = "est maintenant en ligne !",



    -----------------------------------------------------------------------------
    -- ITEM NAMES (PART OF IT) - BACKUP
    -----------------------------------------------------------------------------
    [SI.CONSTANT_TREASURE_MAP] = "carte au trésor", -- need a part of the item name that is in every treasure map item the same no matter which zone
    [SI.CONSTANT_SURVEY_MAP] = "repérages", -- need a part of the item name that is in every survey map item the same no matter which zone and kind of craft

    -----------------------------------------------------------------------------
    -- LibScrollableMenu - Context menu strings --INS260127 Baertram
    -----------------------------------------------------------------------------
    [SI.CONSTANT_LSM_CLICK_SUBMENU_TOGGLE_ALL] = "Toggle all submenu entries ON/OFF", --todo 260127
}

local overrideStr = SafeAddString --do not overwrite with ZO_AddString, but just create a new version to override the exiitng ones created with ZO_CreateStringId!
for k, v in pairs(strings) do
    overrideStr(_G[k], v, 2)
end