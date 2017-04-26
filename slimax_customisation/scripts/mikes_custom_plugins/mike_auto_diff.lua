require "scripts/mikes_custom_plugins/mike_led_utils"

autoDiffMultifunctionName = "ADIF"

local autoDiffActive = false
local diffEvents = nil

local tyres = {}
tyres[0] = "ULTR"
tyres[1] = "SUPR"
tyres[2] = "SOFT"
tyres[3] = "MEDM"
tyres[4] = "HARD"
tyres[5] = "INTR"
tyres[6] = "WETS"
local minTyre = 0
local maxTyre = 6
local currentTyre = 1

function processAutoDiffButtonEvent(button)
	if autoDiffEnabled then
		if button == confirmButton then
			if autoDiffActive then
				autoDiffActive = false
			else
				autoDiffActive = true
				loadDiffEventsForTrack(trackMultiFunction["modes"][trackMultiFunction["currentUpDnMode"]])
			end
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

--The differential on throttle works like it does it real life. A more locked diff will give you more grip, but if you overload the outside tire it will break traction very quickly and spin. A more open diff will not have as much pure grip, but will break traction in a much smoother manner.
--The way you should use this is based on the amount of grip available from the track and tires. For example, in FP1 the track is very low grip. The diff should be turned down or you will get excessive wheel spin when exiting corners. The softer the tires, the more grip they give initially, so you can turn up the diff to get more performance from them. When you start to get corner exit oversteer, start going back down on the diff to match the grip level.
--That is the easy way to control power on oversteer. You can also do it corner by corner if you can keep up. Faster corners like higher diff levels, lower speed corners where you need more traction forgiveness, turn the diff back down.
--The hards like 60s, mediums 70s, softs 80s and supersofts 90s when they are brand new. Havent drove the ultras yet