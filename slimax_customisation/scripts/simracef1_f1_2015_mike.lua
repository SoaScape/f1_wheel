require "scripts/mike_multifunction_switch"
require "scripts/mike_custom_displays"

multifunctionMap = {}

multifunctionMap[1] = {}
multifunctionMap[1]["name"] = "FUEL"
multifunctionMap[1]["upDnSelectable"] = true
multifunctionMap[1]["upDnConfirmRequired"] = true
multifunctionMap[1]["currentUpDnMode"] = 1
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
multifunctionMap[2]["upDnSelectable"] = true
multifunctionMap[2]["upDnConfirmRequired"] = true
multifunctionMap[2]["currentUpDnMode"] = 1
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
multifunctionMap[3]["upDnSelectable"] = true
multifunctionMap[3]["upDnConfirmRequired"] = true
multifunctionMap[3]["currentUpDnMode"] = 1
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
multifunctionMap[4]["upDnSelectable"] = true
multifunctionMap[4]["upDnConfirmRequired"] = true
multifunctionMap[4]["currentUpDnMode"] = 1
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

multifunctionMap[12] = {}
multifunctionMap[12]["name"] = "RSET"

-- Used by the overtake button
fuelMultiFunctionMapIndex = 1

function custom_init_Event(scriptfile)	
end

function custom_controls_Event(deviceType, ctrlType, ctrlPos, value, funcIndex, targetDevice)
	return multiControlsEvent(deviceType, ctrlType, ctrlPos, value, funcIndex, targetDevice)
end

function custom_left_Display_Event(swPosition)
	oneSwitchLeftDisplayEvent(swPosition)
	return customDisplayEventProcessing(swValue, 0)
end

function custom_right_Display_Event(swPosition)
	oneSwitchRightDisplayEvent(swPosition)
	return customDisplayEventProcessing(swValue, 1)
end
