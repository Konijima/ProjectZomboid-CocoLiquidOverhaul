local functions = require("CLO/Functions")

CLO_Contexts = CLO_Contexts or {}

---Context_InventoryDebug
---@param _playerNum number
---@param _context ISContextMenu
---@param _items table
local function Context_InventoryDebug(_playerNum, _context, _items)

    if not getCore():getDebug() then return end

    ---@type IsoPlayer
    local playerObject = getSpecificPlayer(_playerNum)

    ---@type table
    local items = functions.Context.ConvertInventoryItemsToArray(_items)

    ---@type ISContextMenu
    local subMenu = functions.Context.CreateSubMenu(_context, "[DEBUG] CLO")

    if #items > 1 then
        subMenu:addOption("Delete " .. #items .. " items", playerObject, functions.Inventory.RemoveItems, items)
    else
        local item = items[1]
        subMenu:addOption("Delete " .. item:getName(), playerObject, functions.Inventory.RemoveItems, items)
    end
end

CLO_Contexts.Context_InventoryDebug = Context_InventoryDebug