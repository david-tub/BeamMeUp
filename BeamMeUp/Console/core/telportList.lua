local addon = IJA_BMU_GAMEPAD_PLUGIN
local TeleportClass_Shared = addon.subclassTable.list_Shared

local GPS = LibGPS3

local CATEGORY_TYPE_ALL			= 1
local CATEGORY_TYPE_PTF			= 9

---------------------------------------------------------------------------------------------------------------
-- Teleport list
---------------------------------------------------------------------------------------------------------------
local g_onWorldMapChanged_SetMapToTarget = false

local CATEGORY_TYPE_BMU = 7

local USES_RIGHT_SIDE_CONTENT = true

local function getCollectibleData(collectibleId)
	return ZO_COLLECTIBLE_DATA_MANAGER:GetCollectibleDataById(collectibleId)
end

local function getMostUsedModifier()
	local mostUsed = 0

	local portCounterPerZone = BMU.savedVarsAcc.portCounterPerZone or {}
	for zoneId, timesUsed in pairs(BMU.savedVarsAcc.portCounterPerZone) do
		if timesUsed > mostUsed then
			mostUsed = timesUsed
		end
	end

	if mostUsed > 0 then
		mostUsed = mostUsed * 0.9
	end

	return mostUsed
end

local DEFAULT_SORT_KEYS = {
	sortOrder = { tiebreaker = "originalSort", isNumeric = true },
	originalSort = { isNumeric = true },
}

local function sortFunction(data1, data2)
	return ZO_TableOrderingFunction(data1, data2, 'sortOrder', DEFAULT_SORT_KEYS, ZO_SORT_ORDER_UP)
end

local function isTargetPlayer(socialData)
	return socialData.displayName ~= nil and socialData.displayName ~= ''
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------

local teleportList = TeleportClass_Shared:Subclass()

function teleportList:Initialize(owner, control)
	TeleportClass_Shared.Initialize(self, control)
	self.categoryList = owner.categoryList
	self.container = control
	self.owner = owner
	self.owner.savedVars = self.owner.savedVars or {}

	self.noItemsLabel:SetText(GetString(SI_TELE_UI_NO_MATCHES))

	self:InitializeCustomTabs()
	self:RegisterCallbacks()

	self.fragment:RegisterCallback("StateChange",  function(oldState, newState)
		if newState == SCENE_SHOWING then
			self:Activate()

			KEYBIND_STRIP:AddKeybindButtonGroup(self.keybindStripDescriptor)
			self.lastSelectedIndex = 1
		--	local RESET_TO_TOP = true
			self:Refresh(RESET_TO_TOP)
		elseif newState == SCENE_SHOWN then
			-- To force option update on first entry
			self:OnShowTeleportList()
			if not self.socialData.zoneId then
				self:SetSelectedIndexWithoutAnimation(1)
			end

			self:UpdateTooltip(self:GetTargetData())
		elseif newState == SCENE_HIDDEN then
			KEYBIND_STRIP:RemoveKeybindButtonGroup(self.keybindStripDescriptor)
			self:Deactivate()
		--	self:OnHideTeleportList()
			
	--		self:UpdateDirectionalInput()
		end
	end)
end

function teleportList:InitializeKeybindDescriptor()
	self.keybindStripDescriptor = {
		alignment = KEYBIND_STRIP_ALIGN_LEFT,
		{ -- select item
	--		name = GetString(SI_GAMEPAD_SELECT_OPTION),
			name = function()
				local targetData = self:GetTargetData()

				if targetData then
					if targetData.categoryType == CATEGORY_TYPE_BMU then
						return GetString(SI_GUILD_BROWSER_GUILD_LIST_VIEW_GUILD_INFO_KEYBIND)
					end
					--houseNameFormatted
--					if targetData.numberPlayers and BMU.savedVarsAcc.zoneOnceOnly then

					if targetData.displayName ~= '' or targetData.houseId then
						if targetData.numberPlayers and BMU.savedVarsAcc.zoneOnceOnly then
							return zo_strformat(SI_GAMEPAD_WORLD_MAP_INTERACT, GetString(SI_GAMEPAD_WORLD_MAP_TRAVEL), GetString(SI_GAMEPAD_OPTIONS_MENU))
						else
							return GetString(SI_GAMEPAD_WORLD_MAP_TRAVEL)
						end
					else
						return BMU.colorizeText(string.format(GetString(SI_TOOLTIP_RECALL_COST) .. "%d", GetRecallCost()), "red")
					end
				end
			end,
			keybind = "UI_SHORTCUT_PRIMARY",
			callback = function()
				local targetData = self:GetTargetData()

				if targetData then
					if targetData.categoryType == CATEGORY_TYPE_BMU then
						ZO_LinkHandler_OnLinkClicked("|H1:guild:" .. targetData.guildId .. "|hGuild|h", 1, nil)
					else
						if targetData.numberPlayers and BMU.savedVarsAcc.zoneOnceOnly then
							local categoryList = self.owner.categoryList
							self.owner.categoryList.previouseIndex = categoryList:GetSelectedIndex()
							ZO_Dialogs_ShowGamepadDialog("BMU_GAMEPAD_MULTIPLE_SELECTIONS_DIALOG", {targetData = targetData, categoryList = categoryList, selectedIndex = categoryList:GetSelectedIndex()})
						else
							if targetData:TryToPort() then
								SCENE_MANAGER:ShowBaseScene()
							end
						end
					end
				end
			end,
			
---CanLeaveCurrentLocationViaTeleport()
			enabled = function()
				if CanLeaveCurrentLocationViaTeleport() then
					local targetData = self:GetTargetData()
					if targetData then
						if targetData.categoryType == CATEGORY_TYPE_BMU then
							return not targetData.hideButton
						else
							return targetData ~= nil
						end
					end
				end
			end,
			visible = function() return true end,
		},

		{ -- group rally point
			name = GetString(SI_TOOLTIP_UNIT_MAP_RALLY_POINT),
			keybind = "UI_SHORTCUT_SECONDARY",
			callback = function()
				local targetData = self:GetTargetData()
				targetData:Ping()
				PlaySound(SOUNDS.MAP_LOCATION_CLICKED)
			end,
			enabled = function()
				local targetData = self:GetTargetData()
				if targetData ~= nil then
					return targetData.poiIndex or targetData.unitTag ~= nil
				end
				return false
			end,
			visible = function()
				local targetData = self:GetTargetData()
				if targetData ~= nil then
					return targetData.categoryType ~= CATEGORY_TYPE_BMU
				end
			end,
		--	visible = function() return IsUnitGroupLeader("player") end,
		},
		{ -- show options
			name = GetString(SI_GAMEPAD_OPTIONS_MENU),
			keybind = "UI_SHORTCUT_TERTIARY",
			enabled = function()
				return self:HasAnyShownOptions()
			end,
			callback = function()
				return self:ShowOptionsDialog()
			end,
			visible = function()
				local targetData = self:GetTargetData()
				if targetData ~= nil then
					return targetData.categoryType ~= CATEGORY_TYPE_BMU
				end
			end,
		},
	}

	local function backButton()
		PlaySound(SOUNDS.GAMEPAD_MENU_BACK)
		self:OnHideTeleportList(self.owner.selectedIndex)
	end

	ZO_Gamepad_AddBackNavigationKeybindDescriptors(self.keybindStripDescriptor, GAME_NAVIGATION_TYPE_BUTTON, backButton)
	ZO_Gamepad_AddListTriggerKeybindDescriptors(self.keybindStripDescriptor, self)
end

function teleportList:RegisterCallbacks()
	local function onWorldMapChanged()
		if g_onWorldMapChanged_SetMapToTarget then
			if self.owner.savedVars.panAndZoom then
				self:PanAndZoomToPin()
			end
		end
		g_onWorldMapChanged_SetMapToTarget = false
	end
	CALLBACK_MANAGER:RegisterCallback("OnWorldMapChanged", onWorldMapChanged)
end

function teleportList:GetCurrentCategory()
	return self.owner.categoryList:GetTargetData()
end

function teleportList:GetHeaderData()
	local mapInfo = GAMEPAD_WORLD_MAP_INFO
	
	local getTabHeader = function()
		local categoryData = self.owner.categoryList:GetTargetData()

		if categoryData then
			return categoryData.name
		end

		return "Locations"
	end

	return {
		tabBarEntries = {
			{
				text = getTabHeader,
				callback = function() self.owner:SwitchToFragment(self.fragment) end,
			},
		},
		data1HeaderText = function() return GetString(SI_TELE_UI_GOLD) end,
		data1Text = function() return BMU.formatGold(BMU.savedVarsAcc.savedGold) end,

		data2HeaderText = function() return GetString(SI_TELE_UI_TOTAL_PORTS) end,
		data2Text = function() return BMU.formatGold(BMU.savedVarsAcc.totalPortCounter) end,

		data3HeaderText = function() return GetString(SI_TELE_UI_TOTAL) end,
		data3Text = function() return #self.owner.portalPlayers end,
	}
end

function teleportList:RefreshHeader()
	ZO_GamepadGenericHeader_Refresh(mapInfo.header, self:GetHeaderData())
end

function teleportList:SwitchToFragment()
	self:OnShowTeleportList()
	self.owner:SwitchToFragment(self.fragment)
end

function teleportList:OnShowTeleportList()
	self:SetupOptions(self.categoryList:GetTargetData())
	local mapInfo = GAMEPAD_WORLD_MAP_INFO
	mapInfo.baseHeaderData = self.baseHeaderData
	ZO_GamepadGenericHeader_Refresh(mapInfo.header, self:GetHeaderData())
end

function teleportList:OnHideTeleportList(selectedIndex)
	local mapInfo = GAMEPAD_WORLD_MAP_INFO
	mapInfo.baseHeaderData = self.orginalHeaderData
	GAMEPAD_WORLD_MAP_INFO:OnShowing()
	
	-- if was selected by dialogue then go back to last list
	if selectedIndex then
		self.categoryList:SetSelectedIndex(selectedIndex, true)
		CALLBACK_MANAGER:FireCallbacks('BMU_GAMEPAD_CATEGORY_CHANGED', self.categoryList:GetTargetData())
	elseif SCENE_MANAGER:IsShowing("gamepad_worldMap") then
		self.categoryList:SwitchToFragment()
	end
	
	self.owner:RefreshHeader()
end

function teleportList:InitializeCustomTabs()
	local mapInfo = GAMEPAD_WORLD_MAP_INFO
	local tabBarEntries = mapInfo.tabBarEntries
	self.orginalHeaderData = GAMEPAD_WORLD_MAP_INFO.baseHeaderData

	local getTabHeader = function()
		local categoryData = self.owner.categoryList:GetTargetData()

		if categoryData then
			return categoryData.name
		end

		return "Locations"
	end

	self.baseHeaderData = {
		tabBarEntries = {
			{
				text = getTabHeader,
				callback = function() self.owner:SwitchToFragment(self.fragment) end,
			}
		}
	}
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------
function teleportList:BuildOptionsList()
	local function ShouldAddPlayerOption()
		return self:ShouldAddPlayerOption()
	end
	self:BuildPortToFriendOption()
	self:BuildAutoUnlockOptions()
	self:BuildGroupOptionsList()
	self:BuildPlayerOptionsList()

	local groupIdFavorites = self:AddOptionTemplateGroup(function() return GetString(SI_TELE_UI_SUBMENU_FAVORITES) end)
	local function toggleFavoritPlayer()
		local filterData = {
			filterName = GetString(SI_TELE_UI_FAVORITE_PLAYER),
			callback = function(data)
				self:ToggleBUISetting('favoriteListPlayers', data.checked, self.socialData.displayName)
			end,
			checked = function() return self:GetBUISetting('favoriteListPlayers', self.socialData.displayName) end,
		}
		return filterData
	end

	self:AddOptionTemplate(groupIdFavorites, function() return self:BuildCheckbox(nil, label, toggleFavoritPlayer, icon) end, ShouldAddPlayerOption)

	local function toggleFavoritZone()
		local filterData = {
			filterName = GetString(SI_TELE_UI_FAVORITE_ZONE),
			callback = function(data)
				self:ToggleBUISetting('favoriteListZones', data.checked, self.socialData.zoneId)
			end,
			checked = function() return self:GetBUISetting('favoriteListZones', self.socialData.zoneId) end,
		}
		return filterData
	end

	self:AddOptionTemplate(groupIdFavorites, function() return self:BuildCheckbox(nil, label, toggleFavoritZone, icon) end, function() return self.socialData.zoneId ~= nil end)

	-- TODO: create string 'Manage Favorites'
	local function manageFavoritesSetup()
		local function callback()
			ZO_Dialogs_ShowGamepadDialog("BMU_GAMEPAD_MANAGE_FAVORITES_DIALOG")
			ZO_Dialogs_ReleaseDialogOnButtonPress("BMU_GAMEPAD_SOCIAL_OPTIONS_DIALOG")
		end

		return self:BuildOptionEntry(nil, SI_BMU_GAMEPAD_MANAGE_FAVORITES, callback)
	end
	self:AddOptionTemplate(groupIdFavorites, manageFavoritesSetup)
end

function teleportList:BuildPlayerOptionsList()
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

function teleportList:BuildGroupOptionsList(groupId)
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

-- Custom build functions for ZO_SocialOptionsDialogGamepad
function teleportList:BuildPromoteToLeaderOption()
	local callback = function()
		GroupPromote(self.socialData.unitTag)
	end
	return self:BuildOptionEntry(nil, SI_GROUP_LIST_MENU_PROMOTE_TO_LEADER, callback)
end

function teleportList:BuildKickMemberOption()
	local callback = function()
		ZO_Dialogs_ReleaseAllDialogsOfName("BMU_GAMEPAD_SOCIAL_OPTIONS_DIALOG")
		GroupKick(self.socialData.unitTag)
	end
	return self:BuildOptionEntry(nil, SI_GROUP_LIST_MENU_KICK_FROM_GROUP, callback)
end

function teleportList:BuildVoteKickMemberOption()
	local callback = function()
		ZO_Dialogs_ReleaseAllDialogsOfName("BMU_GAMEPAD_SOCIAL_OPTIONS_DIALOG")
		BeginGroupElection(GROUP_ELECTION_TYPE_KICK_MEMBER, ZO_GROUP_ELECTION_DESCRIPTORS.NONE, self.socialData.unitTag)
	end
	return self:BuildOptionEntry(nil, SI_GROUP_LIST_MENU_VOTE_KICK_FROM_GROUP, callback)
end

--[[
function teleportList:AddInviteToGuildOptionTemplates()
	local guildCount = GetNumGuilds()

	if guildCount > 0 then
		local guildInviteGroupingId = self:AddOptionTemplateGroup(function() return GetString(SI_GAMEPAD_CONTACTS_INVITE_TO_GUILD_HEADER) end)
		for i = 1, guildCount do
			local guildId = GetGuildId(i)
			local buildFunction = function() return self:BuildGuildInviteOption(nil, guildId) end
			local function visibleFunction()
				if guildId ~= 0 and DoesPlayerHaveGuildPermission(guildId, GUILD_PERMISSION_INVITE) and self.socialData.displayName ~= '' then
					return GetGuildMemberIndexFromDisplayName(guildId, self.socialData.displayName) == nil
				end

				return false
			end
			self:AddOptionTemplate(guildInviteGroupingId, buildFunction, visibleFunction)
		end
	end
end

function teleportList:BuildGuildInviteOption(header, guildId)
	local inviteFunction = function()
			ZO_TryGuildInvite(guildId, self.socialData.displayName)
		end

	return self:BuildOptionEntry(header, GetGuildName(guildId), inviteFunction, nil, GetLargeAllianceSymbolIcon(GetGuildAlliance(guildId)))
end

]]
function teleportList:BuildAutoUnlockOptions(groupId)
	local function conditionFunction()
		return self:AreAnyWayshrinesLocked() and self.socialData.categoryType == CATEGORY_TYPE_ALL
	end

	local filterName = GetString(SI_TELE_UI_UNLOCK_WAYSHRINES)
	local callback = function(data)
		jo_callLaterOnNextScene("", function()
			ZO_Dialogs_ShowGamepadDialog('BMU_GAMEPAD_AUTO_UNLOCK_DIALOG', self:GetSelectedData())
			ZO_Dialogs_ReleaseAllDialogsOfName("BMU_GAMEPAD_MANAGE_FAVORITES_DIALOG")
		end)
		SCENE_MANAGER:ShowBaseScene()
	end
	local icon = nil

	local groupId = self:AddOptionTemplateGroup(function() return BMU.var.appName end)
	self:AddOptionTemplate(groupId, function() return self:BuildTextFieldSubmitItem(BMU.var.appName, filterName , callback, icon) end, conditionFunction)
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------
	
function teleportList:ToggleBUISetting(index, checked, key)
	key = self:GetBUISettingKey(index, key)

	local savedVars = BMU.savedVarsServ[index]
	savedVars[key] = checked or nil
	BMU.savedVarsServ[index] = savedVars

	self.owner:UpdatePortalPlayers()
--	self:RefreshVisible()
	self:Refresh()
end

function teleportList:GetBUISetting(index, key)
	key = self:GetBUISettingKey(index, key)
	local savedVars = BMU.savedVarsServ[index]
	return savedVars[key]
end

function teleportList:GetBUISettingKey(index, key)
	local savedVars = BMU.savedVarsServ[index]
	
	for k, v in pairs(savedVars) do
		if v == key then
			return k
		end
	end
	return key
end

function teleportList:Refresh(resetToTop)
	if self.fragment:IsHidden() then return end
--	g_selectedData = self:GetTargetData()

	self:Clear()
	local selectedIndex = 1

	local teleportPlayers = self.owner.portalPlayers
--	local myZoneId = GetUnitZone("player")

	local mostUsedModifier = getMostUsedModifier()
	-- Now lets update additional data for each entry to use for sorting.
	for i, entry in ipairs(teleportPlayers) do
		-- Use originalSort to maintain the sort order from BMU within each respective subcategory.
		entry.originalSort = i
		entry:Update(mostUsedModifier)
	end
	table.sort(teleportPlayers, sortFunction)

	local lastHeader
	for i, entry in ipairs(teleportPlayers) do
		local header = entry:GetHeader()
		-- only add the header to the first entry for that subcategory.
	--	d( string.format('category = %s, sortOrder = %s, header = %s', tostring(entry.category), tostring(entry.sortOrder), tostring(header)))
		if lastHeader ~= header then
			lastHeader = header
			entry:SetHeader(header)

			self:AddEntryWithHeader("ZO_GamepadMenuEntryTemplateLowercase42", entry)
		else

			self:AddEntry("ZO_GamepadMenuEntryTemplateLowercase42", entry)
		end
	end

    local BLOCK_SELECTION_CHANGED_CALLBACK = true
	local DEFAULT_RESELECT = false
	-- In order to prevent the map from changing on data update we will block the callback unless selections are being made while updating.
	self:Commit(resetToTop, BLOCK_SELECTION_CHANGED_CALLBACK)
	
--[[
	if selectedIndex then
		local ALLOW_IF_DISABLED = true
		self:SetSelectedIndex(selectedIndex, ALLOW_IF_DISABLED)
		self:RefreshVisible() -- Force the previous selection to take place immediately.
	end

	if selectedIndex then
		local ALLOW_IF_DISABLED = true
		self:SetSelectedIndex(selectedIndex, ALLOW_IF_DISABLED)
		self:RefreshVisible() -- Force the previous selection to take place immediately.
	elseif g_selectedData == nil then
		-- If the currently selected list item no longer exists, lets not reset to top.
		self:SetSelectedIndex(1)
	end
]]

	self:RefreshNoEntriesLabel()
	self:RefreshKeybind()
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------
function teleportList:PanAndZoomToPin()
	local selectedData = self.selectedData

	if selectedData then
		local poiIndex = selectedData.poiIndex

		if selectedData.unitTag and self.owner.savedVars.panToGroupMember then
			local delay, xLoc, yLoc = selectedData:GetUnitMapPosition()

			zo_callLater(function()
				ZO_WorldMap_PanToNormalizedPosition(xLoc, yLoc)
			end, delay)
		elseif poiIndex then
			zo_callLater(function()
				local xLoc, yLoc = selectedData:GetPinMapPosition()
				ZO_WorldMap_PanToNormalizedPosition(xLoc, yLoc)
			end, 100)
		end
	end
end

function teleportList:SetMapToTarget(selectedData)
	g_onWorldMapChanged_SetMapToTarget = true
	WORLD_MAP_MANAGER:SetMapById(selectedData.mapId)
	
	if self.currentaMapId == selectedData.mapId then
		-- We don't need to wait for the map to change, so just do it now.
		if self.owner.savedVars and self.owner.savedVars.panAndZoom then
			self:PanAndZoomToPin()
		end
		g_onWorldMapChanged_SetMapToTarget = false
	end
	self.currentaMapId = selectedData.mapId
end

function teleportList:OnSelectedDataChangedCallback(selectedData)
	jo_callLater('IJA_BMU_Gamepad_SetMapToTarget', function()
		if self.isMoving then
			return self:OnSelectedDataChangedCallback(selectedData)
		end
		self:SetMapToTarget(selectedData)
	end, 10)

	self:UpdateTooltip(selectedData)
	self:RefreshKeybind()
end

local skipped_POIs = {
	[210] = true, -- The Harborage
	[211] = true, -- The Harborage
	[212] = true, -- The Harborage
}
local valid_POI_Types = {
	[POI_TYPE_WAYSHRINE] = true,
	[POI_TYPE_PUBLIC_DUNGEON] = true,
}
-- TODO: run a check on this to see if missing is for undiscovered and locked is for discovered
function teleportList:AreAnyWayshrinesLocked()
	-- This checks all of Tamriel for locked wayshrines.
	local numFastTravelNodes = GetNumFastTravelNodes()
	for nodeIndex = 1, numFastTravelNodes do
		if not skipped_POIs[nodeIndex] then
			local known, name, _, _, icon, glowIcon, poiType = GetFastTravelNodeInfo(nodeIndex)
			if poiType == POI_TYPE_WAYSHRINE then
				if not GetFastTravelNodeOutboundOnlyInfo(nodeIndex) then
					if not known then
						return true
					end
				end
			end
		end
	end
	return false
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------

addon.subclassTable.teleportList = teleportList


--[[
	local skipped_POIs = {
		[] = ture,
	}
	'/esoui/art/icons/poi/poi_cave_complete.dds'
	'/esoui/art/icons/icon_missing.dds'

/script d(GetNumFastTravelNodes())
534
					if icon == '/esoui/art/icons/icon_missing.dds' then
						d( poiType, nodeIndex .. ': ' .. name,icon)
					end
				if icon == '/esoui/art/icons/icon_missing.dds' then

					if poiType == POI_TYPE_WAYSHRINE then
					end

				end
]]