function getTks()
	local ticks = GetAppInfo("ticks")
	if ticks == nil then
		ticks = 0
	end
	return ticks
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function display(leftStr, rightStr, deviceType, timeout)
	if leftStr ~= nul and rightStr ~= nil then			
		local dev = GetDeviceType(deviceType)
		UpdateDigits(leftStr, rightStr, dev)
		SLISendReport(0)
		setDisplayTimeout(timeout)
	end
end

function setDisplayTimeout(timeout)		
	customDisplayTicksTimeout = getTks() + timeout
	customDisplayActive = true	
end