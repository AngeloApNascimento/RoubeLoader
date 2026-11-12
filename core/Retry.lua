--!strict

local Config = require(script.Parent:WaitForChild("Config"))
local Logger = require(script.Parent:WaitForChild("Logger"))

local Retry = {}

function Retry.Run(callback)
    assert(type(callback) == "function", "Retry.Run expects a function")

    local policy = Config.Retry
    local maxAttempts = math.max(1, policy.MaxAttempts)
    local delaySeconds = math.max(0, policy.InitialDelay)

    for attempt = 1, maxAttempts do
        Logger:Info(("Attempt %d/%d"):format(attempt, maxAttempts))

        local callOk, result = pcall(callback)
        local operationOk = callOk and result ~= false

        if operationOk then
            return true, result
        end

        local reason = callOk and "callback returned false" or tostring(result)
        Logger:Error(("Attempt %d failed: %s"):format(attempt, reason))

        if not policy.Enabled or attempt >= maxAttempts then
            break
        end

        task.wait(delaySeconds)
        delaySeconds = math.min(
            delaySeconds * math.max(1, policy.Multiplier),
            math.max(0, policy.MaxDelay)
        )
    end

    return false, "retry policy exhausted"
end

return Retry
