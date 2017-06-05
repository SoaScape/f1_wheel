safetyCarMultifunctionName = "SAFE"
local lastMode = ""
local safetyCarModeActive = false
local autoMixOnBeforeSafetyCar = false
local autoDiffOnBeforeSafetyCar = false
local safetyCarActiveMessageDelay = 10000
local lastSafetyCarMessageTime = 0

local function activateSafetyCarMode()
	safetyCarModeActive = true
	
	if isOvertakeActive() then
		toggleOvertakeMode(false, false)
	end

	fuelMultiFunction["currentUpDnMode"] = fuelMultiFunction["min"]
	nextActiveFuelMix = fuelMultiFunction["currentUpDnMode"]
	confirmSelection(nil, nil, getButtonMap(fuelMultiFunction), false)

	autoDiffOnBeforeSafetyCar = isAutoDiffActive()
	autoMixOff()
	autoDiffOff()
end

local function safetyCarEnd()
	safetyCarModeActive = false
	
	fuelMultiFunction["currentUpDnMode"] = fuelMultiFunction["max"]
	nextActiveFuelMix = fuelMultiFunction["currentUpDnMode"]
	confirmSelection(nil, nil, getButtonMap(fuelMultiFunction), false)

	if autoDiffOnBeforeSafetyCar then
		autoDiffOn()
	end
end

local function safetyCarModeSelected()
	if GetContextInfo("yellow_flag") then
		activateSafetyCarMode()
	else
		currentMultifunction = nil
		display(safetyCarMultifunctionName, "UNAV", mDisplay_Info_Delay)
	end	
end

function safetyCarModeRegularProcessing()
	if mSessionEnter == 1 and not(m_is_sim_idle) then
		if safetyCarModeActive then
			if GetContextInfo("yellow_flag") then
				if getTks() - lastSafetyCarMessageTime >= safetyCarActiveMessageDelay then
					lastSafetyCarMessageTime = getTks()
					display("SAFE", " CAR", 1000)
				end
			else
				safetyCarEnd()
				display("SAFE", " END", 2000)
			end
		else
			if safetyCarModeEnabled and currentMultifunction ~= nil then
				currentMode = currentMultifunction["name"]
				if currentMode == safetyCarMultifunctionName then
					if currentMode ~= lastMode then
						safetyCarModeSelected()
					end
				end
				lastMode = currentMode
			end
		end
	end
end

function resetSafetyCarMode()
	safetyCarModeActive = false
	autoMixOnBeforeSafetyCar = false
	autoDiffOnBeforeSafetyCar = false
end
