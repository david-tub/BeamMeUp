local BMU = BMU --INS251229 Baertram Performancee gain, not searching _G for BMU each time again!

-- all functions which are reachable via slash commands
local SI = BMU.SI

-- -v- INS251229 Baertram BEGIN 0
--Performance reference
----variables (defined now, as they were loaded before this file -> see manifest .txt)
--ZOs variables
local ton = tonumber
local tos = tostring
local string = string
local string_lower = string.lower
local string_match = string.match
local string_sub = string.sub
local string_gsub = string.gsub
local string_gmatch = string.gmatch
local table = table
local table_insert = table.insert
local table_concat = table.concat
local unpack = unpack

--Other addon variables
local BMU_LSC = BMU.LSC
--BMU variables
local teleporterVars = BMU.var --INS251229 Baertram
local appName = teleporterVars.appName

local searchPatternSC = "^(%S*)%s*(.-)$"
local fallbackLang = teleporterVars.fallbackLang
local clientLanguage = string_lower(GetCVar("language.2") or fallbackLang)
local BMU_LibZoneGivenZoneData
----functions
--ZOs functions
local GetZoneNameById = GetZoneNameById
local GetZoneId = GetZoneId
local GetUnitZoneIndex = GetUnitZoneIndex
local GetCurrentMapZoneIndex = GetCurrentMapZoneIndex
local GetFastTravelNodeInfo = GetFastTravelNodeInfo
local BeginGroupElection = BeginGroupElection
local GetCurrentZoneHouseId = GetCurrentZoneHouseId
local GetHouseIdFromCollectibleId = GetHouseIdFromCollectibleId --Where does that API function come from, any customa ddon? Does not exist afaik  --INS251229 Baertram
--BMU functions
local BMU_SI_get = SI.get
local BMU_printToChat = BMU.printToChat
local allowedLanguages = teleporterVars.allowedLanguages
local BMU_addFavoriteZone = BMU.addFavoriteZone
local BMU_getZoneIdFromZoneName  = BMU.getZoneIdFromZoneName
local BMU_formatName = BMU.formatName
local BMU_addFavoritePlayer = BMU.addFavoritePlayer
local BMU_portToParentZone = BMU.portToParentZone
local BMU_portToCurrentZone = BMU.portToCurrentZone
local BMU_portToOwnHouse = BMU.portToOwnHouse
local BMU_portToGroupLeader = BMU.portToGroupLeader
local BMU_portToTrackedQuestZone = BMU.portToTrackedQuestZone
local BMU_getParentZoneId = BMU.getParentZoneId
local BMU_PortalToZone = BMU.PortalToZone
local BMU_PortalToPlayer = BMU.PortalToPlayer


----variables (defined inline in code below, upon first usage, as they are still nil at this line)
local BMU_LibZone, BMU_LibZone_GetZoneGeographicalParentZoneId, BMU_setZoneSpecificHouse, BMU_getZoneSpecificHouse, BMU_clearZoneSpecificHouse,
	  BMU_sc_checkPartnerGuilds_2, BMU_createTable

--BMU functions
----functions (defined inline in code below, upon first usage, as they are still nil at this line)

-- -^- INS251229 Baertram END 0


-- Helper function to get zone name with fallback
local function getZoneNameWithFallback(zoneId)
	local zoneName = GetZoneNameById(zoneId)
	if zoneName and zoneName ~= "" then
		return zoneName
	end
	
	-- Try to get parent zone name if available
	BMU_LibZone = BMU_LibZone or BMU.LibZone
	BMU_LibZone_GetZoneGeographicalParentZoneId = BMU_LibZone_GetZoneGeographicalParentZoneId or BMU_LibZone.GetZoneGeographicalParentZoneId
	BMU_LibZoneGivenZoneData = BMU_LibZoneGivenZoneData or BMU.LibZoneGivenZoneData

	local parentZoneId = BMU_LibZone_GetZoneGeographicalParentZoneId(zoneId)
	if parentZoneId and parentZoneId ~= zoneId then
		local parentZoneName = GetZoneNameById(parentZoneId)
		if parentZoneName and parentZoneName ~= "" then
			return parentZoneName .. " (Sub-zone ID: " .. tos(zoneId) .. ")"
		end
	end

	-- Try to get from LibZone data as fallback
	if BMU_LibZoneGivenZoneData then
		local langData = BMU_LibZoneGivenZoneData[clientLanguage] or (clientLanguage ~= fallbackLang and BMU_LibZoneGivenZoneData[fallbackLang]) or nil
		if langData and langData[zoneId] then
			return langData[zoneId]
		end
		
		-- Also try parent zone from LibZone data
		parentZoneId = BMU_LibZone_GetZoneGeographicalParentZoneId(zoneId)
		if parentZoneId and parentZoneId ~= zoneId and langData[parentZoneId] then
			return langData[parentZoneId] .. " (Sub-zone ID: " .. tos(zoneId) .. ")"
		end
	end
	
	return "Unknown Zone ID: " .. tos(zoneId)
end



--Slash Command functions
local function BMU_sc_parseOptions(option)
	local options = {}
    local searchResult = { string_match(option,searchPatternSC) }
    for i,v in pairs(searchResult) do
        if (v ~= nil and v ~= "") then
            options[i] = v
        end
    end
	return options
end

-- register chat command either with LibSlashCommander or traditional
local function BMU_registerChatCommand(command, callback, description)
	if BMU_LSC then
		BMU_LSC:Register(command, function(option) callback(option) end, description)
	else
		SLASH_COMMANDS[command] = function(option) callback(option) end
	end
end


local function BMU_sc_toggleDebugMode()
	if BMU.debugMode then
		BMU.debugMode = false
		BMU_printToChat("Debug mode disabled")
	else
		BMU.debugMode = true
		BMU_printToChat("Debug mode enabled")
	end
end


local function BMU_sc_switchLanguage(option)
	if allowedLanguages[option] then
		SetCVar("language.2",option)
	else
		BMU_printToChat("invalid language code: " ..tos(option))
		local allowedLanguagesStr = ""
		for langStr, _ in pairs(allowedLanguages) do
			allowedLanguagesStr = (allowedLanguagesStr ~= "" and (allowedLanguagesStr .. ", " .. langStr)) or langStr
		end
		BMU_printToChat("only " .. allowedLanguagesStr .. " allowed")
	end
end


-- Examples:
-- "/bmu/favorites/add/player 1 @Gamer1968PAN"
local function BMU_sc_addFavoritePlayer(option)
	local options = BMU_sc_parseOptions(option)
	local position = ton(options[1])
	local displayName = options[2]
	
	if displayName ~= nil and string_sub(displayName, 1, 1) == "@" and position ~= nil and position >= 1 and position <= teleporterVars.numFavoritePlayers then
		BMU_addFavoritePlayer(position, displayName)
	else
		BMU_printToChat("invalid input")
		BMU_printToChat("<favorite slot (1-5)>  <player name (@...)>")
	end
end


-- Examples:
-- "/bmu/favorites/add/zone 1 57"
-- "/bmu/favorites/add/zone 1 Deshaan"
local function BMU_sc_addFavoriteZone(option)
	local options = BMU_sc_parseOptions(option)
	local position = ton(options[1])
	-- second parameter is number -> zoneId
	-- or concat the params to one zone name (e.g. "High Isle" is incoming as 2 params)
	local zoneNameOrId = ton(options[2]) or table_concat({unpack(options, 2)}, " ")

	local zoneId = ton(zoneNameOrId) or BMU_getZoneIdFromZoneName(zoneNameOrId)
	local zoneName = BMU_formatName(GetZoneNameById(zoneId), BMU.savedVarsAcc.formatZoneName)
	
	if zoneName ~= nil and zoneName ~= "" and position ~= nil and position >= 1 and position <= teleporterVars.numFavoriteZones then
		BMU_addFavoriteZone(position, zoneId, zoneName)
	else
		BMU_printToChat("invalid input")
		BMU_printToChat("<favorite slot (1-10)>  <zone (zoneId or zone name)>")
	end
end


-- Examples:
-- "/bmu/favorites/add/wayshrine 1"
local function BMU_sc_addFavoriteWayshrine(option)
	local function updateWayshrineInteraction(eventCode, nodeIndex)
		--End the interactione vent here so we cannot repeat the same twice!
		EVENT_MANAGER:UnregisterForEvent(appName, EVENT_START_FAST_TRAVEL_INTERACTION)   			--INS251229 Baertram

		local currentFavWayshrinePos = BMU.favWayshrineCurrentPosition
		BMU.savedVarsServ.favoriteListWayshrines[currentFavWayshrinePos] = nodeIndex
		local _, name, _, _, _, _, _, _, _ = GetFastTravelNodeInfo(nodeIndex)
		BMU_printToChat(BMU_SI_get(SI.TELE_KEYBINDING_WAYSHRINE_FAVORITE) .. " " .. currentFavWayshrinePos .. ": " .. BMU_formatName(name), BMU.MSG_AD)
	end

	-- extract position (slot) number from input options
	local options = BMU_sc_parseOptions(option)
	local position = ton(options[1])
	if position == nil or position < 1 or position > teleporterVars.numFavoriteWayshrines then
		BMU_printToChat("invalid input")
		BMU_printToChat("<favorite slot (1-3)>")
		return
	end
	-- remember requested fav position/slot
	BMU.favWayshrineCurrentPosition = position

	-- start interaction countdown - player has to interact with a wayshrine within the countdown
	local countDownSec = 10
	EVENT_MANAGER:RegisterForEvent(appName,  EVENT_START_FAST_TRAVEL_INTERACTION, updateWayshrineInteraction)
	zo_callLater(function() EVENT_MANAGER:UnregisterForEvent(appName, EVENT_START_FAST_TRAVEL_INTERACTION) end, countDownSec*1000)
	BMU_printToChat("Interact with your favorite wayshrine in the next 10 seconds!", BMU.MSG_AD)
end


local function BMU_sc_getCurrentZoneId()
	local playersZoneIndex = GetUnitZoneIndex("player")
	local playersZoneId = GetZoneId(playersZoneIndex)
	BMU_printToChat("Current zone id: " .. playersZoneId)
end


local function BMU_sc_customVoteUnanimous(option)
	if option ~= nil and option ~= "" then
		BeginGroupElection(GROUP_ELECTION_TYPE_GENERIC_UNANIMOUS, option)
	else
		BMU_printToChat("invalid custom text")
	end
end


local function BMU_sc_customVoteSupermajority(option)
	if option ~= nil and option ~= "" then
		BeginGroupElection(GROUP_ELECTION_TYPE_GENERIC_SUPERMAJORITY, option)
	else
		BMU_printToChat("invalid custom text")
	end
end


local function BMU_sc_customVoteSimplemajority(option)
	if option ~= nil and option ~= "" then
		BeginGroupElection(GROUP_ELECTION_TYPE_GENERIC_SIMPLEMAJORITY, option)
	else
		BMU_printToChat("invalid custom text")
	end
end

----- SET PREFERRED HOUSES -----

-- Helpers to resolve house IDs and names
local function BMU_resolveHouseId(idOrCollectible)
	local id = ton(idOrCollectible)
	if not id then return end
	-- If the value looks like a collectible, try to map it to a houseId (if API is available)
	if GetHouseIdFromCollectibleId and (IsCollectibleUnlocked(id) or (GetCollectibleCategoryType and GetCollectibleCategoryType(id) == COLLECTIBLE_CATEGORY_TYPE_HOUSE)) then
		local hId = GetHouseIdFromCollectibleId(id)
		if hId and hId > 0 then return hId end
	end
	return id
end

function BMU.getHouseNameByHouseId(houseId)
	local collectibleId = GetCollectibleIdForHouse(houseId)
	if collectibleId and collectibleId > 0 then
		local houseName = GetCollectibleName(collectibleId)
		if houseName and houseName ~= "" then
			houseName = string_gsub(houseName, "[\n\r]", "")
			houseName = string_gsub(houseName, "%s+$", "")
			return houseName
		end
	end
	return "House ID: " .. tos(houseId)
end
local BMU_getHouseNameByHouseId = BMU.getHouseNameByHouseId

-- Examples:
-- "/bmu/house/set/current_zone 12345"
local function BMU_sc_setCurrentZoneHouse(option)
	BMU_setZoneSpecificHouse = BMU_setZoneSpecificHouse or BMU.setZoneSpecificHouse					--INS251229 Baertram
	local inputId = ton(option)
	if not inputId then
		BMU_printToChat("Usage: /bmu/house/set/current_zone <houseId|collectibleId>")
		BMU_printToChat("Sets preferred house for current zone")
		return
	end

	local houseId = BMU_resolveHouseId(inputId)
	if not houseId or houseId == 0 then
		BMU_printToChat("Invalid house ID: " .. tos(inputId))
		return
	end

	local currentZoneId = GetCurrentMapZoneIndex()
	local parentZoneId = BMU_getParentZoneId(GetZoneId(currentZoneId))
	local zoneName = BMU_formatName(getZoneNameWithFallback(parentZoneId), false)
	local houseName = BMU_formatName(BMU_getHouseNameByHouseId(houseId), false)

	BMU_setZoneSpecificHouse(parentZoneId, houseId)
	BMU_printToChat("Zone-specific house set: " .. zoneName .. " (ID: " .. parentZoneId .. ") -> " .. houseName)
end

local function BMU_sc_setCurrentHouse(option)
	BMU_setZoneSpecificHouse = BMU_setZoneSpecificHouse or BMU.setZoneSpecificHouse					--INS251229 Baertram
	local currentHouseId = GetCurrentZoneHouseId()
	if not currentHouseId or currentHouseId == 0 then
		BMU_printToChat("You are not currently in a house")
		return
	end

	local currentZoneId = GetCurrentMapZoneIndex()
	local parentZoneId = BMU_getParentZoneId(GetZoneId(currentZoneId))
	local zoneName = BMU_formatName(getZoneNameWithFallback(parentZoneId), false)
	local houseName = BMU_formatName(BMU_getHouseNameByHouseId(currentHouseId), false)

	BMU_setZoneSpecificHouse(parentZoneId, currentHouseId)
	BMU_printToChat("Current house set as preferred for " .. zoneName .. " (ID: " .. parentZoneId .. "): " .. houseName)
end

local function BMU_sc_setZoneHouse(option)
	BMU_setZoneSpecificHouse = BMU_setZoneSpecificHouse or BMU.setZoneSpecificHouse					--INS251229 Baertram
	local parts = {}
	for part in string_gmatch(option, "%S+") do table_insert(parts, part) end
	if #parts < 2 then
		BMU_printToChat("Usage: /bmu/house/set/zone <zone> <houseId|collectibleId>")
		BMU_printToChat("<zone> can be zone ID or zone name")
		return
	end

	-- Last parameter is house id or collectible id
	local inputId = ton(parts[#parts])
	if not inputId then
		BMU_printToChat("Invalid house ID: " .. (parts[#parts] or "nil"))
		return
	end
	local houseId = BMU_resolveHouseId(inputId)
	if not houseId or houseId == 0 then
		BMU_printToChat("Invalid house ID: " .. tos(inputId))
		return
	end

	-- Zone can be multi-word
	local zoneStr = table_concat(parts, " ", 1, #parts - 1)
	local zoneId = ton(zoneStr) or BMU_getZoneIdFromZoneName(zoneStr)
	local zoneName = BMU_formatName(GetZoneNameById(zoneId), false)
	if not zoneId or not zoneName or zoneName == "" then
		BMU_printToChat("Invalid zone: " .. zoneStr)
		return
	end

	local houseName = BMU_formatName(BMU_getHouseNameByHouseId(houseId), false)
	BMU_setZoneSpecificHouse(zoneId, houseId)
	BMU_printToChat("Zone-specific house set: " .. zoneName .. " -> " .. houseName)
end

local function BMU_sc_clearCurrentZoneHouse(option)
	BMU_getZoneSpecificHouse = BMU_getZoneSpecificHouse or BMU.getZoneSpecificHouse					--INS251229 Baertram
	BMU_clearZoneSpecificHouse = BMU_clearZoneSpecificHouse or BMU.clearZoneSpecificHouse		 	--INS251229 Baertram

	local currentZoneId = GetCurrentMapZoneIndex()
	local parentZoneId = BMU_getParentZoneId(GetZoneId(currentZoneId))
	local zoneName = BMU_formatName(getZoneNameWithFallback(parentZoneId), false)
	local currentHouseId = BMU_getZoneSpecificHouse(parentZoneId)

	if not currentHouseId then
		BMU_printToChat("No zone-specific house set for " .. zoneName)
		return
	end

	local houseName = BMU_formatName(BMU_getHouseNameByHouseId(currentHouseId), false)
	BMU_clearZoneSpecificHouse(parentZoneId)
	BMU_printToChat("Zone-specific house cleared: " .. zoneName .. " (ID: " .. parentZoneId .. ") (was '" .. houseName .. "')")
end

local function BMU_sc_listZoneHouses()
	if not BMU.savedVarsServ.zoneSpecificHouses or next(BMU.savedVarsServ.zoneSpecificHouses) == nil then
		BMU_printToChat("No zone-specific houses configured")
		return
	end

	BMU_printToChat("Zone-specific house mappings:")
	for zoneId, houseId in pairs(BMU.savedVarsServ.zoneSpecificHouses) do
		local zoneName = BMU_formatName(getZoneNameWithFallback(zoneId), false)
		local houseName = BMU_formatName(BMU_getHouseNameByHouseId(houseId), false)
		BMU_printToChat("  " .. zoneName .. " (ID: " .. tos(zoneId) .. ") -> " .. houseName .. " (House ID: " .. tos(houseId) .. ")")
	end
end

local function BMU_sc_clearZoneHouse(option)
	BMU_clearZoneSpecificHouse = BMU_clearZoneSpecificHouse or BMU.clearZoneSpecificHouse		 	--INS251229 Baertram
	if not option or option == "" then
		BMU_printToChat("Usage: /bmu/house/clear/zone <zone>")
		BMU_printToChat("<zone> can be zone ID or zone name")
		return
	end

	local zoneId = ton(option) or BMU_getZoneIdFromZoneName(option)
	local zoneName = BMU_formatName(GetZoneNameById(zoneId))
	if not zoneId or not zoneName or zoneName == "" then
		BMU_printToChat("Invalid zone: " .. option)
		return
	end

	local currentHouseId = BMU.getZoneSpecificHouse(zoneId)
	if not currentHouseId then
		BMU_printToChat("No zone-specific house set for " .. zoneName)
		return
	end

	local houseName = BMU_formatName(BMU_getHouseNameByHouseId(currentHouseId))
	BMU_clearZoneSpecificHouse(zoneId)
	BMU_printToChat("Zone-specific house cleared: " .. zoneName .. " (was " .. houseName .. ")")
end

-----


local function BMU_sc_joinBlacklistForSlashPorting(list)
	-- join the lists to global blacklist (merge to HashMap instead to a list)
	local blacklistForSlashPorting = BMU.blacklistForSlashPorting
	for index, value in ipairs(list) do
		blacklistForSlashPorting[value] = true
	end
end

function BMU.sc_porting(zoneId)
	BMU_createTable = BMU_createTable or BMU.createTable   											--INS251229 Baertram
	local resultTable = BMU_createTable({index=BMU.indexListZoneHidden, fZoneId=zoneId, dontDisplay=true})
	local entry = resultTable[1]

	if entry.displayName ~= nil and entry.displayName ~= "" then
		-- usual entry with player or house
		BMU_PortalToPlayer(entry.displayName, entry.sourceIndexLeading, entry.zoneName, entry.zoneId, entry.category, true, true, true)
	elseif BMU.savedVarsAcc.showZonesWithoutPlayers2 and BMU.isZoneOverlandZone(zoneId) then
		-- travel for gold only possible for overland zones
		BMU_PortalToZone(zoneId)
	else
		-- no travel option
		BMU_printToChat(BMU_SI_get(SI.TELE_CHAT_NO_FAST_TRAVEL))
	end
end
local BMU_sc_porting = BMU.sc_porting

local function BMU_sc_initializeSlashPorting()

	-- create static blacklist (add everything where the player can not port to)
	BMU.blacklistForSlashPorting = {}
	BMU_sc_joinBlacklistForSlashPorting(BMU.blacklistOthers)
	BMU_sc_joinBlacklistForSlashPorting(BMU.blacklistSoloArenas)
	BMU_sc_joinBlacklistForSlashPorting(BMU.blacklistRefuges)
	BMU_sc_joinBlacklistForSlashPorting(BMU.blacklistCyro)
	BMU_sc_joinBlacklistForSlashPorting(BMU.blacklistImpCity)
	BMU_sc_joinBlacklistForSlashPorting(BMU.blacklistBattlegrounds)
	BMU_sc_joinBlacklistForSlashPorting(BMU.blacklistGroupDungeons)
	BMU_sc_joinBlacklistForSlashPorting(BMU.blacklistRaids)
	BMU_sc_joinBlacklistForSlashPorting(BMU.blacklistGroupZones)
	BMU_sc_joinBlacklistForSlashPorting(BMU.blacklistGroupArenas)
	BMU_sc_joinBlacklistForSlashPorting(BMU.blacklistEndlessDungeons)

	-- initialize chat commands
	-- check if zone name data is available in client language
	-- use English zoneData if zoneData in client language is not available
	local libZoneData = BMU.LibZoneGivenZoneData
	local zoneData = libZoneData[string_lower(BMU.lang)] or (BMU.lang ~= fallbackLang and libZoneData[fallbackLang]) or nil
	if zoneData ~= nil then
		local blacklistForSlashPorting = BMU.blacklistForSlashPorting
		
		for zoneId, zoneName in pairs(zoneData) do
			if type(zoneId) == "number" and type(zoneName) == "string" then
				local zoneNameFormatted = BMU_formatName(zoneName, BMU.savedVarsAcc.formatZoneName)
				local comName = "/bmutp/" .. string_gsub(string_lower(zoneNameFormatted), " ", "_")
				if SLASH_COMMANDS[comName] == nil and CanJumpToPlayerInZone(zoneId) and not blacklistForSlashPorting[zoneId] then -- dont overwrite existing command, check for solo zones by game, check for blacklisting
					BMU_registerChatCommand(comName, function(option) BMU_sc_porting(zoneId) end, zoneNameFormatted)
				end
			end
		end
	end
end

--------------------------------------------------
-- STUFF / UTILITIES / DEVELOP
--------------------------------------------------
local function BMU_sc_hasObjectName(tab, key)
	if type(tab) == "table" then
		for index, object in pairs(tab) do
			if object.name == key then
				return index
			end
		end
		return false
	end
end

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
				local index = BMU_sc_hasObjectName(completePlayerList, displayName)
				if index then
					-- entry exists already
					-- add only guild index
					table_insert(completePlayerList[index].guilds, guildName)
				else
					-- create new entry
					local entry = {
						name = displayName,
						guilds = {guildName},
						secsSinceLogoff=secsSinceLogoff
					}
					table_insert(completePlayerList, entry)
				end
			end
		end
	end
	-- now we have a complete list of all players
	-- add players who are in more than one guild to new list
	for index, object in pairs(completePlayerList) do
		if #object.guilds > 1 then
			-- copy to new result list
			table_insert(result, object)
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

function BMU.sc_checkPartnerGuilds()
	d("----------")
	d("Waiting for guild data ...")
	-- request guild data loading
	BMU.requestGuildData()
	BMU_sc_checkPartnerGuilds_2 = BMU_sc_checkPartnerGuilds_2 or BMU.sc_checkPartnerGuilds_2
	zo_callLater(function() BMU.sc_checkPartnerGuilds_2() end, 2000)
end

function BMU.sc_checkPartnerGuilds_2()
	BMU_sc_checkPartnerGuilds_2 = BMU_sc_checkPartnerGuilds_2 or BMU.sc_checkPartnerGuilds_2
	local list_guildNames = {}
	local list_guildIds = {}
	local count = 0

	for _, guildId in pairs(teleporterVars.partnerGuilds[GetWorldName()]) do
		local guildData = GUILD_BROWSER_MANAGER:GetGuildData(guildId)
		if not guildData then
			-- at least one guild is not loaded, wait and try again
			zo_callLater(function() BMU_sc_checkPartnerGuilds_2() end, 1000)
			return
		else
			table_insert(list_guildNames, guildData.guildName)
			table_insert(list_guildIds, guildId)
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
BMU_sc_checkPartnerGuilds_2 = BMU.sc_checkPartnerGuilds_2


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



--------------------------------------------------------------------------------------------------------------------
-- register/activate all chat commands
--------------------------------------------------------------------------------------------------------------------
function BMU.activateSlashCommands()

	-- Debug Mode (new slash commands will be activated)
	BMU_registerChatCommand("/bmu/misc/debug", function(option) BMU_sc_toggleDebugMode() end, "Enable debug mode")
	-- Switch language
	BMU_registerChatCommand("/bmu/misc/lang", function(option) BMU_sc_switchLanguage(option) end, "Switch client language")
	-- Getting current zone id
	BMU_registerChatCommand("/bmu/misc/current_zone_id", function(option) BMU_sc_getCurrentZoneId() end, "Print current zone id")
	-- Advertise addon
	BMU_registerChatCommand("/bmu/misc/advertise", function(option) StartChatInput("Fast Travel addon BeamMeUp. Check it out: http://bit.ly/bmu4eso") end, "Advertise BeamMeUp")

	-- Adding new player favorite
	BMU_registerChatCommand("/bmu/favorites/add/player", function(option) BMU_sc_addFavoritePlayer(option) end, "Add player favorite")
	-- Adding new zone favorite
	BMU_registerChatCommand("/bmu/favorites/add/zone", function(option) BMU_sc_addFavoriteZone(option) end, "Add zone favorite")
	-- Adding new wayshrine favorite
	BMU_registerChatCommand("/bmu/favorites/add/wayshrine", function(option) BMU_sc_addFavoriteWayshrine(option) end, "Add wayshrine favorite")

	-- Zone-specific house commands
	BMU_registerChatCommand("/bmu/house/set/current_zone", function(option) BMU_sc_setCurrentZoneHouse(option) end, "Set preferred house for current zone")
	BMU_registerChatCommand("/bmu/house/set/current_house", function(option) BMU_sc_setCurrentHouse(option) end, "Set current house as preferred for current zone")
	BMU_registerChatCommand("/bmu/house/set/zone", function(option) BMU_sc_setZoneHouse(option) end, "Set preferred house for specific zone")
	BMU_registerChatCommand("/bmu/house/clear/current_zone", function(option) BMU_sc_clearCurrentZoneHouse(option) end, "Clear zone-specific house preference for current zone")
	BMU_registerChatCommand("/bmu/house/clear/zone", function(option) BMU_sc_clearZoneHouse(option) end, "Clear zone-specific house preference for specific zone")
	BMU_registerChatCommand("/bmu/house/list", function() BMU_sc_listZoneHouses() end, "List all zone-specific house mappings")

	-- Port to goup leader
	BMU_registerChatCommand("/bmutp/leader", function(option) BMU_portToGroupLeader() end, "Port to group leader")
	-- Port to currently tracked/focused quest
	BMU_registerChatCommand("/bmutp/quest", function(option) BMU_portToTrackedQuestZone() end, "Port to focused quest")
	-- Port into own primary residence
	BMU_registerChatCommand("/bmutp/house", function(option) BMU_portToOwnHouse(true, nil, false, nil) end, "Port into primary residence")
	-- Port outside own primary residence
	BMU_registerChatCommand("/bmutp/house_out", function(option) BMU_portToOwnHouse(true, nil, true, nil) end, "Port outside primary residence")
	-- Port to current zone
	BMU_registerChatCommand("/bmutp/current_zone", function(option) BMU_portToCurrentZone() end, "Port to current zone")
	-- Port to parent zone
	BMU_registerChatCommand("/bmutp/parent_zone", function(option) BMU_portToParentZone() end, "Port to parent zone")

	-- switch player status
	BMU_registerChatCommand("/bmu/misc/on", function(option) SelectPlayerStatus(PLAYER_STATUS_ONLINE) end, "Status: online")
	BMU_registerChatCommand("/bmu/misc/off", function(option) SelectPlayerStatus(PLAYER_STATUS_OFFLINE) end, "Status: offline")
	BMU_registerChatCommand("/bmu/misc/afk", function(option) SelectPlayerStatus(PLAYER_STATUS_AWAY) end, "Status: away")
	BMU_registerChatCommand("/bmu/misc/dnd", function(option) SelectPlayerStatus(PLAYER_STATUS_DO_NOT_DISTURB) end, "Status: dont disturb")

	-- Starting custom group vote
	BMU_registerChatCommand("/bmu/vote/custom_vote_unanimous", function(option) BMU_sc_customVoteUnanimous(option) end, "Custom vote (100%)")
	BMU_registerChatCommand("/bmu/vote/custom_vote_simplemajority", function(option) BMU_sc_customVoteSimplemajority(option) end, "Custom vote (>=50%)")

	-- Initialize chat commands for porting (/bmutp...)
	BMU_sc_initializeSlashPorting()

	-- refresh chat commands cache (for auto completing)
	--SLASH_COMMAND_AUTO_COMPLETE:InvalidateSlashCommandCache()
end
