require "scripts/mikes_custom_plugins/mike_led_utils"

autoMixMultifunctionName = "AMIX"

local autoMixFileExtension = "amix"
local autoMixLedPattern = 128 -- LED 5, binary 10000000
local displayMixEvents = false
local displayTimeout = 1000

local mixEvents = nil
local lastEvent = -1
local autoMixSelected = false
local richModePreviouslyDisabled = false

local progMix;

function resetAutoMixData()
	mixEvents = nil
	autoMixSelected = false
	richModePreviouslyDisabled = false
	lastEvent = -1
end

local function toggleAutoMixSelected()
	if autoMixEnabled and mSessionEnter == 1 and not(m_is_sim_idle) then
		autoMixSelected = not(autoMixSelected)
		if autoMixSelected then
			if autoMixOn() then
				display(autoMixMultifunctionName, "ACTV", displayTimeout)
			else
				autoMixSelected = false
				display(autoMixMultifunctionName, " ERR", displayTimeout)
			end
		else
			autoMixOff()
			display(autoMixMultifunctionName, " OFF", displayTimeout)
			fuelMultiFunction["currentUpDnMode"] = fuelMultiFunction["defaultUpDnMode"]
			nextActiveFuelMix = fuelMultiFunction["currentUpDnMode"]
			confirmSelection(nil, nil, getButtonMap(fuelMultiFunction), false)
		end
	end
end

function isAutoMixActive()
	return autoMixSelected
end

local function loadMixEventsForTrack(trackId)
	mixEvents = loadEventsForTrack(trackId, autoMixFileExtension)
	lastEvent = -1
	if mixEvents ~= nil then
		return true
	end
end

function autoMixOn()
	if autoMixEnabled and mSessionEnter == 1 and not(m_is_sim_idle) and loadMixEventsForTrack(trackMultiFunction["modes"][trackMultiFunction["currentUpDnMode"]]) then
		autoMixSelected = true
		richModePreviouslyDisabled = false
		activatePermanentLed(autoMixLedPattern, 0, false)
		return true
	end
	return false
end

function autoMixOff()
	if autoMixEnabled and mSessionEnter == 1 and not(m_is_sim_idle) then
		resetAutoMixData()
		deactivatePermanentLed(autoMixLedPattern)
	end	
end

local function storeMixEvent(mix)
	if(mSessionEnter == 1 and not(m_is_sim_idle)) then
		local distStr = tostring(getLapDistance())
		local mixStr = fuelMultiFunction["modes"][mix]
		progEvents[distStr] = mixStr
		display(distStr, mixStr, progDisplayTimeout)
	end
end

local function displayProgMix(mix)	
	display("PROG", fuelMultiFunction["modes"][mix], progDisplayTimeout)
end

function processAutoMixButtonEvent(button)
	if autoMixEnabled then
		if button == confirmButton or (button == secondaryConfirmButton and mSessionEnter ~= 1 and m_is_sim_idle) then
			if inProgrammingMode() then
				storeMixEvent(progMix)
			else
				toggleAutoMixSelected()
			end
		elseif button == upButton or button == upEncoder then
			if inProgrammingMode() then
				if progMix < fuelMultiFunction["max"] then
					progMix = progMix + 1
				end
				displayProgMix(progMix)
			end
		elseif button == downButton or button == downEncoder then
			if inProgrammingMode() then
				if progMix > fuelMultiFunction["min"] then
					progMix = progMix - 1
				end
				displayProgMix(progMix)
			end
		elseif button == progButton then
			if autoDiffActive or (mSessionEnter ~= 1 or m_is_sim_idle) then
				display("PROG", "UNAV", displayTimeout)
				return
			end
			toggleProgrammingMode(autoMixFileExtension)
			progMix = fuelMultiFunction["defaultUpDnMode"]
		end
	end
end

function autoMixRegularProcessing()
	if autoMixEnabled and mSessionEnter == 1 and not(m_is_sim_idle) then
		local fuelTarget = getAdjustedFuelTarget()
		if fuelTarget == nil then
			fuelTarget = 1
		end
		
		if autoMixSelected then
			local dist = tostring(getLapDistance())
			if mixEvents[dist] ~= nil and lastEvent ~= dist then
				lastEvent = dist
				local autoMix = getKeyForValue(fuelMultiFunction["modes"], mixEvents[dist])
				if fuelTarget < 0 then
					if autoMix > fuelMultiFunction["defaultUpDnMode"] then
						autoMix = fuelMultiFunction["defaultUpDnMode"]
						if not(richModePreviouslyDisabled) then
							richModePreviouslyDisabled = true
							display("RICH", "DISB", displayTimeout)							
						end
					end
				elseif richModePreviouslyDisabled and autoMix > fuelMultiFunction["defaultUpDnMode"] then
					display("RICH", "ENBL", displayTimeout)
					richModePreviouslyDisabled = false
				end

				fuelMultiFunction["currentUpDnMode"] = autoMix
				nextActiveFuelMix = fuelMultiFunction["currentUpDnMode"]
				confirmSelection(autoMixMultifunctionName, fuelMultiFunction["modes"][autoMix], getButtonMap(fuelMultiFunction), displayMixEvents)
			end			
		end
	end
end