require "scripts/simracef1_f1_2016_mike"

debug = true

local instructions = "b1, b2 etc. or s1p10 would be switch 1 position 10"

local modes = {}
modes["m"] = "multifunction"
modes["u"] = "up"
modes["d"] = "down"
modes["c"] = "confirm"
modes["o"] = "overtake"

print(instructions)

while true do
	print("user input: ")
	local input = io.read("*l")
	local buttonEvent = string.find(input, "b")
	local switchEvent = string.find(input, "s")

	if buttonEvent ~= nil then
		local button = string.sub(input, buttonEvent + 1)
		multiControlsEvent(3, 1, tonumber(button), 0)
	elseif switchEvent ~= nil then
		local switch = string.sub(input, switchEvent + 1, 2)
		local position = string.find(input, "p")
		local switchPos = string.sub(input, position + 1)
		multiControlsEvent(3, 0, tonumber(switch), tonumber(switchPos))
	end
end
