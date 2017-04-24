quickMenuUp = "NUMPAD8"
quickMenuDn = "NUMPAD2"
quickMenuLeft = "NUMPAD4"
quickMenuRight = "NUMPAD6"

local quickMenuToggleButton = 13
local quickMenuToggleKey = "M"
local radioKey = "T"
local quickMenuFirstPage = quickMenuLeft

local extraDelay = 400
local openMenuDelay = 500
local closeMenuDelay = 600

function getVoiceMenuButtons(currentMultifunction)
	local index = 0
	local buttonMap = {}

	delayMap = {}
	delayMap[0] = extraDelay
	
	buttonMap[index] = radioKey
	index = index + 1

	for i = 1, currentMultifunction["voiceMenuPage"] - 1 do
		buttonMap[index] = quickMenuToggleKey
		delayMap[index] = 50
		index = index + 1
	end
	
	if currentMultifunction["voiceMenuRows"][currentMultifunction["currentUpDnMode"]] > 1 then
		for i = 1, currentMultifunction["voiceMenuRows"][currentMultifunction["currentUpDnMode"]] - 1 do
			buttonMap[index] = quickMenuDn
			index = index + 1
		end
	else
		delayMap[index - 1] = extraDelay
	end

	buttonMap[index] = quickMenuRight
	return buttonMap
end

local function getSelectRowButtons(chosenRow)
	local buttons = {}
	for i = 0, chosenRow - 1 do
		buttons[i] = quickMenuDn
	end
	return buttons
end

function getMfdMenuButtons(currentMultifunction)
	local index = 0
	local buttonMap = {}
	local numQuickMenuChanges = 0

	delayMap = {}
	delayMap[0] = openMenuDelay

	buttonMap[index] = quickMenuFirstPage
	index = index + 1

	-- Scroll down to the required row.
	local selectRowButtons = getSelectRowButtons(currentMultifunction["row"] - 1)
	for key, value in pairs(selectRowButtons) do
		buttonMap[index] = value
		index = index + 1
	end

	-- We don't know what's currently selected. Therefore move the selector
	-- all the way to the bottom so we know the 'min' mode is selected
	for i = currentMultifunction["min"], currentMultifunction["max"] - 1 do
		buttonMap[index] = quickMenuLeft
		index = index + 1
	end
	-- Now we know the currently selected mode so store it
	currentMultifunction["currentPosition"] = currentMultifunction["min"]

	-- Now increment to reach the requested mode (currentUpDnMode)
	local keyPress = quickMenuRight
	local loopStartIndex = currentMultifunction["currentPosition"] + 1
	
	for i = 1, currentMultifunction["currentUpDnMode"], 1 do
		buttonMap[index] = keyPress
		index = index + 1
	end
	
	-- Update the current position to match what we have selected.
	currentMultifunction["currentPosition"] = currentMultifunction["currentUpDnMode"]

	-- Finally, close the multi function display menu.
	buttonMap[index] = quickMenuToggleKey
	delayMap[index] = closeMenuDelay
	keyHoldMap = {}
	keyHoldMap[index] = closeMenuDelay

	return buttonMap
end

function performRaceStart()
	setDefaultModes()	
	toggleOvertakeMode(false)
end

function exitRaceStart()
	toggleOvertakeMode(false)
end

customFunctionNamesTable = {}
customFunctionNamesTable[1] = {}
customFunctionNamesTable[1][0] = "POS"
customFunctionNamesTable[1][1] = "LAPS"
customFunctionNamesTable[2] = {}
customFunctionNamesTable[2][0] = "LAPS"
customFunctionNamesTable[2][1] = "COMP"
customFunctionNamesTable[3] = {}
customFunctionNamesTable[3][0] = "SPED"
customFunctionNamesTable[3][1] = "PREV"
customFunctionNamesTable[4] = {}
customFunctionNamesTable[4][0] = "CURR"
customFunctionNamesTable[4][1] = "BEST"
customFunctionNamesTable[5] = {}
customFunctionNamesTable[5][0] = "DELT"
customFunctionNamesTable[5][1] = "TIME"
customFunctionNamesTable[6] = {}
customFunctionNamesTable[6][0] = "SECT"
customFunctionNamesTable[6][1] = "TIME"
customFunctionNamesTable[7] = {}
customFunctionNamesTable[7][0] = "TIME"
customFunctionNamesTable[7][1] = "REMN"
customFunctionNamesTable[8] = {}
customFunctionNamesTable[8][0] = "ACCL"
customFunctionNamesTable[8][1] = "BRKE"
customFunctionNamesTable[9] = {}
customFunctionNamesTable[9][0] = "FUEL"
customFunctionNamesTable[9][1] = "PLAP"
customFunctionNamesTable[10] = {}
customFunctionNamesTable[10][0] = "FUEL"
customFunctionNamesTable[10][1] = "TANK"
customFunctionNamesTable[11] = {}
customFunctionNamesTable[11][0] = "FUEL"
customFunctionNamesTable[11][1] = "LAPS"
customFunctionNamesTable[12] = {}
customFunctionNamesTable[12][0] = "FUEL"
customFunctionNamesTable[12][1] = "TARG"