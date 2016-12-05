require "scripts/mikes_custom_plugins/mike_led_utils"

autoMixMultifunctionName = "AUTO"

autoMixLearnedData = {}

autoMixLearnFullThrottleTimeout = 4000
autoMixLearnFullThrottleStartTicks = 0
autoMixLearnFullThrottleStartDistance = 0
autoMixLearnFullThrottleActive = false

autoMixLearnLowThrottleTimeout = 2000
autoMixLearnLowThrottleStartTicks = 0
autoMixLearnLowThrottleStartDistance = 0
autoMixLearnLowThrottleActive = false

function resetAutoMixData()
	autoMixLearnedData = {}
	autoMixLearnFullThrottleActive = false
	autoMixLearnLowThrottleActive = false
	lastLowMixEvent = nil
	lastHighMixEvent = nil
end

function autoMixRegularProcessing()
	if autoMixEnabled and mSessionEnter == 1 and not(m_is_sim_idle) then		
		learnTrack()
		
		local fuelTarget = getFuelTarget()
		if fuelTarget == nil then
			fuelTarget = 1
		end
		
		if currentMultifunction ~= nil and currentMultifunction["name"] == autoMixMultifunctionName then
			if autoMixActiveType == nil then -- Automix not currently set, check if we can set it
				local distance = GetContextInfo("lap_distance")
				activeAutoMixData = autoMixLearnedData[round(distance, 0)]				
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

function learnTrack()
	local minTimeBetweenMixChange = 2000
	local throttle = GetCarInfo("throttle")
	local yellow = GetContextInfo("yellow_flag")
	if GetInPitsState() > 1 or yellow then
		autoMixLearnFullThrottleActive = false
		autoMixLearnLowThrottleActive = false
		return
	end

	if autoMixLearnFullThrottleActive then
		if throttle < 1 then
			autoMixLearnFullThrottleActive = false
			if highLearnt then
				lastHighTime = getTks()
			end
		elseif (getTks() - autoMixLearnFullThrottleStartTicks) >= autoMixLearnFullThrottleTimeout and GetCarInfo("speed") > 100 and not (highLearnt) then				
			highLearnt = true
			if lastLowTime ~= nil and lastLowMixEvent ~= nil and lastLowTime + minTimeBetweenMixChange > autoMixLearnFullThrottleStartTicks then
				lastLowMixEvent["returnMix"] = fuelMultiFunction["max"]
				lastHighMixEvent = nil
				--display("ZMIX", fuelMultiFunction["modes"][fuelMultiFunction["max"]], myDevice, 500)
			else
				autoMixLearnedData[autoMixLearnFullThrottleStartDistance] = {}
				autoMixLearnedData[autoMixLearnFullThrottleStartDistance]["mix"] = fuelMultiFunction["max"]
				autoMixLearnedData[autoMixLearnFullThrottleStartDistance]["returnMix"] = fuelMultiFunction["defaultUpDnMode"]
				lastHighMixEvent = autoMixLearnedData[autoMixLearnFullThrottleStartDistance]
				--display("AMIX", fuelMultiFunction["modes"][fuelMultiFunction["max"]], myDevice, 500)
			end			
		end
	elseif throttle == 1 then
		autoMixLearnFullThrottleStartTicks = getTks()
		autoMixLearnFullThrottleStartDistance = round(GetContextInfo("lap_distance"), 0)
		autoMixLearnFullThrottleActive = true
		highLearnt = false
	end
	

	if autoMixLearnLowThrottleActive then		
		if throttle == 1 then
			autoMixLearnLowThrottleActive = false
			if lowLearnt then
				lastLowTime = getTks()
			end
		elseif (getTks() - autoMixLearnLowThrottleStartTicks) >= autoMixLearnLowThrottleTimeout and not (lowLearnt) then
			lowLearnt = true
			if lastHighTime ~= nil and lastHighMixEvent ~= nil and lastHighTime + minTimeBetweenMixChange > autoMixLearnLowThrottleStartTicks then
				lastHighMixEvent["returnMix"] = fuelMultiFunction["min"]
				lastLowMixEvent = nil
				--display("ZMIX", fuelMultiFunction["modes"][fuelMultiFunction["min"]], myDevice, 500)				
			else
				autoMixLearnedData[autoMixLearnLowThrottleStartDistance] = {}
				autoMixLearnedData[autoMixLearnLowThrottleStartDistance]["mix"] = fuelMultiFunction["min"]
				autoMixLearnedData[autoMixLearnLowThrottleStartDistance]["returnMix"] = fuelMultiFunction["defaultUpDnMode"]
				lastLowMixEvent = autoMixLearnedData[autoMixLearnLowThrottleStartDistance]			
				--display("AMIX", fuelMultiFunction["modes"][fuelMultiFunction["min"]], myDevice, 500)
			end
		end
	elseif throttle < 1 then
		autoMixLearnLowThrottleStartTicks = getTks()
		autoMixLearnLowThrottleStartDistance = round(GetContextInfo("lap_distance"), 0)
		autoMixLearnLowThrottleActive = true
		lowLearnt = false
	end
end
