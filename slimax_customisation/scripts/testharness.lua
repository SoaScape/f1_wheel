require "scripts/vdashemu_f1_2018_mercedes_mike"

local instructions = "b1, b2 etc. or s1p10 would be switch 1 position 10"

print(instructions)

-- Stubs
devName = "SIMRACE-F1"

local locals = {}

locals["throttle"] = 0
locals["pits"] = 0
locals["lapDistance"] = 0
locals["trackSize"] = 100
locals["laps"] = 1
locals["totalLaps"] = 10
locals["fuel"] = 101
locals["startFuel"] = 101
locals["fuelMix"] = 1.0
locals["brakeBias"] = 40.0
locals["kiloMultiplier"] = 1
locals["yellow"] = "false"

locals["left"] = ""
locals["right"] = ""

mDisplay_Info_Delay = 600
mRefreshLapTimeRate = 50
mDeltaTimeDelay = 50
mDeltaTimeAlternateOldTicks = 0
mDeltaTimeOldTicks = 0

displayFunctionIndex = {}
displayFunctionIndex["left"] = {}
displayFunctionIndex["right"] = {}

displayFunctionIndex["left"][1] = 3
displayFunctionIndex["left"][2] = 193
displayFunctionIndex["left"][3] = 1
displayFunctionIndex["left"][4] = 9
displayFunctionIndex["left"][5] = 47
displayFunctionIndex["left"][6] = 5
displayFunctionIndex["left"][7] = 42
displayFunctionIndex["left"][8] = 127
displayFunctionIndex["left"][9] = 190
displayFunctionIndex["left"][10] = 121
displayFunctionIndex["left"][11] = 198
displayFunctionIndex["left"][12] = 194

-- The one switch function adds 1 onto the swValue for right hand switch
displayFunctionIndex["right"][0] = 199-1
displayFunctionIndex["right"][1] = 6-1
displayFunctionIndex["right"][2] = 11-1
displayFunctionIndex["right"][3] = 10-1
displayFunctionIndex["right"][4] = 48-1
displayFunctionIndex["right"][5] = 49-1
displayFunctionIndex["right"][6] = 41-1
displayFunctionIndex["right"][7] = 126-1
displayFunctionIndex["right"][8] = 191-1
displayFunctionIndex["right"][9] = 195-1
displayFunctionIndex["right"][10] = 199-1
displayFunctionIndex["right"][11] = 192-1

function GetDeviceType(deviceType)
	return deviceType
end
function UpdateDigits(leftStr, rightStr, dev)
	print("Display: " .. leftStr .. " : " .. rightStr)
end
function SetLeftDigits(text)
	locals["left"] = text
end
function SetRightDigits(text)
	locals["right"] = text
end
function SLISendReport(val)
end
function GetAppInfo(info)
	if info == "ticks" then
		return os.time() * 1000
	end
end
function SetKeystroke(key, holdDelay, str)
	print("Key: " .. key .. " (" .. holdDelay .. "ms)")
end
function SLISleep(delay)
	--local endTime = getTks() + delay
	print("Wait: " .. delay)
	--while getTks() < endTime do		
	--end
end
function GetCarInfo(item)
	if item == "throttle" then
		return locals["throttle"]
	elseif item == "fuel" then
		return locals["fuel"]
	elseif item == "fuel_total" then
		return locals["startFuel"]
	elseif item == "fuel_mix" then
		return locals["fuelMix"]
	end
end
function GetContextInfo(item)
	if item == "yellow_flag" then
		return locals["yellow"] == "true"
	elseif item == "lap_distance" then
		return locals["lapDistance"]
	elseif item == "laps" then
		return locals["laps"]
	elseif item == "laps_count" then
		return locals["totalLaps"]
	elseif item == "track_size" then
		return locals["trackSize"]
	end
end
function GetBrakeBiasState()
	return locals["brakeBias"]
end
function GetInPitsState()
	return locals["pits"]
end
function GetDisplayFunctionIndex(side, pos)
	return displayFunctionIndex[side][pos]
end
function GetTimeInfo(info)
	return 3.3
end
function GetFuelKilogram(fuel)
	return fuel * locals["kiloMultiplier"]
end
function timeDispatcher(lpt)
	-- hr, mn, sc, hd, tms
	return 13, 00, 00, 00, 00
end
function SetPatternLed(pattern, state)
	print("LED Pattern: " .. pattern .. ", State: " .. state)
end

mSessionEnter = 1
m_is_sim_idle = false
-- End Stubs

local function numberise(line)
	local result = tonumber(line)

	if result ~= nil then
		return result
	else
		return line
	end
end

local leftDisplayPos = 1
local rightDisplayPos = 1

local function showDisplay()	
	swValue = GetDisplayFunctionIndex("left", leftDisplayPos)
	custom_left_Display_Event(leftDisplayPos)
	custom_right_Display_Event(rightDisplayPos)
	UpdateDigits(locals["left"], locals["right"], 3)
end

while true do
	showDisplay()

	print("user input: ")
	local input = io.read("*l")
	local buttonEvent = string.find(input, "b")
	local switchEvent = string.find(input, "s")
	local sessionEvent = string.find(input, "z")
	local globalVarEvent = string.find(input, "g")
	local localVarEvent = string.find(input, "l")
	
	if buttonEvent ~= nil then
		local button = tonumber(string.sub(input, buttonEvent + 1))
		custom_controls_Event(myDevice, 1, button, 0, 0, myDevice)
	elseif switchEvent ~= nil then
		local switch = tonumber(string.sub(input, switchEvent + 1, 2))
		local position = string.find(input, "p")
		local switchPos = tonumber(string.sub(input, position + 1))	
		custom_controls_Event(myDevice, 0, switch, switchPos, 0, myDevice)
		
		if switch == 1 then
			rightDisplayPos = switchPos
		elseif switch == 2 then
			leftDisplayPos = switchPos
		end
	elseif sessionEvent ~= nil then
		if m_is_sim_idle then
			mSessionEnter = 1
			m_is_sim_idle = false
			print("Session Active")
		else
			mSessionEnter = 0
			m_is_sim_idle = true
			print("Session Idle")
		end
	elseif globalVarEvent then
		print("global variable name: ")
		local name = io.read("*l")
		if _G[name] ~= nil then
			print("global variable value (currently: " .. _G[name] .. "): ")
		else
			print("new global variable value (currently: null): ")
		end
		local val = io.read("*l")
		if val ~= nil and string.len(val) > 0 then
			_G[name] = numberise(val)
			print("set global '" .. name .. "' to value: " .. _G[name])
		end
	elseif localVarEvent then
		print("local variable name: ")
		local name = io.read("*l")
		if locals[name] ~= nil then
			print("local variable value (currently: " .. locals[name] .. "): ")
			local val = io.read("*l")
			if val ~= nil and string.len(val) > 0 then
				locals[name] = numberise(val)
				print("set local '" .. name .. "' to value: " .. locals[name])
			end
		else
			print("variable " .. name .. " does not exist")
		end
	end
end
