-- all functions which are reachable via slash commands
local SI = BMU.SI

-- Helper function to get zone name with fallback
local function getZoneNameWithFallback(zoneId)
	local zoneName = GetZoneNameById(zoneId)
	if zoneName and zoneName ~= "" then
		return zoneName
	end
	
	-- Try to get parent zone name if available
	if BMU.LibZone and BMU.LibZone.GetZoneGeographicalParentZoneId then
		local parentZoneId = BMU.LibZone.GetZoneGeographicalParentZoneId(zoneId)
		if parentZoneId and parentZoneId ~= zoneId then
			local parentZoneName = GetZoneNameById(parentZoneId)
			if parentZoneName and parentZoneName ~= "" then
				return parentZoneName .. " (Sub-zone ID: " .. tostring(zoneId) .. ")"
			end
		end
	end
	
	-- Try to get from LibZone data as fallback
	if BMU.LibZoneGivenZoneData then
		local langData = BMU.LibZoneGivenZoneData[string.lower(GetCVar("language.2") or "en")] or BMU.LibZoneGivenZoneData["en"]
		if langData and langData[zoneId] then
			return langData[zoneId]
		end
		
		-- Also try parent zone from LibZone data
		if BMU.LibZone and BMU.LibZone.GetZoneGeographicalParentZoneId then
			local parentZoneId = BMU.LibZone.GetZoneGeographicalParentZoneId(zoneId)
			if parentZoneId and parentZoneId ~= zoneId and langData[parentZoneId] then
				return langData[parentZoneId] .. " (Sub-zone ID: " .. tostring(zoneId) .. ")"
			end
		end
	end
	
	return "Unknown Zone ID: " .. tostring(zoneId)
end


-- register chat command either with LibSlashCommander or traditional
function BMU.registerChatCommand(command, callback, description)
	if BMU.LSC then
		BMU.LSC:Register(command, function(option) callback(option) end, description)
	else
		SLASH_COMMANDS[command] = function(option) callback(option) end
	end
end


-- register/activate all chat commands
function BMU.activateSlashCommands()

	-- Debug Mode (new slash commands will be activated)
	BMU.registerChatCommand("/bmu/misc/debug", function(option) BMU.sc_toggleDebugMode() end, "Enable debug mode")
	-- Switch language
	BMU.registerChatCommand("/bmu/misc/lang", function(option) BMU.sc_switchLanguage(option) end, "Switch client language")
	-- Getting current zone id
	BMU.registerChatCommand("/bmu/misc/current_zone_id", function(option) BMU.sc_getCurrentZoneId() end, "Print current zone id")
	-- Advertise addon
	BMU.registerChatCommand("/bmu/misc/advertise", function(option) StartChatInput("Fast Travel addon BeamMeUp. Check it out: http://bit.ly/bmu4eso") end, "Advertise BeamMeUp")

	-- Adding new player favorite
	BMU.registerChatCommand("/bmu/favorites/add/player", function(option) BMU.sc_addFavoritePlayer(option) end, "Add player favorite")
	-- Adding new zone favorite
	BMU.registerChatCommand("/bmu/favorites/add/zone", function(option) BMU.sc_addFavoriteZone(option) end, "Add zone favorite")
	-- Adding new wayshrine favorite
	BMU.registerChatCommand("/bmu/favorites/add/wayshrine", function(option) BMU.sc_addFavoriteWayshrine(option) end, "Add wayshrine favorite")

	-- Zone-specific house commands
	BMU.registerChatCommand("/bmu/house/set/current_zone", function(option) BMU.sc_setCurrentZoneHouse(option) end, "Set preferred house for current zone")
	BMU.registerChatCommand("/bmu/house/set/current_house", function(option) BMU.sc_setCurrentHouse(option) end, "Set current house as preferred for current zone")
	BMU.registerChatCommand("/bmu/house/set/zone", function(option) BMU.sc_setZoneHouse(option) end, "Set preferred house for specific zone")
	BMU.registerChatCommand("/bmu/house/clear/current_zone", function(option) BMU.sc_clearCurrentZoneHouse(option) end, "Clear zone-specific house preference for current zone")
	BMU.registerChatCommand("/bmu/house/clear/zone", function(option) BMU.sc_clearZoneHouse(option) end, "Clear zone-specific house preference for specific zone")
	BMU.registerChatCommand("/bmu/house/list", function() BMU.sc_listZoneHouses() end, "List all zone-specific house mappings")

	-- Port to goup leader
	BMU.registerChatCommand("/bmutp/leader", function(option) BMU.portToGroupLeader() end, "Port to group leader")
	-- Port to currently tracked/focused quest
	BMU.registerChatCommand("/bmutp/quest", function(option) BMU.portToTrackedQuestZone() end, "Port to focused quest")
	-- Port into own primary residence
	BMU.registerChatCommand("/bmutp/house", function(option) BMU.portToOwnHouse(true, nil, false, nil) end, "Port into primary residence")
	-- Port outside own primary residence
	BMU.registerChatCommand("/bmutp/house_out", function(option) BMU.portToOwnHouse(true, nil, true, nil) end, "Port outside primary residence")
	-- Port to current zone
	BMU.registerChatCommand("/bmutp/current_zone", function(option) BMU.portToCurrentZone() end, "Port to current zone")
	-- Port to parent zone
	BMU.registerChatCommand("/bmutp/parent_zone", function(option) BMU.portToParentZone() end, "Port to parent zone")

	-- switch player status
	BMU.registerChatCommand("/bmu/misc/on", function(option) SelectPlayerStatus(PLAYER_STATUS_ONLINE) end, "Status: online")
	BMU.registerChatCommand("/bmu/misc/off", function(option) SelectPlayerStatus(PLAYER_STATUS_OFFLINE) end, "Status: offline")
	BMU.registerChatCommand("/bmu/misc/afk", function(option) SelectPlayerStatus(PLAYER_STATUS_AWAY) end, "Status: away")
	BMU.registerChatCommand("/bmu/misc/dnd", function(option) SelectPlayerStatus(PLAYER_STATUS_DO_NOT_DISTURB) end, "Status: dont disturb")

	-- Starting custom group vote
	BMU.registerChatCommand("/bmu/vote/custom_vote_unanimous", function(option) BMU.sc_customVoteUnanimous(option) end, "Custom vote (100%)")
	BMU.registerChatCommand("/bmu/vote/custom_vote_simplemajority", function(option) BMU.sc_customVoteSimplemajority(option) end, "Custom vote (>=50%)")

	-- Initialize chat commands for porting (/bmutp...)
	BMU.sc_initializeSlashPorting()

	-- refresh chat commands cache (for auto completing)
	--SLASH_COMMAND_AUTO_COMPLETE:InvalidateSlashCommandCache()
end


function BMU.sc_toggleDebugMode()
	if BMU.debugMode then
		BMU.debugMode = false
		BMU.printToChat("Debug mode disabled")
	else
		BMU.debugMode = true
		BMU.printToChat("Debug mode enabled")
	end
end


function BMU.sc_switchLanguage(option)
	if option == "de" or option == "en" or option == "fr" or option == "ru" or option == "es" or option == "pl" or option == "it" or option == "jp" or option == "br" or option == "kr" or option == "zh" then
		SetCVar("language.2",option)
	else
		BMU.printToChat("invalid language code")
		BMU.printToChat("only en, de, fr, ru, es, jp, pl, it, br, kr or zh allowed")
	end
end


-- Examples:
-- "/bmu/favorites/add/player 1 @Gamer1968PAN"
function BMU.sc_addFavoritePlayer(option)
	local options = BMU.sc_parseOptions(option)
	local position = tonumber(options[1])
	local displayName = options[2]
	
	if displayName ~= nil and string.sub(displayName, 1, 1) == "@" and position ~= nil and position >= 1 and position <= BMU.var.numFavoritePlayers then
		BMU.addFavoritePlayer(position, displayName)
	else
		BMU.printToChat("invalid input")
		BMU.printToChat("<favorite slot (1-5)>  <player name (@...)>")
	end
end


-- Examples:
-- "/bmu/favorites/add/zone 1 57"
-- "/bmu/favorites/add/zone 1 Deshaan"
function BMU.sc_addFavoriteZone(option)
	local options = BMU.sc_parseOptions(option)
	local position = tonumber(options[1])
	-- second parameter is number -> zoneId
	-- or concat the params to one zone name (e.g. "High Isle" is incoming as 2 params)
	local zoneNameOrId = tonumber(options[2]) or table.concat({unpack(options, 2)}, " ")

	local zoneId = tonumber(zoneNameOrId) or BMU.getZoneIdFromZoneName(zoneNameOrId)
	local zoneName = BMU.formatName(GetZoneNameById(zoneId), BMU.savedVarsAcc.formatZoneName)
	
	if zoneName ~= nil and zoneName ~= "" and position ~= nil and position >= 1 and position <= BMU.var.numFavoriteZones then
		BMU.addFavoriteZone(position, zoneId, zoneName)
	else
		BMU.printToChat("invalid input")
		BMU.printToChat("<favorite slot (1-10)>  <zone (zoneId or zone name)>")
	end
end


-- Examples:
-- "/bmu/favorites/add/wayshrine 1"
function BMU.sc_addFavoriteWayshrine(option)
	local function updateWayshrineInteraction(eventCode, nodeIndex)
		BMU.savedVarsServ.favoriteListWayshrines[BMU.favWayshrineCurrentPosition] = nodeIndex
		local _, name, _, _, _, _, _, _, _ = GetFastTravelNodeInfo(nodeIndex)
		BMU.printToChat(SI.get(SI.TELE_KEYBINDING_WAYSHRINE_FAVORITE) .. " " .. BMU.favWayshrineCurrentPosition .. ": " .. BMU.formatName(name), BMU.MSG_AD)
	end

	-- extract position (slot) number from input options
	local options = BMU.sc_parseOptions(option)
	local position = tonumber(options[1])
	if position == nil or position < 1 or position > BMU.var.numFavoriteWayshrines then
		BMU.printToChat("invalid input")
		BMU.printToChat("<favorite slot (1-3)>")
		return
	end
	-- remember requested fav position/slot
	BMU.favWayshrineCurrentPosition = position

	-- start interaction countdown - player has to interact with a wayshrine within the countdown
	local countDownSec = 10
	EVENT_MANAGER:RegisterForEvent(BMU.var.appName,  EVENT_START_FAST_TRAVEL_INTERACTION, updateWayshrineInteraction)
	zo_callLater(function() EVENT_MANAGER:UnregisterForEvent(BMU.var.appName, EVENT_START_FAST_TRAVEL_INTERACTION) end, countDownSec*1000)
	BMU.printToChat("Interact with your favorite wayshrine in the next 10 seconds!", BMU.MSG_AD)
end


function BMU.sc_getCurrentZoneId()
	local playersZoneIndex = GetUnitZoneIndex("player")
	local playersZoneId = GetZoneId(playersZoneIndex)
	BMU.printToChat("Current zone id: " .. playersZoneId)
end


function BMU.sc_customVoteUnanimous(option)
	if option ~= nil and option ~= "" then
		BeginGroupElection(GROUP_ELECTION_TYPE_GENERIC_UNANIMOUS, option)
	else
		BMU.printToChat("invalid custom text")
	end
end


function BMU.sc_customVoteSupermajority(option)
	if option ~= nil and option ~= "" then
		BeginGroupElection(GROUP_ELECTION_TYPE_GENERIC_SUPERMAJORITY, option)
	else
		BMU.printToChat("invalid custom text")
	end
end


function BMU.sc_customVoteSimplemajority(option)
	if option ~= nil and option ~= "" then
		BeginGroupElection(GROUP_ELECTION_TYPE_GENERIC_SIMPLEMAJORITY, option)
	else
		BMU.printToChat("invalid custom text")
	end
end


function BMU.sc_initializeSlashPorting()

	-- create static blacklist (add everything where the player can not port to)
	BMU.blacklistForSlashPorting = {}
	BMU.sc_joinBlacklistForSlashPorting(BMU.blacklistOthers)
	BMU.sc_joinBlacklistForSlashPorting(BMU.blacklistSoloArenas)
	BMU.sc_joinBlacklistForSlashPorting(BMU.blacklistRefuges)
	BMU.sc_joinBlacklistForSlashPorting(BMU.blacklistCyro)
	BMU.sc_joinBlacklistForSlashPorting(BMU.blacklistImpCity)
	BMU.sc_joinBlacklistForSlashPorting(BMU.blacklistBattlegrounds)
	BMU.sc_joinBlacklistForSlashPorting(BMU.blacklistGroupDungeons)
	BMU.sc_joinBlacklistForSlashPorting(BMU.blacklistRaids)
	BMU.sc_joinBlacklistForSlashPorting(BMU.blacklistGroupZones)
	BMU.sc_joinBlacklistForSlashPorting(BMU.blacklistGroupArenas)
	BMU.sc_joinBlacklistForSlashPorting(BMU.blacklistEndlessDungeons)

	-- initialize chat commands
	-- check if zone name data is available in client language
	-- use English zoneData if zoneData in client language is not available
	local libZoneData = BMU.LibZoneGivenZoneData
	local zoneData = libZoneData[string.lower(BMU.lang)] or libZoneData["en"]
	if zoneData ~= nil then
		local blacklistForSlashPorting = BMU.blacklistForSlashPorting
		
		for zoneId, zoneName in pairs(zoneData) do
			if type(zoneId) == "number" and type(zoneName) == "string" then
				local zoneNameFormatted = BMU.formatName(zoneName, BMU.savedVarsAcc.formatZoneName)
				local comName = "/bmutp/" .. string.gsub(string.lower(zoneNameFormatted), " ", "_")
				if SLASH_COMMANDS[comName] == nil and CanJumpToPlayerInZone(zoneId) and not blacklistForSlashPorting[zoneId] then -- dont overwrite existing command, check for solo zones by game, check for blacklisting
					BMU.registerChatCommand(comName, function(option) BMU.sc_porting(zoneId) end, zoneNameFormatted)
				end
			end
		end
	end
end


function BMU.sc_joinBlacklistForSlashPorting(list)
	-- join the lists to global blacklist (merge to HashMap instead to a list)
	local blacklistForSlashPorting = BMU.blacklistForSlashPorting
	for index, value in ipairs(list) do
		blacklistForSlashPorting[value] = true
	end
end


function BMU.sc_porting(zoneId)
	local resultTable = BMU.createTable({index=BMU.indexListZoneHidden, fZoneId=zoneId, dontDisplay=true})
	local entry = resultTable[1]
	
	if entry.displayName ~= nil and entry.displayName ~= "" then
		-- usual entry with player or house
		BMU.PortalToPlayer(entry.displayName, entry.sourceIndexLeading, entry.zoneName, entry.zoneId, entry.category, true, true, true)
	elseif BMU.savedVarsAcc.showZonesWithoutPlayers2 and BMU.isZoneOverlandZone(zoneId) then
		-- travel for gold only possible for overland zones
		BMU.PortalToZone(zoneId)
	else
		-- no travel option
		BMU.printToChat(SI.get(SI.TELE_CHAT_NO_FAST_TRAVEL))
	end
end


function BMU.sc_parseOptions(option)
	local options = {}
    local searchResult = { string.match(option,"^(%S*)%s*(.-)$") }
    for i,v in pairs(searchResult) do
        if (v ~= nil and v ~= "") then
            options[i] = v
        end
    end
	return options
end



--------------------------------------------------
-- STUFF / UTILITIES / DEVELOP
--------------------------------------------------

-- check if any member of guild 1 is also in any other guilds of the player
function BMU.sc_compareAllGuilds()
	local numGuilds = GetNumGuilds()
	if numGuilds < 2 then
		d("No guilds to compare!")
		return
	end
	
	local completePlayerList = {}
	local result = {}
	-- Example:
	-- completePlayerList = { {name="@DeadSoon", guilds={"BeamMeUp","BeamMeUp-Two"}, secsSinceLogoff=23485}, ... }
	for guildIndex=1, numGuilds do
		-- check each player
		local guildId = GetGuildId(guildIndex)
		if BMU.AdminIsBMUGuild(guildId) then
			local guildName = GetGuildName(guildId)
			local totalGuildMembers = GetNumGuildMembers(guildId)
			for playerIndex = 1, totalGuildMembers do
				local displayName, _, _, _, secsSinceLogoff = GetGuildMemberInfo(guildId, playerIndex)
				local index = BMU.sc_hasObjectName(completePlayerList, displayName)
				if index then
					-- entry exists already
					-- add only guild index
					table.insert(completePlayerList[index].guilds, guildName)
				else
					-- create new entry
					local entry = {
						name = displayName,
						guilds = {guildName},
						secsSinceLogoff=secsSinceLogoff
					}
					table.insert(completePlayerList, entry)
				end
			end
		end
	end
	-- now we have a complete list of all players
	-- add players who are in more than one guild to new list
	for index, object in pairs(completePlayerList) do
		if #object.guilds > 1 then
			-- copy to new result list
			table.insert(result, object)
		end
	end
	-- display result
	d("Number of matches: " .. #result)
	for index, object in pairs(result) do
		d(ZO_LinkHandler_CreateDisplayNameLink(object.name))
		d(object.guilds)
		d("-----------------------")
	end
end


function BMU.sc_hasObjectName(tab, key)
	if type(tab) == "table" then
		for index, object in pairs(tab) do
			if object.name == key then
				return index
			end
		end
		return false
	end
end


function BMU.sc_printNodesOfCurrentZone()
	for i = 1, GetNumFastTravelNodes() do
		local known, name, normalizedX, normalizedY, icon, glowIcon, poiType, isShownInCurrentMap, linkedCollectibleIsLocked = GetFastTravelNodeInfo(i)
		if isShownInCurrentMap then
			local type = "unknown"
			if poiType == POI_TYPE_GROUP_DUNGEON then
				type = "Group Dungeon"
			elseif poiType == POI_TYPE_PUBLIC_DUNGEON then
				type = "Public Dungeon"
			elseif poiType == POI_TYPE_WAYSHRINE then
				type = "Wayshrine"
			elseif poiType == POI_TYPE_OBJECTIVE then
				type = "Objective"
			elseif poiType == POI_TYPE_ACHIEVEMENT then
				type = "Achievement"
			elseif poiType == POI_TYPE_HOUSE then
				type = "House"
			end
			d("NodeIndex: " .. i .. "  |  " .. name .. " (" .. type .. ")")
		end
	end
end

function BMU.getHouseNameByHouseId(houseId)
	local collectibleId = GetCollectibleIdForHouse(houseId)
	if collectibleId and collectibleId > 0 then
		local houseName = GetCollectibleName(collectibleId)
		if houseName and houseName ~= "" then
			houseName = string.gsub(houseName, "[\n\r]", "")
			houseName = string.gsub(houseName, "%s+$", "")
			return houseName
		end
	end
	return "House ID: " .. tostring(houseId)
end

function BMU.sc_checkPartnerGuilds()
	d("----------")
	d("Waiting for guild data ...")
	-- request guild data loading
	BMU.requestGuildData()
	zo_callLater(function() BMU.sc_checkPartnerGuilds_2() end, 2000)
end


function BMU.sc_checkPartnerGuilds_2()
	local list_guildNames = {}
	local list_guildIds = {}
	local count = 0

	for _, guildId in pairs(BMU.var.partnerGuilds[GetWorldName()]) do
		local guildData = GUILD_BROWSER_MANAGER:GetGuildData(guildId)
		if not guildData then
			-- at least one guild is not loaded, wait and try again
			zo_callLater(function() BMU.sc_checkPartnerGuilds_2() end, 1000)
			return
		else
			table.insert(list_guildNames, guildData.guildName)
			table.insert(list_guildIds, guildId)
			count = count + 1
		end
	end

	-- all guild data loaded
	d("Guild Data (" .. count .. "):")
	for i=1, #list_guildNames do
		d(list_guildIds[i] .. " | " .. list_guildNames[i])
	end
	d("----------")
end



function BMU.sc_printPortCounterPerZone(option)
	for zoneId, num in pairs(BMU.savedVarsAcc.portCounterPerZone) do
		d(GetZoneNameById(zoneId) .. " - " .. zoneId .. ": " .. num)
	end
end


function BMU.sc_findQuestLocation(questIndex)
	local EmptyResult = ZO_WorldMap_ShowQuestOnMap(questIndex)
	local peter = GetZoneId(GetCurrentMapZoneIndex())
	local result = SetMapToPlayerLocation()
	if result ~= SET_MAP_RESULT_FAILED then
		CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
	end
	--SCENE_MANAGER:Hide("worldMap")
	return peter
	-- Achtung mit Timing, mglw. Delay einbauen für aufwendiges map wechseln
	-- Weitere Idee / Optimierung: Teil Code von der Funktion "ZO_WorldMap_ShowQuestOnMap(questIndex)" kopieren
	-- und nur SetMapTo Funktionen nutzen, die weder die Map öffnen und somit deutlich effizienter sind
end


function BMU.sc_printQuests(option)
	
	for i = 0, GetNumJournalQuests() do
		local zoneName, objectiveName, zoneIndex, poiIndex = GetJournalQuestLocationInfo(i)
		d("----------")
		d("Quest: " .. GetJournalQuestName(i))
		d("Eingang: " .. objectiveName)
		d("ZoneName/Index: " .. zoneName .. " - " .. zoneIndex)
		d("Starting ZoneIndex: " .. GetJournalQuestStartingZone(i))
		d("Steps: " .. GetJournalQuestNumSteps(i))
	end
end

-- Examples:
-- "/bmu/house/set/current_zone 12345"
function BMU.sc_setCurrentZoneHouse(option)
	local inputId = tonumber(option)
	if not inputId then
		BMU.printToChat("Usage: /bmu/house/set/current_zone <houseId|collectibleId>")
		BMU.printToChat("Sets preferred house for current zone")
		return
	end

	local houseId = BMU.resolveHouseId(inputId)
	if not houseId or houseId == 0 then
		BMU.printToChat("Invalid house ID: " .. tostring(inputId))
		return
	end

	local currentZoneId = GetCurrentMapZoneIndex()
	local parentZoneId = BMU.getParentZoneId(GetZoneId(currentZoneId))
	local zoneName = getZoneNameWithFallback(parentZoneId)
	local houseName = BMU.getHouseNameByHouseId(houseId)

	BMU.setZoneSpecificHouse(parentZoneId, houseId)
	BMU.printToChat("Zone-specific house set: " .. zoneName .. " (ID: " .. parentZoneId .. ") -> " .. houseName)
end

function BMU.sc_setCurrentHouse(option)
	local currentHouseId = GetCurrentZoneHouseId()
	if not currentHouseId or currentHouseId == 0 then
		BMU.printToChat("You are not currently in a house")
		return
	end

	local currentZoneId = GetCurrentMapZoneIndex()
	local parentZoneId = BMU.getParentZoneId(GetZoneId(currentZoneId))
	local zoneName = getZoneNameWithFallback(parentZoneId)
	local houseName = BMU.getHouseNameByHouseId(currentHouseId)

	BMU.setZoneSpecificHouse(parentZoneId, currentHouseId)
	BMU.printToChat("Current house set as preferred for " .. zoneName .. " (ID: " .. parentZoneId .. "): " .. houseName)
end

-- Helpers to resolve house IDs and names
function BMU.resolveHouseId(idOrCollectible)
	local id = tonumber(idOrCollectible)
	if not id then return nil end
	-- If the value looks like a collectible, try to map it to a houseId (if API is available)
	if GetHouseIdFromCollectibleId and (IsCollectibleUnlocked(id) or (GetCollectibleCategoryType and GetCollectibleCategoryType(id) == COLLECTIBLE_CATEGORY_TYPE_HOUSE)) then
		local hId = GetHouseIdFromCollectibleId(id)
		if hId and hId > 0 then return hId end
	end
	return id
end

function BMU.sc_setZoneHouse(option)
	local parts = {}
	for part in string.gmatch(option, "%S+") do table.insert(parts, part) end
	if #parts < 2 then
		BMU.printToChat("Usage: /bmu/house/set/zone <zone> <houseId|collectibleId>")
		BMU.printToChat("<zone> can be zone ID or zone name")
		return
	end

	-- Last parameter is house id or collectible id
	local inputId = tonumber(parts[#parts])
	if not inputId then
		BMU.printToChat("Invalid house ID: " .. (parts[#parts] or "nil"))
		return
	end
	local houseId = BMU.resolveHouseId(inputId)
	if not houseId or houseId == 0 then
		BMU.printToChat("Invalid house ID: " .. tostring(inputId))
		return
	end

	-- Zone can be multi-word
	local zoneStr = table.concat(parts, " ", 1, #parts - 1)
	local zoneId = tonumber(zoneStr) or BMU.getZoneIdFromZoneName(zoneStr)
	local zoneName = GetZoneNameById(zoneId)
	if not zoneId or not zoneName or zoneName == "" then
		BMU.printToChat("Invalid zone: " .. zoneStr)
		return
	end

	local houseName = BMU.getHouseNameByHouseId(houseId)
	BMU.setZoneSpecificHouse(zoneId, houseId)
	BMU.printToChat("Zone-specific house set: " .. zoneName .. " -> " .. houseName)
end

function BMU.sc_clearCurrentZoneHouse(option)
	local currentZoneId = GetCurrentMapZoneIndex()
	local parentZoneId = BMU.getParentZoneId(GetZoneId(currentZoneId))
	local zoneName = getZoneNameWithFallback(parentZoneId)
	local currentHouseId = BMU.getZoneSpecificHouse(parentZoneId)

	if not currentHouseId then
		BMU.printToChat("No zone-specific house set for " .. zoneName)
		return
	end

	local houseName = BMU.getHouseNameByHouseId(currentHouseId)
	BMU.clearZoneSpecificHouse(parentZoneId)
	BMU.printToChat("Zone-specific house cleared: " .. zoneName .. " (ID: " .. parentZoneId .. ") (was " .. houseName .. ")")
end

function BMU.sc_listZoneHouses()
	if not BMU.savedVarsServ.zoneSpecificHouses or next(BMU.savedVarsServ.zoneSpecificHouses) == nil then
		BMU.printToChat("No zone-specific houses configured")
		return
	end

	BMU.printToChat("Zone-specific house mappings:")
	for zoneId, houseId in pairs(BMU.savedVarsServ.zoneSpecificHouses) do
		local zoneName = BMU.formatName(getZoneNameWithFallback(zoneId), false)
		local houseName = BMU.formatName(BMU.getHouseNameByHouseId(houseId), false)
		BMU.printToChat("  " .. zoneName .. " (ID: " .. tostring(zoneId) .. ") -> " .. houseName .. " (House ID: " .. tostring(houseId) .. ")")
	end
end

function BMU.sc_clearZoneHouse(option)
	if not option or option == "" then
		BMU.printToChat("Usage: /bmu/house/clear/zone <zone>")
		BMU.printToChat("<zone> can be zone ID or zone name")
		return
	end

	local zoneId = tonumber(option) or BMU.getZoneIdFromZoneName(option)
	local zoneName = GetZoneNameById(zoneId)
	if not zoneId or not zoneName or zoneName == "" then
		BMU.printToChat("Invalid zone: " .. option)
		return
	end

	local currentHouseId = BMU.getZoneSpecificHouse(zoneId)
	if not currentHouseId then
		BMU.printToChat("No zone-specific house set for " .. zoneName)
		return
	end

	local houseName = BMU.getHouseNameByHouseId(currentHouseId)
	BMU.clearZoneSpecificHouse(zoneId)
	BMU.printToChat("Zone-specific house cleared: " .. zoneName .. " (was " .. houseName .. ")")
end
