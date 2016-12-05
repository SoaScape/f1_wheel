require "scripts/mikes_custom_plugins/mike_led_utils"

autoMixMultifunctionName = "AUTO"

local learnedData = {}

local learnFullThrottleTimeout = 4000
local learnFullThrottleStartTicks = 0
local learnFullThrottleStartDistance = 0
local learnFullThrottleActive = false

local learnLowThrottleTimeout = 2000
local learnLowThrottleStartTicks = 0
local learnLowThrottleStartDistance = 0
local learnLowThrottleActive = false

local autoMixSelected = false

local autoMixLedPattern = 128 -- LED 5, binary 10000000

function resetAutoMixData()
	learnedData = {}
	learnFullThrottleActive = false
	learnLowThrottleActive = false
	autoMixSelected = false
	lastLowMixEvent = nil
	lastHighMixEvent = nil
	autoMixActiveType = nil
end

function toggleAutoMixSelected()
	autoMixSelected = not(autoMixSelected)
	local right = "ACTV"
	activatePermanentLed(autoMixLedPattern, 0, false)
	if not(autoMixSelected) then
		" OFF"
		deactivatePermanentLed(autoMixLedPattern)
	end
	display(autoMixMultifunctionName, right, myDevice, 500)
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

function learnTrack()
	local minTimeBetweenMixChange = 2100
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
				lastHighTime = getTks()
			end
		elseif (getTks() - learnFullThrottleStartTicks) >= learnFullThrottleTimeout and GetCarInfo("speed") > 100 and not (highLearnt) then				
			highLearnt = true
			if lastLowTime ~= nil and lastLowMixEvent ~= nil and lastLowTime + minTimeBetweenMixChange > learnFullThrottleStartTicks then
				lastLowMixEvent["returnMix"] = fuelMultiFunction["max"]
				lastHighMixEvent = nil
				--display("ZMIX", fuelMultiFunction["modes"][fuelMultiFunction["max"]], myDevice, 500)
			else
				learnedData[learnFullThrottleStartDistance] = {}
				learnedData[learnFullThrottleStartDistance]["mix"] = fuelMultiFunction["max"]
				learnedData[learnFullThrottleStartDistance]["returnMix"] = fuelMultiFunction["defaultUpDnMode"]
				lastHighMixEvent = learnedData[learnFullThrottleStartDistance]
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
				lastLowTime = getTks()
			end
		elseif (getTks() - learnLowThrottleStartTicks) >= learnLowThrottleTimeout and not (lowLearnt) then
			lowLearnt = true
			if lastHighTime ~= nil and lastHighMixEvent ~= nil and lastHighTime + minTimeBetweenMixChange > learnLowThrottleStartTicks then
				lastHighMixEvent["returnMix"] = fuelMultiFunction["min"]
				lastLowMixEvent = nil
				--display("ZMIX", fuelMultiFunction["modes"][fuelMultiFunction["min"]], myDevice, 500)				
			else
				learnedData[learnLowThrottleStartDistance] = {}
				learnedData[learnLowThrottleStartDistance]["mix"] = fuelMultiFunction["min"]
				learnedData[learnLowThrottleStartDistance]["returnMix"] = fuelMultiFunction["defaultUpDnMode"]
				lastLowMixEvent = learnedData[learnLowThrottleStartDistance]			
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
