CLO_Contexts = CLO_Contexts or {}

---DoTakeFuelFromPump
---@param playerObject IsoPlayer
---@param square IsoGridSquare
---@param petrolCan InventoryItem
local function DoTakeFuelFromPump(playerObject, square, petrolCan)

    ---@type IsoObject
    local fuelStation = CLO_World.GetFuelStationOnSquare(square)
    if fuelStation then
        if playerObject:isPerformingAnAction() then return end

        if luautils.walkAdj(playerObject, square) then

            if playerObject:getPrimaryHandItem() ~= petrolCan or playerObject:getSecondaryHandItem() ~= petrolCan then
                ISInventoryPaneContextMenu.equipWeapon(petrolCan, false, false, playerObject:getPlayerNum())
            end

            ISTimedActionQueue.add(CLO_Actions.TakeFuel:new(playerObject, fuelStation, petrolCan, 5000))
        end
    end
end

---Context_TakeFuelFromPump
---@param _playerNum number
---@param _context ISContextMenu
local function Context_TakeFuelFromPump(_playerNum, _context, _, test)
    if test then return end

    ---@type IsoPlayer
    local playerObject = getSpecificPlayer(_playerNum)

    ---@type ItemContainer
    local inventory = playerObject:getInventory()

    ---@type IsoGridSquare
    local square = clickedSquare

    -- Check if the square is adjacent to the player
    if square then
        haveFuel = nil

        local availableFuel = CLO_World.GetAvailableFuelOnSquare(square)
        if availableFuel > 0 and ((SandboxVars.AllowExteriorGenerator and square:haveElectricity()) or (SandboxVars.ElecShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier)) then
            local petrolCans = CLO_Inventory.GetAllNotFullDrainableItemOfTypeInInventory(inventory, "EmptyPetrolCan", "PetrolCan")
            for i = 1, #CLO_ModSettings.CustomFuelItems do
                local fuelItem = CLO_ModSettings.CustomFuelItems[i]
                local fuelItems = CLO_Inventory.GetAllNotFullDrainableItemOfTypeInInventory(inventory, fuelItem.empty, fuelItem.full)
                if fuelItems then
                    for _,customItem in ipairs(fuelItems) do
                        table.insert(petrolCans, customItem)
                    end
                end
            end

            --local petrolCans = CLO_Inventory.GetAllNotFullDrainableItemOfTypeInInventory(inventory, "EmptyPetrolCan", "PetrolCan")
            --local petrolCans2 = CLO_Inventory.GetAllNotFullDrainableItemOfTypeInInventory(inventory, "Coco_WaterGallonEmpty", "Coco_WaterGallonPetrol")
            --local petrolCans3 = CLO_Inventory.GetAllNotFullDrainableItemOfTypeInInventory(inventory, "Coco_LargeEmptyPetrolCan", "Coco_LargePetrolCan")
            --
            --for _,v in ipairs(petrolCans2) do
            --    table.insert(petrolCans, v)
            --end
            --for _,v in ipairs(petrolCans3) do
            --    table.insert(petrolCans, v)
            --end

            if #petrolCans > 0 then
                local pourSubMenu = CLO_Context.CreateSubMenu(_context, getText("ContextMenu_TakeGasFromPump"))
                for i = 1, #petrolCans do
                    local drainable = petrolCans[i]
                    local option = pourSubMenu:addOption(drainable:getName(), playerObject, DoTakeFuelFromPump, square, drainable)
                    local tooltip = CLO_Context.CreateOptionTooltip(option, "")
                    if CLO_Inventory.GetDrainableItemContent(drainable) > 0 then
                        tooltip.description = getText("ContextMenu_FuelName") .. ": " .. CLO_Inventory.GetDrainableItemContentString(drainable)
                    else
                        tooltip.description = getText("ContextMenu_IsEmpty")
                    end
                end
            end
        end
    end
end

CLO_Contexts.Context_TakeFuelFromPump = Context_TakeFuelFromPump