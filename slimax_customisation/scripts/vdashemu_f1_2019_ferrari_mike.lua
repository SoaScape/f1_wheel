require "scripts/mikes_custom_plugins/mike_codemasters_f1_utils"
require "scripts/mikes_custom_plugins/mike_all_custom_plugins"

myDevice = 15 -- VDashEmu

multiFunctionSwitchId = 3
setValueSwitchId = 2
progButton = 10
confirmButton = 22
secondaryConfirmButton = 10
upButton = 1
downButton = 2
upEncoder = 17
downEncoder = 18
overtakeButton = 15
overtakeLatch = true

oneSwCtrlPos = 1
oneSWActivated = true

saveFuelMessageLedTriggered = true
overTakeMessageLedTriggered = true
autoMixLedTriggered = true
autoDiffLedTriggered = true

overtakeLedPatterns = {}
overtakeLedPatterns[0] = 0x100 -- External LED 6 (triggers message on vdash)
overtakeLedPatterns[1] = 0x100 -- External LED 6 (triggers message on vdash)
resetLedPattern = 0
autoMixLedPattern = 0x80 -- External LED 5 (triggers message on vdash)
autoDiffLedPattern = 0x40 -- External LED 4 (triggers message on vdash)
safetyCarLedPattern = 0x20 -- External LED 3 (triggers message on vdash)

raceStartLedPatterns = {}
raceGoLedPattern = 0x0

progBlinkLedPatterns = {}

lowFuelLedPattern = 0x2 -- Left red LED
saveFuelLedPattern = 0x200 -- External LED 7 (triggers message on vdash)

minFuel = 0

numMenus = 5

confirmDelay = 1000

multifunctionMap = {}

multifunctionMap[1] = {}
multifunctionMap[1]["name"] = "RSET"
multifunctionMap[1]["enabled"] = true

multifunctionMap[2] = {}
multifunctionMap[2]["name"] = "MIX "
multifunctionMap[2]["enabled"] = true
multifunctionMap[2]["mfdShortcut"] = true
multifunctionMap[2]["incrementKey"] = "F"
multifunctionMap[2]["decrementKey"] = "V"
multifunctionMap[2]["currentSettingMethod"] = getFuelMix
multifunctionMap[2]["row"] = 1
multifunctionMap[2]["upDnSelectable"] = true
multifunctionMap[2]["upDnConfirmRequired"] = true
multifunctionMap[2]["defaultUpDnMode"] = 1
multifunctionMap[2]["currentUpDnMode"] = multifunctionMap[2]["defaultUpDnMode"]
multifunctionMap[2]["min"] = 0
multifunctionMap[2]["max"] = 3
multifunctionMap[2]["modes"] = {}
multifunctionMap[2]["modes"][0] = "LEAN"
multifunctionMap[2]["modes"][1] = "NORM"
multifunctionMap[2]["modes"][2] = "RICH"
multifunctionMap[2]["modes"][3] = "QUAL"
multifunctionMap[2]["fuelUsageOffset"] = {}
multifunctionMap[2]["fuelUsageOffset"][0] = 0.681818182
multifunctionMap[2]["fuelUsageOffset"][1] = 1
multifunctionMap[2]["fuelUsageOffset"][2] = 1.363636364
multifunctionMap[2]["fuelUsageOffset"][3] = 1.363636364

multifunctionMap[3] = {}
multifunctionMap[3]["name"] = "BIAS"
multifunctionMap[3]["enabled"] = true
multifunctionMap[3]["mfdShortcut"] = true
multifunctionMap[3]["incrementKey"] = "G"
multifunctionMap[3]["decrementKey"] = "B"
multifunctionMap[3]["currentSettingMethod"] = getRearBrakeBiasIndex
multifunctionMap[3]["row"] = 2
multifunctionMap[3]["upDnSelectable"] = true
multifunctionMap[3]["upDnConfirmRequired"] = true
multifunctionMap[3]["defaultUpDnMode"] = 10
multifunctionMap[3]["currentUpDnMode"] = multifunctionMap[3]["defaultUpDnMode"]
multifunctionMap[3]["min"] = 0
multifunctionMap[3]["max"] = 10
multifunctionMap[3]["modes"] = {}
multifunctionMap[3]["modes"][0] = 50
multifunctionMap[3]["modes"][1] = 52
multifunctionMap[3]["modes"][2] = 54
multifunctionMap[3]["modes"][3] = 56
multifunctionMap[3]["modes"][4] = 58
multifunctionMap[3]["modes"][5] = 60
multifunctionMap[3]["modes"][6] = 62
multifunctionMap[3]["modes"][7] = 64
multifunctionMap[3]["modes"][8] = 66
multifunctionMap[3]["modes"][9] = 68
multifunctionMap[3]["modes"][10] =70

multifunctionMap[4] = {}
multifunctionMap[4]["name"] = "DIFF"
multifunctionMap[4]["enabled"] = true
multifunctionMap[4]["mfdShortcut"] = true
multifunctionMap[4]["incrementKey"] = "H"
multifunctionMap[4]["decrementKey"] = "N"
multifunctionMap[4]["currentSettingMethod"] = getDiffIndex
multifunctionMap[4]["row"] = 3
multifunctionMap[4]["upDnSelectable"] = true
multifunctionMap[4]["upDnConfirmRequired"] = true
multifunctionMap[4]["defaultUpDnMode"] = 7
multifunctionMap[4]["resetPosition"] = multifunctionMap[4]["defaultUpDnMode"]
multifunctionMap[4]["currentUpDnMode"] = multifunctionMap[4]["resetPosition"]
multifunctionMap[4]["currentPosition"] = multifunctionMap[4]["resetPosition"]
multifunctionMap[4]["min"] = 0
multifunctionMap[4]["max"] = 10
multifunctionMap[4]["modes"] = {}
multifunctionMap[4]["modes"][0] = 50
multifunctionMap[4]["modes"][1] = 55
multifunctionMap[4]["modes"][2] = 60
multifunctionMap[4]["modes"][3] = 65
multifunctionMap[4]["modes"][4] = 70
multifunctionMap[4]["modes"][5] = 75
multifunctionMap[4]["modes"][6] = 80
multifunctionMap[4]["modes"][7] = 85
multifunctionMap[4]["modes"][8] = 90
multifunctionMap[4]["modes"][9] = 95
multifunctionMap[4]["modes"][10] = 100

multifunctionMap[5] = {}
multifunctionMap[5]["name"] = "AERO"
multifunctionMap[5]["enabled"] = true
multifunctionMap[5]["menu"] = 2
multifunctionMap[5]["row"] = 1
multifunctionMap[5]["upDnSelectable"] = true
multifunctionMap[5]["upDnConfirmRequired"] = true
multifunctionMap[5]["defaultUpDnMode"] = 4
multifunctionMap[5]["resetPosition"] = multifunctionMap[5]["defaultUpDnMode"]
multifunctionMap[5]["currentUpDnMode"] = multifunctionMap[5]["resetPosition"]
multifunctionMap[5]["currentPosition"] = multifunctionMap[5]["resetPosition"]
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
multifunctionMap[6]["upDnSelectable"] = true
multifunctionMap[6]["upDnConfirmRequired"] = true
multifunctionMap[6]["defaultUpDnMode"] = 2
multifunctionMap[6]["currentUpDnMode"] = multifunctionMap[6]["defaultUpDnMode"]
multifunctionMap[6]["min"] = 0
multifunctionMap[6]["max"] = 4
multifunctionMap[6]["modes"] = {}
multifunctionMap[6]["modes"][0] = "HARD"
multifunctionMap[6]["modes"][1] = "MEDM"
multifunctionMap[6]["modes"][2] = "SOFT"
multifunctionMap[6]["modes"][3] = "INTR"
multifunctionMap[6]["modes"][4] = "WETS"
multifunctionMap[6]["voiceMenuPage"] = 2
multifunctionMap[6]["voiceMenuRows"] = {}
multifunctionMap[6]["voiceMenuRows"][0] = 1
multifunctionMap[6]["voiceMenuRows"][1] = 2
multifunctionMap[6]["voiceMenuRows"][2] = 3
multifunctionMap[6]["voiceMenuRows"][3] = 4
multifunctionMap[6]["voiceMenuRows"][4] = 5

multifunctionMap[7] = {}
multifunctionMap[7]["name"] = "OSP"
multifunctionMap[7]["enabled"] = true
multifunctionMap[7]["upDnSelectable"] = true

multifunctionMap[8] = {}
multifunctionMap[8]["name"] = "TRCK"
multifunctionMap[8]["wrap"] = true
multifunctionMap[8]["enabled"] = true
multifunctionMap[8]["noReset"] = true
multifunctionMap[8]["upDnSelectable"] = true
multifunctionMap[8]["defaultUpDnMode"] = 0
multifunctionMap[8]["currentUpDnMode"] = multifunctionMap[8]["defaultUpDnMode"]
multifunctionMap[8]["upDnConfirmRequired"] = true
multifunctionMap[8]["min"] = 0
multifunctionMap[8]["max"] = 19
multifunctionMap[8]["modes"] = {}
multifunctionMap[8]["modes"][0] = "ASTL"
multifunctionMap[8]["modes"][1] = "CHIN"
multifunctionMap[8]["modes"][2] = "BAHR"
multifunctionMap[8]["modes"][3] = "RUSS"
multifunctionMap[8]["modes"][4] = "SPAN"
multifunctionMap[8]["modes"][5] = "MONA"
multifunctionMap[8]["modes"][6] = "CAND"
multifunctionMap[8]["modes"][7] = "AZER"
multifunctionMap[8]["modes"][8] = "AUST"
multifunctionMap[8]["modes"][9] = "BRIT"
multifunctionMap[8]["modes"][10] = "HUNG"
multifunctionMap[8]["modes"][11] = "BELG"
multifunctionMap[8]["modes"][12] = "ITLY"
multifunctionMap[8]["modes"][13] = "SING"
multifunctionMap[8]["modes"][14] = "MALY"
multifunctionMap[8]["modes"][15] = "JAPN"
multifunctionMap[8]["modes"][16] = " USA"
multifunctionMap[8]["modes"][17] = "MEXI"
multifunctionMap[8]["modes"][18] = "BRAZ"
multifunctionMap[8]["modes"][19] = " ABU"

multifunctionMap[9] = {}
multifunctionMap[9]["name"] = startMultifunctionName
multifunctionMap[9]["display"] = false

multifunctionMap[10] = {}
multifunctionMap[10]["name"] = autoMixMultifunctionName
multifunctionMap[10]["enabled"] = true

multifunctionMap[11] = {}
multifunctionMap[11]["name"] = autoDiffMultifunctionName
multifunctionMap[11]["enabled"] = true

multifunctionMap[12] = {}
multifunctionMap[12]["name"] = " ERS"
multifunctionMap[12]["display"] = true
multifunctionMap[12]["enabled"] = true
multifunctionMap[12]["mfdShortcut"] = true
multifunctionMap[12]["incrementKey"] = "K"
multifunctionMap[12]["decrementKey"] = ","
multifunctionMap[12]["currentSettingMethod"] = getErsMode
multifunctionMap[12]["row"] = 7
multifunctionMap[12]["upDnSelectable"] = true
multifunctionMap[12]["upDnConfirmRequired"] = true
multifunctionMap[12]["defaultUpDnMode"] = 2
multifunctionMap[12]["currentUpDnMode"] = multifunctionMap[12]["defaultUpDnMode"]
multifunctionMap[12]["min"] = 0
multifunctionMap[12]["max"] = 5
multifunctionMap[12]["fastest"] = 4
multifunctionMap[12]["modes"] = {}
multifunctionMap[12]["modes"][0] = "NONE"
multifunctionMap[12]["modes"][1] = "LOW"
multifunctionMap[12]["modes"][2] = "MEDM"
multifunctionMap[12]["modes"][3] = "HIGH"
multifunctionMap[12]["modes"][4] = "OVTK"
multifunctionMap[12]["modes"][5] = " HOT"

tracks = {}
tracks[0] = "ASTL"
tracks[1] = "FRAN"
tracks[2] = "CHIN"
tracks[3] = "BAHR"
tracks[4] = "SPAN"
tracks[5] = "MONA"
tracks[6] = "CAND"
tracks[7] = "SILV"
tracks[8] = "GERM"
tracks[9] = "HUNG"
tracks[10] = "BELG"
tracks[11] = "ITLY"
tracks[12] = "SING"
tracks[13] = "JAPN"
tracks[14] = " ABU"
tracks[15] = "COTA"
tracks[16] = "BRAZ"
tracks[17] = "AUST"
tracks[18] = "RUSS"
tracks[19] = "MEXI"
tracks[20] = "AZER"
-- Short Versions Next
tracks[21] = tracks[3]
tracks[22] = tracks[7]
tracks[23] = tracks[15]
tracks[24] = tracks[13]

-- Used by the overtake button
fuelMultiFunction = multifunctionMap[2]
biasMultiFunction = multifunctionMap[3]
diffMultiFunction = multifunctionMap[4]
trackMultiFunction = multifunctionMap[8]
ersMultiFunction = multifunctionMap[12]
overtakeButtonEnabled = true
overtakeOspOverdrive = false
autoMixEnabled = true
autoDiffEnabled = true
raceStartModeEnabled = true
safetyCarModeEnabled = true


function custom_init_Event(scriptfile)
end

function getButtonMap(currentMultifunction, dontCloseMenu)
	if currentMultifunction["voiceMenuPage"] ~= nil then
		return getVoiceMenuButtons(currentMultifunction)
	elseif currentMultifunction["mfdShortcut"] then
		return getMfdShortcutButtons(currentMultifunction, dontCloseMenu)
	elseif currentMultifunction["menu"] ~= nil then
		return getMfdMenuButtons(currentMultifunction)
	else
		return nil
	end
end

function customReset()
	lastMix = -1
	lastBias = -1
end
