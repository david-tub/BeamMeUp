local CS = {}
local BMU = BMU
local LHAS = LibHarvensAddonSettings
local SI = BMU.SI ---- used for localization
local BMU_SI_get = SI.get
local BMU_colorizeText = BMU.colorizeText

local teleporterVars    = BMU.var
local appName           = teleporterVars.appName
local wm                = WINDOW_MANAGER

-- list of tuples (guildId & displayname) for invite queue (only for admin)
local inviteQueue = {}

-- Settings vars
local function zipDropdownSortedKeys(choices)
  local dropdownSortItems = {}
  for k, v in ipairs(choices) do
    table.insert(dropdownSortItems, { name = v, data = k } )
  end
  return dropdownSortItems
end

local function zipDropdownSortedValues(choices, values)
  local dropdownSortItems = {}
  for k, v in pairs(choices) do
    table.insert(dropdownSortItems, { name = v, data = values[k] } )
  end
  return dropdownSortItems
end

local dropdownSortItems = zipDropdownSortedKeys(BMU.dropdownSortChoices)
local dropdownDefaultTabItems = zipDropdownSortedValues(BMU.dropdownDefaultTabChoices, BMU.dropdownDefaultTabValues)
local dropdownPrioSourceItems = zipDropdownSortedValues(BMU.dropdownPrioSourceChoices, BMU.dropdownPrioSourceValues)
local dropdownSecLangItems = zipDropdownSortedKeys(BMU.dropdownSecLangChoices)

function CS.SetupOptionsMenu(index) --index == Addon name
    local teleporterWin     = BMU.win
    local BMU_savedVarsChar = BMU.savedVarsChar
    local BMU_savedVarsAcc = BMU.savedVarsAcc
    local BMU_savedVarsServ = BMU.savedVarsServ
    local BMU_DefaultsAccount = BMU.DefaultsAccount
    local BMU_getIndexFromValue = BMU.getIndexFromValue

    local panel = LHAS:AddAddon(appName .. "Options", {
      allowDefaults = false,  -- Show "Reset to Defaults" button
      allowRefresh = false    -- Enable automatic control updates
    })

    local optionsData = {
         {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["ShowOnMapOpen"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.ShowOnMapOpen end,
              setFunction = function(value) BMU_savedVarsAcc.ShowOnMapOpen = value end,
			  default = BMU_DefaultsAccount["ShowOnMapOpen"],
         },
         {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["HideOnMapClose"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.HideOnMapClose end,
              setFunction = function(value) BMU_savedVarsAcc.HideOnMapClose = value end,
			  default = BMU_DefaultsAccount["HideOnMapClose"],
         },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_CLOSE_ON_PORTING),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["closeOnPorting"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.closeOnPorting end,
              setFunction = function(value) BMU_savedVarsAcc.closeOnPorting = value end,
			  default = BMU_DefaultsAccount["closeOnPorting"],
		 },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_WINDOW_STAY),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["windowStay"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.windowStay end,
              setFunction = function(value) BMU_savedVarsAcc.windowStay = value end,
			  default = BMU_DefaultsAccount["windowStay"],
		 },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["focusZoneSearchOnOpening"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.focusZoneSearchOnOpening end,
              setFunction = function(value) BMU_savedVarsAcc.focusZoneSearchOnOpening = value end,
			  default = BMU_DefaultsAccount["focusZoneSearchOnOpening"],
         },
		 {
              type = LHAS.ST_SLIDER,
              label = BMU_SI_get(SI.TELE_SETTINGS_AUTO_PORT_FREQ),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsAccount["AutoPortFreq"] .. "]",
              min = 50,
              max = 500,
              getFunction = function() return BMU_savedVarsAcc.AutoPortFreq end,
              setFunction = function(value) BMU_savedVarsAcc.AutoPortFreq = value end,
			  default = BMU_DefaultsAccount["AutoPortFreq"],
         },
		 {
              type = LHAS.ST_SECTION,
              label = ""
         },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["showOpenButtonOnMap"]) .. "]",
			        getFunction = function() return BMU_savedVarsAcc.showOpenButtonOnMap end,
              setFunction = function(value)
                BMU_savedVarsAcc.showOpenButtonOnMap = value
                ReloadUI("ingame")
              end,
			  default = BMU_DefaultsAccount["showOpenButtonOnMap"],
         },
		 {
              type = LHAS.ST_SLIDER,
              label = BMU_SI_get(SI.TELE_SETTINGS_SCALE),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_SCALE_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsAccount["Scale"] .. "]",
			  min = 0.7,
			  max = 1.4,
			  step = 0.05,
			  format = "%.2f",
              getFunction = function() return BMU_savedVarsAcc.Scale end,
              setFunction = function(value)
                BMU_savedVarsAcc.Scale = value
                ReloadUI("ingame")
              end,
			  default = BMU_DefaultsAccount["Scale"],
         },
		 {
              type = LHAS.ST_SLIDER,
              label = BMU_SI_get(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsAccount["chatButtonHorizontalOffset"] .. "]",
              min = 0,
              max = 200,
              getFunction = function() return BMU_savedVarsAcc.chatButtonHorizontalOffset end,
              setFunction = function(value) BMU_savedVarsAcc.chatButtonHorizontalOffset = value
							BMU.chatButtonTex:SetAnchor(TOPRIGHT, ZO_ChatWindow, TOPRIGHT, -40 - BMU_savedVarsAcc.chatButtonHorizontalOffset, 6)
						end,
			  default = BMU_DefaultsAccount["chatButtonHorizontalOffset"],
			  disabled = function() return not BMU_savedVarsAcc.chatButton or not BMU.chatButtonTex end,
         },
		 {
              type = LHAS.ST_SLIDER,
              label = BMU_SI_get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsAccount["anchorMapOffset_x"] .. "]",
			        min = -100,
              max = 100,
              getFunction = function() return BMU_savedVarsAcc.anchorMapOffset_x end,
              setFunction = function(value) BMU_savedVarsAcc.anchorMapOffset_x = value end,
			  default = BMU_DefaultsAccount["anchorMapOffset_x"],
         },
		 {
              type = LHAS.ST_SLIDER,
              label = BMU_SI_get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsAccount["anchorMapOffset_y"] .. "]",
			  min = -150,
			  max = 150,
              getFunction = function() return BMU_savedVarsAcc.anchorMapOffset_y end,
              setFunction = function(value) BMU_savedVarsAcc.anchorMapOffset_y = value end,
			  default = BMU_DefaultsAccount["anchorMapOffset_y"],
         },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_AUTO_REFRESH),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["autoRefresh"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.autoRefresh end,
              setFunction = function(value) BMU_savedVarsAcc.autoRefresh = value end,
			  default = BMU_DefaultsAccount["autoRefresh"],
         },
		 {
              type = LHAS.ST_DROPDOWN,
              label = BMU_SI_get(SI.TELE_SETTINGS_SORTING),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SORTING_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownSortChoices[BMU.DefaultsCharacter["sorting"]] .. "]",
			  items = dropdownSortItems,
              getFunction = function() return BMU_savedVarsChar.sorting end,
			  setFunction = function(value) BMU_savedVarsChar.sorting = value end,
			  default = BMU.DefaultsCharacter["sorting"],
        },
		{
			type = LHAS.ST_DROPDOWN,
			label = BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB),
			tooltip = BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownDefaultTabChoices[BMU_getIndexFromValue(BMU.dropdownDefaultTabValues, BMU.DefaultsCharacter["defaultTab"])] .. "]",
			items = dropdownDefaultTabItems,
			getFunction = function() return BMU_savedVarsChar.defaultTab end,
			setFunction = function(value) BMU_savedVarsChar.defaultTab = value end,
			default = BMU.DefaultsCharacter["defaultTab"],
			disabled = function() return not BMU_savedVarsAcc.autoRefresh end,
		 },
         {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["showNumberPlayers"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.showNumberPlayers end,
              setFunction = function(value) BMU_savedVarsAcc.showNumberPlayers = value end,
			  default = BMU_DefaultsAccount["showNumberPlayers"],
			  		 },
         {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["searchCharacterNames"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.searchCharacterNames end,
              setFunction = function(value) BMU_savedVarsAcc.searchCharacterNames = value end,
			  default = BMU_DefaultsAccount["searchCharacterNames"],
			  		 },
         {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_ZONE_ONCE_ONLY),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["zoneOnceOnly"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.zoneOnceOnly end,
              setFunction = function(value) BMU_savedVarsAcc.zoneOnceOnly = value end,
			  default = BMU_DefaultsAccount["zoneOnceOnly"],
			  		 },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["currentZoneAlwaysTop"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.currentZoneAlwaysTop end,
              setFunction = function(value) BMU_savedVarsAcc.currentZoneAlwaysTop = value end,
			  default = BMU_DefaultsAccount["currentZoneAlwaysTop"],
			  		 },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_VIEWED_ZONE_ALWAYS_TOP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["currentViewedZoneAlwaysTop"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.currentViewedZoneAlwaysTop end,
              setFunction = function(value) BMU_savedVarsAcc.currentViewedZoneAlwaysTop = value end,
			  default = BMU_DefaultsAccount["currentViewedZoneAlwaysTop"],
			  		 },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_FORMAT_ZONE_NAME),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["formatZoneName"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.formatZoneName end,
              setFunction = function(value) BMU_savedVarsAcc.formatZoneName = value end,
			  default = BMU_DefaultsAccount["formatZoneName"],
			           },
		 {
              type = LHAS.ST_SLIDER,
              label = BMU_SI_get(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP) .. " [DEFAULT: " .. BMU_DefaultsAccount["autoRefreshFreq"] .. "]",
              min = 0,
              max = 15,
              getFunction = function() return BMU_savedVarsAcc.autoRefreshFreq end,
              setFunction = function(value) BMU_savedVarsAcc.autoRefreshFreq = value end,
			  default = BMU_DefaultsAccount["autoRefreshFreq"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["showZonesWithoutPlayers2"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.showZonesWithoutPlayers2 end,
              setFunction = function(value) BMU_savedVarsAcc.showZonesWithoutPlayers2 = value end,
			  default = BMU_DefaultsAccount["showZonesWithoutPlayers2"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_ONLY_MAPS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["onlyMaps"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.onlyMaps end,
              setFunction = function(value) BMU_savedVarsAcc.onlyMaps = value end,
			  default = BMU_DefaultsAccount["onlyMaps"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_HIDE_OTHERS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["hideOthers"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.hideOthers end,
              setFunction = function(value) BMU_savedVarsAcc.hideOthers = value end,
			  disabled = function() return BMU_savedVarsAcc.onlyMaps end,
			  default = BMU_DefaultsAccount["hideOthers"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_HIDE_PVP),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["hidePVP"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.hidePVP end,
              setFunction = function(value) BMU_savedVarsAcc.hidePVP = value end,
			  disabled = function() return BMU_savedVarsAcc.onlyMaps end,
			  default = BMU_DefaultsAccount["hidePVP"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["hideClosedDungeons"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.hideClosedDungeons end,
              setFunction = function(value) BMU_savedVarsAcc.hideClosedDungeons = value end,
			  disabled = function() return BMU_savedVarsAcc.onlyMaps end,
			  default = BMU_DefaultsAccount["hideClosedDungeons"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_HIDE_DELVES),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["hideDelves"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.hideDelves end,
              setFunction = function(value) BMU_savedVarsAcc.hideDelves = value end,
			  disabled = function() return BMU_savedVarsAcc.onlyMaps end,
			  default = BMU_DefaultsAccount["hideDelves"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["hidePublicDungeons"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.hidePublicDungeons end,
              setFunction = function(value) BMU_savedVarsAcc.hidePublicDungeons = value end,
			  disabled = function() return BMU_savedVarsAcc.onlyMaps end,
			  default = BMU_DefaultsAccount["hidePublicDungeons"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_HIDE_HOUSES),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["hideHouses"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.hideHouses end,
              setFunction = function(value) BMU_savedVarsAcc.hideHouses = value end,
			  disabled = function() return BMU_savedVarsAcc.onlyMaps end,
			  default = BMU_DefaultsAccount["hideHouses"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_HIDE_OWN_HOUSES),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["hideOwnHouses"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.hideOwnHouses end,
              setFunction = function(value) BMU_savedVarsAcc.hideOwnHouses = value end,
			  default = BMU_DefaultsAccount["hideOwnHouses"],
			           },
		 {
              type = LHAS.ST_LABEL,
              label = BMU_SI_get(SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION),
			           },
         {
              type = LHAS.ST_DROPDOWN,
			  label = "PRIO 1",
              tooltip = "",
			  items = dropdownPrioSourceItems,
              getFunction = function() return BMU_savedVarsServ.prioritizationSource[1] end,
			  setFunction = function(value)
				-- swap positions
				local index = BMU_getIndexFromValue(BMU_savedVarsServ.prioritizationSource, value)
				BMU_savedVarsServ.prioritizationSource[index] = BMU_savedVarsServ.prioritizationSource[1]
				BMU_savedVarsServ.prioritizationSource[1] = value
			  end,
			  default = BMU.DefaultsServer["prioritizationSource"][1],
			          },
		{
              type = LHAS.ST_DROPDOWN,
			  label = "PRIO 2",
              tooltip = "",
			  items = dropdownPrioSourceItems,
              getFunction = function() return BMU_savedVarsServ.prioritizationSource[2] end,
			  setFunction = function(value)
				-- swap positions
				local index = BMU_getIndexFromValue(BMU_savedVarsServ.prioritizationSource, value)
				BMU_savedVarsServ.prioritizationSource[index] = BMU_savedVarsServ.prioritizationSource[2]
				BMU_savedVarsServ.prioritizationSource[2] = value
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
			  items = dropdownPrioSourceItems,
              getFunction = function() return BMU_savedVarsServ.prioritizationSource[3] end,
			  setFunction = function(value)
			  	-- swap positions
				local index = BMU_getIndexFromValue(BMU_savedVarsServ.prioritizationSource, value)
				BMU_savedVarsServ.prioritizationSource[index] = BMU_savedVarsServ.prioritizationSource[3]
				BMU_savedVarsServ.prioritizationSource[3] = value
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
			  items = dropdownPrioSourceItems,
              getFunction = function() return BMU_savedVarsServ.prioritizationSource[4] end,
			  setFunction = function(value)
				-- swap positions
				local index = BMU_getIndexFromValue(BMU_savedVarsServ.prioritizationSource, value)
				BMU_savedVarsServ.prioritizationSource[index] = BMU_savedVarsServ.prioritizationSource[4]
				BMU_savedVarsServ.prioritizationSource[4] = value
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
			  items = dropdownPrioSourceItems,
              getFunction = function() return BMU_savedVarsServ.prioritizationSource[5] end,
			  setFunction = function(value)
			  			  	-- swap positions
				local index = BMU_getIndexFromValue(BMU_savedVarsServ.prioritizationSource, value)
				BMU_savedVarsServ.prioritizationSource[index] = BMU_savedVarsServ.prioritizationSource[5]
				BMU_savedVarsServ.prioritizationSource[5] = value
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
			  items = dropdownPrioSourceItems,
              getFunction = function() return BMU_savedVarsServ.prioritizationSource[6] end,
			  setFunction = function(value)
			  	-- swap positions
				local index = BMU_getIndexFromValue(BMU_savedVarsServ.prioritizationSource, value)
				BMU_savedVarsServ.prioritizationSource[index] = BMU_savedVarsServ.prioritizationSource[6]
				BMU_savedVarsServ.prioritizationSource[6] = value
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
              label = BMU_SI_get(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["showTeleportAnimation"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.showTeleportAnimation end,
              setFunction = function(value) BMU_savedVarsAcc.showTeleportAnimation = value end,
			  default = BMU_DefaultsAccount["showTeleportAnimation"],
			           },
		 {
              type = LHAS.ST_SECTION,
              label = ""
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["usePanAndZoom"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.usePanAndZoom end,
              setFunction = function(value) BMU_savedVarsAcc.usePanAndZoom = value end,
			  default = BMU_DefaultsAccount["usePanAndZoom"],
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_USE_RALLY_POINT),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["useMapPing"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.useMapPing end,
              setFunction = function(value) BMU_savedVarsAcc.useMapPing = value end,
			  disabled = function() return not BMU.LibMapPing end,
			  default = BMU_DefaultsAccount["useMapPing"],
			           },
		 {
              type = LHAS.ST_SECTION,
			           },
         {
              type = LHAS.ST_DROPDOWN,
              label = BMU_SI_get(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP) .. " [DEFAULT: " .. BMU.dropdownSecLangChoices[BMU_DefaultsAccount["secondLanguage"]] .. "]",
			  items = dropdownSecLangItems,
              getFunction = function() return BMU_savedVarsAcc.secondLanguage end,
			  setFunction = function(value) BMU_savedVarsAcc.secondLanguage = value end,
			  default = BMU_DefaultsAccount["secondLanguage"],
			          },
		 {
              type = LHAS.ST_SECTION,
              label = ""
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["FavoritePlayerStatusNotification"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.FavoritePlayerStatusNotification end,
              setFunction = function(value)
                BMU_savedVarsAcc.FavoritePlayerStatusNotification = value
                ReloadUI()
              end,
			  default = BMU_DefaultsAccount["FavoritePlayerStatusNotification"],
			           },
		 {
              type = LHAS.ST_SECTION,
              label = ""
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["surveyMapsNotification"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.surveyMapsNotification end,
              setFunction = function(value)
                BMU_savedVarsAcc.surveyMapsNotification = value
                ReloadUI()
              end,
			  default = BMU_DefaultsAccount["surveyMapsNotification"],
			  requiresReload = true,
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["surveyMapsNotificationSound"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.surveyMapsNotificationSound end,
              setFunction = function(value) BMU_savedVarsAcc.surveyMapsNotificationSound = value end,
			  default = BMU_DefaultsAccount["surveyMapsNotificationSound"],
			  disabled = function() return not BMU_savedVarsAcc.surveyMapsNotification end,
			           },
		 {
              type = LHAS.ST_SECTION,
              label = ""
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["wayshrineTravelAutoConfirm"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.wayshrineTravelAutoConfirm end,
              setFunction = function(value)
                BMU_savedVarsAcc.wayshrineTravelAutoConfirm = value
                ReloadUI()
              end,
			  default = BMU_DefaultsAccount["wayshrineTravelAutoConfirm"],
			           },
		 {
              type = LHAS.ST_SECTION,
              label = ""
			           },
		 {
              type = LHAS.ST_CHECKBOX,
              label = BMU_SI_get(SI.TELE_SETTINGS_OFFLINE_NOTE),
              tooltip = BMU_SI_get(SI.TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["showOfflineReminder"]) .. "]",
              getFunction = function() return BMU_savedVarsAcc.showOfflineReminder end,
              setFunction = function(value)
                BMU_savedVarsAcc.showOfflineReminder = value
                ReloadUI()
              end,
			  default = BMU_DefaultsAccount["showOfflineReminder"],
			           },
		 {
              type = LHAS.ST_SECTION,
              label = ""
			           },
		 {
			  type = LHAS.ST_CHECKBOX,
			  label = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_FAST_TRAVEL),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_FAST_TRAVEL_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["chatOutputFastTravel"]) .. "]",
			  getFunction = function() return BMU_savedVarsAcc.chatOutputFastTravel end,
			  setFunction = function(value) BMU_savedVarsAcc.chatOutputFastTravel = value end,
			  default = BMU_DefaultsAccount["chatOutputFastTravel"],
			  	     },
	     {
			  type = LHAS.ST_CHECKBOX,
			  label = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_ADDITIONAL),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_ADDITIONAL_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["chatOutputAdditional"]) .. "]",
			  getFunction = function() return BMU_savedVarsAcc.chatOutputAdditional end,
			  setFunction = function(value) BMU_savedVarsAcc.chatOutputAdditional = value end,
			  default = BMU_DefaultsAccount["chatOutputAdditional"],
			     		 },
   		 {
			  type = LHAS.ST_CHECKBOX,
			  label = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_UNLOCK),
		 	  tooltip = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_UNLOCK_TOOLTIP) .. " [DEFAULT: " .. tostring(BMU_DefaultsAccount["chatOutputUnlock"]) .. "]",
			  getFunction = function() return BMU_savedVarsAcc.chatOutputUnlock end,
			  setFunction = function(value) BMU_savedVarsAcc.chatOutputUnlock = value end,
			  default = BMU_DefaultsAccount["chatOutputUnlock"],
			  		 },
		 {
			  type = LHAS.ST_CHECKBOX,
			  label = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_DEBUG),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_OUTPUT_DEBUG_TOOLTIP),
			  getFunction = function() return BMU.debugMode end,
			  setFunction = function(value) BMU.debugMode = value end,
			  default = false,
			  	     },
		 {
              type = LHAS.ST_BUTTON,
              label = BMU_colorizeText(BMU_SI_get(SI.TELE_SETTINGS_RESET_ALL_COUNTERS), "red"),
			  tooltip = BMU_SI_get(SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP),
			  clickHandler = function() for zoneId, _ in pairs(BMU_savedVarsAcc.portCounterPerZone) do
									BMU_savedVarsAcc.portCounterPerZone[zoneId] = nil
								end
								BMU.printToChat("ALL COUNTERS RESETTET!")
						end,
			           }
    }
    BMU.SettingsPanel = panel:AddSettings(optionsData)
end

-- function CS.SetupUI()
--   -- dummy controls
--   local win = BMU.win
--
--   win.Main_Control = wm:CreateTopLevelWindow("Teleporter_Location_MainController")
--   BMU.control_global = win.Main_Control
--   BMU.control_global.bd = wm:CreateControl(nil, win.Main_Control, CT_TEXTURE)
--   BMU.counterPanel = wm:CreateControl(nil, win.Main_Control, CT_LABEL)
--   win.anchorTexture = wm:CreateControl(nil, win.Main_Control, CT_TEXTURE)
--   win.closeTexture = wm:CreateControl(nil, win.Main_Control, CT_TEXTURE)
--   win.fixWindowTexture = wm:CreateControl(nil, win.Main_Control, CT_TEXTURE)
--   win.Main_Control.ItemTexture = wm:CreateControl(nil, win.Main_Control, CT_TEXTURE)
-- 	win.Main_Control.OnlyYourzoneTexture = wm:CreateControl(nil, win.Main_Control, CT_TEXTURE)
-- 	win.Main_Control.DelvesTexture = wm:CreateControl(nil, win.Main_Control, CT_TEXTURE)
-- 	win.SearchTexture = wm:CreateControl(nil, win.Main_Control, CT_TEXTURE)
-- 	win.Main_Control.QuestTexture = wm:CreateControl(nil, win.Main_Control, CT_TEXTURE)
-- 	win.Main_Control.OwnHouseTexture = wm:CreateControl(nil, win.Main_Control, CT_TEXTURE)
-- 	win.Main_Control.PTFTexture = wm:CreateControl(nil, win.Main_Control, CT_TEXTURE)
-- 	win.Main_Control.DungeonTexture = wm:CreateControl(nil, win.Main_Control, CT_TEXTURE)
-- 	win.Searcher_Player = wm:CreateControl(nil, win.Main_Control, CT_TEXTURE)
--   win.Main_Control:SetHidden(true)
--   BMU.counterPanel:SetHidden(true)
--   win.anchorTexture:SetHidden(true)
--   win.closeTexture:SetHidden(true)
--   win.fixWindowTexture:SetHidden(true)
--   win.Main_Control.ItemTexture:SetHidden(true)
--   win.Main_Control.OnlyYourzoneTexture:SetHidden(true)
--   win.Main_Control.DelvesTexture:SetHidden(true)
--   win.SearchTexture:SetHidden(true)
--   win.Main_Control.QuestTexture:SetHidden(true)
--   win.Main_Control.OwnHouseTexture:SetHidden(true)
--   win.Main_Control.PTFTexture:SetHidden(true)
--   win.Searcher_Player:SetHidden(true)
--   win.Main_Control.DungeonTexture:SetHidden(true)
-- end

BMU.CS = CS
