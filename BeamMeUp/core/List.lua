local BMU = BMU --INS251229 Baertram Performancee gain, not searching _G for BMU each time again!

local SI = BMU.SI
local teleporterVars = BMU.var
local appName = teleporterVars.appName
local SVTabName = teleporterVars.savedVariablesName

-- -v- INS251229 Baertram BEGIN 0
--Performance reference
----variables (defined now, as they were loaded before this file -> see manifest .txt)
--ZOs variables
local CM = CALLBACK_MANAGER
local EM = EVENT_MANAGER
local wm = WINDOW_MANAGER
local SM = SCENE_MANAGER
local worldMapManager = WORLD_MAP_MANAGER
local playerTag = "player"
local worldName = GetWorldName()
local myDisplayName = GetDisplayName()
local tos = tostring
local ton = tonumber
local string = string
local string_match = string.match
local string_lower = string.lower
local string_gsub = string.gsub
local string_format = string.format
local table = table
local table_insert = table.insert
local table_remove = table.remove
local table_sort = table.sort
--Other addon variables
local BMU_LibZone = BMU.LibZone
local BMU_LibSets = BMU.LibSets
local LSM = BMU.LSM

--Other addon variables
---v- INS BEARTRAM 20260125 LibScrollableMenu
local AddCustomScrollableMenuEntry 		= AddCustomScrollableMenuEntry
local ClearCustomScrollableMenu 		= ClearCustomScrollableMenu
local AddCustomScrollableMenuDivider    = AddCustomScrollableMenuDivider
local AddCustomScrollableMenuHeader    = AddCustomScrollableMenuHeader
local AddCustomScrollableSubMenuEntry 	= AddCustomScrollableSubMenuEntry
local ShowCustomScrollableMenu 			= ShowCustomScrollableMenu
local GetCustomScrollableMenuRowData    = GetCustomScrollableMenuRowData
local PreventCustomScrollableContextMenuHide = PreventCustomScrollableContextMenuHide
--local PreventCustomScrollableContextMenuEntryClickHide = PreventCustomScrollableContextMenuEntryClickHide
local RefreshCustomScrollableMenu = RefreshCustomScrollableMenu
local LSM_UPDATE_MODE_BOTH 			= LSM_UPDATE_MODE_BOTH
local LSM_ENTRY_TYPE_HEADER			= LSM_ENTRY_TYPE_HEADER
local LSM_ENTRY_TYPE_RADIOBUTTON    = LSM_ENTRY_TYPE_RADIOBUTTON
local LSM_ENTRY_TYPE_DIVIDER 		= LSM_ENTRY_TYPE_DIVIDER
local teleportStr = GetString(SI_GAMEPAD_HELP_UNSTUCK_TELEPORT_KEYBIND_TEXT)

--[[
local function refreshLSMMainAndSubMenuOfMOC(control, comboBox)
  RefreshCustomScrollableMenu((control ~= nil and control) or moc(), LSM_UPDATE_MODE_BOTH, comboBox) --Update the opening mainmenu's entry to refresh the shown favorites
end
]]
---^- INS BEARTRAM 20260125 LibScrollableMenu

--BMU variables
local BMU_textures = BMU.textures
local BMU_ZONE_CATEGORY_UNKNOWN = BMU.ZONE_CATEGORY_UNKNOWN
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
local colorLegendary = ZO_ColorDef:New(teleporterVars.color.colLegendary)
local guildHousesAtServer = teleporterVars.guildHouse[worldName]
local BMUGuildsAtServer = teleporterVars.BMUGuilds[worldName]

local BMU_indexListMain 					= BMU.indexListMain
local BMU_indexListCurrentZone 				= BMU.indexListCurrentZone
local BMU_indexListSearchPlayer 			= BMU.indexListSearchPlayer
local BMU_indexListSearchZone 				= BMU.indexListSearchZone
local BMU_indexListItems					= BMU.indexListItems
local BMU_indexListDelves 					= BMU.indexListDelves
local BMU_indexListZoneHidden				= BMU.indexListZoneHidden
local BMU_indexListSource 					= BMU.indexListSource
local BMU_indexListZone						= BMU.indexListZone
local BMU_indexListQuests 					= BMU.indexListQuests
local BMU_indexListOwnHouses				= BMU.indexListOwnHouses
local BMU_indexListPTFHouses 				= BMU.indexListPTFHouses
local BMU_indexListGuilds 					= BMU.indexListGuilds
local BMU_indexListDungeons					= BMU.indexListDungeons

local BMU_SOURCE_INDEX_FRIEND 				= BMU.SOURCE_INDEX_FRIEND
local BMU_SOURCE_INDEX_GROUP 				= BMU.SOURCE_INDEX_GROUP
local BMU_SOURCE_INDEX_GUILD				= BMU.SOURCE_INDEX_GUILD
local BMU_SOURCE_INDEX_OWNHOUSES			= BMU.SOURCE_INDEX_OWNHOUSES

----functions
--ZOs functions
local GetZoneNameById = GetZoneNameById
local GetCurrentMapZoneIndex = GetCurrentMapZoneIndex
local GetZoneId = GetZoneId
local select = select
local RequestJumpToHouse = RequestJumpToHouse
local CancelCast = CancelCast
local FastTravelToNode = FastTravelToNode
local IsPlayerInGroup = IsPlayerInGroup
local GetGroupSize = GetGroupSize
local GetGroupUnitTagByIndex = GetGroupUnitTagByIndex
local GetUnitDisplayName = GetUnitDisplayName
local IsUnitGrouped = IsUnitGrouped
local IsUnitGroupLeader = IsUnitGroupLeader
local IsUnitSoloOrGroupLeader = IsUnitSoloOrGroupLeader
local GroupInviteByName = GroupInviteByName
local GroupPromote = GroupPromote
local GroupKick = GroupKick
local GroupLeave = GroupLeave
local BeginGroupElection = BeginGroupElection
local StartChatInput = StartChatInput
local JumpToHouse = JumpToHouse
local RemoveFriend = RemoveFriend
local RequestFriend = RequestFriend
local InviteToTributeByDisplayName = InviteToTributeByDisplayName
local IsPlayerInGuild = IsPlayerInGuild
local GetGuildMemberIndexFromDisplayName = GetGuildMemberIndexFromDisplayName
local GetInteractionType = GetInteractionType
local GetNumFastTravelNodes = GetNumFastTravelNodes
local UseCollectible = UseCollectible
local GetCollectibleCooldownAndDuration = GetCollectibleCooldownAndDuration
local IsCollectibleUsable = IsCollectibleUsable
local IsCollectibleUnlocked = IsCollectibleUnlocked
local JumpToGuildMember = JumpToGuildMember
local JumpToFriend = JumpToFriend
local JumpToGroupMember = JumpToGroupMember
local IsMounted = IsMounted
local CanLeaveCurrentLocationViaTeleport = CanLeaveCurrentLocationViaTeleport
local IsUnitDead = IsUnitDead
local GetUnitZoneIndex = GetUnitZoneIndex
local GetNormalizedPositionForZoneStoryActivityId = GetNormalizedPositionForZoneStoryActivityId
local GetZoneActivityIdForZoneCompletionType = GetZoneActivityIdForZoneCompletionType
local IsZoneStoryActivityComplete = IsZoneStoryActivityComplete
local GetNumZoneActivitiesForZoneCompletionType = GetNumZoneActivitiesForZoneCompletionType
local zo_callLater = zo_callLater
local CanJumpToPlayerInZone = CanJumpToPlayerInZone

--BMU functions
local BMU_SI_Get 							= SI.get
local BMU_colorizeText 						= BMU.colorizeText
local BMU_printToChat 						= BMU.printToChat
local BMU_getItemTypeIcon 					= BMU.getItemTypeIcon


----variables (defined inline in code below, upon first usage, as they are still nil at this line)
--BMU UI variables
local BMU_win, BMU_win_Main_Control
-------functions (defined inline in code below, upon first usage, as they are still nil at this line)
local BMU_isZoneOverlandZone, BMU_categorizeZone, BMU_showDialogSimple, BMU_prepareAutoUnlock, BMU_formatName, BMU_getZoneWayshrineCompletion,
      BMU_startAutoUnlock, BMU_proceedAutoUnlock, BMU_finishedAutoUnlock, BMU_createTable, BMU_shuffle_table, BMU_has_value,
	  BMU_PortalToPlayer, BMU_showAutoUnlockProceedDialog, BMU_formatGold, BMU_showDialogCustom, BMU_startAutoUnlockLoopSorted,
	  BMU_startAutoUnlockLoopRandom, BMU_round, BMU_createTablePTF, BMU_OpenTeleporter, BMU_getMapIndex, BMU_createTableHouses,
      BMU_isWholeWordInString, BMU_clearZoneSpecificHouse, BMU_setZoneSpecificHouse, BMU_getZoneSpecificHouse, BMU_getLowestNumber,
	  BMU_createTableDungeons, BMU_refreshListAuto, BMU_getNumSetCollectionProgressPieces, BMU_showDialogAutoUnlock, BMU_addFavoriteZone,
	  BMU_removeFavoriteZone, BMU_isFavoriteZone, BMU_createMail, BMU_portToOwnHouse, BMU_HideTeleporter, BMU_showTeleportAnimation,
      BMU_PortalToZone, BMU_portToParentZone, BMU_isFavoritePlayer, BMU_removeFavoritePlayer, BMU_addFavoritePlayer,
	  BMU_findExactQuestLocation, BMU_sc_porting, BMU_getParentZoneId, BMU_clickOnTeleportToOwnHouseButton, BMU_clickOnTeleportToOwnHouseButton_2,
      BMU_tooltipTextEnter, BMU_clickOnTeleportToPTFHouseButton, BMU_clickOnOpenGuild, BMU_clickOnTeleportToDungeonButton, BMU_clickOnTeleportToPlayerButton,
	  BMU_checkIfContextMenuIconShouldShow
-- -^- INS251229 Baertram END 0


local LINES_OFFSET = 45
local SLIDER_WIDTH = 25
-- Make self available to everything in this file
local self = {}
--local mColor = {}
local controlWidth = 0
local totalPortals = 0

local mutexCounter = 0

--local knownWayshrinesBefore = 0
--local knownWayshrinesAfter = 0
--local totalWayshrines = 0

-- Utility / local functions

local function clamp(val, min_, max_)
    val = math.max(val, min_)
    return math.min(val, max_)
end

local function normalTextureForAuto()
	BMU_win = BMU_win or BMU.win
	BMU_win_Main_Control = BMU_win_Main_Control or BMU_win.Main_Control
    BMU_win_Main_Control.portalToAllTexture:SetTexture(BMU_textures.wayshrineBtn2)
end

local function activeTextureForAuto()
	BMU_win = BMU_win or BMU.win
	BMU_win_Main_Control = BMU_win_Main_Control or BMU_win.Main_Control
	BMU_win_Main_Control.portalToAllTexture:SetTexture(BMU_textures.wayshrineBtnOver2)
end

local function tableItemNameSortFunc(entry1, entry2)
	return entry1.itemName < entry2.itemName
end

------------------------------------------------------------

-- closing interface and starting auto unlock core process
function BMU.prepareAutoUnlock(zoneId, loopType, loopZoneList)
	BMU_startAutoUnlock = BMU_startAutoUnlock or BMU.startAutoUnlock
	BMU_HideTeleporter = BMU_HideTeleporter or BMU.HideTeleporter
	-- hide world map if open
	SM:Hide("worldMap")
	-- hide UI if open
	BMU_HideTeleporter()
	-- delay function call, otherwise the auto-unlock-dialog fails (for whatever reason)
	zo_callLater(function() BMU_startAutoUnlock(zoneId, loopType, loopZoneList) end, 150)
end
BMU_prepareAutoUnlock = BMU.prepareAutoUnlock

-- does all the necessary checks for the given zoneId (if auto unlock is possible)
-- starts the auto unlock core process
function BMU.checkAndStartAutoUnlockOfZone(zoneId)
	BMU_isZoneOverlandZone = BMU_isZoneOverlandZone or BMU.isZoneOverlandZone
	BMU_getZoneWayshrineCompletion = BMU_getZoneWayshrineCompletion or BMU.getZoneWayshrineCompletion
	BMU_formatName = BMU_formatName or BMU.formatName
	BMU_showDialogSimple = BMU_showDialogSimple or BMU.showDialogSimple
	BMU_prepareAutoUnlock = BMU_prepareAutoUnlock or BMU.prepareAutoUnlock

	if not BMU_isZoneOverlandZone(zoneId) or not CanJumpToPlayerInZone(zoneId) then
		-- zone is no OverlandZone OR user has no access to zone (DLC) -> show dialog, that unlocking is not possible
		BMU_showDialogSimple("RefuseAutoUnlock2", BMU_SI_Get(SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE), BMU_formatName(GetZoneNameById(zoneId), false) .. ": " .. BMU_SI_Get(SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2), nil, nil)
		return
	end
	
	-- get number of wayhsrines of the current map
	local numWayshrines, numWayshrinesDiscovered = BMU_getZoneWayshrineCompletion(zoneId)
	if numWayshrinesDiscovered >= numWayshrines then
		-- show dialog, that unlocking is not longer possible
		BMU_showDialogSimple("RefuseAutoUnlock", BMU_SI_Get(SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE), BMU_formatName(GetZoneNameById(zoneId), false) .. ": " .. BMU_SI_Get(SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY) .. BMU_colorizeText(" (" .. numWayshrinesDiscovered .. "/" .. numWayshrines .. ")", "green"), nil, nil)
		return
	end
	BMU_prepareAutoUnlock(zoneId, nil, nil)
end

------------ AUTO UNLOCK CORE PROCESS ------------
-- initialization
function BMU.startAutoUnlock(zoneId, loopType, loopZoneList)
	BMU_proceedAutoUnlock = BMU_proceedAutoUnlock or BMU.proceedAutoUnlock
	BMU_formatName = BMU_formatName or BMU.formatName
	BMU_showDialogSimple = BMU_showDialogSimple or BMU.showDialogSimple
	BMU_getZoneWayshrineCompletion = BMU_getZoneWayshrineCompletion or BMU.getZoneWayshrineCompletion
	BMU_createTable = BMU_createTable or BMU.createTable

	-- ensure unlock process is not already running
	if not BMU.uwData or not BMU.uwData.isStarted then
		local formattedZoneName = BMU_formatName(GetZoneNameById(zoneId), false)
		local list = BMU_createTable({index=BMU_indexListZone, fZoneId=zoneId, noOwnHouses=true, dontDisplay=true})
		-- check if list is empty
		local firstRecord = list[1]
		if #list == 0 or not firstRecord or firstRecord.displayName == "" then
			BMU_showDialogSimple("AutoUnlockNoPlayer", BMU_SI_Get(SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE), formattedZoneName .. ": " .. BMU_SI_Get(SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY3), nil, nil)
			return
		end
		
		-- change texture of the button
		activeTextureForAuto()
		
		-- get wayshrine discovery info for that current map
		local numWayshrines, numWayshrinesDiscovered = BMU_getZoneWayshrineCompletion(zoneId)
		
		-- set global variables
		BMU.uwData = {
			isStarted = true,
			dialogName = "BMU_AutoUnlockInProgress",
			zoneId = zoneId,
			fZoneName = formattedZoneName,
			unlockedWayshrines = 0,
			displayNameList = {},
			totalWayshrines = numWayshrines,
			discoveredWayshrinesBefore = numWayshrinesDiscovered,
			totalSteps = #list, -- store #list and update only if the new number is higher than before
			loopType = loopType, -- can be nil
			loopZoneList = loopZoneList, -- can be nil
			gainedXP = 0
		}
		
		-- unregiter existing event for furniture count
		EM:UnregisterForEvent(appName, EVENT_PLAYER_ACTIVATED)
		-- register for event when coming out from loading screen
		EM:RegisterForEvent(appName, EVENT_PLAYER_ACTIVATED, function() zo_callLater(function() BMU_proceedAutoUnlock() end, 1500) end)
		-- register for event when gaining XP from wayshrine discovery
		EM:RegisterForEvent(appName, EVENT_EXPERIENCE_GAIN, function(eventCode, reason, level, previousExperience, currentExperience, championPoints)
			if BMU.uwData.isStarted then
				BMU.uwData.gainedXP = BMU.uwData.gainedXP + (currentExperience-previousExperience)
			end
		end)
		
		-- initiate fast travel loop
		BMU_proceedAutoUnlock()
	end
end
BMU_startAutoUnlock = BMU.startAutoUnlock


-- loop of the automatic teleportation
function BMU.proceedAutoUnlock()
	BMU_getZoneWayshrineCompletion = BMU_getZoneWayshrineCompletion or BMU.getZoneWayshrineCompletion
	BMU_finishedAutoUnlock = BMU_finishedAutoUnlock or BMU.finishedAutoUnlock
	BMU_createTable = BMU_createTable or BMU.createTable
	BMU_shuffle_table = BMU_shuffle_table or BMU.shuffle_table
	BMU_has_value = BMU_has_value or BMU.has_value
	BMU_PortalToPlayer = BMU_PortalToPlayer or BMU.PortalToPlayer
	BMU_showAutoUnlockProceedDialog = BMU_showAutoUnlockProceedDialog or BMU.showAutoUnlockProceedDialog

	-- only proceed if feature is active
	if BMU.uwData.isStarted then
		local _, allUnlockedWayshrines = BMU_getZoneWayshrineCompletion(BMU.uwData.zoneId)
		
		-- Note: multiple wayshrine can be discovered at once
		BMU.uwData.unlockedWayshrines = allUnlockedWayshrines - BMU.uwData.discoveredWayshrinesBefore
		
		-- check if the zone is now complete
		if allUnlockedWayshrines == BMU.uwData.totalWayshrines then
			-- just finish
			BMU_finishedAutoUnlock("wayshrinesComplete")
			return
		end
		
		-- get all travel options
		local list = BMU_createTable({index=BMU_indexListZone, fZoneId=BMU.uwData.zoneId, dontDisplay=true})
		
		if #list ~= 0 or list[1].displayName ~= "" then
			-- re-calculate total steps in case new players come available during process
			-- totalSteps = currentStep(#displayNameList) + number of players which are in list but not in displayNameList
			BMU.uwData.totalSteps = #BMU.uwData.displayNameList
			
			-- shuffle list of players (sort randomly)
			list = BMU_shuffle_table(list)
			local nextPlayer
			for _, record in pairs(list) do
				-- check list of players to which we traveled already
				if record.displayName ~= "" and not BMU_has_value(BMU.uwData.displayNameList, record.displayName) then
					-- open player
					if not nextPlayer then
						-- identify next player for jump if not already set
						nextPlayer = record
					end
					-- count to determine the number of open players
					BMU.uwData.totalSteps = BMU.uwData.totalSteps + 1
				end
			end
			
			if nextPlayer then
				-- start travel
				BMU_PortalToPlayer(nextPlayer.displayName, nextPlayer.sourceIndexLeading, nextPlayer.zoneName, nextPlayer.zoneId, nextPlayer.category, false, false, false)
				-- add player to list
				table_insert(BMU.uwData.displayNameList, nextPlayer.displayName)
				-- NOTE: handling of fast travel error in function BMU.finishedAutoUnlock() in case of timeout
				-- show dialog with all infos
				BMU_showAutoUnlockProceedDialog(nextPlayer)
				return
			end
		end
		-- finish, no open player found
		BMU_finishedAutoUnlock("finished")
	end
end
BMU_proceedAutoUnlock = BMU.proceedAutoUnlock


-- button to abort complete process
-- (later: button to skip a step? --> maybe the zone of the next player changed?)
-- shows dialog with all infos and handles user cancelation and timeout
function BMU.showAutoUnlockProceedDialog(record)
	BMU_getZoneWayshrineCompletion = BMU_getZoneWayshrineCompletion or BMU.getZoneWayshrineCompletion
	BMU_formatGold = BMU_formatGold or BMU.formatGold
	BMU_finishedAutoUnlock = BMU_finishedAutoUnlock or BMU.finishedAutoUnlock
	BMU_showDialogCustom = BMU_showDialogCustom or BMU.showDialogCustom

	-- gather all infos
	local currentStep = #BMU.uwData.displayNameList
	local totalSteps = BMU.uwData.totalSteps
	--local currentDisplayName = record.displayName
	local totalWayhsrines = BMU.uwData.totalWayshrines
	local _, allUnlockedWayshrines = BMU_getZoneWayshrineCompletion(BMU.uwData.zoneId)
	local unlockedWayshrinesString = BMU.uwData.unlockedWayshrines
	-- colorize
	if BMU.uwData.unlockedWayshrines > 0 then
		unlockedWayshrinesString = BMU_colorizeText(BMU.uwData.unlockedWayshrines, "green")
	end
	-- colorize if XP was gained
	local gainedXPString = BMU_formatGold(BMU.uwData.gainedXP)
	if BMU.uwData.gainedXP > 0 then
		gainedXPString = BMU_colorizeText(gainedXPString, "yellow")
	end
	
	local body =
		BMU_SI_Get(SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART) .. "\n\n" ..
		BMU_SI_Get(SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY) .. " " .. tos(unlockedWayshrinesString) .. " (" .. tos(allUnlockedWayshrines) .. "/" .. tos(totalWayhsrines) .. ")" .. "\n" ..
		BMU_SI_Get(SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP) .. " " .. tos(gainedXPString) .. "\n\n" ..
		BMU_SI_Get(SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_PROGRESS) .. " " .. tos(currentStep) .."/" .. tos(totalSteps) .. "\n" ..
		GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. tos(record.displayName)
	
	local countdown = GetTimeStamp() + 8
	local globalDialogName
	local dialogReference
	local remainingSec
	
	-- local function to update the dialog body (to append the countdown)
	local function setTextParameter(parameter)
		ZO_Dialogs_UpdateDialogMainText(dialogReference, {text=body .. "\n\n" .. BMU_SI_Get(SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_TIMER) .. " <<1>>\n"}, {parameter})
	end

	-- local function that is called continously
	local function update()
		remainingSec = countdown - GetTimeStamp()
		-- check for timeout and abort
		if remainingSec < -4 then
			-- abort -> close dialog and finish
			ZO_Dialogs_ReleaseDialog(globalDialogName)
			BMU_finishedAutoUnlock("timeout")
		else
			setTextParameter(BMU_colorizeText(tos(math.max(remainingSec, 0)), "red"))
		end
	end
	
	-- local function that is triggered when the dialog finished (canceled, disappeared etc.)
	local function dialogFinished()
		if remainingSec > 0 then
			PlaySound(SOUNDS.DIALOG_DECLINE)
			-- finishedCallback is also triggered when entering the loading screen
			-- -> consider only during countdown
			-- timeout is handled via update function
			BMU_printToChat(BMU_SI_Get(SI_TELE_CHAT_AUTO_UNLOCK_CANCELED), BMU.MSG_UL)
			BMU_finishedAutoUnlock("canceled")
		end
	end
	
	local dialogInfo = {
		canQueue = true,
		showLoadingIcon = ZO_Anchor:New(BOTTOM, ZO_Dialog1Text, BOTTOM, 0, 20),
		title = {text = BMU.uwData.fZoneName},
		mainText = {align = TEXT_ALIGN_LEFT, text = body},
		buttons = {
			{
				text = SI_DIALOG_CANCEL,
                keybind = "DIALOG_NEGATIVE",
			}
		},
		finishedCallback = dialogFinished,
		updateFn = update,
	}
		
	globalDialogName, dialogReference = BMU_showDialogCustom(BMU.uwData.dialogName, dialogInfo)
end
BMU_showAutoUnlockProceedDialog = BMU.showAutoUnlockProceedDialog


-- finalize auto unlock and show dialog
function BMU.finishedAutoUnlock(reason)
	BMU_proceedAutoUnlock = BMU_proceedAutoUnlock or BMU.proceedAutoUnlock
	BMU_formatGold = BMU_formatGold or BMU.formatGold
	BMU_showDialogSimple = BMU_showDialogSimple or BMU.showDialogSimple
	BMU_startAutoUnlockLoopRandom = BMU_startAutoUnlockLoopRandom or BMU.startAutoUnlockLoopRandom
	BMU_startAutoUnlockLoopSorted = BMU_startAutoUnlockLoopSorted or BMU.startAutoUnlockLoopSorted

	-- check if the timeout was caused by a fast travel error (loading screen)
	if BMU.flagSocialErrorWhilePorting ~= 0  and reason == "timeout" then
		BMU.flagSocialErrorWhilePorting = 0
		-- just proceed with next player
		BMU_printToChat(BMU_SI_Get(SI_TELE_CHAT_AUTO_UNLOCK_SKIP), BMU.MSG_UL)
		BMU_proceedAutoUnlock()
		return
	end
	
	CancelCast()
	
	-- unregister events
	EM:UnregisterForEvent(appName, EVENT_PLAYER_ACTIVATED)
	EM:UnregisterForEvent(appName, EVENT_DISCOVERY_EXPERIENCE)
	-- register again event for furniture count
	EM:RegisterForEvent(appName, EVENT_PLAYER_ACTIVATED, BMU.updateHouseFurnitureCount)

	-- set flag to "inactivate" the proceed function (if unregister failed or it is called for some other reasons)
	BMU.uwData.isStarted = false
	-- restore button texture
	normalTextureForAuto()
	-- show all infos in dialog
	local unlockedWayshrinesString = BMU.uwData.unlockedWayshrines
	-- colorize if one or more wayshrines were unlocked
	if BMU.uwData.unlockedWayshrines > 0 then
		unlockedWayshrinesString = BMU_colorizeText(BMU.uwData.unlockedWayshrines, "green")
	end
	local allUnlockedWayshrines = BMU.uwData.discoveredWayshrinesBefore + BMU.uwData.unlockedWayshrines
	local totalWayshrinesString = allUnlockedWayshrines .. "/" .. BMU.uwData.totalWayshrines
	-- colorize if zone is complete
	if allUnlockedWayshrines == BMU.uwData.totalWayshrines then
		totalWayshrinesString = BMU_colorizeText(totalWayshrinesString, "green")
	end
	-- colorize if XP was gained
	local gainedXPString = BMU_formatGold(BMU.uwData.gainedXP)
	if BMU.uwData.gainedXP > 0 then
		gainedXPString = BMU_colorizeText(gainedXPString, "yellow")
	end
		
	if reason == "timeout" then
		BMU_showDialogSimple("AutoUnlockTimeout", BMU_SI_Get(SI_TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_TITLE), BMU_SI_Get(SI_TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_BODY), nil, nil)
	end
	
	local finishDialogTitle = BMU.uwData.fZoneName
	local finishDialogBody =
		BMU_SI_Get(SI_TELE_DIALOG_FINISH_AUTO_UNLOCK_BODY_PART) .. "\n\n" ..
		BMU_SI_Get(SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY) .. " " .. tos(unlockedWayshrinesString) .. " (" .. tos(totalWayshrinesString) .. ")" .. "\n" ..
		BMU_SI_Get(SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP) .. " " .. tos(gainedXPString)
	
	local globalDialogName, dialogReference = BMU_showDialogSimple("AutoUnlockFinished", finishDialogTitle, finishDialogBody, nil, nil)

	-- print summary into chat
	BMU_printToChat(
		BMU.uwData.fZoneName .. ": " ..
		BMU_SI_Get(SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY) .. " " .. tos(unlockedWayshrinesString) .. " (" .. tos(totalWayshrinesString) .. ")  " ..
		BMU_SI_Get(SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP) .. " " .. tos(gainedXPString), BMU.MSG_UL)

	-- if continuing with next zones and process finished successfully
	local loopType = BMU.uwData.loopType
	if loopType and (reason == "finished" or reason == "wayshrinesComplete") then
		zo_callLater(function()
			ZO_Dialogs_ReleaseDialog(globalDialogName)
		end, 1700)
		zo_callLater(function()
			if loopType == "suffle" then
				BMU_startAutoUnlockLoopRandom(BMU.uwData.zoneId, loopType)
			else
				BMU_startAutoUnlockLoopSorted(BMU.uwData.loopZoneList, loopType)
			end
		end, 1750)
	end
end

------------------------

-- checks for zones that can be unlocked and picks a random one to start auto unlock
function BMU.startAutoUnlockLoopRandom(prevZoneId, loopType)
	BMU_createTable = BMU_createTable or BMU.createTable
	BMU_prepareAutoUnlock = BMU_prepareAutoUnlock or BMU.prepareAutoUnlock
	local overlandZoneIds = {}
	-- add all overlandZoneIds to a new table
	for overlandZoneId, _ in pairs(BMU.overlandDelvesPublicDungeons) do
		-- consider only zones the user has access to (DLC)
		if CanJumpToPlayerInZone(overlandZoneId) then
			table_insert(overlandZoneIds, overlandZoneId)
		end
	end
	
	-- sort the table randomly
	local shuffled = BMU.shuffle_table(overlandZoneIds)
	
	-- go over the zones and find one
	for _, zoneId in ipairs(shuffled) do
		if zoneId ~= prevZoneId then -- dont take the same zone twice in a row
			local list = BMU_createTable({index=BMU_indexListZone, fZoneId=zoneId, noOwnHouses=true, dontDisplay=true})
			-- check if list is empty
			if #list > 0 and list[1] and list[1].displayName ~= "" then
				local numWayshrines, numWayshrinesDiscovered = BMU.getZoneWayshrineCompletion(zoneId)
				if numWayshrinesDiscovered < numWayshrines then		
					zo_callLater(function()
						BMU_prepareAutoUnlock(zoneId, loopType, nil)
					end, 400)
					return
				end
			end
		end
	end
	-- finished here: found no zone to unlock
	BMU.showDialogSimple("AutoUnlockLoopFinish", BMU_SI_Get(SI_TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE), BMU_SI_Get(SI_TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY), nil, nil)
end


-- checks for zones that can be unlocked, sort them and queue the list for auto unlock
function BMU.startAutoUnlockLoopSorted(zoneRecordList, loopType)
	BMU_createTable = BMU_createTable or BMU.createTable
	BMU_getZoneWayshrineCompletion = BMU_getZoneWayshrineCompletion or BMU.getZoneWayshrineCompletion
	BMU_startAutoUnlockLoopSorted = BMU_startAutoUnlockLoopSorted or BMU.startAutoUnlockLoopSorted
	BMU_showDialogSimple = BMU_showDialogSimple or BMU.showDialogSimple
	BMU_prepareAutoUnlock = BMU_prepareAutoUnlock or BMU.prepareAutoUnlock

	if not zoneRecordList or #zoneRecordList == 0 then
		local overlandZoneIds = {}
		local cleanZoneList = {}
		-- add all overlandZoneIds to a new table
		for overlandZoneId, _ in pairs(BMU.overlandDelvesPublicDungeons) do
			-- consider only zones the user has access to (DLC)
			if CanJumpToPlayerInZone(overlandZoneId) then
				--table_insert(overlandZoneIds, overlandZoneId)
				local resultList = BMU_createTable({index=BMU_indexListZone, fZoneId=overlandZoneId, noOwnHouses=true, dontDisplay=true})
				if #resultList > 0 and resultList[1] and resultList[1].displayName ~= "" then
					local numWayshrines, numWayshrinesDiscovered = BMU_getZoneWayshrineCompletion(overlandZoneId)
					if numWayshrinesDiscovered < numWayshrines then
						local record = {}
						record.zoneId = overlandZoneId
						record.numPlayers = #resultList
						record.zoneName = resultList[1].zoneName
						if numWayshrinesDiscovered == 0 then
							record.ratioWayshrines = 0 -- zones with no discovered wayhsrines get "highest prio" independent of the total number
						else
							record.ratioWayshrines = numWayshrinesDiscovered/numWayshrines
						end
						table_insert(cleanZoneList, record)
					end
				end
			end
		end
		-- sort zone records
		if loopType == "wayshrines" then
			-- sort by ratio of undiscovered wayshrines (where more can be released in percent)
			table.sort(cleanZoneList, function(a, b)
				return a.ratioWayshrines < b.ratioWayshrines
			end)
		elseif loopType == "players" then
			-- sort by number of players (where are less players (to prevent unecessary loops))
			table.sort(cleanZoneList, function(a, b)
				return a.numPlayers < b.numPlayers
			end)
		elseif loopType == "zonenames" then
			-- sort by zone name in alphabetical order
			table.sort(cleanZoneList, function(a, b)
				return a.zoneName < b.zoneName
			end)
		end
		zoneRecordList = cleanZoneList
	end
	
	-- at this moment: zoneRecordList was already given or was re-filled right now
	for index, zoneRecord in pairs(zoneRecordList) do
		local resultList = BMU_createTable({index=BMU_indexListZone, fZoneId=zoneRecord.zoneId, noOwnHouses=true, dontDisplay=true})
		if #resultList > 0 and resultList[1] and resultList[1].displayName ~= "" then
			table_remove(zoneRecordList, index)
			zo_callLater(function()
				BMU_prepareAutoUnlock(zoneRecord.zoneId, loopType, zoneRecordList)
			end, 400)
			return
		end
	end
	
	-- if records are still in list, we know that zones were skipped --> start loop again
	-- if no records are in list, we know that we could not find players/zones --> finish
		-- because 1.: if we skipped entries, see case before
		-- because 2.: in case the last entry was processed, it will automatically start again
	if #zoneRecordList > 0 then
		BMU_startAutoUnlockLoopSorted(nil, loopType)
		return
	end
	
	-- finished here: found no zone to unlock
	BMU_showDialogSimple("AutoUnlockLoopFinish", BMU_SI_Get(SI_TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE), BMU_SI_Get(SI_TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY), nil, nil)
end


-- shows confirmation dialog and starts AutoUnlock
-- zoneId: optional, if not set use current zone (where the player actually is)
function BMU.showDialogAutoUnlock(zoneId)
	-- use player's zone if no specific zoneId is given
	zoneId = zoneId or GetZoneId(GetUnitZoneIndex(playerTag))
	
	-- approach: create seperate control and anchor it to the default dialog control (ZO_Dialog1Text) (used by many dialogs)
	-- via the dialog's update function we can interact (show, hide etc.) with the control
	local controlName = "BMU_CustomDialogControl"
	local sectionControl = GetControl(controlName)
	
	if not sectionControl then
		local ZO_Dialog1Text = ZO_Dialog1Text
		local BMU_customDialogSection = WINDOW_MANAGER:CreateControl(controlName, ZO_Dialog1Text, nil)
		BMU.customDialogSection = BMU_customDialogSection
		BMU_customDialogSection:SetAnchor(BOTTOM, ZO_Dialog1Text, BOTTOM, 0, 140)
		BMU_customDialogSection:SetDimensions(ZO_Dialog1Text:GetWidth(), 70)
		
		-- create dropdown control
		BMU.customDialog_comboBox = CreateControlFromVirtual("BMU_CustomComboBoxControl", BMU_customDialogSection, "ZO_ComboBox")
		BMU.customDialog_comboBox:SetAnchor(TOPLEFT, BMU_customDialogSection, TOPLEFT, 20, 0)
		BMU.customDialog_comboBox:SetWidth(ZO_Dialog1Text:GetWidth()-20)
		
		BMU.customDialog_dropdownControl = ZO_ComboBox_ObjectFromContainer(BMU.customDialog_comboBox)
		BMU.customDialog_dropdownControl:SetSortsItems(false)
		-- add items
		local entry1 = BMU.customDialog_dropdownControl:CreateItemEntry(BMU_SI_Get(SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION1), function() end)
		entry1.key = "suffle"
		BMU.customDialog_dropdownControl:AddItem(entry1)
		
		local entry2 = BMU.customDialog_dropdownControl:CreateItemEntry(BMU_SI_Get(SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION2), function() end)
		entry2.key = "wayshrines"
		BMU.customDialog_dropdownControl:AddItem(entry2)
		
		local entry3 = BMU.customDialog_dropdownControl:CreateItemEntry(BMU_SI_Get(SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION3), function() end)
		entry3.key = "players"
		BMU.customDialog_dropdownControl:AddItem(entry3)

		local entry4 = BMU.customDialog_dropdownControl:CreateItemEntry(BMU_SI_Get(SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION4), function() end)
		entry4.key = "zonenames"
		BMU.customDialog_dropdownControl:AddItem(entry4)
		--
		
		-- create checkbox control
		BMU.customDialog_checkboxControl = CreateControlFromVirtual("BMU_CustomCheckboxControl", BMU_customDialogSection, "ZO_CheckButton")
		BMU.customDialog_checkboxControl:SetAnchor(BOTTOMLEFT, BMU_customDialogSection, BOTTOMLEFT, 0, 0)

		ZO_CheckButton_SetLabelText(BMU.customDialog_checkboxControl, BMU_SI_Get(SI_TELE_DIALOG_AUTO_UNLOCK_CHAT_LOG_OPTION))
		--ZO_CheckButton_SetTooltipText(BMU.customDialog_checkboxControl, "check to enable the log")
		
		BMU.customDialog_dropdownControl:SelectItem(entry1, true)
	end
	
	ZO_CheckButton_SetCheckState(BMU.customDialog_checkboxControl, BMU.savedVarsAcc.chatOutputUnlock)
	

	local globalDialogName
	local dialogReference
	local updateFlag = false
	
	-- local function that is called continously
	local function update()
		if not updateFlag then
			-- make checkbox control visible only once
			BMU.customDialogSection:SetHidden(false)
			updateFlag = true
		end
		
		local flagLoop = dialogReference.radioButtonGroup:GetClickedButton().data.loop
		if flagLoop then
			BMU.customDialog_comboBox:SetHidden(false)
		else
			BMU.customDialog_comboBox:SetHidden(true)
		end
	end
	
	local function hideCheckbox()
		-- hide checkbox control to prevent that is visible in any other dialogs
		BMU.customDialogSection:SetHidden(true)
		-- save status to savedVars
		local isChatLoggingChecked = ZO_CheckButton_IsChecked(BMU.customDialog_checkboxControl)
		BMU.savedVarsAcc.chatOutputUnlock = isChatLoggingChecked
	end
	
	local dialogInfo = {
		canQueue = true,
		title = {text = BMU_SI_Get(SI_TELE_DIALOG_AUTO_UNLOCK_TITLE)},
		mainText = {align = TEXT_ALIGN_LEFT, text = BMU_SI_Get(SI_TELE_DIALOG_AUTO_UNLOCK_BODY)},
		buttons = {
			{
				text = SI_DIALOG_CONFIRM,
                keybind = "DIALOG_PRIMARY",
				callback = function()
					local flagLoop = dialogReference.radioButtonGroup:GetClickedButton().data.loop
					local isChatLoggingChecked = ZO_CheckButton_IsChecked(BMU.customDialog_checkboxControl)
					BMU.savedVarsAcc.chatOutputUnlock = isChatLoggingChecked
					local selectedEntry = BMU.customDialog_dropdownControl:GetSelectedItemData()
					if flagLoop then
						if selectedEntry.key == "suffle" then
							-- directly start with random zones
							BMU.startAutoUnlockLoopRandom(nil, selectedEntry.key)
						else
							BMU.startAutoUnlockLoopSorted(nil, selectedEntry.key)
						end
					else
						-- check and start auto unlocking for given zoneId
						BMU.checkAndStartAutoUnlockOfZone(zoneId)
					end
				end,
			},
			{
				text = SI_DIALOG_CANCEL,
                keybind = "DIALOG_NEGATIVE",
				callback = nil,
			},
		},
		radioButtons = {
			{
				text = GetString(SI_ANTIQUITY_SCRYABLE_CURRENT_ZONE_SUBCATEGORY),
				data = {loop=false},
			},
			{
				text = BMU_SI_Get(SI_TELE_DIALOG_AUTO_UNLOCK_LOOP_OPTION),
				data = {loop=true},
			},
		},
		updateFn = update,
		finishedCallback = hideCheckbox,
		-- just to get more place in the dialog window (for custom checkbox control)
		warning = {text = " \n  \n"},
	}
	
	globalDialogName, dialogReference = BMU.showDialogCustom("ConfirmationAutoUnlock", dialogInfo)
end
BMU_showDialogAutoUnlock = BMU.showDialogAutoUnlock



------------------------------------------------------------

-- uses the zone completion data to find out how many wayhrines are discovered in the zone
-- since the ZoneGuide of e.g. Summerset includes the wayshrines of Artaeum, we need to seperate how many wayshrines are really in the zone 
-- returns:
-- 1. number of wayshrines that are located in the zone
-- 2. number of discovered wayshrines that are located in the zone
function BMU.getZoneWayshrineCompletion(zoneId)
	BMU_getMapIndex = BMU_getMapIndex or BMU.getMapIndex
	-- set the map to the correct one
	local mapIndex = BMU_getMapIndex(zoneId)
	if mapIndex ~= nil then
		-- switch to Tamriel and back to target map in order to reset any subzone or zoom
		worldMapManager:SetMapByIndex(1)
		worldMapManager:SetMapByIndex(mapIndex)
	end
	
	-- handling of special cases/zones
	-- check if the zone is a subzone that belongs to a main zone which holds the completion info only
	local mainZoneId = BMU.getMainZoneId(zoneId)
	if mainZoneId then
		zoneId = mainZoneId
	end
	
	local numWayshrines = 0
	local numWayshrinesDiscovered = 0
	-- get total number of wayshrines
	local countTotal = GetNumZoneActivitiesForZoneCompletionType(zoneId, ZONE_COMPLETION_TYPE_WAYSHRINES)
	for activityIndex = 1, countTotal do
		local isActivityComplete = IsZoneStoryActivityComplete(zoneId, ZONE_COMPLETION_TYPE_WAYSHRINES, activityIndex)
		local activityId = GetZoneActivityIdForZoneCompletionType(zoneId, ZONE_COMPLETION_TYPE_WAYSHRINES, activityIndex)
		local normalizedX, normalizedZ, normalizedRadius, isInCurrentMap = GetNormalizedPositionForZoneStoryActivityId(zoneId, ZONE_COMPLETION_TYPE_WAYSHRINES, activityId)
		if isInCurrentMap then
			-- wayshrine of the current map
			numWayshrines = numWayshrines + 1
			if isActivityComplete then
				numWayshrinesDiscovered = numWayshrinesDiscovered + 1
			end
		end
	end
	
	return numWayshrines, numWayshrinesDiscovered
end
BMU_getZoneWayshrineCompletion = BMU.getZoneWayshrineCompletion


-- return true if the zone is a Overland zone / region
function BMU.isZoneOverlandZone(zoneId)
	BMU_categorizeZone = BMU_categorizeZone or BMU.categorizeZone
	-- if zoneId is not given, get zone of player (where the player actually is)
	if not zoneId then
		local zoneIndex = GetUnitZoneIndex(playerTag)
		zoneId = GetZoneId(zoneIndex)
	end
	
	if BMU_categorizeZone(zoneId) == BMU_ZONE_CATEGORY_OVERLAND then
		return true
	else
		return false
	end
end
BMU_isZoneOverlandZone = BMU.isZoneOverlandZone


----------------------------------------------------
--- Function to Port to Players
-----------------------------------------------------
function BMU.PortalToPlayer(displayName, sourceIndex, zoneName, zoneId, zoneCategory, updateSavedGold, tryAgainOnError, printToChat)
	
	-- cut the numbers coming from "item related zones"
	local position = string.find(zoneName, "%(")
	if position ~= nil then
		zoneName = string.sub(zoneName, 1, position-2)
	end
	
	-- reset error flag
	BMU.flagSocialErrorWhilePorting = 0
	
	-- check if porting is possible
	if CanLeaveCurrentLocationViaTeleport() and not IsUnitDead(playerTag) then
		
		-- ESO Bug: If mounted, the player unmounts and nothing happens -> Workaround: start teleport to force unmount and start again automatically after delay
		-- check if mounted
		if IsMounted() then
			-- dont try again, it could interfere with the new delayed try
			tryAgainOnError = false
			zo_callLater(function() BMU.PortalToPlayer(displayName, sourceIndex, zoneName, zoneId, zoneCategory, false, true, false) end, 1500)
		end
	
		-- prophylactic cancel cast
		CancelCast()

		-- show additional animation
		if BMU.savedVarsAcc.showTeleportAnimation then
			BMU.showTeleportAnimation()
		end
		
		-- start porting
		if printToChat then
			BMU_printToChat(GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. displayName .. " - " .. zoneName, BMU.MSG_FT)
		end
		if sourceIndex == BMU_SOURCE_INDEX_GROUP then
			-- 2024/12: a bug was reported, that JumpToGroupLeader() no longer works probably in some cases --> only use JumpToGroupMember()
			JumpToGroupMember(displayName)
		elseif sourceIndex == BMU_SOURCE_INDEX_FRIEND then
			JumpToFriend(displayName)
		else
			-- sourceIndex > 3  -> guild 1-5
			JumpToGuildMember(displayName)
		end
		
		-- check if an error occurred while porting
		zo_callLater(function()
			if BMU.flagSocialErrorWhilePorting ~= 0 then
				-- error occurred
				if printToChat then
					BMU_printToChat(GetString(SI_FASTTRAVELKEEPRESULT9))
				end
				if tryAgainOnError then
					BMU.decideTryAgainPorting(BMU.flagSocialErrorWhilePorting, zoneId, displayName, sourceIndex, updateSavedGold)
				end
			else
				-- update saved gold
				if updateSavedGold then
					BMU.updateStatistic(zoneCategory, zoneId)
				end
			end
		end, 1800)
		-- if necessary show center screen message that the player is still offline
		BMU.showOfflineNote()
	else
		if printToChat then
			-- display message, that porting is not possible at the moment
			BMU_printToChat(GetString(SI_FASTTRAVELKEEPRESULT12))
		end
	end
end
BMU_PortalToPlayer = BMU.PortalToPlayer


-- shows special animation while teleporting by using a collectible ("Finvir's Trinket")
function BMU.showTeleportAnimation()
	local collectibleId = 336
	if IsCollectibleUnlocked(collectibleId) and IsCollectibleUsable(collectibleId) and GetCollectibleCooldownAndDuration(collectibleId) == 0 then
		UseCollectible(collectibleId)
	end
end


-- jump directly to wayshrine node in given zone (for gold)
function BMU.PortalToZone(zoneId)
	BMU_HideTeleporter = BMU_HideTeleporter or BMU.HideTeleporter
	BMU_getMapIndex = BMU_getMapIndex or BMU.getMapIndex
	BMU_showTeleportAnimation = BMU_showTeleportAnimation or BMU.showTeleportAnimation
	BMU_formatName = BMU_formatName or BMU.formatName

	-- set map and find wayshrine node
	local mapIndex = BMU_getMapIndex(zoneId)
	worldMapManager:SetMapByIndex(mapIndex)
	for nodeIndex = 1, GetNumFastTravelNodes() do
		local known, name, normalizedX, normalizedY, icon, glowIcon, poiType, isShownInCurrentMap, linkedCollectibleIsLocked = GetFastTravelNodeInfo(nodeIndex)
		if known and isShownInCurrentMap and poiType == POI_TYPE_WAYSHRINE then
			if GetInteractionType() == INTERACTION_FAST_TRAVEL then
				-- player is at wayshrine and travels for free -> dont show any chat printouts
				-- start travel to node
				FastTravelToNode(nodeIndex)
				return
			else
				BMU_printToChat(GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. BMU_formatName(GetZoneNameById(zoneId)) .. " (" .. zo_strformat(SI_MONEY_FORMAT, GetRecallCost()) .. ")", BMU.MSG_FT)
				-- show additional animation
				if BMU.savedVarsAcc.showTeleportAnimation then
					BMU_showTeleportAnimation()
				end
				-- start travel to node
				FastTravelToNode(nodeIndex)
				if BMU.savedVarsAcc.closeOnPorting then
					-- hide world map if open
					SM:Hide("worldMap")
					-- hide UI if open
					BMU_HideTeleporter()
				end
				return
			end
		end
	end
	-- found no wayshrine
	BMU_printToChat(BMU_SI_Get(SI_TELE_CHAT_NO_FAST_TRAVEL))
end


-- if necessary show center screen message that the player is still offline
function BMU.showOfflineNote(_, messageType)
	-- option is enabled + player does not set to offline since last reload + a blank call or it is outgoing whisper message + player is set to offline + last message was 24 hours ago
	if BMU.savedVarsAcc.showOfflineReminder and not BMU.playerStatusChangedToOffline and (not messageType or messageType == CHAT_CHANNEL_WHISPER_SENT) and GetPlayerStatus() == PLAYER_STATUS_OFFLINE and (GetTimeStamp() - BMU.savedVarsServ.lastofflineReminder > 86400) then
		CENTER_SCREEN_ANNOUNCE:AddMessage(0, CSA_CATEGORY_LARGE_TEXT, "Justice_NowKOS", BMU_SI_Get(SI_TELE_CENTERSCREEN_OFFLINE_NOTE_HEAD), BMU_SI_Get(SI_TELE_CENTERSCREEN_OFFLINE_NOTE_BODY), nil, nil, nil, nil, 10000, nil)
		BMU.savedVarsServ.lastofflineReminder = GetTimeStamp()
	end
end


-- Private API
local function _set_line_counts(self)
    --self.num_visible_lines = math.floor((self.control:GetHeight() - LINES_OFFSET*BMU.savedVarsAcc.Scale) / self.line_height)
    --self.num_visible_lines = math.min(self.num_visible_lines, #self.lines)
	self.num_visible_lines = math.min(BMU.savedVarsAcc.numberLines, #self.lines)

    self.num_hidden_lines = math.max(0, #self.lines - self.num_visible_lines)
    if self.num_hidden_lines == 0 then
        self.offset = 0
    end
end

local function _create_listview_row(self, i)
    local control = self.control
    local name = control:GetName() .. "_list" .. i
	
	-- get zone id of current zone (zoneIndex changes at each API update, zoneId is more robust)
	local currentZoneId = GetZoneId(GetCurrentMapZoneIndex())

	local scale = BMU.savedVarsAcc.Scale

    local list = wm:CreateControl(name, control, CT_CONTROL)
    list:SetHeight(self.line_height)

    local message = self.lines[i]

    if message ~= nil then
		-- RGB color code for mouse over feedback
		local bmuGoldColorRGB = colorLegendary
		
		list.ColumnNumberPlayers = wm:CreateControl(name .. "_NumberPlayers", list, CT_LABEL)
		list.ColumnNumberPlayers:SetDimensions(35*scale, 20*scale)
		list.ColumnNumberPlayers:SetFont(BMU.font1)
		list.ColumnNumberPlayers:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
		list.ColumnNumberPlayers:SetAnchor(0, list, 0, LEFT -40*scale, 50*scale)

		--Create another control (Texture) for MouseOver interactions
		list.ColumnNumberPlayersTex = WINDOW_MANAGER:CreateControl(name .. "_NumberPlayersOver", list.ColumnNumberPlayers, CT_TEXTURE)
		list.ColumnNumberPlayersTex:SetAnchorFill(list.ColumnNumberPlayers)
		list.ColumnNumberPlayersTex:SetMouseEnabled(true)
		list.ColumnNumberPlayersTex:SetDrawLayer(2)
		-- set rgb color instead of texture
		list.ColumnNumberPlayersTex:SetColor(bmuGoldColorRGB:UnpackRGBA())
		list.ColumnNumberPlayersTex:SetAlpha(0)

		
		-- COLUMN PLAYER NAME
		list.ColumnPlayerName = wm:CreateControl(name .. "_Player", list, CT_LABEL)
		list.ColumnPlayerName:SetDimensions(150*scale, 25*scale)
		list.ColumnPlayerName:SetFont(BMU.font1)
		list.ColumnPlayerName:SetAnchor(0, list, 0, LEFT, 50*scale)

		--Create another control (Texture) for Mouse interaction
		list.ColumnPlayerNameTex = WINDOW_MANAGER:CreateControl(name .. "_PlayerOver", list.ColumnPlayerName, CT_TEXTURE)
		list.ColumnPlayerNameTex:SetAnchorFill(list.ColumnPlayerName)
		list.ColumnPlayerNameTex:SetMouseEnabled(true)
		list.ColumnPlayerNameTex:SetDrawLayer(2)
		-- set rgb color instead of texture
		list.ColumnPlayerNameTex:SetColor(bmuGoldColorRGB:UnpackRGBA())
		list.ColumnPlayerNameTex:SetAlpha(0)


		controlWidth = control:GetWidth()
		list.frame = wm:CreateControl(name .. "_frame", list, CT_TEXTURE)
		list.frame:SetDimensions(controlWidth + 30*scale, 3*scale)
		list.frame:SetAnchor(0, list, 0, LEFT - 40*scale, 42*scale)

		list.frame:SetTexture("/esoui/art/guild/sectiondivider_left.dds")
		list.frame:SetTextureCoords(0, 1, 0, 1)
		list.frame:SetAlpha(0.7)


		-- COLUMN ZONE NAME
		list.ColumnZoneName = wm:CreateControl(name .. "_Zone", list, CT_LABEL)
		list.ColumnZoneName:SetDimensions(240*scale, 25*scale)
		list.ColumnZoneName:SetFont(BMU.font1)			
		list.ColumnZoneName:SetAnchor(0, list, 0, LEFT + 165*scale, 50*scale)

		-- Create another control (Texture) for Mouse interaction
		list.ColumnZoneNameTex = WINDOW_MANAGER:CreateControl(name .. "_ZoneOver", list.ColumnZoneName, CT_TEXTURE)
		list.ColumnZoneNameTex:SetAnchorFill(list.ColumnZoneName)
		list.ColumnZoneNameTex:SetMouseEnabled(true)
		list.ColumnZoneNameTex:SetDrawLayer(2)
		-- set rgb color instead of texture
		list.ColumnZoneNameTex:SetColor(bmuGoldColorRGB:UnpackRGBA())
		list.ColumnZoneNameTex:SetAlpha(0)


		list.portalToPlayerTex = WINDOW_MANAGER:CreateControl(name .. "_TeleTex", list, CT_TEXTURE)
		list.portalToPlayerTex:SetDimensions(45*scale, 45*scale)
		list.portalToPlayerTex:SetAnchor(0, list, 0, LEFT + 400*scale, 41*scale) --490 ... 15
		list.portalToPlayerTex:SetMouseEnabled(true)
		list.portalToPlayerTex:SetDrawLayer(2)
			
        return list
    end
end


local function _create_listview_lines_if_needed(self)
    local control = self.control

	local scale = BMU.savedVarsAcc.Scale

    -- Makes sure that the main control is filled up with line controls at all times.
    for i = 1, self.num_visible_lines do
        if control.lines[i] == nil then
            local line = _create_listview_row(self, i)
            control.lines[i] = line
			if i == 1 then
				line:SetAnchor(TOPLEFT, control, TOPLEFT, 0, LINES_OFFSET*scale)
			else
				line:SetAnchor(TOPLEFT, control.lines[i - 1], BOTTOMLEFT, 0, 0)
			end
        end
    end
end


local function _on_resize(self)
	BMU_round = BMU_round or BMU.round
    BMU.control_global_2 = self.control

    -- Need to calculate num_visible_lines etc. for the rest of this function.
    _set_line_counts(self)

    _create_listview_lines_if_needed(self)

	local scale = BMU.savedVarsAcc.Scale

    -- Represent how many lines are visible atm.
	-- on initialization #self.lines can be 0 -> prevent division with 0
	local viewable_lines_pct = 1
	if #self.lines > 0 then
		viewable_lines_pct = BMU_round(self.num_visible_lines / #self.lines, 1) or 1
	end
	
    -- Can we see all the lines?
    if viewable_lines_pct >= 1.0 then
        BMU.control_global_2.slider:SetHidden(true)
    else
        -- If not, make sure the slider is showing.
        BMU.control_global_2.slider:SetHidden(false)
        self.control.slider:SetMinMax(0, self.num_hidden_lines)
		
		local totalListHeight = BMU.calculateListHeight()
		-- slider height = totalListHeight  *  percentage of visible lines
		local sliderHeight = totalListHeight*viewable_lines_pct
		-- while the list control is heigher than the visible space (because of the leaking backgroundin the bottom), we just cut a percentage
		local listHeightForSlider = (0.82*totalListHeight) -- no need of scaling because totalListHeight is already scaled
		
		BMU.control_global_2.slider:SetHeight(listHeightForSlider)
        -- The more lines we can see, the bigger the slider should be.
        local tex = self.slider_texture
        BMU.control_global_2.slider:SetThumbTexture(tex, tex, tex, SLIDER_WIDTH*scale, sliderHeight, 0, 0, 1, 1)
	end

    -- Update line widths in case we just resized self.control.
    local line_width = BMU.control_global_2:GetWidth()
    if not BMU.control_global_2.slider:IsControlHidden() then

        line_width = line_width - BMU.control_global_2.slider:GetWidth()
    end

    for _, line in pairs(BMU.control_global_2.lines) do
        line:SetWidth(line_width)
    end
end


local function _initialize_listview(self_listview, width, height, left, top)
	BMU.control_global = self_listview.control
	BMU_tooltipTextEnter = BMU_tooltipTextEnter or BMU.tooltipTextEnter
    --local control = self_listview.control
    local name = BMU.control_global:GetName()

	local scale = BMU.savedVarsAcc.Scale

    -- main control
    BMU.control_global:SetDimensions(width, height)
    BMU.control_global:SetHidden(true)
    BMU.control_global:SetMouseEnabled(true)
    BMU.control_global:SetClampedToScreen(true)
	--BMU.control_global:SetResizeHandleSize(MOUSE_CURSOR_RESIZE_NS)
	
	
	-- create Backdrop / BackGround
	BMU.control_global.bd = WINDOW_MANAGER:CreateControl(nil, BMU.control_global, CT_TEXTURE)
	BMU.control_global.bd:SetMouseEnabled(true)
	-- Users with Full-HD resolution run into problems because of the space!!
	--BMU.control_global.bd:SetClampedToScreen(true)
	
	-- set position
	BMU.control_global.bd:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LEFT + BMU.savedVarsAcc.pos_x, BMU.savedVarsAcc.pos_y)
	-- set dimensions
	BMU.control_global.bd:SetDimensions(BMU.control_global:GetWidth() + 110*scale, BMU.control_global:GetHeight() + 300*scale)
	-- set texture
	BMU.control_global.bd:SetTexture("/esoui/art/miscellaneous/centerscreen_left.dds")
	
	-- !! anchor & place main control on backdrop !!
	BMU.control_global:SetAnchor(CENTER, BMU.control_global.bd, nil, 15*scale)
	-- set moveable
	BMU.control_global.bd:SetMovable(not BMU.savedVarsAcc.fixedWindow)
	-- bring BMU window from draw layer 1 (default) to draw layer 2, to make sure that other addons and map scene are not in front of BMU window
	BMU.control_global:SetDrawLayer(2)

	
	------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------
	-- Total & Statistics
	
	BMU.control_global.statisticGold = wm:CreateControl(name .. "_StatisticGold", BMU.control_global, CT_LABEL)
	BMU.control_global.statisticGold:SetFont(BMU.font2)
    BMU.control_global.statisticGold:SetAnchor(TOPLEFT, BMU.control_global, TOPLEFT, TOPLEFT-35*scale, 25*scale)
	BMU.control_global.statisticGold:SetText(BMU_SI_Get(SI_TELE_UI_GOLD) .. " " .. BMU.formatGold(BMU.savedVarsAcc.savedGold))
	
	BMU.control_global.statisticTotal = wm:CreateControl(name .. "_StatisticTotal", BMU.control_global, CT_LABEL)
	BMU.control_global.statisticTotal:SetFont(BMU.font2)
    BMU.control_global.statisticTotal:SetAnchor(TOPLEFT, BMU.control_global, TOPLEFT, TOPLEFT-35*scale, 45*scale)
	BMU.control_global.statisticTotal:SetText(BMU_SI_Get(SI_TELE_UI_TOTAL_PORTS) .. " " .. BMU.formatGold(BMU.savedVarsAcc.totalPortCounter))
		
	BMU.control_global.total = wm:CreateControl(name .. "_Total", BMU.control_global, CT_LABEL)
    BMU.control_global.total:SetFont(BMU.font2)
    BMU.control_global.total:SetAnchor(TOPLEFT, BMU.control_global, TOPLEFT, TOPLEFT-35*scale, 65*scale)

    -- slider
    local tex = self_listview.slider_texture
    BMU.control_global.slider = wm:CreateControl(name .. "_Slider", BMU.control_global, CT_SLIDER)
    BMU.control_global.slider:SetWidth(SLIDER_WIDTH*scale)
    BMU.control_global.slider:SetMouseEnabled(true)
    BMU.control_global.slider:SetValue(0)
    BMU.control_global.slider:SetValueStep(1)
    BMU.control_global.slider:SetAnchor(TOPRIGHT, BMU.control_global, TOPRIGHT, 25*scale, 90*scale)

    -- lines
    BMU.control_global.lines = {}
    _on_resize(self_listview) -- sets important datastructures
    _create_listview_lines_if_needed(self_listview)

    -- event: mwheel / scrolling
    BMU.control_global:SetHandler("OnMouseWheel", function(self, delta)
        local new_value = clamp(self_listview.offset - delta, 0, self_listview.num_hidden_lines)
		self.slider:SetValue(new_value)
		
		-- if the mouse hovers over the list, we need to update the current tooltip
		-- because the control under the mouse changed by scrolling
		-- clear tooltip
		InformationTooltip:ClearLines()
        InformationTooltip:SetHidden(true)
		-- get control where the mouse is currently over
		local control = moc()
		-- show new tooltip
		if control.tooltipText then
			BMU_tooltipTextEnter(BMU, control, control.tooltipText)
		end
    end)

    -- event: slider
    BMU.control_global.slider:SetHandler("OnValueChanged", function(self, value, eventReason)
        -- update offset
		self_listview.offset = value
		-- update the list view accoring to slider offset (slider's new position)
        self_listview:update()
    end)

    -- just for preventing multiple reszisings at the samt ime
    BMU.control_global:SetHandler("OnResizeStart", function(self)
        self_listview.currently_resizing = true
    end)

    BMU.control_global:SetHandler("OnResizeStop", function(self)
        self_listview.currently_resizing = false
        _on_resize(self_listview)
        self_listview:update()
    end)

    -- event: backdrop control update position
    BMU.control_global.bd:SetHandler("OnMouseUp", function(self)
		if SM:IsShowing("worldMap") then
			if not BMU.savedVarsAcc.anchorOnMap then
				BMU.savedVarsAcc.pos_MapScene_x = math.floor(BMU.control_global.bd:GetLeft())
				BMU.savedVarsAcc.pos_MapScene_y = math.floor(BMU.control_global.bd:GetTop())
			end
		else
			BMU.savedVarsAcc.pos_x = math.floor(BMU.control_global.bd:GetLeft())
			BMU.savedVarsAcc.pos_y = math.floor(BMU.control_global.bd:GetTop())
		end
    end)
end


-- ListView
local ListView = {}

function ListView.new(control, name, settings)
    settings = settings or {}

	local scale = BMU.savedVarsAcc.Scale

    self = {
        line_height = 40*scale,
        slider_texture = settings.slider_texture or "/esoui/art/miscellaneous/scrollbox_elevator.dds",
        title = settings.title, -- can be nil

        control = control,
        name = control:GetName(),
        offset = 0,
        lines = {},
        currently_resizing = false,
    }
	
	local height = BMU.calculateListHeight()
	local width = 450*scale
    local left = 30*scale
    local top = 150*scale

    -- TODO: Translate self:SetHidden() etc. to self.control:SetHidden()
    setmetatable(self, { __index = ListView })
    _initialize_listview(self, width, height, left, top)
    return self
end


-- update the ListView
-- Goes through each line control and either shows a message or hides it
local cachedSavedVarsAccountSecondLanguage = nil													--INS251229 Baertram
function ListView:update()
	BMU_round = BMU_round or BMU.round
	BMU_createTable = BMU_createTable or BMU.createTable
	BMU_clickOnTeleportToOwnHouseButton = BMU_clickOnTeleportToOwnHouseButton or BMU_clickOnTeleportToOwnHouseButton
	BMU_tooltipTextEnter = BMU_tooltipTextEnter or BMU.tooltipTextEnter
	BMU_clickOnOpenGuild = BMU_clickOnOpenGuild or BMU.clickOnOpenGuild
	BMU_clickOnTeleportToPTFHouseButton = BMU_clickOnTeleportToPTFHouseButton or BMU.clickOnTeleportToPTFHouseButton
	BMU_clickOnTeleportToPlayerButton = BMU_clickOnTeleportToPlayerButton or BMU.clickOnTeleportToPlayerButton
	BMU_clickOnTeleportToDungeonButton = BMU_clickOnTeleportToDungeonButton or BMU.clickOnTeleportToDungeonButton

	-- suggestion by otac0n (Discord, 2022_10)
	-- To make it robust, you may want to create a unique ID per ListView.  This assumes a singleton.
	EM:UnregisterForUpdate("TeleportList_Update")
    
	local throttle_time = self.currently_resizing and 0.02 or 0.1
    if BMU.throttle(self, 0.05) then
		-- suggestion by otac0n (Discord, 2022_10)
		EM:RegisterForUpdate("TeleportList_Update", 100, function() self:update() end)
        return
    end

	local scale = BMU.savedVarsAcc.Scale

    if self.currently_resizing then
        _on_resize(self)
    end
	
    -- Clean the list !!!
	for i, list in pairs(self.control.lines) do
		list:SetHidden(true)
	end
	
	-- show total entries
	local firstRecord = self.lines[1]
	if firstRecord.displayName == "" and firstRecord.zoneNameClickable ~= true then
		-- no entries, only no matches info
		self.control.total:SetText(BMU_SI_Get(SI_TELE_UI_TOTAL) .. " " .. "0")
	elseif #self.lines > 1 and self.lines[totalPortals-1].displayName == "" and self.lines[totalPortals-1].zoneNameClickable ~= true then
		-- last entry is "maps in other zones"
		self.control.total:SetText(BMU_SI_Get(SI_TELE_UI_TOTAL) .. " " .. totalPortals - 1)
	else
		-- normal
		self.control.total:SetText(BMU_SI_Get(SI_TELE_UI_TOTAL) .. " " .. totalPortals)
	end
	
	
    for i, list in pairs(self.control.lines) do
        local message = self.lines[i + self.offset] -- self.offset = how much we've scrolled down
		local tooltipTextPlayer = {}
		local tooltipTextZone = {}
		local tooltipTextLevel = ""
		
        -- Only show messages that will be displayed within the control
        if message ~= nil and i <= self.num_visible_lines then
            if i >= self.num_visible_lines + 1 then return end;
            if message == nil then return end;

			if message.zoneName == nil then return end;
			
			--------- player tooltip ---------
			if message.displayName ~= "" and message.championRank then
				list.ColumnPlayerNameTex:SetHidden(false)
				
				-- set level text for player tooltip
				if message.championRank >= 1 then
					tooltipTextLevel = "CP " .. message.championRank
				else
					tooltipTextLevel = message.level
				end
				tooltipTextPlayer = {message.characterName, tooltipTextLevel, message.allianceName}
				
				----
				-- add source text
				table_insert(tooltipTextPlayer, BMU_textures.tooltipSeperatorStr)
				for _, sourceText in pairs(message.sourcesText) do
					table_insert(tooltipTextPlayer, sourceText)
				end

				----
				-- add favorite player text
				local favSlot = BMU.isFavoritePlayer(message.displayName)
				if favSlot then
					table_insert(tooltipTextPlayer, BMU_textures.tooltipSeperatorStr)
					table_insert(tooltipTextPlayer, BMU_colorizeText(BMU_SI_Get(SI_TELE_UI_FAVORITE_PLAYER) .. " " .. tos(favSlot), "gold"))
				end


				if 	#tooltipTextPlayer > 0 then
					-- show tooltip handler
					list.ColumnPlayerNameTex:SetHandler("OnMouseEnter", function(self)
						if message.playerNameClickable then
							list.ColumnPlayerNameTex:SetAlpha(0.3)
						end
						BMU_tooltipTextEnter(BMU, list.ColumnPlayerNameTex, tooltipTextPlayer)
						BMU.pauseAutoRefresh = true
					end)
					-- hide tooltip handler
					list.ColumnPlayerNameTex:SetHandler("OnMouseExit", function(self) list.ColumnPlayerNameTex:SetAlpha(0) BMU_tooltipTextEnter(BMU, list.ColumnPlayerNameTex) BMU.pauseAutoRefresh = false end)
					-- link tooltip text to control (for update on scroll / mouse wheel)
					list.ColumnPlayerNameTex.tooltipText = tooltipTextPlayer
				end
				
				-- set handler for making favorite
				list.ColumnPlayerNameTex:SetHandler("OnMouseUp", function(self, button) BMU.clickOnPlayerName(button, message) end)
			else
				-- make tooltip invisible (no DisplayName of Player -> no Tooltip)
				list.ColumnPlayerNameTex:SetHidden(true)
			end
			------------------


			--------- zone tooltip (and zone name)  and handler for map opening ---------
			
			-- Second language for zone names
			-- if second language is selected & entry is a real zone & zoneNameSecondLanguage exists
			-- check if enabled
			if cachedSavedVarsAccountSecondLanguage == nil or BMU.secondLanguageChanged then
				cachedSavedVarsAccountSecondLanguage = BMU.savedVarsAcc.secondLanguage  			--INS251229 Baertram Cache the SavedVariables 2nd language until next reloadui or LAm settings changed (which will be checked against BMU.secondLanguageChanged)
				BMU.secondLanguageChanged = nil
			end
			if cachedSavedVarsAccountSecondLanguage ~= 1 and message.zoneNameClickable == true and message.zoneNameSecondLanguage ~= nil then --CHG251229 Baertram
				if #tooltipTextZone > 0 then
					-- add separator
					table_insert(tooltipTextZone, BMU_textures.tooltipSeperatorStr)
				end
				-- add zone name
				table_insert(tooltipTextZone, message.zoneNameSecondLanguage)
			end
			------------------
			
			-- Parent zone name
			-- if zone is no overland zone -> show parent map
			if message.category ~= BMU_ZONE_CATEGORY_OVERLAND and message.parentZoneName and not message.houseTooltip then
				if #tooltipTextZone > 0 then
					-- add separator
					table_insert(tooltipTextZone, BMU_textures.tooltipSeperatorStr)
				end
				-- add zone name
				table_insert(tooltipTextZone, message.parentZoneName)
			end
			------------------

			-- house tooltip
			if message.houseTooltip then
				if #tooltipTextZone > 0 then
					-- add separator
					table_insert(tooltipTextZone, BMU_textures.tooltipSeperatorStr)
				end
				-- add house infos
				for _, v in pairs(message.houseTooltip) do
					table_insert(tooltipTextZone, v)
				end
			end
			------------------

			-- wayshrine and skyshard discovery info
			if message.zoneNameClickable == true and (message.zoneWayhsrineDiscoveryInfo ~= nil or message.zoneSkyshardDiscoveryInfo ~= nil) then
				if #tooltipTextZone > 0 then
					-- add separator
					table_insert(tooltipTextZone, BMU_textures.tooltipSeperatorStr)
				end
				if message.zoneSkyshardDiscoveryInfo ~= nil then
					table_insert(tooltipTextZone, message.zoneSkyshardDiscoveryInfo)
				end
				if message.zoneWayhsrineDiscoveryInfo ~= nil then
					table_insert(tooltipTextZone, message.zoneWayhsrineDiscoveryInfo)
				end
			end
			------------------

			-- public dungeon achievement info (group event / skill point)
			if message.zoneNameClickable == true and message.publicDungeonAchiementInfo then
				if #tooltipTextZone > 0 then
					-- add separator
					table_insert(tooltipTextZone, BMU_textures.tooltipSeperatorStr)
				end
				table_insert(tooltipTextZone, message.publicDungeonAchiementInfo)
			end
			------------------

			-- Set Collection information
			if message.setCollectionProgress then
				if #tooltipTextZone > 0 then
					-- add separator
					table_insert(tooltipTextZone, BMU_textures.tooltipSeperatorStr)
				end
				-- add set collection info
				table_insert(tooltipTextZone, message.setCollectionProgress)
			end
			------------------
			
			-- if search for related items and info not already added
			if message.relatedItems ~= nil and #message.relatedItems > 0 then
				-- ensure to add the total number only once
				if not message.addedTotalItems then
					-- add info about total number of related items
					local totalItemsCountInv = 0
					local totalItemsCountBank = 0
					for index, item in pairs(message.relatedItems) do
						if item.isInInventory then
							totalItemsCountInv = totalItemsCountInv + item.itemCount
						else
							totalItemsCountBank = totalItemsCountBank + item.itemCount
						end
					end
					if totalItemsCountInv > 0 then
						message.zoneName = message.zoneName .. " (" .. totalItemsCountInv .. ")"
					end
					if totalItemsCountBank > 0 then
						message.zoneName = message.zoneName .. BMU_colorizeText(" (" .. totalItemsCountBank .. ")", "gray")
					end
					
					-- add item type icons
					message.zoneName = message.zoneName .. " "
					for _, itemType in ipairs(message.relatedItemsTypes) do
						if itemType ~= nil then
							-- add dimensionized icon (same size as BMU.font1)
							message.zoneName = message.zoneName .. BMU_getItemTypeIcon(itemType, BMU_round(17*scale, 0))
						end
					end
					
					message.addedTotalItems = true
				end
				
				-- copy item names to tooltipTextZone
				if #tooltipTextZone > 0 then
					-- add separator
					table_insert(tooltipTextZone, BMU_textures.tooltipSeperatorStr)
				end
				for _, item in ipairs(message.relatedItems) do
					table_insert(tooltipTextZone, item.itemTooltip)
				end
				
			-- if search for related quests
			elseif message.relatedQuests ~= nil and #message.relatedQuests > 0 then
				-- ensure to add the total number only once
				if not message.addedTotalQuests then
					-- add info about number of related quests
					message.zoneName = message.zoneName .. " (" .. message.countRelatedQuests .. ")"
					message.addedTotalQuests = true
				end

				-- copy quest names to tooltipTextZone
				if #tooltipTextZone > 0 then
					-- add separator
					table_insert(tooltipTextZone, BMU_textures.tooltipSeperatorStr)
				end
				for _, questName in ipairs(message.relatedQuests) do
					table_insert(tooltipTextZone, questName)
				end
			end
			------------------
			
			-- Info if player is in same instance
			if message.groupMemberSameInstance ~= nil then
				if #tooltipTextZone > 0 then
					-- add separator
					table_insert(tooltipTextZone, BMU_textures.tooltipSeperatorStr)
				end
				-- add instance info
				if message.groupMemberSameInstance == true then
					table_insert(tooltipTextZone, BMU_colorizeText(BMU_SI_Get(SI_TELE_UI_SAME_INSTANCE), "green"))
				else
					table_insert(tooltipTextZone, BMU_colorizeText(BMU_SI_Get(SI_TELE_UI_DIFFERENT_INSTANCE), "red"))
				end
			end
			------------------

			-- Info if zone is favorite
			local favSlot = BMU.isFavoriteZone(message.zoneId)
			if favSlot then
				table_insert(tooltipTextZone, BMU_textures.tooltipSeperatorStr)
				table_insert(tooltipTextZone, BMU_colorizeText(BMU_SI_Get(SI_TELE_UI_FAVORITE_ZONE) .. " " .. tos(favSlot), "gold"))
			end
			------------------
			

			-- guild tooltip
			if message.guildTooltip then
				ZO_DeepTableCopy(message.guildTooltip, tooltipTextZone)
			end
			------------------
			

			------------------------------------
			-- Zone Name Column Tooltip & Button Controls
			if message.zoneNameClickable or #tooltipTextZone > 0 then
				-- set handler for map opening
				list.ColumnZoneNameTex:SetHidden(false)
				list.ColumnZoneNameTex:SetHandler("OnMouseEnter", function(self) list.ColumnZoneNameTex:SetAlpha(0.3) BMU_tooltipTextEnter(BMU, list.ColumnZoneNameTex, tooltipTextZone) BMU.pauseAutoRefresh = true end)
				list.ColumnZoneNameTex:SetHandler("OnMouseUp", function(self, button) BMU.clickOnZoneName(button, message) end)
				list.ColumnZoneNameTex:SetHandler("OnMouseExit", function(self) list.ColumnZoneNameTex:SetAlpha(0) BMU_tooltipTextEnter(BMU, list.ColumnZoneNameTex) BMU.pauseAutoRefresh = false end)
				-- link tooltip text to control (for update on scroll / mouse wheel)
				list.ColumnZoneNameTex.tooltipText = tooltipTextZone
			else
				-- do nothing
				list.ColumnZoneNameTex:SetHidden(true)
				list.ColumnZoneNameTex:SetHandler("OnMouseUp", nil)
			end
			------------------

			if message.isDungeon then
				if #tooltipTextZone > 0 then
					-- add separator
					table_insert(tooltipTextZone, BMU_textures.tooltipSeperatorStr)
				end
				-- add dungeon infos
				for _, v in pairs(message.dungeonTooltip) do
					table_insert(tooltipTextZone, v)
				end
			end
			------------------
			
			-- set text and color
			list.ColumnPlayerName:SetText(BMU_colorizeText(message.displayName, message.textColorDisplayName))
			list.ColumnZoneName:SetText(BMU_colorizeText(message.zoneName, message.textColorZoneName))
			
			-- number of players
			if message.numberPlayers then
				-- show
				list.ColumnNumberPlayersTex:SetHidden(false)
				-- set text
				list.ColumnNumberPlayers:SetText("(" .. message.numberPlayers .. ")")
				-- show MouseOver handler
				list.ColumnNumberPlayersTex:SetHandler("OnMouseEnter", function(self) list.ColumnNumberPlayersTex:SetAlpha(0.3) end)
				-- hide MouseOver handler
				list.ColumnNumberPlayersTex:SetHandler("OnMouseExit", function(self) list.ColumnNumberPlayersTex:SetAlpha(0) end)
				-- set handler for opening
				list.ColumnNumberPlayersTex:SetHandler("OnMouseUp", function(self, button) if button ~= MOUSE_BUTTON_INDEX_LEFT then return end BMU_createTable({index=BMU_indexListZone, fZoneId=message.zoneId}) end)
			else
				list.ColumnNumberPlayers:SetText("")
				-- hide
				list.ColumnNumberPlayersTex:SetHidden(true)
			end
			
						
			-- set wayshrine icon
			local texture_normal = BMU_textures.wayshrineBtn
			local texture_over = BMU_textures.wayshrineBtnOver
			
			if message.category ~= nil and message.category ~= BMU_ZONE_CATEGORY_UNKNOWN then
				-- set category texture
				if message.category == BMU_ZONE_CATEGORY_DELVE then
					-- set Delve texture
					texture_normal = BMU_textures.delvesBtn
					texture_over = BMU_textures.delvesBtnOver
				elseif message.category == BMU_ZONE_CATEGORY_PUBDUNGEON then
					-- set Public Dungeon texture
					texture_normal = BMU_textures.publicDungeonBtn
					texture_over = BMU_textures.publicDungeonBtnOver
				elseif message.category == BMU_ZONE_CATEGORY_HOUSE then
					-- set House texture
					texture_normal = BMU_textures.houseBtn
					texture_over = BMU_textures.houseBtnOver
				elseif message.category == BMU_ZONE_CATEGORY_GRPDUNGEON then
					-- 4 men Group Dungeons
					texture_normal = BMU_textures.groupDungeonBtn
					texture_over = BMU_textures.groupDungeonBtnOver
				elseif message.category == BMU_ZONE_CATEGORY_TRAIL then
					-- 12 men Group Dungeons
					texture_normal = BMU_textures.raidDungeonBtn
					texture_over = BMU_textures.raidDungeonBtnOver
				elseif message.category == BMU_ZONE_CATEGORY_ENDLESSD then
					-- endless dungeon
					texture_normal = BMU_textures.endlessDungeonBtn
					texture_over = BMU_textures.endlessDungeonBtnOver
				elseif message.category == BMU_ZONE_CATEGORY_GRPZONES then
					-- Other Group Zones (Dungeons in Craglorn)
					texture_normal = BMU_textures.groupZonesBtn
					texture_over = BMU_textures.groupZonesBtnOver
				elseif message.category == BMU_ZONE_CATEGORY_GRPARENA then
					-- Group Arenas
					texture_normal = BMU_textures.groupDungeonBtn
					texture_over = BMU_textures.groupDungeonBtnOver
				elseif message.category == BMU_ZONE_CATEGORY_SOLOARENA then
					-- Solo Arenas
					texture_normal = BMU_textures.soloArenaBtn
					texture_over = BMU_textures.soloArenaBtnOver
				elseif message.zoneWithoutPlayer and GetInteractionType() ~= INTERACTION_FAST_TRAVEL then
					-- zones without players (fast travel for gold)
					-- show normal icon if player is at a wayshrine (travel for free)
					texture_normal = BMU_textures.noPlayerBtn
					texture_over = BMU_textures.noPlayerBtnOver
				end
			end
			
			-- check for Group Leader
			if message.sourceIndexLeading == BMU_SOURCE_INDEX_GROUP and message.isLeader then
				-- set Group Leader texture
				texture_normal = BMU_textures.groupLeaderBtn
				texture_over = BMU_textures.groupLeaderBtnOver
			end
			
			if message.isOwnHouse and CanJumpToHouseFromCurrentLocation() and CanLeaveCurrentLocationViaTeleport() then
				-- own house
				list.portalToPlayerTex:SetHidden(false)
				list.portalToPlayerTex:SetTexture(BMU_textures.houseBtn)
				list.portalToPlayerTex:SetHandler("OnMouseEnter", function(self) list.portalToPlayerTex:SetTexture(BMU_textures.houseBtnOver) BMU.pauseAutoRefresh = true end)
				list.portalToPlayerTex:SetHandler("OnMouseExit", function(self) list.portalToPlayerTex:SetTexture(BMU_textures.houseBtn) BMU.pauseAutoRefresh = false end)
				list.portalToPlayerTex:SetHandler("OnMouseUp", function(self, button) if button ~= MOUSE_BUTTON_INDEX_LEFT then return end BMU_clickOnTeleportToOwnHouseButton(list.portalToPlayerTex, button, message) end)
				
			elseif message.isPTFHouse and CanJumpToHouseFromCurrentLocation() and CanLeaveCurrentLocationViaTeleport() then
				-- "Port to Freind's House" integration
				list.portalToPlayerTex:SetHidden(false)
				list.portalToPlayerTex:SetTexture(BMU_textures.ptfHouseBtn)
				list.portalToPlayerTex:SetHandler("OnMouseEnter", function(self) list.portalToPlayerTex:SetTexture(BMU_textures.ptfHouseBtnOver) BMU.pauseAutoRefresh = true end)
				list.portalToPlayerTex:SetHandler("OnMouseExit", function(self) list.portalToPlayerTex:SetTexture(BMU_textures.ptfHouseBtn) BMU.pauseAutoRefresh = false end)
				list.portalToPlayerTex:SetHandler("OnMouseUp", function(self, button) if button ~= MOUSE_BUTTON_INDEX_LEFT then return end BMU_clickOnTeleportToPTFHouseButton(list.portalToPlayerTex, button, message) end)

			elseif message.isGuild then
				-- Own and partner guilds
				if not message.hideButton then
					list.portalToPlayerTex:SetHidden(false)
					list.portalToPlayerTex:SetTexture(BMU_textures.guildBtn)
					list.portalToPlayerTex:SetHandler("OnMouseEnter", function(self) list.portalToPlayerTex:SetTexture(BMU_textures.guildBtnOver) BMU.pauseAutoRefresh = true end)
					list.portalToPlayerTex:SetHandler("OnMouseExit", function(self) list.portalToPlayerTex:SetTexture(BMU_textures.guildBtn) BMU.pauseAutoRefresh = false end)
					list.portalToPlayerTex:SetHandler("OnMouseUp", function(self, button) if button ~= MOUSE_BUTTON_INDEX_LEFT then return end BMU_clickOnOpenGuild(list.portalToPlayerTex, button, message) end)
				else
					list.portalToPlayerTex:SetHidden(true)
				end
				
			elseif message.isDungeon and CanLeaveCurrentLocationViaTeleport() and (CanJumpToPlayerInZone(message.zoneId) or select(2, CanJumpToPlayerInZone(message.zoneId)) == JUMP_TO_PLAYER_RESULT_SOLO_ZONE) then -- CanJumpToPlayerInZone is false for solo arenas -> check reason value
				-- Dungeon Finder -> use nodeIndecies instead of travel to zoneId
				list.portalToPlayerTex:SetHidden(false)
				list.portalToPlayerTex:SetTexture(texture_normal)
				list.portalToPlayerTex:SetHandler("OnMouseEnter", function(self)
					list.portalToPlayerTex:SetTexture(texture_over)
					if GetInteractionType() ~= INTERACTION_FAST_TRAVEL then
						-- show tooltip with costs only if player is not at a wayshrine
						BMU_tooltipTextEnter(BMU, list.portalToPlayerTex, message.difficultyText .. "\n" .. BMU_colorizeText(string_format(GetString(SI_TOOLTIP_RECALL_COST) .. "%d", GetRecallCost()), "red"))
					else
						BMU_tooltipTextEnter(BMU, list.portalToPlayerTex, message.difficultyText)
					end
					BMU.pauseAutoRefresh = true end)
				list.portalToPlayerTex:SetHandler("OnMouseExit", function(self) list.portalToPlayerTex:SetTexture(texture_normal) BMU_tooltipTextEnter(BMU, list.portalToPlayerTex) BMU.pauseAutoRefresh = false end)
				list.portalToPlayerTex:SetHandler("OnMouseUp", function(self, button) if button ~= MOUSE_BUTTON_INDEX_LEFT then return end BMU_clickOnTeleportToDungeonButton(list.portalToPlayerTex, button, message) end)
				
			elseif message.displayName ~= "" and CanJumpToPlayerInZone(message.zoneId) and CanLeaveCurrentLocationViaTeleport() then
				-- player
				list.portalToPlayerTex:SetHidden(false)
				list.portalToPlayerTex:SetTexture(texture_normal)
				list.portalToPlayerTex:SetHandler("OnMouseEnter", function(self) list.portalToPlayerTex:SetTexture(texture_over) BMU.pauseAutoRefresh = true end)
				list.portalToPlayerTex:SetHandler("OnMouseExit", function(self) list.portalToPlayerTex:SetTexture(texture_normal) BMU.pauseAutoRefresh = false end)
				list.portalToPlayerTex:SetHandler("OnMouseUp", function(self, button) if button ~= MOUSE_BUTTON_INDEX_LEFT then return end BMU_clickOnTeleportToPlayerButton(list.portalToPlayerTex, button, message) end)

			elseif BMU.savedVarsAcc.showZonesWithoutPlayers2 and message.displayName == "" and message.zoneWithoutPlayer and CanLeaveCurrentLocationViaTeleport() and message.zoneWayshrineDiscovered and message.zoneWayshrineDiscovered > 0 then
				-- zones without players (fast travel for gold)
				list.portalToPlayerTex:SetHidden(false)
				list.portalToPlayerTex:SetTexture(texture_normal)
				list.portalToPlayerTex:SetHandler("OnMouseEnter", function(self)
					list.portalToPlayerTex:SetTexture(texture_over)
					if GetInteractionType() ~= INTERACTION_FAST_TRAVEL then
						-- show tooltip with costs only if player is not at a wayshrine
						BMU_tooltipTextEnter(BMU, list.portalToPlayerTex, BMU_colorizeText(string_format(GetString(SI_TOOLTIP_RECALL_COST) .. "%d", GetRecallCost()), "red"))
					end
					BMU.pauseAutoRefresh = true end)
				list.portalToPlayerTex:SetHandler("OnMouseExit", function(self) list.portalToPlayerTex:SetTexture(texture_normal) BMU_tooltipTextEnter(BMU, list.portalToPlayerTex) BMU.pauseAutoRefresh = false end)
				list.portalToPlayerTex:SetHandler("OnMouseUp", function(self, button) if button ~= MOUSE_BUTTON_INDEX_LEFT then return end BMU_clickOnTeleportToPlayerButton(list.portalToPlayerTex, button, message) end)
			else
				-- no DisplayName -> no teleport possibility
				list.portalToPlayerTex:SetHidden(true)
			end
			
            list:SetHidden(false)
        else
            list:SetHidden(true)
		end
    end
end


function BMU.clickOnTeleportToPlayerButton(textureControl, button, message)
	BMU_PortalToPlayer = BMU_PortalToPlayer or BMU.PortalToPlayer
	BMU_PortalToZone = BMU_PortalToZone or BMU.PortalToZone
	BMU_HideTeleporter = BMU_HideTeleporter or BMU.HideTeleporter

	-- click effect
	textureControl:SetAlpha(0.65)
	zo_callLater(function() textureControl:SetAlpha(1) end, 200)	

	-- catch the case if the it is a zone without player (fast travel for gold)
	if message.zoneWithoutPlayer then
		BMU_PortalToZone(message.zoneId)
		return
	end
	
	if button == MOUSE_BUTTON_INDEX_RIGHT and IsPlayerInGroup(myDisplayName) then
		-- create and share link to the group channel
		local linkType = "book"
		local data1 = 190 -- bookId
		local data2 = "BMU_S_P" -- signature
		local data3 = myDisplayName -- playerFrom
		local data4 = message.displayName -- playerTo
		local text = "Follow me!" -- currently not working because linkType "book" does not allow custom text
		
		local link = "|H1:" .. linkType .. ":" .. data1 .. ":" .. data2 .. ":" .. data3 .. ":" .. data4 .. "|h[" .. text .. "]|h"
		
		local preText = "Click to follow me to " .. message.zoneName .. ": "

		-- print link into group channel - player has to press Enter manually!
		StartChatInput(preText .. link, CHAT_CHANNEL_PARTY)
	end
	
	-- port to player anyway
	BMU_PortalToPlayer(message.displayName, message.sourceIndexLeading, message.zoneName, message.zoneId, message.category, true, true, true)
	if BMU.savedVarsAcc.closeOnPorting or GetInteractionType() == INTERACTION_FAST_TRAVEL then
		-- 2025_06
			-- check additionally if the player is interacting with a wayshrine
			-- in that case fast travel attempt starts immediately (base game feature)
			-- unfortunately the interaction is not ended correctly (bug), that could lead to trouble for minimap addons
			-- so we force map closing to end the interaction somehow (it makes no difference because instant loading screen)
		-- hide world map if open
		SM:Hide("worldMap")
		-- hide UI if open
		BMU_HideTeleporter()
	end
end


function BMU.clickOnTeleportToOwnHouseButton_2(button, message, jumpOutside)
	BMU_formatName = BMU_formatName or BMU.formatName
	BMU_portToOwnHouse = BMU_portToOwnHouse or BMU.portToOwnHouse
	BMU_clickOnTeleportToOwnHouseButton_2 = BMU_clickOnTeleportToOwnHouseButton_2 or BMU.clickOnTeleportToOwnHouseButton_2

	-- debug: entry + params + state
	if BMU.debugMode then
		local state = tos(BMU.state)
		d(string_format("[BMU] clickOnTeleportToOwnHouseButton_2 -> state=%s, button=%s, jumpOutside=%s, houseId=%s, forceOutside=%s, parentZoneId=%s, parentZoneName=%s, zoneId=%s",
			state,
			tos(button),
			tos(jumpOutside),
			tos(message and message.houseId),
			tos(message and message.forceOutside),
			tos(message and message.parentZoneId),
			tos(message and message.parentZoneName),
			tos(message and message.zoneId)))
	end

	-- porting outside of a house cant be shared
	if button == MOUSE_BUTTON_INDEX_RIGHT and IsPlayerInGroup(myDisplayName) and not jumpOutside then
		if BMU.debugMode then d("[BMU] share-link branch taken (right-click inside)") end
		-- create and share link to the group channel
		local linkType = "book"
		local data1 = 190 -- bookId
		local data2 = "BMU_S_H" -- signature
		local data3 = myDisplayName -- player
		local data4 = message.houseId -- houseId
		local text = "Follow me!"
		local link = "|H1:" .. linkType .. ":" .. data1 .. ":" .. data2 .. ":" .. data3 .. ":" .. data4 .. "|h[" .. text .. "]|h"
		local preText = "Click to follow me to " .. BMU_formatName(GetZoneNameById(message.zoneId), false) .. ": "
		StartChatInput(preText .. link, CHAT_CHANNEL_PARTY)
	end

	-- port to own house anyway
	BMU_portToOwnHouse(false, message.houseId, jumpOutside, message.parentZoneName)
end
BMU_clickOnTeleportToOwnHouseButton_2 = BMU.clickOnTeleportToOwnHouseButton_2

function BMU.clickOnTeleportToOwnHouseButton(textureControl, button, message)
	-- click effect
	textureControl:SetAlpha(0.65)
	zo_callLater(function() textureControl:SetAlpha(1) end, 200)
	
	if message.forceOutside then
		BMU_clickOnTeleportToOwnHouseButton_2(button, message, true)
	else
		-- show submenu
		ClearCustomScrollableMenu()
		AddCustomScrollableMenuEntry(GetString(SI_HOUSING_BOOK_ACTION_TRAVEL_TO_HOUSE_INSIDE), function() BMU_clickOnTeleportToOwnHouseButton_2(button, message, false) end)
		AddCustomScrollableMenuEntry(GetString(SI_HOUSING_BOOK_ACTION_TRAVEL_TO_HOUSE_OUTSIDE), function() BMU_clickOnTeleportToOwnHouseButton_2(button, message, true) end)
		ShowCustomScrollableMenu()
	end
end
BMU_clickOnTeleportToOwnHouseButton = BMU.clickOnTeleportToOwnHouseButton

function BMU.clickOnTeleportToPTFHouseButton(textureControl, button, message)
	BMU_formatName = BMU_formatName or BMU.formatName
	BMU_HideTeleporter = BMU_HideTeleporter or BMU.HideTeleporter
	BMU_showTeleportAnimation = BMU_showTeleportAnimation or BMU.showTeleportAnimation

	-- click effect
	textureControl:SetAlpha(0.65)
	zo_callLater(function() textureControl:SetAlpha(1) end, 200)

	if message.displayName ~= nil and message.displayName ~= "" and message.houseId ~= nil and message.houseId > 0 then
		-- cut PTF favorite number which is maybe before displayName
		local position, _ = string.find(message.displayName, "@")
		if position ~= nil then
			message.displayName = string.sub(message.displayName, position)
		end
		
		if button == MOUSE_BUTTON_INDEX_RIGHT and IsPlayerInGroup(myDisplayName) then
			-- create and share link to the group channel
			local linkType = "book"
			local data1 = 190 -- bookId
			local data2 = "BMU_S_H" -- signature
			local data3 = message.displayName -- player
			local data4 = message.houseId -- houseId
			local text = "Follow me!" -- currently not working because linkType "book" does not allow custom text
			
			local link = "|H1:" .. linkType .. ":" .. data1 .. ":" .. data2 .. ":" .. data3 .. ":" .. data4 .. "|h[" .. text .. "]|h"
			local preText = "Click to follow me to " .. data3 .. " - ".. BMU_formatName(GetZoneNameById(message.zoneId), false) .. ": "

			-- print link into group channel - player has to press Enter manually!
			StartChatInput(preText .. link, CHAT_CHANNEL_PARTY)
		end
		
		-- show additional animation
		if BMU.savedVarsAcc.showTeleportAnimation then
			BMU_showTeleportAnimation()
		end
		
		-- port to house anyway
		CancelCast()
		if message.displayName == myDisplayName or message.displayName == nil or zo_strtrim(message.displayName) == "" then
			-- own house
			BMU_printToChat(GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. BMU_formatName(GetZoneNameById(message.zoneId), false), BMU.MSG_FT)
			RequestJumpToHouse(message.houseId)
		else
			BMU_printToChat("Port to PTF House:" .. " " .. message.displayName .. " - " .. BMU_formatName(GetZoneNameById(message.zoneId), false), BMU.MSG_FT)
			JumpToSpecificHouse(message.displayName, message.houseId)
		end
	
		if BMU.savedVarsAcc.closeOnPorting then
			-- hide world map if open
			SM:Hide("worldMap")
			-- hide UI if open
			BMU_HideTeleporter()
		end
	end
end



function BMU.clickOnOpenGuild(textureControl, button, message)
	-- click effect
	textureControl:SetAlpha(0.65)
	zo_callLater(function() textureControl:SetAlpha(1) end, 200)

	ZO_LinkHandler_OnLinkClicked("|H1:guild:" .. message.guildId .. "|hGuild|h", 1, nil)
end



function BMU.clickOnTeleportToDungeonButton(textureControl, button, message)
	-- click effect
	textureControl:SetAlpha(0.65)
	zo_callLater(function() textureControl:SetAlpha(1) end, 200)
	
	if button == MOUSE_BUTTON_INDEX_RIGHT and CanPlayerChangeGroupDifficulty() then
		-- show context menu
		ClearCustomScrollableMenu()
		AddCustomScrollableMenuEntry(BMU_textures.dungeonDifficultyNormalStr .. GetString(SI_DUNGEONDIFFICULTY1), function() BMU.setDungeonDifficulty(false) zo_callLater(function() BMU.clickOnTeleportToDungeonButton_2(message) end, 200) end)
		AddCustomScrollableMenuEntry(BMU_textures.dungeonDifficultyVeteranStr .. GetString(SI_DUNGEONDIFFICULTY2), function() BMU.setDungeonDifficulty(true) zo_callLater(function() BMU.clickOnTeleportToDungeonButton_2(message) end, 200) end)
		ShowCustomScrollableMenu()
	else
		-- just start teleport
		BMU.clickOnTeleportToDungeonButton_2(message)
	end
end


function BMU.clickOnTeleportToDungeonButton_2(message)
	BMU_HideTeleporter = BMU_HideTeleporter or BMU.HideTeleporter
	BMU_showTeleportAnimation = BMU_showTeleportAnimation or BMU.showTeleportAnimation
	local BMU_savedVarsAcc = BMU.savedVarsAcc

	if GetInteractionType() == INTERACTION_FAST_TRAVEL then
		-- player is at wayshrine and travels for free -> dont show any chat printouts
		-- start travel to node
		FastTravelToNode(message.nodeIndex)
		return
	else
		-- port for costs
		BMU_printToChat(GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. message.zoneName .. " (" .. zo_strformat(SI_MONEY_FORMAT, GetRecallCost()) .. ")", BMU.MSG_FT)
		-- show additional animation
		if BMU_savedVarsAcc.showTeleportAnimation then
			BMU_showTeleportAnimation()
		end
		FastTravelToNode(message.nodeIndex)
		if BMU_savedVarsAcc.closeOnPorting then
			-- hide world map if open
			SM:Hide("worldMap")
			-- hide UI if open
			BMU_HideTeleporter()
		end
		return
	end
end


-- refresh in depending of current state
function BMU.refreshListAuto(mapChanged)
	BMU_createTable = BMU_createTable or BMU.createTable
	BMU_createTablePTF = BMU_createTablePTF or BMU.createTablePTF

	-- return if window is hidden
	if BMU.win.Main_Control:IsHidden() then
		return
	end

	local inputString = ""
	if BMU.state == BMU_indexListSearchPlayer then
		-- catch input string (player)
		inputString = BMU.win.Searcher_Player:GetText()
	elseif BMU.state == BMU_indexListSearchZone then
		-- catch input string (zone)
		inputString = BMU.win.Searcher_Zone:GetText()
	end
	
	if BMU.state == BMU_indexListOwnHouses or BMU.state == BMU_indexListGuilds or BMU.state == BMU_indexListDungeons or (BMU.state == BMU_indexListQuests and mapChanged) then
		-- if list of own houses or guilds or Dungeon Finder or (related quests and trigger from map change) dont auto refresh
		return
	elseif BMU.state == BMU_indexListPTFHouses then
		BMU_createTablePTF()
	else
		BMU_createTable({index=BMU.state, inputString=inputString, fZoneId=BMU.stateZoneId, filterSourceIndex=BMU.stateSourceIndex, dontResetSlider=true})
	end
end


function ListView:add_messages(message, dontResetSlider)
	self.lines = message
    totalPortals = #self.lines
    _on_resize(self) -- adjusts slider size according to number of lines
	if (not dontResetSlider) and BMU.control_global.slider:GetValue() ~= 0 then -- OnValueChanged Handler will not be triggered if value stays the same
		-- reset slider position
		-- OnValueChanged Handler will also do the self:update
		BMU.control_global.slider:SetValue(0)
	else
		self:update() -- adjusts list view according to slider offset
	end
	
	-- fire callback (for gamepad addon)
	CM:FireCallbacks('BMU_List_Updated')
end


-- working alternative to unsupported frontier pattern matching with string.find
-- gets an input string (word) and checks if the input string is "as whole" in myString (no alphanumeric symbols directly before or after word)
-- Example: isWholeWordInString("Nchuleft", "Nchuleftingth") -> FALSE
--			isWholeWordInString("Mahlstrom", "The Mahlstrom (Veteran)") -> TRUE
function BMU.isWholeWordInString(myString, word)
	return select(2,myString:gsub('^' .. word .. '%W+','')) +
		select(2,myString:gsub('%W+' .. word .. '$','')) +
		select(2,myString:gsub('^' .. word .. '$','')) +
		select(2,myString:gsub('%W+' .. word .. '%W+','')) > 0
end
BMU_isWholeWordInString = BMU.isWholeWordInString


local function showZoneFavoriteContextMenu(comboBox, control, data)
	if data == nil and control ~= nil then data = GetCustomScrollableMenuRowData(control) end
	if data.zoneId ~= nil and data.zoneId ~= 0 then
		if LSM == nil then
			BMU.GetLibraries()
		end

		ClearMenu()
		AddMenuItem(GetString(SI_COLLECTIBLE_ACTION_REMOVE_FAVORITE), function()
			BMU_removeFavoriteZone = BMU_removeFavoriteZone or BMU.removeFavoriteZone
			BMU_removeFavoriteZone(data.zoneId)
		end, MENU_ADD_OPTION_LABEL)
		PreventCustomScrollableContextMenuHide() --mandatory to keep LSM open!
		ShowMenu()
	end
end

function BMU.clickOnZoneName(button, record)
	BMU_createTableDungeons = BMU_createTableDungeons or BMU.createTableDungeons
	BMU_createTablePTF = BMU_createTablePTF or BMU.createTablePTF
	BMU_OpenTeleporter = BMU_OpenTeleporter or BMU.OpenTeleporter
	BMU_formatName = BMU_formatName or BMU.formatName
	BMU_isWholeWordInString = BMU_isWholeWordInString or BMU.isWholeWordInString
	BMU_createTableHouses = BMU_createTableHouses or BMU.createTableHouses
	BMU_has_value = BMU_has_value or BMU.has_value
	BMU_getLowestNumber = BMU_getLowestNumber or BMU.getLowestNumber
	BMU_getZoneSpecificHouse = BMU_getZoneSpecificHouse or BMU.getZoneSpecificHouse
	BMU_setZoneSpecificHouse = BMU_setZoneSpecificHouse or BMU.setZoneSpecificHouse
	BMU_clearZoneSpecificHouse = BMU_clearZoneSpecificHouse or BMU.clearZoneSpecificHouse
	BMU_isFavoriteZone = BMU_isFavoriteZone or BMU.isFavoriteZone
	BMU_removeFavoriteZone = BMU_removeFavoriteZone or BMU.removeFavoriteZone
	BMU_addFavoriteZone = BMU_addFavoriteZone or BMU.addFavoriteZone
	BMU_showDialogAutoUnlock = BMU_showDialogAutoUnlock or BMU.showDialogAutoUnlock
	BMU_getNumSetCollectionProgressPieces = BMU_getNumSetCollectionProgressPieces or BMU.getNumSetCollectionProgressPieces
	BMU_refreshListAuto = BMU_refreshListAuto or BMU.refreshListAuto
	BMU_HideTeleporter = BMU_HideTeleporter or BMU.HideTeleporter
	BMU_portToParentZone = BMU_portToParentZone or BMU.portToParentZone
	BMU_checkIfContextMenuIconShouldShow = BMU_checkIfContextMenuIconShouldShow or BMU.checkIfContextMenuIconShouldShow
	BMU_sc_porting = BMU_sc_porting or BMU.sc_porting
	BMU_getParentZoneId = BMU_getParentZoneId or BMU.getParentZoneId

	local BMU_savedVarsAcc = BMU.savedVarsAcc
	local BMU_savedVarsServ = BMU.savedVarsServ


	if button == MOUSE_BUTTON_INDEX_LEFT then
		-- PTF house tab
		if record.PTFHouseOpen then
			-- hide world map if open
			SM:Hide("worldMap")
			-- hide UI if open
			BMU_HideTeleporter()
			zo_callLater(function() PortToFriend.OpenWindow(function() zo_callLater(function() SetGameCameraUIMode(true) BMU_OpenTeleporter(false) BMU_createTablePTF() end, 150) end) end, 150)
			--SetGameCameraUIMode(true)
			return
		end

		------ display map ------
		-- switch to Tamriel and back to players map in order to reset any subzone or zoom
		if record.mapIndex ~= nil then
			SM:Show("worldMap")
			worldMapManager:SetMapByIndex(1)
			worldMapManager:SetMapByIndex(record.mapIndex)
			CM:FireCallbacks("OnWorldMapChanged")
		end

		------ display poi on map (in case of delve, dungeon etc.) ------
		if record.parentZoneId ~= nil and (record.category ~= BMU_ZONE_CATEGORY_OVERLAND or record.forceOutside) then
			local normalizedX
			local normalizedZ
			local _
			-- primary: use LibZone function
			local parentZoneId, parentZoneIndex, poiIndex = BMU_LibZone:GetZoneMapPinInfo(record.zoneId, record.parentZoneId)
			if poiIndex ~= nil and poiIndex ~= 0 then
				normalizedX, normalizedZ, _, _, _, _ = GetPOIMapInfo(parentZoneIndex, poiIndex)
			end

			------------------
			-- temp. fallback: search corresponding pin by name
			if not normalizedX or not normalizedZ then
				local toSearch = record.zoneNameUnformatted
				if record.forceOutside then
					toSearch = record.houseNameUnformatted
				end

				-- find out coordinates in order to Ping on Map (e.g. Delves, Public Dungeons)
				local coordinate_x = 0
				local coordinate_z = 0
				local zoneIndex = GetZoneIndex(record.parentZoneId)
				for i = 0, GetNumPOIs(zoneIndex) do
					local e = {}
					e.normalizedX, e.normalizedZ, e.poiPinType, e.icon, e.isShownInCurrentMap, e.linkedCollectibleIsLocked = GetPOIMapInfo(zoneIndex, i)
					e.objectiveName, e.objectiveLevel, e.startDescription, e.finishedDescription = GetPOIInfo(zoneIndex, i)

					-- because of inconsistency with zone names coming from API and coming from map (POI), we have to test all 4 cases / combinations
					local objectiveNameWithArticle = string_lower(BMU_formatName(e.objectiveName, false))
					local zoneNameWithArticle = string_lower(BMU_formatName(toSearch, false))
					--local objectiveNameWithoutArticle = string_lower(BMU_formatName(e.objectiveName, true))
					local zoneNameWithoutArcticle = string_lower(BMU_formatName(toSearch, true))

					-- solve bug with "-"
					if zoneNameWithArticle ~= nil then
						zoneNameWithArticle = string_gsub(zoneNameWithArticle, "-", "--")
					end

					local iconLower = string_lower(e.icon)
					-- check (if zoneNameWithArticle is found in objectiveNameWithArticle) or if (zoneNameWithoutArcticle is found in objectiveNameWithArticle) AND objective has no wayshrine or portal icon (to prevent matches with wayshrines and dolmen)
					if (BMU_isWholeWordInString(objectiveNameWithArticle, zoneNameWithArticle) or BMU_isWholeWordInString(objectiveNameWithArticle, zoneNameWithoutArcticle)) and not string_match(iconLower, "wayshrine") and not string_match(iconLower, "portal") then
						normalizedX = e.normalizedX
						normalizedZ = e.normalizedZ
						break
					end
				end
			end
			------------------

			if normalizedX and normalizedZ then
				-- Map Ping
				if BMU_savedVarsAcc.useMapPing and BMU.LibMapPing then
					PingMap(MAP_PIN_TYPE_RALLY_POINT, MAP_TYPE_LOCATION_CENTERED, normalizedX, normalizedZ)
				end
				-- Pan and Zoom
				if BMU_savedVarsAcc.usePanAndZoom then
					zo_callLater(function() ZO_WorldMap_PanToNormalizedPosition(normalizedX, normalizedZ) end, 200)
				end
			end
		end
	elseif button == MOUSE_BUTTON_INDEX_RIGHT then

		-- build flags to decide for each tab if we show the context menu entires
		local inDungeonTab = false
		local inOwnHouseTab = false
		local inQuestTab = false
		local inItemsTab = false
		
		if record.isDungeon then
			inDungeonTab = true
		elseif record.isOwnHouse and not record.forceOutside then
			inOwnHouseTab = true
		elseif #record.relatedQuests > 0 then
			inQuestTab = true
		elseif #record.relatedItems > 0 then
			inItemsTab = true		
		end
		
		-- start generating context menus
		ClearCustomScrollableMenu()
		
		-------Own house contextMenu-------
		if inOwnHouseTab then

			-- 1. custom sorting (not for primary residence which is always on top)
			if record.prio ~= 1 then
				-- divider
				AddCustomScrollableMenuDivider()
				
				-- button to increase sorting ("move up")
				AddCustomScrollableMenuEntry(BMU_textures.arrowUpStr, function()
					
					if not BMU_savedVarsServ.houseCustomSorting[record.houseId] then
						if next(BMU_savedVarsServ.houseCustomSorting) == nil then
							-- table is empty, just set start value
							BMU_savedVarsServ.houseCustomSorting[record.houseId] = 99
						else
							-- first time: set the entry at the end of the list
							BMU_savedVarsServ.houseCustomSorting[record.houseId] = BMU_getLowestNumber(BMU_savedVarsServ.houseCustomSorting) - 1
						end
					else
						local currentValue = BMU_savedVarsServ.houseCustomSorting[record.houseId]
						local houseIdOfPre = BMU_has_value(BMU_savedVarsServ.houseCustomSorting, currentValue + 1)
						if houseIdOfPre then
							-- predecessor exists: switch positions
							BMU_savedVarsServ.houseCustomSorting[record.houseId] = currentValue + 1
							BMU_savedVarsServ.houseCustomSorting[houseIdOfPre] = currentValue
						end
					end
					BMU_createTableHouses()
				
				end)

				-- button to decrease sorting ("move down")
				-- show only if the entry is already in order
				if BMU_savedVarsServ.houseCustomSorting[record.houseId] then
					AddCustomScrollableMenuEntry(BMU_textures.arrowDownStr, function()

						local currentValue = BMU_savedVarsServ.houseCustomSorting[record.houseId]
						local houseIdOfSuc = BMU_has_value(BMU_savedVarsServ.houseCustomSorting, currentValue - 1)
						if houseIdOfSuc then
							-- successor exists: switch positions
							BMU_savedVarsServ.houseCustomSorting[record.houseId] = currentValue - 1
							BMU_savedVarsServ.houseCustomSorting[houseIdOfSuc] = currentValue
						end
						BMU_createTableHouses()

					end)
				end
				AddCustomScrollableMenuDivider()
			end
			
			-- 2. manage preferred houses
			local preferredHouseId = BMU_getZoneSpecificHouse(record.parentZoneId)
			if preferredHouseId and preferredHouseId == record.houseId then
				-- current house is set as preferred
				-- clear zone to unset the house
				AddCustomScrollableMenuEntry(BMU_SI_Get(SI_TELE_UI_UNSET_PREFERRED_HOUSE), function() BMU_clearZoneSpecificHouse(record.parentZoneId) end)
			else
				-- current house is not preferred
				-- set house as preferred
				AddCustomScrollableMenuEntry(BMU_SI_Get(SI_TELE_UI_SET_PREFERRED_HOUSE), function() BMU_setZoneSpecificHouse(record.parentZoneId, record.houseId) end)
			end
			
			-- 3. make primary residence
			if record.prio ~= 1 then
				-- prio = 1 -> is primary house
				-- make primary and refresh with delay
				AddCustomScrollableMenuEntry(GetString(SI_HOUSING_FURNITURE_SETTINGS_GENERAL_PRIMARY_RESIDENCE_BUTTON_TEXT), function()
					SetHousingPrimaryHouse(record.houseId)
					zo_callLater(function()
						BMU_createTableHouses()
					end, 500)
				 end)
			end

			-- 4. rename own houses
			AddCustomScrollableMenuEntry(BMU_SI_Get(SI_TELE_UI_RENAME_HOUSE_NICKNAME), function() ZO_CollectionsBook.ShowRenameDialog(record.collectibleId) end)

			-- 5. paste link to chat
			AddCustomScrollableMenuEntry(GetString(SI_HOUSING_LINK_IN_CHAT), function() ZO_HousingBook_LinkHouseInChat(record.houseId, myDisplayName) end)
		end
		
		-------Quest contextMenu-------
		-- show quest marker
		if inQuestTab then
			for k, v in pairs(record.relatedQuests) do
				-- Show quest marker on map if record contains quest
				AddCustomScrollableMenuEntry(BMU_SI_Get(SI_TELE_UI_SHOW_QUEST_MARKER_ON_MAP) .. ": \"" .. record.relatedQuests[k] .. "\"", function() ZO_WorldMap_ShowQuestOnMap(record.relatedQuestsSlotIndex[k]) end)
			end
		end

		-------Use items contextMenu-------
		-- use item
		if inItemsTab then
			local mapItems = {}
			local codexItems = {}

			-- create entry for each item in inventory: UseItem(number Bag bagId, number slotIndex)
			--Presort to map items or codex items
			for _, item in pairs(record.relatedItems) do
				if item.bagId == BAG_BACKPACK and IsProtectedFunction("UseItem") then -- item is in inventory and can be used
					table_insert(mapItems, item)
				elseif item.antiquityId then -- lead -> show lead in codex
					table_insert(codexItems, item)
				end
			end
			--Add map items headline
			if #mapItems > 0 then
				table_sort(mapItems, tableItemNameSortFunc)
				local mapItemSubmenuEntries = {}
				for _, mapItem in ipairs(mapItems) do
					-- use item
					mapItemSubmenuEntries[#mapItemSubmenuEntries+1] = {
						label = mapItem.itemName,
						callback = function()
							-- hide world map if open
							SM:Hide("worldMap")
							-- hide UI if open
							BMU_HideTeleporter()
							-- use item delayed
							zo_callLater(function()
								CallSecureProtected("UseItem", BAG_BACKPACK, mapItem.slotIndex)
							end, 250)
						end
					}
				end
				AddCustomScrollableSubMenuEntry(BMU_SI_Get(SI_TELE_UI_VIEW_MAP_ITEM), mapItemSubmenuEntries) --View map item
			end
			--Add codex items headline
			if #codexItems > 0 then
				table_sort(codexItems, tableItemNameSortFunc)
				local codexItemSubmenuEntries = {}
				for _, codexItem in ipairs(codexItems) do
					codexItemSubmenuEntries[#codexItemSubmenuEntries+1] = {
						label = codexItem.itemName,
						callback = function()
							ANTIQUITY_LORE_KEYBOARD:ShowAntiquity(codexItem.antiquityId)
						end
					}
				end
				AddCustomScrollableSubMenuEntry(GetString(SI_ANTIQUITY_VIEW_IN_CODEX), codexItemSubmenuEntries) --View
			end
		end
		
		-------Dungeons contextMenu-------
		-- zone favorite options (showing in all tabs except dungeon and own house tab)
		local favoriteIconPath = BMU_checkIfContextMenuIconShouldShow("favorite")
		local favoriteIconHeaderStr = favoriteIconPath ~= nil and zo_iconTextFormatNoSpace(favoriteIconPath, 24, 24, GetString(SI_COLLECTIONS_FAVORITES_CATEGORY_HEADER)) or GetString(SI_COLLECTIONS_FAVORITES_CATEGORY_HEADER)
		if not inDungeonTab and not inOwnHouseTab then
			AddCustomScrollableMenuHeader(GetString(SI_GROUPFINDERCATEGORY5) .. favoriteIconHeaderStr) --Zone Favorites
			local favoriteZoneSVIndex = BMU_isFavoriteZone(record.zoneId)
			if favoriteZoneSVIndex then
				-- remove zone favorite
				AddCustomScrollableMenuEntry(GetString(SI_COLLECTIBLE_ACTION_REMOVE_FAVORITE) .. "  #" .. tos(favoriteZoneSVIndex), function() BMU_removeFavoriteZone(record.zoneId) end)
			end
			-- favorite list
			local entries_favorites = {}

			local recordZoneIdSave = record.zoneId
			local recordZoneNameSave = record.zoneName

			for i=1, teleporterVars.numFavoriteZones, 1 do
				local favName = ""
				local zoneIdOfSavedFav = BMU_savedVarsServ.favoriteListZones[i]
				if BMU_savedVarsServ.favoriteListZones[i] ~= nil then
					favName = BMU_formatName(GetZoneNameById(zoneIdOfSavedFav), BMU_savedVarsAcc.formatZoneName)
				end
				local entry = {
					label = tos(i) .. ": " .. favName,
					callback = function(comboBox, itemName, item, selectionChanged, oldItem)
						BMU_addFavoriteZone(i, recordZoneIdSave, recordZoneNameSave)
					end,
					contextMenuCallback = function(...)
						showZoneFavoriteContextMenu(...)
					end,
					zoneId = zoneIdOfSavedFav
				}
				table_insert(entries_favorites, entry)
			end

			AddCustomScrollableSubMenuEntry(GetString(SI_COLLECTIBLE_ACTION_ADD_FAVORITE), entries_favorites)

		end

		-- favorite a dungeon
		if inDungeonTab then
			AddCustomScrollableMenuHeader(GetString(SI_GROUPFINDERCATEGORY5) .. favoriteIconHeaderStr) --Zone Favorites
			if BMU_savedVarsServ.favoriteDungeon == record.zoneId then
				AddCustomScrollableMenuEntry(GetString(SI_COLLECTIBLE_ACTION_ADD_FAVORITE), function() BMU_savedVarsServ.favoriteDungeon = 0 BMU_createTableDungeons() end)
			else
				AddCustomScrollableMenuEntry(BMU_SI_Get(SI_TELE_UI_FAVORITE_ZONE), function() BMU_savedVarsServ.favoriteDungeon = record.zoneId BMU_createTableDungeons() end)
			end
		end

		AddCustomScrollableMenuHeader(GetString(SI_ITEMTYPEDISPLAYCATEGORY7)) --Miscellaneous

		-- unlocking wayshrines menu (showing in all lists except dungeon and own house tab)
		if not inDungeonTab and not inOwnHouseTab then
			if BMU.isZoneOverlandZone(record.zoneId) then
				AddCustomScrollableMenuEntry(BMU_SI_Get(SI_TELE_UI_UNLOCK_WAYSHRINES), function() BMU_showDialogAutoUnlock(record.zoneId) end)
			end
		end
		
		-- open item set collection book (collectibles)
		if not inOwnHouseTab then
			local numUnlocked, numTotal, workingZoneId = BMU_getNumSetCollectionProgressPieces(record.zoneId, record.category, record.parentZoneId)
			if workingZoneId then
				AddCustomScrollableMenuEntry(GetString(SI_ITEM_SETS_BOOK_TITLE), function() BMU_LibSets.OpenItemSetCollectionBookOfZone(workingZoneId) end)
			end
		end

		-- reset port counter (due to force refresh only available in general list)
		if not inDungeonTab and not inOwnHouseTab and not inQuestTab and not inItemsTab then
			if BMU.savedVarsChar.sorting == 3 or BMU.savedVarsChar.sorting == 4 then
				AddCustomScrollableMenuDivider()
				AddCustomScrollableMenuEntry(BMU_SI_Get(SI_TELE_UI_RESET_COUNTER_ZONE), function() BMU_savedVarsAcc.portCounterPerZone[record.zoneId] = nil BMU_refreshListAuto() end)
				AddCustomScrollableMenuDivider()
			end
		end

		-- travel to parent zone
		local zoneId = record.zoneId
		local parentZoneId = BMU_getParentZoneId(zoneId)
		local parentZoneExists = (parentZoneId ~= zoneId and true) or false
		local parentZoneName = (parentZoneExists == true and BMU_formatName(GetZoneNameById(parentZoneId), false)) or ""
		AddCustomScrollableMenuEntry((parentZoneExists == true and (BMU_SI_Get(SI_TELE_UI_TRAVEL_PARENT_ZONE) .. ": \'" .. parentZoneName .. "\'")) or teleportStr, function()
			if parentZoneExists then
				BMU_portToParentZone(zoneId)
			else
				BMU_sc_porting(zoneId)
			end
			-- close UI if enabled
			if BMU_savedVarsAcc.closeOnPorting then
				-- hide world map if open
				SM:Hide("worldMap")
				-- hide UI if open
				BMU_HideTeleporter()
			end
		end)
		
		ShowCustomScrollableMenu()
	end
end

local function showPlayerFavoriteContextMenu(comboBox, control, data)
	if data == nil and control ~= nil then data = GetCustomScrollableMenuRowData(control) end
	if data.displayName ~= nil and data.displayName ~= "" then
		if LSM == nil then
			BMU.GetLibraries()
		end

		ClearMenu()
		AddMenuItem(GetString(SI_COLLECTIBLE_ACTION_REMOVE_FAVORITE), function()
			BMU_removeFavoritePlayer(data.displayName)
		end, MENU_ADD_OPTION_LABEL)
		PreventCustomScrollableContextMenuHide() --mandatory to keep LSM open!
		ShowMenu()
	end
end

function BMU.clickOnPlayerName(button, record)
	BMU_createTable = BMU_createTable or BMU.createTable
	BMU_createTableHouses = BMU_createTableHouses or BMU.createTableHouses
	BMU_isFavoriteZone = BMU_isFavoriteZone or BMU.isFavoriteZone
	BMU_removeFavoriteZone = BMU_removeFavoriteZone or BMU.removeFavoriteZone
	BMU_addFavoriteZone = BMU_addFavoriteZone or BMU.addFavoriteZone
	BMU_createMail = BMU_createMail or BMU.createMail
	BMU_addFavoritePlayer = BMU_addFavoritePlayer or BMU.addFavoritePlayer
	BMU_removeFavoritePlayer = BMU_removeFavoritePlayer or BMU.removeFavoritePlayer
	BMU_isFavoritePlayer = BMU_isFavoritePlayer or BMU.isFavoritePlayer
	BMU_checkIfContextMenuIconShouldShow = BMU_checkIfContextMenuIconShouldShow or BMU.checkIfContextMenuIconShouldShow

	-- Actions for "Invite to Guild" ??
		-- GetNumGuilds()
		-- GetGuildId(number index) Returns: number guildId
		-- GetGuildName(number guildId) Returns: string name
		-- GetGuildMemberIndexFromDisplayName(number guildId, string displayName) Returns: number:nilable memberIndex
		-- GetGuildMemberInfo(number guildId, number memberIndex) Returns: string name, string note, number rankIndex, number PlayerStatus playerStatus, number secsSinceLogoff
		-- DoesGuildRankHavePermission(number guildId, number rankIndex, number GuildPermission permission) Returns: boolean hasPermission
		-- GuildInvite(number guildId, string displayName)

	if button == MOUSE_BUTTON_INDEX_RIGHT then
		ClearCustomScrollableMenu()

		-- player favorite options
		local favoriteIconPath = BMU_checkIfContextMenuIconShouldShow("favorite")
		local favoriteIconHeaderStr = favoriteIconPath ~= nil and zo_iconTextFormatNoSpace(favoriteIconPath, 24, 24, GetString(SI_COLLECTIONS_FAVORITES_CATEGORY_HEADER)) or GetString(SI_COLLECTIONS_FAVORITES_CATEGORY_HEADER)
		AddCustomScrollableMenuHeader(GetString(SI_PLAYER_MENU_PLAYER) .. favoriteIconHeaderStr) --Player Favorites
		local playerFavoriteIndex = BMU_isFavoritePlayer(record.displayName)
		if playerFavoriteIndex then
			-- remove player favorite
			AddCustomScrollableMenuEntry(GetString(SI_COLLECTIBLE_ACTION_REMOVE_FAVORITE) .. ":  #" ..tos(playerFavoriteIndex), function() BMU_removeFavoritePlayer(record.displayName) end)
		end
		-- favorite list
		local entries_favorites = {}

		local recordDisplayNameSave = record.displayName

		for i=1, teleporterVars.numFavoritePlayers, 1 do
			local favName = ""
			if BMU.savedVarsServ.favoriteListPlayers[i] ~= nil then
				favName = BMU.savedVarsServ.favoriteListPlayers[i]
			end
			local entry = {
				label = tos(i) .. ": " .. favName,
				callback = function(comboBox, itemName, item, selectionChanged, oldItem)
					BMU_addFavoritePlayer(i, recordDisplayNameSave)
				end,
				contextMenuCallback = function(...)
					showPlayerFavoriteContextMenu(...)
				end,
				displayName = favName
			}
			table_insert(entries_favorites, entry)
		end
		AddCustomScrollableSubMenuEntry(GetString(SI_COLLECTIBLE_ACTION_ADD_FAVORITE), entries_favorites)


		local isAccountInGroup = IsPlayerInGroup(myDisplayName)

		local unitTag = nil
		local entries_group = {}
		local entries_misc = {}
		local pos = 1

		-- get unitTag
		if isAccountInGroup then
			local groupUnitTag = ""
			for j = 1, GetGroupSize() do
				groupUnitTag = GetGroupUnitTagByIndex(j)
				if record.displayName == GetUnitDisplayName(groupUnitTag) then
					unitTag = groupUnitTag
				end
			end
		end

		-- generate submenu entries for group
		---Group
		local isPlayerInGroup = IsUnitGrouped(playerTag)												--CHG251229 Baertram
		local isGroupPlayerInGroup = IsPlayerInGroup(record.displayName)								--CHG251229 Baertram
		local isPlayerGroupLeader = IsUnitGroupLeader(playerTag)										--CHG251229 Baertram
		local groupSize = GetGroupSize()
		local groupMembersOnline = 0
		if isAccountInGroup then
			for j = 1, groupSize do
				local groupUnitTag = GetGroupUnitTagByIndex(j)
				if groupUnitTag ~= nil and GetUnitZoneIndex(groupUnitTag) ~= nil and IsUnitOnline(groupUnitTag) then
					groupMembersOnline = groupMembersOnline + 1
				end
			end
		end
		---Friends
		local numFriends = GetNumFriends()
		local numFriendsOnline = 0
		for j = 1, numFriends do
			local _, _, friendStatus = GetFriendInfo(j)
			if friendStatus ~= PLAYER_STATUS_OFFLINE then
				numFriendsOnline = numFriendsOnline + 1
			end
		end
		---Houses
		local numOwnHouses = NonContiguousCount(COLLECTIONS_BOOK_SINGLETON:GetOwnedHouses()) or 0

		--Group contextMenu entries
		entries_group[pos] = {
			label = tos(record.displayName), 		--Other pLayer's displayname
			entryType = LSM_ENTRY_TYPE_HEADER,
		}
		pos = pos + 1
		if not isGroupPlayerInGroup and IsUnitSoloOrGroupLeader(playerTag) then
			entries_group[pos] = {
				label = GetString(SI_CHAT_PLAYER_CONTEXT_ADD_GROUP), 		--Add to group
				callback = function() GroupInviteByName(record.characterName) end,
				icon = function() return BMU_checkIfContextMenuIconShouldShow("add") end
			}
			pos = pos + 1
		end

		if isGroupPlayerInGroup and isPlayerGroupLeader then
			entries_group[pos] = {
				label = GetString(SI_GROUP_LIST_MENU_PROMOTE_TO_LEADER),	--Promote to groupleader
				callback = function() GroupPromote(unitTag) end,
				icon = function() return BMU_checkIfContextMenuIconShouldShow("groupLeaderBtn") end
			}
			pos = pos + 1

			entries_group[pos] = {
				label = GetString(SI_GROUP_LIST_MENU_KICK_FROM_GROUP),		--Kick from group
				callback = function() GroupKick(unitTag) end,
				icon = function() return BMU_checkIfContextMenuIconShouldShow("remove") end
			}
			pos = pos + 1
		end

		if isPlayerInGroup and not isPlayerGroupLeader and isGroupPlayerInGroup and not IsUnitGroupLeader(unitTag) then
			entries_group[pos] = {
				label = BMU_SI_Get(SI_TELE_UI_VOTE_TO_LEADER),
				callback = function() BeginGroupElection(GROUP_ELECTION_TYPE_NEW_LEADER, ZO_GROUP_ELECTION_DESCRIPTORS.NONE, unitTag) end,
				icon = function() return BMU_checkIfContextMenuIconShouldShow("voteLeader") end
			}
			pos = pos + 1
		end

		if isPlayerInGroup then
			if DoesGroupModificationRequireVote() then
				entries_group[pos] = {
					label = GetString(SI_GROUP_LIST_MENU_VOTE_KICK_FROM_GROUP),
					callback = function() BeginGroupElection(GROUP_ELECTION_TYPE_KICK_MEMBER, ZO_GROUP_ELECTION_DESCRIPTORS.NONE, unitTag) end,
					icon = function() return BMU_checkIfContextMenuIconShouldShow("voteKick") end
				}
				pos = pos + 1
			end
			entries_group[pos] = {
				entryType = LSM_ENTRY_TYPE_DIVIDER,
			}
			pos = pos + 1
			entries_group[pos] = {
				label = GetString(SI_GROUP_LIST_MENU_LEAVE_GROUP),
				callback = function() GroupLeave() end,
				icon = function() return BMU_checkIfContextMenuIconShouldShow("cancel") end
			}
			pos = pos + 1
		end


		-- generate submenu entries for misc
		pos = 1

		-- whisper
		entries_misc[pos] = {
			label = GetString(SI_SOCIAL_LIST_PANEL_WHISPER),
			callback = function() StartChatInput("", CHAT_CHANNEL_WHISPER, record.displayName) end,
			--			tooltip = "Tooltip Test: Whisper",
			icon = function() return BMU_checkIfContextMenuIconShouldShow("whisper") end
		}
		pos = pos + 1

		-- Jump to House
		entries_misc[pos] = {
			label = GetString(SI_SOCIAL_MENU_VISIT_HOUSE),
			callback = function() JumpToHouse(record.displayName) end,
			icon = function() return BMU_checkIfContextMenuIconShouldShow("visitPrimary") end
		}
		pos = pos + 1

		-- Send Mail
		entries_misc[pos] = {
			label = GetString(SI_SOCIAL_MENU_SEND_MAIL),
			callback = function() BMU_createMail(record.displayName, "", "") end,
			icon = function() return BMU_checkIfContextMenuIconShouldShow("mail") end
		}
		pos = pos + 1

		-- Add / Remove Friend
		if IsFriend(record.displayName) then
			entries_misc[pos] = {
				label = GetString(SI_FRIEND_MENU_REMOVE_FRIEND),
				callback = function() RemoveFriend(record.displayName) end,
				icon = function() return BMU_checkIfContextMenuIconShouldShow("removeFriend") end
			}
			pos = pos + 1
		else
			entries_misc[pos] = {
				label = GetString(SI_SOCIAL_MENU_ADD_FRIEND),
				callback = function() RequestFriend(record.displayName, "") end,
				icon = function() return BMU_checkIfContextMenuIconShouldShow("addFriend") end
			}
			pos = pos + 1
		end

		-- Invite to Tribute Card Game
		entries_misc[pos] = {
			label = GetString(SI_NOTIFICATIONTYPE30),
			callback = function() InviteToTributeByDisplayName(record.displayName) end,
			icon = function() return BMU_checkIfContextMenuIconShouldShow("tribute") end
		}
		pos = pos + 1

		-- Invite to primary BeamMeUp guild
		if BMUGuildsAtServer ~= nil then
			local primaryBMUGuild = BMUGuildsAtServer[1]
			if IsPlayerInGuild(primaryBMUGuild) and not GetGuildMemberIndexFromDisplayName(primaryBMUGuild, record.displayName) then
				entries_misc[pos] = {
					label = BMU_SI_Get(SI_TELE_UI_INVITE_BMU_GUILD) .. ": BeamMeUp",
					callback = function() GuildInvite(primaryBMUGuild, record.displayName) end,
				}
				pos = pos + 1
			end

			-- Invite to secondary BeamMeUp guild
			local secondaryBMUGuild = BMUGuildsAtServer[2]
			if IsPlayerInGuild(secondaryBMUGuild) and not GetGuildMemberIndexFromDisplayName(secondaryBMUGuild, record.displayName) then
				entries_misc[pos] = {
					label = BMU_SI_Get(SI_TELE_UI_INVITE_BMU_GUILD) .. ": BeamMeUp-Two",
					callback = function() GuildInvite(secondaryBMUGuild, record.displayName) end,
				}
				pos = pos + 1
			end

			-- Invite to tertiary BeamMeUp guild
			local tertiaryBMUGuild = BMUGuildsAtServer[3]
			if IsPlayerInGuild(tertiaryBMUGuild) and not GetGuildMemberIndexFromDisplayName(tertiaryBMUGuild, record.displayName) then
				entries_misc[pos] = {
					label = BMU_SI_Get(SI_TELE_UI_INVITE_BMU_GUILD) .. ": BeamMeUp-Three",
					callback = function() GuildInvite(tertiaryBMUGuild, record.displayName) end,
				}
				pos = pos + 1
			end

			-- Invite to quaternary BeamMeUp guild
			local quaternaryBMUGuild = BMUGuildsAtServer[4]
			if IsPlayerInGuild(quaternaryBMUGuild) and not GetGuildMemberIndexFromDisplayName(quaternaryBMUGuild, record.displayName) then
				entries_misc[pos] = {
					label = BMU_SI_Get(SI_TELE_UI_INVITE_BMU_GUILD) .. ": BeamMeUp-Four",
					callback = function() GuildInvite(quaternaryBMUGuild, record.displayName) end,
				}
				pos = pos + 1
			end
		end
		-- add submenu misc
		AddCustomScrollableSubMenuEntry(GetString(SI_PLAYER_MENU_MISC), entries_misc)


		-- add submenu group
		if #entries_group > 0 then
			AddCustomScrollableMenuDivider()
			AddCustomScrollableSubMenuEntry(GetString(SI_GAMEPAD_GROUP_ACTIONS_MENU_HEADER), entries_group, nil, { icon = function() return BMU_checkIfContextMenuIconShouldShow("group") end })
		end

		-- add submenu filter
		local entries_filter = {
			{
				label = BMU_colorizeText(GetString(SI_TRADING_HOUSE_BROWSE_ITEM_TYPE_ALL), "lgray"), --All
				callback = function() BMU_createTable({index=BMU_indexListMain}) BMU.var.choosenListPlayerFilter = 0 end,
				entryType = LSM_ENTRY_TYPE_RADIOBUTTON,
				buttonGroup = 7,
				checked = function() return BMU.var.choosenListPlayerFilter == 0 end,
				icon = function() return BMU_checkIfContextMenuIconShouldShow("wayshrineBtn") end,
			},
			{ entryType = LSM_ENTRY_TYPE_DIVIDER },
			{
				label = BMU_colorizeText(GetString(SI_GAMEPAD_CAMPAIGN_BROWSER_TOOLTIP_GROUP_MEMBERS), "orange") .. (groupSize > 0 and BMU_colorizeText(" (" .. tos(groupMembersOnline) .. "/" .. groupSize .. ")", "gray")) or "", -- Group
				callback = function() BMU_createTable({index=BMU_indexListSource, filterSourceIndex=BMU_SOURCE_INDEX_GROUP}) BMU.var.choosenListPlayerFilter = BMU_SOURCE_INDEX_GROUP end,
				entryType = LSM_ENTRY_TYPE_RADIOBUTTON,
				buttonGroup = 7,
				checked = function() return BMU.var.choosenListPlayerFilter == BMU_SOURCE_INDEX_GROUP end,
				icon = function() return BMU_checkIfContextMenuIconShouldShow("group") end,
			},
			{
				label = BMU_colorizeText(GetString(SI_GAMEPAD_CAMPAIGN_BROWSER_TOOLTIP_FRIENDS), "green") .. (numFriends > 0 and BMU_colorizeText(" (" .. tos(numFriendsOnline) .. "/" .. numFriends .. ")", "gray")) or "", --Friends
				callback = function() BMU_createTable({index=BMU_indexListSource, filterSourceIndex=BMU_SOURCE_INDEX_FRIEND}) BMU.var.choosenListPlayerFilter = BMU_SOURCE_INDEX_FRIEND end,
				entryType = LSM_ENTRY_TYPE_RADIOBUTTON,
				buttonGroup = 7,
				checked = function() return BMU.var.choosenListPlayerFilter == BMU_SOURCE_INDEX_FRIEND end,
				icon = function() return BMU_checkIfContextMenuIconShouldShow("friends") end,
			},
			{
				label = GetString(SI_MAPFILTER18) .. (numOwnHouses > 0 and " (#" .. tos(numOwnHouses) .. ")") or "", --"Houses",
				entryType = LSM_ENTRY_TYPE_HEADER,
			},
			{
				label = BMU_colorizeText(BMU_SI_Get(SI_TELE_UI_BTN_PORT_TO_OWN_HOUSE), "teal"), --Own houses
				callback = function()
					BMU_createTable({index=BMU_indexListSource, filterSourceIndex=BMU_SOURCE_INDEX_OWNHOUSES}) --INS Baertram 260206
					BMU.var.choosenListPlayerFilter = BMU_SOURCE_INDEX_OWNHOUSES
					--BMU_createTableHouses() BMU.var.choosenListPlayerFilter = -1
				end,
				entryType = LSM_ENTRY_TYPE_RADIOBUTTON,
				buttonGroup = 7,
				checked = function() return BMU.var.choosenListPlayerFilter == BMU_SOURCE_INDEX_OWNHOUSES end,
				icon = function() return BMU_checkIfContextMenuIconShouldShow("houseBtn") end,
				enabled = function()
					if BMU.savedVarsAcc.hideOwnHouses then return false end
					return numOwnHouses > 0
				end,
			},
			--[[ Currently not supported as there is no "all houses" list, maybe relevant for house tours in the future
			{
				label = BMU_colorizeText(GetString(SI_HOUSE_TOURS_FILTERS_HOUSE_DROPDOWN_NO_SELECTION_TEXT), "teal"), --All houses
				callback = function() BMU_createTableHouses() choosenListPlayerFilter = -2 end,
				entryType = LSM_ENTRY_TYPE_RADIOBUTTON,
				buttonGroup = 7,
				checked = function() return choosenListPlayerFilter == -2 end,
				icon = function() return BMU_checkIfContextMenuIconShouldShow("otherHouses") end,
			},
			]]
		}

		-- add all guilds
		table_insert(entries_filter, {
			label = GetString(SI_MAIN_MENU_GUILDS), --"Guilds",
			entryType = LSM_ENTRY_TYPE_HEADER,
		})
		for guildIndex = 1, GetNumGuilds() do
			local guildId = GetGuildId(guildIndex)
			local entry = {
				label = BMU_colorizeText(GetGuildName(guildId), "white"),
				callback = function() BMU_createTable({index=BMU_indexListSource, filterSourceIndex=2+guildIndex}) BMU.var.choosenListPlayerFilter = 2+guildIndex end,
				entryType = LSM_ENTRY_TYPE_RADIOBUTTON,
				buttonGroup = 7,
				checked = function() return BMU.var.choosenListPlayerFilter == 2+guildIndex  end
			}
			table_insert(entries_filter, entry)
		end

		AddCustomScrollableSubMenuEntry(GetString(SI_GAMEPAD_BANK_FILTER_HEADER), entries_filter, nil, { icon = function() return BMU_checkIfContextMenuIconShouldShow("filter") end })

		ShowCustomScrollableMenu(nil, { visibleRowsDropdown = 20, visibleRowsSubmenu = 20 })

	else -- left mouse click
		if record.groupUnitTag then
			worldMapManager:SetMapByIndex(1)
			worldMapManager:SetMapByIndex(record.mapIndex)
			CM:FireCallbacks("OnWorldMapChanged")
			local xLoc, yLoc = GetMapPlayerPosition(record.groupUnitTag)
			-- Map Ping
			if BMU.savedVarsAcc.useMapPing and BMU.LibMapPing then
				PingMap(MAP_PIN_TYPE_RALLY_POINT, MAP_TYPE_LOCATION_CENTERED, xLoc, yLoc)
			end
			-- Pan and Zoom
			if BMU.savedVarsAcc.usePanAndZoom then
				zo_callLater(function() ZO_WorldMap_PanToNormalizedPosition(xLoc, yLoc) end, 200)
			end
		end
	end
end


-- 


-- checks if specific zone is a favorite
function BMU.isFavoriteZone(zoneId)
	BMU_has_value = BMU_has_value or BMU.has_value
	return BMU_has_value(BMU.savedVarsServ.favoriteListZones, zoneId)
end

-- checks if specific player is a favorite
function BMU.isFavoritePlayer(displayName)
	BMU_has_value = BMU_has_value or BMU.has_value
	return BMU_has_value(BMU.savedVarsServ.favoriteListPlayers, displayName)
end

-- save the new favorite zone
function BMU.addFavoriteZone(position, zoneId, zoneName)
	BMU_refreshListAuto = BMU_refreshListAuto or BMU.refreshListAuto
	-- if zone is already favorite -> swap positions
		-- prevents that you can set the same zone to multiple slots
		-- allows to swap the slot with existing favorites
	local oldPos = BMU.isFavoriteZone(zoneId)
	if oldPos then
		BMU.savedVarsServ.favoriteListZones[oldPos] = BMU.savedVarsServ.favoriteListZones[position]
	end
	BMU.savedVarsServ.favoriteListZones[position] = zoneId
	BMU_printToChat(BMU_SI_Get(SI_TELE_UI_FAVORITE_ZONE) .. " " .. position .. ": " .. zoneName, BMU.MSG_AD)
	BMU_refreshListAuto()
end

-- save the new favorite player
function BMU.addFavoritePlayer(position, displayName)
	BMU_refreshListAuto = BMU_refreshListAuto or BMU.refreshListAuto
	-- if player is already favorite -> swap positions
		-- prevents that you can set the same player to multiple slots
		-- allows to swap the slot with existing favorites
	local oldPos = BMU.isFavoritePlayer(displayName)
	if oldPos then
		BMU.savedVarsServ.favoriteListPlayers[oldPos] = BMU.savedVarsServ.favoriteListPlayers[position]
	end
	BMU.savedVarsServ.favoriteListPlayers[position] = displayName
	BMU_printToChat(BMU_SI_Get(SI_TELE_UI_FAVORITE_PLAYER) .. " " .. position .. ": " .. displayName, BMU.MSG_AD)
	BMU_refreshListAuto()
end


-- remove favorite zone
function BMU.removeFavoriteZone(zoneId)
	BMU_refreshListAuto = BMU_refreshListAuto or BMU.refreshListAuto
	-- go over favorite list and remove
	for index, value in pairs(BMU.savedVarsServ.favoriteListZones) do
        if value == zoneId then
			BMU.savedVarsServ.favoriteListZones[index] = nil
        end
    end
	BMU_refreshListAuto()
end

-- remove favorite player
function BMU.removeFavoritePlayer(displayName)
	BMU_refreshListAuto = BMU_refreshListAuto or BMU.refreshListAuto
	-- go over favorite list and remove
	for index, value in pairs(BMU.savedVarsServ.favoriteListPlayers) do
        if value == displayName then
			BMU.savedVarsServ.favoriteListPlayers[index] = nil
        end
    end
	BMU_refreshListAuto()
end

function BMU.round(num, numDecimalPlaces)
  return ton(string_format("%." .. (numDecimalPlaces or 0) .. "f", num))
end
BMU_round = BMU.round

function BMU.formatGold(number)
	BMU_round = BMU_round or BMU.round
	if number >= 1000000 then
		return BMU_round((number/1000000), 3) .. " " .. BMU_SI_Get(SI_TELE_UI_GOLD_ABBR2)
	elseif number >= 1000 then
		return BMU_round((number/1000), 1) .. " " .. BMU_SI_Get(SI_TELE_UI_GOLD_ABBR)
	else
		return tos(number)
	end
end
BMU_formatGold = BMU.formatGold


-- after click on teleport evrytime a cooldown of 7 seconds starts
-- unlocking after last cooldown finished
function BMU.coolDownGold()
	BMU.blockGold = true
	mutexCounter = mutexCounter + 1

	zo_callLater(function()
		mutexCounter = mutexCounter - 1
		if mutexCounter == 0 then
			BMU.blockGold = false
		end
	end, 7200)
end
local BMU_coolDownGold = BMU.coolDownGold

function BMU.updateStatistic(category, zoneId)
	BMU_formatGold = BMU_formatGold or BMU.formatGold
	-- check for block flag and add manual port cost to statisticGold and also increase total counter
	if not BMU.blockGold then
		-- regard only Overland zones for gold statistics
		if category == BMU_ZONE_CATEGORY_OVERLAND then
			BMU.savedVarsAcc.savedGold = BMU.savedVarsAcc.savedGold + GetRecallCost()
			self.control.statisticGold:SetText(BMU_SI_Get(SI_TELE_UI_GOLD) .. " " .. BMU_formatGold(BMU.savedVarsAcc.savedGold))
		end
		-- increase total port counter
		BMU.savedVarsAcc.totalPortCounter = BMU.savedVarsAcc.totalPortCounter + 1
		self.control.statisticTotal:SetText(BMU_SI_Get(SI_TELE_UI_TOTAL_PORTS) .. " " .. BMU_formatGold(BMU.savedVarsAcc.totalPortCounter))
		-- update port counter per zone statistic
		if BMU.savedVarsAcc.portCounterPerZone[zoneId] == nil then
			BMU.savedVarsAcc.portCounterPerZone[zoneId] = 1
		else
			BMU.savedVarsAcc.portCounterPerZone[zoneId] = BMU.savedVarsAcc.portCounterPerZone[zoneId] + 1
		end
		-- update last used zones list
		table_insert(BMU.savedVarsAcc.lastPortedZones, 1, zoneId)
		if #BMU.savedVarsAcc.lastPortedZones > 20 then
			-- drop oldest element
			table_remove(BMU.savedVarsAcc.lastPortedZones)
		end
	end
	
	-- start cooldown
	BMU_coolDownGold()
end


-- calculate the height of the main control depending on the number of lines
function BMU.calculateListHeight()
	-- 300 => 6 lines, add 46 for each additional line (line_height is only 40)
	return (300 + ((BMU.savedVarsAcc.numberLines - 6) * 46))*BMU.savedVarsAcc.Scale
end


function BMU.createMail(to, subject, body)
	SM:Show('mailSend')
	zo_callLater(function()
		ZO_MailSendToField:SetText(to)
		ZO_MailSendSubjectField:SetText(subject)
		ZO_MailSendBodyField:SetText(body)
		--QueueMoneyAttachment(amount)
		ZO_MailSendBodyField:TakeFocus()		
	end, 200)
end


-- sets the dungeon difficulty and updates the button in the group menu (P)
function BMU.setDungeonDifficulty(vet)
	SetVeteranDifficulty(vet)
	local control = ZO_GroupListVeteranDifficultySettings
	if control then
		control.veteranModeButton:SetState(vet and BSTATE_PRESSED or BSTATE_NORMAL)
		control.normalModeButton:SetState(vet and BSTATE_NORMAL or BSTATE_PRESSED)
	end
end

local function getCurrentDungeonDifficulty()  --INS BAERTRAM 20260125
	return ZO_ConvertToIsVeteranDifficulty(ZO_GetEffectiveDungeonDifficulty())
end
BMU.getCurrentDungeonDifficulty = getCurrentDungeonDifficulty



-- port to group leader OR to the other group member when group contains only 2 player
function BMU.portToGroupLeader()
	BMU_formatName = BMU_formatName or BMU.formatName
	BMU_PortalToPlayer = BMU_PortalToPlayer or BMU.PortalToPlayer

	local unitTag
	local leaderUnitTag = GetGroupLeaderUnitTag()
	
	if leaderUnitTag == nil or leaderUnitTag == "" then
		-- no group
		BMU_printToChat(BMU_SI_Get(SI_TELE_CHAT_NOT_IN_GROUP))
		return
	elseif GetGroupSize() == 2 then
		-- group of two -> port to the other player
		 if GetGroupIndexByUnitTag(playerTag) == 1 then
			unitTag = GetGroupUnitTagByIndex(2)
		else
			unitTag = GetGroupUnitTagByIndex(1)
		end
	elseif IsUnitGroupLeader(playerTag) then
		-- group of more than 2 and the current player is the leader himself
		BMU_printToChat(BMU_SI_Get(SI_TELE_CHAT_GROUP_LEADER_YOURSELF))
		return
	else
		-- group of more than 2 -> port to group leader
		unitTag = leaderUnitTag
	end
	
	local displayName = GetUnitDisplayName(unitTag)
	local zoneName = GetUnitZone(unitTag)
	BMU_PortalToPlayer(displayName, 1, BMU_formatName(zoneName, false), 0, 0, false, false, true)
end


function BMU.portToOwnHouse(primary, houseId, jumpOutside, parentZoneName)
	BMU_HideTeleporter = BMU_HideTeleporter or BMU.HideTeleporter
	BMU_formatName = BMU_formatName or BMU.formatName
	BMU_showTeleportAnimation = BMU_showTeleportAnimation or BMU.showTeleportAnimation
	local BMU_savedVarsAcc = BMU.savedVarsAcc

	-- houseId is nil when primary == true
	local zoneId = GetHouseZoneId(houseId)
	
	if primary then
		-- port to primary residence
		houseId = GetHousingPrimaryHouse()
		zoneId = GetHouseZoneId(houseId)
		if zoneId == nil or zoneId == 0 then
			BMU_printToChat(BMU_SI_Get(SI_TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED))
			return
		end
		-- get parentZoneName
		if jumpOutside then
			parentZoneName = BMU_formatName(GetZoneNameById(BMU.getParentZoneId(zoneId)), false)
		end
	end
	
	-- show additional animation
	if BMU_savedVarsAcc.showTeleportAnimation then
		BMU_showTeleportAnimation()
	end
	
	-- print info to chat
	if jumpOutside then
		BMU_printToChat(GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. parentZoneName .. " (" .. BMU_formatName(GetZoneNameById(zoneId), false) .. ")", BMU.MSG_FT)
	else
		BMU_printToChat(GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. BMU_formatName(GetZoneNameById(zoneId), false), BMU.MSG_FT)
	end
	
	-- start port process
	CancelCast()
	RequestJumpToHouse(houseId, jumpOutside)

	-- close UI if enabled
	if BMU_savedVarsAcc.closeOnPorting then
		-- hide world map if open
		SM:Hide("worldMap")
		-- hide UI if open
		BMU_HideTeleporter()
	end
end


function BMU.portToBMUGuildHouse()
	BMU_HideTeleporter = BMU_HideTeleporter or BMU.HideTeleporter
	BMU_formatName = BMU_formatName or BMU.formatName
	BMU_showTeleportAnimation = BMU_showTeleportAnimation or BMU.showTeleportAnimation
	local BMU_savedVarsAcc = BMU.savedVarsAcc

	if guildHousesAtServer == nil then
		BMU_printToChat("There is no BMU guild house on this server.")
		return
	else
		local displayName = guildHousesAtServer[1]
		local houseId = guildHousesAtServer[2]
		-- show additional animation
		if BMU_savedVarsAcc.showTeleportAnimation then
			BMU_showTeleportAnimation()
		end
		CancelCast()
		JumpToSpecificHouse(displayName, houseId)
		BMU_printToChat("Porting to BMU guild house (" .. displayName .. ")", BMU.MSG_FT)
		if BMU_savedVarsAcc.closeOnPorting then
			-- hide world map if open
			SM:Hide("worldMap")
			-- hide UI if open
			BMU_HideTeleporter()
		end
	end
end


function BMU.portToCurrentZone()
	BMU_sc_porting = BMU_sc_porting or BMU.sc_porting
	local playersZoneId = GetZoneId(GetUnitZoneIndex(playerTag))
	BMU_sc_porting(playersZoneId)
end


function BMU.portToParentZone(zoneId)
	BMU_sc_porting = BMU_sc_porting or BMU.sc_porting
	BMU_getParentZoneId = BMU_getParentZoneId or BMU.getParentZoneId
	local startZoneId = zoneId or GetZoneId(GetUnitZoneIndex(playerTag))
	local parentZoneId = BMU_getParentZoneId(startZoneId)
	-- if parent zone cant be determined the current zone is used
	BMU_sc_porting(parentZoneId)
end


-- identifies the currently tracked/focused quest and start the port
function BMU.portToTrackedQuestZone()
	BMU_sc_porting = BMU_sc_porting or BMU.sc_porting
	BMU_findExactQuestLocation = BMU_findExactQuestLocation or BMU.findExactQuestLocation
	for slotIndex = 1, GetNumJournalQuests() do
		local questName, _, _, _, _, _, tracked = GetJournalQuestInfo(slotIndex)
		if tracked then
			local _, _, questZoneIndex = GetJournalQuestLocationInfo(slotIndex)
			local questZoneId = GetZoneId(questZoneIndex)
			if questZoneId ~= 0 then
				-- get exact quest location
				questZoneId = BMU_findExactQuestLocation(slotIndex)
			end
			BMU_printToChat(GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. questName, BMU.MSG_FT)
			BMU_sc_porting(questZoneId)
			return
		end
	end
end


-- to get to the next wayshrine without preference travel to any available zone/player (first entry from main list)
function BMU.portToAnyZone()
	BMU_createTable = BMU_createTable or BMU.createTable
	BMU_PortalToPlayer = BMU_PortalToPlayer or BMU.PortalToPlayer

	local resultTable = BMU_createTable({index=BMU_indexListMain, noOwnHouses=true, dontDisplay=true})
	
	for _, entry in pairs(resultTable) do
		local entryDisplayName = entry.displayName
		if not entry.zoneWithoutPlayer and entryDisplayName ~= nil and entryDisplayName ~= "" then
			-- usual entry with player or house
			BMU_PortalToPlayer(entryDisplayName, entry.sourceIndexLeading, entry.zoneName, entry.zoneId, entry.category, true, false, true)
			return
		end
	end
	-- no travel option found
	BMU_printToChat(BMU_SI_Get(SI_TELE_CHAT_NO_FAST_TRAVEL))
end


-- set flag when an error occurred while starting port process
function BMU.socialErrorWhilePorting(eventCode, errorCode)
	if errorCode == nil then errorCode = 0 end
	BMU.flagSocialErrorWhilePorting = errorCode
end


-- makes intelligent decision whether to try to port to another player or not
function BMU.decideTryAgainPorting(errorCode, zoneId, displayName, sourceIndex, updateSavedGold)
	BMU_createTable = BMU_createTable or BMU.createTable
	BMU_PortalToPlayer = BMU_PortalToPlayer or BMU.PortalToPlayer
	BMU_portToOwnHouse = BMU_portToOwnHouse or BMU.portToOwnHouse

	-- don't try to port again when: other errors (e.g. solo zone); player is group member; player is favorite; search by player name
	if (errorCode ~= SOCIAL_RESULT_NO_LOCATION and errorCode ~= SOCIAL_RESULT_CHARACTER_NOT_FOUND) or sourceIndex == BMU_SOURCE_INDEX_GROUP or BMU.isFavoritePlayer(displayName) or BMU.state == BMU_indexListSearchPlayer then
		return -- do nothing
	else
		-- try to find another player in the zone
		local result = BMU_createTable({index=BMU_indexListZoneHidden, fZoneId=zoneId, dontDisplay=true})
		for index, record in pairs(result) do
			if record ~= nil then
				local recordDisplayName = record.displayName
				if recordDisplayName ~= "" and recordDisplayName ~= displayName then -- player name must be different
					BMU_PortalToPlayer(recordDisplayName, record.sourceIndexLeading, record.zoneName, record.zoneId, record.zoneCategory, updateSavedGold, false, true)
					return
				elseif record.isOwnHouse then
					-- if there is no other player in this zone -> port to own house
					BMU_portToOwnHouse(false, record.houseId, true, record.parentZoneName)
					return
				end
			end
		end
	end
end


-- TOOLTIP (show and hide)
local InformationTooltip = InformationTooltip
function BMU.tooltipTextEnter(BMU, control, text)
    if type(text) == "string" or (type(text) == "table" and #text > 0) then
        InitializeTooltip(InformationTooltip, control, LEFT, 0, 0, 0)
        InformationTooltip:SetHidden(false)
		-- if text is table of strings -> add for each a separate line
		if type(text) == "table" then
			for _, line in ipairs(text) do
				if type(line) == "table" then
					for _, line2 in ipairs(line) do
						InformationTooltip:AddLine(line2)
					end
				else
					InformationTooltip:AddLine(line)
				end
			end
		else
			InformationTooltip:AddLine(text)
		end
    else -- hide tooltip
        InformationTooltip:ClearLines()
        InformationTooltip:SetHidden(true)
    end
end
BMU_tooltipTextEnter = BMU_tooltipTextEnter or BMU.tooltipTextEnter



-- retrieves zone name from zoneId
function BMU.getZoneIdFromZoneName(searchZoneName)
	local libZoneData = BMU.LibZoneGivenZoneData
	local zoneData = libZoneData[string_lower(BMU.lang)] or libZoneData["en"]
	for zoneId, zoneName in pairs(zoneData) do
		if string_lower(zoneName) == string_lower(searchZoneName) then
			return zoneId
		end
	end
end


BMU.ListView = ListView
