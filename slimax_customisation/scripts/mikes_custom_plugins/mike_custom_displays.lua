require "scripts/mikes_custom_plugins/mike_common"
require "scripts/mikes_custom_plugins/mike_custom_displays_logic"
require "scripts/mikes_custom_plugins/mike_utils"

function customDisplayEventProcessing(swValue, side)
	performRegularCustomDisplayProcessing()
	
	local sliPanel = ""
	local customFunction = false
	local diffTimeFlag = false
	local lpt = nil
	if swValue == 193 then
		-- Mike custom: LAPS COMPLETED SCRIPT INCLUDING CURRENT DECIMAL PLACE LAP
		customFunction = true
		local lapsCompleted = getLapsCompleteIncludingCurrent()
		
		if lapsCompleted ~= nil then
			sliPanel = string.format("L%2.2f",  round(lapsCompleted, 2))
		end
	
	elseif swValue == 194 then		
		-- Mike custom: fuel target.
		customFunction = true
		local fuelTarget = getFuelTarget()
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
				else
					sliPanel = "NREF"
				end
			end
		else
			sliPanel = "NREF"
		end

	elseif swValue == 195 then
		-- Mike custom: total fuel in tank at start(doesn't reset with flashback in F1)
		customFunction = true		
		if getFuelAtStart() ~= nil and getFuelAtStart() > 0 then 
			local ft = GetFuelKilogram(getFuelAtStart())
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
		commonDisplayProcessing(diffTimeFlag, lpt, sliPanel, side)
		return 1
	else
		return 2
	end	
end
