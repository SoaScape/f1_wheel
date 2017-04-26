require "scripts/mikes_custom_plugins/mike_led_utils"

autoDiffMultifunctionName = "ADIF"

function processAutoDiffButtonEvent(button)
	if autoDiffEnabled then
		if button == confirmButton then
		elseif button == upButton then
		elseif button == downButton then
		elseif button == upEncoder then
		elseif button == downEncoder then
		end
	end
end

function processTrackChange(trackId)

end
