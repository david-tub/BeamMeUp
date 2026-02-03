local BMU = BMU --INS251229 Baertram Performancee gain, not searching _G for BMU each time again!

local LAM2 = BMU.LAM
local SI = BMU.SI ---- used for localization

local teleporterVars    = BMU.var
local appName           = teleporterVars.appName

-- -v- INS251229 Baertram BEGIN 0
--Performance reference
----variables (defined now, as they were loaded before this file -> see manifest .txt)
--ZOs variables
local tos                                   = tostring
local select                                = select
local zo_ChatWindow                         = ZO_ChatWindow
--Other addon variables
--BMU variables
local BMU_textures                          = BMU.textures
----functions
--ZOs functions
--BMU functions
local BMU_SI_Get                            = SI.get
local BMU_colorizeText                      = BMU.colorizeText

----variables (defined inline in code below, upon first usage, as they are still nil at this line)
----functions (defined inline in code below, upon first usage, as they are still nil at this line)
local BMU_getIndexFromValue, BMU_formatName, BMU_getStringIsInstalledLibrary
-- -^- INS251229 Baertram END 0


--LAM settings menu
local function SetupOptionsMenu(addonName) --index == Addon name                        --CHG251229 Baertram renamed because index is also used in the loop at line 78 and within several setFunc/getFunc of some entries below and the variable is shadowed then
    -- -v- INS251229 Baertram performance improvement for multiple used variable reference
    local BMU_DefaultsPerCharacter = BMU.DefaultsCharacter
    local BMU_DefaultsPerAccount   = BMU.DefaultsAccount
    BMU_getIndexFromValue = BMU_getIndexFromValue or BMU.getIndexFromValue
    BMU_formatName = BMU_formatName or BMU.formatName
    BMU_getStringIsInstalledLibrary = BMU_getStringIsInstalledLibrary or BMU.getStringIsInstalledLibrary

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
			mostPortedZonesText = mostPortedZonesText .. BMU_formatName(GetZoneNameById(portCounterPerZoneSorted[i]["zoneId"])) .. " (" .. portCounterPerZoneSorted[i]["count"] .. ")\n"
		end
	end

    local optionsData = {
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_ADDON_EXT_DESC),
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
              title = "Port To Friend\'s House",
			  text = BMU_getStringIsInstalledLibrary("ptf"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = BMU_SI_Get(SI_TELE_ADDON_EXT_OPEN_URL),
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info1758-PorttoFriendsHouse.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_ADDON_EXT_PTF_DESC),
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
			  title = "LibSets",
              text = BMU_getStringIsInstalledLibrary("libsets"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = BMU_SI_Get(SI_TELE_ADDON_EXT_OPEN_URL),
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info2241-LibSetsAllsetitemsingameexcellua.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_ADDON_EXT_LIBSETS_DESC),
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
			  title = "LibMapPing",
              text = BMU_getStringIsInstalledLibrary("libmapping"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = BMU_SI_Get(SI_TELE_ADDON_EXT_OPEN_URL),
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info1302-LibMapPing.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_ADDON_EXT_LIBMAPPING_DESC),
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
			  title = "LibSlashCommander",
              text = BMU_getStringIsInstalledLibrary("lsc"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = BMU_SI_Get(SI_TELE_ADDON_EXT_OPEN_URL),
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info1508-LibSlashCommander.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_ADDON_EXT_LIBSLASHCOMMANDER_DESC),
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
			  title = "LibChatMenuButton",
              text = BMU_getStringIsInstalledLibrary("lcmb"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = BMU_SI_Get(SI_TELE_ADDON_EXT_OPEN_URL),
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info3805-LibChatMenuButton.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_ADDON_EXT_LIBCHATMENUBTN_DESC),
			  submenu = "deps",
         },
		 {
              type = "divider",
			  submenu = "deps",
         },
	     {
              type = "description",
              title = "|cFF00FFIsJusta|r Beam Me Up Gamepad Plugin",
			  text = BMU_getStringIsInstalledLibrary("gamepad"),
			  width = "half",
			  submenu = "deps",
         },
		 {
              type = "button",
              name = BMU_SI_Get(SI_TELE_ADDON_EXT_OPEN_URL),
			  func = function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info3624-IsJustaBeamMeUpGamepadPlugin.html") end,
			  width = "half",
			  submenu = "deps",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_ADDON_EXT_IJAGBMUGP_DESC),
			  submenu = "deps",
         },
		 {
              type = "slider",
              name = BMU_SI_Get(SI_TELE_SETTINGS_NUMBER_LINES),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_NUMBER_LINES_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["numberLines"] .. "]",
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
              name = BMU_SI_Get(SI_TELE_SETTINGS_SHOW_ON_MAP_OPEN),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["ShowOnMapOpen"]) .. "]",
              getFunc = function() return BMU_SVAcc.ShowOnMapOpen end,
              setFunc = function(value) BMU_SVAcc.ShowOnMapOpen = value end,
			  default = BMU_DefaultsPerAccount["ShowOnMapOpen"],
			  submenu = "ui",
         },
         {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_HIDE_ON_MAP_CLOSE),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["HideOnMapClose"]) .. "]",
              getFunc = function() return BMU_SVAcc.HideOnMapClose end,
              setFunc = function(value) BMU_SVAcc.HideOnMapClose = value end,
			  default = BMU_DefaultsPerAccount["HideOnMapClose"],
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_CLOSE_ON_PORTING),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["closeOnPorting"]) .. "]",
              getFunc = function() return BMU_SVAcc.closeOnPorting end,
              setFunc = function(value) BMU_SVAcc.closeOnPorting = value end,
			  default = BMU_DefaultsPerAccount["closeOnPorting"],
			  submenu = "ui",
		 },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_WINDOW_STAY),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_WINDOW_STAY_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["windowStay"]) .. "]",
              getFunc = function() return BMU_SVAcc.windowStay end,
              setFunc = function(value) BMU_SVAcc.windowStay = value end,
			  default = BMU_DefaultsPerAccount["windowStay"],
			  submenu = "ui",
		 },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_FOCUS_ON_MAP_OPEN),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["focusZoneSearchOnOpening"]) .. "]",
              getFunc = function() return BMU_SVAcc.focusZoneSearchOnOpening end,
              setFunc = function(value) BMU_SVAcc.focusZoneSearchOnOpening = value end,
			  default = BMU_DefaultsPerAccount["focusZoneSearchOnOpening"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = BMU_SI_Get(SI_TELE_SETTINGS_AUTO_PORT_FREQ),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["AutoPortFreq"] .. "]",
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
              name = BMU_SI_Get(SI_TELE_SETTINGS_SHOW_BUTTON_ON_MAP),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["showOpenButtonOnMap"]) .. "]",
              requiresReload = true,
			  getFunc = function() return BMU_SVAcc.showOpenButtonOnMap end,
              setFunc = function(value) BMU_SVAcc.showOpenButtonOnMap = value end,
			  default = BMU_DefaultsPerAccount["showOpenButtonOnMap"],
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_SHOW_CHAT_BUTTON),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["chatButton"]) .. "]",
              requiresReload = true,
			  getFunc = function() return BMU_SVAcc.chatButton end,
              setFunc = function(value) BMU_SVAcc.chatButton = value end,
			  default = BMU_DefaultsPerAccount["chatButton"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = BMU_SI_Get(SI_TELE_SETTINGS_SCALE),
			  tooltip = BMU_SI_Get(SI_TELE_SETTINGS_SCALE_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["Scale"] .. "]",
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
              name = BMU_SI_Get(SI_TELE_SETTINGS_CHAT_BUTTON_OFFSET),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["chatButtonHorizontalOffset"] .. "]",
              min = 0,
              max = 200,
              getFunc = function() return BMU_SVAcc.chatButtonHorizontalOffset end,
              setFunc = function(value) BMU_SVAcc.chatButtonHorizontalOffset = value
							BMU.chatButtonTex:SetAnchor(TOPRIGHT, zo_ChatWindow, TOPRIGHT, -40 - BMU_SVAcc.chatButtonHorizontalOffset, 6)
						end,
			  default = BMU_DefaultsPerAccount["chatButtonHorizontalOffset"],
			  submenu = "ui",
			  disabled = function() return not BMU_SVAcc.chatButton or not BMU.chatButtonTex end,
         },
		 {
              type = "slider",
              name = BMU_SI_Get(SI_TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["anchorMapOffset_x"] .. "]",
			  min = -100,
              max = 100,
              getFunc = function() return BMU_SVAcc.anchorMapOffset_x end,
              setFunc = function(value) BMU_SVAcc.anchorMapOffset_x = value end,
			  default = BMU_DefaultsPerAccount["anchorMapOffset_x"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = BMU_SI_Get(SI_TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL),
			  tooltip = BMU_SI_Get(SI_TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["anchorMapOffset_y"] .. "]",
			  min = -150,
			  max = 150,
              getFunc = function() return BMU_SVAcc.anchorMapOffset_y end,
              setFunc = function(value) BMU_SVAcc.anchorMapOffset_y = value end,
			  default = BMU_DefaultsPerAccount["anchorMapOffset_y"],
			  submenu = "ui",
         },
		 {
              type = "button",
              name = BMU_SI_Get(SI_TELE_SETTINGS_RESET_UI),
			  tooltip = BMU_SI_Get(SI_TELE_SETTINGS_RESET_UI_TOOLTIP),
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
              name = BMU_SI_Get(SI_TELE_SETTINGS_AUTO_REFRESH),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_AUTO_REFRESH_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["autoRefresh"]) .. "]",
              getFunc = function() return BMU_SVAcc.autoRefresh end,
              setFunc = function(value) BMU_SVAcc.autoRefresh = value end,
			  default = BMU_DefaultsPerAccount["autoRefresh"],
			  submenu = "rec",
         },
		 {
              type = "dropdown",
              name = BMU_SI_Get(SI_TELE_SETTINGS_SORTING),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_SORTING_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownSortChoices[BMU_DefaultsPerCharacter["sorting"]] .. "]",
			  choices = BMU.dropdownSortChoices,
			  choicesValues = BMU.dropdownSortValues,
              getFunc = function() return BMU.savedVarsChar.sorting end,
			  setFunc = function(value) BMU.savedVarsChar.sorting = value end,
			  default = BMU_DefaultsPerCharacter["sorting"],
			  warning = BMU_colorizeText(BMU_SI_Get(SI_TELE_SETTINGS_INFO_CHARACTER_DEPENDING), "red"), --CHG251229 Baertram All following changed enties below are not commented anymore now!
			  submenu = "rec",
        },
		{
			type = "dropdown",
			name = BMU_SI_Get(SI_TELE_SETTINGS_DEFAULT_TAB),
			tooltip = BMU_SI_Get(SI_TELE_SETTINGS_DEFAULT_TAB_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownDefaultTabChoices[BMU_getIndexFromValue(BMU.dropdownDefaultTabValues, BMU_DefaultsPerCharacter["defaultTab"])] .. "]",
			choices = BMU.dropdownDefaultTabChoices,
			choicesValues = BMU.dropdownDefaultTabValues,
			getFunc = function() return BMU.savedVarsChar.defaultTab end,
			setFunc = function(value) BMU.savedVarsChar.defaultTab = value end,
			default = BMU_DefaultsPerCharacter["defaultTab"],
			warning = BMU_colorizeText(BMU_SI_Get(SI_TELE_SETTINGS_INFO_CHARACTER_DEPENDING), "red"),
			disabled = function() return not BMU_SVAcc.autoRefresh end,
			submenu = "rec",
		 },
         {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_SHOW_NUMBER_PLAYERS),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["showNumberPlayers"]) .. "]",
              getFunc = function() return BMU_SVAcc.showNumberPlayers end,
              setFunc = function(value) BMU_SVAcc.showNumberPlayers = value end,
			  default = BMU_DefaultsPerAccount["showNumberPlayers"],
			  submenu = "rec",
		 },
         {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_SEARCH_CHARACTERNAMES),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["searchCharacterNames"]) .. "]",
              getFunc = function() return BMU_SVAcc.searchCharacterNames end,
              setFunc = function(value) BMU_SVAcc.searchCharacterNames = value end,
			  default = BMU_DefaultsPerAccount["searchCharacterNames"],
			  submenu = "rec",
		 },
         {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_ZONE_ONCE_ONLY),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["zoneOnceOnly"]) .. "]",
              getFunc = function() return BMU_SVAcc.zoneOnceOnly end,
              setFunc = function(value) BMU_SVAcc.zoneOnceOnly = value end,
			  default = BMU_DefaultsPerAccount["zoneOnceOnly"],
			  submenu = "rec",
		 },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["currentZoneAlwaysTop"]) .. "]",
              getFunc = function() return BMU_SVAcc.currentZoneAlwaysTop end,
              setFunc = function(value) BMU_SVAcc.currentZoneAlwaysTop = value end,
			  default = BMU_DefaultsPerAccount["currentZoneAlwaysTop"],
			  submenu = "rec",
		 },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["currentViewedZoneAlwaysTop"]) .. "]",
              getFunc = function() return BMU_SVAcc.currentViewedZoneAlwaysTop end,
              setFunc = function(value) BMU_SVAcc.currentViewedZoneAlwaysTop = value end,
			  default = BMU_DefaultsPerAccount["currentViewedZoneAlwaysTop"],
			  submenu = "rec",
		 },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_FORMAT_ZONE_NAME),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["formatZoneName"]) .. "]",
              getFunc = function() return BMU_SVAcc.formatZoneName end,
              setFunc = function(value) BMU_SVAcc.formatZoneName = value end,
			  default = BMU_DefaultsPerAccount["formatZoneName"],
			  submenu = "rec",
         },
		 {
              type = "slider",
              name = BMU_SI_Get(SI_TELE_SETTINGS_AUTO_REFRESH_FREQ),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsPerAccount["autoRefreshFreq"] .. "]",
              min = 0,
              max = 15,
              getFunc = function() return BMU_SVAcc.autoRefreshFreq end,
              setFunc = function(value) BMU_SVAcc.autoRefreshFreq = value end,
			  default = BMU_DefaultsPerAccount["autoRefreshFreq"],
			  submenu = "rec",
         },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["showZonesWithoutPlayers2"]) .. "]",
              getFunc = function() return BMU_SVAcc.showZonesWithoutPlayers2 end,
              setFunc = function(value) BMU_SVAcc.showZonesWithoutPlayers2 = value end,
			  default = BMU_DefaultsPerAccount["showZonesWithoutPlayers2"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_ONLY_MAPS),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_ONLY_MAPS_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["onlyMaps"]) .. "]",
              getFunc = function() return BMU_SVAcc.onlyMaps end,
              setFunc = function(value) BMU_SVAcc.onlyMaps = value end,
			  default = BMU_DefaultsPerAccount["onlyMaps"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_HIDE_OTHERS),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_HIDE_OTHERS_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["hideOthers"]) .. "]",
              getFunc = function() return BMU_SVAcc.hideOthers end,
              setFunc = function(value) BMU_SVAcc.hideOthers = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hideOthers"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_HIDE_PVP),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_HIDE_PVP_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["hidePVP"]) .. "]",
              getFunc = function() return BMU_SVAcc.hidePVP end,
              setFunc = function(value) BMU_SVAcc.hidePVP = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hidePVP"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_HIDE_CLOSED_DUNGEONS),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["hideClosedDungeons"]) .. "]",
              getFunc = function() return BMU_SVAcc.hideClosedDungeons end,
              setFunc = function(value) BMU_SVAcc.hideClosedDungeons = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hideClosedDungeons"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_HIDE_DELVES),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_HIDE_DELVES_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["hideDelves"]) .. "]",
              getFunc = function() return BMU_SVAcc.hideDelves end,
              setFunc = function(value) BMU_SVAcc.hideDelves = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hideDelves"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["hidePublicDungeons"]) .. "]",
              getFunc = function() return BMU_SVAcc.hidePublicDungeons end,
              setFunc = function(value) BMU_SVAcc.hidePublicDungeons = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hidePublicDungeons"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_HIDE_HOUSES),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_HIDE_HOUSES_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["hideHouses"]) .. "]",
              getFunc = function() return BMU_SVAcc.hideHouses end,
              setFunc = function(value) BMU_SVAcc.hideHouses = value end,
			  disabled = function() return BMU_SVAcc.onlyMaps end,
			  default = BMU_DefaultsPerAccount["hideHouses"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_HIDE_OWN_HOUSES),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["hideOwnHouses"]) .. "]",
              getFunc = function() return BMU_SVAcc.hideOwnHouses end,
              setFunc = function(value) BMU_SVAcc.hideOwnHouses = value end,
			  default = BMU_DefaultsPerAccount["hideOwnHouses"],
			  submenu = "bl",
         },
		 {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_PRIORITIZATION_DESCRIPTION),
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
              name = BMU_SI_Get(SI_TELE_SETTINGS_SHOW_TELEPORT_ANIMATION),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["showTeleportAnimation"]) .. "]",
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
              name = BMU_SI_Get(SI_TELE_SETTINGS_USE_PAN_AND_ZOOM),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["usePanAndZoom"]) .. "]",
              getFunc = function() return BMU_SVAcc.usePanAndZoom end,
              setFunc = function(value) BMU_SVAcc.usePanAndZoom = value end,
			  default = BMU_DefaultsPerAccount["usePanAndZoom"],
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_USE_RALLY_POINT),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["useMapPing"]) .. "]",
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
              name = BMU_SI_Get(SI_TELE_SETTINGS_SECOND_SEARCH_LANGUAGE),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownSecLangChoices[BMU_DefaultsPerAccount["secondLanguage"]] .. "]",
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
              name = BMU_SI_Get(SI_TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["FavoritePlayerStatusNotification"]) .. "]",
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
              name = BMU_SI_Get(SI_TELE_SETTINGS_SURVEY_MAP_NOTIFICATION),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["surveyMapsNotification"]) .. "]",
              getFunc = function() return BMU_SVAcc.surveyMapsNotification end,
              setFunc = function(value) BMU_SVAcc.surveyMapsNotification = value end,
			  default = BMU_DefaultsPerAccount["surveyMapsNotification"],
			  requiresReload = true,
			  width = "half",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = BMU_SI_Get(SI_TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["surveyMapsNotificationSound"]) .. "]",
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
              name = BMU_SI_Get(SI_TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["wayshrineTravelAutoConfirm"]) .. "]",
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
              name = BMU_SI_Get(SI_TELE_SETTINGS_OFFLINE_NOTE),
              tooltip = BMU_SI_Get(SI_TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["showOfflineReminder"]) .. "]",
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
			  name = BMU_SI_Get(SI_TELE_SETTINGS_OUTPUT_FAST_TRAVEL),
			  tooltip = BMU_SI_Get(SI_TELE_SETTINGS_OUTPUT_FAST_TRAVEL_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["chatOutputFastTravel"]) .. "]",
			  getFunc = function() return BMU_SVAcc.chatOutputFastTravel end,
			  setFunc = function(value) BMU_SVAcc.chatOutputFastTravel = value end,
			  default = BMU_DefaultsPerAccount["chatOutputFastTravel"],
			  submenu = "co",
	     },
	     {
			  type = "checkbox",
			  name = BMU_SI_Get(SI_TELE_SETTINGS_OUTPUT_ADDITIONAL),
			  tooltip = BMU_SI_Get(SI_TELE_SETTINGS_OUTPUT_ADDITIONAL_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["chatOutputAdditional"]) .. "]",
			  getFunc = function() return BMU_SVAcc.chatOutputAdditional end,
			  setFunc = function(value) BMU_SVAcc.chatOutputAdditional = value end,
			  default = BMU_DefaultsPerAccount["chatOutputAdditional"],
			  submenu = "co",
   		 },
   		 {
			  type = "checkbox",
			  name = BMU_SI_Get(SI_TELE_SETTINGS_OUTPUT_UNLOCK),
		 	  tooltip = BMU_SI_Get(SI_TELE_SETTINGS_OUTPUT_UNLOCK_TOOLTIP) .. " [DEFAULT: " .. tos(BMU_DefaultsPerAccount["chatOutputUnlock"]) .. "]",
			  getFunc = function() return BMU_SVAcc.chatOutputUnlock end,
			  setFunc = function(value) BMU_SVAcc.chatOutputUnlock = value end,
			  default = BMU_DefaultsPerAccount["chatOutputUnlock"],
			  submenu = "co",
		 },
		 {
			  type = "checkbox",
			  name = BMU_SI_Get(SI_TELE_SETTINGS_OUTPUT_DEBUG),
			  tooltip = BMU_SI_Get(SI_TELE_SETTINGS_OUTPUT_DEBUG_TOOLTIP),
			  getFunc = function() return BMU.debugMode end,
			  setFunc = function(value) BMU.debugMode = value end,
			  default = false,
			  warning = BMU_SI_Get(SI_TELE_SETTINGS_OUTPUT_DEBUG_WARN),
			  submenu = "co",
	     },
		 {
              type = "button",
              name = BMU_colorizeText(BMU_SI_Get(SI_TELE_SETTINGS_RESET_ALL_COUNTERS), "red"),
			  tooltip = BMU_SI_Get(SI_TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP),
			  func = function() for zoneId, _ in pairs(BMU_SVAcc.portCounterPerZone) do
									BMU_SVAcc.portCounterPerZone[zoneId] = nil
								end
								BMU.printToChat("ALL COUNTERS RESETTET!")
						end,
			  width = "half",
			  warning =  BMU_SI_Get(SI_TELE_SETTINGS_RESET_ALL_COUNTERS_WARN),
			  submenu = "adv",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_PTZONE_DESC) .. BMU_colorizeText("/bmutp/<zone name>\n", "gold") .. BMU_colorizeText("Example: /bmutp/deshaan", "lgray"), --"Port to specific zone\n(Hint: when you start typing /<zone name> the auto completion will appear on top)\n"
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_PTGROUPLEADER_DESC) .. BMU_colorizeText("/bmutp/leader", "gold"), --"Port to group leader\n"
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_PTCURFOCUSQUEST_DESC) .. BMU_colorizeText("/bmutp/quest", "gold"), --"Port to currently focused quest\n"
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_PTPRIMARYHOUSE_DESC) .. BMU_colorizeText("/bmutp/house", "gold"), --"Port into primary residence\n"
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_PTOUTPRIMARYHOUSE_DESC) .. BMU_colorizeText("/bmutp/house_out", "gold"), --"Port outside primary residence\n"
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_PTCURZONE_DESC) .. BMU_colorizeText("/bmutp/current_zone", "gold"), --"Port to current zone\n"
			  submenu = "cc",
         },
		 {
              type = "divider",
			  submenu = "cc",
         },
	     {
			type = "description",
			text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_ADDFAVZONE_DESC) .. BMU_colorizeText("/bmu/favorites/add/zone <fav slot> <zoneName or zoneId> \n", "gold") .. BMU_colorizeText("Example: /bmu/favorites/add/zone 1 Deshaan", "lgray"), --"Add zone favorite manually\n"
			submenu = "cc",
	   	 },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_ADDFAVPLAYER_DESC) .. BMU_colorizeText("/bmu/favorites/add/player <fav slot> <player name>\n", "gold") .. BMU_colorizeText("Example: /bmu/favorites/add/player 1 @DeadSoon", "lgray"), --"Add player favorite manually\n"
			  submenu = "cc",
         },
	     {
			  type = "description",
			  text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_ADDFAVWAYSHRINE_DESC) .. BMU_colorizeText("/bmu/favorites/add/wayshrine <fav slot>\n", "gold") .. BMU_colorizeText("Example: /bmu/favorites/add/wayshrine 1", "lgray"), --"Add wayshrine favorite\nOnce executed, you must interact (`E`) with your favorite wayshrine within 10 seconds. You can assign hotkeys for your favorite wayshrines.\n"
			  submenu = "cc",
	     },
	     {
			  type = "divider",
			  submenu = "cc",
	     },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_ADDFAVHOUSEZONE_DESC) .. BMU_colorizeText("/bmu/house/set/zone <zoneID> <houseID>\n", "gold") .. BMU_colorizeText("Example: /bmu/house/set/zone 1086 68", "lgray"), --"Add house favorite for zoneID\n"
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_ADDFAVHOUSECURZONE_DESC) .. BMU_colorizeText("/bmu/house/set/current_zone <houseID>\n", "gold") .. BMU_colorizeText("Example: /bmu/house/set/current_zone 68", "lgray"), --"Add house favorite for current zone\n"
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_ADDFAVTHISHOUSECURZONE_DESC) .. BMU_colorizeText("/bmu/house/set/current_house\n", "gold"), --"Add current house as favorite for current zone\n"
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_REMFAVHOUSECURZONE_DESC) .. BMU_colorizeText("/bmu/house/clear/current_zone\n", "gold"), --"Clear house favorite for current zone\n"
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_REMFAVHOUSEZONE_DESC) .. BMU_colorizeText("/bmu/house/clear/zone <zoneID>\n", "gold") .. BMU_colorizeText("Example: /bmu/house/clear/zone 1086", "lgray"), --"Clear house for zone\n"
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_LISTFAVHOUSE_DESC) .. BMU_colorizeText("/bmu/house/list\n", "gold"), --"List house favorites\n"
			  submenu = "cc",
         },
	     {
			  type = "divider",
			  submenu = "cc",
	     },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_GROUPCUSTVOTE100_DESC) .. BMU_colorizeText("/bmu/vote/custom_vote_unanimous <your text>\n", "gold") .. BMU_colorizeText("Example: /bmu/vote/custom_vote_unanimous Do you like BeamMeUp?", "lgray"), --"Start custom vote in group (100% are necessary)\n"
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_GROUPCUSTVOTE60_DESC) .. BMU_colorizeText("/bmu/vote/custom_vote_supermajority <your text>", "gold"), --"Start custom vote in group (>=60% are necessary)\n"
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_GROUPCUSTVOTE50_DESC) .. BMU_colorizeText("/bmu/vote/custom_vote_simplemajority <your text>", "gold"), --"Start custom vote in group (>50% are necessary)\n"
			  submenu = "cc",
         },
		 {
              type = "divider",
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_CHATPROMBMU_DESC) .. BMU_colorizeText("/bmu/misc/advertise", "gold"), --"Promote BeamMeUp by printing short advertising text in the chat\n"
			  submenu = "cc",
         },
	     {
			type = "description",
			text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_BMUGETZONEID_DESC) .. BMU_colorizeText("/bmu/misc/current_zone_id", "gold"), --"Get current zone id (where the player actually is)\n"
			submenu = "cc",
	   	 },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_BMUCHANGELANG_DESC) .. BMU_colorizeText("/bmu/misc/lang", "gold"), --"Switch client language (instant reload!)\n"
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_SLASH_BMUDEBUGMODE_DESC) .. BMU_colorizeText("/bmu/misc/debug", "gold"), --"Enable debug mode\n"
			  submenu = "cc",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_INSTALLED_SCINCE),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = tos(os.date('%Y/%m/%d', BMU_SVAcc.initialTimeStamp)),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_UI_TOTAL_PORTS),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
			-- NOTE: "text" parameter must always be string since LAM2 do not handle integer values correctly
              text = tos(BMU.formatGold(BMU_SVAcc.totalPortCounter)),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_UI_GOLD),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = tos(BMU.formatGold(BMU_SVAcc.savedGold)),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = BMU_SI_Get(SI_TELE_SETTINGS_MOST_PORTED_ZONES),
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
		name = BMU_SI_Get(SI_TELE_SETTINGS_ADDON_EXTENSIONS),
		controls = optionsBySubmenu["deps"],
	}
	local submenu2 = {
		type = "submenu",
		name = BMU_SI_Get(SI_TELE_SETTINGS_HEADER_UI),
		controls = optionsBySubmenu["ui"],
	}
	local submenu3 = {
		type = "submenu",
		name = BMU_SI_Get(SI_TELE_SETTINGS_HEADER_RECORDS),
		controls = optionsBySubmenu["rec"],
	}
	local submenu4 = {
		type = "submenu",
		name = BMU_SI_Get(SI_TELE_SETTINGS_HEADER_BLACKLISTING),
		controls = optionsBySubmenu["bl"],
	}
	local submenu5 = {
		type = "submenu",
		name = BMU_SI_Get(SI_TELE_SETTINGS_HEADER_PRIO),
		controls = optionsBySubmenu["prio"],
	}
	local submenu6 = {
		type = "submenu",
		name = BMU_SI_Get(SI_TELE_SETTINGS_HEADER_ADVANCED),
		controls = optionsBySubmenu["adv"],
	}
	local submenu7 = {
		type = "submenu",
		name = BMU_SI_Get(SI_TELE_SETTINGS_HEADER_CHAT_OUTPUT),
		controls = optionsBySubmenu["co"],
	}
	local submenu8 = {
		type = "submenu",
		name = BMU_SI_Get(SI_TELE_SETTINGS_HEADER_CHAT_COMMANDS),
		controls = optionsBySubmenu["cc"],
	}
	local submenu9 = {
		type = "submenu",
		name = BMU_SI_Get(SI_TELE_SETTINGS_HEADER_STATS),
		controls = optionsBySubmenu["stats"],
	}

	-- register all submenus with options
	-- TODO: add submenu1
	LAM2:RegisterOptionControls(appName .. "Options", {submenu1, submenu2, submenu3, submenu4, submenu5, submenu6, submenu7, submenu8, submenu9})
end
BMU.SetupOptionsMenu = SetupOptionsMenu