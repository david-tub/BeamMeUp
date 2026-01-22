------------------------------------------------
-- English localization
------------------------------------------------

local strings = {
	SI_BMU_GAMEPAD_CATEGORY_DELVES			= "Delves and open Dungeons",
	
	SI_BMU_GAMEPAD_PAN						= "Focus in on map pin",
	SI_BMU_GAMEPAD_PAN_TOOLTIP				= "Enabled: If a destination has a map pin, on selection the map will auto-focus in on the pin.",
	
	SI_BMU_GAMEPAD_PAN_TO_GROUP				= "Focus in on group member",
	SI_BMU_GAMEPAD_PAN_TO_GROUP_TOOLTIP		= "Enabled: on selection of a group member, the map will auto-focus in on them.",
	
	SI_BMU_GAMEPAD_MANAGE_FAVORITES			= 'Manage Favorites',
	
	SI_BMU_GAMEPAD_ZONE_CATEGORY_GRPZONES	= 'Group area',


	SI_BMU_GAMEPAD_NOTIFICATION_TYPE_WAYSHRINE_UNLOCK		= BMU.colorizeText(BMU.var.appName, "gold") .. BMU.colorizeText(" - Teleporter", "white"),
	SI_BMU_GAMEPAD_NOTIFICATION_TYPE_WAYSHRINE_COMLPETE		= BMU.colorizeText(BMU.var.appName, "gold") .. BMU.colorizeText(" - Teleporter", "white"),
	-- Used to append strings to Notifications
	SI_NOTIFICATIONS_AUTO_WAYSHRINE_UNLOCK_STATUS = '<<2>> out of <<1>> wayshrines discovered.',
	SI_NOTIFICATIONS_AUTO_WAYSHRINE_UNLOCK_NOTE2 = '',
	
}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end
