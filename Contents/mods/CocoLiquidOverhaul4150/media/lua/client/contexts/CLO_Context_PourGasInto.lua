CLO_Contexts = CLO_Contexts or {}

---doPourInto
---@param playerObj IsoPlayer
---@param itemFrom DrainableComboItem
---@param itemTo DrainableComboItem
local function doPourInto(playerObj, itemFrom, itemTo)

    if playerObj:isPerformingAnAction() then return end

    local inventory = playerObj:getInventory()

    -- transform empty big water bottle
    if itemTo:getType() == "Coco_WaterGallonEmpty" then
        -- transform empty gas can
        inventory:Remove(itemTo)
        itemTo = inventory:AddItem("CocoLiquidOverhaulItems.Coco_WaterGallonPetrol")
        itemTo:setUsedDelta(0)
    elseif itemTo:getType() == "EmptyPetrolCan" then
        inventory:Remove(itemTo)
        itemTo = inventory:AddItem("Base.PetrolCan")
        itemTo:setUsedDelta(0)
    end

    local petrolStorageAvailable = (1 - itemTo:getUsedDelta()) / itemTo:getUseDelta()
    local petrolStorageNeeded = itemFrom:getUsedDelta() / itemFrom:getUseDelta()

    local itemFromEndingDelta = 0
    local itemToEndingDelta

    if petrolStorageAvailable >= petrolStorageNeeded then
        local petrolInA = itemTo:getUsedDelta() / itemTo:getUseDelta()
        local petrolInB = itemFrom:getUsedDelta() / itemFrom:getUseDelta()
        local totalPetrol = petrolInA + petrolInB

        itemToEndingDelta = totalPetrol * itemTo:getUseDelta()
        itemFromEndingDelta = 0
    elseif petrolStorageAvailable < petrolStorageNeeded then
        local petrolInB = itemFrom:getUsedDelta() / itemFrom:getUseDelta()
        local petrolRemainInB = petrolInB - petrolStorageAvailable

        itemFromEndingDelta = petrolRemainInB * itemFrom:getUseDelta()
        itemToEndingDelta = 1
    end

    ISInventoryPaneContextMenu.transferIfNeeded(playerObj, itemFrom)

    -- let's start the timed action
    ISTimedActionQueue.add(CLO_Actions.ISPourInto:new(playerObj, itemFrom, itemTo, itemFromEndingDelta, itemToEndingDelta))

end

---Context_PourGasInto
---@param _playerNum number
---@param _context ISContextMenu
---@param _items table
local function Context_PourGasInto(_playerNum, _context, _items)

    ---@type IsoPlayer
    local playerObject = getSpecificPlayer(_playerNum)

    ---@type ItemContainer
    local inventory = playerObject:getInventory()

    ---@type table
    local items = CLO_Context.ConvertInventoryItemsToArray(_items)

    if #items == 1 then

        local item = items[1]

        if (item:getType() == "PetrolCan" or item:getType() == "Coco_WaterGallonPetrol") and item:getUsedDelta() > 0 then

            local drainables = {}
            local petrolCans = CLO_Inventory.GetAllNotFullDrainableItemOfTypeInInventory(inventory, "EmptyPetrolCan", "PetrolCan")
            local petrolCans2 = CLO_Inventory.GetAllNotFullDrainableItemOfTypeInInventory(inventory, "Coco_WaterGallonEmpty", "Coco_WaterGallonPetrol")
            for _,v in ipairs(petrolCans) do
                if v ~= item then
                    table.insert(drainables, v)
                end
            end
            for _,v in ipairs(petrolCans2) do
                if v ~= item then
                    table.insert(drainables, v)
                end
            end

            if #drainables > 0 then
                local pourSubMenu = CLO_Context.CreateSubMenu(_context, getText("ContextMenu_Pour_into"))
                for i = 1, #drainables do
                    local drainable = drainables[i]
                    local option = pourSubMenu:addOption(drainable:getName(), playerObject, doPourInto, item, drainable)
                    local tooltip = CLO_Context.CreateOptionTooltip(option, "")
                    if CLO_Inventory.GetDrainableItemContent(drainable) > 0 then
                        tooltip.description = getText("ContextMenu_FuelName") .. ": " .. CLO_Inventory.GetDrainableItemContentString(drainable)
                    else
                        tooltip.description = "Empty"
                    end
                end
            end
        end
    end

end

CLO_Contexts.Context_PourGasInto = Context_PourGasInto