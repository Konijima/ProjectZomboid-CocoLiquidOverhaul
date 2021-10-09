local CLO_Funcs = {}

---CLO_Print
---@param _message string
function CLO_Print(_message)
    if CLO_ModSettings.Config.Verbose then
        print(CLO_ModSettings.Name .. ": " .. _message)
    end
end

-------------------------------------------------------------------------
--- # MATH
-------------------------------------------------------------------------

---Round
---@param x number
---@return number
function CLO_Funcs.Round(x)
    return x + 0.5 - (x + 0.5) % 1
end

---Hypo
---@param x number
---@param y number
---@return number
function CLO_Funcs.Hypo(x, y)
    return math.sqrt(x^2 + y^2)
end

---Distance
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function CLO_Funcs.Distance(x1, y1, x2, y2)
    return CLO_Funcs.Hypo(x2 - x1, y2 - y1)
end

-------------------------------------------------------------------------
--- # WORLD
-------------------------------------------------------------------------

---DistanceBetweenSquares
---@param _squareA IsoGridSquare
---@param _squareB IsoGridSquare
---@return number
function CLO_Funcs.DistanceBetweenSquares(_squareA, _squareB)
    if not instanceof(_squareA, "IsoGridSquare") or not instanceof(_squareB, "IsoGridSquare") then return end
    local x1, y1 = _squareA:getX(), _squareA:getY()
    local x2, y2 = _squareB:getX(), _squareB:getY()
    return CLO_Funcs.Distance(x1, y1, x2, y2)
end

---GetAvailableFuelOnSquare
---@param _square IsoGridSquare
---@return number
function CLO_Funcs.GetAvailableFuelOnSquare(_square)
    if not instanceof(_square, "IsoGridSquare") then return 0 end
    local fuelAvailable = tonumber(_square:getProperties():Val("fuelAmount"))
    return fuelAvailable or 0
end

---SetAvailableFuelOnSquare
---@param _square IsoGridSquare
---@param _fuelAmount number
function CLO_Funcs.SetAvailableFuelOnSquare(_square, _fuelAmount)
    if not instanceof(_square, "IsoGridSquare") then return 0 end
    _square:getProperties():Set("fuelAmount", _fuelAmount)
end

---GetFirstObjectWithCustomNameOnSquare
---@param _square IsoGridSquare
---@param _customName string
---@return IsoObject
function CLO_Funcs.GetFirstObjectWithCustomNameOnSquare(_square, _customName)
    if not instanceof(_square, "IsoGridSquare") then return end
    local result
    local objects = _square:getObjects()
    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        local customName = CLO_Funcs.GetObjectCustomName(object)
        if customName == _customName then
            result = object
            break
        end
    end
    return result
end

---GetAllObjectsWithCustomNameOnSquare
---@param _square table
---@param _customName table
---@return table
function CLO_Funcs.GetAllObjectsWithCustomNameOnSquare(_square, _customName)
    if not instanceof(_square, "IsoGridSquare") then return {} end
    local result = {}
    local objects = _square:getObjects()
    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        local customName = CLO_Funcs.GetObjectCustomName(object)
        if customName == _customName then
            table.insert(result, object)
        end
    end
    return result
end

-------------------------------------------------------------------------
--- # OBJECT
-------------------------------------------------------------------------

---GetObjectCustomName
---@param _object IsoObject
---@return string
function CLO_Funcs.GetObjectCustomName(_object)
    if not instanceof(_object, "IsoObject") then return "" end
    return _object:getProperties():Val("CustomName")
end

---GetObjectFacing
---@param _object IsoObject
---@return string
function CLO_Funcs.GetObjectFacing(_object)
    if not instanceof(_object, "IsoObject") then return "" end
    return _object:getProperties():Val("Facing")
end

---GetObjectWaterTainted
---@param _object IsoObject
---@return boolean
function CLO_Funcs.GetObjectWaterTainted(_object)
    if not instanceof(_object, "IsoObject") then return end
    return _object:getModData().taintedWater
end

---SetObjectWaterTainted
---@param _object IsoObject
---@param _tainted boolean
function CLO_Funcs.SetObjectWaterTainted(_object, _tainted)
    if not instanceof(_object, "IsoObject") then return end
    _object:getModData().taintedWater = _tainted
end

---GetObjectWaterAmount
---@param _object IsoObject
---@return number
function CLO_Funcs.GetObjectWaterAmount(_object)
    if not instanceof(_object, "IsoObject") then return 0 end
    return tonumber(_object:getModData().amountWater)
end

---SetObjectWaterAmount
---@param _object IsoObject
---@param _waterAmount number
function CLO_Funcs.SetObjectWaterAmount(_object, _waterAmount)
    if not instanceof(_object, "IsoObject") then return end
    if not _waterAmount then _waterAmount = CLO_ModSettings.DispenserAmountMax end
    if _waterAmount > CLO_ModSettings.DispenserAmountMax then _waterAmount = CLO_ModSettings.DispenserAmountMax end
    _object:getModData().waterAmount = 0
    _object:getModData().amountWater = _waterAmount
end

---GetObjectWaterMax
---@param _object IsoObject
---@return number
function CLO_Funcs.GetObjectWaterMax(_object)
    if not instanceof(_object, "IsoObject") then return 0 end
    return tonumber(_object:getModData().maxWater)
end

---SetObjectWaterMax
---@param _object IsoObject
---@param _waterMax number
function CLO_Funcs.SetObjectWaterMax(_object, _waterMax)
    if not instanceof(_object, "IsoObject") then return end
    _object:getModData().waterMax = 0
    _object:getModData().maxWater = _waterMax
end

---GetObjectFuelAmount
---@param _object IsoObject
---@return number
function CLO_Funcs.GetObjectFuelAmount(_object)
    if not instanceof(_object, "IsoObject") then return 0 end
    return tonumber(_object:getModData().amountFuel)
end

---SetObjectFuelAmount
---@param _object IsoObject
---@param _fuelAmount number
function CLO_Funcs.SetObjectFuelAmount(_object, _fuelAmount)
    if not instanceof(_object, "IsoObject") then return end
    if not _fuelAmount then _fuelAmount = 0 end
    if _fuelAmount > CLO_ModSettings.DispenserAmountMax then _fuelAmount = CLO_ModSettings.DispenserAmountMax end
    _object:getModData().amountFuel = _fuelAmount
end

---GetObjectFuelMax
---@param _object IsoObject
---@return number
function CLO_Funcs.GetObjectFuelMax(_object)
    if not instanceof(_object, "IsoObject") then return 0 end
    return tonumber(_object:getModData().maxFuel)
end

---SetObjectFuelMax
---@param _object IsoObject
---@param _fuelMax number
function CLO_Funcs.SetObjectFuelMax(_object, _fuelMax)
    if not instanceof(_object, "IsoObject") then return end
    _object:getModData().maxFuel = _fuelMax
end

---CreateObject
---@param _spriteName string
---@param _square IsoGridSquare
---@return IsoObject
function CLO_Funcs.CreateObject(_spriteName, _square)
    if not instanceof(_square, "IsoGridSquare") then return end
    local obj = IsoObject.new(_square, _spriteName, "")
    _square:AddTileObject(obj)
    CLO_Print("Created object " .. _spriteName .. " on square x:" .. _square:getX() .. " y:" .. _square:getY())
    return obj
end

---DeleteObject
---@param _object IsoObject
function CLO_Funcs.DeleteObject(_object)
    if not instanceof(_object, "IsoObject") then return end
    local square = _object:getSquare()
    if square then
        local objectCustomName = CLO_Funcs.GetObjectCustomName(_object)
        square:transmitRemoveItemFromSquare(_object)
        square:RecalcProperties()
        CLO_Print("Deleted object " .. objectCustomName .. " on square x:" .. tostring(square:getX()) .. " y:" .. tostring(square:getY()))
    end
end

-------------------------------------------------------------------------
--- # INVENTORY
-------------------------------------------------------------------------

---GetDrainableItemContent
---@param _item InventoryItem
---@return number
function CLO_Funcs.GetDrainableItemContent(_item)
    local result = 0
    if (_item:IsDrainable()) then
        local storageAvailable = CLO_Funcs.Round(1 / _item:getUseDelta())
        local storageContain = CLO_Funcs.Round(storageAvailable * _item:getUsedDelta())
        result = tonumber(storageContain)
    else
        result = 0
    end
    return result
end

---GetDrainableItemContentString
---@param _item InventoryItem
---@return string
function CLO_Funcs.GetDrainableItemContentString(_item)
    local result = ""
    if (_item:IsDrainable()) then
        local storageAvailable = CLO_Funcs.Round(1 / _item:getUseDelta())
        local storageContain = CLO_Funcs.Round(storageAvailable * _item:getUsedDelta())
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
function CLO_Funcs.FormatWaterAmount(setX, amount, max)
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
function CLO_Funcs.RemoveItems(_playerObject, _items)
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
function CLO_Funcs.GetAllFillableWaterItemInInventory(_inventory)
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
function CLO_Funcs.GetFirstItemOfTypeInInventory(_inventory, _itemType)
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
function CLO_Funcs.GetAllItemOfTypeInInventory(_inventory, _itemType)
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
function CLO_Funcs.GetAllItemOfMultipleTypesInInventory(_inventory, _itemTypes)
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
function CLO_Funcs.GetFirstEmptyDrainableItemOfTypeInInventory(_inventory, _emptyItemType, _fullItemType)
    if not instanceof(_inventory, "ItemContainer") then return end
    local result
    local emptyItems = CLO_Funcs.GetAllItemOfTypeInInventory(_inventory, _emptyItemType)
    local fullItems = CLO_Funcs.GetAllItemOfTypeInInventory(_inventory, _fullItemType)
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
function CLO_Funcs.GetAllEmptyDrainableItemOfTypeInInventory(_inventory, _emptyItemType, _fullItemType)
    if not instanceof(_inventory, "ItemContainer") then return {} end
    local result = {}
    local emptyItems = CLO_Funcs.GetAllItemOfTypeInInventory(_inventory, _emptyItemType)
    local fullItems = CLO_Funcs.GetAllItemOfTypeInInventory(_inventory, _fullItemType)
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
function CLO_Funcs.GetAllNotFullDrainableItemOfTypeInInventory(_inventory, _emptyItemType, _fullItemType)
    if not instanceof(_inventory, "ItemContainer") then return {} end
    local result = {}
    local emptyItems = CLO_Funcs.GetAllItemOfTypeInInventory(_inventory, _emptyItemType)
    local fullItems = CLO_Funcs.GetAllItemOfTypeInInventory(_inventory, _fullItemType)
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
function CLO_Funcs.GetFirstNotEmptyDrainableItemOfTypeInInventory(_inventory, _itemType)
    if not instanceof(_inventory, "ItemContainer") then return end
    local result
    local items = CLO_Funcs.GetAllItemOfTypeInInventory(_inventory, _itemType)
    for i = 1, #items do
        local item = items:get(i)
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
function CLO_Funcs.GetFirstNotFullDrainableItemOfTypeInInventory(_inventory, _emptyItemType, _fullItemType)
    if not instanceof(_inventory, "ItemContainer") then return {} end
    local result
    local emptyItems = CLO_Funcs.GetAllItemOfTypeInInventory(_inventory, _emptyItemType)
    local fullItems = CLO_Funcs.GetAllItemOfTypeInInventory(_inventory, _fullItemType)
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
function CLO_Funcs.GetAllNotEmptyDrainableItemOfTypeInInventory(_inventory, _itemType)
    if not instanceof(_inventory, "ItemContainer") then return {} end
    local result = {}
    local items = CLO_Funcs.GetAllItemOfTypeInInventory(_inventory, _itemType)
    for i = 1, #items do
        local item = items:get(i)
        if item:IsDrainable() and item:getUsedDelta() > 0 then
            table.insert(result, item)
        end
    end
    return result
end

---GetFirstFullDrainableItemOfTypeInInventory
---@param _inventory ItemContainer
---@param _itemType string
---@return InventoryItem
function CLO_Funcs.GetFirstFullDrainableItemOfTypeInInventory(_inventory, _itemType)
    if not instanceof(_inventory, "ItemContainer") then return end
    local result
    local items = CLO_Funcs.GetAllItemOfTypeInInventory(_inventory, _itemType)
    for i = 1, #items do
        local item = items:get(i)
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
function CLO_Funcs.GetAllFullDrainableItemOfTypeInInventory(_inventory, _itemType)
    if not instanceof(_inventory, "ItemContainer") then return {} end
    local result = {}
    local items = CLO_Funcs.GetAllItemOfTypeInInventory(_inventory, _itemType)
    for i = 1, #items do
        local item = items:get(i)
        if item:IsDrainable() and item:getUsedDelta() >= 1 then
            table.insert(result, item)
        end
    end
    return result
end

-------------------------------------------------------------------------
--- # DISPENSER
-------------------------------------------------------------------------

---GetDispenserType
---@param _isoObject IsoObject
---@return table
function CLO_Funcs.GetDispenserType(_isoObject)
    if not instanceof(_isoObject, "IsoObject") then return end
    local customName = CLO_Funcs.GetObjectCustomName(_isoObject)
    if customName == CLO_DispenserTypes.DefaultDispenser.CustomName then
        return CLO_DispenserTypes.DefaultDispenser
    elseif customName == CLO_DispenserTypes.WaterDispenser.CustomName then
        return CLO_DispenserTypes.WaterDispenser
    elseif customName == CLO_DispenserTypes.FuelDispenser.CustomName then
        return CLO_DispenserTypes.FuelDispenser
    elseif customName == CLO_DispenserTypes.EmptyDispenser.CustomName then
        return CLO_DispenserTypes.EmptyDispenser
    elseif customName == CLO_DispenserTypes.EmptyBottleDispenser.CustomName then
        return CLO_DispenserTypes.EmptyBottleDispenser
    end
end

---GetDispenserOnSquare
---@param _square table
---@return IsoObject
function CLO_Funcs.GetDispenserOnSquare(_square)
    if not instanceof(_square, "IsoGridSquare") then return end
    local result
    local objects = _square:getObjects()
    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        if object and CLO_Funcs.GetDispenserType(object) then
            result = object
            break
        end
    end
    return result
end

---CreateDispenserOnSquare
---@param _square IsoGridSquare
---@param _dispenserType table
---@param _amount number
---@return IsoObject
function CLO_Funcs.CreateDispenserOnSquare(_square, _dispenserType, _facing, _amount)
    if not instanceof(_square, "IsoGridSquare") then return end

    if not CLO_Funcs.GetDispenserOnSquare(_square) then
        local dispenser = IsoObject.new(_square, _dispenserType[_facing], _dispenserType.CustomName)
        if _dispenserType ~= CLO_DispenserTypes.DefaultDispenser then
            if _dispenserType.type == "water" then
                CLO_Funcs.SetObjectWaterAmount(dispenser, _amount)
                CLO_Funcs.SetObjectWaterMax(dispenser, CLO_ModSettings.DispenserAmountMax)
            elseif _dispenserType.type == "fuel" then
                CLO_Funcs.SetObjectFuelAmount(dispenser, _amount)
                CLO_Funcs.SetObjectFuelMax(dispenser, CLO_ModSettings.DispenserAmountMax)
            end
        end
        _square:AddTileObject(dispenser)
        return dispenser
    end
end

---RotateDispenserOnSquare
---@param _square IsoGridSquare
---@param _dispenserType table
---@param _facing string
---@return IsoObject
function CLO_Funcs.RotateDispenserOnSquare(_square, _dispenserType, _facing)
    if not instanceof(_square, "IsoGridSquare") then return end

    local currentDispenser = CLO_Funcs.GetDispenserOnSquare(_square)
    local currentType = CLO_Funcs.GetDispenserType(currentDispenser)
    if currentDispenser and currentType then
        local currentAmount = 0
        if currentType == CLO_DispenserTypes.DefaultDispenser or currentType.type == "water" then
            currentAmount = CLO_Funcs.GetObjectWaterAmount(currentDispenser)
        elseif currentType.type == "fuel" then
            currentAmount = CLO_Funcs.GetObjectFuelAmount(currentDispenser)
        end
        CLO_Funcs.DeleteObject(currentDispenser)
        local newDispenser = CLO_Funcs.CreateDispenserOnSquare(_square, _dispenserType, _facing, currentAmount)
        return newDispenser
    end
end

---TransformDispenserOnSquare
---@param _square IsoGridSquare
---@param _dispenserType table
---@param _liquidAmount number
---@param _tainted boolean
---@return IsoObject
function CLO_Funcs.TransformDispenserOnSquare(_square, _dispenserType, _liquidAmount, _tainted)
    if not instanceof(_square, "IsoGridSquare") then return end

    local currentDispenser = CLO_Funcs.GetDispenserOnSquare(_square)
    local currentType = CLO_Funcs.GetDispenserType(currentDispenser)
    if currentDispenser and currentType then
        local facing = CLO_Funcs.GetObjectFacing(currentDispenser)
        local currentAmount = 0
        if currentType == CLO_DispenserTypes.DefaultDispenser or currentType.type == "water" then
            currentAmount = CLO_Funcs.GetObjectWaterAmount(currentDispenser)
        elseif currentType.type == "fuel" then
            currentAmount = CLO_Funcs.GetObjectFuelAmount(currentDispenser)
        end
        if _liquidAmount and _liquidAmount > 0 then
            currentAmount = _liquidAmount
        end
        CLO_Funcs.DeleteObject(currentDispenser)
        local newDispenser = CLO_Funcs.CreateDispenserOnSquare(_square, _dispenserType, facing, currentAmount)
        CLO_Funcs.SetObjectWaterTainted(newDispenser, _tainted)
        return newDispenser
    end
end

-------------------------------------------------------------------------
--- # CONTEXT
-------------------------------------------------------------------------

---CreateSubMenu
---@param _context ISContextMenu
---@param _title string
function CLO_Funcs.CreateSubMenu(_context, _title)
    local option = _context:addOption(_title)
    local subContext = ISContextMenu:getNew(_context)
    _context:addSubMenu(option, subContext)
    return subContext
end

---CreateOptionTooltip
---@param _option ISContextMenu
---@param _description string
---@param _title string
---@return ISToolTip
function CLO_Funcs.CreateOptionTooltip(_option, _description, _title)
    _option.toolTip = ISToolTip:new()
    if _title then _option.toolTip.name = _title end
    _option.toolTip.description = _description
    return _option.toolTip
end

---ConvertInventoryItemsToArray
---@return table
function CLO_Funcs.ConvertInventoryItemsToArray(_items)
    local result = {}
    for _, v in ipairs(_items) do
        local item = v
        if not instanceof(v, "InventoryItem") then
            item = v.items[1]
        end
        table.insert(result, item)
    end
    return result
end

-------------------------------------------------------------------------

CLO_Math = {
    Round = CLO_Funcs.Round,
    Hypo = CLO_Funcs.Hypo,
    Distance = CLO_Funcs.Distance,
}

CLO_World = {
    DistanceBetweenSquares = CLO_Funcs.DistanceBetweenSquares,
    GetAvailableFuelOnSquare = CLO_Funcs.GetAvailableFuelOnSquare,
    SetAvailableFuelOnSquare = CLO_Funcs.SetAvailableFuelOnSquare,
    GetFirstObjectWithCustomNameOnSquare = CLO_Funcs.GetFirstObjectWithCustomNameOnSquare,
    GetAllObjectsWithCustomNameOnSquare = CLO_Funcs.GetAllObjectsWithCustomNameOnSquare,
}

CLO_Object = {
    CreateObject = CLO_Funcs.CreateObject,
    DeleteObject = CLO_Funcs.DeleteObject,
    GetObjectCustomName = CLO_Funcs.GetObjectCustomName,
    GetObjectFacing = CLO_Funcs.GetObjectFacing,
    GetObjectWaterTainted = CLO_Funcs.GetObjectWaterTainted,
    SetObjectWaterTainted = CLO_Funcs.SetObjectWaterTainted,
    GetObjectWaterAmount = CLO_Funcs.GetObjectWaterAmount,
    SetObjectWaterAmount = CLO_Funcs.SetObjectWaterAmount,
    GetObjectWaterMax = CLO_Funcs.GetObjectWaterMax,
    SetObjectWaterMax = CLO_Funcs.SetObjectWaterMax,
    GetObjectFuelAmount = CLO_Funcs.GetObjectFuelAmount,
    SetObjectFuelAmount = CLO_Funcs.SetObjectFuelAmount,
    GetObjectFuelMax = CLO_Funcs.GetObjectFuelMax,
    SetObjectFuelMax = CLO_Funcs.SetObjectFuelMax,
}

CLO_Inventory = {
    GetDrainableItemContent = CLO_Funcs.GetDrainableItemContent,
    GetDrainableItemContentString = CLO_Funcs.GetDrainableItemContentString,
    FormatWaterAmount = CLO_Funcs.FormatWaterAmount,
    RemoveItems = CLO_Funcs.RemoveItems,
    GetAllFillableWaterItemInInventory = CLO_Funcs.GetAllFillableWaterItemInInventory,
    GetFirstItemOfTypeInInventory = CLO_Funcs.GetFirstItemOfTypeInInventory,
    GetAllItemOfTypeInInventory = CLO_Funcs.GetAllItemOfTypeInInventory,
    GetAllItemOfMultipleTypesInInventory = CLO_Funcs.GetAllItemOfMultipleTypesInInventory,
    GetFirstEmptyDrainableItemOfTypeInInventory = CLO_Funcs.GetFirstEmptyDrainableItemOfTypeInInventory,
    GetAllEmptyDrainableItemOfTypeInInventory = CLO_Funcs.GetAllEmptyDrainableItemOfTypeInInventory,
    GetAllNotFullDrainableItemOfTypeInInventory = CLO_Funcs.GetAllNotFullDrainableItemOfTypeInInventory,
    GetFirstNotFullDrainableItemOfTypeInInventory = CLO_Funcs.GetFirstNotFullDrainableItemOfTypeInInventory,
    GetFirstNotEmptyDrainableItemOfTypeInInventory = CLO_Funcs.GetFirstNotEmptyDrainableItemOfTypeInInventory,
    GetAllNotEmptyDrainableItemOfTypeInInventory = CLO_Funcs.GetAllNotEmptyDrainableItemOfTypeInInventory,
    GetFirstFullDrainableItemOfTypeInInventory = CLO_Funcs.GetFirstFullDrainableItemOfTypeInInventory,
    GetAllFullDrainableItemOfTypeInInventory = CLO_Funcs.GetAllFullDrainableItemOfTypeInInventory,
}

CLO_Dispenser = {
    GetDispenserOnSquare = CLO_Funcs.GetDispenserOnSquare,
    GetDispenserType = CLO_Funcs.GetDispenserType,
    CreateDispenserOnSquare = CLO_Funcs.CreateDispenserOnSquare,
    RotateDispenserOnSquare = CLO_Funcs.RotateDispenserOnSquare,
    TransformDispenserOnSquare = CLO_Funcs.TransformDispenserOnSquare,
}

CLO_Context = {
    CreateSubMenu = CLO_Funcs.CreateSubMenu,
    CreateOptionTooltip = CLO_Funcs.CreateOptionTooltip,
    ConvertInventoryItemsToArray = CLO_Funcs.ConvertInventoryItemsToArray,
}
