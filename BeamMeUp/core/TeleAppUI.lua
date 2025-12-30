local BMU = BMU --INS251229 Baertram Performancee gain, not searching _G for BMU each time again!

local LAM2 = BMU.LAM
local SI = BMU.SI ---- used for localization

local teleporterVars    = BMU.var
local appName           = teleporterVars.appName
local wm                = WINDOW_MANAGER

-- -v- INS251229 Baertram BEGIN 0
--Performance reference
----variables (defined now, as they were loaded before this file -> see manifest .txt)
--ZOs variables
local worldName = GetWorldName()
local zo_Menu                               = ZO_Menu     --ZO_Menu speed-up variable (so _G is not searched each time context menus are used)
local zo_WorldMapZoneStoryTopLevel_Keyboard = ZO_WorldMapZoneStoryTopLevel_Keyboard
local zo_ChatWindow                         = ZO_ChatWindow
--Other addon variables
---LibCustomMenu
local libCustomMenuSubmenu = LibCustomMenuSubmenu --The control holding the currently shown submenu control entries (as a submenu is opened)
local LCM_SubmenuEntryNamePrefix = "ZO_SubMenuItem" --row name of a ZO_Menu's submenu entrxy added by LibCustomMenu to the parent control LibCustomMenuSubmenu
local zo_MenuSubmenuItemsHooked = {} --Items hooked by this code, to add a special OnMouseUp handler.
local checkboxesAtSubmenuCurrentState = {} --Save the current checkboxes state (on/off) for a submenu opening control, so we can toggle all checkboxes in the submenu properly
--BMU variables
local BMU_textures                          = BMU.textures
----functions
--ZOs functions
local zoPlainStrFind = zo_plainstrfind
local zo_IsTableEmpty = ZO_IsTableEmpty
local zo_CheckButton_IsChecked = ZO_CheckButton_IsChecked
local zo_CheckButton_SetCheckState = ZO_CheckButton_SetCheckState
local zo_CheckButton_IsEnabled = ZO_CheckButton_IsEnabled
local zo_CheckButton_SetChecked = ZO_CheckButton_SetChecked
--BMU functions
local BMU_SI_get                            = SI.get
local BMU_colorizeText                      = BMU.colorizeText
local BMU_round                             = BMU.round
local BMU_tooltipTextEnter                  = BMU.tooltipTextEnter

----variables (defined inline in code below, upon first usage, as they are still nil at this line)
----functions (defined inline in code below, upon first usage, as they are still nil at this line)
local BMU_getItemTypeIcon, BMU_getDataMapInfo, BMU_OpenTeleporter, BMU_updateContextMenuEntrySurveyAll,
      BMU_getContextMenuEntrySurveyAllAppendix, BMU_clearInputFields, BMU_getIndexFromValue
-- -^- INS251229 Baertram END 0

-- list of tuples (guildId & displayname) for invite queue (only for admin)
local inviteQueue = {}

local function SetupOptionsMenu(addonName) --index == Addon name                        --CHG251229 Baertram renamed because index is also used in the loop at line 78 and within several setFunc/getFunc of some entries below and the variable is shadowed then
    -- -v- INS251229 Baertram performance improvement for multiple used variable reference
    local BMU_DefaultsPerCharacter = BMU.DefaultsCharacter
    local BMU_DefaultsPerAccount   = BMU.DefaultsAccount
    BMU_getIndexFromValue = BMU_getIndexFromValue or BMU.getIndexFromValue
    local BMU_SVAcc = BMU.savedVarsAcc
    -- -^- INS251229 Baertram

    local teleporterWin     = BMU.win


    local panelData = {
            type 				= 'panel',
            name 				= addonName,
            displayName 		= BMU_colorizeText(addonName, "gold"),                  --CHG251229 Baertram
            author 				= BMU_colorizeText(teleporterVars.author, "teal"),      --CHG251229 Baertram
            version 			= BMU_colorizeText(teleporterVars.version, "teal"),     --CHG251229 Baertram -> Also changed in this function at another 48 places! No comments were added there, onlya t the first of the 48 ;-)
            website             = teleporterVars.website,
            feedback            = teleporterVars.feedback,
            registerForRefresh  = true,
            registerForDefaults = true,
        }


    BMU.SettingsPanel = LAM2:RegisterAddonPanel(appName .. "Options", panelData) -- for quick access


	-- retreive most ported zones for statistic
	local portCounterPerZoneSorted = {}
	for index, value in pairs(BMU_SVAcc.portCounterPerZone) do
		table.insert(portCounterPerZoneSorted, {["zoneId"]=index, ["count"]=value})
	end
	-- sort by counts
	table.sort(portCounterPerZoneSorted, function(a, b) return a["count"] > b["count"] end)
	-- build text block
	local mostPortedZonesText = ""
	for i=1, 10 do
		if portCounterPerZoneSorted[i] == nil then
			mostPortedZonesText = mostPortedZonesText .. "\n"
		else
			mostPortedZonesText = mostPortedZonesText .. BMU.formatName(GetZoneNameById(portCounterPerZoneSorted[i]["zoneId"])) .. " (" .. portCounterPerZoneSorted[i]["count"] .. ")\n"
		end
	end

    local optionsData = {
	     {
              type = "description",
              text = "Get the most out of BeamMeUp by using it together with the following addons.",
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
              title = "Port to Friend's House",
			  text = BMU.getStringIsInstalledLibrary("ptf"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = "Open addon website",
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info1758-PorttoFriendsHouse.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = "Access your houses and guild halls directly through BeamMeUp. Your houses that are set in PTF will be displayed in a separate list.",
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
			  title = "LibSets",
              text = BMU.getStringIsInstalledLibrary("libsets"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = "Open addon website",
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info2241-LibSetsAllsetitemsingameexcellua.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = "Check your collection progress of set items in BeamMeUp and sort your fast travel options. The number of the collected set items is displayed in the tooltip of the zone names. Furthermore, you can sort your results according to the number of missing set items.",
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
			  title = "LibMapPing",
              text = BMU.getStringIsInstalledLibrary("libmapping"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = "Open addon website",
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info1302-LibMapPing.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = "Use pings on the map (rally points) instead of zooming when you click on specific zone names or group members. An option in the 'Extra Features' allows you to toggle between the map ping and the zoom & pan feature.",
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
			  title = "LibSlashCommander",
              text = BMU.getStringIsInstalledLibrary("lsc"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = "Open addon website",
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info1508-LibSlashCommander.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = "Get comprehensive auto-completion, color coding and short description for chat commands.",
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
			  title = "LibChatMenuButton",
              text = BMU.getStringIsInstalledLibrary("lcmb"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = "Open addon website",
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info3805-LibChatMenuButton.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = "Leave the positioning of the BMU chat button to an external library. Support the concept of libraries. But you will lose the option to set an individual offset.",
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
              title = "|cFF00FFIsJusta|r Beam Me Up Gamepad Plugin",
			  text = BMU.getStringIsInstalledLibrary("gamepad"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = "Open addon website",
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info3624-IsJustaBeamMeUpGamepadPlugin.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = "Use BeamMeUp in the gamepad mode. Finally, BeamMeUp gets a dedicated gamepad support. |cFF00FFIsJusta|r Beam Me Up Gamepad Plugin integrates the features of BeamMeUp in the gamepad interface and allows you to travel more comfortable than ever before.",
			  submenu = "deps",
         },
		 {
              type = "slider",
              name = BMU_SI_get(SI.TELE_SETTINGS_NUMBER_LINES),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["numberLines"] .. "]",
              min = 6,
              max = 16,
              getFunc = function() return BMU_SVAcc.numberLines end,
              setFunc = function(value) BMU_SVAcc.numberLines = value
							teleporterWin.Main_Control:SetHeight(BMU.calculateListHeight())
							-- add also current height of the counter panel
							teleporterWin.Main_Control.bd:SetHeight(BMU.calculateListHeight() + 280*BMU_SVAcc.Scale + select(2, BMU.counterPanel:GetTextDimensions()))
				end,
			  default = BMU_DefaultsPerAccount["numberLines"],
			  submenu = "ui",
         },
         {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["ShowOnMapOpen"]) .. "]",
              getFunc = function() return BMU_SVAcc.ShowOnMapOpen end,
              setFunc = function(value) BMU_SVAcc.ShowOnMapOpen = value end,
			  default = BMU_DefaultsPerAccount["ShowOnMapOpen"],
			  submenu = "ui",
         },
         {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["HideOnMapClose"]) .. "]",
              getFunc = function() return BMU_SVAcc.HideOnMapClose end,
              setFunc = function(value) BMU_SVAcc.HideOnMapClose = value end,
			  default = BMU_DefaultsPerAccount["HideOnMapClose"],
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_CLOSE_ON_PORTING),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["closeOnPorting"]) .. "]",
              getFunc = function() return BMU_SVAcc.closeOnPorting end,
              setFunc = function(value) BMU_SVAcc.closeOnPorting = value end,
			  default = BMU_DefaultsPerAccount["closeOnPorting"],
			  submenu = "ui",
		 },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_WINDOW_STAY),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["windowStay"]) .. "]",
              getFunc = function() return BMU_SVAcc.windowStay end,
              setFunc = function(value) BMU_SVAcc.windowStay = value end,
			  default = BMU_DefaultsPerAccount["windowStay"],
			  submenu = "ui",
		 },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["focusZoneSearchOnOpening"]) .. "]",
              getFunc = function() return BMU_SVAcc.focusZoneSearchOnOpening end,
              setFunc = function(value) BMU_SVAcc.focusZoneSearchOnOpening = value end,
			  default = BMU_DefaultsPerAccount["focusZoneSearchOnOpening"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = BMU_SI_get(SI.TELE_SETTINGS_AUTO_PORT_FREQ),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["AutoPortFreq"] .. "]",
              min = 50,
              max = 500,
              getFunc = function() return BMU_SVAcc.AutoPortFreq end,
              setFunc = function(value) BMU_SVAcc.AutoPortFreq = value end,
			  default = BMU_DefaultsPerAccount["AutoPortFreq"],
			  submenu = "ui",
         },
		 {
              type = "divider",
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["showOpenButtonOnMap"]) .. "]",
              requiresReload = true,
			  getFunc = function() return BMU_SVAcc.showOpenButtonOnMap end,
              setFunc = function(value) BMU_SVAcc.showOpenButtonOnMap = value end,
			  default = BMU_DefaultsPerAccount["showOpenButtonOnMap"],
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["chatButton"]) .. "]",
              requiresReload = true,
			  getFunc = function() return BMU_SVAcc.chatButton end,
              setFunc = function(value) BMU_SVAcc.chatButton = value end,
			  default = BMU_DefaultsPerAccount["chatButton"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = BMU_SI_get(SI.TELE_SETTINGS_SCALE),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_SCALE_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["Scale"] .. "]",
			  min = 0.7,
			  max = 1.4,
			  step = 0.05,
			  decimals = 2,
			  requiresReload = true,
              getFunc = function() return BMU_SVAcc.Scale end,
              setFunc = function(value) BMU_SVAcc.Scale = value end,
			  default = BMU_DefaultsPerAccount["Scale"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = BMU_SI_get(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["chatButtonHorizontalOffset"] .. "]",
              min = 0,
              max = 200,
              getFunc = function() return BMU_SVAcc.chatButtonHorizontalOffset end,
              setFunc = function(value) BMU_SVAcc.chatButtonHorizontalOffset = value
							BMU.chatButtonTex:SetAnchor(TOPRIGHT, ZO_ChatWindow, TOPRIGHT, -40 - BMU_SVAcc.chatButtonHorizontalOffset, 6)
						end,
			  default = BMU_DefaultsPerAccount["chatButtonHorizontalOffset"],
			  submenu = "ui",
			  disabled = function() return not BMU_SVAcc.chatButton or not BMU.chatButtonTex end,
         },
		 {
              type = "slider",
              name = BMU_SI_get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["anchorMapOffset_x"] .. "]",
			  min = -100,
              max = 100,
              getFunc = function() return BMU_SVAcc.anchorMapOffset_x end,
              setFunc = function(value) BMU_SVAcc.anchorMapOffset_x = value end,
			  default = BMU_DefaultsPerAccount["anchorMapOffset_x"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = BMU_SI_get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["anchorMapOffset_y"] .. "]",
			  min = -150,
			  max = 150,
              getFunc = function() return BMU_SVAcc.anchorMapOffset_y end,
              setFunc = function(value) BMU_SVAcc.anchorMapOffset_y = value end,
			  default = BMU_DefaultsPerAccount["anchorMapOffset_y"],
			  submenu = "ui",
         },
		 {
              type = "button",
              name = BMU_SI_get(SI.TELE_SETTINGS_RESET_UI),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_RESET_UI_TOOLTIP),
			  func = function() 
                                BMU_SVAcc.Scale = BMU_DefaultsPerAccount["Scale"]
								BMU_SVAcc.chatButtonHorizontalOffset = BMU_DefaultsPerAccount["chatButtonHorizontalOffset"]
								BMU_SVAcc.anchorMapOffset_x = BMU_DefaultsPerAccount["anchorMapOffset_x"]
								BMU_SVAcc.anchorMapOffset_y = BMU_DefaultsPerAccount["anchorMapOffset_y"]
								BMU_SVAcc.pos_MapScene_x = BMU_DefaultsPerAccount["pos_MapScene_x"]
								BMU_SVAcc.pos_MapScene_y = BMU_DefaultsPerAccount["pos_MapScene_y"]
								BMU_SVAcc.pos_x = BMU_DefaultsPerAccount["pos_x"]
								BMU_SVAcc.pos_y = BMU_DefaultsPerAccount["pos_y"]
								BMU_SVAcc.anchorOnMap = BMU_DefaultsPerAccount["anchorOnMap"]
								ReloadUI()
						end,
			  width = "half",
			  warning = "This will automatically reload your UI!",
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_AUTO_REFRESH),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["autoRefresh"]) .. "]",
              getFunc = function() return BMU_SVAcc.autoRefresh end,
              setFunc = function(value) BMU_SVAcc.autoRefresh = value end,
			  default = BMU_DefaultsPerAccount["autoRefresh"],
			  submenu = "rec",
         },
		 {
              type = "dropdown",
              name = BMU_SI_get(SI.TELE_SETTINGS_SORTING),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SORTING_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownSortChoices[BMU_DefaultsPerCharacter["sorting"]] .. "]",
			  choices = BMU.dropdownSortChoices,
			  choicesValues = BMU.dropdownSortValues,
              getFunc = function() return BMU.savedVarsChar.sorting end,
			  setFunc = function(value) BMU.savedVarsChar.sorting = value end,
			  default = BMU_DefaultsPerCharacter["sorting"],
			  warning = BMU_colorizeText(BMU_SI_get(SI.TELE_SETTINGS_INFO_CHARACTER_DEPENDING), "red"), --CHG251229 Baertram All following changed enties below are not commented anymore now!
			  submenu = "rec",
        },
		{
			type = "dropdown",
			name = BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB),
			tooltip = BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownDefaultTabChoices[BMU_getIndexFromValue(BMU.dropdownDefaultTabValues, BMU_DefaultsPerCharacter["defaultTab"])] .. "]",
			choices = BMU.dropdownDefaultTabChoices,
			choicesValues = BMU.dropdownDefaultTabValues,
			getFunc = function() return BMU.savedVarsChar.defaultTab end,
			setFunc = function(value) BMU.savedVarsChar.defaultTab = value end,
			default = BMU_DefaultsPerCharacter["defaultTab"],
			warning = BMU_colorizeText(BMU_SI_get(SI.TELE_SETTINGS_INFO_CHARACTER_DEPENDING), "red"),
			disabled = function() return not BMU_SVAcc.autoRefresh end,
			submenu = "rec",
		 },
         {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["showNumberPlayers"]) .. "]",
              getFunc = function() return BMU_SVAcc.showNumberPlayers end,
              setFunc = function(value) BMU_SVAcc.showNumberPlayers = value end,
			  default = BMU_DefaultsPerAccount["showNumberPlayers"],
			  submenu = "rec",
		 },
         {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["searchCharacterNames"]) .. "]",
              getFunc = function() return BMU_SVAcc.searchCharacterNames end,
              setFunc = function(value) BMU_SVAcc.searchCharacterNames = value end,
			  default = BMU_DefaultsPerAccount["searchCharacterNames"],
			  submenu = "rec",
		 },		 
         {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_ZONE_ONCE_ONLY),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["zoneOnceOnly"]) .. "]",
              getFunc = function() return BMU_SVAcc.zoneOnceOnly end,
              setFunc = function(value) BMU_SVAcc.zoneOnceOnly = value end,
			  default = BMU_DefaultsPerAccount["zoneOnceOnly"],
			  submenu = "rec",
		 },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["currentZoneAlwaysTop"]) .. "]",
              getFunc = function() return BMU_SVAcc.currentZoneAlwaysTop end,
              setFunc = function(value) BMU_SVAcc.currentZoneAlwaysTop = value end,
			  default = BMU_DefaultsPerAccount["currentZoneAlwaysTop"],
			  submenu = "rec",
		 },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["currentViewedZoneAlwaysTop"]) .. "]",
              getFunc = function() return BMU_SVAcc.currentViewedZoneAlwaysTop end,
              setFunc = function(value) BMU_SVAcc.currentViewedZoneAlwaysTop = value end,
			  default = BMU_DefaultsPerAccount["currentViewedZoneAlwaysTop"],
			  submenu = "rec",
		 },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_FORMAT_ZONE_NAME),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["formatZoneName"]) .. "]",
              getFunc = function() return BMU_SVAcc.formatZoneName end,
              setFunc = function(value) BMU_SVAcc.formatZoneName = value end,
			  default = BMU_DefaultsPerAccount["formatZoneName"],
			  submenu = "rec",
         },
		 {
              type = "slider",
              name = BMU_SI_get(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["autoRefreshFreq"] .. "]",
              min = 0,
              max = 15,
              getFunc = function() return BMU_SVAcc.autoRefreshFreq end,
              setFunc = function(value) BMU_SVAcc.autoRefreshFreq = value end,
			  default = BMU_DefaultsPerAccount["autoRefreshFreq"],
			  submenu = "rec",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["showZonesWithoutPlayers2"]) .. "]",
              getFunc = function() return BMU_SVAcc.showZonesWithoutPlayers2 end,
              setFunc = function(value) BMU_SVAcc.showZonesWithoutPlayers2 = value end,
			  default = BMU_DefaultsPerAccount["showZonesWithoutPlayers2"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_ONLY_MAPS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["onlyMaps"]) .. "]",
              getFunc = function() return BMU_SVAcc.onlyMaps end,
              setFunc = function(value) BMU_SVAcc.onlyMaps = value end,
			  default = BMU_DefaultsPerAccount["onlyMaps"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_HIDE_OTHERS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["hideOthers"]) .. "]",
              getFunc = function() return BMU_SVAcc.hideOthers end,
              setFunc = function(value) BMU_SVAcc.hideOthers = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hideOthers"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_HIDE_PVP),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["hidePVP"]) .. "]",
              getFunc = function() return BMU_SVAcc.hidePVP end,
              setFunc = function(value) BMU_SVAcc.hidePVP = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hidePVP"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["hideClosedDungeons"]) .. "]",
              getFunc = function() return BMU_SVAcc.hideClosedDungeons end,
              setFunc = function(value) BMU_SVAcc.hideClosedDungeons = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hideClosedDungeons"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_HIDE_DELVES),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["hideDelves"]) .. "]",
              getFunc = function() return BMU_SVAcc.hideDelves end,
              setFunc = function(value) BMU_SVAcc.hideDelves = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hideDelves"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["hidePublicDungeons"]) .. "]",
              getFunc = function() return BMU_SVAcc.hidePublicDungeons end,
              setFunc = function(value) BMU_SVAcc.hidePublicDungeons = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hidePublicDungeons"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_HIDE_HOUSES),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["hideHouses"]) .. "]",
              getFunc = function() return BMU_SVAcc.hideHouses end,
              setFunc = function(value) BMU_SVAcc.hideHouses = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hideHouses"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_HIDE_OWN_HOUSES),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["hideOwnHouses"]) .. "]",
              getFunc = function() return BMU_SVAcc.hideOwnHouses end,
              setFunc = function(value) BMU_SVAcc.hideOwnHouses = value end,
			  default = BMU_DefaultsPerAccount["hideOwnHouses"],
			  submenu = "bl",
         },
		 {
              type = "description",
              text = BMU_SI_get(SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION),
			  submenu = "prio",
         },
         {
              type = "dropdown",
			  width = "half",
              name = "PRIO 1",
              tooltip = "",
			  choices = BMU.dropdownPrioSourceChoices,
			  choicesValues = BMU.dropdownPrioSourceValues,
              getFunc = function() return BMU.savedVarsServ.prioritizationSource[1] end,
			  setFunc = function(value)
				-- swap positions
				local index = BMU_getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
				BMU.savedVarsServ.prioritizationSource[index] = BMU.savedVarsServ.prioritizationSource[1]
				BMU.savedVarsServ.prioritizationSource[1] = value
			  end,
			  default = BMU.DefaultsServer["prioritizationSource"][1],
			  submenu = "prio",
        },
		{
              type = "dropdown",
			  width = "half",
              name = "PRIO 2",
              tooltip = "",
			  choices = BMU.dropdownPrioSourceChoices,
			  choicesValues = BMU.dropdownPrioSourceValues,
              getFunc = function() return BMU.savedVarsServ.prioritizationSource[2] end,
			  setFunc = function(value)
				-- swap positions
				local index = BMU_getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
				BMU.savedVarsServ.prioritizationSource[index] = BMU.savedVarsServ.prioritizationSource[2]
				BMU.savedVarsServ.prioritizationSource[2] = value
			  end,
			  disabled = function()
				if #BMU.dropdownPrioSourceValues >= 2 then
					return false
				else
					return true
				end
			  end,
			  default = BMU.DefaultsServer["prioritizationSource"][2],
			  submenu = "prio",
        },
		{
              type = "dropdown",
			  width = "half",
              name = "PRIO 3",
              tooltip = "",
			  choices = BMU.dropdownPrioSourceChoices,
			  choicesValues = BMU.dropdownPrioSourceValues,
              getFunc = function() return BMU.savedVarsServ.prioritizationSource[3] end,
			  setFunc = function(value)
			  	-- swap positions
				local index = BMU_getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
				BMU.savedVarsServ.prioritizationSource[index] = BMU.savedVarsServ.prioritizationSource[3]
				BMU.savedVarsServ.prioritizationSource[3] = value
			  end,
			  disabled = function()
				if #BMU.dropdownPrioSourceValues >= 3 then
					return false
				else
					return true
				end
			  end,
			  default = BMU.DefaultsServer["prioritizationSource"][3],
			  submenu = "prio",
        },
		{
              type = "dropdown",
			  width = "half",
              name = "PRIO 4",
              tooltip = "",
			  choices = BMU.dropdownPrioSourceChoices,
			  choicesValues = BMU.dropdownPrioSourceValues,
              getFunc = function() return BMU.savedVarsServ.prioritizationSource[4] end,
			  setFunc = function(value)
				-- swap positions
				local index = BMU_getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
				BMU.savedVarsServ.prioritizationSource[index] = BMU.savedVarsServ.prioritizationSource[4]
				BMU.savedVarsServ.prioritizationSource[4] = value
			  end,
			  disabled = function()
				if #BMU.dropdownPrioSourceValues >= 4 then
					return false
				else
					return true
				end
			  end,
			  default = BMU.DefaultsServer["prioritizationSource"][4],
			  submenu = "prio",
        },
		{
              type = "dropdown",
			  width = "half",
              name = "PRIO 5",
              tooltip = "",
			  choices = BMU.dropdownPrioSourceChoices,
			  choicesValues = BMU.dropdownPrioSourceValues,
              getFunc = function() return BMU.savedVarsServ.prioritizationSource[5] end,
			  setFunc = function(value)
			  			  	-- swap positions
				local index = BMU_getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
				BMU.savedVarsServ.prioritizationSource[index] = BMU.savedVarsServ.prioritizationSource[5]
				BMU.savedVarsServ.prioritizationSource[5] = value
			  end,
			  disabled = function()
				if #BMU.dropdownPrioSourceValues >= 5 then
					return false
				else
					return true
				end
			  end,
			  default = BMU.DefaultsServer["prioritizationSource"][5],
			  submenu = "prio",
        },
		{
              type = "dropdown",
			  width = "half",
              name = "PRIO 6",
              tooltip = "",
			  choices = BMU.dropdownPrioSourceChoices,
			  choicesValues = BMU.dropdownPrioSourceValues,
              getFunc = function() return BMU.savedVarsServ.prioritizationSource[6] end,
			  setFunc = function(value)
			  	-- swap positions
				local index = BMU_getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
				BMU.savedVarsServ.prioritizationSource[index] = BMU.savedVarsServ.prioritizationSource[6]
				BMU.savedVarsServ.prioritizationSource[6] = value
			  end,
			  disabled = function()
				if #BMU.dropdownPrioSourceValues >= 6 then
					return false
				else
					return true
				end
			  end,
			  default = BMU.DefaultsServer["prioritizationSource"][6],
			  submenu = "prio",
        },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["showTeleportAnimation"]) .. "]",
              getFunc = function() return BMU_SVAcc.showTeleportAnimation end,
              setFunc = function(value) BMU_SVAcc.showTeleportAnimation = value end,
			  default = BMU_DefaultsPerAccount["showTeleportAnimation"],
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["usePanAndZoom"]) .. "]",
              getFunc = function() return BMU_SVAcc.usePanAndZoom end,
              setFunc = function(value) BMU_SVAcc.usePanAndZoom = value end,
			  default = BMU_DefaultsPerAccount["usePanAndZoom"],
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_USE_RALLY_POINT),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["useMapPing"]) .. "]",
              getFunc = function() return BMU_SVAcc.useMapPing end,
              setFunc = function(value) BMU_SVAcc.useMapPing = value end,
			  disabled = function() return not BMU.LibMapPing end,
			  default = BMU_DefaultsPerAccount["useMapPing"],
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
         {
              type = "dropdown",
              name = BMU_SI_get(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownSecLangChoices[BMU_DefaultsPerAccount["secondLanguage"]] .. "]",
			  choices = BMU.dropdownSecLangChoices,
			  choicesValues = BMU.dropdownSecLangValues,
              getFunc = function() return BMU_SVAcc.secondLanguage end,
			  setFunc = function(value) BMU_SVAcc.secondLanguage = value
                  BMU.secondLanguageChanged = true                                                  --INS251229 Baertram
              end,
			  default = BMU_DefaultsPerAccount["secondLanguage"],
			  submenu = "adv",
        },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["FavoritePlayerStatusNotification"]) .. "]",
              getFunc = function() return BMU_SVAcc.FavoritePlayerStatusNotification end,
              setFunc = function(value) BMU_SVAcc.FavoritePlayerStatusNotification = value end,
			  default = BMU_DefaultsPerAccount["FavoritePlayerStatusNotification"],
			  requiresReload = true,
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["surveyMapsNotification"]) .. "]",
              getFunc = function() return BMU_SVAcc.surveyMapsNotification end,
              setFunc = function(value) BMU_SVAcc.surveyMapsNotification = value end,
			  default = BMU_DefaultsPerAccount["surveyMapsNotification"],
			  requiresReload = true,
			  width = "half",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["surveyMapsNotificationSound"]) .. "]",
              getFunc = function() return BMU_SVAcc.surveyMapsNotificationSound end,
              setFunc = function(value) BMU_SVAcc.surveyMapsNotificationSound = value end,
			  default = BMU_DefaultsPerAccount["surveyMapsNotificationSound"],
			  disabled = function() return not BMU_SVAcc.surveyMapsNotification end,
			  width = "half",
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["wayshrineTravelAutoConfirm"]) .. "]",
              getFunc = function() return BMU_SVAcc.wayshrineTravelAutoConfirm end,
              setFunc = function(value) BMU_SVAcc.wayshrineTravelAutoConfirm = value end,
			  default = BMU_DefaultsPerAccount["wayshrineTravelAutoConfirm"],
			  requiresReload = true,
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = BMU_SI_get(SI.TELE_SETTINGS_OFFLINE_NOTE),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["showOfflineReminder"]) .. "]",
              getFunc = function() return BMU_SVAcc.showOfflineReminder end,
              setFunc = function(value) BMU_SVAcc.showOfflineReminder = value end,
			  default = BMU_DefaultsPerAccount["showOfflineReminder"],
			  requiresReload = true,
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
			  type = "checkbox",
			  name = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_FAST_TRAVEL),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_FAST_TRAVEL_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["chatOutputFastTravel"]) .. "]",
			  getFunc = function() return BMU_SVAcc.chatOutputFastTravel end,
			  setFunc = function(value) BMU_SVAcc.chatOutputFastTravel = value end,
			  default = BMU_DefaultsPerAccount["chatOutputFastTravel"],
			  submenu = "co",
	     },
	     {
			  type = "checkbox",
			  name = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_ADDITIONAL),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_ADDITIONAL_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["chatOutputAdditional"]) .. "]",
			  getFunc = function() return BMU_SVAcc.chatOutputAdditional end,
			  setFunc = function(value) BMU_SVAcc.chatOutputAdditional = value end,
			  default = BMU_DefaultsPerAccount["chatOutputAdditional"],
			  submenu = "co",
   		 },
   		 {
			  type = "checkbox",
			  name = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_UNLOCK),
		 	  tooltip = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_UNLOCK_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsPerAccount["chatOutputUnlock"]) .. "]",
			  getFunc = function() return BMU_SVAcc.chatOutputUnlock end,
			  setFunc = function(value) BMU_SVAcc.chatOutputUnlock = value end,
			  default = BMU_DefaultsPerAccount["chatOutputUnlock"],
			  submenu = "co",
		 },
		 {
			  type = "checkbox",
			  name = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_DEBUG),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_DEBUG_TOOLTIP),
			  getFunc = function() return BMU.debugMode end,
			  setFunc = function(value) BMU.debugMode = value end,
			  default = false,
			  warning = "This option can not be set permanently.",
			  submenu = "co",
	     },
		 {
              type = "button",
              name = BMU_colorizeText(BMU_SI_get(SI.TELE_SETTINGS_RESET_ALL_COUNTERS), "red"),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP),
			  func = function() for zoneId, _ in pairs(BMU_SVAcc.portCounterPerZone) do
									BMU_SVAcc.portCounterPerZone[zoneId] = nil
								end
								BMU.printToChat("ALL COUNTERS RESETTET!")
						end,
			  width = "half",
			  warning = "All zone counters are reset. Therefore, the sorting by most used and your personal statistics are reset.",
			  submenu = "adv",
         },
	     {
              type = "description",
              text = "Port to specific zone\n(Hint: when you start typing /<zone name> the auto completion will appear on top)\n" .. BMU_colorizeText("/bmutp/<zone name>\n", "gold") .. BMU_colorizeText("Example: /bmutp/deshaan", "lgray"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port to group leader\n" .. BMU_colorizeText("/bmutp/leader", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port to currently focused quest\n" .. BMU_colorizeText("/bmutp/quest", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port into primary residence\n" .. BMU_colorizeText("/bmutp/house", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port outside primary residence\n" .. BMU_colorizeText("/bmutp/house_out", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port to current zone\n" .. BMU_colorizeText("/bmutp/current_zone", "gold"),
			  submenu = "cc",
         },
		 {
              type = "divider",
			  submenu = "cc",
         },
	     {
			type = "description",
			text = "Add zone favorite manually\n" .. BMU_colorizeText("/bmu/favorites/add/zone <fav slot> <zoneName or zoneId> \n", "gold") .. BMU_colorizeText("Example: /bmu/favorites/add/zone 1 Deshaan", "lgray"),
			submenu = "cc",
	   	 },
	     {
              type = "description",
              text = "Add player favorite manually\n" .. BMU_colorizeText("/bmu/favorites/add/player <fav slot> <player name>\n", "gold") .. BMU_colorizeText("Example: /bmu/favorites/add/player 1 @DeadSoon", "lgray"),
			  submenu = "cc",
         },
	     {
			  type = "description",
			  text = "Add wayshrine favorite\nOnce executed, you must interact (`E`) with your favorite wayshrine within 10 seconds. You can assign hotkeys for your favorite wayshrines.\n" .. BMU_colorizeText("/bmu/favorites/add/wayshrine <fav slot>\n", "gold") .. BMU_colorizeText("Example: /bmu/favorites/add/wayshrine 1", "lgray"),
			  submenu = "cc",
	     },
	     {
			  type = "divider",
			  submenu = "cc",
	     },
	     {
              type = "description",
              text = "Add house favorite for zoneID\n" .. BMU_colorizeText("/bmu/house/set/zone <zoneID> <houseID>\n", "gold") .. BMU_colorizeText("Example: /bmu/house/set/zone 1086 68", "lgray"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Add house favorite for current zone\n" .. BMU_colorizeText("/bmu/house/set/current_zone <houseID>\n", "gold") .. BMU_colorizeText("Example: /bmu/house/set/current_zone 68", "lgray"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Add current house as favorite for current zone\n" .. BMU_colorizeText("/bmu/house/set/current_house\n", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Clear house favorite for current zone\n" .. BMU_colorizeText("/bmu/house/clear/current_zone\n", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Clear house for zone\n" .. BMU_colorizeText("/bmu/house/clear/zone <zoneID>\n", "gold") .. BMU_colorizeText("Example: /bmu/house/clear/zone 1086", "lgray"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "List house favorites\n" .. BMU_colorizeText("/bmu/house/list\n", "gold"),
			  submenu = "cc",
         },
	     {
			  type = "divider",
			  submenu = "cc",
	     },
	     {
              type = "description",
              text = "Start custom vote in group (100% are necessary)\n" .. BMU_colorizeText("/bmu/vote/custom_vote_unanimous <your text>\n", "gold") .. BMU_colorizeText("Example: /bmu/vote/custom_vote_unanimous Do you like BeamMeUp?", "lgray"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Start custom vote in group (>=60% are necessary)\n" .. BMU_colorizeText("/bmu/vote/custom_vote_supermajority <your text>", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Start custom vote in group (>50% are necessary)\n" .. BMU_colorizeText("/bmu/vote/custom_vote_simplemajority <your text>", "gold"),
			  submenu = "cc",
         },
		 {
              type = "divider",
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Promote BeamMeUp by printing short advertising text in the chat\n" .. BMU_colorizeText("/bmu/misc/advertise", "gold"),
			  submenu = "cc",
         },
	     {
			type = "description",
			text = "Get current zone id (where the player actually is)\n" .. BMU_colorizeText("/bmu/misc/current_zone_id", "gold"),
			submenu = "cc",
	   	 },
	     {
              type = "description",
              text = "Switch client language (instant reload!)\n" .. BMU_colorizeText("/bmu/misc/lang", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Enable debug mode\n" .. BMU_colorizeText("/bmu/misc/debug", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_get(SI.TELE_SETTINGS_INSTALLED_SCINCE),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = tostring(os.date('%Y/%m/%d', BMU_SVAcc.initialTimeStamp)),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = BMU_SI_get(SI.TELE_UI_TOTAL_PORTS),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
			-- NOTE: "text" parameter must always be string since LAM2 do not handle integer values correctly 
              text = tostring(BMU.formatGold(BMU_SVAcc.totalPortCounter)),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = BMU_SI_get(SI.TELE_UI_GOLD),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = tostring(BMU.formatGold(BMU_SVAcc.savedGold)),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = BMU_SI_get(SI.TELE_SETTINGS_MOST_PORTED_ZONES),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = mostPortedZonesText,
			  width = "half",
			  submenu = "stats",
         },
    }
	
	--LAM2:RegisterOptionControls(appName .. "Options", optionsData)
	
	-- group options by submenu
	local optionsBySubmenu = {}
	for _, option in ipairs(optionsData) do
		if option.submenu ~= nil then
			if optionsBySubmenu[option.submenu] == nil then
				optionsBySubmenu[option.submenu] = {}
			end
			table.insert(optionsBySubmenu[option.submenu], option)
		end
	end
	
	-- create submenus
	local submenu1 = {
		type = "submenu",
		name = "Addon Extensions",
		controls = optionsBySubmenu["deps"],
	}
	local submenu2 = {
		type = "submenu",
		name = BMU_SI_get(SI.TELE_SETTINGS_HEADER_UI),
		controls = optionsBySubmenu["ui"],
	}
	local submenu3 = {
		type = "submenu",
		name = BMU_SI_get(SI.TELE_SETTINGS_HEADER_RECORDS),
		controls = optionsBySubmenu["rec"],
	}
	local submenu4 = {
		type = "submenu",
		name = BMU_SI_get(SI.TELE_SETTINGS_HEADER_BLACKLISTING),
		controls = optionsBySubmenu["bl"],
	}
	local submenu5 = {
		type = "submenu",
		name = BMU_SI_get(SI.TELE_SETTINGS_HEADER_PRIO),
		controls = optionsBySubmenu["prio"],
	}
	local submenu6 = {
		type = "submenu",
		name = BMU_SI_get(SI.TELE_SETTINGS_HEADER_ADVANCED),
		controls = optionsBySubmenu["adv"],
	}
	local submenu7 = {
		type = "submenu",
		name = BMU_SI_get(SI.TELE_SETTINGS_HEADER_CHAT_OUTPUT),
		controls = optionsBySubmenu["co"],
	}
	local submenu8 = {
		type = "submenu",
		name = BMU_SI_get(SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS),
		controls = optionsBySubmenu["cc"],
	}
	local submenu9 = {
		type = "submenu",
		name = BMU_SI_get(SI.TELE_SETTINGS_HEADER_STATS),
		controls = optionsBySubmenu["stats"],
	}
	
	-- register all submenus with options
	-- TODO: add submenu1
	LAM2:RegisterOptionControls(appName .. "Options", {submenu1, submenu2, submenu3, submenu4, submenu5, submenu6, submenu7, submenu8, submenu9})
end


function BMU.getStringIsInstalledLibrary(addonName)
	local stringInstalled = BMU_colorizeText("installed and enabled", "green")
	local stringNotInstalled = BMU_colorizeText("not installed or disabled", "red")
	
	-- PortToFriendsHouse
	if string.lower(addonName) == "ptf" then
		if PortToFriend and PortToFriend.GetFavorites then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end

	-- LibSets
	if string.lower(addonName) == "libsets" then
		if BMU.LibSets and BMU.LibSets.GetNumItemSetCollectionZoneUnlockedPieces then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end
	
	-- LibMapPing
	if string.lower(addonName) == "libmapping" then
		if BMU.LibMapPing then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end

	-- LibSlashCommander
	if string.lower(addonName) == "lsc" then
		if BMU.LSC then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end

	-- LibChatMenuButton
	if string.lower(addonName) == "lcmb" then
		if BMU.LCMB then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end
	
	-- GamePadMode "IsJustaBmuGamepadPlugin"
	if string.lower(addonName) == "gamepad" then
		if IsJustaBmuGamepadPlugin or IJA_BMU_GAMEPAD_PLUGIN then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end
	
	-- return empty string if addonName cant bne matched
	return ""
end

-- update content and position of the counter panel
-- display the sum of each related item type without any filter consideration
local textPattern = "%s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d" --INS251229 Baertram Memory and performance improvement: Do not redefine same string again and again on each function call!
function BMU.updateRelatedItemsCounterPanel()
	local counterPanel = BMU.counterPanel   --INS251229 Baertram
    local svAcc = BMU.savedVarsAcc          --INS251229 Baertram
    local scale = svAcc.Scale               --INS251229 Baertram
    BMU_getDataMapInfo = BMU_getDataMapInfo or BMU.getDataMapInfo --INS251229 Baertram calling same function in 2x nested loop below -> Significant performance improvement!
    BMU_getItemTypeIcon = BMU_getItemTypeIcon or BMU.getItemTypeIcon --INS251229 Baertram Performance reference for multiple same used function below

	local counter_table = {
		["alchemist"] = 0,
		["enchanter"] = 0,
		["woodworker"] = 0,
		["blacksmith"] = 0,
		["clothier"] = 0,
		["jewelry"] = 0,
		["treasure"] = 0,
		["leads"] = 0,
	}

	-- count treasure and survey maps
	local bags = {BAG_BACKPACK, BAG_BANK, BAG_SUBSCRIBER_BANK}
    -- go over all bags and bank
	for _, bagId in ipairs(bags) do
		local lastSlot = GetBagSize(bagId)
		for slotIndex = 0, lastSlot, 1 do
			--local itemName = GetItemName(bagId, slotIndex) --CHG251229 Baertram Not used variable, performance gain
			--local itemType, specializedItemType = GetItemType(bagId, slotIndex) --CHG251229 Baertram Not used variable, performance gain
			local itemId = GetItemId(bagId, slotIndex)
			local _, itemCount, _, _, _, _, _, _ = GetItemInfo(bagId, slotIndex)
            local subType, _ = BMU_getDataMapInfo(itemId)          --CHG251229 Baertram
				
			-- check if item is known from internal data table
			if subType and counter_table[subType] ~= nil then
				counter_table[subType] = counter_table[subType] + itemCount
			end
		end
	end

	-- count leads
	local antiquityId = GetNextAntiquityId()
	while antiquityId do
		if DoesAntiquityHaveLead(antiquityId) then
			counter_table["leads"] = counter_table["leads"] + 1
		end
		antiquityId = GetNextAntiquityId(antiquityId)
	end

	-- set dimension of the icons accordingly to the scale level
	local dimension = 28 * scale --CHG251229 Baertram

	-- build argument list
	local arguments_list = {
		BMU_getItemTypeIcon("alchemist", dimension), counter_table["alchemist"],    --CHG251229 Baertram
		BMU_getItemTypeIcon("enchanter", dimension), counter_table["enchanter"],    --CHG251229 Baertram
		BMU_getItemTypeIcon("woodworker", dimension), counter_table["woodworker"],  --CHG251229 Baertram
		BMU_getItemTypeIcon("blacksmith", dimension), counter_table["blacksmith"],  --CHG251229 Baertram
		BMU_getItemTypeIcon("clothier", dimension), counter_table["clothier"],      --CHG251229 Baertram
		BMU_getItemTypeIcon("jewelry", dimension), counter_table["jewelry"],        --CHG251229 Baertram
		BMU_getItemTypeIcon("treasure", dimension), counter_table["treasure"],      --CHG251229 Baertram
		BMU_getItemTypeIcon("leads", dimension), counter_table["leads"]             --CHG251229 Baertram
	}
	
	local text = string.format(textPattern, unpack(arguments_list))                 --CHG251229 Baertram
	counterPanel:SetText(text)                                                      --CHG251229 Baertram
	-- update position (number of lines may have changed)
	counterPanel:ClearAnchors()                                                     --CHG251229 Baertram
	counterPanel:SetAnchor(TOP, BMU.win.Main_Control, TOP, 1*scale, (90*scale)+((svAcc.numberLines*40)*scale))  --CHG251229 Baertram
end


local function SetupUI()
    local svAcc = BMU.savedVarsAcc                                      --INS251229 Baertram
    local scale = svAcc.Scale                                           --INS251229 Baertram
    BMU_clearInputFields = BMU_clearInputFields or BMU.clearInputFields --INS251229 Baertram

	-----------------------------------------------
	-- Fonts
	
	-- default font
	local fontSize = BMU_round(17*scale, 0)   --CHG251229 Baertram
	local fontStyle = ZoFontGame:GetFontInfo()
	local fontWeight = "soft-shadow-thin"
	BMU.font1 = string.format("%s|$(KB_%s)|%s", fontStyle, fontSize, fontWeight)
	
	-- font of statistics
	fontSize = BMU_round(13*scale, 0)       --CHG251229 Baertram
	fontStyle = ZoFontBookTablet:GetFontInfo()
	--fontStyle = "EsoUI/Common/Fonts/consola.ttf"
	fontWeight = "soft-shadow-thin"
	BMU.font2 = string.format("%s|$(KB_%s)|%s", fontStyle, fontSize, fontWeight)
	
	-----------------------------------------------
    local teleporterWin = BMU.win

    -----------------------------------------------
	
	-- Button on Chat Window
	if BMU.savedVarsAcc.chatButton then
        local BMU_textures_wayshrineBtn = BMU_textures.wayshrineBtn --INS251229 Baertram performance improvement for multiple used variable reference
        local BMU_textures_wayshrineBtnOver = BMU_textures.wayshrineBtnOver --INS251229 Baertram performance improvement for multiple used variable reference
        BMU_OpenTeleporter = BMU_OpenTeleporter or BMU.OpenTeleporter --INS251229 Baertram performance improvement for multiple used variable reference

		if BMU.LCMB then
			-- LibChatMenuButton is enabled
			-- register chat button via library
			-- NOTE: Since BMU.chatButtonTex is not defined, the option for the offset is disabled automatically (positioning is handled by the lib)
			BMU.chatButtonLCMB = BMU.LCMB.addChatButton("!!!BMUChatButton", {BMU_textures_wayshrineBtn, BMU_textures_wayshrineBtnOver}, appName, function() BMU_OpenTeleporter(true) end) --CHG251229 Baertram Performance improvement by using defined local
		else
			-- do it the old way
			-- Texture
			local BMU_chatButtonTex = wm:CreateControl("Teleporter_CHAT_MENU_BUTTON", zo_ChatWindow, CT_TEXTURE) --CHG251229 Baertram Performance improvedment for multiple used variable
            BMU.chatButtonTex = BMU_chatButtonTex --INS251229 Baertram
			BMU_chatButtonTex:SetDimensions(33, 33)  --CHG251229 Baertram
			BMU_chatButtonTex:SetAnchor(TOPRIGHT, zo_ChatWindow, TOPRIGHT, -40 - BMU.savedVarsAcc.chatButtonHorizontalOffset, 6) --CHG251229 Baertram
			BMU_chatButtonTex:SetTexture(BMU_textures_wayshrineBtn) --CHG251229 Baertram
			BMU_chatButtonTex:SetMouseEnabled(true) --CHG251229 Baertram
			BMU_chatButtonTex:SetDrawLayer(2) --CHG251229 Baertram
			--Handlers
			BMU_chatButtonTex:SetHandler("OnMouseUp", function() --CHG251229 Baertram
				BMU_OpenTeleporter(true)
			end)
			
			BMU_chatButtonTex:SetHandler("OnMouseEnter", function(chatButtonTexCtrl) --CHG251229 Baertram
				chatButtonTexCtrl:SetTexture(BMU_textures_wayshrineBtnOver) --CHG251229 Baertram
				BMU_tooltipTextEnter(BMU, chatButtonTexCtrl, appName) --CHG251229 Baertram Performance improvement for multiple called same function, respecting : notation (1st passed in param must be the BMU table then)
			end)
		
			BMU_chatButtonTex:SetHandler("OnMouseExit", function(chatButtonTexCtrl) --CHG251229 Baertram
				chatButtonTexCtrl:SetTexture(BMU_textures_wayshrineBtn) --CHG251229 Baertram
				BMU_tooltipTextEnter(BMU, chatButtonTexCtrl) --CHG251229 Baertram Performance improvement for multiple called same function, respecting : notation (1st passed in param must be the BMU table then)
			end)
		end
	end
	
	-----------------------------------------------
	
	-----------------------------------------------
	-- Bandits Integration -> Add custom button to the side bar (with delay to ensure, that BUI is loaded)
	zo_callLater(function()
        local BUI = BUI --INS251229 Baertram Performance improvement for multiple called same variable
		if BUI and BUI.PanelAdd then
            BMU_OpenTeleporter = BMU_OpenTeleporter or BMU.OpenTeleporter --INS251229 Baertram performance improvement for multiple used variable reference
			local content = {
					{	
						icon = BMU_textures.wayshrineBtn,
						tooltip	= appName, --CHG251229 Baertram Performance improvement by using defined local
						func = function() BMU_OpenTeleporter(true) end,
						enabled	= true
					},
					--	{icon="",tooltip="",func=function()end,enabled=true},	-- Button 2, etc.
				}
		
			-- add custom button to side bar (Allowing of custom side bar buttons must be activated in BUI settings)
			BUI.PanelAdd(content)
		end
	end,1000)
	-----------------------------------------------

  --------------------------------------------------------------------------------------------------------------
  --Main Controller. Please notice that teleporterWin comes from our globals variables, as does wm
  --------------------------------------------------------------------------------------------------------------
  local teleporterWin_Main_Control = wm:CreateTopLevelWindow("Teleporter_Location_MainController") --INS251229 Baertram performance improvement for multiple used variable reference
  teleporterWin.Main_Control = teleporterWin_Main_Control --INS251229 Baertram

  teleporterWin_Main_Control:SetMouseEnabled(true) --CHG251229 Baertram
  teleporterWin_Main_Control:SetDimensions(500*scale,400*scale) --CHG251229 Baertram
  teleporterWin_Main_Control:SetHidden(true) --CHG251229 Baertram

  teleporterWin.appTitle =  wm:CreateControl("Teleporter_appTitle", teleporterWin_Main_Control, CT_LABEL) --CHG251229 Baertram
  teleporterWin.appTitle:SetFont(BMU.font1) --CHG251229 Baertram
  teleporterWin.appTitle:SetColor(255, 255, 255, 1) --CHG251229 Baertram
  teleporterWin.appTitle:SetText(BMU_colorizeText(appName, "gold") .. BMU_colorizeText(" - Teleporter", "white")) --CHG251229 Baertram
  --teleporterWin.appTitle:SetAnchor(TOP, teleporterWin_Main_Control, TOP, -31*BMU.savedVarsAcc.Scale, -62*BMU.savedVarsAcc.Scale) --CHG251229 Baertram
  teleporterWin.appTitle:SetAnchor(CENTER, teleporterWin_Main_Control, TOP, nil, -62*scale) --CHG251229 Baertram
  
  ----- This is where we create the list element for TeleUnicorn/ List
  BMU.TeleporterList = BMU.ListView.new(teleporterWin_Main_Control,  {
    width = 750*scale, --CHG251229 Baertram
    height = 500*scale, --CHG251229 Baertram
  })
  
  ---------

  
    -------------------------------------------------------------------
  -- Switch BUTTON ON ZoneGuide window
  local teleporterWin_zoneGuideSwapTexture = wm:CreateControl(nil, zo_WorldMapZoneStoryTopLevel_Keyboard, CT_TEXTURE) --CHG251229 Baertram Performance improvement
  teleporterWin.zoneGuideSwapTexture = teleporterWin_zoneGuideSwapTexture --CHG251229 Baertram Performance improvement
  teleporterWin_zoneGuideSwapTexture:SetDimensions(50*scale, 50*scale) --CHG251229 Baertram Performance improvement
  teleporterWin_zoneGuideSwapTexture:SetAnchor(TOPRIGHT, zo_WorldMapZoneStoryTopLevel_Keyboard, TOPRIGHT, TOPRIGHT -10*scale, -35*scale) --CHG251229 Baertram Performance improvement
  teleporterWin_zoneGuideSwapTexture:SetTexture(BMU_textures.swapBtn) --CHG251229 Baertram Performance improvement
  teleporterWin_zoneGuideSwapTexture:SetMouseEnabled(true) --CHG251229 Baertram Performance improvement
  
  teleporterWin_zoneGuideSwapTexture:SetHandler("OnMouseUp", function()
      BMU_OpenTeleporter = BMU_OpenTeleporter or BMU.OpenTeleporter --INS251229 Baertram performance improvement for multiple used variable reference
	  BMU_OpenTeleporter(true) ----CHG251229 Baertram Performance improvement by using local
	end)

  teleporterWin_zoneGuideSwapTexture:SetHandler("OnMouseEnter", function(teleporterWinZoneGuideSwapTextureCtrl) --CHG251229 Baertram Performance improvement
      teleporterWinZoneGuideSwapTextureCtrl:SetTexture(BMU_textures.swapBtnOver) --CHG251229 Baertram Performance improvement
      BMU_tooltipTextEnter(BMU, teleporterWinZoneGuideSwapTextureCtrl,
          BMU_SI_get(SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE)) --CHG251229 Baertram Performance improvement
  end)

  teleporterWin_zoneGuideSwapTexture:SetHandler("OnMouseExit", function(teleporterWinZoneGuideSwapTextureCtrl) --CHG251229 Baertram Performance improvement
      teleporterWinZoneGuideSwapTextureCtrl:SetTexture(BMU_textures.swapBtn) --CHG251229 Baertram Performance improvement
      BMU_tooltipTextEnter(BMU, teleporterWinZoneGuideSwapTextureCtrl) --CHG251229 Baertram Performance improvement
  end)

  ---------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------
  -- Feedback BUTTON
  local teleporterWin_feedbackTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)  --INS251229 Baertram
  teleporterWin.feedbackTexture = teleporterWin_feedbackTexture --INS251229 Baertram
  teleporterWin_feedbackTexture:SetDimensions(50*scale, 50*scale) --CHG251229 Baertram
  teleporterWin_feedbackTexture:SetAnchor(TOPLEFT, teleporterWin_Main_Control, TOPLEFT, TOPLEFT-35*scale, -75*scale) --CHG251229 Baertram
  teleporterWin_feedbackTexture:SetTexture(BMU_textures.feedbackBtn) --CHG251229 Baertram
  teleporterWin_feedbackTexture:SetMouseEnabled(true) --CHG251229 Baertram
  
  teleporterWin_feedbackTexture:SetHandler("OnMouseUp", function() --CHG251229 Baertram
      BMU.createMail(teleporterVars.feedbackContact, "Feedback - BeamMeUp", "") --CHG251229 Baertram
	end)
	  
  teleporterWin_feedbackTexture:SetHandler("OnMouseEnter", function(teleporterWin_feedbackTextureCtrl) --CHG251229 Baertram
      teleporterWin_feedbackTextureCtrl:SetTexture(BMU_textures.feedbackBtnOver) --CHG251229 Baertram
      BMU_tooltipTextEnter(BMU, teleporterWin_feedbackTextureCtrl, --CHG251229 Baertram
          GetString(SI_CUSTOMER_SERVICE_SUBMIT_FEEDBACK))
  end)

  teleporterWin_feedbackTexture:SetHandler("OnMouseExit", function(teleporterWin_feedbackTextureCtrl) --CHG251229 Baertram
      teleporterWin_feedbackTextureCtrl:SetTexture(BMU_textures.feedbackBtn) --CHG251229 Baertram
      BMU_tooltipTextEnter(BMU, teleporterWin_feedbackTextureCtrl) --CHG251229 Baertram
  end)
  
      -------------------------------------------------------------------
  -- Guild BUTTON
  -- display button only if guilds are available on players game server
	if teleporterVars.BMUGuilds[worldName] ~= nil then --CHG251229 Baertram
		local teleporterWin_guildTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
        teleporterWin.guildTexture = teleporterWin_guildTexture
		teleporterWin_guildTexture:SetDimensions(40*scale, 40*scale)
		teleporterWin_guildTexture:SetAnchor(TOPLEFT, teleporterWin_Main_Control, TOPLEFT, TOPLEFT+10*scale, -75*scale)
		teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtn)
		teleporterWin_guildTexture:SetMouseEnabled(true)
	  
		teleporterWin_guildTexture:SetHandler("OnMouseUp", function(self, button)
			if not BMU.isCurrentlyRequestingGuildData then
				BMU.requestGuildData()
			end
            BMU_clearInputFields()
			zo_callLater(function() BMU.createTableGuilds() end, 350)
		end)
			  
		teleporterWin_guildTexture:SetHandler("OnMouseEnter", function(self)
		  teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtnOver)
		  BMU:tooltipTextEnter(teleporterWin_guildTexture,
			BMU_SI_get(SI.TELE_UI_BTN_GUILD_BMU))
		end)

		teleporterWin_guildTexture:SetHandler("OnMouseExit", function(self)
		  BMU:tooltipTextEnter(teleporterWin_guildTexture)
		  if BMU.state ~= BMU.indexListGuilds then
			teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtn)
		  end
		end)
	end
  
  
      -------------------------------------------------------------------
  -- Guild House BUTTON
  -- display button only if guild house is available on players game server
  if BMU.var.guildHouse[worldName] ~= nil then
	  teleporterWin.guildHouseTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
	  teleporterWin.guildHouseTexture:SetDimensions(40*scale, 40*scale)
	  teleporterWin.guildHouseTexture:SetAnchor(TOPLEFT, teleporterWin_Main_Control, TOPLEFT, TOPLEFT+55*scale, -75*scale)
	  teleporterWin.guildHouseTexture:SetTexture(BMU_textures.guildHouseBtn)
	  teleporterWin.guildHouseTexture:SetMouseEnabled(true)
  
	  teleporterWin.guildHouseTexture:SetHandler("OnMouseUp", function()
		  BMU.portToBMUGuildHouse()
		end)
		  
	  teleporterWin.guildHouseTexture:SetHandler("OnMouseEnter", function(self)
		  teleporterWin.guildHouseTexture:SetTexture(BMU_textures.guildHouseBtnOver)
		  BMU:tooltipTextEnter(teleporterWin.guildHouseTexture,
			  BMU_SI_get(SI.TELE_UI_BTN_GUILD_HOUSE_BMU))
	  end)

	  teleporterWin.guildHouseTexture:SetHandler("OnMouseExit", function(self)
		  teleporterWin.guildHouseTexture:SetTexture(BMU_textures.guildHouseBtn)
		  BMU:tooltipTextEnter(teleporterWin.guildHouseTexture)
	  end)
  end
  
  
  -------------------------------------------------------------------
	-- Lock/Fix window BUTTON
	local lockTexture

	teleporterWin.fixWindowTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
	teleporterWin.fixWindowTexture:SetDimensions(50*scale, 50*scale)
	teleporterWin.fixWindowTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, TOPRIGHT-65*scale, -75*scale)
	-- decide which texture to show
	if BMU.savedVarsAcc.fixedWindow == true then
		lockTexture = BMU_textures.lockClosedBtn
	else
		lockTexture = BMU_textures.lockOpenBtn
	end
	teleporterWin.fixWindowTexture:SetTexture(lockTexture)
	teleporterWin.fixWindowTexture:SetMouseEnabled(true)
 
	teleporterWin.fixWindowTexture:SetHandler("OnMouseUp", function()
		-- change setting
		BMU.savedVarsAcc.fixedWindow = not BMU.savedVarsAcc.fixedWindow
		-- fix/unfix window
		BMU.control_global.bd:SetMovable(not BMU.savedVarsAcc.fixedWindow)
		-- change texture
		if BMU.savedVarsAcc.fixedWindow then
			-- show closed lock over
			lockTexture = BMU_textures.lockClosedBtnOver
		else
			-- show open lock over
			lockTexture = BMU_textures.lockOpenBtnOver
		end
		teleporterWin.fixWindowTexture:SetTexture(lockTexture)
	end)
	
	teleporterWin.fixWindowTexture:SetHandler("OnMouseEnter", function(self)
		if BMU.savedVarsAcc.fixedWindow then
			-- show closed lock over
			lockTexture = BMU_textures.lockClosedBtnOver
		else
			-- show open lock over
			lockTexture = BMU_textures.lockOpenBtnOver
		end
		teleporterWin.fixWindowTexture:SetTexture(lockTexture)
		BMU:tooltipTextEnter(teleporterWin.fixWindowTexture,BMU_SI_get(SI.TELE_UI_BTN_FIX_WINDOW))
	end)

	teleporterWin.fixWindowTexture:SetHandler("OnMouseExit", function(self)
		if BMU.savedVarsAcc.fixedWindow then
			-- show closed lock
			lockTexture = BMU_textures.lockClosedBtn
		else
			-- show open lock
			lockTexture = BMU_textures.lockOpenBtn
		end
		teleporterWin.fixWindowTexture:SetTexture(lockTexture)
		BMU:tooltipTextEnter(teleporterWin.fixWindowTexture)
	end)


  ---------------------------------------------------------------------------------------------------------------
  -- ANCHOR BUTTON

  teleporterWin.anchorTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin.anchorTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin.anchorTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, TOPRIGHT-20*scale, -75*scale)
  teleporterWin.anchorTexture:SetTexture(BMU_textures.anchorMapBtn)
  teleporterWin.anchorTexture:SetMouseEnabled(true)
  
  teleporterWin.anchorTexture:SetHandler("OnMouseUp", function()
	BMU.savedVarsAcc.anchorOnMap = not BMU.savedVarsAcc.anchorOnMap
    BMU.updatePosition()
  end)
	  
  teleporterWin.anchorTexture:SetHandler("OnMouseEnter", function(self)
	teleporterWin.anchorTexture:SetTexture(BMU_textures.anchorMapBtnOver)
      BMU:tooltipTextEnter(teleporterWin.anchorTexture,
          BMU_SI_get(SI.TELE_UI_BTN_ANCHOR_ON_MAP))
  end)

  teleporterWin.anchorTexture:SetHandler("OnMouseExit", function(self)
	if not BMU.savedVarsAcc.anchorOnMap then
		teleporterWin.anchorTexture:SetTexture(BMU_textures.anchorMapBtn)
	end
      BMU:tooltipTextEnter(teleporterWin.anchorTexture)
  end)

  
  -------------------------------------------------------------------
  -- CLOSE / SWAP BUTTON

  teleporterWin.closeTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin.closeTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin.closeTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, TOPRIGHT+25*scale, -75*scale)
  teleporterWin.closeTexture:SetTexture(BMU_textures.closeBtn)
  teleporterWin.closeTexture:SetMouseEnabled(true)
  teleporterWin.closeTexture:SetDrawLayer(2)

  teleporterWin.closeTexture:SetHandler("OnMouseUp", function()
      BMU.HideTeleporter()  end)
	  
  teleporterWin.closeTexture:SetHandler("OnMouseEnter", function(self)
	teleporterWin.closeTexture:SetTexture(BMU_textures.closeBtnOver)
      BMU:tooltipTextEnter(teleporterWin.closeTexture,
          GetString(SI_DIALOG_CLOSE))
  end)

  teleporterWin.closeTexture:SetHandler("OnMouseExit", function(self)
      BMU:tooltipTextEnter(teleporterWin.closeTexture)
  end)


  -------------------------------------------------------------------
  -- OPEN BUTTON ON MAP (upper left corner)
  
	if BMU.savedVarsAcc.showOpenButtonOnMap then
		teleporterWin.MapOpen = CreateControlFromVirtual("TeleporterReopenButon", ZO_WorldMap, "ZO_DefaultButton")
		teleporterWin.MapOpen:SetAnchor(TOPLEFT)
		teleporterWin.MapOpen:SetWidth(200)
		teleporterWin.MapOpen:SetText(appName)
		teleporterWin.MapOpen:SetHidden(true)
  
		teleporterWin.MapOpen:SetHandler("OnClicked",function()
			BMU.OpenTeleporter(true)
		end)
	end

   ---------------------------------------------------------------------------------------------------------------
   -- Search Symbol (no button)
   
  teleporterWin.SearchTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin.SearchTexture:SetDimensions(25*scale, 25*scale)
  teleporterWin.SearchTexture:SetAnchor(TOPLEFT, teleporterWin_Main_Control, TOPLEFT, TOPLEFT-35*scale, -10*scale)

  teleporterWin.SearchTexture:SetTexture(BMU_textures.searchBtn)
  
  ---------------------------------------------------------------------------------------------------------------
  -- Searcher (Search for Players)
  
   teleporterWin.Searcher_Player = CreateControlFromVirtual("Teleporter_SEARCH_EDITBOX",  teleporterWin_Main_Control, "ZO_DefaultEditForBackdrop")
   teleporterWin.Searcher_Player:SetParent(teleporterWin_Main_Control)
   teleporterWin.Searcher_Player:SetSimpleAnchorParent(10*scale,-10*scale)
   teleporterWin.Searcher_Player:SetDimensions(105*scale,25*scale)
   teleporterWin.Searcher_Player:SetResizeToFitDescendents(false)
   teleporterWin.Searcher_Player:SetFont(BMU.font1)

	-- Placeholder
  	teleporterWin.Searcher_Player.Placeholder = wm:CreateControl("Teleporter_SEARCH_EDITBOX_Placeholder", teleporterWin.Searcher_Player, CT_LABEL)
    teleporterWin.Searcher_Player.Placeholder:SetSimpleAnchorParent(4*scale,0)
	teleporterWin.Searcher_Player.Placeholder:SetFont(BMU.font1)
	teleporterWin.Searcher_Player.Placeholder:SetText(BMU_colorizeText(GetString(SI_PLAYER_MENU_PLAYER), "lgray"))
    
  -- BackGround
  teleporterWin.SearchBG = wm:CreateControlFromVirtual(" teleporterWin.SearchBG",  teleporterWin.Searcher_Player, "ZO_DefaultBackdrop")
  teleporterWin.SearchBG:ClearAnchors()
  teleporterWin.SearchBG:SetAnchorFill(teleporterWin.Searcher_Player)
  teleporterWin.SearchBG:SetDimensions(teleporterWin.Searcher_Player:GetWidth(),  teleporterWin.Searcher_Player:GetHeight())
  teleporterWin.SearchBG.controlType = CT_CONTROL
  teleporterWin.SearchBG.system = SETTING_TYPE_UI
  teleporterWin.SearchBG:SetHidden(false)
  teleporterWin.SearchBG:SetMouseEnabled(false)
  teleporterWin.SearchBG:SetMovable(false)
  teleporterWin.SearchBG:SetClampedToScreen(true)
  
  -- Handlers
  ZO_PreHookHandler(teleporterWin.Searcher_Player, "OnTextChanged", function(self)
	if self:HasFocus() and (teleporterWin.Searcher_Player:GetText() ~= "" or (teleporterWin.Searcher_Player:GetText() == "" and BMU.state == BMU.indexListSearchPlayer)) then
		-- make sure player placeholder is hidden
		teleporterWin.Searcher_Player.Placeholder:SetHidden(true)
		-- clear zone input field
		teleporterWin.Searcher_Zone:SetText("")
		-- show zone placeholder
		teleporterWin.Searcher_Zone.Placeholder:SetHidden(false)
		BMU.createTable({index=BMU.indexListSearchPlayer, inputString=teleporterWin.Searcher_Player:GetText()})
	end
  end)
  
  teleporterWin.Searcher_Player:SetHandler("OnFocusGained", function(self)
	teleporterWin.Searcher_Player.Placeholder:SetHidden(true)
  end)
  
  teleporterWin.Searcher_Player:SetHandler("OnFocusLost", function(self)
	if teleporterWin.Searcher_Player:GetText() == "" then
		teleporterWin.Searcher_Player.Placeholder:SetHidden(false)
	end
  end)

  ---------------------------------------------------------------------------------------------------------------
  -- Searcher (Search for zones)

  teleporterWin.Searcher_Zone = CreateControlFromVirtual("Teleporter_Searcher_Player_EDITBOX1",  teleporterWin_Main_Control, "ZO_DefaultEditForBackdrop")
  teleporterWin.Searcher_Zone:SetParent(teleporterWin_Main_Control)
  teleporterWin.Searcher_Zone:SetSimpleAnchorParent(140*scale,-10*scale)
  teleporterWin.Searcher_Zone:SetDimensions(105*scale,25*scale)
  teleporterWin.Searcher_Zone:SetResizeToFitDescendents(false)
  teleporterWin.Searcher_Zone:SetFont(BMU.font1)
  
  -- Placeholder
  teleporterWin.Searcher_Zone.Placeholder = wm:CreateControl("TTeleporter_Searcher_Player_EDITBOX1_Placeholder", teleporterWin.Searcher_Zone, CT_LABEL)
  teleporterWin.Searcher_Zone.Placeholder:SetSimpleAnchorParent(4*scale,0*scale)
  teleporterWin.Searcher_Zone.Placeholder:SetFont(BMU.font1)
  teleporterWin.Searcher_Zone.Placeholder:SetText(BMU_colorizeText(GetString(SI_CHAT_CHANNEL_NAME_ZONE), "lgray"))

  -- BG
  teleporterWin.SearchBG_Player = wm:CreateControlFromVirtual(" teleporterWin.SearchBG_Zone",  teleporterWin.Searcher_Zone, "ZO_DefaultBackdrop")
  teleporterWin.SearchBG_Player:ClearAnchors()
  teleporterWin.SearchBG_Player:SetAnchorFill( teleporterWin.Searcher_Zone)
  teleporterWin.SearchBG_Player:SetDimensions( teleporterWin.Searcher_Zone:GetWidth(),  teleporterWin.Searcher_Zone:GetHeight())
  teleporterWin.SearchBG_Player.controlType = CT_CONTROL
  teleporterWin.SearchBG_Player.system = SETTING_TYPE_UI
  teleporterWin.SearchBG_Player:SetHidden(false)
  teleporterWin.SearchBG_Player:SetMouseEnabled(false)
  teleporterWin.SearchBG_Player:SetMovable(false)
  teleporterWin.SearchBG_Player:SetClampedToScreen(true)
  
  -- Handlers
    ZO_PreHookHandler(teleporterWin.Searcher_Zone, "OnTextChanged", function(self)
		if self:HasFocus() and (teleporterWin.Searcher_Zone:GetText() ~= "" or (teleporterWin.Searcher_Zone:GetText() == "" and BMU.state == BMU.indexListSearchZone)) then
			-- make sure zone placeholder is hidden
			teleporterWin.Searcher_Zone.Placeholder:SetHidden(true)
			-- clear player input field
			teleporterWin.Searcher_Player:SetText("")
			-- show player placeholder
			teleporterWin.Searcher_Player.Placeholder:SetHidden(false)
			if BMU.state == BMU.indexListDungeons then
				BMU.createTableDungeons({inputString=teleporterWin.Searcher_Zone:GetText()})
			else
				BMU.createTable({index=BMU.indexListSearchZone, inputString=teleporterWin.Searcher_Zone:GetText()})
			end
		end
	end)
	
	teleporterWin.Searcher_Zone:SetHandler("OnFocusGained", function(self)
		teleporterWin.Searcher_Zone.Placeholder:SetHidden(true)
	end)
  
	teleporterWin.Searcher_Zone:SetHandler("OnFocusLost", function(self)
		if teleporterWin.Searcher_Zone:GetText() == "" then
			teleporterWin.Searcher_Zone.Placeholder:SetHidden(false)
		end
	end)


  ---------------------------------------------------------------------------------------------------------------
  -- Refresh Button
  
  teleporterWin_Main_Control.RefreshTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.RefreshTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.RefreshTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -80*scale, -5*scale)
  teleporterWin_Main_Control.RefreshTexture:SetTexture(BMU_textures.refreshBtn)
  teleporterWin_Main_Control.RefreshTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.RefreshTexture:SetDrawLayer(2)

  teleporterWin_Main_Control.RefreshTexture:SetHandler("OnMouseUp", function(self)
		if BMU.state == BMU.indexListMain then
			-- dont reset slider if user stays already on main list
			BMU.createTable({index=BMU.indexListMain, dontResetSlider=true})
		else
			BMU.createTable({index=BMU.indexListMain})
		end
  end)
  
  teleporterWin_Main_Control.RefreshTexture:SetHandler("OnMouseEnter", function(self)
      BMU:tooltipTextEnter(teleporterWin_Main_Control.RefreshTexture,
          BMU_SI_get(SI.TELE_UI_BTN_REFRESH_ALL))
      teleporterWin_Main_Control.RefreshTexture:SetTexture(BMU_textures.refreshBtnOver)end)

  teleporterWin_Main_Control.RefreshTexture:SetHandler("OnMouseExit", function(self)
      BMU:tooltipTextEnter(teleporterWin_Main_Control.RefreshTexture)
      teleporterWin_Main_Control.RefreshTexture:SetTexture(BMU_textures.refreshBtn)end)


  ---------------------------------------------------------------------------------------------------------------
  -- Unlock wayshrines

  teleporterWin_Main_Control.portalToAllTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.portalToAllTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.portalToAllTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -40*scale, -5*scale)
  teleporterWin_Main_Control.portalToAllTexture:SetTexture(BMU_textures.wayshrineBtn2)
  teleporterWin_Main_Control.portalToAllTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.portalToAllTexture:SetDrawLayer(2)
  
	teleporterWin_Main_Control.portalToAllTexture:SetHandler("OnMouseUp", function(self, button)
		BMU.showDialogAutoUnlock()
	end)
  
  teleporterWin_Main_Control.portalToAllTexture:SetHandler("OnMouseEnter", function(self)
	teleporterWin_Main_Control.portalToAllTexture:SetTexture(BMU_textures.wayshrineBtnOver2)
		local tooltipTextCompletion = ""
		if BMU.isZoneOverlandZone() then
			-- add wayshrine discovery info from ZoneGuide
			-- Attention: if the user is in Artaeum, he will see the total number of wayshrines (inclusive Summerset)
			-- however, when starting the auto unlock the function getZoneWayshrineCompletion() will check which wayshrines are really located on this map
			local zoneWayhsrineDiscoveryInfo, zoneWayshrineDiscovered, zoneWayshrineTotal = BMU.getZoneGuideDiscoveryInfo(GetZoneId(GetUnitZoneIndex("player")), ZONE_COMPLETION_TYPE_WAYSHRINES)
			if zoneWayhsrineDiscoveryInfo ~= nil then
				tooltipTextCompletion = "(" .. zoneWayshrineDiscovered .. "/" .. zoneWayshrineTotal .. ")"
				if zoneWayshrineDiscovered >= zoneWayshrineTotal then
					tooltipTextCompletion = BMU_colorizeText(tooltipTextCompletion, "green")
				end
			end
		end
		-- display number of unlocked wayshrines in current zone
		BMU:tooltipTextEnter(teleporterWin_Main_Control.portalToAllTexture, BMU_SI_get(SI.TELE_UI_BTN_UNLOCK_WS) .. " " .. tooltipTextCompletion)
	end)

  teleporterWin_Main_Control.portalToAllTexture:SetHandler("OnMouseExit", function(self)
	teleporterWin_Main_Control.portalToAllTexture:SetTexture(BMU_textures.wayshrineBtn2)
	BMU:tooltipTextEnter(teleporterWin_Main_Control.portalToAllTexture)
  end)
  
  
  ---------------------------------------------------------------------------------------------------------------
  -- Settings
  
  teleporterWin_Main_Control.SettingsTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.SettingsTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.SettingsTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, 0, -5*scale)
  teleporterWin_Main_Control.SettingsTexture:SetTexture(BMU_textures.settingsBtn)
  teleporterWin_Main_Control.SettingsTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.SettingsTexture:SetDrawLayer(2)

  teleporterWin_Main_Control.SettingsTexture:SetHandler("OnMouseUp", function(self)
	BMU.HideTeleporter()
	LAM2:OpenToPanel(BMU.SettingsPanel)
  end)
  
  teleporterWin_Main_Control.SettingsTexture:SetHandler("OnMouseEnter", function(self)
      BMU:tooltipTextEnter(teleporterWin_Main_Control.SettingsTexture,
          GetString(SI_GAME_MENU_SETTINGS))
      teleporterWin_Main_Control.SettingsTexture:SetTexture(BMU_textures.settingsBtnOver)
  end)

  teleporterWin_Main_Control.SettingsTexture:SetHandler("OnMouseExit", function(self)
      BMU:tooltipTextEnter(teleporterWin_Main_Control.SettingsTexture)
      teleporterWin_Main_Control.SettingsTexture:SetTexture(BMU_textures.settingsBtn)
  end)
	  

  ---------------------------------------------------------------------------------------------------------------
  -- "Port to Friends House" Integration
  
  teleporterWin_Main_Control.PTFTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.PTFTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.PTFTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -250*scale, 40*scale)
  teleporterWin_Main_Control.PTFTexture:SetTexture(BMU_textures.ptfHouseBtn)
  teleporterWin_Main_Control.PTFTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.PTFTexture:SetDrawLayer(2)
    local PortToFriend = PortToFriend --INS251229 Baertram performance improvement for 2 same used global variables
	if PortToFriend and PortToFriend.GetFavorites then
		-- enable tab	
		teleporterWin_Main_Control.PTFTexture:SetHandler("OnMouseUp", function(self, button, upInside) --CHG251229 Baertram Usage of upInside to properly check the user releaased the mouse on the control!!!
			if upInside and button == MOUSE_BUTTON_INDEX_RIGHT then --CHG251229 Baertram Usage of upInside to properly check the user releaased the mouse on the control!!!
				-- toggle between zone names and house names
                local BMU_savedVarsChar = BMU.savedVarsChar --INS251229 Baertram Performance gain for multiple used samed variable
				ClearMenu()
                local menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_UI_TOOGLE_ZONE_NAME), function() BMU_savedVarsChar.ptfHouseZoneNames = not BMU_savedVarsChar.ptfHouseZoneNames BMU_clearInputFields() BMU.createTablePTF() end, MENU_ADD_OPTION_CHECKBOX)
				if BMU_savedVarsChar.ptfHouseZoneNames then
					zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
				end
				ShowMenu()
			else
                BMU_clearInputFields()
				BMU.createTablePTF()
			end
		end)
  
		teleporterWin_Main_Control.PTFTexture:SetHandler("OnMouseEnter", function(self)
			BMU:tooltipTextEnter(teleporterWin_Main_Control.PTFTexture,
				BMU_SI_get(SI.TELE_UI_BTN_PTF_INTEGRATION) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
			teleporterWin_Main_Control.PTFTexture:SetTexture(BMU_textures.ptfHouseBtnOver)
		end)

		teleporterWin_Main_Control.PTFTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin_Main_Control.PTFTexture)
			if BMU.state ~= BMU.indexListPTFHouses then
				teleporterWin_Main_Control.PTFTexture:SetTexture(BMU_textures.ptfHouseBtn)
			end
		end)
	else
		-- disable tab
		teleporterWin_Main_Control.PTFTexture:SetAlpha(0.4)
		
		teleporterWin_Main_Control.PTFTexture:SetHandler("OnMouseUp", function()
			BMU.showDialogSimple("PTFIntegrationMissing", BMU_SI_get(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE), BMU_SI_get(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY), function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info1758-PorttoFriendsHouse.html") end, nil)
		end)
		
		teleporterWin_Main_Control.PTFTexture:SetHandler("OnMouseEnter", function(self)
			BMU:tooltipTextEnter(teleporterWin_Main_Control.PTFTexture, BMU_SI_get(SI.TELE_UI_BTN_PTF_INTEGRATION))
		end)
		
		teleporterWin_Main_Control.PTFTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin_Main_Control.PTFTexture)
		end)
	end
	  
  ---------------------------------------------------------------------------------------------------------------
  -- Own Houses
  
  teleporterWin_Main_Control.OwnHouseTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.OwnHouseTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.OwnHouseTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -205*scale, 40*scale)
  teleporterWin_Main_Control.OwnHouseTexture:SetTexture(BMU_textures.houseBtn)
  teleporterWin_Main_Control.OwnHouseTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.OwnHouseTexture:SetDrawLayer(2)

  teleporterWin_Main_Control.OwnHouseTexture:SetHandler("OnMouseUp", function(self, button)
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		ClearMenu()
		
		-- toggle between nicknames and standard names
		local menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_UI_TOGGLE_HOUSE_NICKNAME), function() BMU.savedVarsChar.houseNickNames = not BMU.savedVarsChar.houseNickNames BMU_clearInputFields() BMU.createTableHouses() end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.houseNickNames then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)

		-- make default tab
		menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListOwnHouses then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListOwnHouses end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.defaultTab == BMU.indexListOwnHouses then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		ShowMenu()
	else
        BMU_clearInputFields( )
		BMU.createTableHouses()
	end
  end)
  
  teleporterWin_Main_Control.OwnHouseTexture:SetHandler("OnMouseEnter", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.OwnHouseTexture,
		BMU_SI_get(SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin_Main_Control.OwnHouseTexture:SetTexture(BMU_textures.houseBtnOver)
  end)

  teleporterWin_Main_Control.OwnHouseTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.OwnHouseTexture)
	if BMU.state ~= BMU.indexListOwnHouses then
		teleporterWin_Main_Control.OwnHouseTexture:SetTexture(BMU_textures.houseBtn)
	end
  end)

  
    ---------------------------------------------------------------------------------------------------------------
  -- Related Quests
  
  teleporterWin_Main_Control.QuestTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.QuestTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.QuestTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -160*scale, 40*scale)
  teleporterWin_Main_Control.QuestTexture:SetTexture(BMU_textures.questBtn)
  teleporterWin_Main_Control.QuestTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.QuestTexture:SetDrawLayer(2)

  teleporterWin_Main_Control.QuestTexture:SetHandler("OnMouseUp", function(self, button)
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show context menu
		ClearMenu()
		-- make default tab
		local menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListQuests then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListQuests end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.defaultTab == BMU.indexListQuests then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end
		ShowMenu()
	else
		BMU.createTable({index=BMU.indexListQuests})
	end
  end)
  
  teleporterWin_Main_Control.QuestTexture:SetHandler("OnMouseEnter", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.QuestTexture,
		GetString(SI_JOURNAL_MENU_QUESTS) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin_Main_Control.QuestTexture:SetTexture(BMU_textures.questBtnOver)
  end)

  teleporterWin_Main_Control.QuestTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.QuestTexture)
	if BMU.state ~= BMU.indexListQuests then
		teleporterWin_Main_Control.QuestTexture:SetTexture(BMU_textures.questBtn)
	end
  end)
 
 
 ---------------------------------------------------------------------------------------------------------------
  -- Related Items
  
  teleporterWin_Main_Control.ItemTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.ItemTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.ItemTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -120*scale, 40*scale)
  teleporterWin_Main_Control.ItemTexture:SetTexture(BMU_textures.relatedItemsBtn)
  teleporterWin_Main_Control.ItemTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.ItemTexture:SetDrawLayer(2)

  -- -v- INS251229 Baertram BEGIN 1 Variables for the relevant submenu opening controls
  local submenuIndicesToAddCallbackTo = {}
  local BMU_ItemTexture
  --reference variables for performance etc.
  local BMU_updateCheckboxSurveyMap
  local function BMU_CreateTable_IndexListItems() --local function which is not redefined each contextMenu open again and again and again -> memory and performance drain!
    BMU.createTable({index=BMU.indexListItems})
  end
  -- -^- INS251229 Baertram END 1
  teleporterWin_Main_Control.ItemTexture:SetHandler("OnMouseUp", function(self, button)
      BMU_ItemTexture = BMU_ItemTexture or teleporterWin_Main_Control.ItemTexture               --INS251229 Baertram
      BMU_updateCheckboxSurveyMap = BMU_updateCheckboxSurveyMap or BMU.updateCheckboxSurveyMap  --INS251229 Baertram
	  submenuIndicesToAddCallbackTo = {}                                                        --INS251229 Baertram
      if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show filter menu
		ClearMenu()

		-- Add submenu for antiquity leads
		submenuIndicesToAddCallbackTo[#submenuIndicesToAddCallbackTo+1] = AddCustomSubMenuItem(GetString(SI_GAMEPAD_VENDOR_ANTIQUITY_LEAD_GROUP_HEADER), --INS251229 Baertram
			{
				{
					label = GetString(SI_ANTIQUITY_SCRYABLE),
					callback = function()
						BMU.savedVarsChar.displayAntiquityLeads.srcyable = not BMU.savedVarsChar.displayAntiquityLeads.srcyable
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayAntiquityLeads.srcyable end,
				},
				{
					label = GetString(SI_ANTIQUITY_SUBHEADING_IN_PROGRESS),
					callback = function()
						BMU.savedVarsChar.displayAntiquityLeads.scried = not BMU.savedVarsChar.displayAntiquityLeads.scried
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayAntiquityLeads.scried end,
				},
				{
					label = GetString(SI_SCREEN_NARRATION_ACHIEVEMENT_EARNED_ICON_NARRATION) .. " (" .. GetString(SI_ANTIQUITY_LOG_BOOK) .. ")",
					callback = function()
						BMU.savedVarsChar.displayAntiquityLeads.completed = not BMU.savedVarsChar.displayAntiquityLeads.completed
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayAntiquityLeads.completed end,
				},
			}, nil, nil, nil, 5
		)

		-- Clues
		local menuIndex = AddCustomMenuItem(GetString(SI_SPECIALIZEDITEMTYPE113), function() BMU.savedVarsChar.displayMaps.clue = not BMU.savedVarsChar.displayMaps.clue BMU_CreateTable_IndexListItems() end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
		if BMU.savedVarsChar.displayMaps.clue then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end
		
		-- Treasure Maps
		menuIndex = AddCustomMenuItem(GetString(SI_SPECIALIZEDITEMTYPE100), function() BMU.savedVarsChar.displayMaps.treasure = not BMU.savedVarsChar.displayMaps.treasure BMU_CreateTable_IndexListItems() end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
		if BMU.savedVarsChar.displayMaps.treasure then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end
		
		-- All Survey Maps
        BMU_getContextMenuEntrySurveyAllAppendix = BMU_getContextMenuEntrySurveyAllAppendix or BMU.getContextMenuEntrySurveyAllAppendix --INS251229 Baertram
		BMU.menuIndexSurveyAll = AddCustomMenuItem(GetString(SI_SPECIALIZEDITEMTYPE101) .. BMU_getContextMenuEntrySurveyAllAppendix(), --CHG251229 Baertram
			function()
				if zo_CheckButton_IsChecked(zo_Menu.items[BMU.menuIndexSurveyAll].checkbox) then
					-- check all subTypes
					BMU_updateCheckboxSurveyMap(1)
				else
					-- uncheck all subTypes
					BMU_updateCheckboxSurveyMap(2)
				end
				BMU_CreateTable_IndexListItems()
			end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 4)
			
		if BMU.numOfSurveyTypesChecked() > 0 then
			zo_CheckButton_SetChecked(zo_Menu.items[BMU.menuIndexSurveyAll].checkbox)
		end
		
		-- Add submenu for survey types filter
		submenuIndicesToAddCallbackTo[#submenuIndicesToAddCallbackTo+1] = AddCustomSubMenuItem(GetString(SI_GAMEPAD_BANK_FILTER_HEADER), --INS251229 Baertram
			{
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY14),
					callback = function()
						BMU.savedVarsChar.displayMaps.alchemist = not BMU.savedVarsChar.displayMaps.alchemist
						BMU_updateCheckboxSurveyMap(3)
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.alchemist end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY15),
					callback = function()
						BMU.savedVarsChar.displayMaps.enchanter = not BMU.savedVarsChar.displayMaps.enchanter
						BMU_updateCheckboxSurveyMap(3)
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.enchanter end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY12),
					callback = function()
						BMU.savedVarsChar.displayMaps.woodworker = not BMU.savedVarsChar.displayMaps.woodworker
						BMU_updateCheckboxSurveyMap(3)
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.woodworker end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY10),
					callback = function()
						BMU.savedVarsChar.displayMaps.blacksmith = not BMU.savedVarsChar.displayMaps.blacksmith
						BMU_updateCheckboxSurveyMap(3)
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.blacksmith end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY11),
					callback = function()
						BMU.savedVarsChar.displayMaps.clothier = not BMU.savedVarsChar.displayMaps.clothier
						BMU_updateCheckboxSurveyMap(3)
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.clothier end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY13),
					callback = function()
						BMU.savedVarsChar.displayMaps.jewelry = not BMU.savedVarsChar.displayMaps.jewelry
						BMU_updateCheckboxSurveyMap(3)
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.jewelry end,
				},
			}, nil, nil, nil, 5
		)
		
		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)
		
		-- include bank items
		menuIndex = AddCustomMenuItem(GetString(SI_CRAFTING_INCLUDE_BANKED), function() BMU.savedVarsChar.scanBankForMaps = not BMU.savedVarsChar.scanBankForMaps BMU_CreateTable_IndexListItems() end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
		if BMU.savedVarsChar.scanBankForMaps then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		-- enable/disable counter panel
		menuIndex = AddCustomMenuItem(GetString(SI_ENDLESS_DUNGEON_BUFF_TRACKER_SWITCH_TO_SUMMARY_KEYBIND), function() BMU.savedVarsChar.displayCounterPanel = not BMU.savedVarsChar.displayCounterPanel BMU_CreateTable_IndexListItems() end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
		if BMU.savedVarsChar.displayCounterPanel then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)

		-- make default tab
		menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListItems then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListItems end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.defaultTab == BMU.indexListItems then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end
		
		ShowMenu()
	else
		BMU_CreateTable_IndexListItems()
		BMU.showNotification(true)
	end
  end)
  -- -v- INS251229 Baertram BEGIN 2 - Variables for the submenu OnMouseUp click handler -> Clicking the submenu opening controls toggles all checkboxes in the submenu to checked/unchecked
  BMU_ItemTexture = BMU_ItemTexture or teleporterWin_Main_Control.ItemTexture

  --Called from ZO_Menu_OnHide callback
  local function cleanUpzo_MenuItemsSubmenuSpecialCallbacks()
--d("[BMU]cleanUpzo_MenuItemsSubmenuSpecialCallbacks")
      if zo_IsTableEmpty(submenuIndicesToAddCallbackTo) or zo_IsTableEmpty(zo_MenuSubmenuItemsHooked) then return end
      submenuIndicesToAddCallbackTo = {}
      zo_MenuSubmenuItemsHooked = {}
  end

  --Check if LibCustomMenuSubmenu is shown and if any enabled and shown checkboxes are in the submenu, then change the clicked state of them
  --> Called from clicking the ZO_Menu entry which opens the submenu
  local function checkIfLibCustomMenuSubmenuShownAndToggleCheckboxes(itemCtrl, mouseButton, upInside)
--d("[BMU]checkIfLibCustomMenuSubmenuShownAndToggleCheckboxes-mouseButton: " .. tostring(mouseButton) .. ", upInside: " ..tostring(upInside))
      --LibCustomMenuSubmenu got entries?
      if not upInside or mouseButton ~= MOUSE_BUTTON_INDEX_LEFT or not libCustomMenuSubmenu or zo_MenuSubmenuItemsHooked[itemCtrl] == nil then return end
      --Get the current state of the submenu (if not set yet it is assumed to be "all unchecked")
      local checkboxesAtSubmenuNewState = checkboxesAtSubmenuCurrentState[itemCtrl] or false
      --and invert it (on -> off / off -> on)
      checkboxesAtSubmenuNewState = not checkboxesAtSubmenuNewState

      --Check all child controls of the submenu for any checkbox entry and set the new state and calling the toggle function of the checkbox
      for childIndex=1, libCustomMenuSubmenu:GetNumChildren(), 1 do
        local childCtrl = libCustomMenuSubmenu:GetChild(childIndex)
--d(">found childCtrl: " ..tostring(childCtrl:GetName()))
          --Child is a subMenuItem?
          if childCtrl ~= nil then
            local checkBox = childCtrl.checkbox
            if childCtrl.IsHidden and childCtrl.IsMouseEnabled and not childCtrl:IsHidden() and childCtrl:IsMouseEnabled()
                  and checkBox and checkBox.toggleFunction and zo_CheckButton_IsEnabled(checkBox)
                  and childCtrl.GetName and zoPlainStrFind(childCtrl:GetName(), LCM_SubmenuEntryNamePrefix) ~= nil then
--d(">>set new state to: " ..tostring(checkboxesAtSubmenuNewState))
              zo_CheckButton_SetCheckState(checkBox, (checkboxesAtSubmenuNewState == false and BSTATE_NORMAL) or BSTATE_PRESSED)
              checkBox:toggleFunction(checkboxesAtSubmenuNewState)
            end
          end
      end
  end

  --Add the PreHook for handler OnMouseUp, on the submenu opening ZO_Menu item control row
  local function AddToggleAllSubmenuCheckboxEntriesCallback(submenuIndex)
      --d("[BMU]AddToggleAllSubmenuCheckboxEntriesCallback-index: " .. tostring(submenuIndex))
      if not submenuIndex then return end
      local submenuItem = zo_Menu.items[submenuIndex]
      local itemCtrl = submenuItem and submenuItem.item or nil
      --d(">found the itemCtrl: " .. tostring(itemCtrl))
      --Found the zo_Menu submenu opening control?
      if not itemCtrl then return end
      --Add the OnEffectivelyShown handler to the submenu opening control of zo_Menu (if not already in it)
      if zo_MenuSubmenuItemsHooked[itemCtrl] ~= nil then return end
      zo_MenuSubmenuItemsHooked[itemCtrl] = true
      ZO_PreHookHandler(itemCtrl, "OnMouseUp", checkIfLibCustomMenuSubmenuShownAndToggleCheckboxes)
  end

  --Add a prehook to the OnMouseUp handler of the relevant submenu opening ZO_Menu controls (saved into table submenuIndicesToAddCallbackTo)
  ZO_PostHook("ShowMenu", function(owner, initialRefCount, menuType)
      owner = owner or moc()
      menuType = menuType or MENU_TYPE_DEFAULT
--d("[BMU]ShowMenu-owner: " .. tostring(owner) .. "/" .. tostring(BMU_ItemTexture) .. "; menuType: " ..tostring(menuType))
      --Check if the menu is our at the BMU panel's itemTexture, if it got entries, if special submenu items have been defined -> Else abort
      if menuType ~= MENU_TYPE_DEFAULT or (owner == nil or owner ~= BMU_ItemTexture) or zo_IsTableEmpty(submenuIndicesToAddCallbackTo)
              or next(zo_Menu.items) == nil then return end
      zo_MenuSubmenuItemsHooked = {}
      --Add the OnMouseUp handler to the submenu's "opening control" so clicking them will enable/disable (toggle) all the checkboxes inside the submenu
      for _, indexToAddTo in ipairs(submenuIndicesToAddCallbackTo) do
          AddToggleAllSubmenuCheckboxEntriesCallback(indexToAddTo)
      end
      --Called at zo_Menu_OnHide, and cleaned automatically at ClearMenu()
      SetMenuHiddenCallback(cleanUpzo_MenuItemsSubmenuSpecialCallbacks)
  end)
  -- -^- INS251229 Baertram - END 2
  
  teleporterWin_Main_Control.ItemTexture:SetHandler("OnMouseEnter", function(self)
	-- set tooltip accordingly to the selected filter
	local tooltip = ""
    local BMU_savedVarsChar = BMU.savedVarsChar --INS251229 Baertram
	if BMU_savedVarsChar.displayAntiquityLeads.scried or BMU_savedVarsChar.displayAntiquityLeads.srcyable then
		tooltip = GetString(SI_ANTIQUITY_LEAD_TOOLTIP_TAG)
	end
	if BMU_savedVarsChar.displayMaps.clue then
		if tooltip ~= "" then
			tooltip = tooltip .. " + " .. GetString(SI_SPECIALIZEDITEMTYPE113)
		else
			tooltip = GetString(SI_SPECIALIZEDITEMTYPE113)
		end
	end
	if BMU_savedVarsChar.displayMaps.treasure then
		if tooltip ~= "" then
			tooltip = tooltip .. " + " .. GetString(SI_SPECIALIZEDITEMTYPE100)
		else
			tooltip = GetString(SI_SPECIALIZEDITEMTYPE100)
		end
	end
	if BMU.numOfSurveyTypesChecked() > 0 then
		if tooltip ~= "" then
			tooltip = tooltip .. " + " .. GetString(SI_SPECIALIZEDITEMTYPE101)
		else
			tooltip = GetString(SI_SPECIALIZEDITEMTYPE101)
		end
	end
	-- add right-click info
	tooltip = tooltip .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU)
	
	-- show tooltip
    BMU:tooltipTextEnter(teleporterWin_Main_Control.ItemTexture, tooltip)
    -- button highlight
	teleporterWin_Main_Control.ItemTexture:SetTexture(BMU_textures.relatedItemsBtnOver)
  end)

  teleporterWin_Main_Control.ItemTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.ItemTexture)
	if BMU.state ~= BMU.indexListItems then
		teleporterWin_Main_Control.ItemTexture:SetTexture(BMU_textures.relatedItemsBtn)
	end
  end)

  -- Create counter panel that displays the counter for each type
  BMU.counterPanel = WINDOW_MANAGER:CreateControl(nil, BMU.win.Main_Control, CT_LABEL)
  BMU.counterPanel:SetFont(BMU.font1)
  BMU.counterPanel:SetHidden(true)

  ---------------------------------------------------------------------------------------------------------------
  -- Only current zone

  teleporterWin_Main_Control.OnlyYourzoneTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.OnlyYourzoneTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.OnlyYourzoneTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -80*scale, 40*scale)
  teleporterWin_Main_Control.OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtn)
  teleporterWin_Main_Control.OnlyYourzoneTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.OnlyYourzoneTexture:SetDrawLayer(2)
  
	teleporterWin_Main_Control.OnlyYourzoneTexture:SetHandler("OnMouseUp", function(self, button)
		if button == MOUSE_BUTTON_INDEX_RIGHT then
			-- show context menu
			ClearMenu()
			-- make default tab
			local menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListCurrentZone then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListCurrentZone end end, MENU_ADD_OPTION_CHECKBOX)
			if BMU.savedVarsChar.defaultTab == BMU.indexListCurrentZone then
				zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
			end
			ShowMenu()
		else
			BMU.createTable({index=BMU.indexListCurrentZone})
		end
	end)
  
    teleporterWin_Main_Control.OnlyYourzoneTexture:SetHandler("OnMouseEnter", function(self)
		BMU:tooltipTextEnter(teleporterWin_Main_Control.OnlyYourzoneTexture,
			GetString(SI_ANTIQUITY_SCRYABLE_CURRENT_ZONE_SUBCATEGORY) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
		teleporterWin_Main_Control.OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtnOver)
	end)
	
	teleporterWin_Main_Control.OnlyYourzoneTexture:SetHandler("OnMouseExit", function(self)
		BMU:tooltipTextEnter(teleporterWin_Main_Control.OnlyYourzoneTexture)
		if BMU.state ~= BMU.indexListCurrentZone then
			teleporterWin_Main_Control.OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtn)
		end
	end)
	
	
  ---------------------------------------------------------------------------------------------------------------
  -- Delves in current zone
  
  teleporterWin_Main_Control.DelvesTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.DelvesTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.DelvesTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -40*scale, 40*scale)
  teleporterWin_Main_Control.DelvesTexture:SetTexture(BMU_textures.delvesBtn)
  teleporterWin_Main_Control.DelvesTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.DelvesTexture:SetDrawLayer(2)

  teleporterWin_Main_Control.DelvesTexture:SetHandler("OnMouseUp", function(self, button)
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show context menu
		ClearMenu()
		-- show all or only in current zone
		local menuIndex = AddCustomMenuItem(GetString(SI_GAMEPAD_GUILD_HISTORY_SUBCATEGORY_ALL), function() BMU.savedVarsChar.showAllDelves = not BMU.savedVarsChar.showAllDelves BMU.createTable({index=BMU.indexListDelves}) end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.showAllDelves then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)
		
		-- make default tab
		menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListDelves then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListDelves end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.defaultTab == BMU.indexListDelves then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end
		ShowMenu()
	else
		BMU.createTable({index=BMU.indexListDelves})
	end
  end)
  
  teleporterWin_Main_Control.DelvesTexture:SetHandler("OnMouseEnter", function(self)
	local text = GetString(SI_ZONECOMPLETIONTYPE5)
	if not BMU.savedVarsChar.showAllDelves then
		text = text .. " - " .. GetString(SI_ANTIQUITY_SCRYABLE_CURRENT_ZONE_SUBCATEGORY)
	end
	BMU:tooltipTextEnter(teleporterWin_Main_Control.DelvesTexture,
		text .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin_Main_Control.DelvesTexture:SetTexture(BMU_textures.delvesBtnOver)
  end)

  teleporterWin_Main_Control.DelvesTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.DelvesTexture)
	if BMU.state ~= BMU.indexListDelves then
		teleporterWin_Main_Control.DelvesTexture:SetTexture(BMU_textures.delvesBtn)
	end
  end)
  
  
    ---------------------------------------------------------------------------------------------------------------
  -- DUNGEON FINDER
  
  teleporterWin_Main_Control.DungeonTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.DungeonTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.DungeonTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, 0*scale, 40*scale)
  teleporterWin_Main_Control.DungeonTexture:SetTexture(BMU_textures.soloArenaBtn)
  teleporterWin_Main_Control.DungeonTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.DungeonTexture:SetDrawLayer(2)

  teleporterWin_Main_Control.DungeonTexture:SetHandler("OnMouseUp", function(self, button)
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show filter menu
		ClearMenu()
		-- add filters
		AddCustomSubMenuItem(GetString(SI_GAMEPAD_BANK_FILTER_HEADER),
			{
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_ENDLESS_DUNGEONS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showEndlessDungeons = not BMU.savedVarsChar.dungeonFinder.showEndlessDungeons BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showEndlessDungeons end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_ARENAS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showArenas = not BMU.savedVarsChar.dungeonFinder.showArenas BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showArenas end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_GROUP_ARENAS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showGroupArenas = not BMU.savedVarsChar.dungeonFinder.showGroupArenas BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showGroupArenas end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_TRIALS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showTrials = not BMU.savedVarsChar.dungeonFinder.showTrials BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showTrials end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_GROUP_DUNGEONS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showDungeons = not BMU.savedVarsChar.dungeonFinder.showDungeons BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showDungeons end,
				},
			}, nil, nil, nil, 5
		)

		-- sorting (release or acronym)
		-- checkbox does not rely behave like a toogle in this case, enforce 3 possible statuses
		AddCustomSubMenuItem(GetString(SI_GAMEPAD_SORT_OPTION),
			{
				-- sort by release: from old (top of list) to new
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_SORT_RELEASE) .. BMU_textures.arrowUp,
					callback = function()
						BMU.savedVarsChar.dungeonFinder.sortByReleaseASC = true
						BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC = false
						BMU.savedVarsChar.dungeonFinder.sortByAcronym = false
						BMU_clearInputFields()
						BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.sortByReleaseASC end,
				},
				-- sort by release: from new (top of list) to old
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_SORT_RELEASE) .. BMU_textures.arrowDown,
					callback = function()
						BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC = true
						BMU.savedVarsChar.dungeonFinder.sortByReleaseASC = false
						BMU.savedVarsChar.dungeonFinder.sortByAcronym = false
						BMU_clearInputFields()
						BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC end,
				},
				-- sort by acronym
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_SORT_ACRONYM),
					callback = function()
						BMU.savedVarsChar.dungeonFinder.sortByAcronym = true
						BMU.savedVarsChar.dungeonFinder.sortByReleaseASC = false
						BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC = false
						BMU_clearInputFields()
						BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.sortByAcronym end,
				},
			}, nil, nil, nil, 5
		)

		-- display options (update name or acronym) (dungeon name or zone name)
		AddCustomSubMenuItem(GetString(SI_GRAPHICS_OPTIONS_VIDEO_CATEGORY_DISPLAY),
			{
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_UPDATE_NAME),
					callback = function() BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName = not BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName BMU_clearInputFields() BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return not BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_ACRONYM),
					callback = function() BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName = not BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName BMU_clearInputFields() BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName end,
				},
				{
					label = "-",
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOOGLE_DUNGEON_NAME),
					callback = function() BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName = not BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName BMU_clearInputFields() BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return not BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOOGLE_ZONE_NAME),
					callback = function() BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName = not BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName BMU_clearInputFields() BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName end,
				},
			}, nil, nil, nil, 5
		)
			
		-- add dungeon difficulty toggle
		if CanPlayerChangeGroupDifficulty() then
			local menuIndex = AddCustomMenuItem(BMU_textures.dungeonDifficultyVeteran .. GetString(SI_DUNGEONDIFFICULTY2), function() BMU.setDungeonDifficulty(not ZO_ConvertToIsVeteranDifficulty(ZO_GetEffectiveDungeonDifficulty())) zo_callLater(function() BMU.createTableDungeons() end, 300) end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
			if ZO_ConvertToIsVeteranDifficulty(ZO_GetEffectiveDungeonDifficulty()) then
				zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
			end
		end

		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)

		-- make default tab
		local menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListDungeons then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListDungeons end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.defaultTab == BMU.indexListDungeons then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		ShowMenu()
	else
		BMU_clearInputFields()
		BMU.createTableDungeons()
	end
  end)
  
  teleporterWin_Main_Control.DungeonTexture:SetHandler("OnMouseEnter", function(self)
	BMU:tooltipTextEnter(teleporterWin_Main_Control.DungeonTexture,
		BMU_SI_get(SI.TELE_UI_BTN_DUNGEON_FINDER) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin_Main_Control.DungeonTexture:SetTexture(BMU_textures.soloArenaBtnOver)
  end)

  teleporterWin_Main_Control.DungeonTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.DungeonTexture)
	if BMU.state ~= BMU.indexListDungeons then
		teleporterWin_Main_Control.DungeonTexture:SetTexture(BMU_textures.soloArenaBtn)
	end
  end)
	  
end


function BMU.updateCheckboxSurveyMap(action)
	if action == 3 then
		-- check if at least one of the subTypes is checked
		if BMU.numOfSurveyTypesChecked() > 0 then
			zo_CheckButton_SetChecked(zo_Menu.items[BMU.menuIndexSurveyAll].checkbox)
		else
			-- no survey type is checked
			ZO_CheckButton_SetUnchecked(zo_Menu.items[BMU.menuIndexSurveyAll].checkbox)
		end
	else
		-- if action == 1 --> all are checked
		-- else (action == 2) --> all are unchecked
		for _, subType in pairs({'alchemist', 'enchanter', 'woodworker', 'blacksmith', 'clothier', 'jewelry'}) do
			BMU.savedVarsChar.displayMaps[subType] = (action == 1)
		end
	end
	BMU_updateContextMenuEntrySurveyAll = BMU_updateContextMenuEntrySurveyAll or BMU.updateContextMenuEntrySurveyAll --INS251229 Baertram
    BMU_updateContextMenuEntrySurveyAll() --CHG251229 Baertram
end


function BMU.numOfSurveyTypesChecked()
	local num = 0
	for _, subType in pairs({'alchemist', 'enchanter', 'woodworker', 'blacksmith', 'clothier', 'jewelry'}) do
		if BMU.savedVarsChar.displayMaps[subType] then
			num = num + 1
		end
	end
	return num
end
BMU_numOfSurveyTypesChecked = BMU.numOfSurveyTypesChecked --INS251229 Baertram


function BMU.updateContextMenuEntrySurveyAll()
	BMU_getContextMenuEntrySurveyAllAppendix = BMU_getContextMenuEntrySurveyAllAppendix or BMU.getContextMenuEntrySurveyAllAppendix --INS251229 Baertram
    local num = BMU_numOfSurveyTypesChecked()
	local baseString = string.sub(zo_Menu.items[BMU.menuIndexSurveyAll].item.nameLabel:GetText(), 1, -7)
	zo_Menu.items[BMU.menuIndexSurveyAll].item.nameLabel:SetText(baseString .. BMU_getContextMenuEntrySurveyAllAppendix()) --CHG251229 Baertram
end
BMU_updateContextMenuEntrySurveyAll = BMU.updateContextMenuEntrySurveyAll


function BMU.getContextMenuEntrySurveyAllAppendix()
	local num = BMU_numOfSurveyTypesChecked()
	local appendix = " (" .. num .. "/6)"
	return appendix
end
BMU_getContextMenuEntrySurveyAllAppendix = BMU.getContextMenuEntrySurveyAllAppendix --INS251229 Baertram


function BMU.updatePosition()
    local teleporterWin     = BMU.win
	if SCENE_MANAGER:IsShowing("worldMap") then
	
		-- show anchor button
		teleporterWin.anchorTexture:SetHidden(false)
		-- show swap button
		BMU.closeBtnSwitchTexture(true)
		
		if BMU.savedVarsAcc.anchorOnMap then
			-- anchor to map
			BMU.control_global.bd:ClearAnchors()
			--BMU.control_global.bd:SetAnchor(TOPLEFT, ZO_WorldMap, TOPLEFT, BMU.savedVarsAcc.anchorMap_x, BMU.savedVarsAcc.anchorMap_y)
			BMU.control_global.bd:SetAnchor(TOPRIGHT, ZO_WorldMap, TOPLEFT, BMU.savedVarsAcc.anchorMapOffset_x, (-70*BMU.savedVarsAcc.Scale) + BMU.savedVarsAcc.anchorMapOffset_y)
			-- fix position
			BMU.control_global.bd:SetMovable(false)
			-- hide fix/unfix button
			teleporterWin.fixWindowTexture:SetHidden(true)
			-- set anchor button texture
			teleporterWin.anchorTexture:SetTexture(BMU_textures.anchorMapBtnOver)
		else
			-- use saved pos when map is open
			BMU.control_global.bd:ClearAnchors()
			BMU.control_global.bd:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LEFT + BMU.savedVarsAcc.pos_MapScene_x, BMU.savedVarsAcc.pos_MapScene_y)
			-- set fix/unfix state
			BMU.control_global.bd:SetMovable(not BMU.savedVarsAcc.fixedWindow)
			-- show fix/unfix button
			teleporterWin.fixWindowTexture:SetHidden(false)
			-- set anchor button texture
			teleporterWin.anchorTexture:SetTexture(BMU_textures.anchorMapBtn)
		end
	else
		-- hide anchor button
		teleporterWin.anchorTexture:SetHidden(true)
		-- hide swap button
		BMU.closeBtnSwitchTexture(false)
		
		-- use saved pos when map is NOT open
		BMU.control_global.bd:ClearAnchors()
		BMU.control_global.bd:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LEFT + BMU.savedVarsAcc.pos_x, BMU.savedVarsAcc.pos_y)
		-- set fix/unfix state
		BMU.control_global.bd:SetMovable(not BMU.savedVarsAcc.fixedWindow)
		-- show fix/unfix button
		teleporterWin.fixWindowTexture:SetHidden(false)
	end
end


function BMU.closeBtnSwitchTexture(flag)
    local teleporterWin     = BMU.win
	if flag then
		-- show swap button
		-- set texture and handlers
		teleporterWin.closeTexture:SetTexture(BMU_textures.swapBtn)
		teleporterWin.closeTexture:SetHandler("OnMouseEnter", function(self)
			teleporterWin.closeTexture:SetTexture(BMU_textures.swapBtnOver)
			BMU:tooltipTextEnter(teleporterWin.closeTexture,
				BMU_SI_get(SI.TELE_UI_BTN_TOGGLE_BMU))
		end)
		teleporterWin.closeTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin.closeTexture)
			teleporterWin.closeTexture:SetTexture(BMU_textures.swapBtn)
		end)
		
	else
		-- show normal close button
		-- set textures and handlers
		teleporterWin.closeTexture:SetTexture(BMU_textures.closeBtn)
		teleporterWin.closeTexture:SetHandler("OnMouseEnter", function(self)
		teleporterWin.closeTexture:SetTexture(BMU_textures.closeBtnOver)
			BMU:tooltipTextEnter(teleporterWin.closeTexture,
				GetString(SI_DIALOG_CLOSE))
		end)
		teleporterWin.closeTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin.closeTexture)
			teleporterWin.closeTexture:SetTexture(BMU_textures.closeBtn)
		end)
	end
end


function BMU.clearInputFields()
    local teleporterWin = BMU.win
	-- Clear Input Field Player
	teleporterWin.Searcher_Player:SetText("")
	-- Show Placeholder
	teleporterWin.Searcher_Player.Placeholder:SetHidden(false)
	-- Clear Input Field Zone
	teleporterWin.Searcher_Zone:SetText("")
	-- Show Placeholder
	teleporterWin.Searcher_Zone.Placeholder:SetHidden(false)
end
BMU_clearInputFields = BMU.clearInputFields



-- display the correct persistent MouseOver depending on Button
-- also set global state for auto refresh
function BMU.changeState(index)

	BMU.printToChat("Changed - state: " .. tostring(index), BMU.MSG_DB)
    
	local teleporterWin = BMU.win

	-- first disable all MouseOver
    local teleporterWin_Main_Control = teleporterWin.Main_Control                           --INS251229 Baertram
	teleporterWin_Main_Control.ItemTexture:SetTexture(BMU_textures.relatedItemsBtn)
	teleporterWin_Main_Control.OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtn)
	teleporterWin_Main_Control.DelvesTexture:SetTexture(BMU_textures.delvesBtn)
	teleporterWin.SearchTexture:SetTexture(BMU_textures.searchBtn)
	teleporterWin_Main_Control.QuestTexture:SetTexture(BMU_textures.questBtn)
	teleporterWin_Main_Control.OwnHouseTexture:SetTexture(BMU_textures.houseBtn)
	teleporterWin_Main_Control.PTFTexture:SetTexture(BMU_textures.ptfHouseBtn)
	teleporterWin_Main_Control.DungeonTexture:SetTexture(BMU_textures.soloArenaBtn)
	local teleporterWin_guildTexture = teleporterWin.guildTexture
    if teleporterWin_guildTexture then                                                      --INS251229 Baertram
		teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtn)                        --INS251229 Baertram
	end
	-- hide counter panel for related items tab
	BMU.counterPanel:SetHidden(true)
	
	teleporterWin.Searcher_Player:SetHidden(false)

	-- check new state
	if index == BMU.indexListItems then
		-- related Items
		teleporterWin_Main_Control.ItemTexture:SetTexture(BMU_textures.relatedItemsBtnOver)
		if BMU.savedVarsChar.displayCounterPanel then
			BMU.counterPanel:SetHidden(false)
		end
	elseif index == BMU.indexListCurrentZone then
		-- current zone
		teleporterWin_Main_Control.OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtnOver)
	elseif index == BMU.indexListDelves then
		-- current zone delves
		teleporterWin_Main_Control.DelvesTexture:SetTexture(BMU_textures.delvesBtnOver)
	elseif index == BMU.indexListSearchPlayer or index == BMU.indexListSearchZone then
		-- serach by player name or zone name
		teleporterWin.SearchTexture:SetTexture(BMU_textures.searchBtnOver)
	elseif index == BMU.indexListQuests then
		-- related quests
		teleporterWin_Main_Control.QuestTexture:SetTexture(BMU_textures.questBtnOver)
	elseif index == BMU.indexListOwnHouses then
		-- own houses
		teleporterWin_Main_Control.OwnHouseTexture:SetTexture(BMU_textures.houseBtnOver)
	elseif index == BMU.indexListPTFHouses then
		-- PTF houses
		teleporterWin_Main_Control.PTFTexture:SetTexture(BMU_textures.ptfHouseBtnOver)
	elseif index == BMU.indexListGuilds then
		-- guilds
		if teleporterWin_guildTexture then
			teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtnOver)
		end
	elseif index == BMU.indexListDungeons then
		-- dungeon finder
		teleporterWin_Main_Control.DungeonTexture:SetTexture(BMU_textures.soloArenaBtnOver)
		teleporterWin.Searcher_Player:SetHidden(true)
	end
	
	BMU.state = index
end


------------------------

-- register and show basic dialogs
function BMU.showDialogSimple(dialogName, dialogTitle, dialogBody, callbackYes, callbackNo)
	local dialogInfo = {
		canQueue = true,
		title = {text=dialogTitle},
		mainText = {align=TEXT_ALIGN_LEFT, text=dialogBody},
	}
	
	if callbackYes or callbackNo then
		dialogInfo.buttons = {
			{
				text = SI_DIALOG_CONFIRM,
				keybind = "DIALOG_PRIMARY",
				callback = callbackYes,
			},
			{
				text = SI_DIALOG_CANCEL,
				keybind = "DIALOG_NEGATIVE",
				callback = callbackNo,
			},
		}
	else
		-- show only one button if both callbacks are nil
		dialogInfo.buttons = {
			{
				text = SI_DIALOG_CLOSE,
				keybind = "DIALOG_NEGATIVE",
			},
		}
	end
	
	return BMU.showDialogCustom(dialogName, dialogInfo)
end


-- register and show custom dialogs with given dialogInfo
function BMU.showDialogCustom(dialogName, dialogInfoObject)
	local dialogInfo = dialogInfoObject
	
	-- register dialog globally
	local globalDialogName = BMU.var.appName .. dialogName
	
	ESO_Dialogs[globalDialogName] = dialogInfo
	local dialogReference = ZO_Dialogs_ShowDialog(globalDialogName)
	
	return globalDialogName, dialogReference
end

------------------------


function BMU.TeleporterSetupUI(addOnName)
	if appName ~= addOnName then return end
		addOnName = appName .. " - Teleporter"
		SetupOptionsMenu(addOnName)
		SetupUI()
end


function BMU.journalUpdated()
	BMU.questDataChanged = true
end


-- HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_COLLECTIBLE
-- HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_ITEM
-- HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_COLLECTIBLE
-- HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM

-- update own houses furniture count
function BMU.updateHouseFurnitureCount(eventCode, option1, option2)
	-- the player entered a new zone or event furniture count updated
	local houseId = GetCurrentZoneHouseId()
	if houseId ~= nil and IsOwnerOfCurrentHouse() then
		-- player is in an own house
		if eventCode == EVENT_HOUSE_FURNITURE_COUNT_UPDATED and option1 ~= houseId then
			-- abort if furniture count was updated but different house
			return
		end

		local currentFurnitureCount_LII = GetNumHouseFurnishingsPlaced(HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM)
		if currentFurnitureCount_LII ~= nil then
			-- save value to savedVars
			BMU.savedVarsServ.houseFurnitureCount_LII[houseId] = currentFurnitureCount_LII
		end
	end
end


-- handles event when player clicks on a chat link
	-- 1. for sharing teleport destination to the group (built-in type with drive-by data)
	-- 2. for wayshrine map ping (custom link)
function BMU.handleChatLinkClick(rawLink, mouseButton, linkText, linkStyle, linkType, data1, data2, data3, data4) -- can contain more data fields
	local number_to_bool ={ [0]=false, [1]=true }
	-- sharing
	if linkType == "book" then
		local bookId = data1
		local signature = tostring(data2)
		
		-- sharing player
		if signature == "BMU_S_P" then
			local playerFrom = tostring(data3)
			local playerTo = tostring(data4)
			if playerFrom ~= nil and playerTo ~= nil then
				-- try to find the destination player
				local result = BMU.createTable({index=BMU.indexListSearchPlayer, inputString=playerTo, dontDisplay=true})
				local firstRecord = result[1]
				if firstRecord.displayName == "" then
					-- player not found
					BMU.printToChat(playerTo .. " - " .. GetString(SI_FASTTRAVELKEEPRESULT9))
				else
					BMU.printToChat(BMU_SI_get(SI.TELE_CHAT_SHARING_FOLLOW_LINK), BMU.MSG_AD)
					BMU.PortalToPlayer(firstRecord.displayName, firstRecord.sourceIndexLeading, firstRecord.zoneName, firstRecord.zoneId, firstRecord.category, true, false, true)
				end
				return true
			end
			
		-- sharing house
		elseif signature == "BMU_S_H" then
			local player = tostring(data3)
			local houseId = tonumber(data4)
			if player ~= nil and houseId ~= nil then
				-- try to port to the house of the player
				BMU.printToChat(BMU_SI_get(SI.TELE_CHAT_SHARING_FOLLOW_LINK), BMU.MSG_AD)
				CancelCast()
				JumpToSpecificHouse(player, houseId)
			end
			return true
		end
	
	
	-- custom link (wayshrine map ping)
	elseif linkType == "BMU" then
		local signature = tostring(data1)
		local mapIndex = tonumber(data2)
		local coorX = tonumber(data3)
		local coorY = tonumber(data4)
		
		-- check if link is for map pings
		if signature == "BMU_P" and mapIndex ~= nil and coorX ~= nil and coorY ~= nil then
			-- valid map ping
			-- switch to Tamriel and back to specific map in order to reset any subzone or zoom
			WORLD_MAP_MANAGER:SetMapByIndex(1)
			WORLD_MAP_MANAGER:SetMapByIndex(mapIndex)
			-- start ping
			if not SCENE_MANAGER:IsShowing("worldMap") then SCENE_MANAGER:Show("worldMap") end
			PingMap(MAP_PIN_TYPE_RALLY_POINT, MAP_TYPE_LOCATION_CENTERED, coorX, coorY)
		end
		
		-- return true in any case because not handled custom link leads to UI error
		return true
	end
end


-- click on guild button
function BMU.redirectToBMUGuild()
	for _, guildId in pairs(BMU.var.BMUGuilds[worldName]) do
		local guildData = GUILD_BROWSER_MANAGER:GetGuildData(guildId)
		if guildId and guildData and guildData.size and guildData.size < 495 then
			ZO_LinkHandler_OnLinkClicked("|H1:guild:" .. guildId .. "|hBeamMeUp Guild|h", 1, nil)
			return
		end
	end
	-- just redirect to latest BMU guild
	ZO_LinkHandler_OnLinkClicked("|H1:guild:" .. BMU.var.BMUGuilds[worldName][#BMU.var.BMUGuilds[worldName]] .. "|hBeamMeUp Guild|h", 1, nil)
end


-------------------------------------------------------------------
-- EXTRAS
-------------------------------------------------------------------

-- Show Notification when favorite player goes online
function BMU.FavoritePlayerStatusNotification(eventCode, option1, option2, option3, option4, option5) --GUILD:(eventCode, guildID, displayName, prevStatus, curStatus) FRIEND:(eventCode, displayName, characterName, prevStatus, curStatus)
	local displayName = ""
	local prevStatus = option3
	local curStatus = option4
	
	-- in case of EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED first option is guildID instead of displayName
	if eventCode == EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED then
		-- EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED
		displayName = option2
	else
		-- EVENT_FRIEND_PLAYER_STATUS_CHANGED
		displayName = option1
	end
	
	if BMU.savedVarsAcc.FavoritePlayerStatusNotification and BMU.isFavoritePlayer(displayName) and prevStatus == 4 and curStatus ~= 4 then
		CENTER_SCREEN_ANNOUNCE:AddMessage(0, CSA_CATEGORY_MAJOR_TEXT, SOUNDS.DEFER_NOTIFICATION, "Favorite Player Switched Status", BMU_colorizeText(displayName, "gold") .. " " .. BMU_colorizeText(BMU_SI_get(SI.TELE_CENTERSCREEN_FAVORITE_PLAYER_ONLINE), "white"), "esoui/art/mainmenu/menubar_social_up.dds", "EsoUI/Art/Achievements/achievements_iconBG.dds", nil, nil, 4000)
	end
end

--[[
-- Show Note, when player sends a whisper message and is offline -> player cannot receive any whisper messages
function BMU.HintOfflineWhisper(eventCode, messageType, from, test, isFromCustomerService, _)
	if BMU.savedVarsAcc.HintOfflineWhisper and messageType == CHAT_CHANNEL_WHISPER_SENT and GetPlayerStatus() == PLAYER_STATUS_OFFLINE then
		BMU.printToChat(BMU_colorizeText(BMU_SI_get(SI.TELE_CHAT_WHISPER_NOTE), "red"))
	end
end
--]]

function BMU.surveyMapUsed(bagId, slotIndex, slotData)
	if bagId ~= nil and slotData ~= nil then
		if bagId == BAG_BACKPACK and slotData.specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT and not IsBankOpen() then
			-- d("Item Name: " .. BMU.formatName(slotData.rawName, false))
			-- d("Anzahl übrig: " .. slotData.stackCount - 1)
			if slotData.stackCount > 1 then
				-- still more available -> Show center screen message
				local sound = nil
				if BMU.savedVarsAcc.surveyMapsNotificationSound then
					-- set sound
					sound = SOUNDS.GUILD_WINDOW_OPEN  -- SOUNDS.DUEL_START
				end
				zo_callLater(function()
					CENTER_SCREEN_ANNOUNCE:AddMessage(0, CSA_CATEGORY_MAJOR_TEXT, sound, "Survey Maps Note", string.format(BMU_SI_get(SI.TELE_CENTERSCREEN_SURVEY_MAPS), slotData.stackCount-1), "esoui/art/icons/quest_scroll_001.dds", "EsoUI/Art/Achievements/achievements_iconBG.dds", nil, nil, 5000)
				end, 12000)
			end
		end
	end
end


function BMU.activateWayshrineTravelAutoConfirm()
		ESO_Dialogs["RECALL_CONFIRM"]={
			gamepadInfo={dialogType=GAMEPAD_DIALOGS.BASIC},
			title={text=SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM},
			mainText={text=SI_FAST_TRAVEL_DIALOG_MAIN_TEXT},
			updateFn=function(dialog)
					FastTravelToNode(dialog.data.nodeIndex)
					SCENE_MANAGER:ShowBaseScene()
					ZO_Dialogs_ReleaseDialog("RECALL_CONFIRM")
			end
		}
		ESO_Dialogs["FAST_TRAVEL_CONFIRM"]={
			gamepadInfo={dialogType=GAMEPAD_DIALOGS.BASIC},
			title={text=SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM},
			mainText={text=SI_FAST_TRAVEL_DIALOG_MAIN_TEXT},
			updateFn=function(dialog)
					FastTravelToNode(dialog.data.nodeIndex)
					ZO_Dialogs_ReleaseDialog("FAST_TRAVEL_CONFIRM")
			end
		}
end


--Request all BMU and partner guilds information
function BMU.requestGuildData()
	BMU.isCurrentlyRequestingGuildData = true
	local guildsQueue = {}
	-- official guilds
	if BMU.var.BMUGuilds[worldName] ~= nil then
		guildsQueue = BMU.var.BMUGuilds[worldName]
	end
	-- partner guilds
	if BMU.var.partnerGuilds[worldName] ~= nil then
		guildsQueue = BMU.mergeTables(guildsQueue, BMU.var.partnerGuilds[worldName])
	end

	BMU.requestGuildDataRecursive(guildsQueue)
end

-- request all guilds in queue
function BMU.requestGuildDataRecursive(guildIds)
	if #guildIds > 0 then
		GUILD_BROWSER_MANAGER:RequestGuildData(table.remove(guildIds))
		zo_callLater(function() BMU.requestGuildDataRecursive(guildIds) end, 800)
	else
		BMU.isCurrentlyRequestingGuildData = false
	end
end


--------------------------------------------------
-- GUILD ADMINISTRATION TOOL
--------------------------------------------------

function BMU.AdminAddContextMenuToGuildRoster()
	-- add context menu to guild roster
	local GuildRosterRow_OnMouseUp = GUILD_ROSTER_KEYBOARD.GuildRosterRow_OnMouseUp --ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseUp
	GUILD_ROSTER_KEYBOARD.GuildRosterRow_OnMouseUp = function(self, control, button, upInside)

		local data = ZO_ScrollList_GetData(control)
		GuildRosterRow_OnMouseUp(self, control, button, upInside)
		
		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		if (button ~= MOUSE_BUTTON_INDEX_RIGHT --[[and not upInside]]) or data == nil or not BMU.AdminIsBMUGuild(currentGuildId) then
			return
		end
		
		local isAlreadyMember, memberStatusText = BMU.AdminIsAlreadyInGuild(data.displayName)
		
		local entries = {}
		
		-- welcome message
		table.insert(entries, {label = "Willkommensnachricht",
								callback = function(state)
									local guildId = currentGuildId
									local guildIndex = BMU.AdminGetGuildIndexFromGuildId(guildId)
									StartChatInput("Welcome on the bridge " .. data.displayName, _G["CHAT_CHANNEL_GUILD_" .. guildIndex])
								end,
								})
								
		-- new message
		table.insert(entries, {label = "Neue Nachricht",
								callback = function(state) BMU.createMail(data.displayName, "", "") BMU.printToChat("Nachricht erstellt an: " .. data.displayName) end,
								})
								
		-- copy account name
		table.insert(entries, {label = "Account-ID kopieren",
								callback = function(state) BMU.AdminCopyTextToChat(data.displayName) end,
								})
		
		-- invite to BMU guilds
		if BMU.var.BMUGuilds[worldName] ~= nil then
			for _, guildId in pairs(BMU.var.BMUGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.displayName) then
					table.insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.displayName) end,
											})
				end
			end
		end
		
		-- invite to partner guilds
		if BMU.var.partnerGuilds[worldName] ~= nil then
			for _, guildId in pairs(BMU.var.partnerGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.displayName) then
					table.insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.displayName) end,
											})
				end
			end
		end
		
		-- check if the player is also in other BMU guilds and add info
		table.insert(entries, {label = memberStatusText,
								callback = function(state) end,
								})
		
		AddCustomSubMenuItem("BMU Admin", entries)
		self:ShowMenu(control)
	end
end


function BMU.AdminAddContextMenuToGuildApplicationRoster()
	-- add context menu to guild recruitment application roster (if player is already in a one of the BMU guilds + redirection to the other guilds)
	local Row_OnMouseUp = ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseUp
	ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseUp = function(self, control, button, upInside)

		local data = ZO_ScrollList_GetData(control)
		Row_OnMouseUp(self, control, button, upInside)
	
		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		if (button ~= MOUSE_BUTTON_INDEX_RIGHT --[[and not upInside]]) or data == nil or not BMU.AdminIsBMUGuild(currentGuildId) then
			return
		end
		
		local isAlreadyMember, memberStatusText = BMU.AdminIsAlreadyInGuild(data.name)

		local entries = {}
		
		-- new message
		table.insert(entries, {label = "Neue Nachricht",
								callback = function(state) BMU.createMail(data.name, "", "") BMU.printToChat("Nachricht erstellt an: " .. data.name) end,
								})
								
		-- copy account name
		table.insert(entries, {label = "Account-ID kopieren",
								callback = function(state) BMU.AdminCopyTextToChat(data.name) end,
								})
		
		-- invite to BMU guilds
		if BMU.var.BMUGuilds[worldName] ~= nil then
			for _, guildId in pairs(BMU.var.BMUGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.name) then
					table.insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.name) end,
											})
				end
			end
		end
		
		-- invite to partner guilds
		if BMU.var.partnerGuilds[worldName] ~= nil then
			for _, guildId in pairs(BMU.var.partnerGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.name) then
					table.insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.name) end,
											})
				end
			end
		end
		
		-- check if the player is also in other BMU guilds and add info
		table.insert(entries, {label = memberStatusText,
								callback = function(state) end,
								})
		
		AddCustomSubMenuItem("BMU Admin", entries)
		self:ShowMenu(control)
	end
end

function BMU.AdminAddTooltipInfoToGuildApplicationRoster()
	-- add info to the tooltip in guild recruitment application roster
	local Row_OnMouseEnter = ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseEnter
	ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseEnter = function(self, control)
		
		local data = ZO_ScrollList_GetData(control)
		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		
		if data ~= nil and not data.BMUInfo and BMU.AdminIsBMUGuild(currentGuildId) then
			local isAlreadyMember, memberStatusText = BMU.AdminIsAlreadyInGuild(data.name)
			data.message = data.message .. "\n\n" .. memberStatusText
			data.BMUInfo = true
		end
	
		Row_OnMouseEnter(self, control)		
	end
end

function BMU.AdminGetGuildIndexFromGuildId(guildId)
	for i = 1, GetNumGuilds() do
		if GetGuildId(i) == guildId then
			return i
		end
	end
	return 0
end

function BMU.AdminCopyTextToChat(message)
	-- Max of input box is 351 chars
	if string.len(message) < 351 then
		if CHAT_SYSTEM.textEntry:GetText() == "" then
			CHAT_SYSTEM.textEntry:Open(message)
			ZO_ChatWindowTextEntryEditBox:SelectAll()
		end
	end
end

function BMU.AdminAutoWelcome(eventCode, guildId, displayName, result)
	-- only for BMU guilds
	if not BMU.AdminIsBMUGuild(guildId) then
		return
	end
	
	zo_callLater(function()
		if result == 0 then
			local guildIndex = BMU.AdminGetGuildIndexFromGuildId(guildId)
			local totalGuildMembers = GetNumGuildMembers(guildId)
			
			-- find new guild member
			for j = 0, totalGuildMembers do
				local displayName_info, note, guildMemberRankIndex, status, secsSinceLogoff = GetGuildMemberInfo(guildId, j)
				if displayName_info == displayName and status ~= PLAYER_STATUS_OFFLINE then
					-- new guild member is online -> write welcome message to chat
					StartChatInput("Welcome on the bridge " .. displayName, _G["CHAT_CHANNEL_GUILD_" .. guildIndex])
				end
			end
		end
	end, 1300)
end

function BMU.AdminIsAlreadyInGuild(displayName)
	local text = ""
	
	if GetGuildMemberIndexFromDisplayName(BMU.var.BMUGuilds[worldName][1], displayName) then
		text = text .. " 1 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU.var.BMUGuilds[worldName][2], displayName) then
		text = text .. " 2 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU.var.BMUGuilds[worldName][3], displayName) then
		text = text .. " 3 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU.var.BMUGuilds[worldName][4], displayName) then
		text = text .. " 4 "
	end
	
	if text ~= "" then
		-- already member
		return true, BMU_colorizeText("Bereits Mitglied in " .. text, "red")
	else
		-- not a member or admin is not member of the BMU guilds
		return false, BMU_colorizeText("Neues Mitglied", "green")
	end
end

function BMU.AdminIsBMUGuild(guildId)
	if BMU.has_value(BMU.var.BMUGuilds[worldName], guildId) then
		return true
	else
		return false
	end
end

function BMU.AdminInviteToGuilds(guildId, displayName)
	-- add tuple to queue
	table.insert(inviteQueue, {guildId, displayName})
	if #inviteQueue == 1 then
		BMU.AdminInviteToGuildsQueue()
	end
end

function BMU.AdminInviteToGuildsQueue()
	if #inviteQueue > 0 then
		-- get first element and send invite
		local first = inviteQueue[1]
		GuildInvite(first[1], first[2])
		PlaySound(SOUNDS.BOOK_OPEN)
		-- restart to check for other elements
		zo_callLater(function() table.remove(inviteQueue, 1) BMU.AdminInviteToGuildsQueue() end, 16000)
	end		
end

function BMU.AdminAddAutoFillToDeclineApplicationDialog()
	local font = string.format("%s|$(KB_%s)|%s", ZoFontGame:GetFontInfo(), 21, "soft-shadow-thin")
	-- default message
	local autoFill_1 = WINDOW_MANAGER:CreateControl(nil, ZO_ConfirmDeclineApplicationDialog_Keyboard, CT_LABEL)
	autoFill_1:SetAnchor(TOPRIGHT, ZO_ConfirmDeclineApplicationDialog_Keyboard, TOPRIGHT, -5, 10)
	autoFill_1:SetFont(font)
	autoFill_1:SetText(BMU_colorizeText("BMU_AM", "gold"))
	autoFill_1:SetMouseEnabled(true)
	autoFill_1:SetHandler("OnMouseUp", function(self)
		ZO_ConfirmDeclineApplicationDialog_KeyboardDeclineMessageEdit:SetText("You are already a member of one of our other BMU guilds. Sorry, but we only allow joining one guild. You are welcome to join and support our partner guilds (flag button in the upper left corner).")
	end)
	-- message when player is already in 5 guilds
	local autoFill_2 = WINDOW_MANAGER:CreateControl(nil, ZO_ConfirmDeclineApplicationDialog_Keyboard, CT_LABEL)
	autoFill_2:SetAnchor(TOPRIGHT, ZO_ConfirmDeclineApplicationDialog_Keyboard, TOPRIGHT, -5, 40)
	autoFill_2:SetFont(font)
	autoFill_2:SetText(BMU_colorizeText("BMU_5G", "gold"))
	autoFill_2:SetMouseEnabled(true)
	autoFill_2:SetHandler("OnMouseUp", function(self)
		ZO_ConfirmDeclineApplicationDialog_KeyboardDeclineMessageEdit:SetText("We cannot accpect your application because you have already joined 5 other guilds (which is the maximum). If you want to join us, please submit a new application with free guild slot.")
	end)
end

