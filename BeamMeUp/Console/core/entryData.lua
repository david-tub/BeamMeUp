local addon = IJA_BMU_GAMEPAD_PLUGIN

--[[
	Updated how mapInfo is updated
	
	
	
	get strings for quest headers

]]

local SORT_ORDER_NONE			= 0
local SORT_ORDER_FRIEND			= 1
local SORT_ORDER_RECENT			= 2
local SORT_ORDER_FAVORITE		= 3
local SORT_ORDER_GROUP_LEADER	= 4
local SORT_ORDER_GROUP			= 5

local MIN_CATEGORY_SORT = SORT_ORDER_GROUP + 1

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

local CURRENT_CATEGORY_TYPE = 0

--[[
local defaultHeaders = {
	[1] = getHeaderString('ENTRY', 1),
	[2] = getHeaderString('ENTRY', 2),
	[3] = getHeaderString('ENTRY', 3),
	[4] = GetString(SI_TELE_UI_TOGGLE_GROUP_DUNGEONS),
	[5] = GetString(SI_TELE_UI_TOGGLE_TRIALS),
	[6] = getHeaderString('ENTRY', 2),
	[7] = GetString(SI_TELE_UI_TOGGLE_GROUP_ARENAS),
	[8] = GetString(SI_TELE_UI_TOGGLE_ARENAS),
	[9] = getHeaderString('ENTRY', 9),
	[BMU.ZONE_CATEGORY_OVERLAND] = getHeaderString('ENTRY', 9),
}


BMU.ZONE_CATEGORY_UNKNOWN = 0
BMU.ZONE_CATEGORY_DELVE = 1
BMU.ZONE_CATEGORY_PUBDUNGEON = 2
BMU.ZONE_CATEGORY_HOUSE = 3
BMU.ZONE_CATEGORY_GRPDUNGEON = 4
BMU.ZONE_CATEGORY_TRAIL = 5
BMU.ZONE_CATEGORY_ENDLESSD = 6
BMU.ZONE_CATEGORY_GRPZONES = 7
BMU.ZONE_CATEGORY_GRPARENA = 8
BMU.ZONE_CATEGORY_SOLOARENA = 9
BMU.ZONE_CATEGORY_OVERLAND = 100

BMU.blacklistHouses[zoneId]

local zoneCategory = {
	[1306] = BMU.ZONE_CATEGORY_HOUSE,
	[1468] = BMU.ZONE_CATEGORY_HOUSE,
}
local function updateZoneCategory(entry)
	local zoneId = entry.zoneId
	return BMU.blacklistHouses[zoneId] and BMU.ZONE_CATEGORY_HOUSE or
	entry.category or BMU.ZONE_CATEGORY_UNKNOWN
end

]]

local defaultHeaders = {
	[SORT_ORDER_FAVORITE]			= GetString(SI_TELE_UI_SUBMENU_FAVORITES), -- Favorites
	[BMU.ZONE_CATEGORY_UNKNOWN]		= GetString(SI_CHAT_CHANNEL_NAME_ZONE), -- Zone
	[BMU.ZONE_CATEGORY_DELVE]		= GetString(SI_ZONEDISPLAYTYPE7), -- Delve
	[BMU.ZONE_CATEGORY_PUBDUNGEON]	= GetString(SI_ZONEDISPLAYTYPE6), -- Public Dungeon
	[BMU.ZONE_CATEGORY_HOUSE]		= GetString(SI_ZONEDISPLAYTYPE8), -- Housing
	[BMU.ZONE_CATEGORY_GRPDUNGEON]	= GetString(SI_ZONEDISPLAYTYPE2), -- Dungeon
	[BMU.ZONE_CATEGORY_TRAIL]		= GetString(SI_ZONEDISPLAYTYPE3), -- Trial
	[BMU.ZONE_CATEGORY_ENDLESSD]	= GetString(SI_TELE_UI_TOGGLE_ENDLESS_DUNGEONS),
	[BMU.ZONE_CATEGORY_GRPZONES]	= GetString(SI_BMU_GAMEPAD_ZONE_CATEGORY_GRPZONES),
	[BMU.ZONE_CATEGORY_GRPARENA]	= GetString(SI_TELE_UI_TOGGLE_GROUP_ARENAS),
	[BMU.ZONE_CATEGORY_SOLOARENA]	= GetString(SI_TELE_UI_TOGGLE_ARENAS), -- Solo Arenas
	[BMU.ZONE_CATEGORY_OVERLAND]	= GetString(SI_CHAT_CHANNEL_NAME_ZONE), -- Zone
}

local allianceZones = {
    [ALLIANCE_EBONHEART_PACT] = 41,
    [ALLIANCE_ALDMERI_DOMINION] = 381,
    [ALLIANCE_DAGGERFALL_COVENANT] = 3,
}

local getDisplayNameFromAppended = addon.getDisplayNameFromAppended

---------------------------------------------------------------------------------------------------------------
-- Entry Data
---------------------------------------------------------------------------------------------------------------

local function validateDisplayName(displayName)
	return displayName ~= nil and displayName ~= ''
end

local function isFavoritePlayer(displayName)
	local savedVaars = BMU.savedVarsServ.favoriteListPlayers

	for k, v in pairs(savedVaars) do
		local fName = type(k) == 'number' and v or k

		if displayName == fName then
			return true
		end
	end
end

local function isFavoriteZone(zoneId)
	local savedVaars = BMU.savedVarsServ.favoriteListZones

	for k, v in pairs(savedVaars) do
		local fZoneId = type(v) == 'number' and v or k

		if fZoneId == zoneId then
			return true
		end
	end

end

local function getIsFavorite(data)
	if isFavoritePlayer(data.displayName) then
		return true
	elseif isFavoriteZone(data.zoneId) then
		return true
	end
	return false
end

--[[
local function getHasMissingSetItems(data)
	local numUnlocked, numTota = BMU.getNumSetCollectionProgressPieces(data.zoneId, data.category, data.parentZoneId)
	if (numUnlocked and numTota) then
		return ((numTota-numUnlocked) > 0)
	end
end

local function discovery(total, discovered)
	if not total then return nil end
	return total ~= discovered
end
]]

local function getCollectibleData(collectibleId)
	return ZO_COLLECTIBLE_DATA_MANAGER:GetCollectibleDataById(collectibleId)
end

local onPostPortEvent = 'IJA_BMUGP_onPostPortEvent'
local function onTryToPort(zoneCategory, zoneId)
	EVENT_MANAGER:UnregisterForEvent(onPostPortEvent, EVENT_PLAYER_DEACTIVATED)
	EVENT_MANAGER:UnregisterForEvent(onPostPortEvent, EVENT_PLAYER_ACTIVATED)
	EVENT_MANAGER:UnregisterForUpdate(onPostPortEvent)
	
	if zoneCategory then
		EVENT_MANAGER:RegisterForEvent(onPostPortEvent, EVENT_PLAYER_ACTIVATED, function()
			BMU.updateStatistic(zoneCategory, zoneId)
			onTryToPort()
		end)
		
		EVENT_MANAGER:RegisterForEvent(onPostPortEvent, EVENT_PLAYER_DEACTIVATED, function()
			EVENT_MANAGER:UnregisterForUpdate(onPostPortEvent)
		end)
		
		local xLoc, yLoc = GetMapPlayerPosition('player')
		EVENT_MANAGER:RegisterForUpdate(onPostPortEvent, 100, function()
			local xNew, yNew = GetMapPlayerPosition('player')
		
			if xLoc ~= xNew or yLoc ~= yNew then
				onTryToPort()
			end
		end)
	end
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------

local Entry_Class = ZO_GamepadEntryData:Subclass()

function Entry_Class:Initialize(entryData)
	zo_mixin(self,  entryData)
	
--	self.category = updateZoneCategory(self)
	
	-- we need to set the favorite's color here since we use a different favorites system then BMU
	if isFavoritePlayer(self.displayName) then
		self.textColorDisplayName = "gold"
		self.isFavorite	= true
	end
	if isFavoriteZone(self.zoneId) then
		self.textColorZoneName = "gold"
		self.isFavorite	= true
	end

	local text, subLabel = self:GetLabels()
	
	ZO_GamepadEntryData.Initialize(self, text, self.icon, selectedIcon, highlight, isNew)

	if subLabel then
		self:AddSubLabel(subLabel)
	end

	self:SetAlphaChangeOnSelection(true)
end

function Entry_Class:UpdatePayerCount()
	if BMU.savedVarsAcc.zoneOnceOnly and BMU.savedVarsAcc.showNumberPlayers then
		local numberPlayers = self.numberPlayers
		if numberPlayers then
		--	numberPlayers = numberPlayers:gsub('%((%d+)%)', '%1')
			self:SetStackCount(tonumber(numberPlayers))
		end
	end
end

function Entry_Class:GetLabels()
	local zoneName = BMU.colorizeText(self.zoneName, self.textColorZoneName)
	local displayName = BMU.colorizeText(self.displayName, self.textColorDisplayName)

	if (CURRENT_CATEGORY_TYPE == CATEGORY_TYPE_DISPLAYED and self.zoneIndex == GetCurrentMapZoneIndex()) and not self.isDungeon then
		-- Set entries in the current displayed map as displayName
		return displayName, zoneName
	elseif not BMU.savedVarsAcc.zoneOnceOnly then
		return zoneName, displayName
	end

	local parentName = self.zoneName ~= self.parentZoneName and self.parentZoneName or nil
	return zoneName, (parentName or nil)
end

function Entry_Class:GetIcon() -- This may no longer be needed.
	return self.icon
end

function Entry_Class:GetSortOrder()
	local category = self.category or 0
	 if category == 100 and type(self.houseId) == 'number' then
		category = 3
	 end
	 
	return BMU.sortingByCategory[category] + MIN_CATEGORY_SORT
end

function Entry_Class:HasUndiscoveredWayshrines()
	return self.zoneWayshrineDiscovered ~= self.zoneWayshrineTotal
end

function Entry_Class:UpdateEntryData(mostUsedModifier)
	-- Lets add some additional data to use for subcategory sorting.
	if self.houseId then
		self.isPrimaryResidence = IsPrimaryHouse(self.houseId)
	end

	self.status					= self.status or 0

	self.isFavorite				= getIsFavorite(self)

	local timesUsed = BMU.savedVarsAcc.portCounterPerZone[self.zoneId] or 0
	self.mostUsed = timesUsed > mostUsedModifier
	
	self:UpdatePayerCount()
	self:UpdateZoneInfo()
end

function Entry_Class:UpdateIcon(icon)
	self:ClearIcons()
	self:AddIcon(icon)
	
	self.icon = icon
end

function Entry_Class:UpdateSortOrder()
	local sortOrder = 9

	if self.unitTag then
		if self.isLeader then
			sortOrder = SORT_ORDER_GROUP_LEADER
		else
			sortOrder = SORT_ORDER_GROUP
		end
	elseif self.isFavorite then
		sortOrder = SORT_ORDER_FAVORITE
	elseif self.mostUsed then
		sortOrder = SORT_ORDER_FAVORITE
	elseif self.isPrimaryResidence then
		sortOrder = SORT_ORDER_FAVORITE
	else
		sortOrder = self:GetSortOrder()
	end

	self.sortOrder = sortOrder
end

function Entry_Class:Update(mostUsedModifier)
	self:UpdateEntryData(mostUsedModifier)
	self:UpdateSortOrder()
end

function Entry_Class:GetGroupUnitTag()
	if IsUnitGrouped("player") then
		for i = 1, GROUP_SIZE_MAX do
			local unitTag = GetGroupUnitTagByIndex(i)
			local displayName = GetUnitDisplayName(unitTag)
			if displayName == self.displayName then
				return unitTag
			end
		end
	end
end

function Entry_Class:GetHeader()
	local header = GetString(SI_CHAT_CHANNEL_NAME_ZONE) -- Zone

	if self.categoryType == CATEGORY_TYPE_DISPLAYED then
		header = ''
	else
		if self.unitTag then
			header = GetString(SI_MAPFILTER9) -- "Group Members"
		elseif self.isFavorite then
			header = defaultHeaders[SORT_ORDER_FAVORITE]
		else

			if self.category ~= nil and self.category ~= 0 then
--			d( 'self.category ' .. tostring(self.category))
				header = defaultHeaders[self.category]
			end
		end
	end

	return header
end

-----
function Entry_Class:Ping()
	if self.unitTag then
		local delay, xLoc, yLoc, isInCurrentMap = self:GetUnitMapPosition()

		if not isInCurrentMap then
		--	ZO_WorldMap_SetMapByIndex(self.mapIndex)
			WORLD_MAP_MANAGER:SetMapById(self.mapId)
		end

		zo_callLater(function()
			PingMap(MAP_PIN_TYPE_RALLY_POINT, MAP_TYPE_LOCATION_CENTERED, xLoc, yLoc)
		end, delay)

	elseif self.poiIndex then
		local xLoc, yLoc = self:GetPinMapPosition()
		PingMap(MAP_PIN_TYPE_RALLY_POINT, MAP_TYPE_LOCATION_CENTERED, xLoc, yLoc)
	end
end

function Entry_Class:GetUnitMapPosition()
	local xLoc, yLoc, _, isInCurrentMap = GetMapPlayerPosition(self.unitTag)
	local delay = isInCurrentMap and 0 or 100

	return delay, xLoc, yLoc
end

function Entry_Class:GetPinMapPosition()
	local xLoc, yLoc = GetPOIMapInfo(self.parentZoneIndex, self.poiIndex)

	return xLoc, yLoc
end

function Entry_Class:TryToPort()
	onTryToPort(self.category, self.zoneId)
	if self.zoneWithoutPlayer then
		BMU.PortalToZone(self.zoneId)
		return true
	elseif self.displayName ~= '' then
		BMU.PortalToPlayer(self.displayName, self.sourceIndexLeading, self.zoneName, self.zoneId, self.category, false, true, true)
		return true
	end
end

 -- BMU.PortalToZone(zoneId)
local preferedParentZoneIds = {
	[199] = allianceZones[GetUnitAlliance("player")], -- The Harborage --> Player alliance home
	[689] = 684, -- Nikolvara's Kennel --> Wrothgar
	[678] = 181, -- Imperial City Prison --> Cyrodiil
	[688] = 181, -- White-Gold Tower --> Cyrodiil
	[1209] = 1208, -- Gloomreach --> Blackreach: Arkthzand Cavern
}

function Entry_Class:UpdateZoneInfo()
	local preferedParentZoneId = preferedParentZoneIds[self.zoneId] or self.parentZoneId
	local parentZoneId, parentZoneIndex, poiIndex, isValidPin = LibZone:GetZoneMapPinInfo(self.zoneId, preferedParentZoneId)
	
	local icon = "/esoui/art/icons/poi/poi_wayshrine_complete.dds"
	if parentZoneId then
		self.parentZoneId = parentZoneId
		self.parentZoneIndex = parentZoneIndex
	end
	
	if isValidPin then
		local startDescription, finishedDescription = select(3, GetPOIInfo(parentZoneIndex, poiIndex))

		if HasCompletedFastTravelNodePOI(self.zoneIndex) then
			self.pinDesc = finishedDescription
		else
			self.pinDesc = startDescription
		end
		
		icon = select(4, GetPOIMapInfo(parentZoneIndex, poiIndex))
		self.poiIndex = poiIndex
	end
	
	self.mapId = GetMapIdByZoneId(self.parentZoneId)
	self:UpdateIcon(icon)
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------

local Entry_Class_Zone = Entry_Class:Subclass()

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------

local Entry_Class_Dungeon = Entry_Class:Subclass()

function Entry_Class_Dungeon:GetSortOrder()
	return BMU.sortingByCategory[self.category]
end

function Entry_Class_Dungeon:GetHeader()
	if self.category ~= nil and self.category ~= 0 then
		local header = defaultHeaders[self.category]

		return header
	end
end

GetRecallCost()


function Entry_Class_Dungeon:TryToPort()
	onTryToPort(self.category, self.zoneId)
	if CanPlayerChangeGroupDifficulty() then
		jo_callLaterOnNextScene("IJA_BMU", function()
			ZO_Dialogs_ShowGamepadDialog("BMU_GAMEPAD_DUNGEON_TELEPORT_DIALOG", {targetData = self})
		end)
		return true
	elseif self.displayName and self.displayName ~= ''then
		BMU.PortalToPlayer(self.displayName, self.sourceIndexLeading, self.zoneName, self.zoneId, self.category, false, true, true)
		return true
	end
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------

local Entry_Class_Player = Entry_Class:Subclass()

function Entry_Class_Player:GetLabels()
	local name = BMU.colorizeText(self.displayName, self.textColorDisplayName)

	return name, self.zoneName
end

function Entry_Class_Player:GetIcon()
--	local icon = BMU.textures.wayshrineBtndd
	local icon
	if self.unitTag then
		if IsActiveWorldBattleground() then
			local battlegroundAlliance = GetUnitBattlegroundAlliance(self.unitTag)
			if battlegroundAlliance ~= BATTLEGROUND_ALLIANCE_NONE then
				icon = GetBattlegroundTeamIcon(battlegroundAlliance)
			end
		else
			local selectedRole = GetGroupMemberSelectedRole(self.unitTag)
			if selectedRole ~= LFG_ROLE_INVALID then
				icon = GetRoleIcon(selectedRole)
			end
		end
		
		self:ClearIcons()
		self:AddIcon(icon)
	else
	--	icon = Entry_Class.GetIcon(self)
	end

	return icon
end

function Entry_Class_Player:UpdateIcon(icon)
	if self.unitTag then
		if IsActiveWorldBattleground() then
			local battlegroundAlliance = GetUnitBattlegroundAlliance(self.unitTag)
			if battlegroundAlliance ~= BATTLEGROUND_ALLIANCE_NONE then
				icon = GetBattlegroundTeamIcon(battlegroundAlliance)
			end
		else
			local selectedRole = GetGroupMemberSelectedRole(self.unitTag)
			if selectedRole ~= LFG_ROLE_INVALID then
				icon = GetRoleIcon(selectedRole)
			end
		end
	end
	
	self:ClearIcons()
	self:AddIcon(icon)
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------

local Entry_Class_House = Entry_Class:Subclass()

function Entry_Class_House:GetLabels()
	local name = self.houseNameFormatted or self.zoneName

	return BMU.colorizeText(name, self.textColorZoneName), (self.parentZoneName or nil)
end

function Entry_Class_House:TryToPort()
	local collectibleData = getCollectibleData(self.collectibleId)
	if self.forceOutside then
		local TRAVEL_OUTSIDE = true
		RequestJumpToHouse(collectibleData:GetReferenceId(), TRAVEL_OUTSIDE)
	else
		jo_callLaterOnNextScene("IJA_BMU", function()
			ZO_Dialogs_ShowGamepadDialog("GAMEPAD_TRAVEL_TO_HOUSE_OPTIONS_DIALOG", collectibleData)
		end)
	end
	return true
end

function Entry_Class_House:GetHeader()
	return GetString(SI_ZONEDISPLAYTYPE8) -- Housing
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------

local Entry_Class_PortToFriend = Entry_Class_House:Subclass()

function Entry_Class_PortToFriend:GetLabels()
	local name = self.houseNameFormatted or self.zoneName
	return BMU.colorizeText(name, self.textColorZoneName), self.parentZoneName
end

do
	function numberFromString(str)
		local num = 0
		for character in str:gmatch"." do
			num = num + character:byte()
		end
		return num / 100
	end

	function Entry_Class_PortToFriend:GetSortOrder()
		local displayName = getDisplayNameFromAppended(self)
		if displayName == GetDisplayName() then
			return 0
		else
			return numberFromString(displayName)
		end
	end
end

function Entry_Class_PortToFriend:GetHeader()
	if self:GetSortOrder() == 0 then
		return GetString(SI_ZONEDISPLAYTYPE8) -- Housing
	end
	
	return zo_strformat(SI_HOUSING_INFORMATION_TRACKER_OWNER_NAME, getDisplayNameFromAppended(self))
end

function Entry_Class_PortToFriend:TryToPort()
	local displayName = getDisplayNameFromAppended(self)
	
	--[[
	if displayName == GetDisplayName() or displayName == '' then
		local referenceId = collectibleData:GetReferenceId()
		RequestJumpToHouse(self.houseId)
		return true
	else
		JumpToSpecificHouse(displayName, self.houseId)
	end
	]]

	PortToFriend.JumpToHouse(displayName, self.houseId)
	return true
end

--[[

	PortToFriend.JumpToHouse(displayName, self.houseId)
function PortToFriend.JumpToHouse(name, id)
	if name ~= nil and name ~= "" and id ~= nil and id > 0 then
		if name == GetDisplayName() or name == nil or zo_strtrim(name) == "" then
			RequestJumpToHouse(id)
		else
			JumpToSpecificHouse(name, id)
		end
	end
end



PortToFriend.JumpToHouse(name, id)
]]

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------

local Entry_Class_Items = Entry_Class:Subclass()

do
	local headers = {
		[1] = GetString(SI_ANTIQUITY_LEAD_TOOLTIP_TAG),
		[2] = GetString(SI_SPECIALIZEDITEMTYPE101),
		[3] = GetString(SI_SPECIALIZEDITEMTYPE100),
		[4] = GetString(SI_ITEM_SETS_BOOK_SEARCH_NO_MATCHES),
	}

	function Entry_Class_Items:GetHeader()
		local header = headers[self.sortOrder]

		return header
	end
end

function Entry_Class_Items:UpdateSortOrder()
	if self.countRelatedItems == 0 then return end
	local newSortOrder = 0
	local sortOrder = 4

	for k, itemData in pairs(self.relatedItems) do
		if itemData.antiquityId then
			sortOrder = 1
			break
		end
		local itemType, specializedItemType = GetItemType(itemData.bagId, itemData.slotIndex)
		if specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT then
			newSortOrder = 2
		end
		if specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP then
			newSortOrder = 3
		end

		if sortOrder > newSortOrder then
			sortOrder = newSortOrder
		end
	end

	if self.status == 0 then
		sortOrder = 4
	end

	self.sortOrder = sortOrder
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------

local Entry_Class_Quests = Entry_Class:Subclass()

function Entry_Class_Quests:GetSortOrder()
	-- prio (1: tracked quest, 2: related quests (with players), 3: unrelated quests (without players), 4: zoneless quests)
	return self.prio
end

function Entry_Class_Quests:UpdateSortOrder()
	self.sortOrder = self:GetSortOrder()
end

do
	local headers = {
		[1] = GetString(SI_RESTYLE_SHEET_HEADER), -- 'Active' Tracked
		[2] = 'Untracked', -- 'Untracked'
		[3] = GetString(SI_ITEM_SETS_BOOK_SEARCH_NO_MATCHES), -- unrelated untracked
		[4] = 'Zoneless', -- 'Zoneless'
	}

	function Entry_Class_Quests:GetHeader()
		local header = ''
		if self.prio then
			header = headers[self.prio]
		end

		return header
	end
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------

local Entry_Class_BMU = Entry_Class:Subclass()

function Entry_Class_BMU:GetLabels()
	return self.displayName, self.zoneName
end

function Entry_Class_BMU:IsBMUGuild()
	for _, guildId in pairs(BMU.var.BMUGuilds[GetWorldName()]) do
		if guildId == self.guildId then
			return true
		end
	end
end

function Entry_Class_BMU:GetSortOrder()
	local sortOrder = self:IsBMUGuild() and 0 or 1

	return sortOrder
end

function Entry_Class_BMU:UpdateEntryData(mostUsed)
end

do
	local headers = {
		[true] = "-- OFFICIAL GUILDS --",
		[false] = "-- PARTNER GUILDS --",
	}

	function Entry_Class_BMU:GetHeader()
		local header = headers[self.sortOrder == 0]

		return header
	end
end

---------------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------------

local CATEGORY_TYPE_MAP = {
	[CATEGORY_TYPE_ITEMS] = function(data) return Entry_Class_Items:New(data) end,
	[CATEGORY_TYPE_QUESTS] = function(data) return Entry_Class_Quests:New(data) end,
	[CATEGORY_TYPE_DISPLAYED] = function(data) return Entry_Class_Player:New(data) end,
	[CATEGORY_TYPE_BMU] = function(data) return Entry_Class_BMU:New(data) end,

	[CATEGORY_TYPE_DUNGEON] = function(data) return Entry_Class_Dungeon:New(data) end,
	[CATEGORY_TYPE_DELVE] = function(data) return Entry_Class_Dungeon:New(data) end,
	[CATEGORY_TYPE_PTF] = function(data) return Entry_Class_PortToFriend:New(data) end,
--[[

	[CATEGORY_TYPE_GROUP] = function(data) return Entry_Class_Player:New(data) end,
	[CATEGORY_TYPE_ALL] = function(data) return Entry_Class_Items:New(data) end,
	[CATEGORY_TYPE_OTHER] = function(data) return Entry_Class_Items:New(data) end,
]]

}

BMU_Gamepad_EntryData = {}


function BMU_Gamepad_EntryData:CreateNewEntry(data, sameZone)
	CURRENT_CATEGORY_TYPE = data.categoryType
	local setupFunction = CATEGORY_TYPE_MAP[CURRENT_CATEGORY_TYPE]
	
	if setupFunction and validateDisplayName(data.displayName) then
		return setupFunction(data)
	else
		if data.houseId then
			return Entry_Class_House:New(data)
		elseif data.isDungeon then
			return Entry_Class_Dungeon:New(data)
		elseif sameZone and validateDisplayName(data.displayName) then
			return Entry_Class_Player:New(data)
		end

		return Entry_Class_Zone:New(data)
	end
end
