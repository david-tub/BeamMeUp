local BG = {}

-- necessary libraries
BG.LHAS = LibHarvensAddonSettings

-- platform-specific globals
BG.ZoneStoryFragment = WORLD_MAP_ZONE_STORY_GAMEPAD_FRAGMENT
BG.ZO_WorldMapZoneStoryTopLevel = ZO_WorldMapZoneStoryTopLevel_Gamepad
BG.AntiquityLore = ANTIQUITY_LORE_GAMEPAD
BG.ZoFontGame = ZoFontGamepad36
BG.ZoFontGameBookTable = ZoFontGamepadBookTablet
BG.CollectionsBook = GAMEPAD_COLLECTIONS_BOOK
BG.worldMap = "gamepad_worldMap"

-- Settings vars
local function zipDropdownSortedKeys(choices)
  local dropdownSortItems = {}
  for k, v in ipairs(choices) do
    table.insert(dropdownSortItems, { name = v, data = k } )
  end
  return dropdownSortItems
end

local function zipDropdownSortedValues(choices, values)
  local dropdownSortItems = {}
  for k, v in pairs(choices) do
    table.insert(dropdownSortItems, { name = v, data = values[k] } )
  end
  return dropdownSortItems
end

BMU.dropdownSortItems = zipDropdownSortedKeys(BMU.dropdownSortChoices)
BMU.dropdownDefaultTabItems = zipDropdownSortedValues(BMU.dropdownDefaultTabChoices, BMU.dropdownDefaultTabValues)
BMU.dropdownPrioSourceItems = zipDropdownSortedValues(BMU.dropdownPrioSourceChoices, BMU.dropdownPrioSourceValues)
BMU.dropdownSecLangItems = zipDropdownSortedKeys(BMU.dropdownSecLangChoices)

BMU.BG = BG
