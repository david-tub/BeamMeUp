---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------
local addonData = {
	displayName = "|r Beam Me Up Gamepad|r",
	name = "BeamMeUp",
	prefix = "IJA_BMU",
	version = "1.4.2",
}

local defaults = {
	panAndZoom = true,
	panToGroupMember = true,
}

local svVersion = 1

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------
local USES_RIGHT_SIDE_CONTENT = true

local playersPerZone = {}

local function init_NOTIFICATIONTYPES()
	IJA_BMU_NOTIFICATION_TYPE_WAYSHRINE_UNLOCK = NOTIFICATION_TYPE_MAX_VALUE + 1
	IJA_BMU_NOTIFICATION_TYPE_WAYSHRINE_COMLPETE = IJA_BMU_NOTIFICATION_TYPE_WAYSHRINE_UNLOCK + 1
	NOTIFICATION_TYPE_MAX_VALUE = IJA_BMU_NOTIFICATION_TYPE_WAYSHRINE_COMLPETE + 1
	
	strings = {}
	strings["SI_NOTIFICATIONTYPE" .. IJA_BMU_NOTIFICATION_TYPE_WAYSHRINE_UNLOCK] = GetString(SI_BMU_GAMEPAD_NOTIFICATION_TYPE_WAYSHRINE_UNLOCK)
	strings["SI_NOTIFICATIONTYPE" .. IJA_BMU_NOTIFICATION_TYPE_WAYSHRINE_COMLPETE] = GetString(SI_BMU_GAMEPAD_NOTIFICATION_TYPE_WAYSHRINE_COMLPETE)
	
	ZO_GAMEPAD_NOTIFICATION_ICONS[IJA_BMU_NOTIFICATION_TYPE_WAYSHRINE_UNLOCK] = '/esoui/art/icons/poi/poi_wayshrine_incomplete.dds'
	ZO_GAMEPAD_NOTIFICATION_ICONS[IJA_BMU_NOTIFICATION_TYPE_WAYSHRINE_COMLPETE] = '/esoui/art/icons/poi/poi_wayshrine_complete.dds'
	
	for stringId, stringValue in pairs(strings) do
		ZO_CreateStringId(stringId, stringValue)
		SafeAddVersion(stringId, 1)
	end
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------
local addon = ZO_DeferredInitializingObject:Subclass()
BMU.IJA = addon

BMU.IJA.gameplayInfo = {
  newInputType = nil,
  eventCode = nil
}

local BMU = BMU
local em = EVENT_MANAGER
local cm = CALLBACK_MANAGER

function addon:Init(self, control)
    self.categoryList = self.subclassTable.categoryList:New(self, control)
		self.teleportList = self.subclassTable.teleportList:New(self, IJA_BMU_TeleportList_Gamepad)

		self.currentFragment = self.categoryList.fragment

		init_NOTIFICATIONTYPES()

		self:RegisterEvents()
		-- self:CreateSettings()
end

function addon:Initialize(control)

	self.control = control
	zo_mixin(self, addonData)

	self.portalPlayers = {}
	self.teleportMap = {}
	self.subclassTable = {}
	self.autoUnlockProgress = 0

	local function OnLoaded(_, name)
		if name ~= self.name then return end

-- 		self.control:UnregisterForEvent(EVENT_ADD_ON_LOADED)
      zo_callLater(function()
        addon:Init(self, self.control)
      end, 2000)

	end
	control:RegisterForEvent( EVENT_ADD_ON_LOADED, OnLoaded)

	local function onPlayerActivated()
		self.control:UnregisterForEvent(EVENT_PLAYER_ACTIVATED)
	--	d( self.displayName

	end
	control:RegisterForEvent(EVENT_PLAYER_ACTIVATED, onPlayerActivated)
end

function addon.getDisplayNameFromAppended(data)
	local displayName = ''
	local first, last = data.displayName:find('@.*')
	if first and last then
		displayName = data.displayName:sub(first, last)
	else
	
	end
	return displayName
end

--[[
function addon:InitializeCustomTabs()
	local mapInfo = GAMEPAD_WORLD_MAP_INFO
	local tabBarEntries = mapInfo.tabBarEntries
	self.orginalHeaderData = GAMEPAD_WORLD_MAP_INFO.baseHeaderData

	local newtab = {
		text = BMU.colorizeText(BMU.var.appName, "gold") .. BMU.colorizeText(" - Teleporter", "white"),
		callback = function() mapInfo:SwitchToFragment(self.categoryList.fragment, USES_RIGHT_SIDE_CONTENT) end,
	}
	self.newTab = newtab
	table.insert(tabBarEntries, 1, newtab)

	mapInfo.tabBarEntries = tabBarEntries

	mapInfo.baseHeaderData = {
		tabBarEntries = mapInfo.tabBarEntries,
	}

	ZO_GamepadGenericHeader_Refresh(mapInfo.header, mapInfo.baseHeaderData)
	ZO_GamepadGenericHeader_SetActiveTabIndex(mapInfo.header, 1)

	local getTabHeader = function()
		local categoryData = self.categoryList:GetTargetData()

		if categoryData then
			return categoryData.name
		end

		return "Locations"
	end

	local function switchToFragment(fragment)
		self:SwitchToFragment(fragment)
	end
	
	self.baseHeaderData = {
		tabBarEntries = {
			{
				text = getTabHeader,
				callback = function() switchToFragment(self.teleportList.fragment) end,
			}
		}
	}
	self.OnShowTeleportList = function(selectedIndex)
		mapInfo.baseHeaderData = self.baseHeaderData
	--	ZO_GamepadGenericHeader_SetActiveTabIndex(mapInfo.header, 1)
		self:RefreshHeader()
	end

	self.OnHideTeleportList = function(selectedIndex)
		mapInfo.baseHeaderData = self.orginalHeaderData
		GAMEPAD_WORLD_MAP_INFO:OnShowing()
	--	mapInfo:SwitchToFragment(self.categoryList.fragment, USES_RIGHT_SIDE_CONTENT)
		
		-- if was selected by dialogue then go back to last list
		if selectedIndex then
			self.categoryList:SetSelectedIndex(selectedIndex, true)
			CALLBACK_MANAGER:FireCallbacks('BMU_GAMEPAD_CATEGORY_CHANGED', self.categoryList:GetTargetData())
		elseif SCENE_MANAGER:IsShowing("gamepad_worldMap") then
			switchToFragment(self.categoryList.fragment)
		end
		
		self:RefreshHeader()
	--	ZO_GamepadGenericHeader_Refresh(mapInfo.header, mapInfo.baseHeaderData)
	end
end
]]

function addon:SwitchToFragment(fragment)
	local mapInfo = GAMEPAD_WORLD_MAP_INFO
	
	self.currentFragment = fragment
	mapInfo:SwitchToFragment(fragment, USES_RIGHT_SIDE_CONTENT)
end

function addon:RefreshHeader()
	local mapInfo = GAMEPAD_WORLD_MAP_INFO
	local fragments = {
		self.categoryList.fragment,
		self.teleportList.fragment
	}
	if fragments[mapInfo.fragment] then
		mapInfo.fragment:RefreshHeader()
	end
end

function addon:CreateSettings()
	if not BMU.var.optionsTable then return end
	local controls = {
		{ -- "Can Research"
			type = "checkbox",
			name = GetString(SI_BMU_GAMEPAD_PAN),
			tooltip = GetString(SI_IJADECON_AUTOADD_TOOLTIP),
			getFunc = function()
				return self.savedVars.panAndZoom
			end,
			setFunc = function(value)
				self.savedVars.panAndZoom = value
			end,
			width = "full"
		},
		{ -- "Can Research"
			type = "checkbox",
			name = GetString(SI_BMU_GAMEPAD_PAN_TO_GROUP),
			tooltip = GetString(SI_IJADECON_AUTOADD_TOOLTIP),
			getFunc = function()
				return self.savedVars.panToGroupMember
			end,
			setFunc = function(value)
				self.savedVars.panToGroupMember = value
			end,
			disabled = function() return not self.savedVars.panAndZoom end,
			width = "full"
		},
	}
	
	local submenu = {
		type = "submenu",
		name = GetString(SI_GAMEPAD_SECTION_HEADER),
		controls = controls,
	}
	
	local optionsTable = BMU.var.optionsTable
	table.insert(optionsTable, submenu)
	
	BMU.LAM:RegisterOptionControls(BMU.var.appName .. "Options", optionsTable)
end

-- IJA_BMU_GAMEPAD_PLUGIN.portalPlayers
function addon:UpdatePortalPlayers()
	if not self.teleportList then return end
	local portalPlayers = {}
	playersPerZone = {}

	local categoryData = self.categoryList:GetTargetData()
	local myZoneId = GetUnitZone("player")
	local teleporterList = BMU.TeleporterList and BMU.TeleporterList.lines or {}

	for k, data in pairs(teleporterList) do
		if data.category and data.category > 0 or data.guildId ~= nil then
			if not categoryData.categoryFilter or categoryData.categoryFilter(data) then
				local numberPlayers = data.numberPlayers
				data.categoryType = categoryData.categoryType
				
				-- (portal data, in my zone)
				local entry = BMU_Gamepad_EntryData:CreateNewEntry(data, data.zoneId == myZoneId)
				if entry then
					table.insert(portalPlayers, entry)
				end

				if data.numberPlayers then
					local zoneIndex = data.zoneIndex or GetZoneIndex(data.zoneId)
					if not playersPerZone[zoneIndex] then
						playersPerZone[zoneIndex] = data.numberPlayers
					end
				end
			end
		end
	end

	self.portalPlayers = portalPlayers

	GAMEPAD_WORLD_MAP_LOCATIONS:BuildLocationList()
	-- BMU.changeState(index)
end

function addon:CreateTestList(filter)
	if not self.teleportList then return end
	
	local portalPlayers = {}
	playersPerZone = {}

	local categoryData = self.categoryList:GetTargetData()

	local myZoneId = GetUnitZone("player")
	
	local teleporterList = {}
		
	if filter.index == 0 then
		WORLD_MAP_HOUSES_DATA:RefreshHouseList()
		local houses = WORLD_MAP_HOUSES_DATA:GetHouseList()
		for i = 1, #houses do
			local house = houses[i]
			local entry = BMU.createBlankRecord()
			entry.isOwnHouse = house.unlocked
			entry.zoneId = GetHouseZoneId(house.houseId)
			entry.zoneNameUnformatted = GetZoneNameById(entry.zoneId)
			entry.textColorDisplayName = BMU.var.color.colTrash
			entry.zoneNameClickable = true
			entry.mapIndex = BMU.getMapIndex(entry.zoneId)
			entry.parentZoneId = BMU.getParentZoneId(entry.zoneId)
			entry.parentZoneName = BMU.formatName(GetZoneNameById(entry.parentZoneId))
			entry.category = BMU.categorizeZone(entry.zoneId)
			entry.collectibleId = GetCollectibleIdForHouse(entry.houseId)
			entry.houseCategoryType = GetString("SI_HOUSECATEGORYTYPE", GetHouseCategoryType(entry.houseId))
			entry.nickName = BMU.formatName(GetCollectibleNickname(entry.collectibleId))
			entry.zoneName = BMU.formatName(entry.zoneNameUnformatted, BMU.savedVarsAcc.formatZoneName)
			
			_, _, entry.houseIcon = GetCollectibleInfo(entry.collectibleId)
			entry.houseBackgroundImage = GetHousePreviewBackgroundImage(entry.houseId)
			entry.houseTooltip = {entry.zoneName, "\"" .. entry.nickName .. "\"", entry.parentZoneName, "", "", "|t75:75:" .. entry.houseIcon .. "|t", "", "", entry.houseCategoryType}
		
			if BMU.savedVarsAcc.houseNickNames then
				-- show nick name instead of real house name
				entry.zoneName = entry.nickName
			end
			
			table.insert(teleporterList, entry)
		end
	else
		for zoneIndex = 1, GetNumZones() do
			local zoneId = GetZoneId(zoneIndex)
			local zoneName = GetZoneNameById(zoneId)
			
		--	if zoneName ~= '' then
				local entry = BMU.createBlankRecord()
				
				entry.zoneId = zoneId
				entry.zoneNameUnformatted = zoneName
				entry.textColorDisplayName = BMU.var.color.colTrash
				entry.zoneNameClickable = true
				entry.mapIndex = BMU.getMapIndex(zoneId)
				entry.parentZoneId = BMU.getParentZoneId(zoneId)
				entry.parentZoneName = BMU.formatName(GetZoneNameById(parentZoneId))
				entry.category = BMU.categorizeZone(zoneId)
				entry.zoneName = BMU.formatName(zoneName)
				entry.textColorZoneName = BMU.var.color.colWhite
				
				table.insert(teleporterList, entry)
		--	end
		end
	end

	for k, data in pairs(teleporterList) do
	--	if data.category and data.category > 0 or data.guildId ~= nil then
			if not categoryData.categoryFilter or categoryData.categoryFilter(data) then

				data.categoryType = categoryData.categoryType
				data.category = BMU.categorizeZone(data.zoneId) or 9
				if categoryData.filter.index > 9 then
					BMU_Gamepad_EntryData:CreateMultiEntry(data, dataTable)
				else
					local entry = BMU_Gamepad_EntryData:CreateNewEntry(data, data.zoneId == myZoneId)
					if entry then
						table.insert(portalPlayers, entry)
					end
				end
			end
	--	end
	end

	BMU.changeState(0)
	
	self.portalPlayers = portalPlayers

	self:RefreshHeader()

--[[
	if not self.categoryList.fragment:IsHidden() then
		self.categoryList:RefreshKeybind()
	elseif not self.teleportList.fragment:IsHidden() then
		self.teleportList:Refresh()
	end
]]
		
--	GAMEPAD_WORLD_MAP_LOCATIONS.data.mapData = nil
	GAMEPAD_WORLD_MAP_LOCATIONS:BuildLocationList()
end

function addon:IsShowing()
	local categoryListShowing = not self.categoryList.fragment:IsHidden()
	local teleportListShowing = not self.teleportList.fragment:IsHidden()
	
	return categoryListShowing or teleportListShowing
end

do
	local lastTime = 0
	local REFRESH_ON_EVENT_TIME_DELAY = 50 -- 5000
	function addon:RefreshOnEvent(frameTimeInMilliseconds, ...)
	--	if not self:IsShowing() then return end
		if self.currentFragment:IsHidden() then return end
		local args = {...}

		local function onUpdate()
			-- stops selection jump on refresh while moving
			if self.teleportList:IsMoving() then return end
			
			em:UnregisterForUpdate(self.name)
			cm:FireCallbacks('BMU_GAMEPAD_CATEGORY_CHANGED', self.categoryList:GetTargetData())
		end

		em:UnregisterForUpdate(self.name)
		em:RegisterForUpdate(self.name, REFRESH_ON_EVENT_TIME_DELAY, onUpdate)
	end
end

function addon:RegisterEvents()
	local function onCategoryChanged(categoryData, selectedIndex)
		if not categoryData then return end
		
	--	BMU.changeState(categoryData.filter.index)
		if categoryData.callback then
			local filter = categoryData.filter or {}
			self.selectedIndex = selectedIndex
			
			BMU.changeState(filter.index)
			categoryData.callback(filter)
			
			if categoryData.categoryType ~= 9 then
				self:UpdatePortalPlayers()
				self.isDirty = true
			end
			
			self.categoryList.fragment:UpdateTooltip(self.categoryList:GetTargetData())
		end
	end
	cm:RegisterCallback('BMU_GAMEPAD_CATEGORY_CHANGED', onCategoryChanged)

	local function onBmuListUpdated()
		if not self.currentFragment:IsHidden() then
			self:UpdatePortalPlayers()
			self:RefreshHeader()
			
			if self.currentFragment == self.categoryList.fragment then
			--	self.categoryList:RefreshKeybind()
				self.categoryList:UpdateTooltip(self.categoryList:GetTargetData())
				
			else
				self.teleportList:Refresh()
			end
		end
	end
	cm:RegisterCallback('BMU_List_Updated', onBmuListUpdated)

	local function refreshOnEvent(_, ...)
		self:RefreshOnEvent(GetFrameTimeMilliseconds(), ...)
	end

	em:RegisterForEvent(self.name, EVENT_FRIEND_ADDED, refreshOnEvent)
	em:RegisterForEvent(self.name, EVENT_FRIEND_REMOVED, refreshOnEvent)

	em:RegisterForEvent(self.name, EVENT_GROUP_MEMBER_LEFT, refreshOnEvent)
	em:RegisterForEvent(self.name, EVENT_GROUP_MEMBER_JOINED, refreshOnEvent)

	em:RegisterForEvent(self.name, EVENT_GUILD_MEMBER_ADDED, refreshOnEvent)
	em:RegisterForEvent(self.name, EVENT_GUILD_MEMBER_REMOVED, refreshOnEvent)

	em:RegisterForEvent(self.name, EVENT_FRIEND_PLAYER_STATUS_CHANGED, refreshOnEvent)
    em:RegisterForEvent(self.name, EVENT_GROUP_MEMBER_CONNECTED_STATUS, refreshOnEvent)
    em:RegisterForEvent(self.name, EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED, refreshOnEvent)

	em:RegisterForEvent(self.name, EVENT_FRIEND_CHARACTER_ZONE_CHANGED, refreshOnEvent)
	em:RegisterForEvent(self.name, EVENT_GUILD_MEMBER_CHARACTER_ZONE_CHANGED, refreshOnEvent)

    local function OnZoneUpdate(evt, unitTag, newZone)
--	d( '-- EVENT_ZONE_UPDATE', unitTag)
        if ZO_Group_IsGroupUnitTag(unitTag) or unitTag == "player" then
            refreshOnEvent()
        end
    end
    em:RegisterForEvent(self.name, EVENT_ZONE_UPDATE, OnZoneUpdate)

	em:RegisterForEvent(self.name, EVENT_QUEST_ADDED, refreshOnEvent)
	em:RegisterForEvent(self.name, EVENT_QUEST_REMOVED, refreshOnEvent)
	em:RegisterForEvent(self.name, EVENT_QUEST_CONDITION_COUNTER_CHANGED, refreshOnEvent)

	local trackedItems = {
		[SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT] = true,
		[SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP] = true
	}
	local function onSingleSlotUpdate(bagId, slotIndex, slotData)
		if bagId ~= nil and bagId == BAG_BACKPACK then
			local itemType, specializedItemType = GetItemType(bagId, slotIndex)
			if trackedItems[specializedItemType] then
				refreshOnEvent()
			end
		end
	end
	SHARED_INVENTORY:RegisterCallback("SingleSlotInventoryUpdate", onSingleSlotUpdate)

	self.eventsRegistered = true

	local function getLocationList()
		return self:RefreshLocationList()
	end
	GAMEPAD_WORLD_MAP_LOCATIONS.data.GetLocationList = getLocationList
	
	WORLD_MAP_MANAGER:RegisterCallback("Showing", function()
		if GAMEPAD_WORLD_MAP_INFO and SCENE_MANAGER:IsShowing("gamepad_worldMap") then
			-- Beam Me Up "Beam Me Up when Map opens"
			if BMU.savedVarsAcc.ShowOnMapOpen then
				GAMEPAD_WORLD_MAP_INFO:Show()
			end
			
			-- Beam Me Up "Keep Beam Me Up Open"
			if BMU.savedVarsAcc.windowStay then
				ZO_GamepadGenericHeader_SetActiveTabIndex(GAMEPAD_WORLD_MAP_INFO.header, 1)
			end
		end
	end)
end

function addon:RefreshLocationList()
	-- Used to update the gamepad's locations tab to add player counts to zone names.
	-- The counts are based on category selected.
    local mapData = {}
    for i = 1, GetNumMaps() do
        local mapName, mapType, mapContentType, zoneIndex, description = GetMapInfoByIndex(i)

		if description ~= '' then
			local numResults, locationName = playersPerZone[zoneIndex]
			if numResults then
				locationName = ZO_CachedStrFormat('<<t:1>> (<<2>>)', mapName, numResults)
			else
				locationName = ZO_CachedStrFormat(SI_ZONE_NAME, mapName)
			end

			mapData[#mapData + 1] = { locationName = locationName, description = description, index = i }
		end
	end

    table.sort(mapData, function(a,b)
        return a.locationName < b.locationName
    end)

    return mapData
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------
function IJA_BMU_Initialize( ... )
	IJA_BMU_GAMEPAD_PLUGIN = addon:New( ... )
end
	

function locTest()
    local locations = WORLD_MAP_LOCATIONS
    locations.data.mapData = nil
	
	ZO_ScrollList_Clear(locations.list)
    local scrollData = ZO_ScrollList_GetDataList(locations.list)
	
    local mapData = locations.data:GetLocationList()
	
    for i,entry in ipairs(mapData) do
        scrollData[#scrollData + 1] = ZO_ScrollList_CreateDataEntry(1, entry)
    end

    ZO_ScrollList_Commit(locations.list)
	
end

--	/script locTest()
