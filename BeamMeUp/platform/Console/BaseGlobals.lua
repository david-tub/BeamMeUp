-- necessary libraries
BMU.LHAS = LibHarvensAddonSettings

-- platform-specific globals
BMU.ZoneStoryFragment = WORLD_MAP_ZONE_STORY_GAMEPAD_FRAGMENT
BMU.ZO_WorldMapZoneStoryTopLevel = ZO_WorldMapZoneStoryTopLevel_Gamepad
BMU.AntiquityLore = ANTIQUITY_LORE_GAMEPAD

-- Settings vars
local function zipDropdownSortedKeys(choices)
  local dropdownSortItems = {}
  for k, v in pairs(choices) do
    table.insert(dropdownSortItems, { name = v.name, data = k } )
  end
end

local function zipDropdownSortedValues(choices, values)
  local dropdownSortItems = {}
  for k, v in pairs(choices) do
    table.insert(dropdownSortItems, { name = v.name, data = values[k] } )
  end
end

BMU.dropdownSortItems = zipDropdownSortedKeys(BMU.dropdownSortChoices)
BMU.dropdownDefaultTabItems = zipDropdownSortedValues(BMU.dropdownDefaultTabChoices, BMU.dropdownDefaultTabValues)
BMU.dropdownPrioSourceItems = zipDropdownSortedValues(BMU.dropdownPrioSourceChoices, BMU.dropdownPrioSourceValues)
BMU.dropdownSecLangItems = zipDropdownSortedKeys(BMU.dropdownSecLangChoices)
