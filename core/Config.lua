--!strict
-- Edit this file to configure your own Roblox experience.

local Config = {
    Name = "RoubeLoader",
    Version = "1.0.0",

    Debug = true,
    PreventDuplicate = true,

    Logging = {
        Enabled = true,
        MaxEntries = 150,
        Timestamp = true,
    },

    Retry = {
        Enabled = true,
        MaxAttempts = 3,
        InitialDelay = 1,
        Multiplier = 2,
        MaxDelay = 8,
    },

    -- Replace this sample PlaceId with the PlaceId of your own experience.
    -- The value must match a ModuleScript name inside the modules folder.
    ModulesByPlaceId = {
        [123456789] = "Example",
    },
}

return Config
