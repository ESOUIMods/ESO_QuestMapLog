--[[

Quest Map Log
by CaptainBlagbird
https://github.com/CaptainBlagbird

--]]

-- Addon info
local AddonName = "QuestMapLog"
QuestMapLog = {}
QuestMapLog.savedVars = {}

QuestMapLog.data_default = {
    data = {},
}

QuestMapLog.game_default = {
    data = {},
}

function QuestMapLog:GetData()
    -- Saved variables table
    QM_Log = {}
    
    local id
    local id
    -- There currently are < 6000 quests, but some can be completed multiple times.
    -- 10000 should be more than enough to get all completed quests and still avoid an endless loop.
    for i=0, 10000 do
        -- Get next completed quest. If it was the last, break loop
        id = GetNextCompletedQuestId(id)
        if id == nil then break end
        QM_Log[id] = {}
        QM_Log[id].name, QM_Log[id].questType = GetCompletedQuestInfo(id)
        QM_Log[id].zoneName, QM_Log[id].objectiveName, QM_Log[id].zoneIndex, QM_Log[id].poiIndex = GetCompletedQuestLocationInfo(id)
        QM_Log[id].lang = GetCVar("language.2")
    end
    QuestMapLog.savedVars["log"].data = QM_Log
end

-- Event handler function for EVENT_PLAYER_ACTIVATED
local function OnPlayerActivated(eventCode)
    QuestMapLog.savedVars = {
        ["settings"]    = ZO_SavedVars:NewAccountWide("QuestMapLog_SavedVariables", 1, "settings", QuestMapLog.game_default),
        ["log"]         = ZO_SavedVars:New("QuestMapLog_SavedVariables", 1, "log", QuestMapLog.data_default),
    }
    QuestMapLog:GetData()
    QuestMapLog.savedVars["settings"].data.lang = GetCVar("language.2")
    
    EVENT_MANAGER:UnregisterForEvent(AddonName, EVENT_PLAYER_ACTIVATED)
end
EVENT_MANAGER:RegisterForEvent(AddonName, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
