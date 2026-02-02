local BMU = BMU --INS251229 Baertram Performancee gain, not searching _G for BMU each time again!

local SI = BMU.SI
local teleporterVars = BMU.var
local appName = teleporterVars.appName
local SVTabName = teleporterVars.savedVariablesName

-- -v- INS251229 Baertram BEGIN 0
--Performance reference
----variables (defined now, as they were loaded before this file -> see manifest .txt)
--ZOs variables
local EM = EVENT_MANAGER
local CM = CALLBACK_MANAGER
local LH = LINK_HANDLER
local SharedInv = SHARED_INVENTORY
local worldMapScene_Keyboard				= WORLD_MAP_SCENE
local worldMapScene_Gamepad					= GAMEPAD_WORLD_MAP_SCENE
local worldMapZoneStoryTLC_Keyboard			= ZO_WorldMapZoneStoryTopLevel_Keyboard
local ClearCustomScrollableMenu 							= ClearCustomScrollableMenu
--Other addon variables
local BMU_LibZone = BMU.LibZone
--BMU variables
local BMU_ZONE_CATEGORY_DELVE = BMU.ZONE_CATEGORY_DELVE
local BMU_ZONE_CATEGORY_PUBDUNGEON = BMU.ZONE_CATEGORY_PUBDUNGEON
local BMU_ZONE_CATEGORY_HOUSE = BMU.ZONE_CATEGORY_HOUSE
local BMU_ZONE_CATEGORY_GRPDUNGEON = BMU.ZONE_CATEGORY_GRPDUNGEON
local BMU_ZONE_CATEGORY_TRAIL = BMU.ZONE_CATEGORY_TRAIL
local BMU_ZONE_CATEGORY_ENDLESSD = BMU.ZONE_CATEGORY_ENDLESSD
local BMU_ZONE_CATEGORY_GRPZONES = BMU.ZONE_CATEGORY_GRPZONES
local BMU_ZONE_CATEGORY_GRPARENA = BMU.ZONE_CATEGORY_GRPARENA
local BMU_ZONE_CATEGORY_SOLOARENA = BMU.ZONE_CATEGORY_SOLOARENA
local BMU_ZONE_CATEGORY_OVERLAND = BMU.ZONE_CATEGORY_OVERLAND

----functions
--ZOs functions
local GetZoneNameById = GetZoneNameById
local GetCurrentMapZoneIndex = GetCurrentMapZoneIndex
local GetZoneId = GetZoneId
--BMU functions
local BMU_SI_get 							= SI.get
local BMU_updatePosition					= BMU.updatePosition
local BMU_activateWayshrineTravelAutoConfirm= BMU.activateWayshrineTravelAutoConfirm
local BMU_printToChat 						= BMU.printToChat
local BMU_showDialogSimple 					= BMU.showDialogSimple
local BMU_portToAnyZone 					= BMU.portToAnyZone
local BMU_portToTrackedQuestZone 			= BMU.portToTrackedQuestZone
local BMU_portToCurrentZone 				= BMU.portToCurrentZone
local BMU_portToBMUGuildHouse 				= BMU.portToBMUGuildHouse
local BMU_portToGroupLeader 				= BMU.portToGroupLeader
local BMU_portToOwnHouse 					= BMU.portToOwnHouse
local BMU_showDialogAutoUnlock				= BMU.showDialogAutoUnlock
local BMU_PortalToPlayer 					= BMU.PortalToPlayer
local BMU_refreshListAuto 					= BMU.refreshListAuto
local BMU_journalUpdated					= BMU.journalUpdated


----variables (defined inline in code below, upon first usage, as they are still nil at this line)
--BMU UI variables
local BMU_win, BMU_win_Main_Control
-------functions (defined inline in code below, upon first usage, as they are still nil at this line)
local BMU_HideTeleporter, BMU_toggleZoneGuide, BMU_getZoneSpecificHouse, BMU_getAllPublicDungeons, BMU_getAllDelves,
      BMU_joinBlacklist, BMU_formatName, BMU_startCountdownAutoRefresh, BMU_showNotification, BMU_initializeBlacklist,
      BMU_OpenTeleporter, BMU_clearInputFields, BMU_createTable, BMU_createTableHouses, BMU_createTableDungeons,
	  BMU_requestGuildData, BMU_createTableGuilds, BMU_closeBtnSwitchTexture, BMU_getParentZoneId
-- -^- INS251229 Baertram END 0

--Old code from TeleUnicorn -> Moved directly to Teleporter to strip the library
BMU.throttled = {}
local BMU_throttled = BMU.throttled
local current_ms, last_render_ms
function BMU.throttle(key, frequency)
	current_ms = GetFrameTimeMilliseconds() / 1000.0
	last_render_ms = BMU_throttled[key] or 0

	if current_ms > (last_render_ms + frequency) then
		BMU_throttled[key] = current_ms
		return false
	end

	return true
end


local function alertTeleporterLoaded()
    EM:UnregisterForEvent(appName, EVENT_PLAYER_ACTIVATED)
	-- register events for own houses furniture count update
	EM:RegisterForEvent(appName, EVENT_PLAYER_ACTIVATED, BMU.updateHouseFurnitureCount)
	EM:RegisterForEvent(appName, EVENT_HOUSE_FURNITURE_COUNT_UPDATED, BMU.updateHouseFurnitureCount)
end


local function PlayerInitAndReady()
    zo_callLater(function() alertTeleporterLoaded() end, 1500)
end


----------------------------------- KeyBinds
function BMU.PortalHandlerKeyPress(keyPressIndex, favorite)
	BMU_win = BMU_win or BMU.win
	BMU_win_Main_Control = BMU_win_Main_Control or BMU_win.Main_Control
	BMU_OpenTeleporter = BMU_OpenTeleporter or BMU.OpenTeleporter 									--INS251229 Baertram
	BMU_HideTeleporter = BMU_HideTeleporter or BMU.HideTeleporter									--INS251229 Baertram
	BMU_formatName = BMU_formatName or BMU.formatName												--INS251229 Baertram
	BMU_createTable = BMU_createTable or BMU.createTable											--INS251229 Baertram
	BMU_createTableHouses = BMU_createTableHouses or BMU.createTableHouses							--INS251229 Baertram
	BMU_createTableDungeons = BMU_createTableDungeons or BMU.createTableDungeons					--INS251229 Baertram

	-- Port to Group Leader
	if keyPressIndex == 12 then
		BMU_portToGroupLeader()
		return
	end
	
	-- Port to current zone
	if keyPressIndex == 17 then
		BMU_portToCurrentZone()
		return
	end
	
	-- Port to currently tracked/focused quest
	if keyPressIndex == 19 then
		BMU_portToTrackedQuestZone()
		return
	end
	
	-- Port to any available zone (first entry from main list)
	if keyPressIndex == 20 then
		BMU_portToAnyZone()
		return
	end

	-- Port into own Primary Residence
	if keyPressIndex == 13 then
		BMU_portToOwnHouse(true, nil, false, nil)
		return
	end
	
	-- Port outside own Primary Residence
	if keyPressIndex == 18 then
		BMU_portToOwnHouse(true, nil, true, nil)
		return
	end
	
	-- Port to BMU guild house
	if keyPressIndex == 14 then
		BMU_portToBMUGuildHouse()
		return
	end
	
	-- Unlock Wayshrines
	if keyPressIndex == 10 then
		BMU_showDialogAutoUnlock()
		return
	end
	
	-- Zone Favorites
	if keyPressIndex == 15 then
		local fZoneId = BMU.savedVarsServ.favoriteListZones[favorite]
			if fZoneId == nil then
				BMU_printToChat(BMU_SI_get(SI.TELE_CHAT_FAVORITE_UNSET))
				return
			end
		local result = BMU_createTable({index=BMU.indexListZoneHidden, fZoneId=fZoneId, dontDisplay=true})
		local firstRecord = result[1]
		if firstRecord.displayName ~= "" then
			BMU_PortalToPlayer(firstRecord.displayName, firstRecord.sourceIndexLeading, firstRecord.zoneName, firstRecord.zoneId, firstRecord.category, true, true, true)
		elseif firstRecord.isOwnHouse then
			BMU_portToOwnHouse(false, firstRecord.houseId, true, firstRecord.parentZoneName)
		else
			BMU_printToChat(BMU_formatName(GetZoneNameById(fZoneId), BMU.savedVarsAcc.formatZoneName) .. " - " .. BMU_SI_get(SI.TELE_CHAT_NO_FAST_TRAVEL))
		end
		return
	end
	
	-- Player Favorites
	if keyPressIndex == 16 then
		local displayName = BMU.savedVarsServ.favoriteListPlayers[favorite]
			if displayName == nil then
				BMU_printToChat(BMU_SI_get(SI.TELE_CHAT_FAVORITE_UNSET))
				return
			end
		local result = BMU_createTable({index=BMU.indexListSearchPlayer, inputString=displayName, dontDisplay=true})
		local firstRecord = result[1]
		if firstRecord.displayName == "" then
			BMU_printToChat(displayName .. " - " .. BMU_SI_get(SI.TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL))
		else
			BMU_PortalToPlayer(firstRecord.displayName, firstRecord.sourceIndexLeading, firstRecord.zoneName, firstRecord.zoneId, firstRecord.category, true, false, true)
		end
		return
	end

	-- Wayshrine Favorites
	if keyPressIndex == 21 then
		local nodeIndex = BMU.savedVarsServ.favoriteListWayshrines[favorite]
		if nodeIndex == nil then
			BMU_printToChat(BMU_SI_get(SI.TELE_CHAT_FAVORITE_UNSET))
			return
		end
		local _, name, _, _, _, _, _, _, _ = GetFastTravelNodeInfo(nodeIndex)
		if GetInteractionType() ~= INTERACTION_FAST_TRAVEL then
			-- only show info message if the player is not interacting with a wayshrine
			BMU_printToChat(GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. BMU_formatName(name) .. " (" .. zo_strformat(SI_MONEY_FORMAT, GetRecallCost()) .. ")", BMU.MSG_FT)
		end
		FastTravelToNode(nodeIndex)
		return
	end
	
    -- Show/Hide UI with specific Tab
	if BMU_win_Main_Control:IsHidden() then
		-- window is hidden
		if keyPressIndex == 11 then
			-- do nothing if window is hidden and user refresh manually
			return
		end
		
		-- open specific tab
		SetGameCameraUIMode(true)
		BMU_OpenTeleporter(false)
		if keyPressIndex == 6 then
			-- dungeon finder
			BMU_createTableDungeons()
		elseif keyPressIndex == 7 then
			-- own houses
			BMU_createTableHouses()
		else
			BMU_createTable({index=keyPressIndex})
		end
	else
		-- window is shown
		if keyPressIndex == 11 then -- Refresh list
			BMU_refreshListAuto()
		else
			local BMU_state = BMU.state
			if keyPressIndex ~= BMU_state and BMU_state ~= BMU.indexListDungeons and BMU_state ~= BMU.indexListOwnHouses then
				-- index is different -> switch tab but bypass the special states (Dungeon Finder, Own Houses)
				if keyPressIndex == 6 then
					-- dungeon finder
					BMU_createTableDungeons()
				elseif keyPressIndex == 7 then
					-- own houses
					BMU_createTableHouses()
				else
					BMU_createTable({index=keyPressIndex})
				end
			else
				-- same index -> hide UI
				BMU_HideTeleporter()
				SetGameCameraUIMode(false)
			end
		end
    end
end
-----------------------------------


function BMU.onMapShow()
	BMU_OpenTeleporter = BMU_OpenTeleporter or BMU.OpenTeleporter 									--INS251229 Baertram
	BMU_win = BMU_win or BMU.win
	BMU_win_Main_Control = BMU_win_Main_Control or BMU_win.Main_Control

	-- no support for gamepad mode + stay hidden when using the "HarvestFarmTour Editor"
	if BMU_win_Main_Control:IsHidden() and not IsInGamepadPreferredMode() and not SCENE_MANAGER:IsShowing("HarvestFarmScene") then
		if BMU.savedVarsAcc.ShowOnMapOpen then
			-- just open Teleporter
			BMU_OpenTeleporter(true)
		else
			-- display button to open Teleporter
			if BMU_win.MapOpen then
				BMU_win.MapOpen:SetHidden(false)
			end
		end
	else
		-- BMU is open -> update position
		BMU_updatePosition()
	end
end
local BMU_onMapShow = BMU.onMapShow

function BMU.onMapHide()
	BMU_HideTeleporter = BMU_HideTeleporter or BMU.HideTeleporter									--INS251229 Baertram
	BMU_toggleZoneGuide = BMU_toggleZoneGuide or BMU.toggleZoneGuide								--INS251229 Baertram
	BMU_win = BMU_win or BMU.win
	BMU_win_Main_Control = BMU_win_Main_Control or BMU_win.Main_Control

	-- hide button
	local mapOpenButton = BMU_win.MapOpen
	if mapOpenButton then
		mapOpenButton:SetHidden(true)
	end
	
	-- decide if it stays
	if BMU.savedVarsAcc.HideOnMapClose then
		BMU_HideTeleporter()
	else
		BMU_updatePosition()
	end
	
	-- hide ZoneGuide (just to be on the safe side)
	BMU_toggleZoneGuide(false)
end
local BMU_onMapHide = BMU.onMapHide


-- solves incompatibility issue to Votan's Minimap
function BMU.onWorldMapStateChanged(oldState, newState)
    if (newState == SCENE_SHOWING) then
        BMU_onMapShow()
    elseif (newState == SCENE_HIDING) then
        BMU_onMapHide()
    end
end
local BMU_onWorldMapStateChanged = BMU.onWorldMapStateChanged


-- callback to refresh the list if the player changes the current displayed map/zone
function BMU.onWorldMapChanged(wasNavigateIn)
	BMU_refreshListAuto(true)
end
local BMU_onWorldMapChanged = BMU.onWorldMapChanged


function BMU.OpenTeleporter(refresh)
	BMU_toggleZoneGuide = BMU_toggleZoneGuide or BMU.toggleZoneGuide								--INS251229 Baertram
	BMU_showNotification = BMU_showNotification or BMU.showNotification								--INS251229 Baertram
	BMU_initializeBlacklist = BMU_initializeBlacklist or BMU.initializeBlacklist					--INS251229 Baertram
	BMU_win = BMU_win or BMU.win																	--INS251229 Baertram
	BMU_win_Main_Control = BMU_win_Main_Control or BMU_win.Main_Control								--INS251229 Baertram
	BMU_clearInputFields = BMU_clearInputFields or BMU.clearInputFields								--INS251229 Baertram
	BMU_createTable = BMU_createTable or BMU.createTable											--INS251229 Baertram
	BMU_createTableHouses = BMU_createTableHouses or BMU.createTableHouses							--INS251229 Baertram
	BMU_createTableDungeons = BMU_createTableDungeons or BMU.createTableDungeons					--INS251229 Baertram
	BMU_closeBtnSwitchTexture = BMU_closeBtnSwitchTexture or BMU.closeBtnSwitchTexture 				--INS251229 Baertram
	BMU_startCountdownAutoRefresh = BMU_startCountdownAutoRefresh or BMU.startCountdownAutoRefresh	--INS251229 Baertram

	-- show notification (in case)
	BMU_showNotification()
	
	if not worldMapZoneStoryTLC_Keyboard:IsHidden() then
		--hide ZoneGuide
		BMU_toggleZoneGuide(false)
		-- show swap button
		BMU_closeBtnSwitchTexture(true)
	else
		--show normal close button
		BMU_closeBtnSwitchTexture(false)
	end
	
	-- positioning window
	BMU_updatePosition()

	if BMU_win.MapOpen then
		 -- hide open button
		BMU_win.MapOpen:SetHidden(true)
	end
    BMU_win_Main_Control:SetHidden(false) -- show main window
	BMU_initializeBlacklist()
	if BMU.savedVarsAcc.autoRefresh and refresh then
		-- reset input and load default tab
		BMU_clearInputFields()

		local defaultSVCharTab = BMU.savedVarsChar.defaultTab
		if defaultSVCharTab == BMU.indexListOwnHouses then
			BMU_createTableHouses()
		elseif defaultSVCharTab == BMU.indexListDungeons then
			BMU_createTableDungeons()
		else
			BMU_createTable({index=defaultSVCharTab})
		end
	end
	
	-- start auto refresh
	if BMU.savedVarsAcc.autoRefreshFreq ~= 0 then
		zo_callLater(function() BMU_startCountdownAutoRefresh() end, BMU.savedVarsAcc.autoRefreshFreq*1000)
	end
	
	-- focus search box if enabled
	if BMU.savedVarsAcc.focusZoneSearchOnOpening then
		BMU_win.Searcher_Zone:TakeFocus()
	end
end
BMU_OpenTeleporter = BMU.OpenTeleporter


function BMU.HideTeleporter()
	BMU_toggleZoneGuide = BMU_toggleZoneGuide or BMU.toggleZoneGuide								--INS251229 Baertram
	BMU_win = BMU_win or BMU.win
	BMU_win_Main_Control = BMU_win_Main_Control or BMU_win.Main_Control

    BMU_win_Main_Control:SetHidden(true) -- hide main window
	ClearCustomScrollableMenu() -- close all submenus
	ZO_Tooltips_HideTextTooltip() -- close all tooltips
	
	if SCENE_MANAGER:IsShowing("worldMap") then
		-- show button only when main window is hidden and world map is open
		if BMU_win.MapOpen then
			BMU_win.MapOpen:SetHidden(false)
		end
		
		-- show ZoneGuide
		BMU_toggleZoneGuide(true)
	end
end
BMU_HideTeleporter = BMU.HideTeleporter



function BMU.cameraModeChanged()
	if not BMU.savedVarsAcc.windowStay then
		-- hide window, when player moved or camera mode changed
		if not IsGameCameraUIModeActive() then
			BMU_HideTeleporter()
		end
	end
end
local BMU_cameraModeChanged = BMU.cameraModeChanged



-- triggered when ZoneGuide will be displayed (e.g. when worldMap is open and zone changed)
function BMU.onZoneGuideShow()
	BMU_toggleZoneGuide = BMU_toggleZoneGuide or BMU.toggleZoneGuide								--INS251229 Baertram
	BMU_win = BMU_win or BMU.win
	BMU_win_Main_Control = BMU_win_Main_Control or BMU_win.Main_Control

	--check if Teleporter is displayed
	if not BMU_win_Main_Control:IsHidden() then
		-- Teleporter is displayed -> hide ZoneGuide
		BMU_toggleZoneGuide(false)
	end
end
local BMU_onZoneGuideShow = BMU.onZoneGuideShow


-- show/hide ZoneGuide window
function BMU.toggleZoneGuide(show)
	if show then
		-- show ZoneGuide
		--ZO_WorldMapZoneStoryTopLevel_Keyboard:SetHidden(false)
		--ZO_SharedMediumLeftPanelBackground:SetHidden(false)
		worldMapScene_Keyboard:AddFragment(WORLD_MAP_ZONE_STORY_KEYBOARD_FRAGMENT)
	else
		-- hide ZoneGuide
		--ZO_WorldMapZoneStoryTopLevel_Keyboard:SetHidden(true)
		--ZO_SharedMediumLeftPanelBackground:SetHidden(true)
		worldMapScene_Keyboard:RemoveFragment(WORLD_MAP_ZONE_STORY_KEYBOARD_FRAGMENT)
	end
end
BMU_toggleZoneGuide = BMU.toggleZoneGuide


----------------------------
function BMU.initializeBlacklist()
	BMU_joinBlacklist = BMU_joinBlacklist or BMU.joinBlacklist 										--INS251229 Baertram
	BMU_getAllPublicDungeons = BMU_getAllPublicDungeons or BMU.getAllPublicDungeons					--INS251229 Baertram
	BMU_getAllDelves = BMU_getAllDelves or BMU.getAllDelves											--INS251229 Baertram
	local BMU_savedVarsAcc = BMU.savedVarsAcc 														--INS251229 Baertram

	-- check which blacklists are activated and merge them together to one HashMap
	BMU.blacklist = {}
	
	-- hide Others (inaccessible zones)
	if BMU_savedVarsAcc.hideOthers then
		BMU_joinBlacklist(BMU.blacklistOthers)
		BMU_joinBlacklist(BMU.blacklistRefuges)
		BMU_joinBlacklist(BMU.blacklistSoloArenas)
	end
	
	-- hide PVP zones
	if BMU_savedVarsAcc.hidePVP then
		BMU_joinBlacklist(BMU.blacklistCyro)
		BMU_joinBlacklist(BMU.blacklistImpCity)
		BMU_joinBlacklist(BMU.blacklistBattlegrounds)
	end

	-- hide 4 men Dungeons, 12 men Raids, Group Zones, Group Arenas & Endless Dungeons
	if BMU_savedVarsAcc.hideClosedDungeons then
		BMU_joinBlacklist(BMU.blacklistGroupDungeons)
		BMU_joinBlacklist(BMU.blacklistRaids)
		BMU_joinBlacklist(BMU.blacklistGroupZones)
		BMU_joinBlacklist(BMU.blacklistGroupArenas)
		BMU_joinBlacklist(BMU.blacklistEndlessDungeons)
	end
	
	-- hide Houses
	if BMU_savedVarsAcc.hideHouses then
		BMU_joinBlacklist(BMU.blacklistHouses)
	end
	
	-- hide Delves
	if BMU_savedVarsAcc.hideDelves then
		BMU_joinBlacklist(BMU_getAllDelves())
	end
	
	-- hide Public Dungeons
	if BMU_savedVarsAcc.hidePublicDungeons then
		BMU_joinBlacklist(BMU_getAllPublicDungeons())
	end
end
BMU_initializeBlacklist = BMU.initializeBlacklist



function BMU.initializeCategoryMap()
	BMU_joinBlacklist = BMU_joinBlacklist or BMU.joinBlacklist 										--INS251229 Baertram
	BMU_getAllPublicDungeons = BMU_getAllPublicDungeons or BMU.getAllPublicDungeons					--INS251229 Baertram
	BMU_getAllDelves = BMU_getAllDelves or BMU.getAllDelves											--INS251229 Baertram

	BMU.CategoryMap = {}
	local BMU_CategoryMap = BMU.CategoryMap
	-- go over each category list and add to hash map
	
	-- Delves
	for index, value in pairs(BMU_getAllDelves()) do
		BMU_CategoryMap[value] = BMU_ZONE_CATEGORY_DELVE
	end
	
	-- Public Dungeons
	for index, value in pairs(BMU_getAllPublicDungeons()) do
		BMU_CategoryMap[value] = BMU_ZONE_CATEGORY_PUBDUNGEON
	end

	-- Houses
	for index, value in pairs(BMU.blacklistHouses) do
		BMU_CategoryMap[value] = BMU_ZONE_CATEGORY_HOUSE
	end
	
	-- 4 men Group Dungeons
	for index, value in pairs(BMU.blacklistGroupDungeons) do
		BMU_CategoryMap[value] = BMU_ZONE_CATEGORY_GRPDUNGEON
	end
	
	-- 12 men Raids (Trials)
	for index, value in pairs(BMU.blacklistRaids) do
		BMU_CategoryMap[value] = BMU_ZONE_CATEGORY_TRAIL
	end

	-- Endless Dungeons
	for index, value in pairs(BMU.blacklistEndlessDungeons) do
		BMU_CategoryMap[value] = BMU_ZONE_CATEGORY_ENDLESSD
	end
	
	-- Group Zones
	for index, value in pairs(BMU.blacklistGroupZones) do
		BMU_CategoryMap[value] = BMU_ZONE_CATEGORY_GRPZONES
	end
	
	-- Group Arenas
	for index, value in pairs(BMU.blacklistGroupArenas) do
		BMU_CategoryMap[value] = BMU_ZONE_CATEGORY_GRPARENA
	end
	
	-- Solo Arenas
	for index, value in pairs(BMU.blacklistSoloArenas) do
		BMU_CategoryMap[value] = BMU_ZONE_CATEGORY_SOLOARENA
	end
	
	-- Overland Zones
	for parentZoneId, tableObject in pairs(BMU.overlandDelvesPublicDungeons) do
		BMU_CategoryMap[parentZoneId] = BMU_ZONE_CATEGORY_OVERLAND
	end
end
local BMU_initializeCategoryMap = BMU.initializeCategoryMap

----------------------------

-- call function after countdown and repeat
function BMU.startCountdownAutoRefresh()
	BMU_startCountdownAutoRefresh = BMU_startCountdownAutoRefresh or BMU.startCountdownAutoRefresh
	BMU_win = BMU_win or BMU.win
	BMU_win_Main_Control = BMU_win_Main_Control or BMU_win.Main_Control

	if not BMU_win_Main_Control:IsHidden() and not BMU.blockAutoRefreshCycle then
		BMU.blockAutoRefreshCycle = true
		if not BMU.pauseAutoRefresh then
			BMU_refreshListAuto()
		end
		zo_callLater(function()
			BMU.blockAutoRefreshCycle = false
			BMU_startCountdownAutoRefresh()
		end, BMU.savedVarsAcc.autoRefreshFreq*1000)
	end
end
BMU_startCountdownAutoRefresh = BMU.startCountdownAutoRefresh

function BMU.isPlayerInBMUGuild()
	if teleporterVars.BMUGuilds[GetWorldName()] ~= nil then
		for _, guildId in pairs(teleporterVars.BMUGuilds[GetWorldName()]) do
			if IsPlayerInGuild(guildId) then
				return true
			end
		end
	end
	return false
end
local BMU_isPlayerInBMUGuild = BMU.isPlayerInBMUGuild


-- displays notifications
-- itemTabClicked = true -> Tab for treasure and survey maps was clicked
function BMU.showNotification(itemTabClicked)
	BMU_clearInputFields = BMU_clearInputFields or BMU.clearInputFields								--INS251229 Baertram
	BMU_requestGuildData = BMU_requestGuildData or BMU.requestGuildData								--INS251229 Baertram
	BMU_createTableGuilds = BMU_createTableGuilds or BMU.createTableGuilds							--INS251229 Baertram

	-- 2022_08_29
	-- check if the latest LibZone version is installed
	if not BMU_LibZone.GetZoneMapPinInfo or not BMU_LibZone.GetZoneGeographicalParentZoneId then
		-- show dialog
		BMU_showDialogSimple("LibZoneOutdated", "Outdated LibZone version", "The installed version of LibZone is outdated. Please update the LibZone library, otherwise BeamMeUp will not work properly.\n\nIf you dont use Minion Addon Manager, you can open the LibZone website by accepting this dialog.", function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info2171-LibZone.html") end, nil)
	end

	-- only if treasure and survey map tab was clicked
	if itemTabClicked then
		-- new feature: Survey Maps Notification
		--[[ TEMPORARILY DEACTIVATED UNTIL FEATURE IS WORKING PROPERLY (notification comes also when moving maps to bank or chest)
		if not BMU.savedVarsAcc.infoSurveyMapsNotification and not BMU.savedVarsAcc.surveyMapsNotification then
			BMU_showDialogSimple("NotificationBMUNewFeatureSMN", "NEW FEATURE", BMU_SI_get(SI.TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION),
				function()
					-- enable feature
					BMU.savedVarsAcc.surveyMapsNotification = true
					SharedInv:RegisterCallback("SingleSlotInventoryUpdate", BMU.surveyMapUsed, self)
					BMU.savedVarsAcc.infoSurveyMapsNotification = true
				end,
				function()
					-- leave feature on default (disabled)
					BMU.savedVarsAcc.infoSurveyMapsNotification = true
				end)
		end
		--]]
	else	-- normal case - when BMU window is opened		
		-- BeamMeUp guild notification
		if not BMU.savedVarsAcc.infoBMUGuild and not BMU_isPlayerInBMUGuild() and teleporterVars.BMUGuilds[GetWorldName()] ~= nil then
			BMU_showDialogSimple("NotificationBMUGuild", "BeamMeUp: Guilds", BMU_SI_get(SI.TELE_DIALOG_INFO_BMU_GUILD_BODY),
				function()
					BMU_requestGuildData()
					BMU_clearInputFields()
					zo_callLater(function() BMU_createTableGuilds() end, 350)
					BMU.savedVarsAcc.infoBMUGuild = true
				end,
				function()
					BMU.savedVarsAcc.infoBMUGuild = true
				end)
		end		
	end
end
BMU_showNotification = BMU.showNotification  --INS251229 Baertram


-- Helper functions for zone-specific house preferences
function BMU.setZoneSpecificHouse(zoneId, houseId)
	if not BMU.savedVarsServ.zoneSpecificHouses then
		BMU.savedVarsServ.zoneSpecificHouses = {}
	end
	BMU.savedVarsServ.zoneSpecificHouses[zoneId] = houseId
end

function BMU.getZoneSpecificHouse(zoneId)
	if not BMU.savedVarsServ.zoneSpecificHouses then
		return nil
	end
	return BMU.savedVarsServ.zoneSpecificHouses[zoneId]
end
BMU_getZoneSpecificHouse = BMU.getZoneSpecificHouse

function BMU.clearZoneSpecificHouse(zoneId)
	if BMU.savedVarsServ.zoneSpecificHouses then
		BMU.savedVarsServ.zoneSpecificHouses[zoneId] = nil
	end
end


-- Params:
--   useCurrentZone   (boolean) respect zone-specific mapping
--   explicitZoneId   (number|nil) zoneId to check mapping for; defaults to current displayed zone
--   jumpOutside      (boolean|nil) nil defaults to true, false forces inside
--   fallbackHouseId  (number|nil) houseId to use if no mapping exists for the zone
function BMU.portToOwnHouseWithZonePreference(useCurrentZone, explicitZoneId, jumpOutside, fallbackHouseId)
	BMU_formatName = BMU_formatName or BMU.formatName												--INS251229 Baertram
	BMU_getParentZoneId = BMU_getParentZoneId or BMU.getParentZoneId								--INS251229 Baertram
	BMU_portToOwnHouse = BMU_portToOwnHouse or BMU.portToOwnHouse									--INS251229 Baertram

	-- resolve zone to use
	local resolvedZoneId = explicitZoneId or GetZoneId(GetCurrentMapZoneIndex())
	local parentZoneId = BMU_getParentZoneId(resolvedZoneId)
	local zoneName = BMU_formatName(GetZoneNameById(parentZoneId), false)
	-- default outside unless explicitly false
	local goOutside = (jumpOutside ~= false)

	if useCurrentZone then
		BMU_getZoneSpecificHouse = BMU_getZoneSpecificHouse or BMU.getZoneSpecificHouse		 		--INS251229 Baertram
		local preferredHouseId = BMU_getZoneSpecificHouse(parentZoneId)
		if preferredHouseId then
			BMU_portToOwnHouse(false, preferredHouseId, goOutside, (zoneName ~= "" and zoneName) or nil)
			return
		end
	end

	-- no mapping -> try fallback house (e.g., the clicked house)
	if fallbackHouseId then
		BMU_portToOwnHouse(false, fallbackHouseId, goOutside, (zoneName ~= "" and zoneName) or nil)
		return
	end

	-- final fallback -> primary residence
	BMU_portToOwnHouse(true, nil, goOutside, nil)
end


local function OnAddOnLoaded(eventCode, addOnName)
    if (appName ~= addOnName) then return end

	--Read the addon version from the addon's txt manifest file tag ##AddOnVersion
	local function GetAddonVersionFromManifest()
		local addOn_Name
		local ADDON_MANAGER = GetAddOnManager()
		for i = 1, ADDON_MANAGER:GetNumAddOns() do
			addOn_Name = ADDON_MANAGER:GetAddOnInfo(i)
			if addOn_Name == appName then
				return ADDON_MANAGER:GetAddOnVersion(i)
			end
		end
		return -1
		-- Fallback: return the -1 version if AddOnManager was not read properly
	end
	--Set the version dynamically
	teleporterVars.version = tostring(GetAddonVersionFromManifest())

    teleporterVars.isAddonLoaded = true

	--Libraries
	BMU.GetLibraries() --Check if any BMU.* library variable needs an update


    BMU.DefaultsAccount = {
		["pos_MapScene_x"] = -15,
		["pos_MapScene_y"] = 63,
		["pos_x"] = -15,
		["pos_y"] = 63,
		["anchorMapOffset_x"] = 0,
		["anchorMapOffset_y"] = 0,
		["anchorOnMap"] = true,
        ["ShowOnMapOpen"] = true,
		["HideOnMapClose"] = true,
        ["AutoPortFreq"]  = 300,
		["zoneOnceOnly"] = true,
		["autoRefresh"] = true,
		["hideOthers"] = true,
		["hidePVP"] = true,
		["hideClosedDungeons"] = true,
		["hideHouses"] = false,
		["hideDelves"] = false,
		["hidePublicDungeons"] = false,
		["savedGold"] = 0,
		["windowStay"] = false,
		["onlyMaps"] = false,
		["autoRefreshFreq"] = 5,
		["focusZoneSearchOnOpening"] = false,
		["formatZoneName"] = false,
		["numberLines"] = 10,
		["fixedWindow"] = false,
		["secondLanguage"] = 1,  -- 1 = disabled, 2 = English, 3 = German, 4 = French, 5 = Russian, 6 = Japanese
		["closeOnPorting"] = true,
		["showNumberPlayers"] = true,
		["totalPortCounter"] = 0,
		["chatButton"] = true,
		["chatButtonHorizontalOffset"] = 0,
		["portCounterPerZone"] = {},
		["searchCharacterNames"] = false,
		["HintOfflineWhisper"] = true,
		["FavoritePlayerStatusNotification"] = true,
		["Scale"] = 1,
		["infoBMUGuild"] = false, -- false = not yet read
		["surveyMapsNotification"] = false,
		["infoFavoritePlayerStatusNotification"] = false, -- false = not yet read
		["infoSurveyMapsNotification"] = false, -- false = not yet read
		["showOpenButtonOnMap"] = true,
		["surveyMapsNotificationSound"] = true,
		["wayshrineTravelAutoConfirm"] = false,
		["currentZoneAlwaysTop"] = false,
		["currentViewedZoneAlwaysTop"] = false,
		["hideOwnHouses"] = false,
		["showOfflineReminder"] = true,
		["lastPortedZones"] = {},
		["initialTimeStamp"] = GetTimeStamp(),
		["showTeleportAnimation"] = true,
		["usePanAndZoom"] = true,
		["useMapPing"] = false,
		["showZonesWithoutPlayers2"] = true,
		["chatOutputFastTravel"] = true,
		["chatOutputAdditional"] = true,
		["chatOutputUnlock"] = true,
    }
    
	BMU.DefaultsServer = {
		["prioritizationSource"] = {BMU.SOURCE_INDEX_FRIEND, BMU.SOURCE_INDEX_GUILD[1], BMU.SOURCE_INDEX_GUILD[2], BMU.SOURCE_INDEX_GUILD[3], BMU.SOURCE_INDEX_GUILD[4], BMU.SOURCE_INDEX_GUILD[5]}, -- default: friends - guild1 - guild2 - guild3 - guild4 - guild5
		["favoriteListZones"] = {},
		["favoriteListPlayers"] = {},
		["lastofflineReminder"] = 1632859025, -- just a timestamp (2021/09/28)
		["favoriteDungeon"] = 0, -- zone_id of the favorite dungeon
		["houseCustomSorting"] = {},
		["houseFurnitureCount_LII"] = {}, -- maps houseId with furniture count
		["favoriteListWayshrines"] = {},
		["zoneSpecificHouses"] = {}, -- maps zoneId to preferred houseId for that zone
	}
	
	BMU.DefaultsCharacter = {
		["defaultTab"] = 0,
		["sorting"] = 2,
		["scanBankForMaps"] = true,
		["showAllDelves"] = false,
		["dungeonFinder"] = {
			["showArenas"] = true,
			["showGroupArenas"] = true,
			["showDungeons"] = true,
			["showTrials"] = true,
			["showEndlessDungeons"] = true,
			["sortByReleaseASC"] = true,
			["sortByReleaseDESC"] = false,
			["sortByAcronym"] = false,
			["toggleShowAcronymUpdateName"] = false,
			["toggleShowZoneNameDungeonName"] = false,
		},
		["displayAntiquityLeads"] = { -- "displayLeads" was already used in the past (boolean)
			["srcyable"] = true,
			["scried"] = true,
			["completed"] = true,
		},
		["displayMaps"] = {
			["treasure"] = true,
			["alchemist"] = true,
			["enchanter"] = true,
			["woodworker"] = true,
			["blacksmith"] = true,
			["clothier"] = true,
			["jewelry"] = true,
			["clue"] = true,
		},
		["displayCounterPanel"] = true,
		["houseNickNames"] = false,
		["ptfHouseZoneNames"] = false,
	}

	--Add the LibZone datatable to Teleporter -> See event_add_on_loaded as LibZone will be definitely loaded then
	--due to the ##DependsOn: LibZone entry in this addon's manifest file BeamMeUp.txt
	local BMU_LibZoneGivenZoneData = {} 															--INS251229 Baertram
	if BMU_LibZone and BMU_LibZone.GetAllZoneData then
		-- LibZone >= v6
		BMU_LibZoneGivenZoneData = BMU_LibZone:GetAllZoneData()
		if ZO_IsTableEmpty(BMU_LibZoneGivenZoneData) then
			d("[" .. appName .. " - ERROR] LibZone zone data is missing. Please update the library!")
		end
	else
		d("[" .. appName .. " - ERROR] Error when accessing LibZone library: Please update & enable the library!")
	end
	BMU.LibZoneGivenZoneData = BMU_LibZoneGivenZoneData

	--[[
		February 2022
		Switch from global variables only to global, server dependent and character dependet variables
		July 2022
		Removed addon capability to detect and transfer old saved vars (before Feb. 2022 and version 2.6.0)
	--]]
	BMU.savedVarsAcc =  ZO_SavedVars:NewAccountWide(SVTabName, 			2, nil, BMU.DefaultsAccount, 	nil)
	BMU.savedVarsServ = ZO_SavedVars:NewAccountWide(SVTabName, 			3, nil, BMU.DefaultsServer, 	GetWorldName())
	BMU.savedVarsChar = ZO_SavedVars:NewCharacterIdSettings(SVTabName, 	3, nil, BMU.DefaultsCharacter, 	nil)
	local BMU_savedVarsAcc = BMU.savedVarsAcc
	
	BMU.TeleporterSetupUI(addOnName)
	
    EM:RegisterForEvent(appName, EVENT_PLAYER_ACTIVATED, PlayerInitAndReady)
	
	worldMapScene_Keyboard:RegisterCallback("StateChange", 	BMU_onWorldMapStateChanged)
    worldMapScene_Gamepad:RegisterCallback("StateChange", 	BMU_onWorldMapStateChanged)

	CM:RegisterCallback("OnWorldMapChanged", BMU_onWorldMapChanged)

	ZO_PreHookHandler(worldMapZoneStoryTLC_Keyboard, "OnShow", BMU_onZoneGuideShow)
		
	EM:RegisterForEvent(appName, EVENT_GAME_CAMERA_UI_MODE_CHANGED, BMU_cameraModeChanged)
	
	EM:RegisterForEvent(appName, EVENT_SOCIAL_ERROR, BMU.socialErrorWhilePorting)

	--- initialize slash commands
	BMU.activateSlashCommands()

	-- initialize category map
	BMU_initializeCategoryMap()
	
	-- refresh quest location data cache
	EM:RegisterForEvent(appName, EVENT_QUEST_ADDED, 					BMU_journalUpdated)
	EM:RegisterForEvent(appName, EVENT_QUEST_REMOVED, 					BMU_journalUpdated)
	EM:RegisterForEvent(appName, EVENT_QUEST_CONDITION_COUNTER_CHANGED, BMU_journalUpdated)
	
	-- if necessary show center screen message that the player is still offline -> cannot receive any whisper messages
	if BMU_savedVarsAcc.showOfflineReminder then
		EM:RegisterForEvent(appName, EVENT_PLAYER_STATUS_CHANGED, function(_, _, newStatus) if (newStatus == PLAYER_STATUS_OFFLINE) then BMU.playerStatusChangedToOffline = true end end)
		EM:RegisterForEvent(appName, EVENT_CHAT_MESSAGE_CHANNEL, BMU.showOfflineNote)
	end

	-- Show Note, when a favorite player goes online
	if BMU_savedVarsAcc.FavoritePlayerStatusNotification then
		EM:RegisterForEvent(appName, EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED, BMU.FavoritePlayerStatusNotification)
		EM:RegisterForEvent(appName, EVENT_FRIEND_PLAYER_STATUS_CHANGED, BMU.FavoritePlayerStatusNotification)
	end
	
	-- Show Note, when survey map is mined and there are still some identical maps left
	if BMU_savedVarsAcc.surveyMapsNotification then
		SharedInv:RegisterCallback("SingleSlotInventoryUpdate", BMU.surveyMapUsed)
	end
	
	-- Auto confirm dailog when using wayshrines
	if BMU_savedVarsAcc.wayshrineTravelAutoConfirm then
		BMU_activateWayshrineTravelAutoConfirm()
	end
	
	-- activate Link Handler for handling clicks on chat links
	LH:RegisterCallback(LH.LINK_MOUSE_UP_EVENT, BMU.handleChatLinkClick)
	
	--Request BMU guilds and partner guilds information
	--zo_callLater(function() BMU.requestGuildData() end, 5000)

	-- activate guild admin tools -- Needs LibCustomMenu
	local displayName = GetDisplayName()
	local adminAccountsAllowed = {
		["@DeadSoon"] = true,
		["@Gamer1986PAN"] = true,
		["@Pandora959"] = true,
		["@Sokarx"] = true,
		["@Knifekill1984"] = true,
		["@BeamMeUp-Addon"] = true,
	}
	if adminAccountsAllowed[displayName] == true then
		-- add context menu in guild roster and application roster
		zo_callLater(function()
			BMU.AdminAddContextMenuToGuildRoster()
			BMU.AdminAddContextMenuToGuildApplicationRoster()
			BMU.AdminAddTooltipInfoToGuildApplicationRoster()
			BMU.AdminAddAutoFillToDeclineApplicationDialog()
		end, 5000)
		-- write welcome message to chat when you accept application (automatically welcome)
		EM:RegisterForEvent(appName, EVENT_GUILD_FINDER_PROCESS_APPLICATION_RESPONSE, BMU.AdminAutoWelcome)
	end
end


----> START HERE

EM:RegisterForEvent(appName, EVENT_ADD_ON_LOADED, OnAddOnLoaded)



----