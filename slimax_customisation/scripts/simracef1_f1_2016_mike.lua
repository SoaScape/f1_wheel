require "scripts/mikes_custom_plugins/mike_all_custom_plugins"

keystrokeDelay = 200

quickMenuToggleButton = 13
quickMenuToggleKey = "NUMPAD8"
quickMenuUp = "NUMPAD8"
quickMenuDn = "NUMPAD2"
quickMenuLeft = "NUMPAD4"
quickMenuRight = "NUMPAD6"
trackableDecrementButton = quickMenuLeft
trackableIncrementButton = quickMenuRight
customKeystrokeDelays = {}
customKeystrokeDelays[trackableDecrementButton] = 50
customKeystrokeDelays[trackableIncrementButton] = 50

numMenus = 4

buttonTrackerMap = {}
buttonTrackerMap[quickMenuToggleButton] = 0

multifunctionMap = {}

multifunctionMap[1] = {}
multifunctionMap[1]["name"] = "FUEL"
multifunctionMap[1]["enabled"] = true
multifunctionMap[1]["menu"] = 1
multifunctionMap[1]["upDnSelectable"] = true
multifunctionMap[1]["upDnConfirmRequired"] = true
multifunctionMap[1]["defaultUpDnMode"] = 1
multifunctionMap[1]["currentUpDnMode"] = multifunctionMap[1]["defaultUpDnMode"]
multifunctionMap[1]["min"] = 0
multifunctionMap[1]["max"] = 2
multifunctionMap[1]["modes"] = {}
multifunctionMap[1]["modes"][0] = "LEAN"
multifunctionMap[1]["modes"][1] = "NORM"
multifunctionMap[1]["modes"][2] = "RICH"
--multifunctionMap[1]["confirmButtonMap"] = {}
multifunctionMap[1]["trackableButtonMap"] = {}
multifunctionMap[1]["trackableButtonMap"][0] = quickMenuToggleKey

multifunctionMap[2] = {}
multifunctionMap[2]["name"] = "TYRE"
multifunctionMap[2]["enabled"] = true
multifunctionMap[2]["menu"] = 1
multifunctionMap[2]["upDnSelectable"] = true
multifunctionMap[2]["upDnConfirmRequired"] = true
multifunctionMap[2]["defaultUpDnMode"] = 2
multifunctionMap[2]["currentUpDnMode"] = multifunctionMap[2]["defaultUpDnMode"]
multifunctionMap[2]["min"] = 0
multifunctionMap[2]["max"] = 4
multifunctionMap[2]["modes"] = {}
multifunctionMap[2]["modes"][0] = "ULTR"
multifunctionMap[2]["modes"][1] = "OPTN"
multifunctionMap[2]["modes"][2] = "PRME"
multifunctionMap[2]["modes"][3] = "INTR"
multifunctionMap[2]["modes"][4] = "WETS"
multifunctionMap[2]["trackableButtonMap"] = {}
multifunctionMap[2]["trackableButtonMap"][0] = quickMenuToggleKey
multifunctionMap[2]["trackableButtonMap"][1] = quickMenuDn
multifunctionMap[2]["trackableButtonMap"][2] = quickMenuDn
multifunctionMap[2]["trackableButtonMap"][3] = quickMenuDn
multifunctionMap[2]["trackableButtonMap"][4] = quickMenuDn

multifunctionMap[3] = {}
multifunctionMap[3]["name"] = "AERO"
multifunctionMap[3]["enabled"] = true
multifunctionMap[3]["menu"] = 1
multifunctionMap[3]["upDnSelectable"] = true
multifunctionMap[3]["upDnConfirmRequired"] = true
multifunctionMap[3]["defaultUpDnMode"] = 4
multifunctionMap[3]["currentUpDnMode"] = multifunctionMap[3]["defaultUpDnMode"]
multifunctionMap[3]["min"] = 0
multifunctionMap[3]["max"] = 9
multifunctionMap[3]["modes"] = {}
multifunctionMap[3]["modes"][0] = "1"
multifunctionMap[3]["modes"][1] = "2"
multifunctionMap[3]["modes"][2] = "3"
multifunctionMap[3]["modes"][3] = "4"
multifunctionMap[3]["modes"][4] = "5"
multifunctionMap[3]["modes"][5] = "6"
multifunctionMap[3]["modes"][6] = "7"
multifunctionMap[3]["modes"][7] = "8"
multifunctionMap[3]["modes"][8] = "9"
multifunctionMap[3]["modes"][9] = "10"
multifunctionMap[3]["trackableButtonMap"] = {}
multifunctionMap[3]["trackableButtonMap"][0] = quickMenuToggleKey
multifunctionMap[3]["trackableButtonMap"][1] = quickMenuDn
multifunctionMap[3]["trackableButtonMap"][2] = quickMenuDn
multifunctionMap[3]["trackableButtonMap"][3] = quickMenuDn

multifunctionMap[4] = {}
multifunctionMap[4]["name"] = "BIAS"
multifunctionMap[4]["enabled"] = true
multifunctionMap[4]["menu"] = 1
multifunctionMap[4]["upDnSelectable"] = true
multifunctionMap[4]["upDnConfirmRequired"] = true
multifunctionMap[4]["defaultUpDnMode"] = 10
multifunctionMap[4]["currentUpDnMode"] = multifunctionMap[4]["defaultUpDnMode"]
multifunctionMap[4]["min"] = 0
multifunctionMap[4]["max"] = 20
multifunctionMap[4]["modes"] = {}
multifunctionMap[4]["modes"][0] = "30%"
multifunctionMap[4]["modes"][1] = "32%"
multifunctionMap[4]["modes"][2] = "34%"
multifunctionMap[4]["modes"][3] = "36%"
multifunctionMap[4]["modes"][4] = "38%"
multifunctionMap[4]["modes"][5] = "40%"
multifunctionMap[4]["modes"][6] = "42%"
multifunctionMap[4]["modes"][7] = "44%"
multifunctionMap[4]["modes"][8] = "46%"
multifunctionMap[4]["modes"][9] = "48%"
multifunctionMap[4]["modes"][10] = "50%"
multifunctionMap[4]["modes"][11] = "52%"
multifunctionMap[4]["modes"][12] = "54%"
multifunctionMap[4]["modes"][13] = "56%"
multifunctionMap[4]["modes"][14] = "58%"
multifunctionMap[4]["modes"][15] = "60%"
multifunctionMap[4]["modes"][16] = "62%"
multifunctionMap[4]["modes"][17] = "64%"
multifunctionMap[4]["modes"][18] = "66%"
multifunctionMap[4]["modes"][19] = "68%"
multifunctionMap[4]["modes"][20] = "70%"
multifunctionMap[4]["trackableButtonMap"] = {}
multifunctionMap[4]["trackableButtonMap"][0] = quickMenuToggleKey
multifunctionMap[4]["trackableButtonMap"][1] = quickMenuDn

multifunctionMap[5] = {}
multifunctionMap[5]["name"] = "DIFF"
multifunctionMap[5]["enabled"] = true
multifunctionMap[5]["menu"] = 1
multifunctionMap[5]["upDnSelectable"] = true
multifunctionMap[5]["upDnConfirmRequired"] = true
multifunctionMap[5]["defaultUpDnMode"] = 5
multifunctionMap[5]["currentUpDnMode"] = multifunctionMap[5]["defaultUpDnMode"]
multifunctionMap[5]["currentPosition"] = nil
multifunctionMap[5]["min"] = 0
multifunctionMap[5]["max"] = 10
multifunctionMap[5]["modes"] = {}%"
multifunctionMap[5]["modes"][0] = "50%"
multifunctionMap[5]["modes"][1] = "55%"
multifunctionMap[5]["modes"][2] = "60%"
multifunctionMap[5]["modes"][3] = "65%"
multifunctionMap[5]["modes"][4] = "70%"
multifunctionMap[5]["modes"][5] = "75%"
multifunctionMap[5]["modes"][6] = "80%"
multifunctionMap[5]["modes"][7] = "85%"
multifunctionMap[5]["modes"][8] = "90%"
multifunctionMap[5]["modes"][9] = "95%"
multifunctionMap[5]["modes"][10] = "100%"
multifunctionMap[5]["trackableButtonMap"] = {}
multifunctionMap[5]["trackableButtonMap"][0] = quickMenuToggleKey
multifunctionMap[5]["trackableButtonMap"][1] = quickMenuDn
multifunctionMap[5]["trackableButtonMap"][2] = quickMenuDn

multifunctionMap[6] = {}
multifunctionMap[6]["name"] = "L"
multifunctionMap[7] = {}
multifunctionMap[7]["name"] = "D"
multifunctionMap[8] = {}
multifunctionMap[8]["name"] = "WET"
multifunctionMap[9] = {}
multifunctionMap[9]["name"] = "INT"
multifunctionMap[10] = {}
multifunctionMap[10]["name"] = "PRI"

multifunctionMap[11] = {}
multifunctionMap[11]["name"] = "RSET"
multifunctionMap[11]["enabled"] = true

multifunctionMap[12] = {}
multifunctionMap[12]["name"] = "MENU"
multifunctionMap[12]["enabled"] = true
multifunctionMap[12]["upDnSelectable"] = true
multifunctionMap[12]["upDnConfirmRequired"] = false
multifunctionMap[12]["defaultUpDnMode"] = 0
multifunctionMap[12]["currentUpDnMode"] = multifunctionMap[1]["defaultUpDnMode"]
multifunctionMap[12]["min"] = 0
multifunctionMap[12]["max"] = 4
multifunctionMap[12]["modes"] = {}
multifunctionMap[12]["modes"][0] = "NONE"
multifunctionMap[12]["modes"][1] = "SETT"
multifunctionMap[12]["modes"][2] = "WEAR"
multifunctionMap[12]["modes"][3] = "TEMP"
multifunctionMap[12]["modes"][4] = "INFO"

-- Used by the overtake button
fuelMultiFunction = multifunctionMap[1]
overtakeButtonEnabled = true

function custom_init_Event(scriptfile)	
end

function getButtonMap(currentMultifunction)
	if currentMultifunction["trackableButtonMap"] ~= nil then
		-- Trackable up/dn modes. Eg in F1 2016, the quick-menu keeps track of what is currently
		-- selected, therefore the button maps will need to change on the fly.
		next = 0
		buttonMap = {}	

		openMenuButtons = getOpenMenuButtons(currentMultifunction["menu"])
		for key, value in pairs(customButtons) do			
			buttonMap[next] = value
			next = next + 1
		end

		if currentMultifunction["currentPosition"] == nil then
			-- We don't know what's currently selected. Therefore move the selector
			-- all the way to the bottom so we know the 'min' mode is selected
			for i = currentMultifunction["min"], currentMultifunction["max"] do
				buttonMap[next] = trackableDecrementButton
				next = next + 1
			end
			-- Now we know the currently selected mode so store it
			currentMultifunction["currentPosition"] = currentMultifunction["min"]
		end
		
		-- Now increment or decrement to reach the requested mode (currentUpDnMode)
		local keyPress = trackableIncrementButton
		local step = 1
		if currentMultifunction["currentPosition"] > currentMultifunction["currentUpDnMode"] then
			keyPress = trackableDecrementButton
			step = -1
		end
		for i = currentMultifunction["currentPosition"], currentMultifunction["currentUpDnMode"], step do
			buttonMap[next] = keyPress
			next = next + 1
		end
		currentMultifunction["currentPosition"] = currentMultifunction["currentUpDnMode"]
		return buttonMap
	elseif currentMultifunction["name"] = "MENU" then
		next = 0
		buttonMap = {}
		return getOpenMenuButtons(currentMultifunction["currentUpDnMode"] + 1)
	elseif currentMultifunction["confirmButtonMap"] ~= nil then
		-- This is for multifunctions where up/dn modes aren't used, just a single button map for confirm
		return currentMultifunction["confirmButtonMap"]		
	else
		-- F1 2015 quick-menu doesn't keep track of what's selected so button maps are always static
		return currentMultifunction["buttonMap"][currentMultifunction["currentUpDnMode"]]
	end
end

function getOpenMenuButtons(chosenMenu)
	local buttons = {}
	local currentMenu = buttonTrackerMap[quickMenuToggleButton] % (numMenus + 1)
	if currentMenu ~= chosenMenu then
		local closeMenuClicks = 0
		if chosenMenu < currentMenu then
			closeMenuClicks = (numMenus + 1) - currentMenu
		end
		for i = currentMenu, (chosenMenu - 1 + closeMenuClicks) do
			buttons[i] = quickMenuToggleKey
		end
	end	
	return buttons
end