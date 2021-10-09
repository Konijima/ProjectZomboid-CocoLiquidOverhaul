CLO_Contexts = CLO_Contexts or {}

---Context_InventoryDebug
---@param _playerNum number
---@param _context ISContextMenu
---@param _items table
local function Context_InventoryDebug(_playerNum, _context, _items)

    if not CLO_ModSettings.Config.Debug then return end

    ---@type IsoPlayer
    local playerObject = getSpecificPlayer(_playerNum)

    ---@type table
    local items = CLO_Context.ConvertInventoryItemsToArray(_items)

    ---@type ISContextMenu
    local subMenu = CLO_Context.CreateSubMenu(_context, "[DEBUG] CLO")

    if #items > 1 then
        subMenu:addOption("Delete " .. #items .. " items", playerObject, CLO_Inventory.RemoveItems, items)
    else
        local item = items[1]
        subMenu:addOption("Delete " .. item:getName(), playerObject, CLO_Inventory.RemoveItems, items)
    end
end

CLO_Contexts.Context_InventoryDebug = Context_InventoryDebug