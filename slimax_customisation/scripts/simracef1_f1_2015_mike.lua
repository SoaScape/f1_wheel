require "scripts/mikes_custom_plugins/mike_all_custom_plugins"
require "scripts/mikes_custom_plugins/mike_codemasters_f1_utils"

keystrokeDelay = 200

quickMenuToggleButton = 13
quickMenuToggleKey = "M"

quickMenuUp = "NUMPAD8"
quickMenuDn = "NUMPAD2"
quickMenuLeft = "NUMPAD4"
quickMenuRight = "NUMPAD6"
prevCameraKey = "X"
nextCameraKey = "C"

numMenus = 3

customKeystrokeDelays = {}
customKeystrokeDelays[prevCameraKey] = 5
customKeystrokeDelays[nextCameraKey] = 5
customKeystrokeDelays[quickMenuToggleKey] = 5

buttonTrackerMap = {}
buttonTrackerMap[quickMenuToggleButton] = 0

multifunctionMap = {}

multifunctionMap[1] = {}
multifunctionMap[1]["name"] = "FUEL"
multifunctionMap[1]["enabled"] = true
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
multifunctionMap[1]["buttonMap"] = {}
multifunctionMap[1]["buttonMap"][0] = {}
multifunctionMap[1]["buttonMap"][1] = {}
multifunctionMap[1]["buttonMap"][2] = {}
multifunctionMap[1]["buttonMap"][0][0] = quickMenuUp
multifunctionMap[1]["buttonMap"][0][1] = quickMenuUp
multifunctionMap[1]["buttonMap"][0][2] = quickMenuDn
multifunctionMap[1]["buttonMap"][1][0] = quickMenuUp
multifunctionMap[1]["buttonMap"][1][1] = quickMenuUp
multifunctionMap[1]["buttonMap"][1][2] = quickMenuRight
multifunctionMap[1]["buttonMap"][2][0] = quickMenuUp
multifunctionMap[1]["buttonMap"][2][1] = quickMenuUp
multifunctionMap[1]["buttonMap"][2][2] = quickMenuUp

multifunctionMap[2] = {}
multifunctionMap[2]["name"] = "TYRE"
multifunctionMap[2]["enabled"] = true
multifunctionMap[2]["upDnSelectable"] = true
multifunctionMap[2]["upDnConfirmRequired"] = true
multifunctionMap[2]["defaultUpDnMode"] = 2
multifunctionMap[2]["currentUpDnMode"] = multifunctionMap[2]["defaultUpDnMode"]
multifunctionMap[2]["min"] = 0
multifunctionMap[2]["max"] = 3
multifunctionMap[2]["modes"] = {}
multifunctionMap[2]["modes"][0] = "WETS"
multifunctionMap[2]["modes"][1] = "INTR"
multifunctionMap[2]["modes"][2] = "PRME"
multifunctionMap[2]["modes"][3] = "OPTN"
multifunctionMap[2]["buttonMap"] = {}
multifunctionMap[2]["buttonMap"][0] = {}
multifunctionMap[2]["buttonMap"][1] = {}
multifunctionMap[2]["buttonMap"][2] = {}
multifunctionMap[2]["buttonMap"][3] = {}
multifunctionMap[2]["buttonMap"][0][0] = quickMenuUp
multifunctionMap[2]["buttonMap"][0][1] = quickMenuRight
multifunctionMap[2]["buttonMap"][0][2] = quickMenuLeft
multifunctionMap[2]["buttonMap"][1][0] = quickMenuUp
multifunctionMap[2]["buttonMap"][1][1] = quickMenuRight
multifunctionMap[2]["buttonMap"][1][2] = quickMenuDn
multifunctionMap[2]["buttonMap"][2][0] = quickMenuUp
multifunctionMap[2]["buttonMap"][2][1] = quickMenuRight
multifunctionMap[2]["buttonMap"][2][2] = quickMenuRight
multifunctionMap[2]["buttonMap"][3][0] = quickMenuUp
multifunctionMap[2]["buttonMap"][3][1] = quickMenuRight
multifunctionMap[2]["buttonMap"][3][2] = quickMenuUp

multifunctionMap[3] = {}
multifunctionMap[3]["name"] = "WING"
multifunctionMap[3]["enabled"] = true
multifunctionMap[3]["upDnSelectable"] = true
multifunctionMap[3]["upDnConfirmRequired"] = true
multifunctionMap[3]["defaultUpDnMode"] = 1
multifunctionMap[3]["currentUpDnMode"] = multifunctionMap[3]["defaultUpDnMode"]
multifunctionMap[3]["min"] = 0
multifunctionMap[3]["max"] = 2
multifunctionMap[3]["modes"] = {}
multifunctionMap[3]["modes"][0] = "DOWN"
multifunctionMap[3]["modes"][1] = "MIDL"
multifunctionMap[3]["modes"][2] = "UP"
multifunctionMap[3]["buttonMap"] = {}
multifunctionMap[3]["buttonMap"][0] = {}
multifunctionMap[3]["buttonMap"][1] = {}
multifunctionMap[3]["buttonMap"][2] = {}
multifunctionMap[3]["buttonMap"][0][0] = quickMenuUp
multifunctionMap[3]["buttonMap"][0][1] = quickMenuLeft
multifunctionMap[3]["buttonMap"][0][2] = quickMenuDn
multifunctionMap[3]["buttonMap"][1][0] = quickMenuUp
multifunctionMap[3]["buttonMap"][1][1] = quickMenuLeft
multifunctionMap[3]["buttonMap"][1][2] = quickMenuRight
multifunctionMap[3]["buttonMap"][2][0] = quickMenuUp
multifunctionMap[3]["buttonMap"][2][1] = quickMenuLeft
multifunctionMap[3]["buttonMap"][2][2] = quickMenuUp

multifunctionMap[4] = {}
multifunctionMap[4]["name"] = "BIAS"
multifunctionMap[4]["enabled"] = true
multifunctionMap[4]["upDnSelectable"] = true
multifunctionMap[4]["upDnConfirmRequired"] = true
multifunctionMap[4]["defaultUpDnMode"] = 1
multifunctionMap[4]["currentUpDnMode"] = multifunctionMap[4]["defaultUpDnMode"]
multifunctionMap[4]["min"] = 0
multifunctionMap[4]["max"] = 2
multifunctionMap[4]["modes"] = {}
multifunctionMap[4]["modes"][0] = "BACK"
multifunctionMap[4]["modes"][1] = "MIDL"
multifunctionMap[4]["modes"][2] = "FORW"
multifunctionMap[4]["buttonMap"] = {}
multifunctionMap[4]["buttonMap"][0] = {}
multifunctionMap[4]["buttonMap"][1] = {}
multifunctionMap[4]["buttonMap"][2] = {}
multifunctionMap[4]["buttonMap"][0][0] = quickMenuUp
multifunctionMap[4]["buttonMap"][0][1] = quickMenuDn
multifunctionMap[4]["buttonMap"][0][2] = quickMenuDn
multifunctionMap[4]["buttonMap"][1][0] = quickMenuUp
multifunctionMap[4]["buttonMap"][1][1] = quickMenuDn
multifunctionMap[4]["buttonMap"][1][2] = quickMenuRight
multifunctionMap[4]["buttonMap"][2][0] = quickMenuUp
multifunctionMap[4]["buttonMap"][2][1] = quickMenuDn
multifunctionMap[4]["buttonMap"][2][2] = quickMenuUp

multifunctionMap[5] = {}
multifunctionMap[5]["name"] = "DX"
multifunctionMap[6] = {}
multifunctionMap[6]["name"] = "L"
multifunctionMap[7] = {}
multifunctionMap[7]["name"] = "D"
multifunctionMap[8] = {}
multifunctionMap[8]["name"] = "WET"
multifunctionMap[9] = {}
multifunctionMap[9]["name"] = "INT"

multifunctionMap[10] = {}
multifunctionMap[10]["name"] = "RSET"
multifunctionMap[10]["enabled"] = true

multifunctionMap[11] = {}
multifunctionMap[11]["name"] = "VIEW"
multifunctionMap[11]["enabled"] = true
multifunctionMap[11]["upDnSelectable"] = true
multifunctionMap[11]["upDnConfirmRequired"] = false
multifunctionMap[11]["defaultUpDnMode"] = 0
multifunctionMap[11]["currentUpDnMode"] = multifunctionMap[11]["defaultUpDnMode"]
multifunctionMap[11]["min"] = 0
multifunctionMap[11]["max"] = 1
multifunctionMap[11]["modes"] = {}
multifunctionMap[11]["modes"][0] = "PREV"
multifunctionMap[11]["modes"][1] = "NEXT"
multifunctionMap[11]["buttonMap"] = {}
multifunctionMap[11]["buttonMap"][0] = {}
multifunctionMap[11]["buttonMap"][1] = {}
multifunctionMap[11]["buttonMap"][0][0] = prevCameraKey
multifunctionMap[11]["buttonMap"][1][0] = nextCameraKey

multifunctionMap[12] = {}
multifunctionMap[12]["name"] = "MENU"
multifunctionMap[12]["enabled"] = true
multifunctionMap[12]["upDnSelectable"] = true
multifunctionMap[12]["upDnConfirmRequired"] = false
multifunctionMap[12]["defaultUpDnMode"] = 0
multifunctionMap[12]["currentUpDnMode"] = multifunctionMap[12]["defaultUpDnMode"]
multifunctionMap[12]["min"] = 0
multifunctionMap[12]["max"] = 3
multifunctionMap[12]["wrap"] = true
multifunctionMap[12]["modes"] = {}
multifunctionMap[12]["modes"][0] = "NONE"
multifunctionMap[12]["modes"][1] = "INFO"
multifunctionMap[12]["modes"][2] = "WEAR"
multifunctionMap[12]["modes"][3] = "TEMP"

-- Used by the overtake button
fuelMultiFunction = multifunctionMap[1]
overtakeButtonEnabled = true

function custom_init_Event(scriptfile)	
end

function getButtonMap(currentMultifunction)
	if currentMultifunction["confirmButtonMap"] ~= nil then
		-- This is for multifunctions where up/dn modes aren't used, just a single button map for confirm
		return currentMultifunction["confirmButtonMap"]
	elseif currentMultifunction["name"] == "MENU" then
		next = 0
		buttonMap = {}
		return getOpenMenuButtons(currentMultifunction["currentUpDnMode"])
	else
		-- F1 2015 quick-menu doesn't keep track of what's selected so button maps are always static
		return currentMultifunction["buttonMap"][currentMultifunction["currentUpDnMode"]]
	end
end
