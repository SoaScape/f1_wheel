require "scripts/mikes_custom_plugins/mike_led_utils"

autoMixMultifunctionName = "AMIX"

local autoMixFileExtension = "amix"
local displayMixEvents = false
local displayTimeout = 1000

local mixEvents = nil
local lastEvent = -1
local autoMixActive = false
local richModePreviouslyDisabled = false

local autoMixInhibit = false

local progMix;

function resetAutoMixData()
	mixEvents = nil
	autoMixActive = false
	autoMixInhibit = false
	richModePreviouslyDisabled = false
	progMix = fuelMultiFunction["defaultUpDnMode"]
	lastEvent = -1
end

local function loadMixEventsForTrack(trackId)
	mixEvents = loadEventsForTrack(trackId, autoMixFileExtension)
	lastEvent = -1
	if mixEvents ~= nil then
		return true
	end
end

local function autoMixOn()
	if autoMixEnabled and loadMixEventsForTrack(trackMultiFunction["modes"][trackMultiFunction["currentUpDnMode"]]) then
		autoMixActive = true
		richModePreviouslyDisabled = false
		
		if not(autoMixInhibit) then
			activatePermanentLed(autoMixLedPattern, 0, false)
		end
		return true
	end
	return false
end

function autoMixOff()
	if autoMixActive then
		resetAutoMixData()
		deactivatePermanentLed(autoMixLedPattern)
	end	
end

function autoMixInhibitOff()
	if autoMixActive then
		activatePermanentLed(autoMixLedPattern, 0, false)
	end
	autoMixInhibit = false
end

function autoMixInhibitOn()
	deactivatePermanentLed(autoMixLedPattern)
	autoMixInhibit = true
end
local function toggleAutoMixSelected()
	if autoMixEnabled then
		autoMixActive = not(autoMixActive)
		if autoMixActive then
			if autoMixOn() then
				display(autoMixMultifunctionName, "ACTV", displayTimeout)
			else
				autoMixActive = false
				display(autoMixMultifunctionName, " ERR", displayTimeout)
			end
		else
			autoMixOff()
			display(autoMixMultifunctionName, " OFF", displayTimeout)
			if(mSessionEnter == 1 and not(m_is_sim_idle)) then
				fuelMultiFunction["currentUpDnMode"] = fuelMultiFunction["defaultUpDnMode"]
				nextActiveFuelMix = fuelMultiFunction["currentUpDnMode"]
				confirmSelection(nil, nil, getButtonMap(fuelMultiFunction), false)
			end
		end
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
	if not(autoMixInhibit) and autoMixEnabled and mSessionEnter == 1 and not(m_is_sim_idle) then
		local fuelTarget = getAdjustedFuelTarget()
		if fuelTarget == nil then
			fuelTarget = 1
		end
		
		if autoMixActive then
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