local functions = require("CLO/Functions")
local modSettings = require("CLO/Settings")

---@class API
local API = {}

---CLO_AddNewFuelItem
---@param moduleName string
---@param emptyItemName string
---@param fullItemName string
function API.AddFuelItem(moduleName, emptyItemName, fullItemName)
    functions.Print("Add new gas can item:\n- " .. moduleName .. "." .. emptyItemName .. "\n- " .. moduleName .. "." .. fullItemName)
    table.insert(modSettings.CustomFuelItems, { module = moduleName, empty = emptyItemName, full = fullItemName })
end

return API
