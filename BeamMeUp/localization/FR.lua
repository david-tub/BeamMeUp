local mkstr = ZO_CreateStringId
local SI = BMU.SI

-----------------------------------------------------------------------------
-- INTERFACE
-----------------------------------------------------------------------------
mkstr(SI.TELE_UI_TOTAL      , "Résultats :"   )
mkstr(SI.TELE_UI_GOLD       , "Or économisé :")
mkstr(SI.TELE_UI_GOLD_ABBR  , "k"             )
mkstr(SI.TELE_UI_GOLD_ABBR2 , "M"             )
mkstr(SI.TELE_UI_TOTAL_PORTS, "Total des TP :")
---------
--------- Buttons
mkstr(SI.TELE_UI_BTN_REFRESH_ALL        , "Rafraîchir toutes les zones"           )
mkstr(SI.TELE_UI_BTN_UNLOCK_WS          , "Déverrouiller les oratoires de la zone")
mkstr(SI.TELE_UI_BTN_FIX_WINDOW         , "Verrouiller / Déverrouiller la fenêtre")
mkstr(SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE  , "Basculer vers BeamMeUp"                )
mkstr(SI.TELE_UI_BTN_TOGGLE_BMU         , "Basculer vers le guide de zone"        )
mkstr(SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE  , "Maisons possédées"                     )
mkstr(SI.TELE_UI_BTN_ANCHOR_ON_MAP      , "Ancrer à la carte / Libérer"           )
mkstr(SI.TELE_UI_BTN_GUILD_BMU          , "Guildes BeamMeUp & Guildes partenaires")
mkstr(SI.TELE_UI_BTN_GUILD_HOUSE_BMU    , "Visiter la maison de guilde BeamMeUp"  )
mkstr(SI.TELE_UI_BTN_PTF_INTEGRATION    , "Integration \"Port to Friend's House\"")
mkstr(SI.TELE_UI_BTN_DUNGEON_FINDER		, "Arènes / Épreuves / Donjons")
mkstr(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU, "\n|c777777(clic droit pour plus d'options)")
---------
--------- List
mkstr(SI.TELE_UI_UNRELATED_ITEMS      , "Carte dans d'autres zones"  )
mkstr(SI.TELE_UI_UNRELATED_QUESTS     , "Quêtes dans d'autres zones" )
mkstr(SI.TELE_UI_SAME_INSTANCE        , "Même instance"              )
mkstr(SI.TELE_UI_DIFFERENT_INSTANCE   , "Instance différente"        )
mkstr(SI.TELE_UI_GROUP_EVENT          , "Événement de groupe"        )
---------
--------- Menu
mkstr(SI.TELE_UI_FAVORITE_PLAYER         , "Joueurs favoris")
mkstr(SI.TELE_UI_FAVORITE_ZONE           , "Zones favorites")
mkstr(SI.TELE_UI_REMOVE_FAVORITE_PLAYER  , "Enlever le joueur des favoris")
mkstr(SI.TELE_UI_REMOVE_FAVORITE_ZONE    , "Enlever la zone des favoris")
mkstr(SI.TELE_UI_VOTE_TO_LEADER          , "Votez pour le chef")
mkstr(SI.TELE_UI_RESET_COUNTER_ZONE      , "Réinitialiser les compteurs")
mkstr(SI.TELE_UI_INVITE_BMU_GUILD        , "Inviter dans la guilde BeamMeUp")
mkstr(SI.TELE_UI_SHOW_QUEST_MARKER_ON_MAP, "Montrer le marqueur de quête")
mkstr(SI.TELE_UI_RENAME_HOUSE_NICKNAME   , "Renommer la maison")
mkstr(SI.TELE_UI_TOGGLE_HOUSE_NICKNAME   , "Montrer les noms personnalisés")
mkstr(SI.TELE_UI_VIEW_MAP_ITEM           , "Montrer la carte")
mkstr(SI.TELE_UI_TOGGLE_ARENAS			 , "Arènes solo")
mkstr(SI.TELE_UI_TOGGLE_GROUP_ARENAS	 , "Arènes de groupe")
mkstr(SI.TELE_UI_TOGGLE_TRIALS			 , "Épreuves")
mkstr(SI.TELE_UI_TOGGLE_ENDLESS_DUNGEONS , "Endless Dungeons")
mkstr(SI.TELE_UI_TOGGLE_GROUP_DUNGEONS	 , "Donjons de groupe")
mkstr(SI.TELE_UI_TOGGLE_SORT_ACRONYM	 , "Tri par acronyme")
mkstr(SI.TELE_UI_DAYS_LEFT				 , "%d jours restants")
mkstr(SI.TELE_UI_TOGGLE_UPDATE_NAME      , "Show update name")
mkstr(SI.TELE_UI_UNLOCK_WAYSHRINES		 , "Découverte automatique des oratoires")
mkstr(SI.TELE_UI_SUBMENU_FAVORITES       , "Favoris")
mkstr(SI.TELE_UI_TOOGLE_ZONE_NAME		 , "Show zone name")
mkstr(SI.TELE_UI_TOGGLE_SORT_RELEASE     , "Sort by release")
mkstr(SI.TELE_UI_TOGGLE_ACRONYM          , "Show acronym")
mkstr(SI.TELE_UI_TOOGLE_DUNGEON_NAME     , "Show instance name")



-----------------------------------------------------------------------------
-- CHAT OUTPUTS
-----------------------------------------------------------------------------
mkstr(SI.TELE_CHAT_FAVORITE_UNSET					, "L'emplacement favori est indéfini."                                                                                                           )
mkstr(SI.TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL  	, "Le joueur est déconnecté ou caché par des filtres."                                                                                           )
mkstr(SI.TELE_CHAT_NO_FAST_TRAVEL    				, "Aucun voyage rapide trouvé"                                                                                                                   )
mkstr(SI.TELE_CHAT_NOT_IN_GROUP                    	, "Vous n'êtes pas dans un groupe."                                                                                                              )
mkstr(SI.TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED	, "Aucune résidence principale définie !"                                                                                                        )
mkstr(SI.TELE_CHAT_GROUP_LEADER_YOURSELF			, "Vous êtes chef de votre groupe."                                                                                                              )
mkstr(SI.TELE_CHAT_UNLOCK_WS_DISCOVERED_TOTAL		, "Nombre d'oratoires découverts dans cette zone :"                                                                                              )
mkstr(SI.TELE_CHAT_UNLOCK_WS_NEED_DISCOVERED		, "Vous devez toujours vous rendre sur place pour les oratoires suivants :"                                                                      )
mkstr(SI.TELE_CHAT_SHARING_FOLLOW_LINK				, "Suivre le lien..."                                                                                                                            )
mkstr(SI.TELE_CHAT_AUTO_UNLOCK_CANCELED 		   	, "Découverte automatique annulée par l'utilisateur.")
mkstr(SI.TELE_CHAT_AUTO_UNLOCK_SKIP				   	, "Erreur de voyage rapide : omission du joueur courant")



-----------------------------------------------------------------------------
-- SETTINGS
-----------------------------------------------------------------------------
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN, "Ouvrir BeamMeUp avec la carte")
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP, "Quand vous ouvrez la carte, BeamMeUp s'ouvre automatiquement aussi. Sinon, un bouton s'affiche en haut à gauche de la carte, et un bouton d'échange dans le guide de zone.")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY, "Montrer une seule fois chaque zone")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP, "Montre une seule destination par zone (au lieu de toutes celles possibles).")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ, "Vitesse de déverrouillage des oratoires")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP, "Adapte automatiquement la vitesse de déverrouillage automatique des oratoires. Des valeurs plus élevées peuvent aider pour éviter d'être déconnecté ou pour des ordinateurs lents.")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH, "Réinitialisation à l'ouverture")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP, "Mise à jour de la liste des destinations à chaque fois que BeamMeUp est ouvert. Les champs d'entrée sont effacés.")
mkstr(SI.TELE_SETTINGS_HEADER_BLACKLISTING, "Liste noire")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS, "Cacher les diverses zones inaccessibles")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP, "Cacher les zones comme l'Arène de Maelstrom, les refuges de hors-la-loi et les zones solo")
mkstr(SI.TELE_SETTINGS_HIDE_PVP, "Cacher les zones JcJ")
mkstr(SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP, "Cacher les zones comme Cyrodiil, la Cité Impériale, et les champs de bataille.")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS, "Cacher les donjons de groupe et les épreuves")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP, "Cacher tous les donjons de groupe à 4 joueurs, les épreuves à 12 joueurs ainsi que les donjons de groupe à Raidelorn. Les membres du groupe dans ces zones seront quand même affichés !")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES, "Cacher les maisons")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP, "Cacher toutes les maisons")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY, "Maintenir BeamMeUp ouvert")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP, "Quand vous ouvrez BeamMeUp sans la carte, il restera ouvert même si vous bougez ou si vous ouvrez d'autres fenêtres. Si vous activez cette option, il est recommandé de désactiver l'option « Fermer BeamMeUp avec la carte ».")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS, "Ne montrer que les régions")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP, "Montrer seulement les régions principales, comme Deshaan ou le Couchant")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ, "Intervalle(s) de mise à jour")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP, "Quand BeamMeUp est ouvert, une réactualisation automatique des résultats est faite toutes les x secondes. Réglez la valeur sur 0 afin de désactiver l'actualisation automatique.")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN, "Focalisation sur la recherche de zone")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP, "Mettre le focus sur la boîte de recherche de zone quand BeamMeUp est ouvert avec la carte.")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES, "Cacher les antres")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP, "Cacher tous les antres (exemples : le pic de Taléon, la mine de Crêtombre, etc.)")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS, "Cacher les donjons publics")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP, "Cacher tous les donjons publics (exemples : les cryptes oubliées, le sanctuaire du Malandrin, etc.)")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME, "Cacher les articles de zone")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP, "Cacher les articles ('le', 'la', 'les'...) des noms de zone pour améliorer le tri et vous permettre de trouver les zones plus rapidement.")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES, "Nombre de lignes à afficher")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP, "Changer le nombre de lignes à afficher pour ajuster la hauteur de l'extension.")
mkstr(SI.TELE_SETTINGS_HEADER_ADVANCED, "Fonctionnalités supplémentaires")
mkstr(SI.TELE_SETTINGS_HEADER_UI, "Général")
mkstr(SI.TELE_SETTINGS_HEADER_RECORDS, "Affichages")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING, "Fermeture automatique de la carte & BeamMeUp")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP, "Fermer automatiquement la carte et BeamMeUp lorsque le processus de voyage rapide commence.")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS, "Afficher le nombre de joueurs par carte")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP, "Montre le nombre de joueurs par carte vers qui vous pouvez voyager. Vous pouvez cliquer sur ce nombre pour voir tous ces joueurs.")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET, "Décalage du bouton dans la fenêtre de tchat")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP, "Augmente le décalage horizontal du raccourci dans la barre des titres de la fenêtre de tchat pour éviter les conflits visuels avec les icônes d'autres extensions.")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES, "Rechercher aussi le nom des personnages")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP, "Recherche également le nom des personnages lorsqu'une recherche de joueurs est effectuée.")
mkstr(SI.TELE_SETTINGS_SORTING, "Options de tri")
mkstr(SI.TELE_SETTINGS_SORTING_TOOLTIP, "Choisissez l'une des options de tri possibles dans la liste.")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE, "Deuxième langue de recherche")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP, "Vous pouvez effectuer vos recherches par nom de zone dans la langue de votre client et dans cette seconde langue en même temps. L'infobulle du nom de la zone affiche également le nom dans la langue secondaire.")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE, "Notification de connexion de joueur favoris")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP, "Vous recevrez une notification (message au centre de votre écran) lorsqu'un joueur configuré en favoris se connecte au serveur.")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE, "Fermer BeamMeUp à la fermeture de la carte")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP, "Lorsque vous fermez la carte, BeamMeUp se ferme également.")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL, "Décalage de l'ancrage à la carte - horizontal")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP, "Ici vous pouvez configurer le décalage horizontal de la fenêtre de l'extension ancrée à la carte.")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL, "Décalage de l'ancrage à la carte - vertical")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP, "Ici vous pouvez configurer le décalage vertical de la fenêtre de l'extension ancrée à la carte.")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS, "Réinitialiser les compteurs")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP, "Tous les compteurs de zone sont remis à zéro. Par conséquent, le tri des zones les plus utilisées est également réinitialisé.")
mkstr(SI.TELE_SETTINGS_OFFLINE_NOTE, "Rappel hors-ligne")
mkstr(SI.TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP, "Si vous vous êtes mis hors ligne depuis un certain temps et que vous chuchotez ou voyagez jusqu'à quelqu'un, vous aurez un petit message de rappel à l'écran. Tant que vous êtes en hors ligne, vous ne pouvez recevoir de message chuchoté, et personne ne peut voyager jusqu'à vous (mais le partage, c'est la vie !).")
mkstr(SI.TELE_SETTINGS_SCALE, "Échelle IU")
mkstr(SI.TELE_SETTINGS_SCALE_TOOLTIP, "Facteur d'échelle de la fenêtre/IU entière de BeamMeUp. Il sera nécessaire de recharger l'interface utilisateur pour appliquer les modifications.")
mkstr(SI.TELE_SETTINGS_RESET_UI, "Réinitialiser l'IU")
mkstr(SI.TELE_SETTINGS_RESET_UI_TOOLTIP, "Réinitialiser l'interface utilisateur de BeamMeUp en remettant les options suivantes à leur valeur par défaut : Échelle IU, Décalage du bouton, Décalages de l'ancrage et Positions de la fenêtre. La totalité de l'IU sera rechargée.")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION, "Notification de repérage")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP, "Si vous récoltez un repérage et qu'il reste encore des cartes identiques (même endroit) dans votre inventaire, une notification (message au centre de l'écran) vous en avertira.")
mkstr(SI.TELE_SETTINGS_HEADER_PRIO, "Priorisation")
mkstr(SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS, "Commandes de tchat")
mkstr(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT, "Limiter les messages dans le tchat")
mkstr(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT_TOOLTIP, "Réduire le nombre de messages dans le tchat lors de l'utilisation de la fonctionnalité d'auto-découverte.")
mkstr(SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION, "Ici, vous pouvez configurer vers quel joueur se téléporter de préférence. Après avoir rejoint ou quitté une guilde, un rechargement de l'UI est nécessaire pour mettre à jour l'affichage.")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP, "Bouton supplémentaire sur la carte")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP, "Afficher un bouton texte supplémentaire dans le coin en haut à gauche de la carte du monde, pour ouvrir BeamMeUp.")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND, "Jouer un son")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP, "Jouer un son en affichant la notification.")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL, "Auto-confirmation du voyage vers un oratoire")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP, "Désactive le dialogue de confirmation quand vous vous téléportez vers d'autres oratoires.")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP, "Afficher d'abord la zone courante")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP, "Toujours afficher la zone courante en début de liste.")
mkstr(SI.TELE_SETTINGS_HIDE_OWN_HOUSES, "Cacher MES maisons")
mkstr(SI.TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP, "Cache vos propres maisons (téléportation à l'extérieur) dans la liste principale.")
mkstr(SI.TELE_SETTINGS_HEADER_STATS, "Statistiques")
mkstr(SI.TELE_SETTINGS_MOST_PORTED_ZONES, "Zones les plus fréquentes :")
mkstr(SI.TELE_SETTINGS_INSTALLED_SCINCE, "Installé au moins depuis :")
mkstr(SI.TELE_SETTINGS_INFO_CHARACTER_DEPENDING, "Cette option est uniquement liée à ce personnage.")
mkstr(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION, "Animation de la téléportation")
mkstr(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP, "Affiche une animation supplémentaire de téléportation lorsque vous entamez un voyage rapide par BeamMeUp. L'objet de collection 'Babiole de Finvir' doit être déverrouillé.")
mkstr(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON, "Bouton dans la fenêtre de discussion")
mkstr(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP, "Affiche un bouton dans l'en-tête de la fenêtre de discussion pour ouvrir BeamMeUp.")
mkstr(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM, "Panoramique et zoom")
mkstr(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP, "Panoramique et zoom vers la destination sur la carte quand vous cliquez sur des membres du groupe ou des zones spécifiques (donjons, maisons, etc.).")
mkstr(SI.TELE_SETTINGS_USE_RALLY_POINT, "Signe de carte")
mkstr(SI.TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP, "Affiche un signe sur la carte (point de ralliement) à la destination sur la carte quand vous cliquez sur des membres du groupe ou des zones spécifiques (donjons, maisons, etc.). La librairie LibMapPing doit être installée. De plus, rappelez-vous : si vous êtes le chef de groupe, vos signes (points de ralliement) sont visibles pour tous les membres du groupe.")
mkstr(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS, "Montrer les zones sans joueur ni maison")
mkstr(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP, "Montre les zones de la liste principale, même si il n'y a ni joueur ni maison vers lesquels vous puissiez voyager. Vous avez toujours la possibilité de voyager contre de l'or si vous avez découvert au moins un oratoire dans la zone.")
mkstr(SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP, "Show displayed zone & subzones always on top")
mkstr(SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP_TOOLTIP, "Show currently displayed zone and subzones (opened world map) always on top of the list.")


-----------------------------------------------------------------------------
-- KEY BINDING
-----------------------------------------------------------------------------
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN, "Ouvrir BeamMeUp")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_RELATED_ITEMS, "Cartes au trésor, Repérages & Pistes")
mkstr(SI.TELE_KEYBINDING_REFRESH, "Actualiser")
mkstr(SI.TELE_KEYBINDING_WAYSHRINE_UNLOCK, "Déblocage des oratoires")
mkstr(SI.TELE_KEYBINDING_PRIMARY_RESIDENCE, "Se téléporter à l'intérieur de la résidence principale")
mkstr(SI.TELE_KEYBINDING_GUILD_HOUSE_BMU, "Visiter la maison de guilde BeamMeUp")
mkstr(SI.TELE_KEYBINDING_CURRENT_ZONE, "Voyage dans la zone actuelle")
mkstr(SI.TELE_KEYBINDING_PRIMARY_RESIDENCE_OUTSIDE, "Se téléporter à l'extérieur de la résidence principale")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_DUNGEON_FINDER, "Arènes / Épreuves / Donjons")
mkstr(SI.TELE_KEYBINDING_TRACKED_QUEST, "Voyage vers la quête courante")
mkstr(SI.TELE_KEYBINDING_ANY_ZONE, "Port to any zone")


-----------------------------------------------------------------------------
-- DIALOGS | NOTIFICATIONS
-----------------------------------------------------------------------------
mkstr(SI.TELE_DIALOG_NO_BMU_GUILD_BODY, "Nous sommes désolés, mais il semblerait qu'il n'y a pas encore de guilde BeamMeUp active sur ce serveur.\n\nN'hésitez pas à nous contacter via le site ESOUI afin qu'une guilde officielle BeamMeUp soit créée sur ce serveur.")
mkstr(SI.TELE_DIALOG_INFO_BMU_GUILD_BODY, "Bonjour et merci d'utiliser BeamMeUp. En 2019, nous avons créé plusieurs guildes BeamMeUp dans le but de partager librement nos options de voyage rapide. Toutle monde est bienvenu, aucun prérequis ni obligation !\n\nEn confirmant cette boîte de dialogue, vous verrez les guildes officielles BeamMeUp et les guildes partenaires. Nous vous invitons cordialement à nous rejoindre ! Vous pouvez aussi afficher les guildes en cliquant sur le bouton guilde dans le coin en haut à gauche.\nVotre équipe BeamMeUp")
mkstr(SI.TELE_DIALOG_INFO_NEW_FEATURE_FAVORITE_PLAYER_NOTIFICATION, "Vous recevez une notification (message au centre de l'écran) quand un joueur favori se connecte.\n\nActiver cette fonctionnalité ?")
mkstr(SI.TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION, "Si vous récoltez un repérage et qu'il reste encore des cartes identiques (même endroit) dans votre inventaire, une notification (message au centre de l'écran) vous en avertira.\n\nActiver cette fonctionnalité ?")
mkstr(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE, "Integration de \"Port to Friend's House\"")
mkstr(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY, "Pour utiliser la fonctionnalité d'intégration, installez l'extension \"Port to Friend's House\". Vos maisons et manoirs de guilde configurés apparaitront alors dans cette liste.\n\nVoulez-vous accéder au site de l'extension ?")
-- AUTO UNLOCK: Start Dialog
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_TITLE, "Commencer le déverrouillage automatique des oratoires ?")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_BODY, "Après confirmation, BeamMeUp commencera à voyager vers tous les joueurs disponibles dans la zone courante. De cette façon, vous sauterez automatiquement d'oratoire en oratoire pour en déverrouiller autant que possible.")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_LOOP_OPTION, "Parcours des zones ...")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION1, "Ordre aléatoire")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION2, "Par taux d'oratoires inconnus")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION3, "Par nombre de joueurs")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_CHAT_LOG_OPTION, "Résultats dans le tchat")
-- AUTO UNLOCK: Refuse Dialogs
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE, "La découverte n'est pas possible")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY, "Tous les oratoires de la zone ont été découverts.")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2, "La découverte des oratoires n'est pas disponible dans cette zone. Cette fonctionnalité n'est disponible que dans les zones et régions principales.")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY3, "Malheureusement, il n'y a pas de joueurs dans la zone vers lequel voyager.")
-- AUTO UNLOCK: Process Dialog
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART, "Découverte automatique des oratoires en cours...")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY, "Nouveaux oratoires découverts :")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP, "XP gagnés :")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_PROGRESS, "Avancement :")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_TIMER, "Prochain saut dans :")
-- AUTO UNLOCK: Finish Dialog
mkstr(SI.TELE_DIALOG_FINISH_AUTO_UNLOCK_BODY_PART, "Découverte automatique des oratoires terminé.")
-- AUTO UNLOCK: Timeout Dialog
mkstr(SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_TITLE, "Temps dépassé")
mkstr(SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_BODY, "Désolé - une erreur inconnue est survenue. La découverte automatique a été annulée.")
-- AUTO UNLOCK: Loop Finish Dialog
mkstr(SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE, "Découverte automatique terminée")
mkstr(SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY, "Pas d'autres zones à découvrir. Soit il n'y a plus de joueurs dans les zones, ou vous avez déjà découvert tous les oratoires.")



-----------------------------------------------------------------------------
-- CENTER SCREEN NOTIFICATIONS
-----------------------------------------------------------------------------
mkstr(SI.TELE_CENTERSCREEN_OFFLINE_NOTE_HEAD, "Vous êtes encore en mode hors-ligne !")
mkstr(SI.TELE_CENTERSCREEN_OFFLINE_NOTE_BODY, "Personne ne peut chuchoter ou voyager vers vous !\n|c8c8c8c(Notification suppressible dans les options de BeamMeUp)")
mkstr(SI.TELE_CENTERSCREEN_SURVEY_MAPS, "Il vous reste %d de ces repérages. Revenez après régénération !")
mkstr(SI.TELE_CENTERSCREEN_FAVORITE_PLAYER_ONLINE, "est maintenant en ligne !")



-----------------------------------------------------------------------------
-- ITEM NAMES (PART OF IT) - BACKUP
-----------------------------------------------------------------------------
mkstr(SI.CONSTANT_TREASURE_MAP, "carte au trésor") -- need a part of the item name that is in every treasure map item the same no matter which zone
mkstr(SI.CONSTANT_SURVEY_MAP, "repérages") -- need a part of the item name that is in every survey map item the same no matter which zone and kind of craft