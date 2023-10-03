local mkstr = ZO_CreateStringId
local SI = BMU.SI

-----------------------------------------------------------------------------
-- INTERFACE
-----------------------------------------------------------------------------
mkstr(SI.TELE_UI_TOTAL, "Risultati:")
mkstr(SI.TELE_UI_GOLD, "Oro Risparmiato:")
mkstr(SI.TELE_UI_GOLD_ABBR, "k")
mkstr(SI.TELE_UI_GOLD_ABBR2, "m")
mkstr(SI.TELE_UI_TOTAL_PORTS, "Totale Viaggi:")
---------
--------- Buttons
mkstr(SI.TELE_UI_BTN_REFRESH_ALL, "Aggiorna lista Risultati")
mkstr(SI.TELE_UI_BTN_UNLOCK_WS, "Sblocca santuari nella zona corrente")
mkstr(SI.TELE_UI_BTN_FIX_WINDOW, "Blocca / Sblocca Finestra")
mkstr(SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE, "Mostra BeamMeUp")
mkstr(SI.TELE_UI_BTN_TOGGLE_BMU, "Mosta Obiettivi di Zona")
mkstr(SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE, "Le Tue Case")
mkstr(SI.TELE_UI_BTN_ANCHOR_ON_MAP, "Sblocca / Blocca in Mappa")
mkstr(SI.TELE_UI_BTN_GUILD_BMU, "Gilde BeamMeUp & Gilde Associate")
mkstr(SI.TELE_UI_BTN_GUILD_HOUSE_BMU, "Visita la casa di gilda BeamMeUp")
mkstr(SI.TELE_UI_BTN_PTF_INTEGRATION, "\"Viaggia a Casa di Amici\" Integrazione")
mkstr(SI.TELE_UI_BTN_DUNGEON_FINDER, "Arenas / Trials / Dungeons")
mkstr(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU, "\n|c777777(right-click for more options)")
---------
--------- List
mkstr(SI.TELE_UI_UNRELATED_ITEMS, "Mappe in altre Zone")
mkstr(SI.TELE_UI_UNRELATED_QUESTS, "Missioni in altre Zone")
mkstr(SI.TELE_UI_SAME_INSTANCE, "Stessa Istanza")
mkstr(SI.TELE_UI_DIFFERENT_INSTANCE, "Differente Istanza")
mkstr(SI.TELE_UI_GROUP_EVENT, "Evento di gruppo")
---------
--------- Menu
mkstr(SI.TELE_UI_FAVORITE_PLAYER, "Giocatore Preferito")
mkstr(SI.TELE_UI_FAVORITE_ZONE, "Zona Preferita")
mkstr(SI.TELE_UI_REMOVE_FAVORITE_PLAYER, "Rimuovi Giocatore Preferito")
mkstr(SI.TELE_UI_REMOVE_FAVORITE_ZONE, "Rimuovi Zona Preferita")
mkstr(SI.TELE_UI_VOTE_TO_LEADER, "Vota a Capo Gruppo")
mkstr(SI.TELE_UI_RESET_COUNTER_ZONE, "Resetta Contatori")
mkstr(SI.TELE_UI_INVITE_BMU_GUILD, "Invita nella gilda BeamMeUp")
mkstr(SI.TELE_UI_SHOW_QUEST_MARKER_ON_MAP, "Mostra Missioni Selezionate")
mkstr(SI.TELE_UI_RENAME_HOUSE_NICKNAME, "Cambia Sopranome alla Casa")
mkstr(SI.TELE_UI_TOGGLE_HOUSE_NICKNAME, "Mostra Sopranomi")
mkstr(SI.TELE_UI_VIEW_MAP_ITEM, "Visualizza Mappa Oggetti")
mkstr(SI.TELE_UI_TOGGLE_ARENAS, "Solo Arenas")
mkstr(SI.TELE_UI_TOGGLE_GROUP_ARENAS, "Group Arenas")
mkstr(SI.TELE_UI_TOGGLE_TRIALS, "Trials")
mkstr(SI.TELE_UI_TOGGLE_ENDLESS_DUNGEONS, "Endless Dungeons")
mkstr(SI.TELE_UI_TOGGLE_GROUP_DUNGEONS, "Group Dungeons")
mkstr(SI.TELE_UI_TOGGLE_SORT_ACRONYM, "Sort by Acronym")
mkstr(SI.TELE_UI_DAYS_LEFT, "%d days left")
mkstr(SI.TELE_UI_TOGGLE_UPDATE_NAME, "Show update name")
mkstr(SI.TELE_UI_UNLOCK_WAYSHRINES, "Automatic discovery of wayshrines")
mkstr(SI.TELE_UI_SUBMENU_FAVORITES, "Preferiti")
mkstr(SI.TELE_UI_TOOGLE_ZONE_NAME, "Show zone name")
mkstr(SI.TELE_UI_TOGGLE_SORT_RELEASE, "Sort by release")
mkstr(SI.TELE_UI_TOGGLE_ACRONYM, "Show acronym")
mkstr(SI.TELE_UI_TOOGLE_DUNGEON_NAME, "Show instance name")



-----------------------------------------------------------------------------
-- CHAT OUTPUTS
-----------------------------------------------------------------------------
mkstr(SI.TELE_CHAT_FAVORITE_UNSET, "Slot preferito è disattivato")
mkstr(SI.TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL, "Il giocatore è offline o nascosto dalle impostazioni dei Filtri")
mkstr(SI.TELE_CHAT_NO_FAST_TRAVEL, "Nessuna opzione di viaggio veloce trovata")
mkstr(SI.TELE_CHAT_NOT_IN_GROUP, "Non sei in un gruppo")
mkstr(SI.TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED, "Nessuna Residenza Primaria Impostata!")
mkstr(SI.TELE_CHAT_GROUP_LEADER_YOURSELF, "Tu sei il Capogruppo")
mkstr(SI.TELE_CHAT_UNLOCK_WS_DISCOVERED_TOTAL, "Totale santuari scoperti nella zona:")
mkstr(SI.TELE_CHAT_UNLOCK_WS_NEED_DISCOVERED, "I seguenti santuari devono ancora essere visitati fisicamente:")
mkstr(SI.TELE_CHAT_SHARING_FOLLOW_LINK, "Cliccando il link ...")
mkstr(SI.TELE_CHAT_AUTO_UNLOCK_CANCELED, "Automatic discovery canceled by user.")
mkstr(SI.TELE_CHAT_AUTO_UNLOCK_SKIP, "Fast Travel error: Skip current player.")



-----------------------------------------------------------------------------
-- SETTINGS
-----------------------------------------------------------------------------
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN, "Apri Beammeup quando la mappa è aperta")
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP, "Quando apri la mappa, Beammeup si aprirà automaticamente, altrimenti vedrai un pulsante in alto a sinistra sulla mappa e anche un pulsante di swap nella finestra di completamento della mappa.")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY, "Mostra ogni Zona una sola volta")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP, "Mostra un solo annuncio per ogni zona.")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ, "Frequenza sblocco Santuari (ms)")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP, "Regolare la frequenza dello sblocco automatico dei Santuari. Per computer lenti o per evitare possibili rallentamenti nel gioco, un valore più alto può aiutare.")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH, "Aggiorna & Resetta all'apertura")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP, "Aggiorna l'elenco dei risultati ogni volta che apri Beammeup. I campi di input vengono cancellati.")
mkstr(SI.TELE_SETTINGS_HEADER_BLACKLISTING, "Lista Nera")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS, "Nascondi varie zone inaccessibili")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP, "Nascondi zone come Maelstrom Arena, Rifugi dei Banditi e zone in Solo.")
mkstr(SI.TELE_SETTINGS_HIDE_PVP, "Nascondi zone PVP")
mkstr(SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP, "Nascondi zone come Cyrodiil, Citta Imperiale e Battlegrounds.")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS, "Nascondi Dungeon di Gruppo e Prove")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP, "Nascondi tutti i Dungeon di Gruppo da 4 persone, Prove da 12  e Dungeon di Gruppo a Craglorn. I membri del gruppo in queste zone saranno ancora visualizzati!")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES, "Nascondi Case")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP, "Nascondi tutte le Case.")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY, "Tieni aperto Beammeup")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP, "Quando si apre Beammeup senza la mappa, rimarrà anche se si sposta o apre altre finestre. Se si utilizza questa opzione, si consiglia di disabilitare l'opzione 'Chiudi Beammeup con mappa'.")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS, "Mostra solo Regioni / Zone Aperte")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP, "Mostra solo le principali regioni come Deshaan o Summerset.")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ, "Intervallo di aggiornamento (s)")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP, "Quando Beammeup è aperto, un aggiornamento automatico dell'elenco dei risultati viene eseguito ogni x secondi..")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN, "Attiva la casella di ricerca della zona")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP, "Attiva la casella di ricerca della zona quando Beammeup viene aperto insieme alla mappa.")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES, "Nascondi Dungeon in Solo")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP, "Nascondi tutti i Dungeon in Solo.")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS, "Nascondi Dungeon Pubblici")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP, "Nascondi tutti i Dungeon Pubblici.")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME, "Nascondi gli articoli nei nomi di zona")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP, "Nascondi gli articoli nei nomi di zona per garantire un migliore ordinamento per trovare le zone più velocemente.")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES, "Numero di linee / elenchi")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP, "Impostando il numero di linee visibili / elenchi è possibile controllare l'altezza totale del Addon.")
mkstr(SI.TELE_SETTINGS_HEADER_ADVANCED, "Funzionalità Extra")
mkstr(SI.TELE_SETTINGS_HEADER_UI, "Generale")
mkstr(SI.TELE_SETTINGS_HEADER_RECORDS, "Elenchi")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING, "Auto chiudi mappa e Beammeup")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP, "Chiudi mappa e Beammeup dopo l'avvio del processo di viaggio")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS, "Mostra numero di giocatori per mappa")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP, "Mostra il numero di giocatori per mappa, è possibile viaggia verso. È possibile fare clic sul numero per vedere tutti questi giocatori.")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET, "Spostamento del pulsante nella chatbox")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP, "Aumenta lo spostamento orizzontale del pulsante nell'intestazione della chatbox per evitare conflitti visivi con altre icone Addon.")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES, "Cerca anche per nome personaggio")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP, "Cerca anche i nomi dei personaggi quando cerchi i giocatori")
mkstr(SI.TELE_SETTINGS_SORTING, "Ordinamento")
mkstr(SI.TELE_SETTINGS_SORTING_TOOLTIP, "Scegli uno dei possibili tipi di lista.")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE, "Seconda lingua di ricerca")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP, "È possibile cercare per nome di zona nella lingua del client e per la seconda lingua allo stesso tempo.la descrizione del nome della zona viene visualizzato anche nella seconda lingua.")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE, "Notifica quando il Giocatore preferito è Online")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP, "Ricevi una notifica (messaggio al centro della schermata) quando un giocatore preferito è online.")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE, "Chiudi Beammeup quando la mappa è chiusa")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP, "Quando chiudi la mappa, si chiude anche Beammeup.")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL, "Spostamento della posizione del dock della mappa - Orizzontale")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP, "Qui puoi personalizzare lo spostamento orizzontale dell'aggancio sulla mappa.")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL, "Spostamento della posizione del dock della mappa - Verticale")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP, "Qui puoi personalizzare lo spostamento verticale dell'aggancio sulla mappa.")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS, "Resetta tutti i contatori di zona")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP, "Tutti i contatori di zona sono resettati. Pertanto, i filtri utilizzati sono stati resettati.")
mkstr(SI.TELE_SETTINGS_OFFLINE_NOTE, "Offline Reminder")
mkstr(SI.TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP, "If you are set to offline for a while and you whisper or travel to someone, you will get a short screen message as reminder. As long as you are set to offline you cannot receive any whisper messages and no one can travel to you (but sharing is caring).")
mkstr(SI.TELE_SETTINGS_SCALE, "Scala UI")
mkstr(SI.TELE_SETTINGS_SCALE_TOOLTIP, "Fattore di scala per l'interfaccia utente/finestra completa di Beammeup. Un reload è necessario per applicare le modifiche.")
mkstr(SI.TELE_SETTINGS_RESET_UI, "Resetta UI")
mkstr(SI.TELE_SETTINGS_RESET_UI_TOOLTIP, "Resetta Beammeup UI impostando le seguenti opzioni di default: Ridimensionamento, Offset pulsante, Mappa Dock Offsets e le posizioni delle finestre. L'interfaccia utente completa sarà ricaricata.")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION, "Notifica Mappe di ricerca")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP, "Se estrai una mappa di ricerca e ci sono ancora alcune mappe identiche (stessa posizione) nel tuo inventario, una notifica (messaggio al centro dello schermo) ti informerà.")
mkstr(SI.TELE_SETTINGS_HEADER_PRIO, "Priorità")
mkstr(SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS, "Comandi della Chat")
mkstr(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT, "Minimizza i messaggi in uscita della chat")
mkstr(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT_TOOLTIP, "Riduce il numero di messaggi in uscita della chat quando si utilizza la funzione di sblocco automatico.")
mkstr(SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION, "Qui puoi definire quali giocatori dovrebbero preferibilmente essere utilizzati per i viaggi veloci. Dopo aver lasciato o esserti unito ad una gilda, un reload è necessario per essere visualizzato correttamente.")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP, "Mostra pulsante aggiuntivo sulla mappa")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP, "Mostra un pulsante di testo nell'angolo in alto a sinistra della mappa del mondo per aprire Beammeup.")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND, "Riproduci Suono")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP, "Riproduce un suono quando mostra la notifica.")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL, "Auto conferma viaggio verso santurario")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP, "Disabilita la finestra di conferma quando ti teletrasporti ad altri santuari.")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP, "Mostra la zona corrente sempre in alto")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP, "Mostra la zona corrente sempre in cima all'elenco.")
mkstr(SI.TELE_SETTINGS_HIDE_OWN_HOUSES, "Nascondi case proprie")
mkstr(SI.TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP, "Nascondi le tue case (teletrasporto esterno) nell'elenco principale.")
mkstr(SI.TELE_SETTINGS_HEADER_STATS, "Statistics")
mkstr(SI.TELE_SETTINGS_MOST_PORTED_ZONES, "Most traveled zones:")
mkstr(SI.TELE_SETTINGS_INSTALLED_SCINCE, "Installed at least since:")
mkstr(SI.TELE_SETTINGS_INFO_CHARACTER_DEPENDING, "Questa opzione è collegata al tuo personaggio (non a livello di account)!")
mkstr(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION, "Teleport animation")
mkstr(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP, "Show an additional teleportation animation when starting a fast travel via BMU. The collectible 'Finvir's Trinket' must be unlocked.")
mkstr(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON, "Button in the chat window")
mkstr(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP, "Display a button in the header of the chat window to open BeamMeUp.")
mkstr(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM, "Pan and zoom")
mkstr(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP, "Pan and zoom to the destination on the map when you click on group members or specific zones (dungeons, houses etc.).")
mkstr(SI.TELE_SETTINGS_USE_RALLY_POINT, "Map ping")
mkstr(SI.TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP, "Display a map ping (rally point) on the destination on the map when you click on group members or specific zones (dungeons, houses etc.). The library LibMapPing must be installed. Also remember: If you are the group leader, your pings (rally points) are visible for all group members.")
mkstr(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS, "Show zones without players or houses")
mkstr(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP, "Display zones in the main list even if there are no players or houses you can travel to. You still have the option to travel for gold if you have discovered at least one wayshrine in the zone.")
mkstr(SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP, "Show displayed zone & subzones always on top")
mkstr(SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP_TOOLTIP, "Show currently displayed zone and subzones (opened world map) always on top of the list.")


-----------------------------------------------------------------------------
-- KEY BINDING
-----------------------------------------------------------------------------
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN, "Apri BeamMeUp")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_RELATED_ITEMS, "Mappe del Tesoro & Mappe di Ricerca & Indizi")
mkstr(SI.TELE_KEYBINDING_REFRESH, "Aggiorna Lista Risultati")
mkstr(SI.TELE_KEYBINDING_WAYSHRINE_UNLOCK, "Sblocca i santuari nella zona attuale")
mkstr(SI.TELE_KEYBINDING_PRIMARY_RESIDENCE, "Viaggia nella Residenza Primaria")
mkstr(SI.TELE_KEYBINDING_GUILD_HOUSE_BMU, "Visita la casa di gilda di BeamMeUp")
mkstr(SI.TELE_KEYBINDING_CURRENT_ZONE, "Viaggia nella zona corrente")
mkstr(SI.TELE_KEYBINDING_PRIMARY_RESIDENCE_OUTSIDE, "Viaggia fuori la Residenza Primaria")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_DUNGEON_FINDER, "Arenas / Trials / Dungeons")
mkstr(SI.TELE_KEYBINDING_TRACKED_QUEST, "Port to focused quest")
mkstr(SI.TELE_KEYBINDING_ANY_ZONE, "Port to any zone")


-----------------------------------------------------------------------------
-- DIALOGS | NOTIFICATIONS
-----------------------------------------------------------------------------
mkstr(SI.TELE_DIALOG_NO_BMU_GUILD_BODY, "Ci dispiace tanto, ma sembra che non ci sia ancora una gilda di Beammeup su questo server.\n\nSentiti libero di contattarci tramite il sito web ESOUI e avviare una gilda ufficiale Beammeup su questo server.")
mkstr(SI.TELE_DIALOG_INFO_BMU_GUILD_BODY, "Ciao e grazie per aver utilizzato Beammeup. Nel 2019, abbiamo fondato diverse gilde Beammeup allo scopo di condividere opzioni di viaggio veloce gratuite. Tutti sono i benvenuti, senza nessun requisito o obbligo!\n\n.confermando questa finestra di dialogo, vedrete le gilde ufficiali e partner di Beammeup nella lista. Siete i benvenuti a partecipare! Puoi anche visualizzare le gilde cliccando sul pulsante GILDA nell'angolo in alto a sinistra\nIl Tuo Team BeamMeUp")
mkstr(SI.TELE_DIALOG_INFO_NEW_FEATURE_FAVORITE_PLAYER_NOTIFICATION, "Si riceve una notifica (messaggio al centro dello schermo) quando un giocatore preferito è online.\n\nAbilitare questa funzione?")
mkstr(SI.TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION, "Se apri una mappa di ricerca e ci sono delle mappe identiche (stessa posizione) nel tuo inventario, una notifica (messaggio al centro dello schermo) ti informerà.\n\nAbilitare questa funzione")
mkstr(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE, "Installazione di \"Port to Friend's House\"")
mkstr(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY, "Per utilizzare la funzione di integrazione, si prega di installare l'addon \"Port to Friend's House\". Vedrete le vostre case configurate e le sale delle corporazioni qui nella lista.\n\nVuoi aprire il sito di \"Port to Friend's House\" adesso?")
-- AUTO UNLOCK: Start Dialog
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_TITLE, "Avviare sblocco automatico Santuari?")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_BODY, "By confirming, BeamMeUp will start traveling to all available players in the current zone. This way you will automatically jump from wayshrine to wayshrine to unlock as much as possible.")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_LOOP_OPTION, "Looping over zones ...")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION1, "shuffle randomly")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION2, "by ratio of undiscovered wayshrines")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION3, "by number of players")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_CHAT_LOG_OPTION, "Output results in chat")
-- AUTO UNLOCK: Refuse Dialogs
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE, "Lo sblocco non è possibile")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY, "Tutti i santuari della zona sono già stati sbloccati.")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2, "Sbloccare santuari non è possibile in questa zona. La funzione è disponibile solo nelle Zone Aperte / Regioni.")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY3, "Unfortunately, there are no players in the zone to travel to.")
-- AUTO UNLOCK: Process Dialog
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART, "Automatic wayshrine discovery is running...")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY, "Newly discovered wayshrines:")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP, "Gained XP:")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_PROGRESS, "Progress:")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_TIMER, "Next jump in:")
-- AUTO UNLOCK: Finish Dialog
mkstr(SI.TELE_DIALOG_FINISH_AUTO_UNLOCK_BODY_PART, "Automatic discovery of wayshrines completed.")
-- AUTO UNLOCK: Timeout Dialog
mkstr(SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_TITLE, "Timeout")
mkstr(SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_BODY, "Sorry, an unknown error has occurred. The automatic discovery was canceled.")
-- AUTO UNLOCK: Loop Finish Dialog
mkstr(SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE, "Automatic discovery finished")
mkstr(SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY, "No more zones found to be discovered. Either there are no players in the zones or you have already discovered all wayshrines.")



-----------------------------------------------------------------------------
-- CENTER SCREEN NOTIFICATIONS
-----------------------------------------------------------------------------
mkstr(SI.TELE_CENTERSCREEN_OFFLINE_NOTE_HEAD, "Note: You are still set to offline!")
mkstr(SI.TELE_CENTERSCREEN_OFFLINE_NOTE_BODY, "No one can whisper or travel to you!\n|c8c8c8c(Notification can be disabled in BeamMeUp settings)")
mkstr(SI.TELE_CENTERSCREEN_SURVEY_MAPS, "You have %d of this survey maps left! Come back after respawn!")
mkstr(SI.TELE_CENTERSCREEN_FAVORITE_PLAYER_ONLINE, "is now online!")



-----------------------------------------------------------------------------
-- ITEM NAMES (PART OF IT) - BACKUP
-----------------------------------------------------------------------------
mkstr(SI.CONSTANT_TREASURE_MAP, "mappa del tesoro") -- need a part of the item name that is in every treasure map item the same no matter which zone
mkstr(SI.CONSTANT_SURVEY_MAP, "ricerca:") -- need a part of the item name that is in every survey map item the same no matter which zone and kind of craft