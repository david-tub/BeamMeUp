local addon = IJA_BMU_GAMEPAD_PLUGIN


local var_AUTOUNLOCK_PROGRESS_NONE = 0
local var_AUTOUNLOCK_PROGRESS_ACTIVE = 1
local var_AUTOUNLOCK_PROGRESS_COMPLETE = 2
local var_AUTOUNLOCK_PROGRESS_FAILED = 3

local var_AUTOUNLOCK_COOLDOWN = 100

if IsConsoleUI() then
  -- actual console UI has a stricter cooldown time
  var_AUTOUNLOCK_COOLDOWN = 10000
end

local unlockProgress = string.format('%%s: %s %%s(%%s) %s %%s', GetString(SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY), GetString(SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP))
--[[
	
mkstr(SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE, "Automatic discovery finished")
mkstr(SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY, "No more zones found to be discovered. Either there are no players in the zones or you have already discovered all wayshrines.")

]]
local setup_function_map = {
	[var_AUTOUNLOCK_PROGRESS_ACTIVE] = function(self)
		local zoneId = GetZoneId(GetUnitZoneIndex("player"))
		local numWayshrines, numWayshrinesDiscovered = BMU.getZoneWayshrineCompletion(zoneId)

		local entry = {
			dataType = NOTIFICATIONS_ALERT_DATA,
			notificationType = IJA_BMU_NOTIFICATION_TYPE_WAYSHRINE_UNLOCK,
			shortDisplayText = GetString(SI_TELE_UI_UNLOCK_WAYSHRINES),
			message = GetString(SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART),
			note = zo_strformat(SI_NOTIFICATIONS_AUTO_WAYSHRINE_UNLOCK_STATUS, numWayshrines, numWayshrinesDiscovered),
			secsSinceRequest = ZO_NormalizeSecondsSince(0),
			acceptText = GetString(SI_TUTORIAL_CONTINUE),
			declineText = GetString(SI_CANCEL),
		}
		return entry, GetString(SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART)
	end,
	[var_AUTOUNLOCK_PROGRESS_COMPLETE] = function(self)
		local entry = {
			dataType = NOTIFICATIONS_ALERT_DATA,
			notificationType = IJA_BMU_NOTIFICATION_TYPE_WAYSHRINE_COMLPETE,
			shortDisplayText = GetString(SI_TELE_UI_UNLOCK_WAYSHRINES),
			message = GetString(SI_TELE_DIALOG_FINISH_AUTO_UNLOCK_BODY_PART),
			note = GetString(SI_TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY),
			secsSinceRequest = ZO_NormalizeSecondsSince(0),
			acceptText = GetString(SI_DIALOG_ACCEPT),
		--	declineText = GetString(SI_CANCEL),
		}
		return entry, GetString(SI_TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE)
	end,
	[var_AUTOUNLOCK_PROGRESS_FAILED] = function(self)
		local entry = {
			dataType = NOTIFICATIONS_ALERT_DATA,
			notificationType = IJA_BMU_NOTIFICATION_TYPE_WAYSHRINE_UNLOCK,
			shortDisplayText = GetString(SI_TELE_UI_UNLOCK_WAYSHRINES),
			message = GetString(SI_TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE),
			note = zo_strformat('<<1>>\n<<2>>: <<3>>', GetString(SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE), self.formattedZoneName, GetString(SI_TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY3)),
			secsSinceRequest = ZO_NormalizeSecondsSince(0),
		--	acceptText = GetString(SI_DIALOG_ACCEPT),
		--	declineText = GetString(SI_CANCEL),
		}
		return entry, GetString(SI_TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_BODY)
	end,
}

local callback_Map = {
	[var_AUTOUNLOCK_PROGRESS_ACTIVE] = function(self)
		SCENE_MANAGER:ShowBaseScene() -- not working
		IJA_BMU_GAMEPAD_PLUGIN:AutoUnlockContinue()
	end,
	[var_AUTOUNLOCK_PROGRESS_COMPLETE] = function(self)
		self.progress = var_AUTOUNLOCK_PROGRESS_NONE
	end,
	[var_AUTOUNLOCK_PROGRESS_FAILED] = function(self)
		self.progress = var_AUTOUNLOCK_PROGRESS_NONE
	end,
}

local function getSetupFunction(progress)
	return setup_function_map[progress]
end

---------------------------------------------------------------------------------------------------------------
-- 
---------------------------------------------------------------------------------------------------------------
local AutoUnlockNotificationProvider = ZO_NotificationProvider:Subclass()

function AutoUnlockNotificationProvider:New(notificationManager)
    local provider = ZO_NotificationProvider.New(self, notificationManager)
	local updateName = addon.prefix .. "autoUnlockProgress"

	local function onUpdate()
		if provider.oldProgress ~= provider.progress then
			provider.notificationManager:RefreshNotificationList()
		end
	end

	EVENT_MANAGER:RegisterForUpdate(updateName, 1000, onUpdate)
    return provider
end

function AutoUnlockNotificationProvider:BuildNotificationList()
    ZO_ClearNumericallyIndexedTable(self.list)
	EVENT_MANAGER:UnregisterForUpdate(updateName)
	
	local setupFunction = getSetupFunction(self.progress)
	if setupFunction then
		self:AddNotification(setupFunction)
	end
	self.oldProgress = self.progress
end

function AutoUnlockNotificationProvider:AddNotification(setupFunction)
	local listEntry, alertString = setupFunction(self)

	table.insert(self.list, listEntry)
	if self.oldProgress ~= self.progress then
		ZO_Alert(UI_ALERT_CATEGORY_ALERT, SOUNDS.NEW_NOTIFICATION, alertString)
	end
end

function AutoUnlockNotificationProvider:Accept(data)
    -- continue
	local callback = callback_Map[self.progress]
	if callback then
		callback(self)
	end
end

function AutoUnlockNotificationProvider:Decline(data)
	-- cancel
	self.progress = var_AUTOUNLOCK_PROGRESS_NONE
	IJA_BMU_GAMEPAD_PLUGIN:AutoUnlockCancel()
end
local provider = AutoUnlockNotificationProvider:New(GAMEPAD_NOTIFICATIONS)

table.insert(GAMEPAD_NOTIFICATIONS.providers, provider)
GAMEPAD_NOTIFICATIONS:RefreshNotificationList()
-- /tb GAMEPAD_NOTIFICATIONS.providers[28]
---------------------------------------------------------------------------------------------------------------
-- 
---------------------------------------------------------------------------------------------------------------
function addon:AutoUnlockContinue()
	self:ProceedAutoUnlock()
end

function addon:AutoUnlockCancel()
--	EVENT_MANAGER:UnregisterForUpdate(updateName)
	self:UnregisterAutoUnlockEvents()
end

-- does all the necessary checks for the given zoneId (if auto unlock is possible)
-- starts the auto unlock core process
function addon:CheckAndStartAutoUnlockOfZone(zoneId, isChatLogging)
	self:PrepareAutoUnlock(zoneId, isChatLogging, nil, nil)
end

-- closing interface and starting auto unlock core process
function addon:PrepareAutoUnlock(zoneId, isChatLogging, loopType, loopZoneList)
	-- hide world map if open
	SCENE_MANAGER:ShowBaseScene()
	-- delay function call, otherwise the auto-unlock-dialog fails (for whatever reason)
	zo_callLater(function() self:StartAutoUnlock(zoneId, isChatLogging, loopType, loopZoneList) end, 150)
end

------------ AUTO UNLOCK CORE PROCESS ------------
-- initialization
function addon:StartAutoUnlock(zoneId, isChatLogging, loopType, loopZoneList)
	provider.progress = var_AUTOUNLOCK_PROGRESS_ACTIVE
	-- ensure unlock process is not already running
	if not BMU.uwData or not BMU.uwData.isStarted then
		local formattedZoneName = BMU.formatName(GetZoneNameById(zoneId), false)
		local list = BMU.createTable({index=8, fZoneId=zoneId, noOwnHouses=true, dontDisplay=true})
		-- check if list is empty
		provider.formattedZoneName = formattedZoneName
		local firstRecord = list[1]
		if #list == 0 or not firstRecord or firstRecord.displayName == "" then
			provider.progress = var_AUTOUNLOCK_PROGRESS_FAILED
			return
		end
		
		-- get wayshrine discovery info for that current map
		local numWayshrines, numWayshrinesDiscovered = BMU.getZoneWayshrineCompletion(zoneId)
		
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
			gainedXP = 0,
			isChatLogging = isChatLogging or false,
		}
		self:RegisterAutoUnlockEvents()
		
		-- initiate fast travel loop
		self:ProceedAutoUnlock()
	end
end

-- loop of the automatic teleportation
function addon:ProceedAutoUnlock(nextPlayer)
	-- only proceed if feature is active
	if BMU.uwData.isStarted then
		local _, allUnlockedWayshrines = BMU.getZoneWayshrineCompletion(BMU.uwData.zoneId)
		
		-- Note: multiple wayshrine can be discovered at once
		BMU.uwData.unlockedWayshrines = allUnlockedWayshrines - BMU.uwData.discoveredWayshrinesBefore
		
		-- check if the zone is now complete
		if allUnlockedWayshrines == BMU.uwData.totalWayshrines then
			-- just finish
			provider.progress = var_AUTOUNLOCK_PROGRESS_COMPLETE
			self:FinishedAutoUnlock("wayshrinesComplete")
			return
		end
		
		-- get all travel options
		local list = BMU.createTable({index=8, fZoneId=BMU.uwData.zoneId, dontDisplay=true})
		
		if #list ~= 0 or list[1].displayName ~= "" then
			-- re-calculate total steps in case new players come available during process
			-- totalSteps = currentStep(#displayNameList) + number of players which are in list but not in displayNameList
			BMU.uwData.totalSteps = #BMU.uwData.displayNameList
			
			-- shuffle list of players (sort randomly)
			list = BMU.shuffle_table(list)
			
			for _, record in pairs(list) do
				-- check list of players to which we traveled already
				if record.displayName ~= "" and not BMU.has_value(BMU.uwData.displayNameList, record.displayName) then
					-- open player
					if not nextPlayer then
						-- identify next player for jump if not already set
						nextPlayer = record
					end
					-- count to determine the number of open players
					BMU.uwData.totalSteps = BMU.uwData.totalSteps + 1
					break
				else
					nextPlayer = nil
				end
			end
			
			self.nextPlayer = nextPlayer
			if nextPlayer then
				-- start travel
				self:TryToJump()
			--	BMU.PortalToPlayer(nextPlayer.displayName, nextPlayer.sourceIndexLeading, nextPlayer.zoneName, nextPlayer.zoneId, nextPlayer.category, false, false, false)
				-- add player to list
				table.insert(BMU.uwData.displayNameList, nextPlayer.displayName)
				-- NOTE: handling of fast travel error in function BMU.FinishedAutoUnlock() in case of timeout

				zo_callLater(function()
					if BMU.flagSocialErrorWhilePorting > 0 then
						self:ProceedAutoUnlock(nextPlayer)
					end
				end, var_AUTOUNLOCK_COOLDOWN)
				return
			end
		end
		-- finish, no open player found
		self:FinishedAutoUnlock("finished")
	end
end

-- finalize auto unlock and show dialog
function addon:FinishedAutoUnlock(reason)
--	d( 'FinishedAutoUnlock', reason)
	-- check if the timeout was caused by a fast travel error (loading screen)
	if reason == "timeout" and BMU.flagSocialErrorWhilePorting ~= 0 then
		BMU.flagSocialErrorWhilePorting = 0
		-- just proceed with next player
		BMU.printToChat(GetString(SI_TELE_CHAT_AUTO_UNLOCK_SKIP))
		self:ProceedAutoUnlock()
		return
	end
	
	CancelCast()
	-- unregister events
	self:UnregisterAutoUnlockEvents()
	-- set flag to "inactivate" the proceed function (if unregister failed or it is called for some other reasons)
	BMU.uwData.isStarted = false
	
	-- show all infos in dialog
	local unlockedWayshrinesString = BMU.uwData.unlockedWayshrines
	-- colorize if one or more wayshrines were unlocked
	if BMU.uwData.unlockedWayshrines > 0 then
		unlockedWayshrinesString = BMU.colorizeText(BMU.uwData.unlockedWayshrines, "green")
	end
	local allUnlockedWayshrines = BMU.uwData.discoveredWayshrinesBefore + BMU.uwData.unlockedWayshrines
	local totalWayshrinesString = allUnlockedWayshrines .. "/" .. BMU.uwData.totalWayshrines
	-- colorize if zone is complete
	if allUnlockedWayshrines == BMU.uwData.totalWayshrines then
		totalWayshrinesString = BMU.colorizeText(totalWayshrinesString, "green")
	end
	-- colorize if XP was gained
	local gainedXPString = BMU.formatGold(BMU.uwData.gainedXP)
	if BMU.uwData.gainedXP > 0 then
		gainedXPString = BMU.colorizeText(gainedXPString, "yellow")
	end
		
	if BMU.uwData.isChatLogging then
		-- print summary into chat
		BMU.printToChat(
			string.format(unlockProgress, BMU.uwData.fZoneName, tostring(unlockedWayshrinesString), 
				tostring(totalWayshrinesString), tostring(gainedXPString))
			--[[
			BMU.uwData.fZoneName .. ": " ..
			GetString(SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY) .. " " 
			.. tostring(unlockedWayshrinesString) .. " (" .. tostring(totalWayshrinesString) .. ")  " ..
			GetString(SI_TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP) .. " " .. tostring(gainedXPString))
			]]
			)
	end

	-- if continuing with next zones and process finished successfully
	if BMU.uwData.loopType and (reason == "finished" or reason == "wayshrinesComplete") then

		-- set completed or could not finish ?
		zo_callLater(function()
			if BMU.uwData.loopType == "suffle" then
				self:StartAutoUnlockLoopRandom(BMU.uwData.zoneId, BMU.uwData.loopType, BMU.uwData.isChatLogging)
			else
				self:StartAutoUnlockLoopSorted(BMU.uwData.loopZoneList, BMU.uwData.loopType, BMU.uwData.isChatLogging)
			end
		end, 1750)
	end

	if reason == "finished" then
		provider.progress = var_AUTOUNLOCK_PROGRESS_FAILED
	end
end

------------------------
-- checks for zones that can be unlocked and picks a random one to start auto unlock
function addon:StartAutoUnlockLoopRandom(prevZoneId, loopType, isChatLogging)
	local overlandZoneIds = {}
	-- add all overlandZoneIds to a new table
	for overlandZoneId, _ in pairs(BMU.overlandDelvesPublicDungeons) do
		-- consider only zones the user has access to (DLC)
		if CanJumpToPlayerInZone(overlandZoneId) then
			table.insert(overlandZoneIds, overlandZoneId)
		end
	end
	
	-- sort the table randomly
	local shuffled = BMU.shuffle_table(overlandZoneIds)
	
	-- go over the zones and find one
	for _, zoneId in ipairs(shuffled) do
		if zoneId ~= prevZoneId then -- dont take the same zone twice in a row
			local list = BMU.createTable({index=8, fZoneId=zoneId, noOwnHouses=true, dontDisplay=true})
			-- check if list is empty
			if #list > 0 and list[1] and list[1].displayName ~= "" then
				local numWayshrines, numWayshrinesDiscovered = BMU.getZoneWayshrineCompletion(zoneId)
				if numWayshrinesDiscovered < numWayshrines then		
					zo_callLater(function()
						self:PrepareAutoUnlock(zoneId, isChatLogging, loopType, nil)
					end, 400)
					return
				end
			end
		end
	end
end

-- checks for zones that can be unlocked, sort them and queue the list for auto unlock
function addon:StartAutoUnlockLoopSorted(zoneRecordList, loopType, isChatLogging)
	if not zoneRecordList or #zoneRecordList == 0 then
		local overlandZoneIds = {}
		local cleanZoneList = {}
		-- add all overlandZoneIds to a new table
		for overlandZoneId, _ in pairs(BMU.overlandDelvesPublicDungeons) do
			-- consider only zones the user has access to (DLC)
			if CanJumpToPlayerInZone(overlandZoneId) then
				--table.insert(overlandZoneIds, overlandZoneId)
				local resultList = BMU.createTable({index=8, fZoneId=overlandZoneId, noOwnHouses=true, dontDisplay=true})
				if #resultList > 0 and resultList[1] and resultList[1].displayName ~= "" then
					local numWayshrines, numWayshrinesDiscovered = BMU.getZoneWayshrineCompletion(overlandZoneId)
					if numWayshrinesDiscovered < numWayshrines then
						record = {}
						record.zoneId = overlandZoneId
						record.numPlayers = #resultList
						if numWayshrinesDiscovered == 0 then
							record.ratioWayshrines = 0 -- zones with no discovered wayhsrines get "highest prio" independent of the total number
						else
							record.ratioWayshrines = numWayshrinesDiscovered/numWayshrines
						end
						table.insert(cleanZoneList, record)
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
		end
		zoneRecordList = cleanZoneList
	end
	
	-- at this moment: zoneRecordList was already given or was re-filled right now
	for index, zoneRecord in pairs(zoneRecordList) do
		local resultList = BMU.createTable({index=8, fZoneId=zoneRecord.zoneId, noOwnHouses=true, dontDisplay=true})
		if #resultList > 0 and resultList[1] and resultList[1].displayName ~= "" then
			table.remove(zoneRecordList, index)
			zo_callLater(function()
				self:PrepareAutoUnlock(zoneRecord.zoneId, isChatLogging, loopType, zoneRecordList)
			end, 400)
			return
		end
	end
	
	-- if records are still in list, we know that zones were skipped --> start loop again
	-- if no records are in list, we know that we could not find players/zones --> finish
		-- because 1.: if we skipped entries, see case before
		-- because 2.: in case the last entry was processed, it will automatically start again
	if #zoneRecordList > 0 then
		self:StartAutoUnlockLoopSorted(nil, loopType, isChatLogging)
		return
	end
	provider.progress = var_AUTOUNLOCK_PROGRESS_COMPLETE
end

function addon:TryToJump()
	local nextPlayer = self.nextPlayer
	
	BMU.PortalToPlayer(nextPlayer.displayName, nextPlayer.sourceIndexLeading, nextPlayer.zoneName, nextPlayer.zoneId, nextPlayer.category, false, false, false)
end


local ignoredResults = {
	[JUMP_RESULT_JUMP_FAILED_ZONE_COLLECTIBLE] = true,
	[JUMP_RESULT_JUMP_FAILED_SOCIAL_TARGET_ZONE_COLLECTIBLE_LOCKED] = true,
}
local eventHandlers = {
	[EVENT_PLAYER_ACTIVATED] = function()
		zo_callLater(function() IJA_BMU_GAMEPAD_PLUGIN:ProceedAutoUnlock() end, 1500)
	end,
	[EVENT_DISCOVERY_EXPERIENCE] = function(eventCode, reason, level, previousExperience, currentExperience, championPoints)
		if BMU.uwData.isStarted then
			BMU.uwData.gainedXP = BMU.uwData.gainedXP + (currentExperience-previousExperience)
		end
	end,
	[EVENT_JUMP_FAILED] = function(eventId, result)
		-- make sure it's not a result handled by EVENT_ZONE_COLLECTIBLE_REQUIREMENT_FAILED, which will prompt a dialog
		if not ignoredResults[result] then
		--	return ALERT, GetString("SI_JUMPRESULT", result)
			zo_callLater(function()
				IJA_BMU_GAMEPAD_PLUGIN:ProceedAutoUnlock()
			end,var_AUTOUNLOCK_COOLDOWN)
		end
	end,
}

function addon:RegisterAutoUnlockEvents()
	for evenId, handler in pairs(eventHandlers) do
		EVENT_MANAGER:RegisterForEvent(self.prefix .. "_AutoWayshrineUnlock", evenId, handler)
	end
end
function addon:UnregisterAutoUnlockEvents()
	for evenId, handler in pairs(eventHandlers) do
		EVENT_MANAGER:UnregisterForEvent(self.prefix .. "_AutoWayshrineUnlock", evenId)
	end
end

--[[
	no suitable location to jump to
	error 35

/script GAMEPAD_NOTIFICATIONS:RefreshNotificationList()



		-- register for event when coming out from loading screen
		EVENT_MANAGER:RegisterForEvent(BMU.var.appName, EVENT_PLAYER_ACTIVATED, function() zo_callLater(function() self:ProceedAutoUnlock() end, 1500) end)
		-- register for event when gaining XP from wayshrine discovery
		EVENT_MANAGER:RegisterForEvent(BMU.var.appName, EVENT_EXPERIENCE_GAIN, function(eventCode, reason, level, previousExperience, currentExperience, championPoints)
			if BMU.uwData.isStarted then
				BMU.uwData.gainedXP = BMU.uwData.gainedXP + (currentExperience-previousExperience)
			end
		end)

EVENT_MANAGER:RegisterForEvent("AlertTextManager", EVENT_JUMP_FAILED, function(eventId, result)
	-- make sure it's not a result handled by EVENT_ZONE_COLLECTIBLE_REQUIREMENT_FAILED, which will prompt a dialog
	if not ignoredResults[result] then
		return ALERT, GetString("SI_JUMPRESULT", result)
	end
end


/script IJA_BMU_GAMEPAD_PLUGIN.autoUnlockInProgess = 1
/script IJA_BMU_GAMEPAD_PLUGIN.autoUnlockInProgess = false

	EVENT_MANAGER:RegisterForUpdate(updateName)
    local function OnUpdate(updateControl, currentFrameTimeSeconds)
		if oldProgress ~= provider.progress then
			oldProgress = provider.progress
			
			provider.notificationManager:RefreshNotificationList()
		end
    end

	EVENT_MANAGER:RegisterForUpdate(updateName, 1000, OnUpdate)

]]
