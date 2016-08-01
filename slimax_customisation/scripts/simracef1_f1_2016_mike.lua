require "scripts/mikes_custom_plugins/mike_all_custom_plugins"

multifunctionMap = {}
keystrokeDelay = 200

quickMenuToggleButton = "NUMPAD8"
quickMenuUp = "NUMPAD8"
quickMenuDn = "NUMPAD2"
quickMenuLeft = "NUMPAD4"
quickMenuRight = "NUMPAD6"
trackableDecrementButton = quickMenuLeft
trackableIncrementButton = quickMenuRight

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
multifunctionMap[1]["trackableButtonMap"] = {}
multifunctionMap[1]["trackableButtonMap"][0] = quickMenuToggleButton

multifunctionMap[2] = {}
multifunctionMap[2]["name"] = "TYRE"
multifunctionMap[2]["enabled"] = true
multifunctionMap[2]["upDnSelectable"] = true
multifunctionMap[2]["upDnConfirmRequired"] = true
multifunctionMap[2]["defaultUpDnMode"] = 2
multifunctionMap[2]["currentUpDnMode"] = multifunctionMap[2]["defaultUpDnMode"]
multifunctionMap[2]["min"] = 0
multifunctionMap[2]["max"] = 4
multifunctionMap[2]["modes"] = {}
multifunctionMap[2]["modes"][0] = "WETS"
multifunctionMap[2]["modes"][1] = "INTR"
multifunctionMap[2]["modes"][2] = "PRME"
multifunctionMap[2]["modes"][3] = "OPTN"
multifunctionMap[2]["modes"][4] = "SOPT"
multifunctionMap[5]["trackableButtonMap"] = {}
multifunctionMap[5]["trackableButtonMap"][0] = quickMenuToggleButton
multifunctionMap[5]["trackableButtonMap"][1] = quickMenuDn

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
multifunctionMap[5]["trackableButtonMap"] = {}
multifunctionMap[5]["trackableButtonMap"][0] = quickMenuToggleButton
multifunctionMap[5]["trackableButtonMap"][1] = quickMenuDn

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
multifunctionMap[5]["trackableButtonMap"] = {}
multifunctionMap[5]["trackableButtonMap"][0] = quickMenuToggleButton
multifunctionMap[5]["trackableButtonMap"][1] = quickMenuDn

multifunctionMap[5] = {}
multifunctionMap[5]["name"] = "DIFF"
multifunctionMap[5]["enabled"] = true
multifunctionMap[5]["upDnSelectable"] = true
multifunctionMap[5]["upDnConfirmRequired"] = true
multifunctionMap[5]["defaultUpDnMode"] = 5
multifunctionMap[5]["currentUpDnMode"] = multifunctionMap[5]["defaultUpDnMode"]
multifunctionMap[5]["currentPosition"] = nil
multifunctionMap[5]["min"] = 0
multifunctionMap[5]["max"] = 10
multifunctionMap[5]["modes"] = {}
multifunctionMap[5]["modes"][0] = " 0%"
multifunctionMap[5]["modes"][1] = "10%"
multifunctionMap[5]["modes"][2] = "20%"
multifunctionMap[5]["modes"][3] = "30%"
multifunctionMap[5]["modes"][4] = "40%"
multifunctionMap[5]["modes"][5] = "50%"
multifunctionMap[5]["modes"][6] = "60%"
multifunctionMap[5]["modes"][7] = "70%"
multifunctionMap[5]["modes"][8] = "80%"
multifunctionMap[5]["modes"][9] = "90%"
multifunctionMap[5]["modes"][10] = "100%"
multifunctionMap[5]["trackableButtonMap"] = {}
multifunctionMap[5]["trackableButtonMap"][0] = quickMenuToggleButton
multifunctionMap[5]["trackableButtonMap"][1] = quickMenuDn

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
fuelMultiFunction = multifunctionMap[1]
overtakeButtonEnabled = true

function custom_init_Event(scriptfile)	
end
