local LAM2 = BMU.LAM
local SI = BMU.SI ---- used for localization

local teleporterVars    = BMU.var
local appName           = teleporterVars.appName
local wm                = WINDOW_MANAGER

-- list of tuples (guildId & displayname) for invite queue (only for admin)
local inviteQueue = {}

local function SetupOptionsMenu(index) --index == Addon name
    local teleporterWin     = BMU.win

    local panelData = {
            type 				= 'panel',
            name 				= index,
            displayName 		= BMU.colorizeText(index, "gold"),
            author 				= BMU.colorizeText(teleporterVars.author, "teal"),
            version 			= BMU.colorizeText(teleporterVars.version, "teal"),
            website             = teleporterVars.website,
            feedback            = teleporterVars.feedback,
            registerForRefresh  = true,
            registerForDefaults = true,
        }


    BMU.SettingsPanel = LAM2:RegisterAddonPanel(appName .. "Options", panelData) -- for quick access
	
	-- retreive most ported zones for statistic
	local portCounterPerZoneSorted = {}
	for index, value in pairs(BMU.savedVarsAcc.portCounterPerZone) do
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
              name = SI.get(SI.TELE_SETTINGS_NUMBER_LINES),
              tooltip = SI.get(SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP) .. " [DEFAULT: " .. BMU.DefaultsAccount["numberLines"] .. "]",
              min = 6,
              max = 16,
              getFunc = function() return BMU.savedVarsAcc.numberLines end,
              setFunc = function(value) BMU.savedVarsAcc.numberLines = value
							teleporterWin.Main_Control:SetHeight(BMU.calculateListHeight())
							teleporterWin.Main_Control.bd:SetHeight(BMU.calculateListHeight() + 280*BMU.savedVarsAcc.Scale)
				end,
			  default = BMU.DefaultsAccount["numberLines"],
			  submenu = "ui",
         },
         {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN),
              tooltip = SI.get(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["ShowOnMapOpen"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.ShowOnMapOpen end,
              setFunc = function(value) BMU.savedVarsAcc.ShowOnMapOpen = value end,
			  default = BMU.DefaultsAccount["ShowOnMapOpen"],
			  submenu = "ui",
         },
         {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["HideOnMapClose"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.HideOnMapClose end,
              setFunc = function(value) BMU.savedVarsAcc.HideOnMapClose = value end,
			  default = BMU.DefaultsAccount["HideOnMapClose"],
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_CLOSE_ON_PORTING),
              tooltip = SI.get(SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["closeOnPorting"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.closeOnPorting end,
              setFunc = function(value) BMU.savedVarsAcc.closeOnPorting = value end,
			  default = BMU.DefaultsAccount["closeOnPorting"],
			  submenu = "ui",
		 },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_WINDOW_STAY),
              tooltip = SI.get(SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["windowStay"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.windowStay end,
              setFunc = function(value) BMU.savedVarsAcc.windowStay = value end,
			  default = BMU.DefaultsAccount["windowStay"],
			  submenu = "ui",
		 },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN),
              tooltip = SI.get(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["focusZoneSearchOnOpening"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.focusZoneSearchOnOpening end,
              setFunc = function(value) BMU.savedVarsAcc.focusZoneSearchOnOpening = value end,
			  default = BMU.DefaultsAccount["focusZoneSearchOnOpening"],
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT),
              tooltip = SI.get(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["unlockingLessChatOutput"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.unlockingLessChatOutput end,
              setFunc = function(value) BMU.savedVarsAcc.unlockingLessChatOutput = value end,
			  default = BMU.DefaultsAccount["unlockingLessChatOutput"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = SI.get(SI.TELE_SETTINGS_AUTO_PORT_FREQ),
              tooltip = SI.get(SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP) .. " [DEFAULT: " .. BMU.DefaultsAccount["AutoPortFreq"] .. "]",
              min = 50,
              max = 500,
              getFunc = function() return BMU.savedVarsAcc.AutoPortFreq end,
              setFunc = function(value) BMU.savedVarsAcc.AutoPortFreq = value end,
			  default = BMU.DefaultsAccount["AutoPortFreq"],
			  submenu = "ui",
         },
		 {
              type = "divider",
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP),
              tooltip = SI.get(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["showOpenButtonOnMap"]) .. "]",
              requiresReload = true,
			  getFunc = function() return BMU.savedVarsAcc.showOpenButtonOnMap end,
              setFunc = function(value) BMU.savedVarsAcc.showOpenButtonOnMap = value end,
			  default = BMU.DefaultsAccount["showOpenButtonOnMap"],
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON),
              tooltip = SI.get(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["chatButton"]) .. "]",
              requiresReload = true,
			  getFunc = function() return BMU.savedVarsAcc.chatButton end,
              setFunc = function(value) BMU.savedVarsAcc.chatButton = value end,
			  default = BMU.DefaultsAccount["chatButton"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = SI.get(SI.TELE_SETTINGS_SCALE),
			  tooltip = SI.get(SI.TELE_SETTINGS_SCALE_TOOLTIP) .. " [DEFAULT: " .. BMU.DefaultsAccount["Scale"] .. "]",
			  min = 0.7,
			  max = 1.4,
			  step = 0.05,
			  decimals = 2,
			  requiresReload = true,
              getFunc = function() return BMU.savedVarsAcc.Scale end,
              setFunc = function(value) BMU.savedVarsAcc.Scale = value end,
			  default = BMU.DefaultsAccount["Scale"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = SI.get(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET),
              tooltip = SI.get(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP) .. " [DEFAULT: " .. BMU.DefaultsAccount["chatButtonHorizontalOffset"] .. "]",
              min = 0,
              max = 200,
              getFunc = function() return BMU.savedVarsAcc.chatButtonHorizontalOffset end,
              setFunc = function(value) BMU.savedVarsAcc.chatButtonHorizontalOffset = value
							BMU.chatButtonTex:SetAnchor(TOPRIGHT, ZO_ChatWindow, TOPRIGHT, -40 - BMU.savedVarsAcc.chatButtonHorizontalOffset, 6)
						end,
			  default = BMU.DefaultsAccount["chatButtonHorizontalOffset"],
			  submenu = "ui",
			  disabled = function() return not BMU.savedVarsAcc.chatButton or not BMU.chatButtonTex end,
         },
		 {
              type = "slider",
              name = SI.get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL),
              tooltip = SI.get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP) .. " [DEFAULT: " .. BMU.DefaultsAccount["anchorMapOffset_x"] .. "]",
			  min = -100,
              max = 100,
              getFunc = function() return BMU.savedVarsAcc.anchorMapOffset_x end,
              setFunc = function(value) BMU.savedVarsAcc.anchorMapOffset_x = value end,
			  default = BMU.DefaultsAccount["anchorMapOffset_x"],
			  submenu = "ui",
         },
		 {
              type = "slider",
              name = SI.get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL),
			  tooltip = SI.get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP) .. " [DEFAULT: " .. BMU.DefaultsAccount["anchorMapOffset_y"] .. "]",
			  min = -150,
			  max = 150,
              getFunc = function() return BMU.savedVarsAcc.anchorMapOffset_y end,
              setFunc = function(value) BMU.savedVarsAcc.anchorMapOffset_y = value end,
			  default = BMU.DefaultsAccount["anchorMapOffset_y"],
			  submenu = "ui",
         },
		 {
              type = "button",
              name = SI.get(SI.TELE_SETTINGS_RESET_UI),
			  tooltip = SI.get(SI.TELE_SETTINGS_RESET_UI_TOOLTIP),
			  func = function() BMU.savedVarsAcc.Scale = BMU.DefaultsAccount["Scale"]
								BMU.savedVarsAcc.chatButtonHorizontalOffset = BMU.DefaultsAccount["chatButtonHorizontalOffset"]
								BMU.savedVarsAcc.anchorMapOffset_x = BMU.DefaultsAccount["anchorMapOffset_x"]
								BMU.savedVarsAcc.anchorMapOffset_y = BMU.DefaultsAccount["anchorMapOffset_y"]
								BMU.savedVarsAcc.pos_MapScene_x = BMU.DefaultsAccount["pos_MapScene_x"]
								BMU.savedVarsAcc.pos_MapScene_y = BMU.DefaultsAccount["pos_MapScene_y"]
								BMU.savedVarsAcc.pos_x = BMU.DefaultsAccount["pos_x"]
								BMU.savedVarsAcc.pos_y = BMU.DefaultsAccount["pos_y"]
								BMU.savedVarsAcc.anchorOnMap = BMU.DefaultsAccount["anchorOnMap"]
								ReloadUI()
						end,
			  width = "half",
			  warning = "This will automatically reload your UI!",
			  submenu = "ui",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_AUTO_REFRESH),
              tooltip = SI.get(SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["autoRefresh"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.autoRefresh end,
              setFunc = function(value) BMU.savedVarsAcc.autoRefresh = value end,
			  default = BMU.DefaultsAccount["autoRefresh"],
			  submenu = "rec",
         },
		 {
              type = "dropdown",
              name = SI.get(SI.TELE_SETTINGS_SORTING),
              tooltip = SI.get(SI.TELE_SETTINGS_SORTING_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownSortChoices[BMU.DefaultsCharacter["sorting"]] .. "]",
			  choices = BMU.dropdownSortChoices,
			  choicesValues = BMU.dropdownSortValues,
              getFunc = function() return BMU.savedVarsChar.sorting end,
			  setFunc = function(value) BMU.savedVarsChar.sorting = value end,
			  default = BMU.DefaultsCharacter["sorting"],
			  warning = BMU.colorizeText(SI.get(SI.TELE_SETTINGS_INFO_CHARACTER_DEPENDING), "dred"),
			  submenu = "rec",
        },
         {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS),
              tooltip = SI.get(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["showNumberPlayers"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.showNumberPlayers end,
              setFunc = function(value) BMU.savedVarsAcc.showNumberPlayers = value end,
			  default = BMU.DefaultsAccount["showNumberPlayers"],
			  submenu = "rec",
		 },
         {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES),
              tooltip = SI.get(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["searchCharacterNames"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.searchCharacterNames end,
              setFunc = function(value) BMU.savedVarsAcc.searchCharacterNames = value end,
			  default = BMU.DefaultsAccount["searchCharacterNames"],
			  submenu = "rec",
		 },		 
         {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_ZONE_ONCE_ONLY),
              tooltip = SI.get(SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["zoneOnceOnly"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.zoneOnceOnly end,
              setFunc = function(value) BMU.savedVarsAcc.zoneOnceOnly = value end,
			  default = BMU.DefaultsAccount["zoneOnceOnly"],
			  submenu = "rec",
		 },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP),
              tooltip = SI.get(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["currentZoneAlwaysTop"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.currentZoneAlwaysTop end,
              setFunc = function(value) BMU.savedVarsAcc.currentZoneAlwaysTop = value end,
			  default = BMU.DefaultsAccount["currentZoneAlwaysTop"],
			  submenu = "rec",
		 },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP),
              tooltip = SI.get(SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["currentViewedZoneAlwaysTop"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.currentViewedZoneAlwaysTop end,
              setFunc = function(value) BMU.savedVarsAcc.currentViewedZoneAlwaysTop = value end,
			  default = BMU.DefaultsAccount["currentViewedZoneAlwaysTop"],
			  submenu = "rec",
		 },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_FORMAT_ZONE_NAME),
              tooltip = SI.get(SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["formatZoneName"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.formatZoneName end,
              setFunc = function(value) BMU.savedVarsAcc.formatZoneName = value end,
			  default = BMU.DefaultsAccount["formatZoneName"],
			  submenu = "rec",
         },
		 {
              type = "slider",
              name = SI.get(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ),
              tooltip = SI.get(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP) .. " [DEFAULT: " .. BMU.DefaultsAccount["autoRefreshFreq"] .. "]",
              min = 0,
              max = 15,
              getFunc = function() return BMU.savedVarsAcc.autoRefreshFreq end,
              setFunc = function(value) BMU.savedVarsAcc.autoRefreshFreq = value end,
			  default = BMU.DefaultsAccount["autoRefreshFreq"],
			  submenu = "rec",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS),
              tooltip = SI.get(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["showZonesWithoutPlayers2"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.showZonesWithoutPlayers2 end,
              setFunc = function(value) BMU.savedVarsAcc.showZonesWithoutPlayers2 = value end,
			  default = BMU.DefaultsAccount["showZonesWithoutPlayers2"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_ONLY_MAPS),
              tooltip = SI.get(SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["onlyMaps"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.onlyMaps end,
              setFunc = function(value) BMU.savedVarsAcc.onlyMaps = value end,
			  default = BMU.DefaultsAccount["onlyMaps"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_HIDE_OTHERS),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["hideOthers"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.hideOthers end,
              setFunc = function(value) BMU.savedVarsAcc.hideOthers = value end,
			  disabled = function() return BMU.savedVarsAcc.onlyMaps end,
			  default = BMU.DefaultsAccount["hideOthers"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_HIDE_PVP),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["hidePVP"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.hidePVP end,
              setFunc = function(value) BMU.savedVarsAcc.hidePVP = value end,
			  disabled = function() return BMU.savedVarsAcc.onlyMaps end,
			  default = BMU.DefaultsAccount["hidePVP"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["hideClosedDungeons"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.hideClosedDungeons end,
              setFunc = function(value) BMU.savedVarsAcc.hideClosedDungeons = value end,
			  disabled = function() return BMU.savedVarsAcc.onlyMaps end,
			  default = BMU.DefaultsAccount["hideClosedDungeons"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_HIDE_DELVES),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["hideDelves"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.hideDelves end,
              setFunc = function(value) BMU.savedVarsAcc.hideDelves = value end,
			  disabled = function() return BMU.savedVarsAcc.onlyMaps end,
			  default = BMU.DefaultsAccount["hideDelves"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["hidePublicDungeons"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.hidePublicDungeons end,
              setFunc = function(value) BMU.savedVarsAcc.hidePublicDungeons = value end,
			  disabled = function() return BMU.savedVarsAcc.onlyMaps end,
			  default = BMU.DefaultsAccount["hidePublicDungeons"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_HIDE_HOUSES),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["hideHouses"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.hideHouses end,
              setFunc = function(value) BMU.savedVarsAcc.hideHouses = value end,
			  disabled = function() return BMU.savedVarsAcc.onlyMaps end,
			  default = BMU.DefaultsAccount["hideHouses"],
			  submenu = "bl",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_HIDE_OWN_HOUSES),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["hideOwnHouses"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.hideOwnHouses end,
              setFunc = function(value) BMU.savedVarsAcc.hideOwnHouses = value end,
			  default = BMU.DefaultsAccount["hideOwnHouses"],
			  submenu = "bl",
         },
		 {
              type = "description",
              text = SI.get(SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION),
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
				local index = BMU.getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
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
				local index = BMU.getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
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
				local index = BMU.getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
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
				local index = BMU.getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
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
				local index = BMU.getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
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
				local index = BMU.getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
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
              name = SI.get(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION),
              tooltip = SI.get(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["showTeleportAnimation"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.showTeleportAnimation end,
              setFunc = function(value) BMU.savedVarsAcc.showTeleportAnimation = value end,
			  default = BMU.DefaultsAccount["showTeleportAnimation"],
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM),
              tooltip = SI.get(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["usePanAndZoom"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.usePanAndZoom end,
              setFunc = function(value) BMU.savedVarsAcc.usePanAndZoom = value end,
			  default = BMU.DefaultsAccount["usePanAndZoom"],
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_USE_RALLY_POINT),
              tooltip = SI.get(SI.TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["useMapPing"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.useMapPing end,
              setFunc = function(value) BMU.savedVarsAcc.useMapPing = value end,
			  disabled = function() return not BMU.LibMapPing end,
			  default = BMU.DefaultsAccount["useMapPing"],
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
         {
              type = "dropdown",
              name = SI.get(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE),
              tooltip = SI.get(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownSecLangChoices[BMU.DefaultsAccount["secondLanguage"]] .. "]",
			  choices = BMU.dropdownSecLangChoices,
			  choicesValues = BMU.dropdownSecLangValues,
              getFunc = function() return BMU.savedVarsAcc.secondLanguage end,
			  setFunc = function(value) BMU.savedVarsAcc.secondLanguage = value end,
			  default = BMU.DefaultsAccount["secondLanguage"],
			  submenu = "adv",
        },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE),
              tooltip = SI.get(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["FavoritePlayerStatusNotification"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.FavoritePlayerStatusNotification end,
              setFunc = function(value) BMU.savedVarsAcc.FavoritePlayerStatusNotification = value end,
			  default = BMU.DefaultsAccount["FavoritePlayerStatusNotification"],
			  requiresReload = true,
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION),
              tooltip = SI.get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["surveyMapsNotification"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.surveyMapsNotification end,
              setFunc = function(value) BMU.savedVarsAcc.surveyMapsNotification = value end,
			  default = BMU.DefaultsAccount["surveyMapsNotification"],
			  requiresReload = true,
			  width = "half",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND),
              tooltip = SI.get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["surveyMapsNotificationSound"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.surveyMapsNotificationSound end,
              setFunc = function(value) BMU.savedVarsAcc.surveyMapsNotificationSound = value end,
			  default = BMU.DefaultsAccount["surveyMapsNotificationSound"],
			  disabled = function() return not BMU.savedVarsAcc.surveyMapsNotification end,
			  width = "half",
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL),
              tooltip = SI.get(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["wayshrineTravelAutoConfirm"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.wayshrineTravelAutoConfirm end,
              setFunc = function(value) BMU.savedVarsAcc.wayshrineTravelAutoConfirm = value end,
			  default = BMU.DefaultsAccount["wayshrineTravelAutoConfirm"],
			  requiresReload = true,
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "checkbox",
              name = SI.get(SI.TELE_SETTINGS_OFFLINE_NOTE),
              tooltip = SI.get(SI.TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["showOfflineReminder"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.showOfflineReminder end,
              setFunc = function(value) BMU.savedVarsAcc.showOfflineReminder = value end,
			  default = BMU.DefaultsAccount["showOfflineReminder"],
			  requiresReload = true,
			  submenu = "adv",
         },
		 {
              type = "divider",
			  submenu = "adv",
         },
		 {
              type = "button",
              name = BMU.colorizeText(SI.get(SI.TELE_SETTINGS_RESET_ALL_COUNTERS), "red"),
			  tooltip = SI.get(SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP),
			  func = function() for zoneId, _ in pairs(BMU.savedVarsAcc.portCounterPerZone) do
									BMU.savedVarsAcc.portCounterPerZone[zoneId] = nil
								end
								BMU.printToChat("ALL COUNTERS RESETTET!")
						end,
			  width = "half",
			  warning = "All zone counters are reset. Therefore, the sorting by most used and your personal statistics are reset.",
			  submenu = "adv",
         },
	     {
              type = "description",
              text = "Port to specific zone\n(Hint: when you start typing /<zone name> the auto completion will appear on top)\n" .. BMU.colorizeText("/bmutp/<zone name>\n", "gold") .. BMU.colorizeText("Example: /bmutp/deshaan", "lgray"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port to group leader\n" .. BMU.colorizeText("/bmutp/leader", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port to currently focused quest\n" .. BMU.colorizeText("/bmutp/quest", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port into primary residence\n" .. BMU.colorizeText("/bmutp/house", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port outside primary residence\n" .. BMU.colorizeText("/bmutp/house_out", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Port to current zone\n" .. BMU.colorizeText("/bmutp/current_zone", "gold"),
			  submenu = "cc",
         },
		 {
              type = "divider",
			  submenu = "cc",
         },
	     {
			type = "description",
			text = "Add zone favorite manually\n" .. BMU.colorizeText("/bmu/favorites/add/zone <fav slot> <zoneName or zoneId> \n", "gold") .. BMU.colorizeText("Example: /bmu/favorites/add/zone 1 Deshaan", "lgray"),
			submenu = "cc",
	   	 },
	     {
              type = "description",
              text = "Add player favorite manually\n" .. BMU.colorizeText("/bmu/favorites/add/player <fav slot> <player name>\n", "gold") .. BMU.colorizeText("Example: /bmu/favorites/add/player 1 @DeadSoon", "lgray"),
			  submenu = "cc",
         },
		 {
              type = "divider",
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Start custom vote in group (100% are necessary)\n" .. BMU.colorizeText("/bmu/vote/custom_vote_unanimous <your text>\n", "gold") .. BMU.colorizeText("Example: /bmu/vote/custom_vote_unanimous Do you like BeamMeUp?", "lgray"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Start custom vote in group (>=60% are necessary)\n" .. BMU.colorizeText("/bmu/vote/custom_vote_supermajority <your text>", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Start custom vote in group (>50% are necessary)\n" .. BMU.colorizeText("/bmu/vote/custom_vote_simplemajority <your text>", "gold"),
			  submenu = "cc",
         },
		 {
              type = "divider",
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Promote BeamMeUp by printing short advertising text in the chat\n" .. BMU.colorizeText("/bmu/misc/advertise", "gold"),
			  submenu = "cc",
         },
	     {
			type = "description",
			text = "Get current zone id (where the player actually is)\n" .. BMU.colorizeText("/bmu/misc/current_zone_id", "gold"),
			submenu = "cc",
	   	 },
	     {
              type = "description",
              text = "Switch client language (instant reload!)\n" .. BMU.colorizeText("/bmu/misc/lang", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = "Enable debug mode\n" .. BMU.colorizeText("/bmu/misc/debug", "gold"),
			  submenu = "cc",
         },
	     {
              type = "description",
              text = SI.get(SI.TELE_SETTINGS_INSTALLED_SCINCE),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = tostring(os.date('%Y/%m/%d', BMU.savedVarsAcc.initialTimeStamp)),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = SI.get(SI.TELE_UI_TOTAL_PORTS),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = BMU.formatGold(BMU.savedVarsAcc.totalPortCounter),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = SI.get(SI.TELE_UI_GOLD),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = BMU.formatGold(BMU.savedVarsAcc.savedGold),
			  width = "half",
			  submenu = "stats",
         },
	     {
              type = "description",
              text = SI.get(SI.TELE_SETTINGS_MOST_PORTED_ZONES),
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
		name = SI.get(SI.TELE_SETTINGS_HEADER_UI),
		controls = optionsBySubmenu["ui"],
	}
	local submenu3 = {
		type = "submenu",
		name = SI.get(SI.TELE_SETTINGS_HEADER_RECORDS),
		controls = optionsBySubmenu["rec"],
	}
	local submenu4 = {
		type = "submenu",
		name = SI.get(SI.TELE_SETTINGS_HEADER_BLACKLISTING),
		controls = optionsBySubmenu["bl"],
	}
	local submenu5 = {
		type = "submenu",
		name = SI.get(SI.TELE_SETTINGS_HEADER_PRIO),
		controls = optionsBySubmenu["prio"],
	}
	local submenu6 = {
		type = "submenu",
		name = SI.get(SI.TELE_SETTINGS_HEADER_ADVANCED),
		controls = optionsBySubmenu["adv"],
	}
	local submenu7 = {
		type = "submenu",
		name = SI.get(SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS),
		controls = optionsBySubmenu["cc"],
	}
	local submenu8 = {
		type = "submenu",
		name = SI.get(SI.TELE_SETTINGS_HEADER_STATS),
		controls = optionsBySubmenu["stats"],
	}
	
	-- register all submenus with options
	-- TODO: add submenu1
	LAM2:RegisterOptionControls(appName .. "Options", {submenu1, submenu2, submenu3, submenu4, submenu5, submenu6, submenu7, submenu8})
end


function BMU.getStringIsInstalledLibrary(addonName)
	local stringInstalled = BMU.colorizeText("installed and enabled", "green")
	local stringNotInstalled = BMU.colorizeText("not installed or disabled", "red")
	
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


local function SetupUI()
	-----------------------------------------------
	-- Fonts
	
	-- default font
	local fontSize = BMU.round(17*BMU.savedVarsAcc.Scale, 0)
	local fontStyle = ZoFontGame:GetFontInfo()
	local fontWeight = "soft-shadow-thin"
	BMU.font1 = string.format("%s|$(KB_%s)|%s", fontStyle, fontSize, fontWeight)
	
	-- font of statistics
	fontSize = BMU.round(13*BMU.savedVarsAcc.Scale, 0)
	fontStyle = ZoFontBookTablet:GetFontInfo()
	--fontStyle = "EsoUI/Common/Fonts/consola.ttf"
	fontWeight = "soft-shadow-thin"
	BMU.font2 = string.format("%s|$(KB_%s)|%s", fontStyle, fontSize, fontWeight)
	
	-----------------------------------------------
    local teleporterWin = BMU.win

    -----------------------------------------------
	
	-- Button on Chat Window
	if BMU.savedVarsAcc.chatButton then
		-- Texture
		BMU.chatButtonTex = wm:CreateControl(nil, ZO_ChatWindow, CT_TEXTURE)
		BMU.chatButtonTex:SetDimensions(33, 33)
		BMU.chatButtonTex:SetAnchor(TOPRIGHT, ZO_ChatWindow, TOPRIGHT, -40 - BMU.savedVarsAcc.chatButtonHorizontalOffset, 6)
		BMU.chatButtonTex:SetTexture(BMU.textures.wayshrineBtn)
		BMU.chatButtonTex:SetMouseEnabled(true)
		BMU.chatButtonTex:SetDrawLayer(2)
		--Handlers
		BMU.chatButtonTex:SetHandler("OnMouseUp", function()
			BMU.OpenTeleporter(true)
		end)
		
		BMU.chatButtonTex:SetHandler("OnMouseEnter", function(self)
			BMU.chatButtonTex:SetTexture(BMU.textures.wayshrineBtnOver)
			BMU:tooltipTextEnter(BMU.chatButtonTex, appName)
		end)
	  
		BMU.chatButtonTex:SetHandler("OnMouseExit", function(self)
			BMU.chatButtonTex:SetTexture(BMU.textures.wayshrineBtn)
			BMU:tooltipTextEnter(BMU.chatButtonTex)
		end)
	end
	
	-----------------------------------------------
	
	-----------------------------------------------
	-- Bandits Integration -> Add custom button to the side bar (with delay to ensure, that BUI is loaded)
	zo_callLater(function()
		if BUI and BUI.PanelAdd then
			local content = {
					{	
						icon = BMU.textures.wayshrineBtn,
						tooltip	= BMU.var.appName,
						func = function() BMU.OpenTeleporter(true) end,
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
  -----------------------------------------------------------------------------------------------------------------
  teleporterWin.Main_Control = wm:CreateTopLevelWindow("Teleporter_Location_MainController")

  teleporterWin.Main_Control:SetMouseEnabled(true)
  teleporterWin.Main_Control:SetDimensions(500*BMU.savedVarsAcc.Scale,400*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control:SetHidden(true)

  teleporterWin.appTitle =  wm:CreateControl("Teleporter" .. "_appTitle", teleporterWin.Main_Control, CT_LABEL)
  teleporterWin.appTitle:SetFont(BMU.font1)
  teleporterWin.appTitle:SetColor(255, 255, 255, 1)
  teleporterWin.appTitle:SetText(BMU.colorizeText(appName, "gold") .. BMU.colorizeText(" - Teleporter", "white"))
  --teleporterWin.appTitle:SetAnchor(TOP, teleporterWin.Main_Control, TOP, -31*BMU.savedVarsAcc.Scale, -62*BMU.savedVarsAcc.Scale)
  teleporterWin.appTitle:SetAnchor(CENTER, teleporterWin.Main_Control, TOP, nil, -62*BMU.savedVarsAcc.Scale)
  
  ----- This is where we create the list element for TeleUnicorn/ List
  TeleporterList = BMU.ListView.new(teleporterWin.Main_Control,  {
    width = 750*BMU.savedVarsAcc.Scale,
    height = 500*BMU.savedVarsAcc.Scale,
  })
  
  ---------

  
    -------------------------------------------------------------------
  -- Switch BUTTON ON ZoneGuide window

  teleporterWin.zoneGuideSwapTexture = wm:CreateControl(nil, ZO_WorldMapZoneStoryTopLevel_Keyboard, CT_TEXTURE)
  teleporterWin.zoneGuideSwapTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.zoneGuideSwapTexture:SetAnchor(TOPRIGHT, ZO_WorldMapZoneStoryTopLevel_Keyboard, TOPRIGHT, TOPRIGHT -10*BMU.savedVarsAcc.Scale, -35*BMU.savedVarsAcc.Scale)
  teleporterWin.zoneGuideSwapTexture:SetTexture(BMU.textures.swapBtn)
  teleporterWin.zoneGuideSwapTexture:SetMouseEnabled(true)
  
  teleporterWin.zoneGuideSwapTexture:SetHandler("OnMouseUp", function()
	  BMU.OpenTeleporter(true)
	end)
	  
  teleporterWin.zoneGuideSwapTexture:SetHandler("OnMouseEnter", function(self)
      teleporterWin.zoneGuideSwapTexture:SetTexture(BMU.textures.swapBtnOver)
      BMU:tooltipTextEnter(teleporterWin.zoneGuideSwapTexture,
          SI.get(SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE))
  end)

  teleporterWin.zoneGuideSwapTexture:SetHandler("OnMouseExit", function(self)
      teleporterWin.zoneGuideSwapTexture:SetTexture(BMU.textures.swapBtn)
      BMU:tooltipTextEnter(teleporterWin.zoneGuideSwapTexture)
  end)

  ---------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------
  -- Feedback BUTTON

  teleporterWin.feedbackTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.feedbackTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.feedbackTexture:SetAnchor(TOPLEFT, teleporterWin.Main_Control, TOPLEFT, TOPLEFT-35*BMU.savedVarsAcc.Scale, -75*BMU.savedVarsAcc.Scale)
  teleporterWin.feedbackTexture:SetTexture(BMU.textures.feedbackBtn)
  teleporterWin.feedbackTexture:SetMouseEnabled(true)
  
  teleporterWin.feedbackTexture:SetHandler("OnMouseUp", function()
      BMU.createMail("@DeadSoon", "Feedback - BeamMeUp", "")
	end)
	  
  teleporterWin.feedbackTexture:SetHandler("OnMouseEnter", function(self)
      teleporterWin.feedbackTexture:SetTexture(BMU.textures.feedbackBtnOver)
      BMU:tooltipTextEnter(teleporterWin.feedbackTexture,
          GetString(SI_CUSTOMER_SERVICE_SUBMIT_FEEDBACK))
  end)

  teleporterWin.feedbackTexture:SetHandler("OnMouseExit", function(self)
      teleporterWin.feedbackTexture:SetTexture(BMU.textures.feedbackBtn)
      BMU:tooltipTextEnter(teleporterWin.feedbackTexture)
  end)
  
      -------------------------------------------------------------------
  -- Guild BUTTON
  -- display button only if guilds are available on players game server
	if BMU.var.BMUGuilds[GetWorldName()] ~= nil then
		teleporterWin.guildTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
		teleporterWin.guildTexture:SetDimensions(40*BMU.savedVarsAcc.Scale, 40*BMU.savedVarsAcc.Scale)
		teleporterWin.guildTexture:SetAnchor(TOPLEFT, teleporterWin.Main_Control, TOPLEFT, TOPLEFT+10*BMU.savedVarsAcc.Scale, -75*BMU.savedVarsAcc.Scale)
		teleporterWin.guildTexture:SetTexture(BMU.textures.guildBtn)
		teleporterWin.guildTexture:SetMouseEnabled(true)
	  
		teleporterWin.guildTexture:SetHandler("OnMouseUp", function(self, button)
			if not BMU.isCurrentlyRequestingGuildData then
				BMU.requestGuildData()
			end
			BMU.clearInputFields()
			zo_callLater(function() BMU.createTableGuilds() end, 350)
		end)
			  
		teleporterWin.guildTexture:SetHandler("OnMouseEnter", function(self)
		  teleporterWin.guildTexture:SetTexture(BMU.textures.guildBtnOver)
		  BMU:tooltipTextEnter(teleporterWin.guildTexture,
			SI.get(SI.TELE_UI_BTN_GUILD_BMU))
		end)

		teleporterWin.guildTexture:SetHandler("OnMouseExit", function(self)
		  BMU:tooltipTextEnter(teleporterWin.guildTexture)
		  if BMU.state ~= 13 then
			teleporterWin.guildTexture:SetTexture(BMU.textures.guildBtn)
		  end
		end)
	end
  
  
      -------------------------------------------------------------------
  -- Guild House BUTTON
  -- display button only if guild house is available on players game server
  if BMU.var.guildHouse[GetWorldName()] ~= nil then
	  teleporterWin.guildHouseTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
	  teleporterWin.guildHouseTexture:SetDimensions(40*BMU.savedVarsAcc.Scale, 40*BMU.savedVarsAcc.Scale)
	  teleporterWin.guildHouseTexture:SetAnchor(TOPLEFT, teleporterWin.Main_Control, TOPLEFT, TOPLEFT+55*BMU.savedVarsAcc.Scale, -75*BMU.savedVarsAcc.Scale)
	  teleporterWin.guildHouseTexture:SetTexture(BMU.textures.guildHouseBtn)
	  teleporterWin.guildHouseTexture:SetMouseEnabled(true)
  
	  teleporterWin.guildHouseTexture:SetHandler("OnMouseUp", function()
		  BMU.portToBMUGuildHouse()
		end)
		  
	  teleporterWin.guildHouseTexture:SetHandler("OnMouseEnter", function(self)
		  teleporterWin.guildHouseTexture:SetTexture(BMU.textures.guildHouseBtnOver)
		  BMU:tooltipTextEnter(teleporterWin.guildHouseTexture,
			  SI.get(SI.TELE_UI_BTN_GUILD_HOUSE_BMU))
	  end)

	  teleporterWin.guildHouseTexture:SetHandler("OnMouseExit", function(self)
		  teleporterWin.guildHouseTexture:SetTexture(BMU.textures.guildHouseBtn)
		  BMU:tooltipTextEnter(teleporterWin.guildHouseTexture)
	  end)
  end
  
  
  -------------------------------------------------------------------
	-- Lock/Fix window BUTTON
	local lockTexture

	teleporterWin.fixWindowTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
	teleporterWin.fixWindowTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
	teleporterWin.fixWindowTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, TOPRIGHT-65*BMU.savedVarsAcc.Scale, -75*BMU.savedVarsAcc.Scale)
	-- decide which texture to show
	if BMU.savedVarsAcc.fixedWindow == true then
		lockTexture = BMU.textures.lockClosedBtn
	else
		lockTexture = BMU.textures.lockOpenBtn
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
			lockTexture = BMU.textures.lockClosedBtnOver
		else
			-- show open lock over
			lockTexture = BMU.textures.lockOpenBtnOver
		end
		teleporterWin.fixWindowTexture:SetTexture(lockTexture)
	end)
	
	teleporterWin.fixWindowTexture:SetHandler("OnMouseEnter", function(self)
		if BMU.savedVarsAcc.fixedWindow then
			-- show closed lock over
			lockTexture = BMU.textures.lockClosedBtnOver
		else
			-- show open lock over
			lockTexture = BMU.textures.lockOpenBtnOver
		end
		teleporterWin.fixWindowTexture:SetTexture(lockTexture)
		BMU:tooltipTextEnter(teleporterWin.fixWindowTexture,SI.get(SI.TELE_UI_BTN_FIX_WINDOW))
	end)

	teleporterWin.fixWindowTexture:SetHandler("OnMouseExit", function(self)
		if BMU.savedVarsAcc.fixedWindow then
			-- show closed lock
			lockTexture = BMU.textures.lockClosedBtn
		else
			-- show open lock
			lockTexture = BMU.textures.lockOpenBtn
		end
		teleporterWin.fixWindowTexture:SetTexture(lockTexture)
		BMU:tooltipTextEnter(teleporterWin.fixWindowTexture)
	end)


  ---------------------------------------------------------------------------------------------------------------
  -- ANCHOR BUTTON

  teleporterWin.anchorTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.anchorTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.anchorTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, TOPRIGHT-20*BMU.savedVarsAcc.Scale, -75*BMU.savedVarsAcc.Scale)
  teleporterWin.anchorTexture:SetTexture(BMU.textures.anchorMapBtn)
  teleporterWin.anchorTexture:SetMouseEnabled(true)
  
  teleporterWin.anchorTexture:SetHandler("OnMouseUp", function()
	BMU.savedVarsAcc.anchorOnMap = not BMU.savedVarsAcc.anchorOnMap
    BMU.updatePosition()
  end)
	  
  teleporterWin.anchorTexture:SetHandler("OnMouseEnter", function(self)
	teleporterWin.anchorTexture:SetTexture(BMU.textures.anchorMapBtnOver)
      BMU:tooltipTextEnter(teleporterWin.anchorTexture,
          SI.get(SI.TELE_UI_BTN_ANCHOR_ON_MAP))
  end)

  teleporterWin.anchorTexture:SetHandler("OnMouseExit", function(self)
	if not BMU.savedVarsAcc.anchorOnMap then
		teleporterWin.anchorTexture:SetTexture(BMU.textures.anchorMapBtn)
	end
      BMU:tooltipTextEnter(teleporterWin.anchorTexture)
  end)

  
  -------------------------------------------------------------------
  -- CLOSE / SWAP BUTTON

  teleporterWin.closeTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.closeTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.closeTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, TOPRIGHT+25*BMU.savedVarsAcc.Scale, -75*BMU.savedVarsAcc.Scale)
  teleporterWin.closeTexture:SetTexture(BMU.textures.closeBtn)
  teleporterWin.closeTexture:SetMouseEnabled(true)
  teleporterWin.closeTexture:SetDrawLayer(2)

  teleporterWin.closeTexture:SetHandler("OnMouseUp", function()
      BMU.HideTeleporter()  end)
	  
  teleporterWin.closeTexture:SetHandler("OnMouseEnter", function(self)
	teleporterWin.closeTexture:SetTexture(BMU.textures.closeBtnOver)
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
   
  teleporterWin.SearchTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.SearchTexture:SetDimensions(25*BMU.savedVarsAcc.Scale, 25*BMU.savedVarsAcc.Scale)
  teleporterWin.SearchTexture:SetAnchor(TOPLEFT, teleporterWin.Main_Control, TOPLEFT, TOPLEFT-35*BMU.savedVarsAcc.Scale, -10*BMU.savedVarsAcc.Scale)

  teleporterWin.SearchTexture:SetTexture(BMU.textures.searchBtn)
  
  ---------------------------------------------------------------------------------------------------------------
  -- Searcher (Search for Players)
  
   teleporterWin.Searcher_Player = CreateControlFromVirtual("Teleporter_SEARCH_EDITBOX",  teleporterWin.Main_Control, "ZO_DefaultEditForBackdrop")
   teleporterWin.Searcher_Player:SetParent(teleporterWin.Main_Control)
   teleporterWin.Searcher_Player:SetSimpleAnchorParent(10*BMU.savedVarsAcc.Scale,-10*BMU.savedVarsAcc.Scale)
   teleporterWin.Searcher_Player:SetDimensions(105*BMU.savedVarsAcc.Scale,25*BMU.savedVarsAcc.Scale)
   teleporterWin.Searcher_Player:SetResizeToFitDescendents(false)
   teleporterWin.Searcher_Player:SetFont(BMU.font1)

	-- Placeholder
  	teleporterWin.Searcher_Player.Placeholder = wm:CreateControl("Teleporter_SEARCH_EDITBOX_Placeholder", teleporterWin.Searcher_Player, CT_LABEL)
    teleporterWin.Searcher_Player.Placeholder:SetSimpleAnchorParent(4*BMU.savedVarsAcc.Scale,0)
	teleporterWin.Searcher_Player.Placeholder:SetFont(BMU.font1)
	teleporterWin.Searcher_Player.Placeholder:SetText(BMU.colorizeText(GetString(SI_PLAYER_MENU_PLAYER), "lgray"))
    
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
	if self:HasFocus() and (teleporterWin.Searcher_Player:GetText() ~= "" or (teleporterWin.Searcher_Player:GetText() == "" and BMU.state == 2)) then
		-- make sure player placeholder is hidden
		teleporterWin.Searcher_Player.Placeholder:SetHidden(true)
		-- clear zone input field
		teleporterWin.Searcher_Zone:SetText("")
		-- show zone placeholder
		teleporterWin.Searcher_Zone.Placeholder:SetHidden(false)
		BMU.createTable({index=2, inputString=teleporterWin.Searcher_Player:GetText()})
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

  teleporterWin.Searcher_Zone = CreateControlFromVirtual("Teleporter_Searcher_Player_EDITBOX1",  teleporterWin.Main_Control, "ZO_DefaultEditForBackdrop")
  teleporterWin.Searcher_Zone:SetParent(teleporterWin.Main_Control)
  teleporterWin.Searcher_Zone:SetSimpleAnchorParent(140*BMU.savedVarsAcc.Scale,-10*BMU.savedVarsAcc.Scale)
  teleporterWin.Searcher_Zone:SetDimensions(105*BMU.savedVarsAcc.Scale,25*BMU.savedVarsAcc.Scale)
  teleporterWin.Searcher_Zone:SetResizeToFitDescendents(false)
  teleporterWin.Searcher_Zone:SetFont(BMU.font1)
  
  -- Placeholder
  teleporterWin.Searcher_Zone.Placeholder = wm:CreateControl("TTeleporter_Searcher_Player_EDITBOX1_Placeholder", teleporterWin.Searcher_Zone, CT_LABEL)
  teleporterWin.Searcher_Zone.Placeholder:SetSimpleAnchorParent(4*BMU.savedVarsAcc.Scale,0*BMU.savedVarsAcc.Scale)
  teleporterWin.Searcher_Zone.Placeholder:SetFont(BMU.font1)
  teleporterWin.Searcher_Zone.Placeholder:SetText(BMU.colorizeText(GetString(SI_CHAT_CHANNEL_NAME_ZONE), "lgray"))

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
		if self:HasFocus() and (teleporterWin.Searcher_Zone:GetText() ~= "" or (teleporterWin.Searcher_Zone:GetText() == "" and BMU.state == 3)) then
			-- make sure zone placeholder is hidden
			teleporterWin.Searcher_Zone.Placeholder:SetHidden(true)
			-- clear player input field
			teleporterWin.Searcher_Player:SetText("")
			-- show player placeholder
			teleporterWin.Searcher_Player.Placeholder:SetHidden(false)
			BMU.createTable({index=3, inputString=teleporterWin.Searcher_Zone:GetText()})
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
  
  teleporterWin.Main_Control.RefreshTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.RefreshTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.RefreshTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -80*BMU.savedVarsAcc.Scale, -5*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.RefreshTexture:SetTexture(BMU.textures.refreshBtn)
  teleporterWin.Main_Control.RefreshTexture:SetMouseEnabled(true)
  teleporterWin.Main_Control.RefreshTexture:SetDrawLayer(2)

  teleporterWin.Main_Control.RefreshTexture:SetHandler("OnMouseUp", function(self)
	if BMU.state == 0 then
		-- dont reset slider if user stays already on main list
		BMU.createTable({index=0, dontResetSlider=true})
	else
		BMU.createTable({index=0})
	end
  end)
  
  teleporterWin.Main_Control.RefreshTexture:SetHandler("OnMouseEnter", function(self)
      BMU:tooltipTextEnter(teleporterWin.Main_Control.RefreshTexture,
          SI.get(SI.TELE_UI_BTN_REFRESH_ALL))
      teleporterWin.Main_Control.RefreshTexture:SetTexture(BMU.textures.refreshBtnOver)end)

  teleporterWin.Main_Control.RefreshTexture:SetHandler("OnMouseExit", function(self)
      BMU:tooltipTextEnter(teleporterWin.Main_Control.RefreshTexture)
      teleporterWin.Main_Control.RefreshTexture:SetTexture(BMU.textures.refreshBtn)end)


  ---------------------------------------------------------------------------------------------------------------
  -- Unlock wayshrines

  teleporterWin.Main_Control.portalToAllTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.portalToAllTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.portalToAllTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -40*BMU.savedVarsAcc.Scale, -5*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.portalToAllTexture:SetTexture(BMU.textures.wayshrineBtn2)
  teleporterWin.Main_Control.portalToAllTexture:SetMouseEnabled(true)
  teleporterWin.Main_Control.portalToAllTexture:SetDrawLayer(2)
  
	teleporterWin.Main_Control.portalToAllTexture:SetHandler("OnMouseUp", function(self, button)
		BMU.showDialogAutoUnlock()
	end)
  
  teleporterWin.Main_Control.portalToAllTexture:SetHandler("OnMouseEnter", function(self)
	teleporterWin.Main_Control.portalToAllTexture:SetTexture(BMU.textures.wayshrineBtnOver2)
		local tooltipTextCompletion = ""
		if BMU.isZoneOverlandZone() then
			-- add wayshrine discovery info from ZoneGuide
			-- Attention: if the user is in Artaeum, he will see the total number of wayshrines (inclusive Summerset)
			-- however, when starting the auto unlock the function getZoneWayshrineCompletion() will check which wayshrines are really located on this map
			local zoneWayhsrineDiscoveryInfo, zoneWayshrineDiscovered, zoneWayshrineTotal = BMU.getZoneGuideDiscoveryInfo(GetZoneId(GetUnitZoneIndex("player")), ZONE_COMPLETION_TYPE_WAYSHRINES)
			if zoneWayhsrineDiscoveryInfo ~= nil then
				tooltipTextCompletion = "(" .. zoneWayshrineDiscovered .. "/" .. zoneWayshrineTotal .. ")"
				if zoneWayshrineDiscovered >= zoneWayshrineTotal then
					tooltipTextCompletion = BMU.colorizeText(tooltipTextCompletion, "green")
				end
			end
		end
		-- display number of unlocked wayshrines in current zone
		BMU:tooltipTextEnter(teleporterWin.Main_Control.portalToAllTexture, SI.get(SI.TELE_UI_BTN_UNLOCK_WS) .. " " .. tooltipTextCompletion)
	end)

  teleporterWin.Main_Control.portalToAllTexture:SetHandler("OnMouseExit", function(self)
	teleporterWin.Main_Control.portalToAllTexture:SetTexture(BMU.textures.wayshrineBtn2)
	BMU:tooltipTextEnter(teleporterWin.Main_Control.portalToAllTexture)
  end)
  
  
  ---------------------------------------------------------------------------------------------------------------
  -- Settings
  
  teleporterWin.Main_Control.SettingsTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.SettingsTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.SettingsTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, 0, -5*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.SettingsTexture:SetTexture(BMU.textures.settingsBtn)
  teleporterWin.Main_Control.SettingsTexture:SetMouseEnabled(true)
  teleporterWin.Main_Control.SettingsTexture:SetDrawLayer(2)

  teleporterWin.Main_Control.SettingsTexture:SetHandler("OnMouseUp", function(self)
	BMU.HideTeleporter()
	LAM2:OpenToPanel(BMU.SettingsPanel)
  end)
  
  teleporterWin.Main_Control.SettingsTexture:SetHandler("OnMouseEnter", function(self)
      BMU:tooltipTextEnter(teleporterWin.Main_Control.SettingsTexture,
          GetString(SI_GAME_MENU_SETTINGS))
      teleporterWin.Main_Control.SettingsTexture:SetTexture(BMU.textures.settingsBtnOver)
  end)

  teleporterWin.Main_Control.SettingsTexture:SetHandler("OnMouseExit", function(self)
      BMU:tooltipTextEnter(teleporterWin.Main_Control.SettingsTexture)
      teleporterWin.Main_Control.SettingsTexture:SetTexture(BMU.textures.settingsBtn)
  end)
	  

  ---------------------------------------------------------------------------------------------------------------
  -- "Port to Friends House" Integration
  
  teleporterWin.Main_Control.PTFTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.PTFTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.PTFTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -250*BMU.savedVarsAcc.Scale, 40*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.PTFTexture:SetTexture(BMU.textures.ptfHouseBtn)
  teleporterWin.Main_Control.PTFTexture:SetMouseEnabled(true)
  teleporterWin.Main_Control.PTFTexture:SetDrawLayer(2)
  
	if PortToFriend and PortToFriend.GetFavorites then
		-- enable tab	
		teleporterWin.Main_Control.PTFTexture:SetHandler("OnMouseUp", function(self, button)
			if button == MOUSE_BUTTON_INDEX_RIGHT then
				-- toggle between zoner names and house names
				ClearMenu()
				local menuIndex = AddCustomMenuItem(SI.get(SI.TELE_UI_TOOGLE_ZONE_NAME), function() BMU.savedVarsChar.ptfHouseZoneNames = not BMU.savedVarsChar.ptfHouseZoneNames BMU.clearInputFields() BMU.createTablePTF() end, MENU_ADD_OPTION_CHECKBOX)
				if BMU.savedVarsChar.ptfHouseZoneNames then
					ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
				end
				ShowMenu()
			else
				BMU.clearInputFields()
				BMU.createTablePTF()
			end
		end)
  
		teleporterWin.Main_Control.PTFTexture:SetHandler("OnMouseEnter", function(self)
			BMU:tooltipTextEnter(teleporterWin.Main_Control.PTFTexture, SI.get(SI.TELE_UI_BTN_PTF_INTEGRATION) .. SI.get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
			teleporterWin.Main_Control.PTFTexture:SetTexture(BMU.textures.ptfHouseBtnOver)
		end)

		teleporterWin.Main_Control.PTFTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin.Main_Control.PTFTexture)
			if BMU.state ~= 12 then
				teleporterWin.Main_Control.PTFTexture:SetTexture(BMU.textures.ptfHouseBtn)
			end
		end)
	else
		-- disable tab
		teleporterWin.Main_Control.PTFTexture:SetAlpha(0.4)
		
		teleporterWin.Main_Control.PTFTexture:SetHandler("OnMouseUp", function()
			BMU.showDialogSimple("PTFIntegrationMissing", SI.get(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE), SI.get(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY), function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info1758-PorttoFriendsHouse.html") end, nil)
		end)
		
		teleporterWin.Main_Control.PTFTexture:SetHandler("OnMouseEnter", function(self)
			BMU:tooltipTextEnter(teleporterWin.Main_Control.PTFTexture, SI.get(SI.TELE_UI_BTN_PTF_INTEGRATION))
		end)
		
		teleporterWin.Main_Control.PTFTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin.Main_Control.PTFTexture)
		end)
	end
	  
  ---------------------------------------------------------------------------------------------------------------
  -- Port to own Residences
  
  teleporterWin.Main_Control.OwnHouseTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.OwnHouseTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.OwnHouseTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -205*BMU.savedVarsAcc.Scale, 40*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.OwnHouseTexture:SetTexture(BMU.textures.houseBtn)
  teleporterWin.Main_Control.OwnHouseTexture:SetMouseEnabled(true)
  teleporterWin.Main_Control.OwnHouseTexture:SetDrawLayer(2)

  teleporterWin.Main_Control.OwnHouseTexture:SetHandler("OnMouseUp", function(self, button)
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- toggle between nicknames and standard names
		ClearMenu()
		local menuIndex = AddCustomMenuItem(SI.get(SI.TELE_UI_TOGGLE_HOUSE_NICKNAME), function() BMU.savedVarsChar.houseNickNames = not BMU.savedVarsChar.houseNickNames BMU.clearInputFields() BMU.createTableHouses() end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.houseNickNames then
			ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
		end
		ShowMenu()
	else
		BMU.clearInputFields()
		BMU.createTableHouses()
	end
  end)
  
  teleporterWin.Main_Control.OwnHouseTexture:SetHandler("OnMouseEnter", function(self)
    BMU:tooltipTextEnter(teleporterWin.Main_Control.OwnHouseTexture, SI.get(SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE) .. SI.get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin.Main_Control.OwnHouseTexture:SetTexture(BMU.textures.houseBtnOver)
  end)

  teleporterWin.Main_Control.OwnHouseTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin.Main_Control.OwnHouseTexture)
	if BMU.state ~= 11 then
		teleporterWin.Main_Control.OwnHouseTexture:SetTexture(BMU.textures.houseBtn)
	end
  end)

  
    ---------------------------------------------------------------------------------------------------------------
  -- Related Quests
  
  teleporterWin.Main_Control.QuestTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.QuestTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.QuestTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -160*BMU.savedVarsAcc.Scale, 40*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.QuestTexture:SetTexture(BMU.textures.questBtn)
  teleporterWin.Main_Control.QuestTexture:SetMouseEnabled(true)
  teleporterWin.Main_Control.QuestTexture:SetDrawLayer(2)

  teleporterWin.Main_Control.QuestTexture:SetHandler("OnMouseUp", function()
	BMU.createTable({index=9})
  end)
  
  teleporterWin.Main_Control.QuestTexture:SetHandler("OnMouseEnter", function(self)
    BMU:tooltipTextEnter(teleporterWin.Main_Control.QuestTexture, GetString(SI_JOURNAL_MENU_QUESTS))
    teleporterWin.Main_Control.QuestTexture:SetTexture(BMU.textures.questBtnOver)
  end)

  teleporterWin.Main_Control.QuestTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin.Main_Control.QuestTexture)
	if BMU.state ~= 9 then
		teleporterWin.Main_Control.QuestTexture:SetTexture(BMU.textures.questBtn)
	end
  end)
 
 
 ---------------------------------------------------------------------------------------------------------------
  -- Related Items
  
  teleporterWin.Main_Control.ItemTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.ItemTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.ItemTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -120*BMU.savedVarsAcc.Scale, 40*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.ItemTexture:SetTexture(BMU.textures.relatedItemsBtn)
  teleporterWin.Main_Control.ItemTexture:SetMouseEnabled(true)
  teleporterWin.Main_Control.ItemTexture:SetDrawLayer(2)

  teleporterWin.Main_Control.ItemTexture:SetHandler("OnMouseUp", function(self, button)
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show filter menu
		ClearMenu()
		-- Leads
		local menuIndex = AddCustomMenuItem(GetString(SI_ANTIQUITY_LEAD_TOOLTIP_TAG), function() BMU.savedVarsChar.displayLeads = not BMU.savedVarsChar.displayLeads BMU.createTable({index=4}) end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
		if BMU.savedVarsChar.displayLeads then
			ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
		end
		-- Clues
		local menuIndex = AddCustomMenuItem(GetString(SI_SPECIALIZEDITEMTYPE113), function() BMU.savedVarsChar.displayMaps.clue = not BMU.savedVarsChar.displayMaps.clue BMU.createTable({index=4}) end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
		if BMU.savedVarsChar.displayMaps.clue then
			ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
		end
		-- Treasure Maps
		menuIndex = AddCustomMenuItem(GetString(SI_SPECIALIZEDITEMTYPE100), function() BMU.savedVarsChar.displayMaps.treasure = not BMU.savedVarsChar.displayMaps.treasure BMU.createTable({index=4}) end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
		if BMU.savedVarsChar.displayMaps.treasure then
			ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
		end
		
		-- All Survey Maps
		BMU.menuIndexSurveyAll = AddCustomMenuItem(GetString(SI_SPECIALIZEDITEMTYPE101) .. BMU.getContextMenuEntrySurveyAllAppendix(),
			function()
				if ZO_CheckButton_IsChecked(ZO_Menu.items[BMU.menuIndexSurveyAll].checkbox) then
					-- check all subTypes
					BMU.updateCheckboxSurveyMap(1)
				else
					-- uncheck all subTypes
					BMU.updateCheckboxSurveyMap(2)
				end
				BMU.createTable({index=4})
			end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 4)
			
		if BMU.numOfSurveyTypesChecked() > 0 then
			ZO_CheckButton_SetChecked(ZO_Menu.items[BMU.menuIndexSurveyAll].checkbox)
		end
		
		-- Add submenu for survey types filter
		AddCustomSubMenuItem(GetString(SI_GAMEPAD_BANK_FILTER_HEADER),
			{
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY14),
					callback = function()
						BMU.savedVarsChar.displayMaps.alchemist = not BMU.savedVarsChar.displayMaps.alchemist
						BMU.updateCheckboxSurveyMap(3)
						BMU.createTable({index=4}) end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.alchemist end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY15),
					callback = function()
						BMU.savedVarsChar.displayMaps.enchanter = not BMU.savedVarsChar.displayMaps.enchanter
						BMU.updateCheckboxSurveyMap(3)
						BMU.createTable({index=4}) end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.enchanter end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY12),
					callback = function()
						BMU.savedVarsChar.displayMaps.woodworker = not BMU.savedVarsChar.displayMaps.woodworker
						BMU.updateCheckboxSurveyMap(3)
						BMU.createTable({index=4}) end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.woodworker end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY10),
					callback = function()
						BMU.savedVarsChar.displayMaps.blacksmith = not BMU.savedVarsChar.displayMaps.blacksmith
						BMU.updateCheckboxSurveyMap(3)
						BMU.createTable({index=4}) end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.blacksmith end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY11),
					callback = function()
						BMU.savedVarsChar.displayMaps.clothier = not BMU.savedVarsChar.displayMaps.clothier
						BMU.updateCheckboxSurveyMap(3)
						BMU.createTable({index=4}) end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.clothier end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY13),
					callback = function()
						BMU.savedVarsChar.displayMaps.jewelry = not BMU.savedVarsChar.displayMaps.jewelry
						BMU.updateCheckboxSurveyMap(3)
						BMU.createTable({index=4}) end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.jewelry end,
				},
			}, nil, nil, nil, 5
		)
		
		-- divider
		AddCustomMenuItem("-", function() end)
		
		menuIndex = AddCustomMenuItem(GetString(SI_CRAFTING_INCLUDE_BANKED), function() BMU.savedVarsChar.scanBankForMaps = not BMU.savedVarsChar.scanBankForMaps BMU.createTable({index=4}) end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 4)
		if BMU.savedVarsChar.scanBankForMaps then
			ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
		end
		ShowMenu()
	else
		BMU.createTable({index=4})
		BMU.showNotification(true)
	end
  end)
  
  teleporterWin.Main_Control.ItemTexture:SetHandler("OnMouseEnter", function(self)
	-- set tooltip accordingly to the selected filter
	local tooltip = ""

	if BMU.savedVarsChar.displayLeads then
		tooltip = GetString(SI_ANTIQUITY_LEAD_TOOLTIP_TAG)
	end
	if BMU.savedVarsChar.displayMaps.clue then
		if tooltip ~= "" then
			tooltip = tooltip .. " + " .. GetString(SI_SPECIALIZEDITEMTYPE113)
		else
			tooltip = GetString(SI_SPECIALIZEDITEMTYPE113)
		end
	end
	if BMU.savedVarsChar.displayMaps.treasure then
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
	tooltip = tooltip .. SI.get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU)
	
	-- show tooltip
    BMU:tooltipTextEnter(teleporterWin.Main_Control.ItemTexture, tooltip)
    -- button highlight
	teleporterWin.Main_Control.ItemTexture:SetTexture(BMU.textures.relatedItemsBtnOver)
  end)

  teleporterWin.Main_Control.ItemTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin.Main_Control.ItemTexture)
	if BMU.state ~= 4 then
		teleporterWin.Main_Control.ItemTexture:SetTexture(BMU.textures.relatedItemsBtn)
	end
  end)


  ---------------------------------------------------------------------------------------------------------------
  -- Only current zone

  teleporterWin.Main_Control.OnlyYourzoneTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.OnlyYourzoneTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.OnlyYourzoneTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -80*BMU.savedVarsAcc.Scale, 40*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.OnlyYourzoneTexture:SetTexture(BMU.textures.currentZoneBtn)
  teleporterWin.Main_Control.OnlyYourzoneTexture:SetMouseEnabled(true)
  teleporterWin.Main_Control.OnlyYourzoneTexture:SetDrawLayer(2)
  
	teleporterWin.Main_Control.OnlyYourzoneTexture:SetHandler("OnMouseUp", function(self)
		BMU.createTable({index=1})
	end)
  
    teleporterWin.Main_Control.OnlyYourzoneTexture:SetHandler("OnMouseEnter", function(self)
		BMU:tooltipTextEnter(teleporterWin.Main_Control.OnlyYourzoneTexture, GetString(SI_ANTIQUITY_SCRYABLE_CURRENT_ZONE_SUBCATEGORY))
		teleporterWin.Main_Control.OnlyYourzoneTexture:SetTexture(BMU.textures.currentZoneBtnOver)
	end)
	
	teleporterWin.Main_Control.OnlyYourzoneTexture:SetHandler("OnMouseExit", function(self)
		BMU:tooltipTextEnter(teleporterWin.Main_Control.OnlyYourzoneTexture)
		if BMU.state ~= 1 then
			teleporterWin.Main_Control.OnlyYourzoneTexture:SetTexture(BMU.textures.currentZoneBtn)
		end
	end)
	
	
  ---------------------------------------------------------------------------------------------------------------
  -- Delves in current zone
  
  teleporterWin.Main_Control.DelvesTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.DelvesTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.DelvesTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -40*BMU.savedVarsAcc.Scale, 40*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.DelvesTexture:SetTexture(BMU.textures.delvesBtn)
  teleporterWin.Main_Control.DelvesTexture:SetMouseEnabled(true)
  teleporterWin.Main_Control.DelvesTexture:SetDrawLayer(2)

  teleporterWin.Main_Control.DelvesTexture:SetHandler("OnMouseUp", function(self, button)
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show context menu
		ClearMenu()
		local menuIndex = AddCustomMenuItem(GetString(SI_GAMEPAD_GUILD_HISTORY_SUBCATEGORY_ALL), function() BMU.savedVarsChar.showAllDelves = not BMU.savedVarsChar.showAllDelves BMU.createTable({index=5}) end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.showAllDelves then
			ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
		end
		ShowMenu()
	else
		BMU.createTable({index=5})
	end
  end)
  
  teleporterWin.Main_Control.DelvesTexture:SetHandler("OnMouseEnter", function(self)
	local text = GetString(SI_ZONECOMPLETIONTYPE5)
	if not BMU.savedVarsChar.showAllDelves then
		text = text .. " - " .. GetString(SI_ANTIQUITY_SCRYABLE_CURRENT_ZONE_SUBCATEGORY)
	end
	BMU:tooltipTextEnter(teleporterWin.Main_Control.DelvesTexture, text .. SI.get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin.Main_Control.DelvesTexture:SetTexture(BMU.textures.delvesBtnOver)
  end)

  teleporterWin.Main_Control.DelvesTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin.Main_Control.DelvesTexture)
	if BMU.state ~= 5 then
		teleporterWin.Main_Control.DelvesTexture:SetTexture(BMU.textures.delvesBtn)
	end
  end)
  
  
    ---------------------------------------------------------------------------------------------------------------
  -- DUNGEON FINDER
  
  teleporterWin.Main_Control.DungeonTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.DungeonTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.DungeonTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, 0*BMU.savedVarsAcc.Scale, 40*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.DungeonTexture:SetTexture(BMU.textures.soloArenaBtn)
  teleporterWin.Main_Control.DungeonTexture:SetMouseEnabled(true)
  teleporterWin.Main_Control.DungeonTexture:SetDrawLayer(2)

  teleporterWin.Main_Control.DungeonTexture:SetHandler("OnMouseUp", function(self, button)
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show filter menu
		ClearMenu()
		-- add filters
		AddCustomSubMenuItem(GetString(SI_GAMEPAD_BANK_FILTER_HEADER),
			{
				{
					label = SI.get(SI.TELE_UI_TOGGLE_ENDLESS_DUNGEONS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showEndlessDungeons = not BMU.savedVarsChar.dungeonFinder.showEndlessDungeons BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showEndlessDungeons end,
				},
				{
					label = SI.get(SI.TELE_UI_TOGGLE_ARENAS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showArenas = not BMU.savedVarsChar.dungeonFinder.showArenas BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showArenas end,
				},
				{
					label = SI.get(SI.TELE_UI_TOGGLE_GROUP_ARENAS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showGroupArenas = not BMU.savedVarsChar.dungeonFinder.showGroupArenas BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showGroupArenas end,
				},
				{
					label = SI.get(SI.TELE_UI_TOGGLE_TRIALS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showTrials = not BMU.savedVarsChar.dungeonFinder.showTrials BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showTrials end,
				},
				{
					label = SI.get(SI.TELE_UI_TOGGLE_GROUP_DUNGEONS),
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
					label = SI.get(SI.TELE_UI_TOGGLE_SORT_RELEASE) .. BMU.textures.arrowUp,
					callback = function()
						BMU.savedVarsChar.dungeonFinder.sortByReleaseASC = true
						BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC = false
						BMU.savedVarsChar.dungeonFinder.sortByAcronym = false
						BMU.clearInputFields()
						BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.sortByReleaseASC end,
				},
				-- sort by release: from new (top of list) to old
				{
					label = SI.get(SI.TELE_UI_TOGGLE_SORT_RELEASE) .. BMU.textures.arrowDown,
					callback = function()
						BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC = true
						BMU.savedVarsChar.dungeonFinder.sortByReleaseASC = false
						BMU.savedVarsChar.dungeonFinder.sortByAcronym = false
						BMU.clearInputFields()
						BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC end,
				},
				-- sort by acronym
				{
					label = SI.get(SI.TELE_UI_TOGGLE_SORT_ACRONYM),
					callback = function()
						BMU.savedVarsChar.dungeonFinder.sortByAcronym = true
						BMU.savedVarsChar.dungeonFinder.sortByReleaseASC = false
						BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC = false
						BMU.clearInputFields()
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
					label = SI.get(SI.TELE_UI_TOGGLE_UPDATE_NAME),
					callback = function() BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName = not BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName BMU.clearInputFields() BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return not BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName end,
				},
				{
					label = SI.get(SI.TELE_UI_TOGGLE_ACRONYM),
					callback = function() BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName = not BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName BMU.clearInputFields() BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName end,
				},
				{
					label = "-",
				},
				{
					label = SI.get(SI.TELE_UI_TOOGLE_DUNGEON_NAME),
					callback = function() BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName = not BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName BMU.clearInputFields() BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return not BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName end,
				},
				{
					label = SI.get(SI.TELE_UI_TOOGLE_ZONE_NAME),
					callback = function() BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName = not BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName BMU.clearInputFields() BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName end,
				},
			}, nil, nil, nil, 5
		)
			
		-- add dungeon difficulty toggle
		if CanPlayerChangeGroupDifficulty() then
			local menuIndex = AddCustomMenuItem(BMU.textures.dungeonDifficultyVeteran .. GetString(SI_DUNGEONDIFFICULTY2), function() BMU.setDungeonDifficulty(not ZO_ConvertToIsVeteranDifficulty(ZO_GetEffectiveDungeonDifficulty())) zo_callLater(function() BMU.createTableDungeons() end, 300) end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
			if ZO_ConvertToIsVeteranDifficulty(ZO_GetEffectiveDungeonDifficulty()) then
				ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
			end
		end
		ShowMenu()
	else
		BMU.clearInputFields()
		BMU.createTableDungeons()
	end
  end)
  
  teleporterWin.Main_Control.DungeonTexture:SetHandler("OnMouseEnter", function(self)
	BMU:tooltipTextEnter(teleporterWin.Main_Control.DungeonTexture, SI.get(SI.TELE_UI_BTN_DUNGEON_FINDER) .. SI.get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin.Main_Control.DungeonTexture:SetTexture(BMU.textures.soloArenaBtnOver)
  end)

  teleporterWin.Main_Control.DungeonTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin.Main_Control.DungeonTexture)
	if BMU.state ~= 14 then
		teleporterWin.Main_Control.DungeonTexture:SetTexture(BMU.textures.soloArenaBtn)
	end
  end)
	  
end


function BMU.updateCheckboxSurveyMap(action)
	if action == 3 then
		-- check if at least one of the subTypes is checked
		if BMU.numOfSurveyTypesChecked() > 0 then
			ZO_CheckButton_SetChecked(ZO_Menu.items[BMU.menuIndexSurveyAll].checkbox)
		else
			-- no survey type is checked
			ZO_CheckButton_SetUnchecked(ZO_Menu.items[BMU.menuIndexSurveyAll].checkbox)
		end
	else
		-- if action == 1 --> all are checked
		-- else (action == 2) --> all are unchecked
		for _, subType in pairs({'alchemist', 'enchanter', 'woodworker', 'blacksmith', 'clothier', 'jewelry'}) do
			BMU.savedVarsChar.displayMaps[subType] = (action == 1)
		end
	end
	BMU.updateContextMenuEntrySurveyAll()
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


function BMU.updateContextMenuEntrySurveyAll()
	local num = BMU.numOfSurveyTypesChecked()
	local baseString = string.sub(ZO_Menu.items[BMU.menuIndexSurveyAll].item.nameLabel:GetText(), 1, -7)
	ZO_Menu.items[BMU.menuIndexSurveyAll].item.nameLabel:SetText(baseString .. BMU.getContextMenuEntrySurveyAllAppendix())
end


function BMU.getContextMenuEntrySurveyAllAppendix()
	local num = BMU.numOfSurveyTypesChecked()
	local appendix = " (" .. num .. "/6)"
	return appendix
end


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
			teleporterWin.anchorTexture:SetTexture(BMU.textures.anchorMapBtnOver)
		else
			-- use saved pos when map is open
			BMU.control_global.bd:ClearAnchors()
			BMU.control_global.bd:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LEFT + BMU.savedVarsAcc.pos_MapScene_x, BMU.savedVarsAcc.pos_MapScene_y)
			-- set fix/unfix state
			BMU.control_global.bd:SetMovable(not BMU.savedVarsAcc.fixedWindow)
			-- show fix/unfix button
			teleporterWin.fixWindowTexture:SetHidden(false)
			-- set anchor button texture
			teleporterWin.anchorTexture:SetTexture(BMU.textures.anchorMapBtn)
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
		teleporterWin.closeTexture:SetTexture(BMU.textures.swapBtn)
		teleporterWin.closeTexture:SetHandler("OnMouseEnter", function(self)
			teleporterWin.closeTexture:SetTexture(BMU.textures.swapBtnOver)
			BMU:tooltipTextEnter(teleporterWin.closeTexture,
				SI.get(SI.TELE_UI_BTN_TOGGLE_BMU))
		end)
		teleporterWin.closeTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin.closeTexture)
			teleporterWin.closeTexture:SetTexture(BMU.textures.swapBtn)
		end)
		
	else
		-- show normal close button
		-- set textures and handlers
		teleporterWin.closeTexture:SetTexture(BMU.textures.closeBtn)
		teleporterWin.closeTexture:SetHandler("OnMouseEnter", function(self)
		teleporterWin.closeTexture:SetTexture(BMU.textures.closeBtnOver)
			BMU:tooltipTextEnter(teleporterWin.closeTexture,
				GetString(SI_DIALOG_CLOSE))
		end)
		teleporterWin.closeTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin.closeTexture)
			teleporterWin.closeTexture:SetTexture(BMU.textures.closeBtn)
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



-- display the correct persistent MouseOver depending on Button
-- also set global state for auto refresh
function BMU.changeState(index)
	if BMU.debugMode == 1 then
		-- debug mode
		BMU.printToChat("Changed - state: " .. tostring(index))
	end
    local teleporterWin     = BMU.win

	-- first disable all MouseOver
	teleporterWin.Main_Control.ItemTexture:SetTexture(BMU.textures.relatedItemsBtn)
	teleporterWin.Main_Control.OnlyYourzoneTexture:SetTexture(BMU.textures.currentZoneBtn)
	teleporterWin.Main_Control.DelvesTexture:SetTexture(BMU.textures.delvesBtn)
	teleporterWin.SearchTexture:SetTexture(BMU.textures.searchBtn)
	teleporterWin.Main_Control.QuestTexture:SetTexture(BMU.textures.questBtn)
	teleporterWin.Main_Control.OwnHouseTexture:SetTexture(BMU.textures.houseBtn)
	teleporterWin.Main_Control.PTFTexture:SetTexture(BMU.textures.ptfHouseBtn)
	teleporterWin.Main_Control.DungeonTexture:SetTexture(BMU.textures.soloArenaBtn)
	if teleporterWin.guildTexture then
		teleporterWin.guildTexture:SetTexture(BMU.textures.guildBtn)
	end
	
	-- check new state
	if index == 4 then
		-- related Items
		teleporterWin.Main_Control.ItemTexture:SetTexture(BMU.textures.relatedItemsBtnOver)
	elseif index == 1 then
		-- current zone
		teleporterWin.Main_Control.OnlyYourzoneTexture:SetTexture(BMU.textures.currentZoneBtnOver)
	elseif index == 5 then
		-- current zone delves
		teleporterWin.Main_Control.DelvesTexture:SetTexture(BMU.textures.delvesBtnOver)
	elseif index == 2 or index == 3 then
		-- serach by player name or zone name
		teleporterWin.SearchTexture:SetTexture(BMU.textures.searchBtnOver)
	elseif index == 9 then
		-- related quests
		teleporterWin.Main_Control.QuestTexture:SetTexture(BMU.textures.questBtnOver)
	elseif index == 11 then
		-- own houses
		teleporterWin.Main_Control.OwnHouseTexture:SetTexture(BMU.textures.houseBtnOver)
	elseif index == 12 then
		-- PTF houses
		teleporterWin.Main_Control.PTFTexture:SetTexture(BMU.textures.ptfHouseBtnOver)
	elseif index == 13 then
		-- guilds
		if teleporterWin.guildTexture then
			teleporterWin.guildTexture:SetTexture(BMU.textures.guildBtnOver)
		end
	elseif index == 14 then
		-- dungeon finder
		teleporterWin.Main_Control.DungeonTexture:SetTexture(BMU.textures.soloArenaBtnOver)
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
	dialogReference = ZO_Dialogs_ShowDialog(globalDialogName)
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
				local result = BMU.createTable({index=2, inputString=playerTo, dontDisplay=true})
				local firstRecord = result[1]
				if firstRecord.displayName == "" then
					-- player not found
					BMU.printToChat(playerTo .. " - " .. GetString(SI_FASTTRAVELKEEPRESULT9))
				else
					BMU.printToChat(SI.get(SI.TELE_CHAT_SHARING_FOLLOW_LINK))
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
				BMU.printToChat(SI.get(SI.TELE_CHAT_SHARING_FOLLOW_LINK))
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
			ZO_WorldMap_SetMapByIndex(1)
			ZO_WorldMap_SetMapByIndex(mapIndex)
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
	for _, guildId in pairs(BMU.var.BMUGuilds[GetWorldName()]) do
		local guildData = GUILD_BROWSER_MANAGER:GetGuildData(guildId)
		if guildId and guildData and guildData.size and guildData.size < 495 then
			ZO_LinkHandler_OnLinkClicked("|H1:guild:" .. guildId .. "|hBeamMeUp Guild|h", 1, nil)
			return
		end
	end
	-- just redirect to latest BMU guild
	ZO_LinkHandler_OnLinkClicked("|H1:guild:" .. BMU.var.BMUGuilds[GetWorldName()][#BMU.var.BMUGuilds[GetWorldName()]] .. "|hBeamMeUp Guild|h", 1, nil)
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
		CENTER_SCREEN_ANNOUNCE:AddMessage(0, CSA_CATEGORY_MAJOR_TEXT, SOUNDS.DEFER_NOTIFICATION, "Favorite Player Switched Status", BMU.colorizeText(displayName, "gold") .. " " .. BMU.colorizeText(SI.get(SI.TELE_CENTERSCREEN_FAVORITE_PLAYER_ONLINE), "white"), "esoui/art/mainmenu/menubar_social_up.dds", "EsoUI/Art/Achievements/achievements_iconBG.dds", nil, nil, 4000)
	end
end

--[[
-- Show Note, when player sends a whisper message and is offline -> player cannot receive any whisper messages
function BMU.HintOfflineWhisper(eventCode, messageType, from, test, isFromCustomerService, _)
	if BMU.savedVarsAcc.HintOfflineWhisper and messageType == CHAT_CHANNEL_WHISPER_SENT and GetPlayerStatus() == PLAYER_STATUS_OFFLINE then
		BMU.printToChat(BMU.colorizeText(SI.get(SI.TELE_CHAT_WHISPER_NOTE), "red"))
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
					CENTER_SCREEN_ANNOUNCE:AddMessage(0, CSA_CATEGORY_MAJOR_TEXT, sound, "Survey Maps Note", string.format(SI.get(SI.TELE_CENTERSCREEN_SURVEY_MAPS), slotData.stackCount-1), "esoui/art/icons/quest_scroll_001.dds", "EsoUI/Art/Achievements/achievements_iconBG.dds", nil, nil, 5000)
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
	if BMU.var.BMUGuilds[GetWorldName()] ~= nil then
		guildsQueue = BMU.var.BMUGuilds[GetWorldName()]
	end
	-- partner guilds
	if BMU.var.partnerGuilds[GetWorldName()] ~= nil then
		guildsQueue = BMU.mergeTables(guildsQueue, BMU.var.partnerGuilds[GetWorldName()])
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
		if BMU.var.BMUGuilds[GetWorldName()] ~= nil then
			for _, guildId in pairs(BMU.var.BMUGuilds[GetWorldName()]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.displayName) then
					table.insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.displayName) end,
											})
				end
			end
		end
		
		-- invite to partner guilds
		if BMU.var.partnerGuilds[GetWorldName()] ~= nil then
			for _, guildId in pairs(BMU.var.partnerGuilds[GetWorldName()]) do
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
		if BMU.var.BMUGuilds[GetWorldName()] ~= nil then
			for _, guildId in pairs(BMU.var.BMUGuilds[GetWorldName()]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.name) then
					table.insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.name) end,
											})
				end
			end
		end
		
		-- invite to partner guilds
		if BMU.var.partnerGuilds[GetWorldName()] ~= nil then
			for _, guildId in pairs(BMU.var.partnerGuilds[GetWorldName()]) do
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
	
	if GetGuildMemberIndexFromDisplayName(BMU.var.BMUGuilds[GetWorldName()][1], displayName) then
		text = text .. " 1 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU.var.BMUGuilds[GetWorldName()][2], displayName) then
		text = text .. " 2 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU.var.BMUGuilds[GetWorldName()][3], displayName) then
		text = text .. " 3 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU.var.BMUGuilds[GetWorldName()][4], displayName) then
		text = text .. " 4 "
	end
	
	if text ~= "" then
		-- already member
		return true, BMU.colorizeText("Bereits Mitglied in " .. text, "red")
	else
		-- not a member or admin is not member of the BMU guilds
		return false, BMU.colorizeText("Neues Mitglied", "green")
	end
end

function BMU.AdminIsBMUGuild(guildId)
	if BMU.has_value(BMU.var.BMUGuilds[GetWorldName()], guildId) then
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
	autoFill_1:SetText(BMU.colorizeText("BMU_AM", "gold"))
	autoFill_1:SetMouseEnabled(true)
	autoFill_1:SetHandler("OnMouseUp", function(self)
		ZO_ConfirmDeclineApplicationDialog_KeyboardDeclineMessageEdit:SetText("You are already a member of one of our other BMU guilds. Sorry, but we only allow joining one guild. You are welcome to join and support our partner guilds (flag button in the upper left corner).")
	end)
	-- message when player is already in 5 guilds
	local autoFill_2 = WINDOW_MANAGER:CreateControl(nil, ZO_ConfirmDeclineApplicationDialog_Keyboard, CT_LABEL)
	autoFill_2:SetAnchor(TOPRIGHT, ZO_ConfirmDeclineApplicationDialog_Keyboard, TOPRIGHT, -5, 40)
	autoFill_2:SetFont(font)
	autoFill_2:SetText(BMU.colorizeText("BMU_5G", "gold"))
	autoFill_2:SetMouseEnabled(true)
	autoFill_2:SetHandler("OnMouseUp", function(self)
		ZO_ConfirmDeclineApplicationDialog_KeyboardDeclineMessageEdit:SetText("We cannot accpect your application because you have already joined 5 other guilds (which is the maximum). If you want to join us, please submit a new application with free guild slot.")
	end)
end

