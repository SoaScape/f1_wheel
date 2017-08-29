require "scripts/mikes_custom_plugins/mike_common"
require "scripts/mikes_custom_plugins/mike_custom_displays_logic"
require "scripts/mikes_custom_plugins/mike_utils"

local function checkFuelChange()
	if lastMix ~= nil then
		local fuelMix = getFuelMix()
		if fuelMix ~= nil and fuelMix ~= lastMix then
			fuelMultiFunction["currentPosition"] = fuelMix
			fuelMultiFunction["currentUpDnMode"] = fuelMix
			lastMix = fuelMix
			display("MIX-", fuelMultiFunction["modes"][fuelMix], mDisplay_Info_Delay)
			return true
		end
	end
	return false
end

local function displayFuelTarget(fuelTarget)
	local sliPanel = "NREF"
	if fuelTarget ~= nil then
		local fuelRemaining = GetCarInfo("fuel")
		local c = ""
		if(fuelTarget >= 0) then
			c = "+"
		end
	
		if firstLapCompleted() and remainingLapsInTank ~= 0 then
			if(fuelTarget >= 10 or fuelTarget <= -10) then
				sliPanel = string.format("%s%2.1f",  c, fuelTarget, 1)
			else
				sliPanel = string.format("T%s%1.1f",  c, fuelTarget, 1)
			end
			isSlowUpdate = true
		else
			if(fuelRemaining <= minFuel) then
				sliPanel = "OUT "
			end
		end	
	end
	return sliPanel
end

function customDisplayEventProcessing(swValue, side)
	if checkFuelChange() then
		return 1
	end

	local sliPanel = ""
	local isSlowUpdate = false
	local customFunction = false
	local diffTimeFlag = false
	local lpt = nil
	
	if swValue == 189 then
		customFunction = true
		-- distance
		local dist = getLapDistance()
		if devName == "SLI-PRO" then
			sliPanel = string.format(" D%3d   ", dist )
		else
			sliPanel = string.format("%3d", dist )
		end		
	elseif swValue == 190 then
		-- Mike custom: average fuel used per lap
		customFunction = true				
		sliPanel = displayFuel(getAverageFuelPerLap())
	elseif swValue == 191 then
		-- Mike custom: fuel used last lap
		customFunction = true				
		sliPanel = displayFuel(getFuelUsedLastLap())
	elseif swValue == 192 then		
		-- Mike custom: fuel target.
		customFunction = true
		sliPanel = displayFuelTarget(getAdjustedFuelTarget())
	elseif swValue == 193 then
		-- Mike custom: LAPS COMPLETED SCRIPT INCLUDING CURRENT DECIMAL PLACE LAP
		customFunction = true
		local lapsCompleted = getLapsCompleteIncludingCurrent()
		
		if lapsCompleted ~= nil then
			sliPanel = string.format("L%2.2f",  round(lapsCompleted, 2))
		end
	
	elseif swValue == 194 then		
		-- Mike custom: fuel target.
		customFunction = true
		sliPanel = displayFuelTarget(getFuelTarget())

	elseif swValue == 195 then
		-- Mike custom: total fuel in tank at start(doesn't reset with flashback in F1)
		customFunction = true				
		sliPanel = displayFuel(getFuelAtStart())

	elseif swValue == 196 then
		-- Mike custom: real time diff vs next
		customFunction = true
		diffTimeFlag = true
		timeFlag = true
		lpt = GetTimeInfo("diff_time_behind_next")
	
	elseif swValue == 197 then
		-- Mike custom: real time diff vs leader
		customFunction = true
		diffTimeFlag = true
		timeFlag = true
		lpt = GetTimeInfo("diff_time_behind_leader")
		
	elseif swValue == 198 then
		-- Mike custom: fuel laps remaining.
		customFunction = true
		local fuelRemaining = GetCarInfo("fuel")
		local remainingLapsInTank = getRemainingLapsInTank(fuelRemaining)

		if remainingLapsInTank > 0 then
			sliPanel = string.format("F%2.2f",  round(remainingLapsInTank, 2))
			isSlowUpdate = true
		elseif remainingLapsInTank == 0 then
			if(fuelRemaining <= minFuel) then
				sliPanel = "OUT "
			else
				sliPanel = "NREF"
			end
		end

	elseif swValue == 199 then
		-- Mike custom: Laps remaining including current (using decimal)
		customFunction = true
		lapsRemaining = getLapsRemaining()
		
		if lapsRemaining ~= nil then
			sliPanel = string.format("L%2.2f",  round(lapsRemaining, 2))
		end
	
	else
		customFunction = false
	end
	
	if customFunction and not(m_is_sim_idle) then
		commonDisplayProcessing(diffTimeFlag, lpt, sliPanel, side, isSlowUpdate)
		return 1
	else
		return 2
	end	
end
