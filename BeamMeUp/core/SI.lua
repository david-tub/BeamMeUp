BMU = {} --Create global BMU variable

local BMU = BMU --INS251229 Baertram Performancee gain, not searching _G for BMU each time again!

local SI = {}

-- Switch language ingame (chat command)
--[[
English
/script SetCVar("language.2","en")

German
/script SetCVar("language.2","de")

France
/script SetCVar("language.2","fr")
--]]

--[[

Beartram 20260203 This all is not needed ?! You simply define the constants inside the en.lua once, and done!
No need to predefine them here in another table SI and use that everywhere, it's just a complication.

---->removed all predefined SI. constants here
]]

----------------------------------------------------------------------------
-- Dynamic dropdown controls in LAM - Define the number of entries and SI constants will be created (translate in en.lua, de.lua etc. then)
--> Used in file TeleporterGlobals -> Search for the "numVars"
-----------------------------------------------------------------------------
BMU.numVars = {}
local numVars = BMU.numVars
numVars.teleDropdownPrefix = "SI_TELE_DROPDOWN_"
local teleDropdownPrefix = numVars.teleDropdownPrefix

--Language selction dropdown
numVars.numSecLangDropdownEntries = 9
numVars.secLangDropdownEntryPrefix = teleDropdownPrefix .. "SECOND_LANG_CHOICE_"

--Sort dropdown
numVars.numSortDropdownEntries = 11
numVars.sortDropdownEntryPrefix = teleDropdownPrefix .. "SORT_CHOICE_"



----------------------------------------------------------------------------
-- Utility functions
----------------------------------------------------------------------------
--Get the string from the ESO_Strings table via the key _G[key .. n] -> Using GetString function
function SI.get(key, n)
    return assert(GetString(key, n))
end


BMU.SI = SI

