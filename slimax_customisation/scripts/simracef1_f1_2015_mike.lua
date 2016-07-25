require "scripts/mike_multifunction_switch"
require "scripts/mike_custom_displays"
require "scripts/mike_utils"

multifunctionMap = {}
keystrokeDelay = 200

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
multifunctionMap[1]["buttonMap"] = {}
multifunctionMap[1]["buttonMap"][0] = {}
multifunctionMap[1]["buttonMap"][1] = {}
multifunctionMap[1]["buttonMap"][2] = {}
multifunctionMap[1]["buttonMap"][0][0] = "NUMPAD8"
multifunctionMap[1]["buttonMap"][0][1] = "NUMPAD8"
multifunctionMap[1]["buttonMap"][0][2] = "NUMPAD2"
multifunctionMap[1]["buttonMap"][1][0] = "NUMPAD8"
multifunctionMap[1]["buttonMap"][1][1] = "NUMPAD8"
multifunctionMap[1]["buttonMap"][1][2] = "NUMPAD6"
multifunctionMap[1]["buttonMap"][2][0] = "NUMPAD8"
multifunctionMap[1]["buttonMap"][2][1] = "NUMPAD8"
multifunctionMap[1]["buttonMap"][2][2] = "NUMPAD8"

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
multifunctionMap[2]["buttonMap"][3][0] = "NUMPAD6"
multifunctionMap[2]["buttonMap"][3][1] = "NUMPAD6"
multifunctionMap[2]["buttonMap"][3][2] = "NUMPAD8"
multifunctionMap[2]["buttonMap"][2][0] = "NUMPAD6"
multifunctionMap[2]["buttonMap"][2][1] = "NUMPAD6"
multifunctionMap[2]["buttonMap"][2][2] = "NUMPAD6"
multifunctionMap[2]["buttonMap"][1][0] = "NUMPAD6"
multifunctionMap[2]["buttonMap"][1][1] = "NUMPAD6"
multifunctionMap[2]["buttonMap"][1][2] = "NUMPAD2"
multifunctionMap[2]["buttonMap"][0][0] = "NUMPAD6"
multifunctionMap[2]["buttonMap"][0][1] = "NUMPAD6"
multifunctionMap[2]["buttonMap"][0][2] = "NUMPAD4"

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
multifunctionMap[3]["buttonMap"][0][0] = "NUMPAD4"
multifunctionMap[3]["buttonMap"][0][1] = "NUMPAD4"
multifunctionMap[3]["buttonMap"][0][2] = "NUMPAD2"
multifunctionMap[3]["buttonMap"][1][0] = "NUMPAD4"
multifunctionMap[3]["buttonMap"][1][1] = "NUMPAD4"
multifunctionMap[3]["buttonMap"][1][2] = "NUMPAD6"
multifunctionMap[3]["buttonMap"][2][0] = "NUMPAD4"
multifunctionMap[3]["buttonMap"][2][1] = "NUMPAD4"
multifunctionMap[3]["buttonMap"][2][2] = "NUMPAD8"

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
multifunctionMap[4]["buttonMap"][0][0] = "NUMPAD2"
multifunctionMap[4]["buttonMap"][0][1] = "NUMPAD2"
multifunctionMap[4]["buttonMap"][0][2] = "NUMPAD2"
multifunctionMap[4]["buttonMap"][1][0] = "NUMPAD2"
multifunctionMap[4]["buttonMap"][1][1] = "NUMPAD2"
multifunctionMap[4]["buttonMap"][1][2] = "NUMPAD6"
multifunctionMap[4]["buttonMap"][2][0] = "NUMPAD2"
multifunctionMap[4]["buttonMap"][2][1] = "NUMPAD2"
multifunctionMap[4]["buttonMap"][2][2] = "NUMPAD8"

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
multifunctionMap[10]["name"] = "PRI"
multifunctionMap[11] = {}
multifunctionMap[11]["name"] = "OPT"

multifunctionMap[12] = {}
multifunctionMap[12]["name"] = "RSET"
multifunctionMap[12]["enabled"] = true

-- Used by the overtake button
fuelMultiFunctionMapIndex = 1

function custom_init_Event(scriptfile)	
end

function custom_controls_Event(deviceType, ctrlType, ctrlPos, value, funcIndex, targetDevice)
	local mult = multiControlsEvent(deviceType, ctrlType, ctrlPos, value)
	local oneSw = oneSwitchEvent(ctrlType, ctrlPos, value)
	if mult < oneSw then
		return mult
	else
		return oneSw
	end
end

function custom_left_Display_Event(swPosition)
	return dispEvent(0, swPosition)
end

function custom_right_Display_Event(swPosition)
	return dispEvent(1, swPosition)
end

function dispEvent(side, swPosition)
	oneSwitchDisplayEvent(side, swPosition)
	
	if not(customDisplayIsActive()) then		
		return customDisplayEventProcessing(swValue, side)
	else
		return 1
	end
end
