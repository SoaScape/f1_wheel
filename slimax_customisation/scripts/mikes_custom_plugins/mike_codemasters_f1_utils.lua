quickMenuUp = "NUMPAD8"
quickMenuDn = "NUMPAD2"
quickMenuLeft = "NUMPAD4"
quickMenuRight = "NUMPAD6"

local quickMenuToggleButton = 13
local quickMenuToggleKey = "M"
local radioKey = "T"
local quickMenuFirstPage = quickMenuLeft

local voiceMenuDelay = 600
local openMenuDelay = 600
local closeMenuDelay = 600

local function getRearBrakeBias()
	local frontBias = round(GetBrakeBiasState(), 0)
	return 100 - frontBias
end

function getRearBrakeBiasIndex()
	return getKeyForValue(biasMultiFunction["modes"], getRearBrakeBias())
end

function getVoiceMenuButtons(multifunction)
	local index = 0
	local buttonMap = {}

	delayMap = {}
	delayMap[0] = voiceMenuDelay
	
	buttonMap[index] = radioKey
	index = index + 1

	for i = 1, multifunction["voiceMenuPage"] - 1 do
		buttonMap[index] = quickMenuToggleKey
		delayMap[index] = 50
		index = index + 1
	end
	
	if multifunction["voiceMenuRows"][multifunction["currentUpDnMode"]] > 1 then
		for i = 1, multifunction["voiceMenuRows"][multifunction["currentUpDnMode"]] - 1 do
			buttonMap[index] = quickMenuDn
			index = index + 1
		end
	else
		delayMap[index - 1] = voiceMenuDelay
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

local function setMinPosition(multifunction, buttonMap, decKey)
	local count = 0
	-- If We don't know what's currently selected. Therefore move the selector
	-- all the way to the bottom so we know the 'min' mode is selected
	for i = multifunction["min"], multifunction["max"] - 1 do
		table.insert(buttonMap, decKey)
		count = count + 1
	end
	-- Now we know the currently selected mode so store it
	multifunction["currentPosition"] = multifunction["min"]
	return count
end

local function getSelectModeButtons(buttonMap, multifunction, currentPosition, decKey, incKey)
	local step = 1
	local loopStartIndex = currentPosition + 1
	local keyPress = incKey
	local count = 0
	if currentPosition > multifunction["currentUpDnMode"] then
		keyPress = decKey
		loopStartIndex = currentPosition - 1
		step = -1
	end
	for i = loopStartIndex, multifunction["currentUpDnMode"], step do
		table.insert(buttonMap, keyPress)
		count = count + 1
	end
	return count
end

function getMfdShortcutButtons(multifunction, dontCloseMenu)
	if inPits() then
		return nil
	end
	delayMap = {}
	local nextIndex = 1
	local buttonMap = {}
	local currentSetting
	local positionPreviouslyUnknown = false
	if multifunction["currentSettingMethod"] ~= nil then
		currentSetting = multifunction["currentSettingMethod"]()
	else
		if multifunction["currentPosition"] == nil then
			nextIndex = nextIndex + setMinPosition(multifunction, buttonMap, multifunction["decrementKey"])
			positionPreviouslyUnknown = true
		end
		currentSetting = multifunction["currentPosition"]
	end
	-- Don't process if position is already set
	if positionPreviouslyUnknown or currentSetting ~= multifunction["currentUpDnMode"] then
		multifunction["currentPosition"] = multifunction["currentUpDnMode"]
		nextIndex = nextIndex + getSelectModeButtons(buttonMap, multifunction, currentSetting, multifunction["decrementKey"], multifunction["incrementKey"])

		-- Close the MFD window
		if dontCloseMenu == nil or not(dontCloseMenu) then
			buttonMap[nextIndex] = quickMenuToggleKey
			delayMap[nextIndex] = closeMenuDelay
			keyHoldMap = {}
			keyHoldMap[nextIndex] = closeMenuDelay
		end
	end
	return buttonMap
end

function getMfdMenuButtons(multifunction)
	if inPits() then
		return nil
	end
	-- Trackable up/dn modes. Eg in F1 2016, the quick-menu keeps track of what is currently
	-- selected, therefore the button maps will need to change on the fly.
	local index = 1
	local buttonMap = {}

	delayMap = {}
	delayMap[1] = openMenuDelay

	buttonMap[index] = quickMenuFirstPage
	index = index + 1

	-- Scroll down to the required row.
	local selectRowButtons = getSelectRowButtons(multifunction["row"] - 1)
	for key, value in pairs(selectRowButtons) do
		buttonMap[index] = value
		index = index + 1
	end

	-- Reset currentPosition based off the min, if it wasn't known previously, or if
	-- the chosen mode matches the current position. If the later, this implies something
	-- is out of sync and the user is trying to 'force set' the mode.
	if multifunction["currentPosition"] == nil or multifunction["currentPosition"] == multifunction["currentUpDnMode"] then
		positionPreviouslyUnknown = true
		index = setMinPosition(multifunction, buttonMap, quickMenuLeft) + index
	end

	-- Now increment or decrement to reach the requested mode (currentUpDnMode)
	local numSelectPresses = getSelectModeButtons(buttonMap, multifunction, multifunction["currentPosition"], quickMenuLeft, quickMenuRight)
	index = index + numSelectPresses
	
	-- Update the current position to match what we have selected.
	multifunction["currentPosition"] = multifunction["currentUpDnMode"]

	-- Finally, close the multi function display menu.
	buttonMap[index] = quickMenuToggleKey
	delayMap[index] = closeMenuDelay
	keyHoldMap = {}
	keyHoldMap[index] = closeMenuDelay
	return buttonMap
end

function performRaceStart()
	toggleOvertakeMode(false, true)
	autoMixInhibitOn()
end

function exitRaceStart()
	toggleOvertakeMode(false, true)
	autoMixInhibitOff()
end

local trackLookupBySize = {}
trackLookupBySize[0] = "ASTL"
trackLookupBySize[1] = "FRAN"
trackLookupBySize[2] = "CHIN"
trackLookupBySize[3] = "BAHR"
trackLookupBySize[4] = "SPAN"
trackLookupBySize[5] = "MONA"
trackLookupBySize[6] = "CAND"
trackLookupBySize[7] = "SILV"
trackLookupBySize[8] = "GERM"
trackLookupBySize[9] = "HUNG"
trackLookupBySize[7003] = "BELG"
trackLookupBySize[11] = "ITLY"
trackLookupBySize[12] = "SING"
trackLookupBySize[13] = "JAPN"
trackLookupBySize[14] = " ABU"
trackLookupBySize[15] = "COTA"
trackLookupBySize[16] = "BRAZ"
trackLookupBySize[17] = "AUST"
trackLookupBySize[18] = "RUSS"
trackLookupBySize[19] = "MEXI"
trackLookupBySize[20] = "AZER"
local lastSize = 0;
function getTrack()
	--round(GetCarInfo("track_size"), 0)
	local size = GetContextInfo("track_size")
	if size ~= lastSize then
		print("Track Size: " .. size)
		lastSize = size
	end
	return trackLookupBySize[size]
end

customFunctionNamesTable = {}
customFunctionNamesTable[1] = {}
customFunctionNamesTable[1][0] = "DENT"
customFunctionNamesTable[1][1] = "DMID"
customFunctionNamesTable[2] = {}
customFunctionNamesTable[2][0] = "DEXT"
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
customFunctionNamesTable[7][1] = "DIST"
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