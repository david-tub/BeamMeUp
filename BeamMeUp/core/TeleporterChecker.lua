local SI = BMU.SI
local portalPlayers = {}
local TeleportAllPlayersTable = {}
local allZoneIds = {} -- stores the number of hits of a zoneId at index (allzoneIds[zoneId] = 1) | to know which zoneId is already added | to count the number of port options/alternatives

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
			if "The " == string.sub(unformatted, 1, 4) then
				-- remove "The " in the beginning
				formatted = string.sub(unformatted, 5)
			else
				-- no "The " to remove
				formatted = unformatted
			end
			
		elseif BMU.lang == "de" or BMU.lang == "fr" then
			if string.match(unformatted, ".*^") ~= nil then
				-- remove German and French articles
				formatted = string.match(unformatted, ".*^")
				-- and cut last character
				if formatted ~= nil then
					formatted = string.sub(formatted, 1, -2)
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


-- zone where the player actual is
function BMU.getPlayersZoneId()
	local playersZoneIndex = GetUnitZoneIndex("player")
	local playersZoneId = GetZoneId(playersZoneIndex)
	
	return playersZoneId
end


-- current / displayed zone depending on map status
function BMU.getCurrentZoneId()
	local currentZoneId = 0
	local playersZoneId = BMU.getPlayersZoneId()
	if SCENE_MANAGER:IsShowing("worldMap") or SCENE_MANAGER:IsShowing("gamepad_worldMap") then
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


-- index: choose scenario
--		1: only current zone
--		2: filter by player name
--		3: filter by zone name
--		4: related items
--		5: delves and public dungeons
--		6: Favorite Search | Looking for specific zoneId (without state change)
--		7: filter by sourceIndex
--		8: Looking for specific zoneId (with state change)
--		9: related quests
--		else (0): everything

-- inputString: search string
-- fZoneId: specific zoneId (favorite)
-- dontDisplay: flag if the result should be displayed in table (nil or false) or just return the result (true)
-- filterSourceIndex: specific sourceIndex
-- dontResetSlider: flag if the slider/scroll bar should not be reset (reset to top of the list)
-- noOwnHouses: flag if the owned houses shall not appear in result list
function BMU.createTable(args)
	local index = args.index or 0
	local inputString = args.inputString or ""
	local fZoneId = args.fZoneId
	local dontDisplay = args.dontDisplay or false
	local filterSourceIndex = args.filterSourceIndex
	local dontResetSlider = args.dontResetSlider or false
	local noOwnHouses = args.noOwnHouses or false
	
	-- simple checks
	if type(index) ~= 'number' or (index == 7 and type(filterSourceIndex) ~= 'number') or (index == 8 and type(fZoneId) ~= 'number') then
		return
	end
	
	local startTime = GetGameTimeMilliseconds() -- get start time
	
	-- clear input fields
	if index ~= 2 and index ~= 3 then
		BMU.clearInputFields()
	end

	-- if filtering by name (2 or 3) and inputString is empty -> same as everything (0)
	if (index == 2 or index == 3) and inputString == "" then
		index = 0
	end

	if BMU.debugMode == 1 then
		-- debug mode
		-- print status
		BMU.printToChat("Refreshed - state: " .. tostring(index) .. " - String: " .. tostring(inputString))
	end
	
	-- change state for correct persistent MouseOver and for auto refresh
	if not dontDisplay then -- dont change when result should not be displayed in list
		BMU.changeState(index)
	end
	
	-- save SourceIndex in global variable
	if index == 7 then
		BMU.stateSourceIndex = filterSourceIndex
	end
	
	-- save ZoneId in global variable
	if index == 8 then
		BMU.stateZoneId = fZoneId
	end
	
	-- zone where the player actual is
	local playersZoneId = BMU.getPlayersZoneId() or 0
	-- current / displayed zone depending on map status
	local currentZoneId = BMU.getCurrentZoneId() or 0
	
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
				e = BMU.addInfo_1(e, currentZoneId, playersZoneId, TELEPORTER_SOURCE_INDEX_GROUP)
				
				-- second big filter level
				if BMU.filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex) then
					-- add bunch of information to the record
					e = BMU.addInfo_2(e)
					-- insert into table
					table.insert(TeleportAllPlayersTable, e)
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
			e = BMU.addInfo_1(e, currentZoneId, playersZoneId, TELEPORTER_SOURCE_INDEX_FRIEND)		
			
			-- second big filter level
			if BMU.filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex) then
				-- add bunch of information to the record
				e = BMU.addInfo_2(e)			
				-- insert into table
				table.insert(TeleportAllPlayersTable, e)
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
				e = BMU.addInfo_1(e, currentZoneId, playersZoneId, _G["TELEPORTER_SOURCE_INDEX_GUILD" .. tostring(i)])
				
				-- second big filter level
				if BMU.filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex) then
					-- add bunch of information to the record
					e = BMU.addInfo_2(e)
					-- insert into table
					table.insert(TeleportAllPlayersTable, e)	
				end
			end	
		end
	end
	
	if not BMU.savedVarsAcc.hideOwnHouses and not noOwnHouses then
		-- 4. go over own houses
		-- player can port outside own houses -> check own houses and add parent zone entries if not already in list
		for _, house in pairs(COLLECTIONS_BOOK_SINGLETON:GetOwnedHouses()) do
			local houseZoneId = GetHouseZoneId(house.houseId)
			local mapIndex = BMU.getMapIndex(houseZoneId)
			local parentZoneId = BMU.getParentZoneId(houseZoneId)
			-- check if parent zone not already in result list
			---if not allZoneIds[parentZoneId] then
			local e = {}
			-- add infos
			e.parentZoneId = parentZoneId
			e.parentZoneName = BMU.formatName(GetZoneNameById(e.parentZoneId))
			e.zoneId = e.parentZoneId
			e.displayName = ""
			e.houseId = house.houseId
			e.isOwnHouse = true
			-- add flag to port outside the house
			e.forceOutside = true
			e.zoneName = GetZoneNameById(e.zoneId)
			e.houseNameUnformatted = GetZoneNameById(houseZoneId)
			e.houseNameFormatted = BMU.formatName(e.houseNameUnformatted)
			e.collectibleId = GetCollectibleIdForHouse(e.houseId)
			e.nickName = BMU.formatName(GetCollectibleNickname(e.collectibleId))
			e.houseTooltip = {e.houseNameFormatted, "\"" .. e.nickName .. "\""}
			
			e = BMU.addInfo_1(e, currentZoneId, playersZoneId, "")
			if BMU.filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex) then
				e = BMU.addInfo_2(e)
				-- overwrite
				e.mapIndex = BMU.getMapIndex(houseZoneId)
				e.parentZoneId = BMU.getParentZoneId(houseZoneId)
				-- add manually
				--allZoneIds[e.zoneId] = allZoneIds[e.zoneId] + 1
				table.insert(TeleportAllPlayersTable, e)
			end
		end
	end
	
	if BMU.savedVarsAcc.showZonesWithoutPlayers2 or index == 3 then
		-- 5. add all overland zones without players
		for overlandZoneId, _ in pairs(BMU.overlandDelvesPublicDungeons) do
			local e = {}
			e.zoneId = overlandZoneId
			e.displayName = ""
			e.zoneName = GetZoneNameById(overlandZoneId)
			e.zoneWithoutPlayer = true
			e = BMU.addInfo_1(e, currentZoneId, playersZoneId, "")
			if BMU.filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex) then
				e = BMU.addInfo_2(e)
				e.textColorDisplayName = "dred"
				e.textColorZoneName = "dred"
				table.insert(TeleportAllPlayersTable, e)
			end
		end
	end
	
	portalPlayers = TeleportAllPlayersTable
	
	-- display number of hits (port alternatives)
	-- not needed in case of only current zone (1) and favorite zoneId (6 and 8)
	if BMU.savedVarsAcc.showNumberPlayers and not (index == 1 or index == 6 or index == 8) then
		portalPlayers = BMU.addNumberPlayers(portalPlayers)
	end
	
	if index == 4 then
		-- related items
		portalPlayers = BMU.syncWithItems(portalPlayers) -- returns already sorted list
	elseif index == 9 then
		-- related quests
		portalPlayers = BMU.syncWithQuests(portalPlayers) -- returns already sorted list
	elseif index == 2 then
		-- search by player name
		-- sort by string match position (displayName and characterName)
		portalPlayers = BMU.sortByStringFindPosition(portalPlayers, inputString, "displayName", "characterName")
	elseif index == 3 then
		-- search by zone name
		-- sort by string match position (zoneName, zoneNameSecondLanguage)
		portalPlayers = BMU.sortByStringFindPosition(portalPlayers, inputString, "zoneName", "zoneNameSecondLanguage")
	else
		-- SORTING
		if BMU.savedVarsChar.sorting == 2 then
			-- sort by prio, category, zoneName, prio by source
			table.sort(portalPlayers, function(a, b)
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
				return BMU.decidePrioDisplay(a, b)
			end)
			
		elseif BMU.savedVarsChar.sorting == 3 then
			-- sort by prio, most used, zoneName, prio by source
			table.sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- most used
				local num1 = BMU.savedVarsAcc.portCounterPerZone[a.zoneId] or 0
				local num2 = BMU.savedVarsAcc.portCounterPerZone[b.zoneId] or 0
				if num1 ~= num2 then
					return num1 > num2
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU.decidePrioDisplay(a, b)
			end)
			
		elseif BMU.savedVarsChar.sorting == 4 then
			-- sort by prio, most used, category, zoneName, prio by source
			table.sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- most used
				local num1 = BMU.savedVarsAcc.portCounterPerZone[a.zoneId] or 0
				local num2 = BMU.savedVarsAcc.portCounterPerZone[b.zoneId] or 0
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
				return BMU.decidePrioDisplay(a, b)
			end)
		
		elseif BMU.savedVarsChar.sorting == 5 then
			-- sort by prio, number players, zoneName, prio by source
			table.sort(portalPlayers, function(a, b)
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
				return BMU.decidePrioDisplay(a, b)
			end)
			
		elseif BMU.savedVarsChar.sorting == 6 then
			-- sort by prio, number of undiscovered wayshrines, zone category, zoneName, prio by source
			table.sort(portalPlayers, function(a, b)
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
				return BMU.decidePrioDisplay(a, b)
			end)
		
		elseif BMU.savedVarsChar.sorting == 7 then
			-- sort by prio, number of undiscovered skyshards, zone category, zoneName, prio by source
			table.sort(portalPlayers, function(a, b)
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
				return BMU.decidePrioDisplay(a, b)
			end)
			
		elseif BMU.savedVarsChar.sorting == 8 then
			-- sort by prio, last used, zoneName, prio by source
			table.sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- last used
				local pos1 = BMU.has_value(BMU.savedVarsAcc.lastPortedZones, a.zoneId) or 99
				local pos2 = BMU.has_value(BMU.savedVarsAcc.lastPortedZones, b.zoneId) or 99
				if pos1 ~= pos2 then
					return pos1 < pos2
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU.decidePrioDisplay(a, b)
			end)
			
		elseif BMU.savedVarsChar.sorting == 9 then
			-- sort by prio, last used, category, zoneName, prio by source
			table.sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- last used
				local pos1 = BMU.has_value(BMU.savedVarsAcc.lastPortedZones, a.zoneId) or 99
				local pos2 = BMU.has_value(BMU.savedVarsAcc.lastPortedZones, b.zoneId) or 99
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
				return BMU.decidePrioDisplay(a, b)
			end)
			
		elseif BMU.savedVarsChar.sorting == 10 then
			-- sort by prio, number of missing set items, category, zoneName, prio by source
			table.sort(portalPlayers, function(a, b)
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
				return BMU.decidePrioDisplay(a, b)
			end)
			
		elseif BMU.savedVarsChar.sorting == 11 then
			-- sort by prio, category, zones without players, zoneName, prio by source
			table.sort(portalPlayers, function(a, b)
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
				return BMU.decidePrioDisplay(a, b)
			end)
			
		else -- BMU.savedVarsChar.sorting == 1
			-- sort by prio, zoneName, prio by source
			table.sort(portalPlayers, function(a, b)
				-- prio
				if a.prio ~= b.prio then
					return a.prio < b.prio
				end
				-- zoneName
				if a.zoneName ~= b.zoneName then
					return a.zoneName < b.zoneName
				end
				-- prio by source
				return BMU.decidePrioDisplay(a, b)
			end)
		end
	end
	
	-- in case of no results, add message with information
	if #portalPlayers == 0 then
		table.insert(portalPlayers, BMU.createNoResultsInfo())
	end
	
	if BMU.debugMode == 1 then
		-- get end time and print runtime in milliseconds
		BMU.printToChat("RunTime: " .. (GetGameTimeMilliseconds() - startTime) .. " ms")
	end
	
	-- display or return result
	if dontDisplay == true then
		return portalPlayers
	else
		TeleporterList:add_messages(portalPlayers, dontResetSlider)
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
	e.zoneName = BMU.formatName(e.zoneName, BMU.savedVarsAcc.formatZoneName)
	
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
		if sourceIndexLeading == TELEPORTER_SOURCE_INDEX_GROUP then
			table.insert(e.sources, TELEPORTER_SOURCE_INDEX_GROUP)
			table.insert(e.sourcesText, BMU.colorizeText(GetString(SI_GAMEPAD_CAMPAIGN_BROWSER_TOOLTIP_GROUP_MEMBERS), "orange"))
		end
		
		-- is Friend?
		if sourceIndexLeading == TELEPORTER_SOURCE_INDEX_FRIEND or IsFriend(e.displayName) then
			table.insert(e.sources, TELEPORTER_SOURCE_INDEX_FRIEND)
			table.insert(e.sourcesText, BMU.colorizeText(GetString(SI_GAMEPAD_CAMPAIGN_BROWSER_TOOLTIP_FRIENDS), "green"))
		end
		
		-- is in Guild?
		local numGuilds = GetNumGuilds()
		for i = 1, numGuilds do
			local guildId = GetGuildId(i)
			if GetGuildMemberIndexFromDisplayName(guildId, e.displayName) ~= nil then
				table.insert(e.sources, _G["TELEPORTER_SOURCE_INDEX_GUILD" .. tostring(i)])
				table.insert(e.sourcesText, BMU.colorizeText(GetGuildName(guildId), "white"))
			end
		end
	end
	
	return e
end


-- adds second bunch of information after filterAndDecide
function BMU.addInfo_2(e)
	-- inititialize more values
	e.relatedItems = {}
	e.relatedQuests = {}
	e.countRelatedItems = 0
	e.relatedQuestsSlotIndex = {}
	e.countRelatedQuests = 0
	
	-- valid entry / show zone on click
	e.zoneNameClickable = true
	
	-- format alliance name
	if e.alliance ~= nil then
		e.allianceName = BMU.formatName(GetAllianceName(e.alliance), false)
	end
	
	-- add wayshrine discovery info (for zone tooltip)
	e.zoneWayhsrineDiscoveryInfo, e.zoneWayshrineDiscovered, e.zoneWayshrineTotal = BMU.getZoneGuideDiscoveryInfo(e.zoneId, ZONE_COMPLETION_TYPE_WAYSHRINES)
	-- add skyshard discovery info (for zone tooltip)
	e.zoneSkyshardDiscoveryInfo, e.zoneSkyshardDiscovered, e.zoneSkyshardTotal = BMU.getZoneGuideDiscoveryInfo(e.zoneId, ZONE_COMPLETION_TYPE_SKYSHARDS)
	-- add public dungeon completeness info (for zone tooltip)
	-- e.zonePublicDungeonDiscoveryInfo, e.zonePublicDungeonDiscovered, e.zonePublicDungeonTotal = BMU.getZoneGuideDiscoveryInfo(e.zoneId, ZONE_COMPLETION_TYPE_PUBLIC_DUNGEONS)
	-- add delve completeness info (for zone tooltip)
	-- e.zoneDelveDiscoveryInfo, e.zoneDelveDiscovered, e.zoneDelveTotal = BMU.getZoneGuideDiscoveryInfo(e.zoneId, ZONE_COMPLETION_TYPE_DELVES)
	
	-- categorize zone
	e.category = BMU.categorizeZone(e.zoneId)
	e.parentZoneId = BMU.getParentZoneId(e.zoneId)
	e.parentZoneName = BMU.formatName(GetZoneNameById(e.parentZoneId))
	-- get parent map index and zoneId (for map opening)
	e.mapIndex = BMU.getMapIndex(e.zoneId)
	
	-- check public dungeon achievement / skill point
	if e.category == TELEPORTER_ZONE_CATEGORY_OVERLAND then
		-- overland zone --> show completion of all public dungeons in the zone
		e.publicDungeonAchiementInfo = BMU.createPublicDungeonAchiementInfo(e.zoneId)
	elseif e.category == TELEPORTER_ZONE_CATEGORY_PUBDUNGEON then
		-- specific public dungeon --> show completion of itself
		e.publicDungeonAchiementInfo = BMU.createPublicDungeonAchiementInfo(e.parentZoneId, e.zoneId)
	end

	-- add set collection information
	e.setCollectionProgress = BMU.getSetCollectionProgressString(e.zoneId, e.category, e.parentZoneId)
	
	-- set colors
	if e.sourceIndexLeading == TELEPORTER_SOURCE_INDEX_GROUP then
		e.textColorDisplayName = "orange"
		e.textColorZoneName = "orange"
	elseif e.playersZone then
		e.textColorDisplayName = "blue"
		e.textColorZoneName = "blue"
	elseif e.sourceIndexLeading == TELEPORTER_SOURCE_INDEX_FRIEND then
		e.textColorDisplayName = "green"
		e.textColorZoneName = "green"
	else
		e.textColorDisplayName = "white"
		e.textColorZoneName = "white"
	end	
		
	--set prio
	local currentZoneId = GetZoneId(GetCurrentMapZoneIndex())
	if BMU.savedVarsAcc.currentViewedZoneAlwaysTop and (BMU.getParentZoneId(e.zoneId) == currentZoneId or e.zoneId == currentZoneId or e.zoneId == BMU.getParentZoneId(currentZoneId)) then
		-- current viewed zone + subzones
		e.prio = 0
		e.textColorDisplayName = "teal"
		e.textColorZoneName = "teal"
	elseif BMU.savedVarsAcc.currentZoneAlwaysTop and e.playersZone then
		-- current zone (players location)
		e.prio = 1
	elseif e.sourceIndexLeading == TELEPORTER_SOURCE_INDEX_GROUP and e.isLeader then
		-- group leader
		e.prio = 2
	elseif e.sourceIndexLeading == TELEPORTER_SOURCE_INDEX_GROUP and (e.category == TELEPORTER_ZONE_CATEGORY_GRPDUNGEON or e.category == TELEPORTER_ZONE_CATEGORY_TRAIL or e.category == TELEPORTER_ZONE_CATEGORY_GRPZONES or e.category == TELEPORTER_ZONE_CATEGORY_GRPARENA or e.category == TELEPORTER_ZONE_CATEGORY_ENDLESSD) then
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
		e.prio = 6
		e.textColorZoneName = "gold"
	else
		e.prio = 7
	end
	
	return e
end


-- create tooltip text info about public dungeon achievement completion (group event / skill point)
function BMU.createPublicDungeonAchiementInfo(overlandZoneId, onlyPublicDungeonZoneId)
	local info = {}
	if BMU.overlandDelvesPublicDungeons[overlandZoneId] and BMU.overlandDelvesPublicDungeons[overlandZoneId].publicDungeonsAchievements then
		-- only for a specific public dungeon
		if onlyPublicDungeonZoneId then
			local publicDungeonAchvText = BMU.getColorizedPublicDungeonAchievementText(overlandZoneId, onlyPublicDungeonZoneId)
			if publicDungeonAchvText then
				table.insert(info, publicDungeonAchvText)
			end

		-- for all public dungeons of the zone
		else
			for publicDungeonZoneId, _ in pairs(BMU.overlandDelvesPublicDungeons[overlandZoneId].publicDungeonsAchievements) do
				local publicDungeonAchvText = BMU.getColorizedPublicDungeonAchievementText(overlandZoneId, publicDungeonZoneId)
				if publicDungeonAchvText then
					table.insert(info, publicDungeonAchvText)
				end
			end
		end

		-- add header and return info
		if #info > 0 then
			table.insert(info, 1, GetString(SI_LEVEL_UP_REWARDS_SKILL_POINT_TOOLTIP_HEADER) .. " (" .. SI.get(SI.TELE_UI_GROUP_EVENT) .. "):")
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
			return BMU.textures.acceptGreen .. "  " .. BMU.colorizeText(BMU.formatName(GetZoneNameById(publicDungeonZoneId)), "green")
		else
			return BMU.textures.declineRed .. "  " .. BMU.colorizeText(BMU.formatName(GetZoneNameById(publicDungeonZoneId)), "red")
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
		if localizedZoneName == nil or type(localizedZoneName) ~= "string" then return nil end
	
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
		
		if not (numUnlocked and numTotal) and (category == TELEPORTER_ZONE_CATEGORY_DELVE or category == TELEPORTER_ZONE_CATEGORY_PUBDUNGEON) and parentZoneId then
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
			progressString = BMU.colorizeText(progressString, "green")
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
		mapIndex = GetMapIndexByZoneId(BMU.getParentZoneId(zoneId))
	end
	
	-- in case the parent zone is also a sub zone (e.g. Asylum Sanctorium is in Brass Fortress is in Clockwork City)
	if mapIndex == nil then
		mapIndex = GetMapIndexByZoneId(BMU.getParentZoneId(BMU.getParentZoneId(zoneId)))
	end
		
	return mapIndex -- mapIndex can be nil
end


function BMU.filterAndDecide(index, e, inputString, currentZoneId, fZoneId, filterSourceIndex)
	-- do filtering and decide
	
	-- try to fix "-" issue
	if inputString ~= nil then
		inputString = string.gsub(inputString, "-", "--")
	end
	
	-- index == 1 -> only own zone
	if index == 1 then
		-- only add records of the current (displayed) zone (and ensure that a record without player (dark red) is only added if there is no other record -> see BMU.checkOnceOnly())
		-- OR if displayed zone is not overland and zone is parent of current zone (e.g. to see the parent overland zone in the list if the player is in a delve)
		if (e.currentZone and BMU.checkOnceOnly(false, e)) or (BMU.categorizeZone(currentZoneId) ~= TELEPORTER_ZONE_CATEGORY_OVERLAND and e.zoneId == BMU.getParentZoneId(currentZoneId) and BMU.checkOnceOnly(true, e)) then
			return true
		end
		
	-- index == 2 -> filter by player name
	elseif index == 2 then
		if (string.match(string.lower(e.displayName), string.lower(inputString)) or (BMU.savedVarsAcc.searchCharacterNames and string.match(string.lower(e.characterName), string.lower(inputString)))) then -- and not BMU.isBlacklisted(e.zoneId, e.sourceIndexLeading, BMU.savedVarsAcc.onlyMaps) and BMU.checkOnceOnly(BMU.savedVarsAcc.zoneOnceOnly, e)
			return true
		end
		
	-- index == 3 -> filter by zone name
	elseif index == 3 then
		if (string.match(string.lower(e.zoneName), string.lower(inputString)) or (BMU.savedVarsAcc.secondLanguage ~= 1 and string.match(string.lower(e.zoneNameSecondLanguage), string.lower(inputString)))) and not BMU.isBlacklisted(e.zoneId, e.sourceIndexLeading, BMU.savedVarsAcc.onlyMaps) and BMU.checkOnceOnly(BMU.savedVarsAcc.zoneOnceOnly, e) then
			return true
		end
		
	-- index == 4 -> search for related items
	elseif index == 4 then
		if not BMU.isBlacklisted(e.zoneId, e.sourceIndexLeading, BMU.savedVarsAcc.onlyMaps) and BMU.checkOnceOnly(true, e) then
			return true
		end
		
	-- index == 5 -> only Delves and Public Dungeons (in your own Zone or globally)
	elseif index == 5 then
		if BMU.savedVarsChar.showAllDelves then
			-- add all delves and public dungeons
			-- zone is delve or public dungeon + not blacklisted + add only once to list
			local zoneCategory = BMU.categorizeZone(e.zoneId)
			if (zoneCategory == TELEPORTER_ZONE_CATEGORY_DELVE or zoneCategory == TELEPORTER_ZONE_CATEGORY_PUBDUNGEON) and not BMU.isBlacklisted(e.zoneId, e.sourceIndexLeading, false) and BMU.checkOnceOnly(BMU.savedVarsAcc.zoneOnceOnly, e) then
				return true
			end
		else
			-- add delves and public dungeons only from current zone
			-- always use parent zone which is the same, when player is in e.g. overland zone
			-- check if parent zone has delves or public dungeons + zone is in the delves list of the parent zone OR zone is in the public dungeon list of the parent zone + not blacklisted + add only once to list
			if BMU.overlandDelvesPublicDungeons[BMU.getParentZoneId(currentZoneId)] and (BMU.isWhitelisted(BMU.overlandDelvesPublicDungeons[BMU.getParentZoneId(currentZoneId)].delves, e.zoneId, false) or BMU.isWhitelisted(BMU.overlandDelvesPublicDungeons[BMU.getParentZoneId(currentZoneId)].publicDungeons, e.zoneId, false)) and not BMU.isBlacklisted(e.zoneId, e.sourceIndexLeading, false) and BMU.checkOnceOnly(BMU.savedVarsAcc.zoneOnceOnly, e) then
				return true
			end
		end
		
	-- index == 6 -> looking for specific zone id (favorites, no state change)
	-- index == 8 -> looking for specific zone id (displaying, state change)
	elseif index == 6 or index == 8 then
		-- only one entry is needed for favorite search, but this function is also used to get ALL players for a specific zone
		if e.zoneId == fZoneId and BMU.checkOnceOnly(false, e) then
			return true
		end
	
	-- index == 7 -> looking for specific sourceIndex
	elseif index == 7 then
		-- add only player with given sourceIndex
		if BMU.has_value(e.sources, filterSourceIndex) then
			return true
		end
		
	-- add all / no filters (index == 0)
	else
		if (not BMU.isBlacklisted(e.zoneId, e.sourceIndexLeading, BMU.savedVarsAcc.onlyMaps) or BMU.isFavoritePlayer(e.displayName)) and BMU.checkOnceOnly(BMU.savedVarsAcc.zoneOnceOnly, e) then
			return true
		end
	end
	
	return false
end


-- check against blacklist
function BMU.isBlacklisted(zoneId, sourceIndex, onlyMaps)

	-- use hard filter (like whitelist) if active
	if onlyMaps then
		-- only check the indecies!
		if BMU.isWhitelisted(BMU.overlandDelvesPublicDungeons, zoneId, true) then
			return false
		else
			-- seperate filtering, if group member (whitelisting)
			if sourceIndex == TELEPORTER_SOURCE_INDEX_GROUP then
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
		if sourceIndex == TELEPORTER_SOURCE_INDEX_GROUP then
			--return true
			return not BMU.isWhitelisted(BMU.whitelistGroupMembers, zoneId, false)
		end
		return true
	else
		return false
	end
	
end


-- check against whitelist
function BMU.isWhitelisted(whitelist, zoneId, flag)
	if whitelist == nil then
		-- no whitelist for this zone
		return false
	end
	
	if not flag then
		-- normal search in a list (search for value)
		if BMU.has_value(whitelist, zoneId) then
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
	if type(tab) == "table" then
		for index, value in pairs(tab) do
			if value == val then
				return index
			end
		end
	end
    return false
end


-- search for a index
function BMU.has_value_special(tab, val)
	if type(tab) == "table" then
		for index, value in pairs(tab) do
			if index == val then
				return true
			end
		end
	end
    return false
end


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
			BMU.removeExistingEntry(record.zoneId)
			-- increment counter
			allZoneIds[record.zoneId] = allZoneIds[record.zoneId] + 1
			return true
		elseif BMU.decidePrioDisplay(record, BMU.getExistingEntry(record.zoneId)) then -- returns true, if first record is preferred
			-- zone already added, but prio is higher
			-- clean existing entry (when existing one is not favorite and not group member)
			BMU.removeExistingEntry(record.zoneId)
			-- increment counter
			allZoneIds[record.zoneId] = allZoneIds[record.zoneId] + 1
			return true
		elseif record.isOwnHouse and BMU.getExistingEntry(record.zoneId).isOwnHouse and record.nickName < BMU.getExistingEntry(record.zoneId).nickName then
			-- for this zone exists already an own house, but prio is higher (compare nicknames)
			-- clean existing entry and use this house instead
			BMU.removeExistingEntry(record.zoneId)
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
		return TELEPORTER_ZONE_CATEGORY_UNKNOWN			-- category index (unknown)
	end
end


-- connect survey and treasure maps from bags to port options and zones
function BMU.syncWithItems(portalPlayers)
	-- local function to identify the item as survey or treasure map (check itemType and custom mapping as backup)
	local function isSurveyMap(itemName, specializedItemType)
		return (specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT or string.match(string.lower(itemName), string.lower(SI.get(SI.CONSTANT_SURVEY_MAP))))
	end
	local function isTreasureMap(itemName, specializedItemType)
		return (specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP or string.match(string.lower(itemName), string.lower(SI.get(SI.CONSTANT_TREASURE_MAP))))
	end
	local function isClueMap(itemId, specializedItemType)
		local subType, _ = BMU.getDataMapInfo(itemId)
		return (specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_TRIBUTE_CLUE or subType == "clue")
	end
	-- local function check if the map type (coming from BMU.treasureAndSurveyMaps) is enabled by the user
	local function isSubtypeEnabled(subType)
		return BMU.savedVarsChar.displayMaps[subType] or false
	end
	
	local newTable ={}
	local unrelatedItemsRecords = {}
	local zonelessRecord = nil
	
	local bags = {BAG_BACKPACK}
	if BMU.savedVarsChar.scanBankForMaps then
		table.insert(bags, BAG_BANK)
		table.insert(bags, BAG_SUBSCRIBER_BANK)
	end
	
	-- go over all bags
	for index, bagId in ipairs(bags) do
		local lastSlot = GetBagSize(bagId)
		for slotIndex = 0, lastSlot, 1 do
			local itemName = GetItemName(bagId, slotIndex)
			local itemType, specializedItemType = GetItemType(bagId, slotIndex)
			local itemId = GetItemId(bagId, slotIndex)
			-- filter for relevant items and consider active option
			if (BMU.savedVarsChar.displayMaps.treasure and isTreasureMap(itemName, specializedItemType)) or (BMU.numOfSurveyTypesChecked() > 0 and isSurveyMap(itemName, specializedItemType)) or (BMU.savedVarsChar.displayMaps.clue and isClueMap(itemId, specializedItemType)) then
				-- determine subType and itemZoneId from global list
				local subType, itemZoneId = BMU.getDataMapInfo(itemId)
				if subType then
					-- filter valid subTypes
					if isSubtypeEnabled(subType) then
						-- create item data
						-- check if item is related to an entry in portalPlayers table (player can port to this location) and get updated record in portalPlayers table
						local isRelated, updatedRecord, recordIndex = BMU.itemIsRelated(portalPlayers, bagId, slotIndex, itemZoneId)
						if isRelated then
							-- item is related and connected to an entry in portalPlayers table
							-- update record in portalPlayers
							portalPlayers[recordIndex] = updatedRecord
						else
							-- item cannot be assigned to an entry in portalPlayers table
							-- but we know the item's zone from global list
							-- check if a record for the zone already exists
							local record = unrelatedItemsRecords[itemZoneId]
							if not record then
								-- create new record
								record = BMU.createClickableZoneRecord(itemZoneId)
							end
							-- add item to the record
							record = BMU.addItemInformation(record, bagId, slotIndex)
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
						zonelessRecord = BMU.createZoneLessItemsInfo()
					end
					-- add item data to record
					zonelessRecord = BMU.addItemInformation(zonelessRecord, bagId, slotIndex)
				end
			end
		end
	end
	
	if BMU.savedVarsChar.displayLeads then
		-- seperately: go over all leads and add them to "portalPlayers" and "unrelatedItemsRecords"
		local antiquityId = GetNextAntiquityId()
		while antiquityId do
			if DoesAntiquityHaveLead(antiquityId) then
				-- check if lead can be matched to an entry in portalPlayers table
				local isRelated, updatedRecord, recordIndex = BMU.leadIsRelated(portalPlayers, antiquityId)
				if isRelated then
					-- lead is related and connected to an entry in portalPlayers table
					-- update record in portalPlayers
					portalPlayers[recordIndex] = updatedRecord
				else
					local zoneId = GetAntiquityZoneId(antiquityId)
					-- lead cannot be assigned to an entry in portalPlayers table
					-- check if a record for the zone already exists
					local record = unrelatedItemsRecords[zoneId]
					if not record then
						-- create new record
						record = BMU.createClickableZoneRecord(zoneId)
					end
					-- add lead to the record
					record = BMU.addLeadInformation(record, antiquityId)
					-- save record
					unrelatedItemsRecords[zoneId] = record
				end
			end
			antiquityId = GetNextAntiquityId(antiquityId)
		end
	end
	
	
	-- clean portalPlayers table from entries without assigned items
	newTable = BMU.cleanUnrelatedRecords(portalPlayers)
	
	-- sort table by number of items and by name
	table.sort(newTable, function(a, b)
			if a.countRelatedItems ~= b.countRelatedItems then
				return a.countRelatedItems > b.countRelatedItems
			end
			return a.zoneName < b.zoneName
		end)
	
	-- sort records with unrelated items (maps without port possibility)
	table.sort(unrelatedItemsRecords, function(a, b)
			if a.countRelatedItems ~= b.countRelatedItems then
				return a.countRelatedItems > b.countRelatedItems
			end
			return a.zoneName < b.zoneName
		end)
		
	-- add them to the final table
	for zoneId, record in pairs(unrelatedItemsRecords) do
		table.insert(newTable, record)
	end
	
	-- add info with zoneless items
	if zonelessRecord then
		table.insert(newTable, zonelessRecord)
	end
	
	return newTable
end


-- try to find a record that matches with item's zone and update record
function BMU.itemIsRelated(portalPlayers, bagId, slotIndex, itemZoneId)
	local itemName = GetItemName(bagId, slotIndex)
	local itemId = GetItemId(bagId, slotIndex)

	-- go over all records in portalPlayers
	for index, record in ipairs(portalPlayers) do
		-- only check overland maps & Cyrodiil
		if record.category == TELEPORTER_ZONE_CATEGORY_OVERLAND or record.zoneId == 181 then
			-- try to match with zone
			if record.zoneId == itemZoneId then
				return true, BMU.addItemInformation(record, bagId, slotIndex), index
			end
		end
	end
	return false, nil, nil
end


-- check if a lead is related to a zone in given table
function BMU.leadIsRelated(portalPlayers, antiquityId)
	-- go over all records in portalPlayers
	for index, record in ipairs(portalPlayers) do
		-- only check overland maps
		if record.category == TELEPORTER_ZONE_CATEGORY_OVERLAND then
			-- try to match lead with zone
			if GetAntiquityZoneId(antiquityId) == record.zoneId then
				return true, BMU.addLeadInformation(record, antiquityId), index
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
	local itemName = color:Colorize(BMU.formatName(GetItemName(bagId, slotIndex), false))
	local itemTooltip = itemName
	
	if itemCount > 1 then
		-- change item name (add itemCount of this item)
		itemTooltip = itemTooltip .. BMU.colorizeText(" (" .. itemCount .. ")", "white")
	end
	
	if bagId ~= BAG_BACKPACK then
		-- coloring if item is not in inventory
		itemTooltip = BMU.colorizeText(GetString(SI_CURRENCYLOCATION1) .. ": ", "gray") .. itemTooltip
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
	
	table.insert(record.relatedItems, itemData)
	
	record.countRelatedItems = record.countRelatedItems + itemCount
	
	return record
end


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
					BMU.colorizeText(string.format(SI.get(SI.TELE_UI_DAYS_LEFT), math.floor(leadtimeleft/86400)) .. "\n" ..
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
	
	table.insert(record.relatedItems, leadData)
	record.countRelatedItems = record.countRelatedItems + 1
	return record
end


-- remove all records which have no related items
function BMU.cleanUnrelatedRecords(portalPlayers)
	local newTable = {}
	
	-- go over all records in portalPlayers
	for index, record in ipairs(portalPlayers) do
		if #record.relatedItems > 0 then
			table.insert(newTable, record)
		end
	end
	
	return newTable
end


-- create record for a concret (clickable) zone
-- e.g. for items which are connected to a zone but without port possibilities
-- e.g. overland zones that matches to a search string but without port possibilities
function BMU.createClickableZoneRecord(zoneId, currentZoneId, playersZondeId, sourceIndex)
	-- create a new record
	local record = BMU.createBlankRecord()
	record.zoneId = zoneId
	record.zoneName = BMU.formatName(GetZoneNameById(zoneId), BMU.savedVarsAcc.formatZoneName)
	record = BMU.addInfo_1(record, currentZoneId, playersZondeId, sourceIndex)
	record = BMU.addInfo_2(record)
	record.textColorDisplayName = "dred"
	record.textColorZoneName = "dred"
	return record
end


-- create record for items which could not be assigned to any zone
function BMU.createZoneLessItemsInfo()
	local info = BMU.createBlankRecord()
	info.zoneName = SI.get(SI.TELE_UI_UNRELATED_ITEMS)
	info.textColorDisplayName = "gray"
	info.textColorZoneName = "gray"
	info.zoneNameClickable = false -- show Tamriel on click
	
	return info
end


-- try to match zone to matchStr
-- return true if match with zone else return false
function BMU.tryMatchZoneToMatchStr(matchStr, zoneId)
	if matchStr == nil or matchStr == "" or zoneId == nil or zoneId == "" then
		return false
	end
	
	-- get zone name by game without articles !
	local zoneName = BMU.formatName(GetZoneNameById(zoneId), true)
	
	if zoneName == nil or zoneName == "" then
		return false
	end
	
	-- "-" issue:
	zoneName = string.gsub(zoneName, "-", "--")

	-- try to match
		-- handle "Alik'r desert" exception
	if (string.match(string.lower(matchStr), string.lower("Alik'r")) and string.match(string.lower(zoneName), string.lower("Alik'r")))
		-- handle "Morneroc" expception (FR)
		or (string.match(string.lower(matchStr), string.lower("Morneroc")) and string.match(string.lower(zoneName), string.lower("Morneroc")))
		-- hanlde "Bleakrock" expception (EN)
		or (string.match(string.lower(matchStr), string.lower("Bleakrock")) and string.match(string.lower(zoneName), string.lower("Bleakrock")))
		-- handle "Wrothgar - Orsinium" exception (EN, FR, DE)
		or (string.match(string.lower(matchStr), string.lower("Orsinium")) and string.match(string.lower(zoneName), string.lower("Wrothgar")))
		-- handle "Greymoor Kaverns" exception (DE)
		or (string.match(string.lower(matchStr), string.lower("Graumoorkaverne")) and string.match(string.lower(zoneName), string.lower("Graumoorkaverne")))
		-- handle "Greymoor Kaverns" exception (FR)
		or (string.match(string.lower(matchStr), string.lower("Griselande")) and string.match(string.lower(zoneName), string.lower("Griselande")))
		-- normal match
		or (string.match(string.lower(matchStr), string.lower(zoneName))) then
			return true
	else
			return false
	end
end


-- connect quests with found zones
function BMU.syncWithQuests(portalPlayers)
-- go over all active quests
-- for each quest go over all portalPlayers entries and find the zone
	-- if found add the information and break/go to next quest
	-- else add the quest to unrelated quest table
	local newTable ={}
	local unRelatedQuests = {}
	
	-- go over all quest slotIndices
	for slotIndex = 1, GetNumJournalQuests() do
		local isRelated, updatedRecord, recordIndex = BMU.questIsRelated(portalPlayers, slotIndex) -- check if quest is related to entry in portalPlayers table and return new record and its index
		if isRelated then
			-- quest is related and connected to an entry in portalPlayers table
			-- update record in result table
			portalPlayers[recordIndex] = updatedRecord
		else
			-- quest is not related to an entry -> save slotIndex for UnRelatedQuestInfo
			table.insert(unRelatedQuests, slotIndex)
		end
	end
	
	-- clean result table from zones without related quests
	newTable = BMU.cleanUnrelatedRecords2(portalPlayers)
	
	-- create table of records of unrelated quests with their zones (maybe empty) & returns list of zoneless quests
	local unrelatedQuestsRecords, zoneLessQuests = BMU.createUnrelatedQuestsRecords(unRelatedQuests)
	if next(unrelatedQuestsRecords) ~= nil then
		for _, record in pairs(unrelatedQuestsRecords) do
			table.insert(newTable, record)
		end
	end
	
	-- are there any zoneless quests?
	if next(zoneLessQuests) ~= nil then
		-- create entry for zoneless quests (maybe empty)
		local zoneLessQuestsRecord = BMU.createZoneLessQuestsInfo(zoneLessQuests)
		if next(zoneLessQuestsRecord) ~= nil then
			table.insert(newTable, zoneLessQuestsRecord)
		end
	end
	
	-- sort table
	table.sort(newTable, function(a, b)
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
function BMU.cleanUnrelatedRecords2(portalPlayers)
	local newTable = {}
	
	-- go over all records in portalPlayers
	for index, record in ipairs(portalPlayers) do
		if record.countRelatedQuests > 0 then
			table.insert(newTable, record)
		end
	end
	
	return newTable
end


-- creates table of records with quests and their zones (zone without players)
function BMU.createUnrelatedQuestsRecords(unRelatedQuests)
	local unrelatedQuestsRecords = {}
	local zoneLessQuests = {}
	
	for _, slotIndex in ipairs(unRelatedQuests) do
		--local questName = GetJournalQuestName(slotIndex)
		local questName, _, _, _, _, _, tracked = GetJournalQuestInfo(slotIndex)
		local questZoneName, objectiveName, questZoneIndex, poiIndex = GetJournalQuestLocationInfo(slotIndex)
		local questZoneId = GetZoneId(questZoneIndex)
		if questZoneId ~= 0 then
			-- get exact quest location
			questZoneId = BMU.findExactQuestLocation(slotIndex)
			questZoneName =  BMU.formatName(GetZoneNameById(questZoneId), BMU.savedVarsAcc.formatZoneName)
		end
		local questRepeatType = GetJournalQuestRepeatType(slotIndex)
		
		if tracked then
			questName =  BMU.colorizeText(questName, "gold")
		elseif questRepeatType == 1 or questRepeatType == 2 then
		-- color repeatable quests (1,2: repeatable quest | 0: not repeatable)
			questName = BMU.colorizeText(questName, "teal")
		end
	
		if questZoneId == 0 then
			-- zoneless quest
			table.insert(zoneLessQuests, slotIndex)
		else
			if unrelatedQuestsRecords[questZoneId] == nil then
				-- create a new record
				local record = BMU.createClickableZoneRecord(questZoneId)
				-- set color and prio
				if tracked then
					record.prio = 1
					record.textColorZoneName = "gold"
				else
					record.prio = 3
					record.textColorZoneName = "dred"
				end
				record.countRelatedQuests = 1
				-- add quest name
				table.insert(record.relatedQuests, questName)
				-- add questIndex for quest map ping
				table.insert(record.relatedQuestsSlotIndex, slotIndex)
				unrelatedQuestsRecords[questZoneId] = record
			else
				-- add quest to already existing record
				local record = unrelatedQuestsRecords[questZoneId]
				-- increment counter
				record.countRelatedQuests = record.countRelatedQuests + 1
				-- add quest name to relatedList
				table.insert(record.relatedQuests, questName)
				-- add questIndex for quest map ping
				table.insert(record.relatedQuestsSlotIndex, slotIndex)
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
	info.zoneName = SI.get(SI.TELE_UI_UNRELATED_QUESTS)
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
			questName =  BMU.colorizeText(questName, "gold")
		elseif questRepeatType == 1 or questRepeatType == 2 then
		-- color repeatable quests (1,2: repeatable quest | 0: not repeatable)
			questName = BMU.colorizeText(questName, "teal")
		end
		-- increment counter
		info.countRelatedQuests = info.countRelatedQuests + 1
		-- add quest name to relatedList
		table.insert(info.relatedQuests, questName)
		-- add questIndex for quest map ping
		table.insert(info.relatedQuestsSlotIndex, slotIndex)
		-- change color of record if contains tracked quest
		if tracked then
			info.textColorZoneName = "gold"
		end
	end

	return info
end


-- check if a quest is related to an entry of the portalPlayers table and return the new record
function BMU.questIsRelated(portalPlayers, slotIndex)
	--local questName = GetJournalQuestName(slotIndex)
	local questName, _, _, _, _, _, tracked = GetJournalQuestInfo(slotIndex)
	local zoneName, objectiveName, questZoneIndex, poiIndex = GetJournalQuestLocationInfo(slotIndex)
	local questZoneId = GetZoneId(questZoneIndex)
	if questZoneId ~= 0 then
		-- get exact quest location
		questZoneId = BMU.findExactQuestLocation(slotIndex)
		questZoneName =  BMU.formatName(GetZoneNameById(questZoneId), BMU.savedVarsAcc.formatZoneName)
	end
	local questRepeatType = GetJournalQuestRepeatType(slotIndex)
	
	if tracked then
		questName = BMU.colorizeText(questName, "gold")
	elseif questRepeatType == 1 or questRepeatType == 2 then
	-- color repeatable quests (1,2: repeatable quest | 0: not repeatable)
		questName = BMU.colorizeText(questName, "teal")
	end
	
	-- go over all records in portalPlayers
	for index, record in ipairs(portalPlayers) do
		if record.zoneId == questZoneId then
			-- add quest name to record
			table.insert(record.relatedQuests, questName)
			-- add questIndex for quest map ping
			table.insert(record.relatedQuestsSlotIndex, slotIndex)
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


function BMU.createNoResultsInfo()
	local info = BMU.createBlankRecord()
	info.zoneName = GetString(SI_ITEM_SETS_BOOK_SEARCH_NO_MATCHES)
	info.textColorDisplayName = "gray"
	info.textColorZoneName = "gray"
	info.zoneNameClickable = false -- show Tamriel on click
	return info
end


-- checks if specific zone is a favorite
function BMU.isFavoriteZone(zoneId)
	return BMU.has_value(BMU.savedVarsServ.favoriteListZones, zoneId)
end


-- checks if specific player is a favorite
function BMU.isFavoritePlayer(displayName)
	return BMU.has_value(BMU.savedVarsServ.favoriteListPlayers, displayName)
end


-- removes an existing entry (already added zoneId) from table (TeleportAllPlayersTable) if it is not a player favorite or group member
function BMU.removeExistingEntry(zoneId)
	for index, record in pairs(TeleportAllPlayersTable) do
		if record.zoneId == zoneId and not BMU.isFavoritePlayer(record.displayName) and record.sourceIndexLeading ~= TELEPORTER_SOURCE_INDEX_GROUP then
			table.remove(TeleportAllPlayersTable, index)
		end
	end
end


-- returns the record from table (TeleportAllPlayersTable) located at given zoneId
function BMU.getExistingEntry(zoneId)
	for index, record in pairs(TeleportAllPlayersTable) do
		if record.zoneId == zoneId then
			return record
		end
	end
	d("NOT FOUND: " .. zoneId)
end


-- returns true if the first record is preferred
-- return false if the second record is preferred
function BMU.decidePrioDisplay(record1, record2)
	if record1.isLeader and not record2.isLeader then
		return true
	elseif record2.isLeader and not record1.isLeader then
		return false
	elseif record1.sourceIndexLeading == TELEPORTER_SOURCE_INDEX_GROUP and record2.sourceIndexLeading ~= TELEPORTER_SOURCE_INDEX_GROUP then
		-- group is always comes first
		return true
	elseif record1.sourceIndexLeading ~= TELEPORTER_SOURCE_INDEX_GROUP and record2.sourceIndexLeading == TELEPORTER_SOURCE_INDEX_GROUP then
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
		table.insert(newTable, record)
	end
	
	return newTable
end


-- find itemId in global list and return subType and zoneId
function BMU.getDataMapInfo(itemId)
	-- go over all overland zones in global list
	for zoneId, typeList in pairs(BMU.treasureAndSurveyMaps) do
		for mapType, itemList in pairs(typeList) do
			-- check if itemList contains itemId
			if BMU.has_value(itemList, itemId) then
				return mapType, zoneId
			end
		end
	end
	return false
end


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


function BMU.createTableHouses()
	-- change global state to 11, to have the correct tab active
	BMU.changeState(11)
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
	
		if BMU.savedVarsChar.houseNickNames then
			-- show nick name instead of real house name
			entry.zoneName = entry.nickName
		end
		
		table.insert(resultList, entry)
	end
	
	-- sort
	table.sort(resultList, function(a, b)
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
		table.insert(resultList, BMU.createNoResultsInfo())
	end
	
	TeleporterList:add_messages(resultList)
end


function BMU.createTablePTF()
	if not PortToFriend or not PortToFriend.GetFavorites then
		return
	end
	-- change global state to 12, to have the correct tab active
	BMU.changeState(12)
	local resultList = {}
	
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
			entry.mapIndex = BMU.getMapIndex(entry.zoneId)
			entry.parentZoneId = BMU.getParentZoneId(entry.zoneId)
			entry.parentZoneName = BMU.formatName(GetZoneNameById(entry.parentZoneId))
			entry.category = BMU.categorizeZone(entry.zoneId)
			entry.collectibleId = GetCollectibleIdForHouse(entry.houseId)
			entry.houseCategoryType = GetString("SI_HOUSECATEGORYTYPE", GetHouseCategoryType(entry.houseId))
			entry.zoneName = BMU.formatName(entry.zoneNameUnformatted)
			
			_, _, entry.houseIcon = GetCollectibleInfo(entry.collectibleId)
			entry.houseBackgroundImage = GetHousePreviewBackgroundImage(entry.houseId)
			entry.houseTooltip = {entry.zoneName, entry.parentZoneName, "", "", "|t75:75:" .. entry.houseIcon .. "|t", "", "", entry.houseCategoryType}
			
			-- current / displayed zone depending on map status
			local currentZoneId = BMU.getCurrentZoneId()
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
			
			table.insert(resultList, entry)
		end
		
		-- sort
		table.sort(resultList, function(a, b)
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
	
	table.insert(resultList, openPTF)
	
	TeleporterList:add_messages(resultList)
end


-- adds matching overland zones to the result list
-- return sorted result list ready for display
function BMU.addOverlandZoneMatches(portalPlayers, inputString, currentZoneId)
	-- go over complete overland list
	for overlandZoneId, _ in pairs(BMU.overlandDelvesPublicDungeons) do
		local entry = BMU.createClickableZoneRecord(overlandZoneId)
		-- add only if zone not already in result list + search string match
		if not allZoneIds[overlandZoneId] and (string.match(string.lower(entry.zoneName), string.lower(inputString)) or (BMU.savedVarsAcc.secondLanguage ~= 1 and string.match(string.lower(entry.zoneNameSecondLanguage), string.lower(inputString)))) then
			-- change text color if zone is displayed zone
			if entry.zoneId == currentZoneId then
				entry.textColorZoneName = "teal"
			end
			table.insert(portalPlayers, entry)
		end
	end

	return portalPlayers
end


-- sorting for search by displayName or zoneName
-- sorts the entries according to the position of the string match
-- keys are the used key field (e.g. "displayName" or "zoneName")
function BMU.sortByStringFindPosition(portalPlayers, inputString, key1, key2)
	table.sort(portalPlayers, function(a, b)
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
			local pos1 = string.find(string.lower(tostring(a[key1])), string.lower(inputString))
			local pos2 = string.find(string.lower(tostring(b[key1])), string.lower(inputString))
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
			local pos1 = string.find(string.lower(tostring(a[key2])), string.lower(inputString))
			local pos2 = string.find(string.lower(tostring(b[key2])), string.lower(inputString))
			if pos1 and not pos2 then
				return true
			elseif pos2 and not pos1 then
				return false
			elseif pos1 and pos2 then
				return pos1 < pos2
			end
		end		
	end)
	
	return portalPlayers
end


function BMU.createTableGuilds(repeatFlag)
	-- abort repeating the function if user switched to other tab
	if repeatFlag and BMU.state ~= 13 then
		return
	end

	-- change global state to 13, to have the correct tab active
	BMU.changeState(13)
	local resultList = {}
	
	-- headline for the official guilds
	local entry = BMU.createBlankRecord()
	entry.zoneName = "-- OFFICIAL GUILDS --"
	entry.textColorZoneName = "gray"
	table.insert(resultList, entry)
	
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
				entry.hideButton = false
				-- hide button and change text color if guild almost full
				if guildData.size >= 495 then
					entry.hideButton = true
					guildSizeText = BMU.colorizeText(guildSizeText, "red")
				end
				entry.guildTooltip = {guildData.headerMessage, BMU.textures.tooltipSeperator, prefixMembers .. guildSizeText, prefixLanguage .. GetString("SI_GUILDLANGUAGEATTRIBUTEVALUE", guildData.language)}
				entry.zoneName = GetString("SI_GUILDLANGUAGEATTRIBUTEVALUE", guildData.language) .. " || " .. guildSizeText
				table.insert(resultList, entry)
			end
		else
			success = false
		end
	end
	
	
	-- headline for the partner guilds
	local entry = BMU.createBlankRecord()
	entry.zoneName = "-- PARTNER GUILDS --"
	entry.textColorZoneName = "gray"
	table.insert(resultList, entry)
	
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
				entry.prio = 1
				-- change text color if guild almost full and reduce prio
				if guildData.size >= 495 then
					entry.prio = 2
					guildSizeText = BMU.colorizeText(guildSizeText, "red")
				end
				entry.guildTooltip = {guildData.headerMessage, BMU.textures.tooltipSeperator, prefixMembers .. guildSizeText, prefixLanguage .. GetString("SI_GUILDLANGUAGEATTRIBUTEVALUE", guildData.language)}
				entry.zoneName = GetString("SI_GUILDLANGUAGEATTRIBUTEVALUE", guildData.language) .. " || " .. guildSizeText
				table.insert(tempList, entry)
			end
		else
			success = false
		end
	end
	-- only sort partner guilds
	table.sort(tempList, function(a, b)
		if a.languageCode ~= b.languageCode then
			return a.languageCode < b.languageCode
		end
		if a.prio ~= b.prio then
			return a.prio < b.prio
		end
		if a.size ~= b.size then
			return a.size > b.size
		end
	end)
	-- add partner guild list to final list
	for _, v in pairs(tempList) do table.insert(resultList, v) end
	
	TeleporterList:add_messages(resultList)
	
	if not success then
		-- try again
		zo_callLater(function() BMU.createTableGuilds(true) end, 600)
	end
end



-- create table of Dungeons, Trials, Arenas depending on the settings
function BMU.createTableDungeons()
	-- change global state to 14, to have the correct tab active
	BMU.changeState(14)
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
				table.insert(resultListEndlessDungeons, entry)
			end
		end
		
		if BMU.savedVarsChar.dungeonFinder.sortByAcronym then
			-- sort by acronym
			table.sort(resultListEndlessDungeons, function(a, b)
				return a.acronym < b.acronym
			end)
		else
			-- sort by release and name
			table.sort(resultListEndlessDungeons, function(a, b)
				if a.updateNum ~= b.updateNum then
					return (a.updateNum < b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseASC) or (a.updateNum > b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC)
				end
				return a.zoneName < b.zoneName
			end)
		end
		
		-- add headline
		if #resultListEndlessDungeons > 0 then
			local entry = BMU.createBlankRecord()
			entry.zoneName = "-- " .. string.upper(SI.get(SI.TELE_UI_TOGGLE_ENDLESS_DUNGEONS)) .. " --"
			entry.textColorZoneName = "gray"
			table.insert(resultListEndlessDungeons, 1, entry)
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
				table.insert(resultListArenas, entry)
			end
		end
		
		if BMU.savedVarsChar.dungeonFinder.sortByAcronym then
			-- sort by acronym
			table.sort(resultListArenas, function(a, b)
				return a.acronym < b.acronym
			end)
		else
			-- sort by release and name
			table.sort(resultListArenas, function(a, b)
				if a.updateNum ~= b.updateNum then
					return (a.updateNum < b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseASC) or (a.updateNum > b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC)
				end
				return a.zoneName < b.zoneName
			end)
		end
		
		-- add headline
		if #resultListArenas > 0 then
			local entry = BMU.createBlankRecord()
			entry.zoneName = "-- " .. string.upper(SI.get(SI.TELE_UI_TOGGLE_ARENAS)) .. " --"
			entry.textColorZoneName = "gray"
			table.insert(resultListArenas, 1, entry)
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
				table.insert(resultListGroupArenas, entry)
			end
		end
		
		if BMU.savedVarsChar.dungeonFinder.sortByAcronym then
			-- sort by acronym
			table.sort(resultListGroupArenas, function(a, b)
				return a.acronym < b.acronym
			end)
		else
			-- sort by release and name
			table.sort(resultListGroupArenas, function(a, b)
				if a.updateNum ~= b.updateNum then
					return (a.updateNum < b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseASC) or (a.updateNum > b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC)
				end
				return a.zoneName < b.zoneName
			end)
		end
		
		-- add headline
		if #resultListGroupArenas > 0 then
			local entry = BMU.createBlankRecord()
			entry.zoneName = "-- " .. string.upper(SI.get(SI.TELE_UI_TOGGLE_GROUP_ARENAS)) .. " --"
			entry.textColorZoneName = "gray"
			table.insert(resultListGroupArenas, 1, entry)
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
				table.insert(resultListTrials, entry)
			end
		end
		
		if BMU.savedVarsChar.dungeonFinder.sortByAcronym then
			-- sort by acronym
			table.sort(resultListTrials, function(a, b)
				return a.acronym < b.acronym
			end)
		else
			-- sort by release and name
			table.sort(resultListTrials, function(a, b)
				if a.updateNum ~= b.updateNum then
					return (a.updateNum < b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseASC) or (a.updateNum > b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC)
				end
				return a.zoneName < b.zoneName
			end)
		end
		
		-- add headline
		if #resultListTrials > 0 then
			local entry = BMU.createBlankRecord()
			entry.zoneName = "-- " .. string.upper(SI.get(SI.TELE_UI_TOGGLE_TRIALS)) .. " --"
			entry.textColorZoneName = "gray"
			table.insert(resultListTrials, 1, entry)
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
				table.insert(resultListGroupDungeons, entry)
			end
		end
		
		if BMU.savedVarsChar.dungeonFinder.sortByAcronym then
			-- sort by acronym
			table.sort(resultListGroupDungeons, function(a, b)
				return a.acronym < b.acronym
			end)
		else
			-- sort by release and name
			table.sort(resultListGroupDungeons, function(a, b)
				if a.updateNum ~= b.updateNum then
					return (a.updateNum < b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseASC) or (a.updateNum > b.updateNum and BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC)
				end
				return a.zoneName < b.zoneName
			end)
		end
		
		-- add headline
		if #resultListGroupDungeons > 0 then
			local entry = BMU.createBlankRecord()
			entry.zoneName = "-- " .. string.upper(SI.get(SI.TELE_UI_TOGGLE_GROUP_DUNGEONS)) .. " --"
			entry.textColorZoneName = "gray"
			table.insert(resultListGroupDungeons, 1, entry)
		end
	end
	
	-- merge all lists together
	local resultList = {}
	for _, v in pairs(resultListEndlessDungeons) do table.insert(resultList, v) end
	for _, v in pairs(resultListArenas) do table.insert(resultList, v) end
	for _, v in pairs(resultListGroupArenas) do table.insert(resultList, v) end
	for _, v in pairs(resultListTrials) do table.insert(resultList, v) end
	for _, v in pairs(resultListGroupDungeons) do table.insert(resultList, v) end
	
	-- add no results info if player disabled all categories
	if #resultList == 0 then
		table.insert(resultList, BMU.createNoResultsInfo())
	end
	
	TeleporterList:add_messages(resultList)
end


-- creates an record for an dungeon entry
function BMU.createDungeonRecord(zoneId)
	local entry = BMU.createClickableZoneRecord(zoneId)
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
	entry.zoneName = BMU.formatName(entry.zoneNameUnformatted, BMU.savedVarsAcc.formatZoneName)
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


-- get completion info for specific zone and completionType
function BMU.getZoneGuideDiscoveryInfo(zoneId, completionType)

	-- check for any zone exceptions
	local mainZoneId = BMU.getMainZoneId(zoneId)
	if mainZoneId then
		zoneId = mainZoneId
	end

	local numCompletedActivities, totalActivities, numUnblockedActivities, blockingBranchErrorStringId = ZO_ZoneStories_Manager.GetActivityCompletionProgressValues(zoneId, completionType)
	if totalActivities == 0 then
		return nil
	end
	
	local infoString = numCompletedActivities .. "/" .. totalActivities
	if numCompletedActivities == totalActivities then
		infoString = BMU.colorizeText(infoString, "green")
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

