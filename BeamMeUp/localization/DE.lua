-----------------------------------------------------------------------------
-- INTERFACE
-----------------------------------------------------------------------------
local strings = {
    ["SI_TELE_UI_TOTAL"] = "Treffer:",
    ["SI_TELE_UI_GOLD"] = "Gold gespart:",
    ["SI_TELE_UI_GOLD_ABBR"] = "Tsd",
    ["SI_TELE_UI_GOLD_ABBR2"] = "Mio",
    ["SI_TELE_UI_TOTAL_PORTS"] = "Reisen gesamt:",
    ---------
    --------- Buttons
    ["SI_TELE_UI_BTN_REFRESH_ALL"] = "Trefferliste neu laden",
    ["SI_TELE_UI_BTN_UNLOCK_WS"] = "Wegschreine im aktuellen Gebiet automatisch freischalten",
    ["SI_TELE_UI_BTN_FIX_WINDOW"] = "Fenster fixieren / lösen",
    ["SI_TELE_UI_BTN_TOGGLE_ZONE_GUIDE"] = "Wechsel zu BeamMeUp",
    ["SI_TELE_UI_BTN_TOGGLE_BMU"] = "Wechsel zum Kartenfortschritt",
    ["SI_TELE_UI_BTN_PORT_TO_OWN_HOUSE"] = "Eigene Häuser",
    ["SI_TELE_UI_BTN_ANCHOR_ON_MAP"] = "Ab- / Andocken an Karte",
    ["SI_TELE_UI_BTN_GUILD_BMU"] = "BeamMeUp Gilden & Partner Gilden",
    ["SI_TELE_UI_BTN_GUILD_HOUSE_BMU"] = "BeamMeUp Gildenhaus besuchen",
    ["SI_TELE_UI_BTN_PTF_INTEGRATION"] = "\"Port to Friend's House\" Integration",
    ["SI_TELE_UI_BTN_DUNGEON_FINDER"] = "Arenen / Prüfungen / Verliese",
    ["SI_TELE_UI_BTN_TOOLTIP_CONTEXT_MENU"] = "\n|c777777(Rechtsklick für weitere Optionen)",
    ---------
    --------- List
    ["SI_TELE_UI_UNRELATED_ITEMS"] = "Karten in anderen Gebieten",
    ["SI_TELE_UI_UNRELATED_QUESTS"] = "Quests in anderen Gebieten",
    ["SI_TELE_UI_SAME_INSTANCE"] = "Gleiche Instanz",
    ["SI_TELE_UI_DIFFERENT_INSTANCE"] = "Andere Instanz",
    ["SI_TELE_UI_GROUP_EVENT"] = "Gruppenwagnis",
    ---------
    --------- Menu
    ["SI_TELE_UI_FAVORITE_PLAYER"] = "Spieler-Favorit",
    ["SI_TELE_UI_FAVORITE_ZONE"] = "Zonen-Favorit",
    ["SI_TELE_UI_VOTE_TO_LEADER"] = "Zum Anführer voten",
    ["SI_TELE_UI_RESET_COUNTER_ZONE"] = "Zähler zurücksetzen",
    ["SI_TELE_UI_INVITE_BMU_GUILD"] = "Zur BeamMeUp Gilde einladen",
    ["SI_TELE_UI_SHOW_QUEST_MARKER_ON_MAP"] = "Zeige Questmarker",
    ["SI_TELE_UI_RENAME_HOUSE_NICKNAME"] = "Spitzname des Hauses umbenennen",
    ["SI_TELE_UI_TOGGLE_HOUSE_NICKNAME"] = "Zeige Spitznamen",
    ["SI_TELE_UI_VIEW_MAP_ITEM"] = "Kartenelement ansehen",
    ["SI_TELE_UI_TOGGLE_ARENAS"] = "Solo-Arenen",
    ["SI_TELE_UI_TOGGLE_GROUP_ARENAS"] = "Gruppen-Arenen",
    ["SI_TELE_UI_TOGGLE_TRIALS"] = "Prüfungen",
    ["SI_TELE_UI_TOGGLE_ENDLESS_DUNGEONS"] = "Endlose Verliese",
    ["SI_TELE_UI_TOGGLE_GROUP_DUNGEONS"] = "Verliese",
    ["SI_TELE_UI_TOGGLE_SORT_ACRONYM"] = "Nach Kürzel sortieren",
    ["SI_TELE_UI_DAYS_LEFT"] = "%d Tage",
    ["SI_TELE_UI_TOGGLE_UPDATE_NAME"] = "Zeige Update Name",
    ["SI_TELE_UI_UNLOCK_WAYSHRINES"] = "Wegschreine automatisch freischalten",
    ["SI_TELE_UI_TOOGLE_ZONE_NAME"] = "Zeige Zonen Name",
    ["SI_TELE_UI_TOGGLE_SORT_RELEASE"] = "Nach Erscheinung sortieren",
    ["SI_TELE_UI_TOGGLE_ACRONYM"] = "Zeige Kürzel",
    ["SI_TELE_UI_TOOGLE_DUNGEON_NAME"] = "Zeige Instanz Name",
    ["SI_TELE_UI_TRAVEL_PARENT_ZONE"] = "Schnellreise in die Eltern-Zone",
    ["SI_TELE_UI_SET_PREFERRED_HOUSE"] = "Als bevorzugtes Haus festlegen",
    ["SI_TELE_UI_UNSET_PREFERRED_HOUSE"] = "Bevorzugtes Haus freigeben",



    -----------------------------------------------------------------------------
    -- CHAT OUTPUTS
    -----------------------------------------------------------------------------
    ["SI_TELE_CHAT_FAVORITE_UNSET"] = "Favoriten-Slot ist unbesetzt",
    ["SI_TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL"] = "Der Spieler ist offline oder wird durch gesetzte Filter ausgeblendet",
    ["SI_TELE_CHAT_NO_FAST_TRAVEL"] = "Keine Schnellreise-Möglichkeit gefunden",
    ["SI_TELE_CHAT_NOT_IN_GROUP"] = "Du bist in keiner Gruppe",
    ["SI_TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED"] = "Kein Hauptwohnsitz gesetzt!",
    ["SI_TELE_CHAT_GROUP_LEADER_YOURSELF"] = "Du selbst bist der Gruppenanführer",
    ["SI_TELE_CHAT_UNLOCK_WS_DISCOVERED_TOTAL"] = "Insgesamt entdeckte Wegschreine in der Zone:",
    ["SI_TELE_CHAT_UNLOCK_WS_NEED_DISCOVERED"] = "Die folgenden Wegschreine müssen noch physisch besucht werden:",
    ["SI_TELE_CHAT_SHARING_FOLLOW_LINK"] = "Folge dem Link ...",
    ["SI_TELE_CHAT_AUTO_UNLOCK_CANCELED"] = "Wegschrein-Freischaltung durch Nutzer abgebrochen.",
    ["SI_TELE_CHAT_AUTO_UNLOCK_SKIP"] = "Schnellreise Fehler: Überspringe aktuellen Spieler.",



    -----------------------------------------------------------------------------
    -- SETTINGS
    -----------------------------------------------------------------------------
    --Addon Extensions
    ["SI_TELE_LIB_INSTALLED"] = "Installiert, und aktiv",
    ["SI_TELE_LIB_NOT_INSTALLED"] = "Nicht installiert, oder inaktiv",
    ["SI_TELE_SETTINGS_ADDON_EXTENSIONS"] = "AddOn Erweiterungen",
    ["SI_TELE_ADDON_EXT_DESC"] = "Holen Sie das Beste aus BeamMeUp heraus, indem Sie es zusammen mit den folgenden Add-ons verwenden.",
    ["SI_TELE_ADDON_EXT_OPEN_URL"] = "Öffne AddOn Webseite",
    ["SI_TELE_ADDON_EXT_PTF_DESC"] = "Greife direkt über BeamMeUp auf deine Häuser und Gildenhallen zu. Deine Häuser, die sich im PTF-Modus befinden, werden in einer separaten Liste angezeigt.",
    ["SI_TELE_ADDON_EXT_LIBSETS_DESC"] = "Überprüfe deinen Fortschritt beim Sammeln von Set-Gegenständen in BeamMeUp und sortiere deine Schnellreiseoptionen. Die Anzahl der gesammelten Set-Gegenstände wird in der QuickInfo der Zonennamen angezeigt. Außerdem kannst du deine Ergebnisse nach der Anzahl der fehlenden Set-Gegenstände sortieren.",
    ["SI_TELE_ADDON_EXT_LIBMAPPING_DESC"] = "Nutzen Sie Markierungen (Treffpunkte) auf der Karte, anstatt zu zoomen, wenn Sie auf bestimmte Zonennamen oder Gruppenmitglieder klicken. Eine Option in den „Zusätzlichen Funktionen“ ermöglicht das Umschalten zwischen der Markierung auf der Karte und der Zoom- und Schwenkfunktion.",
    ["SI_TELE_ADDON_EXT_LIBSLASHCOMMANDER_DESC"] = "Erhalten Sie umfassende Autovervollständigung, Farbkennzeichnung und Kurzbeschreibung für Chat-Befehle.",
    ["SI_TELE_ADDON_EXT_LIBCHATMENUBTN_DESC"] = "Die Positionierung des BMU-Chat-Buttons sollte in einer externen Bibliothek erfolgen. Das Konzept von Bibliotheken wird unterstützt. Allerdings geht dadurch die Möglichkeit verloren, eine individuelle Offset-Position festzulegen.",
    ["SI_TELE_ADDON_EXT_IJAGBMUGP_DESC"] = "Nutze BeamMeUp im Gamepad-Modus. Damit gibt es für BeamMeUp eine dedizierte Gamepad-Unterstützung. Das |cFF00FFIsJusta|rBeamMeUp Gamepad-Plugin integriert die Funktionen von BeamMeUp in die Gamepad-Oberfläche und ermöglicht dir komfortableres Reisen als je zuvor.",

    --Andere Einstellungen
    ["SI_TELE_SETTINGS_SHOW_ON_MAP_OPEN"] = "Öffne BeamMeUp zusammen mit der Karte",
    ["SI_TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP"] = "Wenn du die Karte öffnest, öffnet sich auch BeamMeUp. Wenn du diese Funktion deaktivierst, kannst du BeamMeUp auch über den Button auf der Karte oben links, über den Button in der Chat-Box und über den Toggle-Button öffnen.",
    ["SI_TELE_SETTINGS_ZONE_ONCE_ONLY"] = "Nur ein Eintrag pro Gebiet",
    ["SI_TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP"] = "Zeige nur einen Eintrag pro Gebiet anstatt jeden einzelnen Treffer.",
    ["SI_TELE_SETTINGS_AUTO_PORT_FREQ"] = "Frequenz der Wegschrein-Freischaltung (ms)",
    ["SI_TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP"] = "Passe die Frequenz der automatischen Wegschrein-Freischaltung an. Bei langsameren Rechnern oder um eventuelle Kicks durch Spam zu verhindern kann ein höherer Wert helfen.",
    ["SI_TELE_SETTINGS_AUTO_REFRESH"] = "Zurücksetzen und neu laden beim Öffnen",
    ["SI_TELE_SETTINGS_AUTO_REFRESH_TOOLTIP"] = "Trefferliste beim Öffnen neu laden. Suchfelder und Scroll-Leiste werden ebenfalls zurückgesetzt.",
    ["SI_TELE_SETTINGS_HEADER_BLACKLISTING"] = "Schwarze Liste (Ziele ausblenden)",
    ["SI_TELE_SETTINGS_HIDE_OTHERS"] = "Ausblenden von gesperrten Gebieten",
    ["SI_TELE_SETTINGS_HIDE_OTHERS_TOOLTIP"] = "Blende unzugängliche Gebiete wie die Mahlstrom-Arena, Unterschlüpfe und Solo-Zonen aus.",
    ["SI_TELE_SETTINGS_HIDE_PVP"] = "Ausblenden von PVP-Gebieten",
    ["SI_TELE_SETTINGS_HIDE_PVP_TOOLTIP"] = "Blende PVP-Gebiete wie Cyrodiil, Schlachtfelder und die Gebiete der Kaiserstadt aus.",
    ["SI_TELE_SETTINGS_HIDE_CLOSED_DUNGEONS"] = "Ausblenden von Gruppen-Verliesen und Prüfungen",
    ["SI_TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP"] = "Blende alle 4-Spieler-Gruppeninstanzen, 12-Spieler-Prüfungen, die Drachenstern-Arena und Kargstein-Gruppen-Verliese aus. Gruppenmitglieder in diesen Zonen werden trotzdem angezeigt!",
    ["SI_TELE_SETTINGS_HIDE_HOUSES"] = "Ausblenden von Häusern",
    ["SI_TELE_SETTINGS_HIDE_HOUSES_TOOLTIP"] = "Blende alle Häuser aus.",
    ["SI_TELE_SETTINGS_WINDOW_STAY"] = "BeamMeUp geöffnet halten",
    ["SI_TELE_SETTINGS_WINDOW_STAY_TOOLTIP"] = "Wenn du BeamMeUp ohne Karte öffnest, bleibt das Fenster offen, auch wenn du dich bewegst oder andere Fenster öffnest. Wenn du diese Option nutzt, empfiehlt es sich die Option 'Öffne / Schließe BeamMeUp mit Karte' zu deaktivieren.",
    ["SI_TELE_SETTINGS_ONLY_MAPS"] = "Zeige nur Regionen",
    ["SI_TELE_SETTINGS_ONLY_MAPS_TOOLTIP"] = "Zeige ausschließlich Regionen bzw. Oberflächen-Maps wie Deshaan oder Sommersend.",
    ["SI_TELE_SETTINGS_AUTO_REFRESH_FREQ"] = "Aktualisierungsintervall (s)",
    ["SI_TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP"] = "Wenn BeamMeUp geöffnet ist, wird eine automatische Aktualisierung der Ergebnisse alle x Sekunden durchgeführt. Setze den Wert auf 0 um die automatische Aktualisierung abzuschalten.",
    ["SI_TELE_SETTINGS_FOCUS_ON_MAP_OPEN"] = "Zonen-Suchfeld fokussieren",
    ["SI_TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP"] = "Fokussiere das Suchfeld für Zonen, wenn BeamMeUp geöffnet wird.",
    ["SI_TELE_SETTINGS_HIDE_DELVES"] = "Ausblenden von Gewölben",
    ["SI_TELE_SETTINGS_HIDE_DELVES_TOOLTIP"] = "Blende alle Gewölbe (Fackel-Symbol) aus.",
    ["SI_TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS"] = "Ausblenden von Öffentlichen Verliesen",
    ["SI_TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP"] = "Blende alle öffentlichen Verliese aus.",
    ["SI_TELE_SETTINGS_FORMAT_ZONE_NAME"] = "Artikel der Zonen ausblenden",
    ["SI_TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP"] = "Blende die Artikel der Zonennamen aus, damit diese durch eine bessere Sortierung schneller gefunden werden können.",
    ["SI_TELE_SETTINGS_NUMBER_LINES"] = "Anzahl der Zeilen / Einträge",
    ["SI_TELE_SETTINGS_NUMBER_LINES_TOOLTIP"] = "Mit der Anzahl der sichtbaren Zeilen bzw. Einträge kann die Höhe des Addons justiert werden.",
    ["SI_TELE_SETTINGS_HEADER_ADVANCED"] = "Extra Funktionen",
    ["SI_TELE_SETTINGS_HEADER_UI"] = "Allgemein",
    ["SI_TELE_SETTINGS_HEADER_RECORDS"] = "Ergebnisse",
    ["SI_TELE_SETTINGS_CLOSE_ON_PORTING"] = "Automatisches Schließen",
    ["SI_TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP"] = "Schließe Karte und BeamMeUp nachdem der Schnellreisevorgang gestartet wurde.",
    ["SI_TELE_SETTINGS_SHOW_NUMBER_PLAYERS"] = "Zeige Anzahl der Spieler pro Gebiet",
    ["SI_TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP"] = "Zeige die Anzahl der Spieler im jeweiligen Gebiet an, zu denen du Reisen kannst. Durch einen Klick auf die Zahl werden alle diese Spieler angezeigt.",
    ["SI_TELE_SETTINGS_CHAT_BUTTON_OFFSET"] = "Offset des Buttons in der Chatbox",
    ["SI_TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP"] = "Erhöhe den horizontalen Offset des Buttons im Kopfbereich der Chatbox, um visuelle Konflikte mit anderen Addon-Symbolen zu vermeiden.",
    ["SI_TELE_SETTINGS_SEARCH_CHARACTERNAMES"] = "Suche auch nach Charakternamen",
    ["SI_TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP"] = "Suche auch nach Charakternamen bei der Suche nach Spielern.",
    ["SI_TELE_SETTINGS_SORTING"] = "Sortierung",
    ["SI_TELE_SETTINGS_SORTING_TOOLTIP"] = "Wähle eine der möglichen Sortierungen der Liste.",
    ["SI_TELE_SETTINGS_SECOND_SEARCH_LANGUAGE"] = "Zweite Suchsprache",
    ["SI_TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP"] = "Du kannst in deiner Anzeigesprache und in dieser zweiten Sprache gleichzeitig nach Zonennamen suchen. Der Tooltip des Zonennamens zeigt auch den Namen in der zweiten Sprache an.",
    ["SI_TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE"] = "Benachrichtigung Spieler-Favorit Online",
    ["SI_TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP"] = "Du erhältst eine Benachrichtigung (Bildschirmmeldung), wenn ein Spieler-Favorit online kommt.",
    ["SI_TELE_SETTINGS_HIDE_ON_MAP_CLOSE"] = "Schließe BeamMeUp zusammen mit der Karte",
    ["SI_TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP"] = "Wenn du die Karte schließt, wird auch BeamMeUp geschlossen.",
    ["SI_TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL"] = "Offset der Karten Dock-Position - Horizontal",
    ["SI_TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP"] = "Hier kannst du den horizontalen Offset des Andockens an der Karte anpassen.",
    ["SI_TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL"] = "Offset der Karten Dock-Position - Vertikal",
    ["SI_TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP"] = "Hier kannst du den vertikalen Offset des Andockens an der Karte anpassen.",
    ["SI_TELE_SETTINGS_RESET_ALL_COUNTERS"] = "Zähler zurücksetzen",
    ["SI_TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP"] = "Alle Zähler werden zurückgesetzet. Dadurch wird auch die Sortierung nach 'am meisten verwendet' zurückgesetzt.",
    ["SI_TELE_SETTINGS_RESET_ALL_COUNTERS_WARN"] = "Alle Zähler werden zurückgesetzet. Dadurch wird auch die Sortierung nach 'am meisten verwendet' zurückgesetzt.",
    ["SI_TELE_SETTINGS_OFFLINE_NOTE"] = "Offline Erinnerung",
    ["SI_TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP"] = "Wenn du für eine Weile offline gestellt bist und jemandem anflüsterst oder zu ihm reist, erhältst du eine kurze Bildschirmnachricht als Erinnerung. Solange du offline gestellt bist, kannst du keine Flüsternachrichten empfangen und niemand kann zu dir reisen (aber Sharing is Caring).",
    ["SI_TELE_SETTINGS_SCALE"] = "UI Skalierung",
    ["SI_TELE_SETTINGS_SCALE_TOOLTIP"] = "Skalierungsfaktor für die BeamMeUp-Benutzeroberfläche. Änderungen werden erst nach einem Reload übernommen.",
    ["SI_TELE_SETTINGS_RESET_UI"] = "UI zurücksetzen",
    ["SI_TELE_SETTINGS_RESET_UI_TOOLTIP"] = "Zurücksetzen der BeamMeUp-Benutzeroberfläche durch das Zurücksetzen folgender Optionen: Skalierung, Button-Offset, Karten-Dock-Offsets und Fensterpositionen. Die gesamte UI wird neugeladen.",
    ["SI_TELE_SETTINGS_SURVEY_MAP_NOTIFICATION"] = "Fundberichte Benachrichtigung",
    ["SI_TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP"] = "Wenn du einen Fundbericht abbaust und sich noch weitere identische Fundberichte (selbe Stelle) in deinem Inventar befinden, wird dich eine Benachrichtigung darüber informieren.",
    ["SI_TELE_SETTINGS_HEADER_PRIO"] = "Priorisierung",
    ["SI_TELE_SETTINGS_HEADER_CHAT_COMMANDS"] = "Chat Befehle",
    ["SI_TELE_SETTINGS_PRIORITIZATION_DESCRIPTION"] = "Hier kannst du einstellen, welche Spieler vorzugsweise für die Schnellreise genutzt werden sollen. Nach dem Beitritt oder Verlassen einer Gilde ist ein Reload erforderlich, um hier korrekt angezeigt zu werden.",
    ["SI_TELE_SETTINGS_SHOW_BUTTON_ON_MAP"] = "Zusätzliche Schaltfläche auf der Karte anzeigen",
    ["SI_TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP"] = "Zeigt in der oberen linken Ecke der Weltkarte eine Textschaltfläche zum Öffnen von BeamMeUp an.",
    ["SI_TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND"] = "Sound abspielen",
    ["SI_TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP"] = "Spielt einen Sound ab, wenn die Benachrichtigung angezeigt wird.",
    ["SI_TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL"] = "Automatische Bestätigung beim Wegschrein-Reisen",
    ["SI_TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP"] = "Deaktiviert den Bestätigungsdialog, wenn du zu anderen Wegschreinen reist.",
    ["SI_TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP"] = "Aktuelle Zone immer oben anzeigen",
    ["SI_TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP"] = "Aktuelle Zone immer an oberster Stelle der Liste anzeigen.",
    ["SI_TELE_SETTINGS_HIDE_OWN_HOUSES"] = "Ausblenden von EIGENEN Häusern",
    ["SI_TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP"] = "Blende alle eigene Häuser (außerhalb reisen) in der Hauptliste aus.",
    ["SI_TELE_SETTINGS_HEADER_STATS"] = "Statistiken",
    ["SI_TELE_SETTINGS_MOST_PORTED_ZONES"] = "Meist bereiste Zonen:",
    ["SI_TELE_SETTINGS_INSTALLED_SCINCE"] = "Mindestens installiert seit:",
    ["SI_TELE_SETTINGS_INFO_CHARACTER_DEPENDING"] = "Diese Option ist an deinem Charakter gebunden (nicht accountweit)!",
    ["SI_TELE_SETTINGS_SHOW_TELEPORT_ANIMATION"] = "Teleportanimation",
    ["SI_TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP"] = "Zeigt eine zusätzliche Animation, wenn eine Schnellreise über BeamMeUp gestartet wird. Das Sammlungsstück 'Finvirs Glücksbringer' muss freigeschaltet sein.",
    ["SI_TELE_SETTINGS_SHOW_CHAT_BUTTON"] = "Schaltfläche im Chat-Fenster",
    ["SI_TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP"] = "Anzeigen einer Schaltfläche im Kopfbereich des Chat-Fensters um BeamMeUp zu öffnen.",
    ["SI_TELE_SETTINGS_USE_PAN_AND_ZOOM"] = "Zentrieren und Zoomen",
    ["SI_TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP"] = "Schwenke und zoome zum Ziel auf der Karte, wenn du auf Gruppenmitglieder oder bestimmte Zonen (Dungeons, Häuser usw.) klickst.",
    ["SI_TELE_SETTINGS_USE_RALLY_POINT"] = "Karten-Ping",
    ["SI_TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP"] = "Zeigt einen Karten-Ping (Sammelpunkt) am Zielort auf der Karte an, wenn du auf Gruppenmitglieder oder bestimmte Zonen (Dungeons, Häuser etc.) klickst. Die Bibliothek LibMapPing muss installiert sein. Bedenke auch: Wenn du der Gruppenleiter bist, sind deine Pings (Sammelpunkt) für alle Gruppenmitglieder sichtbar.",
    ["SI_TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS"] = "Zeige Regionen ohne Schnellreise-Möglichkeit",
    ["SI_TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP"] = "Zeige Regionen bzw. Oberflächen-Maps in der Hauptliste an, auch wenn es keine Schnellreise-Möglichkeit gibt (kein Spieler oder Haus zu dem/das du reisen kannst).",
    ["SI_TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP"] = "Angezeigte Zone & Unterzonen immer oben anzeigen",
    ["SI_TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP_TOOLTIP"] = "Aktuell angezeigte Zone und Unterzonen (geöffnete Karte) immer an oberster Stelle der Liste anzeigen.",
    ["SI_TELE_SETTINGS_DEFAULT_TAB"] = "Standardliste",
    ["SI_TELE_SETTINGS_DEFAULT_TAB_TOOLTIP"] = "Die Liste, die standardmäßig beim Öffnen von BeamMeUp angezeigt wird.",
    ["SI_TELE_SETTINGS_HEADER_CHAT_OUTPUT"] = "Chat Meldungen",
    ["SI_TELE_SETTINGS_OUTPUT_FAST_TRAVEL"] = "Schnellreisevorgänge",
    ["SI_TELE_SETTINGS_OUTPUT_FAST_TRAVEL_TOOLTIP"] = "Informative Chat-Meldungen über die eingeleiteten Schnellreisen. Fehlermeldungen werden weiterhin im Chat angezeigt.",
    ["SI_TELE_SETTINGS_OUTPUT_ADDITIONAL"] = "Unterstützende Meldungen",
    ["SI_TELE_SETTINGS_OUTPUT_ADDITIONAL_TOOLTIP"] = "Weitere hilfreiche Chat-Meldungen zu verschiedenen Aktionen des Addons.",
    ["SI_TELE_SETTINGS_OUTPUT_UNLOCK"] = "Ergebnisse der Wegschrein-Freischaltung",
    ["SI_TELE_SETTINGS_OUTPUT_UNLOCK_TOOLTIP"] = "Zwischenergebnisse (entdeckte Wegschreine und XP) und unterstützende Chat-Meldungen der automatischen Wegschrein-Freischaltung.",
    ["SI_TELE_SETTINGS_OUTPUT_DEBUG"] = "Debug Meldungen",
    ["SI_TELE_SETTINGS_OUTPUT_DEBUG_TOOLTIP"] = "Technische Chat-Meldungen zur Fehlerbehebung. Dadurch wird der Chat zugespammt. Bitte nur auf Anfrage und nur für kurze Zeit verwenden!",
    ["SI_TELE_SETTINGS_OUTPUT_DEBUG_WARN"] = "Diese Option kann nicht permanent aktiviert bleiben.",

    ["SI_TELE_SETTINGS_SHOW_CNTXTMENU_ICONS"] = "Zeige Symbole in Kontextmenüs",
    ["SI_TELE_SETTINGS_SHOW_CNTXTMENU_ICONS_TOOLTIP"] = "Zeige Symbole in Kontextmenüs, um die relevanten Einträge einfacher zu finden",

    -----------------------------------------------------------------------------
    -- KEY BINDING
    -----------------------------------------------------------------------------
    ["SI_TELE_KEYBINDING_TOGGLE_MAIN"] = "Öffne BeamMeUp",
    ["SI_TELE_KEYBINDING_TOGGLE_MAIN_RELATED_ITEMS"] = "Schatzkarten & Fundberichte & Spuren",
    ["SI_TELE_KEYBINDING_REFRESH"] = "Trefferliste aktualisieren",
    ["SI_TELE_KEYBINDING_WAYSHRINE_UNLOCK"] = "Wegschrein-Freischaltung",
    ["SI_TELE_KEYBINDING_PRIMARY_RESIDENCE"] = "Schnellreise in den Hauptwohnsitz",
    ["SI_TELE_KEYBINDING_GUILD_HOUSE_BMU"] = "BeamMeUp Gildenhaus besuchen",
    ["SI_TELE_KEYBINDING_CURRENT_ZONE"] = "Schnellreise ins aktuelle Gebiet",
    ["SI_TELE_KEYBINDING_PRIMARY_RESIDENCE_OUTSIDE"] = "Schnellreise vor den Hauptwohnsitz",
    ["SI_TELE_KEYBINDING_TOGGLE_MAIN_DUNGEON_FINDER"] = "Arenen / Prüfungen / Verliese",
    ["SI_TELE_KEYBINDING_TRACKED_QUEST"] = "Schnellreise zur verfolgten Quest",
    ["SI_TELE_KEYBINDING_ANY_ZONE"] = "Schnellreise in beliebiges Gebiet",
    ["SI_TELE_KEYBINDING_WAYSHRINE_FAVORITE"] = "Wegschrein-Favorit",


    -----------------------------------------------------------------------------
    -- DIALOGS | NOTIFICATIONS
    -----------------------------------------------------------------------------
    ["SI_TELE_DIALOG_NO_BMU_GUILD_BODY"] = "Es tut uns leid, aber es scheint, dass noch keine BeamMeUp Gilde auf diesem Server existiert.\n\nZögere nicht, uns über die ESOUI-Website zu kontaktieren und eine offizielle BeamMeUp Gilde auf diesem Server zu starten.",
    ["SI_TELE_DIALOG_INFO_BMU_GUILD_BODY"] = "Hallo und vielen Dank, dass du BeamMeUp nutzt. Im Jahr 2019 haben wir mehrere BeamMeUp Gilden gegründet, um kostenlose Schnellreise-Möglichkeiten zu teilen. Jeder ist willkommen, keine Voraussetzungen oder Verpflichtungen!\n\nWenn du diesen Dialog bestätigst, siehst du die offizielen und Partner-Gilden in der Liste des Addons. Du bist herzlich eingeladen, beizutreten! Du kannst die Gilden auch finden, indem du auf den Gilden-Button in der oberen linken Ecke klickst.\nDein BeamMeUp-Team",
    ["SI_TELE_DIALOG_INFO_NEW_FEATURE_FAVORITE_PLAYER_NOTIFICATION"] = "Du erhältst eine Benachrichtigung (Bildschirmmeldung), wenn ein Spieler-Favorit online kommt.\n\nDiese Funktion aktivieren?",
    ["SI_TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION"] = "Wenn du einen Fundbericht abbaust und sich noch weitere identische Fundberichte (selbe Stelle) in deinem Inventar befinden, wird dich eine Benachrichtigung darüber informieren.\n\nDiese Funktion aktivieren?",
    ["SI_TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE"] = "Integration von \"Port to Friend's House\"",
    ["SI_TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY"] = "Um die Integration zu nutzen, installiere bitte das Addon \"Port to Friend's House\". Du wirst dann deine konfigurierten Häuser und Gildenhallen hier in der Liste sehen.\n\nJetzt die \"Port to Friend's House\" Addon-Website öffnen?",
    -- AUTO UNLOCK: Start Dialog
    ["SI_TELE_DIALOG_AUTO_UNLOCK_TITLE"] = "Automatische Wegschrein-Freischaltung starten?",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_BODY"] = "Durch Bestätigen startet BeamMeUp die Schnellreise zu allen verfügbaren Spielern in der aktuellen Zone. Auf diese Weise springst du automatisch von Wegschrein zu Wegschrein, um so viele wie möglich zu entdecken.",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_LOOP_OPTION"] = "Dauerschleife über die Zonen ...",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION1"] = "zufällig",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION2"] = "nach Verhältnis der unentdeckten Wegschreine",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION3"] = "nach Anzahl der Spieler",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION4"] = "nach Zonennamen",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_CHAT_LOG_OPTION"] = "Ergebnisse im Chat ausgeben",
    -- AUTO UNLOCK: Refuse Dialogs
    ["SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE"] = "Wegschrein-Freischaltung ist nicht möglich",
    ["SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY"] = "Alle Wegschreine in der Zone wurden bereits entdeckt.",
    ["SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2"] = "Die Wegschrein-Freischaltung ist in dieser Zone nicht möglich. Die Funktion ist nur in Regionen/Überlandgebieten verfügbar.",
    ["SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY3"] = "Leider gibt es in der Zone keine Spieler, zu denen du reisen kannst.",
    -- AUTO UNLOCK: Process Dialog
    ["SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART"] = "Wegschrein-Freischaltung läuft ...",
    ["SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY"] = "Neu entdeckte Wegschreine:",
    ["SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP"] = "Gewonnene EP:",
    ["SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_PROGRESS"] = "Fortschritt:",
    ["SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_TIMER"] = "Nächster Sprung in:",
    -- AUTO UNLOCK: Finish Dialog
    ["SI_TELE_DIALOG_FINISH_AUTO_UNLOCK_BODY_PART"] = "Automatische Wegschrein-Freischaltung abgeschlossen.",
    -- AUTO UNLOCK: Timeout Dialog
    ["SI_TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_TITLE"] = "Zeitüberschreitung",
    ["SI_TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_BODY"] = "Entschuldigung, ein unbekannter Fehler ist aufgetreten. Die Wegschrein-Freischaltung wurde abgebrochen.",
    -- AUTO UNLOCK: Loop Finish Dialog
    ["SI_TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE"] = "Wegschrein-Freischaltung abgeschlossen",
    ["SI_TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY"] = "Es wurden keine weiteren Zonen gefunden. Entweder gibt es keine Spieler in den Zonen oder du hast bereits alle Wegschreine entdeckt.",



    -----------------------------------------------------------------------------
    -- CENTER SCREEN NOTIFICATIONS
    -----------------------------------------------------------------------------
    ["SI_TELE_CENTERSCREEN_OFFLINE_NOTE_HEAD"] = "Beachte: Du bist immer noch auf offline gestellt!",
    ["SI_TELE_CENTERSCREEN_OFFLINE_NOTE_BODY"] = "Keiner kann dich anflüstern oder zu dir reisen!\n|c8c8c8c(Meldung deaktivierbar in BeamMeUp Einstellungen)",
    ["SI_TELE_CENTERSCREEN_SURVEY_MAPS"] = "Du hast noch %d von diesen Fundberichten übrig! Komm nach dem Respawn zurück!",
    ["SI_TELE_CENTERSCREEN_FAVORITE_PLAYER_ONLINE"] = "ist jetzt online!",



    -----------------------------------------------------------------------------
    -- ITEM NAMES (PART OF IT) - BACKUP
    -----------------------------------------------------------------------------
    ["SI_CONSTANT_TREASURE_MAP"] = "schatzkarte", -- need a part of the item name that is in every treasure map item the same no matter which zone
    ["SI_CONSTANT_SURVEY_MAP"] = "fundbericht", -- need a part of the item name that is in every survey map item the same no matter which zone and kind of craft


    -----------------------------------------------------------------------------
    --SLASH COMMANDS
    -----------------------------------------------------------------------------
    ["SI_TELE_SETTINGS_SLASH_PTZONE_DESC"] = "Teleportiere zu einer bestimmten Zone\n(Tipp: wenn du anfängst zu tippen /<zone Name> wird die Auto-Vervollständigung dir Vorschläge anzeigen (LibSlashCommander muss aktiv sein))\n",
    ["SI_TELE_SETTINGS_SLASH_PTGROUPLEADER_DESC"] = "Teleportiere zum Gruppenanführer\n",
    ["SI_TELE_SETTINGS_SLASH_PTCURFOCUSQUEST_DESC"] = "Teleportiere zur aktuell verfolgten Quest\n",
    ["SI_TELE_SETTINGS_SLASH_PTPRIMARYHOUSE_DESC"] = "Teleportiere in deine primäre Residenz\n",
    ["SI_TELE_SETTINGS_SLASH_PTOUTPRIMARYHOUSE_DESC"] = "Teleportiere vor (ausserhalb) deine primäre Residenz\n",
    ["SI_TELE_SETTINGS_SLASH_PTCURZONE_DESC"] = "Teleportiere zur aktuellen Zone\n",
    ["SI_TELE_SETTINGS_SLASH_ADDFAVZONE_DESC"] = "Füge einen Zonen Favorit manuell hinzu\n",
    ["SI_TELE_SETTINGS_SLASH_ADDFAVPLAYER_DESC"] = "Füge einen Spieler Favorit manuell hinzu\n",
    ["SI_TELE_SETTINGS_SLASH_ADDFAVWAYSHRINE_DESC"] = "Füge einen Wegschrein Favorit hinzu\nNach dem Ausführen musst du mit dem Favoriten Wegschrein innerhalb von 10 Sekunden interagieren (Standard Taste `E`). Du kannst auch Tastenkombinationen für deine Favoriten Wegschreine definieren.\n",
    ["SI_TELE_SETTINGS_SLASH_ADDFAVHOUSEZONE_DESC"] = "Füge Haus Favorit für eine ZonenID hinzu\n",
    ["SI_TELE_SETTINGS_SLASH_ADDFAVHOUSECURZONE_DESC"] = "Füge Haus Favorit für die aktuelle Zone hinzu\n",
    ["SI_TELE_SETTINGS_SLASH_ADDFAVTHISHOUSECURZONE_DESC"] = "Füge das aktuelle Haus als Favorit für die aktuelle Zone hinzu\n",
    ["SI_TELE_SETTINGS_SLASH_REMFAVHOUSECURZONE_DESC"] = "Lösche Haus Favorit für die aktuelle Zone\n",
    ["SI_TELE_SETTINGS_SLASH_REMFAVHOUSEZONE_DESC"] = "Lösche Haus für Zone\n",
    ["SI_TELE_SETTINGS_SLASH_LISTFAVHOUSE_DESC"] = "Liste Haus Favoriten auf\n",
    ["SI_TELE_SETTINGS_SLASH_GROUPCUSTVOTE100_DESC"] = "Starte Gruppenabfrage (100% Teilnahme erforderlich)\n",
    ["SI_TELE_SETTINGS_SLASH_GROUPCUSTVOTE60_DESC"] = "Starte Gruppenabfrage (>=60% Teilnahme erforderlich)\n",
    ["SI_TELE_SETTINGS_SLASH_GROUPCUSTVOTE50_DESC"] = "Starte Gruppenabfrage (>50% Teilnahme erforderlich)\n",
    ["SI_TELE_SETTINGS_SLASH_CHATPROMBMU_DESC"] = "BeamMeUp im Chat promoten, mit einem Werbungstext\n",
    ["SI_TELE_SETTINGS_SLASH_BMUGETZONEID_DESC"] = "Erhalte die aktuelle ZonenID (in welcher der Spieler sich befindet)\n",
    ["SI_TELE_SETTINGS_SLASH_BMUCHANGELANG_DESC"] = "Wechsle die Sprache des Clients (Achtung: Sofortiger Reload der UI!)\n",
    ["SI_TELE_SETTINGS_SLASH_BMUDEBUGMODE_DESC"] = "Aktiviere den Debug Modus\n",


    -----------------------------------------------------------------------------
    --Dynamic choices for LAM dropdown
    -----------------------------------------------------------------------------
    --Second language
    ["SI_TELE_DROPDOWN_SECOND_LANG_CHOICE_1"] = "DEAKTIVIERT",
    ["SI_TELE_DROPDOWN_SECOND_LANG_CHOICE_2"] = "Englisch",
    ["SI_TELE_DROPDOWN_SECOND_LANG_CHOICE_3"] = "Deutsch",
    ["SI_TELE_DROPDOWN_SECOND_LANG_CHOICE_4"] = "Französisch",
    ["SI_TELE_DROPDOWN_SECOND_LANG_CHOICE_5"] = "Russisch",
    ["SI_TELE_DROPDOWN_SECOND_LANG_CHOICE_6"] = "Japanisch",
    ["SI_TELE_DROPDOWN_SECOND_LANG_CHOICE_7"] = "Polnisch",

    --Sorting
    ["SI_TELE_DROPDOWN_SORT_CHOICE_1"] = "Zonen Name",
    ["SI_TELE_DROPDOWN_SORT_CHOICE_2"] = "Zonen Kategorie > Zonen Name",
    ["SI_TELE_DROPDOWN_SORT_CHOICE_3"] = "Am meisten verwendete Zone > Zonen Name",
    ["SI_TELE_DROPDOWN_SORT_CHOICE_4"] = "Am meisten verwendete Zone > Zonen Kategorie > Zonen Name",
    ["SI_TELE_DROPDOWN_SORT_CHOICE_5"] = "Anzahl Spieler > Zonen Name",
    ["SI_TELE_DROPDOWN_SORT_CHOICE_6"] = "Unentdeckte Wegschreine > Zonen Kategorie > Zonen Name",
    ["SI_TELE_DROPDOWN_SORT_CHOICE_7"] = "Unentdeckte Himmelsscherben > Zonen Kategorie > Zonen Name",
    ["SI_TELE_DROPDOWN_SORT_CHOICE_8"] = "Zuletzt verwendete Zone > Zonen Name",
    ["SI_TELE_DROPDOWN_SORT_CHOICE_9"] = "Zuletzt verwendete Zone > Zonen Kategorie > Zonen Name",
    ["SI_TELE_DROPDOWN_SORT_CHOICE_10"] = "Fehlende Set Gegenstände > Zonen Kategorie > Zonen Name (LibSets muss aktiviert sein)",
    ["SI_TELE_DROPDOWN_SORT_CHOICE_11"] = "Zonen Kategorie (Zonen ohne freie Teleport Option am Ende) > Zonen Name",


    -----------------------------------------------------------------------------
    -- LibScrollableMenu - Context menu strings --INS260127 Baertram
    -----------------------------------------------------------------------------
    ["SI_CONSTANT_LSM_CLICK_SUBMENU_TOGGLE_ALL"] = "Alle Untermenü Einträge AN/AUS schalten",
}

local overrideStr = SafeAddString --do not overwrite with ZO_AddString, but just create a new version to override the exiitng ones created with ZO_CreateStringId!
for k, v in pairs(strings) do
    overrideStr(_G[k], v, 2)
end 