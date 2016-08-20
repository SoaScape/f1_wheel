require "scripts/mikes_custom_plugins/mike_codemasters_f1_utils"
require "scripts/mikes_custom_plugins/mike_all_custom_plugins"

numMenus = 4

confirmDelay = 1000

customKeystrokeDelays = {}
--customKeystrokeDelays[quickMenuLeft] = 5
--customKeystrokeDelays[quickMenuRight] = 5

multifunctionMap = {}

multifunctionMap[1] = {}
multifunctionMap[1]["name"] = "RSET"
multifunctionMap[1]["enabled"] = true

multifunctionMap[2] = {}
multifunctionMap[2]["name"] = "MIX"
multifunctionMap[2]["enabled"] = true
multifunctionMap[2]["menu"] = 1
multifunctionMap[2]["row"] = 1
multifunctionMap[2]["upDnSelectable"] = true
multifunctionMap[2]["upDnConfirmRequired"] = true
multifunctionMap[2]["defaultUpDnMode"] = 1
multifunctionMap[2]["currentUpDnMode"] = multifunctionMap[2]["defaultUpDnMode"]
multifunctionMap[2]["confirmDelay"] = confirmDelay
multifunctionMap[2]["min"] = 0
multifunctionMap[2]["max"] = 2
multifunctionMap[2]["modes"] = {}
multifunctionMap[2]["modes"][0] = "LEAN"
multifunctionMap[2]["modes"][1] = "NORM"
multifunctionMap[2]["modes"][2] = "RICH"
--multifunctionMap[2]["confirmButtonMap"] = {}

multifunctionMap[3] = {}
multifunctionMap[3]["name"] = "DIFF"
multifunctionMap[3]["enabled"] = true
multifunctionMap[3]["menu"] = 1
multifunctionMap[3]["row"] = 3
multifunctionMap[3]["upDnSelectable"] = true
multifunctionMap[3]["upDnConfirmRequired"] = true
multifunctionMap[3]["defaultUpDnMode"] = 5
multifunctionMap[3]["currentUpDnMode"] = multifunctionMap[3]["defaultUpDnMode"]
multifunctionMap[3]["confirmDelay"] = confirmDelay
multifunctionMap[3]["min"] = 0
multifunctionMap[3]["max"] = 10
multifunctionMap[3]["modes"] = {}
multifunctionMap[3]["modes"][0] = "50%"
multifunctionMap[3]["modes"][1] = "55%"
multifunctionMap[3]["modes"][2] = "60%"
multifunctionMap[3]["modes"][3] = "65%"
multifunctionMap[3]["modes"][4] = "70%"
multifunctionMap[3]["modes"][5] = "75%"
multifunctionMap[3]["modes"][6] = "80%"
multifunctionMap[3]["modes"][7] = "85%"
multifunctionMap[3]["modes"][8] = "90%"
multifunctionMap[3]["modes"][9] = "95%"
multifunctionMap[3]["modes"][10] = "100%"

multifunctionMap[4] = {}
multifunctionMap[4]["name"] = "BIAS"
multifunctionMap[4]["enabled"] = true
multifunctionMap[4]["menu"] = 1
multifunctionMap[4]["row"] = 2
multifunctionMap[4]["upDnSelectable"] = true
multifunctionMap[4]["upDnConfirmRequired"] = true
multifunctionMap[4]["defaultUpDnMode"] = 10
multifunctionMap[4]["currentUpDnMode"] = multifunctionMap[4]["defaultUpDnMode"]
multifunctionMap[4]["confirmDelay"] = confirmDelay
multifunctionMap[4]["min"] = 0
multifunctionMap[4]["max"] = 10
multifunctionMap[4]["modes"] = {}
multifunctionMap[4]["modes"][0] = "50%"
multifunctionMap[4]["modes"][1] = "52%"
multifunctionMap[4]["modes"][2] = "54%"
multifunctionMap[4]["modes"][3] = "56%"
multifunctionMap[4]["modes"][4] = "58%"
multifunctionMap[4]["modes"][5] = "60%"
multifunctionMap[4]["modes"][6] = "62%"
multifunctionMap[4]["modes"][7] = "64%"
multifunctionMap[4]["modes"][8] = "66%"
multifunctionMap[4]["modes"][9] = "68%"
multifunctionMap[4]["modes"][10] = "70%"

multifunctionMap[5] = {}
multifunctionMap[5]["name"] = "AERO"
multifunctionMap[5]["enabled"] = true
multifunctionMap[5]["menu"] = 1
multifunctionMap[5]["row"] = 4
multifunctionMap[5]["upDnSelectable"] = true
multifunctionMap[5]["upDnConfirmRequired"] = true
multifunctionMap[5]["defaultUpDnMode"] = 4
multifunctionMap[5]["currentUpDnMode"] = multifunctionMap[5]["defaultUpDnMode"]
multifunctionMap[5]["confirmDelay"] = confirmDelay
multifunctionMap[5]["min"] = 0
multifunctionMap[5]["max"] = 10
multifunctionMap[5]["modes"] = {}
multifunctionMap[5]["modes"][0] = "1"
multifunctionMap[5]["modes"][1] = "2"
multifunctionMap[5]["modes"][2] = "3"
multifunctionMap[5]["modes"][3] = "4"
multifunctionMap[5]["modes"][4] = "5"
multifunctionMap[5]["modes"][5] = "6"
multifunctionMap[5]["modes"][6] = "7"
multifunctionMap[5]["modes"][7] = "8"
multifunctionMap[5]["modes"][8] = "9"
multifunctionMap[5]["modes"][9] = "10"
multifunctionMap[5]["modes"][9] = "11"

multifunctionMap[6] = {}
multifunctionMap[6]["name"] = "TYRE"
multifunctionMap[6]["enabled"] = true
multifunctionMap[6]["menu"] = 1
multifunctionMap[6]["row"] = 5
multifunctionMap[6]["upDnSelectable"] = true
multifunctionMap[6]["upDnConfirmRequired"] = true
multifunctionMap[6]["defaultUpDnMode"] = 2
multifunctionMap[6]["currentUpDnMode"] = multifunctionMap[6]["defaultUpDnMode"]
multifunctionMap[6]["currentPosition"] = multifunctionMap[6]["defaultUpDnMode"]
multifunctionMap[6]["confirmDelay"] = confirmDelay
multifunctionMap[6]["min"] = 0
multifunctionMap[6]["max"] = 4
multifunctionMap[6]["modes"] = {}
multifunctionMap[6]["modes"][0] = "ULTR"
multifunctionMap[6]["modes"][1] = "OPTN"
multifunctionMap[6]["modes"][2] = "PRME"
multifunctionMap[6]["modes"][3] = "INTR"
multifunctionMap[6]["modes"][4] = "WETS"

multifunctionMap[7] = {}
multifunctionMap[7]["name"] = "OSP"
multifunctionMap[7]["enabled"] = true
multifunctionMap[7]["upDnSelectable"] = true

multifunctionMap[8] = {}
multifunctionMap[8]["name"] = "PIT"
multifunctionMap[9] = {}
multifunctionMap[9]["name"] = "SPR"
multifunctionMap[10] = {}
multifunctionMap[10]["name"] = "OFF"

multifunctionMap[11] = {}
multifunctionMap[11]["name"] = "CAM"
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
multifunctionMap[12]["name"] = "INFO"
multifunctionMap[12]["enabled"] = true
multifunctionMap[12]["upDnSelectable"] = true
multifunctionMap[12]["upDnConfirmRequired"] = false
multifunctionMap[12]["defaultUpDnMode"] = 0
multifunctionMap[12]["currentUpDnMode"] = multifunctionMap[12]["defaultUpDnMode"]
multifunctionMap[12]["min"] = 0
multifunctionMap[12]["max"] = 4
multifunctionMap[12]["wrap"] = true
multifunctionMap[12]["modes"] = {}
multifunctionMap[12]["modes"][0] = "NONE"
multifunctionMap[12]["modes"][1] = "SETT"
multifunctionMap[12]["modes"][2] = "WEAR"
multifunctionMap[12]["modes"][3] = "TEMP"
multifunctionMap[12]["modes"][4] = "INFO"

-- Used by the overtake button
fuelMultiFunction = multifunctionMap[2]
overtakeButtonEnabled = true
overtakeOspOverdrive = true

function custom_init_Event(scriptfile)	
end

function getButtonMap(currentMultifunction)
	if currentMultifunction["menu"] ~= nil then
		return getTrackableQuickMenuSettingButtons(currentMultifunction)
	elseif currentMultifunction["name"] == "INFO" then
		return getOpenMenuButtons(currentMultifunction["currentUpDnMode"])
	elseif currentMultifunction["confirmButtonMap"] ~= nil then
		-- This is for multifunctions where up/dn modes aren't used, just a single button map for confirm
		return currentMultifunction["confirmButtonMap"]		
	else
		-- F1 2015 quick-menu doesn't keep track of what's selected so button maps are always static
		return currentMultifunction["buttonMap"][currentMultifunction["currentUpDnMode"]]
	end
end
