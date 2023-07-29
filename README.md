# BeamMeUp
Addon for Elder Scrolls Online (PC) to utilize the fast travel functionaility of the game.


### Official Addon Website with all details
https://www.esoui.com/downloads/info2143-BeamMeUp-TeleporterFastTravel.html

### Description:
This addon allows you to use the fast travel functionality of the game in a comfortable and highly-customizable way. All fast travel options you have through your guilds, friends and group are listed in a clear way and are usable with different search and filtering features. To get the most out of it, as with any other addon, it is recommended to check the settings after initial installation.

### Installation
1. Download project as zip file
2. Extract the subfolder "BeamMeUp" to the game addon folder: \Documents\Elder Scrolls Online\live\AddOns\BeamMeUp\ ...


***
***
***


## Maintainence Guide
This guide will help developers to maintain the addon for further game updates.


### Updating Zone IDs
- New zones introduced by a game update, DLC or chapter must be added to internal lists for filtering and general display to work correctly. Much information is also retrieved automatically from the API. Nevertheless, it is necessary to maintain some data manually.
- All the zone data is stored in the `TeleporterGlobals.lua`. Depending on the zone type the new IDs must be added to the corresponding tables.
- To determine the corresponding zone IDs you can use the chat command `/bmu/misc/current_zone_id` or check out https://wiki.esoui.com/Zones
- To determine the correspoding item IDs you can use the addon *ItemFinder* or search on https://esoitem.uesp.net/itemSearch.php

#### New overland zone
- Update `BMU.overlandDelvesPublicDungeons`
    - zoneId of the overland zone as index
    - zoneId of the corresponding delves and public dungeons
- Update `BMU.treasureAndSurveyMaps` (if the new overland zone contains treasure & survey maps or clues)
    - zoneId of the overland zone as index
    - itemId of the corresponding survey map (by type), treasure map or clue
- Update `BMU.blacklistRefuges` (if the new overland zone has a outlaw refuge)
    - zoneId of the refuge

#### New House
- Update `BMU.blacklistHouses`
    - zoneId of the house (not the parent zone)

#### New instance (group dungeon, trial and arena)
- Update `BMU.blacklistGroupDungeons` or `BMU.blacklistRaids` or `BMU.blacklistSoloArenas` or `BMU.blacklistGroupArenas`
    - zoneId of the instance
- Update `BMU.nodeIndexMap`
    - zoneId of the instance as index
    - nodeIndex of the fast travel entry point (use `BMU.sc_printNodesOfCurrentZone()` to display all nodes in the parent zone)
    - additional information for display

#### Other zones
Special zones such as the group zones in Craglorn, PVP zones and solo zones are stored in:
- `BMU.blacklistBattlegrounds`
- `BMU.blacklistCyro`
- `BMU.blacklistImpCity`
- `BMU.blacklistGroupZones`
- `BMU.blacklistOthers`


### Updating partner guild IDs
Partner guilds are foreign guilds that are not managed by the BMU developers. The list of partner guilds allows especially new players to easily find a beginner-friendly guild with free fast travel options.
The IDs of the guilds per server and correspoding comments are stored in `GuildData.lua` (you can get the guild ID by copying the guild chat link out from the game).
