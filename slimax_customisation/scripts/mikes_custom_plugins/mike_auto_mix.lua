require "scripts/mikes_custom_plugins/mike_led_utils"

autoMixMultifunctionName = "AUTO"

local learnedData = {}

local timeouts =  {}
timeouts["INTV"] = 2100 -- minTimeBetweenMixChange
timeouts["LOW "] = 2000 -- learnLowThrottleTimeout
timeouts["FULL"] = 4000 -- learnFullThrottleTimeout

timeoutIds = {}
timeoutIds[0] = "INTV"
timeoutIds[1] = "LOW "
timeoutIds[2] = "FULL"

local selectedTimeout = 0
local encoderIncrement = 500

local learnFullThrottleStartTicks = 0
local learnFullThrottleStartDistance = 0
local learnFullThrottleActive = false

local learnLowThrottleStartTicks = 0
local learnLowThrottleStartDistance = 0
local learnLowThrottleActive = false

local lastMixEvent = nil
local autoMixSelected = false

local autoMixLedPattern = 128 -- LED 5, binary 10000000

function resetAutoMixData()
	learnedData = {}
	learnFullThrottleActive = false
	learnLowThrottleActive = false
	autoMixSelected = false
	lastMixEvent = nil
	autoMixActiveType = nil
end

local function toggleAutoMixSelected()
	autoMixSelected = not(autoMixSelected)
	local right = "ACTV"
	activatePermanentLed(autoMixLedPattern, 0, false)
	if not(autoMixSelected) then
		right = " OFF"
		deactivatePermanentLed(autoMixLedPattern)
	end
	display(autoMixMultifunctionName, right, myDevice, 500)
end

function processAutoMixButtonEvent(button)
	if button == confirmButton then
		toggleAutoMixSelected()
	elseif button == upButton then
		if selectedTimeout < tablelength(timeoutIds) - 1 then
			selectedTimeout = 0
		else
			selectedTimeout = selectedTimeout + 1
		end
	elseif button == downButton then
		if selectedTimeout == 0 then
			selectedTimeout = tablelength(timeoutIds) - 1
		else
			selectedTimeout = selectedTimeout - 1
		end	
	elseif button == upEncoder then
		timeouts[timeoutIds[selectedTimeout]] = timeouts[timeoutIds[selectedTimeout]] + encoderIncrement
		display(timeoutIds[selectedTimeout], encoderIncrement, myDevice, 500)
	elseif button == downEncoder then
		if timeouts[timeoutIds[selectedTimeout]] >= encoderIncrement then
			timeouts[timeoutIds[selectedTimeout]] = timeouts[timeoutIds[selectedTimeout]] - encoderIncrement
		end
		display(timeoutIds[selectedTimeout], encoderIncrement, myDevice, 500)
	end
end

local function recentEvent(startTicks)
	if lastMixEvent ~= nil and lastMixEvent["endTicks"] ~= nil and lastMixEvent["endTicks"] + timeouts["INTV"] > startTicks then
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
		elseif (getTks() - learnFullThrottleStartTicks) >= timeouts["FULL"] and GetCarInfo("speed") > 100 and not (highLearnt) then				
			highLearnt = true
			if recentEvent(learnFullThrottleStartTicks) then
				lastMixEvent["returnMix"] = fuelMultiFunction["max"]
				lastMixEvent = nil
				--display("ZMIX", fuelMultiFunction["modes"][fuelMultiFunction["max"]], myDevice, 500)
			else
				learnedData[learnFullThrottleStartDistance] = {}
				learnedData[learnFullThrottleStartDistance]["mix"] = fuelMultiFunction["max"]
				learnedData[learnFullThrottleStartDistance]["returnMix"] = fuelMultiFunction["defaultUpDnMode"]
				lastMixEvent = learnedData[learnFullThrottleStartDistance]
				--display("AMIX", fuelMultiFunction["modes"][fuelMultiFunction["max"]], myDevice, 500)
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
		elseif (getTks() - learnLowThrottleStartTicks) >= timeouts["LOW "] and not (lowLearnt) then
			lowLearnt = true
			if recentEvent(learnLowThrottleStartTicks) then
				lastMixEvent["returnMix"] = fuelMultiFunction["min"]
				lastMixEvent = nil
				--display("ZMIX", fuelMultiFunction["modes"][fuelMultiFunction["min"]], myDevice, 500)				
			else
				learnedData[learnLowThrottleStartDistance] = {}
				learnedData[learnLowThrottleStartDistance]["mix"] = fuelMultiFunction["min"]
				learnedData[learnLowThrottleStartDistance]["returnMix"] = fuelMultiFunction["defaultUpDnMode"]
				lastMixEvent = learnedData[learnLowThrottleStartDistance]			
				--display("AMIX", fuelMultiFunction["modes"][fuelMultiFunction["min"]], myDevice, 500)
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
		
		local fuelTarget = getFuelTarget()
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
					end
					
					fuelMultiFunction["currentUpDnMode"] = autoMix
					confirmSelection("AUTO", fuelMultiFunction["modes"][autoMix], myDevice, getButtonMap(fuelMultiFunction), true)
					if autoMix == fuelMultiFunction["max"] then
						autoMixActiveType = "max"
					else
						autoMixActiveType = "min"
					end
				end
			elseif autoMixActiveType ~= nil then
				local throttle = GetCarInfo("throttle")
				if autoMixActiveType == "max" then
					if throttle < 1 then
						autoMixActiveType = nil
						fuelMultiFunction["currentUpDnMode"] = autoMixReturnMix
						confirmSelection("AUTO", fuelMultiFunction["modes"][autoMixReturnMix], myDevice, getButtonMap(fuelMultiFunction), true)
					end
				else
					if throttle == 1 then
						autoMixActiveType = nil
						fuelMultiFunction["currentUpDnMode"] = autoMixReturnMix
						confirmSelection("AUTO", fuelMultiFunction["modes"][autoMixReturnMix], myDevice, getButtonMap(fuelMultiFunction), true)
					end
				end				
			end
		end
	end
end