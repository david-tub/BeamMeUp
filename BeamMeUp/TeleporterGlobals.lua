BMU = {}

BMU.win =   {
      Main_Control = {},
}

BMU.var = {
  appName               = "BeamMeUp",
  appNameAbbr			= "BMU",
  version				= "", -- Will be set by help of function GetAddonVersionFromManifest(), see file BeamMeUp.lua event_add_on_loaded
  author				= "DeadSoon, Gamer1986PAN",
  website				= "https://www.esoui.com/downloads/info2143-BeamMeUp-TeleporterFastTravel.html",
  feedback				= "https://www.esoui.com/portal.php?id=283&a=faq", -- FAQ link
  controls              = {},
  isAddonLoaded         = false,
  color                 = {
    colTrash     = "777777", -- Trash Gray
    colYellow    = "FFFF00" ,-- yellow
    colArcane    = "3689ef", -- blue (Rare)
    colWhite     = "FFFFFF", -- white
    colRed       = "FF0000", -- Red
    colLegendary = "d5b526", -- gold (TheShit)
    colGreen     = "00FF00", -- green
	colOrange    = "fd7a1a", -- orange
	colBlue		 = "75bac1", -- light blue / teal (for repeatable quests)
	colDarkRed	 = "a20000", -- dark red (for unrelated quests)
	colGray		 = "8c8c8c", -- light gray for placeholder
  },
  
  BMUGuilds = BMU_GuildData.officialGuilds,
  partnerGuilds = BMU_GuildData.partnerGuilds,
  guildHouse = BMU_GuildData.guildHouses,

  numFavoriteZones = 10,
  numFavoritePlayers = 5,
}

-- libraries
BMU.LibZone = LibZone
if BMU.LibZone == nil then
	if LibStub then
		BMU.LibZone = LibStub('LibZone', true)
	else
		d("[" .. BMU.var.appName .. " - ERROR] unable to load library LibZone")
	end
end

BMU.LAM = LibAddonMenu2
if BMU.LAM == nil then
	if LibStub then
		BMU.LAM = LibStub('LibAddonMenu-2.0', true)
	else
		d("[" .. BMU.var.appName .. " - ERROR] unable to load library LibAddonMenu-2.0")
	end
end

-- optional libraries
BMU.LSC = LibSlashCommander
if BMU.LSC == nil and LibStub then
	BMU.LSC = LibStub('LibSlashCommander', true)
end

BMU.LibSets = LibSets
if BMU.LibSets == nil and LibStub then
	BMU.LibSets = LibStub('LibSets', true)
end

BMU.LibMapPing = LibMapPing
if BMU.LibMapPing == nil and LibStub then
	BMU.LibMapPing = LibStub('LibMapPing', true)
end


-------------VERY FIRST FUNCTIONS---------
function BMU.mergeTables(t, ...)
	local new = {unpack(t)}
	for i, v in ipairs({...}) do
		for ii, vv in ipairs(v) do
			new[#new+1] = vv
		end
	end
	return new
end

-- colorize text
function BMU.colorizeText(text, color)
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

-- send addon messages to the chat
function BMU.printToChat(text)
	local prefix = "[" .. BMU.var.appNameAbbr .. "]"
	local prefix_colorized = BMU.colorizeText(prefix, "white")

	d(prefix_colorized .. ": " .. text)
end
-----------------------------------------

-- Textures
BMU.textures = {
	tooltipSeperator = "|t120:5:esoui/art/guild/sectiondivider_left.dds|t",
	anchorMapBtn = "/BeamMeUp/media/dock.dds",
	anchorMapBtnOver = "/BeamMeUp/media/dock_over.dds",
	lockClosedBtn = "/BeamMeUp/media/lock_closed.dds",
	lockClosedBtnOver = "/BeamMeUp/media/lock_closed_over2.dds",
	lockOpenBtn = "/BeamMeUp/media/lock_open.dds",
	lockOpenBtnOver = "/BeamMeUp/media/lock_open_over2.dds",
	swapBtn = "/BeamMeUp/media/swap.dds",
	swapBtnOver = "/BeamMeUp/media/swap_over.dds",
	closeBtn = "/BeamMeUp/media/close.dds",
	closeBtnOver = "/BeamMeUp/media/close_over.dds",
	feedbackBtn = "/esoui/art/mail/mail_tabicon_compose_up.dds",
	feedbackBtnOver = "/esoui/art/mail/mail_tabicon_compose_down.dds",
	searchBtn = "/BeamMeUp/media/tradinghouse_browse_tabicon.dds",
	searchBtnOver = "/BeamMeUp/media/tradinghouse_browse_tabicon_over.dds",
	refreshBtn = "/BeamMeUp/media/gp_radialicon_trade.dds",
	refreshBtnOver = "/BeamMeUp/media/gp_radialicon_trade_over.dds",
	questBtn = "/BeamMeUp/media/quest.dds",
	questBtnOver = "/BeamMeUp/media/quest_over.dds",
	wayshrineBtn = "/BeamMeUp/media/poi_wayshrine_complete.dds",
	wayshrineBtnOver = "/BeamMeUp/media/poi_wayshrine_complete_over.dds",
	-- wayshrine button texture with event cycle
	wayshrineBtn2 = "/BeamMeUp/media/poi_wayshrine_complete.dds",
	wayshrineBtnOver2 = "/BeamMeUp/media/poi_wayshrine_complete_over.dds",
	settingsBtn = "/BeamMeUp/media/menubar_mainmenu.dds",
	settingsBtnOver = "/BeamMeUp/media/menubar_mainmenu_over.dds",
	relatedItemsBtn = "/BeamMeUp/media/help_tabicon_overview.dds",
	relatedItemsBtnOver = "/BeamMeUp/media/help_tabicon_overview_over.dds",
	currentZoneBtn = "/BeamMeUp/media/menubar_map.dds",
	currentZoneBtnOver = "/BeamMeUp/media/menubar_map_over.dds",
	delvesBtn = "/BeamMeUp/media/poi_delve_complete.dds",
	delvesBtnOver = "/BeamMeUp/media/poi_delve_complete_over.dds",
	publicDungeonBtn = "/BeamMeUp/media/poi_dungeon_complete.dds",
	publicDungeonBtnOver = "/BeamMeUp/media/poi_dungeon_complete_over.dds",
	houseBtn = "/BeamMeUp/media/poi_group_house_owned.dds",
	houseBtnOver = "/BeamMeUp/media/poi_group_house_owned_over.dds",
	groupDungeonBtn = "/BeamMeUp/media/poi_groupinstance_complete.dds",
	groupDungeonBtnOver = "/BeamMeUp/media/poi_groupinstance_complete_over.dds",
	raidDungeonBtn = "/BeamMeUp/media/poi_raiddungeon_complete.dds",
	raidDungeonBtnOver = "/BeamMeUp/media/poi_raiddungeon_complete_over.dds",
	endlessDungeonBtn = "/BeamMeUp/media/poi_endlessdungeon_complete.dds",
	endlessDungeonBtnOver = "/BeamMeUp/media/poi_endlessdungeon_complete_over.dds",
	groupZonesBtn = "/BeamMeUp/media/poi_groupdelve_complete.dds",
	groupZonesBtnOver = "/BeamMeUp/media/poi_groupdelve_complete_over.dds",
	groupLeaderBtn = "/BeamMeUp/media/lfg_leader_icon.dds",
	groupLeaderBtnOver = "/BeamMeUp/media/lfg_leader_icon_over.dds",
	guildBtn = "/BeamMeUp/media/menubar_guilds.dds",
	guildBtnOver = "/BeamMeUp/media/menubar_guilds_over.dds",
	guildHouseBtn = "/BeamMeUp/media/guild_hall_temple.dds",
	guildHouseBtnOver = "/BeamMeUp/media/guild_hall_temple_mouseover.dds",
	ptfHouseBtn = "/BeamMeUp/media/ptf_house.dds",
	ptfHouseBtnOver = "/BeamMeUp/media/ptf_house_mouseover.dds",
	soloArenaBtn = "/BeamMeUp/media/poi_solotrial.dds",
	soloArenaBtnOver = "/BeamMeUp/media/poi_solotrial_over.dds",
	dungeonDifficultyNormal = "|t32:32:esoui/art/lfg/lfg_normaldungeon_up.dds|t",
	dungeonDifficultyVeteran = "|t32:32:esoui/art/lfg/lfg_veterandungeon_up.dds|t",
	noPlayerBtn = "/BeamMeUp/media/guildstore_sell_tabicon.dds",
	noPlayerBtnOver = "/BeamMeUp/media/guildstore_sell_tabicon_over.dds",
	arrowDown = "|t32:32:esoui/art/worldmap/mapnav_downarrow_up.dds|t",
	arrowUp = "|t32:32:esoui/art/worldmap/mapnav_uparrow_up.dds|t",
	acceptGreen = "|t16:16:esoui/art/interaction/accept.dds|t",
	declineRed = "|t16:16:esoui/art/interaction/goodbye.dds|t",
}

-- Special textures for event days
local ld = os.date("*t")
if ld.month == 2 and ld.day >= 11 and ld.day <= 14 then
	-- Valentine's Day (val)
	BMU.textures.wayshrineBtn2 = "/BeamMeUp/media/poi_wayshrine_complete_val.dds"
	BMU.textures.wayshrineBtnOver2 = "/BeamMeUp/media/poi_wayshrine_complete_over_val.dds"
elseif (ld.month == 3 and ld.day >= 20) or (ld.month == 4 and ld.day <= 25) then
	-- Ester (egg)
	BMU.textures.wayshrineBtn2 = "/BeamMeUp/media/poi_wayshrine_complete_egg.dds"
	BMU.textures.wayshrineBtnOver2 = "/BeamMeUp/media/poi_wayshrine_complete_over_egg.dds"
elseif ld.month == 10 and ld.day >= 27 then
	-- Halloween (hw)
	BMU.textures.wayshrineBtn2 = "/BeamMeUp/media/poi_wayshrine_complete_hw.dds"
	BMU.textures.wayshrineBtnOver2 = "/BeamMeUp/media/poi_wayshrine_complete_over_hw.dds"
elseif ld.month == 12 and ld.day >= 17 and ld.day <= 26 then
	-- Christmas (xmas)
	BMU.textures.wayshrineBtn2 = "/BeamMeUp/media/poi_wayshrine_complete_xmas.dds"
	BMU.textures.wayshrineBtnOver2 = "/BeamMeUp/media/poi_wayshrine_complete_over_xmas.dds"
elseif (ld.month == 12 and ld.day >= 29) or (ld.month == 1 and ld.day == 1) or (ld.month == 7 and ld.day == 4 and GetWorldName() == "NA Megaserver") then
	-- New year (nye) + Independence Day (NA only)
	BMU.textures.wayshrineBtn2 = "/BeamMeUp/media/poi_wayshrine_complete_nye.dds"
	BMU.textures.wayshrineBtnOver2 = "/BeamMeUp/media/poi_wayshrine_complete_over_nye.dds"
end

-- constant values for the source
TELEPORTER_SOURCE_INDEX_GROUP = 1
TELEPORTER_SOURCE_INDEX_FRIEND = 2
TELEPORTER_SOURCE_INDEX_GUILD1 = 3
TELEPORTER_SOURCE_INDEX_GUILD2 = 4
TELEPORTER_SOURCE_INDEX_GUILD3 = 5
TELEPORTER_SOURCE_INDEX_GUILD4 = 6
TELEPORTER_SOURCE_INDEX_GUILD5 = 7

-- constant values for zone categorization
TELEPORTER_ZONE_CATEGORY_UNKNOWN = 0
TELEPORTER_ZONE_CATEGORY_DELVE = 1
TELEPORTER_ZONE_CATEGORY_PUBDUNGEON = 2
TELEPORTER_ZONE_CATEGORY_HOUSE = 3
TELEPORTER_ZONE_CATEGORY_GRPDUNGEON = 4
TELEPORTER_ZONE_CATEGORY_TRAIL = 5
TELEPORTER_ZONE_CATEGORY_ENDLESSD = 6
TELEPORTER_ZONE_CATEGORY_GRPZONES = 7
TELEPORTER_ZONE_CATEGORY_GRPARENA = 8
TELEPORTER_ZONE_CATEGORY_SOLOARENA = 9
TELEPORTER_ZONE_CATEGORY_OVERLAND = 100

-- flag and cache to check if quest data in journal changed
BMU.questDataCache = {}
BMU.questDataChanged = true
		
-- second language dropdown choices/values
BMU.dropdownSecLangChoices = {"DISABLED", "en", "de", "fr", "ru", "jp", "pl"}
BMU.dropdownSecLangValues = {1, 2, 3, 4, 5, 6, 7}

-- sortings dropdown choices/values
BMU.dropdownSortChoices = {"zone name", "zone category > zone name", "most used zone > zone name", "most used zone > zone category > zone name", "number of players > zone name", "undiscovered wayshrines > zone category > zone name", "undiscovered skyshards > zone category > zone name", "last used zone > zone name", "last used zone > zone category > zone name", "missing set items > zone category > zone name (LibSets must be installed)", "zone category (zones without free options at the end) > zone name"}
BMU.dropdownSortValues = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}

-- prioritization of the sources
BMU.dropdownPrioSourceChoices = {"Friends"}
BMU.dropdownPrioSourceValues = {TELEPORTER_SOURCE_INDEX_FRIEND}
for i = 1, GetNumGuilds() do
	table.insert(BMU.dropdownPrioSourceChoices, GetGuildName(GetGuildId(i)))
	table.insert(BMU.dropdownPrioSourceValues, _G["TELEPORTER_SOURCE_INDEX_GUILD" .. tostring(i)])
end

-- flag to toggle debug mode
BMU.debugMode = 0

-- game language of the client
BMU.lang = GetCVar("language.2")

-- flag to save the current display state (by this the UI display again after opening menus)
BMU.displayComeback = false
	
-- flag to block multiple addition of gold
BMU.blockGold = false

-- State to show correct persistent MouseOver and for auto refresh
BMU.state = 0

-- current SourceIndex 
BMU.stateSourceIndex = 0

-- current ZoneID
BMU.stateZoneId = 0

-- flag to block the start of multiple auto refresh cycles
BMU.blockAutoRefreshCycle = false

-- flag to pause auto refresh (let cycle run)
BMU.pauseAutoRefresh = false

-- flag to check if an error occurred while porting (if an error occurred it contains the error code)
BMU.flagSocialErrorWhilePorting = 0

-- flag if guild data request process is already running (prevents user from being kicked from the server if double-click guild button)
BMU.isCurrentlyRequestingGuildData = false


-- !!!!!!!!!  When new zones are added ingame, you have to add the specific zoneIDs here. See the links below for all IDs and names provided from wiki-esoui.
-- !!!!!!!!!  You may have to add new IDs in more then one lists below (depending on zone type). Just read and check all following lists and decide where the new zone ID needs to be added.

----------------------------------------- Blacklists -- zoneId -> http://wiki.esoui.com/Zones
BMU.blacklist = {}
BMU.blacklistForSlashPorting = {}

-- different unaccessable zones (Thieves Den, Dark Brotherhood Sanctuary)
BMU.blacklistOthers = {821, 826}

-- other zones only for groups (the specific player has to be in the same group) (Group Delves/Dungeons in Craglorn)
BMU.blacklistGroupZones = {890, 893, 895, 897, 899, 904, 906, 908, 907, 913, 909, 914, 915, 916}

-- all Outlaws Refuges
BMU.blacklistRefuges = {746, 747, 748, 479, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 760, 761, 780, 837, 971, 982, 1028, 1088, 1178, 1252, 1293, 1319, 1367, 1412}

--------

-- just Cyrodiil
BMU.blacklistCyro = {181}

-- imperial city and imperial underground and sewers
BMU.blacklistImpCity = {584, 551, 643}

-- Battlegrounds -- order -> http://en.uesp.net/wiki/Online:Battlegrounds
BMU.blacklistBattlegrounds = {509, 511, 510, 508, 513, 512, 514, 517, 518}

--------

-- 4 men Group Dungeons -- order -> http://en.uesp.net/wiki/Online:Veteran_Dungeons
BMU.blacklistGroupDungeons = {380, 935, 126, 931, 176, 681, 1055, 131, 1052, 31, 22, 38, 1009, 144, 936, 130, 932, 1010, 146, 933, 63, 930, 449, 64, 148, 848, 843, 283, 934, 11, 973, 974, 688, 678, 1080, 1081, 1122, 1123, 1152, 1153, 1201, 1197, 1228, 1229, 1267, 1268, 1301, 1302, 1360, 1361, 1389, 1390}

-- 12 men Raids (Trials) -- order -> http://en.uesp.net/wiki/Online:Trials
BMU.blacklistRaids = {1000, 638, 636, 639, 725, 1051, 975, 1121, 1196, 1263, 1344, 1427}

-- Solo Arenas -- https://en.uesp.net/wiki/Online:Arenas (Maelstrom Arena, Vateshran Hollows)
BMU.blacklistSoloArenas = {677, 1227}

-- Group Arenas -- https://en.uesp.net/wiki/Online:Arenas (Dragonstar, BlackRose Prison)
BMU.blacklistGroupArenas = {635, 1082}

-- Endless Dungeons -- Endless Archive
BMU.blacklistEndlessDungeons = {1436}

--------

-- Houses
BMU.blacklistHouses = {940, 942, 941, 939, 938, 937, 859, 858, 878, 868, 869, 873, 860, 861, 877, 852, 853, 881, 867, 866, 874, 863, 862, 876, 871, 870, 872, 864, 865, 875, 855, 854, 880, 856, 857, 879, 944, 943, 945, 882, 883, 994, 995, 997, 996, 1005, 1008, 1007, 1006, 1042, 1043, 1044, 1045, 1059, 1060, 1061, 1063, 1108, 1109, 1064, 1125, 1126, 1128, 1129, 1130, 1154, 1155, 1192, 1193, 1199, 1200, 1218, 1219, 1220, 1233, 1234, 1264, 1265, 1270, 1271, 1275, 1276, 1277, 1307, 1342, 1343, 1306, 1345, 1363, 1364, 1432, 1433, 1434, 1435, 1437, 1468, 1472, 1473}

-----------------------------------------

----------------------------------------- Whitelists

-- special Whitelist just for group members: Group Arenas, Group Dungeons in Craglorn, 4 men Group Dungeons, 12 men Group Dungeons
BMU.whitelistGroupMembers = BMU.mergeTables(BMU.blacklistGroupArenas, BMU.blacklistGroupZones, BMU.blacklistGroupDungeons, BMU.blacklistRaids, BMU.blacklistEndlessDungeons)
									

-- List of all Overland-Zones incl. their delves and public dungeons
-- http://en.uesp.net/wiki/Online:Delves   http://en.uesp.net/wiki/Online:Public_Dungeons
-- additional the assignment of the public dungeons to their group event achievements (skill point)
BMU.overlandDelvesPublicDungeons = {
	-- Greenshade
	[108] = {
		delves = {575, 576, 577, 578, 579, 580},
		publicDungeons = {137},
		publicDungeonsAchievements = {
			[137] = 445,		--Rulanyil's Fall
		}
	},
	-- Auridon
	[381] = {
		delves = {396, 397, 398, 399, 400, 401},
		publicDungeons = {486},
		publicDungeonsAchievements = {
			[486] = 468,		--Toothmaul Gully
		}
	},
	-- Malabal Tor
	[58] = {
		delves = {468, 469, 470, 471, 472, 473},
		publicDungeons = {138},
		publicDungeonsAchievements = {
			[138] = 460,		--Crimson Cove
		}
	},
	-- Grahtwood
	[383] = {
		delves = {444, 447, 442, 475, 477, 478},
		publicDungeons = {124},
		publicDungeonsAchievements = {
			[124] = 470,		--Root Sunder Ruins
		}
	},
	-- Reaper's March
	[382] = {
		delves = {462, 463, 464, 465, 466, 467},
		publicDungeons = {487},
		publicDungeonsAchievements = {
			[487] = 469,		--The Vile Manse
		}
	},
	-- Alik'r Desert
	[104] = {
		delves = {327, 328, 329, 330, 331, 332},
		publicDungeons = {308},
		publicDungeonsAchievements = {
			[308] = 707,		--Lost City of the Na-Totambu
		}
	},
	-- Stormhaven
	[19] = {
		delves = {315, 316, 317, 318, 319, 320},
		publicDungeons = {142},
		publicDungeonsAchievements = {
			[142] = 714,		--Bonesnap Ruins
		}
	},
	-- Rivenspire
	[20] = {
		delves = {321, 322, 323, 324, 325, 326},
		publicDungeons = {162},
		publicDungeonsAchievements = {
			[162] = 713,		--Obsidian Scar
		}
	},
	-- Bangkorai
	[92] = {
		delves = {333, 334, 335, 336, 337, 338},
		publicDungeons = {169},
		publicDungeonsAchievements = {
			[169] = 708,		--Razak's Wheel
		}
	},
	-- Glenumbra
	[3] = {
		delves = {309, 310, 311, 312, 313, 314},
		publicDungeons = {284},
		publicDungeonsAchievements = {
			[284] = 380,		--Bad Man's Hallows
		}
	},
	-- Shadowfen
	[117] = {
		delves = {270, 271, 272, 273, 274, 275},
		publicDungeons = {134},
		publicDungeonsAchievements = {
			[134] = 372,		--Sanguine's Demesne
		}
	},
	-- The Rift
	[103] = {
		delves = {413, 485, 484, 481, 482, 480},
		publicDungeons = {341},
		publicDungeonsAchievements = {
			[341] = 371,		--The Lion's Den
		}
	},
	-- Stonefalls
	[41] = {
		delves = {296, 290, 287, 288, 291, 289},
		publicDungeons = {216},
		publicDungeonsAchievements = {
			[216] = 379,		--Crow's Wood
		}
	},
	-- Eastmarch
	[101] = {
		delves = {359, 360, 361, 362, 363, 364},
		publicDungeons = {339},
		publicDungeonsAchievements = {
			[339] = 381,		--Hall of the Dead
		}
	},
	-- Deshaan
	[57] = {
		delves = {405, 406, 407, 408, 409, 410},
		publicDungeons = {306},
		publicDungeonsAchievements = {
			[306] = 388,		--Forgotten Crypts
		}
	},
	-- Coldharbour
	[347] = {
		delves = {417, 418, 419, 420, 421, 422},
		publicDungeons = {557},
		publicDungeonsAchievements = {
			[557] = 874,		--Village of the Lost
		}
	},
	-- Craglorn
	[888] = {
		delves = {889, 891, 892, 894, 896, 898, 900, 901, 902, 903, 905, 910, 890, 893, 895, 897, 899, 904, 906, 908, 907, 913, 909, 914, 915, 916},
		publicDungeons = {},
	},
	-- Wrothgar
	[684] = {
		delves = {694, 693, 689, 691, 692, 697},
		publicDungeons = {705, 706},
		publicDungeonsAchievements = {
			[705] = 1235,		--Rkindaleft
			[706] = 1238,		--Old Orsinium
		}
	},
	-- Hew's Bane
	[816] = {
		delves = {817, 676},
		publicDungeons = {},
	},
	-- Gold Coast
	[823] = {
		delves = {825, 824},
		publicDungeons = {},
	},
	-- Vvardenfell
	[849] = {
		delves = {961, 921, 922, 923, 924, 925},
		publicDungeons = {919, 918},
		publicDungeonsAchievements = {
			[919] = 1855,		--Forgotten Wastes
			[918] = 1846,		--Nchuleftingth
		}
	},
	-- The Clockwork City
	[980] = {
		delves = {985, 986},
		publicDungeons = {},
	},
	-- The Clockwork City: The Brass Fortress
	[981] = {
		delves = {985, 986},
		publicDungeons = {},
	},
	-- Summerset (+ "Traitor's Vault")
	[1011] = {
		delves = {1016, 1017, 1015, 1018, 1014, 1019},
		publicDungeons = {1020, 1021},
		publicDungeonsAchievements = {
			[1020] = 2096,		--Karnwasten
			[1021] = 2095,		--Sunhold
		}
	},
	-- Artaeum
	[1027] = {
		delves = {1016},
		publicDungeons = {},
	},
	-- Bal Foyen
	[281] = {
		delves = {},
		publicDungeons = {},
	},
	-- Stros M'Kai
	[534] = {
		delves = {},
		publicDungeons = {},
	},
	-- Betnikh
	[535] = {
		delves = {},
		publicDungeons = {},
	},
	-- Khenarthi's Roost
	[537] = {
		delves = {},
		publicDungeons = {},
	},
	-- Bleakrock Isle
	[280] = {
		delves = {},
		publicDungeons = {},
	},
	-- Murkmire
	[726] = {
		delves = {1073, 1066},
		publicDungeons = {},
	},
	-- Northern Elsweyr
	[1086] = {
		delves = {1091, 1092, 1094, 1095, 1096, 1119},
		publicDungeons = {1089, 1090},
		publicDungeonsAchievements = {
			[1089] = 2444,		--Rimmen Necropolis
			[1090] = 2445,		--Orcrest
		}
	},
	-- Southern Elsweyr
	[1133] = {
		delves = {1134, 1135},
		publicDungeons = {},
	},
	-- Western Skyrim
	[1160] = {
		delves = {1166, 1167, 1168, 1170},
		publicDungeons = {1186},
		publicDungeonsAchievements = {
			[1186] = 2714,		--Labyrinthian
		}
	},
	-- Blackreach: Greymoor Caverns
	[1161] = {
		delves = {1165, 1169},
		publicDungeons = {1187},
		publicDungeonsAchievements = {
			[1187] = 2715,		-- Nchuthnkarst
		}
	},
	-- Reach
	[1207] = {
		delves = {1209, 1210},
		publicDungeons = {},
	},
	-- Blackreach: Arkthzand Caverns
	[1208] = {
		delves = {1209},
		publicDungeons = {},
	},
	-- Blackwood
	[1261] = {
		delves = {1253, 1254, 1255, 1256, 1257, 1258},
		publicDungeons = {1259, 1260},
		publicDungeonsAchievements = {
			[1259] = 2995,		--Zenithar's Abbey
			[1260] = 2994,		--The Silent Halls
		}
	},
	-- Deadlands
	[1286] = {
		delves = {1297, 1298},
		publicDungeons = {},
	},
	-- Fargrave - City
	[1282] = {
		delves = {},
		publicDungeons = {},
	},
	-- The Shambles
	[1283] = {
		delves = {},
		publicDungeons = {},
	},
	-- High Isle
	[1318] = {
		delves = {1331, 1332, 1333, 1334, 1335, 1336},
		publicDungeons = {1337, 1338},
		publicDungeonsAchievements = {
			[1337] = 3283,		--Spire of the Crimson Coin
			[1338] = 3281,		--Ghost Haven Bay
		}
	},
	-- Galen and Y'ffelon
	[1383] = {
		delves = {1374, 1375},
		publicDungeons = {},
	},
	-- Telvanni Peninsula
	[1414] = {
    		delves = {1396, 1397, 1398},
    		publicDungeons = {1415},
		publicDungeonsAchievements = {
			[1415] = 3658,		--Gorne
		}
  	},
  	-- Apocrypha
  	[1413] = {
    		delves = {1399, 1400, 1401},
    		publicDungeons = {1416},
		publicDungeonsAchievements = {
			[1416] = 3657,		--The Underweave
		}
  },
	}
			

-- maps nodeIndicies with specific/selected zoneIds
-- structure: [<zone_id of the instance>] = {<node_index>, <abbreviation>, <is DLC>, <DLC name>, <update>, <release date>}
BMU.nodeIndexMap = {
	-- ENDLESS DUNGEONS
	-- Endless Archive
	[1436] = {
		nodeIndex = 550,
		abbreviation = "EA",
		isBaseGame = true,
		updateNum = 40,
		releaseDate = "2023/10"
	},

	-- SOLO ARENAS
	-- Maelstrom Arena
	[677] = {
		nodeIndex = 250,
		abbreviation = "MSA / MA",
		isDLC = true,
		updateName = "Orsinium",
		updateNum = 8,
		releaseDate = "2015/11"
	},
	-- Vateshran Hollows
	[1227] = {
		nodeIndex = 457,
		abbreviation = "VH / Vateshran",
		isDLC = true,
		updateName = "Markarth",
		updateNum = 28,
		releaseDate = "2020/11"
	},
	
	-- GROUP ARENAS
	-- Dragonstar Arena
	[635] = {
		nodeIndex = 270,
		abbreviation = "DSA",
		isBaseGame = true,
		updateNum = 4,
		releaseDate = "2014/09"
	},
	-- Black Rose Prison
	[1082] = {
		nodeIndex = 378,
		abbreviation = "BRP",
		isDLC = true,
		updateName = "Murkmire",
		updateNum = 20,
		releaseDate = "2018/10"
	},

	-- TRIALS
	-- Hel Ra Citadel
	[636] = {
		nodeIndex = 230,
		abbreviation = "HRC / Hel Ra",
		isBaseGame = true,
		updateNum = 1,
		releaseDate = "2014/05"
	},
	-- Aetherian Archive
	[638] = {
		nodeIndex = 231,
		abbreviation = "AA",
		isBaseGame = true,
		updateNum = 1,
		releaseDate = "2014/05"
	},
	-- Sanctum Ophidia
	[639] = {
		nodeIndex = 232,
		abbreviation = "SO",
		isBaseGame = true,
		updateNum = 4,
		releaseDate = "2014/09"
	},
	-- Maw of Lorkhaj
	[725] = {
		nodeIndex = 258,
		abbreviation = "MoL",
		isDLC = true,
		updateName = "Thieves Guild",
		updateNum = 9,
		releaseDate = "2016/03"
	},
	-- Halls of Fabrication
	[975] = {
		nodeIndex = 331,
		abbreviation = "HoF",
		isChapter = true,
		updateName = GetString(SI_CHAPTER1),
		updateNum = 14,
		releaseDate = "2017/05"
	},
	-- Asylum Sanctorium
	[1000] = {
		nodeIndex = 346,
		abbreviation = "AS",
		isDLC = true,
		updateName = "Clockwork City",
		updateNum = 16,
		releaseDate = "2017/10"
	},
	-- Cloudrest
	[1051] = {
		nodeIndex = 364,
		abbreviation = "CR",
		isChapter = true,
		updateName = GetString(SI_CHAPTER2),
		updateNum = 18,
		releaseDate = "2018/05"
	},
	-- Sunspire
	[1121] = {
		nodeIndex = 399,
		abbreviation = "SS",
		isChapter = true,
		updateName = GetString(SI_CHAPTER3),
		updateNum = 22,
		releaseDate = "2019/05"
	},
	-- Kyne's Aegis
	[1196] = {
		nodeIndex = 434,
		abbreviation = "KA",
		isChapter = true,
		updateName = GetString(SI_CHAPTER4),
		updateNum = 26,
		releaseDate = "2020/05"
	},
	-- Rockgrove
	[1263] = {
		nodeIndex = 468,
		abbreviation = "RG",
		isChapter = true,
		updateName = GetString(SI_CHAPTER5),
		updateNum = 30,
		releaseDate = "2021/06"
	},
	-- Dreadsail Reef
	[1344] = {
		nodeIndex = 488,
		abbreviation = "DR/DSR",
		isChapter = true,
		updateName = GetString(SI_CHAPTER6),
		updateNum = 34,
		releaseDate = "2022/06"
	},
	-- Sanity's Edge
	[1427] = {
		nodeIndex = 534,
		abbreviation = "SE",
		isChapter = true,
		updateName = GetString(SI_CHAPTER7),
		updateNum = 38,
		releaseDate = "2023/06"
	},

	-- GROUP DUNGEONS
	-- Base Game
	-- Vaults of Madness
	[11] = {
		nodeIndex = 184,
		abbreviation = "VoM / Vaults",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Volenfell
	[22] = {
		nodeIndex = 196,
		abbreviation = "VF / Volenfell",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Selene's Web
	[31] = {
		nodeIndex = 185,
		abbreviation = "SW / Selene",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Blackheart Haven
	[38] = {
		nodeIndex = 186,
		abbreviation = "BHH / Blackheart",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Darkshade Caverns I
	[63] = {
		nodeIndex = 198,
		abbreviation = "DSC 1 / Darkshade 1",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Blessed Crucible
	[64] = {
		nodeIndex = 187,
		abbreviation = "BC / Crucible",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Elden Hollow I
	[126] = {
		nodeIndex = 191,
		abbreviation = "EH1 / Elden1",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Crypt of Hearts I
	[130] = {
		nodeIndex = 190,
		abbreviation = "CoH1 / Crypts 1",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Tempest Island
	[131] = {
		nodeIndex = 188,
		abbreviation = "TI / Tempest",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Spindleclutch I
	[144] = {
		nodeIndex = 193,
		abbreviation = "SC1 / Spindle 1",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Wayrest Sewers I
	[146] = {
		nodeIndex = 189,
		abbreviation = "WRS1 / Wayrest 1",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Arx Corinium
	[148] = {
		nodeIndex = 192,
		abbreviation = "AC / Arx",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- City of Ash I
	[176] = {
		nodeIndex = 197,
		abbreviation = "CoA 1",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Fungal Grotto I
	[283] = {
		nodeIndex = 98,
		abbreviation = "FG1 / Fungal 1",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- The Banished Cells I
	[380] = {
		nodeIndex = 194,
		abbreviation = "BC1 / Banished 1",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Direfrost Keep
	[449] = {
		nodeIndex = 195,
		abbreviation = "DFK / DK / Direfrost",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Darkshade Caverns I
	[930] = {
		nodeIndex = 264,
		abbreviation = "DSC 2 / Darkshade 2",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Elden Hollow II
	[931] = {
		nodeIndex = 265,
		abbreviation = "EH2 / Elden2",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Wayrest Sewers II
	[933] = {
		nodeIndex = 263,
		abbreviation = "WRS2 / Wayrest 2",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Fungal Grotto II
	[934] = {
		nodeIndex = 266,
		abbreviation = "FG2 / Fungal 2",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- The Banished Cells II
	[935] = {
		nodeIndex = 262,
		abbreviation = "BC2 / Banished 2",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Spindleclutch II
	[936] = {
		nodeIndex = 267,
		abbreviation = "SC2 / Spindle 2",
		isBaseGame = true,
		updateNum = 0,
		releaseDate = "2014/04"
	},
	-- Crypt of Hearts II
	[932] = {
		nodeIndex = 269,
		abbreviation = "CoH2 / Crypts 2",
		isBaseGame = true,
		updateNum = 2,
		releaseDate = "2014/06"
	},
	-- City of Ash II
	[681] = {
		nodeIndex = 268,
		abbreviation = "CoA 2",
		isBaseGame = true,
		updateNum = 5,
		releaseDate = "2014/11"
	},

	-- DLC
	-- Imperial City Prison
	[678] = {
		nodeIndex = 236,
		abbreviation = "ICP / Prison",
		isDLC = true,
		updateName = "Imperial City",
		updateNum = 7,
		releaseDate = "2015/08"
	},
	-- White-Gold Tower
	[688] = {
		nodeIndex = 247,
		abbreviation = "WGT",
		isDLC = true,
		updateName = "Imperial City",
		updateNum = 7,
		releaseDate = "2015/08"
	},
	-- Ruins of Mazzatun
	[843] = {
		nodeIndex = 260,
		abbreviation = "RoM / Mazza",
		isDLC = true,
		updateName = "Shadow of the Hist",
		updateNum = 11,
		releaseDate = "2016/08"
	},
	-- Cradle of Shadows
	[848] = {
		nodeIndex = 261,
		abbreviation = "CoS",
		isDLC = true,
		updateName = "Shadow of the Hist",
		updateNum = 11,
		releaseDate = "2016/08"
	},
	-- Bloodroot Forge
	[973] = {
		nodeIndex = 326,
		abbreviation = "BRF / BF",
		isDLC = true,
		updateName = "Horns of the Reach",
		updateNum = 15,
		releaseDate = "2017/08"
	},
	-- Falkreath Hold
	[974] = {
		nodeIndex = 332,
		abbreviation = "FH",
		isDLC = true,
		updateName = "Horns of the Reach",
		updateNum = 15,
		releaseDate = "2017/08"
	},
	-- Fang Lair
	[1009] = {
		nodeIndex = 341,
		abbreviation = "FL",
		isDLC = true,
		updateName = "Dragon Bones",
		updateNum = 17,
		releaseDate = "2018/02"
	},
	-- Scalecaller Peak
	[1010] = {
		nodeIndex = 363,
		abbreviation = "SCP",
		isDLC = true,
		updateName = "Dragon Bones",
		updateNum = 17,
		releaseDate = "2018/02"
	},
	-- Moon Hunter Keep
	[1052] = {
		nodeIndex = 371,
		abbreviation = "MHK",
		isDLC = true,
		updateName = "Wolfhunter",
		updateNum = 19,
		releaseDate = "2018/08"
	},
	-- March of Sacrifices
	[1055] = {
		nodeIndex = 370,
		abbreviation = "MoS",
		isDLC = true,
		updateName = "Wolfhunter",
		updateNum = 19,
		releaseDate = "2018/08"
	},
	-- Frostvault
	[1080] = {
		nodeIndex = 389,
		abbreviation = "FV / Frost",
		isDLC = true,
		updateName = "Wrathstone",
		updateNum = 21,
		releaseDate = "2019/02"
	},
	-- Depths of Malatar
	[1081] = {
		nodeIndex = 390,
		abbreviation = "DoM",
		isDLC = true,
		updateName = "Wrathstone",
		updateNum = 21,
		releaseDate = "2019/02"
	},
	-- Moongrave Fane
	[1122] = {
		nodeIndex = 391,
		abbreviation = "MGF / MF",
		isDLC = true,
		updateName = "Scalebreaker",
		updateNum = 23,
		releaseDate = "2019/08"
	},
	-- Lair of Maarselok
	[1123] = {
		nodeIndex = 398,
		abbreviation = "LoM",
		isDLC = true,
		updateName = "Scalebreaker",
		updateNum = 23,
		releaseDate = "2019/08"
	},
	-- Icereach
	[1152] = {
		nodeIndex = 424,
		abbreviation = "IR / Ice",
		isDLC = true,
		updateName = "Harrowstorm",
		updateNum = 25,
		releaseDate = "2020/03"
	},
	-- Unhallowed Grave
	[1153] = {
		nodeIndex = 425,
		abbreviation = "UG",
		isDLC = true,
		updateName = "Harrowstorm",
		updateNum = 25,
		releaseDate = "2020/03"
	},
	-- Stone Garden
	[1197] = {
		nodeIndex = 435,
		abbreviation = "SG",
		isDLC = true,
		updateName = "Stonethorn",
		updateNum = 27,
		releaseDate = "2020/09"
	},
	-- Castle Thorn
	[1201] = {
		nodeIndex = 436,
		abbreviation = "CT",
		isDLC = true,
		updateName = "Stonethorn",
		updateNum = 27,
		releaseDate = "2020/09"
	},
	-- Black Drake Villa
	[1228] = {
		nodeIndex = 437,
		abbreviation = "BDV",
		isDLC = true,
		updateName = "Flames of Ambition",
		updateNum = 29,
		releaseDate = "2021/03"
	},
	-- The Cauldron
	[1229] = {
		nodeIndex = 454,
		abbreviation = "CD / Cauldron",
		isDLC = true,
		updateName = "Flames of Ambition",
		updateNum = 29,
		releaseDate = "2021/03"
	},
	-- Red Petal Bastion
	[1267] = {
		nodeIndex = 470,
		abbreviation = "RPB",
		isDLC = true,
		updateName = "Waking Flame",
		updateNum = 31,
		releaseDate = "2021/08"
	},
	-- The Dread Cellar
	[1268] = {
		nodeIndex = 469,
		abbreviation = "TDC / DC",
		isDLC = true,
		updateName = "Waking Flame",
		updateNum = 31,
		releaseDate = "2021/08"
	},
	-- Coral Aerie
	[1301] = {
		nodeIndex = 497,
		abbreviation = "CA",
		isDLC = true,
		updateName = "Ascending Tide",
		updateNum = 33,
		releaseDate = "2022/03"
	},
	-- Shipwright’s Regret
	[1302] = {
		nodeIndex = 498,
		abbreviation = "SR",
		isDLC = true,
		updateName = "Ascending Tide",
		updateNum = 33,
		releaseDate = "2022/03"
	},
	-- Earthen Root Enclave
	[1360] = {
		nodeIndex = 520,
		abbreviation = "ERE",
		isDLC = true,
		updateName = "Lost Depths",
		updateNum = 35,
		releaseDate = "2022/08"
	},
	-- Graven Deep
	[1361] = {
		nodeIndex = 521,
		abbreviation = "GD",
		isDLC = true,
		updateName = "Lost Depths",
		updateNum = 35,
		releaseDate = "2022/08"
	},
	-- Bal Sunnar
	[1389] = {
		nodeIndex = 531,
		abbreviation = "BS",
		isDLC = true,
		updateName = "Scribes of Fate",
		updateNum = 37,
		releaseDate = "2023/03"
	},
	-- Scrivener's Hall
	[1390] = {
		nodeIndex = 532,
		abbreviation = "SH",
		isDLC = true,
		updateName = "Scribes of Fate",
		updateNum = 37,
		releaseDate = "2023/03"
	},
}


-----------------------------------------

----------------------------------------- Treasure/Survey Maps/Clues


BMU.treasureAndSurveyMaps = {
	--Cyrodiil
	[181] = {
		treasure = {43703, 43704, 43705, 43706, 43707, 43708, 43709, 43710, 43711, 43712, 43713, 43714, 43715, 43716, 43717, 43718, 43719, 43720},
	},
	-- Greenshade
	[108] = {
		alchemist = {57774},
		enchanter = {57802},
		woodworker = {57819},
		blacksmith = {57788},
		clothier = {57757},
		jewelry = {139427},
		treasure = {43637, 43638, 43639, 43640, 43641, 43642, 44938},
		clue = {187902},
	},
	-- Auridon
	[381] = {
		alchemist = {57744},
		enchanter = {57733},
		woodworker = {57741},
		blacksmith = {57687},
		clothier = {57738},
		jewelry = {139422},
		treasure = {153640, 43625, 43626, 43627, 43628, 43629, 43630, 44927},
		clue = {187892},
	},
	-- Malabal Tor
	[58] = {
		alchemist = {57777},
		enchanter = {57805},
		woodworker = {57822},
		blacksmith = {57791},
		clothier = {57760},
		jewelry = {139430},
		treasure = {153644, 43643, 43644, 43645, 43646, 43647, 43648, 44940},
	},
	-- Grahtwood
	[383] = {
		alchemist = {57771},
		enchanter = {57750},
		woodworker = {57816},
		blacksmith = {57747},
		clothier = {57754},
		jewelry = {139425},
		treasure = {43631, 43632, 43633, 43634, 43635, 43636, 44937},
		clue = {188203},
	},
	-- Reaper's March
	[382] = {
		alchemist = {57780},
		enchanter = {57808},
		woodworker = {57825},
		blacksmith = {57793},
		clothier = {57763},
		jewelry = {139432},
		treasure = {153645, 43649, 43650, 43651, 43652, 43653, 43654, 44941},
		clue = {188204, 203826},
	},
	-- Alik'r Desert
	[104] = {
		alchemist = {57779},
		enchanter = {57806},
		woodworker = {57824},
		blacksmith = {57792},
		clothier = {57762},
		jewelry = {139431},
		treasure = {153639, 43613, 43614, 43615, 43616, 43617, 43618, 44926},
		clue = {188206},
	},
	-- Stormhaven
	[19] = {
		alchemist = {57773},
		enchanter = {57752},
		woodworker = {57818},
		blacksmith = {57749},
		clothier = {57756},
		jewelry = {139408},
		treasure = {43601, 43602, 43603, 43604, 43605, 43606, 44945},
	},
	-- Rivenspire
	[20] = {
		alchemist = {57776},
		enchanter = {57804},
		woodworker = {57821},
		blacksmith = {57790},
		clothier = {57759},
		jewelry = {139429},
		treasure = {153646, 43607, 43608, 43609, 43610, 43611, 43612, 44942},
		clue = {191157},
	},
	-- Bangkorai
	[92] = {
		alchemist = {57781},
		enchanter = {57810},
		woodworker = {57827},
		blacksmith = {57795},
		clothier = {57764},
		jewelry = {139434},
		treasure = {153641, 43619, 43620, 43621, 43622, 43623, 43624, 44929},
		clue = {187904, 190927},
	},
	-- Glenumbra
	[3] = {
		alchemist = {57745},
		enchanter = {57734},
		woodworker = {57742},
		blacksmith = {57736},
		clothier = {57739},
		jewelry = {139423},
		treasure = {153642, 43507, 43525, 43527, 43600, 43509, 43526, 44936},
		clue = {187886},
	},
	-- Shadowfen
	[117] = {
		alchemist = {57775},
		enchanter = {57803},
		woodworker = {57820},
		blacksmith = {57789},
		clothier = {57758},
		jewelry = {139428},
		treasure = {153647, 43667, 43668, 43669, 43670, 43671, 43672, 44943},
	},
	-- The Rift
	[103] = {
		alchemist = {57782},
		enchanter = {57809},
		woodworker = {57826},
		blacksmith = {57794},
		clothier = {57765},
		jewelry = {139433},
		treasure = {43679, 43680, 43681, 43682, 43683, 43684, 44947, 194360},
		clue = {187898,203825},
	},
	-- Stonefalls
	[41] = {
		alchemist = {57746},
		enchanter = {57735},
		woodworker = {57743},
		blacksmith = {57737},
		clothier = {57740},
		jewelry = {139424},
		treasure = {153648, 43655, 43656, 43657, 43658, 43659, 43660, 44944},
	},
	-- Eastmarch
	[101] = {
		alchemist = {57778},
		enchanter = {57807},
		woodworker = {57823},
		blacksmith = {57801},
		clothier = {57761},
		jewelry = {139440},
		treasure = {153643, 43673, 43674, 43675, 43676, 43677, 43678, 44935},
	},
	-- Deshaan
	[57] = {
		alchemist = {57772},
		enchanter = {57751},
		woodworker = {57817},
		blacksmith = {57748},
		clothier = {57755},
		jewelry = {139426},
		treasure = {43661, 43662, 43663, 43664, 43665, 43666, 44934},
		clue = {187890, 197843},
	},
	-- Coldharbour
	[347] = {
		alchemist = {57783, 57784},
		enchanter = { 57811, 57812},
		woodworker = {57828, 57829},
		blacksmith = {57796, 57797},
		clothier = {57766, 57767},
		jewelry = {139435, 139436},
		treasure = {43685, 43686, 43687, 43688, 43689, 43690, 44932},
	},
	-- Craglorn
	[888] = {
		alchemist = {57785, 57786, 57787},
		enchanter = { 57813, 57814, 57815},
		woodworker = { 57830, 57831, 57832},
		blacksmith = {57798, 57799, 57800},
		clothier = {57768, 57769, 57770},
		jewelry = {139437, 139439, 139438},
		treasure = {43721, 43722, 43723, 43724, 43725, 43726},
	},
	-- Wrothgar
	[684] = {
		alchemist = {71083, 71084, 71085},
		enchanter = {71086, 71087, 71088},
		woodworker = {71080, 71081, 71082},
		blacksmith = {71065, 71066, 71067},
		clothier = { 71068, 71069, 71070},
		jewelry = { 139441, 139442, 139443},
		treasure = {43727, 43728, 43729, 43730, 43731, 43732},
		clue = {187900},
	},
	-- Hew's Bane
	[816] = {
		treasure = {43733, 43734},
	},
	-- Gold Coast
	[823] = {
		treasure = {43735, 43736},
	},
	-- Vvardenfell
	[849] = {
		alchemist = {126113},
		enchanter = {126122},
		woodworker = {126112},
		blacksmith = {126110},
		clothier = {126111},
		jewelry = {139444},
		treasure = {43737, 43738, 43739, 43740, 43741, 43742, 43743, 43744, 43745},
		clue = {187888},
	},
	-- The Clockwork City
	[980] = {
		treasure = {43746, 43747},
	},
	-- Summerset
	[1011] = {
		treasure = {139008, 139009, 139007, 43748, 43750, 43751, 43752, 43753, 43749},
	},
	-- Bal Foyen
	[281] = {
		treasure = {43701, 43702, 44928},
	},
	-- Stros M'Kai
	[534] = {
		treasure = {43691, 43692, 44946},
		clue = {188205},
	},
	-- Betnikh
	[535] = {
		treasure = {43693, 43694, 44930},
	},
	-- Khenarthi's Roost
	[537] = {
		treasure = {43695, 43696, 43697, 43698, 44939, 45010},
	},
	-- Bleakrock Isle
	[280] = {
		treasure = {43699, 43700, 44931},
	},
	-- Murkmire
	[726] = {
		treasure = {145510, 145512},
	},
	-- Northern Elsweyr
	[1086] = {
		alchemist = {151601},
		enchanter = {151602},
		woodworker = {151600},
		blacksmith = {151598},
		clothier = {151599},
		jewelry = {151603},
		treasure = {147922, 147923, 147924, 151613, 151614, 151615, 151616, 151617, 151618},
	},
	-- Southern Elsweyr
	[1133] = {
		treasure = {156716, 156715},
	},
	-- Western Skyrim
	[1160] = {
		alchemist = {166459},
		enchanter = {166462},
		woodworker = {166465},
		blacksmith = {166460},
		clothier = {166461},
		jewelry = {166464},
		treasure = {166035, 166040, 166041, 166042, 166043},
	},
	-- Blackreach: Greymoor Caverns
	[1161] = {
		treasure = {166036, 166037, 166038, 166039},
	},
	-- The Reach
	[1207] = {
		treasure = {171474},
	},
	-- Blackreach: Arkthzand Cavern
	[1208] = {
		treasure = {171475},
	},
	-- Blackwood
	[1261] = {
		alchemist = {178469},
		enchanter = {178468},
		woodworker = {178465},
		blacksmith = {178464},
		clothier = {178467},
		jewelry = {178466},
		treasure = {175544, 175545, 175546, 175547, 175548, 175549, 175550, 175551, 175552},
	},
	-- Deadlands
	[1286] = {
		treasure = {183005, 183006},
	},
	-- High Isle
	[1318] = {
		alchemist = {188191},
		enchanter = {188195},
		woodworker = {188197},
		blacksmith = {188193},
		clothier = {188194},
		jewelry = {188196},
		treasure = {187668, 187669, 187670, 187671, 187672, 187673, 187674, 187675, 187676},
		clue = {187906},
	},
	-- Crow's Wood
	[216] = {
		clue = {187726},
	},
	-- Wansalen
	[399] = {
		clue = {187894},
	},
	-- The Wailing Maw
	[422] = {
		clue = {187896},
	},
	-- Galen and Y'ffelon
	[1383] = {
		treasure = {192370, 192371},
		clue = {191158},
	},
	-- Telvanni Peninsula
	[1414] = {
		woodworker = {198297},
		blacksmith = {198291},
		jewelry = {198294},
		treasure = {196201, 196202, 198087, 198098, 198099, 198100},
		clue = {197842},
  	},
    -- Apocrypha
  	[1413] = {
		alchemist = {198288},
		enchanter = {198289},
		clothier = {198290},
		treasure = {196203, 198101, 198102},
  	},
}


-------------FUNCTIONS--------------------
function BMU.joinBlacklist(list)
	-- join the lists to global blacklist (merge to HashMap instead to a list)
   for index, value in ipairs(list) do
      BMU.blacklist[value] = true
   end 
end

function BMU.getAllDelves()
	local newList = {}
	-- gather all delves from the global list
	for parentZoneId, tableObject in pairs(BMU.overlandDelvesPublicDungeons) do
		for index, zoneId in ipairs(tableObject.delves) do
			table.insert(newList, zoneId)
		end
	end
	return newList
end

function BMU.getAllPublicDungeons()
	local newList = {}
	-- gather all public dungeons from the global list
	for parentZoneId, tableObject in pairs(BMU.overlandDelvesPublicDungeons) do
		for index, zoneId in ipairs(tableObject.publicDungeons) do
			table.insert(newList, zoneId)
		end
	end
	return newList
end
-----------------------------------------

----------------------------------------- Sorting/Grouping
BMU.sortingByCategory = {
	[TELEPORTER_ZONE_CATEGORY_OVERLAND] 	= 1,
	[TELEPORTER_ZONE_CATEGORY_PUBDUNGEON] 	= 2,
	[TELEPORTER_ZONE_CATEGORY_DELVE] 		= 3,
	[TELEPORTER_ZONE_CATEGORY_UNKNOWN] 		= 4,
	[TELEPORTER_ZONE_CATEGORY_TRAIL] 		= 5,
	[TELEPORTER_ZONE_CATEGORY_GRPDUNGEON] 	= 6,
	[TELEPORTER_ZONE_CATEGORY_GRPARENA] 	= 7,
	[TELEPORTER_ZONE_CATEGORY_ENDLESSD] 	= 8,
	[TELEPORTER_ZONE_CATEGORY_GRPZONES] 	= 9,
	[TELEPORTER_ZONE_CATEGORY_HOUSE] 		= 10,
	[TELEPORTER_ZONE_CATEGORY_SOLOARENA] 	= 11}

-----------------------------------------

---- API FUNCTIONS FOR OTHER ADDONS ----

-- returns a table containing the map (treasure/survey map) type (value) for each itemId (key)
-- value range: "alchemist" | "enchanter" | "woodworker" | "blacksmith" | "clothier" | "jewelry" | "treasure" | "clue"
-- e.g. [57774] = "alchemist"
function BMU.GetMapTypeTable()
	if not BMU.mapTypeByItemId then
		-- build table once
		BMU.mapTypeByItemId = {}
		for zoneId, zoneTab in pairs(BMU.treasureAndSurveyMaps) do
			for mapType, zoneIds in pairs(zoneTab) do
				for _, zoneId in pairs(zoneIds) do
					BMU.mapTypeByItemId[zoneId] = mapType
				end
			end
		end
	end
	return BMU.mapTypeByItemId
end


-- returns current user filter for treasure and survey maps
-- returns 7 boolean values at once, representing the filter states (true: map type is shown)
-- returning values and their order: alchemist, enchanter, woodworker, blacksmith, clothier, jewelry, treasure
function BMU.GetCurrentMapDisplayFilter()
	return BMU.savedVarsChar.displayMaps.alchemist, BMU.savedVarsChar.displayMaps.enchanter,
		BMU.savedVarsChar.displayMaps.woodworker, BMU.savedVarsChar.displayMaps.blacksmith,
		BMU.savedVarsChar.displayMaps.clothier, BMU.savedVarsChar.displayMaps.jewelry,
		BMU.savedVarsChar.displayMaps.treasure
end
