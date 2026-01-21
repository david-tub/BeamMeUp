local BG = {}

-- necessary libraries
BG.LHAS = LibHarvensAddonSettings

-- platform-specific globals
BG.ZoneStoryFragment = WORLD_MAP_ZONE_STORY_GAMEPAD_FRAGMENT
BG.ZO_WorldMapZoneStoryTopLevel = ZO_WorldMapZoneStoryTopLevel_Gamepad
BG.AntiquityLore = ANTIQUITY_LORE_GAMEPAD
BG.ZoFontGame = ZoFontGamepad22
BG.ZoFontGameBookTable = ZoFontGamepadBookTablet

-- Settings vars
local function zipDropdownSortedKeys(choices)
  local dropdownSortItems = {}
  for k, v in pairs(choices) do
    table.insert(dropdownSortItems, { name = v.name, data = k } )
  end
  return dropdownSortItems
end

local function zipDropdownSortedValues(choices, values)
  local dropdownSortItems = {}
  for k, v in pairs(choices) do
    table.insert(dropdownSortItems, { name = v.name, data = values[k] } )
  end
  return dropdownSortItems
end

BMU.dropdownSortItems = zipDropdownSortedKeys(BMU.dropdownSortChoices)
BMU.dropdownDefaultTabItems = zipDropdownSortedValues(BMU.dropdownDefaultTabChoices, BMU.dropdownDefaultTabValues)
BMU.dropdownPrioSourceItems = zipDropdownSortedValues(BMU.dropdownPrioSourceChoices, BMU.dropdownPrioSourceValues)
BMU.dropdownSecLangItems = zipDropdownSortedKeys(BMU.dropdownSecLangChoices)

BMU.BG = BG
