local wm = WINDOW_MANAGER

local LINES_OFFSET = 45
local SLIDER_WIDTH = 25
local SI = BMU.SI
-- Make self available to everything in this file
local self = {}
local mColor = {}
local controlWidth = 0
local totalPortals = 0

local mutexCounter = 0

local knownWayshrinesBefore = 0
local knownWayshrinesAfter = 0
local totalWayshrines = 0

-- Utility / local functions

local function clamp(val, min_, max_)
    val = math.max(val, min_)
    return math.min(val, max_)
end

local function normalTextureForAuto()
    BMU.win.Main_Control.portalToAllTexture:SetTexture(BMU.textures.wayshrineBtn2)
end

local function activeTextureForAuto()
	BMU.win.Main_Control.portalToAllTexture:SetTexture(BMU.textures.wayshrineBtnOver2)
end

------------------------------------------------------------


-- does all the necessary checks for the given zoneId (if auto unlock is possible)
-- starts the auto unlock core process
function BMU.checkAndStartAutoUnlockOfZone(zoneId, isChatLogging)
	if not BMU.isZoneOverlandZone(zoneId) or not CanJumpToPlayerInZone(zoneId) then
		-- zone is no OverlandZone OR user has no access to zone (DLC) -> show dialog, that unlocking is not possible
		BMU.showDialogSimple("RefuseAutoUnlock2", SI.get(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE), BMU.formatName(GetZoneNameById(zoneId), false) .. ": " .. SI.get(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2), nil, nil)
		return
	end
	
	-- get number of wayhsrines of the current map
	local numWayshrines, numWayshrinesDiscovered = BMU.getZoneWayshrineCompletion(zoneId)
	if numWayshrinesDiscovered >= numWayshrines then
		-- show dialog, that unlocking is not longer possible
		BMU.showDialogSimple("RefuseAutoUnlock", SI.get(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE), BMU.formatName(GetZoneNameById(zoneId), false) .. ": " .. SI.get(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY) .. BMU.colorizeText(" (" .. numWayshrinesDiscovered .. "/" .. numWayshrines .. ")", "green"), nil, nil)
		return
	end
	BMU.prepareAutoUnlock(zoneId, isChatLogging, nil, nil)
end


-- closing interface and starting auto unlock core process
function BMU.prepareAutoUnlock(zoneId, isChatLogging, loopType, loopZoneList)
	-- hide world map if open
	SCENE_MANAGER:Hide("worldMap")
	-- hide UI if open
	BMU.HideTeleporter()
	-- delay function call, otherwise the auto-unlock-dialog fails (for whatever reason)
	zo_callLater(function() BMU.startAutoUnlock(zoneId, isChatLogging, loopType, loopZoneList) end, 150)
end


------------ AUTO UNLOCK CORE PROCESS ------------
-- initialization
function BMU.startAutoUnlock(zoneId, isChatLogging, loopType, loopZoneList)
	-- ensure unlock process is not already running
	if not BMU.uwData or not BMU.uwData.isStarted then
		local formattedZoneName = BMU.formatName(GetZoneNameById(zoneId), false)
		local list = BMU.createTable({index=8, fZoneId=zoneId, noOwnHouses=true, dontDisplay=true})
		-- check if list is empty
		local firstRecord = list[1]
		if #list == 0 or not firstRecord or firstRecord.displayName == "" then
			BMU.showDialogSimple("AutoUnlockNoPlayer", SI.get(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE), formattedZoneName .. ": " .. SI.get(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY3), nil, nil)
			return
		end
		
		-- change texture of the button
		activeTextureForAuto()
		
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
		
		-- register for event when coming out from loading screen
		EVENT_MANAGER:RegisterForEvent(BMU.var.appName, EVENT_PLAYER_ACTIVATED, function() zo_callLater(function() BMU.proceedAutoUnlock() end, 1500) end)
		-- register for event when gaining XP from wayshrine discovery
		EVENT_MANAGER:RegisterForEvent(BMU.var.appName, EVENT_EXPERIENCE_GAIN, function(eventCode, reason, level, previousExperience, currentExperience, championPoints)
			if BMU.uwData.isStarted then
				BMU.uwData.gainedXP = BMU.uwData.gainedXP + (currentExperience-previousExperience)
			end
		end)
		
		-- initiate fast travel loop
		BMU.proceedAutoUnlock()
	end
end


-- loop of the automatic teleportation
function BMU.proceedAutoUnlock()
	-- only proceed if feature is active
	if BMU.uwData.isStarted then
		local _, allUnlockedWayshrines = BMU.getZoneWayshrineCompletion(BMU.uwData.zoneId)
		
		-- Note: multiple wayshrine can be discovered at once
		BMU.uwData.unlockedWayshrines = allUnlockedWayshrines - BMU.uwData.discoveredWayshrinesBefore
		
		-- check if the zone is now complete
		if allUnlockedWayshrines == BMU.uwData.totalWayshrines then
			-- just finish
			BMU.finishedAutoUnlock("wayshrinesComplete")
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
			local nextPlayer
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
				end
			end
			
			if nextPlayer then
				-- start travel
				BMU.PortalToPlayer(nextPlayer.displayName, nextPlayer.sourceIndexLeading, nextPlayer.zoneName, nextPlayer.zoneId, nextPlayer.category, false, false, false)
				-- add player to list
				table.insert(BMU.uwData.displayNameList, nextPlayer.displayName)
				-- NOTE: handling of fast travel error in function BMU.finishedAutoUnlock() in case of timeout
				-- show dialog with all infos
				BMU.showAutoUnlockProceedDialog(nextPlayer)
				return
			end
		end
		-- finish, no open player found
		BMU.finishedAutoUnlock("finished")
	end
end


-- button to abort complete process
-- (later: button to skip a step? --> maybe the zone of the next player changed?)
-- shows dialog with all infos and handles user cancelation and timeout
function BMU.showAutoUnlockProceedDialog(record)
	-- gather all infos
	local currentStep = #BMU.uwData.displayNameList
	local totalSteps = BMU.uwData.totalSteps
	local currentDisplayName = record.displayName
	local totalWayhsrines = BMU.uwData.totalWayshrines
	local _, allUnlockedWayshrines = BMU.getZoneWayshrineCompletion(BMU.uwData.zoneId)
	local unlockedWayshrinesString = BMU.uwData.unlockedWayshrines
	-- colorize
	if BMU.uwData.unlockedWayshrines > 0 then
		unlockedWayshrinesString = BMU.colorizeText(BMU.uwData.unlockedWayshrines, "green")
	end
	-- colorize if XP was gained
	local gainedXPString = BMU.formatGold(BMU.uwData.gainedXP)
	if BMU.uwData.gainedXP > 0 then
		gainedXPString = BMU.colorizeText(gainedXPString, "yellow")
	end
	
	local body =
		SI.get(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART) .. "\n\n" ..
		SI.get(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY) .. " " .. tostring(unlockedWayshrinesString) .. " (" .. tostring(allUnlockedWayshrines) .. "/" .. tostring(totalWayhsrines) .. ")" .. "\n" ..
		SI.get(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP) .. " " .. tostring(gainedXPString) .. "\n\n" ..
		SI.get(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_PROGRESS) .. " " .. tostring(currentStep) .."/" .. tostring(totalSteps) .. "\n" ..
		GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. tostring(record.displayName)
	
	local countdown = GetTimeStamp() + 8
	local globalDialogName
	local dialogReference
	local remainingSec
	
	-- local function to update the dialog body (to append the countdown)
	local function setTextParameter(parameter)
		ZO_Dialogs_UpdateDialogMainText(dialogReference, {text=body .. "\n\n" .. SI.get(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_TIMER) .. " <<1>>\n"}, {parameter})
	end

	-- local function that is called continously
	local function update()
		remainingSec = countdown - GetTimeStamp()
		-- check for timeout and abort
		if remainingSec < -4 then
			-- abort -> close dialog and finish
			ZO_Dialogs_ReleaseDialog(globalDialogName)
			BMU.finishedAutoUnlock("timeout")
		else
			setTextParameter(BMU.colorizeText(tostring(math.max(remainingSec, 0)), "red"))
		end
	end
	
	-- local function that is triggered when the dialog finished (canceled, disappeared etc.)
	local function dialogFinished()
		if remainingSec > 0 then
			PlaySound(SOUNDS.DIALOG_DECLINE)
			-- finishedCallback is also triggered when entering the loading screen
			-- -> consider only during countdown
			-- timeout is handled via update function
			BMU.printToChat(SI.get(SI.TELE_CHAT_AUTO_UNLOCK_CANCELED))
			BMU.finishedAutoUnlock("canceled")
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
		
	globalDialogName, dialogReference = BMU.showDialogCustom(BMU.uwData.dialogName, dialogInfo)
end


-- finalize auto unlock and show dialog
function BMU.finishedAutoUnlock(reason)
	-- check if the timeout was caused by a fast travel error (loading screen)
	if reason == "timeout" and BMU.flagSocialErrorWhilePorting ~= 0 then
		BMU.flagSocialErrorWhilePorting = 0
		-- just proceed with next player
		BMU.printToChat(SI.get(SI.TELE_CHAT_AUTO_UNLOCK_SKIP))
		BMU.proceedAutoUnlock()
		return
	end
	
	CancelCast()
	-- unregister events
	EVENT_MANAGER:UnregisterForEvent(BMU.var.appName, EVENT_PLAYER_ACTIVATED)
	EVENT_MANAGER:UnregisterForEvent(BMU.var.appName, EVENT_DISCOVERY_EXPERIENCE)
	-- set flag to "inactivate" the proceed function (if unregister failed or it is called for some other reasons)
	BMU.uwData.isStarted = false
	-- restore button texture
	normalTextureForAuto()
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
		
	if reason == "timeout" then
		BMU.showDialogSimple("AutoUnlockTimeout", SI.get(SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_TITLE), SI.get(SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_BODY), nil, nil)
	end
	
	local finishDialogTitle = BMU.uwData.fZoneName
	local finishDialogBody =
		SI.get(SI.TELE_DIALOG_FINISH_AUTO_UNLOCK_BODY_PART) .. "\n\n" ..
		SI.get(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY) .. " " .. tostring(unlockedWayshrinesString) .. " (" .. tostring(totalWayshrinesString) .. ")" .. "\n" ..
		SI.get(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP) .. " " .. tostring(gainedXPString)
	
	local globalDialogName, dialogReference = BMU.showDialogSimple("AutoUnlockFinished", finishDialogTitle, finishDialogBody, nil, nil)

	if BMU.uwData.isChatLogging then
		-- print summary into chat
		BMU.printToChat(
			BMU.uwData.fZoneName .. ": " ..
			SI.get(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY) .. " " .. tostring(unlockedWayshrinesString) .. " (" .. tostring(totalWayshrinesString) .. ")  " ..
			SI.get(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP) .. " " .. tostring(gainedXPString))
	end

	-- if continuing with next zones and process finished successfully
	if BMU.uwData.loopType and (reason == "finished" or reason == "wayshrinesComplete") then
		zo_callLater(function()
			ZO_Dialogs_ReleaseDialog(globalDialogName)
		end, 1700)
		zo_callLater(function()
			if BMU.uwData.loopType == "suffle" then
				BMU.startAutoUnlockLoopRandom(BMU.uwData.zoneId, BMU.uwData.loopType, BMU.uwData.isChatLogging)
			else
				BMU.startAutoUnlockLoopSorted(BMU.uwData.loopZoneList, BMU.uwData.loopType, BMU.uwData.isChatLogging)
			end
		end, 1750)
	end
end

------------------------

-- checks for zones that can be unlocked and picks a random one to start auto unlock
function BMU.startAutoUnlockLoopRandom(prevZoneId, loopType, isChatLogging)
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
						BMU.prepareAutoUnlock(zoneId, isChatLogging, loopType, nil)
					end, 400)
					return
				end
			end
		end
	end
	-- finished here: found no zone to unlock
	BMU.showDialogSimple("AutoUnlockLoopFinish", SI.get(SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE), SI.get(SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY), nil, nil)
end


-- checks for zones that can be unlocked, sort them and queue the list for auto unlock
function BMU.startAutoUnlockLoopSorted(zoneRecordList, loopType, isChatLogging)
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
				BMU.prepareAutoUnlock(zoneRecord.zoneId, isChatLogging, loopType, zoneRecordList)
			end, 400)
			return
		end
	end
	
	-- if records are still in list, we know that zones were skipped --> start loop again
	-- if no records are in list, we know that we could not find players/zones --> finish
		-- because 1.: if we skipped entries, see case before
		-- because 2.: in case the last entry was processed, it will automatically start again
	if #zoneRecordList > 0 then
		BMU.startAutoUnlockLoopSorted(nil, loopType, isChatLogging)
		return
	end
	
	-- finished here: found no zone to unlock
	BMU.showDialogSimple("AutoUnlockLoopFinish", SI.get(SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE), SI.get(SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY), nil, nil)
end


-- shows confirmation dialog and starts AutoUnlock
-- zoneId: optional, if not set use current zone (where the player actually is)
function BMU.showDialogAutoUnlock(zoneId)
	-- use player's zone if no specific zoneId is given
	local zoneId = zoneId or GetZoneId(GetUnitZoneIndex("player"))
	
	-- approach: create seperate control and anchor it to the defualt dialog control (ZO_Dialog1Text) (used by many dialogs)
	-- via the dialog's update function we can interact (show, hide etc.) with the control
	local controlName = "BMU_CustomDialogControl"
	local sectionControl = GetControl(controlName)
	
	if not sectionControl then
		BMU.customDialogSection = WINDOW_MANAGER:CreateControl(controlName, ZO_Dialog1Text, nil)
		BMU.customDialogSection:SetAnchor(BOTTOM, ZO_Dialog1Text, BOTTOM, 0, 140)
		BMU.customDialogSection:SetDimensions(ZO_Dialog1Text:GetWidth(), 70)
		
		-- create dropdown control
		BMU.customDialog_comboBox = CreateControlFromVirtual("BMU_CustomComboBoxControl", BMU.customDialogSection, "ZO_ComboBox")
		BMU.customDialog_comboBox:SetAnchor(TOPLEFT, BMU.customDialogSection, TOPLEFT, 20, 0)
		BMU.customDialog_comboBox:SetWidth(ZO_Dialog1Text:GetWidth()-20)
		
		BMU.customDialog_dropdownControl = ZO_ComboBox_ObjectFromContainer(BMU.customDialog_comboBox)
		BMU.customDialog_dropdownControl:SetSortsItems(false)
		-- add items
		entry1 = BMU.customDialog_dropdownControl:CreateItemEntry(SI.get(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION1), function() end)
		entry1.key = "suffle"
		BMU.customDialog_dropdownControl:AddItem(entry1)
		
		entry2 = BMU.customDialog_dropdownControl:CreateItemEntry(SI.get(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION2), function() end)
		entry2.key = "wayshrines"
		BMU.customDialog_dropdownControl:AddItem(entry2)
		
		entry3 = BMU.customDialog_dropdownControl:CreateItemEntry(SI.get(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION3), function() end)
		entry3.key = "players"
		BMU.customDialog_dropdownControl:AddItem(entry3)
		--
		
		-- create checkbox control
		BMU.customDialog_checkboxControl = CreateControlFromVirtual("BMU_CustomCheckboxControl", BMU.customDialogSection, "ZO_CheckButton")
		BMU.customDialog_checkboxControl:SetAnchor(BOTTOMLEFT, BMU.customDialogSection, BOTTOMLEFT, 0, 0)
		-- TODO: localize text
		ZO_CheckButton_SetLabelText(BMU.customDialog_checkboxControl, SI.get(SI.TELE_DIALOG_AUTO_UNLOCK_CHAT_LOG_OPTION))
		--ZO_CheckButton_SetTooltipText(BMU.customDialog_checkboxControl, "check to enable the log")
	end
	
	BMU.customDialog_dropdownControl:SelectItem(entry1, true)
	
	ZO_CheckButton_SetCheckState(BMU.customDialog_checkboxControl, BMU.savedVarsAcc.autoUnlockChatLogging)
	


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
		BMU.savedVarsAcc.autoUnlockChatLogging = isChatLoggingChecked
	end
	
	local dialogInfo = {
		canQueue = true,
		title = {text = SI.get(SI.TELE_DIALOG_AUTO_UNLOCK_TITLE)},
		mainText = {align = TEXT_ALIGN_LEFT, text = SI.get(SI.TELE_DIALOG_AUTO_UNLOCK_BODY)},
		buttons = {
			{
				text = SI_DIALOG_CONFIRM,
                keybind = "DIALOG_PRIMARY",
				callback = function()
					local flagLoop = dialogReference.radioButtonGroup:GetClickedButton().data.loop
					local isChatLoggingChecked = ZO_CheckButton_IsChecked(BMU.customDialog_checkboxControl)
					local selectedEntry = BMU.customDialog_dropdownControl:GetSelectedItemData()
					if flagLoop then
						if selectedEntry.key == "suffle" then
							-- directly start with random zones
							BMU.startAutoUnlockLoopRandom(nil, selectedEntry.key, isChatLoggingChecked)
						else
							BMU.startAutoUnlockLoopSorted(nil, selectedEntry.key, isChatLoggingChecked)
						end
					else
						-- check and start auto unlocking for given zoneId
						BMU.checkAndStartAutoUnlockOfZone(zoneId, isChatLoggingChecked)
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
				text = SI.get(SI.TELE_DIALOG_AUTO_UNLOCK_LOOP_OPTION),
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



------------------------------------------------------------

-- uses the zone completion data to find out how many wayhrines are discovered in the zone
-- since the ZoneGuide of e.g. Summerset includes the wayshrines of Artaeum, we need to seperate how many wayshrines are really in the zone 
-- returns:
-- 1. number of wayshrines that are located in the zone
-- 2. number of discovered wayshrines that are located in the zone
function BMU.getZoneWayshrineCompletion(zoneId)
	-- set the map to the correct one
	local mapIndex = BMU.getMapIndex(zoneId)
	if mapIndex ~= nil then
		-- switch to Tamriel and back to target map in order to reset any subzone or zoom
		ZO_WorldMap_SetMapByIndex(1)
		ZO_WorldMap_SetMapByIndex(mapIndex)
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


-- return true if the zone is a Overland zone / region
function BMU.isZoneOverlandZone(zoneId)
	-- if zoneId is not given, get zone of player (where the player actually is)
	if not zoneId then
		local zoneIndex = GetUnitZoneIndex("player")
		zoneId = GetZoneId(zoneIndex)
	end
	
	if BMU.categorizeZone(zoneId) == TELEPORTER_ZONE_CATEGORY_OVERLAND then
		return true
	else
		return false
	end
end


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
	if CanLeaveCurrentLocationViaTeleport() and not IsUnitDead("player") then
		
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
			BMU.printToChat(GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. displayName .. " - " .. zoneName)
		end
		if sourceIndex == TELEPORTER_SOURCE_INDEX_GROUP then
			if displayName == GetUnitDisplayName(GetGroupLeaderUnitTag()) then
				JumpToGroupLeader()
			else
				JumpToGroupMember(displayName)
			end
		elseif sourceIndex == TELEPORTER_SOURCE_INDEX_FRIEND then
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
					BMU.printToChat(GetString(SI_FASTTRAVELKEEPRESULT9))
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
			BMU.printToChat(GetString(SI_FASTTRAVELKEEPRESULT12))
		end
	end
end


-- shows special animation while teleporting by using a collectible ("Finvir's Trinket")
function BMU.showTeleportAnimation()
	local collectibleId = 336
	if IsCollectibleUnlocked(collectibleId) and IsCollectibleUsable(collectibleId) and GetCollectibleCooldownAndDuration(collectibleId) == 0 then
		UseCollectible(collectibleId)
	end
end


-- jump directly to wayshrine node in given zone (for gold)
function BMU.PortalToZone(zoneId)
	-- set map and find wayshrine node
	local mapIndex = BMU.getMapIndex(zoneId)
	ZO_WorldMap_SetMapByIndex(mapIndex)
	for nodeIndex = 1, GetNumFastTravelNodes() do
		local known, name, normalizedX, normalizedY, icon, glowIcon, poiType, isShownInCurrentMap, linkedCollectibleIsLocked = GetFastTravelNodeInfo(nodeIndex)
		if known and isShownInCurrentMap and poiType == POI_TYPE_WAYSHRINE then
			if GetInteractionType() == INTERACTION_FAST_TRAVEL then
				-- player is at wayshrine and travels for free -> dont show any chat printouts
				-- start travel to node
				FastTravelToNode(nodeIndex)
				return
			else
				BMU.printToChat(GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. BMU.formatName(GetZoneNameById(zoneId)) .. " (" .. zo_strformat(SI_MONEY_FORMAT, GetRecallCost()) .. ")")
				-- show additional animation
				if BMU.savedVarsAcc.showTeleportAnimation then
					BMU.showTeleportAnimation()
				end
				-- start travel to node
				FastTravelToNode(nodeIndex)
				if BMU.savedVarsAcc.closeOnPorting then
					-- hide world map if open
					SCENE_MANAGER:Hide("worldMap")
					-- hide UI if open
					BMU.HideTeleporter()
				end
				return
			end
		end
	end
	-- found no wayshrine
	BMU.printToChat(SI.get(SI.TELE_CHAT_NO_FAST_TRAVEL))
end


-- if necessary show center screen message that the player is still offline
function BMU.showOfflineNote(_, messageType)
	-- option is enabled + player does not set to offline since last reload + a blank call or it is outgoing whisper message + player is set to offline + last message was 24 hours ago
	if BMU.savedVarsAcc.showOfflineReminder and not BMU.playerStatusChangedToOffline and (not messageType or messageType == CHAT_CHANNEL_WHISPER_SENT) and GetPlayerStatus() == PLAYER_STATUS_OFFLINE and (GetTimeStamp() - BMU.savedVarsServ.lastofflineReminder > 86400) then
		CENTER_SCREEN_ANNOUNCE:AddMessage(0, CSA_CATEGORY_LARGE_TEXT, "Justice_NowKOS", SI.get(SI.TELE_CENTERSCREEN_OFFLINE_NOTE_HEAD), SI.get(SI.TELE_CENTERSCREEN_OFFLINE_NOTE_BODY), nil, nil, nil, nil, 10000, nil)
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


    local list = wm:CreateControl(name, control, CT_CONTROL)
    list:SetHeight(self.line_height)

    local message = self.lines[i]

    if message ~= nil then
		-- RGB color code for mouse over feedback
		local bmuGoldColorRGB = ZO_ColorDef:New(BMU.var.color.colLegendary)
		
		list.ColumnNumberPlayers = wm:CreateControl(name .. "_NumberPlayers", list, CT_LABEL)
		list.ColumnNumberPlayers:SetDimensions(35*BMU.savedVarsAcc.Scale, 20*BMU.savedVarsAcc.Scale)
		list.ColumnNumberPlayers:SetFont(BMU.font1)
		list.ColumnNumberPlayers:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
		list.ColumnNumberPlayers:SetAnchor(0, list, 0, LEFT -40*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)

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
		list.ColumnPlayerName:SetDimensions(150*BMU.savedVarsAcc.Scale, 25*BMU.savedVarsAcc.Scale)
		list.ColumnPlayerName:SetFont(BMU.font1)
		list.ColumnPlayerName:SetAnchor(0, list, 0, LEFT, 50*BMU.savedVarsAcc.Scale)

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
		list.frame:SetDimensions(controlWidth + 30*BMU.savedVarsAcc.Scale, 3*BMU.savedVarsAcc.Scale)
		list.frame:SetAnchor(0, list, 0, LEFT - 40*BMU.savedVarsAcc.Scale, 42*BMU.savedVarsAcc.Scale)

		list.frame:SetTexture("/esoui/art/guild/sectiondivider_left.dds")
		list.frame:SetTextureCoords(0, 1, 0, 1)
		list.frame:SetAlpha(0.7)


		-- COLUMN ZONE NAME
		list.ColumnZoneName = wm:CreateControl(name .. "_Zone", list, CT_LABEL)
		list.ColumnZoneName:SetDimensions(240*BMU.savedVarsAcc.Scale, 25*BMU.savedVarsAcc.Scale)
		list.ColumnZoneName:SetFont(BMU.font1)			
		list.ColumnZoneName:SetAnchor(0, list, 0, LEFT + 165*BMU.savedVarsAcc.Scale, 50*BMU.savedVarsAcc.Scale)

		-- Create another control (Texture) for Mouse interaction
		list.ColumnZoneNameTex = WINDOW_MANAGER:CreateControl(name .. "_ZoneOver", list.ColumnZoneName, CT_TEXTURE)
		list.ColumnZoneNameTex:SetAnchorFill(list.ColumnZoneName)
		list.ColumnZoneNameTex:SetMouseEnabled(true)
		list.ColumnZoneNameTex:SetDrawLayer(2)
		-- set rgb color instead of texture
		list.ColumnZoneNameTex:SetColor(bmuGoldColorRGB:UnpackRGBA())
		list.ColumnZoneNameTex:SetAlpha(0)


		list.portalToPlayerTex = WINDOW_MANAGER:CreateControl(name .. "_TeleTex", list, CT_TEXTURE)
		list.portalToPlayerTex:SetDimensions(45*BMU.savedVarsAcc.Scale, 45*BMU.savedVarsAcc.Scale)
		list.portalToPlayerTex:SetAnchor(0, list, 0, LEFT + 400*BMU.savedVarsAcc.Scale, 41*BMU.savedVarsAcc.Scale) --490 ... 15
		list.portalToPlayerTex:SetMouseEnabled(true)
		list.portalToPlayerTex:SetDrawLayer(2)
			
        return list
    end
end


local function _create_listview_lines_if_needed(self)
    local control = self.control

    -- Makes sure that the main control is filled up with line controls at all times.
    for i = 1, self.num_visible_lines do
        if control.lines[i] == nil then
            local line = _create_listview_row(self, i)
            control.lines[i] = line
			if i == 1 then
				line:SetAnchor(TOPLEFT, control, TOPLEFT, 0, LINES_OFFSET*BMU.savedVarsAcc.Scale)
			else
				line:SetAnchor(TOPLEFT, control.lines[i - 1], BOTTOMLEFT, 0, 0)
			end
        end
    end
end


local function _on_resize(self)
    BMU.control_global_2 = self.control

    -- Need to calculate num_visible_lines etc. for the rest of this function.
    _set_line_counts(self)

    _create_listview_lines_if_needed(self)

    -- Represent how many lines are visible atm.
	-- on initialization #self.lines can be 0 -> prevent division with 0
	local viewable_lines_pct = 1
	if #self.lines > 0 then
		viewable_lines_pct = BMU.round(self.num_visible_lines / #self.lines, 1) or 1
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
        BMU.control_global_2.slider:SetThumbTexture(tex, tex, tex, SLIDER_WIDTH*BMU.savedVarsAcc.Scale, sliderHeight, 0, 0, 1, 1)
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
    --local control = self_listview.control
    local name = BMU.control_global:GetName()

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
	BMU.control_global.bd:SetDimensions(BMU.control_global:GetWidth() + 110*BMU.savedVarsAcc.Scale, BMU.control_global:GetHeight() + 300*BMU.savedVarsAcc.Scale)
	-- set texture
	BMU.control_global.bd:SetTexture("/esoui/art/miscellaneous/centerscreen_left.dds")
	
	-- !! anchor & place main control on backdrop !!
	BMU.control_global:SetAnchor(CENTER, BMU.control_global.bd, nil, 15*BMU.savedVarsAcc.Scale)
	-- set moveable
	BMU.control_global.bd:SetMovable(not BMU.savedVarsAcc.fixedWindow)
	-- bring BMU window from draw layer 1 (default) to draw layer 2, to make sure that other addons and map scene are not in front of BMU window
	BMU.control_global:SetDrawLayer(2)

	
	------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------
	-- Total & Statistics
	
	BMU.control_global.statisticGold = wm:CreateControl(name .. "_StatisticGold", BMU.control_global, CT_LABEL)
	BMU.control_global.statisticGold:SetFont(BMU.font2)
    BMU.control_global.statisticGold:SetAnchor(TOPLEFT, BMU.control_global, TOPLEFT, TOPLEFT-35*BMU.savedVarsAcc.Scale, 25*BMU.savedVarsAcc.Scale)
	BMU.control_global.statisticGold:SetText(SI.get(SI.TELE_UI_GOLD) .. " " .. BMU.formatGold(BMU.savedVarsAcc.savedGold))
	
	BMU.control_global.statisticTotal = wm:CreateControl(name .. "_StatisticTotal", BMU.control_global, CT_LABEL)
	BMU.control_global.statisticTotal:SetFont(BMU.font2)
    BMU.control_global.statisticTotal:SetAnchor(TOPLEFT, BMU.control_global, TOPLEFT, TOPLEFT-35*BMU.savedVarsAcc.Scale, 45*BMU.savedVarsAcc.Scale)
	BMU.control_global.statisticTotal:SetText(SI.get(SI.TELE_UI_TOTAL_PORTS) .. " " .. BMU.formatGold(BMU.savedVarsAcc.totalPortCounter))
		
	BMU.control_global.total = wm:CreateControl(name .. "_Total", BMU.control_global, CT_LABEL)
    BMU.control_global.total:SetFont(BMU.font2)
    BMU.control_global.total:SetAnchor(TOPLEFT, BMU.control_global, TOPLEFT, TOPLEFT-35*BMU.savedVarsAcc.Scale, 65*BMU.savedVarsAcc.Scale)

    -- slider
    local tex = self_listview.slider_texture
    BMU.control_global.slider = wm:CreateControl(name .. "_Slider", BMU.control_global, CT_SLIDER)
    BMU.control_global.slider:SetWidth(SLIDER_WIDTH*BMU.savedVarsAcc.Scale)
    BMU.control_global.slider:SetMouseEnabled(true)
    BMU.control_global.slider:SetValue(0)
    BMU.control_global.slider:SetValueStep(1)
    BMU.control_global.slider:SetAnchor(TOPRIGHT, BMU.control_global, TOPRIGHT, 25*BMU.savedVarsAcc.Scale, 90*BMU.savedVarsAcc.Scale)

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
			BMU:tooltipTextEnter(control, control.tooltipText)
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
		if SCENE_MANAGER:IsShowing("worldMap") then
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

    self = {
        line_height = 40*BMU.savedVarsAcc.Scale,
        slider_texture = settings.slider_texture or "/esoui/art/miscellaneous/scrollbox_elevator.dds",
        title = settings.title, -- can be nil

        control = control,
        name = control:GetName(),
        offset = 0,
        lines = {},
        currently_resizing = false,
    }
	
	local height = BMU.calculateListHeight()
	local width = 450*BMU.savedVarsAcc.Scale
    local left = 30*BMU.savedVarsAcc.Scale
    local top = 150*BMU.savedVarsAcc.Scale

    -- TODO: Translate self:SetHidden() etc. to self.control:SetHidden()
    setmetatable(self, { __index = ListView })
    _initialize_listview(self, width, height, left, top)
    return self
end


-- update the ListView
-- Goes through each line control and either shows a message or hides it
function ListView:update()
	-- suggestion by otac0n (Discord, 2022_10)
	-- To make it robust, you may want to create a unique ID per ListView.  This assumes a singleton.
	EVENT_MANAGER:UnregisterForUpdate("TeleportList_Update")
    
	local throttle_time = self.currently_resizing and 0.02 or 0.1
    if BMU.throttle(self, 0.05) then
		-- suggestion by otac0n (Discord, 2022_10)
		EVENT_MANAGER:RegisterForUpdate("TeleportList_Update", 100, function() self:update() end)
        return
    end

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
		self.control.total:SetText(SI.get(SI.TELE_UI_TOTAL) .. " " .. "0")
	elseif #self.lines > 1 and self.lines[totalPortals-1].displayName == "" and self.lines[totalPortals-1].zoneNameClickable ~= true then
		-- last entry is "maps in other zones"
		self.control.total:SetText(SI.get(SI.TELE_UI_TOTAL) .. " " .. totalPortals - 1)
	else
		-- normal
		self.control.total:SetText(SI.get(SI.TELE_UI_TOTAL) .. " " .. totalPortals)
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
				-- add source text
				-- add separator
				table.insert(tooltipTextPlayer, BMU.textures.tooltipSeperator)
				for _, sourceText in pairs(message.sourcesText) do
					table.insert(tooltipTextPlayer, sourceText)
				end
				
			
				if 	#tooltipTextPlayer > 0 then
					-- show tooltip handler
					list.ColumnPlayerNameTex:SetHandler("OnMouseEnter", function(self)
						if message.playerNameClickable then
							list.ColumnPlayerNameTex:SetAlpha(0.3)
						end
						BMU:tooltipTextEnter(list.ColumnPlayerNameTex, tooltipTextPlayer)
						BMU.pauseAutoRefresh = true
					end)
					-- hide tooltip handler
					list.ColumnPlayerNameTex:SetHandler("OnMouseExit", function(self) list.ColumnPlayerNameTex:SetAlpha(0) BMU:tooltipTextEnter(list.ColumnPlayerNameTex) BMU.pauseAutoRefresh = false end)
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
			if BMU.savedVarsAcc.secondLanguage ~= 1 and message.zoneNameClickable == true and message.zoneNameSecondLanguage ~= nil then
				if #tooltipTextZone > 0 then
					-- add separator
					table.insert(tooltipTextZone, BMU.textures.tooltipSeperator)
				end
				-- add zone name
				table.insert(tooltipTextZone, message.zoneNameSecondLanguage)
			end
			------------------
			
			-- Parent zone name
			-- if zone is no overland zone -> show parent map
			if message.category ~= TELEPORTER_ZONE_CATEGORY_OVERLAND and message.parentZoneName and not message.houseTooltip then
				if #tooltipTextZone > 0 then
					-- add separator
					table.insert(tooltipTextZone, BMU.textures.tooltipSeperator)
				end
				-- add zone name
				table.insert(tooltipTextZone, message.parentZoneName)
			end
			------------------

			-- house tooltip
			if message.houseTooltip then
				if #tooltipTextZone > 0 then
					-- add separator
					table.insert(tooltipTextZone, BMU.textures.tooltipSeperator)
				end
				-- add house infos
				for _, v in pairs(message.houseTooltip) do
					table.insert(tooltipTextZone, v)
				end
			end
			------------------

			-- wayshrine and skyshard discovery info
			if message.zoneNameClickable == true and (message.zoneWayhsrineDiscoveryInfo ~= nil or message.zoneSkyshardDiscoveryInfo ~= nil) then
				if #tooltipTextZone > 0 then
					-- add separator
					table.insert(tooltipTextZone, BMU.textures.tooltipSeperator)
				end
				if message.zoneSkyshardDiscoveryInfo ~= nil then
					table.insert(tooltipTextZone, message.zoneSkyshardDiscoveryInfo)
				end
				if message.zoneWayhsrineDiscoveryInfo ~= nil then
					table.insert(tooltipTextZone, message.zoneWayhsrineDiscoveryInfo)
				end
			end
			------------------

			-- public dungeon achievement info (group event / skill point)
			if message.zoneNameClickable == true and message.publicDungeonAchiementInfo then
				if #tooltipTextZone > 0 then
					-- add separator
					table.insert(tooltipTextZone, BMU.textures.tooltipSeperator)
				end
				table.insert(tooltipTextZone, message.publicDungeonAchiementInfo)
			end
			------------------

			-- Set Collection information
			if message.setCollectionProgress then
				if #tooltipTextZone > 0 then
					-- add separator
					table.insert(tooltipTextZone, BMU.textures.tooltipSeperator)
				end
				-- add set collection info
				table.insert(tooltipTextZone, message.setCollectionProgress)
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
						message.zoneName = message.zoneName .. BMU.colorizeText(" (" .. totalItemsCountBank .. ")", "gray")
					end
					message.addedTotalItems = true
				end
				
				-- copy item names to tooltipTextZone
				if #tooltipTextZone > 0 then
					-- add separator
					table.insert(tooltipTextZone, BMU.textures.tooltipSeperator)
				end
				for _, item in ipairs(message.relatedItems) do
					table.insert(tooltipTextZone, item.itemTooltip)
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
					table.insert(tooltipTextZone, BMU.textures.tooltipSeperator)
				end
				for _, questName in ipairs(message.relatedQuests) do
					table.insert(tooltipTextZone, questName)
				end
			end
			------------------
			
			-- Info if player is in same instance
			if message.groupMemberSameInstance ~= nil then
				if #tooltipTextZone > 0 then
					-- add separator
					table.insert(tooltipTextZone, BMU.textures.tooltipSeperator)
				end
				-- add instance info
				if message.groupMemberSameInstance == true then
					table.insert(tooltipTextZone, BMU.colorizeText(SI.get(SI.TELE_UI_SAME_INSTANCE), "green"))
				else
					table.insert(tooltipTextZone, BMU.colorizeText(SI.get(SI.TELE_UI_DIFFERENT_INSTANCE), "red"))
				end
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
				list.ColumnZoneNameTex:SetHandler("OnMouseEnter", function(self) list.ColumnZoneNameTex:SetAlpha(0.3) BMU:tooltipTextEnter(list.ColumnZoneNameTex, tooltipTextZone) BMU.pauseAutoRefresh = true end)
				list.ColumnZoneNameTex:SetHandler("OnMouseUp", function(self, button) BMU.clickOnZoneName(button, message) end)
				list.ColumnZoneNameTex:SetHandler("OnMouseExit", function(self) list.ColumnZoneNameTex:SetAlpha(0) BMU:tooltipTextEnter(list.ColumnZoneNameTex) BMU.pauseAutoRefresh = false end)
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
					table.insert(tooltipTextZone, BMU.textures.tooltipSeperator)
				end
				-- add dungeon infos
				for _, v in pairs(message.dungeonTooltip) do
					table.insert(tooltipTextZone, v)
				end
			end
			------------------
			
			-- set text and color
			list.ColumnPlayerName:SetText(BMU.colorizeText(message.displayName, message.textColorDisplayName))
			list.ColumnZoneName:SetText(BMU.colorizeText(message.zoneName, message.textColorZoneName))
			
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
				list.ColumnNumberPlayersTex:SetHandler("OnMouseUp", function(self, button) BMU.createTable({index=8, fZoneId=message.zoneId}) end)
			else
				list.ColumnNumberPlayers:SetText("")
				-- hide
				list.ColumnNumberPlayersTex:SetHidden(true)
			end
			
						
			-- set wayshrine icon
			local texture_normal = BMU.textures.wayshrineBtn
			local texture_over = BMU.textures.wayshrineBtnOver
			
			if message.category ~= nil and message.category ~= TELEPORTER_ZONE_CATEGORY_UNKNOWN then
				-- set category texture
				if message.category == TELEPORTER_ZONE_CATEGORY_DELVE then
					-- set Delve texture
					texture_normal = BMU.textures.delvesBtn
					texture_over = BMU.textures.delvesBtnOver
				elseif message.category == TELEPORTER_ZONE_CATEGORY_PUBDUNGEON then
					-- set Public Dungeon texture
					texture_normal = BMU.textures.publicDungeonBtn
					texture_over = BMU.textures.publicDungeonBtnOver
				elseif message.category == TELEPORTER_ZONE_CATEGORY_HOUSE then
					-- set House texture
					texture_normal = BMU.textures.houseBtn
					texture_over = BMU.textures.houseBtnOver
				elseif message.category == TELEPORTER_ZONE_CATEGORY_GRPDUNGEON then
					-- 4 men Group Dungeons
					texture_normal = BMU.textures.groupDungeonBtn
					texture_over = BMU.textures.groupDungeonBtnOver
				elseif message.category == TELEPORTER_ZONE_CATEGORY_TRAIL then
					-- 12 men Group Dungeons
					texture_normal = BMU.textures.raidDungeonBtn
					texture_over = BMU.textures.raidDungeonBtnOver
				elseif message.category == TELEPORTER_ZONE_CATEGORY_ENDLESSD then
					-- endless dungeon
					texture_normal = BMU.textures.endlessDungeonBtn
					texture_over = BMU.textures.endlessDungeonBtnOver
				elseif message.category == TELEPORTER_ZONE_CATEGORY_GRPZONES then
					-- Other Group Zones (Dungeons in Craglorn)
					texture_normal = BMU.textures.groupZonesBtn
					texture_over = BMU.textures.groupZonesBtnOver
				elseif message.category == TELEPORTER_ZONE_CATEGORY_GRPARENA then
					-- Group Arenas
					texture_normal = BMU.textures.groupDungeonBtn
					texture_over = BMU.textures.groupDungeonBtnOver
				elseif message.category == TELEPORTER_ZONE_CATEGORY_SOLOARENA then
					-- Solo Arenas
					texture_normal = BMU.textures.soloArenaBtn
					texture_over = BMU.textures.soloArenaBtnOver
				elseif message.zoneWithoutPlayer and GetInteractionType() ~= INTERACTION_FAST_TRAVEL then
					-- zones without players (fast travel for gold)
					-- show normal icon if player is at a wayshrine (travel for free)
					texture_normal = BMU.textures.noPlayerBtn
					texture_over = BMU.textures.noPlayerBtnOver
				end
			end
			
			-- check for Group Leader
			if message.sourceIndexLeading == TELEPORTER_SOURCE_INDEX_GROUP and message.isLeader then
				-- set Group Leader texture
				texture_normal = BMU.textures.groupLeaderBtn
				texture_over = BMU.textures.groupLeaderBtnOver
			end
			
			if message.isOwnHouse and CanJumpToHouseFromCurrentLocation() and CanLeaveCurrentLocationViaTeleport() then
				-- own house
				list.portalToPlayerTex:SetHidden(false)
				list.portalToPlayerTex:SetTexture(BMU.textures.houseBtn)
				list.portalToPlayerTex:SetHandler("OnMouseEnter", function(self) list.portalToPlayerTex:SetTexture(BMU.textures.houseBtnOver) BMU.pauseAutoRefresh = true end)
				list.portalToPlayerTex:SetHandler("OnMouseExit", function(self) list.portalToPlayerTex:SetTexture(BMU.textures.houseBtn) BMU.pauseAutoRefresh = false end)
				list.portalToPlayerTex:SetHandler("OnMouseUp", function(self, button) BMU.clickOnTeleportToOwnHouseButton(list.portalToPlayerTex, button, message) end)
				
			elseif message.isPTFHouse and CanJumpToHouseFromCurrentLocation() and CanLeaveCurrentLocationViaTeleport() then
				-- "Port to Freind's House" integration
				list.portalToPlayerTex:SetHidden(false)
				list.portalToPlayerTex:SetTexture(BMU.textures.ptfHouseBtn)
				list.portalToPlayerTex:SetHandler("OnMouseEnter", function(self) list.portalToPlayerTex:SetTexture(BMU.textures.ptfHouseBtnOver) BMU.pauseAutoRefresh = true end)
				list.portalToPlayerTex:SetHandler("OnMouseExit", function(self) list.portalToPlayerTex:SetTexture(BMU.textures.ptfHouseBtn) BMU.pauseAutoRefresh = false end)
				list.portalToPlayerTex:SetHandler("OnMouseUp", function(self, button) BMU.clickOnTeleportToPTFHouseButton(list.portalToPlayerTex, button, message) end)

			elseif message.isGuild then
				-- Own and partner guilds
				if not message.hideButton then
					list.portalToPlayerTex:SetHidden(false)
					list.portalToPlayerTex:SetTexture(BMU.textures.guildBtn)
					list.portalToPlayerTex:SetHandler("OnMouseEnter", function(self) list.portalToPlayerTex:SetTexture(BMU.textures.guildBtnOver) BMU.pauseAutoRefresh = true end)
					list.portalToPlayerTex:SetHandler("OnMouseExit", function(self) list.portalToPlayerTex:SetTexture(BMU.textures.guildBtn) BMU.pauseAutoRefresh = false end)
					list.portalToPlayerTex:SetHandler("OnMouseUp", function(self, button) BMU.clickOnOpenGuild(list.portalToPlayerTex, button, message) end)
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
						BMU:tooltipTextEnter(list.portalToPlayerTex, message.difficultyText .. "\n" .. BMU.colorizeText(string.format(GetString(SI_TOOLTIP_RECALL_COST) .. "%d", GetRecallCost()), "red"))
					else
						BMU:tooltipTextEnter(list.portalToPlayerTex, message.difficultyText)
					end
					BMU.pauseAutoRefresh = true end)
				list.portalToPlayerTex:SetHandler("OnMouseExit", function(self) list.portalToPlayerTex:SetTexture(texture_normal) BMU:tooltipTextEnter(list.portalToPlayerTex) BMU.pauseAutoRefresh = false end)
				list.portalToPlayerTex:SetHandler("OnMouseUp", function(self, button) BMU.clickOnTeleportToDungeonButton(list.portalToPlayerTex, button, message) end)
				
			elseif message.displayName ~= "" and CanJumpToPlayerInZone(message.zoneId) and CanLeaveCurrentLocationViaTeleport() then
				-- player
				list.portalToPlayerTex:SetHidden(false)
				list.portalToPlayerTex:SetTexture(texture_normal)
				list.portalToPlayerTex:SetHandler("OnMouseEnter", function(self) list.portalToPlayerTex:SetTexture(texture_over) BMU.pauseAutoRefresh = true end)
				list.portalToPlayerTex:SetHandler("OnMouseExit", function(self) list.portalToPlayerTex:SetTexture(texture_normal) BMU.pauseAutoRefresh = false end)
				list.portalToPlayerTex:SetHandler("OnMouseUp", function(self, button) BMU.clickOnTeleportToPlayerButton(list.portalToPlayerTex, button, message) end)
			
			elseif BMU.savedVarsAcc.showZonesWithoutPlayers2 and message.displayName == "" and message.zoneWithoutPlayer and CanLeaveCurrentLocationViaTeleport() and message.zoneWayshrineDiscovered and message.zoneWayshrineDiscovered > 0 then
				-- zones without players (fast travel for gold)
				list.portalToPlayerTex:SetHidden(false)
				list.portalToPlayerTex:SetTexture(texture_normal)
				list.portalToPlayerTex:SetHandler("OnMouseEnter", function(self)
					list.portalToPlayerTex:SetTexture(texture_over)
					if GetInteractionType() ~= INTERACTION_FAST_TRAVEL then
						-- show tooltip with costs only if player is not at a wayshrine
						BMU:tooltipTextEnter(list.portalToPlayerTex, BMU.colorizeText(string.format(GetString(SI_TOOLTIP_RECALL_COST) .. "%d", GetRecallCost()), "red"))
					end
					BMU.pauseAutoRefresh = true end)
				list.portalToPlayerTex:SetHandler("OnMouseExit", function(self) list.portalToPlayerTex:SetTexture(texture_normal) BMU:tooltipTextEnter(list.portalToPlayerTex) BMU.pauseAutoRefresh = false end)
				list.portalToPlayerTex:SetHandler("OnMouseUp", function(self, button) BMU.clickOnTeleportToPlayerButton(list.portalToPlayerTex, button, message) end)
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
	-- click effect
	textureControl:SetAlpha(0.65)
	zo_callLater(function() textureControl:SetAlpha(1) end, 200)	

	-- catch the case if the it is a zone without player (fast travel for gold)
	if message.zoneWithoutPlayer then
		BMU.PortalToZone(message.zoneId)
		return
	end
	
	if button == MOUSE_BUTTON_INDEX_RIGHT and IsPlayerInGroup(GetDisplayName()) then
		-- create and share link to the group channel
		local linkType = "book"
		local data1 = 190 -- bookId
		local data2 = "BMU_S_P" -- signature
		local data3 = GetDisplayName() -- playerFrom
		local data4 = message.displayName -- playerTo
		local text = "Follow me!" -- currently not working because linkType "book" does not allow custom text
		
		local link = "|H1:" .. linkType .. ":" .. data1 .. ":" .. data2 .. ":" .. data3 .. ":" .. data4 .. "|h[" .. text .. "]|h"
		
		local preText = "Click to follow me to " .. message.zoneName .. ": "

		-- print link into group channel - player has to press Enter manually!
		StartChatInput(preText .. link, CHAT_CHANNEL_PARTY)
	end
	
	-- port to player anyway
	BMU.PortalToPlayer(message.displayName, message.sourceIndexLeading, message.zoneName, message.zoneId, message.category, true, true, true)
	if BMU.savedVarsAcc.closeOnPorting then
		-- hide world map if open
		SCENE_MANAGER:Hide("worldMap")
		-- hide UI if open
		BMU.HideTeleporter()
	end
end


function BMU.clickOnTeleportToOwnHouseButton(textureControl, button, message)
	-- click effect
	textureControl:SetAlpha(0.65)
	zo_callLater(function() textureControl:SetAlpha(1) end, 200)
	
	if message.forceOutside then
		BMU.clickOnTeleportToOwnHouseButton_2(button, message, true)
	else
		-- show submenu
		ClearMenu()
		AddCustomMenuItem(GetString(SI_HOUSING_BOOK_ACTION_TRAVEL_TO_HOUSE_INSIDE), function() BMU.clickOnTeleportToOwnHouseButton_2(button, message, false) end)
		AddCustomMenuItem(GetString(SI_HOUSING_BOOK_ACTION_TRAVEL_TO_HOUSE_OUTSIDE), function() BMU.clickOnTeleportToOwnHouseButton_2(button, message, true) end)
		ShowMenu()
	end
end


function BMU.clickOnTeleportToOwnHouseButton_2(button, message, jumpOutside)
	-- porting outside of a house cant be shared
	if button == MOUSE_BUTTON_INDEX_RIGHT and IsPlayerInGroup(GetDisplayName()) and not jumpOutside then
		-- create and share link to the group channel
		local linkType = "book"
		local data1 = 190 -- bookId
		local data2 = "BMU_S_H" -- signature
		local data3 = GetDisplayName() -- player
		local data4 = message.houseId -- houseId
		local text = "Follow me!" -- currently not working because linkType "book" does not allow custom text
		
		local link = "|H1:" .. linkType .. ":" .. data1 .. ":" .. data2 .. ":" .. data3 .. ":" .. data4 .. "|h[" .. text .. "]|h"
		local preText = "Click to follow me to " .. BMU.formatName(GetZoneNameById(message.zoneId), false) .. ": "

		-- print link into group channel - player has to press Enter manually!
		StartChatInput(preText .. link, CHAT_CHANNEL_PARTY)
	end
	
	-- port to own house anyway
	BMU.portToOwnHouse(false, message.houseId, jumpOutside, message.parentZoneName)
end


function BMU.clickOnTeleportToPTFHouseButton(textureControl, button, message)
	-- click effect
	textureControl:SetAlpha(0.65)
	zo_callLater(function() textureControl:SetAlpha(1) end, 200)

	if message.displayName ~= nil and message.displayName ~= "" and message.houseId ~= nil and message.houseId > 0 then
		-- cut PTF favorite number which is maybe before displayName
		local position, _ = string.find(message.displayName, "@")
		if position ~= nil then
			message.displayName = string.sub(message.displayName, position)
		end
		
		if button == MOUSE_BUTTON_INDEX_RIGHT and IsPlayerInGroup(GetDisplayName()) then
			-- create and share link to the group channel
			local linkType = "book"
			local data1 = 190 -- bookId
			local data2 = "BMU_S_H" -- signature
			local data3 = message.displayName -- player
			local data4 = message.houseId -- houseId
			local text = "Follow me!" -- currently not working because linkType "book" does not allow custom text
			
			local link = "|H1:" .. linkType .. ":" .. data1 .. ":" .. data2 .. ":" .. data3 .. ":" .. data4 .. "|h[" .. text .. "]|h"
			local preText = "Click to follow me to " .. data3 .. " - ".. BMU.formatName(GetZoneNameById(message.zoneId), false) .. ": "

			-- print link into group channel - player has to press Enter manually!
			StartChatInput(preText .. link, CHAT_CHANNEL_PARTY)
		end
		
		-- show additional animation
		if BMU.savedVarsAcc.showTeleportAnimation then
			BMU.showTeleportAnimation()
		end
		
		-- port to house anyway
		if message.displayName == GetDisplayName() or message.displayName == nil or zo_strtrim(message.displayName) == "" then
			-- own house
			BMU.printToChat(GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. BMU.formatName(GetZoneNameById(message.zoneId), false))
			RequestJumpToHouse(message.houseId)
		else
			BMU.printToChat("Port to PTF House:" .. " " .. message.displayName .. " - " .. BMU.formatName(GetZoneNameById(message.zoneId), false))
			JumpToSpecificHouse(message.displayName, message.houseId)
		end
	
		if BMU.savedVarsAcc.closeOnPorting then
			-- hide world map if open
			SCENE_MANAGER:Hide("worldMap")
			-- hide UI if open
			BMU.HideTeleporter()
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
		ClearMenu()
		AddCustomMenuItem(BMU.textures.dungeonDifficultyNormal .. GetString(SI_DUNGEONDIFFICULTY1), function() BMU.setDungeonDifficulty(false) zo_callLater(function() BMU.clickOnTeleportToDungeonButton_2(message) end, 200) end)
		AddCustomMenuItem(BMU.textures.dungeonDifficultyVeteran .. GetString(SI_DUNGEONDIFFICULTY2), function() BMU.setDungeonDifficulty(true) zo_callLater(function() BMU.clickOnTeleportToDungeonButton_2(message) end, 200) end)
		ShowMenu()
	else
		-- just start teleport
		BMU.clickOnTeleportToDungeonButton_2(message)
	end
end


function BMU.clickOnTeleportToDungeonButton_2(message)
	if GetInteractionType() == INTERACTION_FAST_TRAVEL then
		-- player is at wayshrine and travels for free -> dont show any chat printouts
		-- start travel to node
		FastTravelToNode(message.nodeIndex)
		return
	else
		-- port for costs
		BMU.printToChat(GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. message.zoneName .. " (" .. zo_strformat(SI_MONEY_FORMAT, GetRecallCost()) .. ")")
		-- show additional animation
		if BMU.savedVarsAcc.showTeleportAnimation then
			BMU.showTeleportAnimation()
		end
		FastTravelToNode(message.nodeIndex)
		if BMU.savedVarsAcc.closeOnPorting then
			-- hide world map if open
			SCENE_MANAGER:Hide("worldMap")
			-- hide UI if open
			BMU.HideTeleporter()
		end
		return
	end
end


-- refresh in depending of current state
function BMU.refreshListAuto(mapChanged)
	-- return if window is hidden
	if BMU.win.Main_Control:IsHidden() then
		return
	end

	local inputString = ""
	if BMU.state == 2 then
		-- catch input string (player)
		inputString = BMU.win.Searcher_Player:GetText()
	elseif BMU.state == 3 then
		-- catch input string (zone)
		inputString = BMU.win.Searcher_Zone:GetText()
	end
	
	if BMU.state == 11 or BMU.state == 13 or BMU.state == 14 or (BMU.state == 9 and mapChanged) then
		-- if list of own houses (11) or guilds (13) or Dungeon Finder (14) or (related quests (9) and trigger from map change) dont auto refresh
		return
	elseif BMU.state == 12 then
		BMU.createTablePTF()
	else
		BMU.createTable({index=BMU.state, inputString=inputString, fZoneId=BMU.stateZoneId, filterSourceIndex=BMU.stateSourceIndex, dontResetSlider=true})
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
	CALLBACK_MANAGER:FireCallbacks('BMU_List_Updated')
end


-- working alternative to unsupported frontier pattern mathing with string.find
-- gets an input string (word) and checks if the input string is "as whole" in myString (no alphanumeric symbols directly before or after word)
-- Example: isWholeWordInString("Nchuleft", "Nchuleftingth") -> FALSE
--			isWholeWordInString("Mahlstrom", "The Mahlstrom (Veteran)") -> TRUE
function BMU.isWholeWordInString(myString, word)
	return select(2,myString:gsub('^' .. word .. '%W+','')) +
		select(2,myString:gsub('%W+' .. word .. '$','')) +
		select(2,myString:gsub('^' .. word .. '$','')) +
		select(2,myString:gsub('%W+' .. word .. '%W+','')) > 0
end


function BMU.clickOnZoneName(button, record)
	if button == MOUSE_BUTTON_INDEX_LEFT then
		-- PTF house tab
		if record.PTFHouseOpen then
			-- hide world map if open
			SCENE_MANAGER:Hide("worldMap")
			-- hide UI if open
			BMU.HideTeleporter()
			zo_callLater(function() PortToFriend.OpenWindow(function() zo_callLater(function() SetGameCameraUIMode(true) BMU.OpenTeleporter(false) BMU.createTablePTF() end, 150) end) end, 150)
			--SetGameCameraUIMode(true)
			return
		end
		
		------ display map ------
		-- switch to Tamriel and back to players map in order to reset any subzone or zoom
		if record.mapIndex ~= nil then
			SCENE_MANAGER:Show("worldMap")
			ZO_WorldMap_SetMapByIndex(1)
			ZO_WorldMap_SetMapByIndex(record.mapIndex)
			CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
		end
		
		------ display poi on map (in case of delve, dungeon etc.) ------
		if record.parentZoneId ~= nil and (record.category ~= TELEPORTER_ZONE_CATEGORY_OVERLAND or record.forceOutside) then			
			local normalizedX
			local normalizedZ
			-- primary: use LibZone function
			local parentZoneId, parentZoneIndex, poiIndex = BMU.LibZone:GetZoneMapPinInfo(record.zoneId, record.parentZoneId)
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
					local objectiveNameWithArticle = string.lower(BMU.formatName(e.objectiveName, false))
					local zoneNameWithArticle = string.lower(BMU.formatName(toSearch, false))
					local objectiveNameWithoutArticle = string.lower(BMU.formatName(e.objectiveName, true))
					local zoneNameWithoutArcticle = string.lower(BMU.formatName(toSearch, true))
					
					-- solve bug with "-"
					if zoneNameWithArticle ~= nil then
						zoneNameWithArticle = string.gsub(zoneNameWithArticle, "-", "--")
					end
				
					-- check (if zoneNameWithArticle is found in objectiveNameWithArticle) or if (zoneNameWithoutArcticle is found in objectiveNameWithArticle) AND objective has no wayshrine or portal icon (to prevent matches with wayshrines and dolmen)
					if (BMU.isWholeWordInString(objectiveNameWithArticle, zoneNameWithArticle) or BMU.isWholeWordInString(objectiveNameWithArticle, zoneNameWithoutArcticle)) and not string.match(string.lower(e.icon), "wayshrine") and not string.match(string.lower(e.icon), "portal") then
						normalizedX = e.normalizedX
						normalizedZ = e.normalizedZ
						break
					end
				end
			end
			------------------
			
			if normalizedX and normalizedZ then
				-- Map Ping
				if BMU.savedVarsAcc.useMapPing and BMU.LibMapPing then
					PingMap(MAP_PIN_TYPE_RALLY_POINT, MAP_TYPE_LOCATION_CENTERED, normalizedX, normalizedZ)
				end
				-- Pan and Zoom
				if BMU.savedVarsAcc.usePanAndZoom then
					zo_callLater(function() ZO_WorldMap_PanToNormalizedPosition(normalizedX, normalizedZ) end, 200)
				end
			end
		end
	else -- button == MOUSE_BUTTON_INDEX_RIGHT
		
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
		ClearMenu()
		
		if inOwnHouseTab then
			
			-- rename own houses
			AddCustomMenuItem(SI.get(SI.TELE_UI_RENAME_HOUSE_NICKNAME), function() ZO_CollectionsBook.ShowRenameDialog(record.collectibleId) end)
			
			-- make primary residence
			if record.prio ~= 1 then
				-- prio = 1 -> is primary house
				-- make primary and refresh with delay
				AddCustomMenuItem(GetString(SI_HOUSING_FURNITURE_SETTINGS_GENERAL_PRIMARY_RESIDENCE_BUTTON_TEXT), function()
					SetHousingPrimaryHouse(record.houseId)
					zo_callLater(function()
						BMU.createTableHouses()
					end, 500)
				 end)
			end
			
			-- custom sorting (not for primary residence which is always on top)
			if record.prio ~= 1 then
				-- divider
				AddCustomMenuItem("-", function() end)
				-- button to increase sorting ("move up")
				AddCustomMenuItem(BMU.textures.arrowUp, function()
					
					if not BMU.savedVarsServ.houseCustomSorting[record.houseId] then
						if next(BMU.savedVarsServ.houseCustomSorting) == nil then
							-- table is empty, just set start value
							BMU.savedVarsServ.houseCustomSorting[record.houseId] = 99
						else
							-- first time: set the entry at the end of the list
							BMU.savedVarsServ.houseCustomSorting[record.houseId] = BMU.getLowestNumber(BMU.savedVarsServ.houseCustomSorting) - 1
						end
					else
						local currentValue = BMU.savedVarsServ.houseCustomSorting[record.houseId]
						local houseIdOfPre = BMU.has_value(BMU.savedVarsServ.houseCustomSorting, currentValue + 1)
						if houseIdOfPre then
							-- predecessor exists: switch positions
							BMU.savedVarsServ.houseCustomSorting[record.houseId] = currentValue + 1
							BMU.savedVarsServ.houseCustomSorting[houseIdOfPre] = currentValue
						end
					end
					BMU.createTableHouses()
				
				end)
				
				-- current position
				-- AddCustomMenuItem("   " .. (BMU.savedVarsServ.houseCustomSorting[record.houseId] or "-"), function() end)
				
				-- button to decrease sorting ("move down")
				-- show only if the entry is already in order
				if BMU.savedVarsServ.houseCustomSorting[record.houseId] then
					AddCustomMenuItem(BMU.textures.arrowDown, function()

						local currentValue = BMU.savedVarsServ.houseCustomSorting[record.houseId]
						local houseIdOfSuc = BMU.has_value(BMU.savedVarsServ.houseCustomSorting, currentValue - 1)
						if houseIdOfSuc then
							-- successor exists: switch positions
							BMU.savedVarsServ.houseCustomSorting[record.houseId] = currentValue - 1
							BMU.savedVarsServ.houseCustomSorting[houseIdOfSuc] = currentValue
						end
						BMU.createTableHouses()

					end)
				end

			end
		end
		
		-- show quest marker
		if inQuestTab then
			for k, v in pairs(record.relatedQuests) do
				-- Show quest marker on map if record contains quest
				AddCustomMenuItem(SI.get(SI.TELE_UI_SHOW_QUEST_MARKER_ON_MAP) .. ": \"" .. record.relatedQuests[k] .. "\"", function() ZO_WorldMap_ShowQuestOnMap(record.relatedQuestsSlotIndex[k]) end)
			end
		end
		
		-- use item
		if inItemsTab then
			-- create entry for each item in inventory: UseItem(number Bag bagId, number slotIndex)
			for index, item in pairs(record.relatedItems) do
				if item.bagId == BAG_BACKPACK and IsProtectedFunction("UseItem") then -- item is in inventory and can be used
					-- use item
					AddCustomMenuItem(SI.get(SI.TELE_UI_VIEW_MAP_ITEM) .. ": '" .. item.itemName .. "'", function()
						-- hide world map if open
						SCENE_MANAGER:Hide("worldMap")
						-- hide UI if open
						BMU.HideTeleporter()
						-- use item delayed
						zo_callLater(function()
							CallSecureProtected("UseItem", BAG_BACKPACK, item.slotIndex)
						end, 250)
					end)
				elseif item.antiquityId then -- lead -> show lead in codex
					AddCustomMenuItem(GetString(SI_ANTIQUITY_VIEW_IN_CODEX) .. ": \"" .. item.itemName .. "\"", function()
						ANTIQUITY_LORE_KEYBOARD:ShowAntiquity(item.antiquityId)
					end)
				end
				
			end
		end
		
		-- favorites menu (showing in all lists except dungeon and own house tab)
		local entries_favorites = {}
		
		if not inDungeonTab and not inOwnHouseTab then
			-- generate menu entries favorites
			if BMU.isFavoriteZone(record.zoneId) then
				entries_favorites = {
					{
						label = SI.get(SI.TELE_UI_REMOVE_FAVORITE_ZONE),
						callback = function(state) BMU.removeFavoriteZone(record.zoneId) end,
					}
				}
			else
				-- number of favorites displayed in the context menu
				for i=1, BMU.var.numFavoriteZones, 1 do
					local favName = ""
					if BMU.savedVarsServ.favoriteListZones[i] ~= nil then
						favName = BMU.formatName(GetZoneNameById(BMU.savedVarsServ.favoriteListZones[i]), BMU.savedVarsAcc.formatZoneName)
					end
					local entry = {
						label = SI.get(SI.TELE_UI_FAVORITE_ZONE) .. " " .. tostring(i) .. ": " .. favName,
						callback = function(state) BMU.addFavoriteZone(i, record.zoneId, record.zoneName) end,
					}			
					table.insert(entries_favorites, entry)
				end
			end
			AddCustomSubMenuItem(SI.get(SI.TELE_UI_SUBMENU_FAVORITES), entries_favorites)
		end
		
		-- unlocking wayshrines menu (showing in all lists except dungeon and own house tab)
		if not inDungeonTab and not inOwnHouseTab then
			if BMU.isZoneOverlandZone(record.zoneId) then
				AddCustomMenuItem(SI.get(SI.TELE_UI_UNLOCK_WAYSHRINES), function() BMU.showDialogAutoUnlock(record.zoneId) end)
			end
		end
		
		-- open item set collection book (collectibles)
		if not inOwnHouseTab then
			local numUnlocked, numTotal, workingZoneId = BMU.getNumSetCollectionProgressPieces(record.zoneId, record.category, record.parentZoneId)
			if workingZoneId then
				AddCustomMenuItem(GetString(SI_ITEM_SETS_BOOK_TITLE), function() BMU.LibSets.OpenItemSetCollectionBookOfZone(workingZoneId) end)
			end
		end
		
		-- reset port counter (due to force refresh only available in general list)
		if not inDungeonTab and not inOwnHouseTab and not inQuestTab and not inItemsTab then
			if BMU.savedVarsChar.sorting == 3 or BMU.savedVarsChar.sorting == 4 then
				AddCustomMenuItem(SI.get(SI.TELE_UI_RESET_COUNTER_ZONE), function() BMU.savedVarsAcc.portCounterPerZone[record.zoneId] = nil BMU.refreshListAuto() end)
			end
		end

		-- favorite a dungeon
		if inDungeonTab then
			if BMU.savedVarsServ.favoriteDungeon == record.zoneId then
				AddCustomMenuItem(SI.get(SI.TELE_UI_REMOVE_FAVORITE_ZONE), function() BMU.savedVarsServ.favoriteDungeon = 0 BMU.createTableDungeons() end)
			else
				AddCustomMenuItem(SI.get(SI.TELE_UI_FAVORITE_ZONE), function() BMU.savedVarsServ.favoriteDungeon = record.zoneId BMU.createTableDungeons() end)
			end
		end
		
		ShowMenu()
	end
end


function BMU.clickOnPlayerName(button, record)
	-- Actions for "Invite to Guild" ??
		-- GetNumGuilds()
		-- GetGuildId(number index) Returns: number guildId
		-- GetGuildName(number guildId) Returns: string name
		-- GetGuildMemberIndexFromDisplayName(number guildId, string displayName) Returns: number:nilable memberIndex
		-- GetGuildMemberInfo(number guildId, number memberIndex) Returns: string name, string note, number rankIndex, number PlayerStatus playerStatus, number secsSinceLogoff
		-- DoesGuildRankHavePermission(number guildId, number rankIndex, number GuildPermission permission) Returns: boolean hasPermission
		-- GuildInvite(number guildId, string displayName)
	
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		ClearMenu()
		
		local unitTag = nil
		local entries_group = {}
		local entries_misc = {}
		local pos = 1
		
		-- get unitTag
		if IsPlayerInGroup(GetDisplayName()) then
			local groupUnitTag = ""
			for j = 1, GetGroupSize() do
				groupUnitTag = GetGroupUnitTagByIndex(j)
				if record.displayName == GetUnitDisplayName(groupUnitTag) then
				unitTag = groupUnitTag
				end
			end
		end
	
		-- generate submenu entries for group
		if not IsPlayerInGroup(record.displayName) and IsUnitSoloOrGroupLeader("player") then
			entries_group[pos] = {
				label = GetString(SI_CHAT_PLAYER_CONTEXT_ADD_GROUP),
				callback = function(state) GroupInviteByName(record.characterName) end,
			}
			pos = pos + 1
		end
		
		if IsPlayerInGroup(record.displayName) and IsUnitGroupLeader("player") then
			entries_group[pos] = {
				label = GetString(SI_GROUP_LIST_MENU_PROMOTE_TO_LEADER),
				callback = function(state) GroupPromote(unitTag) end,
			}
			pos = pos + 1
			
			entries_group[pos] = {
				label = GetString(SI_GROUP_LIST_MENU_KICK_FROM_GROUP),
				callback = function(state) GroupKick(unitTag) end,
			}
			pos = pos + 1
		end
		
		if IsUnitGrouped("player") and not IsUnitGroupLeader("player") and IsPlayerInGroup(record.displayName) and not IsUnitGroupLeader(unitTag) then
			entries_group[pos] = {
				label = SI.get(SI.TELE_UI_VOTE_TO_LEADER),
				callback = function(state) BeginGroupElection(GROUP_ELECTION_TYPE_NEW_LEADER, ZO_GROUP_ELECTION_DESCRIPTORS.NONE, unitTag) end,
			}
			pos = pos + 1
		end
		
		if IsUnitGrouped("player") then
			entries_group[pos] = {
				label = GetString(SI_GROUP_LIST_MENU_LEAVE_GROUP),
				callback = function(state) GroupLeave() end,
			}
			pos = pos + 1
			
			if DoesGroupModificationRequireVote() then
				entries_group[pos] = {
					label = GetString(SI_GROUP_LIST_MENU_VOTE_KICK_FROM_GROUP),
					callback = function(state) BeginGroupElection(GROUP_ELECTION_TYPE_KICK_MEMBER, ZO_GROUP_ELECTION_DESCRIPTORS.NONE, unitTag) end,
				}
				pos = pos + 1
			end
		end
		
		
		-- generate submenu entries for misc
		pos = 1
		
		-- whisper
		entries_misc[pos] = {
			label = GetString(SI_SOCIAL_LIST_PANEL_WHISPER),
			callback = function(state) StartChatInput("", CHAT_CHANNEL_WHISPER, record.displayName) end,
--			tooltip = "Tooltip Test: Whisper",
		}
		pos = pos + 1
		
		-- Jump to House
		entries_misc[pos] = {
			label = GetString(SI_SOCIAL_MENU_VISIT_HOUSE),
			callback = function(state) JumpToHouse(record.displayName) end,
		}
		pos = pos + 1
		
		-- Send Mail
		entries_misc[pos] = {
			label = GetString(SI_SOCIAL_MENU_SEND_MAIL),
			callback = function(state) BMU.createMail(record.displayName, "", "") end,
		}
		pos = pos + 1	

		-- Add / Remove Friend
		if IsFriend(record.displayName) then
			entries_misc[pos] = {
				label = GetString(SI_FRIEND_MENU_REMOVE_FRIEND),
				callback = function(state) RemoveFriend(record.displayName) end,
			}
			pos = pos + 1
		else
			entries_misc[pos] = {
				label = GetString(SI_SOCIAL_MENU_ADD_FRIEND),
				callback = function(state) RequestFriend(record.displayName, "") end,
			}
			pos = pos + 1
		end
		
		-- Invite to Tribute Card Game
		entries_misc[pos] = {
			label = GetString(SI_NOTIFICATIONTYPE30),
			callback = function(state) InviteToTributeByDisplayName(record.displayName) end,
		}
		pos = pos + 1
		
		-- Invite to primary BeamMeUp guild
		if BMU.var.BMUGuilds[GetWorldName()] ~= nil then
			local primaryBMUGuild = BMU.var.BMUGuilds[GetWorldName()][1]
			if IsPlayerInGuild(primaryBMUGuild) and not GetGuildMemberIndexFromDisplayName(primaryBMUGuild, record.displayName) then
				entries_misc[pos] = {
					label = SI.get(SI.TELE_UI_INVITE_BMU_GUILD) .. ": BeamMeUp",
					callback = function(state) GuildInvite(primaryBMUGuild, record.displayName) end,
				}
				pos = pos + 1
			end
		
			-- Invite to secondary BeamMeUp guild
			local secondaryBMUGuild = BMU.var.BMUGuilds[GetWorldName()][2]
			if IsPlayerInGuild(secondaryBMUGuild) and not GetGuildMemberIndexFromDisplayName(secondaryBMUGuild, record.displayName) then
				entries_misc[pos] = {
					label = SI.get(SI.TELE_UI_INVITE_BMU_GUILD) .. ": BeamMeUp-Two",
					callback = function(state) GuildInvite(secondaryBMUGuild, record.displayName) end,
				}
				pos = pos + 1
			end

			-- Invite to tertiary BeamMeUp guild
			local tertiaryBMUGuild = BMU.var.BMUGuilds[GetWorldName()][3]
			if IsPlayerInGuild(tertiaryBMUGuild) and not GetGuildMemberIndexFromDisplayName(tertiaryBMUGuild, record.displayName) then
				entries_misc[pos] = {
					label = SI.get(SI.TELE_UI_INVITE_BMU_GUILD) .. ": BeamMeUp-Three",
					callback = function(state) GuildInvite(tertiaryBMUGuild, record.displayName) end,
				}
				pos = pos + 1
			end
			
			-- Invite to quaternary BeamMeUp guild
			local quaternaryBMUGuild = BMU.var.BMUGuilds[GetWorldName()][4]
			if IsPlayerInGuild(quaternaryBMUGuild) and not GetGuildMemberIndexFromDisplayName(quaternaryBMUGuild, record.displayName) then
				entries_misc[pos] = {
					label = SI.get(SI.TELE_UI_INVITE_BMU_GUILD) .. ": BeamMeUp-Four",
					callback = function(state) GuildInvite(quaternaryBMUGuild, record.displayName) end,
				}
				pos = pos + 1
			end
		end
		
		-- generate menu entries favorites
		local entries_favorites = {}
		if BMU.isFavoritePlayer(record.displayName) then
			entries_favorites = {
				{
					label = SI.get(SI.TELE_UI_REMOVE_FAVORITE_PLAYER),
					callback = function(state) BMU.removeFavoritePlayer(record.displayName) end,
				}
			}
		else
			-- number of favorites displayed in the context menu
			for i=1, BMU.var.numFavoritePlayers, 1 do
				local favName = ""
				if BMU.savedVarsServ.favoriteListPlayers[i] ~= nil then
					favName = BMU.savedVarsServ.favoriteListPlayers[i]
				end
				local entry = {
					label = SI.get(SI.TELE_UI_FAVORITE_PLAYER) .. " " .. tostring(i) .. ": " .. favName,
					callback = function(state) BMU.addFavoritePlayer(i, record.displayName) end,
				}			
				table.insert(entries_favorites, entry)
			end
		end
		AddCustomSubMenuItem(SI.get(SI.TELE_UI_SUBMENU_FAVORITES), entries_favorites)
		
		-- add submenu group
		if #entries_group > 0 then
			AddCustomSubMenuItem(GetString(SI_PLAYER_MENU_GROUP), entries_group)
		end
		
		-- add submenu misc
	    AddCustomSubMenuItem(GetString(SI_PLAYER_MENU_MISC), entries_misc)
		
		-- add submenu filter
		local entries_filter = {
				{
					label = BMU.colorizeText(GetString(SI_GAMEPAD_CAMPAIGN_BROWSER_TOOLTIP_GROUP_MEMBERS), "orange"),
					callback = function(state) BMU.createTable({index=7, filterSourceIndex=TELEPORTER_SOURCE_INDEX_GROUP}) end,
				},
				{
					label = BMU.colorizeText(GetString(SI_GAMEPAD_CAMPAIGN_BROWSER_TOOLTIP_FRIENDS), "green"),
					callback = function(state) BMU.createTable({index=7, filterSourceIndex=TELEPORTER_SOURCE_INDEX_FRIEND}) end,
				},
			}
			
		-- add all guilds
		for guildIndex = 1, GetNumGuilds() do
			local guildId = GetGuildId(guildIndex)
			local entry = {
					label = BMU.colorizeText(GetGuildName(guildId), "white"),
					callback = function() BMU.createTable({index=7, filterSourceIndex=2+guildIndex}) end,
				}
				table.insert(entries_filter, entry)
		end		
		
		AddCustomSubMenuItem(GetString(SI_GAMEPAD_BANK_FILTER_HEADER), entries_filter)
		
		ShowMenu()
		
	else -- left mouse click
		if record.groupUnitTag then		
			ZO_WorldMap_SetMapByIndex(1)
			ZO_WorldMap_SetMapByIndex(record.mapIndex)
			CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
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


-- save the new favorite zone
function BMU.addFavoriteZone(position, zoneId, zoneName)
		BMU.savedVarsServ.favoriteListZones[position] = zoneId
		BMU.printToChat(SI.get(SI.TELE_UI_FAVORITE_ZONE) .. " " .. position .. ": " .. zoneName)
		BMU.refreshListAuto()
end

-- save the new favorite player
function BMU.addFavoritePlayer(position, displayName)
		BMU.savedVarsServ.favoriteListPlayers[position] = displayName
		BMU.printToChat(SI.get(SI.TELE_UI_FAVORITE_PLAYER) .. " " .. position .. ": " .. displayName)
		BMU.refreshListAuto()
end

-- remove favorite zone
function BMU.removeFavoriteZone(zoneId)
	-- go over favorite list and remove
	for index, value in pairs(BMU.savedVarsServ.favoriteListZones) do
        if value == zoneId then
			BMU.savedVarsServ.favoriteListZones[index] = nil
        end
    end
	BMU.refreshListAuto()
end

-- remove favorite player
function BMU.removeFavoritePlayer(displayName)
	-- go over favorite list and remove
	for index, value in pairs(BMU.savedVarsServ.favoriteListPlayers) do
        if value == displayName then
			BMU.savedVarsServ.favoriteListPlayers[index] = nil
        end
    end
	BMU.refreshListAuto()
end


function BMU.updateStatistic(category, zoneId)
	-- check for block flag and add manual port cost to statisticGold and also increase total counter
	if not BMU.blockGold then
		-- regard only Overland zones for gold statistics
		if category == TELEPORTER_ZONE_CATEGORY_OVERLAND then
			BMU.savedVarsAcc.savedGold = BMU.savedVarsAcc.savedGold + GetRecallCost()
			self.control.statisticGold:SetText(SI.get(SI.TELE_UI_GOLD) .. " " .. BMU.formatGold(BMU.savedVarsAcc.savedGold))
		end
		-- increase total port counter
		BMU.savedVarsAcc.totalPortCounter = BMU.savedVarsAcc.totalPortCounter + 1
		self.control.statisticTotal:SetText(SI.get(SI.TELE_UI_TOTAL_PORTS) .. " " .. BMU.formatGold(BMU.savedVarsAcc.totalPortCounter))
		-- update port counter per zone statistic
		if BMU.savedVarsAcc.portCounterPerZone[zoneId] == nil then
			BMU.savedVarsAcc.portCounterPerZone[zoneId] = 1
		else
			BMU.savedVarsAcc.portCounterPerZone[zoneId] = BMU.savedVarsAcc.portCounterPerZone[zoneId] + 1
		end
		-- update last used zones list
		table.insert(BMU.savedVarsAcc.lastPortedZones, 1, zoneId)
		if #BMU.savedVarsAcc.lastPortedZones > 20 then
			-- drop oldest element
			table.remove(BMU.savedVarsAcc.lastPortedZones)
		end
	end
	
	-- start cooldown
	BMU.coolDownGold()
end

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


function BMU.formatGold(number)
	if number >= 1000000 then
		return BMU.round((number/1000000), 3) .. " " .. SI.get(SI.TELE_UI_GOLD_ABBR2)
	elseif number >= 1000 then
		return BMU.round((number/1000), 1) .. " " .. SI.get(SI.TELE_UI_GOLD_ABBR)
	else
		return number
	end
end


function BMU.round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end


-- calculate the height of the main control depending on the number of lines
function BMU.calculateListHeight()
	-- 300 => 6 lines, add 46 for each additional line (line_height is only 40)
	return (300 + ((BMU.savedVarsAcc.numberLines - 6) * 46))*BMU.savedVarsAcc.Scale
end


function BMU.createMail(to, subject, body)
	SCENE_MANAGER:Show('mailSend')
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


-- port to group leader OR to the other group member when group contains only 2 player
function BMU.portToGroupLeader()
	local unitTag
	local leaderUnitTag = GetGroupLeaderUnitTag()
	
	if leaderUnitTag == nil or leaderUnitTag == "" then
		-- no group
		BMU.printToChat(SI.get(SI.TELE_CHAT_NOT_IN_GROUP))
		return
	elseif GetGroupSize() == 2 then
		-- group of two -> port to the other player
		 if GetGroupIndexByUnitTag("player") == 1 then
			unitTag = GetGroupUnitTagByIndex(2)
		else
			unitTag = GetGroupUnitTagByIndex(1)
		end
	elseif IsUnitGroupLeader("player") then
		-- group of more than 2 and the current player is the leader himself
		BMU.printToChat(SI.get(SI.TELE_CHAT_GROUP_LEADER_YOURSELF))
		return
	else
		-- group of more than 2 -> port to group leader
		unitTag = leaderUnitTag
	end
	
	local displayName = GetUnitDisplayName(unitTag)
	local zoneName = GetUnitZone(unitTag)
	BMU.PortalToPlayer(displayName, 1, BMU.formatName(zoneName, false), 0, 0, false, false, true)
end


function BMU.portToOwnHouse(primary, houseId, jumpOutside, parentZoneName)
	-- houseId is nil when primary == true
	local zoneId = GetHouseZoneId(houseId)
	
	if primary then
		-- port to primary residence
		houseId = GetHousingPrimaryHouse()
		zoneId = GetHouseZoneId(houseId)
		if zoneId == nil or zoneId == 0 then
			BMU.printToChat(SI.get(SI.TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED))
			return
		end
		-- get parentZoneName
		if jumpOutside then
			parentZoneName = BMU.formatName(GetZoneNameById(BMU.getParentZoneId(zoneId)), false)
		end
	end
	
	-- show additional animation
	if BMU.savedVarsAcc.showTeleportAnimation then
		BMU.showTeleportAnimation()
	end
	
	-- print info to chat
	if jumpOutside then
		BMU.printToChat(GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. parentZoneName .. " (" .. BMU.formatName(GetZoneNameById(zoneId), false) .. ")")
	else
		BMU.printToChat(GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. BMU.formatName(GetZoneNameById(zoneId), false))
	end
	
	-- start port process
	RequestJumpToHouse(houseId, jumpOutside)
	
	-- close UI if enabled
	if BMU.savedVarsAcc.closeOnPorting then
		-- hide world map if open
		SCENE_MANAGER:Hide("worldMap")
		-- hide UI if open
		BMU.HideTeleporter()
	end
end


function BMU.portToBMUGuildHouse()
	if BMU.var.guildHouse[GetWorldName()] == nil then
		BMU.printToChat("There is no BMU guild house on this server.")
		return
	else
		local displayName = BMU.var.guildHouse[GetWorldName()][1]
		local houseId = BMU.var.guildHouse[GetWorldName()][2]
		-- show additional animation
		if BMU.savedVarsAcc.showTeleportAnimation then
			BMU.showTeleportAnimation()
		end
		JumpToSpecificHouse(displayName, houseId)
		BMU.printToChat("Porting to BMU guild house (" .. displayName .. ")")
		if BMU.savedVarsAcc.closeOnPorting then
			-- hide world map if open
			SCENE_MANAGER:Hide("worldMap")
			-- hide UI if open
			BMU.HideTeleporter()
		end
	end
end


function BMU.portToCurrentZone()
	local playersZoneId = GetZoneId(GetUnitZoneIndex("player"))
	BMU.sc_porting(playersZoneId)
end


-- identifies the currently tracked/focused quest and start the port
function BMU.portToTrackedQuestZone()
	for slotIndex = 1, GetNumJournalQuests() do
		local questName, _, _, _, _, _, tracked = GetJournalQuestInfo(slotIndex)
		if tracked then
			local _, _, questZoneIndex = GetJournalQuestLocationInfo(slotIndex)
			local questZoneId = GetZoneId(questZoneIndex)
			if questZoneId ~= 0 then
				-- get exact quest location
				questZoneId = BMU.findExactQuestLocation(slotIndex)
			end
			BMU.printToChat(GetString(SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM) .. ": " .. questName)
			BMU.sc_porting(questZoneId)
			return
		end
	end
end


-- to get to the next wayshrine without preference travel to any available zone/player (first entry from main list)
function BMU.portToAnyZone()
	local resultTable = BMU.createTable({index=0, noOwnHouses=true, dontDisplay=true})
	
	for _, entry in pairs(resultTable) do
		if not entry.zoneWithoutPlayer and entry.displayName ~= nil and entry.displayName ~= "" then
			-- usual entry with player or house
			BMU.PortalToPlayer(entry.displayName, entry.sourceIndexLeading, entry.zoneName, entry.zoneId, entry.category, true, false, true)
			return
		end
	end
	-- no travel option found
	BMU.printToChat(SI.get(SI.TELE_CHAT_NO_FAST_TRAVEL))
end


-- set flag when an error occurred while starting port process
function BMU.socialErrorWhilePorting(eventCode, errorCode)
	if errorCode == nil then errorCode = 0 end
	BMU.flagSocialErrorWhilePorting = errorCode
end


-- makes intelligent decision whether to try to port to another player or not
function BMU.decideTryAgainPorting(errorCode, zoneId, displayName, sourceIndex, updateSavedGold)
	-- don't try to port again when: other errors (e.g. solo zone); player is group member; player is favorite; search by player name
	if (errorCode ~= SOCIAL_RESULT_NO_LOCATION and errorCode ~= SOCIAL_RESULT_CHARACTER_NOT_FOUND) or sourceIndex == TELEPORTER_SOURCE_INDEX_GROUP or BMU.isFavoritePlayer(displayName) or BMU.state == 2 then
		return -- do nothing
	else
		-- try to find another player in the zone
		local result = BMU.createTable({index=6, fZoneId=zoneId, dontDisplay=true})
		for index, record in pairs(result) do
			if record ~= nil then
				if record.displayName ~= "" and record.displayName ~= displayName then -- player name must be different
					BMU.PortalToPlayer(record.displayName, record.sourceIndexLeading, record.zoneName, record.zoneId, record.zoneCategory, updateSavedGold, false, true)
					return
				elseif record.isOwnHouse then
					-- if there is no other player in this zone -> port to own house
					BMU.portToOwnHouse(false, record.houseId, true, record.parentZoneName)
					return
				end
			end
		end
	end
end


-- TOOLTIP (show and hide)
function BMU:tooltipTextEnter(control, text)
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


-- retrieves zone name from zoneId
function BMU.getZoneIdFromZoneName(searchZoneName)
	local libZoneData = BMU.LibZoneGivenZoneData
	local zoneData = libZoneData[string.lower(BMU.lang)] or libZoneData["en"]
	for zoneId, zoneName in pairs(zoneData) do
		if string.lower(zoneName) == string.lower(searchZoneName) then
			return zoneId
		end
	end
end



BMU.ListView = ListView
