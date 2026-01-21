local BMU = BMU --INS251229 Baertram Performancee gain, not searching _G for BMU each time again!

local LAM2 = BMU.LAM
local SI = BMU.SI ---- used for localization

local teleporterVars    = BMU.var
local appName           = teleporterVars.appName
local wm                = WINDOW_MANAGER

-- -v- INS251229 Baertram BEGIN 0
--Performance reference
----variables (defined now, as they were loaded before this file -> see manifest .txt)
--ZOs variables
local string 								= string
local string_lower 							= string.lower
local string_len							= string.len
local string_format							= string.format
local table 								= table
local table_insert 							= table.insert
local table_remove 							= table.remove
local worldName 							= GetWorldName()
local zo_Menu                               = ZO_Menu     --ZO_Menu speed-up variable (so _G is not searched each time context menus are used)
local zo_WorldMapZoneStoryTopLevel_Keyboard = ZO_WorldMapZoneStoryTopLevel_Keyboard
local zo_ChatWindow                         = ZO_ChatWindow
local ClearMenu 							= ClearMenu
local ShowMenu 								= ShowMenu
--Other addon variables
---LibCustomMenu
local libCustomMenuSubmenu = LibCustomMenuSubmenu --The control holding the currently shown submenu control entries (as a submenu is opened)
local LCM_SubmenuEntryNamePrefix = "ZO_SubMenuItem" --row name of a ZO_Menu's submenu entrxy added by LibCustomMenu to the parent control LibCustomMenuSubmenu
local zo_MenuSubmenuItemsHooked = {} --Items hooked by this code, to add a special OnMouseUp handler.
local checkboxesAtSubmenuCurrentState = {} --Save the current checkboxes state (on/off) for a submenu opening control, so we can toggle all checkboxes in the submenu properly
--BMU variables
local BMU_textures                          = BMU.textures
local colorGreen 							= "green"
local colorRed 								= "red"
local fontPattern							= "%s|$(KB_%s)|%s"
local textPattern 							= "%s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d"
local subType_Alchemist 					= "alchemist"
local subType_Enchanter 					= "enchanter"
local subType_Woodworker 					= "woodworker"
local subType_Blacksmith 					= "blacksmith"
local subType_Clothier 						= "clothier"
local subType_Jewelry 						= "jewelry"
local subType_Treasure 						= "treasure"
local subType_Leads 						= "leads"
----functions
--ZOs functions
local zoPlainStrFind 						= zo_plainstrfind
local zo_IsTableEmpty 						= ZO_IsTableEmpty
local zo_CheckButton_IsChecked 				= ZO_CheckButton_IsChecked
local zo_CheckButton_SetCheckState 			= ZO_CheckButton_SetCheckState
local zo_CheckButton_IsEnabled 				= ZO_CheckButton_IsEnabled
local zo_CheckButton_SetChecked 			= ZO_CheckButton_SetChecked
local unpack 								= unpack
--BMU functions
local BMU_SI_get                            = SI.get
local BMU_colorizeText                      = BMU.colorizeText
local BMU_round                             = BMU.round
local BMU_mergeTables						= BMU.mergeTables
local BMU_tooltipTextEnter					= BMU.tooltipTextEnter

----variables (defined inline in code below, upon first usage, as they are still nil at this line)
--BMU UI variables
local BMU_chatButtonTex, teleporterWin_appTitle, teleporterWin_Main_Control, teleporterWin_zoneGuideSwapTexture, teleporterWin_feedbackTexture,
	teleporterWin_guildTexture, teleporterWin_MapOpen, teleporterWin_guildHouseTexture, teleporterWin_fixWindowTexture, teleporterWin_anchorTexture,
	teleporterWin_closeTexture, teleporterWin_SearchTexture, teleporterWin_SearchBG, teleporterWin_Searcher_Player_Placeholder,teleporterWin_Searcher_Player,
	teleporterWin_SearchBG_Player, teleporterWin_Searcher_Zone_Placeholder, teleporterWin_Searcher_Zone, teleporterWin_Main_Control_RefreshTexture,
	teleporterWin_Main_Control_portalToAllTexture, teleporterWin_Main_Control_SettingsTexture, teleporterWin_Main_Control_PTFTexture,
	teleporterWin_Main_Control_OwnHouseTexture, teleporterWin_Main_Control_QuestTexture, teleporterWin_Main_Control_ItemTexture, BMU_counterPanel,
	teleporterWin_Main_Control_OnlyYourzoneTexture, teleporterWin_Main_Control_DelvesTexture, teleporterWin_Main_Control_DungeonTexture

-------functions (defined inline in code below, upon first usage, as they are still nil at this line)
local BMU_getItemTypeIcon, BMU_getDataMapInfo, BMU_OpenTeleporter, BMU_updateContextMenuEntrySurveyAll,
      BMU_getContextMenuEntrySurveyAllAppendix, BMU_clearInputFields, BMU_createTable,
      BMU_createTableDungeons, BMU_createTableGuilds, BMU_numOfSurveyTypesChecked, 	BMU_updateCheckboxSurveyMap,
 	  BMU_createTableHouses
-- -^- INS251229 Baertram END 0

-- list of tuples (guildId & displayname) for invite queue (only for admin)
local inviteQueue = {}

function BMU.getStringIsInstalledLibrary(addonName)
	local stringInstalled = BMU_colorizeText("installed and enabled", colorGreen)
	local stringNotInstalled = BMU_colorizeText("not installed or disabled", colorRed)
	local lowerAddonName = string_lower(addonName)

	-- PortToFriendsHouse
	if lowerAddonName== "ptf" then
		local PortToFriend = PortToFriend	 --INS251229 Baertram
		if PortToFriend and PortToFriend.GetFavorites then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end

	-- LibSets
	if lowerAddonName== "libsets" then
		local BMU_LibSets = BMU.LibSets --INS251229 Baertram
		if BMU_LibSets and BMU_LibSets.GetNumItemSetCollectionZoneUnlockedPieces then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end
	
	-- LibMapPing
	if lowerAddonName== "libmapping" then
		if BMU.LibMapPing then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end

	-- LibSlashCommander
	if lowerAddonName== "lsc" then
		if BMU.LSC then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end

	-- LibChatMenuButton
	if lowerAddonName== "lcmb" then
		if BMU.LCMB then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end
	
	-- GamePadMode "IsJustaBmuGamepadPlugin"
	if lowerAddonName== "gamepad" then
		if IsJustaBmuGamepadPlugin or IJA_BMU_GAMEPAD_PLUGIN then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end
	
	-- return empty string if addonName cant bne matched
	return ""
end

-- update content and position of the counter panel
-- display the sum of each related item type without any filter consideration
function BMU.updateRelatedItemsCounterPanel()
	local counterPanel = BMU.counterPanel   --INS251229 Baertram
    local svAcc = BMU.savedVarsAcc          --INS251229 Baertram
    local scale = svAcc.Scale               --INS251229 Baertram
    BMU_getDataMapInfo = BMU_getDataMapInfo or BMU.getDataMapInfo --INS251229 Baertram calling same function in 2x nested loop below -> Significant performance improvement!
    BMU_getItemTypeIcon = BMU_getItemTypeIcon or BMU.getItemTypeIcon --INS251229 Baertram Performance reference for multiple same used function below

	local counter_table = {
		[subType_Alchemist] = 0,
		[subType_Enchanter] = 0,
		[subType_Woodworker] = 0,
		[subType_Blacksmith] = 0,
		[subType_Clothier] = 0,
		[subType_Jewelry] = 0,
		[subType_Treasure] = 0,
		[subType_Leads] = 0,
	}

	-- count treasure and survey maps
	local bags = {BAG_BACKPACK, BAG_BANK, BAG_SUBSCRIBER_BANK}
    -- go over all bags and bank
	for _, bagId in ipairs(bags) do
		local lastSlot = GetBagSize(bagId)
		for slotIndex = 0, lastSlot, 1 do
			--local itemName = GetItemName(bagId, slotIndex) --CHG251229 Baertram Not used variable, performance gain
			--local itemType, specializedItemType = GetItemType(bagId, slotIndex) --CHG251229 Baertram Not used variable, performance gain
			local itemId = GetItemId(bagId, slotIndex)
			local _, itemCount, _, _, _, _, _, _ = GetItemInfo(bagId, slotIndex)
            local subType, _ = BMU_getDataMapInfo(itemId)          --CHG251229 Baertram
				
			-- check if item is known from internal data table
			if subType and counter_table[subType] ~= nil then
				counter_table[subType] = counter_table[subType] + itemCount
			end
		end
	end

	-- count leads
	local antiquityId = GetNextAntiquityId()
	while antiquityId do
		if DoesAntiquityHaveLead(antiquityId) then
			counter_table[subType_Leads] = counter_table[subType_Leads] + 1
		end
		antiquityId = GetNextAntiquityId(antiquityId)
	end

	-- set dimension of the icons accordingly to the scale level
	local dimension = 28 * scale --CHG251229 Baertram

	-- build argument list
	local arguments_list = {
		BMU_getItemTypeIcon(subType_Alchemist, dimension), 	counter_table[subType_Alchemist],   --CHG251229 Baertram
		BMU_getItemTypeIcon(subType_Enchanter, dimension), 	counter_table[subType_Enchanter],   --CHG251229 Baertram
		BMU_getItemTypeIcon(subType_Woodworker, dimension), counter_table[subType_Woodworker],  --CHG251229 Baertram
		BMU_getItemTypeIcon(subType_Blacksmith, dimension), counter_table[subType_Blacksmith],  --CHG251229 Baertram
		BMU_getItemTypeIcon(subType_Clothier, dimension), 	counter_table[subType_Clothier],    --CHG251229 Baertram
		BMU_getItemTypeIcon(subType_Jewelry, dimension), 	counter_table[subType_Jewelry],     --CHG251229 Baertram
		BMU_getItemTypeIcon(subType_Treasure, dimension), 	counter_table[subType_Treasure],    --CHG251229 Baertram
		BMU_getItemTypeIcon(subType_Leads, dimension), 		counter_table[subType_Leads],       --CHG251229 Baertram
	}
	
	local text = string_format(textPattern, unpack(arguments_list))                 --CHG251229 Baertram
	counterPanel:SetText(text)                                                      --CHG251229 Baertram
	-- update position (number of lines may have changed)
	counterPanel:ClearAnchors()                                                     --CHG251229 Baertram
	counterPanel:SetAnchor(TOP, BMU.win.Main_Control, TOP, 1*scale, (90*scale)+((svAcc.numberLines*40)*scale))  --CHG251229 Baertram
end

--------------------------------------------------------------------------------------------------------------------
-- -v- SetupUI
--------------------------------------------------------------------------------------------------------------------
local function SetupUI()
    local BMU_svAcc = BMU.savedVarsAcc                                  							--INS251229 Baertram
    local scale = BMU_svAcc.Scale                                       							--INS251229 Baertram
    BMU_clearInputFields = BMU_clearInputFields or BMU.clearInputFields 							--INS251229 Baertram
	BMU_createTable = BMU_createTable or BMU.createTable											--INS251229 Baertram
	BMU_createTableGuilds = BMU_createTableGuilds or BMU.createTableGuilds							--INS251229 Baertram
	BMU_createTableDungeons = BMU_createTableDungeons or BMU.createTableDungeons					--INS251229 Baertram
	BMU_numOfSurveyTypesChecked = BMU_numOfSurveyTypesChecked or BMU.numOfSurveyTypesChecked   	    --INS251229 Baertram
	BMU_createTableHouses = BMU_createTableHouses or BMU.createTableHouses 	   	    				--INS251229 Baertram


	-----------------------------------------------
	-- Fonts
	
	-- default font
	local fontSize = BMU_round(17*scale, 0)   --CHG251229 Baertram
	local fontStyle = ZoFontGame:GetFontInfo()
	local fontWeight = "soft-shadow-thin"
	BMU.font1 = string_format(fontPattern, fontStyle, fontSize, fontWeight)
	
	-- font of statistics
	fontSize = BMU_round(13*scale, 0)       --CHG251229 Baertram
	fontStyle = ZoFontBookTablet:GetFontInfo()
	--fontStyle = "EsoUI/Common/Fonts/consola.ttf"
	fontWeight = "soft-shadow-thin"
	BMU.font2 = string_format(fontPattern, fontStyle, fontSize, fontWeight)
	
	-----------------------------------------------
    local teleporterWin = BMU.win

    --------------------------------------------------------------------------------------------------------------------
	-- Button on Chat Window
    --------------------------------------------------------------------------------------------------------------------
	if BMU_svAcc.chatButton then
        local BMU_textures_wayshrineBtn = BMU_textures.wayshrineBtn --INS251229 Baertram performance improvement for multiple used variable reference
        local BMU_textures_wayshrineBtnOver = BMU_textures.wayshrineBtnOver --INS251229 Baertram performance improvement for multiple used variable reference
        BMU_OpenTeleporter = BMU_OpenTeleporter or BMU.OpenTeleporter --INS251229 Baertram performance improvement for multiple used variable reference

		if BMU.LCMB then
			-- LibChatMenuButton is enabled
			-- register chat button via library
			-- NOTE: Since BMU.chatButtonTex is not defined, the option for the offset is disabled automatically (positioning is handled by the lib)
			BMU.chatButtonLCMB = BMU.LCMB.addChatButton("!!!BMUChatButton", {BMU_textures_wayshrineBtn, BMU_textures_wayshrineBtnOver}, appName, function() BMU_OpenTeleporter(true) end) --CHG251229 Baertram Performance improvement by using defined local
		else
			-- do it the old way
			-- Texture
			BMU_chatButtonTex = wm:CreateControl("Teleporter_CHAT_MENU_BUTTON", zo_ChatWindow, CT_TEXTURE) --CHG251229 Baertram Performance improvedment for multiple used variable
            BMU.chatButtonTex = BMU_chatButtonTex --INS251229 Baertram
			BMU_chatButtonTex:SetDimensions(33, 33)  --CHG251229 Baertram
			BMU_chatButtonTex:SetAnchor(TOPRIGHT, zo_ChatWindow, TOPRIGHT, -40 - BMU_svAcc.chatButtonHorizontalOffset, 6) --CHG251229 Baertram
			BMU_chatButtonTex:SetTexture(BMU_textures_wayshrineBtn) --CHG251229 Baertram
			BMU_chatButtonTex:SetMouseEnabled(true) --CHG251229 Baertram
			BMU_chatButtonTex:SetDrawLayer(2) --CHG251229 Baertram
			--Handlers
			BMU_chatButtonTex:SetHandler("OnMouseUp", function() --CHG251229 Baertram
				BMU_OpenTeleporter(true)
			end)
			
			BMU_chatButtonTex:SetHandler("OnMouseEnter", function(chatButtonTexCtrl) --CHG251229 Baertram
				chatButtonTexCtrl:SetTexture(BMU_textures_wayshrineBtnOver) --CHG251229 Baertram
				BMU_tooltipTextEnter(BMU, chatButtonTexCtrl, appName) --CHG251229 Baertram Performance improvement for multiple called same function, respecting : notation (1st passed in param must be the BMU table then)
			end)
		
			BMU_chatButtonTex:SetHandler("OnMouseExit", function(chatButtonTexCtrl) --CHG251229 Baertram
				chatButtonTexCtrl:SetTexture(BMU_textures_wayshrineBtn) --CHG251229 Baertram
				BMU_tooltipTextEnter(BMU, chatButtonTexCtrl) --CHG251229 Baertram Performance improvement for multiple called same function, respecting : notation (1st passed in param must be the BMU table then)
			end)
		end
	end
	
    --------------------------------------------------------------------------------------------------------------------
	-- Bandits Integration -> Add custom button to the side bar (with delay to ensure, that BUI is loaded)
    --------------------------------------------------------------------------------------------------------------------
	zo_callLater(function()
        local BUI = BUI --INS251229 Baertram Performance improvement for multiple called same variable
		if BUI and BUI.PanelAdd then
            BMU_OpenTeleporter = BMU_OpenTeleporter or BMU.OpenTeleporter --INS251229 Baertram performance improvement for multiple used variable reference
			local content = {
					{	
						icon = BMU_textures.wayshrineBtn,
						tooltip	= appName, --CHG251229 Baertram Performance improvement by using defined local
						func = function() BMU_OpenTeleporter(true) end,
						enabled	= true
					},
					--	{icon="",tooltip="",func=function()end,enabled=true},	-- Button 2, etc.
				}
		
			-- add custom button to side bar (Allowing of custom side bar buttons must be activated in BUI settings)
			BUI.PanelAdd(content)
		end
	end,1000)

  --------------------------------------------------------------------------------------------------------------
  --Main Controller. Please notice that teleporterWin comes from our globals variables, as does WindowManager
  --------------------------------------------------------------------------------------------------------------
  teleporterWin_Main_Control = wm:CreateTopLevelWindow("Teleporter_Location_MainController") --INS251229 Baertram performance improvement for multiple used variable reference
  teleporterWin.Main_Control = teleporterWin_Main_Control --INS251229 Baertram

  teleporterWin_Main_Control:SetMouseEnabled(true) --CHG251229 Baertram
  teleporterWin_Main_Control:SetDimensions(500*scale,400*scale) --CHG251229 Baertram
  teleporterWin_Main_Control:SetHidden(true) --CHG251229 Baertram

  teleporterWin_appTitle = wm:CreateControl("Teleporter_appTitle", teleporterWin_Main_Control, CT_LABEL) --CHG251229 Baertram
  teleporterWin.appTitle = teleporterWin_appTitle
  teleporterWin_appTitle:SetFont(BMU.font1) --CHG251229 Baertram
  teleporterWin_appTitle:SetColor(255, 255, 255, 1) --CHG251229 Baertram
  teleporterWin_appTitle:SetText(BMU_colorizeText(appName, "gold") .. BMU_colorizeText(" - Teleporter", "white")) --CHG251229 Baertram
  --teleporterWin_appTitle:SetAnchor(TOP, teleporterWin_Main_Control, TOP, -31*BMU_svAcc.Scale, -62*BMU_svAcc.Scale) --CHG251229 Baertram
  teleporterWin_appTitle:SetAnchor(CENTER, teleporterWin_Main_Control, TOP, nil, -62*scale) --CHG251229 Baertram

  ----- This is where we create the list element for TeleUnicorn/ List
  BMU.TeleporterList = BMU.ListView.new(teleporterWin_Main_Control,  {
    width = 750*scale, --CHG251229 Baertram
    height = 500*scale, --CHG251229 Baertram
  })

  ---------


  --------------------------------------------------------------------------------------------------------------------
  -- Switch BUTTON ON ZoneGuide window
  --------------------------------------------------------------------------------------------------------------------
  teleporterWin_zoneGuideSwapTexture = wm:CreateControl(nil, zo_WorldMapZoneStoryTopLevel_Keyboard, CT_TEXTURE) --CHG251229 Baertram Performance improvement
  teleporterWin.zoneGuideSwapTexture = teleporterWin_zoneGuideSwapTexture --CHG251229 Baertram Performance improvement
  teleporterWin_zoneGuideSwapTexture:SetDimensions(50*scale, 50*scale) --CHG251229 Baertram Performance improvement
  teleporterWin_zoneGuideSwapTexture:SetAnchor(TOPRIGHT, zo_WorldMapZoneStoryTopLevel_Keyboard, TOPRIGHT, TOPRIGHT -10*scale, -35*scale) --CHG251229 Baertram Performance improvement
  teleporterWin_zoneGuideSwapTexture:SetTexture(BMU_textures.swapBtn) --CHG251229 Baertram Performance improvement
  teleporterWin_zoneGuideSwapTexture:SetMouseEnabled(true) --CHG251229 Baertram Performance improvement

  teleporterWin_zoneGuideSwapTexture:SetHandler("OnMouseUp", function()
      BMU_OpenTeleporter = BMU_OpenTeleporter or BMU.OpenTeleporter --INS251229 Baertram performance improvement for multiple used variable reference
	  BMU_OpenTeleporter(true) ----CHG251229 Baertram Performance improvement by using local
	end)

  teleporterWin_zoneGuideSwapTexture:SetHandler("OnMouseEnter", function(teleporterWinZoneGuideSwapTextureCtrl) --CHG251229 Baertram Performance improvement
      teleporterWinZoneGuideSwapTextureCtrl:SetTexture(BMU_textures.swapBtnOver) --CHG251229 Baertram Performance improvement
      BMU_tooltipTextEnter(BMU, teleporterWinZoneGuideSwapTextureCtrl,
          BMU_SI_get(SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE)) --CHG251229 Baertram Performance improvement
  end)

  teleporterWin_zoneGuideSwapTexture:SetHandler("OnMouseExit", function(teleporterWinZoneGuideSwapTextureCtrl) --CHG251229 Baertram Performance improvement
      teleporterWinZoneGuideSwapTextureCtrl:SetTexture(BMU_textures.swapBtn) --CHG251229 Baertram Performance improvement
      BMU_tooltipTextEnter(BMU, teleporterWinZoneGuideSwapTextureCtrl) --CHG251229 Baertram Performance improvement
  end)

  --------------------------------------------------------------------------------------------------------------------
  -- Feedback BUTTON
  --------------------------------------------------------------------------------------------------------------------
  teleporterWin_feedbackTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)  --INS251229 Baertram
  teleporterWin.feedbackTexture = teleporterWin_feedbackTexture --INS251229 Baertram
  teleporterWin_feedbackTexture:SetDimensions(50*scale, 50*scale) --CHG251229 Baertram
  teleporterWin_feedbackTexture:SetAnchor(TOPLEFT, teleporterWin_Main_Control, TOPLEFT, TOPLEFT-35*scale, -75*scale) --CHG251229 Baertram
  teleporterWin_feedbackTexture:SetTexture(BMU_textures.feedbackBtn) --CHG251229 Baertram
  teleporterWin_feedbackTexture:SetMouseEnabled(true) --CHG251229 Baertram

  teleporterWin_feedbackTexture:SetHandler("OnMouseUp", function() --CHG251229 Baertram
      BMU.createMail(teleporterVars.feedbackContact, "Feedback - BeamMeUp", "") --CHG251229 Baertram
	end)

  teleporterWin_feedbackTexture:SetHandler("OnMouseEnter", function(teleporterWin_feedbackTextureCtrl) --CHG251229 Baertram
      teleporterWin_feedbackTextureCtrl:SetTexture(BMU_textures.feedbackBtnOver) --CHG251229 Baertram
      BMU_tooltipTextEnter(BMU, teleporterWin_feedbackTextureCtrl, --CHG251229 Baertram
          GetString(SI_CUSTOMER_SERVICE_SUBMIT_FEEDBACK))
  end)

  teleporterWin_feedbackTexture:SetHandler("OnMouseExit", function(teleporterWin_feedbackTextureCtrl) --CHG251229 Baertram
      teleporterWin_feedbackTextureCtrl:SetTexture(BMU_textures.feedbackBtn) --CHG251229 Baertram
      BMU_tooltipTextEnter(BMU, teleporterWin_feedbackTextureCtrl) --CHG251229 Baertram
  end)

  --------------------------------------------------------------------------------------------------------------------
  -- Guild BUTTON
  -- display button only if guilds are available on players game server
  --------------------------------------------------------------------------------------------------------------------
	if teleporterVars.BMUGuilds[worldName] ~= nil then --CHG251229 Baertram
		teleporterWin_guildTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
        teleporterWin.guildTexture = teleporterWin_guildTexture
		teleporterWin_guildTexture:SetDimensions(40*scale, 40*scale)
		teleporterWin_guildTexture:SetAnchor(TOPLEFT, teleporterWin_Main_Control, TOPLEFT, TOPLEFT+10*scale, -75*scale)
		teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtn)
		teleporterWin_guildTexture:SetMouseEnabled(true)

		teleporterWin_guildTexture:SetHandler("OnMouseUp", function(self, button)
			if not BMU.isCurrentlyRequestingGuildData then
				BMU.requestGuildData()
			end
            BMU_clearInputFields()
			zo_callLater(function() BMU_createTableGuilds() end, 350)
		end)

		teleporterWin_guildTexture:SetHandler("OnMouseEnter", function(self)
		  teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtnOver)
		  BMU_tooltipTextEnter(BMU, teleporterWin_guildTexture,
			BMU_SI_get(SI.TELE_UI_BTN_GUILD_BMU))
		end)

		teleporterWin_guildTexture:SetHandler("OnMouseExit", function(self)
		  BMU_tooltipTextEnter(BMU, teleporterWin_guildTexture)
		  if BMU.state ~= BMU.indexListGuilds then
			teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtn)
		  end
		end)
	end


  --------------------------------------------------------------------------------------------------------------------
  -- Guild House BUTTON
  -- display button only if guild house is available on players game server
  --------------------------------------------------------------------------------------------------------------------
  if teleporterVars.guildHouse[worldName] ~= nil then
	  teleporterWin_guildHouseTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
	  teleporterWin.guildHouseTexture = teleporterWin_guildHouseTexture
	  teleporterWin_guildHouseTexture:SetDimensions(40*scale, 40*scale)
	  teleporterWin_guildHouseTexture:SetAnchor(TOPLEFT, teleporterWin_Main_Control, TOPLEFT, TOPLEFT+55*scale, -75*scale)
	  teleporterWin_guildHouseTexture:SetTexture(BMU_textures.guildHouseBtn)
	  teleporterWin_guildHouseTexture:SetMouseEnabled(true)

	  teleporterWin_guildHouseTexture:SetHandler("OnMouseUp", function()
		  BMU.portToBMUGuildHouse()
		end)

	  teleporterWin_guildHouseTexture:SetHandler("OnMouseEnter", function(teleporterWin_guildHouseTextureCtrl)
		  teleporterWin_guildHouseTextureCtrl:SetTexture(BMU_textures.guildHouseBtnOver)
		  BMU_tooltipTextEnter(BMU, teleporterWin_guildHouseTextureCtrl,
			  BMU_SI_get(SI.TELE_UI_BTN_GUILD_HOUSE_BMU))
	  end)

	  teleporterWin_guildHouseTexture:SetHandler("OnMouseExit", function(teleporterWin_guildHouseTextureCtrl)
		  teleporterWin_guildHouseTextureCtrl:SetTexture(BMU_textures.guildHouseBtn)
		  BMU_tooltipTextEnter(BMU, teleporterWin_guildHouseTextureCtrl)
	  end)
  end


    --------------------------------------------------------------------------------------------------------------------
	-- Lock/Fix window BUTTON
    --------------------------------------------------------------------------------------------------------------------
	local lockTexture
	teleporterWin_fixWindowTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
	teleporterWin.fixWindowTexture = teleporterWin_fixWindowTexture
	teleporterWin_fixWindowTexture:SetDimensions(50*scale, 50*scale)
	teleporterWin_fixWindowTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, TOPRIGHT-65*scale, -75*scale)
	-- decide which texture to show
	if BMU_svAcc.fixedWindow == true then
		lockTexture = BMU_textures.lockClosedBtn
	else
		lockTexture = BMU_textures.lockOpenBtn
	end
	teleporterWin_fixWindowTexture:SetTexture(lockTexture)
	teleporterWin_fixWindowTexture:SetMouseEnabled(true)

	teleporterWin_fixWindowTexture:SetHandler("OnMouseUp", function(teleporterWin_fixWindowTextureCtrl)
		-- change setting
		BMU_svAcc.fixedWindow = not BMU_svAcc.fixedWindow
		-- fix/unfix window
		BMU.control_global.bd:SetMovable(not BMU_svAcc.fixedWindow)
		-- change texture
		if BMU_svAcc.fixedWindow then
			-- show closed lock over
			lockTexture = BMU_textures.lockClosedBtnOver
		else
			-- show open lock over
			lockTexture = BMU_textures.lockOpenBtnOver
		end
		teleporterWin_fixWindowTextureCtrl:SetTexture(lockTexture)
	end)

	teleporterWin_fixWindowTexture:SetHandler("OnMouseEnter", function(teleporterWin_fixWindowTextureCtrl)
		if BMU_svAcc.fixedWindow then
			-- show closed lock over
			lockTexture = BMU_textures.lockClosedBtnOver
		else
			-- show open lock over
			lockTexture = BMU_textures.lockOpenBtnOver
		end
		teleporterWin_fixWindowTextureCtrl:SetTexture(lockTexture)
		BMU_tooltipTextEnter(BMU, teleporterWin_fixWindowTextureCtrl,BMU_SI_get(SI.TELE_UI_BTN_FIX_WINDOW))
	end)

	teleporterWin_fixWindowTexture:SetHandler("OnMouseExit", function(teleporterWin_fixWindowTextureCtrl)
		if BMU_svAcc.fixedWindow then
			-- show closed lock
			lockTexture = BMU_textures.lockClosedBtn
		else
			-- show open lock
			lockTexture = BMU_textures.lockOpenBtn
		end
		teleporterWin_fixWindowTextureCtrl:SetTexture(lockTexture)
		BMU_tooltipTextEnter(BMU, teleporterWin_fixWindowTextureCtrl)
	end)


  --------------------------------------------------------------------------------------------------------------------
  -- ANCHOR BUTTON
  --------------------------------------------------------------------------------------------------------------------
  teleporterWin_anchorTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin.anchorTexture = teleporterWin_anchorTexture
  teleporterWin_anchorTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_anchorTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, TOPRIGHT-20*scale, -75*scale)
  teleporterWin_anchorTexture:SetTexture(BMU_textures.anchorMapBtn)
  teleporterWin_anchorTexture:SetMouseEnabled(true)

  teleporterWin_anchorTexture:SetHandler("OnMouseUp", function()
	BMU_svAcc.anchorOnMap = not BMU_svAcc.anchorOnMap
    BMU.updatePosition()
  end)

  teleporterWin_anchorTexture:SetHandler("OnMouseEnter", function(teleporterWin_anchorTextureCtrl)
	teleporterWin_anchorTextureCtrl:SetTexture(BMU_textures.anchorMapBtnOver)
      BMU_tooltipTextEnter(BMU, teleporterWin_anchorTextureCtrl,
          BMU_SI_get(SI.TELE_UI_BTN_ANCHOR_ON_MAP))
  end)

  teleporterWin_anchorTexture:SetHandler("OnMouseExit", function(teleporterWin_anchorTextureCtrl)
	if not BMU_svAcc.anchorOnMap then
		teleporterWin_anchorTextureCtrl:SetTexture(BMU_textures.anchorMapBtn)
	end
      BMU_tooltipTextEnter(BMU, teleporterWin_anchorTextureCtrl)
  end)


  --------------------------------------------------------------------------------------------------------------------
  -- CLOSE / SWAP BUTTON
  --------------------------------------------------------------------------------------------------------------------
  teleporterWin_closeTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin.closeTexture = teleporterWin_closeTexture
  teleporterWin_closeTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_closeTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, TOPRIGHT+25*scale, -75*scale)
  teleporterWin_closeTexture:SetTexture(BMU_textures.closeBtn)
  teleporterWin_closeTexture:SetMouseEnabled(true)
  teleporterWin_closeTexture:SetDrawLayer(2)

  teleporterWin_closeTexture:SetHandler("OnMouseUp", function()
      BMU.HideTeleporter()  end)

  teleporterWin_closeTexture:SetHandler("OnMouseEnter", function(teleporterWin_closeTextureCtrl)
	teleporterWin_closeTextureCtrl:SetTexture(BMU_textures.closeBtnOver)
      BMU_tooltipTextEnter(BMU, teleporterWin_closeTextureCtrl,
          GetString(SI_DIALOG_CLOSE))
  end)

  teleporterWin_closeTexture:SetHandler("OnMouseExit", function(teleporterWin_closeTextureCtrl)
      BMU_tooltipTextEnter(BMU, teleporterWin_closeTextureCtrl)
  end)


  --------------------------------------------------------------------------------------------------------------------
  -- OPEN BUTTON ON MAP (upper left corner)
  --------------------------------------------------------------------------------------------------------------------
	if BMU_svAcc.showOpenButtonOnMap then
		teleporterWin_MapOpen = CreateControlFromVirtual("TeleporterReopenButon", ZO_WorldMap, "ZO_DefaultButton")
		teleporterWin.MapOpen = teleporterWin_MapOpen
		teleporterWin_MapOpen:SetAnchor(TOPLEFT)
		teleporterWin_MapOpen:SetWidth(200)
		teleporterWin_MapOpen:SetText(appName)
		teleporterWin_MapOpen:SetHidden(true)

		teleporterWin_MapOpen:SetHandler("OnClicked",function()
			BMU.OpenTeleporter(true)
		end)
	end

  --------------------------------------------------------------------------------------------------------------------
  -- Search Symbol (no button)
  --------------------------------------------------------------------------------------------------------------------
  teleporterWin_SearchTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin.SearchTexture = teleporterWin_SearchTexture
  teleporterWin_SearchTexture:SetDimensions(25*scale, 25*scale)
  teleporterWin_SearchTexture:SetAnchor(TOPLEFT, teleporterWin_Main_Control, TOPLEFT, TOPLEFT-35*scale, -10*scale)

  teleporterWin_SearchTexture:SetTexture(BMU_textures.searchBtn)

  ---------------------------------------------------------------------------------------------------------------
  -- Searcher (Search for Players)
   teleporterWin_Searcher_Player = CreateControlFromVirtual("Teleporter_SEARCH_EDITBOX",  teleporterWin_Main_Control, "ZO_DefaultEditForBackdrop")
   teleporterWin.Searcher_Player = teleporterWin_Searcher_Player
   teleporterWin_Searcher_Player:SetParent(teleporterWin_Main_Control)
   teleporterWin_Searcher_Player:SetSimpleAnchorParent(10*scale,-10*scale)
   teleporterWin_Searcher_Player:SetDimensions(105*scale,25*scale)
   teleporterWin_Searcher_Player:SetResizeToFitDescendents(false)
   teleporterWin_Searcher_Player:SetFont(BMU.font1)

	-- Placeholder
	teleporterWin_Searcher_Player_Placeholder = wm:CreateControl("Teleporter_SEARCH_EDITBOX_Placeholder", teleporterWin_Searcher_Player, CT_LABEL)
  	teleporterWin_Searcher_Player.Placeholder = teleporterWin_Searcher_Player_Placeholder
    teleporterWin_Searcher_Player_Placeholder:SetSimpleAnchorParent(4*scale,0)
	teleporterWin_Searcher_Player_Placeholder:SetFont(BMU.font1)
	teleporterWin_Searcher_Player_Placeholder:SetText(BMU_colorizeText(GetString(SI_PLAYER_MENU_PLAYER), "lgray"))

  -- BackGround
  teleporterWin_SearchBG = wm:CreateControlFromVirtual("Teleporter_SearchBG",  teleporterWin_Searcher_Player, "ZO_DefaultBackdrop")
  teleporterWin.SearchBG = teleporterWin_SearchBG
  teleporterWin_SearchBG:ClearAnchors()
  teleporterWin_SearchBG:SetAnchorFill(teleporterWin_Searcher_Player)
  teleporterWin_SearchBG:SetDimensions(teleporterWin_Searcher_Player:GetWidth(),  teleporterWin_Searcher_Player:GetHeight())
  teleporterWin_SearchBG.controlType = CT_CONTROL
  teleporterWin_SearchBG.system = SETTING_TYPE_UI
  teleporterWin_SearchBG:SetHidden(false)
  teleporterWin_SearchBG:SetMouseEnabled(false)
  teleporterWin_SearchBG:SetMovable(false)
  teleporterWin_SearchBG:SetClampedToScreen(true)

  -- Handlers
  ZO_PreHookHandler(teleporterWin_Searcher_Player, "OnTextChanged", function(teleporterWin_Searcher_PlayerCtrl)
	  if teleporterWin_Searcher_PlayerCtrl:HasFocus() then
		  local searchPlayerText = teleporterWin_Searcher_PlayerCtrl:GetText()
		  if (searchPlayerText ~= "" or BMU.state == BMU.indexListSearchPlayer) then
			  -- make sure player placeholder is hidden
			  teleporterWin_Searcher_Player_Placeholder:SetHidden(true)
			  -- clear zone input field
			  teleporterWin_Searcher_Zone:SetText("")
			  -- show zone placeholder
			  teleporterWin_Searcher_Zone.Placeholder:SetHidden(false)
			  BMU_createTable({index=BMU.indexListSearchPlayer, inputString=searchPlayerText})
		  end
	end
  end)

  teleporterWin_Searcher_Player:SetHandler("OnFocusGained", function(self)
	teleporterWin_Searcher_Player_Placeholder:SetHidden(true)
  end)

  teleporterWin_Searcher_Player:SetHandler("OnFocusLost", function(teleporterWin_Searcher_PlayerCtrl)
	if teleporterWin_Searcher_PlayerCtrl:GetText() == "" then
		teleporterWin_Searcher_Player_Placeholder:SetHidden(false)
	end
  end)

  --------------------------------------------------------------------------------------------------------------------
  -- Searcher (Search for zones)
  --------------------------------------------------------------------------------------------------------------------
  teleporterWin_Searcher_Zone = CreateControlFromVirtual("Teleporter_Searcher_Player_EDITBOX1",  teleporterWin_Main_Control, "ZO_DefaultEditForBackdrop")
  teleporterWin.Searcher_Zone = teleporterWin_Searcher_Zone
  teleporterWin_Searcher_Zone:SetParent(teleporterWin_Main_Control)
  teleporterWin_Searcher_Zone:SetSimpleAnchorParent(140*scale,-10*scale)
  teleporterWin_Searcher_Zone:SetDimensions(105*scale,25*scale)
  teleporterWin_Searcher_Zone:SetResizeToFitDescendents(false)
  teleporterWin_Searcher_Zone:SetFont(BMU.font1)

  -- Placeholder
  teleporterWin_Searcher_Zone_Placeholder = wm:CreateControl("Teleporter_Searcher_Player_EDITBOX1_Placeholder", teleporterWin_Searcher_Zone, CT_LABEL)
  teleporterWin_Searcher_Zone.Placeholder = teleporterWin_Searcher_Zone_Placeholder
  teleporterWin_Searcher_Zone_Placeholder:SetSimpleAnchorParent(4*scale,0*scale)
  teleporterWin_Searcher_Zone_Placeholder:SetFont(BMU.font1)
  teleporterWin_Searcher_Zone_Placeholder:SetText(BMU_colorizeText(GetString(SI_CHAT_CHANNEL_NAME_ZONE), "lgray"))

  -- BG
  teleporterWin_SearchBG_Player = wm:CreateControlFromVirtual("Teleporter_SearchBG_Zone", teleporterWin_Searcher_Zone, "ZO_DefaultBackdrop")
  teleporterWin.SearchBG_Player = teleporterWin_SearchBG_Player
  teleporterWin_SearchBG_Player:ClearAnchors()
  teleporterWin_SearchBG_Player:SetAnchorFill(teleporterWin_Searcher_Zone)
  teleporterWin_SearchBG_Player:SetDimensions(teleporterWin_Searcher_Zone:GetWidth(), teleporterWin_Searcher_Zone:GetHeight())
  teleporterWin_SearchBG_Player.controlType = CT_CONTROL
  teleporterWin_SearchBG_Player.system = SETTING_TYPE_UI
  teleporterWin_SearchBG_Player:SetHidden(false)
  teleporterWin_SearchBG_Player:SetMouseEnabled(false)
  teleporterWin_SearchBG_Player:SetMovable(false)
  teleporterWin_SearchBG_Player:SetClampedToScreen(true)

  -- Handlers
	--Editbox for search (zone search, dungeon search, survey search, lead search, house search, etc.)
	-->Entries in this table below will update the list if the search editBox is having an empty "" text
	local searchEditBoxStatesThatShouldUpdateListIfEditboxEmptry = {
		[BMU.indexListSearchZone] = true,
		[BMU.indexListDungeons] = true,
	}
    ZO_PreHookHandler(teleporterWin_Searcher_Zone, "OnTextChanged", function(teleporterWin_Searcher_ZoneCtrl)
		if teleporterWin_Searcher_ZoneCtrl:HasFocus() then
			local BMU_state = BMU.state
			local searchZoneText = teleporterWin_Searcher_ZoneCtrl:GetText()
			if (searchZoneText ~= "" or searchEditBoxStatesThatShouldUpdateListIfEditboxEmptry[BMU_state]) then
				-- make sure zone placeholder is hidden
				teleporterWin_Searcher_Zone_Placeholder:SetHidden(true)
				-- clear player input field
				teleporterWin_Searcher_Player:SetText("")
				-- show player placeholder
				teleporterWin_Searcher_Player_Placeholder:SetHidden(false)
				if BMU_state == BMU.indexListDungeons then
					BMU_createTableDungeons({inputString=searchZoneText})
				else
					BMU_createTable({index=BMU.indexListSearchZone, inputString=searchZoneText})
				end
			end
		end
	end)

	teleporterWin_Searcher_Zone:SetHandler("OnFocusGained", function(teleporterWin_Searcher_ZoneCtrl)
		teleporterWin_Searcher_Zone_Placeholder:SetHidden(true)
	end)

	teleporterWin_Searcher_Zone:SetHandler("OnFocusLost", function(teleporterWin_Searcher_ZoneCtrl)
		if teleporterWin_Searcher_ZoneCtrl:GetText() == "" then
			teleporterWin_Searcher_Zone_Placeholder:SetHidden(false)
		end
	end)


  --------------------------------------------------------------------------------------------------------------------
  -- Refresh Button
  --------------------------------------------------------------------------------------------------------------------
  teleporterWin_Main_Control_RefreshTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.RefreshTexture = teleporterWin_Main_Control_RefreshTexture
  teleporterWin_Main_Control_RefreshTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_RefreshTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -80*scale, -5*scale)
  teleporterWin_Main_Control_RefreshTexture:SetTexture(BMU_textures.refreshBtn)
  teleporterWin_Main_Control_RefreshTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_RefreshTexture:SetDrawLayer(2)

  teleporterWin_Main_Control_RefreshTexture:SetHandler("OnMouseUp", function(self)
		if BMU.state == BMU.indexListMain then
			-- dont reset slider if user stays already on main list
			BMU_createTable({index=BMU.indexListMain, dontResetSlider=true})
		else
			BMU_createTable({index=BMU.indexListMain})
		end
  end)

  teleporterWin_Main_Control_RefreshTexture:SetHandler("OnMouseEnter", function(teleporterWin_Main_Control_RefreshTextureCtrl)
      BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_RefreshTextureCtrl,
          BMU_SI_get(SI.TELE_UI_BTN_REFRESH_ALL))
      teleporterWin_Main_Control_RefreshTextureCtrl:SetTexture(BMU_textures.refreshBtnOver)end)

  teleporterWin_Main_Control_RefreshTexture:SetHandler("OnMouseExit", function(teleporterWin_Main_Control_RefreshTextureCtrl)
      BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_RefreshTextureCtrl)
      teleporterWin_Main_Control_RefreshTextureCtrl:SetTexture(BMU_textures.refreshBtn)end)


  --------------------------------------------------------------------------------------------------------------------
  -- Unlock wayshrines
  --------------------------------------------------------------------------------------------------------------------
  teleporterWin_Main_Control_portalToAllTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.portalToAllTexture = teleporterWin_Main_Control_portalToAllTexture
  teleporterWin_Main_Control_portalToAllTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_portalToAllTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -40*scale, -5*scale)
  teleporterWin_Main_Control_portalToAllTexture:SetTexture(BMU_textures.wayshrineBtn2)
  teleporterWin_Main_Control_portalToAllTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_portalToAllTexture:SetDrawLayer(2)

	teleporterWin_Main_Control_portalToAllTexture:SetHandler("OnMouseUp", function(self, button)
		BMU.showDialogAutoUnlock()
	end)

  teleporterWin_Main_Control_portalToAllTexture:SetHandler("OnMouseEnter", function(teleporterWin_Main_Control_portalToAllTextureCtrl)
	teleporterWin_Main_Control_portalToAllTextureCtrl:SetTexture(BMU_textures.wayshrineBtnOver2)
		local tooltipTextCompletion = ""
		if BMU.isZoneOverlandZone() then
			-- add wayshrine discovery info from ZoneGuide
			-- Attention: if the user is in Artaeum, he will see the total number of wayshrines (inclusive Summerset)
			-- however, when starting the auto unlock the function getZoneWayshrineCompletion() will check which wayshrines are really located on this map
			local zoneWayhsrineDiscoveryInfo, zoneWayshrineDiscovered, zoneWayshrineTotal = BMU.getZoneGuideDiscoveryInfo(GetZoneId(GetUnitZoneIndex("player")), ZONE_COMPLETION_TYPE_WAYSHRINES)
			if zoneWayhsrineDiscoveryInfo ~= nil then
				tooltipTextCompletion = "(" .. zoneWayshrineDiscovered .. "/" .. zoneWayshrineTotal .. ")"
				if zoneWayshrineDiscovered >= zoneWayshrineTotal then
					tooltipTextCompletion = BMU_colorizeText(tooltipTextCompletion, colorGreen)
				end
			end
		end
		-- display number of unlocked wayshrines in current zone
		BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_portalToAllTextureCtrl, BMU_SI_get(SI.TELE_UI_BTN_UNLOCK_WS) .. " " .. tooltipTextCompletion)
	end)

  teleporterWin_Main_Control_portalToAllTexture:SetHandler("OnMouseExit", function(teleporterWin_Main_Control_portalToAllTextureCtrl)
	teleporterWin_Main_Control_portalToAllTextureCtrl:SetTexture(BMU_textures.wayshrineBtn2)
	BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_portalToAllTextureCtrl)
  end)


  --------------------------------------------------------------------------------------------------------------------
  -- Settings
  --------------------------------------------------------------------------------------------------------------------
  teleporterWin_Main_Control_SettingsTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.SettingsTexture = teleporterWin_Main_Control_SettingsTexture
  teleporterWin_Main_Control_SettingsTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_SettingsTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, 0, -5*scale)
  teleporterWin_Main_Control_SettingsTexture:SetTexture(BMU_textures.settingsBtn)
  teleporterWin_Main_Control_SettingsTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_SettingsTexture:SetDrawLayer(2)

  teleporterWin_Main_Control_SettingsTexture:SetHandler("OnMouseUp", function(self)
	BMU.HideTeleporter()
	LAM2:OpenToPanel(BMU.SettingsPanel)
  end)

  teleporterWin_Main_Control_SettingsTexture:SetHandler("OnMouseEnter", function(teleporterWin_Main_Control_SettingsTextureCtrl)
      BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_SettingsTextureCtrl,
          GetString(SI_GAME_MENU_SETTINGS))
      teleporterWin_Main_Control_SettingsTextureCtrl:SetTexture(BMU_textures.settingsBtnOver)
  end)

  teleporterWin_Main_Control_SettingsTexture:SetHandler("OnMouseExit", function(teleporterWin_Main_Control_SettingsTextureCtrl)
      BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_SettingsTextureCtrl)
      teleporterWin_Main_Control_SettingsTextureCtrl:SetTexture(BMU_textures.settingsBtn)
  end)


  --------------------------------------------------------------------------------------------------------------------
  -- "Port to Friends House" Integration
  --------------------------------------------------------------------------------------------------------------------
  teleporterWin_Main_Control_PTFTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control_PTFTexture = teleporterWin_Main_Control_PTFTexture
  teleporterWin_Main_Control_PTFTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_PTFTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -250*scale, 40*scale)
  teleporterWin_Main_Control_PTFTexture:SetTexture(BMU_textures.ptfHouseBtn)
  teleporterWin_Main_Control_PTFTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_PTFTexture:SetDrawLayer(2)
    local PortToFriend = PortToFriend --INS251229 Baertram performance improvement for 2 same used global variables
	if PortToFriend and PortToFriend.GetFavorites then
		-- enable tab
		teleporterWin_Main_Control_PTFTexture:SetHandler("OnMouseUp", function(self, button, upInside) --CHG251229 Baertram Usage of upInside to properly check the user releaased the mouse on the control!!!
			ClearMenu()
			if upInside and button == MOUSE_BUTTON_INDEX_RIGHT then --CHG251229 Baertram Usage of upInside to properly check the user releaased the mouse on the control!!!
				-- toggle between zone names and house names
                local BMU_savedVarsChar = BMU.savedVarsChar --INS251229 Baertram Performance gain for multiple used samed variable
                local menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_UI_TOOGLE_ZONE_NAME), function() BMU_savedVarsChar.ptfHouseZoneNames = not BMU_savedVarsChar.ptfHouseZoneNames BMU_clearInputFields() BMU.createTablePTF() end, MENU_ADD_OPTION_CHECKBOX)
				if BMU_savedVarsChar.ptfHouseZoneNames then
					zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
				end
				ShowMenu()
			else
                BMU_clearInputFields()
				BMU.createTablePTF()
			end
		end)

		teleporterWin_Main_Control_PTFTexture:SetHandler("OnMouseEnter", function(teleporterWin_Main_Control_PTFTextureCtrl)
			BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_PTFTextureCtrl,
				BMU_SI_get(SI.TELE_UI_BTN_PTF_INTEGRATION) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
			teleporterWin_Main_Control_PTFTextureCtrl:SetTexture(BMU_textures.ptfHouseBtnOver)
		end)

		teleporterWin_Main_Control_PTFTexture:SetHandler("OnMouseExit", function(teleporterWin_Main_Control_PTFTextureCtrl)
			BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_PTFTextureCtrl)
			if BMU.state ~= BMU.indexListPTFHouses then
				teleporterWin_Main_Control_PTFTextureCtrl:SetTexture(BMU_textures.ptfHouseBtn)
			end
		end)
	else
		-- disable tab
		teleporterWin_Main_Control_PTFTexture:SetAlpha(0.4)

		teleporterWin_Main_Control_PTFTexture:SetHandler("OnMouseUp", function()
			BMU.showDialogSimple("PTFIntegrationMissing", BMU_SI_get(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE), BMU_SI_get(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY), function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info1758-PorttoFriendsHouse.html") end, nil)
		end)

		teleporterWin_Main_Control_PTFTexture:SetHandler("OnMouseEnter", function(teleporterWin_Main_Control_PTFTextureCtrl)
			BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_PTFTextureCtrl, BMU_SI_get(SI.TELE_UI_BTN_PTF_INTEGRATION))
		end)

		teleporterWin_Main_Control_PTFTexture:SetHandler("OnMouseExit", function(teleporterWin_Main_Control_PTFTextureCtrl)
			BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_PTFTextureCtrl)
		end)
	end

  --------------------------------------------------------------------------------------------------------------------
  -- Own Houses
  --------------------------------------------------------------------------------------------------------------------
  teleporterWin_Main_Control_OwnHouseTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.OwnHouseTexture = teleporterWin_Main_Control_OwnHouseTexture
  teleporterWin_Main_Control_OwnHouseTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_OwnHouseTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -205*scale, 40*scale)
  teleporterWin_Main_Control_OwnHouseTexture:SetTexture(BMU_textures.houseBtn)
  teleporterWin_Main_Control_OwnHouseTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_OwnHouseTexture:SetDrawLayer(2)

  teleporterWin_Main_Control_OwnHouseTexture:SetHandler("OnMouseUp", function(self, button)
	ClearMenu()
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		local BMU_savedVarsChar = BMU.savedVarsChar  --INS251229 Baertram
		-- toggle between nicknames and standard names
		local menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_UI_TOGGLE_HOUSE_NICKNAME), function() BMU_savedVarsChar.houseNickNames = not BMU_savedVarsChar.houseNickNames BMU_clearInputFields() BMU_createTableHouses() end, MENU_ADD_OPTION_CHECKBOX)
		if BMU_savedVarsChar.houseNickNames then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)

		-- make default tab
		menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU_savedVarsChar.defaultTab == BMU.indexListOwnHouses then BMU_savedVarsChar.defaultTab = BMU.indexListMain else BMU_savedVarsChar.defaultTab = BMU.indexListOwnHouses end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU_savedVarsChar.defaultTab == BMU.indexListOwnHouses then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		ShowMenu()
	else
        BMU_clearInputFields( )
		BMU_createTableHouses()
	end
  end)

  teleporterWin_Main_Control_OwnHouseTexture:SetHandler("OnMouseEnter", function(teleporterWin_Main_Control_OwnHouseTextureCtrl)
    BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_OwnHouseTextureCtrl,
		BMU_SI_get(SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin_Main_Control_OwnHouseTextureCtrl:SetTexture(BMU_textures.houseBtnOver)
  end)

  teleporterWin_Main_Control_OwnHouseTexture:SetHandler("OnMouseExit", function(teleporterWin_Main_Control_OwnHouseTextureCtrl)
    BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_OwnHouseTextureCtrl)
	if BMU.state ~= BMU.indexListOwnHouses then
		teleporterWin_Main_Control_OwnHouseTextureCtrl:SetTexture(BMU_textures.houseBtn)
	end
  end)


  --------------------------------------------------------------------------------------------------------------------
  -- Related Quests
  --------------------------------------------------------------------------------------------------------------------
  teleporterWin_Main_Control_QuestTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.QuestTexture = teleporterWin_Main_Control_QuestTexture
  teleporterWin_Main_Control_QuestTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_QuestTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -160*scale, 40*scale)
  teleporterWin_Main_Control_QuestTexture:SetTexture(BMU_textures.questBtn)
  teleporterWin_Main_Control_QuestTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_QuestTexture:SetDrawLayer(2)

  teleporterWin_Main_Control_QuestTexture:SetHandler("OnMouseUp", function(self, button)
	ClearMenu()
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show context menu
		local BMU_savedVarsChar = BMU.savedVarsChar  --INS251229 Baertram
		-- make default tab
		local menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU_savedVarsChar.defaultTab == BMU.indexListQuests then BMU_savedVarsChar.defaultTab = BMU.indexListMain else BMU_savedVarsChar.defaultTab = BMU.indexListQuests end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU_savedVarsChar.defaultTab == BMU.indexListQuests then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end
		ShowMenu()
	else
		BMU_createTable({index=BMU.indexListQuests})
	end
  end)

  teleporterWin_Main_Control_QuestTexture:SetHandler("OnMouseEnter", function(teleporterWin_Main_Control_QuestTextureCtrl)
    BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_QuestTextureCtrl,
		GetString(SI_JOURNAL_MENU_QUESTS) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin_Main_Control_QuestTextureCtrl:SetTexture(BMU_textures.questBtnOver)
  end)

  teleporterWin_Main_Control_QuestTexture:SetHandler("OnMouseExit", function(teleporterWin_Main_Control_QuestTextureCtrl)
    BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_QuestTextureCtrl)
	if BMU.state ~= BMU.indexListQuests then
		teleporterWin_Main_Control_QuestTextureCtrl:SetTexture(BMU_textures.questBtn)
	end
  end)


  --------------------------------------------------------------------------------------------------------------------
  -- Related Items (Antiquities, Surveys, ...)
  --------------------------------------------------------------------------------------------------------------------
  teleporterWin_Main_Control_ItemTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.ItemTexture = teleporterWin_Main_Control_ItemTexture
  teleporterWin_Main_Control_ItemTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_ItemTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -120*scale, 40*scale)
  teleporterWin_Main_Control_ItemTexture:SetTexture(BMU_textures.relatedItemsBtn)
  teleporterWin_Main_Control_ItemTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_ItemTexture:SetDrawLayer(2)

  -- -v- INS251229 Baertram BEGIN 1 Variables for the relevant submenu opening controls
  local submenuIndicesToAddCallbackTo = {}
  --reference variables for performance etc.
  local function BMU_CreateTable_IndexListItems() --local function which is not redefined each contextMenu open again and again and again -> memory and performance drain!
    BMU_createTable({index=BMU.indexListItems})
  end
  -- -^- INS251229 Baertram END 1
  teleporterWin_Main_Control_ItemTexture:SetHandler("OnMouseUp", function(ctrl, button)
      BMU_updateCheckboxSurveyMap = BMU_updateCheckboxSurveyMap or BMU.updateCheckboxSurveyMap  --INS251229 Baertram
	  submenuIndicesToAddCallbackTo = {}                                                        --INS251229 Baertram
	  ClearMenu()
      if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show filter menu

		-- Add submenu for antiquity leads
		submenuIndicesToAddCallbackTo[#submenuIndicesToAddCallbackTo+1] = AddCustomSubMenuItem(GetString(SI_GAMEPAD_VENDOR_ANTIQUITY_LEAD_GROUP_HEADER), --INS251229 Baertram
			{
				{
					label = GetString(SI_ANTIQUITY_SCRYABLE),
					callback = function()
						BMU.savedVarsChar.displayAntiquityLeads.srcyable = not BMU.savedVarsChar.displayAntiquityLeads.srcyable
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayAntiquityLeads.srcyable end,
				},
				{
					label = GetString(SI_ANTIQUITY_SUBHEADING_IN_PROGRESS),
					callback = function()
						BMU.savedVarsChar.displayAntiquityLeads.scried = not BMU.savedVarsChar.displayAntiquityLeads.scried
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayAntiquityLeads.scried end,
				},
				{
					label = GetString(SI_SCREEN_NARRATION_ACHIEVEMENT_EARNED_ICON_NARRATION) .. " (" .. GetString(SI_ANTIQUITY_LOG_BOOK) .. ")",
					callback = function()
						BMU.savedVarsChar.displayAntiquityLeads.completed = not BMU.savedVarsChar.displayAntiquityLeads.completed
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayAntiquityLeads.completed end,
				},
			}, nil, nil, nil, 5
		)

		-- Clues
		local menuIndex = AddCustomMenuItem(GetString(SI_SPECIALIZEDITEMTYPE113), function() BMU.savedVarsChar.displayMaps.clue = not BMU.savedVarsChar.displayMaps.clue BMU_CreateTable_IndexListItems() end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
		if BMU.savedVarsChar.displayMaps.clue then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		-- Treasure Maps
		menuIndex = AddCustomMenuItem(GetString(SI_SPECIALIZEDITEMTYPE100), function() BMU.savedVarsChar.displayMaps.treasure = not BMU.savedVarsChar.displayMaps.treasure BMU_CreateTable_IndexListItems() end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
		if BMU.savedVarsChar.displayMaps.treasure then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		-- All Survey Maps
        BMU_getContextMenuEntrySurveyAllAppendix = BMU_getContextMenuEntrySurveyAllAppendix or BMU.getContextMenuEntrySurveyAllAppendix --INS251229 Baertram
		BMU.menuIndexSurveyAll = AddCustomMenuItem(GetString(SI_SPECIALIZEDITEMTYPE101) .. BMU_getContextMenuEntrySurveyAllAppendix(), --CHG251229 Baertram
			function()
				if zo_CheckButton_IsChecked(zo_Menu.items[BMU.menuIndexSurveyAll].checkbox) then
					-- check all subTypes
					BMU_updateCheckboxSurveyMap(1)
				else
					-- uncheck all subTypes
					BMU_updateCheckboxSurveyMap(2)
				end
				BMU_CreateTable_IndexListItems()
			end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 4)

		if BMU_numOfSurveyTypesChecked() > 0 then
			zo_CheckButton_SetChecked(zo_Menu.items[BMU.menuIndexSurveyAll].checkbox)
		end

		-- Add submenu for survey types filter
		submenuIndicesToAddCallbackTo[#submenuIndicesToAddCallbackTo+1] = AddCustomSubMenuItem(GetString(SI_GAMEPAD_BANK_FILTER_HEADER), --INS251229 Baertram
			{
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY14),
					callback = function()
						BMU.savedVarsChar.displayMaps.alchemist = not BMU.savedVarsChar.displayMaps.alchemist
						BMU_updateCheckboxSurveyMap(3)
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.alchemist end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY15),
					callback = function()
						BMU.savedVarsChar.displayMaps.enchanter = not BMU.savedVarsChar.displayMaps.enchanter
						BMU_updateCheckboxSurveyMap(3)
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.enchanter end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY12),
					callback = function()
						BMU.savedVarsChar.displayMaps.woodworker = not BMU.savedVarsChar.displayMaps.woodworker
						BMU_updateCheckboxSurveyMap(3)
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.woodworker end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY10),
					callback = function()
						BMU.savedVarsChar.displayMaps.blacksmith = not BMU.savedVarsChar.displayMaps.blacksmith
						BMU_updateCheckboxSurveyMap(3)
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.blacksmith end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY11),
					callback = function()
						BMU.savedVarsChar.displayMaps.clothier = not BMU.savedVarsChar.displayMaps.clothier
						BMU_updateCheckboxSurveyMap(3)
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.clothier end,
				},
				{
					label = GetString(SI_ITEMTYPEDISPLAYCATEGORY13),
					callback = function()
						BMU.savedVarsChar.displayMaps.jewelry = not BMU.savedVarsChar.displayMaps.jewelry
						BMU_updateCheckboxSurveyMap(3)
						BMU_CreateTable_IndexListItems() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.displayMaps.jewelry end,
				},
			}, nil, nil, nil, 5
		)

		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)

		-- include bank items
		menuIndex = AddCustomMenuItem(GetString(SI_CRAFTING_INCLUDE_BANKED), function() BMU.savedVarsChar.scanBankForMaps = not BMU.savedVarsChar.scanBankForMaps BMU_CreateTable_IndexListItems() end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
		if BMU.savedVarsChar.scanBankForMaps then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		-- enable/disable counter panel
		menuIndex = AddCustomMenuItem(GetString(SI_ENDLESS_DUNGEON_BUFF_TRACKER_SWITCH_TO_SUMMARY_KEYBIND), function() BMU.savedVarsChar.displayCounterPanel = not BMU.savedVarsChar.displayCounterPanel BMU_CreateTable_IndexListItems() end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
		if BMU.savedVarsChar.displayCounterPanel then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)

		-- make default tab
		menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListItems then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListItems end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.defaultTab == BMU.indexListItems then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		ShowMenu()
	else
		BMU_CreateTable_IndexListItems()
		BMU.showNotification(true)
	end
  end)
  -- -v- INS251229 Baertram BEGIN 2 - Variables for the submenu OnMouseUp click handler -> Clicking the submenu opening controls toggles all checkboxes in the submenu to checked/unchecked
  --Called from ZO_Menu_OnHide callback
  local function cleanUpzo_MenuItemsSubmenuSpecialCallbacks()
--d("[BMU]cleanUpzo_MenuItemsSubmenuSpecialCallbacks")
      if zo_IsTableEmpty(submenuIndicesToAddCallbackTo) or zo_IsTableEmpty(zo_MenuSubmenuItemsHooked) then return end
      submenuIndicesToAddCallbackTo = {}
      zo_MenuSubmenuItemsHooked = {}
  end

  --Check if LibCustomMenuSubmenu is shown and if any enabled and shown checkboxes are in the submenu, then change the clicked state of them
  --> Called from clicking the ZO_Menu entry which opens the submenu
  local function checkIfLibCustomMenuSubmenuShownAndToggleCheckboxes(itemCtrl, mouseButton, upInside)
--d("[BMU]checkIfLibCustomMenuSubmenuShownAndToggleCheckboxes-mouseButton: " .. tostring(mouseButton) .. ", upInside: " ..tostring(upInside))
      --LibCustomMenuSubmenu got entries?
      if not upInside or mouseButton ~= MOUSE_BUTTON_INDEX_LEFT or not libCustomMenuSubmenu or zo_MenuSubmenuItemsHooked[itemCtrl] == nil then return end
      --Get the current state of the submenu (if not set yet it is assumed to be "all unchecked")
      local checkboxesAtSubmenuNewState = checkboxesAtSubmenuCurrentState[itemCtrl] or false
      --and invert it (on -> off / off -> on)
      checkboxesAtSubmenuNewState = not checkboxesAtSubmenuNewState

      --Check all child controls of the submenu for any checkbox entry and set the new state and calling the toggle function of the checkbox
      for childIndex=1, libCustomMenuSubmenu:GetNumChildren(), 1 do
        local childCtrl = libCustomMenuSubmenu:GetChild(childIndex)
--d(">found childCtrl: " ..tostring(childCtrl:GetName()))
          --Child is a subMenuItem?
          if childCtrl ~= nil then
            local checkBox = childCtrl.checkbox
            if childCtrl.IsHidden and childCtrl.IsMouseEnabled and not childCtrl:IsHidden() and childCtrl:IsMouseEnabled()
                  and checkBox and checkBox.toggleFunction and zo_CheckButton_IsEnabled(checkBox)
                  and childCtrl.GetName and zoPlainStrFind(childCtrl:GetName(), LCM_SubmenuEntryNamePrefix) ~= nil then
--d(">>set new state to: " ..tostring(checkboxesAtSubmenuNewState))
              zo_CheckButton_SetCheckState(checkBox, (checkboxesAtSubmenuNewState == false and BSTATE_NORMAL) or BSTATE_PRESSED)
              checkBox:toggleFunction(checkboxesAtSubmenuNewState)
            end
          end
      end
  end

  --Add the PreHook for handler OnMouseUp, on the submenu opening ZO_Menu item control row
  local function AddToggleAllSubmenuCheckboxEntriesCallback(submenuIndex)
      --d("[BMU]AddToggleAllSubmenuCheckboxEntriesCallback-index: " .. tostring(submenuIndex))
      if not submenuIndex then return end
      local submenuItem = zo_Menu.items[submenuIndex]
      local itemCtrl = submenuItem and submenuItem.item or nil
      --d(">found the itemCtrl: " .. tostring(itemCtrl))
      --Found the zo_Menu submenu opening control?
      if not itemCtrl then return end
      --Add the OnEffectivelyShown handler to the submenu opening control of zo_Menu (if not already in it)
      if zo_MenuSubmenuItemsHooked[itemCtrl] ~= nil then return end
      zo_MenuSubmenuItemsHooked[itemCtrl] = true
      ZO_PreHookHandler(itemCtrl, "OnMouseUp", checkIfLibCustomMenuSubmenuShownAndToggleCheckboxes)
  end

  --Add a prehook to the OnMouseUp handler of the relevant submenu opening ZO_Menu controls (saved into table submenuIndicesToAddCallbackTo)
  ZO_PostHook("ShowMenu", function(owner, initialRefCount, menuType)
      owner = owner or moc()
      menuType = menuType or MENU_TYPE_DEFAULT
--d("[BMU]ShowMenu-owner: " .. tostring(owner) .. "/" .. tostring(BMU_ItemTexture) .. "; menuType: " ..tostring(menuType))
      --Check if the menu is our at the BMU panel's itemTexture, if it got entries, if special submenu items have been defined -> Else abort
      if menuType ~= MENU_TYPE_DEFAULT or (owner == nil or owner ~= teleporterWin_Main_Control_ItemTexture) or zo_IsTableEmpty(submenuIndicesToAddCallbackTo)
              or next(zo_Menu.items) == nil then return end
      zo_MenuSubmenuItemsHooked = {}
      --Add the OnMouseUp handler to the submenu's "opening control" so clicking them will enable/disable (toggle) all the checkboxes inside the submenu
      for _, indexToAddTo in ipairs(submenuIndicesToAddCallbackTo) do
          AddToggleAllSubmenuCheckboxEntriesCallback(indexToAddTo)
      end
      --Called at zo_Menu_OnHide, and cleaned automatically at ClearMenu()
      SetMenuHiddenCallback(cleanUpzo_MenuItemsSubmenuSpecialCallbacks)
  end)
  -- -^- INS251229 Baertram - END 2

  teleporterWin_Main_Control_ItemTexture:SetHandler("OnMouseEnter", function(teleporterWin_Main_Control_ItemTextureCtrl)
	-- set tooltip accordingly to the selected filter
	local tooltip = ""
    local BMU_savedVarsChar = BMU.savedVarsChar --INS251229 Baertram
	if BMU_savedVarsChar.displayAntiquityLeads.scried or BMU_savedVarsChar.displayAntiquityLeads.srcyable then
		tooltip = GetString(SI_ANTIQUITY_LEAD_TOOLTIP_TAG)
	end
	if BMU_savedVarsChar.displayMaps.clue then
		if tooltip ~= "" then
			tooltip = tooltip .. " + " .. GetString(SI_SPECIALIZEDITEMTYPE113)
		else
			tooltip = GetString(SI_SPECIALIZEDITEMTYPE113)
		end
	end
	if BMU_savedVarsChar.displayMaps.treasure then
		if tooltip ~= "" then
			tooltip = tooltip .. " + " .. GetString(SI_SPECIALIZEDITEMTYPE100)
		else
			tooltip = GetString(SI_SPECIALIZEDITEMTYPE100)
		end
	end
	if BMU_numOfSurveyTypesChecked() > 0 then
		if tooltip ~= "" then
			tooltip = tooltip .. " + " .. GetString(SI_SPECIALIZEDITEMTYPE101)
		else
			tooltip = GetString(SI_SPECIALIZEDITEMTYPE101)
		end
	end
	-- add right-click info
	tooltip = tooltip .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU)

	-- show tooltip
    BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_ItemTextureCtrl, tooltip)
    -- button highlight
	teleporterWin_Main_Control_ItemTextureCtrl:SetTexture(BMU_textures.relatedItemsBtnOver)
  end)

  teleporterWin_Main_Control_ItemTexture:SetHandler("OnMouseExit", function(teleporterWin_Main_Control_ItemTextureCtrl)
    BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_ItemTextureCtrl)
	if BMU.state ~= BMU.indexListItems then
		teleporterWin_Main_Control_ItemTextureCtrl:SetTexture(BMU_textures.relatedItemsBtn)
	end
  end)

  --------------------------------------------------------------------------------------------------------------------
  -- Create counter panel that displays the counter for each type
  --------------------------------------------------------------------------------------------------------------------
  BMU_counterPanel = WINDOW_MANAGER:CreateControl(nil, BMU.win.Main_Control, CT_LABEL)
  BMU.counterPanel = BMU_counterPanel
  BMU_counterPanel:SetFont(BMU.font1)
  BMU_counterPanel:SetHidden(true)

  --------------------------------------------------------------------------------------------------------------------
  -- Only current zone
  --------------------------------------------------------------------------------------------------------------------
  teleporterWin_Main_Control_OnlyYourzoneTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.OnlyYourzoneTexture = teleporterWin_Main_Control_OnlyYourzoneTexture
  teleporterWin_Main_Control_OnlyYourzoneTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_OnlyYourzoneTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -80*scale, 40*scale)
  teleporterWin_Main_Control_OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtn)
  teleporterWin_Main_Control_OnlyYourzoneTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_OnlyYourzoneTexture:SetDrawLayer(2)

	teleporterWin_Main_Control_OnlyYourzoneTexture:SetHandler("OnMouseUp", function(self, button)
		ClearMenu()
		if button == MOUSE_BUTTON_INDEX_RIGHT then
			-- show context menu
			local BMU_savedVarsChar = BMU.savedVarsChar   --INS251229 Baertram
			-- make default tab
			local menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU_savedVarsChar.defaultTab == BMU.indexListCurrentZone then BMU_savedVarsChar.defaultTab = BMU.indexListMain else BMU_savedVarsChar.defaultTab = BMU.indexListCurrentZone end end, MENU_ADD_OPTION_CHECKBOX)
			if BMU_savedVarsChar.defaultTab == BMU.indexListCurrentZone then
				zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
			end
			ShowMenu()
		else
			BMU_createTable({index=BMU.indexListCurrentZone})
		end
	end)

    teleporterWin_Main_Control_OnlyYourzoneTexture:SetHandler("OnMouseEnter", function(teleporterWin_Main_Control_OnlyYourzoneTextureCtrl)
		BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_OnlyYourzoneTextureCtrl,
			GetString(SI_ANTIQUITY_SCRYABLE_CURRENT_ZONE_SUBCATEGORY) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
		teleporterWin_Main_Control_OnlyYourzoneTextureCtrl:SetTexture(BMU_textures.currentZoneBtnOver)
	end)

	teleporterWin_Main_Control_OnlyYourzoneTexture:SetHandler("OnMouseExit", function(teleporterWin_Main_Control_OnlyYourzoneTextureCtrl)
		BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_OnlyYourzoneTextureCtrl)
		if BMU.state ~= BMU.indexListCurrentZone then
			teleporterWin_Main_Control_OnlyYourzoneTextureCtrl:SetTexture(BMU_textures.currentZoneBtn)
		end
	end)


  --------------------------------------------------------------------------------------------------------------------
  -- Delves in current zone
  --------------------------------------------------------------------------------------------------------------------
  teleporterWin_Main_Control_DelvesTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.DelvesTexture = teleporterWin_Main_Control_DelvesTexture
  teleporterWin_Main_Control_DelvesTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_DelvesTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -40*scale, 40*scale)
  teleporterWin_Main_Control_DelvesTexture:SetTexture(BMU_textures.delvesBtn)
  teleporterWin_Main_Control_DelvesTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_DelvesTexture:SetDrawLayer(2)

  teleporterWin_Main_Control_DelvesTexture:SetHandler("OnMouseUp", function(self, button)
	ClearMenu()
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show context menu
		local BMU_savedVarsChar = BMU.savedVarsChar  --INS251229 Baertram
		-- show all or only in current zone
		local menuIndex = AddCustomMenuItem(GetString(SI_GAMEPAD_GUILD_HISTORY_SUBCATEGORY_ALL), function() BMU_savedVarsChar.showAllDelves = not BMU_savedVarsChar.showAllDelves BMU_createTable({index=BMU.indexListDelves}) end, MENU_ADD_OPTION_CHECKBOX)
		if BMU_savedVarsChar.showAllDelves then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)

		-- make default tab
		menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU_savedVarsChar.defaultTab == BMU.indexListDelves then BMU_savedVarsChar.defaultTab = BMU.indexListMain else BMU_savedVarsChar.defaultTab = BMU.indexListDelves end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU_savedVarsChar.defaultTab == BMU.indexListDelves then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end
		ShowMenu()
	else
		BMU_createTable({index=BMU.indexListDelves})
	end
  end)

  teleporterWin_Main_Control_DelvesTexture:SetHandler("OnMouseEnter", function(teleporterWin_Main_Control_DelvesTextureCtrl)
	local text = GetString(SI_ZONECOMPLETIONTYPE5)
	if not BMU.savedVarsChar.showAllDelves then
		text = text .. " - " .. GetString(SI_ANTIQUITY_SCRYABLE_CURRENT_ZONE_SUBCATEGORY)
	end
	BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_DelvesTextureCtrl,
		text .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin_Main_Control_DelvesTextureCtrl:SetTexture(BMU_textures.delvesBtnOver)
  end)

  teleporterWin_Main_Control_DelvesTexture:SetHandler("OnMouseExit", function(teleporterWin_Main_Control_DelvesTextureCtrl)
    BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_DelvesTextureCtrl)
	if BMU.state ~= BMU.indexListDelves then
		teleporterWin_Main_Control_DelvesTextureCtrl:SetTexture(BMU_textures.delvesBtn)
	end
  end)


  --------------------------------------------------------------------------------------------------------------------
  -- DUNGEON FINDER
  --------------------------------------------------------------------------------------------------------------------
  teleporterWin_Main_Control_DungeonTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.DungeonTexture = teleporterWin_Main_Control_DungeonTexture
  teleporterWin_Main_Control_DungeonTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control_DungeonTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, 0*scale, 40*scale)
  teleporterWin_Main_Control_DungeonTexture:SetTexture(BMU_textures.soloArenaBtn)
  teleporterWin_Main_Control_DungeonTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control_DungeonTexture:SetDrawLayer(2)

  teleporterWin_Main_Control_DungeonTexture:SetHandler("OnMouseUp", function(self, button)
	ClearMenu()
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show filter menu
		-- add filters
		AddCustomSubMenuItem(GetString(SI_GAMEPAD_BANK_FILTER_HEADER),
			{
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_ENDLESS_DUNGEONS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showEndlessDungeons = not BMU.savedVarsChar.dungeonFinder.showEndlessDungeons BMU_createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showEndlessDungeons end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_ARENAS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showArenas = not BMU.savedVarsChar.dungeonFinder.showArenas BMU_createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showArenas end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_GROUP_ARENAS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showGroupArenas = not BMU.savedVarsChar.dungeonFinder.showGroupArenas BMU_createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showGroupArenas end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_TRIALS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showTrials = not BMU.savedVarsChar.dungeonFinder.showTrials BMU_createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showTrials end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_GROUP_DUNGEONS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showDungeons = not BMU.savedVarsChar.dungeonFinder.showDungeons BMU_createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showDungeons end,
				},
			}, nil, nil, nil, 5
		)

		-- sorting (release or acronym)
		-- checkbox does not rely behave like a toogle in this case, enforce 3 possible statuses
		AddCustomSubMenuItem(GetString(SI_GAMEPAD_SORT_OPTION),
			{
				-- sort by release: from old (top of list) to new
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_SORT_RELEASE) .. BMU_textures.arrowUp,
					callback = function()
						local dungeonFinderCharSV = BMU.savedVarsChar.dungeonFinder
						dungeonFinderCharSV.sortByReleaseASC = true
						dungeonFinderCharSV.sortByReleaseDESC = false
						dungeonFinderCharSV.sortByAcronym = false
						BMU_clearInputFields()
						BMU_createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.sortByReleaseASC end,
				},
				-- sort by release: from new (top of list) to old
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_SORT_RELEASE) .. BMU_textures.arrowDown,
					callback = function()
						local dungeonFinderCharSV = BMU.savedVarsChar.dungeonFinder
						dungeonFinderCharSV.sortByReleaseDESC = true
						dungeonFinderCharSV.sortByReleaseASC = false
						dungeonFinderCharSV.sortByAcronym = false
						BMU_clearInputFields()
						BMU_createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC end,
				},
				-- sort by acronym
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_SORT_ACRONYM),
					callback = function()
						local dungeonFinderCharSV = BMU.savedVarsChar.dungeonFinder
						dungeonFinderCharSV.sortByAcronym = true
						dungeonFinderCharSV.sortByReleaseASC = false
						dungeonFinderCharSV.sortByReleaseDESC = false
						BMU_clearInputFields()
						BMU_createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.sortByAcronym end,
				},
			}, nil, nil, nil, 5
		)

		-- display options (update name or acronym) (dungeon name or zone name)
		AddCustomSubMenuItem(GetString(SI_GRAPHICS_OPTIONS_VIDEO_CATEGORY_DISPLAY),
			{
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_UPDATE_NAME),
					callback = function() BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName = not BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName BMU_clearInputFields() BMU_createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return not BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_ACRONYM),
					callback = function() BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName = not BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName BMU_clearInputFields() BMU_createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName end,
				},
				{
					label = "-",
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOOGLE_DUNGEON_NAME),
					callback = function() BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName = not BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName BMU_clearInputFields() BMU_createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return not BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOOGLE_ZONE_NAME),
					callback = function() BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName = not BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName BMU_clearInputFields() BMU_createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName end,
				},
			}, nil, nil, nil, 5
		)

		-- add dungeon difficulty toggle
		if CanPlayerChangeGroupDifficulty() then
			local menuIndex = AddCustomMenuItem(BMU_textures.dungeonDifficultyVeteran .. GetString(SI_DUNGEONDIFFICULTY2), function() BMU.setDungeonDifficulty(not ZO_ConvertToIsVeteranDifficulty(ZO_GetEffectiveDungeonDifficulty())) zo_callLater(function() BMU_createTableDungeons() end, 300) end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
			if ZO_ConvertToIsVeteranDifficulty(ZO_GetEffectiveDungeonDifficulty()) then
				zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
			end
		end

		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)

		-- make default tab
		local menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListDungeons then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListDungeons end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.defaultTab == BMU.indexListDungeons then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		ShowMenu()
	else
		BMU_clearInputFields()
		BMU_createTableDungeons()
	end
  end)

  teleporterWin_Main_Control_DungeonTexture:SetHandler("OnMouseEnter", function(teleporterWin_Main_Control_DungeonTextureCtrl)
	BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_DungeonTextureCtrl,
		BMU_SI_get(SI.TELE_UI_BTN_DUNGEON_FINDER) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin_Main_Control_DungeonTextureCtrl:SetTexture(BMU_textures.soloArenaBtnOver)
  end)

  teleporterWin_Main_Control_DungeonTexture:SetHandler("OnMouseExit", function(teleporterWin_Main_Control_DungeonTextureCtrl)
    BMU_tooltipTextEnter(BMU, teleporterWin_Main_Control_DungeonTextureCtrl)
	if BMU.state ~= BMU.indexListDungeons then
		teleporterWin_Main_Control_DungeonTextureCtrl:SetTexture(BMU_textures.soloArenaBtn)
	end
  end)
	  
end
--------------------------------------------------------------------------------------------------------------------
-- -^- SetupUI
--------------------------------------------------------------------------------------------------------------------


function BMU.updateCheckboxSurveyMap(action)
	BMU_numOfSurveyTypesChecked = BMU_numOfSurveyTypesChecked or BMU.numOfSurveyTypesChecked   	    --INS251229 Baertram
	BMU_updateContextMenuEntrySurveyAll = BMU_updateContextMenuEntrySurveyAll or BMU.updateContextMenuEntrySurveyAll --INS251229 Baertram
	if action == 3 then
		-- check if at least one of the subTypes is checked
		if BMU_numOfSurveyTypesChecked() > 0 then
			zo_CheckButton_SetChecked(zo_Menu.items[BMU.menuIndexSurveyAll].checkbox)
		else
			-- no survey type is checked
			ZO_CheckButton_SetUnchecked(zo_Menu.items[BMU.menuIndexSurveyAll].checkbox)
		end
	else
		-- if action == 1 --> all are checked
		-- else (action == 2) --> all are unchecked
		for _, subType in pairs({'alchemist', 'enchanter', 'woodworker', 'blacksmith', 'clothier', 'jewelry'}) do
			BMU.savedVarsChar.displayMaps[subType] = (action == 1)
		end
	end
    BMU_updateContextMenuEntrySurveyAll() --CHG251229 Baertram
end
BMU_updateCheckboxSurveyMap = BMU.updateCheckboxSurveyMap


function BMU.numOfSurveyTypesChecked()
	local num = 0
	for _, subType in pairs({'alchemist', 'enchanter', 'woodworker', 'blacksmith', 'clothier', 'jewelry'}) do
		if BMU.savedVarsChar.displayMaps[subType] then
			num = num + 1
		end
	end
	return num
end
BMU_numOfSurveyTypesChecked = BMU.numOfSurveyTypesChecked --INS251229 Baertram


function BMU.updateContextMenuEntrySurveyAll()
	BMU_getContextMenuEntrySurveyAllAppendix = BMU_getContextMenuEntrySurveyAllAppendix or BMU.getContextMenuEntrySurveyAllAppendix --INS251229 Baertram
	BMU_numOfSurveyTypesChecked = BMU_numOfSurveyTypesChecked or BMU.numOfSurveyTypesChecked   	    --INS251229 Baertram
    local num = BMU_numOfSurveyTypesChecked()
	local baseString = string.sub(zo_Menu.items[BMU.menuIndexSurveyAll].item.nameLabel:GetText(), 1, -7)
	zo_Menu.items[BMU.menuIndexSurveyAll].item.nameLabel:SetText(baseString .. BMU_getContextMenuEntrySurveyAllAppendix()) --CHG251229 Baertram
end
BMU_updateContextMenuEntrySurveyAll = BMU.updateContextMenuEntrySurveyAll


function BMU.getContextMenuEntrySurveyAllAppendix()
	BMU_numOfSurveyTypesChecked = BMU_numOfSurveyTypesChecked or BMU.numOfSurveyTypesChecked   	    --INS251229 Baertram
	local num = BMU_numOfSurveyTypesChecked()
	local appendix = " (" .. num .. "/6)"
	return appendix
end
BMU_getContextMenuEntrySurveyAllAppendix = BMU.getContextMenuEntrySurveyAllAppendix --INS251229 Baertram


function BMU.updatePosition()
    local teleporterWin     = BMU.win
	if SCENE_MANAGER:IsShowing("worldMap") then
	
		-- show anchor button
		teleporterWin_anchorTexture:SetHidden(false)
		-- show swap button
		BMU.closeBtnSwitchTexture(true)
		
		if BMU.savedVarsAcc.anchorOnMap then
			-- anchor to map
			BMU.control_global.bd:ClearAnchors()
			--BMU.control_global.bd:SetAnchor(TOPLEFT, ZO_WorldMap, TOPLEFT, BMU.savedVarsAcc.anchorMap_x, BMU.savedVarsAcc.anchorMap_y)
			BMU.control_global.bd:SetAnchor(TOPRIGHT, ZO_WorldMap, TOPLEFT, BMU.savedVarsAcc.anchorMapOffset_x, (-70*BMU.savedVarsAcc.Scale) + BMU.savedVarsAcc.anchorMapOffset_y)
			-- fix position
			BMU.control_global.bd:SetMovable(false)
			-- hide fix/unfix button
			teleporterWin.fixWindowTexture:SetHidden(true)
			-- set anchor button texture
			teleporterWin_anchorTexture:SetTexture(BMU_textures.anchorMapBtnOver)
		else
			-- use saved pos when map is open
			BMU.control_global.bd:ClearAnchors()
			BMU.control_global.bd:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LEFT + BMU.savedVarsAcc.pos_MapScene_x, BMU.savedVarsAcc.pos_MapScene_y)
			-- set fix/unfix state
			BMU.control_global.bd:SetMovable(not BMU.savedVarsAcc.fixedWindow)
			-- show fix/unfix button
			teleporterWin.fixWindowTexture:SetHidden(false)
			-- set anchor button texture
			teleporterWin_anchorTexture:SetTexture(BMU_textures.anchorMapBtn)
		end
	else
		-- hide anchor button
		teleporterWin_anchorTexture:SetHidden(true)
		-- hide swap button
		BMU.closeBtnSwitchTexture(false)
		
		-- use saved pos when map is NOT open
		BMU.control_global.bd:ClearAnchors()
		BMU.control_global.bd:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LEFT + BMU.savedVarsAcc.pos_x, BMU.savedVarsAcc.pos_y)
		-- set fix/unfix state
		BMU.control_global.bd:SetMovable(not BMU.savedVarsAcc.fixedWindow)
		-- show fix/unfix button
		teleporterWin.fixWindowTexture:SetHidden(false)
	end
end


function BMU.closeBtnSwitchTexture(flag)
    local teleporterWin     = BMU.win
	if flag then
		-- show swap button
		-- set texture and handlers
		teleporterWin_closeTexture:SetTexture(BMU_textures.swapBtn)
		teleporterWin_closeTexture:SetHandler("OnMouseEnter", function(self)
			teleporterWin_closeTexture:SetTexture(BMU_textures.swapBtnOver)
			BMU:tooltipTextEnter(teleporterWin_closeTexture,
				BMU_SI_get(SI.TELE_UI_BTN_TOGGLE_BMU))
		end)
		teleporterWin_closeTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin_closeTexture)
			teleporterWin_closeTexture:SetTexture(BMU_textures.swapBtn)
		end)
		
	else
		-- show normal close button
		-- set textures and handlers
		teleporterWin_closeTexture:SetTexture(BMU_textures.closeBtn)
		teleporterWin_closeTexture:SetHandler("OnMouseEnter", function(self)
		teleporterWin_closeTexture:SetTexture(BMU_textures.closeBtnOver)
			BMU:tooltipTextEnter(teleporterWin_closeTexture,
				GetString(SI_DIALOG_CLOSE))
		end)
		teleporterWin_closeTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin_closeTexture)
			teleporterWin_closeTexture:SetTexture(BMU_textures.closeBtn)
		end)
	end
end


function BMU.clearInputFields()
    local teleporterWin = BMU.win
	-- Clear Input Field Player
	teleporterWin_Searcher_Player:SetText("")
	-- Show Placeholder
	teleporterWin_Searcher_Player_Placeholder:SetHidden(false)
	-- Clear Input Field Zone
	teleporterWin_Searcher_Zone:SetText("")
	-- Show Placeholder
	teleporterWin_Searcher_Zone_Placeholder:SetHidden(false)
end
BMU_clearInputFields = BMU.clearInputFields



-- display the correct persistent MouseOver depending on Button
-- also set global state for auto refresh
function BMU.changeState(index)

	BMU.printToChat("Changed - state: " .. tostring(index), BMU.MSG_DB)
    
	local teleporterWin = BMU.win

	-- first disable all MouseOver
    local teleporterWin_Main_Control = teleporterWin.Main_Control                           --INS251229 Baertram
	teleporterWin_Main_Control_ItemTexture:SetTexture(BMU_textures.relatedItemsBtn)
	teleporterWin_Main_Control_OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtn)
	teleporterWin_Main_Control_DelvesTexture:SetTexture(BMU_textures.delvesBtn)
	teleporterWin_SearchTexture:SetTexture(BMU_textures.searchBtn)
	teleporterWin_Main_Control_QuestTexture:SetTexture(BMU_textures.questBtn)
	teleporterWin_Main_Control_OwnHouseTexture:SetTexture(BMU_textures.houseBtn)
	teleporterWin_Main_Control_PTFTexture:SetTexture(BMU_textures.ptfHouseBtn)
	teleporterWin_Main_Control_DungeonTexture:SetTexture(BMU_textures.soloArenaBtn)
	local teleporterWin_guildTexture = teleporterWin.guildTexture
    if teleporterWin_guildTexture then                                                      --INS251229 Baertram
		teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtn)                        --INS251229 Baertram
	end
	-- hide counter panel for related items tab
	BMU_counterPanel:SetHidden(true)
	
	teleporterWin_Searcher_Player:SetHidden(false)

	-- check new state
	if index == BMU.indexListItems then
		-- related Items
		teleporterWin_Main_Control_ItemTexture:SetTexture(BMU_textures.relatedItemsBtnOver)
		if BMU.savedVarsChar.displayCounterPanel then
			BMU_counterPanel:SetHidden(false)
		end
	elseif index == BMU.indexListCurrentZone then
		-- current zone
		teleporterWin_Main_Control_OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtnOver)
	elseif index == BMU.indexListDelves then
		-- current zone delves
		teleporterWin_Main_Control_DelvesTexture:SetTexture(BMU_textures.delvesBtnOver)
	elseif index == BMU.indexListSearchPlayer or index == BMU.indexListSearchZone then
		-- serach by player name or zone name
		teleporterWin_SearchTexture:SetTexture(BMU_textures.searchBtnOver)
	elseif index == BMU.indexListQuests then
		-- related quests
		teleporterWin_Main_Control_QuestTexture:SetTexture(BMU_textures.questBtnOver)
	elseif index == BMU.indexListOwnHouses then
		-- own houses
		teleporterWin_Main_Control_OwnHouseTexture:SetTexture(BMU_textures.houseBtnOver)
	elseif index == BMU.indexListPTFHouses then
		-- PTF houses
		teleporterWin_Main_Control_PTFTexture:SetTexture(BMU_textures.ptfHouseBtnOver)
	elseif index == BMU.indexListGuilds then
		-- guilds
		if teleporterWin_guildTexture then
			teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtnOver)
		end
	elseif index == BMU.indexListDungeons then
		-- dungeon finder
		teleporterWin_Main_Control_DungeonTexture:SetTexture(BMU_textures.soloArenaBtnOver)
		teleporterWin_Searcher_Player:SetHidden(true)
	end
	
	BMU.state = index
end


------------------------

-- register and show basic dialogs
function BMU.showDialogSimple(dialogName, dialogTitle, dialogBody, callbackYes, callbackNo)
	local dialogInfo = {
		canQueue = true,
		title = {text=dialogTitle},
		mainText = {align=TEXT_ALIGN_LEFT, text=dialogBody},
	}
	
	if callbackYes or callbackNo then
		dialogInfo.buttons = {
			{
				text = SI_DIALOG_CONFIRM,
				keybind = "DIALOG_PRIMARY",
				callback = callbackYes,
			},
			{
				text = SI_DIALOG_CANCEL,
				keybind = "DIALOG_NEGATIVE",
				callback = callbackNo,
			},
		}
	else
		-- show only one button if both callbacks are nil
		dialogInfo.buttons = {
			{
				text = SI_DIALOG_CLOSE,
				keybind = "DIALOG_NEGATIVE",
			},
		}
	end
	
	return BMU.showDialogCustom(dialogName, dialogInfo)
end


-- register and show custom dialogs with given dialogInfo
function BMU.showDialogCustom(dialogName, dialogInfoObject)
	local dialogInfo = dialogInfoObject
	
	-- register dialog globally
	local globalDialogName = appName .. dialogName
	
	ESO_Dialogs[globalDialogName] = dialogInfo
	local dialogReference = ZO_Dialogs_ShowDialog(globalDialogName)
	
	return globalDialogName, dialogReference
end

------------------------


function BMU.TeleporterSetupUI(addOnName)
	if appName ~= addOnName then return end
		addOnName = appName .. " - Teleporter"
		BMU.SetupOptionsMenu(addOnName)
		SetupUI()
end


function BMU.journalUpdated()
	BMU.questDataChanged = true
end


-- HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_COLLECTIBLE
-- HOUSING_FURNISHING_LIMIT_TYPE_HIGH_IMPACT_ITEM
-- HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_COLLECTIBLE
-- HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM

-- update own houses furniture count
function BMU.updateHouseFurnitureCount(eventCode, option1, option2)
	-- the player entered a new zone or event furniture count updated
	local houseId = GetCurrentZoneHouseId()
	if houseId ~= nil and IsOwnerOfCurrentHouse() then
		-- player is in an own house
		if eventCode == EVENT_HOUSE_FURNITURE_COUNT_UPDATED and option1 ~= houseId then
			-- abort if furniture count was updated but different house
			return
		end

		local currentFurnitureCount_LII = GetNumHouseFurnishingsPlaced(HOUSING_FURNISHING_LIMIT_TYPE_LOW_IMPACT_ITEM)
		if currentFurnitureCount_LII ~= nil then
			-- save value to savedVars
			BMU.savedVarsServ.houseFurnitureCount_LII[houseId] = currentFurnitureCount_LII
		end
	end
end


-- handles event when player clicks on a chat link
	-- 1. for sharing teleport destination to the group (built-in type with drive-by data)
	-- 2. for wayshrine map ping (custom link)
function BMU.handleChatLinkClick(rawLink, mouseButton, linkText, linkStyle, linkType, data1, data2, data3, data4) -- can contain more data fields
	local number_to_bool ={ [0]=false, [1]=true }
	-- sharing
	if linkType == "book" then
		local bookId = data1
		local signature = tostring(data2)
		
		-- sharing player
		if signature == "BMU_S_P" then
			local playerFrom = tostring(data3)
			local playerTo = tostring(data4)
			if playerFrom ~= nil and playerTo ~= nil then
				-- try to find the destination player
				local result = BMU_createTable({index=BMU.indexListSearchPlayer, inputString=playerTo, dontDisplay=true})
				local firstRecord = result[1]
				if firstRecord.displayName == "" then
					-- player not found
					BMU.printToChat(playerTo .. " - " .. GetString(SI_FASTTRAVELKEEPRESULT9))
				else
					BMU.printToChat(BMU_SI_get(SI.TELE_CHAT_SHARING_FOLLOW_LINK), BMU.MSG_AD)
					BMU.PortalToPlayer(firstRecord.displayName, firstRecord.sourceIndexLeading, firstRecord.zoneName, firstRecord.zoneId, firstRecord.category, true, false, true)
				end
				return true
			end
			
		-- sharing house
		elseif signature == "BMU_S_H" then
			local player = tostring(data3)
			local houseId = tonumber(data4)
			if player ~= nil and houseId ~= nil then
				-- try to port to the house of the player
				BMU.printToChat(BMU_SI_get(SI.TELE_CHAT_SHARING_FOLLOW_LINK), BMU.MSG_AD)
				CancelCast()
				JumpToSpecificHouse(player, houseId)
			end
			return true
		end
	
	
	-- custom link (wayshrine map ping)
	elseif linkType == "BMU" then
		local signature = tostring(data1)
		local mapIndex = tonumber(data2)
		local coorX = tonumber(data3)
		local coorY = tonumber(data4)
		
		-- check if link is for map pings
		if signature == "BMU_P" and mapIndex ~= nil and coorX ~= nil and coorY ~= nil then
			-- valid map ping
			-- switch to Tamriel and back to specific map in order to reset any subzone or zoom
			WORLD_MAP_MANAGER:SetMapByIndex(1)
			WORLD_MAP_MANAGER:SetMapByIndex(mapIndex)
			-- start ping
			if not SCENE_MANAGER:IsShowing("worldMap") then SCENE_MANAGER:Show("worldMap") end
			PingMap(MAP_PIN_TYPE_RALLY_POINT, MAP_TYPE_LOCATION_CENTERED, coorX, coorY)
		end
		
		-- return true in any case because not handled custom link leads to UI error
		return true
	end
end


-- click on guild button
function BMU.redirectToBMUGuild()
	for _, guildId in pairs(teleporterVars.BMUGuilds[worldName]) do
		local guildData = GUILD_BROWSER_MANAGER:GetGuildData(guildId)
		if guildId and guildData and guildData.size and guildData.size < 495 then
			ZO_LinkHandler_OnLinkClicked("|H1:guild:" .. guildId .. "|hBeamMeUp Guild|h", 1, nil)
			return
		end
	end
	-- just redirect to latest BMU guild
	ZO_LinkHandler_OnLinkClicked("|H1:guild:" .. teleporterVars.BMUGuilds[worldName][#teleporterVars.BMUGuilds[worldName]] .. "|hBeamMeUp Guild|h", 1, nil)
end


-------------------------------------------------------------------
-- EXTRAS
-------------------------------------------------------------------

-- Show Notification when favorite player goes online
function BMU.FavoritePlayerStatusNotification(eventCode, option1, option2, option3, option4, option5) --GUILD:(eventCode, guildID, displayName, prevStatus, curStatus) FRIEND:(eventCode, displayName, characterName, prevStatus, curStatus)
	local displayName = ""
	local prevStatus = option3
	local curStatus = option4
	
	-- in case of EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED first option is guildID instead of displayName
	if eventCode == EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED then
		-- EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED
		displayName = option2
	else
		-- EVENT_FRIEND_PLAYER_STATUS_CHANGED
		displayName = option1
	end
	
	if BMU.savedVarsAcc.FavoritePlayerStatusNotification and BMU.isFavoritePlayer(displayName) and prevStatus == 4 and curStatus ~= 4 then
		CENTER_SCREEN_ANNOUNCE:AddMessage(0, CSA_CATEGORY_MAJOR_TEXT, SOUNDS.DEFER_NOTIFICATION, "Favorite Player Switched Status", BMU_colorizeText(displayName, "gold") .. " " .. BMU_colorizeText(BMU_SI_get(SI.TELE_CENTERSCREEN_FAVORITE_PLAYER_ONLINE), "white"), "esoui/art/mainmenu/menubar_social_up.dds", "EsoUI/Art/Achievements/achievements_iconBG.dds", nil, nil, 4000)
	end
end

--[[
-- Show Note, when player sends a whisper message and is offline -> player cannot receive any whisper messages
function BMU.HintOfflineWhisper(eventCode, messageType, from, test, isFromCustomerService, _)
	if BMU.savedVarsAcc.HintOfflineWhisper and messageType == CHAT_CHANNEL_WHISPER_SENT and GetPlayerStatus() == PLAYER_STATUS_OFFLINE then
		BMU.printToChat(BMU_colorizeText(BMU_SI_get(SI.TELE_CHAT_WHISPER_NOTE), colorRed))
	end
end
--]]

function BMU.surveyMapUsed(bagId, slotIndex, slotData)
	if bagId ~= nil and slotData ~= nil then
		if bagId == BAG_BACKPACK and slotData.specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT and not IsBankOpen() then
			-- d("Item Name: " .. BMU.formatName(slotData.rawName, false))
			-- d("Anzahl übrig: " .. slotData.stackCount - 1)
			if slotData.stackCount > 1 then
				-- still more available -> Show center screen message
				local sound = nil
				if BMU.savedVarsAcc.surveyMapsNotificationSound then
					-- set sound
					sound = SOUNDS.GUILD_WINDOW_OPEN  -- SOUNDS.DUEL_START
				end
				zo_callLater(function()
					CENTER_SCREEN_ANNOUNCE:AddMessage(0, CSA_CATEGORY_MAJOR_TEXT, sound, "Survey Maps Note", string_format(BMU_SI_get(SI.TELE_CENTERSCREEN_SURVEY_MAPS), slotData.stackCount-1), "esoui/art/icons/quest_scroll_001.dds", "EsoUI/Art/Achievements/achievements_iconBG.dds", nil, nil, 5000)
				end, 12000)
			end
		end
	end
end


function BMU.activateWayshrineTravelAutoConfirm()
		ESO_Dialogs["RECALL_CONFIRM"]={
			gamepadInfo={dialogType=GAMEPAD_DIALOGS.BASIC},
			title={text=SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM},
			mainText={text=SI_FAST_TRAVEL_DIALOG_MAIN_TEXT},
			updateFn=function(dialog)
					FastTravelToNode(dialog.data.nodeIndex)
					SCENE_MANAGER:ShowBaseScene()
					ZO_Dialogs_ReleaseDialog("RECALL_CONFIRM")
			end
		}
		ESO_Dialogs["FAST_TRAVEL_CONFIRM"]={
			gamepadInfo={dialogType=GAMEPAD_DIALOGS.BASIC},
			title={text=SI_PROMPT_TITLE_FAST_TRAVEL_CONFIRM},
			mainText={text=SI_FAST_TRAVEL_DIALOG_MAIN_TEXT},
			updateFn=function(dialog)
					FastTravelToNode(dialog.data.nodeIndex)
					ZO_Dialogs_ReleaseDialog("FAST_TRAVEL_CONFIRM")
			end
		}
end


-- request all guilds in queue
local BMU_requestGuildDataRecursive
function BMU.requestGuildDataRecursive(guildIds)
	BMU_requestGuildDataRecursive = BMU_requestGuildDataRecursive or BMU.requestGuildDataRecursive
	if #guildIds > 0 then
		GUILD_BROWSER_MANAGER:RequestGuildData(table_remove(guildIds))
		zo_callLater(function() BMU_requestGuildDataRecursive(guildIds) end, 800)
	else
		BMU.isCurrentlyRequestingGuildData = false
	end
end
BMU_requestGuildDataRecursive = BMU.requestGuildDataRecursive

--Request all BMU and partner guilds information
function BMU.requestGuildData()
	BMU.isCurrentlyRequestingGuildData = true
	local guildsQueue = {}
	-- official guilds
	if teleporterVars.BMUGuilds[worldName] ~= nil then
		guildsQueue = teleporterVars.BMUGuilds[worldName]
	end
	-- partner guilds
	if teleporterVars.partnerGuilds[worldName] ~= nil then
		guildsQueue = BMU_mergeTables(guildsQueue, teleporterVars.partnerGuilds[worldName])
	end

	BMU_requestGuildDataRecursive(guildsQueue)
end


--------------------------------------------------
-- GUILD ADMINISTRATION TOOL
--------------------------------------------------

function BMU.AdminAddContextMenuToGuildRoster()
	-- add context menu to guild roster
	local GuildRosterRow_OnMouseUp = GUILD_ROSTER_KEYBOARD.GuildRosterRow_OnMouseUp --ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseUp
	GUILD_ROSTER_KEYBOARD.GuildRosterRow_OnMouseUp = function(self, control, button, upInside)
		ClearMenu()     	    																	--INS251229 Baertram
		local data = ZO_ScrollList_GetData(control)
		GuildRosterRow_OnMouseUp(self, control, button, upInside)
		
		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		if (button ~= MOUSE_BUTTON_INDEX_RIGHT --[[and not upInside]]) or data == nil or not BMU.AdminIsBMUGuild(currentGuildId) then
			return
		end
		
		local isAlreadyMember, memberStatusText = BMU.AdminIsAlreadyInGuild(data.displayName)
		
		local entries = {}
		
		-- welcome message
		table_insert(entries, {label = "Willkommensnachricht",
								callback = function(state)
									local guildId = currentGuildId
									local guildIndex = BMU.AdminGetGuildIndexFromGuildId(guildId)
									StartChatInput("Welcome on the bridge " .. data.displayName, _G["CHAT_CHANNEL_GUILD_" .. guildIndex])
								end,
								})
								
		-- new message
		table_insert(entries, {label = "Neue Nachricht",
								callback = function(state) BMU.createMail(data.displayName, "", "") BMU.printToChat("Nachricht erstellt an: " .. data.displayName) end,
								})
								
		-- copy account name
		table_insert(entries, {label = "Account-ID kopieren",
								callback = function(state) BMU.AdminCopyTextToChat(data.displayName) end,
								})
		
		-- invite to BMU guilds
		if teleporterVars.BMUGuilds[worldName] ~= nil then
			for _, guildId in pairs(teleporterVars.BMUGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.displayName) then
					table_insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.displayName) end,
											})
				end
			end
		end
		
		-- invite to partner guilds
		if teleporterVars.partnerGuilds[worldName] ~= nil then
			for _, guildId in pairs(teleporterVars.partnerGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.displayName) then
					table_insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.displayName) end,
											})
				end
			end
		end
		
		-- check if the player is also in other BMU guilds and add info
		table_insert(entries, {label = memberStatusText,
								callback = function(state) end,
								})
		
		AddCustomSubMenuItem("BMU Admin", entries)
		self:ShowMenu(control)
	end
end


function BMU.AdminAddContextMenuToGuildApplicationRoster()
	-- add context menu to guild recruitment application roster (if player is already in a one of the BMU guilds + redirection to the other guilds)
	local Row_OnMouseUp = ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseUp
	ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseUp = function(self, control, button, upInside)
		ClearMenu()     	    																	--INS251229 Baertram
		local data = ZO_ScrollList_GetData(control)
		Row_OnMouseUp(self, control, button, upInside)
	
		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		if (button ~= MOUSE_BUTTON_INDEX_RIGHT --[[and not upInside]]) or data == nil or not BMU.AdminIsBMUGuild(currentGuildId) then
			return
		end
		
		local isAlreadyMember, memberStatusText = BMU.AdminIsAlreadyInGuild(data.name)

		local entries = {}
		
		-- new message
		table_insert(entries, {label = "Neue Nachricht",
								callback = function(state) BMU.createMail(data.name, "", "") BMU.printToChat("Nachricht erstellt an: " .. data.name) end,
								})
								
		-- copy account name
		table_insert(entries, {label = "Account-ID kopieren",
								callback = function(state) BMU.AdminCopyTextToChat(data.name) end,
								})
		
		-- invite to BMU guilds
		if teleporterVars.BMUGuilds[worldName] ~= nil then
			for _, guildId in pairs(teleporterVars.BMUGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.name) then
					table_insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.name) end,
											})
				end
			end
		end
		
		-- invite to partner guilds
		if teleporterVars.partnerGuilds[worldName] ~= nil then
			for _, guildId in pairs(teleporterVars.partnerGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.name) then
					table_insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.name) end,
											})
				end
			end
		end
		
		-- check if the player is also in other BMU guilds and add info
		table_insert(entries, {label = memberStatusText,
								callback = function(state) end,
								})
		
		AddCustomSubMenuItem("BMU Admin", entries)
		self:ShowMenu(control)
	end
end

function BMU.AdminAddTooltipInfoToGuildApplicationRoster()
	-- add info to the tooltip in guild recruitment application roster
	local Row_OnMouseEnter = ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseEnter
	ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseEnter = function(self, control)
		
		local data = ZO_ScrollList_GetData(control)
		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		
		if data ~= nil and not data.BMUInfo and BMU.AdminIsBMUGuild(currentGuildId) then
			local isAlreadyMember, memberStatusText = BMU.AdminIsAlreadyInGuild(data.name)
			data.message = data.message .. "\n\n" .. memberStatusText
			data.BMUInfo = true
		end
	
		Row_OnMouseEnter(self, control)		
	end
end

function BMU.AdminGetGuildIndexFromGuildId(guildId)
	for i = 1, GetNumGuilds() do
		if GetGuildId(i) == guildId then
			return i
		end
	end
	return 0
end
local BMU_AdminGetGuildIndexFromGuildId = BMU.AdminGetGuildIndexFromGuildId

function BMU.AdminCopyTextToChat(message)
	-- Max of input box is 351 chars
	if string_len(message) < 351 then
		local chatTextEntrey = CHAT_SYSTEM.textEntry
		if chatTextEntrey:GetText() == "" then
			chatTextEntrey:Open(message)
			ZO_ChatWindowTextEntryEditBox:SelectAll()
		end
	end
end

function BMU.AdminAutoWelcome(eventCode, guildId, displayName, result)
	-- only for BMU guilds
	if not BMU.AdminIsBMUGuild(guildId) then
		return
	end
	
	zo_callLater(function()
		if result == 0 then
			local guildIndex = BMU_AdminGetGuildIndexFromGuildId(guildId)
			local totalGuildMembers = GetNumGuildMembers(guildId)
			
			-- find new guild member
			for j = 0, totalGuildMembers do
				local displayName_info, note, guildMemberRankIndex, status, secsSinceLogoff = GetGuildMemberInfo(guildId, j)
				if displayName_info == displayName and status ~= PLAYER_STATUS_OFFLINE then
					-- new guild member is online -> write welcome message to chat
					StartChatInput("Welcome on the bridge " .. displayName, _G["CHAT_CHANNEL_GUILD_" .. guildIndex])
				end
			end
		end
	end, 1300)
end

function BMU.AdminIsAlreadyInGuild(displayName)
	local text = ""
	local BMU_guildsOfServer = teleporterVars.BMUGuilds[worldName]  								--INS251229 Baertram
	if GetGuildMemberIndexFromDisplayName(BMU_guildsOfServer[1], displayName) then
		text = text .. " 1 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU_guildsOfServer[2], displayName) then
		text = text .. " 2 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU_guildsOfServer[3], displayName) then
		text = text .. " 3 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU_guildsOfServer[4], displayName) then
		text = text .. " 4 "
	end
	
	if text ~= "" then
		-- already member
		return true, BMU_colorizeText("Bereits Mitglied in " .. text, colorRed)
	else
		-- not a member or admin is not member of the BMU guilds
		return false, BMU_colorizeText("Neues Mitglied", colorGreen)
	end
end

function BMU.AdminIsBMUGuild(guildId)
	if BMU.has_value(teleporterVars.BMUGuilds[worldName], guildId) then
		return true
	else
		return false
	end
end

local BMU_AdminInviteToGuildsQueue
function BMU.AdminInviteToGuildsQueue()
	BMU_AdminInviteToGuildsQueue = BMU_AdminInviteToGuildsQueue or BMU.AdminInviteToGuildsQueue
	if #inviteQueue > 0 then
		-- get first element and send invite
		local first = inviteQueue[1]
		GuildInvite(first[1], first[2])
		PlaySound(SOUNDS.BOOK_OPEN)
		-- restart to check for other elements
		zo_callLater(function() table_remove(inviteQueue, 1) BMU_AdminInviteToGuildsQueue() end, 16000)
	end
end
BMU_AdminInviteToGuildsQueue = BMU.AdminInviteToGuildsQueue

function BMU.AdminInviteToGuilds(guildId, displayName)
	-- add tuple to queue
	table_insert(inviteQueue, {guildId, displayName})
	if #inviteQueue == 1 then
		BMU_AdminInviteToGuildsQueue()
	end
end

function BMU.AdminAddAutoFillToDeclineApplicationDialog()
	local confirmDeclineDialogKeyboard = ZO_ConfirmDeclineApplicationDialog_Keyboard				--INS251229 Baertram
	local confirmDeclineEdit = ZO_ConfirmDeclineApplicationDialog_KeyboardDeclineMessageEdit		--INS251229 Baertram
	local font = string_format(fontPattern, ZoFontGame:GetFontInfo(), 21, "soft-shadow-thin")
	-- default message
	local autoFill_1 = WINDOW_MANAGER:CreateControl(nil, confirmDeclineDialogKeyboard, CT_LABEL)
	autoFill_1:SetAnchor(TOPRIGHT, confirmDeclineDialogKeyboard, TOPRIGHT, -5, 10)
	autoFill_1:SetFont(font)
	autoFill_1:SetText(BMU_colorizeText("BMU_AM", "gold"))
	autoFill_1:SetMouseEnabled(true)
	autoFill_1:SetHandler("OnMouseUp", function(self)
		confirmDeclineEdit:SetText("You are already a member of one of our other BMU guilds. Sorry, but we only allow joining one guild. You are welcome to join and support our partner guilds (flag button in the upper left corner).")
	end)
	-- message when player is already in 5 guilds
	local autoFill_2 = WINDOW_MANAGER:CreateControl(nil, confirmDeclineDialogKeyboard, CT_LABEL)
	autoFill_2:SetAnchor(TOPRIGHT, confirmDeclineDialogKeyboard, TOPRIGHT, -5, 40)
	autoFill_2:SetFont(font)
	autoFill_2:SetText(BMU_colorizeText("BMU_5G", "gold"))
	autoFill_2:SetMouseEnabled(true)
	autoFill_2:SetHandler("OnMouseUp", function(self)
		confirmDeclineEdit:SetText("We cannot accpect your application because you have already joined 5 other guilds (which is the maximum). If you want to join us, please submit a new application with free guild slot.")
	end)
end

