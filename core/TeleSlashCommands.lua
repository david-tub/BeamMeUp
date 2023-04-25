-- all functions which are reachable via slash commands
local SI = BMU.SI
local LSC = BMU.LSC

function BMU.activateSlashCommands()
	-- Debug Mode (new slash commands will be activated)
	LSC:Register("/bmu/debug", function(option) BMU.sc_toggleDebugMode() end, "Enable debug mode")
	-- Switch language
	LSC:Register("/bmu/lang", function(option) BMU.sc_switchLanguage(option) end, "Switch client language")
	-- Adding new player favorite
	LSC:Register("/bmu/favorites/add/player", function(option) BMU.sc_addFavoritePlayer(option) end, "Add player favorite")
	-- Adding new zone favorite
	LSC:Register("/bmu/favorites/add/zone", function(option) BMU.sc_addFavoriteZone(option) end, "Add zone favorite")
	-- Getting current zone id
	LSC:Register("/bmu/misc/current_zone_id", function(option) BMU.sc_getCurrentZoneId() end, "Print current zone id")
	-- Port to goup leader
	LSC:Register("/bmutp/leader", function(option) BMU.portToGroupLeader() end, "Port to group leader")
	-- Port to currently tracked/focused quest
	LSC:Register("/bmutp/quest", function(option) BMU.portToTrackedQuestZone() end, "Port to focused quest")
	-- Port into own primary residence
	LSC:Register("/bmutp/house", function(option) BMU.portToOwnHouse(true, nil, false, nil) end, "Port into primary residence")
	-- Port outside own primary residence
	LSC:Register("/bmutp/house_out", function(option) BMU.portToOwnHouse(true, nil, true, nil) end, "Port outside primary residence")
	-- Advertise addon
	LSC:Register("/bmu/advertise", function(option) StartChatInput("Fast Travel addon BeamMeUp. Check it out: http://bit.ly/bmu4eso") end, "Advertise BeamMeUp")
	
	
	-- Starting custom group vote
	LSC:Register("/bmu/vote/custom_vote_unanimous", function(option) BMU.sc_customVoteUnanimous(option) end, "Custom vote (100%)")
	LSC:Register("/bmu/vote/custom_vote_supermajority", function(option) BMU.sc_customVoteSupermajority(option) end, "Custom vote (>=60%)")
	LSC:Register("/bmu/vote/custom_vote_simplemajority", function(option) BMU.sc_customVoteSimplemajority(option) end, "Custom vote (>=50%)")
	
	
	-- Initialize chat commands for porting (/bmutp...)
	BMU.sc_initializeSlashPorting()
	
	-- add chat command for porting to current zone seperately
	LSC:Register("/bmutp/current_zone", function(option) BMU.portToCurrentZone() end, "Port to current zone")
end


function BMU.sc_toggleDebugMode()
	if BMU.debugMode == 1 then
		BMU.debugMode = 0
		BMU.printToChat("Debug mode disabled")
	else
		BMU.debugMode = 1
		BMU.printToChat("Debug mode enabled")
		--[[
		d("New slash commands available:")
	
		d("Printing of complete inventory (1): /bmu/debug/inv1")
		SLASH_COMMANDS["/bmu/debug/inv1"] = BMU.sc_inv1
	
		d("Printing of complete inventory (2): /bmu/debug/inv2")
		SLASH_COMMANDS["/bmu/debug/inv2"] = BMU.sc_inv2
	
		d("Printing of all POI in current zone: /bmu/debug/poi")
		SLASH_COMMANDS["/bmu/debug/poi"] = BMU.sc_poi
		
		d("Testing library LibZone: /bmu/debug/libzone <zoneId>")
		SLASH_COMMANDS["/bmu/debug/libzone"] = BMU.sc_testLibZone
		
		d("Initialization of Slash-Command-Porting: /bmu/debug/slashporting")
		SLASH_COMMANDS["/bmu/debug/slashporting"] = BMU.sc_initializeSlashPorting
		
		d("Printing of all Quests and their location: /bmu/debug/quests")
		SLASH_COMMANDS["/bmu/debug/quests"] = BMU.sc_printQuests
		
		-- refresh slash commands cache (for auto completing)
		SLASH_COMMAND_AUTO_COMPLETE:InvalidateSlashCommandCache()
		--]]
	end
end


function BMU.sc_switchLanguage(option)
	if option == "de" or option == "en" or option == "fr" or option == "ru" or option == "es" or option == "pl" or option == "it" or option == "jp" or option == "br" or option == "kr" or option == "zh" then
		SetCVar("language.2",option)
	else
		d("invalid language code")
		d("only en, de, fr, ru, es, jp, pl, it, br, kr or zh allowed")
	end
end


function BMU.sc_addFavoritePlayer(option)
	local options = BMU.sc_parseOptions(option)
	local displayName = options[1]
	local position = tonumber(options[2])
	if displayName ~= nil and string.sub(displayName, 1, 1) == "@" and position ~= nil and position >= 1 and position <= 10 then
		BMU.addFavoritePlayer(position, displayName)
	else
		d("invalid player name or slot")
		d("player name has to begin with @... and slot must be a number between 1-10")
	end
end


function BMU.sc_addFavoriteZone(option)
	local options = BMU.sc_parseOptions(option)
	local zoneId = tonumber(options[1])
	local position = tonumber(options[2])
	local zoneName = BMU.formatName(GetZoneNameById(zoneId), BMU.savedVarsAcc.formatZoneName)
	if zoneName ~= nil and position ~= nil and position >= 1 and position <= 5 then
		BMU.addFavoriteZone(position, zoneId, zoneName)
	else
		d("invalid zone id or slot")
		d("zone id must be exist and slot must be a number between 1-5")
	end
end


function BMU.sc_getCurrentZoneId()
	local playersZoneIndex = GetUnitZoneIndex("player")
	local playersZoneId = GetZoneId(playersZoneIndex)
	d("Current zone id: " .. playersZoneId)
end


function BMU.sc_customVoteUnanimous(option)
	if option ~= nil and option ~= "" then
		BeginGroupElection(GROUP_ELECTION_TYPE_GENERIC_UNANIMOUS, option)
	else
		d("invalid custom text")
	end
end


function BMU.sc_customVoteSupermajority(option)
	if option ~= nil and option ~= "" then
		BeginGroupElection(GROUP_ELECTION_TYPE_GENERIC_SUPERMAJORITY, option)
	else
		d("invalid custom text")
	end
end


function BMU.sc_customVoteSimplemajority(option)
	if option ~= nil and option ~= "" then
		BeginGroupElection(GROUP_ELECTION_TYPE_GENERIC_SIMPLEMAJORITY, option)
	else
		d("invalid custom text")
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

	-- initialize chat commands
	-- check if zone name data is available in client language
	-- use English zoneData if zoneData in client language is not available
	local libZoneData = BMU.LibZoneGivenZoneData
	local zoneData = libZoneData[string.lower(BMU.lang)] or libZoneData["en"]
	if zoneData ~= nil then
		local blacklistForSlashPorting = BMU.blacklistForSlashPorting
		
		for zoneId, zoneName in pairs(zoneData) do
			if type(zoneId) == "number" and type(zoneName) == "string" then
				local comName = "/bmutp/" .. string.gsub(string.lower(BMU.formatName(zoneName, BMU.savedVarsAcc.formatZoneName)), " ", "_")
				if SLASH_COMMANDS[comName] == nil and CanJumpToPlayerInZone(zoneId) and not blacklistForSlashPorting[zoneId] then -- dont overwrite existing command, check for solo zones by game, check for blacklisting
					LSC:Register(comName, function(option) BMU.sc_porting(zoneId) end, "")
				end
			end
		end
	end

	-- refresh chat commands cache (for auto completing)
	--SLASH_COMMAND_AUTO_COMPLETE:InvalidateSlashCommandCache()
end


function BMU.sc_joinBlacklistForSlashPorting(list)
	-- join the lists to global blacklist (merge to HashMap instead to a list)
	local blacklistForSlashPorting = BMU.blacklistForSlashPorting
	for index, value in ipairs(list) do
		blacklistForSlashPorting[value] = true
	end
end


function BMU.sc_porting(zoneId)
	local resultTable = BMU.createTable({index=6, fZoneId=zoneId, dontDisplay=true})
	local entry = resultTable[1]
	
	if entry.displayName ~= nil and entry.displayName ~= "" then
		BMU.PortalToPlayer(entry.displayName, entry.sourceIndexLeading, entry.zoneName, entry.zoneId, entry.category, true, true, true)
	elseif BMU.savedVarsAcc.showZonesWithoutPlayers2 then
		BMU.PortalToZone(zoneId)
	else
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
				displayName, _, _, _, secsSinceLogoff = GetGuildMemberInfo(guildId, playerIndex)
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


function BMU.sc_testTableMerge()
	local function cat(t, ...)  
		local new = {unpack(t)}  
		for i,v in ipairs({...}) do  
			for ii,vv in ipairs(v) do  
				new[#new+1] = vv  
			end  
		end  
		return new  
	end
	
	
	local a = {unpack(BMU.blacklistGroupArenas),
				unpack(BMU.blacklistGroupZones),
				unpack(BMU.blacklistGroupDungeons),
				unpack(BMU.blacklistRaids)
			}
	local b = #BMU.blacklistGroupArenas + #BMU.blacklistGroupZones + #BMU.blacklistGroupDungeons + #BMU.blacklistRaids	
	d(b .. ' == ' .. #a)
	
	local c = {}
	c = {unpack(c), unpack(BMU.var.partnerGuilds[GetWorldName()])}
	c = {unpack(c), unpack(BMU.var.partnerGuilds[GetWorldName()])}
	local dd = #BMU.var.partnerGuilds[GetWorldName()] + #BMU.var.partnerGuilds[GetWorldName()]
	d(dd .. ' == ' .. #c)
	
	local e = cat(BMU.blacklistGroupArenas, BMU.blacklistGroupZones, BMU.blacklistGroupDungeons, BMU.blacklistRaids)
	d('NEU')
	d(b .. ' == ' .. #e)
	
	local f = cat(BMU.var.partnerGuilds[GetWorldName()], BMU.var.partnerGuilds[GetWorldName()])
	d(dd .. ' == ' .. #f)
end



function BMU.sc_findNodesofZoneId(zoneId)
	local list = {zoneId}
	local counter = 1
	for _, zoneId in ipairs(list) do
		for i = 1, GetNumFastTravelNodes() do
			local known, name, normalizedX, normalizedY, icon, glowIcon, poiType, isShownInCurrentMap, linkedCollectibleIsLocked = GetFastTravelNodeInfo(i)
			if string.match(string.lower(name), string.lower(BMU.formatName(GetZoneNameById(zoneId), true))) then
				d("MATCH" .. counter .. ": " .. name .. "(" .. i.. ") | " .. GetZoneNameById(zoneId) .. "(" .. zoneId .. ")")
				counter = counter + 1
			end
		end
	end
	--d(counter)
end

function BMU.sc_printAllDungeonNodesOfCurrentZone()
	for i = 1, GetNumFastTravelNodes() do
		local known, name, normalizedX, normalizedY, icon, glowIcon, poiType, isShownInCurrentMap, linkedCollectibleIsLocked = GetFastTravelNodeInfo(i)
		if poiType == POI_TYPE_GROUP_DUNGEON and isShownInCurrentMap then
			d("NodeIndex: " .. i .. "  |  " .. name)
		end
	end
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


function test()
	local link = "|H1:item:156616:6:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"
	--GetItemLinkItemStyle(GetItemLink(0, 5)))
	d(GetItemLinkItemStyle(link))
end


function test2()
	for i = 1, 500 do
            displayName, Note, GuildMemberRankIndex, status, secsSinceLogoff = GetGuildMemberInfo(GetGuildId(1), i)
            hasCharacter, characterName, zoneName, classType, alliance, level, championRank, zoneId = GetGuildMemberCharacterInfo(GetGuildId(1), i)
			--d(displayName)
			--d(GetGuildMemberCharacterInfo(GetGuildId(1), i))
		if displayName == "@AndVinny" then
			d(GetGuildMemberCharacterInfo(GetGuildId(1), i))
		end
	end
end


function testGeoParentZones()
	local count = 0
	for zoneId=1, 1400 do
		if GetZoneNameById(zoneId) ~= "" then
			local myParentZone = BMU.getParentZoneId(zoneId)
			local libZoneParentZone = LibZone:GetZoneGeographicalParentZoneId(zoneId)
			if myParentZone ~= libZoneParentZone then
				count = count + 1
				d(GetZoneNameById(zoneId) .. " | BMU: " .. GetZoneNameById(myParentZone) .. "(" .. tostring(myParentZone) .. ") | LibZone: " .. GetZoneNameById(libZoneParentZone) .. "(" .. tostring(libZoneParentZone) .. ")")
			end
		end
	end
	d("NO MATCH: " .. count)
end


function testWayshrineFind(zoneId)
	local mapIndex = BMU.getMapIndex(zoneId)
	ZO_WorldMap_SetMapByIndex(mapIndex)
	for i = 1, GetNumFastTravelNodes() do
		local known, name, normalizedX, normalizedY, icon, glowIcon, poiType, isShownInCurrentMap, linkedCollectibleIsLocked = GetFastTravelNodeInfo(i)
		if isShownInCurrentMap and poiType == POI_TYPE_WAYSHRINE then
			d("MATCH: " .. name)
		end
	end
end