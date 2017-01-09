-- MIKE CUSTOM FUNCTIONS
local fuelAtStart = 0
local lowFuelLedPattern = 64
local lowFuelLedBlinkDelay = 500
local startFuelStoredLedPattern = 248
local fuelResetDisplayTimeout = 1000

local fuelTarget = nil
local adjustedFuelTarget = nil
local maxYellowFlagPercentageForValidFuelLap = 0

local fuelLaps = {}
local lastFuelLapCompleted = -1
local maxNonStandardFuelLapsToStore = 3

local function getPercentageLapComplete()
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
	return fuelTarget
end

function getAdjustedFuelTarget()
	return adjustedFuelTarget
end

local function assessFuelLapData()
	local lapComparator = function(a, b) return a.accuracy > b.accuracy end	
	local sortedKeys = getKeysSortedByValue(fuelLaps, lapComparator)
	
	local count = 0
	
	for _, key in ipairs(sortedKeys) do
		count = count + 1
		local fuelLap = fuelLaps[key]
		if fuelLap.accuracy < 100 and count > maxNonStandardFuelLapsToStore then
			fuelLap.adjustedFuelUsed = nil
		end
	end
end

local function calculateMixAdjustedFuelLap(fuelLap)
	local fuelUsed = fuelLap.startFuel - fuelLap.endFuel
	local fuelMixes = {}
	local numMixEvents = 0
	local numStandardMixEvents = 0
	local numYellow = 0
	for distance, mixData in pairs(fuelLap.mixdata) do
		local fuelMode = mixData.mix
		if fuelMixes[fuelMode] == nil then
			fuelMixes[fuelMode] = 1
		else
			fuelMixes[fuelMode] = fuelMixes[fuelMode] + 1
		end
		
		if fuelMode == fuelMultiFunction.defaultUpDnMode then
			numStandardMixEvents = numStandardMixEvents + 1
		end
		if mixData.yellow then
			numYellow = numYellow + 1
		end
		numMixEvents = numMixEvents + 1
	end

	local yellowFlagLapPrecentage = ((numYellow / numMixEvents) * 100)
	if yellowFlagLapPrecentage <= maxYellowFlagPercentageForValidFuelLap then
		local fuelOffset = 1
		if fuelMultiFunction.fuelUsageOffset ~= nil then
			for mix, total in pairs(fuelMixes) do
				local distPercentage = total / numMixEvents
				local offset = -fuelMultiFunction.fuelUsageOffset[mix]
				fuelOffset = fuelOffset + (offset * distPercentage)
			end
		end
		
		if fuelUsed > 0 then
			fuelLap.fuelUsed = fuelUsed
			fuelLap.adjustedFuelUsed = fuelUsed * fuelOffset
			fuelLap.accuracy = ((numStandardMixEvents / numMixEvents) * 100) - (yellowFlagLapPrecentage * 3)			
			display("DATA", tostring(fuelLap.accuracy), mDisplay_Info_Delay)
			assessFuelLapData()			
		end
	end
end

local function trackFuelLapData()	
	local lapsCompleted = GetContextInfo("laps")
	if lapsCompleted ~= nil then
		local distance = round(GetContextInfo("lap_distance"), 0)
		if lapsCompleted > lastFuelLapCompleted then
			local fuel = GetCarInfo("fuel")
			if fuelLaps[lastFuelLapCompleted] ~= nil and fuelLaps[lastFuelLapCompleted].endFuel == nil then				
				fuelLaps[lastFuelLapCompleted].endFuel = fuel
				fuelLaps[lastFuelLapCompleted].accuracy = 0
				calculateMixAdjustedFuelLap(fuelLaps[lastFuelLapCompleted])
			end
			
			if distance <= 1 then
				local fuelLap = {}
				fuelLap.startFuel = fuel
				fuelLap.mixdata = {}
				fuelLaps[lapsCompleted] = fuelLap			
				lastFuelLapCompleted = lapsCompleted
			end
		elseif lapsCompleted == lastFuelLapCompleted then
			local fuelLap = fuelLaps[lapsCompleted]			
			if fuelLap.mixdata[distance] == nil then
				fuelLap.mixdata[distance] = {}
				fuelLap.mixdata[distance].mix = getActiveFuelMix()
				fuelLap.mixdata[distance].yellow = GetContextInfo("yellow_flag")
			end			
		end
	end
end

local function calcFuelTarget(totalFuelUsed, fuelLapsCompleted)
	local fuelPerLap = totalFuelUsed / fuelLapsCompleted
	local fuelRemaining = GetCarInfo("fuel") - minFuel
	local fuelLapsRemaining = fuelRemaining / fuelPerLap
	local lapsRemaining = getLapsRemaining()
	return fuelLapsRemaining - lapsRemaining
end

local function calculateFuelTargets()	
	trackFuelLapData()
	
	local totalFuelUsed = 0
	local totalAdjustedFuelUsed = 0
	local fuelLapsCompleted = 0
	
	for lapId, fuelLap in pairs(fuelLaps) do
		if fuelLap.fuelUsed ~= nil then
			totalFuelUsed = totalFuelUsed + fuelLap.fuelUsed
			if fuelLap.adjustedFuelUsed ~= nil then
				totalAdjustedFuelUsed = totalAdjustedFuelUsed + fuelLap.adjustedFuelUsed
			end
			fuelLapsCompleted = fuelLapsCompleted + 1
		end			
	end
	
	if fuelLapsCompleted > 0 then
		fuelTarget = calcFuelTarget(totalFuelUsed, fuelLapsCompleted)
		adjustedFuelTarget = calcFuelTarget(totalAdjustedFuelUsed, fuelLapsCompleted)
		
		if fuelTarget < 0 then
			activateBlinkingLed(lowFuelLedPattern, lowFuelLedBlinkDelay, 0, false)
		else
			deactivateBlinkingLed(lowFuelLedPattern)
		end
	else
		fuelTarget = nil
		adjustedFuelTarget = nil
		deactivateBlinkingLed(lowFuelLedPattern)
	end
end

function performRegularCustomDisplayProcessing()
	if mSessionEnter == 1 and not(m_is_sim_idle) then
		-- Calculate fuel targets
		calculateFuelTargets()
	end
end

function storeStartFuel()	
	fuelAtStart = GetCarInfo("fuel_total")
end

function resetFuelData()
	if mSessionEnter ~= 1 and m_is_sim_idle then
		fuelAtStart = nil
	end
	fuelLaps = {}
	lastFuelLapCompleted = -1
	fuelTarget = nil
	adjustedFuelTarget = nil
end

function getFuelAtStart()
	return fuelAtStart
end