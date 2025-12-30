local BMU = BMU --INS251229 Baertram Performancee gain, not searching _G for BMU each time again!

local teleporterVars = BMU.var --INS251229 Baertram

local SI = BMU.SI
local portalPlayers = {}
local TeleportAllPlayersTable = {}
local allZoneIds = {} -- stores the number of hits of a zoneId at index (allzoneIds[zoneId] = 1) | to know which zoneId is already added | to count the number of port options/alternatives

-- -v- INS251229 Baertram BEGIN 0
--Performance reference
----variables (defined now, as they were loaded before this file -> see manifest .txt)
--ZOs variables
local SM = SCENE_MANAGER
local worldName = GetWorldName()
local numberType = "number"
local stringType = "string"
local tableType = "table"
--Other addon variables
--BMU variables
local BMU_textures                          = BMU.textures
local subTypeClue = "clue"
----functions
--ZOs functions
local string = string
local string_sub = string.sub
local string_match = string.match
local string_lower = string.lower
local string_gsub = string.gsub
local zo_strformat = zo_strformat
local zo_plainstrfind = zo_plainstrfind
local table = table
local table_insert = table.insert
local table_remove = table.remove
local table_sort = table.sort
local GetItemId = GetItemId
local GetItemType = GetItemType
local GetItemName = GetItemName
local GetBagSize = GetBagSize
--BMU functions
local BMU_SI_get                            = SI.get
local BMU_colorizeText 						= BMU.colorizeText
local BMU_changeState 						= BMU.changeState
local BMU_isFavoriteZone 					= BMU.isFavoriteZone
local BMU_isFavoritePlayer 					= BMU.isFavoritePlayer

----variables (defined inline in code below, upon first usage, as they are still nil at this line)
--BMU functions
local BMU_getParentZoneId, BMU_getMapIndex, BMU_categorizeZone, BMU_getCurrentZoneId, BMU_isBlacklisted, BMU_checkOnceOnly,
	  BMU_has_value, BMU_has_value_special, BMU_getExistingEntry, BMU_removeExistingEntry, BMU_addInfo_1, BMU_addInfo_2,
	  BMU_filterAndDecide, BMU_sortByStringFindPosition, BMU_syncWithQuests, BMU_syncWithItems, BMU_numOfSurveyTypesChecked,
      BMU_getDataMapInfo, BMU_itemIsRelated, BMU_createZoneLessItemsInfo, BMU_createClickableZoneRecord, BMU_addItemInformation,
   	  BMU_addLeadInformation, BMU_cleanUnrelatedRecords, BMU_cleanUnrelatedRecords2, BMU_findExactQuestLocation, BMU_createNoResultsInfo,
      BMU_decidePrioDisplay, BMU_addNumberPlayers, BMU_getZoneGuideDiscoveryInfo
----functions (defined inline in code below, upon first usage, as they are still nil at this line)

--String text variables
--Lowercase constants for string comparisons
local surveyMapStrLower   = 		string_lower(BMU_SI_get(SI.CONSTANT_SURVEY_MAP))
local treasureMapStrLower = 		string_lower(BMU_SI_get(SI.CONSTANT_TREASURE_MAP))
-- -^- INS251229 Baertram END 0



-- format zone name and removes articles (if enabled)
function BMU.formatName(unformatted, flag)

	local formatted = ""

	if unformatted == nil or unformatted == "" then
		return formatted
	end

	if not flag then
		-- normal format
		formatted = zo_strformat("<<C:1>>", unformatted)
	else
		-- remove all articles
		if BMU.lang == "en" then
			if "The " == string_sub(unformatted, 1, 4) then
				-- remove "The " in the beginning
				formatted = string_sub(unformatted, 5)
			else
				-- no "The " to remove
				formatted = unformatted
			end

		elseif BMU.lang == "de" or BMU.lang == "fr" then
			if string_match(unformatted, ".*^") ~= nil then
				-- remove German and French articles
				formatted = string_match(unformatted, ".*^")
				-- and cut last character
				if formatted ~= nil then
					formatted = string_sub(formatted, 1, -2)
				else
					formatted = ""
				end
			else
				-- nothing to format (DE, FR)
				formatted = unformatted
			end

		else
			-- unsupported language -> use game format
			--formatted = zo_strformat("<<C:1>>", unformatted)
			formatted = unformatted
		end
	end

	return zo_strformat("<<C:1>>", formatted)
end
local BMU_formatName = BMU.formatName                                                      --INS251229 Baertram


-- zone where the player actual is
function BMU.getPlayersZoneId()
	local playersZoneIndex = GetUnitZoneIndex("player")
	local playersZoneId = GetZoneId(playersZoneIndex)

	return playersZoneId
end
local BMU_getPlayersZoneId = BMU.getPlayersZoneId


-- current / displayed zone depending on map status
function BMU.getCurrentZoneId()
	local currentZoneId = 0
	local playersZoneId = BMU_getPlayersZoneId()
	if SM:IsShowing("worldMap") or SM:IsShowing("gamepad_worldMap") then
		if DoesCurrentMapMatchMapForPlayerLocation() then
			-- if shown map is the map/zone of the player, take playersZoneId because it is more reliable (especially in delves, the parent zone is often returned as currentZoneId)
			currentZoneId = playersZoneId
		else
			currentZoneId = GetZoneId(GetCurrentMapZoneIndex()) -- get zone id of current / displayed zone
		end
	else
		-- if world map is not showing, take zone where the player is actual in (background: when you change the zone in the world map and you close, then this zone is still the last showing map)
		currentZoneId = playersZoneId
	end

	return currentZoneId
end
BMU_getCurrentZoneId = BMU.getCurrentZoneId


-- index: choose scenario / filter action -> see globals
-- inputString: search string
-- fZoneId: specific zoneId (favorite)
-- dontDisplay: flag if the result should be displayed in table (nil or false) or just return the result (true)
-- filterSourceIndex: specific sourceIndex
-- dontResetSlider: flag if the slider/scroll bar should not be reset (reset to top of the list)
-- noOwnHouses: flag if the owned houses shall not appear in result list
function BMU.createTable(args)
	-- -v- INS251229 Baertram Local reference updates for functions further down below in the file
	BMU_getMapIndex = BMU_getMapIndex or BMU.getMapIndex
	BMU_getParentZoneId = BMU_getParentZoneId or BMU.getParentZoneId
	BMU_checkOnceOnly = BMU_checkOnceOnly or BMU.checkOnceOnly
	BMU_has_value = BMU_has_value or BMU.has_value
	BMU_has_value_special = BMU_has_value_special or BMU.has_value_special
	BMU_addInfo_2 = BMU_addInfo_2 or BMU.addInfo_2
	BMU_filterAndDecide = BMU_filterAndDecide or BMU.filterAndDecide
	BMU_sortByStringFindPosition = BMU_sortByStringFindPosition or BMU.sortByStringFindPosition
	BMU_syncWithItems = BMU_syncWithItems or BMU.syncWithItems
	BMU_syncWithQuests = BMU_syncWithQuests or BMU.syncWithQuests
	BMU_createNoResultsInfo = BMU_createNoResultsInfo or BMU.createNoResultsInfo
	BMU_addNumberPlayers = BMU_addNumberPlayers or BMU.addNumberPlayers
	BMU_decidePrioDisplay = BMU_decidePrioDisplay or BMU.decidePrioDisplay
	local BMU_savedVarsAcc = BMU.savedVarsAcc
	-- -^- INS251229 Baertram

	local index = args.index or 0
	local inputString = args.inputString or ""
	local fZoneId = args.fZoneId
	local dontDisplay = args.dontDisplay or false
	local filterSourceIndex = args.filterSourceIndex
	local dontResetSlider = args.dontResetSlider or false
	local noOwnHouses = args.noOwnHouses or false

	-- simple checks
	if type(index) ~= numberType or (index == BMU.indexListSource and type(filterSourceIndex) ~= numberType) or (index == BMU.indexListZone and type(fZoneId) ~= numberType) then
		return
	end

	local startTime = GetGameTimeMilliseconds() -- get start time

	-- clear input fields
	if index ~= BMU.indexListSearchPlayer and index ~= BMU.indexListSearchZone then
		BMU.clearInputFields()
	end

	-- if filtering by name and inputString is empty -> same as everything
	if (index == BMU.indexListSearchPlayer or index == BMU.indexListSearchZone) and inputString == "" then
		index = BMU.indexListMain
	end

	-- print status (debug)
	BMU.printToChat("Refreshed - state: " .. tostring(index) .. " - String: " .. tostring(inputString), BMU.MSG_DB)

	-- change state for correct persistent MouseOver and for auto refresh
	if not dontDisplay then -- dont change when result should not be displayed in list
		BMU.changeState(index)
	end

	-- save SourceIndex in global variable
	if index == BMU.indexListSource then
		BMU.stateSourceIndex = filterSourceIndex
	end

	-- save ZoneId in global variable
	if index == BMU.indexListZone then
		BMU.stateZoneId = fZoneId
	end

	-- zone where the player actual is
	local playersZoneId = BMU.getPlayersZoneId() or 0
	-- current / displayed zone depending on map status
	local currentZoneId = BMU_getCurrentZoneId() or 0

	local TeleTotalFriends = GetNumFriends() -- number of friends
    local TeleTotalGuilds = GetNumGuilds() -- number of Guilds
    TeleportAllPlayersTable = {} -- clear result table
	--local currentZoneId = GetZoneId(GetCurrentMapZoneIndex()) -- get zone id of current zone
	allZoneIds = {} -- clear zoneId list (see BMU.checkOnceOnly)
	local consideredPlayers = {} -- contains at index displayName to track which player was already considered

	-- 1. go over all group members
	if IsPlayerInGroup(GetDisplayName()) then
		local groupUnitTag = ""
		for j = 1, GetGroupSize() do
			groupUnitTag = GetGroupUnitTagByIndex(j)
			local e = {}
			-- gathering information (and prefiltering of offline players and other invalid entries)
			if groupUnitTag ~= nil and GetUnitZoneIndex(groupUnitTag) ~= nil then
				e.displayName = GetUnitDisplayName(groupUnitTag)
				e.characterName = GetUnitName(groupUnitTag)
				e.online = IsUnitOnline(groupUnitTag)
				e.zoneName = GetUnitZone(groupUnitTag)
				e.zoneId = GetZoneId(GetUnitZoneIndex(groupUnitTag))
				e.level = GetUnitLevel(groupUnitTag)
				e.championRank = GetUnitChampionPoints(groupUnitTag)
				e.alliance = GetUnitAlliance(groupUnitTag)
				e.isLeader = IsUnitGroupLeader(groupUnitTag)
				e.groupMemberSameInstance = not IsGroupMemberInRemoteRegion(groupUnitTag)	-- IsGroupMemberInSameInstanceAsPlayer(groupUnitTag)
				-- to ping group members
				e.playerNameClickable = true
				e.groupUnitTag = groupUnitTag
			end

			-- first big layer of filtering, second layer is placed in seperate function (mainly offline players)
			-- consider only: other players ; online users ; valid zone names ; valid player names
			if e.displayName ~= GetDisplayName() and e.online and e.zoneName ~= nil and e.zoneName ~= "" and e.zoneId ~= nil and e.zoneId ~= 0 and e.displayName ~= "" then

				-- save displayName
				consideredPlayers[e.displayName] = true
				-- add bunch of information to the record
				e = BMU_addInfo_1(e, currentZoneId, playersZoneId, BMU.SOURCE_INDEX_GROUP)

				-- second big filter level
				if BMU_filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex) then
					-- add bunch of information to the record
					e = BMU_addInfo_2(e)
					-- insert into table
					table_insert(TeleportAllPlayersTable, e)
				end
			end
		end
	end


	-- 2. go over all friends
    for j = 1, TeleTotalFriends do
		-- gathering information
        local e = {}
        e.displayName, e.Note, e.status, e.secsSinceLogoff = GetFriendInfo(j)
        e.hasCharacter, e.characterName, e.zoneName, e.classType, e.alliance, e.level, e.championRank, e.zoneId = GetFriendCharacterInfo(j)

		-- first big layer of filtering, second layer is placed in seperate function
        -- consider only: other players ; online users (state 1,2,3) ; valid zone names ; valid player names
		if e.displayName ~= GetDisplayName() and e.status ~= 4 and e.zoneName ~= nil and e.zoneName ~= "" and e.zoneId ~= nil and e.zoneId ~= 0 and e.displayName ~= "" and not consideredPlayers[e.displayName] then

			-- save displayName
			consideredPlayers[e.displayName] = true
			-- do some formating stuff
			e = BMU_addInfo_1(e, currentZoneId, playersZoneId, BMU.SOURCE_INDEX_FRIEND)

			-- second big filter level
			if BMU_filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex) then
				-- add bunch of information to the record
				e = BMU_addInfo_2(e)
				-- insert into table
				table_insert(TeleportAllPlayersTable, e)
			end
		end
	end


	-- 3. go over all Guild members
    for i = 1, TeleTotalGuilds do
        local totalGuildMembers = GetNumGuildMembers(GetGuildId(i))

        for j = 1, totalGuildMembers do
			-- gathering information
            local e = {}
            e.displayName, e.Note, e.GuildMemberRankIndex, e.status, e.secsSinceLogoff = GetGuildMemberInfo(GetGuildId(i), j)
            e.hasCharacter, e.characterName, e.zoneName, e.classType, e.alliance, e.level, e.championRank, e.zoneId = GetGuildMemberCharacterInfo(GetGuildId(i), j)
			e.guildIndex = i

			-- first big layer of filtering, second layer is placed in seperate function
            -- consider only: other players ; online users (state 1,2,3) ; valid zone names ; valid player names
			if e.displayName ~= GetDisplayName() and e.status ~= 4 and e.zoneName ~= nil and e.zoneName ~= "" and e.zoneId ~= nil and e.zoneId ~= 0 and e.displayName ~= "" and not consideredPlayers[e.displayName] then
				-- save displayName
				consideredPlayers[e.displayName] = true
				-- do some formating stuff
				e = BMU_addInfo_1(e, currentZoneId, playersZoneId, BMU.SOURCE_INDEX_GUILD[i])

				-- second big filter level
				if BMU_filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex) then
					-- add bunch of information to the record
					e = BMU_addInfo_2(e)
					-- insert into table
					table_insert(TeleportAllPlayersTable, e)
				end
			end
		end
	end

	if not BMU_savedVarsAcc.hideOwnHouses and not noOwnHouses then
		-- 4. go over own houses
		-- player can port outside own houses -> check own houses and add parent zone entries if not already in list
		for _, house in pairs(COLLECTIONS_BOOK_SINGLETON:GetOwnedHouses()) do
			local houseZoneId = GetHouseZoneId(house.houseId)
			local mapIndex = BMU_getMapIndex(houseZoneId)
			local parentZoneId = BMU.getParentZoneId(houseZoneId)
			-- check if parent zone not already in result list
			---if not allZoneIds[parentZoneId] then
			local e = {}
			-- add infos
			e.parentZoneId = parentZoneId
			e.parentZoneName = BMU_formatName(GetZoneNameById(e.parentZoneId))
			e.zoneId = e.parentZoneId
			e.displayName = ""
			e.houseId = house.houseId
			e.isOwnHouse = true
			-- add flag to port outside the house
			e.forceOutside = true
			e.zoneName = GetZoneNameById(e.zoneId)
			e.houseNameUnformatted = GetZoneNameById(houseZoneId)
			e.houseNameFormatted = BMU_formatName(e.houseNameUnformatted)
			e.collectibleId = GetCollectibleIdForHouse(e.houseId)
			e.nickName = BMU_formatName(GetCollectibleNickname(e.collectibleId))
			e.houseTooltip = {e.houseNameFormatted, "\"" .. e.nickName .. "\""}

			e = BMU_addInfo_1(e, currentZoneId, playersZoneId, "")
			if BMU_filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex) then
				e = BMU_addInfo_2(e)
				-- overwrite
				e.mapIndex = BMU_getMapIndex(houseZoneId)
				e.parentZoneId = BMU.getParentZoneId(houseZoneId)
				-- add manually
				--allZoneIds[e.zoneId] = allZoneIds[e.zoneId] + 1
				table_insert(TeleportAllPlayersTable, e)
			end
		end
	end

	if BMU_savedVarsAcc.showZonesWithoutPlayers2 or index == BMU.indexListSearchZone then
		-- 5. add all overland zones without players
		for overlandZoneId, _ in pairs(BMU.overlandDelvesPublicDungeons) do
			local e = {}
			e.zoneId = overlandZoneId
			e.displayName = ""
			e.zoneName = GetZoneNameById(overlandZoneId)
			e.zoneWithoutPlayer = true
			e = BMU_addInfo_1(e, currentZoneId, playersZoneId, "")
			if BMU_filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex) then
				e = BMU_addInfo_2(e)
				e.textColorDisplayName = "red"
				e.textColorZoneName = "red"
				table_insert(TeleportAllPlayersTable, e)
			end
		end
	end

	portalPlayers = TeleportAllPlayersTable

	-- display number of hits (port alternatives)
	-- not needed in case of only current zone and favorite zoneId
	if BMU_savedVarsAcc.showNumberPlayers and not (index == BMU.indexListCurrentZone or index == BMU.indexListZoneHidden or index == BMU.indexListZone) then
		portalPlayers = BMU_addNumberPlayers(portalPlayers)
	end

	if index == BMU.indexListItems then
		-- related items
		portalPlayers = BMU_syncWithItems(portalPlayers) -- returns already sorted list
	elseif index == BMU.indexListQuests then
		-- related quests
		portalPlayers = BMU_syncWithQuests(portalPlayers) -- returns already sorted list
	elseif index == BMU.indexListSearchPlayer then
		-- search by player name
		-- sort by string match position (displayName and characterName)
		portalPlayers = BMU_sortByStringFindPosition(portalPlayers, inputString, "displayName", "characterName")
	elseif index == BMU.indexListSearchZone then
		-- search by zone name
		-- sort by string match position (zoneName, zoneNameSecondLanguage)
		portalPlayers = BMU_sortByStringFindPosition(portalPlayers, inputString, "zoneName", "zoneNameSecondLanguage")
	else
		-- SORTING
		if BMU.savedVarsChar.sorting == 2 then
			-- sort by prio, category, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- category
				if BMU.sortingByCategory[a.category] ~= BMU.sortingByCategory[b.category] then
					return BMU.sortingByCategory[a.category] < BMU.sortingByCategory[b.category]
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU.savedVarsChar.sorting == 3 then
			-- sort by prio, most used, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- most used
				local num1 = BMU_savedVarsAcc.portCounterPerZone[a.zoneId] or 0
				local num2 = BMU_savedVarsAcc.portCounterPerZone[b.zoneId] or 0
				if num1 ~= num2 then
					return num1 > num2
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU.savedVarsChar.sorting == 4 then
			-- sort by prio, most used, category, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- most used
				local num1 = BMU_savedVarsAcc.portCounterPerZone[a.zoneId] or 0
				local num2 = BMU_savedVarsAcc.portCounterPerZone[b.zoneId] or 0
				if num1 ~= num2 then
					return num1 > num2
				end
				-- category
				if BMU.sortingByCategory[a.category] ~= BMU.sortingByCategory[b.category] then
					return BMU.sortingByCategory[a.category] < BMU.sortingByCategory[b.category]
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU.savedVarsChar.sorting == 5 then
			-- sort by prio, number players, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- number players
				local numP1 = a.numberPlayers or 1
				local numP2 = b.numberPlayers or 1
				if numP1 ~= numP2 then
					return numP1 > numP2
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU.savedVarsChar.sorting == 6 then
			-- sort by prio, number of undiscovered wayshrines, zone category, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- number of undiscovered wayshrines
				if not (a.zoneWayshrineTotal == nil and b.zoneWayshrineTotal == nil) then
					if a.zoneWayshrineTotal ~= nil and b.zoneWayshrineTotal == nil then
						return true
					elseif a.zoneWayshrineTotal == nil and b.zoneWayshrineTotal ~= nil then
						return false
					elseif (a.zoneWayshrineTotal - a.zoneWayshrineDiscovered) ~= (b.zoneWayshrineTotal - b.zoneWayshrineDiscovered) then
						return (a.zoneWayshrineTotal - a.zoneWayshrineDiscovered) > (b.zoneWayshrineTotal - b.zoneWayshrineDiscovered)
					end
				end
				-- category
				if BMU.sortingByCategory[a.category] ~= BMU.sortingByCategory[b.category] then
					return BMU.sortingByCategory[a.category] < BMU.sortingByCategory[b.category]
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU.savedVarsChar.sorting == 7 then
			-- sort by prio, number of undiscovered skyshards, zone category, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- number of undiscovered skyshards
				if not (a.zoneSkyshardTotal == nil and b.zoneSkyshardTotal == nil) then
					if a.zoneSkyshardTotal ~= nil and b.zoneSkyshardTotal == nil then
						return true
					elseif a.zoneSkyshardTotal == nil and b.zoneSkyshardTotal ~= nil then
						return false
					elseif (a.zoneSkyshardTotal - a.zoneSkyshardDiscovered) ~= (b.zoneSkyshardTotal - b.zoneSkyshardDiscovered) then
						return (a.zoneSkyshardTotal - a.zoneSkyshardDiscovered) > (b.zoneSkyshardTotal - b.zoneSkyshardDiscovered)
					end
				end
				-- category
				if BMU.sortingByCategory[a.category] ~= BMU.sortingByCategory[b.category] then
					return BMU.sortingByCategory[a.category] < BMU.sortingByCategory[b.category]
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU.savedVarsChar.sorting == 8 then
			-- sort by prio, last used, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- last used
				local pos1 = BMU_has_value(BMU_savedVarsAcc.lastPortedZones, a.zoneId) or 99
				local pos2 = BMU_has_value(BMU_savedVarsAcc.lastPortedZones, b.zoneId) or 99
				if pos1 ~= pos2 then
					return pos1 < pos2
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU.savedVarsChar.sorting == 9 then
			-- sort by prio, last used, category, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- last used
				local pos1 = BMU_has_value(BMU_savedVarsAcc.lastPortedZones, a.zoneId) or 99
				local pos2 = BMU_has_value(BMU_savedVarsAcc.lastPortedZones, b.zoneId) or 99
				if pos1 ~= pos2 then
					return pos1 < pos2
				end
				-- category
				if BMU.sortingByCategory[a.category] ~= BMU.sortingByCategory[b.category] then
					return BMU.sortingByCategory[a.category] < BMU.sortingByCategory[b.category]
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU.savedVarsChar.sorting == 10 then
			-- sort by prio, number of missing set items, category, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- missing set items
				local numUnlocked1, numTotal1, _ = BMU.getNumSetCollectionProgressPieces(a.zoneId, a.category, a.parentZoneId)
				local numUnlocked2, numTotal2, _ = BMU.getNumSetCollectionProgressPieces(b.zoneId, b.category, b.parentZoneId)
				if (numUnlocked1 and numTotal1) or (numUnlocked2 and numTotal2) then
					-- if at least one side
					if (numUnlocked1 and numTotal1) and not (numUnlocked2 and numTotal2) then
						-- only a
						return true
					elseif not (numUnlocked1 and numTotal1) and (numUnlocked2 and numTotal2) then
						-- only b
						return false
					elseif (numTotal1-numUnlocked1) ~= (numTotal2-numUnlocked2) then
						-- a and b
						return (numTotal1-numUnlocked1) > (numTotal2-numUnlocked2)
					end
				end
				-- category
				if BMU.sortingByCategory[a.category] ~= BMU.sortingByCategory[b.category] then
					return BMU.sortingByCategory[a.category] < BMU.sortingByCategory[b.category]
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		elseif BMU.savedVarsChar.sorting == 11 then
			-- sort by prio, category, zones without players, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- category
				if BMU.sortingByCategory[a.category] ~= BMU.sortingByCategory[b.category] then
					return BMU.sortingByCategory[a.category] < BMU.sortingByCategory[b.category]
				end
				-- zones without players
				if not a.zoneWithoutPlayer and b.zoneWithoutPlayer then
					return true
				elseif a.zoneWithoutPlayer and not b.zoneWithoutPlayer then
					return false
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)

		else -- BMU.savedVarsChar.sorting == 1
			-- sort by prio, zoneName, prio by source
			table_sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU_decidePrioDisplay(a, b)
			end)
		end
	end

	-- in case of no results, add message with information
	if #portalPlayers == 0 then
		table_insert(portalPlayers, BMU_createNoResultsInfo())
	end

	-- get end time and print runtime in milliseconds (debug)
	BMU.printToChat("RunTime: " .. (GetGameTimeMilliseconds() - startTime) .. " ms", BMU.MSG_DB)

	-- display or return result
	if dontDisplay == true then
		return portalPlayers
	else
		BMU.TeleporterList:add_messages(portalPlayers, dontResetSlider)
		if index == BMU.indexListItems and BMU.savedVarsChar.displayCounterPanel then
			-- update counter panel for related items
			BMU.updateRelatedItemsCounterPanel()
		end
	end
end


function BMU.getIndexFromValue(myTable, v)
	for index, value in ipairs(myTable) do
		--d("V: " .. value .. " ** v: " .. v)
		if value == v then
			return index
		end
	end
	return 99 -- special case, just return high value (low priority for houses), SORRY
end


-- adds first bunch of information which are necessary for filterAndDecide
function BMU.addInfo_1(e, currentZoneId, playersZoneId, sourceIndexLeading)
	e.zoneNameUnformatted = e.zoneName
	-- format zone name
	e.zoneName = BMU_formatName(e.zoneName, BMU.savedVarsAcc.formatZoneName)

	-- check if zone == current displayed zone
	if currentZoneId == e.zoneId then
		e.currentZone = true
	else
		e.currentZone = false
	end

	-- exepction handling for combined Overview-Map (Fargrave + The Shambles)
	-- both zones are current zone
	if GetCurrentMapZoneIndex() == 854 then
		local _, subzone = select(3,(GetMapTileTexture()):lower():find("maps/([%w%-]+)/([%w%-]+_[%w%-]+)"))
		if subzone == "u32_fargravezone" and (e.zoneId == 1282 or e.zoneId == 1283) then
			e.currentZone = true
		end
	end

	-- check if zone == players zone
	if playersZoneId == e.zoneId then
		e.playersZone = true
	else
		e.playersZone = false
	end

	-- add second zone name
	e.zoneNameSecondLanguage = BMU.getZoneNameSecondLanguage(e.zoneId)

	if e.displayName ~= "" and e.displayName ~= nil then
		-- format character name
		e.characterName = e.characterName:gsub("%^.*x$", "")

		-- gather sources, sourcesText and set sourceIndexLeading (see globals BMU.SOURCE_INDEX)
		e.sourcesText = {} -- contains strings ("Guild", "Friend", ...)
		e.sources = {} -- contains all source indicies while sourceIndexLeading is the leading (first one)
		e.sourceIndexLeading = sourceIndexLeading -- first source where the player was found

		-- is in Group?
		if sourceIndexLeading == BMU.SOURCE_INDEX_GROUP then
			table_insert(e.sources, BMU.SOURCE_INDEX_GROUP)
			table_insert(e.sourcesText, BMU_colorizeText(GetString(SI_GAMEPAD_CAMPAIGN_BROWSER_TOOLTIP_GROUP_MEMBERS), "orange"))
		end

		-- is Friend?
		if sourceIndexLeading == BMU.SOURCE_INDEX_FRIEND or IsFriend(e.displayName) then
			table_insert(e.sources, BMU.SOURCE_INDEX_FRIEND)
			table_insert(e.sourcesText, BMU_colorizeText(GetString(SI_GAMEPAD_CAMPAIGN_BROWSER_TOOLTIP_FRIENDS), "green"))
		end

		-- is in Guild?
		local numGuilds = GetNumGuilds()
		for i = 1, numGuilds do
			local guildId = GetGuildId(i)
			if GetGuildMemberIndexFromDisplayName(guildId, e.displayName) ~= nil then
				table_insert(e.sources, BMU.SOURCE_INDEX_GUILD[i])
				table_insert(e.sourcesText, BMU_colorizeText(GetGuildName(guildId), "white"))
			end
		end
	end

	return e
end
BMU_addInfo_1 = BMU.addInfo_1				--INS251229 Baertram


-- adds second bunch of information after filterAndDecide
function BMU.addInfo_2(e)
	-- -v- INS251229 Baertram local references to functions defined later in this file
	BMU_getMapIndex = BMU_getMapIndex or BMU.getMapIndex
	BMU_getParentZoneId = BMU_getParentZoneId or BMU.getParentZoneId
	BMU_categorizeZone = BMU_categorizeZone or BMU.categorizeZone
	BMU_getZoneGuideDiscoveryInfo = BMU_getZoneGuideDiscoveryInfo or BMU.getZoneGuideDiscoveryInfo
	-- -^- INS251229 Baertram

	-- inititialize more values
	e.relatedItems = {}
	e.relatedItemsTypes = {}
	e.relatedQuests = {}
	e.countRelatedItems = 0
	e.relatedQuestsSlotIndex = {}
	e.countRelatedQuests = 0

	-- valid entry / show zone on click
	e.zoneNameClickable = true

	-- format alliance name
	if e.alliance ~= nil then
		e.allianceName = BMU_formatName(GetAllianceName(e.alliance), false)
	end

	-- add wayshrine discovery info (for zone tooltip)
	e.zoneWayhsrineDiscoveryInfo, e.zoneWayshrineDiscovered, e.zoneWayshrineTotal = BMU_getZoneGuideDiscoveryInfo(e.zoneId, ZONE_COMPLETION_TYPE_WAYSHRINES)
	-- add skyshard discovery info (for zone tooltip)
	e.zoneSkyshardDiscoveryInfo, e.zoneSkyshardDiscovered, e.zoneSkyshardTotal = BMU_getZoneGuideDiscoveryInfo(e.zoneId, ZONE_COMPLETION_TYPE_SKYSHARDS)
	-- add public dungeon completeness info (for zone tooltip)
	-- e.zonePublicDungeonDiscoveryInfo, e.zonePublicDungeonDiscovered, e.zonePublicDungeonTotal = BMU_getZoneGuideDiscoveryInfo(e.zoneId, ZONE_COMPLETION_TYPE_PUBLIC_DUNGEONS)
	-- add delve completeness info (for zone tooltip)
	-- e.zoneDelveDiscoveryInfo, e.zoneDelveDiscovered, e.zoneDelveTotal = BMU_getZoneGuideDiscoveryInfo(e.zoneId, ZONE_COMPLETION_TYPE_DELVES)

	-- categorize zone
	e.category = BMU_categorizeZone(e.zoneId)
	e.parentZoneId = BMU_getParentZoneId(e.zoneId)
	e.parentZoneName = BMU_formatName(GetZoneNameById(e.parentZoneId))
	-- get parent map index and zoneId (for map opening)
	e.mapIndex = BMU_getMapIndex(e.zoneId)

	-- check public dungeon achievement / skill point
	if e.category == BMU.ZONE_CATEGORY_OVERLAND then
		-- overland zone --> show completion of all public dungeons in the zone
		e.publicDungeonAchiementInfo = BMU.createPublicDungeonAchiementInfo(e.zoneId)
	elseif e.category == BMU.ZONE_CATEGORY_PUBDUNGEON then
		-- specific public dungeon --> show completion of itself
		e.publicDungeonAchiementInfo = BMU.createPublicDungeonAchiementInfo(e.parentZoneId, e.zoneId)
	end

	-- add set collection information
	e.setCollectionProgress = BMU.getSetCollectionProgressString(e.zoneId, e.category, e.parentZoneId)

	-- set colors
	if e.sourceIndexLeading == BMU.SOURCE_INDEX_GROUP then
		e.textColorDisplayName = "orange"
		e.textColorZoneName = "orange"
	elseif e.playersZone then
		e.textColorDisplayName = "blue"
		e.textColorZoneName = "blue"
	elseif e.sourceIndexLeading == BMU.SOURCE_INDEX_FRIEND then
		e.textColorDisplayName = "green"
		e.textColorZoneName = "green"
	else
		e.textColorDisplayName = "white"
		e.textColorZoneName = "white"
	end

	--set prio
	local currentZoneId = GetZoneId(GetCurrentMapZoneIndex())
	if BMU.savedVarsAcc.currentViewedZoneAlwaysTop and (BMU.getParentZoneId(e.zoneId) == currentZoneId or e.zoneId == currentZoneId or e.zoneId == BMU_getParentZoneId(currentZoneId)) then
		-- current viewed zone + subzones
		e.prio = 0
		e.textColorZoneName = "teal"
	elseif BMU.savedVarsAcc.currentZoneAlwaysTop and e.playersZone then
		-- current zone (players location)
		e.prio = 1
	elseif e.sourceIndexLeading == BMU.SOURCE_INDEX_GROUP and e.isLeader then
		-- group leader
		e.prio = 2
	elseif e.sourceIndexLeading == BMU.SOURCE_INDEX_GROUP and (e.category == BMU.ZONE_CATEGORY_GRPDUNGEON or e.category == BMU.ZONE_CATEGORY_TRAIL or e.category == BMU.ZONE_CATEGORY_GRPZONES or e.category == BMU.ZONE_CATEGORY_GRPARENA or e.category == BMU.ZONE_CATEGORY_ENDLESSD) then
		-- group member is in 4 men Group Dungeons | 12 men Raids (Trials) | Group Zones | Group Arenas | Endless Dungeons
		e.prio = 3
	elseif BMU.isFavoritePlayer(e.displayName) and BMU.isFavoriteZone(e.zoneId) then
		-- favorite player + favorite zone
		e.prio = 4
		e.textColorDisplayName = "gold"
		e.textColorZoneName = "gold"
	elseif BMU.isFavoritePlayer(e.displayName) then
		-- favorite player
		e.prio = 5
		e.textColorDisplayName = "gold"
	elseif BMU.isFavoriteZone(e.zoneId) then
		-- favorite zone
		-- set sub-prio by slot number
		local favSlot = BMU.isFavoriteZone(e.zoneId)
		e.prio = 6 + (0.01 * favSlot)
		e.textColorZoneName = "gold"
	else
		e.prio = 7
	end

	return e
end
BMU_addInfo_2 = BMU.addInfo_2


-- create tooltip text info about public dungeon achievement completion (group event / skill point)
function BMU.createPublicDungeonAchiementInfo(overlandZoneId, onlyPublicDungeonZoneId)
	local info = {}
	if BMU.overlandDelvesPublicDungeons[overlandZoneId] and BMU.overlandDelvesPublicDungeons[overlandZoneId].publicDungeonsAchievements then
		-- only for a specific public dungeon
		if onlyPublicDungeonZoneId then
			local publicDungeonAchvText = BMU.getColorizedPublicDungeonAchievementText(overlandZoneId, onlyPublicDungeonZoneId)
			if publicDungeonAchvText then
				table_insert(info, publicDungeonAchvText)
			end

		-- for all public dungeons of the zone
		else
			for publicDungeonZoneId, _ in pairs(BMU.overlandDelvesPublicDungeons[overlandZoneId].publicDungeonsAchievements) do
				local publicDungeonAchvText = BMU.getColorizedPublicDungeonAchievementText(overlandZoneId, publicDungeonZoneId)
				if publicDungeonAchvText then
					table_insert(info, publicDungeonAchvText)
				end
			end
		end

		-- add header and return info
		if #info > 0 then
			table_insert(info, 1, GetString(SI_LEVEL_UP_REWARDS_SKILL_POINT_TOOLTIP_HEADER) .. " (" .. BMU_SI_get(SI.TELE_UI_GROUP_EVENT) .. "):")
			return info
		end
	end
end

-- generate colorized text for a specific public dungeon (group event / skill point)
function BMU.getColorizedPublicDungeonAchievementText(overlandZoneId, publicDungeonZoneId)
	local achievmentId = BMU.overlandDelvesPublicDungeons[overlandZoneId].publicDungeonsAchievements[publicDungeonZoneId]
	if achievmentId then
		-- local name, _, _, _, completed, _, _ = GetAchievementInfo(achievmentId)
		local completed = IsAchievementComplete(achievmentId)
		if completed then
			return BMU.textures.acceptGreen .. "  " .. BMU_formatName(GetZoneNameById(publicDungeonZoneId))
		else
			return BMU.textures.declineRed .. "  " .. BMU_formatName(GetZoneNameById(publicDungeonZoneId))
		end
	end
end


-- add alternative zone name (second language) if feature active (see translation array)
function BMU.getZoneNameSecondLanguage(zoneId)
	-- check if enabled
	if BMU.savedVarsAcc.secondLanguage ~= 1 then
		local language = BMU.dropdownSecLangChoices[BMU.savedVarsAcc.secondLanguage]
		local localizedZoneIdData = BMU.LibZoneGivenZoneData[language]
		if localizedZoneIdData == nil then return nil end
		local localizedZoneName = localizedZoneIdData[zoneId]
		if localizedZoneName == nil or type(localizedZoneName) ~= stringType then return nil end

		return localizedZoneName
	else
		return nil
	end
end


-- returns numUnlocked, numTotal of set collection progress of the zone + working zoneId
-- tries to retreive values from parent zone as alternative (onlyin case of delves and pub. dungeons)
function BMU.getNumSetCollectionProgressPieces(zoneId, category, parentZoneId)
	local numUnlocked = nil
	local numTotal = nil
	local workingZoneId = nil

	if BMU.LibSets and BMU.LibSets.GetNumItemSetCollectionZoneUnlockedPieces then
		-- catch possible exceptions | pcall returns false if function call fails, otherwise true
		if pcall(function() BMU.LibSets.GetNumItemSetCollectionZoneUnlockedPieces(zoneId) end) then
			numUnlocked, numTotal = BMU.LibSets.GetNumItemSetCollectionZoneUnlockedPieces(zoneId)
			workingZoneId = zoneId
		end

		if not (numUnlocked and numTotal) and (category == BMU.ZONE_CATEGORY_DELVE or category == BMU.ZONE_CATEGORY_PUBDUNGEON) and parentZoneId then
			-- catch possible exceptions | pcall returns false if function call fails, otherwise true
			if pcall(function() BMU.LibSets.GetNumItemSetCollectionZoneUnlockedPieces(parentZoneId) end) then
				numUnlocked, numTotal = BMU.LibSets.GetNumItemSetCollectionZoneUnlockedPieces(parentZoneId)
				workingZoneId = parentZoneId
			end
		end
	end

	return numUnlocked, numTotal, workingZoneId
end


-- return string for set collection progress for given zoneId
function BMU.getSetCollectionProgressString(zoneId, category, parentZoneId)
	local numUnlocked, numTotal, workingZoneId = BMU.getNumSetCollectionProgressPieces(zoneId, category, parentZoneId)
	if numUnlocked and numTotal then
		local progressString = string.format("%d/%d", numUnlocked, numTotal)
		if numUnlocked == numTotal then
			-- colorize string
			progressString = BMU_colorizeText(progressString, "green")
		end
		return GetString(SI_ITEM_SET_SUMMARY_ITEM_COUNT_LABEL) .. ": " .. progressString
	end
end


-- try to find map index by game or by own exceptions
function BMU.getMapIndex(zoneId)
	-- get map index by API (overland zones which are listed in the map list)
	local mapIndex = GetMapIndexByZoneId(zoneId)

	-- if zone is not a overland zone
	if mapIndex == nil then
		mapIndex = GetMapIndexByZoneId(BMU_getParentZoneId(zoneId))
	end

	-- in case the parent zone is also a sub zone (e.g. Asylum Sanctorium is in Brass Fortress is in Clockwork City)
	if mapIndex == nil then
		mapIndex = GetMapIndexByZoneId(BMU_getParentZoneId(BMU_getParentZoneId(zoneId)))
	end

	return mapIndex -- mapIndex can be nil
end
BMU_getMapIndex = BMU.getMapIndex                                                      --INS251229 Baertram


function BMU.filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex)
	-- do filtering and decide
	local BMU_savedVarsAcc = BMU.savedVarsAcc 														--INS251229 Baertram
	BMU_isBlacklisted = BMU_isBlacklisted or BMU.isBlacklisted										--INS251229 Baertram
	BMU_checkOnceOnly = BMU_checkOnceOnly or BMU.checkOnceOnly  	                           		--INS251229 Baertram
	BMU_has_value = BMU_has_value or BMU.has_value                                 					--INS251229 Baertram

	-- try to fix "-" issue
	if inputString ~= nil then
		inputString = string_gsub(inputString, "-", "--")
	end

	-- only own zone
	if index == BMU.indexListCurrentZone then
		-- only add records of the current (displayed) zone (and ensure that a record without player (dark red) is only added if there is no other record -> see BMU_checkOnceOnly())
		-- OR if displayed zone is not overland and zone is parent of current zone (e.g. to see the parent overland zone in the list if the player is in a delve)
		if (e.currentZone and BMU_checkOnceOnly(false, e)) or (BMU_categorizeZone(currentZoneId) ~= BMU.ZONE_CATEGORY_OVERLAND and e.zoneId == BMU_getParentZoneId(currentZoneId) and BMU_checkOnceOnly(true, e)) then
			return true
		end

	-- filter by player name
	elseif index == BMU.indexListSearchPlayer then
		if (string_match(string_lower(e.displayName), string_lower(inputString)) or (BMU_savedVarsAcc.searchCharacterNames and string_match(string_lower(e.characterName), string_lower(inputString)))) then -- and not BMU_isBlacklisted(e.zoneId, e.sourceIndexLeading, BMU_savedVarsAcc.onlyMaps) and BMU_checkOnceOnly(BMU_savedVarsAcc.zoneOnceOnly, e)
			return true
		end

	-- filter by zone name
	elseif index == BMU.indexListSearchZone then
		if (string_match(string_lower(e.zoneName), string_lower(inputString)) or (BMU_savedVarsAcc.secondLanguage ~= 1 and string_match(string_lower(e.zoneNameSecondLanguage), string_lower(inputString)))) and not BMU_isBlacklisted(e.zoneId, e.sourceIndexLeading, BMU_savedVarsAcc.onlyMaps) and BMU_checkOnceOnly(BMU_savedVarsAcc.zoneOnceOnly, e) then
			return true
		end

	-- search for related items
	elseif index == BMU.indexListItems then
		if not BMU_isBlacklisted(e.zoneId, e.sourceIndexLeading, BMU_savedVarsAcc.onlyMaps) and BMU_checkOnceOnly(true, e) then
			return true
		end

	-- only Delves and Public Dungeons (in your own Zone or globally)
	elseif index == BMU.indexListDelves then
		if BMU.savedVarsChar.showAllDelves then
			-- add all delves and public dungeons
			-- zone is delve or public dungeon + not blacklisted + add only once to list
			local zoneCategory = BMU_categorizeZone(e.zoneId)
			if (zoneCategory == BMU.ZONE_CATEGORY_DELVE or zoneCategory == BMU.ZONE_CATEGORY_PUBDUNGEON) and not BMU_isBlacklisted(e.zoneId, e.sourceIndexLeading, false) and BMU_checkOnceOnly(BMU_savedVarsAcc.zoneOnceOnly, e) then
				return true
			end
		else
			-- add delves and public dungeons only from current zone
			-- always use parent zone which is the same, when player is in e.g. overland zone
			-- check if parent zone has delves or public dungeons + zone is in the delves list of the parent zone OR zone is in the public dungeon list of the parent zone + not blacklisted + add only once to list
			if BMU.overlandDelvesPublicDungeons[BMU_getParentZoneId(currentZoneId)] and (BMU.isWhitelisted(BMU.overlandDelvesPublicDungeons[BMU_getParentZoneId(currentZoneId)].delves, e.zoneId, false) or BMU.isWhitelisted(BMU.overlandDelvesPublicDungeons[BMU_getParentZoneId(currentZoneId)].publicDungeons, e.zoneId, false)) and not BMU_isBlacklisted(e.zoneId, e.sourceIndexLeading, false) and BMU_checkOnceOnly(BMU_savedVarsAcc.zoneOnceOnly, e) then
				return true
			end
		end

	-- looking for specific zone id (favorites, no state change)
	-- looking for specific zone id (displaying, state change)
	elseif index == BMU.indexListZoneHidden or index == BMU.indexListZone then
		-- only one entry is needed for favorite search, but this function is also used to get ALL players for a specific zone
		if e.zoneId == fZoneId and BMU_checkOnceOnly(false, e) then
			return true
		end

	-- looking for specific sourceIndex
	elseif index == BMU.indexListSource then
		-- add only player with given sourceIndex
		if BMU_has_value(e.sources, filterSourceIndex) then
			return true
		end

	-- add all / no filters (index == BMU.indexListMain)
	else
		if (not BMU_isBlacklisted(e.zoneId, e.sourceIndexLeading, BMU_savedVarsAcc.onlyMaps) or BMU.isFavoritePlayer(e.displayName)) and BMU_checkOnceOnly(BMU_savedVarsAcc.zoneOnceOnly, e) then
			return true
		end
	end

	return false
end
BMU_filterAndDecide = BMU.filterAndDecide 								--INS251229 Baertram


-- check against blacklist
function BMU.isBlacklisted(zoneId, sourceIndex, onlyMaps)

	-- use hard filter (like whitelist) if active
	if onlyMaps then
		-- only check the indecies!
		if BMU.isWhitelisted(BMU.overlandDelvesPublicDungeons, zoneId, true) then
			return false
		else
			-- seperate filtering, if group member (whitelisting)
			if sourceIndex == BMU.SOURCE_INDEX_GROUP then
				--return true
				return not BMU.isWhitelisted(BMU.whitelistGroupMembers, zoneId, false)
			end
			return true
		end
	end


	-- use filtering by game if filter is active (in addition)
	if BMU.savedVarsAcc.hideOthers then
		if not CanJumpToPlayerInZone(zoneId) then
			return true
		end
	end

	if BMU.blacklist[zoneId] then
		-- separate filtering, if group member (whitelisting)
		if sourceIndex == BMU.SOURCE_INDEX_GROUP then
			--return true
			return not BMU.isWhitelisted(BMU.whitelistGroupMembers, zoneId, false)
		end
		return true
	else
		return false
	end

end
BMU_isBlacklisted = BMU.isBlacklisted


-- check against whitelist
function BMU.isWhitelisted(whitelist, zoneId, flag)
	if whitelist == nil then
		-- no whitelist for this zone
		return false
	end

	if not flag then
		-- normal search in a list (search for value)
		if BMU_has_value(whitelist, zoneId) then
			return true
		else
			return false
		end
	else
		-- special search (search for index)
		if BMU.has_value_special(whitelist, zoneId) then
			return true
		else
			return false
		end
	end
end


-- search for a value
function BMU.has_value(tab, val)
	if type(tab) == tableType then
		for index, value in pairs(tab) do
			if value == val then
				return index
			end
		end
	end
    return false
end
BMU_has_value = BMU.has_value


-- search for a index
function BMU.has_value_special(tab, val)
	if type(tab) == tableType then
		for index, value in pairs(tab) do
			if index == val then
				return true
			end
		end
	end
    return false
end
BMU_has_value_special = BMU.has_value_special

-- re-order a table randomly
function BMU.shuffle_table(tbl)
	for i = #tbl, 2, -1 do
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl
end


-- find lowest number in a table
function BMU.getLowestNumber(tab)
	local low = math.huge
	local index
	for i, v in pairs(tab) do
		if v < low then
			low = v
			index = i
		end
	end
	return low
end


-- checks if "only one entry per zone" is enabled
-- increments counter according to case
-- returns if the record can be used
function BMU.checkOnceOnly(activ, record)
	-- -v- INS251229 Baertram local reference updates for functions further down in this file
	BMU_has_value = BMU_has_value or BMU.has_value
	BMU_getExistingEntry = BMU_getExistingEntry or BMU.getExistingEntry
	BMU_removeExistingEntry = BMU_removeExistingEntry or BMU.removeExistingEntry
	BMU_decidePrioDisplay = BMU_decidePrioDisplay or BMU.decidePrioDisplay
	-- -^- INS251229 Baertram

	-- in general: dont add a record without player (dark red) if there is already another record for this zone
	if allZoneIds[record.zoneId] and record.zoneWithoutPlayer then
		return false
	end

	if activ then
		if not allZoneIds[record.zoneId] then
			-- zone is not added yet
			-- initialize counter
			allZoneIds[record.zoneId] = 1
			return true
		elseif BMU.isFavoritePlayer(record.displayName) then
			-- zone already added, but player is favorite
			-- clean existing entry (when existing one is not favorite and not group member)
			BMU_removeExistingEntry(record.zoneId)
			-- increment counter
			allZoneIds[record.zoneId] = allZoneIds[record.zoneId] + 1
			return true
		elseif (record.isOwnHouse and BMU_getExistingEntry(record.zoneId).isOwnHouse) and BMU_has_value(BMU.savedVarsServ.zoneSpecificHouses, record.houseId) then
			-- zone already added, compare house with house
			-- house has higher prio because it is a preferred house
			-- clean existing entry and use this house instead
			BMU_removeExistingEntry(record.zoneId)
			-- increment counter
			allZoneIds[record.zoneId] = allZoneIds[record.zoneId] + 1
			return true
		elseif (record.isOwnHouse and BMU_getExistingEntry(record.zoneId).isOwnHouse) and BMU_has_value(BMU.savedVarsServ.zoneSpecificHouses, BMU_getExistingEntry(record.zoneId).houseId) then
			-- zone already added, compare house with house
			-- existing record (house) is preferred house, so it has to stay (dont check further cases)
			-- increment counter
			allZoneIds[record.zoneId] = allZoneIds[record.zoneId] + 1
			return false
		elseif BMU_decidePrioDisplay(record, BMU.getExistingEntry(record.zoneId)) then -- returns true, if first record is preferred
			-- zone already added, but prio is higher
			-- clean existing entry (when existing one is not favorite and not group member)
			BMU_removeExistingEntry(record.zoneId)
			-- increment counter
			allZoneIds[record.zoneId] = allZoneIds[record.zoneId] + 1
			return true
		else
			-- zone already added
			-- increment counter
			allZoneIds[record.zoneId] = allZoneIds[record.zoneId] + 1
			return false
		end
	else
		if not allZoneIds[record.zoneId] then
			-- zone is not added yet
			-- initialize counter
			allZoneIds[record.zoneId] = 1
		else
			-- increment counter
			allZoneIds[record.zoneId] = allZoneIds[record.zoneId] + 1
		end
		return true
	end
end


-- categorize zone and set category index
function BMU.categorizeZone(zoneId)
	-- just check against hashmap category list
	local value = BMU.CategoryMap[zoneId]

	if value ~= nil then
		return value									-- category index
	else
		return BMU.ZONE_CATEGORY_UNKNOWN			-- category index (unknown)
	end
end
BMU_categorizeZone = BMU.categorizeZone


-- connect survey and treasure maps from bags to port options and zones
--CHG251229 Baertram Removed local functions from within function BMU.syncWithItems below, so they do not get gedefined & created on each function call of BMU.syncWithItems! -> memory and performance gain
-- local function to identify the item as survey or treasure map (check itemType and custom mapping as backup)
local function isSurveyMap(itemName, specializedItemType)
	return (specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT or string_match(string_lower(itemName), surveyMapStrLower)) --CHG251229 Baertram Defined local lower string variables at the top so they aren't rechecked and build expensively on eac string comparison again and again and ...
end
local function isTreasureMap(itemName, specializedItemType)
	return (specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP or string_match(string_lower(itemName), treasureMapStrLower)) --CHG251229 Baertram Defined local lower string variables at the top so they aren't rechecked and build expensively on eac string comparison again and again and ...
end
local function isClueMap(itemId, specializedItemType)
	local subType, _ = BMU.getDataMapInfo(itemId)
	return (specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_TRIBUTE_CLUE or subType == subTypeClue) --CHG251229 Baertram Defined local string variable at the top so they aren't redefined on each string comparison again and again and ...
end
-- local function check if the map type (coming from BMU.treasureAndSurveyMaps) is enabled by the user
local function isSubtypeEnabled(subType)
	return BMU.savedVarsChar.displayMaps[subType] or false
end
function BMU.syncWithItems(p_portalPlayers)															--CHG251229 Baertram Renamed param portalPlayers: Shadows the in line 6 defined table portalPlayers with same name!
	BMU_numOfSurveyTypesChecked = BMU_numOfSurveyTypesChecked or BMU.numOfSurveyTypesChecked 		--INS251229 Baertram
	BMU_getDataMapInfo = BMU_getDataMapInfo or BMU.getDataMapInfo 									--INS251229 Baertram
	BMU_itemIsRelated = BMU_itemIsRelated or BMU.itemIsRelated	 									--INS251229 Baertram
	BMU_createClickableZoneRecord = BMU_createClickableZoneRecord or BMU.createClickableZoneRecord  --INS251229 Baertram
	BMU_createZoneLessItemsInfo = BMU_createZoneLessItemsInfo or BMU.createZoneLessItemsInfo  		--INS251229 Baertram
	BMU_addItemInformation = BMU_addItemInformation or BMU.addItemInformation						--INS251229 Baertram
	BMU_addLeadInformation = BMU_addLeadInformation or BMU.addLeadInformation						--INS251229 Baertram
	BMU_cleanUnrelatedRecords = BMU_cleanUnrelatedRecords or BMU.cleanUnrelatedRecords				--INS251229 Baertram
	local BMU_savedVarsChar = BMU.savedVarsChar 													--INS251229 Baertram

	local newTable ={}
	local unrelatedItemsRecords = {}
	local zonelessRecord = nil

	local bags = {BAG_BACKPACK}
	if BMU_savedVarsChar.scanBankForMaps then
		table_insert(bags, BAG_BANK)
		table_insert(bags, BAG_SUBSCRIBER_BANK)
	end

	-- go over all bags
	for _, bagId in ipairs(bags) do
		local lastSlot = GetBagSize(bagId)
		for slotIndex = 0, lastSlot, 1 do
			local itemName = GetItemName(bagId, slotIndex)
			local itemType, specializedItemType = GetItemType(bagId, slotIndex)
			local itemId = GetItemId(bagId, slotIndex)
			-- filter for relevant items and consider active option
			if (BMU_savedVarsChar.displayMaps.treasure and isTreasureMap(itemName, specializedItemType)) or (BMU_numOfSurveyTypesChecked() > 0 and isSurveyMap(itemName, specializedItemType)) or (BMU_savedVarsChar.displayMaps.clue and isClueMap(itemId, specializedItemType)) then
				-- determine subType and itemZoneId from global list
				local subType, itemZoneId = BMU_getDataMapInfo(itemId)
				if subType then
					-- filter valid subTypes
					if isSubtypeEnabled(subType) then
						-- create item data
						-- check if item is related to an entry in portalPlayers table (player can port to this location) and get updated record in portalPlayers table
						local isRelated, updatedRecord, recordIndex = BMU_itemIsRelated(p_portalPlayers, bagId, slotIndex, itemZoneId)
						if isRelated then
							-- item is related and connected to an entry in portalPlayers table
							-- update record in portalPlayers
							p_portalPlayers[recordIndex] = updatedRecord
						else
							-- item cannot be assigned to an entry in portalPlayers table
							-- but we know the item's zone from global list
							-- check if a record for the zone already exists
							local record = unrelatedItemsRecords[itemZoneId]
							if not record then
								-- create new record
								record = BMU_createClickableZoneRecord(itemZoneId)
							end
							-- add item to the record
							record = BMU_addItemInformation(record, bagId, slotIndex)
							-- save updated record
							unrelatedItemsRecords[itemZoneId] = record
						end
					end
				else
					-- could not determine subType and itemZoneId
					-- nevertheless we consider this item because of the beginning statement
					-- check if zoneless info record already exists
					if not zonelessRecord then
						-- create new zoneless info record
						zonelessRecord = BMU_createZoneLessItemsInfo()
					end
					-- add item data to record
					zonelessRecord = BMU_addItemInformation(zonelessRecord, bagId, slotIndex)
				end
			end
		end
	end

	if BMU_savedVarsChar.displayAntiquityLeads.scried or BMU_savedVarsChar.displayAntiquityLeads.srcyable then
		-- seperately: go over all leads and add them to "portalPlayers" and "unrelatedItemsRecords"
		local antiquityId = GetNextAntiquityId()
		while antiquityId do
			if DoesAntiquityHaveLead(antiquityId) then
				local zoneId = GetAntiquityZoneId(antiquityId)
				local achievedGoals = GetNumGoalsAchievedForAntiquity(antiquityId)
					-- leads that are already scried (at least one "achieved goal" in lead scry progress)
				if ((BMU_savedVarsChar.displayAntiquityLeads.scried and achievedGoals > 0)
					or
					-- leads that are are scryable (no progress)
					(BMU_savedVarsChar.displayAntiquityLeads.srcyable and achievedGoals == 0))
					and
					-- include or filter completed leads (codex)
					(BMU_savedVarsChar.displayAntiquityLeads.completed or GetNumAntiquityLoreEntries(antiquityId) ~= GetNumAntiquityLoreEntriesAcquired(antiquityId))
				then
					-- check if lead can be matched to an entry in portalPlayers table
					local isRelated, updatedRecord, recordIndex = BMU.leadIsRelated(p_portalPlayers, antiquityId)
					if isRelated then
						-- lead is related and connected to an entry in portalPlayers table
						-- update record in portalPlayers
						p_portalPlayers[recordIndex] = updatedRecord
					else
						-- lead cannot be assigned to an entry in portalPlayers table
						-- check if a record for the zone already exists
						local record = unrelatedItemsRecords[zoneId]
						if not record then
							-- create new record
							record = BMU_createClickableZoneRecord(zoneId)
						end
						-- add lead to the record
						record = BMU_addLeadInformation(record, antiquityId)
						-- save record
						unrelatedItemsRecords[zoneId] = record
					end
				end
			end
			antiquityId = GetNextAntiquityId(antiquityId)
		end
	end


	-- clean portalPlayers table from entries without assigned items
	newTable = BMU_cleanUnrelatedRecords(p_portalPlayers)

	-- sort table by number of items and by name
	table_sort(newTable, function(a, b)
			if a.countRelatedItems ~= b.countRelatedItems then
				return a.countRelatedItems > b.countRelatedItems
			end
			return a.zoneName < b.zoneName
		end)

	-- sort records with unrelated items (maps without port possibility)
	table_sort(unrelatedItemsRecords, function(a, b)
			if a.countRelatedItems ~= b.countRelatedItems then
				return a.countRelatedItems > b.countRelatedItems
			end
			return a.zoneName < b.zoneName
		end)

	-- add them to the final table
	for zoneId, record in pairs(unrelatedItemsRecords) do
		table_insert(newTable, record)
	end

	-- add info with zoneless items
	if zonelessRecord then
		table_insert(newTable, zonelessRecord)
	end

	return newTable
end
BMU_syncWithItems = BMU_syncWithItems or BMU.syncWithItems  		--INS251229 Baertram


-- try to find a record that matches with item's zone and update record
function BMU.itemIsRelated(p_portalPlayers, bagId, slotIndex, itemZoneId)							--CHG251229 Baertram Renamed param portalPlayers: Shadows the in line 6 defined table portalPlayers with same name!
	BMU_addItemInformation = BMU_addItemInformation or BMU.addItemInformation						--INS251229 Baertram
	local itemName = GetItemName(bagId, slotIndex)
	local itemId = GetItemId(bagId, slotIndex)

	-- go over all records in portalPlayers
	for index, record in ipairs(p_portalPlayers) do
		-- only check overland maps & Cyrodiil
		if record.category == BMU.ZONE_CATEGORY_OVERLAND or record.zoneId == 181 then
			-- try to match with zone
			if record.zoneId == itemZoneId then
				return true, BMU_addItemInformation(record, bagId, slotIndex), index
			end
		end
	end
	return false, nil, nil
end
BMU_itemIsRelated = BMU.itemIsRelated --INS251229 Baertram


-- check if a lead is related to a zone in given table
function BMU.leadIsRelated(p_portalPlayers, antiquityId)											--CHG251229 Baertram Renamed param portalPlayers: Shadows the in line 6 defined table portalPlayers with same name!
	BMU_addLeadInformation = BMU_addLeadInformation or BMU.addLeadInformation						--INS251229 Baertram
	-- go over all records in portalPlayers
	for index, record in ipairs(p_portalPlayers) do
		-- only check overland maps
		if record.category == BMU.ZONE_CATEGORY_OVERLAND then
			-- try to match lead with zone
			if GetAntiquityZoneId(antiquityId) == record.zoneId then
				return true, BMU_addLeadInformation(record, antiquityId), index
			end
		end
	end

	return false, nil, nil
end


-- add item information to an existing record
function BMU.addItemInformation(record, bagId, slotIndex)
	--local itemCount = GetItemTotalCount(bagId, slotIndex)
	local icon, itemCount, sellPrice, meetsUsageRequirement, locked, equipType, itemStyle, quality = GetItemInfo(bagId, slotIndex)
	local isInInventory = true
	local color = GetItemQualityColor(quality)
	local itemName = color:Colorize(BMU_formatName(GetItemName(bagId, slotIndex), false))
	local itemTooltip = itemName
	local itemId = GetItemId(bagId, slotIndex)
	local itemType, _ = BMU.getDataMapInfo(itemId)

	if itemCount > 1 then
		-- change item name (add itemCount of this item)
		itemTooltip = itemTooltip .. BMU_colorizeText(" (" .. itemCount .. ")", "white")
	end

	if bagId ~= BAG_BACKPACK then
		-- coloring if item is not in inventory
		itemTooltip = BMU_colorizeText(GetString(SI_CURRENCYLOCATION1) .. ": ", "gray") .. itemTooltip
		isInInventory = false
		if #record.relatedItems == 0 then
			record.textColorZoneName = "gray"
		end
	end

	--create and add new item to record
	local itemData = {}
	itemData.itemName = itemName
	itemData.itemTooltip = itemTooltip -- just to have the possibility of showing something different in the tooltip
	itemData.itemCount = itemCount
	itemData.bagId = bagId
	itemData.slotIndex = slotIndex
	itemData.isInInventory = isInInventory

	table_insert(record.relatedItems, itemData)

	-- update counter in record
	record.countRelatedItems = record.countRelatedItems + itemCount

	-- add item type to record (treasure/survey map)
	if not BMU_has_value(record.relatedItemsTypes, itemType) then
		table_insert(record.relatedItemsTypes, itemType)
	end

	return record
end
BMU_addItemInformation = BMU.addItemInformation --INS251229 Baertram


-- add lead information to an existing record
function BMU.addLeadInformation(record, antiquityId)
	local quality = GetAntiquityQuality(antiquityId)
	local color = GetAntiquityQualityColor(quality)

	local leadtimeleft = GetAntiquityLeadTimeRemainingSeconds(antiquityId)
	if leadtimeleft == 0 then
		-- some timers go back to 0 -> just display ususal timer 33 days
		leadtimeleft = 2851200
	end

	local numEntries = GetNumAntiquityLoreEntries(antiquityId)
	local numEntriesAcquired = GetNumAntiquityLoreEntriesAcquired(antiquityId)

	local aName = color:Colorize(ZO_CachedStrFormat("<<C:1>>",GetAntiquityName(antiquityId)))
	local aTooltip = color:Colorize(ZO_CachedStrFormat("<<C:1>>",GetAntiquityName(antiquityId))) .. "\n" ..
					BMU_colorizeText(string.format(BMU_SI_get(SI.TELE_UI_DAYS_LEFT), math.floor(leadtimeleft/86400)) .. "\n" ..
					zo_strformat(SI_ANTIQUITY_CODEX_ENTRIES_FOUND, numEntriesAcquired, numEntries), "gray")

	--create and add new item to record
	local leadData = {}
	leadData.itemName = aName
	leadData.itemTooltip = aTooltip
	leadData.itemCount = 1
	leadData.bagId = -1
	leadData.slotIndex = 0
	leadData.isInInventory = true
	leadData.antiquityId = antiquityId
	leadData.numEntries = numEntries
	leadData.numEntriesAcquired = numEntriesAcquired

	table_insert(record.relatedItems, leadData)

	-- update counter in record
	record.countRelatedItems = record.countRelatedItems + 1

	-- add lead type to record
	if not BMU_has_value(record.relatedItemsTypes, "leads") then
		table_insert(record.relatedItemsTypes, "leads")
	end

	return record
end
BMU_addLeadInformation = BMU.addLeadInformation --INS251229 Baertram


-- remove all records which have no related items
function BMU.cleanUnrelatedRecords(p_portalPlayers)													--CHG251229 Baertram Renamed param portalPlayers: Shadows the in line 6 defined table portalPlayers with same name!
	local newTable = {}

	-- go over all records in portalPlayers
	for index, record in ipairs(p_portalPlayers) do
		if #record.relatedItems > 0 then
			table_insert(newTable, record)
		end
	end

	return newTable
end
BMU_cleanUnrelatedRecords = BMU.cleanUnrelatedRecords --INS251229 Baertram


-- create record for a concret (clickable) zone
-- e.g. for items which are connected to a zone but without port possibilities
-- e.g. overland zones that matches to a search string but without port possibilities
function BMU.createClickableZoneRecord(zoneId, currentZoneId, playersZondeId, sourceIndex)
	BMU_addInfo_1 = BMU_addInfo_1 or BMU.addInfo_1						        					--INS251229 Baertram
	BMU_addInfo_2 = BMU_addInfo_2 or BMU.addInfo_2        											--INS251229 Baertram
	-- create a new record
	local record = BMU.createBlankRecord()
	record.zoneId = zoneId
	record.zoneName = BMU_formatName(GetZoneNameById(zoneId), BMU.savedVarsAcc.formatZoneName)
	record = BMU_addInfo_1(record, currentZoneId, playersZondeId, sourceIndex)
	record = BMU_addInfo_2(record)
	record.textColorDisplayName = "red"
	record.textColorZoneName = "red"
	return record
end
BMU_createClickableZoneRecord = BMU.createClickableZoneRecord --INS251229 Baertram


-- create record for items which could not be assigned to any zone
function BMU.createZoneLessItemsInfo()
	local info = BMU.createBlankRecord()
	info.zoneName = BMU_SI_get(SI.TELE_UI_UNRELATED_ITEMS)
	info.textColorDisplayName = "gray"
	info.textColorZoneName = "gray"
	info.zoneNameClickable = false -- show Tamriel on click

	return info
end
BMU_createZoneLessItemsInfo = BMU.createZoneLessItemsInfo --INS251229 Baertram


-- try to match zone to matchStr
-- return true if match with zone else return false
local specialZoneNameMatches = teleporterVars.specialZoneNameMatches --INS251229 Baertram
function BMU.tryMatchZoneToMatchStr(matchStr, zoneId)
	if matchStr == nil or matchStr == "" or zoneId == nil or zoneId == "" then
		return false
	end

	-- get zone name by game without articles !
	local zoneName = BMU_formatName(GetZoneNameById(zoneId), true)

	if zoneName == nil or zoneName == "" then
		return false
	end

	-- "-" issue:
	zoneName = string_gsub(zoneName, "-", "--")

	-- -v- --INS251229 Baertram Use table to loop (defined in BMU.var.specialZoneNameMatches, already containing the lowercase strings of the special zone names)
	--and also defining local variables with lowercase for the zoneName and matchString as else it will be redone on each if elseif again and again -> Performance gain
	-- try to match
		-- handle "Alik'r desert" exception
	--[[
	if (string_match(string_lower(matchStr), string_lower("Alik'r")) and string_match(string_lower(zoneName), string_lower("Alik'r")))
		-- handle "Morneroc" expception (FR)
		or (string_match(string_lower(matchStr), string_lower("Morneroc")) and string_match(string_lower(zoneName), string_lower("Morneroc")))
		-- hanlde "Bleakrock" expception (EN)
		or (string_match(string_lower(matchStr), string_lower("Bleakrock")) and string_match(string_lower(zoneName), string_lower("Bleakrock")))
		-- handle "Wrothgar - Orsinium" exception (EN, FR, DE)
		or (string_match(string_lower(matchStr), string_lower("Orsinium")) and string_match(string_lower(zoneName), string_lower("Wrothgar")))
		-- handle "Greymoor Kaverns" exception (DE)
		or (string_match(string_lower(matchStr), string_lower("Graumoorkaverne")) and string_match(string_lower(zoneName), string_lower("Graumoorkaverne")))
		-- handle "Greymoor Kaverns" exception (FR)
		or (string_match(string_lower(matchStr), string_lower("Griselande")) and string_match(string_lower(zoneName), string_lower("Griselande")))
		-- normal match
		or (string_match(string_lower(matchStr), string_lower(zoneName))) then
			return true
	else
			return false
	end
	]]

	--Match string
	local matchStringLower = string_lower(matchStr)
	--ZoneName
	local zoneNameLower = string_lower(zoneName)

	--ZoneName matches the matchString? Not using string.match anymore as this is plain text search, and no pattern search (more expensive)
	if zo_plainstrfind(matchStringLower, zoneNameLower) then
		return true
	else
		--No, so do special checks (more expensive string comparison)
		for specialMatchString, specialZoneName in pairs(specialZoneNameMatches) do
			--if the zoneName is the same as the matchString (table's key), it will be shown as ""
			if specialZoneName == "" then specialZoneName = specialMatchString end
			if zo_plainstrfind(matchStringLower, specialMatchString) and zo_plainstrfind(zoneNameLower, specialZoneName) then
				return true
			end
		end
		--no match
		return false
	end
	-- -^ --INS251229 Baertram
end


-- connect quests with found zones
function BMU.syncWithQuests(p_portalPlayers)														--CHG251229 Baertram Renamed param portalPlayers: Shadows the in line 6 defined table portalPlayers with same name!
	BMU_cleanUnrelatedRecords2 = BMU_cleanUnrelatedRecords2 or BMU.cleanUnrelatedRecords2			--INS251229 Baertram
-- go over all active quests
-- for each quest go over all portalPlayers entries and find the zone
	-- if found add the information and break/go to next quest
	-- else add the quest to unrelated quest table
	local newTable ={}
	local unRelatedQuests = {}

	-- go over all quest slotIndices
	for slotIndex = 1, GetNumJournalQuests() do
		local isRelated, updatedRecord, recordIndex = BMU.questIsRelated(p_portalPlayers, slotIndex) -- check if quest is related to entry in portalPlayers table and return new record and its index
		if isRelated then
			-- quest is related and connected to an entry in portalPlayers table
			-- update record in result table
			p_portalPlayers[recordIndex] = updatedRecord
		else
			-- quest is not related to an entry -> save slotIndex for UnRelatedQuestInfo
			table_insert(unRelatedQuests, slotIndex)
		end
	end

	-- clean result table from zones without related quests
	newTable = BMU_cleanUnrelatedRecords2(p_portalPlayers)

	-- create table of records of unrelated quests with their zones (maybe empty) & returns list of zoneless quests
	local unrelatedQuestsRecords, zoneLessQuests = BMU.createUnrelatedQuestsRecords(unRelatedQuests)
	if next(unrelatedQuestsRecords) ~= nil then
		for _, record in pairs(unrelatedQuestsRecords) do
			table_insert(newTable, record)
		end
	end

	-- are there any zoneless quests?
	if next(zoneLessQuests) ~= nil then
		-- create entry for zoneless quests (maybe empty)
		local zoneLessQuestsRecord = BMU.createZoneLessQuestsInfo(zoneLessQuests)
		if next(zoneLessQuestsRecord) ~= nil then
			table_insert(newTable, zoneLessQuestsRecord)
		end
	end

	-- sort table
	table_sort(newTable, function(a, b)
		-- prio (1: tracked quest, 2: related quests (with players), 3: unrelated quests (without players), 4: zoneless quests)
		if a.prio ~= b.prio then
			return a.prio < b.prio
		else
		-- zoneName
			return a.zoneName < b.zoneName
		end
	end)

	-- set flag, that quest location data cache was updated
	BMU.questDataChanged = false

	return newTable
end


-- remove all records which have no related quests
function BMU.cleanUnrelatedRecords2(p_portalPlayers)												--CHG251229 Baertram Renamed param portalPlayers: Shadows the in line 6 defined table portalPlayers with same name!
	local newTable = {}

	-- go over all records in portalPlayers
	for index, record in ipairs(p_portalPlayers) do
		if record.countRelatedQuests > 0 then
			table_insert(newTable, record)
		end
	end

	return newTable
end
BMU_cleanUnrelatedRecords2 = BMU.cleanUnrelatedRecords2				--INS251229 Baertram


-- creates table of records with quests and their zones (zone without players)
function BMU.createUnrelatedQuestsRecords(unRelatedQuests)
	BMU_findExactQuestLocation = BMU_findExactQuestLocation or BMU.findExactQuestLocation 			--INS251229 Baertram
	local unrelatedQuestsRecords = {}
	local zoneLessQuests = {}

	for _, slotIndex in ipairs(unRelatedQuests) do
		--local questName = GetJournalQuestName(slotIndex)
		local questName, _, _, _, _, _, tracked = GetJournalQuestInfo(slotIndex)
		local questZoneName, objectiveName, questZoneIndex, poiIndex = GetJournalQuestLocationInfo(slotIndex)
		local questZoneId = GetZoneId(questZoneIndex)
		if questZoneId ~= 0 then
			-- get exact quest location
			questZoneId = BMU_findExactQuestLocation(slotIndex)
		end
		local questRepeatType = GetJournalQuestRepeatType(slotIndex)

		if tracked then
			questName =  BMU_colorizeText(questName, "gold")
		elseif questRepeatType == 1 or questRepeatType == 2 then
		-- color repeatable quests (1,2: repeatable quest | 0: not repeatable)
			questName = BMU_colorizeText(questName, "teal")
		end

		if questZoneId == 0 then
			-- zoneless quest
			table_insert(zoneLessQuests, slotIndex)
		else
			if unrelatedQuestsRecords[questZoneId] == nil then
				-- create a new record
				local record = BMU_createClickableZoneRecord(questZoneId)
				-- set color and prio
				if tracked then
					record.prio = 1
					record.textColorZoneName = "gold"
				else
					record.prio = 3
					record.textColorZoneName = "red"
				end
				record.countRelatedQuests = 1
				-- add quest name
				table_insert(record.relatedQuests, questName)
				-- add questIndex for quest map ping
				table_insert(record.relatedQuestsSlotIndex, slotIndex)
				unrelatedQuestsRecords[questZoneId] = record
			else
				-- add quest to already existing record
				local record = unrelatedQuestsRecords[questZoneId]
				-- increment counter
				record.countRelatedQuests = record.countRelatedQuests + 1
				-- add quest name to relatedList
				table_insert(record.relatedQuests, questName)
				-- add questIndex for quest map ping
				table_insert(record.relatedQuestsSlotIndex, slotIndex)
				-- set color and prio
				if tracked then
					record.prio = 1
					record.textColorZoneName = "gold"
				end
				-- update record
				unrelatedQuestsRecords[questZoneId] = record
			end
		end
	end
	return unrelatedQuestsRecords, zoneLessQuests
end


-- create message with all zoneless quests
function BMU.createZoneLessQuestsInfo(zoneLessQuests)
	local info = BMU.createBlankRecord()
	info.zoneName = BMU_SI_get(SI.TELE_UI_UNRELATED_QUESTS)
	--info.textColorDisplayName = "gray"
	info.textColorZoneName = "gray"
	info.prio = 4
	info.zoneNameClickable = false

	-- go over all zoneless quests
	for _, slotIndex in ipairs(zoneLessQuests) do
		--local questName = GetJournalQuestName(slotIndex)
		local questName, _, _, _, _, _, tracked = GetJournalQuestInfo(slotIndex)
		local questRepeatType = GetJournalQuestRepeatType(slotIndex)
		if tracked then
			questName =  BMU_colorizeText(questName, "gold")
		elseif questRepeatType == 1 or questRepeatType == 2 then
		-- color repeatable quests (1,2: repeatable quest | 0: not repeatable)
			questName = BMU_colorizeText(questName, "teal")
		end
		-- increment counter
		info.countRelatedQuests = info.countRelatedQuests + 1
		-- add quest name to relatedList
		table_insert(info.relatedQuests, questName)
		-- add questIndex for quest map ping
		table_insert(info.relatedQuestsSlotIndex, slotIndex)
		-- change color of record if contains tracked quest
		if tracked then
			info.textColorZoneName = "gold"
		end
	end

	return info
end


-- check if a quest is related to an entry of the portalPlayers table and return the new record
function BMU.questIsRelated(p_portalPlayers, slotIndex)												--CHG251229 Baertram Renamed param portalPlayers: Shadows the in line 6 defined table portalPlayers with same name!
	BMU_findExactQuestLocation = BMU_findExactQuestLocation or BMU.findExactQuestLocation 			--INS251229 Baertram
	--local questName = GetJournalQuestName(slotIndex)
	local questName, _, _, _, _, _, tracked = GetJournalQuestInfo(slotIndex)
	local zoneName, objectiveName, questZoneIndex, poiIndex = GetJournalQuestLocationInfo(slotIndex)
	local questZoneId = GetZoneId(questZoneIndex)
	if questZoneId ~= 0 then
		-- get exact quest location
		questZoneId = BMU_findExactQuestLocation(slotIndex)
	end
	local questRepeatType = GetJournalQuestRepeatType(slotIndex)

	if tracked then
		questName = BMU_colorizeText(questName, "gold")
	elseif questRepeatType == 1 or questRepeatType == 2 then
	-- color repeatable quests (1,2: repeatable quest | 0: not repeatable)
		questName = BMU_colorizeText(questName, "teal")
	end

	-- go over all records in portalPlayers
	for index, record in ipairs(p_portalPlayers) do
		if record.zoneId == questZoneId then
			-- add quest name to record
			table_insert(record.relatedQuests, questName)
			-- add questIndex for quest map ping
			table_insert(record.relatedQuestsSlotIndex, slotIndex)
			-- increment quest counter
			record.countRelatedQuests = record.countRelatedQuests + 1
			-- set color and prio
			if tracked then
				record.prio = 1
				record.textColorZoneName = "gold"
			elseif record.countRelatedQuests == 1 then
			-- set prio and color only for "new" records to not override the tracked marker
				record.prio = 2
				record.textColorZoneName = "white"
			end
			return true, record, index
		end
	end

	return false, nil, nil
end

local grayText = "gray"  --INS251229 Baertram
function BMU.createNoResultsInfo()
	local info = BMU.createBlankRecord()
	info.zoneName = GetString(SI_ITEM_SETS_BOOK_SEARCH_NO_MATCHES)
	info.textColorDisplayName = grayText	--CHG251229 Baertram
	info.textColorZoneName = grayText		--CHG251229 Baertram
	info.zoneNameClickable = false -- show Tamriel on click
	return info
end
BMU_createNoResultsInfo = BMU.createNoResultsInfo  --INS251229 Baertram


-- removes an existing entry (already added zoneId) from table (TeleportAllPlayersTable) if it is not a player favorite or group member
function BMU.removeExistingEntry(zoneId)
	for index, record in pairs(TeleportAllPlayersTable) do
		if record.zoneId == zoneId and not BMU.isFavoritePlayer(record.displayName) and record.sourceIndexLeading ~= BMU.SOURCE_INDEX_GROUP then
			table_remove(TeleportAllPlayersTable, index)
		end
	end
end
BMU_removeExistingEntry = BMU.removeExistingEntry  					--INS251229 Baertram



-- returns the record from table (TeleportAllPlayersTable) located at given zoneId
function BMU.getExistingEntry(zoneId)
	for index, record in pairs(TeleportAllPlayersTable) do
		if record.zoneId == zoneId then
			return record
		end
	end
	d("NOT FOUND: " .. zoneId)
end
BMU_getExistingEntry = BMU.getExistingEntry							--INS251229 Baertram


-- returns true if the first record is preferred
-- return false if the second record is preferred
function BMU.decidePrioDisplay(record1, record2)
	if record1.isLeader and not record2.isLeader then
		return true
	elseif record2.isLeader and not record1.isLeader then
		return false
	elseif record1.sourceIndexLeading == BMU.SOURCE_INDEX_GROUP and record2.sourceIndexLeading ~= BMU.SOURCE_INDEX_GROUP then
		-- group is always comes first
		return true
	elseif record1.sourceIndexLeading ~= BMU.SOURCE_INDEX_GROUP and record2.sourceIndexLeading == BMU.SOURCE_INDEX_GROUP then
		-- group is always comes first
		return false
	elseif BMU.getIndexFromValue(BMU.savedVarsServ.prioritizationSource, record1.sourceIndexLeading) < BMU.getIndexFromValue(BMU.savedVarsServ.prioritizationSource, record2.sourceIndexLeading) then
		-- source of record1 has lower index in prioritization table (higher priority)
		return true
	elseif record1.isOwnHouse and record2.isOwnHouse then
		-- both entries are own houses -> sort by nickname
		return record1.nickName < record2.nickName
	else
		return false
	end
end
BMU_decidePrioDisplay = BMU.decidePrioDisplay 			--INS251229 Baertram


function BMU.addNumberPlayers(oldTable)
	local newTable = {}
	-- go over table
	for index, record in pairs(oldTable) do
		local numPlayers = allZoneIds[record.zoneId]
		if numPlayers and numPlayers > 1 and (record.isOwnHouse or (record.displayName and record.displayName ~= "")) then
			-- add number of players per map
			record.numberPlayers = tonumber(allZoneIds[record.zoneId])
		end
		-- copy records to the new table
		table_insert(newTable, record)
	end

	return newTable
end
BMU_addNumberPlayers = BMU.addNumberPlayers 			--INS251229 Baertram


-- find itemId in global list and return subType and zoneId
function BMU.getDataMapInfo(itemId)
	BMU_has_value = BMU_has_value or BMU.has_value                                 					--INS251229 Baertram
	-- go over all overland zones in global list
	for zoneId, typeList in pairs(BMU.treasureAndSurveyMaps) do
		for mapType, itemList in pairs(typeList) do
			-- check if itemList contains itemId
			if BMU_has_value(itemList, itemId) then
				return mapType, zoneId
			end
		end
	end
	return false
end
BMU_getDataMapInfo = BMU.getDataMapInfo


-- return (geographical) parent zone id (if parent zone id can not be found -> parentZoneId = zoneId)
function BMU.getParentZoneId(zoneId)
	-- use LibZone function that already handles exceptions and returns true geographical parent zone
	local parentZoneId = BMU.LibZone:GetZoneGeographicalParentZoneId(zoneId)

	-- fallback: use API to get parent zone
	if not parentZoneId or parentZoneId == 0 then
		parentZoneId = GetParentZoneId(zoneId)
	end

	-- return zoneId if the parentZoneId can not be determined
	if not parentZoneId or parentZoneId == 0 then
		return zoneId
	else
		return parentZoneId
	end
end
BMU_getParentZoneId = BMU.getParentZoneId


function BMU.createTableHouses()
	-- change global state, to have the correct tab active
	BMU.changeState(BMU.indexListOwnHouses)
	local resultList = {}

	for _, house in pairs(COLLECTIONS_BOOK_SINGLETON:GetOwnedHouses()) do
		local entry = BMU.createBlankRecord()
		entry.houseId = house.houseId
		if IsPrimaryHouse(house.houseId) then
			entry.prio = 1
			entry.textColorZoneName = "gold"
		else
			entry.prio = 2
			entry.textColorZoneName = "white"
		end
		entry.isOwnHouse = true
		entry.zoneId = GetHouseZoneId(house.houseId)
		entry.zoneNameUnformatted = GetZoneNameById(entry.zoneId)
		entry.textColorDisplayName = "gray"
		entry.zoneNameClickable = true
		entry.mapIndex = BMU_getMapIndex(entry.zoneId)
		entry.parentZoneId = BMU_getParentZoneId(entry.zoneId)
		entry.parentZoneName = BMU_formatName(GetZoneNameById(entry.parentZoneId))
		entry.category = BMU_categorizeZone(entry.zoneId)
		entry.collectibleId = GetCollectibleIdForHouse(entry.houseId)
		entry.houseCategoryType = GetString("SI_HOUSECATEGORYTYPE", GetHouseCategoryType(entry.houseId))
		entry.nickName = BMU_formatName(GetCollectibleNickname(entry.collectibleId))
		entry.zoneName = BMU_formatName(entry.zoneNameUnformatted, BMU.savedVarsAcc.formatZoneName)

		_, _, entry.houseIcon = GetCollectibleInfo(entry.collectibleId)
		entry.houseBackgroundImage = GetHousePreviewBackgroundImage(entry.houseId)
		entry.houseTooltip = {entry.zoneName, "\"" .. entry.nickName .. "\"", entry.parentZoneName, "", "", "|t75:75:" .. entry.houseIcon .. "|t", "", "", entry.houseCategoryType}

		-- add house furniture count to tooltip
		local currentFurnitureCount_LII = BMU.savedVarsServ.houseFurnitureCount_LII[entry.houseId]
		if currentFurnitureCount_LII ~= nil then
			local tooltipFurnitureCount = GetString(SI_HOUSINGFURNISHINGLIMITTYPE0) .. ": " .. currentFurnitureCount_LII .. "/" .. GetHouseFurnishingPlacementLimit(entry.houseId, HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM)
			table_insert(entry.houseTooltip, tooltipFurnitureCount)
		end

		if BMU.savedVarsChar.houseNickNames then
			-- show nick name instead of real house name
			entry.zoneName = entry.nickName
		end

		table_insert(resultList, entry)
	end

	-- sort
	table_sort(resultList, function(a, b)
		-- prio
		if a.prio ~= b.prio then
			return a.prio < b.prio
		end
		-- custom sorting
		local cSortingA = BMU.savedVarsServ.houseCustomSorting[a.houseId] or -99
		local cSortingB = BMU.savedVarsServ.houseCustomSorting[b.houseId] or -99
		if cSortingA ~= cSortingB then
			return cSortingA > cSortingB
		end
		-- name
		return a.zoneName < b.zoneName
	end)

	-- in case of no results, add message with information
	if #resultList == 0 then
		table_insert(resultList, BMU_createNoResultsInfo())
	end

	BMU.TeleporterList:add_messages(resultList)
end


function BMU.createTablePTF()
	local PortToFriend = PortToFriend --INS251229 Baertram
	if not PortToFriend or not PortToFriend.GetFavorites then
		return
	end
	BMU_getMapIndex = BMU_getMapIndex or BMU.getMapIndex
	BMU_getParentZoneId = BMU_getParentZoneId or BMU.getParentZoneId

	-- change global state, to have the correct tab active
	BMU.changeState(BMU.indexListPTFHouses)
	local resultList = {}
	local _

	-- add PTF entries
	local favorites = PortToFriend.GetFavorites()
	if favorites and #favorites > 0 then
		for i = 1, #favorites do
			local favorite = favorites[i]

			local entry = BMU.createBlankRecord()
			entry.houseId = favorite.houseId
			local IdAsText = ""
			if favorite.id then
				entry.prio = 1
				entry.order = favorite.id
				IdAsText = favorite.id .. " - "
			else
				entry.prio = 2
			end
			entry.isPTFHouse = true
			entry.displayName = IdAsText .. favorite.name
			entry.houseId = favorite.houseId
			entry.zoneId = GetHouseZoneId(favorite.houseId)
			entry.zoneNameUnformatted = GetZoneNameById(entry.zoneId)
			entry.zoneNameClickable = true
			entry.mapIndex = BMU_getMapIndex(entry.zoneId)
			entry.parentZoneId = BMU_getParentZoneId(entry.zoneId)
			entry.parentZoneName = BMU_formatName(GetZoneNameById(entry.parentZoneId))
			entry.category = BMU_categorizeZone(entry.zoneId)
			entry.collectibleId = GetCollectibleIdForHouse(entry.houseId)
			entry.houseCategoryType = GetString("SI_HOUSECATEGORYTYPE", GetHouseCategoryType(entry.houseId))
			entry.zoneName = BMU_formatName(entry.zoneNameUnformatted)

			_, _, entry.houseIcon = GetCollectibleInfo(entry.collectibleId)
			entry.houseBackgroundImage = GetHousePreviewBackgroundImage(entry.houseId)
			entry.houseTooltip = {entry.zoneName, entry.parentZoneName, "", "", "|t75:75:" .. entry.houseIcon .. "|t", "", "", entry.houseCategoryType}

			-- current / displayed zone depending on map status
			local currentZoneId = BMU_getCurrentZoneId()
			if currentZoneId == entry.parentZoneId then
				entry.textColorDisplayName = "blue"
				entry.textColorZoneName = "blue"
			else
				entry.textColorDisplayName = "white"
				entry.textColorZoneName = "white"
			end

			if BMU.savedVarsChar.ptfHouseZoneNames then
				-- show zone name instead of real house name
				entry.zoneName = entry.parentZoneName
			end

			table_insert(resultList, entry)
		end

		-- sort
		table_sort(resultList, function(a, b)
			-- prio
			if a.prio ~= b.prio then
				return a.prio < b.prio
			end
			if a.order and a.order ~= b.order then
				return a.order < b.order
			end
			-- name
			return a.zoneName < b.zoneName
		end)
	end

	-- creat record as button for addon opening
	local openPTF = BMU.createBlankRecord()
	openPTF.zoneName = "Open \"Port to Friend's House\""
	openPTF.textColorDisplayName = "gold"
	openPTF.textColorZoneName = "gold"
	openPTF.zoneNameClickable = true
	openPTF.PTFHouseOpen = true

	table_insert(resultList, openPTF)

	BMU.TeleporterList:add_messages(resultList)
end


-- adds matching overland zones to the result list
-- return sorted result list ready for display
function BMU.addOverlandZoneMatches(portalPlayers, inputString, currentZoneId)
	BMU_createClickableZoneRecord = BMU_createClickableZoneRecord or BMU.createClickableZoneRecord  --INS251229 Baertram
	-- go over complete overland list
	for overlandZoneId, _ in pairs(BMU.overlandDelvesPublicDungeons) do
		local entry = BMU_createClickableZoneRecord(overlandZoneId)
		-- add only if zone not already in result list + search string match
		if not allZoneIds[overlandZoneId] and (string_match(string_lower(entry.zoneName), string_lower(inputString)) or (BMU.savedVarsAcc.secondLanguage ~= 1 and string_match(string_lower(entry.zoneNameSecondLanguage), string_lower(inputString)))) then
			-- change text color if zone is displayed zone
			if entry.zoneId == currentZoneId then
				entry.textColorZoneName = "teal"
			end
			table_insert(portalPlayers, entry)
		end
	end

	return portalPlayers
end


-- sorting for search by displayName or zoneName
-- sorts the entries according to the position of the string match
-- keys are the used key field (e.g. "displayName" or "zoneName")
function BMU.sortByStringFindPosition(portalPlayers, inputString, key1, key2)
	table_sort(portalPlayers, function(a, b)
		--[[
		-- first, real port options (where players or own houses are)
		if (a.displayName ~= "" or a.isOwnHouse) and (b.displayName == "" and not b.isOwnHouse) then
			return true
		elseif (a.displayName == "" and not a.isOwnHouse) and (b.displayName ~= "" or b.isOwnHouse) then
			return false
		end
		--]]

		-- second, by search match position of key1
		if key1 then
			local pos1 = string.find(string_lower(tostring(a[key1])), string_lower(inputString))
			local pos2 = string.find(string_lower(tostring(b[key1])), string_lower(inputString))
			if pos1 and not pos2 then
				return true
			elseif pos2 and not pos1 then
				return false
			elseif pos1 and pos2 then
				return pos1 < pos2
			end
		end

		-- third, by search match position of key2
		if key2 then
			local pos1 = string.find(string_lower(tostring(a[key2])), string_lower(inputString))
			local pos2 = string.find(string_lower(tostring(b[key2])), string_lower(inputString))
			if pos1 and not pos2 then
				return true
			elseif pos2 and not pos1 then
				return false
			elseif pos1 and pos2 then
				return pos1 < pos2
			end
		end
		return false -- Default: no swap if all conditions are equal
	end)

	return portalPlayers
end
BMU_sortByStringFindPosition = BMU.sortByStringFindPosition --INS251229 Baertram


function BMU.createTableGuilds(repeatFlag)
	-- abort repeating the function if user switched to other tab
	if repeatFlag and BMU.state ~= BMU.indexListGuilds then
		return
	end

	-- change global state, to have the correct tab active
	BMU.changeState(BMU.indexListGuilds)
	local resultList = {}

	-- headline for the official guilds
	local entry = BMU.createBlankRecord()
	entry.zoneName = "-- OFFICIAL GUILDS --"
	entry.textColorZoneName = "gray"
	table_insert(resultList, entry)

	-- official guilds
	local success = true
	for _, guildId in pairs(BMU.var.BMUGuilds[GetWorldName()]) do
		local guildData = GUILD_BROWSER_MANAGER:GetGuildData(guildId)
		if guildData then
			-- display only guilds that are listed/active
			if guildData.guildName ~= nil and guildData.guildName ~= "" then
				local entry = BMU.createBlankRecord()
				entry.guildId = guildId
				entry.isGuild = true
				entry.displayName = guildData.guildName
				entry.textColorZoneName = "white"
				entry.textColorDisplayName = "gold"
				local prefixMembers = GetString("SI_GUILDMETADATAATTRIBUTE", GUILD_META_DATA_ATTRIBUTE_SIZE) .. ": "
				local prefixLanguage = GetString("SI_GUILDMETADATAATTRIBUTE", GUILD_META_DATA_ATTRIBUTE_LANGUAGES) .. ": "
				local guildSizeText = guildData.size .. "/500"
				local guildTraderText = guildData.guildTraderText
				if guildTraderText and #guildTraderText > 1 then
					guildTraderText = GetString(SI_GUILD_TRADER_OWNERSHIP_HEADER) .. ": " .. guildTraderText
				else
					guildTraderText = nil
				end
				entry.hideButton = false
				-- hide button and change text color if guild almost full
				if guildData.size >= 495 then
					entry.hideButton = true
					guildSizeText = BMU_colorizeText(guildSizeText, "red")
				end
				entry.guildTooltip = {guildData.headerMessage, BMU.textures.tooltipSeperator, prefixMembers .. guildSizeText, prefixLanguage .. GetString("SI_GUILDLANGUAGEATTRIBUTEVALUE", guildData.language), guildTraderText}
				entry.zoneName = GetString("SI_GUILDLANGUAGEATTRIBUTEVALUE", guildData.language) .. " || " .. guildSizeText
				table_insert(resultList, entry)
			end
		else
			success = false
		end
	end


	-- headline for the partner guilds
	local entry = BMU.createBlankRecord()
	entry.zoneName = "-- PARTNER GUILDS --"
	entry.textColorZoneName = "gray"
	table_insert(resultList, entry)

	-- partner guilds
	local tempList = {}
	for _, guildId in pairs(BMU.var.partnerGuilds[GetWorldName()]) do
		local guildData = GUILD_BROWSER_MANAGER:GetGuildData(guildId)
		if guildData then
			-- display only guilds that are listed/active
			if guildData.guildName ~= nil and guildData.guildName ~= "" then
				local entry = BMU.createBlankRecord()
				entry.guildId = guildId
				entry.isGuild = true
				entry.displayName = guildData.guildName
				entry.languageCode = guildData.language
				entry.size = guildData.size
				local prefixMembers = GetString("SI_GUILDMETADATAATTRIBUTE", GUILD_META_DATA_ATTRIBUTE_SIZE) .. ": "
				local prefixLanguage = GetString("SI_GUILDMETADATAATTRIBUTE", GUILD_META_DATA_ATTRIBUTE_LANGUAGES) .. ": "
				local guildSizeText = guildData.size .. "/500"
				local guildTraderText = guildData.guildTraderText
				if guildTraderText and #guildTraderText > 1 then
					guildTraderText = GetString(SI_GUILD_TRADER_OWNERSHIP_HEADER) .. ": " .. guildTraderText
				else
					guildTraderText = nil
				end
				entry.prio = 1
				-- change text color if guild almost full and reduce prio
				if guildData.size >= 495 then
					entry.prio = 2
					guildSizeText = BMU_colorizeText(guildSizeText, "red")
				end
				entry.guildTooltip = {guildData.headerMessage, BMU.textures.tooltipSeperator, prefixMembers .. guildSizeText, prefixLanguage .. GetString("SI_GUILDLANGUAGEATTRIBUTEVALUE", guildData.language), guildTraderText}
				entry.zoneName = GetString("SI_GUILDLANGUAGEATTRIBUTEVALUE", guildData.language) .. " || " .. guildSizeText
				table_insert(tempList, entry)
			end
		else
			success = false
		end
	end
	-- only sort partner guilds
	table_sort(tempList, function(a, b)
		if a.languageCode ~= b.languageCode then
			return a.languageCode < b.languageCode
		end
		if a.prio ~= b.prio then
			return a.prio < b.prio
		end
		if a.size ~= b.size then
			return a.size > b.size
		end
		return false -- Default: no swap if all conditions are equal
	end)
	-- add partner guild list to final list
	for _, v in pairs(tempList) do table_insert(resultList, v) end

	BMU.TeleporterList:add_messages(resultList)

	if not success then
		-- try again
		zo_callLater(function() BMU.createTableGuilds(true) end, 600)
	end
end
local BMU_createTableGuilds = BMU.createTableGuilds 								--INS251229 Baertram



-- create table of Dungeons, Trials, Arenas depending on the settings
function BMU.createTableDungeons(args)
	-- change global state, to have the correct tab active
	BMU.changeState(BMU.indexListDungeons)
	local inputString = (args and args.inputString) or nil

	local resultListEndlessDungeons = {}
	local resultListArenas = {}
	local resultListGroupArenas = {}
	local resultListTrials = {}
	local resultListGroupDungeons = {}

	if BMU.savedVarsChar.dungeonFinder.showEndlessDungeons then
		for _, zoneId in ipairs(BMU.blacklistEndlessDungeons) do
			local entry = BMU.createDungeonRecord(zoneId)
			if entry then
				if BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName then
					-- show zone name instead of instance name
					entry.zoneName = entry.parentZoneName
				end
				table_insert(resultListEndlessDungeons, entry)
			end
		end

		if BMU.savedVarsChar.dungeonFinder.sortByAcronym then
			-- sort by acronym
			table_sort(resultListEndlessDungeons, function(a, b)
				return a.acronym < b.acronym
			end)
		else
			-- sort by release and name
			table_sort(resultListEndlessDungeons, function(a, b)
				if a.updateNum ~= b.updateNum then
					return (a.updateNum < b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseASC) or (a.updateNum > b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC)
				end
				return a.zoneName < b.zoneName
			end)
		end

		-- add headline
		if #resultListEndlessDungeons > 0 then
			local entry = BMU.createBlankRecord()
			entry.zoneName = "-- " .. string.upper(BMU_SI_get(SI.TELE_UI_TOGGLE_ENDLESS_DUNGEONS)) .. " --"
			entry.textColorZoneName = "gray"
			table_insert(resultListEndlessDungeons, 1, entry)
		end
	end


	if BMU.savedVarsChar.dungeonFinder.showArenas then
		for _, zoneId in ipairs(BMU.blacklistSoloArenas) do
			local entry = BMU.createDungeonRecord(zoneId)
			if entry then
				if BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName then
					-- show zone name instead of instance name
					entry.zoneName = entry.parentZoneName
				end
				table_insert(resultListArenas, entry)
			end
		end

		if BMU.savedVarsChar.dungeonFinder.sortByAcronym then
			-- sort by acronym
			table_sort(resultListArenas, function(a, b)
				return a.acronym < b.acronym
			end)
		else
			-- sort by release and name
			table_sort(resultListArenas, function(a, b)
				if a.updateNum ~= b.updateNum then
					return (a.updateNum < b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseASC) or (a.updateNum > b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC)
				end
				return a.zoneName < b.zoneName
			end)
		end

		-- add headline
		if #resultListArenas > 0 then
			local entry = BMU.createBlankRecord()
			entry.zoneName = "-- " .. string.upper(BMU_SI_get(SI.TELE_UI_TOGGLE_ARENAS)) .. " --"
			entry.textColorZoneName = "gray"
			table_insert(resultListArenas, 1, entry)
		end
	end


	if BMU.savedVarsChar.dungeonFinder.showGroupArenas then
		for _, zoneId in ipairs(BMU.blacklistGroupArenas) do
			local entry = BMU.createDungeonRecord(zoneId)
			if entry then
				if BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName then
					-- show zone name instead of instance name
					entry.zoneName = entry.parentZoneName
				end
				table_insert(resultListGroupArenas, entry)
			end
		end

		if BMU.savedVarsChar.dungeonFinder.sortByAcronym then
			-- sort by acronym
			table_sort(resultListGroupArenas, function(a, b)
				return a.acronym < b.acronym
			end)
		else
			-- sort by release and name
			table_sort(resultListGroupArenas, function(a, b)
				if a.updateNum ~= b.updateNum then
					return (a.updateNum < b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseASC) or (a.updateNum > b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC)
				end
				return a.zoneName < b.zoneName
			end)
		end

		-- add headline
		if #resultListGroupArenas > 0 then
			local entry = BMU.createBlankRecord()
			entry.zoneName = "-- " .. string.upper(BMU_SI_get(SI.TELE_UI_TOGGLE_GROUP_ARENAS)) .. " --"
			entry.textColorZoneName = "gray"
			table_insert(resultListGroupArenas, 1, entry)
		end
	end


	if BMU.savedVarsChar.dungeonFinder.showTrials then
		for _, zoneId in ipairs(BMU.blacklistRaids) do
			local entry = BMU.createDungeonRecord(zoneId)
			if entry then
				if BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName then
					-- show zone name instead of instance name
					entry.zoneName = entry.parentZoneName
				end
				table_insert(resultListTrials, entry)
			end
		end

		if BMU.savedVarsChar.dungeonFinder.sortByAcronym then
			-- sort by acronym
			table_sort(resultListTrials, function(a, b)
				return a.acronym < b.acronym
			end)
		else
			-- sort by release and name
			table_sort(resultListTrials, function(a, b)
				if a.updateNum ~= b.updateNum then
					return (a.updateNum < b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseASC) or (a.updateNum > b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC)
				end
				return a.zoneName < b.zoneName
			end)
		end

		-- add headline
		if #resultListTrials > 0 then
			local entry = BMU.createBlankRecord()
			entry.zoneName = "-- " .. string.upper(BMU_SI_get(SI.TELE_UI_TOGGLE_TRIALS)) .. " --"
			entry.textColorZoneName = "gray"
			table_insert(resultListTrials, 1, entry)
		end
	end


	if BMU.savedVarsChar.dungeonFinder.showDungeons then
		for _, zoneId in ipairs(BMU.blacklistGroupDungeons) do
			local entry = BMU.createDungeonRecord(zoneId)
			if entry then
				if BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName then
					-- show zone name instead of instance name
					entry.zoneName = entry.parentZoneName
				end
				table_insert(resultListGroupDungeons, entry)
			end
		end

		if BMU.savedVarsChar.dungeonFinder.sortByAcronym then
			-- sort by acronym
			table_sort(resultListGroupDungeons, function(a, b)
				return a.acronym < b.acronym
			end)
		else
			-- sort by release and name
			table_sort(resultListGroupDungeons, function(a, b)
				if a.updateNum ~= b.updateNum then
					return (a.updateNum < b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseASC) or (a.updateNum > b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC)
				end
				return a.zoneName < b.zoneName
			end)
		end

		-- add headline
		if #resultListGroupDungeons > 0 then
			local entry = BMU.createBlankRecord()
			entry.zoneName = "-- " .. string.upper(BMU_SI_get(SI.TELE_UI_TOGGLE_GROUP_DUNGEONS)) .. " --"
			entry.textColorZoneName = "gray"
			table_insert(resultListGroupDungeons, 1, entry)
		end
	end

	-- merge all lists together
	local resultList = {}
	if inputString and inputString ~= "" then
		for _, v in pairs(resultListEndlessDungeons) do if string.find(v.zoneName:lower(), inputString:lower()) then table_insert(resultList, v) end end
		for _, v in pairs(resultListArenas) do if string.find(v.zoneName:lower(), inputString:lower()) then table_insert(resultList, v) end end
		for _, v in pairs(resultListGroupArenas) do if string.find(v.zoneName:lower(), inputString:lower()) then table_insert(resultList, v) end end
		for _, v in pairs(resultListTrials) do if string.find(v.zoneName:lower(), inputString:lower()) then table_insert(resultList, v) end end
		for _, v in pairs(resultListGroupDungeons) do if string.find(v.zoneName:lower(), inputString:lower()) then table_insert(resultList, v) end end
	else
		for _, v in pairs(resultListEndlessDungeons) do table_insert(resultList, v) end
		for _, v in pairs(resultListArenas) do table_insert(resultList, v) end
		for _, v in pairs(resultListGroupArenas) do table_insert(resultList, v) end
		for _, v in pairs(resultListTrials) do table_insert(resultList, v) end
		for _, v in pairs(resultListGroupDungeons) do table_insert(resultList, v) end
	end
	-- add no results info if player disabled all categories
	if #resultList == 0 then
		table_insert(resultList, BMU_createNoResultsInfo())
	end

	BMU.TeleporterList:add_messages(resultList)
end


-- creates an record for an dungeon entry
function BMU.createDungeonRecord(zoneId)
	BMU_createClickableZoneRecord = BMU_createClickableZoneRecord or BMU.createClickableZoneRecord  --INS251229 Baertram
	local entry = BMU_createClickableZoneRecord(zoneId)
	entry.isDungeon = true
	if zoneId == BMU.savedVarsServ.favoriteDungeon then
		entry.textColorDisplayName = "gold"
		entry.textColorZoneName = "gold"
	else
		entry.textColorDisplayName = "white"
		entry.textColorZoneName = "white"
	end

	-- in the case that new DLC dungeons from PTS are already added but not published on live servers so far
	-- prevent them from showing as empty row or invalid entry
	if not entry.zoneNameUnformatted or entry.zoneNameUnformatted == "" or not BMU.nodeIndexMap[zoneId] then
		return nil
	end

	local nodeObject = BMU.nodeIndexMap[zoneId]
	entry.nodeIndex = nodeObject.nodeIndex
	entry.acronym = nodeObject.abbreviation or ""
	entry.updateName = nodeObject.updateName or GetString(SI_CHAPTER0)
	entry.updateNum = nodeObject.updateNum or ""
	entry.releaseDate = nodeObject.releaseDate or ""

	entry.dungeonTooltip = {
		string.format(GetString(SI_CHAPTER_UPGRADE_RELEASE_HEADER) .. ": Update %s (%s)", entry.updateNum, entry.releaseDate)
	}

	if BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName then
		-- use acronyms
		entry.displayName = entry.acronym
	else
		-- use update name
		entry.displayName = entry.updateName
	end
	entry.zoneName = BMU_formatName(entry.zoneNameUnformatted, BMU.savedVarsAcc.formatZoneName)
	entry.difficultyText = GetString(SI_DUNGEONDIFFICULTY1)

	if ZO_ConvertToIsVeteranDifficulty(ZO_GetEffectiveDungeonDifficulty()) then
		entry.difficultyText = GetString(SI_DUNGEONDIFFICULTY2)
	end

	return entry
end


-- create and initialize a list entry (record)
function BMU.createBlankRecord()
	local record = {}
	record.displayName = ""
	record.textColorDisplayName = "white"
	record.textColorZoneName = "white"
	record.countRelatedQuests = 0
	record.countRelatedItems = 0
	record.relatedItems = {}
	record.relatedItemsTypes = {}
	record.relatedQuests = {}
	record.relatedQuestsSlotIndex = {}
	return record
end


-- find exact quest location by setting the map via questmarker
function BMU.findExactQuestLocation(questIndex)
	local questName, _, _, _, _, _, _ = GetJournalQuestInfo(questIndex)
	local questZoneId = 0

	if BMU.questDataCache[questIndex] ~= nil and not BMU.questDataChanged then
		-- quest data did not changed -> use location data from cache
		questZoneId = BMU.questDataCache[questIndex]["zoneId"]
	else
		-- gather location info
		local result = BMU.setMapToQuest(questIndex)
		questZoneId = GetZoneId(GetCurrentMapZoneIndex())
		-- set map back to player location
		SetMapToPlayerLocation()
		CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")

		-- save location data into cache
		BMU.questDataCache[questIndex] = {}
		BMU.questDataCache[questIndex]["zoneId"] = questZoneId
	end

	return questZoneId
end
local BMU_findExactQuestLocation = BMU.findExactQuestLocation


-- set map to actual quest location depending on the active step and conditions
-- code is based on the function "ZO_WorldMap_ShowQuestOnMap(questIndex)"
-- https://esoapi.uesp.net/100028/src/ingame/map/worldmap.lua.html#6838
function BMU.setMapToQuest(questIndex)
    --first try to set the map to one of the quest's step pins
    local result = SET_MAP_RESULT_FAILED
    for stepIndex = QUEST_MAIN_STEP_INDEX, GetJournalQuestNumSteps(questIndex) do
        --Loop through the conditions, if there are any. Prefer non-completed conditions to completed ones.
        local requireNotCompleted = true
        local conditionsExhausted = false
        while result == SET_MAP_RESULT_FAILED and not conditionsExhausted do
            for conditionIndex = 1, GetJournalQuestNumConditions(questIndex, stepIndex) do
                local tryCondition = true
                if requireNotCompleted then
                    local complete = select(4, GetJournalQuestConditionValues(questIndex, stepIndex, conditionIndex))
                    tryCondition = not complete
                end
                if tryCondition then
                    result = SetMapToQuestCondition(questIndex, stepIndex, conditionIndex)
                    if result ~= SET_MAP_RESULT_FAILED then
                        break
                    end
                end
            end
            if requireNotCompleted then
                requireNotCompleted = false
            else
                conditionsExhausted = true
            end
        end
        if result ~= SET_MAP_RESULT_FAILED then
            break
        end
        --If it's the end, set the map to the ending location (Endings don't have conditions)
        if IsJournalQuestStepEnding(questIndex, stepIndex) then
            result = SetMapToQuestStepEnding(questIndex, stepIndex)
            if result ~= SET_MAP_RESULT_FAILED then
                break
            end
        end
    end
    --if it has no condition pins, set it to the quest's zone
    if result == SET_MAP_RESULT_FAILED then
		result = SetMapToQuestZone(questIndex)
    end
    --if that doesn't work, bail
    if result == SET_MAP_RESULT_FAILED then
        ZO_Alert(UI_ALERT_CATEGORY_ERROR, SOUNDS.NEGATIVE_CLICK, SI_WORLD_MAP_NO_QUEST_MAP_LOCATION)
    end

	return result
end

-- exception handling
-- check if the zone belongs to another (main) zone which holds the map completion information
-- returns the corresponding zoneId if the input zone is part of a zone realtionship
function BMU.getMainZoneId(zoneId)
	if zoneId == 1011 or zoneId == 1027 then
		-- Summerset/Artaeum
		return 1011
	elseif zoneId == 1160 or zoneId == 1161 then
		-- Blackreach/Western Skyrim
		return 1160
	elseif zoneId == 1207 or zoneId == 1208 then
		-- Reach/Blackreach(Arkthzand)
		return 1207
	elseif zoneId == 1286 or zoneId == 1282 or zoneId == 1283 then
		-- Deadlands/Fargrave(City)/The Shambles
		return 1286
	elseif zoneId == 1413 or zoneId == 1414 then
		-- Telvanni Peninsula/Apocrypha
		return 1413
	else
		return false
	end
end
local BMU_getMainZoneId = BMU.getMainZoneId  	--INS251229 Baertram

-- get completion info for specific zone and completionType
function BMU.getZoneGuideDiscoveryInfo(zoneId, completionType)
	local numCompletedActivities = 0
	local totalActivities = 0
	local _

	-- check for any zone mapping exceptions
	local mainZoneId = BMU_getMainZoneId(zoneId)
	if mainZoneId then
		zoneId = mainZoneId
	end

	-- additional wayshrine exception for Eyevea (Augvea) since this map has no zone completion info
	if zoneId == 267 and completionType == ZONE_COMPLETION_TYPE_WAYSHRINES then
		totalActivities = 1
		-- check the only one wayshrine on this map
		local known, _, _, _, _, _, _, _, _ = GetFastTravelNodeInfo(215)
		if known then
			numCompletedActivities = 1
		else
			numCompletedActivities = 0
		end
	else
		numCompletedActivities, totalActivities, _, _ = ZO_ZoneStories_Manager.GetActivityCompletionProgressValues(zoneId, completionType)
	end

	if totalActivities == 0 then
		return nil
	end

	local infoString = numCompletedActivities .. "/" .. totalActivities
	if numCompletedActivities == totalActivities then
		infoString = BMU_colorizeText(infoString, "green")
	end

	if completionType == ZONE_COMPLETION_TYPE_WAYSHRINES then
		infoString = GetString(SI_ZONECOMPLETIONTYPE4) .. ": " .. infoString

	elseif completionType == ZONE_COMPLETION_TYPE_SKYSHARDS then
		infoString = GetString(SI_ZONECOMPLETIONTYPE7) .. ": " .. infoString

	elseif completionType == ZONE_COMPLETION_TYPE_PUBLIC_DUNGEONS then
		infoString = GetString(SI_ZONECOMPLETIONTYPE13) .. ": " .. infoString

	elseif completionType == ZONE_COMPLETION_TYPE_DELVES then
		infoString = GetString(SI_ZONECOMPLETIONTYPE5) .. ": " .. infoString
	end

	return infoString, numCompletedActivities, totalActivities
end
BMU_getZoneGuideDiscoveryInfo = BMU.getZoneGuideDiscoveryInfo --INS251229 Baertram