safetyCarMultifunctionName = "SAFE"
local safetyCarModeActive = false
local safetyCarActiveMessageDelay = 10000
local lastSafetyCarMessageTime = 0

local function activateSafetyCarMode()
	safetyCarModeActive = true
	
	if isOvertakeActive() then
		toggleOvertakeMode(false, false)
	end

	fuelMultiFunction["currentUpDnMode"] = fuelMultiFunction["min"]
	confirmSelection(nil, nil, getButtonMap(fuelMultiFunction, false, true), false)
	ersMultiFunction["currentUpDnMode"] = ersMultiFunction["min"]
	confirmSelection(nil, nil, getButtonMap(ersMultiFunction, true, false), false)
	autoMixOff()
	autoMixInhibitOn()
	autoDiffInhibitOn()
end

local function safetyCarEnd()
	safetyCarModeActive = false
	fuelMultiFunction["currentUpDnMode"] = fuelMultiFunction["max"]
	confirmSelection(nil, nil, getButtonMap(fuelMultiFunction, false, true), false)
	ersMultiFunction["currentUpDnMode"] = ersMultiFunction["max"]
	confirmSelection(nil, nil, getButtonMap(ersMultiFunction, true, false), false)	
	autoDiffInhibitOff()
	autoMixInhibitOff()
	if safetyCarLedPattern ~= nil then
		deactivatePermanentLed(safetyCarLedPattern)
	else
		display("SAFE", " END", 2000)
	end
end

function safetyCarModeRegularProcessing()	
	if mSessionEnter == 1 and not(m_is_sim_idle) then
		if safetyCarModeActive then
			if getSafetyCar() then
				if safetyCarLedPattern ~= nil then
					activatePermanentLed(safetyCarLedPattern, 0, false)
				elseif getTks() - lastSafetyCarMessageTime >= safetyCarActiveMessageDelay then
					lastSafetyCarMessageTime = getTks()
					display("SAFE", " CAR", 1000)
				end
			else
				safetyCarEnd()
			end
		elseif getSafetyCar() then
			activateSafetyCarMode()
		end
	end
end

function resetSafetyCarMode()
	safetyCarModeActive = false
	lastSafetyCarMessageTime = 0
end
