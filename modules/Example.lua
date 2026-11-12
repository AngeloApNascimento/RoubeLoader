--!strict
-- Demonstration module. Replace with code for an experience you own.

return function(context)
    context.Logger:Info("Example module is running.")
    context.Logger:Info(("Current PlaceId: %d"):format(context.PlaceId))

    -- Put your own authorized initialization logic here.
    -- Return false or raise an error if initialization should be retried.

    return true
end
