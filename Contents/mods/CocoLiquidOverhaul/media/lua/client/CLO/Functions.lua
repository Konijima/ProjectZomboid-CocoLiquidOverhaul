local settings = require("CLO/Settings")

--- Custom CLO Print
---@param _message string
local function Print(_message)
    if settings.Config.Verbose then
        local message = "CLO: " .. _message
        if settings.Loaded then
            print(message)
        else
            table.insert(settings.PreloadLogs, message)
        end
    end
end

return {
    Print = Print,
    Context = require("CLO/Functions/Context"),
    Dispenser = require("CLO/Functions/Dispenser"),
    Inventory = require("CLO/Functions/Inventory"),
    Math = require("CLO/Functions/Math"),
    Object = require("CLO/Functions/Object"),
    World = require("CLO/Functions/World"),
}