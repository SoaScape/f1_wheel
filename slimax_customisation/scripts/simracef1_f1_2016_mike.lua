require "scripts/mikes_custom_plugins/mike_codemasters_f1_utils"
require "scripts/mikes_custom_plugins/mike_all_custom_plugins"

minFuel = 1

numMenus = 4

confirmDelay = 1000

customKeystrokeDelays = {}
customKeystrokeDelays[quickMenuLeft] = 40
customKeystrokeDelays[quickMenuRight] = 40
customKeystrokeDelays[quickMenuUp] = 40
customKeystrokeDelays[quickMenuDn] = 40

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
multifunctionMap[2]["min"] = 0
multifunctionMap[2]["max"] = 2
multifunctionMap[2]["modes"] = {}
multifunctionMap[2]["modes"][0] = "LEAN"
multifunctionMap[2]["modes"][1] = "NORM"
multifunctionMap[2]["modes"][2] = "RICH"
multifunctionMap[2]["fuelUsageOffset"] = {}
multifunctionMap[2]["fuelUsageOffset"][0] = 0.681818182
multifunctionMap[2]["fuelUsageOffset"][1] = 1
multifunctionMap[2]["fuelUsageOffset"][2] = 1.363636364

multifunctionMap[3] = {}
multifunctionMap[3]["name"] = "DIFF"
multifunctionMap[3]["enabled"] = true
multifunctionMap[3]["menu"] = 1
multifunctionMap[3]["row"] = 3
multifunctionMap[3]["upDnSelectable"] = true
multifunctionMap[3]["upDnConfirmRequired"] = true
multifunctionMap[3]["defaultUpDnMode"] = 5
multifunctionMap[3]["currentUpDnMode"] = multifunctionMap[3]["defaultUpDnMode"]
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
multifunctionMap[6]["min"] = 0
multifunctionMap[6]["max"] = 4
multifunctionMap[6]["modes"] = {}
multifunctionMap[6]["modes"][4] = "ULTR"
multifunctionMap[6]["modes"][3] = "OPTN"
multifunctionMap[6]["modes"][2] = "PRME"
multifunctionMap[6]["modes"][1] = "INTR"
multifunctionMap[6]["modes"][0] = "WETS"
multifunctionMap[6]["voiceMenuPage"] = 2
multifunctionMap[6]["voiceMenuRows"] = {}
multifunctionMap[6]["voiceMenuRows"][2] = 1
multifunctionMap[6]["voiceMenuRows"][3] = 2
multifunctionMap[6]["voiceMenuRows"][4] = 3
multifunctionMap[6]["voiceMenuRows"][1] = 4
multifunctionMap[6]["voiceMenuRows"][0] = 5

multifunctionMap[7] = {}
multifunctionMap[7]["name"] = "OSP"
multifunctionMap[7]["enabled"] = true
multifunctionMap[7]["upDnSelectable"] = true

multifunctionMap[8] = {}
multifunctionMap[8]["name"] = "DATA"
multifunctionMap[8]["display"] = true
multifunctionMap[8]["enabled"] = true

multifunctionMap[9] = {}
multifunctionMap[9]["name"] = autoDiffMultifunctionName
multifunctionMap[9]["enabled"] = true

multifunctionMap[10] = {}
multifunctionMap[10]["name"] = "TRCK"
multifunctionMap[10]["enabled"] = true
multifunctionMap[10]["upDnSelectable"] = true
multifunctionMap[10]["defaultUpDnMode"] = 0
multifunctionMap[10]["currentUpDnMode"] = multifunctionMap[10]["defaultUpDnMode"]
multifunctionMap[10]["upDnConfirmRequired"] = true
multifunctionMap[10]["min"] = 0
multifunctionMap[10]["max"] = 19
multifunctionMap[10]["modes"] = {}
multifunctionMap[10]["modes"][0] = "ASTL"
multifunctionMap[10]["modes"][1] = "CHIN"
multifunctionMap[10]["modes"][2] = "BAHR"
multifunctionMap[10]["modes"][3] = "RUSS"
multifunctionMap[10]["modes"][4] = "SPAN"
multifunctionMap[10]["modes"][5] = "MONA"
multifunctionMap[10]["modes"][6] = "CAND"
multifunctionMap[10]["modes"][7] = "AZER"
multifunctionMap[10]["modes"][8] = "AUST"
multifunctionMap[10]["modes"][9] = "BRIT"
multifunctionMap[10]["modes"][10] = "HUNG"
multifunctionMap[10]["modes"][11] = "BELG"
multifunctionMap[10]["modes"][12] = "ITLY"
multifunctionMap[10]["modes"][13] = "SING"
multifunctionMap[10]["modes"][14] = "MALY"
multifunctionMap[10]["modes"][15] = "JAPN"
multifunctionMap[10]["modes"][16] = " USA"
multifunctionMap[10]["modes"][17] = "MEXI"
multifunctionMap[10]["modes"][18] = "BRAZ"
multifunctionMap[10]["modes"][19] = " ABU"

multifunctionMap[11] = {}
multifunctionMap[11]["name"] = autoMixMultifunctionName
multifunctionMap[11]["enabled"] = true

multifunctionMap[12] = {}
multifunctionMap[12]["name"] = startMultifunctionName
multifunctionMap[12]["display"] = false

-- Used by the overtake button
fuelMultiFunction = multifunctionMap[2]
diffMultiFunction = multifunctionMap[3]
trackMultiFunction = multifunctionMap[10]
overtakeButtonEnabled = true
overtakeOspOverdrive = false
autoMixEnabled = true
autoDiffEnabled = true
raceStartModeEnabled = true

function custom_init_Event(scriptfile)
end

function getButtonMap(currentMultifunction)
	if currentMultifunction["voiceMenuPage"] ~= nil then
		return getVoiceMenuButtons(currentMultifunction)
	elseif currentMultifunction["menu"] ~= nil then
		return getMfdMenuButtons(currentMultifunction)
	elseif currentMultifunction["name"] == "INFO" then
		return getOpenMenuButtons(currentMultifunction["currentUpDnMode"])
	else
		return nil
	end
end
