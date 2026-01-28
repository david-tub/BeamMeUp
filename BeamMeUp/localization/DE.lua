local BMU = BMU
local SI = BMU.SI

-----------------------------------------------------------------------------
-- INTERFACE
-----------------------------------------------------------------------------
local strings = {
    [SI.TELE_UI_TOTAL] = "Treffer:",
    [SI.TELE_UI_GOLD] = "Gold gespart:",
    [SI.TELE_UI_GOLD_ABBR] = "Tsd",
    [SI.TELE_UI_GOLD_ABBR2] = "Mio",
    [SI.TELE_UI_TOTAL_PORTS] = "Reisen gesamt:",
    ---------
    --------- Buttons
    [SI.TELE_UI_BTN_REFRESH_ALL] = "Trefferliste neu laden",
    [SI.TELE_UI_BTN_UNLOCK_WS] = "Wegschreine im aktuellen Gebiet automatisch freischalten",
    [SI.TELE_UI_BTN_FIX_WINDOW] = "Fenster fixieren / lösen",
    [SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE] = "Wechsel zu BeamMeUp",
    [SI.TELE_UI_BTN_TOGGLE_BMU] = "Wechsel zum Kartenfortschritt",
    [SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE] = "Eigene Häuser",
    [SI.TELE_UI_BTN_ANCHOR_ON_MAP] = "Ab- / Andocken an Karte",
    [SI.TELE_UI_BTN_GUILD_BMU] = "BeamMeUp Gilden & Partner Gilden",
    [SI.TELE_UI_BTN_GUILD_HOUSE_BMU] = "BeamMeUp Gildenhaus besuchen",
    [SI.TELE_UI_BTN_PTF_INTEGRATION] = "\"Port to Friend's House\" Integration",
    [SI.TELE_UI_BTN_DUNGEON_FINDER] = "Arenen / Prüfungen / Verliese",
    [SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU] = "\n|c777777(Rechtsklick für weitere Optionen)",
    ---------
    --------- List
    [SI.TELE_UI_UNRELATED_ITEMS] = "Karten in anderen Gebieten",
    [SI.TELE_UI_UNRELATED_QUESTS] = "Quests in anderen Gebieten",
    [SI.TELE_UI_SAME_INSTANCE] = "Gleiche Instanz",
    [SI.TELE_UI_DIFFERENT_INSTANCE] = "Andere Instanz",
    [SI.TELE_UI_GROUP_EVENT] = "Gruppenwagnis",
    ---------
    --------- Menu
    [SI.TELE_UI_FAVORITE_PLAYER] = "Spieler-Favorit",
    [SI.TELE_UI_FAVORITE_ZONE] = "Zonen-Favorit",
    [SI.TELE_UI_VOTE_TO_LEADER] = "Zum Anführer voten",
    [SI.TELE_UI_RESET_COUNTER_ZONE] = "Zähler zurücksetzen",
    [SI.TELE_UI_INVITE_BMU_GUILD] = "Zur BeamMeUp Gilde einladen",
    [SI.TELE_UI_SHOW_QUEST_MARKER_ON_MAP] = "Zeige Questmarker",
    [SI.TELE_UI_RENAME_HOUSE_NICKNAME] = "Spitzname des Hauses umbenennen",
    [SI.TELE_UI_TOGGLE_HOUSE_NICKNAME] = "Zeige Spitznamen",
    [SI.TELE_UI_VIEW_MAP_ITEM] = "Kartenelement ansehen",
    [SI.TELE_UI_TOGGLE_ARENAS] = "Solo-Arenen",
    [SI.TELE_UI_TOGGLE_GROUP_ARENAS] = "Gruppen-Arenen",
    [SI.TELE_UI_TOGGLE_TRIALS] = "Prüfungen",
    [SI.TELE_UI_TOGGLE_ENDLESS_DUNGEONS] = "Endlose Verliese",
    [SI.TELE_UI_TOGGLE_GROUP_DUNGEONS] = "Verliese",
    [SI.TELE_UI_TOGGLE_SORT_ACRONYM] = "Nach Kürzel sortieren",
    [SI.TELE_UI_DAYS_LEFT] = "%d Tage verbleibend",
    [SI.TELE_UI_TOGGLE_UPDATE_NAME] = "Zeige Update Name",
    [SI.TELE_UI_UNLOCK_WAYSHRINES] = "Wegschreine automatisch freischalten",
    [SI.TELE_UI_TOOGLE_ZONE_NAME] = "Zeige Zonen Name",
    [SI.TELE_UI_TOGGLE_SORT_RELEASE] = "Nach Erscheinung sortieren",
    [SI.TELE_UI_TOGGLE_ACRONYM] = "Zeige Kürzel",
    [SI.TELE_UI_TOOGLE_DUNGEON_NAME] = "Zeige Instanz Name",
    [SI.TELE_UI_TRAVEL_PARENT_ZONE] = "Schnellreise in die Eltern-Zone",
    [SI.TELE_UI_SET_PREFERRED_HOUSE] = "Als bevorzugtes Haus festlegen",
    [SI.TELE_UI_UNSET_PREFERRED_HOUSE] = "Bevorzugtes Haus freigeben",



    -----------------------------------------------------------------------------
    -- CHAT OUTPUTS
    -----------------------------------------------------------------------------
    [SI.TELE_CHAT_FAVORITE_UNSET] = "Favoriten-Slot ist unbesetzt",
    [SI.TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL] = "Der Spieler ist offline oder wird durch gesetzte Filter ausgeblendet",
    [SI.TELE_CHAT_NO_FAST_TRAVEL] = "Keine Schnellreise-Möglichkeit gefunden",
    [SI.TELE_CHAT_NOT_IN_GROUP] = "Du bist in keiner Gruppe",
    [SI.TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED] = "Kein Hauptwohnsitz gesetzt!",
    [SI.TELE_CHAT_GROUP_LEADER_YOURSELF] = "Du selbst bist der Gruppenanführer",
    [SI.TELE_CHAT_UNLOCK_WS_DISCOVERED_TOTAL] = "Insgesamt entdeckte Wegschreine in der Zone:",
    [SI.TELE_CHAT_UNLOCK_WS_NEED_DISCOVERED] = "Die folgenden Wegschreine müssen noch physisch besucht werden:",
    [SI.TELE_CHAT_SHARING_FOLLOW_LINK] = "Folge dem Link ...",
    [SI.TELE_CHAT_AUTO_UNLOCK_CANCELED] = "Wegschrein-Freischaltung durch Nutzer abgebrochen.",
    [SI.TELE_CHAT_AUTO_UNLOCK_SKIP] = "Schnellreise Fehler: Überspringe aktuellen Spieler.",



    -----------------------------------------------------------------------------
    -- SETTINGS
    -----------------------------------------------------------------------------
    [SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN] = "Öffne BeamMeUp zusammen mit der Karte",
    [SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP] = "Wenn du die Karte öffnest, öffnet sich auch BeamMeUp. Wenn du diese Funktion deaktivierst, kannst du BeamMeUp auch über den Button auf der Karte oben links, über den Button in der Chat-Box und über den Toggle-Button öffnen.",
    [SI.TELE_SETTINGS_ZONE_ONCE_ONLY] = "Nur ein Eintrag pro Gebiet",
    [SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP] = "Zeige nur einen Eintrag pro Gebiet anstatt jeden einzelnen Treffer.",
    [SI.TELE_SETTINGS_AUTO_PORT_FREQ] = "Frequenz der Wegschrein-Freischaltung (ms)",
    [SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP] = "Passe die Frequenz der automatischen Wegschrein-Freischaltung an. Bei langsameren Rechnern oder um eventuelle Kicks durch Spam zu verhindern kann ein höherer Wert helfen.",
    [SI.TELE_SETTINGS_AUTO_REFRESH] = "Zurücksetzen und neu laden beim Öffnen",
    [SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP] = "Trefferliste beim Öffnen neu laden. Suchfelder und Scroll-Leiste werden ebenfalls zurückgesetzt.",
    [SI.TELE_SETTINGS_HEADER_BLACKLISTING] = "Schwarze Liste (Ziele ausblenden)",
    [SI.TELE_SETTINGS_HIDE_OTHERS] = "Ausblenden von gesperrten Gebieten",
    [SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP] = "Blende unzugängliche Gebiete wie die Mahlstrom-Arena, Unterschlüpfe und Solo-Zonen aus.",
    [SI.TELE_SETTINGS_HIDE_PVP] = "Ausblenden von PVP-Gebieten",
    [SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP] = "Blende PVP-Gebiete wie Cyrodiil, Schlachtfelder und die Gebiete der Kaiserstadt aus.",
    [SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS] = "Ausblenden von Gruppen-Verliesen und Prüfungen",
    [SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP] = "Blende alle 4-Spieler-Gruppeninstanzen, 12-Spieler-Prüfungen, die Drachenstern-Arena und Kargstein-Gruppen-Verliese aus. Gruppenmitglieder in diesen Zonen werden trotzdem angezeigt!",
    [SI.TELE_SETTINGS_HIDE_HOUSES] = "Ausblenden von Häusern",
    [SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP] = "Blende alle Häuser aus.",
    [SI.TELE_SETTINGS_WINDOW_STAY] = "BeamMeUp geöffnet halten",
    [SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP] = "Wenn du BeamMeUp ohne Karte öffnest, bleibt das Fenster offen, auch wenn du dich bewegst oder andere Fenster öffnest. Wenn du diese Option nutzt, empfiehlt es sich die Option 'Öffne / Schließe BeamMeUp mit Karte' zu deaktivieren.",
    [SI.TELE_SETTINGS_ONLY_MAPS] = "Zeige nur Regionen",
    [SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP] = "Zeige ausschließlich Regionen bzw. Oberflächen-Maps wie Deshaan oder Sommersend.",
    [SI.TELE_SETTINGS_AUTO_REFRESH_FREQ] = "Aktualisierungsintervall (s)",
    [SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP] = "Wenn BeamMeUp geöffnet ist, wird eine automatische Aktualisierung der Ergebnisse alle x Sekunden durchgeführt. Setze den Wert auf 0 um die automatische Aktualisierung abzuschalten.",
    [SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN] = "Zonen-Suchfeld fokussieren",
    [SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP] = "Fokussiere das Suchfeld für Zonen, wenn BeamMeUp geöffnet wird.",
    [SI.TELE_SETTINGS_HIDE_DELVES] = "Ausblenden von Gewölben",
    [SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP] = "Blende alle Gewölbe (Fackel-Symbol) aus.",
    [SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS] = "Ausblenden von Öffentlichen Verliesen",
    [SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP] = "Blende alle öffentlichen Verliese aus.",
    [SI.TELE_SETTINGS_FORMAT_ZONE_NAME] = "Artikel der Zonen ausblenden",
    [SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP] = "Blende die Artikel der Zonennamen aus, damit diese durch eine bessere Sortierung schneller gefunden werden können.",
    [SI.TELE_SETTINGS_NUMBER_LINES] = "Anzahl der Zeilen / Einträge",
    [SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP] = "Mit der Anzahl der sichtbaren Zeilen bzw. Einträge kann die Höhe des Addons justiert werden.",
    [SI.TELE_SETTINGS_HEADER_ADVANCED] = "Extra Funktionen",
    [SI.TELE_SETTINGS_HEADER_UI] = "Allgemein",
    [SI.TELE_SETTINGS_HEADER_RECORDS] = "Ergebnisse",
    [SI.TELE_SETTINGS_CLOSE_ON_PORTING] = "Automatisches Schließen",
    [SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP] = "Schließe Karte und BeamMeUp nachdem der Schnellreisevorgang gestartet wurde.",
    [SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS] = "Zeige Anzahl der Spieler pro Gebiet",
    [SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP] = "Zeige die Anzahl der Spieler im jeweiligen Gebiet an, zu denen du Reisen kannst. Durch einen Klick auf die Zahl werden alle diese Spieler angezeigt.",
    [SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET] = "Offset des Buttons in der Chatbox",
    [SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP] = "Erhöhe den horizontalen Offset des Buttons im Kopfbereich der Chatbox, um visuelle Konflikte mit anderen Addon-Symbolen zu vermeiden.",
    [SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES] = "Suche auch nach Charakternamen",
    [SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP] = "Suche auch nach Charakternamen bei der Suche nach Spielern.",
    [SI.TELE_SETTINGS_SORTING] = "Sortierung",
    [SI.TELE_SETTINGS_SORTING_TOOLTIP] = "Wähle eine der möglichen Sortierungen der Liste.",
    [SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE] = "Zweite Suchsprache",
    [SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP] = "Du kannst in deiner Anzeigesprache und in dieser zweiten Sprache gleichzeitig nach Zonennamen suchen. Der Tooltip des Zonennamens zeigt auch den Namen in der zweiten Sprache an.",
    [SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE] = "Benachrichtigung Spieler-Favorit Online",
    [SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP] = "Du erhältst eine Benachrichtigung (Bildschirmmeldung), wenn ein Spieler-Favorit online kommt.",
    [SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE] = "Schließe BeamMeUp zusammen mit der Karte",
    [SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP] = "Wenn du die Karte schließt, wird auch BeamMeUp geschlossen.",
    [SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL] = "Offset der Karten Dock-Position - Horizontal",
    [SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP] = "Hier kannst du den horizontalen Offset des Andockens an der Karte anpassen.",
    [SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL] = "Offset der Karten Dock-Position - Vertikal",
    [SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP] = "Hier kannst du den vertikalen Offset des Andockens an der Karte anpassen.",
    [SI.TELE_SETTINGS_RESET_ALL_COUNTERS] = "Zähler zurücksetzen",
    [SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP] = "Alle Zähler werden zurückgesetzet. Dadurch wird auch die Sortierung nach 'most used' zurückgesetzt.",
    [SI.TELE_SETTINGS_OFFLINE_NOTE] = "Offline Erinnerung",
    [SI.TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP] = "Wenn du für eine Weile offline gestellt bist und jemandem anflüsterst oder zu ihm reist, erhältst du eine kurze Bildschirmnachricht als Erinnerung. Solange du offline gestellt bist, kannst du keine Flüsternachrichten empfangen und niemand kann zu dir reisen (aber Sharing is Caring).",
    [SI.TELE_SETTINGS_SCALE] = "UI Skalierung",
    [SI.TELE_SETTINGS_SCALE_TOOLTIP] = "Skalierungsfaktor für die BeamMeUp-Benutzeroberfläche. Änderungen werden erst nach einem Reload übernommen.",
    [SI.TELE_SETTINGS_RESET_UI] = "UI zurücksetzen",
    [SI.TELE_SETTINGS_RESET_UI_TOOLTIP] = "Zurücksetzen der BeamMeUp-Benutzeroberfläche durch das Zurücksetzen folgender Optionen: Skalierung, Button-Offset, Karten-Dock-Offsets und Fensterpositionen. Die gesamte UI wird neugeladen.",
    [SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION] = "Fundberichte Benachrichtigung",
    [SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP] = "Wenn du einen Fundbericht abbaust und sich noch weitere identische Fundberichte (selbe Stelle) in deinem Inventar befinden, wird dich eine Benachrichtigung darüber informieren.",
    [SI.TELE_SETTINGS_HEADER_PRIO] = "Priorisierung",
    [SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS] = "Chat Befehle",
    [SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION] = "Hier kannst du einstellen, welche Spieler vorzugsweise für die Schnellreise genutzt werden sollen. Nach dem Beitritt oder Verlassen einer Gilde ist ein Reload erforderlich, um hier korrekt angezeigt zu werden.",
    [SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP] = "Zusätzliche Schaltfläche auf der Karte anzeigen",
    [SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP] = "Zeigt in der oberen linken Ecke der Weltkarte eine Textschaltfläche zum Öffnen von BeamMeUp an.",
    [SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND] = "Sound abspielen",
    [SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP] = "Spielt einen Sound ab, wenn die Benachrichtigung angezeigt wird.",
    [SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL] = "Automatische Bestätigung beim Wegschrein-Reisen",
    [SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP] = "Deaktiviert den Bestätigungsdialog, wenn du zu anderen Wegschreinen reist.",
    [SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP] = "Aktuelle Zone immer oben anzeigen",
    [SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP] = "Aktuelle Zone immer an oberster Stelle der Liste anzeigen.",
    [SI.TELE_SETTINGS_HIDE_OWN_HOUSES] = "Ausblenden von EIGENEN Häusern",
    [SI.TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP] = "Blende alle eigene Häuser (außerhalb reisen) in der Hauptliste aus.",
    [SI.TELE_SETTINGS_HEADER_STATS] = "Statistiken",
    [SI.TELE_SETTINGS_MOST_PORTED_ZONES] = "Meist bereiste Zonen:",
    [SI.TELE_SETTINGS_INSTALLED_SCINCE] = "Mindestens installiert seit:",
    [SI.TELE_SETTINGS_INFO_CHARACTER_DEPENDING] = "Diese Option ist an deinem Charakter gebunden (nicht accountweit)!",
    [SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION] = "Teleportanimation",
    [SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP] = "Zeigt eine zusätzliche Animation, wenn eine Schnellreise über BeamMeUp gestartet wird. Das Sammlungsstück 'Finvirs Glücksbringer' muss freigeschaltet sein.",
    [SI.TELE_SETTINGS_SHOW_CHAT_BUTTON] = "Schaltfläche im Chat-Fenster",
    [SI.TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP] = "Anzeigen einer Schaltfläche im Kopfbereich des Chat-Fensters um BeamMeUp zu öffnen.",
    [SI.TELE_SETTINGS_USE_PAN_AND_ZOOM] = "Zentrieren und Zoomen",
    [SI.TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP] = "Schwenke und zoome zum Ziel auf der Karte, wenn du auf Gruppenmitglieder oder bestimmte Zonen (Dungeons, Häuser usw.) klickst.",
    [SI.TELE_SETTINGS_USE_RALLY_POINT] = "Karten-Ping",
    [SI.TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP] = "Zeigt einen Karten-Ping (Sammelpunkt) am Zielort auf der Karte an, wenn du auf Gruppenmitglieder oder bestimmte Zonen (Dungeons, Häuser etc.) klickst. Die Bibliothek LibMapPing muss installiert sein. Bedenke auch: Wenn du der Gruppenleiter bist, sind deine Pings (Sammelpunkt) für alle Gruppenmitglieder sichtbar.",
    [SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS] = "Zeige Regionen ohne Schnellreise-Möglichkeit",
    [SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP] = "Zeige Regionen bzw. Oberflächen-Maps in der Hauptliste an, auch wenn es keine Schnellreise-Möglichkeit gibt (kein Spieler oder Haus zu dem/das du reisen kannst).",
    [SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP] = "Angezeigte Zone & Unterzonen immer oben anzeigen",
    [SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP_TOOLTIP] = "Aktuell angezeigte Zone und Unterzonen (geöffnete Karte) immer an oberster Stelle der Liste anzeigen.",
    [SI.TELE_SETTINGS_DEFAULT_TAB] = "Standardliste",
    [SI.TELE_SETTINGS_DEFAULT_TAB_TOOLTIP] = "Die Liste, die standardmäßig beim Öffnen von BeamMeUp angezeigt wird.",
    [SI.TELE_SETTINGS_HEADER_CHAT_OUTPUT] = "Chat Meldungen",
    [SI.TELE_SETTINGS_OUTPUT_FAST_TRAVEL] = "Schnellreisevorgänge",
    [SI.TELE_SETTINGS_OUTPUT_FAST_TRAVEL_TOOLTIP] = "Informative Chat-Meldungen über die eingeleiteten Schnellreisen. Fehlermeldungen werden weiterhin im Chat angezeigt.",
    [SI.TELE_SETTINGS_OUTPUT_ADDITIONAL] = "Unterstützende Meldungen",
    [SI.TELE_SETTINGS_OUTPUT_ADDITIONAL_TOOLTIP] = "Weitere hilfreiche Chat-Meldungen zu verschiedenen Aktionen des Addons.",
    [SI.TELE_SETTINGS_OUTPUT_UNLOCK] = "Ergebnisse der Wegschrein-Freischaltung",
    [SI.TELE_SETTINGS_OUTPUT_UNLOCK_TOOLTIP] = "Zwischenergebnisse (entdeckte Wegschreine und XP) und unterstützende Chat-Meldungen der automatischen Wegschrein-Freischaltung.",
    [SI.TELE_SETTINGS_OUTPUT_DEBUG] = "Debug Meldungen",
    [SI.TELE_SETTINGS_OUTPUT_DEBUG_TOOLTIP] = "Technische Chat-Meldungen zur Fehlerbehebung. Dadurch wird der Chat zugespammt. Bitte nur auf Anfrage und nur für kurze Zeit verwenden!",


    -----------------------------------------------------------------------------
    -- KEY BINDING
    -----------------------------------------------------------------------------
    [SI.TELE_KEYBINDING_TOGGLE_MAIN] = "Öffne BeamMeUp",
    [SI.TELE_KEYBINDING_TOGGLE_MAIN_RELATED_ITEMS] = "Schatzkarten & Fundberichte & Spuren",
    [SI.TELE_KEYBINDING_REFRESH] = "Trefferliste aktualisieren",
    [SI.TELE_KEYBINDING_WAYSHRINE_UNLOCK] = "Wegschrein-Freischaltung",
    [SI.TELE_KEYBINDING_PRIMARY_RESIDENCE] = "Schnellreise in den Hauptwohnsitz",
    [SI.TELE_KEYBINDING_GUILD_HOUSE_BMU] = "BeamMeUp Gildenhaus besuchen",
    [SI.TELE_KEYBINDING_CURRENT_ZONE] = "Schnellreise ins aktuelle Gebiet",
    [SI.TELE_KEYBINDING_PRIMARY_RESIDENCE_OUTSIDE] = "Schnellreise vor den Hauptwohnsitz",
    [SI.TELE_KEYBINDING_TOGGLE_MAIN_DUNGEON_FINDER] = "Arenen / Prüfungen / Verliese",
    [SI.TELE_KEYBINDING_TRACKED_QUEST] = "Schnellreise zur verfolgten Quest",
    [SI.TELE_KEYBINDING_ANY_ZONE] = "Schnellreise in beliebiges Gebiet",
    [SI.TELE_KEYBINDING_WAYSHRINE_FAVORITE] = "Wegschrein-Favorit",


    -----------------------------------------------------------------------------
    -- DIALOGS | NOTIFICATIONS
    -----------------------------------------------------------------------------
    [SI.TELE_DIALOG_NO_BMU_GUILD_BODY] = "Es tut uns leid, aber es scheint, dass noch keine BeamMeUp Gilde auf diesem Server existiert.\n\nZögere nicht, uns über die ESOUI-Website zu kontaktieren und eine offizielle BeamMeUp Gilde auf diesem Server zu starten.",
    [SI.TELE_DIALOG_INFO_BMU_GUILD_BODY] = "Hallo und vielen Dank, dass du BeamMeUp nutzt. Im Jahr 2019 haben wir mehrere BeamMeUp Gilden gegründet, um kostenlose Schnellreise-Möglichkeiten zu teilen. Jeder ist willkommen, keine Voraussetzungen oder Verpflichtungen!\n\nWenn du diesen Dialog bestätigst, siehst du die offizielen und Partner-Gilden in der Liste des Addons. Du bist herzlich eingeladen, beizutreten! Du kannst die Gilden auch finden, indem du auf den Gilden-Button in der oberen linken Ecke klickst.\nDein BeamMeUp-Team",
    [SI.TELE_DIALOG_INFO_NEW_FEATURE_FAVORITE_PLAYER_NOTIFICATION] = "Du erhältst eine Benachrichtigung (Bildschirmmeldung), wenn ein Spieler-Favorit online kommt.\n\nDiese Funktion aktivieren?",
    [SI.TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION] = "Wenn du einen Fundbericht abbaust und sich noch weitere identische Fundberichte (selbe Stelle) in deinem Inventar befinden, wird dich eine Benachrichtigung darüber informieren.\n\nDiese Funktion aktivieren?",
    [SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE] = "Integration von \"Port to Friend's House\"",
    [SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY] = "Um die Integration zu nutzen, installiere bitte das Addon \"Port to Friend's House\". Du wirst dann deine konfigurierten Häuser und Gildenhallen hier in der Liste sehen.\n\nJetzt die \"Port to Friend's House\" Addon-Website öffnen?",
    -- AUTO UNLOCK: Start Dialog
    [SI.TELE_DIALOG_AUTO_UNLOCK_TITLE] = "Automatische Wegschrein-Freischaltung starten?",
    [SI.TELE_DIALOG_AUTO_UNLOCK_BODY] = "Durch Bestätigen startet BeamMeUp die Schnellreise zu allen verfügbaren Spielern in der aktuellen Zone. Auf diese Weise springst du automatisch von Wegschrein zu Wegschrein, um so viele wie möglich zu entdecken.",
    [SI.TELE_DIALOG_AUTO_UNLOCK_LOOP_OPTION] = "Dauerschleife über die Zonen ...",
    [SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION1] = "zufällig",
    [SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION2] = "nach Verhältnis der unentdeckten Wegschreine",
    [SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION3] = "nach Anzahl der Spieler",
    [SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION4] = "nach Zonennamen",
    [SI.TELE_DIALOG_AUTO_UNLOCK_CHAT_LOG_OPTION] = "Ergebnisse im Chat ausgeben",
    -- AUTO UNLOCK: Refuse Dialogs
    [SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE] = "Wegschrein-Freischaltung ist nicht möglich",
    [SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY] = "Alle Wegschreine in der Zone wurden bereits entdeckt.",
    [SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2] = "Die Wegschrein-Freischaltung ist in dieser Zone nicht möglich. Die Funktion ist nur in Regionen/Überlandgebieten verfügbar.",
    [SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY3] = "Leider gibt es in der Zone keine Spieler, zu denen du reisen kannst.",
    -- AUTO UNLOCK: Process Dialog
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART] = "Wegschrein-Freischaltung läuft ...",
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY] = "Neu entdeckte Wegschreine:",
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP] = "Gewonnene EP:",
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_PROGRESS] = "Fortschritt:",
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_TIMER] = "Nächster Sprung in:",
    -- AUTO UNLOCK: Finish Dialog
    [SI.TELE_DIALOG_FINISH_AUTO_UNLOCK_BODY_PART] = "Automatische Wegschrein-Freischaltung abgeschlossen.",
    -- AUTO UNLOCK: Timeout Dialog
    [SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_TITLE] = "Zeitüberschreitung",
    [SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_BODY] = "Entschuldigung, ein unbekannter Fehler ist aufgetreten. Die Wegschrein-Freischaltung wurde abgebrochen.",
    -- AUTO UNLOCK: Loop Finish Dialog
    [SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE] = "Wegschrein-Freischaltung abgeschlossen",
    [SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY] = "Es wurden keine weiteren Zonen gefunden. Entweder gibt es keine Spieler in den Zonen oder du hast bereits alle Wegschreine entdeckt.",



    -----------------------------------------------------------------------------
    -- CENTER SCREEN NOTIFICATIONS
    -----------------------------------------------------------------------------
    [SI.TELE_CENTERSCREEN_OFFLINE_NOTE_HEAD] = "Beachte: Du bist immer noch auf offline gestellt!",
    [SI.TELE_CENTERSCREEN_OFFLINE_NOTE_BODY] = "Keiner kann dich anflüstern oder zu dir reisen!\n|c8c8c8c(Meldung deaktivierbar in BeamMeUp Einstellungen)",
    [SI.TELE_CENTERSCREEN_SURVEY_MAPS] = "Du hast noch %d von diesen Fundberichten übrig! Komm nach dem Respawn zurück!",
    [SI.TELE_CENTERSCREEN_FAVORITE_PLAYER_ONLINE] = "ist jetzt online!",



    -----------------------------------------------------------------------------
    -- ITEM NAMES (PART OF IT) - BACKUP
    -----------------------------------------------------------------------------
    [SI.CONSTANT_TREASURE_MAP] = "schatzkarte", -- need a part of the item name that is in every treasure map item the same no matter which zone
    [SI.CONSTANT_SURVEY_MAP] = "fundbericht", -- need a part of the item name that is in every survey map item the same no matter which zone and kind of craft



    -----------------------------------------------------------------------------
    -- LibScrollableMenu - Context menu strings --INS260127 Baertram
    -----------------------------------------------------------------------------
    [SI.CONSTANT_LSM_CLICK_SUBMENU_TOGGLE_ALL] = "Alle Untermenü Einträge AN/AUS schalten",
}

local overrideStr = SafeAddString --do not overwrite with ZO_AddString, but just create a new version to override the exiitng ones created with ZO_CreateStringId!
for k, v in pairs(strings) do
    overrideStr(_G[k], v, 2)
end 