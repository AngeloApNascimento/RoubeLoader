--!strict

local Config = require(script.Parent:WaitForChild("Config"))

local Registry = {}

function Registry:GetModuleName(placeId)
    return Config.ModulesByPlaceId[placeId]
end

return Registry
