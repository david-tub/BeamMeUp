-- keybindings
local BMU = BMU
local BMU_SI_Get = BMU.SI.get

local teleporterVars = BMU.var

ZO_CreateStringId("SI_BINDING_NAME_BMU_TOGGLE_MAIN",                            BMU_SI_Get(SI_TELE_KEYBINDING_TOGGLE_MAIN))
ZO_CreateStringId("SI_BINDING_NAME_BMU_TOGGLE_MAIN_ACTIVE_QUESTS",              GetString(SI_JOURNAL_MENU_QUESTS))
ZO_CreateStringId("SI_BINDING_NAME_BMU_TOGGLE_MAIN_RELATED_ITEMS",              BMU_SI_Get(SI_TELE_KEYBINDING_TOGGLE_MAIN_RELATED_ITEMS))
ZO_CreateStringId("SI_BINDING_NAME_BMU_TOGGLE_MAIN_CURRENT_ZONE",               GetString(SI_ANTIQUITY_SCRYABLE_CURRENT_ZONE_SUBCATEGORY))
ZO_CreateStringId("SI_BINDING_NAME_BMU_TOGGLE_MAIN_DELVES",                     GetString(SI_ZONECOMPLETIONTYPE5))
ZO_CreateStringId("SI_BINDING_NAME_BMU_TOGGLE_MAIN_DUNGEON_FINDER",             BMU_SI_Get(SI_TELE_KEYBINDING_TOGGLE_MAIN_DUNGEON_FINDER))
ZO_CreateStringId("SI_BINDING_NAME_BMU_TOGGLE_OWN_HOUSES",                      BMU_SI_Get(SI_TELE_UI_BTN_PORT_TO_OWN_HOUSE))

ZO_CreateStringId("SI_BINDING_NAME_BMU_WAYSHRINE_UNLOCK",                       BMU_SI_Get(SI_TELE_KEYBINDING_WAYSHRINE_UNLOCK))
ZO_CreateStringId("SI_BINDING_NAME_BMU_REFRESH",                                BMU_SI_Get(SI_TELE_KEYBINDING_REFRESH))

for i=1, teleporterVars.numFavoriteZones, 1 do
    ZO_CreateStringId("SI_BINDING_NAME_BMU_FAVORITE_ZONE_" .. tostring(i),      BMU_SI_Get(SI_TELE_UI_FAVORITE_ZONE) .. " " .. tostring(i))
end

for i=1, teleporterVars.numFavoritePlayers, 1 do
    ZO_CreateStringId("SI_BINDING_NAME_BMU_FAVORITE_PLAYER_" .. tostring(i),    BMU_SI_Get(SI_TELE_UI_FAVORITE_PLAYER) .. " " .. tostring(i))
end

for i=1, teleporterVars.numFavoriteWayshrines, 1 do
    ZO_CreateStringId("SI_BINDING_NAME_BMU_FAVORITE_WAYSHRINE_" .. tostring(i), BMU_SI_Get(SI_TELE_KEYBINDING_WAYSHRINE_FAVORITE) .. " " .. tostring(i))
end

ZO_CreateStringId("SI_BINDING_NAME_BMU_GROUP_LEADER",                           GetString(SI_JUMP_TO_GROUP_LEADER_TITLE))
ZO_CreateStringId("SI_BINDING_NAME_BMU_CURRENT_ZONE",                           BMU_SI_Get(SI_TELE_KEYBINDING_CURRENT_ZONE))
ZO_CreateStringId("SI_BINDING_NAME_BMU_TRACKED_QUEST",                          BMU_SI_Get(SI_TELE_KEYBINDING_TRACKED_QUEST))
ZO_CreateStringId("SI_BINDING_NAME_BMU_ANY_ZONE",                               BMU_SI_Get(SI_TELE_KEYBINDING_ANY_ZONE))

ZO_CreateStringId("SI_BINDING_NAME_BMU_PRIMARY_RESIDENCE",                      BMU_SI_Get(SI_TELE_KEYBINDING_PRIMARY_RESIDENCE))
ZO_CreateStringId("SI_BINDING_NAME_BMU_PRIMARY_RESIDENCE_OUTSIDE",              BMU_SI_Get(SI_TELE_KEYBINDING_PRIMARY_RESIDENCE_OUTSIDE))

ZO_CreateStringId("SI_BINDING_NAME_BMU_GUILD_HOUSE",                            BMU_SI_Get(SI_TELE_KEYBINDING_GUILD_HOUSE_BMU))
