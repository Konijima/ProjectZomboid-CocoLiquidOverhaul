local MathFunctions = require("CLO/Functions/Math")

---@class InventoryFunctions
local InventoryFunctions = {}

---GetDrainableItemContent
---@param _item InventoryItem
---@return number
function InventoryFunctions.GetDrainableItemContent(_item)
    local result = 0
    if (_item:IsDrainable()) then
        local storageAvailable = MathFunctions.Round(1 / _item:getUseDelta())
        local storageContain = MathFunctions.Round(storageAvailable * _item:getUsedDelta())
        result = tonumber(storageContain)
    else
        result = 0
    end
    return result
end

---GetDrainableItemContentString
---@param _item InventoryItem
---@return string
function InventoryFunctions.GetDrainableItemContentString(_item)
    local result = ""
    if (_item:IsDrainable()) then
        local storageAvailable = MathFunctions.Round(1 / _item:getUseDelta())
        local storageContain = MathFunctions.Round(storageAvailable * _item:getUsedDelta())
        result = tostring(storageContain) .. "/" .. tostring(storageAvailable)
    else
        result = "Empty"
    end
    return result
end

---FormatWaterAmount
---@param setX string
---@param amount number
---@param max number
function InventoryFunctions.FormatWaterAmount(setX, amount, max)
    -- Water tiles have waterAmount=9999
    -- Piped water has waterAmount=10000
    if max >= 9999 then
        return string.format("%s: <SETX:%d> %s", getText("ContextMenu_WaterName"), setX, getText("Tooltip_WaterUnlimited"))
    end
    return string.format("%s: <SETX:%d> %d / %d", getText("ContextMenu_WaterName"), setX, amount, max)
end

---RemoveItems
---@param _playerObject IsoPlayer
---@param _items table
function InventoryFunctions.RemoveItems(_playerObject, _items)
    for i = 1, #_items do
        ---@type InventoryItem
        local item = _items[i]
        if _playerObject and item:isEquipped() then
            item:getContainer():setDrawDirty(true)
            _playerObject:removeWornItem(item)
            triggerEvent("OnClothingUpdated", _playerObject)
            if item == _playerObject:getPrimaryHandItem() then
                _playerObject:setPrimaryHandItem(nil)
            end
            if item == _playerObject:getSecondaryHandItem() then
                _playerObject:setSecondaryHandItem(nil)
            end
        end
        item:getContainer():Remove(item)
    end
end

---GetAllFillableWaterItemInInventory
---@param _inventory ItemContainer
---@return table
function InventoryFunctions.GetAllFillableWaterItemInInventory(_inventory)
    if not instanceof(_inventory, "ItemContainer") then return end
    local result = {}
    local items = _inventory:getItems()
    for i = 0, items:size() - 1 do
        ---@type InventoryItem
        local item = items:get(i)
        if item:canStoreWater() and not item:isWaterSource() and not item:isBroken() then
            table.insert(result, item)
        elseif item:canStoreWater() and item:isWaterSource() and not item:isBroken() and instanceof(item, "DrainableComboItem") and item:getUsedDelta() < 1 then
            table.insert(result, item)
        end
    end
    return result
end

---GetFirstItemOfTypeInInventory
---@param _inventory ItemContainer
---@param _itemType string
---@return InventoryItem
function InventoryFunctions.GetFirstItemOfTypeInInventory(_inventory, _itemType)
    if not instanceof(_inventory, "ItemContainer") then return end
    local result
    local items = _inventory:getItems()
    for i = 0, items:size() - 1 do
        ---@type InventoryItem
        local item = items:get(i)
        if item:getType() == _itemType then
            result = item
            break
        end
    end
    return result
end

---GetAllItemOfTypeInInventory
---@param _inventory ItemContainer
---@param _itemType string
---@return table
function InventoryFunctions.GetAllItemOfTypeInInventory(_inventory, _itemType)
    if not instanceof(_inventory, "ItemContainer") then return {} end
    local result = {}
    local items = _inventory:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item:getType() == _itemType then
            table.insert(result, item)
        end
    end
    return result
end

---GetAllItemOfMultipleTypesInInventory
---@param _inventory table
---@param _itemTypes table
---@return table
function InventoryFunctions.GetAllItemOfMultipleTypesInInventory(_inventory, _itemTypes)
    if not instanceof(_inventory, "ItemContainer") then return {} end
    local result = {}
    local items = _inventory:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        for t = 1, #_itemTypes do
            local type = _itemTypes[t]
            if item:getType() == type then
                table.insert(result, item)
            end
        end
    end
    return result
end

---GetFirstEmptyDrainableItemOfTypeInInventory
---@param _inventory ItemContainer
---@param _emptyItemType string The empty item type
---@param _fullItemType string The full item type (drainable)
---@return InventoryItem
function InventoryFunctions.GetFirstEmptyDrainableItemOfTypeInInventory(_inventory, _emptyItemType, _fullItemType)
    if not instanceof(_inventory, "ItemContainer") then return end
    local result
    local emptyItems = InventoryFunctions.GetAllItemOfTypeInInventory(_inventory, _emptyItemType)
    local fullItems = InventoryFunctions.GetAllItemOfTypeInInventory(_inventory, _fullItemType)
    for _, v in pairs(emptyItems) do
        result = v
        break
    end
    for _, v in pairs(fullItems) do
        local item = v
        if item:IsDrainable() and item:getUsedDelta() < 1 then
            result = v
            break
        end
    end
    return result
end

---GetAllEmptyDrainableItemOfTypeInInventory
---@param _inventory ItemContainer
---@param _emptyItemType string The empty item type
---@param _fullItemType string The full item type (drainable)
---@return table
function InventoryFunctions.GetAllEmptyDrainableItemOfTypeInInventory(_inventory, _emptyItemType, _fullItemType)
    if not instanceof(_inventory, "ItemContainer") then return {} end
    local result = {}
    local emptyItems = InventoryFunctions.GetAllItemOfTypeInInventory(_inventory, _emptyItemType)
    local fullItems = InventoryFunctions.GetAllItemOfTypeInInventory(_inventory, _fullItemType)
    for _, v in pairs(emptyItems) do
        table.insert(result, v)
    end
    for _, v in pairs(fullItems) do
        local item = v
        if item:IsDrainable() and item:getUsedDelta() == 0 then
            table.insert(result, item)
        end
    end
    return result
end

---GetAllNotFullDrainableItemOfTypeInInventory
---@param _inventory ItemContainer
---@param _emptyItemType string The empty item type
---@param _fullItemType string The full item type (drainable)
---@return table
function InventoryFunctions.GetAllNotFullDrainableItemOfTypeInInventory(_inventory, _emptyItemType, _fullItemType)
    if not instanceof(_inventory, "ItemContainer") then return {} end
    local result = {}
    local emptyItems = InventoryFunctions.GetAllItemOfTypeInInventory(_inventory, _emptyItemType)
    local fullItems = InventoryFunctions.GetAllItemOfTypeInInventory(_inventory, _fullItemType)
    for _, v in pairs(emptyItems) do
        table.insert(result, v)
    end
    for _, v in pairs(fullItems) do
        local item = v
        if item:IsDrainable() and item:getUsedDelta() < 1 then
            table.insert(result, item)
        end
    end
    return result
end

---GetFirstNotEmptyDrainableItemOfTypeInInventory
---@param _inventory ItemContainer
---@param _itemType string
---@return InventoryItem
function InventoryFunctions.GetFirstNotEmptyDrainableItemOfTypeInInventory(_inventory, _itemType)
    if not instanceof(_inventory, "ItemContainer") then return end
    local result
    local items = InventoryFunctions.GetAllItemOfTypeInInventory(_inventory, _itemType)
    for _, item in pairs(items) do
        if item:IsDrainable() and item:getUsedDelta() > 0 then
            result = item
            break
        end
    end
    return result
end

---GetFirstNotFullDrainableItemOfTypeInInventory
---@param _inventory ItemContainer
---@param _emptyItemType string The empty item type
---@param _fullItemType string The full item type (drainable)
---@return table
function InventoryFunctions.GetFirstNotFullDrainableItemOfTypeInInventory(_inventory, _emptyItemType, _fullItemType)
    if not instanceof(_inventory, "ItemContainer") then return {} end
    local result
    local emptyItems = InventoryFunctions.GetAllItemOfTypeInInventory(_inventory, _emptyItemType)
    local fullItems = InventoryFunctions.GetAllItemOfTypeInInventory(_inventory, _fullItemType)
    for _, v in pairs(emptyItems) do
        result = v
        break
    end
    for _, v in pairs(fullItems) do
        if v:IsDrainable() and v:getUsedDelta() < 1 then
            result = v
            break
        end
    end
    return result
end

---GetAllNotEmptyDrainableItemOfTypeInInventory
---@param _inventory ItemContainer
---@param _itemType string
---@return table
function InventoryFunctions.GetAllNotEmptyDrainableItemOfTypeInInventory(_inventory, _itemType)
    if not instanceof(_inventory, "ItemContainer") then return {} end
    local result = {}
    local items = InventoryFunctions.GetAllItemOfTypeInInventory(_inventory, _itemType)
    for _, item in pairs(items) do
        if item and item:IsDrainable() and item:getUsedDelta() > 0 then
            table.insert(result, item)
        end
    end
    return result
end

---GetFirstFullDrainableItemOfTypeInInventory
---@param _inventory ItemContainer
---@param _itemType string
---@return InventoryItem
function InventoryFunctions.GetFirstFullDrainableItemOfTypeInInventory(_inventory, _itemType)
    if not instanceof(_inventory, "ItemContainer") then return end
    local result
    local items = InventoryFunctions.GetAllItemOfTypeInInventory(_inventory, _itemType)
    for _, item in pairs(items) do
        if item:IsDrainable() and item:getUsedDelta() >= 1 then
            result = item
            break
        end
    end
    return result
end

---GetAllFullDrainableItemOfTypeInInventory
---@param _inventory ItemContainer
---@param _itemType string
---@return table
function InventoryFunctions.GetAllFullDrainableItemOfTypeInInventory(_inventory, _itemType)
    if not instanceof(_inventory, "ItemContainer") then return {} end
    local result = {}
    local items = InventoryFunctions.GetAllItemOfTypeInInventory(_inventory, _itemType)
    for _, item in pairs(items) do
        if item:IsDrainable() and item:getUsedDelta() >= 1 then
            table.insert(result, item)
        end
    end
    return result
end

return InventoryFunctions
