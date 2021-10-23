CLO_Contexts = CLO_Contexts or {}

---------------------------------------------------------------------------------------
---Do

---doPlaceBottleOnDispenser
---@param _dispenserObject IsoObject
---@param _bigBottleItem InventoryItem
local function doPlaceBottleOnDispenser(_dispenserObject, _bigBottleItem)
    if instanceof(_dispenserObject, "IsoObject") and instanceof(_bigBottleItem, "InventoryItem") then

        ---@type IsoPlayer
        local playerObject = getPlayer()

        ---@type IsoGridSquare
        local square = _dispenserObject:getSquare()

        if (luautils.walkAdj(playerObject, square, false)) then

            if CLO_Dispenser.GetDispenserType(_dispenserObject) == CLO_DispenserTypes.EmptyDispenser then
                if playerObject:getPrimaryHandItem() ~= _bigBottleItem and playerObject:getSecondaryHandItem() ~= _bigBottleItem then
                    ISInventoryPaneContextMenu.equipWeapon(_bigBottleItem, false, false, playerObject:getPlayerNum())
                end

                ISTimedActionQueue.add(CLO_Actions.ISPlaceDispenserBottle:new(playerObject, _dispenserObject, _bigBottleItem, 200))
            end
        end
    end
end

---doTakeBottleFromDispenser
---@param _dispenserObject IsoObject
local function doTakeBottleFromDispenser(_dispenserObject)
    if instanceof(_dispenserObject, "IsoObject") then

        ---@type IsoPlayer
        local playerObject = getPlayer()

        ---@type IsoGridSquare
        local square = _dispenserObject:getSquare()

        if (luautils.walkAdj(playerObject, square, false)) then
            if CLO_Dispenser.GetDispenserType(_dispenserObject) ~= CLO_DispenserTypes.EmptyDispenser then
                ISTimedActionQueue.add(CLO_Actions.ISTakeDispenserBottle:new(playerObject, _dispenserObject, 200))
            end
        end
    end
end

---doDrinkWaterFromDispenser
---@param _dispenserObject IsoObject
local function doDrinkWaterFromDispenser(_dispenserObject)
    if instanceof(_dispenserObject, "IsoObject") then

        ---@type IsoPlayer
        local playerObject = getPlayer()

        ---@type IsoGridSquare
        local square = _dispenserObject:getSquare()

        if (luautils.walkAdj(playerObject, square, true)) then

            ISTimedActionQueue.add(CLO_Actions.ISDrinkFromDispenser:new(playerObject, _dispenserObject, 120))

        end

    end
end

---doPlaceBottleOnDispenser
---@param _dispenserObject IsoObject
---@param _drainableItem InventoryItem
local function doFillWaterFromDispenser(_dispenserObject, _drainableItems, _drainableItem)
    if instanceof(_dispenserObject, "IsoObject") then

        ---@type IsoPlayer
        local playerObject = getPlayer()

        ---@type ItemContainer
        local inventory = playerObject:getInventory()

        ---@type IsoGridSquare
        local square = _dispenserObject:getSquare()

        local waterAvailable = CLO_Object.GetObjectWaterAmount(_dispenserObject)

        if not _drainableItems then
            _drainableItems = {}
            table.insert(_drainableItems, _drainableItem)
        end

        for _,item in ipairs(_drainableItems) do
            if item:canStoreWater() and not item:isWaterSource() then
                if (luautils.walkAdj(playerObject, square, true)) then
                    waterAvailable = CLO_Object.GetObjectWaterAmount(_dispenserObject)
                    if waterAvailable <= 0 then return end
                    -- we create the item which contain our water
                    local newItemType = item:getReplaceOnUseOn()
                    newItemType = string.sub(newItemType,13)
                    newItemType = item:getModule() .. "." .. newItemType;
                    local newItem = InventoryItemFactory.CreateItem(newItemType,0)
                    newItem:setCondition(item:getCondition())
                    newItem:setFavorite(item:isFavorite())
                    local returnToContainer = item:getContainer():isInCharacterInventory(playerObject) and item:getContainer()
                    ISWorldObjectContextMenu.transferIfNeeded(playerObject, item)
                    local destCapacity = 1 / newItem:getUseDelta()
                    local waterConsumed = math.min(math.floor(destCapacity + 0.001), waterAvailable)
                    ISTimedActionQueue.add(CLO_Actions.ISTakeWaterActionFromDispenser:new(playerObject, newItem, waterConsumed, _dispenserObject, waterConsumed * 10, item))
                    if returnToContainer and (returnToContainer ~= inventory) then
                        ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObject, item, inventory, returnToContainer))
                    end
                end
            elseif item:canStoreWater() and item:isWaterSource() then
                if (luautils.walkAdj(playerObject, square, true)) then
                    waterAvailable = CLO_Object.GetObjectWaterAmount(_dispenserObject)
                    if waterAvailable <= 0 then return end
                    local returnToContainer = item:getContainer():isInCharacterInventory(playerObject) and item:getContainer()
                    if playerObject:getPrimaryHandItem() ~= item and playerObject:getSecondaryHandItem() ~= item then
                    end
                    ISWorldObjectContextMenu.transferIfNeeded(playerObject, item)
                    local destCapacity = (1 - item:getUsedDelta()) / item:getUseDelta()
                    local waterConsumed = math.min(math.floor(destCapacity + 0.001), waterAvailable)
                    ISTimedActionQueue.add(CLO_Actions.ISTakeWaterActionFromDispenser:new(playerObject, item, waterConsumed, _dispenserObject, waterConsumed * 10, nil))
                    if returnToContainer then
                        ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObject, item, inventory, returnToContainer))
                    end
                end
            end
        end
    end
end

---doPlaceBottleOnDispenser
---@param _dispenserObject IsoObject
---@param _drainableItem InventoryItem
local function doFillFuelFromDispenser(_dispenserObject, _drainableItem)
    if instanceof(_dispenserObject, "IsoObject") and instanceof(_drainableItem, "InventoryItem") then

        ---@type IsoPlayer
        local playerObject = getPlayer()

        ---@type IsoGridSquare
        local square = _dispenserObject:getSquare()

        -- Prefer an equipped EmptyPetrolCan/PetrolCan, then the fullest PetrolCan, then any EmptyPetrolCan.
        if _drainableItem and luautils.walkAdj(playerObject, square, false) then
            ISInventoryPaneContextMenu.equipWeapon(_drainableItem, false, false, playerObject:getPlayerNum())
            ISTimedActionQueue.add(CLO_Actions.ISTakeFuelFromDispenser:new(playerObject, _dispenserObject, _drainableItem, 100))
        end
    end
end

---doWashYourselfFromDispenser
---@param _playerObject IsoPlayer
---@param _dispenserObject IsoObject
---@param _soapList table
local function doWashYourselfFromDispenser(_playerObject, _dispenserObject, _soapList)
    if instanceof(_playerObject, "IsoPlayer") and instanceof(_dispenserObject, "IsoObject") then

        ---@type IsoGridSquare
        local square = _dispenserObject:getSquare()

        if (luautils.walkAdj(_playerObject, square, true)) then

            ISTimedActionQueue.add(CLO_Actions.ISWashYourselfFromDispenser:new(_playerObject, _dispenserObject, _soapList))

        end

    end
end

---doWashClothing
---@param _playerObject IsoPlayer
---@param _dispenserObject IsoObject
---@param soapList table
---@param washList table
local function doWashClothing(_playerObject, _dispenserObject, soapList, washList, singleClothing, noSoap)
    if instanceof(_playerObject, "IsoPlayer") and instanceof(_dispenserObject, "IsoObject") then

        ---@type IsoGridSquare
        local square = _dispenserObject:getSquare()

        if (luautils.walkAdj(_playerObject, square, true)) then

            if not washList then
                washList = {};
                table.insert(washList, singleClothing);
            end

            for _,item in ipairs(washList) do
                local bloodAmount = 0
                local dirtAmount = 0
                if instanceof(item, "Clothing") then
                    if BloodClothingType.getCoveredParts(item:getBloodClothingType()) then
                        local coveredParts = BloodClothingType.getCoveredParts(item:getBloodClothingType())
                        for j=0, coveredParts:size()-1 do
                            local thisPart = coveredParts:get(j)
                            bloodAmount = bloodAmount + item:getBlood(thisPart)
                        end
                    end
                    if item:getDirtyness() > 0 then
                        dirtAmount = dirtAmount + item:getDirtyness()
                    end
                else
                    bloodAmount = bloodAmount + item:getBloodLevel()
                end
                ISTimedActionQueue.add(CLO_Actions.ISWashClothingFromDispenser:new(_playerObject, _dispenserObject, soapList, item, bloodAmount, dirtAmount, noSoap))
            end
        end
    end
end

---------------------------------------------------------------------------------------
---Menus

---menu_place_bottle
---@param _playerNum number
---@param _dispenserObject IsoObject
---@param _context ISContextMenu
local function menu_place_bottle(_playerNum, _dispenserObject, _context)
    local playerObj = getSpecificPlayer(_playerNum)
    local playerInv = playerObj:getInventory()

    local items = CLO_Inventory.GetAllItemOfMultipleTypesInInventory(playerInv, {"Coco_WaterGallonEmpty", "Coco_WaterGallonFull", "Coco_WaterGallonPetrol"})
    if #items > 0 then
        local placeBottleOnDispenserSubMenu = CLO_Context.CreateSubMenu(_context, getText("ContextMenu_PlaceBottle"))
        for i = 1, #items do
            local item = items[i]
            local dispenserNewType
            local waterTainted = item:isTaintedWater()
            local toolTipPrefix = ""
            if item:getType() == "Coco_WaterGallonFull" then
                toolTipPrefix = getText("ContextMenu_WaterName")
                dispenserNewType = CLO_DispenserTypes.WaterDispenser
            elseif item:getType() == "Coco_WaterGallonPetrol" then
                toolTipPrefix = getText("ContextMenu_FuelName")
                dispenserNewType = CLO_DispenserTypes.FuelDispenser
            else
                dispenserNewType = CLO_DispenserTypes.EmptyBottleDispenser
            end

            local option = placeBottleOnDispenserSubMenu:addOption(item:getName(), _dispenserObject, doPlaceBottleOnDispenser, item)
            local tooltip = CLO_Context.CreateOptionTooltip(option, "")
            if CLO_Inventory.GetDrainableItemContent(item) > 0 then
                tooltip.description = toolTipPrefix .. ": " .. CLO_Inventory.GetDrainableItemContentString(item)
            else
                tooltip.description = getText("ContextMenu_IsEmpty")
            end
            if waterTainted then
                tooltip.description = tooltip.description .. " <BR> <RGB:1,0.5,0.5> " .. getText("Tooltip_item_TaintedWater")
            end
        end
    end
end

---menu_place_bottle
---@param _playerNum number
---@param _dispenserObject IsoObject
---@param _context ISContextMenu
local function menu_wash(_playerNum, _dispenserObject, _context)
    local playerObj = getSpecificPlayer(_playerNum)
    local playerInv = playerObj:getInventory()
    local washYourself = false
    local washEquipment = false
    local washList = {}
    local soapList = {}
    local noSoap = true

    washYourself = ISWashYourself.GetRequiredWater(playerObj) > 0

    local barList = playerInv:getItemsFromType("Soap2", true)
    for i=0, barList:size() - 1 do
        local item = barList:get(i)
        table.insert(soapList, item)
    end

    local bottleList = playerInv:getItemsFromType("CleaningLiquid2", true)
    for i=0, bottleList:size() - 1 do
        local item = bottleList:get(i)
        table.insert(soapList, item)
    end

    local clothingInventory = playerInv:getItemsFromCategory("Clothing")
    for i=0, clothingInventory:size() - 1 do
        local item = clothingInventory:get(i)
        if not item:isHidden() and (item:hasBlood() or item:hasDirt()) then
            if washEquipment == false then
                washEquipment = true
            end
            table.insert(washList, item)
        end
    end


    local weaponInventory = playerInv:getItemsFromCategory("Weapon")
    for i=0, weaponInventory:size() - 1 do
        local item = weaponInventory:get(i)
        if item:hasBlood() then
            if washEquipment == false then
                washEquipment = true
            end
            table.insert(washList, item)
        end
    end

    clothingInventory = playerInv:getItemsFromCategory("Container")
    for i=0, clothingInventory:size() - 1 do
        local item = clothingInventory:get(i)
        if not item:isHidden() and (item:hasBlood() or item:hasDirt()) then
            washEquipment = true
            table.insert(washList, item)
        end
    end
    -- Sort clothes from least-bloody to most-bloody.
    table.sort(washList, ISWorldObjectContextMenu.compareClothingBlood)

    if washYourself or washEquipment then
        local mainOption = _context:addOption(getText("ContextMenu_Wash"), nil, nil);
        local mainSubMenu = ISContextMenu:getNew(_context)
        _context:addSubMenu(mainOption, mainSubMenu)

        local soapRemaining = CLO_Actions.ISWashClothingFromDispenser.GetSoapRemaining(soapList)
        local waterRemaining = CLO_Object.GetObjectWaterAmount(_dispenserObject)

        if washYourself then
            local soapRequired = CLO_Actions.ISWashYourselfFromDispenser.GetRequiredSoap(playerObj)
            local waterRequired = CLO_Actions.ISWashYourselfFromDispenser.GetRequiredWater(playerObj)
            local option = mainSubMenu:addOption(getText("ContextMenu_Yourself"), playerObj, doWashYourselfFromDispenser, _dispenserObject, soapList)
            local tooltip = CLO_Context.CreateOptionTooltip(option, "")
            tooltip.description = getText("ContextMenu_WaterSource")  .. ": " .. CLO_Context.GetMoveableDisplayName(_dispenserObject) .. " <LINE> "
            if soapRemaining < soapRequired then
                tooltip.description = tooltip.description .. getText("IGUI_Washing_WithoutSoap") .. " <LINE> "
            else
                tooltip.description = tooltip.description .. getText("IGUI_Washing_Soap") .. ": " .. tostring(math.min(soapRemaining, soapRequired)) .. " / " .. tostring(soapRequired) .. " <LINE> "
            end
            tooltip.description = tooltip.description .. getText("ContextMenu_WaterName") .. ": " .. tostring(math.min(waterRemaining, waterRequired)) .. " / " .. tostring(waterRequired)
            option.toolTip = tooltip
            if waterRemaining < 1 then
                option.notAvailable = true
            end
        end

        if washEquipment then
            if #washList > 1 then
                local soapRequired = 0
                local waterRequired = 0
                for _,item in ipairs(washList) do
                    soapRequired = soapRequired + CLO_Actions.ISWashClothingFromDispenser.GetRequiredSoap(item)
                    waterRequired = waterRequired + CLO_Actions.ISWashClothingFromDispenser.GetRequiredWater(item)
                end
                local tooltip = ISToolTip:new()
                tooltip.description = getText("ContextMenu_WaterSource")  .. ": " .. CLO_Context.GetMoveableDisplayName(_dispenserObject) .. " <LINE> "
                if (soapRemaining < soapRequired) then
                    tooltip.description = tooltip.description .. getText("IGUI_Washing_WithoutSoap") .. " <LINE> "
                    noSoap = true
                else
                    tooltip.description = tooltip.description .. getText("IGUI_Washing_Soap") .. ": " .. tostring(math.min(soapRemaining, soapRequired)) .. " / " .. tostring(soapRequired) .. " <LINE> "
                    noSoap = false
                end
                tooltip.description = tooltip.description .. getText("ContextMenu_WaterName") .. ": " .. tostring(math.min(waterRemaining, waterRequired)) .. " / " .. tostring(waterRequired)
                local option = mainSubMenu:addOption(getText("ContextMenu_WashAllClothing"), playerObj, doWashClothing, _dispenserObject, soapList, washList, nil,  noSoap)
                option.toolTip = tooltip
                if (waterRemaining < waterRequired) then
                    option.notAvailable = true
                end
            end
            for _,item in ipairs(washList) do
                local soapRequired = CLO_Actions.ISWashClothingFromDispenser.GetRequiredSoap(item)
                local waterRequired = CLO_Actions.ISWashClothingFromDispenser.GetRequiredWater(item)
                local tooltip = ISToolTip:new()
                tooltip.description = getText("ContextMenu_WaterSource")  .. ": " .. CLO_Context.GetMoveableDisplayName(_dispenserObject) .. " <LINE> "
                if (soapRemaining < soapRequired) then
                    tooltip.description = tooltip.description .. getText("IGUI_Washing_WithoutSoap") .. " <LINE> "
                    noSoap = true
                else
                    tooltip.description = tooltip.description .. getText("IGUI_Washing_Soap") .. ": " .. tostring(math.min(soapRemaining, soapRequired)) .. " / " .. tostring(soapRequired) .. " <LINE> "
                    noSoap = false
                end
                tooltip.description = tooltip.description .. getText("ContextMenu_WaterName") .. ": " .. tostring(math.min(waterRemaining, waterRequired)) .. " / " .. tostring(waterRequired)
                local option = mainSubMenu:addOption(getText("ContextMenu_WashClothing", item:getDisplayName()), playerObj, doWashClothing, _dispenserObject, soapList, nil, item, noSoap);
                option.toolTip = tooltip
                if (waterRemaining < waterRequired) then
                    option.notAvailable = true
                end
            end
        end
    end
end

---menu_place_bottle
---@param _playerNum number
---@param _dispenserObject IsoObject
---@param _context ISContextMenu
local function menu_fill_water(_playerNum, _dispenserObject, _context)
    local playerObj = getSpecificPlayer(_playerNum)
    local playerInv = playerObj:getInventory()

    local waterTainted = CLO_Object.GetObjectWaterTainted(_dispenserObject)

    local fillableBottles = CLO_Inventory.GetAllFillableWaterItemInInventory(playerInv)
    if #fillableBottles > 0 then
        local fillSubMenu = CLO_Context.CreateSubMenu(_context, getText("ContextMenu_Fill"))
        if #fillableBottles > 1 then
            fillSubMenu:addOption(getText("ContextMenu_FillAll"), _dispenserObject, doFillWaterFromDispenser, fillableBottles, nil)
        end
        for i = 1, #fillableBottles do
            local item = fillableBottles[i]
            local option = fillSubMenu:addOption(item:getName(), _dispenserObject, doFillWaterFromDispenser, nil, item)
            local tooltip = CLO_Context.CreateOptionTooltip(option, "")
            tooltip.description = getText("ContextMenu_WaterSource")  .. ": " .. CLO_Context.GetMoveableDisplayName(_dispenserObject) .. " <LINE> "
            if CLO_Inventory.GetDrainableItemContent(item) > 0 then
                tooltip.description = tooltip.description .. getText("ContextMenu_WaterName") .. ": " .. CLO_Inventory.GetDrainableItemContentString(item)
            else
                tooltip.description = tooltip.description .. getText("ContextMenu_IsEmpty")
            end
            if waterTainted then
                tooltip.description = tooltip.description .. " <BR> <RGB:1,0.5,0.5> " .. getText("Tooltip_item_TaintedWater")
            end
        end
    end
end

---menu_drink
---@param _playerNum number
---@param _dispenserObject IsoObject
---@param _context ISContextMenu
local function menu_drink(_playerNum, _dispenserObject, _context)
    local playerObj = getSpecificPlayer(_playerNum)
    local waterAmount = CLO_Object.GetObjectWaterAmount(_dispenserObject)
    local waterMax = CLO_Object.GetObjectWaterMax(_dispenserObject)
    local waterTainted = CLO_Object.GetObjectWaterTainted(_dispenserObject)

    local thirst = playerObj:getStats():getThirst()
    if (thirst >= 0.01) then
        local drinkOption = _context:addOption(getText("ContextMenu_Drink"), _dispenserObject, doDrinkWaterFromDispenser)
        local drinkTooltip = CLO_Context.CreateOptionTooltip(drinkOption, "")
        local units = math.min(math.ceil(thirst / 0.1), 10)
        units = math.min(units, waterAmount)
        local tx1 = getTextManager():MeasureStringX(drinkTooltip.font, getText("Tooltip_food_Thirst") .. ":") + 20
        local tx2 = getTextManager():MeasureStringX(drinkTooltip.font, getText("ContextMenu_WaterName") .. ":") + 20
        local tx = math.max(tx1, tx2)
        drinkTooltip.description = getText("ContextMenu_WaterSource")  .. ": " .. CLO_Context.GetMoveableDisplayName(_dispenserObject) .. " <LINE> "
        drinkTooltip.description = drinkTooltip.description .. string.format("%s: <SETX:%d> -%d / %d <LINE> %s", getText("Tooltip_food_Thirst"), tx, math.min(units * 10, thirst * 100), thirst * 100, CLO_Inventory.FormatWaterAmount(tx, waterAmount, waterMax))
        if waterTainted then
            drinkTooltip.description = drinkTooltip.description .. " <BR> <RGB:1,0.5,0.5> " .. getText("Tooltip_item_TaintedWater")
        end
    end
end

---menu_fill_fuel
---@param _playerNum number
---@param _dispenserObject IsoObject
---@param _context ISContextMenu
local function menu_fill_fuel(_playerNum, _dispenserObject, _context)
    local playerObj = getSpecificPlayer(_playerNum)
    local playerInv = playerObj:getInventory()

    local fillableBottles = CLO_Inventory.GetAllNotFullDrainableItemOfTypeInInventory(playerInv, "EmptyPetrolCan", "PetrolCan")
    
    for i = 1, #CLO_ModSettings.CustomFuelItems do
        local fuelItem = CLO_ModSettings.CustomFuelItems[i]
        local fillableBottles2 = CLO_Inventory.GetAllNotFullDrainableItemOfTypeInInventory(playerInv, fuelItem.empty, fuelItem.full)
        for _,v in ipairs(fillableBottles2) do
            table.insert(fillableBottles, v)
        end
    end

    if #fillableBottles > 0 then
        local fillSubMenu = CLO_Context.CreateSubMenu(_context, getText("ContextMenu_Fill"))
        for i = 1, #fillableBottles do
            local item = fillableBottles[i]
            local option = fillSubMenu:addOption(item:getName(), _dispenserObject, doFillFuelFromDispenser, item)
            local tooltip = CLO_Context.CreateOptionTooltip(option, "")
            tooltip.description = getText("ContextMenu_FuelSource")  .. ": " .. CLO_Context.GetMoveableDisplayName(_dispenserObject) .. " <LINE> "
            if CLO_Inventory.GetDrainableItemContent(item) > 0 then
                tooltip.description = tooltip.description .. getText("ContextMenu_FuelName") .. ": " .. CLO_Inventory.GetDrainableItemContentString(item)
            else
                tooltip.description = tooltip.description .. getText("ContextMenu_IsEmpty")
            end
        end
    end
end

---------------------------------------------------------------------------------------

---Context_InteractWithDispenser
---@param _playerNum number
---@param _context ISContextMenu
local function Context_InteractWithDispenser(_playerNum, _context, _, test)
    if test then return end

    ---@type IsoGridSquare
    local square = clickedSquare

    if square then

        ---@type IsoObject
        local dispenser = CLO_Dispenser.GetDispenserOnSquare(square)

        ---@type table
        local dispenserType = CLO_Dispenser.GetDispenserType(dispenser)

        if dispenser then
            storeWater = false

            ----- Convert default dispenser
            if dispenserType == CLO_DispenserTypes.DefaultDispenser then
                waterDispenser = nil

                dispenser = CLO_Dispenser.TransformDispenserOnSquare(square, CLO_DispenserTypes.WaterDispenser)
                dispenserType = CLO_Dispenser.GetDispenserType(dispenser)
            end

            local checkContentOption = _context:addOption("Check Content")

            --- No Bottle
            if dispenserType.CustomName == CLO_DispenserTypes.EmptyDispenser.CustomName then

                checkContentOption.name = getText("ContextMenu_EmptyDispenser")
                CLO_Context.CreateOptionTooltip(checkContentOption, getText("ContextMenu_NoBottle"))

                menu_place_bottle(_playerNum, dispenser, _context)

            else

                _context:addOption(getText("ContextMenu_TakeBottle"), dispenser, doTakeBottleFromDispenser)

                --- Empty Bottle
                if dispenserType.CustomName == CLO_DispenserTypes.EmptyBottleDispenser.CustomName then
                    checkContentOption.name = getText("ContextMenu_EmptyBottleDispenser")
                    CLO_Context.CreateOptionTooltip(checkContentOption, getText("ContextMenu_EmptyBottle"))

                --- Water Bottle
                elseif dispenserType.CustomName == CLO_DispenserTypes.WaterDispenser.CustomName then
                    checkContentOption.name = getText("ContextMenu_WaterDispenser")
                    local toolTip = CLO_Context.CreateOptionTooltip(checkContentOption, getText("ContextMenu_WaterName") .. ": ")
                    local waterTainted = CLO_Object.GetObjectWaterTainted(dispenser)
                    local waterAmount = CLO_Object.GetObjectWaterAmount(dispenser)
                    local waterMax = CLO_Object.GetObjectWaterMax(dispenser)
                    toolTip.description = toolTip.description .. CLO_Math.Round(waterAmount) .. "/" .. CLO_Math.Round(waterMax)
                    if waterTainted then
                        toolTip.description = toolTip.description .. " <BR> <RGB:1,0.5,0.5> " .. getText("Tooltip_item_TaintedWater")
                    end

                    if waterAmount > 0 then
                        --- Wash
                        menu_wash(_playerNum, dispenser, _context)

                        --- Fill
                        menu_fill_water(_playerNum, dispenser, _context)

                        --- Drink
                        menu_drink(_playerNum, dispenser, _context)
                    end

                --- Fuel Bottle
                elseif dispenserType.CustomName == CLO_DispenserTypes.FuelDispenser.CustomName then
                    checkContentOption.name = getText("ContextMenu_FuelDispenser")
                    local toolTip = CLO_Context.CreateOptionTooltip(checkContentOption, getText("ContextMenu_FuelName") .. ": ")
                    local fuelAmount = CLO_Object.GetObjectFuelAmount(dispenser)
                    local fuelMax = CLO_Object.GetObjectFuelMax(dispenser)
                    toolTip.description = toolTip.description .. CLO_Math.Round(fuelAmount) .. "/" .. CLO_Math.Round(fuelMax)

                    if fuelAmount > 0 then
                        --- Fill
                        menu_fill_fuel(_playerNum, dispenser, _context)
                    end
                end

            end

        end

    end

end

CLO_Contexts.Context_InteractWithDispenser = Context_InteractWithDispenser
