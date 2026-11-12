--!strict

local Retry = require(script.Parent:WaitForChild("Retry"))
local Logger = require(script.Parent:WaitForChild("Logger"))

local Loader = {}

function Loader:Run(moduleScript, context)
    assert(moduleScript and moduleScript:IsA("ModuleScript"), "Expected a ModuleScript")

    return Retry.Run(function()
        -- require() is limited to a ModuleScript that is part of this installed project.
        local moduleValue = require(moduleScript)

        if type(moduleValue) ~= "function" then
            error(("Module '%s' must return a function"):format(moduleScript.Name))
        end

        local result = moduleValue(context)

        if result == false then
            error(("Module '%s' reported initialization failure"):format(moduleScript.Name))
        end

        return result
    end)
end

return Loader
