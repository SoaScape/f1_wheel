safetyCarMultifunctionName = "SAFE"
local lastMode = ""
local safetyCarModeActive = false
local autoMixOnBeforeSafetyCar = false
local autoDiffOnBeforeSafetyCar = false

local function activateSafetyCarMode()
	safetyCarModeActive = true
	
	if isOvertakeActive() then
		toggleOvertakeMode(false, false)
	end

	fuelMultiFunction["currentUpDnMode"] = fuelMultiFunction["min"]
	nextActiveFuelMix = fuelMultiFunction["currentUpDnMode"]
	confirmSelection(nil, nil, getButtonMap(fuelMultiFunction), false)
	
	autoMixOnBeforeSafetyCar = isAutoMixActive()
	if autoMixOnBeforeSafetyCar then
		autoMixOff()
	end
	
	autoDiffOnBeforeSafetyCar = isAutoDiffActive()
	if autoDiffOnBeforeSafetyCar then
		autoDiffOff()
	end
end

local function safetyCarEnd()
	safetyCarModeActive = false
	
	fuelMultiFunction["currentUpDnMode"] = fuelMultiFunction["max"]
	nextActiveFuelMix = fuelMultiFunction["currentUpDnMode"]
	confirmSelection(nil, nil, getButtonMap(fuelMultiFunction), false)
	
	if not(isOvertakeActive) then
		toggleOvertakeMode(false, true)
	end
	
	if autoMixOnBeforeSafetyCar then
		autoMixOn()
	end	
	if autoDiffOnBeforeSafetyCar then
		autoDiffOn()
	end
end

local function safetyCarModeSelected()
	local displayDelay = 2000
	if mSessionEnter == 1 and not(m_is_sim_idle) and GetContextInfo("yellow_flag") then		
		left = safetyCarMultifunctionName
		right = " CAR"
		activateSafetyCarMode()
	else
		left = safetyCarMultifunctionName
		right = "UNAV"
		currentMultifunction = nil
		displayDelay = mDisplay_Info_Delay
	end
	display(left, right, displayDelay)
end

function safetyCarModeRegularProcessing()
	if safetyCarModeActive then
		if mSessionEnter == 1 and not(m_is_sim_idle) and not(GetContextInfo("yellow_flag")) then
			safetyCarEnd()
			display("SAFE", " END", 2000)
		end
	else
		if safetyCarModeEnabled and currentMultifunction ~= nil then
			local inScMode = currentMultifunction["name"] == safetyCarMultifunctionName
			local modeName = currentMultifunction["name"]
			
			if inScMode then
				if currentMultifunction["name"] ~= lastMode then
					safetyCarModeSelected()
				end
			end		
			lastMode = modeName
		end
	end
end

function resetSafetyCarMode()
	safetyCarModeActive = false
	autoMixOnBeforeSafetyCar = false
	autoDiffOnBeforeSafetyCar = false
end
