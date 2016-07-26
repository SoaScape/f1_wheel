require "scripts/mike_led_utils"
require "scripts/mike_utils"

-- MIKE CUSTOM FUNCTIONS
fuelAtStart = 0
resetStartFuel = true
startFuelLocked = false
minFuel = 10
lowFuelLedPattern = 64
startFuelStoredLedPattern = 248

function performRegularCustomDisplayProcessing()
	checkForStartFuel()	
	-- Calculate fuel target
	fuelTarget = getFuelTarget()
end

function getPercentageLapComplete()
	-- percentage of current lap completed
	local dist = GetContextInfo("lap_distance")		
	local trcksz = GetContextInfo("track_size")
	return dist / (trcksz / 100)
end

function getLapsCompleteIncludingCurrent()
	local lapsCompleted = GetContextInfo("laps") - 1 -- F1 2015 reports current lap as completed, so subtract 1					
	local percentLapComplete = getPercentageLapComplete() / 100
	return lapsCompleted + percentLapComplete -- Add on % current lap complete
end

function firstLapCompleted()
	-- Returns true once the first lap has been completed.
	local lapsCompleted = GetContextInfo("laps") - 1
	if lapsCompleted ~= nil and lapsCompleted > 0 then
		return true
	else
		return false
	end		
end

function getLapsRemaining()
	-- Returns remaining laps including current (decimal format)
	local lapsCompleted = GetContextInfo("laps")
	local totalLaps = GetContextInfo("laps_count")
	local lapsRemaining = totalLaps - lapsCompleted

	local percentLapComplete = getPercentageLapComplete()
	local percentLapRemaining = (100 - percentLapComplete) / 100
	
	lapsRemaining = lapsRemaining + percentLapRemaining
	return lapsRemaining
end

function getRemainingLapsInTank(fuelRemaining)
	-- Mike custom: fuel laps remaining.
	-- Discounts 2.6 litres as car stutters when down to that level
	local lapsCompleted = getLapsCompleteIncludingCurrent()

	local remainingLapsInTank = 0
	if fuelRemaining > 0 and fuelAtStart > 0 and lapsCompleted >= 1 then
		local fuelUsed = fuelAtStart - fuelRemaining
		local fuelPerLap = fuelUsed / lapsCompleted	
		if fuelPerLap > 0 then				
			remainingLapsInTank = (fuelRemaining - minFuel) / fuelPerLap
		end
	end
	return remainingLapsInTank	
end

function getFuelTarget()
	local fuelRemaining = GetCarInfo("fuel")
	if firstLapCompleted() and fuelAtStart > 0 and fuelRemaining > 0 then
		local remainingLapsInTank = getRemainingLapsInTank(fuelRemaining)
		local remainingLaps = getLapsRemaining()
		local target = round(remainingLapsInTank - remainingLaps, 1)

		if target < 0 then
			activateBlinkingLed(lowFuelLedPattern)
		else
			deactivateBlinkingLed(lowFuelLedPattern)
		end

		return target
	else
		deactivateBlinkingLed(lowFuelLedPattern)
		return nil
	end
end

function checkForStartFuel()
	-- Store Fuel At Start (to preserve after flashback)
	local startFuel = GetCarInfo("fuel_total")	

	if resetStartFuel and not(startFuelLocked) and
		mSessionEnter == 1 and not(m_is_sim_idle) and
			startFuel ~= nil and startFuel > 0 then
		fuelAtStart = startFuel
		display("TANK", GetFuelKilogram(fuelAtStart), myDevice, 500)		
		activatePermanentLed(startFuelStoredLedPattern, 500)
		resetStartFuel = false
	end
end
