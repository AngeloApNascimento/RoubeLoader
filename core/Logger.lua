--!strict

local Config = require(script.Parent:WaitForChild("Config"))

local Logger = {}
local history = {}

local function makeTimestamp()
    if not Config.Logging.Timestamp then
        return ""
    end

    return os.date("%Y-%m-%d %H:%M:%S") .. " "
end

function Logger:Write(level, message)
    if not Config.Logging.Enabled then
        return
    end

    local entry = {
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        level = level,
        message = tostring(message),
    }

    table.insert(history, entry)

    local maxEntries = math.max(1, Config.Logging.MaxEntries)
    while #history > maxEntries do
        table.remove(history, 1)
    end

    local line = ("[%s]%s[%s] %s"):format(
        Config.Name,
        makeTimestamp(),
        level,
        entry.message
    )

    if level == "ERROR" or level == "WARN" then
        warn(line)
    elseif Config.Debug then
        print(line)
    end
end

function Logger:Info(message)
    self:Write("INFO", message)
end

function Logger:Warn(message)
    self:Write("WARN", message)
end

function Logger:Error(message)
    self:Write("ERROR", message)
end

function Logger:GetHistory()
    local copy = {}
    for index, entry in ipairs(history) do
        copy[index] = {
            timestamp = entry.timestamp,
            level = entry.level,
            message = entry.message,
        }
    end
    return copy
end

return Logger
