-- MIKE CUSTOM FUNCTIONS
local fuelAtStart = 0

local lowFuelLedBlinkDelay = 500
local fuelResetDisplayTimeout = 1000
local saveFuelLedBlinkDelay = 500
local timeAtSaveFuelMessage = 0
local timeBetweenSaveFuelMessages = 30000 -- 30 seconds
local saveFuelDisplayTime = 1000
local saveFuelMessageMinRacePercentageComplete = 50 -- % race complete before displaying save fuel messages

local accurateFuelLapCalculated = false

local fuelTarget = nil
local adjustedFuelTarget = nil
local maxYellowFlagPercentageForValidFuelLap = 5
local fuelUsedLastLap = nil

local fuelLaps = {}
local lastFuelLapCompleted = -1
local maxNonStandardFuelLapsToStore = 3
local fuelLapCompleteLedPattern = 192 -- 4, 5  = 11000000
local currentFuelLap = nil

function displayFuel(fuel)
	local sliPanel = "NREF"
	if fuel ~= nil and fuel > 0 then 
		local ft = GetFuelKilogram(fuel)
		if devName == "SLI-PRO" then
			if ft >= 100 then
				sliPanel = string.format(" F%3d  ", round(ft))
			elseif ft >= 10 then
				sliPanel = string.format(" F%2d   ", round(ft))
			else
				sliPanel = string.format(" F%1.1f  ", ft)
			end
		else
			if ft >= 100 then
				sliPanel = string.format("F%3d", round(ft))
			elseif ft >= 10 then
				sliPanel = string.format(" F%2d", round(ft))
			else
				sliPanel = string.format(" F%1.1f", ft)
			end
		end
	else
		sliPanel = "NREF"
	end
	return sliPanel
end

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

local function getPercentageRaceComplete()
	local lapsCompleted = GetContextInfo("laps")
	local totalLaps = GetContextInfo("laps_count")
	return (lapsCompleted / totalLaps) * 100
end

function getRemainingLapsInTank(fuelRemaining)
	-- Mike custom: fuel laps remaining.
	-- Discounts 2.6 litres as car stutters when down to that level
	local remainingLapsInTank = 0
	local fuelPerLap = getAverageFuelPerLap()
	if fuelPerLap ~= nil and fuelRemaining > 0 then		
		remainingLapsInTank = (fuelRemaining - minFuel) / fuelPerLap
	end
	return remainingLapsInTank	
end

function getFuelUsedLastLap()
	return fuelUsedLastLap
end

function getAverageFuelPerLap()
	local totalFuelUsed = 0
	local count = 0
	for key, fuelLap in pairs(fuelLaps) do
		if fuelLap.fuelUsed ~= nil then
			totalFuelUsed = totalFuelUsed + fuelLap.fuelUsed
			count = count + 1
		end
	end
	
	if count > 0 then
		return totalFuelUsed / count
	else
		return nil
	end
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
		if fuelLap.accuracy < 100 and (count > maxNonStandardFuelLapsToStore or accurateFuelLapCalculated) then
			fuelLap.adjustedFuelUsed = nil
		elseif fuelLap.accuracy == 100 then
			accurateFuelLapCalculated = true
		end
	end
end

local function calculateMixAdjustedFuelLap(fuelLap)
	fuelUsedLastLap = fuelLap.startFuel - fuelLap.endFuel
	local fuelMixes = {}
	local numMixEvents = 0
	local numStandardMixEvents = 0
	local numYellow = 0
	local inPitsDuringLap = false
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
		if mixData.pits then
			inPitsDuringLap = true
		end
		numMixEvents = numMixEvents + 1
	end

	local yellowFlagLapPrecentage = ((numYellow / numMixEvents) * 100)
	local fuelOffset = 0
	if fuelMultiFunction.fuelUsageOffset ~= nil then
		for mix, total in pairs(fuelMixes) do
			local distPercentage = total / numMixEvents
			local offset = fuelMultiFunction.fuelUsageOffset[mix]
			fuelOffset = fuelOffset + (offset * distPercentage)
		end
	end
	
	fuelLap.numMixEvents = numMixEvents
	fuelLap.numStandardMixEvents = numStandardMixEvents
	fuelLap.yellowFlagLapPrecentage = yellowFlagLapPrecentage
	fuelLap.offset = fuelOffset
	fuelLap.accuracy = ((numStandardMixEvents / numMixEvents) * 100) - (yellowFlagLapPrecentage)
	fuelLap.adjustedFuelUsed = fuelUsedLastLap / fuelOffset			
	
	if not (GetContextInfo("yellow_flag"))
		and yellowFlagLapPrecentage <= maxYellowFlagPercentageForValidFuelLap
			and not(inPitsDuringLap)
				and fuelUsedLastLap > 0 then
		fuelLap.fuelUsed = fuelUsedLastLap
		assessFuelLapData()
		if accurateFuelLapCalculated then
			display("USED", displayFuel(fuelLap.fuelUsed), mDisplay_Info_Delay)
		else
			display("DATA", tostring(fuelLap.accuracy), mDisplay_Info_Delay)
		end
		activateBlinkingLed(fuelLapCompleteLedPattern, 100, 250, false)
	end
end

local function trackFuelLapData()
	local lapsCompleted = GetContextInfo("laps")
	if lapsCompleted ~= nil then
		local distance = round(GetContextInfo("lap_distance"), 0)
		if lapsCompleted > lastFuelLapCompleted then
			local fuel = GetCarInfo("fuel")
			if currentFuelLap ~= nil and currentFuelLap.endFuel == nil then				
				currentFuelLap.endFuel = fuel
				currentFuelLap.accuracy = 0
				calculateMixAdjustedFuelLap(currentFuelLap)
			end
			
			if distance <= 1 then
				local fuelLap = {}
				fuelLap.lap = lapsCompleted
				fuelLap.startFuel = fuel
				fuelLap.mixdata = {}
				table.insert(fuelLaps, fuelLap)
				currentFuelLap = fuelLap
				lastFuelLapCompleted = lapsCompleted
			end
		elseif lapsCompleted == lastFuelLapCompleted then
			if currentFuelLap.mixdata[distance] == nil then
				currentFuelLap.mixdata[distance] = {}
				currentFuelLap.mixdata[distance].mix = getFuelMix()
				currentFuelLap.mixdata[distance].yellow = GetContextInfo("yellow_flag")
				currentFuelLap.mixdata[distance].pits = inPits()
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
	local adjustedFuelLapsCompleted = 0
	
	for lapId, fuelLap in pairs(fuelLaps) do
		if fuelLap.fuelUsed ~= nil then
			totalFuelUsed = totalFuelUsed + fuelLap.fuelUsed
			if fuelLap.adjustedFuelUsed ~= nil then
				totalAdjustedFuelUsed = totalAdjustedFuelUsed + fuelLap.adjustedFuelUsed
				adjustedFuelLapsCompleted = adjustedFuelLapsCompleted + 1
			end
			fuelLapsCompleted = fuelLapsCompleted + 1
		end			
	end
	
	if fuelLapsCompleted > 0 then
		fuelTarget = calcFuelTarget(totalFuelUsed, fuelLapsCompleted)
		adjustedFuelTarget = calcFuelTarget(totalAdjustedFuelUsed, adjustedFuelLapsCompleted)
		
		if fuelTarget < 0 then
			activateBlinkingLed(lowFuelLedPattern, lowFuelLedBlinkDelay, 0, false)
		else
			deactivateBlinkingLed(lowFuelLedPattern)
		end

		if adjustedFuelTarget < 0 and getPercentageRaceComplete() >= saveFuelMessageMinRacePercentageComplete then
			if saveFuelMessageLedTriggered == nil and getTks() - timeAtSaveFuelMessage > timeBetweenSaveFuelMessages then
				timeAtSaveFuelMessage = getTks()
				display("SAVE", "FUEL", saveFuelDisplayTime)
			end
			activateBlinkingLed(saveFuelLedPattern, saveFuelLedBlinkDelay, 0, false)
		else
			deactivateBlinkingLed(saveFuelLedPattern)
		end
	else
		fuelTarget = nil
		adjustedFuelTarget = nil
		deactivateBlinkingLed(lowFuelLedPattern)
		deactivateBlinkingLed(saveFuelLedPattern)
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
	fuelAtStart = nil
	fuelLaps = {}
	lastFuelLapCompleted = -1
	fuelTarget = nil
	adjustedFuelTarget = nil
	fuelUsedLastLap = nil
	currentFuelLap = nil
	currentDataItemIndex = 1
	accurateFuelLapCalculated = false
end

function getFuelAtStart()
	return fuelAtStart
end