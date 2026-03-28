local addon = BMU_BMU_GAMEPAD_PLUGIN

local EM = EVENT_MANAGER

local addon = BMU_BMU_GAMEPAD_PLUGIN
local var_AUTOUNLOCK_PROGRESS_NONE = 0
local var_AUTOUNLOCK_PROGRESS_ACTIVE = 1
local var_AUTOUNLOCK_PROGRESS_COMPLETE = 2
local var_AUTOUNLOCK_PROGRESS_FAILED = 3

local setup_function_map = {
	[var_AUTOUNLOCK_PROGRESS_ACTIVE] = function(self)
		local zoneId = GetZoneId(GetUnitZoneIndex("player"))
		numWayshrines, numWayshrinesDiscovered = BMU.getZoneWayshrineCompletion(zoneId)

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
			declineText = GetString(SI_CANCEL),
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
		}
		return entry, GetString(SI_TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_BODY)
	end,
}

local callback_Map = {
	[var_AUTOUNLOCK_PROGRESS_ACTIVE] = function(self)
		addon:AutoUnlockContinue()
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

local AutoUnlockNotificationProvider = ZO_NotificationProvider:Subclass()

function AutoUnlockNotificationProvider:New(notificationManager)
    local provider = ZO_NotificationProvider.New(self, notificationManager)
	local updateName = addon.prefix .. "autoUnlockProgress"

	local function onUpdate()
		if provider.oldProgress ~= provider.progress then
			provider.notificationManager:RefreshNotificationList()
		end
	end

	EM:RegisterForUpdate(updateName, 1000, onUpdate)
    return provider
end

function AutoUnlockNotificationProvider:BuildNotificationList()
    ZO_ClearNumericallyIndexedTable(self.list)
	EM:UnregisterForUpdate(updateName)

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
		ZO_Alert(UI_ALERT_CATEGORY_ALERT, SOUNDS.NONE, alertString)
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
	EM:UnregisterForUpdate(updateName)
	BMU:UnregisterAutoUnlockEvents()
  BMU.finishedAutoUnlock("canceled")
end
addon.provider = AutoUnlockNotificationProvider:New(GAMEPAD_NOTIFICATIONS)
local provider = addon.provider

table.insert(GAMEPAD_NOTIFICATIONS.providers, provider)
GAMEPAD_NOTIFICATIONS:RefreshNotificationList()

function addon:AutoUnlockContinue()
	BMU_proceedAutoUnlock()
end