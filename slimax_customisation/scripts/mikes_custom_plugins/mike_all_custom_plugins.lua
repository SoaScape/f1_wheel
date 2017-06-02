require "scripts/mikes_custom_plugins/mike_auto_mix"
require "scripts/mikes_custom_plugins/mike_auto_diff"
require "scripts/mikes_custom_plugins/mike_multifunction_switch"
require "scripts/mikes_custom_plugins/mike_custom_displays"
require "scripts/mikes_custom_plugins/mike_utils"
require "scripts/mikes_custom_plugins/mike_one_switch"
require "scripts/mikes_custom_plugins/mike_race_start_mode"
require "scripts/mikes_custom_plugins/mike_safety_car_mode"

function custom_controls_Event(deviceType, ctrlType, ctrlPos, value, funcIndex, targetDevice)
	local mult = multiControlsEvent(deviceType, ctrlType, ctrlPos, value)
	local oneSw = oneSwitchControlEvent(ctrlType, ctrlPos, value)
	if mult < oneSw then
		return mult
	else
		return oneSw
	end
end

local function performRegularProcessing()
	performRegularCustomDisplayProcessing()
	autoMixRegularProcessing()
	autoDiffRegularProcessing()
	raceStartRegularProcessing()
	safetyCarModeRegularProcessing()
	utilsRegularProcessing()
	updateLeds()
end

local function dispEvent(side, swPosition)	
	if not(customDisplayIsActive()) then		
		return customDisplayEventProcessing(swValue, side)
	else
		return 1
	end
end

function custom_left_Display_Event(swPosition)	
	performRegularProcessing()
	return dispEvent(0, swPosition)
end

function custom_right_Display_Event(swPosition)
	oneSwitchRightDisplayEvent(swPosition)
	return dispEvent(1, swPosition)
end
