require "scripts/simracef1_f1_2016_mike"

local instructions = "b1, b2 etc. or s1p10 would be switch 1 position 10"

print(instructions)

-- Stubs
devName = "SIMRACE-F1"

local throttle = 0
local pits = 0
local lapDistance = 10
local trackSize = 100
local laps = 0
local totalLaps = 10
local fuel = 70
local yellow = false

local left = ""
local right = ""

mDisplay_Info_Delay = 600

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
displayFunctionIndex["left"][9] = 7
displayFunctionIndex["left"][10] = 121
displayFunctionIndex["left"][11] = 198
displayFunctionIndex["left"][12] = 194

displayFunctionIndex["right"][0] = 199
displayFunctionIndex["right"][1] = 6
displayFunctionIndex["right"][2] = 11
displayFunctionIndex["right"][3] = 10
displayFunctionIndex["right"][4] = 48
displayFunctionIndex["right"][5] = 49
displayFunctionIndex["right"][6] = 41
displayFunctionIndex["right"][7] = 126
displayFunctionIndex["right"][8] = 8
displayFunctionIndex["right"][9] = 195
displayFunctionIndex["right"][10] = 199
displayFunctionIndex["right"][11] = 199

function GetDeviceType(deviceType)
	return deviceType
end
function UpdateDigits(leftStr, rightStr, dev)
	print("Display: " .. leftStr .. " : " .. rightStr)
end
function SetLeftDigits(text)
	left = text
end
function SetRightDigits(text)
	right = text
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
	local endTime = getTks() + delay
	print("Wait: " .. delay)
	while getTks() < endTime do		
	end
end
function GetCarInfo(item)
	if item == "throttle" then
		return throttle
	elseif item == "fuel" then
		return fuel
	end
end
function GetContextInfo(item)
	if item == "yellow_flag" then
		return yellow
	elseif item == "lap_distance" then
		return lapDistance
	elseif item == "laps" then
		return laps
	elseif item == "laps_count" then
		return totalLaps
	elseif item == "track_size" then
		return trackSize
	end
end
function GetInPitsState()
	return pits
end
function GetDisplayFunctionIndex(side, pos)
	return displayFunctionIndex[side][pos]
end
function SetPatternLed(pattern, state)
	print("LED Pattern: " .. pattern .. ", State: " .. state)
end

mSessionEnter = 1
m_is_sim_idle = false
-- End Stubs

local leftDisplayPos = 1
local rightDisplayPos = 1
while true do
	swValue = GetDisplayFunctionIndex("left", leftDisplayPos)
	custom_left_Display_Event(leftDisplayPos)
	custom_right_Display_Event(rightDisplayPos)
	UpdateDigits(left, right, 3)
	
	print("user input: ")
	local input = io.read("*l")
	local buttonEvent = string.find(input, "b")
	local switchEvent = string.find(input, "s")
	local sessionEvent = string.find(input, "z")
	
	if buttonEvent ~= nil then
		local button = tonumber(string.sub(input, buttonEvent + 1))
		custom_controls_Event(3, 1, button, 0, 0, 3)
	elseif switchEvent ~= nil then
		local switch = tonumber(string.sub(input, switchEvent + 1, 2))
		local position = string.find(input, "p")
		local switchPos = tonumber(string.sub(input, position + 1))	
		custom_controls_Event(3, 0, switch, switchPos, 0, 3)
		
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
	end
end
