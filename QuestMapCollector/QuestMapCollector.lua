--[[

Quest Map
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

-- Addon info
QuestMapCollector = {}
QuestMapCollector.name = "QuestMapCollector"

local function GetData()
	-- Set up SavedVariables table
	local savedVars = ZO_SavedVars:New("Log", 1, nil, {})
	savedVars.Log = {}
	
	local id
	while true do
		-- Get next completed quest. If it was the last, break loop
		id = GetNextCompletedQuestId(id)
		if id == nil then break end
		savedVars.Log[id] = {}
		savedVars.Log[id].name, savedVars.Log[id].questType = GetCompletedQuestInfo(id)
		savedVars.Log[id].zoneName, savedVars.Log[id].objectiveName, savedVars.Log[id].zoneIndex, savedVars.Log[id].poiIndex = GetCompletedQuestLocationInfo(id)
	end
	d("|c70C0DE["..QuestMapCollector.name.."] |rData collected")
end

-- Event handler function for EVENT_PLAYER_ACTIVATED
local function OnPlayerActivated(event)
	SLASH_COMMANDS["/qmlog"] = GetData
	
	EVENT_MANAGER:UnregisterForEvent(QuestMapCollector.name, EVENT_PLAYER_ACTIVATED)
end


-- Registering the event handler functions for the events
EVENT_MANAGER:RegisterForEvent(QuestMapCollector.name, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)