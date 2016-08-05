quickMenuToggleButton = 13
quickMenuToggleKey = "M"
quickMenuUp = "NUMPAD8"
quickMenuDn = "NUMPAD2"
quickMenuLeft = "NUMPAD4"
quickMenuRight = "NUMPAD6"
prevCameraKey = "X"
nextCameraKey = "C"

buttonTrackerMap = {}
buttonTrackerMap[quickMenuToggleButton] = 0

function getOpenMenuButtons(chosenMenu)
	local buttons = {}
	local currentMenu = getCurrentMenu()
	if currentMenu ~= chosenMenu then
		if chosenMenu < currentMenu then
			local closeMenuClicks = (numMenus + 1) - currentMenu
			for i = 0, closeMenuClicks + chosenMenu - 1 do
				buttons[i] = quickMenuToggleKey
				buttonTrackerMap[quickMenuToggleButton] = buttonTrackerMap[quickMenuToggleButton] + 1
			end
		else
			for i = 0, chosenMenu - currentMenu - 1 do
				buttons[i] = quickMenuToggleKey
				buttonTrackerMap[quickMenuToggleButton] = buttonTrackerMap[quickMenuToggleButton] + 1
			end
		end		
	end	
	return buttons
end

function getCurrentMenu()
	return buttonTrackerMap[quickMenuToggleButton] % (numMenus + 1)
end

function getSelectRowButtons(chosenRow)
	local buttons = {}	
	for i = 0, chosenRow - 1 do
		buttons[i] = quickMenuDn
	end	
	return buttons
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
customFunctionNamesTable[9][0] = "WATR"
customFunctionNamesTable[9][1] = " OIL"
customFunctionNamesTable[10] = {}
customFunctionNamesTable[10][0] = "FUEL"
customFunctionNamesTable[10][1] = "TANK"
customFunctionNamesTable[11] = {}
customFunctionNamesTable[11][0] = "FUEL"
customFunctionNamesTable[11][1] = "LAPS"
customFunctionNamesTable[12] = {}
customFunctionNamesTable[12][0] = "FUEL"
customFunctionNamesTable[12][1] = "TARG"