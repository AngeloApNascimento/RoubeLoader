--!strict
-- RoubeLoader entry point.
-- Place this ModuleScript beside the core/ and modules/ folders.

local packageFolder = script.Parent
local core = packageFolder:WaitForChild("core")

local Config = require(core:WaitForChild("Config"))
local Logger = require(core:WaitForChild("Logger"))
local Registry = require(core:WaitForChild("Registry"))
local Loader = require(core:WaitForChild("Loader"))

local started = false

local function start()
    if Config.PreventDuplicate and started then
        Logger:Warn("Start ignored: loader already started.")
        return false
    end

    local placeId = game.PlaceId
    local moduleName = Registry:GetModuleName(placeId)

    Logger:Info(("RoubeLoader %s starting for PlaceId %d"):format(
        Config.Version,
        placeId
    ))

    if not moduleName then
        Logger:Warn(("No module is configured for PlaceId %d"):format(placeId))
        return false
    end

    local modulesFolder = packageFolder:WaitForChild("modules")
    local moduleScript = modulesFolder:FindFirstChild(moduleName)

    if not moduleScript or not moduleScript:IsA("ModuleScript") then
        Logger:Error(("Configured ModuleScript '%s' was not found"):format(moduleName))
        return false
    end

    local ok, result = Loader:Run(moduleScript, {
        PlaceId = placeId,
        GameId = game.GameId,
        Logger = Logger,
        Config = Config,
    })

    if ok then
        started = true
        Logger:Info("Initialization completed.")
        return true, result
    end

    Logger:Error("Initialization failed after retry policy was applied.")
    return false, result
end

local function getLogs()
    return Logger:GetHistory()
end

local function getConfig()
    return Config
end

return {
    Start = start,
    GetLogs = getLogs,
    GetConfig = getConfig,
    GetVersion = function()
        return Config.Version
    end,
}
