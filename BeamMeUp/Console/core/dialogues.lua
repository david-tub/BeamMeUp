local SI = BMU.SI

local function ReleaseDialog(dialogName)
	ZO_Dialogs_ReleaseDialogOnButtonPress(dialogName)
end

local finishedCallback = nil

ZO_Dialogs_RegisterCustomDialog("BMU_GAMEPAD_SOCIAL_OPTIONS_DIALOG",
{
	gamepadInfo = {
		dialogType = GAMEPAD_DIALOGS.PARAMETRIC,
	},
	setup = function(dialog)
		local data = dialog.data
		if data.setupFunction then
			data.setupFunction(dialog)
		end

		dialog.info.parametricList = data.parametricList
		finishedCallback = nil
		dialog:setupFunc()
	end,
	finishedCallback = function(dialog)
		if finishedCallback then
			finishedCallback(dialog)
		end
	end,
	title = {
		text = SI_GAMEPAD_CONTACTS_OPTIONS_TITLE,
	},
	blockDialogReleaseOnPress = true, -- We'll handle Dialog Releases ourselves since we don't want DIALOG_PRIMARY to release the dialog on press.

	canQueue = true,
	buttons = {
		{
			keybind = "DIALOG_PRIMARY",
			text = SI_GAMEPAD_SELECT_OPTION,
			callback =  function(dialog)
				local data = dialog.entryList:GetTargetData()
				if data.callback then
					data.callback(dialog)
				end
				finishedCallback = data.finishedCallback
			--	ReleaseDialog(dialogName)
			end,
		},

		{
			keybind = "DIALOG_NEGATIVE",
			text = SI_DIALOG_CLOSE,
			callback = function()
				ReleaseDialog("BMU_GAMEPAD_SOCIAL_OPTIONS_DIALOG")
			end,
		},
	}
})

local function buildCheckbox(header, label, entryData, finishedCallback, icon)
	local function onFilterToggled(data)
		if entryData.control ~= nil then
			local targetControl = entryData.control
			ZO_GamepadCheckBoxTemplate_OnClicked(targetControl)
			entryData.checked = ZO_CheckButton_IsChecked(targetControl.checkBox)

			BMU.savedVarsServ[entryData.savedVar][entryData.savedVarIndex] = entryData.checked or nil
		end
	end
	
	local function setupFunction(control, data, selected, reselectingDuringRebuild, enabled, active)
		data.callback = onFilterToggled
		ZO_GamepadCheckBoxTemplate_Setup(control, data, selected, reselectingDuringRebuild, enabled, active)
		
		local checked = entryData.checked
		
		if type(checked) == 'function' then
			checked = checked()
		end
		
		if checked then
			ZO_CheckButton_SetChecked(control.checkBox)
		else
			ZO_CheckButton_SetUnchecked(control.checkBox)
		end
		entryData.control = control
	end

	entryData.setup = setupFunction
	local listItem =
	{
		template = "ZO_CheckBoxTemplate_WithPadding_Gamepad",
		entryData = entryData,
		header = header,
	}

	return listItem
end

local function getPlayerName(k, v)
	local name = type(k) ~= 'number' and k or v
	return name
end

local function getZoneName(k, v)
	local zoneId = type(v) == 'number' and v or k
	return GetZoneNameById(zoneId)
end

local function addFavorites(parametricList, categoryName, list, getName)
	for k, v in pairs(list) do
		local name = getName(k, v)

		local entryData = ZO_GamepadEntryData:New(name)
		entryData.savedVar = 'favoriteListPlayers'
		entryData.savedVarIndex = k
		entryData.checked = true

		local listItem = buildCheckbox(categoryName, name, entryData)

		table.insert(parametricList, listItem)
		categoryName = nil
	end
end

ZO_Dialogs_RegisterCustomDialog("BMU_GAMEPAD_MANAGE_FAVORITES_DIALOG",
{
	gamepadInfo = {
		dialogType = GAMEPAD_DIALOGS.PARAMETRIC,
		allowShowOnNextScene = true,
	},
	finishedCallback = function(dialog)
		if finishedCallback then
			finishedCallback(dialog)
		end
	end,
	title = {
		text = SI_GAMEPAD_CONTACTS_OPTIONS_TITLE,
	},
	canQueue = true,
	blockDialogReleaseOnPress = true, -- We'll handle Dialog Releases ourselves since we don't want DIALOG_PRIMARY to release the dialog on press.

	parametricList = {}, -- Generated Dynamically
	setup = function(dialog)
		local parametricList = dialog.info.parametricList
		ZO_ClearNumericallyIndexedTable(parametricList)

		addFavorites(parametricList, GetString(SI_TELE_UI_FAVORITE_PLAYER), BMU.savedVarsServ.favoriteListPlayers, getPlayerName)
		addFavorites(parametricList, GetString(SI_TELE_UI_FAVORITE_ZONE), BMU.savedVarsServ.favoriteListZones, getZoneName)

		if #parametricList == 0 then
			local name = GetString(SI_TELE_UI_NO_MATCHES)

			local entryData = ZO_GamepadEntryData:New(name)
			entryData.setup = ZO_SharedGamepadEntry_OnSetup

			local listItem =
			{
				template = "ZO_GamepadItemEntryTemplate",
				entryData = entryData,
			}
			table.insert(parametricList, listItem)
		end

		dialog:setupFunc()
	end,

	buttons = {
		{
			keybind = "DIALOG_PRIMARY",
			text = SI_GAMEPAD_SELECT_OPTION,
			callback =  function(dialog)
				local data = dialog.entryList:GetTargetData()
				if data.callback then
					data.callback(dialog)
				end
				finishedCallback = data.finishedCallback
			end,
		},

		{
			keybind = "DIALOG_NEGATIVE",
			text = SI_DIALOG_CLOSE,
			callback = function()
				ReleaseDialog("BMU_GAMEPAD_MANAGE_FAVORITES_DIALOG")
			end,
		},
	}
})



ZO_Dialogs_RegisterCustomDialog("BMU_GAMEPAD_MULTIPLE_SELECTIONS_DIALOG",
{
	gamepadInfo = {
		dialogType = GAMEPAD_DIALOGS.PARAMETRIC,
	},
	setup = function(dialog)
		dialog:setupFunc()
	end,
	title = {
		text = SI_GAMEPAD_CONTACTS_OPTIONS_TITLE,
	},
	canQueue = true,
	
	parametricList =
	{
		-- Teleport
		{
			template = "ZO_GamepadTextFieldSubmitItem",
			templateData = {
				text = GetString(SI_GAMEPAD_WORLD_MAP_TRAVEL),
				setup = ZO_SharedGamepadEntry_OnSetup,
				callback = function(dialog)
					ReleaseDialog()
					dialog.data.targetData:TryToPort()
					SCENE_MANAGER:ShowBaseScene()
				end,
			},
		},

		-- Show all in zone
		{
			template = "ZO_GamepadTextFieldSubmitItem",
			templateData = {
				text = GetString(SI_ANTIQUITY_SCRYABLE_CURRENT_ZONE_SUBCATEGORY),
				setup = ZO_SharedGamepadEntry_OnSetup,
				callback = function(dialog)
					ReleaseDialog()
					local categoryList = dialog.data.categoryList
					local index = IsUnitGrouped('player') and 3 or 2
					categoryList:SetSelectedIndex(index, true)
					CALLBACK_MANAGER:FireCallbacks('BMU_GAMEPAD_CATEGORY_CHANGED', categoryList:GetTargetData(), dialog.data.selectedIndex)
				end,
			},
		},
	},
	buttons = {
		{
			keybind = "DIALOG_PRIMARY",
			text = SI_GAMEPAD_SELECT_OPTION,
			callback =  function(dialog)
				local data = dialog.entryList:GetTargetData()
				if data.callback then
					data.callback(dialog)
				end
				ReleaseDialog("BMU_GAMEPAD_MULTIPLE_SELECTIONS_DIALOG")
			end,
		},

		{
			keybind = "DIALOG_NEGATIVE",
			text = SI_DIALOG_CLOSE,
			callback = function(dialog)
				ReleaseDialog("BMU_GAMEPAD_MULTIPLE_SELECTIONS_DIALOG")
			end,
		},
	}
})

local function tryToPort(target, isVet)
	ReleaseDialog("BMU_GAMEPAD_DUNGEON_TELEPORT_DIALOG")
	SetVeteranDifficulty(isVet)
	--target:TryToPort()
	FastTravelToNode(target.nodeIndex)
end


ZO_Dialogs_RegisterCustomDialog("BMU_GAMEPAD_DUNGEON_TELEPORT_DIALOG",
{
	gamepadInfo = {
		dialogType = GAMEPAD_DIALOGS.PARAMETRIC,
	},
	setup = function(dialog)
		dialog:setupFunc()
	end,
	title = {
		text = SI_GAMEPAD_GROUP_DUNGEON_DIFFICULTY,
	},
	canQueue = true,
	
	parametricList =
	{
		{
			template = "ZO_GamepadTextFieldSubmitItem",
			templateData = {
				text = GetString(SI_GAMEPAD_GROUP_DUNGEON_MODE_NORMAL),
				setup = ZO_SharedGamepadEntry_OnSetup,
				callback = function(dialog)
					tryToPort(dialog.data.targetData, false)
				end,
			},
		},
		{
			template = "ZO_GamepadTextFieldSubmitItem",
			templateData = {
				text = GetString(SI_GAMEPAD_GROUP_DUNGEON_MODE_VETERAN),
				setup = ZO_SharedGamepadEntry_OnSetup,
				callback = function(dialog)
					tryToPort(dialog.data.targetData, true)
				end,
			},
		},
	},
	buttons = {
		{
			keybind = "DIALOG_PRIMARY",
			text = SI_GAMEPAD_SELECT_OPTION,
			callback =  function(dialog)
				local data = dialog.entryList:GetTargetData()
				if data.callback then
					data.callback(dialog)
				end
			end,
		},

		{
			keybind = "DIALOG_NEGATIVE",
			text = SI_DIALOG_CLOSE,
			callback = function(dialog)
				ReleaseDialog("BMU_GAMEPAD_DUNGEON_TELEPORT_DIALOG")
			end,
		},
	}
})
ZO_Dialogs_RegisterCustomDialog("BMU_GAMEPAD_AUTO_UNLOCK_DIALOG",
{
	gamepadInfo = {
		dialogType = GAMEPAD_DIALOGS.PARAMETRIC,
	},
	setup = function(dialog)
		dialog:setupFunc()
		local textControl = dialog:GetNamedChild("ContainerScrollChildMainText")
		
		if textControl then
			-- must increase the max line count in order to show the full text
			textControl:SetDimensionConstraints(0, 0, 0, 300)
			textControl:SetMaxLineCount(10)
		end
	end,
	title = {
		text = SI.get(SI.TELE_DIALOG_AUTO_UNLOCK_TITLE),
	},
	mainText = {
		align = TEXT_ALIGN_CENTER, 
		text = SI.get(SI_TELE_DIALOG_AUTO_UNLOCK_BODY)
	},
	
	blockDialogReleaseOnPress = true, -- We'll handle Dialog Releases ourselves since we don't want DIALOG_PRIMARY to release the dialog on press.

	canQueue = true,
	
	parametricList =
	{
		{
			template = "ZO_GamepadTextFieldSubmitItem",
			templateData = {
				text = SI.get(SI.TELE_UI_BTN_UNLOCK_WS),
				setup = ZO_SharedGamepadEntry_OnSetup,
				callback = function(dialog)
					ReleaseDialog("BMU_GAMEPAD_AUTO_UNLOCK_DIALOG")
					IJA_BMU_GAMEPAD_PLUGIN:CheckAndStartAutoUnlockOfZone(dialog.data.zoneId, BMU.savedVarsAcc.autoUnlockChatLogging)
				end,
		--		visible = function(dialog) return dialog.data:HasUndiscoveredWayshrines()  end
			},
		},
		{
			template = "ZO_GamepadTextFieldSubmitItem",
			header = SI.get(SI.TELE_DIALOG_AUTO_UNLOCK_LOOP_OPTION),
			templateData = {
				text = GetString(SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION1),
				setup = ZO_SharedGamepadEntry_OnSetup,
				callback = function(dialog)
					ReleaseDialog("BMU_GAMEPAD_AUTO_UNLOCK_DIALOG")
					IJA_BMU_GAMEPAD_PLUGIN:StartAutoUnlockLoopRandom(nil, 'suffle', BMU.savedVarsAcc.autoUnlockChatLogging)
				end,
			},
		},
		{
			template = "ZO_GamepadTextFieldSubmitItem",
			templateData = {
				text = GetString(SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION2),
				setup = ZO_SharedGamepadEntry_OnSetup,
				callback = function(dialog)
					ReleaseDialog("BMU_GAMEPAD_AUTO_UNLOCK_DIALOG")
					IJA_BMU_GAMEPAD_PLUGIN:StartAutoUnlockLoopSorted(nil, 'wayshrines', BMU.savedVarsAcc.autoUnlockChatLogging)
				end,
			},
		},
		{
			template = "ZO_GamepadTextFieldSubmitItem",
				templateData = {
				text = GetString(SI_TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION3),
				setup = ZO_SharedGamepadEntry_OnSetup,
				callback = function(dialog)
					ReleaseDialog("BMU_GAMEPAD_AUTO_UNLOCK_DIALOG")
					IJA_BMU_GAMEPAD_PLUGIN:StartAutoUnlockLoopSorted(nil, 'players', BMU.savedVarsAcc.autoUnlockChatLogging)
				end,
			},
		},
		{
			template = "ZO_CheckBoxTemplate_WithoutIndent_Gamepad",
			header = '',
			templateData = {
				text = GetString(SI_TELE_DIALOG_AUTO_UNLOCK_CHAT_LOG_OPTION),
				setup = function(control, data, selected, reselectingDuringRebuild, enabled, active)
					ZO_GamepadCheckBoxTemplate_Setup(control, data, selected, reselectingDuringRebuild, enabled, active)
					
					if BMU.savedVarsAcc.autoUnlockChatLogging then
						ZO_CheckButton_SetChecked(control.checkBox)
					else
						ZO_CheckButton_SetUnchecked(control.checkBox)
					end
				end,
				callback = function(dialog)
					local targetControl = dialog.entryList:GetTargetControl()
					ZO_GamepadCheckBoxTemplate_OnClicked(targetControl)
					
					BMU.savedVarsAcc.autoUnlockChatLogging = ZO_CheckButton_IsChecked(targetControl.checkBox)
				end,
				narrationText = function(entryData, entryControl)
					local isChecked = entryData.checked(entryData)
					return ZO_FormatToggleNarrationText(entryData.text, isChecked)
				end,
				checked = function() return BMU.savedVarsAcc.autoUnlockChatLogging end,
			},
		},
	},
	buttons = {
		{
			keybind = "DIALOG_PRIMARY",
			text = SI_GAMEPAD_SELECT_OPTION,
			callback =  function(dialog)
				local data = dialog.entryList:GetTargetData()
				if data.callback then
					data.callback(dialog)
				end
			end,
		},
		{
			keybind = "DIALOG_NEGATIVE",
			text = SI_DIALOG_CLOSE,
			callback = function(dialog)
				ReleaseDialog("BMU_GAMEPAD_AUTO_UNLOCK_DIALOG")
			end,
		},
	}
})
