local BMU = BMU
local SI = BMU.SI

-----------------------------------------------------------------------------
-- INTERFACE
-----------------------------------------------------------------------------
local stringsEN = {
    [SI.TELE_UI_TOTAL] = "Results:",
    [SI.TELE_UI_GOLD] = "Saved Gold:",
    [SI.TELE_UI_GOLD_ABBR] = "k",
    [SI.TELE_UI_GOLD_ABBR2] = "m",
    [SI.TELE_UI_TOTAL_PORTS] = "Total Ports:",
    ---------
    --------- Buttons
    [SI.TELE_UI_BTN_REFRESH_ALL] = "Refresh result list",
    [SI.TELE_UI_BTN_UNLOCK_WS] = "Automatic discovery of current zone wayshrines",
    [SI.TELE_UI_BTN_FIX_WINDOW] = "Fix / Unfix window",
    [SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE] = "Swap to BeamMeUp",
    [SI.TELE_UI_BTN_TOGGLE_BMU] = "Swap to Zone Guide",
    [SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE] = "Own houses",
    [SI.TELE_UI_BTN_ANCHOR_ON_MAP] = "Undock / Dock on map",
    [SI.TELE_UI_BTN_GUILD_BMU] = "BeamMeUp Guilds & Partner Guilds",
    [SI.TELE_UI_BTN_GUILD_HOUSE_BMU] = "Visit BeamMeUp guild house",
    [SI.TELE_UI_BTN_PTF_INTEGRATION] = "\"Port to Friend's House\" Integration",
    [SI.TELE_UI_BTN_DUNGEON_FINDER] = "Arenas / Trials / Dungeons",
    [SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU] = "\n|c777777(right-click for more options)",
    ---------
    --------- List
    [SI.TELE_UI_UNRELATED_ITEMS] = "Maps in other Zones",
    [SI.TELE_UI_UNRELATED_QUESTS] = "Quests in other Zones",
    [SI.TELE_UI_SAME_INSTANCE] = "Same Instance",
    [SI.TELE_UI_DIFFERENT_INSTANCE] = "Different Instance",
    [SI.TELE_UI_GROUP_EVENT] = "Group Event",
    ---------
    --------- Menu
    [SI.TELE_UI_FAVORITE_PLAYER] = "Player Favorite",
    [SI.TELE_UI_FAVORITE_ZONE] = "Zone Favorite",
    [SI.TELE_UI_VOTE_TO_LEADER] = "Vote to Leader",
    [SI.TELE_UI_RESET_COUNTER_ZONE] = "Reset Counter",
    [SI.TELE_UI_INVITE_BMU_GUILD] = "Invite to BeamMeUp guild",
    [SI.TELE_UI_SHOW_QUEST_MARKER_ON_MAP] = "Show Quest Marker",
    [SI.TELE_UI_RENAME_HOUSE_NICKNAME] = "Rename House nickname",
    [SI.TELE_UI_TOGGLE_HOUSE_NICKNAME] = "Show nicknames",
    [SI.TELE_UI_VIEW_MAP_ITEM] = "View Map Item",
    [SI.TELE_UI_TOGGLE_ARENAS] = "Solo Arenas",
    [SI.TELE_UI_TOGGLE_GROUP_ARENAS] = "Group Arenas",
    [SI.TELE_UI_TOGGLE_TRIALS] = "Trials",
    [SI.TELE_UI_TOGGLE_ENDLESS_DUNGEONS] = "Endless Dungeons",
    [SI.TELE_UI_TOGGLE_GROUP_DUNGEONS] = "Group Dungeons",
    [SI.TELE_UI_TOGGLE_SORT_ACRONYM] = "Sort by Acronym",
    [SI.TELE_UI_DAYS_LEFT] = "%d days left",
    [SI.TELE_UI_TOGGLE_UPDATE_NAME] = "Show update name",
    [SI.TELE_UI_UNLOCK_WAYSHRINES] = "Automatic discovery of wayshrines",
    [SI.TELE_UI_TOOGLE_ZONE_NAME] = "Show zone name",
    [SI.TELE_UI_TOGGLE_SORT_RELEASE] = "Sort by release",
    [SI.TELE_UI_TOGGLE_ACRONYM] = "Show acronym",
    [SI.TELE_UI_TOOGLE_DUNGEON_NAME] = "Show instance name",
    [SI.TELE_UI_TRAVEL_PARENT_ZONE] = "Port to parent zone",
    [SI.TELE_UI_SET_PREFERRED_HOUSE] = "Set as preferred house",
    [SI.TELE_UI_UNSET_PREFERRED_HOUSE] = "Unset preferred house",



    -----------------------------------------------------------------------------
    -- CHAT OUTPUTS
    -----------------------------------------------------------------------------
    [SI.TELE_CHAT_FAVORITE_UNSET] = "Favorite slot is unset",
    [SI.TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL] = "The player is offline or hidden by set filters",
    [SI.TELE_CHAT_NO_FAST_TRAVEL] = "No fast travel option found",
    [SI.TELE_CHAT_NOT_IN_GROUP] = "You are not in a group",
    [SI.TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED] = "No Primary Residence set!",
    [SI.TELE_CHAT_GROUP_LEADER_YOURSELF] = "You are the group leader",
    [SI.TELE_CHAT_UNLOCK_WS_DISCOVERED_TOTAL] = "Total wayshrines discovered in the zone:",
    [SI.TELE_CHAT_UNLOCK_WS_NEED_DISCOVERED] = "The following wayshrines still need to be physically visited:",
    [SI.TELE_CHAT_SHARING_FOLLOW_LINK] = "Following the link ...",
    [SI.TELE_CHAT_AUTO_UNLOCK_CANCELED] = "Automatic discovery canceled by user.",
    [SI.TELE_CHAT_AUTO_UNLOCK_SKIP] = "Fast Travel error: Skip current player.",



    -----------------------------------------------------------------------------
    -- SETTINGS
    -----------------------------------------------------------------------------
    [SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN] = "Open BeamMeUp when the map is opened",
    [SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP] = "When you open the map, BeamMeUp will automatically open as well, otherwise you'll see a button on the map top left and also a swap button in the map completion window.",
    [SI.TELE_SETTINGS_ZONE_ONCE_ONLY] = "Show every Zone once only",
    [SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP] = "Show only one listing for each zone.",
    [SI.TELE_SETTINGS_AUTO_PORT_FREQ] = "Frequency of unlocking wayshrines (ms)",
    [SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP] = "Adjust the frequency of the automatic wayshrine unlocking. For slow computers or to prevent possible kicks from the game, a higher value can help.",
    [SI.TELE_SETTINGS_AUTO_REFRESH] = "Refresh & Reset on opening",
    [SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP] = "Refresh result list each time you open BeamMeUp. Input fields are cleared.",
    [SI.TELE_SETTINGS_HEADER_BLACKLISTING] = "Blacklisting",
    [SI.TELE_SETTINGS_HIDE_OTHERS] = "Hide various inaccessible Zones",
    [SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP] = "Hide zones like Maelstrom Arena, Outlaw Refuges and solo zones.",
    [SI.TELE_SETTINGS_HIDE_PVP] = "Hide PVP Zones",
    [SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP] = "Hide zones like Cyrodiil, Imperial City and Battlegrounds.",
    [SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS] = "Hide Group Dungeons and Trials",
    [SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP] = "Hide all 4 men Group Dungeons, 12 men Trials and Group Dungeons in Craglorn. Group members in these zones will still be displayed!",
    [SI.TELE_SETTINGS_HIDE_HOUSES] = "Hide Houses",
    [SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP] = "Hide all Houses.",
    [SI.TELE_SETTINGS_WINDOW_STAY] = "Keep BeamMeUp open",
    [SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP] = "When you open BeamMeUp without the map, it will stay even if you move or open other windows. If you use this option, it is recommended to disable the option 'Close BeamMeUp with map'.",
    [SI.TELE_SETTINGS_ONLY_MAPS] = "Show only Regions / Overland zones",
    [SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP] = "Show only the main regions like Deshaan or Summerset.",
    [SI.TELE_SETTINGS_AUTO_REFRESH_FREQ] = "Refresh interval (s)",
    [SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP] = "When BeamMeUp is open, an automatic refresh of the result list is performed every x seconds. Set the value to 0 to disable the automatic refresh.",
    [SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN] = "Focus the zone search box",
    [SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP] = "Focus the zone search box when BeamMeUp is opened together with the map.",
    [SI.TELE_SETTINGS_HIDE_DELVES] = "Hide Delves",
    [SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP] = "Hide all Delves.",
    [SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS] = "Hide Public Dungeons",
    [SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP] = "Hide all Public Dungeons.",
    [SI.TELE_SETTINGS_FORMAT_ZONE_NAME] = "Hide articles of zone names",
    [SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP] = "Hide the articles of zone names to ensure a better sorting to find zones faster.",
    [SI.TELE_SETTINGS_NUMBER_LINES] = "Number of lines / listings",
    [SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP] = "By setting the number of visible lines / listings you can control the total height of the Addon.",
    [SI.TELE_SETTINGS_HEADER_ADVANCED] = "Extra Features",
    [SI.TELE_SETTINGS_HEADER_UI] = "General",
    [SI.TELE_SETTINGS_HEADER_RECORDS] = "Listings",
    [SI.TELE_SETTINGS_CLOSE_ON_PORTING] = "Auto close map and BeamMeUp",
    [SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP] = "Close map and BeamMeUp after the port process is started.",
    [SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS] = "Show number of players per map",
    [SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP] = "Display the number of players per map, you can port to. You can click on the number to see all these players.",
    [SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET] = "Offset of the button in the chatbox",
    [SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP] = "Increase the horizontal offset of the button in the header of the chatbox to avoid visual conflicts with other Addon icons.",
    [SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES] = "Also search for character names",
    [SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP] = "Also search for character names when searching for players.",
    [SI.TELE_SETTINGS_SORTING] = "Sorting",
    [SI.TELE_SETTINGS_SORTING_TOOLTIP] = "Choose one of the possible sorts of the list.",
    [SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE] = "Second Search Language",
    [SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP] = "You can search by zone names in your client language and this second language at the same time. The tooltip of the zone name displays also the name in the second language.",
    [SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE] = "Notification Player Favorite Online",
    [SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP] = "You receive a notification (center screen message) when a player favorite comes online.",
    [SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE] = "Close BeamMeUp when the map is closed",
    [SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP] = "When you close the map, BeamMeUp also closes.",
    [SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL] = "Offset of the Map Dock Position - Horizontal",
    [SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP] = "Here you can customize the horizontal offset of the docking on the map.",
    [SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL] = "Offset of the Map Dock Position - Vertical",
    [SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP] = "Here you can customize the vertical offset of the docking on the map.",
    [SI.TELE_SETTINGS_RESET_ALL_COUNTERS] = "Reset all Zone Counters",
    [SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP] = "All zone counters are reset. Therefore, the sorting by most used is reset.",
    [SI.TELE_SETTINGS_OFFLINE_NOTE] = "Offline Reminder",
    [SI.TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP] = "If you are set to offline for a while and you whisper or travel to someone, you will get a short screen message as reminder. As long as you are set to offline you cannot receive any whisper messages and no one can travel to you (but sharing is caring).",
    [SI.TELE_SETTINGS_SCALE] = "UI Scaling",
    [SI.TELE_SETTINGS_SCALE_TOOLTIP] = "Scale factor for the complete UI/window of BeamMeUp. A reload is necessary to apply changes.",
    [SI.TELE_SETTINGS_RESET_UI] = "Reset UI",
    [SI.TELE_SETTINGS_RESET_UI_TOOLTIP] = "Reset BeamMeUp UI by setting the following options back to default: Scaling, Button Offset, Map Dock Offsets and window positions. The complete UI will be reloaded.",
    [SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION] = "Survey Map Notification",
    [SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP] = "If you mine a survey map and there are still some identical maps (same location) in your inventory, a notification (center screen message) will inform you.",
    [SI.TELE_SETTINGS_HEADER_PRIO] = "Prioritization",
    [SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS] = "Chat Commands",
    [SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION] = "Here you can define which players should preferably be used for fast travel. After leaving or joining a guild, a reload is necessary to be displayed correctly here.",
    [SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP] = "Show additional button on the map",
    [SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP] = "Display a text button in the upper left corner of the world map to open BeamMeUp.",
    [SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND] = "Play sound",
    [SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP] = "Play a sound when showing the notification.",
    [SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL] = "Auto confirm wayshrine traveling",
    [SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP] = "Disable the confirmation dialog when you teleport to other wayshrines.",
    [SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP] = "Show current zone always on top",
    [SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP] = "Show current zone always on top of the list.",
    [SI.TELE_SETTINGS_HIDE_OWN_HOUSES] = "Hide OWN Houses",
    [SI.TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP] = "Hide your own houses (teleport outside) in the main list.",
    [SI.TELE_SETTINGS_HEADER_STATS] = "Statistics",
    [SI.TELE_SETTINGS_MOST_PORTED_ZONES] = "Most traveled zones:",
    [SI.TELE_SETTINGS_INSTALLED_SCINCE] = "Installed at least since:",
    [SI.TELE_SETTINGS_INFO_CHARACTER_DEPENDING] = "This option is linked to your character (not account wide)!",
    [SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION] = "Teleport animation",
    [SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP] = "Show an additional teleportation animation when starting a fast travel via BeamMeUp. The collectible 'Finvir's Trinket' must be unlocked.",
    [SI.TELE_SETTINGS_SHOW_CHAT_BUTTON] = "Button in the chat window",
    [SI.TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP] = "Display a button in the header of the chat window to open BeamMeUp.",
    [SI.TELE_SETTINGS_USE_PAN_AND_ZOOM] = "Pan and zoom",
    [SI.TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP] = "Pan and zoom to the destination on the map when you click on group members or specific zones (dungeons, houses etc.).",
    [SI.TELE_SETTINGS_USE_RALLY_POINT] = "Map ping",
    [SI.TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP] = "Display a map ping (rally point) on the destination on the map when you click on group members or specific zones (dungeons, houses etc.). The library LibMapPing must be installed. Also remember: If you are the group leader, your pings (rally points) are visible for all group members.",
    [SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS] = "Show zones without players or houses",
    [SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP] = "Display zones in the main list even if there are no players or houses you can travel to. You still have the option to travel for gold if you have discovered at least one wayshrine in the zone.",
    [SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP] = "Show displayed zone & subzones always on top",
    [SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP_TOOLTIP] = "Show currently displayed zone and subzones (opened world map) always on top of the list.",
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
    [SI.TELE_KEYBINDING_TOGGLE_MAIN] = "Open BeamMeUp",
    [SI.TELE_KEYBINDING_TOGGLE_MAIN_RELATED_ITEMS] = "Treasure & survey maps & leads",
    [SI.TELE_KEYBINDING_REFRESH] = "Refresh result list",
    [SI.TELE_KEYBINDING_WAYSHRINE_UNLOCK] = "Unlock current zone wayshrines",
    [SI.TELE_KEYBINDING_PRIMARY_RESIDENCE] = "Port into Primary Residence",
    [SI.TELE_KEYBINDING_GUILD_HOUSE_BMU] = "Visit BeamMeUp Guild House",
    [SI.TELE_KEYBINDING_CURRENT_ZONE] = "Port to current zone",
    [SI.TELE_KEYBINDING_PRIMARY_RESIDENCE_OUTSIDE] = "Port outside Primary Residence",
    [SI.TELE_KEYBINDING_TOGGLE_MAIN_DUNGEON_FINDER] = "Arenas / Trials / Dungeons",
    [SI.TELE_KEYBINDING_TRACKED_QUEST] = "Port to focused quest",
    [SI.TELE_KEYBINDING_ANY_ZONE] = "Port to any zone",
    [SI.TELE_KEYBINDING_WAYSHRINE_FAVORITE] = "Wayshrine Favorite",


    -----------------------------------------------------------------------------
    -- DIALOGS | NOTIFICATIONS
    -----------------------------------------------------------------------------
    [SI.TELE_DIALOG_NO_BMU_GUILD_BODY] = "We are so sorry, but it seems that there is no BeamMeUp guild on this server yet.\n\nFeel free to contact us via the ESOUI website and start an official BeamMeUp guild on this server.",
    [SI.TELE_DIALOG_INFO_BMU_GUILD_BODY] = "Hello and thank you for using BeamMeUp. In 2019, we started several BeamMeUp guilds for the purpose of sharing free fast travel options. Everyone is welcome, no requirements or obligations!\n\nBy confirming this dialog, you will see the official and partner guilds of BeamMeUp in the list. You are welcome to join! You can also display the guilds by clicking on the guild button in the upper left corner.\nYour BeamMeUp Team",
    [SI.TELE_DIALOG_INFO_NEW_FEATURE_FAVORITE_PLAYER_NOTIFICATION] = "You receive a notification (center screen message) when a player favorite comes online.\n\nEnable this feature?",
    [SI.TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION] = "If you mine a survey map and there are still some identical maps (same location) in your inventory, a notification (center screen message) will inform you.\n\nEnable this feature?",
    [SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE] = "Integration of \"Port to Friend's House\"",
    [SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY] = "To use the integration feature, please install the addon \"Port to Friend's House\". You will then see your configured houses and guild halls here in the list.\n\nDo you want to open \"Port to Friend's House\" addon website now?",
    -- AUTO UNLOCK: Start Dialog
    [SI.TELE_DIALOG_AUTO_UNLOCK_TITLE] = "Start automatic wayshrine discovery?",
    [SI.TELE_DIALOG_AUTO_UNLOCK_BODY] = "By confirming, BeamMeUp will start traveling to all available players in the current zone. This way you will automatically jump from wayshrine to wayshrine to discover as much as possible.",
    [SI.TELE_DIALOG_AUTO_UNLOCK_LOOP_OPTION] = "Looping over zones ...",
    [SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION1] = "shuffle randomly",
    [SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION2] = "by ratio of undiscovered wayshrines",
    [SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION3] = "by number of players",
    [SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION4] = "by zone name",
    [SI.TELE_DIALOG_AUTO_UNLOCK_CHAT_LOG_OPTION] = "Output results in chat",
    -- AUTO UNLOCK: Refuse Dialogs
    [SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE] = "Discovery is not possible",
    [SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY] = "All wayshrines in the zone have already been discovered.",
    [SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2] = "Wayshrine discovery is not possible in this zone. The feature is only available in overland zones/regions.",
    [SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY3] = "Unfortunately, there are no players in the zone to travel to.",
    -- AUTO UNLOCK: Process Dialog
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART] = "Automatic wayshrine discovery is running...",
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY] = "Newly discovered wayshrines:",
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP] = "Gained XP:",
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_PROGRESS] = "Progress:",
    [SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_TIMER] = "Next jump in:",
    -- AUTO UNLOCK: Finish Dialog
    [SI.TELE_DIALOG_FINISH_AUTO_UNLOCK_BODY_PART] = "Automatic discovery of wayshrines completed.",
    -- AUTO UNLOCK: Timeout Dialog
    [SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_TITLE] = "Timeout",
    [SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_BODY] = "Sorry, an unknown error has occurred. The automatic discovery was canceled.",
    -- AUTO UNLOCK: Loop Finish Dialog
    [SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE] = "Automatic discovery finished",
    [SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY] = "No more zones found to be discovered. Either there are no players in the zones or you have already discovered all wayshrines.",



    -----------------------------------------------------------------------------
    -- CENTER SCREEN NOTIFICATIONS
    -----------------------------------------------------------------------------
    [SI.TELE_CENTERSCREEN_OFFLINE_NOTE_HEAD] = "Note: You are still set to offline!",
    [SI.TELE_CENTERSCREEN_OFFLINE_NOTE_BODY] = "No one can whisper or travel to you!\n|c8c8c8c(Notification can be disabled in BeamMeUp settings)",
    [SI.TELE_CENTERSCREEN_SURVEY_MAPS] = "You have %d of this survey maps left! Come back after respawn!",
    [SI.TELE_CENTERSCREEN_FAVORITE_PLAYER_ONLINE] = "is now online!",



    -----------------------------------------------------------------------------
    -- ITEM NAMES (PART OF IT) - BACKUP
    -----------------------------------------------------------------------------
    [SI.CONSTANT_TREASURE_MAP] = "treasure map", -- need a part of the item name that is in every treasure map item the same no matter which zone
    [SI.CONSTANT_SURVEY_MAP] = "survey:", -- need a part of the item name that is in every survey map item the same no matter which zone and kind of craft



    -----------------------------------------------------------------------------
    -- LibScrollableMenu - Context menu strings --INS260127 Baertram
    -----------------------------------------------------------------------------
    [SI.CONSTANT_LSM_CLICK_SUBMENU_TOGGLE_ALL] = "Toggle all submenu entries ON/OFF",


} --stringsEN

--Create StringIds in global table ESO_Strings now
local mkstr = ZO_CreateStringId
for k, v in pairs(stringsEN) do
    mkstr(k, v)
end