local BMU = BMU
local SI = BMU.SI

local strings = {
    -----------------------------------------------------------------------------
    -- INTERFACE
    -----------------------------------------------------------------------------
    [SI.TELE_UI_TOTAL] = "Wyniki:",
    [SI.TELE_UI_GOLD] = "Oszczędzone złoto:",
    [SI.TELE_UI_GOLD_ABBR] = "k",
    [SI.TELE_UI_GOLD_ABBR2] = "m",
    [SI.TELE_UI_TOTAL_PORTS] = "Ilość podróży:",
    ---------
    --------- Buttons
    [SI.TELE_UI_BTN_REFRESH_ALL] = "Odśwież listę",
    [SI.TELE_UI_BTN_UNLOCK_WS] = "Odblokuj teleporty w obecnej strefie",
    [SI.TELE_UI_BTN_FIX_WINDOW] = "Okno błędów",
    [SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE] = "Przełącz do BeamMeUp",
    [SI.TELE_UI_BTN_TOGGLE_BMU] = "Przełącz do Przewodnika",
    [SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE] = "Posiadane domy",
    [SI.TELE_UI_BTN_ANCHOR_ON_MAP] = "Odepnij / Przypnij na mapie",
    [SI.TELE_UI_BTN_GUILD_BMU] = "Gildie BeamMeUp i partnerzy",
    [SI.TELE_UI_BTN_GUILD_HOUSE_BMU] = "Odwiedź siedzibę BeamMeUp",
    [SI.TELE_UI_BTN_PTF_INTEGRATION] = "\"Port to Friend's House\" Integracja",
    [SI.TELE_UI_BTN_DUNGEON_FINDER] = "Areny / Triale / Lochy",
    [SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU] = "\n|c777777(prawoklik by otworzyć opcje)",
    ---------
    --------- List
    [SI.TELE_UI_UNRELATED_ITEMS] = "Mapy w innej strefie",
    [SI.TELE_UI_UNRELATED_QUESTS] = "Zadania w innej strefie",
    [SI.TELE_UI_SAME_INSTANCE] = "Tożsama lokalizacja",
    [SI.TELE_UI_DIFFERENT_INSTANCE] = "Inna lokalizacja",
    [SI.TELE_UI_GROUP_EVENT] = "Grupowe wydarzenie",
    ---------
    --------- Menu
    [SI.TELE_UI_FAVORITE_PLAYER] = "Ulubiony gracz",
    [SI.TELE_UI_FAVORITE_ZONE] = "Ulubiona strefa",
    [SI.TELE_UI_VOTE_TO_LEADER] = "Głosowanie na lidera",
    [SI.TELE_UI_RESET_COUNTER_ZONE] = "Resetuj licznik",
    [SI.TELE_UI_INVITE_BMU_GUILD] = "Zaproś do gildii BeamMeUp",
    [SI.TELE_UI_SHOW_QUEST_MARKER_ON_MAP] = "Pokaż znacznik zadania",
    [SI.TELE_UI_RENAME_HOUSE_NICKNAME] = "Przemianuj dom",
    [SI.TELE_UI_TOGGLE_HOUSE_NICKNAME] = "Pokaż nazwy",
    [SI.TELE_UI_VIEW_MAP_ITEM] = "Pokaż przedmiot - mapa",
    [SI.TELE_UI_TOGGLE_ARENAS] = "Areny Jednoosobowe",
    [SI.TELE_UI_TOGGLE_GROUP_ARENAS] = "Areny Grupowe",
    [SI.TELE_UI_TOGGLE_TRIALS] = "Triale",
    [SI.TELE_UI_TOGGLE_ENDLESS_DUNGEONS] = "Nieskończone lochy",
    [SI.TELE_UI_TOGGLE_GROUP_DUNGEONS] = "Lochy",
    [SI.TELE_UI_TOGGLE_SORT_ACRONYM] = "Sortuj wg. skrótu",
    [SI.TELE_UI_DAYS_LEFT] = "Pozostało %d dni",
    [SI.TELE_UI_TOGGLE_UPDATE_NAME] = "Pokaż nazwę aktualizacji",
    [SI.TELE_UI_UNLOCK_WAYSHRINES] = "Automatyczne odkrywanie kapliczek",
    [SI.TELE_UI_TOOGLE_ZONE_NAME] = "Pokaż nazwę strefy",
    [SI.TELE_UI_TOGGLE_SORT_RELEASE] = "Sortuj wg. daty wydania",
    [SI.TELE_UI_TOGGLE_ACRONYM] = "Pokaż akronim",
    [SI.TELE_UI_TOOGLE_DUNGEON_NAME] = "Pokaż pełną nazwę",
    [SI.TELE_UI_TRAVEL_PARENT_ZONE] = "Port to parent zone",
    [SI.TELE_UI_SET_PREFERRED_HOUSE] = "Set as preferred house",
    [SI.TELE_UI_UNSET_PREFERRED_HOUSE] = "Unset preferred house",



    -----------------------------------------------------------------------------
    -- CHAT OUTPUTS
    -----------------------------------------------------------------------------
    [SI.TELE_CHAT_FAVORITE_UNSET] = "Nie wybrano ulubionego miejsca",
    [SI.TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL] = "Gracz jest offline lub ukryty przez ustawione filtry",
    [SI.TELE_CHAT_NO_FAST_TRAVEL] = "Nie znaleziono opcji Szybkiej Podróży",
    [SI.TELE_CHAT_NOT_IN_GROUP] = "Nie jesteś w grupie",
    [SI.TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED] = "Nie ustawiono Głównej Rezydencji!",
    [SI.TELE_CHAT_GROUP_LEADER_YOURSELF] = "Jesteś liderem grupy",
    [SI.TELE_CHAT_UNLOCK_WS_DISCOVERED_TOTAL] = "Ilość kapliczek odkrytych w strefie:",
    [SI.TELE_CHAT_UNLOCK_WS_NEED_DISCOVERED] = "Następujące kapliczki nadal muszą być osobiście odwiedzone:",
    [SI.TELE_CHAT_SHARING_FOLLOW_LINK] = "Przekierowanie do linka...",
    [SI.TELE_CHAT_AUTO_UNLOCK_CANCELED] = "Automatyczne odblokowywanie przerwane przez użytkownika.",
    [SI.TELE_CHAT_AUTO_UNLOCK_SKIP] = "Błąd szybkiej podróży: pominięto tego gracza.",



    -----------------------------------------------------------------------------
    -- SETTINGS
    -----------------------------------------------------------------------------
    [SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN] = "Otwórz BeamMeUp kiedy mapa jest otwarta",
    [SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP] = "Kiedy otworzysz mapę, BeamMeUp automatycznie się otworzy, w innym przypadku użyj przycisku na górze mapy po lewej oraz przełącznika w panelu przewodnika po mapie.",
    [SI.TELE_SETTINGS_ZONE_ONCE_ONLY] = "Pokaż każdą strefę tylko raz.",
    [SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP] = "Pokaż tylko jedno wyszukanie dla każdej strefy.",
    [SI.TELE_SETTINGS_AUTO_PORT_FREQ] = "Częstotliwość odblokowywania teleportów (ms)",
    [SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP] = "Dopasuj częstotliwość automatycznego odblokowywania teleportów. Dla słabszych komputerów lub by zapobiec możliwym rozłączeniom gry wysoka wartość może być pomocna.",
    [SI.TELE_SETTINGS_AUTO_REFRESH] = "Odśwież i zresetuj otwierając",
    [SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP] = "Odśwież listę wyników każdorazowo przy otwarciu BeamMeUp. Pola do uzupełnienia są puste.",
    [SI.TELE_SETTINGS_HEADER_BLACKLISTING] = "Czarna lista",
    [SI.TELE_SETTINGS_HIDE_OTHERS] = "Ukryj niedostępne strefy",
    [SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP] = "Ukryj strefy takie jak Wirująca Arena, Schronienia banitów i strefy solo.",
    [SI.TELE_SETTINGS_HIDE_PVP] = "Ukryj strefy PvP",
    [SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP] = "Ukryj strefy takie jak Cyrodiil, Cesarskie Miasto oraz Pola Bitewne.",
    [SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS] = "Ukryj grupowe lochy i triale",
    [SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP] = "Ukryj wszystkie 4-osobowe grupowe lochy, 12-osobowe triale i grupowe lochy w Craglornie. Członkowie grupy w tych strefach wciąż będą pokazywani!",
    [SI.TELE_SETTINGS_HIDE_HOUSES] = "Ukryj rezydencje",
    [SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP] = "Ukryj wszystkie rezydencje.",
    [SI.TELE_SETTINGS_WINDOW_STAY] = "Utrzymaj BeamMeUp otwarte",
    [SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP] = "Kiedy otworzysz BeamMeUp bez mapy, pozostanie tam nawet jeśli się poruszysz lub otworzysz inne okna. Jeśli uzywasz tej opcji, rekomendujemy wyłączyć opcję 'Zamknij BeamMeUp kiedy mapa jest zamknięta'.",
    [SI.TELE_SETTINGS_ONLY_MAPS] = "Pokazuj tylko Regiony/Lądy",
    [SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP] = "Pokazuj tylko gówne Regiony jak Deshaan or Summerset.",
    [SI.TELE_SETTINGS_AUTO_REFRESH_FREQ] = "Częstotliwość odświeżania",
    [SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP] = "Kiedy BeamMeUp jest otwarte, automatyczne odświeżanie listy wyników odbywa się co x sekund. Ustaw wartość na 0 by wyłączyć automatyczne odświeżanie.",
    [SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN] = "Aktywuj okno wyszukiwania strefy",
    [SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP] = "Aktywuj okno wyszukiwania strefy kiedy BeamMeUp jest otwarty razem z mapą.",
    [SI.TELE_SETTINGS_HIDE_DELVES] = "Ukryj Groty",
    [SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP] = "Ukryj wszystkie Groty.",
    [SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS] = "Ukryj Publiczne Lochy",
    [SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP] = "Ukryj wszystkie Publiczne Lochy.",
    [SI.TELE_SETTINGS_FORMAT_ZONE_NAME] = "Ukryj okienka z nazwami stref",
    [SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP] = "Ukryj okienka z nazwami stref, aby zapewnić lepsze sortowanie i szybciej znajdować strefy.",
    [SI.TELE_SETTINGS_NUMBER_LINES] = "Ilość wersów/wyszukań",
    [SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP] = "Przez ustawienie ilości widocznych wersów/wyszukań możesz kontrolować całkowitą wysokość dodatku.",
    [SI.TELE_SETTINGS_HEADER_ADVANCED] = "Opcje zaawansowane",
    [SI.TELE_SETTINGS_HEADER_UI] = "Ogólne",
    [SI.TELE_SETTINGS_HEADER_RECORDS] = "Wyszukiwanie",
    [SI.TELE_SETTINGS_CLOSE_ON_PORTING] = "Automatycznie zamknij mapę i BeamMeUp",
    [SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP] = "Zamknij mapę i BeamMeUp po rozpoczęciu procesu podróży.",
    [SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS] = "Pokaż ilość graczy na mapę",
    [SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP] = "Pokazuje ilość graczy na mapie, do których możesz podróżować. Możesz kliknąć na numer by zobaczyć tych wszystkich graczy.",
    [SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET] = "Przesunięcie przycisku w oknie czatu",
    [SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP] = "Zmień przesunięcie poziome przycisku w nagłówku czatu, aby uniknąć wizualnych konfliktów z innymi ikonami dodatków.",
    [SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES] = "Przeszukuj również imiona postaci",
    [SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP] = "Przeszukuj również imiona postaci kiedy szukasz graczy.",
    [SI.TELE_SETTINGS_SORTING] = "Sortowanie",
    [SI.TELE_SETTINGS_SORTING_TOOLTIP] = "Wybierz jeden z możliwych rodzajów listy.",
    [SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE] = "Drugi język wyszukiwania",
    [SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP] = "Możesz wyszukiwać według nazw stref w języku domyślnym i tym drugim języku jednocześnie. Etykietka nazwy strefy wyświetla także nazwę w drugim języku.",
    [SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE] = "Powiadomienia o ulubionych graczach online",
    [SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP] = "Otrzymasz powiadomienie (wiadomość na środku ekranu), gdy jeden z ulubionych graczy bedzie online.",
    [SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE] = "Zamknij BeamMeUp kiedy mapa jest zamknięta",
    [SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP] = "Kiedy zamykasz mapę, BeamMeUp również się zamyka.",
    [SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL] = "Przesunięcie pozycji dokowania mapy w poziomie",
    [SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP] = "Możesz dostosować poziome przesunięcie dokowania na mapie.",
    [SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL] = "Przesunięcie pozycji dokowania mapy w pionie",
    [SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP] = "Możesz dostosować pionowe przesunięcie dokowania na mapie.",
    [SI.TELE_SETTINGS_RESET_ALL_COUNTERS] = "Zresetuj wszystkie liczniki stref",
    [SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP] = "Wszystkie liczniki stref będą zresetowane. Sortowanie wg. najczęściej używanych zostaje zresetowane.",
    [SI.TELE_SETTINGS_OFFLINE_NOTE] = "Powiadomienie o statusie offline",
    [SI.TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP] = "Jeśli ustawisz status offline i chcesz szeptać lub podróżować do kogoś, dostaniesz krótki komunikat na ekranie jako przypomnienie. Tak długo jak jesteś 'offline' nie możesz dostać żadnych szeptanych wiadomości i z nikim nie podzielisz się najbliższą kapliczką (a dzielenie się jest fajne).",
    [SI.TELE_SETTINGS_SCALE] = "Skalowanie interfejsu",
    [SI.TELE_SETTINGS_SCALE_TOOLTIP] = "Współczynnik skalowania dla całego interfejsu/okna BeamMeUp. Aby zastosować zmiany konieczne jest przeładowanie.",
    [SI.TELE_SETTINGS_RESET_UI] = "Resetuj interfejs",
    [SI.TELE_SETTINGS_RESET_UI_TOOLTIP] = "Resetuj interfejs BeamMeUp przez ustawienie następujących opcji na domyślne: Skalowanie, Przesunięcie przycisku, Przesunięcie dokowania mapy i pozycje okna. Cały interfejs zostanie zresetowany.",
    [SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION] = "Powiadomienie o mapie surowców",
    [SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP] = "Jeśli wydobywasz surowce z mapy i masz nadal jakieś identyczne mapy (ta sama lokalizacja) w swoim ekwipunku, powiadomienie (wiadomość na środku ekranu) poinformuje Cię o tym.",
    [SI.TELE_SETTINGS_HEADER_PRIO] = "Priorytety",
    [SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS] = "Komendy Czatu",
    [SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION] = "Możesz wybrać, którzy gracze będą preferowani w opcji szybkiej podróży. Po opuszczeniu lub przyłączeniu się do gildii, odświeżenie jest potrzebne by poprawnie wyświetlić.",
    [SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP] = "Pokaż dodatkowy przycisk na mapie",
    [SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP] = "Pokaż przycisk z tekstem w górnym lewym rogu mapy świata do otwierania BeamMeUp.",
    [SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND] = "Odtwarzaj dźwięki",
    [SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP] = "Odtwórz dźwięk pokazując powiadomienie.",
    [SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL] = "Automatyczne potwierdzenie podróży do kapliczki",
    [SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP] = "Wyłącz potwierdzanie podróży do kapliczki oknem dialogowym.",
    [SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP] = "Pokaż aktualną strefę zawsze na górze",
    [SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP] = "Pokazuj aktualną strefę zawsze na górze listy.",
    [SI.TELE_SETTINGS_HIDE_OWN_HOUSES] = "Ukryj posiadane domy",
    [SI.TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP] = "Ukryj swoje posiadane domy (teleportacja na zewnątrz) w głównej liście.",
    [SI.TELE_SETTINGS_HEADER_STATS] = "Statystyki",
    [SI.TELE_SETTINGS_MOST_PORTED_ZONES] = "Najczęściej odwiedzane strefy:",
    [SI.TELE_SETTINGS_INSTALLED_SCINCE] = "Zainstalowane co najmniej od:",
    [SI.TELE_SETTINGS_INFO_CHARACTER_DEPENDING] = "Ta opcja jest przypięta do postaci (nie całego konta)!",
    [SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION] = "Animacja teleportacji",
    [SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP] = "Pokaż dodatkową animację teleportacji gdy podróżujesz przez BeamMeUp. Kolekcjonerski przedmiot 'Błyskotka Finvira' musi być odblokowany.",
    [SI.TELE_SETTINGS_SHOW_CHAT_BUTTON] = "Przycisk w oknie czatu",
    [SI.TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP] = "Wyświetl przycisk w nagłówku okna czatu, które będzie otwierać BeamMeUp.",
    [SI.TELE_SETTINGS_USE_PAN_AND_ZOOM] = "Przesuń i powiększ",
    [SI.TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP] = "Przesuń i powiększ mapę do celu kiedy klikasz na członka grupy lub konkretną lokację (lochy, domy, itd.).",
    [SI.TELE_SETTINGS_USE_RALLY_POINT] = "Znacznik mapy",
    [SI.TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP] = "Pokazuje znacznik mapy (punkt zbiórki) jako cel na mapie kiedy klikniesz na członka grupy lub konkretną lokację (lochy, domy, itd.). Biblioteka LibMapPing musi być zainstalowana. Pamiętaj również, że jeśli jesteś liderem grupy Twoje zaznaczenia (punkty zbiórki) są widoczne dla wszystkich członków grupy.",
    [SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS] = "Pokaż mapy bez graczy i domów",
    [SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP] = "Pokazuje mapy w głównej liście nawet jeśli nie ma w niej gracza ani domu do którego możesz podróżować. Nadal masz możliwość podróżować za złoto jeżeli odkryto co najmniej jedną kapliczkę na tej mapie.",
    [SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP] = "Wyświetlana strefa i podstrefy zawsze na górze",
    [SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP_TOOLTIP] = "Pokaż aktualnie wyświetlaną na mapie świata strefę oraz jej podstrefy zawsze na górze listy.",
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
    [SI.TELE_KEYBINDING_TOGGLE_MAIN] = "Otwórz BeamMeUp",
    [SI.TELE_KEYBINDING_TOGGLE_MAIN_RELATED_ITEMS] = "Mapy skarbów, surowców i wskazówki wizji",
    [SI.TELE_KEYBINDING_REFRESH] = "Odśwież listę wyników",
    [SI.TELE_KEYBINDING_WAYSHRINE_UNLOCK] = "Odblokuj kapliczki w obecnej strefie",
    [SI.TELE_KEYBINDING_PRIMARY_RESIDENCE] = "Podróż do Głównej Rezydencji",
    [SI.TELE_KEYBINDING_GUILD_HOUSE_BMU] = "Odwiedź siedzibę BeamMeUp",
    [SI.TELE_KEYBINDING_CURRENT_ZONE] = "Podróżuj do obecnej strefy",
    [SI.TELE_KEYBINDING_PRIMARY_RESIDENCE_OUTSIDE] = "Podróż na zewnątrz Głównej Rezydencji",
    [SI.TELE_KEYBINDING_TOGGLE_MAIN_DUNGEON_FINDER] = "Areny / Triale / Lochy",
    [SI.TELE_KEYBINDING_TRACKED_QUEST] = "Podróż do śledzonego zadania",
    [SI.TELE_KEYBINDING_ANY_ZONE] = "Losowy teleport",
    [SI.TELE_KEYBINDING_WAYSHRINE_FAVORITE] = "Wayshrine Favorite",


    -----------------------------------------------------------------------------
    -- DIALOGS | NOTIFICATIONS
    -----------------------------------------------------------------------------
    [SI.TELE_DIALOG_NO_BMU_GUILD_BODY] = "Bardzo nam przykro, ale wygląda na to, że na tym serwerze nie ma jeszcze gildii BeamMeUp. \n\nSkontaktuj się z nami za pośrednictwem strony ESOUI i załóż oficjalną gildię BeamMeUp na tym serwerze.",
    [SI.TELE_DIALOG_INFO_BMU_GUILD_BODY] = "Witamy i dziękujemy za korzystanie z BeamMeUp. W 2019 r. uruchomiliśmy oficjalne gildie BeamMeUp w celu udostępniania bezpłatnych opcji szybkiej podróży. Wszyscy są mile widziani, żadnych wymagań ani zobowiązań!\n\nPo potwierdzeniu tego okna dialogowego zobaczysz spis gildii BeamMeUp oraz gildii partnerskich. Zapraszamy do przyłączenia się! Możesz również znaleźć te gildie klikając przycisk gildii w lewym górnym rogu.\nWasz zespół BeamMeUp",
    [SI.TELE_DIALOG_INFO_NEW_FEATURE_FAVORITE_PLAYER_NOTIFICATION] = "Otrzymasz powiadomienie (komunikat środku ekranu), gdy ulubiony gracz wejdzie do gry.\n\nWłączyć tę funkcję?",
    [SI.TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION] = "Jeśli wydobywasz surowce z mapy i masz nadal jakieś identyczne mapy (ta sama lokalizacja) w swoim ekwipunku, powiadomienie (wiadomość na środku ekranu) poinformuje Cię o tym.\n\nWłączyć tę funkcję?",
    [SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE] = "Integracja \"Port to Friend's House\"",
    [SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY] = "Aby skorzystać z funkcji integracji, zainstaluj dodatek \"Port to Friend's House\". Na liście zobaczysz skonfigurowane domy i siedziby gildii.\n\nCzy chcesz teraz otworzyć stronę z dodatkiem \"Port to Friend's House\"?",
    -- AUTO UNLOCK: Start Dialog
    [SI.TELE_DIALOG_AUTO_UNLOCK_TITLE] = "Zacząć automatyczne odblokowanie kapliczek?",
    [SI.TELE_DIALOG_AUTO_UNLOCK_BODY] = "Użycie sprawia, że BeamMeUp rozpocznie serię szybkich podróży do wszystkich dostępnych graczy w aktualnej strefie. W ten sposób będziesz automatycznie skakać z jednej kapliczki do następnej by odblokować tak wiele jak to możliwe.",
    [SI.TELE_DIALOG_AUTO_UNLOCK_LOOP_OPTION] = "Zapętlone odblokowywanie map...",
    [SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION1] = "losowo",
    [SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION2] = "wg. ilości nieodkrytych kapliczek",
    [SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION3] = "wg. ilości graczy",
    [SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION4] = "wg. nazwy strefy",
    [SI.TELE_DIALOG_AUTO_UNLOCK_CHAT_LOG_OPTION] = "Umieść wyniki w oknie chatu",
    -- AUTO UNLOCK: Refuse Dialogs
    [SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE] = "Odblokowanie jest niemożliwe",
    [SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY] = "Wszystkie kapliczki na tej mapie zostały już odblokowane.",
    [SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2] = "Odblokowanie kapliczek nie jest możliwe na tej mapie. Ta funkcja jest dostępna tylko w głównych strefach/lądach.",
    [SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY3] = "Niestety, nie ma graczy w strefie, do których można by podróżować.",
    -- AUTO UNLOCK: Process Dialog
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART] = "Uruchomiono automatyczne odblokowywanie kapliczek...",
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY] = "Nowo odkryte kapliczki:",
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP] = "Zdobyte doświadczenie:",
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_PROGRESS] = "Postęp:",
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_TIMER] = "Następna podróż za:",
    -- AUTO UNLOCK: Finish Dialog
    [SI.TELE_DIALOG_FINISH_AUTO_UNLOCK_BODY_PART] = "Ukończono automatyczne odblokowywanie kapliczek.",
    -- AUTO UNLOCK: Timeout Dialog
    [SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_TITLE] = "Zbyt długi czas oczekiwania",
    [SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_BODY] = "Przepraszamy, wystąpił nieznany błąd. Automatyczne odblokowywanie zostało przerwane.",
    -- AUTO UNLOCK: Loop Finish Dialog
    [SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE] = "Ukończono automatyczne odblokowywanie",
    [SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY] = "Nie znaleziono więcej map do odblokowywania. Albo nie ma graczy na tych mapach albo już odkryłeś wszystkie kapliczki.",



    -----------------------------------------------------------------------------
    -- CENTER SCREEN NOTIFICATIONS
    -----------------------------------------------------------------------------
    [SI.TELE_CENTERSCREEN_OFFLINE_NOTE_HEAD] = "Uwaga: Masz ustawiony status offline!",
    [SI.TELE_CENTERSCREEN_OFFLINE_NOTE_BODY] = "Nikt nie może szeptać lub podróżować do Ciebie!\n|c8c8c8c(Powiadomienie może być wyłączone w ustawieniach BeamMeUp)",
    [SI.TELE_CENTERSCREEN_SURVEY_MAPS] = "Nadal masz %d taką mapę/mapy badawcze! Wróć tu za chwilę!",
    [SI.TELE_CENTERSCREEN_FAVORITE_PLAYER_ONLINE] = "jest teraz online!",



    -----------------------------------------------------------------------------
    -- ITEM NAMES (PART OF IT) - BACKUP
    -----------------------------------------------------------------------------
    [SI.CONSTANT_TREASURE_MAP] = "mapa skarbu", -- need a part of the item name that is in every treasure map item the same no matter which zone
    [SI.CONSTANT_SURVEY_MAP] = "survey:", -- need a part of the item name that is in every survey map item the same no matter which zone and kind of craft

    -----------------------------------------------------------------------------
    -- LibScrollableMenu - Context menu strings --INS260127 Baertram
    -----------------------------------------------------------------------------
    [SI.CONSTANT_LSM_CLICK_SUBMENU_TOGGLE_ALL] = "Toggle all submenu entries ON/OFF", --todo 260127
}

local overrideStr = SafeAddString --do not overwrite with ZO_AddString, but just create a new version to override the exiitng ones created with ZO_CreateStringId!
for k, v in pairs(strings) do
    overrideStr(_G[k], v, 2)
end