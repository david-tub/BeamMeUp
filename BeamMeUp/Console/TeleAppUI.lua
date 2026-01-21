local BG = BMU.BG
local LHAS = BG.LHAS
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

    BMU.SettingsPanel = LHAS:AddAddon(appName .. "Options", {
      allowDefaults = false,  -- Show "Reset to Defaults" button
      allowRefresh = false    -- Enable automatic control updates
    })
	
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
              type = LHAS.ST_SLIDER,
              label = SI.get(SI.TELE_SETTINGS_NUMBER_LINES),
              tooltip = SI.get(SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP) .. " [DEFAULT: " .. BMU.DefaultsAccount["numberLines"] .. "]",
              min = 6,
              max = 16,
              getFunc = function() return BMU.savedVarsAcc.numberLines end,
              setFunc = function(value) BMU.savedVarsAcc.numberLines = value
							teleporterWin.Main_Control:SetHeight(BMU.calculateListHeight())
							-- add also current height of the counter panel
							teleporterWin.Main_Control.bd:SetHeight(BMU.calculateListHeight() + 280*BMU.savedVarsAcc.Scale + select(2, BMU.counterPanel:GetTextDimensions()))
				end,
			  default = BMU.DefaultsAccount["numberLines"],
         },
         {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN),
              tooltip = SI.get(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["ShowOnMapOpen"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.ShowOnMapOpen end,
              setFunc = function(value) BMU.savedVarsAcc.ShowOnMapOpen = value end,
			  default = BMU.DefaultsAccount["ShowOnMapOpen"],
         },
         {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["HideOnMapClose"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.HideOnMapClose end,
              setFunc = function(value) BMU.savedVarsAcc.HideOnMapClose = value end,
			  default = BMU.DefaultsAccount["HideOnMapClose"],
         },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_CLOSE_ON_PORTING),
              tooltip = SI.get(SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["closeOnPorting"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.closeOnPorting end,
              setFunc = function(value) BMU.savedVarsAcc.closeOnPorting = value end,
			  default = BMU.DefaultsAccount["closeOnPorting"],
		 },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_WINDOW_STAY),
              tooltip = SI.get(SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["windowStay"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.windowStay end,
              setFunc = function(value) BMU.savedVarsAcc.windowStay = value end,
			  default = BMU.DefaultsAccount["windowStay"],
		 },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN),
              tooltip = SI.get(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["focusZoneSearchOnOpening"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.focusZoneSearchOnOpening end,
              setFunc = function(value) BMU.savedVarsAcc.focusZoneSearchOnOpening = value end,
			  default = BMU.DefaultsAccount["focusZoneSearchOnOpening"],
         },
		 {
              type = LHAS.ST_SLIDER,
              label = SI.get(SI.TELE_SETTINGS_AUTO_PORT_FREQ),
              tooltip = SI.get(SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP) .. " [DEFAULT: " .. BMU.DefaultsAccount["AutoPortFreq"] .. "]",
              min = 50,
              max = 500,
              getFunc = function() return BMU.savedVarsAcc.AutoPortFreq end,
              setFunc = function(value) BMU.savedVarsAcc.AutoPortFreq = value end,
			  default = BMU.DefaultsAccount["AutoPortFreq"],
         },
		 {
              type = LHAS.ST_SECTION,
              label = ""
         },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP),
              tooltip = SI.get(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["showOpenButtonOnMap"]) .. "]",
			        getFunc = function() return BMU.savedVarsAcc.showOpenButtonOnMap end,
              setFunc = function(value)
                BMU.savedVarsAcc.showOpenButtonOnMap = value
                ReloadUI("ingame")
              end,
			  default = BMU.DefaultsAccount["showOpenButtonOnMap"],
         },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON),
              tooltip = SI.get(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["chatButton"]) .. "]",
			        getFunc = function() return BMU.savedVarsAcc.chatButton end,
              setFunc = function(value)
                BMU.savedVarsAcc.chatButton = value
                ReloadUI("ingame")
              end,
			  default = BMU.DefaultsAccount["chatButton"],
         },
		 {
              type = LHAS.ST_SLIDER,
              label = SI.get(SI.TELE_SETTINGS_SCALE),
			  tooltip = SI.get(SI.TELE_SETTINGS_SCALE_TOOLTIP) .. " [DEFAULT: " .. BMU.DefaultsAccount["Scale"] .. "]",
			  min = 0.7,
			  max = 1.4,
			  step = 0.05,
			  format = "%.2f",
              getFunc = function() return BMU.savedVarsAcc.Scale end,
              setFunc = function(value)
                BMU.savedVarsAcc.Scale = value
                ReloadUI("ingame")
              end,
			  default = BMU.DefaultsAccount["Scale"],
         },
		 {
              type = LHAS.ST_SLIDER,
              label = SI.get(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET),
              tooltip = SI.get(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP) .. " [DEFAULT: " .. BMU.DefaultsAccount["chatButtonHorizontalOffset"] .. "]",
              min = 0,
              max = 200,
              getFunc = function() return BMU.savedVarsAcc.chatButtonHorizontalOffset end,
              setFunc = function(value) BMU.savedVarsAcc.chatButtonHorizontalOffset = value
							BMU.chatButtonTex:SetAnchor(TOPRIGHT, ZO_ChatWindow, TOPRIGHT, -40 - BMU.savedVarsAcc.chatButtonHorizontalOffset, 6)
						end,
			  default = BMU.DefaultsAccount["chatButtonHorizontalOffset"],
			  disabled = function() return not BMU.savedVarsAcc.chatButton or not BMU.chatButtonTex end,
         },
		 {
              type = LHAS.ST_SLIDER,
              label = SI.get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL),
              tooltip = SI.get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP) .. " [DEFAULT: " .. BMU.DefaultsAccount["anchorMapOffset_x"] .. "]",
			        min = -100,
              max = 100,
              getFunc = function() return BMU.savedVarsAcc.anchorMapOffset_x end,
              setFunc = function(value) BMU.savedVarsAcc.anchorMapOffset_x = value end,
			  default = BMU.DefaultsAccount["anchorMapOffset_x"],
         },
		 {
              type = LHAS.ST_SLIDER,
              label = SI.get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL),
			  tooltip = SI.get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP) .. " [DEFAULT: " .. BMU.DefaultsAccount["anchorMapOffset_y"] .. "]",
			  min = -150,
			  max = 150,
              getFunc = function() return BMU.savedVarsAcc.anchorMapOffset_y end,
              setFunc = function(value) BMU.savedVarsAcc.anchorMapOffset_y = value end,
			  default = BMU.DefaultsAccount["anchorMapOffset_y"],
         },
		 {
              type = LHAS.ST_BUTTON,
              label = SI.get(SI.TELE_SETTINGS_RESET_UI),
			  tooltip = SI.get(SI.TELE_SETTINGS_RESET_UI_TOOLTIP),
			  clickHandler = function() BMU.savedVarsAcc.Scale = BMU.DefaultsAccount["Scale"]
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
         },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_AUTO_REFRESH),
              tooltip = SI.get(SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["autoRefresh"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.autoRefresh end,
              setFunc = function(value) BMU.savedVarsAcc.autoRefresh = value end,
			  default = BMU.DefaultsAccount["autoRefresh"],
         },
		 {
              type = LHAS.ST_DROPDOWN,
              label = SI.get(SI.TELE_SETTINGS_SORTING),
              tooltip = SI.get(SI.TELE_SETTINGS_SORTING_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownSortChoices[BMU.DefaultsCharacter["sorting"]] .. "]",
			  items = BMU.dropdownSortItems,
              getFunc = function() return BMU.savedVarsChar.sorting end,
			  setFunc = function(value) BMU.savedVarsChar.sorting = value end,
			  default = BMU.DefaultsCharacter["sorting"],
        },
		{
			type = LHAS.ST_DROPDOWN,
			label = SI.get(SI.TELE_SETTINGS_DEFAULT_TAB),
			tooltip = SI.get(SI.TELE_SETTINGS_DEFAULT_TAB_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownDefaultTabChoices[BMU.getIndexFromValue(BMU.dropdownDefaultTabValues, BMU.DefaultsCharacter["defaultTab"])] .. "]",
			items = BMU.dropdownDefaultTabItems,
			getFunc = function() return BMU.savedVarsChar.defaultTab end,
			setFunc = function(value) BMU.savedVarsChar.defaultTab = value end,
			default = BMU.DefaultsCharacter["defaultTab"],
			disabled = function() return not BMU.savedVarsAcc.autoRefresh end,
		 },
         {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS),
              tooltip = SI.get(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["showNumberPlayers"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.showNumberPlayers end,
              setFunc = function(value) BMU.savedVarsAcc.showNumberPlayers = value end,
			  default = BMU.DefaultsAccount["showNumberPlayers"],
			  		 },
         {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES),
              tooltip = SI.get(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["searchCharacterNames"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.searchCharacterNames end,
              setFunc = function(value) BMU.savedVarsAcc.searchCharacterNames = value end,
			  default = BMU.DefaultsAccount["searchCharacterNames"],
			  		 },		 
         {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_ZONE_ONCE_ONLY),
              tooltip = SI.get(SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["zoneOnceOnly"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.zoneOnceOnly end,
              setFunc = function(value) BMU.savedVarsAcc.zoneOnceOnly = value end,
			  default = BMU.DefaultsAccount["zoneOnceOnly"],
			  		 },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP),
              tooltip = SI.get(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["currentZoneAlwaysTop"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.currentZoneAlwaysTop end,
              setFunc = function(value) BMU.savedVarsAcc.currentZoneAlwaysTop = value end,
			  default = BMU.DefaultsAccount["currentZoneAlwaysTop"],
			  		 },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP),
              tooltip = SI.get(SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["currentViewedZoneAlwaysTop"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.currentViewedZoneAlwaysTop end,
              setFunc = function(value) BMU.savedVarsAcc.currentViewedZoneAlwaysTop = value end,
			  default = BMU.DefaultsAccount["currentViewedZoneAlwaysTop"],
			  		 },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_FORMAT_ZONE_NAME),
              tooltip = SI.get(SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["formatZoneName"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.formatZoneName end,
              setFunc = function(value) BMU.savedVarsAcc.formatZoneName = value end,
			  default = BMU.DefaultsAccount["formatZoneName"],
			           },
		 {
              type = LHAS.ST_SLIDER,
              label = SI.get(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ),
              tooltip = SI.get(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP) .. " [DEFAULT: " .. BMU.DefaultsAccount["autoRefreshFreq"] .. "]",
              min = 0,
              max = 15,
              getFunc = function() return BMU.savedVarsAcc.autoRefreshFreq end,
              setFunc = function(value) BMU.savedVarsAcc.autoRefreshFreq = value end,
			  default = BMU.DefaultsAccount["autoRefreshFreq"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS),
              tooltip = SI.get(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["showZonesWithoutPlayers2"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.showZonesWithoutPlayers2 end,
              setFunc = function(value) BMU.savedVarsAcc.showZonesWithoutPlayers2 = value end,
			  default = BMU.DefaultsAccount["showZonesWithoutPlayers2"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_ONLY_MAPS),
              tooltip = SI.get(SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["onlyMaps"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.onlyMaps end,
              setFunc = function(value) BMU.savedVarsAcc.onlyMaps = value end,
			  default = BMU.DefaultsAccount["onlyMaps"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_HIDE_OTHERS),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["hideOthers"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.hideOthers end,
              setFunc = function(value) BMU.savedVarsAcc.hideOthers = value end,
			  disabled = function() return BMU.savedVarsAcc.onlyMaps end,
			  default = BMU.DefaultsAccount["hideOthers"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_HIDE_PVP),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["hidePVP"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.hidePVP end,
              setFunc = function(value) BMU.savedVarsAcc.hidePVP = value end,
			  disabled = function() return BMU.savedVarsAcc.onlyMaps end,
			  default = BMU.DefaultsAccount["hidePVP"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["hideClosedDungeons"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.hideClosedDungeons end,
              setFunc = function(value) BMU.savedVarsAcc.hideClosedDungeons = value end,
			  disabled = function() return BMU.savedVarsAcc.onlyMaps end,
			  default = BMU.DefaultsAccount["hideClosedDungeons"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_HIDE_DELVES),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["hideDelves"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.hideDelves end,
              setFunc = function(value) BMU.savedVarsAcc.hideDelves = value end,
			  disabled = function() return BMU.savedVarsAcc.onlyMaps end,
			  default = BMU.DefaultsAccount["hideDelves"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["hidePublicDungeons"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.hidePublicDungeons end,
              setFunc = function(value) BMU.savedVarsAcc.hidePublicDungeons = value end,
			  disabled = function() return BMU.savedVarsAcc.onlyMaps end,
			  default = BMU.DefaultsAccount["hidePublicDungeons"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_HIDE_HOUSES),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["hideHouses"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.hideHouses end,
              setFunc = function(value) BMU.savedVarsAcc.hideHouses = value end,
			  disabled = function() return BMU.savedVarsAcc.onlyMaps end,
			  default = BMU.DefaultsAccount["hideHouses"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_HIDE_OWN_HOUSES),
              tooltip = SI.get(SI.TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["hideOwnHouses"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.hideOwnHouses end,
              setFunc = function(value) BMU.savedVarsAcc.hideOwnHouses = value end,
			  default = BMU.DefaultsAccount["hideOwnHouses"],
			           },
		 {
              type = LHAS.ST_LABEL,
              label = SI.get(SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION),
			           },
         {
              type = LHAS.ST_DROPDOWN,
			  label = "PRIO 1",
              tooltip = "",
			  items = BMU.dropdownPrioSourceItems,
              getFunc = function() return BMU.savedVarsServ.prioritizationSource[1] end,
			  setFunc = function(value)
				-- swap positions
				local index = BMU.getIndexFromValue(BMU.savedVarsServ.prioritizationSource, value)
				BMU.savedVarsServ.prioritizationSource[index] = BMU.savedVarsServ.prioritizationSource[1]
				BMU.savedVarsServ.prioritizationSource[1] = value
			  end,
			  default = BMU.DefaultsServer["prioritizationSource"][1],
			          },
		{
              type = LHAS.ST_DROPDOWN,
			  label = "PRIO 2",
              tooltip = "",
			  items = BMU.dropdownPrioSourceItems,
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
			          },
		{
              type = LHAS.ST_DROPDOWN,
			  label = "PRIO 3",
              tooltip = "",
			  items = BMU.dropdownPrioSourceItems,
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
			          },
		{
              type = LHAS.ST_DROPDOWN,
			  label = "PRIO 4",
              tooltip = "",
			  items = BMU.dropdownPrioSourceItems,
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
			          },
		{
              type = LHAS.ST_DROPDOWN,
			  label = "PRIO 5",
              tooltip = "",
			  items = BMU.dropdownPrioSourceItems,
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
			          },
		{
              type = LHAS.ST_DROPDOWN,
			  label = "PRIO 6",
              tooltip = "",
			  items = BMU.dropdownPrioSourceItems,
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
			          },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION),
              tooltip = SI.get(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["showTeleportAnimation"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.showTeleportAnimation end,
              setFunc = function(value) BMU.savedVarsAcc.showTeleportAnimation = value end,
			  default = BMU.DefaultsAccount["showTeleportAnimation"],
			           },
		 {
              type = LHAS.ST_SECTION,
              label = ""
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM),
              tooltip = SI.get(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["usePanAndZoom"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.usePanAndZoom end,
              setFunc = function(value) BMU.savedVarsAcc.usePanAndZoom = value end,
			  default = BMU.DefaultsAccount["usePanAndZoom"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_USE_RALLY_POINT),
              tooltip = SI.get(SI.TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["useMapPing"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.useMapPing end,
              setFunc = function(value) BMU.savedVarsAcc.useMapPing = value end,
			  disabled = function() return not BMU.LibMapPing end,
			  default = BMU.DefaultsAccount["useMapPing"],
			           },
		 {
              type = LHAS.ST_SECTION,
			           },
         {
              type = LHAS.ST_DROPDOWN,
              label = SI.get(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE),
              tooltip = SI.get(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownSecLangChoices[BMU.DefaultsAccount["secondLanguage"]] .. "]",
			  items = BMU.dropdownSecLangItems,
              getFunc = function() return BMU.savedVarsAcc.secondLanguage end,
			  setFunc = function(value) BMU.savedVarsAcc.secondLanguage = value end,
			  default = BMU.DefaultsAccount["secondLanguage"],
			          },
		 {
              type = LHAS.ST_SECTION,
              label = ""
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE),
              tooltip = SI.get(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["FavoritePlayerStatusNotification"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.FavoritePlayerStatusNotification end,
              setFunc = function(value) 
                BMU.savedVarsAcc.FavoritePlayerStatusNotification = value 
                ReloadUI()
              end,
			  default = BMU.DefaultsAccount["FavoritePlayerStatusNotification"],
			           },
		 {
              type = LHAS.ST_SECTION,
              label = ""
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION),
              tooltip = SI.get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["surveyMapsNotification"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.surveyMapsNotification end,
              setFunc = function(value) 
                BMU.savedVarsAcc.surveyMapsNotification = value 
                ReloadUI()
              end,
			  default = BMU.DefaultsAccount["surveyMapsNotification"],
			  requiresReload = true,
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND),
              tooltip = SI.get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["surveyMapsNotificationSound"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.surveyMapsNotificationSound end,
              setFunc = function(value) BMU.savedVarsAcc.surveyMapsNotificationSound = value end,
			  default = BMU.DefaultsAccount["surveyMapsNotificationSound"],
			  disabled = function() return not BMU.savedVarsAcc.surveyMapsNotification end,
			           },
		 {
              type = LHAS.ST_SECTION,
              label = ""
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL),
              tooltip = SI.get(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["wayshrineTravelAutoConfirm"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.wayshrineTravelAutoConfirm end,
              setFunc = function(value) 
                BMU.savedVarsAcc.wayshrineTravelAutoConfirm = value 
                ReloadUI()
              end,
			  default = BMU.DefaultsAccount["wayshrineTravelAutoConfirm"],
			           },
		 {
              type = LHAS.ST_SECTION,
              label = ""
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = SI.get(SI.TELE_SETTINGS_OFFLINE_NOTE),
              tooltip = SI.get(SI.TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["showOfflineReminder"]) .. "]",
              getFunc = function() return BMU.savedVarsAcc.showOfflineReminder end,
              setFunc = function(value) 
                BMU.savedVarsAcc.showOfflineReminder = value 
                ReloadUI()
              end,
			  default = BMU.DefaultsAccount["showOfflineReminder"],
			           },
		 {
              type = LHAS.ST_SECTION,
              label = ""
			           },
		 {
			  type = LHAS.ST_CHECKBOX,
			  label = SI.get(SI.TELE_SETTINGS_OUTPUT_FAST_TRAVEL),
			  tooltip = SI.get(SI.TELE_SETTINGS_OUTPUT_FAST_TRAVEL_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["chatOutputFastTravel"]) .. "]",
			  getFunc = function() return BMU.savedVarsAcc.chatOutputFastTravel end,
			  setFunc = function(value) BMU.savedVarsAcc.chatOutputFastTravel = value end,
			  default = BMU.DefaultsAccount["chatOutputFastTravel"],
			  	     },
	     {
			  type = LHAS.ST_CHECKBOX,
			  label = SI.get(SI.TELE_SETTINGS_OUTPUT_ADDITIONAL),
			  tooltip = SI.get(SI.TELE_SETTINGS_OUTPUT_ADDITIONAL_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["chatOutputAdditional"]) .. "]",
			  getFunc = function() return BMU.savedVarsAcc.chatOutputAdditional end,
			  setFunc = function(value) BMU.savedVarsAcc.chatOutputAdditional = value end,
			  default = BMU.DefaultsAccount["chatOutputAdditional"],
			     		 },
   		 {
			  type = LHAS.ST_CHECKBOX,
			  label = SI.get(SI.TELE_SETTINGS_OUTPUT_UNLOCK),
		 	  tooltip = SI.get(SI.TELE_SETTINGS_OUTPUT_UNLOCK_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU.DefaultsAccount["chatOutputUnlock"]) .. "]",
			  getFunc = function() return BMU.savedVarsAcc.chatOutputUnlock end,
			  setFunc = function(value) BMU.savedVarsAcc.chatOutputUnlock = value end,
			  default = BMU.DefaultsAccount["chatOutputUnlock"],
			  		 },
		 {
			  type = LHAS.ST_CHECKBOX,
			  label = SI.get(SI.TELE_SETTINGS_OUTPUT_DEBUG),
			  tooltip = SI.get(SI.TELE_SETTINGS_OUTPUT_DEBUG_TOOLTIP),
			  getFunc = function() return BMU.debugMode end,
			  setFunc = function(value) BMU.debugMode = value end,
			  default = false,
			  	     },
		 {
              type = LHAS.ST_BUTTON,
              label = BMU.colorizeText(SI.get(SI.TELE_SETTINGS_RESET_ALL_COUNTERS), "red"),
			  tooltip = SI.get(SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP),
			  clickHandler = function() for zoneId, _ in pairs(BMU.savedVarsAcc.portCounterPerZone) do
									BMU.savedVarsAcc.portCounterPerZone[zoneId] = nil
								end
								BMU.printToChat("ALL COUNTERS RESETTET!")
						end,
			           }
    }
    BMU.SettingsPanel = BMU.SettingsPanel:AddSettings(optionsData)
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
function BMU.updateRelatedItemsCounterPanel()
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
			local itemName = GetItemName(bagId, slotIndex)
			local itemType, specializedItemType = GetItemType(bagId, slotIndex)
			local itemId = GetItemId(bagId, slotIndex)
			local _, itemCount, _, _, _, _, _, _ = GetItemInfo(bagId, slotIndex)
			local subType, itemZoneId = BMU.getDataMapInfo(itemId)
				
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
	local dimension = 28 * BMU.savedVarsAcc.Scale

	-- build argument list
	local arguments_list = {
		BMU.getItemTypeIcon("alchemist", dimension), counter_table["alchemist"],
		BMU.getItemTypeIcon("enchanter", dimension), counter_table["enchanter"],
		BMU.getItemTypeIcon("woodworker", dimension), counter_table["woodworker"],
		BMU.getItemTypeIcon("blacksmith", dimension), counter_table["blacksmith"],
		BMU.getItemTypeIcon("clothier", dimension), counter_table["clothier"],
		BMU.getItemTypeIcon("jewelry", dimension), counter_table["jewelry"],
		BMU.getItemTypeIcon("treasure", dimension), counter_table["treasure"],
		BMU.getItemTypeIcon("leads", dimension), counter_table["leads"]
	}
	
	local text = string.format("%s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d", unpack(arguments_list))
	
	BMU.counterPanel:SetText(text)
	-- update position (number of lines may have changed)
	BMU.counterPanel:ClearAnchors()
	BMU.counterPanel:SetAnchor(TOP, BMU.win.Main_Control, TOP, 1*BMU.savedVarsAcc.Scale, (90*BMU.savedVarsAcc.Scale)+((BMU.savedVarsAcc.numberLines*40)*BMU.savedVarsAcc.Scale))
end


local function SetupUI()
	-----------------------------------------------
	-- Fonts
	
	-- default font
	local fontSize = BMU.round(17*BMU.savedVarsAcc.Scale, 0)
	local fontStyle = BG.ZoFontGame:GetFontInfo()
	local fontWeight = "soft-shadow-thin"
	BMU.font1 = string.format("%s|$(KB_%s)|%s", fontStyle, fontSize, fontWeight)
	
	-- font of statistics
	fontSize = BMU.round(13*BMU.savedVarsAcc.Scale, 0)
	fontStyle = BG.ZoFontGameBookTable:GetFontInfo()
	--fontStyle = "EsoUI/Common/Fonts/consola.ttf"
	fontWeight = "soft-shadow-thin"
	BMU.font2 = string.format("%s|$(KB_%s)|%s", fontStyle, fontSize, fontWeight)
	
	-----------------------------------------------
    local teleporterWin = BMU.win

    -----------------------------------------------
	
	-- Button on Chat Window
	if BMU.savedVarsAcc.chatButton then
		if BMU.LCMB then
			-- LibChatMenuButton is enabled
			-- register chat button via library
			-- NOTE: Since BMU.chatButtonTex is not defined, the option for the offset is disabled automatically (positioning is handled by the lib)
			BMU.chatButtonLCMB = BMU.LCMB.addChatButton("!!!BMUChatButton", {BMU.textures.wayshrineBtn, BMU.textures.wayshrineBtnOver}, appName, function() BMU.OpenTeleporter(true) end)
		else
			-- do it the old way
			-- Texture
			BMU.chatButtonTex = wm:CreateControl("Teleporter_CHAT_MENU_BUTTON", ZO_ChatWindow, CT_TEXTURE)
			if BMU.chatButtonTex ~= nil then
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
		end
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
  BMU.TeleporterList = BMU.ListView.new(teleporterWin.Main_Control,  {
    width = 750*BMU.savedVarsAcc.Scale,
    height = 500*BMU.savedVarsAcc.Scale,
  })
  
  ---------

  
    -------------------------------------------------------------------
  -- Switch BUTTON ON ZoneGuide window

  teleporterWin.zoneGuideSwapTexture = wm:CreateControl(nil, BG.ZO_WorldMapZoneStoryTopLevel, CT_TEXTURE)
  teleporterWin.zoneGuideSwapTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.zoneGuideSwapTexture:SetAnchor(TOPRIGHT, BG.ZO_WorldMapZoneStoryTopLevel, TOPRIGHT, TOPRIGHT -10*BMU.savedVarsAcc.Scale, -35*BMU.savedVarsAcc.Scale)
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
		  if BMU.state ~= BMU.indexListGuilds then
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
  
  teleporterWin.Main_Control.RefreshTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.RefreshTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.RefreshTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -80*BMU.savedVarsAcc.Scale, -5*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.RefreshTexture:SetTexture(BMU.textures.refreshBtn)
  teleporterWin.Main_Control.RefreshTexture:SetMouseEnabled(true)
  teleporterWin.Main_Control.RefreshTexture:SetDrawLayer(2)

  teleporterWin.Main_Control.RefreshTexture:SetHandler("OnMouseUp", function(self)
		if BMU.state == BMU.indexListMain then
			-- dont reset slider if user stays already on main list
			BMU.createTable({index=BMU.indexListMain, dontResetSlider=true})
		else
			BMU.createTable({index=BMU.indexListMain})
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
			BMU:tooltipTextEnter(teleporterWin.Main_Control.PTFTexture,
				SI.get(SI.TELE_UI_BTN_PTF_INTEGRATION) .. SI.get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
			teleporterWin.Main_Control.PTFTexture:SetTexture(BMU.textures.ptfHouseBtnOver)
		end)

		teleporterWin.Main_Control.PTFTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin.Main_Control.PTFTexture)
			if BMU.state ~= BMU.indexListPTFHouses then
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
  -- Own Houses
  
  teleporterWin.Main_Control.OwnHouseTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.OwnHouseTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.OwnHouseTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -205*BMU.savedVarsAcc.Scale, 40*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.OwnHouseTexture:SetTexture(BMU.textures.houseBtn)
  teleporterWin.Main_Control.OwnHouseTexture:SetMouseEnabled(true)
  teleporterWin.Main_Control.OwnHouseTexture:SetDrawLayer(2)

  teleporterWin.Main_Control.OwnHouseTexture:SetHandler("OnMouseUp", function(self, button)
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		ClearMenu()
		
		-- toggle between nicknames and standard names
		local menuIndex = AddCustomMenuItem(SI.get(SI.TELE_UI_TOGGLE_HOUSE_NICKNAME), function() BMU.savedVarsChar.houseNickNames = not BMU.savedVarsChar.houseNickNames BMU.clearInputFields() BMU.createTableHouses() end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.houseNickNames then
			ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
		end

		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)

		-- make default tab
		menuIndex = AddCustomMenuItem(SI.get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListOwnHouses then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListOwnHouses end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.defaultTab == BMU.indexListOwnHouses then
			ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
		end

		ShowMenu()
	else
		BMU.clearInputFields()
		BMU.createTableHouses()
	end
  end)
  
  teleporterWin.Main_Control.OwnHouseTexture:SetHandler("OnMouseEnter", function(self)
    BMU:tooltipTextEnter(teleporterWin.Main_Control.OwnHouseTexture,
		SI.get(SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE) .. SI.get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin.Main_Control.OwnHouseTexture:SetTexture(BMU.textures.houseBtnOver)
  end)

  teleporterWin.Main_Control.OwnHouseTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin.Main_Control.OwnHouseTexture)
	if BMU.state ~= BMU.indexListOwnHouses then
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

  teleporterWin.Main_Control.QuestTexture:SetHandler("OnMouseUp", function(self, button)
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show context menu
		ClearMenu()
		-- make default tab
		local menuIndex = AddCustomMenuItem(SI.get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListQuests then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListQuests end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.defaultTab == BMU.indexListQuests then
			ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
		end
		ShowMenu()
	else
		BMU.createTable({index=BMU.indexListQuests})
	end
  end)
  
  teleporterWin.Main_Control.QuestTexture:SetHandler("OnMouseEnter", function(self)
    BMU:tooltipTextEnter(teleporterWin.Main_Control.QuestTexture,
		GetString(SI_JOURNAL_MENU_QUESTS) .. SI.get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin.Main_Control.QuestTexture:SetTexture(BMU.textures.questBtnOver)
  end)

  teleporterWin.Main_Control.QuestTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin.Main_Control.QuestTexture)
	if BMU.state ~= BMU.indexListQuests then
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

		-- Add submenu for antiquity leads
		AddCustomSubMenuItem(GetString(SI_GAMEPAD_VENDOR_ANTIQUITY_LEAD_GROUP_HEADER),
			{
				{
					label = GetString(SI_ANTIQUITY_SCRYABLE),
					callback = function()
						BMU.savedVarsChar.displayAntiquityLeads.srcyable = not BMU.savedVarsChar.displayAntiquityLeads.srcyable
						BMU.createTable({index=BMU.indexListItems}) end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayAntiquityLeads.srcyable end,
				},
				{
					label = GetString(SI_ANTIQUITY_SUBHEADING_IN_PROGRESS),
					callback = function()
						BMU.savedVarsChar.displayAntiquityLeads.scried = not BMU.savedVarsChar.displayAntiquityLeads.scried
						BMU.createTable({index=BMU.indexListItems}) end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayAntiquityLeads.scried end,
				},
				{
					label = GetString(SI_SCREEN_NARRATION_ACHIEVEMENT_EARNED_ICON_NARRATION) .. " (" .. GetString(SI_ANTIQUITY_LOG_BOOK) .. ")",
					callback = function()
						BMU.savedVarsChar.displayAntiquityLeads.completed = not BMU.savedVarsChar.displayAntiquityLeads.completed
						BMU.createTable({index=BMU.indexListItems}) end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayAntiquityLeads.completed end,
				},
			}, nil, nil, nil, 5
		)

		-- Clues
		local menuIndex = AddCustomMenuItem(GetString(SI_SPECIALIZEDITEMTYPE113), function() BMU.savedVarsChar.displayMaps.clue = not BMU.savedVarsChar.displayMaps.clue BMU.createTable({index=BMU.indexListItems}) end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
		if BMU.savedVarsChar.displayMaps.clue then
			ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
		end
		
		-- Treasure Maps
		menuIndex = AddCustomMenuItem(GetString(SI_SPECIALIZEDITEMTYPE100), function() BMU.savedVarsChar.displayMaps.treasure = not BMU.savedVarsChar.displayMaps.treasure BMU.createTable({index=BMU.indexListItems}) end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
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
				BMU.createTable({index=BMU.indexListItems})
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
						BMU.createTable({index=BMU.indexListItems}) end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.alchemist end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY15),
					callback = function()
						BMU.savedVarsChar.displayMaps.enchanter = not BMU.savedVarsChar.displayMaps.enchanter
						BMU.updateCheckboxSurveyMap(3)
						BMU.createTable({index=BMU.indexListItems}) end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.enchanter end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY12),
					callback = function()
						BMU.savedVarsChar.displayMaps.woodworker = not BMU.savedVarsChar.displayMaps.woodworker
						BMU.updateCheckboxSurveyMap(3)
						BMU.createTable({index=BMU.indexListItems}) end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.woodworker end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY10),
					callback = function()
						BMU.savedVarsChar.displayMaps.blacksmith = not BMU.savedVarsChar.displayMaps.blacksmith
						BMU.updateCheckboxSurveyMap(3)
						BMU.createTable({index=BMU.indexListItems}) end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.blacksmith end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY11),
					callback = function()
						BMU.savedVarsChar.displayMaps.clothier = not BMU.savedVarsChar.displayMaps.clothier
						BMU.updateCheckboxSurveyMap(3)
						BMU.createTable({index=BMU.indexListItems}) end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.clothier end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY13),
					callback = function()
						BMU.savedVarsChar.displayMaps.jewelry = not BMU.savedVarsChar.displayMaps.jewelry
						BMU.updateCheckboxSurveyMap(3)
						BMU.createTable({index=BMU.indexListItems}) end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.jewelry end,
				},
			}, nil, nil, nil, 5
		)
		
		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)
		
		-- include bank items
		menuIndex = AddCustomMenuItem(GetString(SI_CRAFTING_INCLUDE_BANKED), function() BMU.savedVarsChar.scanBankForMaps = not BMU.savedVarsChar.scanBankForMaps BMU.createTable({index=BMU.indexListItems}) end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
		if BMU.savedVarsChar.scanBankForMaps then
			ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
		end

		-- enable/disable counter panel
		menuIndex = AddCustomMenuItem(GetString(SI_ENDLESS_DUNGEON_BUFF_TRACKER_SWITCH_TO_SUMMARY_KEYBIND), function() BMU.savedVarsChar.displayCounterPanel = not BMU.savedVarsChar.displayCounterPanel BMU.createTable({index=BMU.indexListItems}) end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
		if BMU.savedVarsChar.displayCounterPanel then
			ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
		end

		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)

		-- make default tab
		menuIndex = AddCustomMenuItem(SI.get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListItems then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListItems end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.defaultTab == BMU.indexListItems then
			ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
		end
		
		ShowMenu()
	else
		BMU.createTable({index=BMU.indexListItems})
		BMU.showNotification(true)
	end
  end)
  
  teleporterWin.Main_Control.ItemTexture:SetHandler("OnMouseEnter", function(self)
	-- set tooltip accordingly to the selected filter
	local tooltip = ""

	if BMU.savedVarsChar.displayAntiquityLeads.scried or BMU.savedVarsChar.displayAntiquityLeads.srcyable then
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
	if BMU.state ~= BMU.indexListItems then
		teleporterWin.Main_Control.ItemTexture:SetTexture(BMU.textures.relatedItemsBtn)
	end
  end)

  -- Create counter panel that displays the counter for each type
  BMU.counterPanel = WINDOW_MANAGER:CreateControl(nil, BMU.win.Main_Control, CT_LABEL)
  BMU.counterPanel:SetFont(BMU.font1)
  BMU.counterPanel:SetHidden(true)

  ---------------------------------------------------------------------------------------------------------------
  -- Only current zone

  teleporterWin.Main_Control.OnlyYourzoneTexture = wm:CreateControl(nil, teleporterWin.Main_Control, CT_TEXTURE)
  teleporterWin.Main_Control.OnlyYourzoneTexture:SetDimensions(50*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.OnlyYourzoneTexture:SetAnchor(TOPRIGHT, teleporterWin.Main_Control, TOPRIGHT, -80*BMU.savedVarsAcc.Scale, 40*BMU.savedVarsAcc.Scale)
  teleporterWin.Main_Control.OnlyYourzoneTexture:SetTexture(BMU.textures.currentZoneBtn)
  teleporterWin.Main_Control.OnlyYourzoneTexture:SetMouseEnabled(true)
  teleporterWin.Main_Control.OnlyYourzoneTexture:SetDrawLayer(2)
  
	teleporterWin.Main_Control.OnlyYourzoneTexture:SetHandler("OnMouseUp", function(self, button)
		if button == MOUSE_BUTTON_INDEX_RIGHT then
			-- show context menu
			ClearMenu()
			-- make default tab
			local menuIndex = AddCustomMenuItem(SI.get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListCurrentZone then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListCurrentZone end end, MENU_ADD_OPTION_CHECKBOX)
			if BMU.savedVarsChar.defaultTab == BMU.indexListCurrentZone then
				ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
			end
			ShowMenu()
		else
			BMU.createTable({index=BMU.indexListCurrentZone})
		end
	end)
  
    teleporterWin.Main_Control.OnlyYourzoneTexture:SetHandler("OnMouseEnter", function(self)
		BMU:tooltipTextEnter(teleporterWin.Main_Control.OnlyYourzoneTexture,
			GetString(SI_ANTIQUITY_SCRYABLE_CURRENT_ZONE_SUBCATEGORY) .. SI.get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
		teleporterWin.Main_Control.OnlyYourzoneTexture:SetTexture(BMU.textures.currentZoneBtnOver)
	end)
	
	teleporterWin.Main_Control.OnlyYourzoneTexture:SetHandler("OnMouseExit", function(self)
		BMU:tooltipTextEnter(teleporterWin.Main_Control.OnlyYourzoneTexture)
		if BMU.state ~= BMU.indexListCurrentZone then
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
		-- show all or only in current zone
		local menuIndex = AddCustomMenuItem(GetString(SI_GAMEPAD_GUILD_HISTORY_SUBCATEGORY_ALL), function() BMU.savedVarsChar.showAllDelves = not BMU.savedVarsChar.showAllDelves BMU.createTable({index=BMU.indexListDelves}) end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.showAllDelves then
			ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
		end

		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)
		
		-- make default tab
		menuIndex = AddCustomMenuItem(SI.get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListDelves then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListDelves end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.defaultTab == BMU.indexListDelves then
			ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
		end
		ShowMenu()
	else
		BMU.createTable({index=BMU.indexListDelves})
	end
  end)
  
  teleporterWin.Main_Control.DelvesTexture:SetHandler("OnMouseEnter", function(self)
	local text = GetString(SI_ZONECOMPLETIONTYPE5)
	if not BMU.savedVarsChar.showAllDelves then
		text = text .. " - " .. GetString(SI_ANTIQUITY_SCRYABLE_CURRENT_ZONE_SUBCATEGORY)
	end
	BMU:tooltipTextEnter(teleporterWin.Main_Control.DelvesTexture,
		text .. SI.get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin.Main_Control.DelvesTexture:SetTexture(BMU.textures.delvesBtnOver)
  end)

  teleporterWin.Main_Control.DelvesTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin.Main_Control.DelvesTexture)
	if BMU.state ~= BMU.indexListDelves then
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

		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)

		-- make default tab
		local menuIndex = AddCustomMenuItem(SI.get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListDungeons then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListDungeons end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.defaultTab == BMU.indexListDungeons then
			ZO_CheckButton_SetChecked(ZO_Menu.items[menuIndex].checkbox)
		end

		ShowMenu()
	else
		BMU.clearInputFields()
		BMU.createTableDungeons()
	end
  end)
  
  teleporterWin.Main_Control.DungeonTexture:SetHandler("OnMouseEnter", function(self)
	BMU:tooltipTextEnter(teleporterWin.Main_Control.DungeonTexture,
		SI.get(SI.TELE_UI_BTN_DUNGEON_FINDER) .. SI.get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin.Main_Control.DungeonTexture:SetTexture(BMU.textures.soloArenaBtnOver)
  end)

  teleporterWin.Main_Control.DungeonTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin.Main_Control.DungeonTexture)
	if BMU.state ~= BMU.indexListDungeons then
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

	BMU.printToChat("Changed - state: " .. tostring(index), BMU.MSG_DB)
    
	local teleporterWin = BMU.win

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
	-- hide counter panel for related items tab
	BMU.counterPanel:SetHidden(true)
	
	teleporterWin.Searcher_Player:SetHidden(false)

	-- check new state
	if index == BMU.indexListItems then
		-- related Items
		teleporterWin.Main_Control.ItemTexture:SetTexture(BMU.textures.relatedItemsBtnOver)
		if BMU.savedVarsChar.displayCounterPanel then
			BMU.counterPanel:SetHidden(false)
		end
	elseif index == BMU.indexListCurrentZone then
		-- current zone
		teleporterWin.Main_Control.OnlyYourzoneTexture:SetTexture(BMU.textures.currentZoneBtnOver)
	elseif index == BMU.indexListDelves then
		-- current zone delves
		teleporterWin.Main_Control.DelvesTexture:SetTexture(BMU.textures.delvesBtnOver)
	elseif index == BMU.indexListSearchPlayer or index == BMU.indexListSearchZone then
		-- serach by player name or zone name
		teleporterWin.SearchTexture:SetTexture(BMU.textures.searchBtnOver)
	elseif index == BMU.indexListQuests then
		-- related quests
		teleporterWin.Main_Control.QuestTexture:SetTexture(BMU.textures.questBtnOver)
	elseif index == BMU.indexListOwnHouses then
		-- own houses
		teleporterWin.Main_Control.OwnHouseTexture:SetTexture(BMU.textures.houseBtnOver)
	elseif index == BMU.indexListPTFHouses then
		-- PTF houses
		teleporterWin.Main_Control.PTFTexture:SetTexture(BMU.textures.ptfHouseBtnOver)
	elseif index == BMU.indexListGuilds then
		-- guilds
		if teleporterWin.guildTexture then
			teleporterWin.guildTexture:SetTexture(BMU.textures.guildBtnOver)
		end
	elseif index == BMU.indexListDungeons then
		-- dungeon finder
		teleporterWin.Main_Control.DungeonTexture:SetTexture(BMU.textures.soloArenaBtnOver)
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
					BMU.printToChat(SI.get(SI.TELE_CHAT_SHARING_FOLLOW_LINK), BMU.MSG_AD)
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
				BMU.printToChat(SI.get(SI.TELE_CHAT_SHARING_FOLLOW_LINK), BMU.MSG_AD)
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
