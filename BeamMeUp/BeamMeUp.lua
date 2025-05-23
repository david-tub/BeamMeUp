local SI = BMU.SI
local teleporterVars = BMU.var
local appName = teleporterVars.appName

--Old code from TeleUnicorn -> Moved directly to Teleporter to strip the library
BMU.throttled = {}
local current_ms, last_render_ms
function BMU.throttle(key, frequency)
	current_ms = GetFrameTimeMilliseconds() / 1000.0
	last_render_ms = BMU.throttled[key] or 0

	if current_ms > (last_render_ms + frequency) then
		BMU.throttled[key] = current_ms
		return false
	end

	return true
end

local function alertTeleporterLoaded()
    EVENT_MANAGER:UnregisterForEvent(appName, EVENT_PLAYER_ACTIVATED)
	-- register events for own houses furniture count update
	EVENT_MANAGER:RegisterForEvent(appName, EVENT_PLAYER_ACTIVATED, BMU.updateHouseFurnitureCount)
	EVENT_MANAGER:RegisterForEvent(appName, EVENT_HOUSE_FURNITURE_COUNT_UPDATED, BMU.updateHouseFurnitureCount)
end


local function PlayerInitAndReady()
    zo_callLater(function() alertTeleporterLoaded() end, 1500)
end


----------------------------------- KeyBinds
function BMU.PortalHandlerKeyPress(keyPressIndex, favorite)
	-- Port to Group Leader
	if keyPressIndex == 12 then
		BMU.portToGroupLeader()
		return
	end
	
	-- Port to current zone
	if keyPressIndex == 17 then
		BMU.portToCurrentZone()
		return
	end
	
	-- Port to currently tracked/focused quest
	if keyPressIndex == 19 then
		BMU.portToTrackedQuestZone()
		return
	end
	
	-- Port to any available zone (first entry from main list)
	if keyPressIndex == 20 then
		BMU.portToAnyZone()
		return
	end

	-- Port into own Primary Residence
	if keyPressIndex == 13 then
		BMU.portToOwnHouse(true, nil, false, nil)
		return
	end
	
	-- Port outside own Primary Residence
	if keyPressIndex == 18 then
		BMU.portToOwnHouse(true, nil, true, nil)
		return
	end
	
	-- Port to BMU guild house
	if keyPressIndex == 14 then
		BMU.portToBMUGuildHouse()
		return
	end
	
	-- Unlock Wayshrines
	if keyPressIndex == 10 then
		BMU.showDialogAutoUnlock()
		return
	end
	
	-- Zone Favorites
	if keyPressIndex == 15 then
		local fZoneId = BMU.savedVarsServ.favoriteListZones[favorite]
			if fZoneId == nil then
				BMU.printToChat(SI.get(SI.TELE_CHAT_FAVORITE_UNSET))
				return
			end
		local result = BMU.createTable({index=BMU.indexListZoneHidden, fZoneId=fZoneId, dontDisplay=true})
		local firstRecord = result[1]
		if firstRecord.displayName ~= "" then
			BMU.PortalToPlayer(firstRecord.displayName, firstRecord.sourceIndexLeading, firstRecord.zoneName, firstRecord.zoneId, firstRecord.category, true, true, true)
		elseif firstRecord.isOwnHouse then
			BMU.portToOwnHouse(false, firstRecord.houseId, true, firstRecord.parentZoneName)
		else
			BMU.printToChat(BMU.formatName(GetZoneNameById(fZoneId), BMU.savedVarsAcc.formatZoneName) .. " - " .. SI.get(SI.TELE_CHAT_NO_FAST_TRAVEL))
		end
		return
	end
	
	-- Player Favorites
	if keyPressIndex == 16 then
		local displayName = BMU.savedVarsServ.favoriteListPlayers[favorite]
			if displayName == nil then
				BMU.printToChat(SI.get(SI.TELE_CHAT_FAVORITE_UNSET))
				return
			end
		local result = BMU.createTable({index=BMU.indexListSearchPlayer, inputString=displayName, dontDisplay=true})
		local firstRecord = result[1]
		if firstRecord.displayName == "" then
			BMU.printToChat(displayName .. " - " .. SI.get(SI.TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL))
		else
			BMU.PortalToPlayer(firstRecord.displayName, firstRecord.sourceIndexLeading, firstRecord.zoneName, firstRecord.zoneId, firstRecord.category, true, false, true)
		end
		return
	end

	-- Wayshrine Favorites
	if keyPressIndex == 21 then
		local nodeIndex = BMU.savedVarsServ.favoriteListWayshrines[favorite]
		if nodeIndex == nil then
			BMU.printToChat(SI.get(SI.TELE_CHAT_FAVORITE_UNSET))
			return
		end
		local _, name, _, _, _, _, _, _, _ = GetFastTravelNodeInfo(nodeIndex)
		if GetInteractionType() ~= INTERACTION_FAST_TRAVEL then
			-- only show info message if the player is not interacting with a wayshrine
			BMU.printToChat(GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. BMU.formatName(name) .. " (" .. zo_strformat(SI_MONEY_FORMAT, GetRecallCost()) .. ")", BMU.MSG_FT)
		end
		FastTravelToNode(nodeIndex)
		return
	end
	
    -- Show/Hide UI with specific Tab
	if BMU.win.Main_Control:IsHidden() then
		-- window is hidden
		if keyPressIndex == 11 then
			-- do nothing if window is hidden and user refresh manually
			return
		end
		
		-- open specific tab
		SetGameCameraUIMode(true)
		BMU.OpenTeleporter(false)
		if keyPressIndex == 6 then
			-- dungeon finder
			BMU.createTableDungeons()
		elseif keyPressIndex == 7 then
			-- own houses
			BMU.createTableHouses()
		else
			BMU.createTable({index=keyPressIndex})
		end
	else
		-- window is shown
		if keyPressIndex == 11 then -- Refresh list
			BMU.refreshListAuto()
		else
			if keyPressIndex ~= BMU.state and BMU.state ~= BMU.indexListDungeons and BMU.state ~= BMU.indexListOwnHouses then
				-- index is different -> switch tab but bypass the special states (Dungeon Finder, Own Houses)
				if keyPressIndex == 6 then
					-- dungeon finder
					BMU.createTableDungeons()
				elseif keyPressIndex == 7 then
					-- own houses
					BMU.createTableHouses()
				else
					BMU.createTable({index=keyPressIndex})
				end
			else
				-- same index -> hide UI
				BMU.HideTeleporter()
				SetGameCameraUIMode(false)
			end
		end
    end
end
-----------------------------------


function BMU.onMapShow()
	-- no support for gamepad mode + stay hidden when using the "HarvestFarmTour Editor"
	if BMU.win.Main_Control:IsHidden() and not IsInGamepadPreferredMode() and not SCENE_MANAGER:IsShowing("HarvestFarmScene") then
		if BMU.savedVarsAcc.ShowOnMapOpen then
			-- just open Teleporter
			BMU.OpenTeleporter(true)
		else
			-- display button to open Teleporter
			if BMU.win.MapOpen then
				BMU.win.MapOpen:SetHidden(false)
			end
		end
	else
		-- BMU is open -> update position
		BMU.updatePosition()
	end
end


function BMU.onMapHide()
	-- hide button
	if BMU.win.MapOpen then
		BMU.win.MapOpen:SetHidden(true)
	end
	
	-- decide if it stays
	if BMU.savedVarsAcc.HideOnMapClose then
		BMU.HideTeleporter()
	else
		BMU.updatePosition()
	end
	
	-- hide ZoneGuide (just to be on the safe side)
	BMU.toggleZoneGuide(false)
end


-- solves incompatibility issue to Votan's Minimap
function BMU.onWorldMapStateChanged(oldState, newState)
    if (newState == SCENE_SHOWING) then
        BMU.onMapShow()
    elseif (newState == SCENE_HIDING) then
        BMU.onMapHide()
    end
end


-- callback to refresh the list if the player changes the current displayed map/zone
function BMU.onWorldMapChanged(wasNavigateIn)
	BMU.refreshListAuto(true)
end


function BMU.OpenTeleporter(refresh)
	-- show notification (in case)
	BMU.showNotification()
	
	if not ZO_WorldMapZoneStoryTopLevel_Keyboard:IsHidden() then
		--hide ZoneGuide
		BMU.toggleZoneGuide(false)
		-- show swap button
		BMU.closeBtnSwitchTexture(true)
	else
		--show normal close button
		BMU.closeBtnSwitchTexture(false)
	end
	
	-- positioning window
	BMU.updatePosition()

	if BMU.win.MapOpen then
		 -- hide open button
		BMU.win.MapOpen:SetHidden(true)
	end
    BMU.win.Main_Control:SetHidden(false) -- show main window
	BMU.initializeBlacklist()
	if BMU.savedVarsAcc.autoRefresh and refresh then
		-- reset input and load default tab
		BMU.clearInputFields()
		
		if BMU.savedVarsChar.defaultTab == BMU.indexListOwnHouses then
			BMU.createTableHouses()
		elseif BMU.savedVarsChar.defaultTab == BMU.indexListDungeons then
			BMU.createTableDungeons()
		else
			BMU.createTable({index=BMU.savedVarsChar.defaultTab})
		end
	end
	
	-- start auto refresh
	if BMU.savedVarsAcc.autoRefreshFreq ~= 0 then
		zo_callLater(function() BMU.startCountdownAutoRefresh() end, BMU.savedVarsAcc.autoRefreshFreq*1000)
	end
	
	-- focus search box if enabled
	if BMU.savedVarsAcc.focusZoneSearchOnOpening then
		BMU.win.Searcher_Zone:TakeFocus()
	end
end


function BMU.HideTeleporter()
    BMU.win.Main_Control:SetHidden(true) -- hide main window
	ClearMenu() -- close all submenus
	ZO_Tooltips_HideTextTooltip() -- close all tooltips
	
	if SCENE_MANAGER:IsShowing("worldMap") then
		-- show button only when main window is hidden and world map is open
		if BMU.win.MapOpen then
			BMU.win.MapOpen:SetHidden(false)
		end
		
		-- show ZoneGuide
		BMU.toggleZoneGuide(true)
	end
end



function BMU.cameraModeChanged()
	if not BMU.savedVarsAcc.windowStay then
		-- hide window, when player moved or camera mode changed
		if not IsGameCameraUIModeActive() then
			BMU.HideTeleporter()
		end
	end
end



-- triggered when ZoneGuide will be displayed (e.g. when worldMap is open and zone changed)
function BMU.onZoneGuideShow()
	--check if Teleporter is displayed
	if not BMU.win.Main_Control:IsHidden() then
		-- Teleporter is displayed -> hide ZoneGuide
		BMU.toggleZoneGuide(false)
	end
end


-- show/hide ZoneGuide window
function BMU.toggleZoneGuide(show)
	if show then
		-- show ZoneGuide
		--ZO_WorldMapZoneStoryTopLevel_Keyboard:SetHidden(false)
		--ZO_SharedMediumLeftPanelBackground:SetHidden(false)
		WORLD_MAP_SCENE:AddFragment(WORLD_MAP_ZONE_STORY_KEYBOARD_FRAGMENT)
	else
		-- hide ZoneGuide
		--ZO_WorldMapZoneStoryTopLevel_Keyboard:SetHidden(true)
		--ZO_SharedMediumLeftPanelBackground:SetHidden(true)
		WORLD_MAP_SCENE:RemoveFragment(WORLD_MAP_ZONE_STORY_KEYBOARD_FRAGMENT)
	end
end


----------------------------
function BMU.initializeBlacklist()
	-- check which blacklists are activated and merge them together to one HashMap
	BMU.blacklist = {}
	
	-- hide Others (inaccessible zones)
	if BMU.savedVarsAcc.hideOthers then
		BMU.joinBlacklist(BMU.blacklistOthers)
		BMU.joinBlacklist(BMU.blacklistRefuges)
		BMU.joinBlacklist(BMU.blacklistSoloArenas)
	end
	
	-- hide PVP zones
	if BMU.savedVarsAcc.hidePVP then
		BMU.joinBlacklist(BMU.blacklistCyro)
		BMU.joinBlacklist(BMU.blacklistImpCity)
		BMU.joinBlacklist(BMU.blacklistBattlegrounds)
	end

	-- hide 4 men Dungeons, 12 men Raids, Group Zones, Group Arenas & Endless Dungeons
	if BMU.savedVarsAcc.hideClosedDungeons then
		BMU.joinBlacklist(BMU.blacklistGroupDungeons)
		BMU.joinBlacklist(BMU.blacklistRaids)
		BMU.joinBlacklist(BMU.blacklistGroupZones)
		BMU.joinBlacklist(BMU.blacklistGroupArenas)
		BMU.joinBlacklist(BMU.blacklistEndlessDungeons)
	end
	
	-- hide Houses
	if BMU.savedVarsAcc.hideHouses then
		BMU.joinBlacklist(BMU.blacklistHouses)
	end
	
	-- hide Delves
	if BMU.savedVarsAcc.hideDelves then
		BMU.joinBlacklist(BMU.getAllDelves())
	end
	
	-- hide Public Dungeons
	if BMU.savedVarsAcc.hidePublicDungeons then
		BMU.joinBlacklist(BMU.getAllPublicDungeons())
	end
end


function BMU.initializeCategoryMap()
	BMU.CategoryMap = {}
	-- go over each category list and add to hash map
	
	-- Delves
	for index, value in pairs(BMU.getAllDelves()) do
		BMU.CategoryMap[value] = BMU.ZONE_CATEGORY_DELVE
	end
	
	-- Public Dungeons
	for index, value in pairs(BMU.getAllPublicDungeons()) do
		BMU.CategoryMap[value] = BMU.ZONE_CATEGORY_PUBDUNGEON
	end

	-- Houses
	for index, value in pairs(BMU.blacklistHouses) do
		BMU.CategoryMap[value] = BMU.ZONE_CATEGORY_HOUSE
	end
	
	-- 4 men Group Dungeons
	for index, value in pairs(BMU.blacklistGroupDungeons) do
		BMU.CategoryMap[value] = BMU.ZONE_CATEGORY_GRPDUNGEON
	end
	
	-- 12 men Raids (Trials)
	for index, value in pairs(BMU.blacklistRaids) do
		BMU.CategoryMap[value] = BMU.ZONE_CATEGORY_TRAIL
	end

	-- Endless Dungeons
	for index, value in pairs(BMU.blacklistEndlessDungeons) do
		BMU.CategoryMap[value] = BMU.ZONE_CATEGORY_ENDLESSD
	end
	
	-- Group Zones
	for index, value in pairs(BMU.blacklistGroupZones) do
		BMU.CategoryMap[value] = BMU.ZONE_CATEGORY_GRPZONES
	end
	
	-- Group Arenas
	for index, value in pairs(BMU.blacklistGroupArenas) do
		BMU.CategoryMap[value] = BMU.ZONE_CATEGORY_GRPARENA
	end
	
	-- Solo Arenas
	for index, value in pairs(BMU.blacklistSoloArenas) do
		BMU.CategoryMap[value] = BMU.ZONE_CATEGORY_SOLOARENA
	end
	
	-- Overland Zones
	for parentZoneId, tableObject in pairs(BMU.overlandDelvesPublicDungeons) do
		BMU.CategoryMap[parentZoneId] = BMU.ZONE_CATEGORY_OVERLAND
	end
end

----------------------------

-- call function after countdown and repeat
function BMU.startCountdownAutoRefresh()
	if not BMU.win.Main_Control:IsHidden() and not BMU.blockAutoRefreshCycle then
		BMU.blockAutoRefreshCycle = true
		if not BMU.pauseAutoRefresh then
			BMU.refreshListAuto()
		end
		zo_callLater(function()
			BMU.blockAutoRefreshCycle = false
			BMU.startCountdownAutoRefresh()
		end, BMU.savedVarsAcc.autoRefreshFreq*1000)
	end
end

-- displays notifications
-- itemTabClicked = true -> Tab for treasure and survey maps was clicked
function BMU.showNotification(itemTabClicked)
	-- 2022_08_29
	-- check if the latest LibZone version is installed
	if not BMU.LibZone.GetZoneMapPinInfo or not BMU.LibZone.GetZoneGeographicalParentZoneId then
		-- show dialog
		BMU.showDialogSimple("LibZoneOutdated", "Outdated LibZone version", "The installed version of LibZone is outdated. Please update the LibZone library, otherwise BeamMeUp will not work properly.\n\nIf you dont use Minion Addon Manager, you can open the LibZone website by accepting this dialog.", function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info2171-LibZone.html") end, nil)
	end

	-- only if treasure and survey map tab was clicked
	if itemTabClicked then
		-- new feature: Survey Maps Notification
		--[[ TEMPORARILY DEACTIVATED UNTIL FEATURE IS WORKING PROPERLY (notification comes also when moving maps to bank or chest)
		if not BMU.savedVarsAcc.infoSurveyMapsNotification and not BMU.savedVarsAcc.surveyMapsNotification then
			BMU.showDialogSimple("NotificationBMUNewFeatureSMN", "NEW FEATURE", SI.get(SI.TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION),
				function()
					-- enable feature
					BMU.savedVarsAcc.surveyMapsNotification = true
					SHARED_INVENTORY:RegisterCallback("SingleSlotInventoryUpdate", BMU.surveyMapUsed, self)
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
		if not BMU.savedVarsAcc.infoBMUGuild and not BMU.isPlayerInBMUGuild() and BMU.var.BMUGuilds[GetWorldName()] ~= nil then
			BMU.showDialogSimple("NotificationBMUGuild", "BeamMeUp: Guilds", SI.get(SI.TELE_DIALOG_INFO_BMU_GUILD_BODY),
				function()
					BMU.requestGuildData()
					BMU.clearInputFields()
					zo_callLater(function() BMU.createTableGuilds() end, 350)
					BMU.savedVarsAcc.infoBMUGuild = true
				end,
				function()
					BMU.savedVarsAcc.infoBMUGuild = true
				end)
		end		
	end
end


function BMU.isPlayerInBMUGuild()
	if BMU.var.BMUGuilds[GetWorldName()] ~= nil then
		for _, guildId in pairs(BMU.var.BMUGuilds[GetWorldName()]) do
			if IsPlayerInGuild(guildId) then
				return true
			end
		end
	end
	return false
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
	BMU.LibZoneGivenZoneData = {}
	local libZone = BMU.LibZone
	if libZone then
		-- LibZone >= v6
		if libZone.GetAllZoneData then
			BMU.LibZoneGivenZoneData = libZone:GetAllZoneData()
		-- LibZone <= v5 (backup)
		elseif libZone.givenZoneData then
			BMU.LibZoneGivenZoneData = libZone.givenZoneData
		else
			d("[" .. appName .. " - ERROR] LibZone zone data is missing!")
		end
	else
		d("[" .. appName .. " - ERROR] Error when accessing LibZone library!")
	end

	--[[
		February 2022
		Switch from global variables only to global, server dependent and character dependet variables
		July 2022
		Removed addon capability to detect and transfer old saved vars (before Feb. 2022 and version 2.6.0)
	--]]
	BMU.savedVarsAcc = ZO_SavedVars:NewAccountWide("BeamMeUp_SV", 2, nil, BMU.DefaultsAccount, nil)
	BMU.savedVarsServ = ZO_SavedVars:NewAccountWide("BeamMeUp_SV", 3, nil, BMU.DefaultsServer, GetWorldName())
	BMU.savedVarsChar = ZO_SavedVars:NewCharacterIdSettings("BeamMeUp_SV", 3, nil, BMU.DefaultsCharacter, nil)
	
	
	BMU.TeleporterSetupUI(addOnName)
	
    EVENT_MANAGER:RegisterForEvent(appName, EVENT_PLAYER_ACTIVATED, PlayerInitAndReady)
	
	WORLD_MAP_SCENE:RegisterCallback("StateChange", BMU.onWorldMapStateChanged)
    GAMEPAD_WORLD_MAP_SCENE:RegisterCallback("StateChange", BMU.onWorldMapStateChanged)

	CALLBACK_MANAGER:RegisterCallback("OnWorldMapChanged", BMU.onWorldMapChanged)

	ZO_PreHookHandler(ZO_WorldMapZoneStoryTopLevel_Keyboard, "OnShow", BMU.onZoneGuideShow)
		
	EVENT_MANAGER:RegisterForEvent(appName, EVENT_GAME_CAMERA_UI_MODE_CHANGED, BMU.cameraModeChanged)
	
	EVENT_MANAGER:RegisterForEvent(appName, EVENT_SOCIAL_ERROR, BMU.socialErrorWhilePorting)

	--- initialize slash commands
	BMU.activateSlashCommands()

	-- initialize category map
	BMU.initializeCategoryMap()
	
	-- refresh quest location data cache
	EVENT_MANAGER:RegisterForEvent(appName, EVENT_QUEST_ADDED, BMU.journalUpdated)
	EVENT_MANAGER:RegisterForEvent(appName, EVENT_QUEST_REMOVED, BMU.journalUpdated)
	EVENT_MANAGER:RegisterForEvent(appName, EVENT_QUEST_CONDITION_COUNTER_CHANGED, BMU.journalUpdated)
	
	-- if necessary show center screen message that the player is still offline -> cannot receive any whisper messages
	if BMU.savedVarsAcc.showOfflineReminder then
		EVENT_MANAGER:RegisterForEvent(appName, EVENT_PLAYER_STATUS_CHANGED, function(_, _, newStatus) if (newStatus == 4) then BMU.playerStatusChangedToOffline = true end end)
		EVENT_MANAGER:RegisterForEvent(appName, EVENT_CHAT_MESSAGE_CHANNEL, BMU.showOfflineNote)
	end

	-- Show Note, when a favorite player goes online
	if BMU.savedVarsAcc.FavoritePlayerStatusNotification then
		EVENT_MANAGER:RegisterForEvent(appName, EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED, BMU.FavoritePlayerStatusNotification)
		EVENT_MANAGER:RegisterForEvent(appName, EVENT_FRIEND_PLAYER_STATUS_CHANGED, BMU.FavoritePlayerStatusNotification)
	end
	
	-- Show Note, when survey map is mined and there are still some identical maps left
	if BMU.savedVarsAcc.surveyMapsNotification then
		SHARED_INVENTORY:RegisterCallback("SingleSlotInventoryUpdate", BMU.surveyMapUsed)
	end
	
	-- Auto confirm dailog when using wayshrines
	if BMU.savedVarsAcc.wayshrineTravelAutoConfirm then
		BMU.activateWayshrineTravelAutoConfirm()
	end
	
	-- activate Link Handler for handling clicks on chat links
	LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_MOUSE_UP_EVENT, BMU.handleChatLinkClick)
	
	--Request BMU guilds and partner guilds information
	--zo_callLater(function() BMU.requestGuildData() end, 5000)

	-- activate guild admin tools
	local displayName = GetDisplayName()
	if displayName == "@DeadSoon" or displayName == "@Gamer1986PAN" or displayName == "@Pandora959" or displayName == "@Sokarx" or displayName == "@Knifekill1984" or displayName == "@BeamMeUp-Addon" then
		-- add context menu in guild roster and application roster
		zo_callLater(function()
			BMU.AdminAddContextMenuToGuildRoster()
			BMU.AdminAddContextMenuToGuildApplicationRoster()
			BMU.AdminAddTooltipInfoToGuildApplicationRoster()
			BMU.AdminAddAutoFillToDeclineApplicationDialog()
		end, 5000)
		-- write welcome message to chat when you accept application (automatically welcome)
		EVENT_MANAGER:RegisterForEvent(appName, EVENT_GUILD_FINDER_PROCESS_APPLICATION_RESPONSE, BMU.AdminAutoWelcome)
	end
end


----> START HERE

EVENT_MANAGER:RegisterForEvent(appName, EVENT_ADD_ON_LOADED, OnAddOnLoaded)



----