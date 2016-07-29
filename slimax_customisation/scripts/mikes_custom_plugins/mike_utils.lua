myDevice = 3 -- 3 = SIMR-F1
switch = 0
pushbutton = 1
buttonReleaseValue = 0
customDisplayActive = false
customDisplayTicksTimeout = 0

function customDisplayIsActive()
	if customDisplayActive and getTks() > customDisplayTicksTimeout then		
		customDisplayActive = false
	end
	return customDisplayActive
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

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end