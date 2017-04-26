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

function loadDiffEventsForTrack(trackId)
	diffEvents = loadProperties(trackId .. ".diff")
end

function autoDiffRegularProcessing()
	if autoDiffEnabled and mSessionEnter == 1 and not(m_is_sim_idle) then
		
	end
end
