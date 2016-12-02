require "scripts/mikes_custom_plugins/mike_led_utils"

autoMixMultifunctionName = "AUTO"

autoMixLearnedData = {}

autoMixLearnFullThrottleTimeout = 4000
autoMixLearnFullThrottleStartTicks = 0
autoMixLearnFullThrottleStartDistance = 0
autoMixLearnFullThrottleActive = false

lastAutoMixTicks = 0

function resetAutoMixData()
	autoMixLearnedData = {}
	autoMixLearnFullThrottleActive = false
end

function autoMixRegularProcessing()
	if autoMixEnabled and mSessionEnter == 1 and not(m_is_sim_idle) then		
		learnTrack()		
		if currentMultifunction ~= nil and currentMultifunction["name"] == autoMixMultifunctionName
		  and lastAutoMixTicks + autoMixLearnFullThrottleTimeout < getTks() then
			local distance = GetContextInfo("lap_distance")
			local autoMixEvent = autoMixLearnedData[round(distance, 1)]
			if autoMixEvent ~= nil then
				lastAutoMixTicks = getTks()
				local fuelMode = autoMixEvent					
				multiFunctionBak = currentMultifunction
				currentMultifunction = fuelMultiFunction					
				currentMultifunction["currentUpDnMode"] = fuelMode
				confirmSelection("AUTO", fuelMultiFunction["modes"][fuelMode], myDevice, getButtonMap(currentMultifunction), showDisplay)					
				currentMultifunction = multiFunctionBak
			end
		end
	end
end

function learnTrack()
	local throttle = GetCarInfo("throttle")

	if autoMixLearnFullThrottleActive and throttle < 1 then
		autoMixLearnFullThrottleActive = false
		
		if (getTks() - autoMixLearnFullThrottleStartTicks) >= autoMixLearnFullThrottleTimeout then
			local distance = GetContextInfo("lap_distance")
			autoMixLearnedData[round(distance, 1)] = fuelMultiFunction["defaultUpDnMode"]
			autoMixLearnedData[round(autoMixLearnFullThrottleStartDistance, 1)] = fuelMultiFunction["max"]
			--activatePermanentLed(pattern, 500, false)
			display("AMIX", distance, myDevice, 500)				
		end
	elseif throttle == 1 and not (autoMixLearnFullThrottleActive) then
		autoMixLearnFullThrottleStartTicks = getTks()
		autoMixLearnFullThrottleStartDistance = GetContextInfo("lap_distance")
		autoMixLearnFullThrottleActive = true
	end
end
