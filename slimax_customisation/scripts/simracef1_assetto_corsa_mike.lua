require "scripts/mikes_custom_plugins/mike_all_custom_plugins"

minFuel = 0

multifunctionMap = {}

multifunctionMap[1] = {}
multifunctionMap[1]["name"] = "RSET"
multifunctionMap[1]["display"] = true

multifunctionMap[2] = {}
multifunctionMap[2]["name"] = "MIX"
multifunctionMap[2]["display"] = true
multifunctionMap[2]["defaultUpDnMode"] = 1
multifunctionMap[2]["currentUpDnMode"] = multifunctionMap[2]["defaultUpDnMode"]
multifunctionMap[2]["min"] = 1
multifunctionMap[2]["max"] = 1
multifunctionMap[2]["modes"] = {}
multifunctionMap[2]["modes"][1] = "NORM"
multifunctionMap[2]["fuelUsageOffset"] = {}
multifunctionMap[2]["fuelUsageOffset"][1] = 1

multifunctionMap[3] = {}
multifunctionMap[3]["name"] = "DIFF"
multifunctionMap[3]["display"] = true

multifunctionMap[4] = {}
multifunctionMap[4]["name"] = "BIAS"
multifunctionMap[4]["display"] = true

multifunctionMap[5] = {}
multifunctionMap[5]["name"] = "AERO"
multifunctionMap[5]["display"] = true

multifunctionMap[6] = {}
multifunctionMap[6]["name"] = "TYRE"
multifunctionMap[6]["display"] = true

multifunctionMap[7] = {}
multifunctionMap[7]["name"] = "OSP"
multifunctionMap[7]["display"] = true

multifunctionMap[8] = {}
multifunctionMap[8]["name"] = "PIT"
multifunctionMap[8]["display"] = true
multifunctionMap[9] = {}
multifunctionMap[9]["name"] = "SPR"
multifunctionMap[9]["display"] = true
multifunctionMap[10] = {}
multifunctionMap[10]["name"] = "DATA"
multifunctionMap[10]["enabled"] = true
multifunctionMap[11] = {}
multifunctionMap[11]["name"] = autoMixMultifunctionName
multifunctionMap[11]["display"] = true

multifunctionMap[12] = {}
multifunctionMap[12]["name"] = startMultifunctionName
multifunctionMap[12]["display"] = false

-- Used by the overtake button
fuelMultiFunction = multifunctionMap[2]
overtakeButtonEnabled = false
overtakeOspOverdrive = false
autoMixEnabled = false

function custom_init_Event(scriptfile)
end

function getButtonMap(currentMultifunction)	
	-- This is for multifunctions where up/dn modes aren't used, just a single button map for confirm
	return currentMultifunction["confirmButtonMap"]
end
