require "scripts/mikes_custom_plugins/mike_led_utils"

autoMixMultifunctionName = "AMIX"

local learnedData = {}

local config =  {}
config["INTV"] = 2100 -- minTimeBetweenMixChange
config["LOW "] = 2000 -- learnLowThrottleTimeout
config["FULL"] = 4000 -- learnFullThrottleTimeout
config["INC "] = 100  -- The amount to increment when adjusting the timeouts.
config["DISP"] = false -- Whether to display auto mix changes on the dash

local configIds = {}
configIds[0] = "INTV"
configIds[1] = "LOW "
configIds[2] = "FULL"
configIds[3] = "INC "
configIds[4] = "DISP"

local selectedConfig = 0

local displayAutoMixChanges = false
local displayTimeout = 1000

local learnFullThrottleStartTicks = 0
local learnFullThrottleStartDistance = 0
local learnFullThrottleActive = false

local learnLowThrottleStartTicks = 0
local learnLowThrottleStartDistance = 0
local learnLowThrottleActive = false

local lastMixEvent = nil
local autoMixSelected = false
local autoMixReturnMix = nil

local richModePreviouslyDisabled = false

local autoMixLedPattern = 128 -- LED 5, binary 10000000
local autoMixEventActiveBlinkTime = 400

function resetAutoMixData()
	learnedData = {}
	learnFullThrottleActive = false
	learnLowThrottleActive = false
	autoMixSelected = false
	richModePreviouslyDisabled = false
	lastMixEvent = nil
	autoMixActiveType = nil
end

local function toggleAutoMixSelected()
	if autoMixEnabled and mSessionEnter == 1 and not(m_is_sim_idle) then
		autoMixSelected = not(autoMixSelected)
		if autoMixSelected then
			autoMixOn()
			display(autoMixMultifunctionName, "ACTV", displayTimeout)
		else
			autoMixOff()
			display(autoMixMultifunctionName, " OFF", displayTimeout)
			fuelMultiFunction["currentUpDnMode"] = fuelMultiFunction["defaultUpDnMode"]
			confirmSelection(nil, nil, getButtonMap(fuelMultiFunction), false)
		end
	end
end

function isAutoMixActive()
	return autoMixSelected
end

function autoMixOn()
	if autoMixEnabled and mSessionEnter == 1 and not(m_is_sim_idle) then
		autoMixSelected = true
		richModePreviouslyDisabled = false
		activatePermanentLed(autoMixLedPattern, 0, false)
	end
end

function autoMixOff()
	if autoMixEnabled and mSessionEnter == 1 and not(m_is_sim_idle) then
		autoMixSelected = false
		autoMixActiveType = nil
		deactivatePermanentLed(autoMixLedPattern)
		deactivateBlinkingLed(autoMixLedPattern)
	end	
end

local function displaySelectedConfig()
	local setting = config[configIds[selectedConfig]]
	if configIds[selectedConfig] == "DISP" then
		if setting then
			setting = "  ON"
		else
			setting = " OFF"
		end
	end
	display(configIds[selectedConfig], setting, displayTimeout)
end

function processAutoMixButtonEvent(button)
	if autoMixEnabled then
		if button == confirmButton then
			toggleAutoMixSelected()
		elseif configIds[selectedConfig] == "DISP" and (button == upEncoder or button == downEncoder) then
			config[configIds[selectedConfig]] = not(config[configIds[selectedConfig]])
			displaySelectedConfig()
		elseif button == upButton then
			if selectedConfig < tablelength(configIds) - 1 then
				selectedConfig = selectedConfig + 1
			else
				selectedConfig = 0
			end
			displaySelectedConfig()
		elseif button == downButton then
			if selectedConfig == 0 then
				selectedConfig = tablelength(configIds) - 1
			else
				selectedConfig = selectedConfig - 1
			end
			displaySelectedConfig()
		elseif button == upEncoder then
			local inc = config["INC "]
			if configIds[selectedConfig] == "INC " then
				inc = 100
			end
			config[configIds[selectedConfig]] = config[configIds[selectedConfig]] + inc
			display(configIds[selectedConfig], config[configIds[selectedConfig]], displayTimeout)
		elseif button == downEncoder then
			local inc = config["INC "]
			if configIds[selectedConfig] == "INC " then
				inc = 100
			end
			
			if config[configIds[selectedConfig]] > inc then
				config[configIds[selectedConfig]] = config[configIds[selectedConfig]] - inc
			end
			display(configIds[selectedConfig], config[configIds[selectedConfig]], displayTimeout)
		end
	end
end

local function recentEvent(startTicks)
	if lastMixEvent ~= nil and lastMixEvent["endTicks"] ~= nil and lastMixEvent["endTicks"] + config["INTV"] > startTicks then
		return true
	else
		return false
	end	
end

local function learnTrack()	
	local throttle = GetCarInfo("throttle")
	local yellow = GetContextInfo("yellow_flag")
	if GetInPitsState() > 1 or yellow then
		learnFullThrottleActive = false
		learnLowThrottleActive = false
		return
	end

	if learnFullThrottleActive then
		if throttle < 1 then
			learnFullThrottleActive = false
			if highLearnt then
				lastMixEvent["endTicks"] = getTks()
			end
		elseif (getTks() - learnFullThrottleStartTicks) >= config["FULL"] and GetCarInfo("speed") > 100 and not (highLearnt) then							
			if recentEvent(learnFullThrottleStartTicks) then
				lastMixEvent["returnMix"] = fuelMultiFunction["max"]
				lastMixEvent = nil
				--display("ZMIX", fuelMultiFunction["modes"][fuelMultiFunction["max"]], displayTimeout)
			else				
				learnedData[learnFullThrottleStartDistance] = {}
				learnedData[learnFullThrottleStartDistance]["mix"] = fuelMultiFunction["max"]
				learnedData[learnFullThrottleStartDistance]["returnMix"] = fuelMultiFunction["defaultUpDnMode"]
				lastMixEvent = learnedData[learnFullThrottleStartDistance]
				highLearnt = true
				--display("AMIX", fuelMultiFunction["modes"][fuelMultiFunction["max"]], displayTimeout)
			end			
		end
	elseif throttle == 1 then
		learnFullThrottleStartTicks = getTks()
		learnFullThrottleStartDistance = round(GetContextInfo("lap_distance"), 0)
		learnFullThrottleActive = true
		highLearnt = false
	end	

	if learnLowThrottleActive then		
		if throttle == 1 then
			learnLowThrottleActive = false
			if lowLearnt then
				lastMixEvent["endTicks"] = getTks()
			end
		elseif (getTks() - learnLowThrottleStartTicks) >= config["LOW "] and not (lowLearnt) then			
			if recentEvent(learnLowThrottleStartTicks) then
				lastMixEvent["returnMix"] = fuelMultiFunction["min"]
				lastMixEvent = nil
				--display("ZMIX", fuelMultiFunction["modes"][fuelMultiFunction["min"]], displayTimeout)				
			else				
				learnedData[learnLowThrottleStartDistance] = {}
				learnedData[learnLowThrottleStartDistance]["mix"] = fuelMultiFunction["min"]
				learnedData[learnLowThrottleStartDistance]["returnMix"] = fuelMultiFunction["defaultUpDnMode"]
				lastMixEvent = learnedData[learnLowThrottleStartDistance]			
				lowLearnt = true
				--display("AMIX", fuelMultiFunction["modes"][fuelMultiFunction["min"]], displayTimeout)
			end
		end
	elseif throttle < 1 then
		learnLowThrottleStartTicks = getTks()
		learnLowThrottleStartDistance = round(GetContextInfo("lap_distance"), 0)
		learnLowThrottleActive = true
		lowLearnt = false
	end
end

function autoMixRegularProcessing()
	if autoMixEnabled and mSessionEnter == 1 and not(m_is_sim_idle) then
		learnTrack()
		
		local fuelTarget = getAdjustedFuelTarget()
		if fuelTarget == nil then
			fuelTarget = 1
		end
		
		if autoMixSelected then
			if autoMixActiveType == nil then -- Automix not currently set, check if we can set it
				local distance = GetContextInfo("lap_distance")
				activeAutoMixData = learnedData[round(distance, 0)]
				if activeAutoMixData ~= nil then
					local autoMix = activeAutoMixData["mix"]	
					autoMixReturnMix = activeAutoMixData["returnMix"]
					
					if fuelTarget < 0 then
						if autoMix == fuelMultiFunction["max"] then
							return -- don't process a rich mix if we're below target
						elseif autoMixReturnMix == fuelMultiFunction["max"] then
							autoMixReturnMix = fuelMultiFunction["defaultUpDnMode"]
						end
						
						if not(richModePreviouslyDisabled) then
							display("RICH", "DISB", displayTimeout)
							richModePreviouslyDisabled = true
						end						
					else
						richModePreviouslyDisabled = false
					end
					
					local multiFunctionBak = currentMultifunction
					currentMultifunction = fuelMultiFunction
					currentMultifunction["currentUpDnMode"] = autoMix
					confirmSelection("AUTO", currentMultifunction["modes"][autoMix], getButtonMap(currentMultifunction), config["DISP"])
					currentMultifunction = multiFunctionBak
					if autoMix == fuelMultiFunction["max"] then
						autoMixActiveType = "max"
					else
						autoMixActiveType = "min"
					end
					deactivatePermanentLed(autoMixLedPattern)
					activateBlinkingLed(autoMixLedPattern, autoMixEventActiveBlinkTime, 0, false)
				end
			elseif autoMixActiveType ~= nil then
				local throttle = GetCarInfo("throttle")
				if autoMixActiveType == "max" then
					if throttle < 1 then
						autoMixActiveType = nil
						local multiFunctionBak = currentMultifunction
						currentMultifunction = fuelMultiFunction
						currentMultifunction["currentUpDnMode"] = autoMixReturnMix
						confirmSelection("AUTO", currentMultifunction["modes"][autoMixReturnMix], getButtonMap(currentMultifunction), config["DISP"])
						currentMultifunction = multiFunctionBak
						deactivateBlinkingLed(autoMixLedPattern)
						activatePermanentLed(autoMixLedPattern, 0, false)
					end
				else
					if throttle == 1 then
						autoMixActiveType = nil
						local multiFunctionBak = currentMultifunction
						currentMultifunction = fuelMultiFunction
						currentMultifunction["currentUpDnMode"] = autoMixReturnMix
						confirmSelection("AUTO", currentMultifunction["modes"][autoMixReturnMix], getButtonMap(currentMultifunction), config["DISP"])
						currentMultifunction = multiFunctionBak			
						deactivateBlinkingLed(autoMixLedPattern)
						activatePermanentLed(autoMixLedPattern, 0, false)
					end
				end				
			end
		end
	end
end