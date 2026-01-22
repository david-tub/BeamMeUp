local addon = IJA_BMU_GAMEPAD_PLUGIN

local CATEGORY_TYPE_GROUP		= 0
local CATEGORY_TYPE_ALL			= 1
local CATEGORY_TYPE_OTHER		= 2
local CATEGORY_TYPE_QUESTS		= 3
local CATEGORY_TYPE_ITEMS		= 4
local CATEGORY_TYPE_DUNGEON		= 5
local CATEGORY_TYPE_DISPLAYED	= 6
local CATEGORY_TYPE_BMU			= 7
local CATEGORY_TYPE_DELVE		= 8
local CATEGORY_TYPE_PTF			= 9
local CATEGORY_TYPE_TEST		= 10

---------------------------------------------------------------------------------------------------------------
-- Right Side Tooltip
---------------------------------------------------------------------------------------------------------------
local GENERAL_COLOR_WHITE = GAMEPAD_TOOLTIP_COLOR_GENERAL_COLOR_1
local TOOLTIP_STYLES = ZO_TOOLTIP_STYLES
TOOLTIP_STYLES.bmuGPplugInHeader = {
		fontFace = "$(GAMEPAD_MEDIUM_FONT)",
		fontSize = "$(GP_27)",
		uppercase = true,
		fontColorField = GENERAL_COLOR_WHITE,
		horizontalAlignment = TEXT_ALIGN_CENTER,
		widthPercent = 100,
}
TOOLTIP_STYLES.bmuGPplugInTitle = {
		fontSize = "$(GP_42)",
		horizontalAlignment = TEXT_ALIGN_CENTER,

}
TOOLTIP_STYLES.bmuGPplugInBodyDescription = {
		fontSize = "$(GP_34)",
		horizontalAlignment = TEXT_ALIGN_CENTER,

}
TOOLTIP_STYLES.bmuGPplugInBodySection = {
		childSpacing = 2,
		widthPercent = 100,
}

--[[
ZO_TOOLTIP_STYLES.bmuGPplugInHeader = {
		fontFace = "$(GAMEPAD_MEDIUM_FONT)",
		fontSize = "$(GP_27)",
		uppercase = true,
		fontColorField = GENERAL_COLOR_WHITE,
		horizontalAlignment = TEXT_ALIGN_CENTER,
		widthPercent = 100,
}
ZO_TOOLTIP_STYLES.bmuGPplugInTitle = {
		fontSize = "$(GP_42)",
		horizontalAlignment = TEXT_ALIGN_CENTER,

}
ZO_TOOLTIP_STYLES.bmuGPplugInBodyDescription = {
		fontSize = "$(GP_34)",
		horizontalAlignment = TEXT_ALIGN_CENTER,

}
ZO_TOOLTIP_STYLES.bmuGPplugInBodySection = {
		childSpacing = 2,
		widthPercent = 100,

}
]]

local tooltip_mixin = {}
function tooltip_mixin:LayoutTitleAndMultiSectionDescriptionTooltip(title, ...)
	--Title
	if title then
		local headerSection = self.tooltip:AcquireSection(self.tooltip:GetStyle("bmuGPplugInHeader"))
		headerSection:AddLine(title, self.tooltip:GetStyle("bmuGPplugInTitle"))
		self.tooltip:AddSection(headerSection)
	end

	--Body
	for i = 1, select("#", ...) do
		local bodySection = self.tooltip:AcquireSection(self.tooltip:GetStyle("bmuGPplugInBodySection"))
		bodySection:AddLine(select(i, ...), self.tooltip:GetStyle("bmuGPplugInBodyDescription"))
		self.tooltip:AddSection(bodySection)
	end
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------
local function GetStringFromData(data)
	local dataType = type(data)
	if dataType == "function" then
		return data()
	elseif dataType == "number" then
		return GetString(data)
	else
		return data
	end
end

local function highlightText(label)
	return '|cFFFFFF' .. label-- .. 'r|'
end

local function addTooltipData(tooltipData, data)
	if data then
		if #tooltipData > 0 then
			-- add separator
			table.insert(tooltipData, BMU.textures.tooltipSeperator)
		end
		if type(data) == 'table' then
			for k, entry in pairs(data) do
				table.insert(tooltipData, entry)
			end
		else
			table.insert(tooltipData, data)
		end
	else
		table.insert(tooltipData, BMU.textures.tooltipSeperator)
	end
end

local function getTargetTooltipData(targetData)
	local tooltipData = {}
	local tooltipTextLevel = ""

	-- Second language for zone names
	-- if second language is selected & entry is a real zone & zoneNameSecondLanguage exists
	if BMU.savedVarsAcc.secondLanguage ~= 1 and targetData.zoneNameClickable == true and targetData.zoneNameSecondLanguage ~= nil then
		-- add zone name
		addTooltipData(tooltipData, targetData.zoneNameSecondLanguage)
	end
	------------------


	-- wayhsrine and skyshard discovery info
	if targetData.zoneNameClickable == true and (targetData.zoneWayhsrineDiscoveryInfo ~= nil or targetData.zoneSkyshardDiscoveryInfo ~= nil) then
		if #tooltipData > 0 then
			-- add separator
	--		table.insert(tooltipData, 1, BMU.textures.tooltipSeperator)
		end
		
		local discoveryInfo = {}
		-- add discovery info
		if targetData.zoneWayhsrineDiscoveryInfo ~= nil then
			table.insert(discoveryInfo, targetData.zoneWayhsrineDiscoveryInfo)
		end
		if targetData.zoneSkyshardDiscoveryInfo ~= nil then
			table.insert(discoveryInfo, targetData.zoneSkyshardDiscoveryInfo)
		end
		
		addTooltipData(tooltipData, discoveryInfo)
	end
	------------------
	
	
	--------- zone tooltip (and zone name)  and handler for map opening ---------
	-- if search for related items and info not already added
	if targetData.relatedItems ~= nil and #targetData.relatedItems > 0 then
		if string.sub(targetData.zoneName, -1) ~= ")" then
			-- add info about total number of related items
			local totalItemsCountInv = 0
			local totalItemsCountBank = 0
			for index, item in pairs(targetData.relatedItems) do
				if item.isInInventory then
					totalItemsCountInv = totalItemsCountInv + item.itemCount
				else
					totalItemsCountBank = totalItemsCountBank + item.itemCount
				end
			end
			if totalItemsCountInv > 0 then
				targetData.zoneName = targetData.zoneName .. " (" .. totalItemsCountInv .. ")"
			end
			if totalItemsCountBank > 0 then
				targetData.zoneName = targetData.zoneName .. BMU.var.color.colTrash .. " (" .. totalItemsCountBank .. ")"
			end
		end

		-- copy item names to tooltipData
		local relatedItems = {}
		for index, item in ipairs(targetData.relatedItems) do
			table.insert(relatedItems, item.itemTooltip)
		end

		addTooltipData(tooltipData, relatedItems)

	-- if search for related quests
	elseif targetData.relatedQuests ~= nil and #targetData.relatedQuests > 0 then
		if string.sub(targetData.zoneName, -1) ~= ")" then
			-- add info about number of related quests
			targetData.zoneName = targetData.zoneName .. " (" .. targetData.countRelatedQuests .. ")"
		end
		-- copy "targetData.relatedQuests" to "tooltipData" (Attention: "=" will set pointer!)
	--	ZO_DeepTableCopy(targetData.relatedQuests, tooltipData)
		local relatedQuests = {}
		for index, quest in ipairs(targetData.relatedQuests) do
			table.insert(relatedQuests, quest)
		end
		
		addTooltipData(tooltipData, relatedQuests)
	end

	--------- player tooltip ---------
	if targetData.displayName ~= "" and targetData.championRank then
		-- set level text for player tooltip
		if targetData.championRank >= 1 then
			tooltipTextLevel = "CP " .. targetData.championRank
		else
			tooltipTextLevel = targetData.level
		end
		local playerInfo = {highlightText(targetData.displayName), targetData.characterName, tooltipTextLevel, targetData.allianceName}

		addTooltipData(tooltipData, playerInfo)
		addTooltipData(tooltipData, targetData.sourcesText)
	end
	------------------


	-- GetString(SI_TELE_UI_GOLD) .. " " .. BMU.formatGold(BMU.savedVarsAcc.savedGold)
	-- Info if player is in same instance
	if targetData.groupMemberSameInstance ~= nil then
		-- add instance info
		if targetData.groupMemberSameInstance == true then
			addTooltipData(tooltipData, BMU.var.color.colGreen .. GetString(SI_TELE_UI_SAME_INSTANCE))
		else
			addTooltipData(tooltipData, BMU.var.color.colRed .. GetString(SI_TELE_UI_DIFFERENT_INSTANCE))
		end
	end
	------------------

	-- house tooltip
	if targetData.houseTooltip then
		-- add house infos
		--ZO_DeepTableCopy(targetData.houseTooltip, tooltipData)
		local hasZoneName = false
		local houseData = {}
		for _, v in pairs(targetData.houseTooltip) do
			if v == targetData.parentZoneName then
				v = highlightText(targetData.parentZoneName)
				hasZoneName = true
			end
			v = v:gsub('%|t75%:75', '|t128:128')
			table.insert(houseData, v)
		end
		if not hasZoneName then
			table.insert(houseData, highlightText(targetData.parentZoneName))
		end
		
		addTooltipData(tooltipData, houseData)
	end

	-- guild tooltip
	if targetData.guildTooltip then
		ZO_DeepTableCopy(tooltipData, targetData.guildTooltip)
	end

	return tooltipData
end

local function releaseDialogueCallback()
	ZO_Dialogs_ReleaseAllDialogsOfName("BMU_GAMEPAD_SOCIAL_OPTIONS_DIALOG")
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------
local TeleportClass_Shared = ZO_Object.MultiSubclass(ZO_GamepadVerticalParametricScrollList, ZO_SocialOptionsDialogGamepad)

function TeleportClass_Shared:New(...)
	return ZO_GamepadVerticalParametricScrollList.New(self, ...)
end

function TeleportClass_Shared:Initialize(control)
	local listControl = control:GetNamedChild('Main'):GetNamedChild('List')
--	self.list = listControl
	self.socialData = {}
	
	-- Initialize self as the list.
	ZO_GamepadVerticalParametricScrollList.Initialize(self, listControl)
	ZO_SocialOptionsDialogGamepad.Initialize(self)
	
	-- Initialize the right side tooltip.
	self.scrollTooltip = control:GetNamedChild("SideContent"):GetNamedChild("Tooltip")
--	ZO_ScrollTooltip_Gamepad:Initialize(self.scrollTooltip, ZO_TOOLTIP_STYLES, "worldMapTooltip")
	ZO_ScrollTooltip_Gamepad:Initialize(self.scrollTooltip, TOOLTIP_STYLES, "worldMapTooltip")
	zo_mixin(self.scrollTooltip, ZO_MapInformationTooltip_Gamepad_Mixin, tooltip_mixin)

	ZO_Scroll_Gamepad_SetScrollIndicatorSide(self.scrollTooltip.scrollIndicator, ZO_SharedGamepadNavQuadrant_4_Background, LEFT)

	self:InitializeKeybindDescriptor()

	self.noItemsLabel:SetText(GetString(SI_TELE_UI_NO_MATCHES))

	self:SetOnSelectedDataChangedCallback(function(_, selectedData, oldData, reselectingDuringRebuild, listIndex)
		self:OnSelectedDataChangedCallback(selectedData, oldData, reselectingDuringRebuild, listIndex)
	end)

--	self.targetSelectedIndex = 1
	self:SetOnTargetDataChangedCallback(function(_, newTargetData, oldTargetData)
		if ZO_IsTableEmpty(newTargetData) then
			self:SetupOptions(nil)
		else
			self:SetupOptions(newTargetData)
		end
	end)
	
--	self.fragment = ZO_SimpleSceneFragment:New(control)
	self.fragment = ZO_Object.MultiSubclass(ZO_SimpleSceneFragment:New(control), self)
	
    local function equalityFunction(left, right)
        return left.text == right.text
    end
	
	local function setupFunction(control, data, selected, reselectingDuringRebuild, enabled, active)
		ZO_SharedGamepadEntry_OnSetup(control, data, selected, reselectingDuringRebuild, enabled, active)
		control.m_data = data
	end
	
	self:AddDataTemplate("ZO_GamepadMenuEntryTemplateLowercase42", setupFunction, ZO_GamepadMenuEntryTemplateParametricListFunction, equalityFunction)
	self:AddDataTemplateWithHeader("ZO_GamepadMenuEntryTemplateLowercase42", setupFunction, ZO_GamepadMenuEntryTemplateParametricListFunction, equalityFunction, "ZO_GamepadMenuEntryHeaderTemplate")

--	self:BuildOptionsList()

	local narrationInfo = 
	{
		canNarrate = function()
			return self.fragment:IsShowing()
		end,
		headerNarrationFunction = function()
			return GAMEPAD_WORLD_MAP_INFO:GetHeaderNarration()
		end,
	}
	SCREEN_NARRATION_MANAGER:RegisterParametricList(self, narrationInfo)
end

function TeleportClass_Shared:PerformFullRefresh()
	if self.fragment:IsHidden() then return end

	self:Clear()
	self:Refresh()
	self:Commit()
	self:RefreshNoEntriesLabel()

	local targetData = self:GetTargetData()
	if not targetData then
		self:SetSelectedIndexWithoutAnimation(1)
	end

	self:RefreshKeybind()
end

function TeleportClass_Shared:PerformUpdate()
	self.dirty = false
end

function TeleportClass_Shared:RefreshKeybind()
	if self.fragment:IsHidden() then return end
	KEYBIND_STRIP:UpdateKeybindButtonGroup(self.keybindStripDescriptor)
end

function TeleportClass_Shared:UpdateTooltip(targetData)
	if not targetData then
		self:RefreshKeybind()
		return
	end
	if self.control:IsHidden() then return end

	local tooltipControl = self.scrollTooltip
	tooltipControl:ClearLines()

	local tooltipData = {}
	if targetData.zoneName then
		tooltipData = getTargetTooltipData(targetData)
	elseif targetData.tooltipData then
		tooltipData = ZO_ShallowTableCopy(targetData.tooltipData)
	end

	if #tooltipData > 0 then -- add separator
		table.insert(tooltipData, 1, BMU.textures.tooltipSeperator)
	end
	if targetData.setCollectionProgress then
		table.insert(tooltipData, 1, targetData.setCollectionProgress)
		table.insert(tooltipData, 1, BMU.textures.tooltipSeperator)
	end
	
	if targetData.collectibleId then
		if #tooltipData > 0 then -- add separator
			table.insert(tooltipData, BMU.textures.tooltipSeperator)
		end
		local collectibleDescription = select(2, GetCollectibleInfo(targetData.collectibleId))
		table.insert(tooltipData, collectibleDescription)
	end
	
	if targetData.pinDesc and targetData.pinDesc ~= '' then
		if #tooltipData > 0 then -- add separator
			table.insert(tooltipData, BMU.textures.tooltipSeperator)
		end
		table.insert(tooltipData, targetData.pinDesc)
	end
	
	if targetData.mapId then
		local description = select(5, GetMapInfoById(targetData.mapId))
		
	--	local parentZoneId = GetZoneId(GetCurrentMapZoneIndex())
		local parentZoneId = targetData.parentZoneId
		local zoneName = GetZoneNameById(parentZoneId)
		
		if description == '' then
			-- If the parent zone is a subzone then let's get the subzone's parent
			parentZoneId = GetParentZoneId(parentZoneId)
			zoneName = GetZoneNameById(parentZoneId)
			description = select(5, GetMapInfoById(GetMapIdByZoneId(parentZoneId)))
		end
		
		if description ~= '' then
			if #tooltipData > 0 then -- add separator
				table.insert(tooltipData, BMU.textures.tooltipSeperator)
			end
			
			if targetData.zoneId ~= targetData.parentZoneId then
				table.insert(tooltipData, highlightText(zoneName))
			end
			
			table.insert(tooltipData, description)
		end
	end
	
	if #tooltipData == 0 then -- category info
		if targetData.categoryType then -- category info
			table.insert(tooltipData, 1, BMU.textures.tooltipSeperator)
			
			local teleportPlayers = self.owner.portalPlayers
			local addedEntries = {}
			for i, entry in ipairs(teleportPlayers) do
				local name = entry:GetLabels()
				if not addedEntries[name] then
					addedEntries[name] = true
					table.insert(tooltipData, name)
				end
			end
		end
	end
	
	
	tooltipControl:LayoutTitleAndMultiSectionDescriptionTooltip(targetData.text, unpack(tooltipData))
	self:RefreshKeybind()
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------
function TeleportClass_Shared:RefreshNoEntriesLabel()
	self.noItemsLabel:SetHidden(not self:IsEmpty())
end

function TeleportClass_Shared:ShowOptionsDialog()
	self.filterControls = {}
	local parametricList = {}
	self:PopulateOptionsList(parametricList)
	local data = self:GetDialogData()
	--Saving the displayName and online state of the person the dialog is being opened for.
	--	self.dialogData.displayName = self.socialData.displayName
	--	self.dialogData.online = self.socialData.online
	ZO_Dialogs_ShowGamepadDialog("BMU_GAMEPAD_SOCIAL_OPTIONS_DIALOG", data)
end

-- Custom build functions for ZO_SocialOptionsDialogGamepad
function TeleportClass_Shared:BuildCheckboxEntry(header, label, setupFunction, callback, setChecked, finishedCallback, icon)
	local entry =
	{
		template = "ZO_CheckBoxTemplate_WithPadding_Gamepad",
		header = header or self.currentGroupingHeader,
		templateData =
		{
			text = GetStringFromData(label),
			setup = setupFunction,
			callback = callback,
			setChecked = setChecked,
			finishedCallback = finishedCallback,
		},
		icon = icon,
	}
	return entry
end

function TeleportClass_Shared:BuildCheckbox(header, label, currentFilter, finishedCallback, icon)
	if type(currentFilter) == 'function' then
		currentFilter = currentFilter()
	end

	local header = self.currentGroupHeader
	local label = currentFilter.filterName

	local function onFilterToggled()
		if currentFilter.control ~= nil then
			local targetControl = currentFilter.control
			ZO_GamepadCheckBoxTemplate_OnClicked(targetControl)
			currentFilter.checked = ZO_CheckButton_IsChecked(targetControl.checkBox)

			if currentFilter.callback then
				currentFilter:callback()
			end
		end
	end

	local function onFilterSelected()
		if not self.dialogData.ignoreTooltips then
			GAMEPAD_TOOLTIPS:LayoutTitleAndDescriptionTooltip(GAMEPAD_LEFT_TOOLTIP, GetStringFromData(currentFilter.filterName), GetStringFromData(currentFilter.filterTooltip))
		end
	end

	local function filterCheckboxEntrySetup(control, data, selected, reselectingDuringRebuild, enabled, active)
		data.callback = onFilterToggled
		data.onSelected = onFilterSelected
		ZO_GamepadCheckBoxTemplate_Setup(control, data, selected, reselectingDuringRebuild, enabled, active)

		local checked = currentFilter.checked
		if type(checked) == 'function' then
			checked = checked()
		end
		
		if checked then
			ZO_CheckButton_SetChecked(control.checkBox)
		else
			ZO_CheckButton_SetUnchecked(control.checkBox)
		end
		currentFilter.control = control

	end

	return self:BuildCheckboxEntry(header, label, filterCheckboxEntrySetup, Callback, setChecked)
end

function TeleportClass_Shared:BuildDropdownEntry(header, label, setupFunction, callback, finishedCallback, icon)
	local entry = {
		header = header or self.currentGroupingHeader,
		template = "ZO_GamepadDropdownItem",

		templateData =
		{
			text = GetStringFromData(label),
			setup = setupFunction,
			callback = callback,
			finishedCallback = finishedCallback,
			narrationText = ZO_GetDefaultParametricListDropdownNarrationText,
		},
		icon = icon,
	}

	return entry
end

function TeleportClass_Shared:BuildDropdown(header, label, dropdownData, icon)

	local function onSelectedCallback(dropdown, entryText, entry)
		dropdownData.selectedIndex = entry.index

		if dropdownData.callback then
			dropdownData.callback(entry)
		end
	end

	local function callback(dialog)
		local targetData = dialog.entryList:GetTargetData()
		local targetControl = dialog.entryList:GetTargetControl()
		targetControl.dropdown:Activate()
	end

	local function dropdownEntrySetup(control, data, selected, reselectingDuringRebuild, enabled, active)
		local dialogData = data and data.dialog and data.dialog.data

		local dropdowns = data.dialog.dropdowns
		if not dropdowns then
			dropdowns = {}
			data.dialog.dropdowns = dropdowns
		end
		local dropdown = control.dropdown
		table.insert(dropdowns, dropdown)

		dropdown:SetNormalColor(ZO_GAMEPAD_COMPONENT_COLORS.UNSELECTED_INACTIVE:UnpackRGB())
		dropdown:SetHighlightedColor(ZO_GAMEPAD_COMPONENT_COLORS.SELECTED_ACTIVE:UnpackRGB())
		dropdown:SetSelectedItemTextColor(selected)

		SCREEN_NARRATION_MANAGER:RegisterDialogDropdown(data.dialog, dropdown)

		dropdown:SetSortsItems(false)
		dropdown:ClearItems()

		for i = 1, #dropdownData do
			local entryText = dropdownData[i].filterName
			local newEntry = dropdown:CreateItemEntry(entryText, onSelectedCallback)
			newEntry.index = i
			zo_mixin(newEntry, dropdownData[i])
			dropdown:AddItem(newEntry)
		end

		dropdown:UpdateItems()

		local initialIndex = dropdownData.selectedIndex or 1
		dropdown:SelectItemByIndex(initialIndex)
	end

	return self:BuildDropdownEntry(header, label, dropdownEntrySetup, callback, icon)
end
	
function TeleportClass_Shared:BuildMultiSelectDropdownEntry(header, label, setupFunction, callback, finishedCallback, icon, enabledFunction)
    local function OnReleaseDialog(dialog)
        if dialog.dropdowns then
            for _, dropdown in ipairs(dialog.dropdowns) do
                dropdown:Deactivate()
            end
        end
        dialog.dropdowns = nil
    end
	
	local entry = {
		header = header or self.currentGroupingHeader,
		template = "ZO_GamepadMultiSelectionDropdownItem",

		templateData =
		{
			text = GetStringFromData(label),
			setup = setupFunction,
			callback = callback,
			finishedCallback = finishedCallback,
			narrationText = ZO_GetDefaultParametricListDropdownNarrationText,
			visible = enabledFunction,
			enabled = enabledFunction,
		},
		icon = icon,
	}

	return entry
end

function TeleportClass_Shared:BuildMultiSelectDropdown(header, label, dropdownTable, icon, enabledFunction)

	local function onSelectedCallback(dropdown, entryText, entry)
		dialogData.selectedIndex = entry.index

		if dialogData.callback then
			dialogData.callback(entry)
		end
	end

	local function callback(dialog)
		local targetData = dialog.entryList:GetTargetData()
		local targetControl = dialog.entryList:GetTargetControl()
		targetControl.dropdown:Activate()
	end
	
	local function dropdownEntrySetup(control, data, selected, reselectingDuringRebuild, enabled, active)
		local dialog = data.dialog
		local dialogData = dialog and dialog.data
		
		local dropdown = control.dropdown
		
		local dropdowns = data.dialog.dropdowns
		if not dropdowns then
			dropdowns = {}
			data.dialog.dropdowns = dropdowns
		end
		table.insert(dialog.dropdowns, dropdown)


		dropdown:SetNormalColor(ZO_GAMEPAD_COMPONENT_COLORS.UNSELECTED_INACTIVE:UnpackRGB())
		dropdown:SetHighlightedColor(ZO_GAMEPAD_COMPONENT_COLORS.SELECTED_ACTIVE:UnpackRGB())
		dropdown:SetSelectedItemTextColor(selected)

		dropdown:SetSortsItems(false)
		dropdown:SetNoSelectionText(GetString(SI_ITEMTYPE0))
		dropdown:SetMultiSelectionTextFormatter(GetString(SI_GAMEPAD_BANK_FILTER_DROPDOWN_TEXT))

		SCREEN_NARRATION_MANAGER:RegisterDialogDropdown(data.dialog, dropdown)

		local dropdownData = ZO_MultiSelection_ComboBox_Data_Gamepad:New()
		dropdownData:Clear()
		
		local enabled = enabledFunction
		if type(enabled) == 'function' then
			enabled = enabled()
		end

		for k, filterData in ipairs(dropdownTable) do
			local checked = filterData.checked
			local newEntry = dropdown:CreateItemEntry(filterData.filterName, nil, enabled)
			newEntry.callback = function(control, name, item, isSelected)
				if filterData.callback then
					filterData.callback(isSelected)
				end
			end

			if type(checked) == 'function' then
				checked = checked()
			end
			
			if checked then
				dropdownData:ToggleItemSelected(newEntry)
			end
			dropdownData:AddItem(newEntry)
		end
		dropdown:LoadData(dropdownData)
	end

	return self:BuildMultiSelectDropdownEntry(header, label, dropdownEntrySetup, callback, icon, enabledFunction)
end

-- Custom build functions for ZO_GamepadTextFieldSubmitItem
function TeleportClass_Shared:BuildTextFieldSubmitItem(header, label, callback, icon)
	local entry =
	{
		template = "IJA_BMU_GamepadTextFieldSubmitItem",
		header = header or self.currentGroupingHeader,
		templateData = {
			text = label,
			setup = ZO_SharedGamepadEntry_OnSetup,
			callback = callback,
		},
		icon = icon,
	}
	return entry
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------
-- Custom build functions for ZO_SocialOptionsDialogGamepad
function TeleportClass_Shared:BuildPlayerOptionsList()
	local function ShouldAddPlayerOption()
		return self:ShouldAddPlayerOption()
	end

	local function BuildIgnoreOption()
		local callback = function()
			ZO_Dialogs_ReleaseAllDialogsOfName("BMU_GAMEPAD_SOCIAL_OPTIONS_DIALOG")
			ZO_Dialogs_ShowGamepadDialog("CONFIRM_IGNORE_FRIEND", self.socialData, {mainTextParams={ ZO_FormatUserFacingDisplayName(self.socialData.displayName) }})
		end
		return self:BuildOptionEntry(nil, SI_FRIEND_MENU_IGNORE, callback)
	end

	local function BuildAddFriendOption()
		local callback = function()
			ZO_Dialogs_ReleaseAllDialogsOfName("BMU_GAMEPAD_SOCIAL_OPTIONS_DIALOG")
			ZO_Dialogs_ShowGamepadDialog("GAMEPAD_SOCIAL_ADD_FRIEND_DIALOG", { displayName = self.socialData.displayName, })
		end
		return self:BuildOptionEntry(nil, SI_SOCIAL_MENU_ADD_FRIEND, callback)
	end

	local groupId = self:AddOptionTemplateGroup(function() return self.socialData.displayName end)

	local function ShouldAddInviteToGroupOptionAndCanSelectedDataBeInvited()
		return self:ShouldAddInviteToGroupOption() and (self:SelectedDataIsLoggedIn() and not IsPlayerInGroup(self.socialData.displayName))
	end

	self:AddOptionTemplate(groupId, self.BuildWhisperOption, ShouldAddPlayerOption)
	self:AddOptionTemplate(groupId, ZO_SocialOptionsDialogGamepad.BuildInviteToGroupOption, ShouldAddInviteToGroupOptionAndCanSelectedDataBeInvited)
	self:AddOptionTemplate(groupId, ZO_SocialOptionsDialogGamepad.BuildVisitPlayerHouseOption, ShouldAddPlayerOption)

	self:AddOptionTemplate(groupId, BuildAddFriendOption, ShouldAddPlayerOption)
	self:AddOptionTemplate(groupId, self.BuildSendMailOption, ShouldAddPlayerOption)

	self:AddOptionTemplate(groupId, BuildIgnoreOption, ShouldAddPlayerOption)

	self:AddInviteToGuildOptionTemplates()
end

function TeleportClass_Shared:BuildGroupOptionsList(groupId)
	if not IsUnitGrouped("player") then return end

	local groupId = self:AddOptionTemplateGroup(function() return GetString(SI_INSTANCEDISPLAYTYPE5) end)

	local function CanKickMember()
		return IsGroupModificationAvailable() and not DoesGroupModificationRequireVote() and IsUnitGroupLeader("player") and not self:SelectedDataIsPlayer()
	end

	local function CanVoteForKickMember()
		return IsGroupModificationAvailable() and DoesGroupModificationRequireVote() and not self:SelectedDataIsPlayer()
	end

	local function ShouldAddPromoteOption()
		return IsUnitGroupLeader("player") and self.socialData.online and not self:SelectedDataIsPlayer()
	end
	self:AddOptionTemplate(groupId, self.BuildPromoteToLeaderOption, ShouldAddPromoteOption)
	self:AddOptionTemplate(groupId, self.BuildKickMemberOption, CanKickMember)
	self:AddOptionTemplate(groupId, self.BuildVoteKickMemberOption, CanVoteForKickMember)

	local function BuilLeaveGroupOption()
		local callback = function()
			ZO_Dialogs_ReleaseAllDialogsOfName("BMU_GAMEPAD_SOCIAL_OPTIONS_DIALOG")
			ZO_Dialogs_ShowGamepadDialog("GROUP_LEAVE_DIALOG")
		end
		return self:BuildOptionEntry(nil, SI_GROUP_LIST_MENU_LEAVE_GROUP, callback)
	end

	self:AddOptionTemplate(groupId, BuilLeaveGroupOption, ZO_SocialOptionsDialogGamepad.ShouldAddSendMailOption)
end

function TeleportClass_Shared:BuildPromoteToLeaderOption()
	local callback = function()
		GroupPromote(self.socialData.unitTag)
	end
	return self:BuildOptionEntry(nil, SI_GROUP_LIST_MENU_PROMOTE_TO_LEADER, callback)
end

function TeleportClass_Shared:BuildKickMemberOption()
	local callback = function()
		ZO_Dialogs_ReleaseAllDialogsOfName("BMU_GAMEPAD_SOCIAL_OPTIONS_DIALOG")
		GroupKick(self.socialData.unitTag)
	end
	return self:BuildOptionEntry(nil, SI_GROUP_LIST_MENU_KICK_FROM_GROUP, callback)
end

function TeleportClass_Shared:BuildVoteKickMemberOption()
	local callback = function()
		ZO_Dialogs_ReleaseAllDialogsOfName("BMU_GAMEPAD_SOCIAL_OPTIONS_DIALOG")
		BeginGroupElection(GROUP_ELECTION_TYPE_KICK_MEMBER, ZO_GROUP_ELECTION_DESCRIPTORS.NONE, self.socialData.unitTag)
	end
	return self:BuildOptionEntry(nil, SI_GROUP_LIST_MENU_VOTE_KICK_FROM_GROUP, callback)
end

function TeleportClass_Shared:ShouldAddPlayerOption()
	return (self.socialData.displayName ~= nil and self.socialData.displayName ~= '' and self.socialData.displayName:find(GetDisplayName()) == nil) or false
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------
function TeleportClass_Shared:BuildMainCategroyOptions(groupId)
	local function callback(data)
		self:SetCategoryFilter(2, data.filterName, data.filterIndex, data.filterSourceIndex, data.controlIndex)
		self:Refresh()
	end

	local function conditionFunction()
		local categoryData = self:GetTargetData()
		if not categoryData then return false end
		return categoryData.categoryType == CATEGORY_TYPE_ALL
	end

	if self.dropdownDataMain == nil then
		local dropdownData = {callback = callback}
		table.insert(dropdownData, { -- All
			filterName = GetString(SI_GUILD_HISTORY_SUBCATEGORY_ALL),
			filterIndex = 0,
		})

		table.insert(dropdownData, { -- Group
			filterName = BMU.var.color.colOrange .. GetString(SI_TELE_UI_FILTER_GROUP),
			filterIndex = 7,
			filterSourceIndex = TELEPORTER_SOURCE_INDEX_GROUP,
		})

		table.insert(dropdownData, { -- Friends
			filterName = BMU.var.color.colGreen .. GetString(SI_TELE_UI_FILTER_FRIENDS),
			filterIndex = 7,
			filterSourceIndex = TELEPORTER_SOURCE_INDEX_FRIEND,
		})

		for guildIndex = 1, GetNumGuilds() do -- Guilds
			local guildId = GetGuildId(guildIndex)

			table.insert(dropdownData, {
				filterName = BMU.var.color.colWhite .. GetGuildName(guildId),
				filterIndex = 7,
				filterSourceIndex = TELEPORTER_SOURCE_INDEX_FRIEND + guildIndex,
			})
		end

		self.dropdownDataMain = dropdownData
	end

	self:AddOptionTemplate(groupId, function() return self:BuildDropdown(SI_GAMEPAD_CRAFTING_OPTIONS_FILTERS, label, self.dropdownDataMain, icon) end, conditionFunction)
end

function TeleportClass_Shared:BuildItemsCategoryOptions(groupId)
	local function conditionFunction()
		local categoryData = self:GetTargetData()
		if not categoryData then return false end
		return categoryData.categoryType == CATEGORY_TYPE_ITEMS
	end

	local surveyReports = {
		'displaySurveyMapsAlchemist', 'displaySurveyMapsEnchanter', 'displaySurveyMapsWoodworker',
		'displaySurveyMapsBlacksmith', 'displaySurveyMapsClothier', 'displaySurveyMapsJewelry'
	}


	local function areSurveysActive()
		for k, index in pairs(surveyReports) do
			if not getTeleporterSetting(index) then
				return false
			end
		end
		return true
	end

	local filterData = {
		{
			filterName = GetString(SI_TELE_UI_TOGGLE_SURVEY_MAP),
			callback = function(data)
				for k, index in pairs(surveyReports) do
					self:ToggleBUISetting(index, data.checked)
				end
			end,
			checked = function() return areSurveysActive() end,
		},
		{
			filterName = GetString(SI_TELE_UI_TOGGLE_TREASURE_MAP),
			callback = function(data)
				self:ToggleBUISetting('displayTreasureMaps', data.checked)
			end,
			checked = function() return getTeleporterSetting('displayTreasureMaps') end,
		},
		{
			filterName = GetString(SI_TELE_UI_TOGGLE_LEADS_MAP),
			callback = function(data)
				self:ToggleBUISetting('displayLeads', data.checked)
			end,
			checked = function() return getTeleporterSetting('displayLeads') end,
		},
		{
			filterName = GetString(SI_TELE_UI_TOGGLE_INCLUDE_BANK_MAP),
			callback = function(data)
				self:ToggleBUISetting('scanBankForMaps', data.checked)
			end,
			checked = function() return getTeleporterSetting('scanBankForMaps') end,
		},
	}

	for filterIndex, currentFilter in ipairs(filterData) do
		self:AddOptionTemplate(groupId, function() return self:BuildCheckbox(SI_GAMEPAD_CRAFTING_OPTIONS_FILTERS, label, currentFilter, icon) end, conditionFunction)
	end

	local filterData = {
		{
			filterName = GetString(SI_ITEMTYPEDISPLAYCATEGORY14),
			callback = function(data)
				self:ToggleBUISetting('displaySurveyMapsAlchemist', data.checked)
			end,
			checked = function() return getTeleporterSetting('displaySurveyMapsAlchemist') end,
		},
		{
			filterName = GetString(SI_ITEMTYPEDISPLAYCATEGORY15),
			callback = function(data)
				self:ToggleBUISetting('displaySurveyMapsEnchanter', data.checked)
			end,
			checked = function() return getTeleporterSetting('displaySurveyMapsEnchanter') end,
		},
		{
			filterName = GetString(SI_ITEMTYPEDISPLAYCATEGORY12),
			callback = function(data)
				self:ToggleBUISetting('displaySurveyMapsWoodworker', data.checked)
			end,
			checked = function() return getTeleporterSetting('displaySurveyMapsWoodworker') end,
		},
		{
			filterName = GetString(SI_ITEMTYPEDISPLAYCATEGORY10),
			callback = function(data)
				self:ToggleBUISetting('displaySurveyMapsBlacksmith', data.checked)
			end,
			checked = function() return getTeleporterSetting('displaySurveyMapsBlacksmith') end,
		},
		{
			filterName = GetString(SI_ITEMTYPEDISPLAYCATEGORY11),
			callback = function(data)
				self:ToggleBUISetting('displaySurveyMapsClothier', data.checked)
			end,
			checked = function() return getTeleporterSetting('displaySurveyMapsClothier') end,
		},
		{
			filterName = GetString(SI_ITEMTYPEDISPLAYCATEGORY13),
			callback = function(data)
				self:ToggleBUISetting('displaySurveyMapsJewelry', data.checked)
			end,
			checked = function() return getTeleporterSetting('displaySurveyMapsJewelry') end,
		},
	}

	local filtersGroupId = self:AddOptionTemplateGroup(function() return GetString(SI_TELE_UI_TOGGLE_SURVEY_MAP) end)
	for filterIndex, currentFilter in ipairs(filterData) do
		self:AddOptionTemplate(filtersGroupId, function() return self:BuildCheckbox(SI_GAMEPAD_CRAFTING_OPTIONS_FILTERS, label, currentFilter, icon) end, conditionFunction)
	end
	


	--[[
	local filterData = {
		{
			filterName = GetString(SI_ITEMTYPEDISPLAYCATEGORY14),
			callback = function(data)
				self:ToggleBUISetting('displaySurveyMapsAlchemist', data.checked)
			end,
			checked = getTeleporterSetting('displaySurveyMapsAlchemist'),
		},
		{
			filterName = GetString(SI_ITEMTYPEDISPLAYCATEGORY15),
			callback = function(data)
				self:ToggleBUISetting('displaySurveyMapsEnchanter', data.checked)
			end,
			checked = getTeleporterSetting('displaySurveyMapsEnchanter'),
		},
		{
			filterName = GetString(SI_ITEMTYPEDISPLAYCATEGORY12),
			callback = function(data)
				self:ToggleBUISetting('displaySurveyMapsWoodworker', data.checked)
			end,
			checked = getTeleporterSetting('displaySurveyMapsWoodworker'),
		},
		{
			filterName = GetString(SI_ITEMTYPEDISPLAYCATEGORY10),
			callback = function(data)
				self:ToggleBUISetting(displaySurveyMapsBlacksmith)
			end,
			checked = getTeleporterSetting('displaySurveyMapsBlacksmith'),
		},
		{
			filterName = GetString(SI_ITEMTYPEDISPLAYCATEGORY11),
			callback = function(data)
				self:ToggleBUISetting('displaySurveyMapsClothier', data.checked)
			end,
			checked = getTeleporterSetting('displaySurveyMapsClothier'),
		},
		{
			filterName = GetString(SI_ITEMTYPEDISPLAYCATEGORY13),
			callback = function(data)
				self:ToggleBUISetting('displaySurveyMapsJewelry', data.checked)
			end,
			checked = getTeleporterSetting('displaySurveyMapsJewelry'),
		},
	}
	]]
end

function TeleportClass_Shared:BuildDungeonsCategoryOptions(groupId)
	local function conditionFunction()
		local categoryData = self:GetTargetData()
		if not categoryData then return false end
		return categoryData.categoryType == CATEGORY_TYPE_DUNGEON
	end
	local filterData = {
		{
			filterName = GetString(SI_TELE_UI_TOGGLE_ARENAS),
			callback = function(data)
				self:ToggleBUISetting('df_showArenas', data.checked)
			end,
			checked = getTeleporterSetting('df_showArenas'),
		},
		{
			filterName = GetString(SI_TELE_UI_TOGGLE_GROUP_ARENAS),
			callback = function(data)
				self:ToggleBUISetting('df_showGroupArenas', data.checked)
			end,
			checked = getTeleporterSetting('df_showGroupArenas'),
		},
		{
			filterName = GetString(SI_TELE_UI_TOGGLE_TRIALS),
			callback = function(data)
				self:ToggleBUISetting('df_showTrials', data.checked)
			end,
			checked = getTeleporterSetting('df_showTrials'),
		},
		{
			filterName = GetString(SI_TELE_UI_TOGGLE_GROUP_DUNGEONS),
			callback = function(data)
				self:ToggleBUISetting('df_showDungeons', data.checked)
			end,
			checked = getTeleporterSetting('df_showDungeons'),
		},
	}
	for filterIndex, currentFilter in ipairs(filterData) do
		self:AddOptionTemplate(groupId, function() return self:BuildCheckbox(SI_GAMEPAD_CRAFTING_OPTIONS_FILTERS, label, currentFilter, icon) end, conditionFunction)
	end

end

function TeleportClass_Shared:BuildDelvesCategoryOptions(groupId)
	local function conditionFunction()
		local categoryData = self:GetTargetData()
		if not categoryData then return false end
		return categoryData.categoryType == CATEGORY_TYPE_DELVE
	end
	
	local filterData = {
		{
			filterName = GetString(SI_TELE_UI_TOGGLE_ALL_DELVES),
			callback = function(data)
				self:ToggleBUISetting('showAllDelves', data.checked)
			end,
			checked = getTeleporterSetting('showAllDelves'),
		},
	}
	for filterIndex, currentFilter in ipairs(filterData) do
		self:AddOptionTemplate(groupId, function() return self:BuildCheckbox(SI_GAMEPAD_CRAFTING_OPTIONS_FILTERS, label, currentFilter, icon) end, conditionFunction)
	end
end

function TeleportClass_Shared:BuildPortToFriendOption()
	local groupId = self:AddOptionTemplateGroup(function() return PortToFriend and PortToFriend.constants.HEADER_TITLE or 'BLANK' end)
	
	local function showPTF()
		return self.socialData.categoryType == CATEGORY_TYPE_PTF
	end

	local function BuildPTFOption()
		local callback = function()
			SCENE_MANAGER:Hide("gamepad_worldMap")
			
			zo_callLater(function()
				PortToFriend.OpenWindow(function()
					zo_callLater(function()
						SCENE_MANAGER:Push("gamepad_worldMap")
						GAMEPAD_WORLD_MAP_INFO:Show()
						self:SwitchToFragment()
					end, 150)
				end)
			end, 150)
		end
		local  list = BMU.TeleporterList
		local openPTF = list.lines[#list.lines]
		
		--[[
	openPTF.zoneName = "Open \"Port to Friend's House\""
	openPTF.textColorDisplayName = "gold"
	openPTF.textColorZoneName = "gold"
		]]
		
		local label = BMU.colorizeText(openPTF.zoneName, openPTF.textColorZoneName)
		local label = BMU.colorizeText(GetString(SI_ENTER_CODE_CONFIRM_BUTTON), 'gold')
		
		return self:BuildOptionEntry(nil, label, callback)
	end

	self:AddOptionTemplate(groupId, BuildPTFOption, showPTF)
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------
function TeleportClass_Shared:BuildGuildInviteOption(header, guildId)
    local inviteFunction = function()
            ZO_TryGuildInvite(guildId, self.socialData.displayName)
        end

    return self:BuildOptionEntry(header, GetGuildName(guildId), inviteFunction, nil, ZO_GetLargeAllianceSymbolIcon(GetGuildAlliance(guildId)))
end

function TeleportClass_Shared:AddInviteToGuildOptionTemplates()
	
    local guildCount = GetNumGuilds()
    if guildCount > 0 then
        local guildInviteGroupingId = self:AddOptionTemplateGroup(function() return GetString(SI_GAMEPAD_CONTACTS_INVITE_TO_GUILD_HEADER) end)
	
		for i = 1, guildCount do
			local guildId = GetGuildId(i)
			
			local function showGuild()
				return self:ShouldShowGuildInvite(guildId)
			end
			
			local buildFunction = function() return self:BuildGuildInviteOption(nil, guildId) end
			self:AddOptionTemplate(guildInviteGroupingId, buildFunction, showGuild)
		end
    end
end

function TeleportClass_Shared:ShouldShowGuildInvite(guildId)
	if self.socialData and self.socialData.displayName and self.socialData.displayName ~= '' then
		local displayName = self.socialData.displayName
		local a, b = displayName:find('@.*')
		displayName = displayName:sub(a, b)

		if GUILD_ROSTER_MANAGER:FindDataByDisplayName(displayName) == nil then
			return self:ShouldAddPlayerOption() and DoesPlayerHaveGuildPermission(guildId, GUILD_PERMISSION_INVITE)
		end
	end	
end

function TeleportClass_Shared:BuildSendMailOption()
    local function finishCallback(dialog)
        if IsUnitDead("player") then
            ZO_AlertEvent(EVENT_UI_ERROR, SI_CANNOT_DO_THAT_WHILE_DEAD)
        elseif IsUnitInCombat("player") then
            ZO_AlertEvent(EVENT_UI_ERROR, SI_CANNOT_DO_THAT_WHILE_IN_COMBAT)
        else
            MAIL_MANAGER_GAMEPAD:GetSend():ComposeMailTo(ZO_FormatUserFacingCharacterOrDisplayName(self.socialData.displayName))
        end
    end
    return self:BuildOptionEntry(nil, SI_SOCIAL_MENU_SEND_MAIL, releaseDialogueCallback, finishCallback)
end

function TeleportClass_Shared:BuildWhisperOption()
    local finishCallback = function()
		StartChatInput("", CHAT_CHANNEL_WHISPER, self.socialData.displayName)
	end
    return self:BuildOptionEntry(nil, SI_SOCIAL_LIST_PANEL_WHISPER, releaseDialogueCallback, finishCallback)
end

-- colorize text
function TeleportClass_Shared.colorizeText(text, color)
	if type(color) == "string" then
		local code = BMU.var.color.colWhite

		if string.lower(color) == "gray" then
			code = BMU.var.color.colTrash
		elseif string.lower(color) == "yellow" then
			code = BMU.var.color.colYellow
		elseif string.lower(color) == "blue" then
			code = BMU.var.color.colArcane
		elseif string.lower(color) == "white" then
			code = BMU.var.color.colWhite
		elseif string.lower(color) == "red" then
			code = BMU.var.color.colRed
		elseif string.lower(color) == "gold" then
			code = BMU.var.color.colLegendary
		elseif string.lower(color) == "green" then
			code = BMU.var.color.colGreen
		elseif string.lower(color) == "orange" then
			code = BMU.var.color.colOrange
		elseif string.lower(color) == "teal" then
			code = BMU.var.color.colBlue
		elseif string.lower(color) == "dred" then
			code = BMU.var.color.colDarkRed
		elseif string.lower(color) == "lgray" then
			code = BMU.var.color.colGray
		end

		return "|c" .. code .. tostring(text) .. "|r"
	end
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------
addon.subclassTable.list_Shared = TeleportClass_Shared