local strings = {
    -----------------------------------------------------------------------------
    -- INTERFACE
    -----------------------------------------------------------------------------
    ["SI_TELE_UI_TOTAL"] = "Всего:",
    ["SI_TELE_UI_GOLD"] = "Сохр. золото:",
    ["SI_TELE_UI_GOLD_ABBR"] = "k",
    ["SI_TELE_UI_GOLD_ABBR2"] = "m",
    ["SI_TELE_UI_TOTAL_PORTS"] = "Перемещений:",
    ---------
    --------- Buttons
    ["SI_TELE_UI_BTN_REFRESH_ALL"] = "Обновить все локации",
    ["SI_TELE_UI_BTN_UNLOCK_WS"] = "Разблокировка дорожных святилищ в текущей локации",
    ["SI_TELE_UI_BTN_FIX_WINDOW"] = "За/разморозить окно",
    ["SI_TELE_UI_BTN_TOGGLE_ZONE_GUIDE"] = "Показать BeamMeUp",
    ["SI_TELE_UI_BTN_TOGGLE_BMU"] = "Показать Zone Guide",
    ["SI_TELE_UI_BTN_PORT_TO_OWN_HOUSE"] = "Свои дома",
    ["SI_TELE_UI_BTN_ANCHOR_ON_MAP"] = "Открепить / Прикрепить",
    ["SI_TELE_UI_BTN_GUILD_BMU"] = "Официальная гильдия и партнёры BeamMeUp",
    ["SI_TELE_UI_BTN_GUILD_HOUSE_BMU"] = "Гильдхолл BeamMeUp",
    ["SI_TELE_UI_BTN_PTF_INTEGRATION"] = "Поддержка \"Port to Friend's House\"",
    ["SI_TELE_UI_BTN_DUNGEON_FINDER"] = "Арены / Испытания / Подземелья",
    ["SI_TELE_UI_BTN_TOOLTIP_CONTEXT_MENU"] = "\n|c777777(правый клик для параметров)",
    ---------
    --------- List
    ["SI_TELE_UI_UNRELATED_ITEMS"] = "Другие карты сокровищ.",
    ["SI_TELE_UI_UNRELATED_QUESTS"] = "Квесты в других зонах",
    ["SI_TELE_UI_SAME_INSTANCE"] = "Тот же инстанс",
    ["SI_TELE_UI_DIFFERENT_INSTANCE"] = "Разные инстансы",
    ["SI_TELE_UI_GROUP_EVENT"] = "Групповое событие",
    ---------
    --------- Menu
    ["SI_TELE_UI_FAVORITE_PLAYER"] = "Избранный игрок",
    ["SI_TELE_UI_FAVORITE_ZONE"] = "Избранная локация",
    ["SI_TELE_UI_VOTE_TO_LEADER"] = "Голосовать за Лидера",
    ["SI_TELE_UI_RESET_COUNTER_ZONE"] = "Сбросить счетчик",
    ["SI_TELE_UI_INVITE_BMU_GUILD"] = "Пригласить в гильдию BeamMeUp",
    ["SI_TELE_UI_SHOW_QUEST_MARKER_ON_MAP"] = "Показать маркер квеста",
    ["SI_TELE_UI_RENAME_HOUSE_NICKNAME"] = "Сменить название дома",
    ["SI_TELE_UI_TOGGLE_HOUSE_NICKNAME"] = "Показать названия домов",
    ["SI_TELE_UI_VIEW_MAP_ITEM"] = "Показать свиток",
    ["SI_TELE_UI_TOGGLE_ARENAS"] = "Одиночные арены",
    ["SI_TELE_UI_TOGGLE_GROUP_ARENAS"] = "Групповые арены",
    ["SI_TELE_UI_TOGGLE_TRIALS"] = "Испытания",
    ["SI_TELE_UI_TOGGLE_ENDLESS_DUNGEONS"] = "Бесконечные подземелья",
    ["SI_TELE_UI_TOGGLE_GROUP_DUNGEONS"] = "Групповые подземелья",
    ["SI_TELE_UI_TOGGLE_SORT_ACRONYM"] = "Отсортировать по аббревиатуре",
    ["SI_TELE_UI_DAYS_LEFT"] = "осталось %d дней",
    ["SI_TELE_UI_TOGGLE_UPDATE_NAME"] = "Показать название обновления",
    ["SI_TELE_UI_UNLOCK_WAYSHRINES"] = "Автоматическое открытие дорожных святилищ",
    ["SI_TELE_UI_TOOGLE_ZONE_NAME"] = "Показать название зоны",
    ["SI_TELE_UI_TOGGLE_SORT_RELEASE"] = "Сортировать по дате выпуска",
    ["SI_TELE_UI_TOGGLE_ACRONYM"] = "Показать аббревиатуру",
    ["SI_TELE_UI_TOOGLE_DUNGEON_NAME"] = "Показать название инстанса",
    ["SI_TELE_UI_TRAVEL_PARENT_ZONE"] = "Port to parent zone",
    ["SI_TELE_UI_SET_PREFERRED_HOUSE"] = "Set as preferred house",
    ["SI_TELE_UI_UNSET_PREFERRED_HOUSE"] = "Unset preferred house",
    
    
    
    -----------------------------------------------------------------------------
    -- CHAT OUTPUTS
    -----------------------------------------------------------------------------
    ["SI_TELE_CHAT_FAVORITE_UNSET"] = "Избранный слот не установлен",
    ["SI_TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL"] = "Игрок не в сети или скрыт фильтрами",
    ["SI_TELE_CHAT_NO_FAST_TRAVEL"] = "Опция быстрого перемещения не найдена",
    ["SI_TELE_CHAT_NOT_IN_GROUP"] = "Вы не в группе",
    ["SI_TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED"] = "Основной дом не установлен!",
    ["SI_TELE_CHAT_GROUP_LEADER_YOURSELF"] = "Вы лидер группы",
    ["SI_TELE_CHAT_UNLOCK_WS_DISCOVERED_TOTAL"] = "Всего святилищ открыто в этой зоне:",
    ["SI_TELE_CHAT_UNLOCK_WS_NEED_DISCOVERED"] = "Эти дорожные святилища все еще надо посетить лично:",
    ["SI_TELE_CHAT_SHARING_FOLLOW_LINK"] = "Следуем по ссылке ...",
    ["SI_TELE_CHAT_AUTO_UNLOCK_CANCELED"] = "Автоматическое обнаружение отменено пользователем.",
    ["SI_TELE_CHAT_AUTO_UNLOCK_SKIP"] = "Ошибка быстрого перемещения: пропустить текущего игрока.",
    
    
    
    -----------------------------------------------------------------------------
    -- SETTINGS
    -----------------------------------------------------------------------------
    ["SI_TELE_SETTINGS_SHOW_ON_MAP_OPEN"] = "Открывать BeamMeUp при открытии карты",
    ["SI_TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP"] = "Когда вы откроете карту, автоматически откроется BeamMeUp, в противном случае вы получите кнопку в левом верхнем углу карты.",
    ["SI_TELE_SETTINGS_ZONE_ONCE_ONLY"] = "Показыть локацию только один раз",
    ["SI_TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP"] = "Показать только одну запись для каждой найденной локации.",
    ["SI_TELE_SETTINGS_AUTO_PORT_FREQ"] = "Частота разблокировки дорожных святилищ (мс)",
    ["SI_TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP"] = "Регулировка частоты автоматической разблокировки дорожных святилищ. Для медленных компьютеров или для предотвращения возможных вылетов из игры, может помочь более высокое значение.",
    ["SI_TELE_SETTINGS_AUTO_REFRESH"] = "Обновить и сбросить при открытии",
    ["SI_TELE_SETTINGS_AUTO_REFRESH_TOOLTIP"] = "Обновляйть список каждый раз, когда вы открываете BeamMeUp. Поля ввода будут очищены.",
    ["SI_TELE_SETTINGS_HEADER_BLACKLISTING"] = "Черный список",
    ["SI_TELE_SETTINGS_HIDE_OTHERS"] = "Скрыть недоступные локации",
    ["SI_TELE_SETTINGS_HIDE_OTHERS_TOOLTIP"] = "Скрыть такие локации, как Maelstrom Arena, Outlaw Refuges и одиночные локации.",
    ["SI_TELE_SETTINGS_HIDE_PVP"] = "Скрыть PvP локации",
    ["SI_TELE_SETTINGS_HIDE_PVP_TOOLTIP"] = "Скрыть локации, такие как Сиродил, Имперский город и Поля Битвы.",
    ["SI_TELE_SETTINGS_HIDE_CLOSED_DUNGEONS"] = "Скрыть Групповые Подземелья и Испытания",
    ["SI_TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP"] = "Скрыть Групповые Подземелья (4 игрока), Испытания (12 игроков) и Групповые Подземелья в Краглорне. Участники группы в этих зонах все равно будут отображаться!",
    ["SI_TELE_SETTINGS_HIDE_HOUSES"] = "Скрыть дома",
    ["SI_TELE_SETTINGS_HIDE_HOUSES_TOOLTIP"] = "Скрыть дома.",
    ["SI_TELE_SETTINGS_WINDOW_STAY"] = "Держать BeamMeUp открытым",
    ["SI_TELE_SETTINGS_WINDOW_STAY_TOOLTIP"] = "Когда вы открываете BeamMeUp через привязанную клавишу, он останется открытым, даже если вы откроете другие окна. Если вы используете эту опцию, рекомендуется отключить опцию «Открыть/Закрыть BeamMeUp с картой».",
    ["SI_TELE_SETTINGS_ONLY_MAPS"] = "Показать только Регионы/Сухопутные Карты",
    ["SI_TELE_SETTINGS_ONLY_MAPS_TOOLTIP"] = "Показать только основные регионы, такие как Дешаан или Саммерсет.",
    ["SI_TELE_SETTINGS_AUTO_REFRESH_FREQ"] = "Интервал обновления (с)",
    ["SI_TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP"] = "Когда BeamMeUp открыт, обновление результатов выполняется автоматически каждые x секунд. Установите значение на 0, чтобы отключить автоматическое обновление.",
    ["SI_TELE_SETTINGS_FOCUS_ON_MAP_OPEN"] = "Фокус области поиска локации",
    ["SI_TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP"] = "Фокус области поиска локации, когда BeamMeUp открыт вместе с картой.",
    ["SI_TELE_SETTINGS_HIDE_DELVES"] = "Скрыть Вылазки",
    ["SI_TELE_SETTINGS_HIDE_DELVES_TOOLTIP"] = "Скрыть все Вылазки.",
    ["SI_TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS"] = "Скрыть Публичные Подземелья",
    ["SI_TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP"] = "Скрыть все Публичные Подземелья.",
    ["SI_TELE_SETTINGS_FORMAT_ZONE_NAME"] = "Скрыть артикли у названий локаций",
    ["SI_TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP"] = "Скрыть артикул у названий локаций, чтобы обеспечить лучшую сортировку и быстрее находить нужные локации.",
    ["SI_TELE_SETTINGS_NUMBER_LINES"] = "Количество строк/записей",
    ["SI_TELE_SETTINGS_NUMBER_LINES_TOOLTIP"] = "Установив количество видимых строк/записей, вы можете контролировать общую высоту аддона.",
    ["SI_TELE_SETTINGS_HEADER_ADVANCED"] = "Дополнительные функции",
    ["SI_TELE_SETTINGS_HEADER_UI"] = "Общие настройки",
    ["SI_TELE_SETTINGS_HEADER_RECORDS"] = "Записи",
    ["SI_TELE_SETTINGS_CLOSE_ON_PORTING"] = "Автоматически закрывать карту и BeamMeUp",
    ["SI_TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP"] = "Закрывать карту и BeamMeUp после начала перемещения.",
    ["SI_TELE_SETTINGS_SHOW_NUMBER_PLAYERS"] = "Показывать число игроков на карте",
    ["SI_TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP"] = "Показывать число игроков, доступных для перемещения на картах. Нажмите на число, чтобы увидеть их список.",
    ["SI_TELE_SETTINGS_CHAT_BUTTON_OFFSET"] = "Смещение кнопки в окне текста",
    ["SI_TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP"] = "Увеличть горизонтальный отступ кнопки в заголовке окна текста во избедание наложений на иконки дргих адд-онов.",
    ["SI_TELE_SETTINGS_SEARCH_CHARACTERNAMES"] = "Искать имена персонажей",
    ["SI_TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP"] = "При поиске игроков искать также имена персонажей.",
    ["SI_TELE_SETTINGS_SORTING"] = "Сортировка",
    ["SI_TELE_SETTINGS_SORTING_TOOLTIP"] = "Выберите один из вариантов сортировки списка.",
    ["SI_TELE_SETTINGS_SECOND_SEARCH_LANGUAGE"] = "Второй язык поиска",
    ["SI_TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP"] = "Вы можете искать названия зон на языке клиента игры и на этом втором языке одновременно. Подсказка на названии зоны всегда показывается на втором языке.",
    ["SI_TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE"] = "Оповещение об избранных игроках",
    ["SI_TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP"] = "Выдавать оповещение (в центре экрана) когда избранный игрок появляется онлайн.",
    ["SI_TELE_SETTINGS_HIDE_ON_MAP_CLOSE"] = "Закрывать BeamMeUp при закрытии карты",
    ["SI_TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP"] = "Когда карта закрывается, BeamMeUp тоже закрывается.",
    ["SI_TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL"] = "Смещение крепления к карте - по горизонтали",
    ["SI_TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP"] = "Здесь можно задать горизонтальное смещение прикрепления к карте.",
    ["SI_TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL"] = "Смещение крепления к карте - по вертикали",
    ["SI_TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP"] = "Здесь можно задать вертикальное смещение прикрепления к карте.",
    ["SI_TELE_SETTINGS_RESET_ALL_COUNTERS"] = "Сбросить счетчик зон",
    ["SI_TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP"] = "Будут сброшены все счетчики зон. Так что сортировка по частоте использования тоже будет сброшена.",
    ["SI_TELE_SETTINGS_OFFLINE_NOTE"] = "Автономный режим - напоминание",
    ["SI_TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP"] = "Если вы выбрали свой статус как автономный режим и отправляете личное сообщение кому-либо или пытаетесь телепортироваться к кому-либо, вы получите предупреждение на экране в качестве напоминания. Пока вы находитесь в автономном режиме, вы не можете получать никаких личных сообщений, и никто не может к вам телепортироваться (делиться - значит заботиться).",
    ["SI_TELE_SETTINGS_SCALE"] = "Масштаб UI",
    ["SI_TELE_SETTINGS_SCALE_TOOLTIP"] = "Масштабирование окна и всего интерфейса BeamMeUp. Для применения нужна перезагрузка.",
    ["SI_TELE_SETTINGS_RESET_UI"] = "Сброс UI",
    ["SI_TELE_SETTINGS_RESET_UI_TOOLTIP"] = "Сбросить интерфейс BeamMeUp установкой на значения по умолчанию опций: Масштаб, Смещение кнопки, Смещение привязки к карте и местоположение окна. Весь интерфейс будет перезагружен.",
    ["SI_TELE_SETTINGS_SURVEY_MAP_NOTIFICATION"] = "Оповещение о карте исследований",
    ["SI_TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP"] = "Если вы собираете ресурсы на карте исследований, а в инвентаре есть идентичные карты (на том же месте), в центре экрана будет показано оповещение.",
    ["SI_TELE_SETTINGS_HEADER_PRIO"] = "Приоритеты",
    ["SI_TELE_SETTINGS_HEADER_CHAT_COMMANDS"] = "Команды чата",
    ["SI_TELE_SETTINGS_PRIORITIZATION_DESCRIPTION"] = "Здесь можно выбрать каких игроков предпочтительнее выбирать для быстрого перемещения. После вступления или выхода из гильдии требуется перезагрузка для корректного отображения.",
    ["SI_TELE_SETTINGS_SHOW_BUTTON_ON_MAP"] = "Показывать кнопку на карте",
    ["SI_TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP"] = "Показывать дополнительную текстовую кнопку для вызова BeamMeUp в левом верхнем углу карты мира.",
    ["SI_TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND"] = "Звуковое оповещение",
    ["SI_TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP"] = "Оповещать звуком при показе оповещения",
    ["SI_TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL"] = "Автоматически подтверждать телепорт",
    ["SI_TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP"] = "Отключить диалог подтверждения при быстром перемещении",
    ["SI_TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP"] = "Текущая зона всегда первая",
    ["SI_TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP"] = "Показывать текущую зону всегда в начале списка.",
    ["SI_TELE_SETTINGS_HIDE_OWN_HOUSES"] = "Скрывать свои дома",
    ["SI_TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP"] = "Скрывать сво дома (телепорт ко входу) в общем списке.",
    ["SI_TELE_SETTINGS_HEADER_STATS"] = "Статистика",
    ["SI_TELE_SETTINGS_MOST_PORTED_ZONES"] = "Часто посещаемые зоны:",
    ["SI_TELE_SETTINGS_INSTALLED_SCINCE"] = "Установлен по крайней мере с:",
    ["SI_TELE_SETTINGS_INFO_CHARACTER_DEPENDING"] = "Эта настройка действует только для персонажа (не для всего аккаунта)!",
    ["SI_TELE_SETTINGS_SHOW_TELEPORT_ANIMATION"] = "Анимация телепортации",
    ["SI_TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP"] = "Показать дополнительную анимацию телепортации при запуске быстрого путешествия через BeamMeUp. Коллекционная 'Безделушка Финвира' должна быть разблокирована.",
    ["SI_TELE_SETTINGS_SHOW_CHAT_BUTTON"] = "Кнопка в окне чата",
    ["SI_TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP"] = "Отображать кнопку в заголовке окна чата, для доступа к BeamMeUp.",
    ["SI_TELE_SETTINGS_USE_PAN_AND_ZOOM"] = "Панорама и масштаб",
    ["SI_TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP"] = "Перемещает и приближает место назначения на карте, при нажатии на члена группы или определенной зоны (подземелья, дома и т. д.).",
    ["SI_TELE_SETTINGS_USE_RALLY_POINT"] = "Отметка на карте",
    ["SI_TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP"] = "Отметка на карте (точка сбора), при нажатии на члена группы или определенную зону (подземелья, дома и т. д.). Должна быть установлена библиотека LibMapPing. Также помните: если вы лидер группы, ваши отметки (точки сбора) видны всем участникам группы.",
    ["SI_TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS"] = "Показать регионы без игроков и домов",
    ["SI_TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP"] = "Отображать регионы в основном списке, даже если нет игроков или домов, в которые вы можете отправиться. У вас все еще есть возможность путешествовать за золото, если вы открыли хотя бы одно дорожное святилище в регионе.",
    ["SI_TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP"] = "Всегда наверху списка с текущей зоной и подзонами",
    ["SI_TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP_TOOLTIP"] = "Всегда показывать текущую отображаемую зону и подзоны (открытую на карте мира) вверху списка.",
    ["SI_TELE_SETTINGS_DEFAULT_TAB"] = "Default list",
    ["SI_TELE_SETTINGS_DEFAULT_TAB_TOOLTIP"] = "The list that is displayed by default when opening BeamMeUp.",
    ["SI_TELE_SETTINGS_HEADER_CHAT_OUTPUT"] = "Chat Output",
    ["SI_TELE_SETTINGS_OUTPUT_FAST_TRAVEL"] = "Fast travel executions",
    ["SI_TELE_SETTINGS_OUTPUT_FAST_TRAVEL_TOOLTIP"] = "Informative chat messages about the initiated fast travels. Error messages are still displayed in the chat.",
    ["SI_TELE_SETTINGS_OUTPUT_ADDITIONAL"] = "Supporting messages",
    ["SI_TELE_SETTINGS_OUTPUT_ADDITIONAL_TOOLTIP"] = "Further helpful chat messages on various actions of the addon.",
    ["SI_TELE_SETTINGS_OUTPUT_UNLOCK"] = "Automatic discovery results",
    ["SI_TELE_SETTINGS_OUTPUT_UNLOCK_TOOLTIP"] = "Interim results (discovered wayshrines and XP) and supporting messages of the automatic wayshrine discovery.",
    ["SI_TELE_SETTINGS_OUTPUT_DEBUG"] = "Debug messages",
    ["SI_TELE_SETTINGS_OUTPUT_DEBUG_TOOLTIP"] = "Technical messages for troubleshooting. It will spam your chat. Please use only on request for short time!",
    
    
    -----------------------------------------------------------------------------
    -- KEY BINDING
    -----------------------------------------------------------------------------
    ["SI_TELE_KEYBINDING_TOGGLE_MAIN"] = "Открыть BeamMeUp",
    ["SI_TELE_KEYBINDING_TOGGLE_MAIN_RELATED_ITEMS"] = "Карты и зацепки",
    ["SI_TELE_KEYBINDING_REFRESH"] = "Обновить",
    ["SI_TELE_KEYBINDING_WAYSHRINE_UNLOCK"] = "Разблокировка дорожных святилищ",
    ["SI_TELE_KEYBINDING_PRIMARY_RESIDENCE"] = "Перемещение в основной дом",
    ["SI_TELE_KEYBINDING_GUILD_HOUSE_BMU"] = "Посетить гильдхолл BeamMeUp",
    ["SI_TELE_KEYBINDING_CURRENT_ZONE"] = "Перемещение в текущее локацие",
    ["SI_TELE_KEYBINDING_PRIMARY_RESIDENCE_OUTSIDE"] = "Перемещение ко входу основного дома",
    ["SI_TELE_KEYBINDING_TOGGLE_MAIN_DUNGEON_FINDER"] = "Арены / Испытания / Подземелья",
    ["SI_TELE_KEYBINDING_TRACKED_QUEST"] = "Перeмещение на выбранный квест",
    ["SI_TELE_KEYBINDING_ANY_ZONE"] = "Порт в любую зону",
    ["SI_TELE_KEYBINDING_WAYSHRINE_FAVORITE"] = "Wayshrine Favorite",
    
    
    -----------------------------------------------------------------------------
    -- DIALOGS | NOTIFICATIONS
    -----------------------------------------------------------------------------
    ["SI_TELE_DIALOG_NO_BMU_GUILD_BODY"] = "К сожалению на этом сервере еще нет гильдии BeamMeUp.\n\nМожете связаться с нами через сайт ESOUI и создать гильдию BeamMeUp на этом сервере.",
    ["SI_TELE_DIALOG_INFO_BMU_GUILD_BODY"] = "Привет и спасибо за использование BeamMeUp. В 2019 мы создали несколько гильдий BeamMeUp для доступных быстрых перемещений. Принимаются все, никаких требований или обязательств!\n\nСогласившись с этим диалогом вы увидите список официальных гильдий BeamMeUp и партнёров. Добро пожаловать, вступайте! Также гильдии можно найти, нажав на иконку в левом верхнем углу.\nВаша команда BeamMeUp.",
    ["SI_TELE_DIALOG_INFO_NEW_FEATURE_FAVORITE_PLAYER_NOTIFICATION"] = "Вы получите оповещение (в центре экрана) когда избранный игрок появится онлайн.\n\nВключить эту функцию?",
    ["SI_TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION"] = "Если вы собираете ресурсы на карте исследований, а в инвентаре есть идентичные карты (на том же месте), в центре экрана будет показано оповещение.\n\nВключить эту функцию?",
    ["SI_TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE"] = "Интеграция с \"Port to Friend's House\"",
    ["SI_TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY"] = "Для использования функции интеграции установите аддон \"Port to Friend's House\". Тогда вы увидите ваш список домов и гильдхолов здесь.\n\nОткрыть сайт аддона \"Port to Friend's House\"?",
    -- AUTO UNLOCK: Start Dialog
    ["SI_TELE_DIALOG_AUTO_UNLOCK_TITLE"] = "Начать авторазблокировку дорожных святилищ?",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_BODY"] = "После подтверждения BeamMeUp начнет сканировать всех доступных игроков в локации. Вы будете автоматически перемещаться между дорожными святилищами, чтобы разблокировать как можно больше.",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_LOOP_OPTION"] = "Перемещение по зонам ...",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION1"] = "случайный",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION2"] = "по количеству неоткрытых дорожных святынь",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION3"] = "по кол-ву игроков",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION4"] = "по названию зоны",
    ["SI_TELE_DIALOG_AUTO_UNLOCK_CHAT_LOG_OPTION"] = "Вывод результатов в чат",
    -- AUTO UNLOCK: Refuse Dialogs
    ["SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE"] = "Разблокирование невозможно",
    ["SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY"] = "Все дорожные святилища в этой зоне уже разблокированы.",
    ["SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2"] = "Разблокирование дорожных святилищ невозможно в этой зоне. Эта функция доступна только для основных зон / регионов.",
    ["SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY3"] = "Увы, в локации нет игроков, доступных для телепорта.",
    -- AUTO UNLOCK: Process Dialog
    ["SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART"] = "Автоматическое обнаружение дорожных святилищ запущено...",
    ["SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY"] = "Недавно обнаруженные дорожные святилища:",
    ["SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP"] = "Полученный опыт:",
    ["SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_PROGRESS"] = "Прогресс:",
    ["SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_TIMER"] = "Следующий прыжок:",
    -- AUTO UNLOCK: Finish Dialog
    ["SI_TELE_DIALOG_FINISH_AUTO_UNLOCK_BODY_PART"] = "Автоматическое обнаружение дорожных святилищ завершено.",
    -- AUTO UNLOCK: Timeout Dialog
    ["SI_TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_TITLE"] = "Тайм-аут",
    ["SI_TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_BODY"] = "Что-то пошло не так... Автоматическое обнаружение было отменено.",
    -- AUTO UNLOCK: Loop Finish Dialog
    ["SI_TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE"] = "Автоматическое обнаружение завершено",
    ["SI_TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY"] = "Больше регионов обнаружено не было. Либо регионы без игроков, либо вы уже открыли все святилища.",
    
    
    
    -----------------------------------------------------------------------------
    -- CENTER SCREEN NOTIFICATIONS
    -----------------------------------------------------------------------------
    ["SI_TELE_CENTERSCREEN_OFFLINE_NOTE_HEAD"] = "Важно: Вы в автономном режиме!",
    ["SI_TELE_CENTERSCREEN_OFFLINE_NOTE_BODY"] = "Личные сообщения и телепорт к вам недоступны!\n|c8c8c8c(Уведомление можно отключить в настройках BeamMeUp)",
    ["SI_TELE_CENTERSCREEN_SURVEY_MAPS"] = "У вас есть еще %d подобных карт! Вернись после ресета!",
    ["SI_TELE_CENTERSCREEN_FAVORITE_PLAYER_ONLINE"] = "сейчас онлайн!",
    
    
    
    -----------------------------------------------------------------------------
    -- ITEM NAMES (PART OF IT) - BACKUP
    -----------------------------------------------------------------------------
    ["SI_CONSTANT_TREASURE_MAP"] = "карта сокровищ", -- need a part of the item name that is in every treasure map item the same no matter which zone
    ["SI_CONSTANT_SURVEY_MAP"] = "карта исследований:", -- need a part of the item name that is in every survey map item the same no matter which zone and kind of craft
    
    -----------------------------------------------------------------------------
    -- LibScrollableMenu - Context menu strings --INS260127 Baertram
    -----------------------------------------------------------------------------
    ["SI_CONSTANT_LSM_CLICK_SUBMENU_TOGGLE_ALL"] = "Toggle all submenu entries ON/OFF", --todo 260127
}

local overrideStr = SafeAddString --do not overwrite with ZO_AddString, but just create a new version to override the exiitng ones created with ZO_CreateStringId!
for k, v in pairs(strings) do
    overrideStr(_G[k], v, 2)
end