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
local worldName = GetWorldName()
local zo_Menu                               = ZO_Menu     --ZO_Menu speed-up variable (so _G is not searched each time context menus are used)
local zo_WorldMapZoneStoryTopLevel_Keyboard = ZO_WorldMapZoneStoryTopLevel_Keyboard
local zo_ChatWindow                         = ZO_ChatWindow
--Other addon variables
---LibCustomMenu
local libCustomMenuSubmenu = LibCustomMenuSubmenu --The control holding the currently shown submenu control entries (as a submenu is opened)
local LCM_SubmenuEntryNamePrefix = "ZO_SubMenuItem" --row name of a ZO_Menu's submenu entrxy added by LibCustomMenu to the parent control LibCustomMenuSubmenu
local zo_MenuSubmenuItemsHooked = {} --Items hooked by this code, to add a special OnMouseUp handler.
local checkboxesAtSubmenuCurrentState = {} --Save the current checkboxes state (on/off) for a submenu opening control, so we can toggle all checkboxes in the submenu properly
--BMU variables
local BMU_textures                          = BMU.textures
----functions
--ZOs functions
local zoPlainStrFind = zo_plainstrfind
local zo_IsTableEmpty = ZO_IsTableEmpty
local zo_CheckButton_IsChecked = ZO_CheckButton_IsChecked
local zo_CheckButton_SetCheckState = ZO_CheckButton_SetCheckState
local zo_CheckButton_IsEnabled = ZO_CheckButton_IsEnabled
local zo_CheckButton_SetChecked = ZO_CheckButton_SetChecked
--BMU functions
local BMU_SI_get                            = SI.get
local BMU_colorizeText                      = BMU.colorizeText
local BMU_round                             = BMU.round
local BMU_tooltipTextEnter                  = BMU.tooltipTextEnter

----variables (defined inline in code below, upon first usage, as they are still nil at this line)
----functions (defined inline in code below, upon first usage, as they are still nil at this line)
local BMU_getItemTypeIcon, BMU_getDataMapInfo, BMU_OpenTeleporter, BMU_updateContextMenuEntrySurveyAll,
      BMU_getContextMenuEntrySurveyAllAppendix, BMU_clearInputFields, BMU_getIndexFromValue
-- -^- INS251229 Baertram END 0

-- list of tuples (guildId & displayname) for invite queue (only for admin)
local inviteQueue = {}


function BMU.getStringIsInstalledLibrary(addonName)
	local stringInstalled = BMU_colorizeText("installed and enabled", "green")
	local stringNotInstalled = BMU_colorizeText("not installed or disabled", "red")
	
	-- PortToFriendsHouse
	if string.lower(addonName) == "ptf" then
		if PortToFriend and PortToFriend.GetFavorites then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end

	-- LibSets
	if string.lower(addonName) == "libsets" then
		if BMU.LibSets and BMU.LibSets.GetNumItemSetCollectionZoneUnlockedPieces then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end
	
	-- LibMapPing
	if string.lower(addonName) == "libmapping" then
		if BMU.LibMapPing then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end

	-- LibSlashCommander
	if string.lower(addonName) == "lsc" then
		if BMU.LSC then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end

	-- LibChatMenuButton
	if string.lower(addonName) == "lcmb" then
		if BMU.LCMB then
			return stringInstalled
		else
			return stringNotInstalled
		end
	end
	
	-- GamePadMode "IsJustaBmuGamepadPlugin"
	if string.lower(addonName) == "gamepad" then
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
local textPattern = "%s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d   %s: %d" --INS251229 Baertram Memory and performance improvement: Do not redefine same string again and again on each function call!
function BMU.updateRelatedItemsCounterPanel()
	local counterPanel = BMU.counterPanel   --INS251229 Baertram
    local svAcc = BMU.savedVarsAcc          --INS251229 Baertram
    local scale = svAcc.Scale               --INS251229 Baertram
    BMU_getDataMapInfo = BMU_getDataMapInfo or BMU.getDataMapInfo --INS251229 Baertram calling same function in 2x nested loop below -> Significant performance improvement!
    BMU_getItemTypeIcon = BMU_getItemTypeIcon or BMU.getItemTypeIcon --INS251229 Baertram Performance reference for multiple same used function below

	local counter_table = {
		["alchemist"] = 0,
		["enchanter"] = 0,
		["woodworker"] = 0,
		["blacksmith"] = 0,
		["clothier"] = 0,
		["jewelry"] = 0,
		["treasure"] = 0,
		["leads"] = 0,
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
			counter_table["leads"] = counter_table["leads"] + 1
		end
		antiquityId = GetNextAntiquityId(antiquityId)
	end

	-- set dimension of the icons accordingly to the scale level
	local dimension = 28 * scale --CHG251229 Baertram

	-- build argument list
	local arguments_list = {
		BMU_getItemTypeIcon("alchemist", dimension), counter_table["alchemist"],    --CHG251229 Baertram
		BMU_getItemTypeIcon("enchanter", dimension), counter_table["enchanter"],    --CHG251229 Baertram
		BMU_getItemTypeIcon("woodworker", dimension), counter_table["woodworker"],  --CHG251229 Baertram
		BMU_getItemTypeIcon("blacksmith", dimension), counter_table["blacksmith"],  --CHG251229 Baertram
		BMU_getItemTypeIcon("clothier", dimension), counter_table["clothier"],      --CHG251229 Baertram
		BMU_getItemTypeIcon("jewelry", dimension), counter_table["jewelry"],        --CHG251229 Baertram
		BMU_getItemTypeIcon("treasure", dimension), counter_table["treasure"],      --CHG251229 Baertram
		BMU_getItemTypeIcon("leads", dimension), counter_table["leads"]             --CHG251229 Baertram
	}
	
	local text = string.format(textPattern, unpack(arguments_list))                 --CHG251229 Baertram
	counterPanel:SetText(text)                                                      --CHG251229 Baertram
	-- update position (number of lines may have changed)
	counterPanel:ClearAnchors()                                                     --CHG251229 Baertram
	counterPanel:SetAnchor(TOP, BMU.win.Main_Control, TOP, 1*scale, (90*scale)+((svAcc.numberLines*40)*scale))  --CHG251229 Baertram
end


local function SetupUI()
    local svAcc = BMU.savedVarsAcc                                      --INS251229 Baertram
    local scale = svAcc.Scale                                           --INS251229 Baertram
    BMU_clearInputFields = BMU_clearInputFields or BMU.clearInputFields --INS251229 Baertram

	-----------------------------------------------
	-- Fonts
	
	-- default font
	local fontSize = BMU_round(17*scale, 0)   --CHG251229 Baertram
	local fontStyle = ZoFontGame:GetFontInfo()
	local fontWeight = "soft-shadow-thin"
	BMU.font1 = string.format("%s|$(KB_%s)|%s", fontStyle, fontSize, fontWeight)
	
	-- font of statistics
	fontSize = BMU_round(13*scale, 0)       --CHG251229 Baertram
	fontStyle = ZoFontBookTablet:GetFontInfo()
	--fontStyle = "EsoUI/Common/Fonts/consola.ttf"
	fontWeight = "soft-shadow-thin"
	BMU.font2 = string.format("%s|$(KB_%s)|%s", fontStyle, fontSize, fontWeight)
	
	-----------------------------------------------
    local teleporterWin = BMU.win

    -----------------------------------------------
	
	-- Button on Chat Window
	if BMU.savedVarsAcc.chatButton then
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
			local BMU_chatButtonTex = wm:CreateControl("Teleporter_CHAT_MENU_BUTTON", zo_ChatWindow, CT_TEXTURE) --CHG251229 Baertram Performance improvedment for multiple used variable
            BMU.chatButtonTex = BMU_chatButtonTex --INS251229 Baertram
			BMU_chatButtonTex:SetDimensions(33, 33)  --CHG251229 Baertram
			BMU_chatButtonTex:SetAnchor(TOPRIGHT, zo_ChatWindow, TOPRIGHT, -40 - BMU.savedVarsAcc.chatButtonHorizontalOffset, 6) --CHG251229 Baertram
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
	
	-----------------------------------------------
	
	-----------------------------------------------
	-- Bandits Integration -> Add custom button to the side bar (with delay to ensure, that BUI is loaded)
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
	-----------------------------------------------

  --------------------------------------------------------------------------------------------------------------
  --Main Controller. Please notice that teleporterWin comes from our globals variables, as does wm
  --------------------------------------------------------------------------------------------------------------
  local teleporterWin_Main_Control = wm:CreateTopLevelWindow("Teleporter_Location_MainController") --INS251229 Baertram performance improvement for multiple used variable reference
  teleporterWin.Main_Control = teleporterWin_Main_Control --INS251229 Baertram

  teleporterWin_Main_Control:SetMouseEnabled(true) --CHG251229 Baertram
  teleporterWin_Main_Control:SetDimensions(500*scale,400*scale) --CHG251229 Baertram
  teleporterWin_Main_Control:SetHidden(true) --CHG251229 Baertram

  teleporterWin.appTitle =  wm:CreateControl("Teleporter_appTitle", teleporterWin_Main_Control, CT_LABEL) --CHG251229 Baertram
  teleporterWin.appTitle:SetFont(BMU.font1) --CHG251229 Baertram
  teleporterWin.appTitle:SetColor(255, 255, 255, 1) --CHG251229 Baertram
  teleporterWin.appTitle:SetText(BMU_colorizeText(appName, "gold") .. BMU_colorizeText(" - Teleporter", "white")) --CHG251229 Baertram
  --teleporterWin.appTitle:SetAnchor(TOP, teleporterWin_Main_Control, TOP, -31*BMU.savedVarsAcc.Scale, -62*BMU.savedVarsAcc.Scale) --CHG251229 Baertram
  teleporterWin.appTitle:SetAnchor(CENTER, teleporterWin_Main_Control, TOP, nil, -62*scale) --CHG251229 Baertram
  
  ----- This is where we create the list element for TeleUnicorn/ List
  BMU.TeleporterList = BMU.ListView.new(teleporterWin_Main_Control,  {
    width = 750*scale, --CHG251229 Baertram
    height = 500*scale, --CHG251229 Baertram
  })
  
  ---------

  
    -------------------------------------------------------------------
  -- Switch BUTTON ON ZoneGuide window
  local teleporterWin_zoneGuideSwapTexture = wm:CreateControl(nil, zo_WorldMapZoneStoryTopLevel_Keyboard, CT_TEXTURE) --CHG251229 Baertram Performance improvement
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

  ---------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------
  -- Feedback BUTTON
  local teleporterWin_feedbackTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)  --INS251229 Baertram
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
  
      -------------------------------------------------------------------
  -- Guild BUTTON
  -- display button only if guilds are available on players game server
	if teleporterVars.BMUGuilds[worldName] ~= nil then --CHG251229 Baertram
		local teleporterWin_guildTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
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
			zo_callLater(function() BMU.createTableGuilds() end, 350)
		end)
			  
		teleporterWin_guildTexture:SetHandler("OnMouseEnter", function(self)
		  teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtnOver)
		  BMU:tooltipTextEnter(teleporterWin_guildTexture,
			BMU_SI_get(SI.TELE_UI_BTN_GUILD_BMU))
		end)

		teleporterWin_guildTexture:SetHandler("OnMouseExit", function(self)
		  BMU:tooltipTextEnter(teleporterWin_guildTexture)
		  if BMU.state ~= BMU.indexListGuilds then
			teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtn)
		  end
		end)
	end
  
  
      -------------------------------------------------------------------
  -- Guild House BUTTON
  -- display button only if guild house is available on players game server
  if BMU.var.guildHouse[worldName] ~= nil then
	  teleporterWin.guildHouseTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
	  teleporterWin.guildHouseTexture:SetDimensions(40*scale, 40*scale)
	  teleporterWin.guildHouseTexture:SetAnchor(TOPLEFT, teleporterWin_Main_Control, TOPLEFT, TOPLEFT+55*scale, -75*scale)
	  teleporterWin.guildHouseTexture:SetTexture(BMU_textures.guildHouseBtn)
	  teleporterWin.guildHouseTexture:SetMouseEnabled(true)
  
	  teleporterWin.guildHouseTexture:SetHandler("OnMouseUp", function()
		  BMU.portToBMUGuildHouse()
		end)
		  
	  teleporterWin.guildHouseTexture:SetHandler("OnMouseEnter", function(self)
		  teleporterWin.guildHouseTexture:SetTexture(BMU_textures.guildHouseBtnOver)
		  BMU:tooltipTextEnter(teleporterWin.guildHouseTexture,
			  BMU_SI_get(SI.TELE_UI_BTN_GUILD_HOUSE_BMU))
	  end)

	  teleporterWin.guildHouseTexture:SetHandler("OnMouseExit", function(self)
		  teleporterWin.guildHouseTexture:SetTexture(BMU_textures.guildHouseBtn)
		  BMU:tooltipTextEnter(teleporterWin.guildHouseTexture)
	  end)
  end
  
  
  -------------------------------------------------------------------
	-- Lock/Fix window BUTTON
	local lockTexture

	teleporterWin.fixWindowTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
	teleporterWin.fixWindowTexture:SetDimensions(50*scale, 50*scale)
	teleporterWin.fixWindowTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, TOPRIGHT-65*scale, -75*scale)
	-- decide which texture to show
	if BMU.savedVarsAcc.fixedWindow == true then
		lockTexture = BMU_textures.lockClosedBtn
	else
		lockTexture = BMU_textures.lockOpenBtn
	end
	teleporterWin.fixWindowTexture:SetTexture(lockTexture)
	teleporterWin.fixWindowTexture:SetMouseEnabled(true)
 
	teleporterWin.fixWindowTexture:SetHandler("OnMouseUp", function()
		-- change setting
		BMU.savedVarsAcc.fixedWindow = not BMU.savedVarsAcc.fixedWindow
		-- fix/unfix window
		BMU.control_global.bd:SetMovable(not BMU.savedVarsAcc.fixedWindow)
		-- change texture
		if BMU.savedVarsAcc.fixedWindow then
			-- show closed lock over
			lockTexture = BMU_textures.lockClosedBtnOver
		else
			-- show open lock over
			lockTexture = BMU_textures.lockOpenBtnOver
		end
		teleporterWin.fixWindowTexture:SetTexture(lockTexture)
	end)
	
	teleporterWin.fixWindowTexture:SetHandler("OnMouseEnter", function(self)
		if BMU.savedVarsAcc.fixedWindow then
			-- show closed lock over
			lockTexture = BMU_textures.lockClosedBtnOver
		else
			-- show open lock over
			lockTexture = BMU_textures.lockOpenBtnOver
		end
		teleporterWin.fixWindowTexture:SetTexture(lockTexture)
		BMU:tooltipTextEnter(teleporterWin.fixWindowTexture,BMU_SI_get(SI.TELE_UI_BTN_FIX_WINDOW))
	end)

	teleporterWin.fixWindowTexture:SetHandler("OnMouseExit", function(self)
		if BMU.savedVarsAcc.fixedWindow then
			-- show closed lock
			lockTexture = BMU_textures.lockClosedBtn
		else
			-- show open lock
			lockTexture = BMU_textures.lockOpenBtn
		end
		teleporterWin.fixWindowTexture:SetTexture(lockTexture)
		BMU:tooltipTextEnter(teleporterWin.fixWindowTexture)
	end)


  ---------------------------------------------------------------------------------------------------------------
  -- ANCHOR BUTTON

  teleporterWin.anchorTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin.anchorTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin.anchorTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, TOPRIGHT-20*scale, -75*scale)
  teleporterWin.anchorTexture:SetTexture(BMU_textures.anchorMapBtn)
  teleporterWin.anchorTexture:SetMouseEnabled(true)
  
  teleporterWin.anchorTexture:SetHandler("OnMouseUp", function()
	BMU.savedVarsAcc.anchorOnMap = not BMU.savedVarsAcc.anchorOnMap
    BMU.updatePosition()
  end)
	  
  teleporterWin.anchorTexture:SetHandler("OnMouseEnter", function(self)
	teleporterWin.anchorTexture:SetTexture(BMU_textures.anchorMapBtnOver)
      BMU:tooltipTextEnter(teleporterWin.anchorTexture,
          BMU_SI_get(SI.TELE_UI_BTN_ANCHOR_ON_MAP))
  end)

  teleporterWin.anchorTexture:SetHandler("OnMouseExit", function(self)
	if not BMU.savedVarsAcc.anchorOnMap then
		teleporterWin.anchorTexture:SetTexture(BMU_textures.anchorMapBtn)
	end
      BMU:tooltipTextEnter(teleporterWin.anchorTexture)
  end)

  
  -------------------------------------------------------------------
  -- CLOSE / SWAP BUTTON

  teleporterWin.closeTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin.closeTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin.closeTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, TOPRIGHT+25*scale, -75*scale)
  teleporterWin.closeTexture:SetTexture(BMU_textures.closeBtn)
  teleporterWin.closeTexture:SetMouseEnabled(true)
  teleporterWin.closeTexture:SetDrawLayer(2)

  teleporterWin.closeTexture:SetHandler("OnMouseUp", function()
      BMU.HideTeleporter()  end)
	  
  teleporterWin.closeTexture:SetHandler("OnMouseEnter", function(self)
	teleporterWin.closeTexture:SetTexture(BMU_textures.closeBtnOver)
      BMU:tooltipTextEnter(teleporterWin.closeTexture,
          GetString(SI_DIALOG_CLOSE))
  end)

  teleporterWin.closeTexture:SetHandler("OnMouseExit", function(self)
      BMU:tooltipTextEnter(teleporterWin.closeTexture)
  end)


  -------------------------------------------------------------------
  -- OPEN BUTTON ON MAP (upper left corner)
  
	if BMU.savedVarsAcc.showOpenButtonOnMap then
		teleporterWin.MapOpen = CreateControlFromVirtual("TeleporterReopenButon", ZO_WorldMap, "ZO_DefaultButton")
		teleporterWin.MapOpen:SetAnchor(TOPLEFT)
		teleporterWin.MapOpen:SetWidth(200)
		teleporterWin.MapOpen:SetText(appName)
		teleporterWin.MapOpen:SetHidden(true)
  
		teleporterWin.MapOpen:SetHandler("OnClicked",function()
			BMU.OpenTeleporter(true)
		end)
	end

   ---------------------------------------------------------------------------------------------------------------
   -- Search Symbol (no button)
   
  teleporterWin.SearchTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin.SearchTexture:SetDimensions(25*scale, 25*scale)
  teleporterWin.SearchTexture:SetAnchor(TOPLEFT, teleporterWin_Main_Control, TOPLEFT, TOPLEFT-35*scale, -10*scale)

  teleporterWin.SearchTexture:SetTexture(BMU_textures.searchBtn)
  
  ---------------------------------------------------------------------------------------------------------------
  -- Searcher (Search for Players)
  
   teleporterWin.Searcher_Player = CreateControlFromVirtual("Teleporter_SEARCH_EDITBOX",  teleporterWin_Main_Control, "ZO_DefaultEditForBackdrop")
   teleporterWin.Searcher_Player:SetParent(teleporterWin_Main_Control)
   teleporterWin.Searcher_Player:SetSimpleAnchorParent(10*scale,-10*scale)
   teleporterWin.Searcher_Player:SetDimensions(105*scale,25*scale)
   teleporterWin.Searcher_Player:SetResizeToFitDescendents(false)
   teleporterWin.Searcher_Player:SetFont(BMU.font1)

	-- Placeholder
  	teleporterWin.Searcher_Player.Placeholder = wm:CreateControl("Teleporter_SEARCH_EDITBOX_Placeholder", teleporterWin.Searcher_Player, CT_LABEL)
    teleporterWin.Searcher_Player.Placeholder:SetSimpleAnchorParent(4*scale,0)
	teleporterWin.Searcher_Player.Placeholder:SetFont(BMU.font1)
	teleporterWin.Searcher_Player.Placeholder:SetText(BMU_colorizeText(GetString(SI_PLAYER_MENU_PLAYER), "lgray"))
    
  -- BackGround
  teleporterWin.SearchBG = wm:CreateControlFromVirtual(" teleporterWin.SearchBG",  teleporterWin.Searcher_Player, "ZO_DefaultBackdrop")
  teleporterWin.SearchBG:ClearAnchors()
  teleporterWin.SearchBG:SetAnchorFill(teleporterWin.Searcher_Player)
  teleporterWin.SearchBG:SetDimensions(teleporterWin.Searcher_Player:GetWidth(),  teleporterWin.Searcher_Player:GetHeight())
  teleporterWin.SearchBG.controlType = CT_CONTROL
  teleporterWin.SearchBG.system = SETTING_TYPE_UI
  teleporterWin.SearchBG:SetHidden(false)
  teleporterWin.SearchBG:SetMouseEnabled(false)
  teleporterWin.SearchBG:SetMovable(false)
  teleporterWin.SearchBG:SetClampedToScreen(true)
  
  -- Handlers
  ZO_PreHookHandler(teleporterWin.Searcher_Player, "OnTextChanged", function(self)
	if self:HasFocus() and (teleporterWin.Searcher_Player:GetText() ~= "" or (teleporterWin.Searcher_Player:GetText() == "" and BMU.state == BMU.indexListSearchPlayer)) then
		-- make sure player placeholder is hidden
		teleporterWin.Searcher_Player.Placeholder:SetHidden(true)
		-- clear zone input field
		teleporterWin.Searcher_Zone:SetText("")
		-- show zone placeholder
		teleporterWin.Searcher_Zone.Placeholder:SetHidden(false)
		BMU.createTable({index=BMU.indexListSearchPlayer, inputString=teleporterWin.Searcher_Player:GetText()})
	end
  end)
  
  teleporterWin.Searcher_Player:SetHandler("OnFocusGained", function(self)
	teleporterWin.Searcher_Player.Placeholder:SetHidden(true)
  end)
  
  teleporterWin.Searcher_Player:SetHandler("OnFocusLost", function(self)
	if teleporterWin.Searcher_Player:GetText() == "" then
		teleporterWin.Searcher_Player.Placeholder:SetHidden(false)
	end
  end)

  ---------------------------------------------------------------------------------------------------------------
  -- Searcher (Search for zones)

  teleporterWin.Searcher_Zone = CreateControlFromVirtual("Teleporter_Searcher_Player_EDITBOX1",  teleporterWin_Main_Control, "ZO_DefaultEditForBackdrop")
  teleporterWin.Searcher_Zone:SetParent(teleporterWin_Main_Control)
  teleporterWin.Searcher_Zone:SetSimpleAnchorParent(140*scale,-10*scale)
  teleporterWin.Searcher_Zone:SetDimensions(105*scale,25*scale)
  teleporterWin.Searcher_Zone:SetResizeToFitDescendents(false)
  teleporterWin.Searcher_Zone:SetFont(BMU.font1)
  
  -- Placeholder
  teleporterWin.Searcher_Zone.Placeholder = wm:CreateControl("TTeleporter_Searcher_Player_EDITBOX1_Placeholder", teleporterWin.Searcher_Zone, CT_LABEL)
  teleporterWin.Searcher_Zone.Placeholder:SetSimpleAnchorParent(4*scale,0*scale)
  teleporterWin.Searcher_Zone.Placeholder:SetFont(BMU.font1)
  teleporterWin.Searcher_Zone.Placeholder:SetText(BMU_colorizeText(GetString(SI_CHAT_CHANNEL_NAME_ZONE), "lgray"))

  -- BG
  teleporterWin.SearchBG_Player = wm:CreateControlFromVirtual(" teleporterWin.SearchBG_Zone",  teleporterWin.Searcher_Zone, "ZO_DefaultBackdrop")
  teleporterWin.SearchBG_Player:ClearAnchors()
  teleporterWin.SearchBG_Player:SetAnchorFill( teleporterWin.Searcher_Zone)
  teleporterWin.SearchBG_Player:SetDimensions( teleporterWin.Searcher_Zone:GetWidth(),  teleporterWin.Searcher_Zone:GetHeight())
  teleporterWin.SearchBG_Player.controlType = CT_CONTROL
  teleporterWin.SearchBG_Player.system = SETTING_TYPE_UI
  teleporterWin.SearchBG_Player:SetHidden(false)
  teleporterWin.SearchBG_Player:SetMouseEnabled(false)
  teleporterWin.SearchBG_Player:SetMovable(false)
  teleporterWin.SearchBG_Player:SetClampedToScreen(true)
  
  -- Handlers
    ZO_PreHookHandler(teleporterWin.Searcher_Zone, "OnTextChanged", function(self)
		if self:HasFocus() and (teleporterWin.Searcher_Zone:GetText() ~= "" or (teleporterWin.Searcher_Zone:GetText() == "" and BMU.state == BMU.indexListSearchZone)) then
			-- make sure zone placeholder is hidden
			teleporterWin.Searcher_Zone.Placeholder:SetHidden(true)
			-- clear player input field
			teleporterWin.Searcher_Player:SetText("")
			-- show player placeholder
			teleporterWin.Searcher_Player.Placeholder:SetHidden(false)
			if BMU.state == BMU.indexListDungeons then
				BMU.createTableDungeons({inputString=teleporterWin.Searcher_Zone:GetText()})
			else
				BMU.createTable({index=BMU.indexListSearchZone, inputString=teleporterWin.Searcher_Zone:GetText()})
			end
		end
	end)
	
	teleporterWin.Searcher_Zone:SetHandler("OnFocusGained", function(self)
		teleporterWin.Searcher_Zone.Placeholder:SetHidden(true)
	end)
  
	teleporterWin.Searcher_Zone:SetHandler("OnFocusLost", function(self)
		if teleporterWin.Searcher_Zone:GetText() == "" then
			teleporterWin.Searcher_Zone.Placeholder:SetHidden(false)
		end
	end)


  ---------------------------------------------------------------------------------------------------------------
  -- Refresh Button
  
  teleporterWin_Main_Control.RefreshTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.RefreshTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.RefreshTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -80*scale, -5*scale)
  teleporterWin_Main_Control.RefreshTexture:SetTexture(BMU_textures.refreshBtn)
  teleporterWin_Main_Control.RefreshTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.RefreshTexture:SetDrawLayer(2)

  teleporterWin_Main_Control.RefreshTexture:SetHandler("OnMouseUp", function(self)
		if BMU.state == BMU.indexListMain then
			-- dont reset slider if user stays already on main list
			BMU.createTable({index=BMU.indexListMain, dontResetSlider=true})
		else
			BMU.createTable({index=BMU.indexListMain})
		end
  end)
  
  teleporterWin_Main_Control.RefreshTexture:SetHandler("OnMouseEnter", function(self)
      BMU:tooltipTextEnter(teleporterWin_Main_Control.RefreshTexture,
          BMU_SI_get(SI.TELE_UI_BTN_REFRESH_ALL))
      teleporterWin_Main_Control.RefreshTexture:SetTexture(BMU_textures.refreshBtnOver)end)

  teleporterWin_Main_Control.RefreshTexture:SetHandler("OnMouseExit", function(self)
      BMU:tooltipTextEnter(teleporterWin_Main_Control.RefreshTexture)
      teleporterWin_Main_Control.RefreshTexture:SetTexture(BMU_textures.refreshBtn)end)


  ---------------------------------------------------------------------------------------------------------------
  -- Unlock wayshrines

  teleporterWin_Main_Control.portalToAllTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.portalToAllTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.portalToAllTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -40*scale, -5*scale)
  teleporterWin_Main_Control.portalToAllTexture:SetTexture(BMU_textures.wayshrineBtn2)
  teleporterWin_Main_Control.portalToAllTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.portalToAllTexture:SetDrawLayer(2)
  
	teleporterWin_Main_Control.portalToAllTexture:SetHandler("OnMouseUp", function(self, button)
		BMU.showDialogAutoUnlock()
	end)
  
  teleporterWin_Main_Control.portalToAllTexture:SetHandler("OnMouseEnter", function(self)
	teleporterWin_Main_Control.portalToAllTexture:SetTexture(BMU_textures.wayshrineBtnOver2)
		local tooltipTextCompletion = ""
		if BMU.isZoneOverlandZone() then
			-- add wayshrine discovery info from ZoneGuide
			-- Attention: if the user is in Artaeum, he will see the total number of wayshrines (inclusive Summerset)
			-- however, when starting the auto unlock the function getZoneWayshrineCompletion() will check which wayshrines are really located on this map
			local zoneWayhsrineDiscoveryInfo, zoneWayshrineDiscovered, zoneWayshrineTotal = BMU.getZoneGuideDiscoveryInfo(GetZoneId(GetUnitZoneIndex("player")), ZONE_COMPLETION_TYPE_WAYSHRINES)
			if zoneWayhsrineDiscoveryInfo ~= nil then
				tooltipTextCompletion = "(" .. zoneWayshrineDiscovered .. "/" .. zoneWayshrineTotal .. ")"
				if zoneWayshrineDiscovered >= zoneWayshrineTotal then
					tooltipTextCompletion = BMU_colorizeText(tooltipTextCompletion, "green")
				end
			end
		end
		-- display number of unlocked wayshrines in current zone
		BMU:tooltipTextEnter(teleporterWin_Main_Control.portalToAllTexture, BMU_SI_get(SI.TELE_UI_BTN_UNLOCK_WS) .. " " .. tooltipTextCompletion)
	end)

  teleporterWin_Main_Control.portalToAllTexture:SetHandler("OnMouseExit", function(self)
	teleporterWin_Main_Control.portalToAllTexture:SetTexture(BMU_textures.wayshrineBtn2)
	BMU:tooltipTextEnter(teleporterWin_Main_Control.portalToAllTexture)
  end)
  
  
  ---------------------------------------------------------------------------------------------------------------
  -- Settings
  
  teleporterWin_Main_Control.SettingsTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.SettingsTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.SettingsTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, 0, -5*scale)
  teleporterWin_Main_Control.SettingsTexture:SetTexture(BMU_textures.settingsBtn)
  teleporterWin_Main_Control.SettingsTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.SettingsTexture:SetDrawLayer(2)

  teleporterWin_Main_Control.SettingsTexture:SetHandler("OnMouseUp", function(self)
	BMU.HideTeleporter()
	LAM2:OpenToPanel(BMU.SettingsPanel)
  end)
  
  teleporterWin_Main_Control.SettingsTexture:SetHandler("OnMouseEnter", function(self)
      BMU:tooltipTextEnter(teleporterWin_Main_Control.SettingsTexture,
          GetString(SI_GAME_MENU_SETTINGS))
      teleporterWin_Main_Control.SettingsTexture:SetTexture(BMU_textures.settingsBtnOver)
  end)

  teleporterWin_Main_Control.SettingsTexture:SetHandler("OnMouseExit", function(self)
      BMU:tooltipTextEnter(teleporterWin_Main_Control.SettingsTexture)
      teleporterWin_Main_Control.SettingsTexture:SetTexture(BMU_textures.settingsBtn)
  end)
	  

  ---------------------------------------------------------------------------------------------------------------
  -- "Port to Friends House" Integration
  
  teleporterWin_Main_Control.PTFTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.PTFTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.PTFTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -250*scale, 40*scale)
  teleporterWin_Main_Control.PTFTexture:SetTexture(BMU_textures.ptfHouseBtn)
  teleporterWin_Main_Control.PTFTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.PTFTexture:SetDrawLayer(2)
    local PortToFriend = PortToFriend --INS251229 Baertram performance improvement for 2 same used global variables
	if PortToFriend and PortToFriend.GetFavorites then
		-- enable tab	
		teleporterWin_Main_Control.PTFTexture:SetHandler("OnMouseUp", function(self, button, upInside) --CHG251229 Baertram Usage of upInside to properly check the user releaased the mouse on the control!!!
			if upInside and button == MOUSE_BUTTON_INDEX_RIGHT then --CHG251229 Baertram Usage of upInside to properly check the user releaased the mouse on the control!!!
				-- toggle between zone names and house names
                local BMU_savedVarsChar = BMU.savedVarsChar --INS251229 Baertram Performance gain for multiple used samed variable
				ClearMenu()
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
  
		teleporterWin_Main_Control.PTFTexture:SetHandler("OnMouseEnter", function(self)
			BMU:tooltipTextEnter(teleporterWin_Main_Control.PTFTexture,
				BMU_SI_get(SI.TELE_UI_BTN_PTF_INTEGRATION) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
			teleporterWin_Main_Control.PTFTexture:SetTexture(BMU_textures.ptfHouseBtnOver)
		end)

		teleporterWin_Main_Control.PTFTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin_Main_Control.PTFTexture)
			if BMU.state ~= BMU.indexListPTFHouses then
				teleporterWin_Main_Control.PTFTexture:SetTexture(BMU_textures.ptfHouseBtn)
			end
		end)
	else
		-- disable tab
		teleporterWin_Main_Control.PTFTexture:SetAlpha(0.4)
		
		teleporterWin_Main_Control.PTFTexture:SetHandler("OnMouseUp", function()
			BMU.showDialogSimple("PTFIntegrationMissing", BMU_SI_get(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE), BMU_SI_get(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY), function() RequestOpenUnsafeURL("https://www.esoui.com/downloads/info1758-PorttoFriendsHouse.html") end, nil)
		end)
		
		teleporterWin_Main_Control.PTFTexture:SetHandler("OnMouseEnter", function(self)
			BMU:tooltipTextEnter(teleporterWin_Main_Control.PTFTexture, BMU_SI_get(SI.TELE_UI_BTN_PTF_INTEGRATION))
		end)
		
		teleporterWin_Main_Control.PTFTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin_Main_Control.PTFTexture)
		end)
	end
	  
  ---------------------------------------------------------------------------------------------------------------
  -- Own Houses
  
  teleporterWin_Main_Control.OwnHouseTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.OwnHouseTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.OwnHouseTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -205*scale, 40*scale)
  teleporterWin_Main_Control.OwnHouseTexture:SetTexture(BMU_textures.houseBtn)
  teleporterWin_Main_Control.OwnHouseTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.OwnHouseTexture:SetDrawLayer(2)

  teleporterWin_Main_Control.OwnHouseTexture:SetHandler("OnMouseUp", function(self, button)
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		ClearMenu()
		
		-- toggle between nicknames and standard names
		local menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_UI_TOGGLE_HOUSE_NICKNAME), function() BMU.savedVarsChar.houseNickNames = not BMU.savedVarsChar.houseNickNames BMU_clearInputFields() BMU.createTableHouses() end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.houseNickNames then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)

		-- make default tab
		menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListOwnHouses then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListOwnHouses end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.defaultTab == BMU.indexListOwnHouses then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		ShowMenu()
	else
        BMU_clearInputFields( )
		BMU.createTableHouses()
	end
  end)
  
  teleporterWin_Main_Control.OwnHouseTexture:SetHandler("OnMouseEnter", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.OwnHouseTexture,
		BMU_SI_get(SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin_Main_Control.OwnHouseTexture:SetTexture(BMU_textures.houseBtnOver)
  end)

  teleporterWin_Main_Control.OwnHouseTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.OwnHouseTexture)
	if BMU.state ~= BMU.indexListOwnHouses then
		teleporterWin_Main_Control.OwnHouseTexture:SetTexture(BMU_textures.houseBtn)
	end
  end)

  
    ---------------------------------------------------------------------------------------------------------------
  -- Related Quests
  
  teleporterWin_Main_Control.QuestTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.QuestTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.QuestTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -160*scale, 40*scale)
  teleporterWin_Main_Control.QuestTexture:SetTexture(BMU_textures.questBtn)
  teleporterWin_Main_Control.QuestTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.QuestTexture:SetDrawLayer(2)

  teleporterWin_Main_Control.QuestTexture:SetHandler("OnMouseUp", function(self, button)
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show context menu
		ClearMenu()
		-- make default tab
		local menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListQuests then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListQuests end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.defaultTab == BMU.indexListQuests then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end
		ShowMenu()
	else
		BMU.createTable({index=BMU.indexListQuests})
	end
  end)
  
  teleporterWin_Main_Control.QuestTexture:SetHandler("OnMouseEnter", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.QuestTexture,
		GetString(SI_JOURNAL_MENU_QUESTS) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin_Main_Control.QuestTexture:SetTexture(BMU_textures.questBtnOver)
  end)

  teleporterWin_Main_Control.QuestTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.QuestTexture)
	if BMU.state ~= BMU.indexListQuests then
		teleporterWin_Main_Control.QuestTexture:SetTexture(BMU_textures.questBtn)
	end
  end)
 
 
 ---------------------------------------------------------------------------------------------------------------
  -- Related Items
  
  teleporterWin_Main_Control.ItemTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.ItemTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.ItemTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -120*scale, 40*scale)
  teleporterWin_Main_Control.ItemTexture:SetTexture(BMU_textures.relatedItemsBtn)
  teleporterWin_Main_Control.ItemTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.ItemTexture:SetDrawLayer(2)

  -- -v- INS251229 Baertram BEGIN 1 Variables for the relevant submenu opening controls
  local submenuIndicesToAddCallbackTo = {}
  local BMU_ItemTexture
  --reference variables for performance etc.
  local BMU_updateCheckboxSurveyMap
  local function BMU_CreateTable_IndexListItems() --local function which is not redefined each contextMenu open again and again and again -> memory and performance drain!
    BMU.createTable({index=BMU.indexListItems})
  end
  -- -^- INS251229 Baertram END 1
  teleporterWin_Main_Control.ItemTexture:SetHandler("OnMouseUp", function(self, button)
      BMU_ItemTexture = BMU_ItemTexture or teleporterWin_Main_Control.ItemTexture               --INS251229 Baertram
      BMU_updateCheckboxSurveyMap = BMU_updateCheckboxSurveyMap or BMU.updateCheckboxSurveyMap  --INS251229 Baertram
	  submenuIndicesToAddCallbackTo = {}                                                        --INS251229 Baertram
      if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show filter menu
		ClearMenu()

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
			
		if BMU.numOfSurveyTypesChecked() > 0 then
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
  BMU_ItemTexture = BMU_ItemTexture or teleporterWin_Main_Control.ItemTexture

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
      if menuType ~= MENU_TYPE_DEFAULT or (owner == nil or owner ~= BMU_ItemTexture) or zo_IsTableEmpty(submenuIndicesToAddCallbackTo)
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
  
  teleporterWin_Main_Control.ItemTexture:SetHandler("OnMouseEnter", function(self)
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
	if BMU.numOfSurveyTypesChecked() > 0 then
		if tooltip ~= "" then
			tooltip = tooltip .. " + " .. GetString(SI_SPECIALIZEDITEMTYPE101)
		else
			tooltip = GetString(SI_SPECIALIZEDITEMTYPE101)
		end
	end
	-- add right-click info
	tooltip = tooltip .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU)
	
	-- show tooltip
    BMU:tooltipTextEnter(teleporterWin_Main_Control.ItemTexture, tooltip)
    -- button highlight
	teleporterWin_Main_Control.ItemTexture:SetTexture(BMU_textures.relatedItemsBtnOver)
  end)

  teleporterWin_Main_Control.ItemTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.ItemTexture)
	if BMU.state ~= BMU.indexListItems then
		teleporterWin_Main_Control.ItemTexture:SetTexture(BMU_textures.relatedItemsBtn)
	end
  end)

  -- Create counter panel that displays the counter for each type
  BMU.counterPanel = WINDOW_MANAGER:CreateControl(nil, BMU.win.Main_Control, CT_LABEL)
  BMU.counterPanel:SetFont(BMU.font1)
  BMU.counterPanel:SetHidden(true)

  ---------------------------------------------------------------------------------------------------------------
  -- Only current zone

  teleporterWin_Main_Control.OnlyYourzoneTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.OnlyYourzoneTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.OnlyYourzoneTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -80*scale, 40*scale)
  teleporterWin_Main_Control.OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtn)
  teleporterWin_Main_Control.OnlyYourzoneTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.OnlyYourzoneTexture:SetDrawLayer(2)
  
	teleporterWin_Main_Control.OnlyYourzoneTexture:SetHandler("OnMouseUp", function(self, button)
		if button == MOUSE_BUTTON_INDEX_RIGHT then
			-- show context menu
			ClearMenu()
			-- make default tab
			local menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListCurrentZone then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListCurrentZone end end, MENU_ADD_OPTION_CHECKBOX)
			if BMU.savedVarsChar.defaultTab == BMU.indexListCurrentZone then
				zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
			end
			ShowMenu()
		else
			BMU.createTable({index=BMU.indexListCurrentZone})
		end
	end)
  
    teleporterWin_Main_Control.OnlyYourzoneTexture:SetHandler("OnMouseEnter", function(self)
		BMU:tooltipTextEnter(teleporterWin_Main_Control.OnlyYourzoneTexture,
			GetString(SI_ANTIQUITY_SCRYABLE_CURRENT_ZONE_SUBCATEGORY) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
		teleporterWin_Main_Control.OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtnOver)
	end)
	
	teleporterWin_Main_Control.OnlyYourzoneTexture:SetHandler("OnMouseExit", function(self)
		BMU:tooltipTextEnter(teleporterWin_Main_Control.OnlyYourzoneTexture)
		if BMU.state ~= BMU.indexListCurrentZone then
			teleporterWin_Main_Control.OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtn)
		end
	end)
	
	
  ---------------------------------------------------------------------------------------------------------------
  -- Delves in current zone
  
  teleporterWin_Main_Control.DelvesTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.DelvesTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.DelvesTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, -40*scale, 40*scale)
  teleporterWin_Main_Control.DelvesTexture:SetTexture(BMU_textures.delvesBtn)
  teleporterWin_Main_Control.DelvesTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.DelvesTexture:SetDrawLayer(2)

  teleporterWin_Main_Control.DelvesTexture:SetHandler("OnMouseUp", function(self, button)
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show context menu
		ClearMenu()
		-- show all or only in current zone
		local menuIndex = AddCustomMenuItem(GetString(SI_GAMEPAD_GUILD_HISTORY_SUBCATEGORY_ALL), function() BMU.savedVarsChar.showAllDelves = not BMU.savedVarsChar.showAllDelves BMU.createTable({index=BMU.indexListDelves}) end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.showAllDelves then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end

		-- divider
		AddCustomMenuItem("-", function() end, nil, nil, nil, nil, 5)
		
		-- make default tab
		menuIndex = AddCustomMenuItem(BMU_SI_get(SI.TELE_SETTINGS_DEFAULT_TAB), function() if BMU.savedVarsChar.defaultTab == BMU.indexListDelves then BMU.savedVarsChar.defaultTab = BMU.indexListMain else BMU.savedVarsChar.defaultTab = BMU.indexListDelves end end, MENU_ADD_OPTION_CHECKBOX)
		if BMU.savedVarsChar.defaultTab == BMU.indexListDelves then
			zo_CheckButton_SetChecked(zo_Menu.items[menuIndex].checkbox)
		end
		ShowMenu()
	else
		BMU.createTable({index=BMU.indexListDelves})
	end
  end)
  
  teleporterWin_Main_Control.DelvesTexture:SetHandler("OnMouseEnter", function(self)
	local text = GetString(SI_ZONECOMPLETIONTYPE5)
	if not BMU.savedVarsChar.showAllDelves then
		text = text .. " - " .. GetString(SI_ANTIQUITY_SCRYABLE_CURRENT_ZONE_SUBCATEGORY)
	end
	BMU:tooltipTextEnter(teleporterWin_Main_Control.DelvesTexture,
		text .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin_Main_Control.DelvesTexture:SetTexture(BMU_textures.delvesBtnOver)
  end)

  teleporterWin_Main_Control.DelvesTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.DelvesTexture)
	if BMU.state ~= BMU.indexListDelves then
		teleporterWin_Main_Control.DelvesTexture:SetTexture(BMU_textures.delvesBtn)
	end
  end)
  
  
    ---------------------------------------------------------------------------------------------------------------
  -- DUNGEON FINDER
  
  teleporterWin_Main_Control.DungeonTexture = wm:CreateControl(nil, teleporterWin_Main_Control, CT_TEXTURE)
  teleporterWin_Main_Control.DungeonTexture:SetDimensions(50*scale, 50*scale)
  teleporterWin_Main_Control.DungeonTexture:SetAnchor(TOPRIGHT, teleporterWin_Main_Control, TOPRIGHT, 0*scale, 40*scale)
  teleporterWin_Main_Control.DungeonTexture:SetTexture(BMU_textures.soloArenaBtn)
  teleporterWin_Main_Control.DungeonTexture:SetMouseEnabled(true)
  teleporterWin_Main_Control.DungeonTexture:SetDrawLayer(2)

  teleporterWin_Main_Control.DungeonTexture:SetHandler("OnMouseUp", function(self, button)
	if button == MOUSE_BUTTON_INDEX_RIGHT then
		-- show filter menu
		ClearMenu()
		-- add filters
		AddCustomSubMenuItem(GetString(SI_GAMEPAD_BANK_FILTER_HEADER),
			{
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_ENDLESS_DUNGEONS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showEndlessDungeons = not BMU.savedVarsChar.dungeonFinder.showEndlessDungeons BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showEndlessDungeons end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_ARENAS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showArenas = not BMU.savedVarsChar.dungeonFinder.showArenas BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showArenas end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_GROUP_ARENAS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showGroupArenas = not BMU.savedVarsChar.dungeonFinder.showGroupArenas BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showGroupArenas end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_TRIALS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showTrials = not BMU.savedVarsChar.dungeonFinder.showTrials BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.showTrials end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_GROUP_DUNGEONS),
					callback = function() BMU.savedVarsChar.dungeonFinder.showDungeons = not BMU.savedVarsChar.dungeonFinder.showDungeons BMU.createTableDungeons() end,
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
						BMU.savedVarsChar.dungeonFinder.sortByReleaseASC = true
						BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC = false
						BMU.savedVarsChar.dungeonFinder.sortByAcronym = false
						BMU_clearInputFields()
						BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.sortByReleaseASC end,
				},
				-- sort by release: from new (top of list) to old
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_SORT_RELEASE) .. BMU_textures.arrowDown,
					callback = function()
						BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC = true
						BMU.savedVarsChar.dungeonFinder.sortByReleaseASC = false
						BMU.savedVarsChar.dungeonFinder.sortByAcronym = false
						BMU_clearInputFields()
						BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC end,
				},
				-- sort by acronym
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_SORT_ACRONYM),
					callback = function()
						BMU.savedVarsChar.dungeonFinder.sortByAcronym = true
						BMU.savedVarsChar.dungeonFinder.sortByReleaseASC = false
						BMU.savedVarsChar.dungeonFinder.sortByReleaseDESC = false
						BMU_clearInputFields()
						BMU.createTableDungeons() end,
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
					callback = function() BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName = not BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName BMU_clearInputFields() BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return not BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOGGLE_ACRONYM),
					callback = function() BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName = not BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName BMU_clearInputFields() BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.toggleShowAcronymUpdateName end,
				},
				{
					label = "-",
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOOGLE_DUNGEON_NAME),
					callback = function() BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName = not BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName BMU_clearInputFields() BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return not BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName end,
				},
				{
					label = BMU_SI_get(SI.TELE_UI_TOOGLE_ZONE_NAME),
					callback = function() BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName = not BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName BMU_clearInputFields() BMU.createTableDungeons() end,
					itemType = MENU_ADD_OPTION_CHECKBOX,
					checked = function() return BMU.savedVarsChar.dungeonFinder.toggleShowZoneNameDungeonName end,
				},
			}, nil, nil, nil, 5
		)
			
		-- add dungeon difficulty toggle
		if CanPlayerChangeGroupDifficulty() then
			local menuIndex = AddCustomMenuItem(BMU_textures.dungeonDifficultyVeteran .. GetString(SI_DUNGEONDIFFICULTY2), function() BMU.setDungeonDifficulty(not ZO_ConvertToIsVeteranDifficulty(ZO_GetEffectiveDungeonDifficulty())) zo_callLater(function() BMU.createTableDungeons() end, 300) end, MENU_ADD_OPTION_CHECKBOX, nil, nil, nil, 5)
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
		BMU.createTableDungeons()
	end
  end)
  
  teleporterWin_Main_Control.DungeonTexture:SetHandler("OnMouseEnter", function(self)
	BMU:tooltipTextEnter(teleporterWin_Main_Control.DungeonTexture,
		BMU_SI_get(SI.TELE_UI_BTN_DUNGEON_FINDER) .. BMU_SI_get(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU))
    teleporterWin_Main_Control.DungeonTexture:SetTexture(BMU_textures.soloArenaBtnOver)
  end)

  teleporterWin_Main_Control.DungeonTexture:SetHandler("OnMouseExit", function(self)
    BMU:tooltipTextEnter(teleporterWin_Main_Control.DungeonTexture)
	if BMU.state ~= BMU.indexListDungeons then
		teleporterWin_Main_Control.DungeonTexture:SetTexture(BMU_textures.soloArenaBtn)
	end
  end)
	  
end


function BMU.updateCheckboxSurveyMap(action)
	if action == 3 then
		-- check if at least one of the subTypes is checked
		if BMU.numOfSurveyTypesChecked() > 0 then
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
	BMU_updateContextMenuEntrySurveyAll = BMU_updateContextMenuEntrySurveyAll or BMU.updateContextMenuEntrySurveyAll --INS251229 Baertram
    BMU_updateContextMenuEntrySurveyAll() --CHG251229 Baertram
end


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
    local num = BMU_numOfSurveyTypesChecked()
	local baseString = string.sub(zo_Menu.items[BMU.menuIndexSurveyAll].item.nameLabel:GetText(), 1, -7)
	zo_Menu.items[BMU.menuIndexSurveyAll].item.nameLabel:SetText(baseString .. BMU_getContextMenuEntrySurveyAllAppendix()) --CHG251229 Baertram
end
BMU_updateContextMenuEntrySurveyAll = BMU.updateContextMenuEntrySurveyAll


function BMU.getContextMenuEntrySurveyAllAppendix()
	local num = BMU_numOfSurveyTypesChecked()
	local appendix = " (" .. num .. "/6)"
	return appendix
end
BMU_getContextMenuEntrySurveyAllAppendix = BMU.getContextMenuEntrySurveyAllAppendix --INS251229 Baertram


function BMU.updatePosition()
    local teleporterWin     = BMU.win
	if SCENE_MANAGER:IsShowing("worldMap") then
	
		-- show anchor button
		teleporterWin.anchorTexture:SetHidden(false)
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
			teleporterWin.anchorTexture:SetTexture(BMU_textures.anchorMapBtnOver)
		else
			-- use saved pos when map is open
			BMU.control_global.bd:ClearAnchors()
			BMU.control_global.bd:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LEFT + BMU.savedVarsAcc.pos_MapScene_x, BMU.savedVarsAcc.pos_MapScene_y)
			-- set fix/unfix state
			BMU.control_global.bd:SetMovable(not BMU.savedVarsAcc.fixedWindow)
			-- show fix/unfix button
			teleporterWin.fixWindowTexture:SetHidden(false)
			-- set anchor button texture
			teleporterWin.anchorTexture:SetTexture(BMU_textures.anchorMapBtn)
		end
	else
		-- hide anchor button
		teleporterWin.anchorTexture:SetHidden(true)
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
		teleporterWin.closeTexture:SetTexture(BMU_textures.swapBtn)
		teleporterWin.closeTexture:SetHandler("OnMouseEnter", function(self)
			teleporterWin.closeTexture:SetTexture(BMU_textures.swapBtnOver)
			BMU:tooltipTextEnter(teleporterWin.closeTexture,
				BMU_SI_get(SI.TELE_UI_BTN_TOGGLE_BMU))
		end)
		teleporterWin.closeTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin.closeTexture)
			teleporterWin.closeTexture:SetTexture(BMU_textures.swapBtn)
		end)
		
	else
		-- show normal close button
		-- set textures and handlers
		teleporterWin.closeTexture:SetTexture(BMU_textures.closeBtn)
		teleporterWin.closeTexture:SetHandler("OnMouseEnter", function(self)
		teleporterWin.closeTexture:SetTexture(BMU_textures.closeBtnOver)
			BMU:tooltipTextEnter(teleporterWin.closeTexture,
				GetString(SI_DIALOG_CLOSE))
		end)
		teleporterWin.closeTexture:SetHandler("OnMouseExit", function(self)
			BMU:tooltipTextEnter(teleporterWin.closeTexture)
			teleporterWin.closeTexture:SetTexture(BMU_textures.closeBtn)
		end)
	end
end


function BMU.clearInputFields()
    local teleporterWin = BMU.win
	-- Clear Input Field Player
	teleporterWin.Searcher_Player:SetText("")
	-- Show Placeholder
	teleporterWin.Searcher_Player.Placeholder:SetHidden(false)
	-- Clear Input Field Zone
	teleporterWin.Searcher_Zone:SetText("")
	-- Show Placeholder
	teleporterWin.Searcher_Zone.Placeholder:SetHidden(false)
end
BMU_clearInputFields = BMU.clearInputFields



-- display the correct persistent MouseOver depending on Button
-- also set global state for auto refresh
function BMU.changeState(index)

	BMU.printToChat("Changed - state: " .. tostring(index), BMU.MSG_DB)
    
	local teleporterWin = BMU.win

	-- first disable all MouseOver
    local teleporterWin_Main_Control = teleporterWin.Main_Control                           --INS251229 Baertram
	teleporterWin_Main_Control.ItemTexture:SetTexture(BMU_textures.relatedItemsBtn)
	teleporterWin_Main_Control.OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtn)
	teleporterWin_Main_Control.DelvesTexture:SetTexture(BMU_textures.delvesBtn)
	teleporterWin.SearchTexture:SetTexture(BMU_textures.searchBtn)
	teleporterWin_Main_Control.QuestTexture:SetTexture(BMU_textures.questBtn)
	teleporterWin_Main_Control.OwnHouseTexture:SetTexture(BMU_textures.houseBtn)
	teleporterWin_Main_Control.PTFTexture:SetTexture(BMU_textures.ptfHouseBtn)
	teleporterWin_Main_Control.DungeonTexture:SetTexture(BMU_textures.soloArenaBtn)
	local teleporterWin_guildTexture = teleporterWin.guildTexture
    if teleporterWin_guildTexture then                                                      --INS251229 Baertram
		teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtn)                        --INS251229 Baertram
	end
	-- hide counter panel for related items tab
	BMU.counterPanel:SetHidden(true)
	
	teleporterWin.Searcher_Player:SetHidden(false)

	-- check new state
	if index == BMU.indexListItems then
		-- related Items
		teleporterWin_Main_Control.ItemTexture:SetTexture(BMU_textures.relatedItemsBtnOver)
		if BMU.savedVarsChar.displayCounterPanel then
			BMU.counterPanel:SetHidden(false)
		end
	elseif index == BMU.indexListCurrentZone then
		-- current zone
		teleporterWin_Main_Control.OnlyYourzoneTexture:SetTexture(BMU_textures.currentZoneBtnOver)
	elseif index == BMU.indexListDelves then
		-- current zone delves
		teleporterWin_Main_Control.DelvesTexture:SetTexture(BMU_textures.delvesBtnOver)
	elseif index == BMU.indexListSearchPlayer or index == BMU.indexListSearchZone then
		-- serach by player name or zone name
		teleporterWin.SearchTexture:SetTexture(BMU_textures.searchBtnOver)
	elseif index == BMU.indexListQuests then
		-- related quests
		teleporterWin_Main_Control.QuestTexture:SetTexture(BMU_textures.questBtnOver)
	elseif index == BMU.indexListOwnHouses then
		-- own houses
		teleporterWin_Main_Control.OwnHouseTexture:SetTexture(BMU_textures.houseBtnOver)
	elseif index == BMU.indexListPTFHouses then
		-- PTF houses
		teleporterWin_Main_Control.PTFTexture:SetTexture(BMU_textures.ptfHouseBtnOver)
	elseif index == BMU.indexListGuilds then
		-- guilds
		if teleporterWin_guildTexture then
			teleporterWin_guildTexture:SetTexture(BMU_textures.guildBtnOver)
		end
	elseif index == BMU.indexListDungeons then
		-- dungeon finder
		teleporterWin_Main_Control.DungeonTexture:SetTexture(BMU_textures.soloArenaBtnOver)
		teleporterWin.Searcher_Player:SetHidden(true)
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
	local globalDialogName = BMU.var.appName .. dialogName
	
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
				local result = BMU.createTable({index=BMU.indexListSearchPlayer, inputString=playerTo, dontDisplay=true})
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
	for _, guildId in pairs(BMU.var.BMUGuilds[worldName]) do
		local guildData = GUILD_BROWSER_MANAGER:GetGuildData(guildId)
		if guildId and guildData and guildData.size and guildData.size < 495 then
			ZO_LinkHandler_OnLinkClicked("|H1:guild:" .. guildId .. "|hBeamMeUp Guild|h", 1, nil)
			return
		end
	end
	-- just redirect to latest BMU guild
	ZO_LinkHandler_OnLinkClicked("|H1:guild:" .. BMU.var.BMUGuilds[worldName][#BMU.var.BMUGuilds[worldName]] .. "|hBeamMeUp Guild|h", 1, nil)
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
		BMU.printToChat(BMU_colorizeText(BMU_SI_get(SI.TELE_CHAT_WHISPER_NOTE), "red"))
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
					CENTER_SCREEN_ANNOUNCE:AddMessage(0, CSA_CATEGORY_MAJOR_TEXT, sound, "Survey Maps Note", string.format(BMU_SI_get(SI.TELE_CENTERSCREEN_SURVEY_MAPS), slotData.stackCount-1), "esoui/art/icons/quest_scroll_001.dds", "EsoUI/Art/Achievements/achievements_iconBG.dds", nil, nil, 5000)
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


--Request all BMU and partner guilds information
function BMU.requestGuildData()
	BMU.isCurrentlyRequestingGuildData = true
	local guildsQueue = {}
	-- official guilds
	if BMU.var.BMUGuilds[worldName] ~= nil then
		guildsQueue = BMU.var.BMUGuilds[worldName]
	end
	-- partner guilds
	if BMU.var.partnerGuilds[worldName] ~= nil then
		guildsQueue = BMU.mergeTables(guildsQueue, BMU.var.partnerGuilds[worldName])
	end

	BMU.requestGuildDataRecursive(guildsQueue)
end

-- request all guilds in queue
function BMU.requestGuildDataRecursive(guildIds)
	if #guildIds > 0 then
		GUILD_BROWSER_MANAGER:RequestGuildData(table.remove(guildIds))
		zo_callLater(function() BMU.requestGuildDataRecursive(guildIds) end, 800)
	else
		BMU.isCurrentlyRequestingGuildData = false
	end
end


--------------------------------------------------
-- GUILD ADMINISTRATION TOOL
--------------------------------------------------

function BMU.AdminAddContextMenuToGuildRoster()
	-- add context menu to guild roster
	local GuildRosterRow_OnMouseUp = GUILD_ROSTER_KEYBOARD.GuildRosterRow_OnMouseUp --ZO_GuildRecruitment_ApplicationsList_Keyboard.Row_OnMouseUp
	GUILD_ROSTER_KEYBOARD.GuildRosterRow_OnMouseUp = function(self, control, button, upInside)

		local data = ZO_ScrollList_GetData(control)
		GuildRosterRow_OnMouseUp(self, control, button, upInside)
		
		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		if (button ~= MOUSE_BUTTON_INDEX_RIGHT --[[and not upInside]]) or data == nil or not BMU.AdminIsBMUGuild(currentGuildId) then
			return
		end
		
		local isAlreadyMember, memberStatusText = BMU.AdminIsAlreadyInGuild(data.displayName)
		
		local entries = {}
		
		-- welcome message
		table.insert(entries, {label = "Willkommensnachricht",
								callback = function(state)
									local guildId = currentGuildId
									local guildIndex = BMU.AdminGetGuildIndexFromGuildId(guildId)
									StartChatInput("Welcome on the bridge " .. data.displayName, _G["CHAT_CHANNEL_GUILD_" .. guildIndex])
								end,
								})
								
		-- new message
		table.insert(entries, {label = "Neue Nachricht",
								callback = function(state) BMU.createMail(data.displayName, "", "") BMU.printToChat("Nachricht erstellt an: " .. data.displayName) end,
								})
								
		-- copy account name
		table.insert(entries, {label = "Account-ID kopieren",
								callback = function(state) BMU.AdminCopyTextToChat(data.displayName) end,
								})
		
		-- invite to BMU guilds
		if BMU.var.BMUGuilds[worldName] ~= nil then
			for _, guildId in pairs(BMU.var.BMUGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.displayName) then
					table.insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.displayName) end,
											})
				end
			end
		end
		
		-- invite to partner guilds
		if BMU.var.partnerGuilds[worldName] ~= nil then
			for _, guildId in pairs(BMU.var.partnerGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.displayName) then
					table.insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.displayName) end,
											})
				end
			end
		end
		
		-- check if the player is also in other BMU guilds and add info
		table.insert(entries, {label = memberStatusText,
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

		local data = ZO_ScrollList_GetData(control)
		Row_OnMouseUp(self, control, button, upInside)
	
		local currentGuildId = GUILD_ROSTER_MANAGER:GetGuildId()
		if (button ~= MOUSE_BUTTON_INDEX_RIGHT --[[and not upInside]]) or data == nil or not BMU.AdminIsBMUGuild(currentGuildId) then
			return
		end
		
		local isAlreadyMember, memberStatusText = BMU.AdminIsAlreadyInGuild(data.name)

		local entries = {}
		
		-- new message
		table.insert(entries, {label = "Neue Nachricht",
								callback = function(state) BMU.createMail(data.name, "", "") BMU.printToChat("Nachricht erstellt an: " .. data.name) end,
								})
								
		-- copy account name
		table.insert(entries, {label = "Account-ID kopieren",
								callback = function(state) BMU.AdminCopyTextToChat(data.name) end,
								})
		
		-- invite to BMU guilds
		if BMU.var.BMUGuilds[worldName] ~= nil then
			for _, guildId in pairs(BMU.var.BMUGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.name) then
					table.insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.name) end,
											})
				end
			end
		end
		
		-- invite to partner guilds
		if BMU.var.partnerGuilds[worldName] ~= nil then
			for _, guildId in pairs(BMU.var.partnerGuilds[worldName]) do
				if IsPlayerInGuild(guildId) and not GetGuildMemberIndexFromDisplayName(guildId, data.name) then
					table.insert(entries, {label = "Einladen in: " .. GetGuildName(guildId),
											callback = function(state) BMU.AdminInviteToGuilds(guildId, data.name) end,
											})
				end
			end
		end
		
		-- check if the player is also in other BMU guilds and add info
		table.insert(entries, {label = memberStatusText,
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

function BMU.AdminCopyTextToChat(message)
	-- Max of input box is 351 chars
	if string.len(message) < 351 then
		if CHAT_SYSTEM.textEntry:GetText() == "" then
			CHAT_SYSTEM.textEntry:Open(message)
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
			local guildIndex = BMU.AdminGetGuildIndexFromGuildId(guildId)
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
	
	if GetGuildMemberIndexFromDisplayName(BMU.var.BMUGuilds[worldName][1], displayName) then
		text = text .. " 1 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU.var.BMUGuilds[worldName][2], displayName) then
		text = text .. " 2 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU.var.BMUGuilds[worldName][3], displayName) then
		text = text .. " 3 "
	end
	if GetGuildMemberIndexFromDisplayName(BMU.var.BMUGuilds[worldName][4], displayName) then
		text = text .. " 4 "
	end
	
	if text ~= "" then
		-- already member
		return true, BMU_colorizeText("Bereits Mitglied in " .. text, "red")
	else
		-- not a member or admin is not member of the BMU guilds
		return false, BMU_colorizeText("Neues Mitglied", "green")
	end
end

function BMU.AdminIsBMUGuild(guildId)
	if BMU.has_value(BMU.var.BMUGuilds[worldName], guildId) then
		return true
	else
		return false
	end
end

function BMU.AdminInviteToGuilds(guildId, displayName)
	-- add tuple to queue
	table.insert(inviteQueue, {guildId, displayName})
	if #inviteQueue == 1 then
		BMU.AdminInviteToGuildsQueue()
	end
end

function BMU.AdminInviteToGuildsQueue()
	if #inviteQueue > 0 then
		-- get first element and send invite
		local first = inviteQueue[1]
		GuildInvite(first[1], first[2])
		PlaySound(SOUNDS.BOOK_OPEN)
		-- restart to check for other elements
		zo_callLater(function() table.remove(inviteQueue, 1) BMU.AdminInviteToGuildsQueue() end, 16000)
	end		
end

function BMU.AdminAddAutoFillToDeclineApplicationDialog()
	local font = string.format("%s|$(KB_%s)|%s", ZoFontGame:GetFontInfo(), 21, "soft-shadow-thin")
	-- default message
	local autoFill_1 = WINDOW_MANAGER:CreateControl(nil, ZO_ConfirmDeclineApplicationDialog_Keyboard, CT_LABEL)
	autoFill_1:SetAnchor(TOPRIGHT, ZO_ConfirmDeclineApplicationDialog_Keyboard, TOPRIGHT, -5, 10)
	autoFill_1:SetFont(font)
	autoFill_1:SetText(BMU_colorizeText("BMU_AM", "gold"))
	autoFill_1:SetMouseEnabled(true)
	autoFill_1:SetHandler("OnMouseUp", function(self)
		ZO_ConfirmDeclineApplicationDialog_KeyboardDeclineMessageEdit:SetText("You are already a member of one of our other BMU guilds. Sorry, but we only allow joining one guild. You are welcome to join and support our partner guilds (flag button in the upper left corner).")
	end)
	-- message when player is already in 5 guilds
	local autoFill_2 = WINDOW_MANAGER:CreateControl(nil, ZO_ConfirmDeclineApplicationDialog_Keyboard, CT_LABEL)
	autoFill_2:SetAnchor(TOPRIGHT, ZO_ConfirmDeclineApplicationDialog_Keyboard, TOPRIGHT, -5, 40)
	autoFill_2:SetFont(font)
	autoFill_2:SetText(BMU_colorizeText("BMU_5G", "gold"))
	autoFill_2:SetMouseEnabled(true)
	autoFill_2:SetHandler("OnMouseUp", function(self)
		ZO_ConfirmDeclineApplicationDialog_KeyboardDeclineMessageEdit:SetText("We cannot accpect your application because you have already joined 5 other guilds (which is the maximum). If you want to join us, please submit a new application with free guild slot.")
	end)
end

