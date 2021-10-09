function CLO_Override_ISVehicleMenu_FillPartMenu()
    CLO_Print("Overriding: 'ISVehicleMenu.FillPartMenu'")

    local original_onAddGasoline = ISVehicleMenu.onAddGasoline
    function ISVehiclePartMenu.onAddGasoline(playerObj, part)
        if playerObj:getVehicle() then
            ISVehicleMenu.onExit(playerObj)
        end
        local typeToItem = VehicleUtils.getItems(playerObj:getPlayerNum())
        local item = ISVehiclePartMenu.getGasCanNotEmpty(playerObj, typeToItem)
        if not item then item = ISVehiclePartMenu.getCustomGasCanNotEmpty(playerObj, typeToItem) end
        if item then
            ISVehiclePartMenu.toPlayerInventory(playerObj, item)
            ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))
            ISInventoryPaneContextMenu.equipWeapon(item, true, false, playerObj:getPlayerNum())
            ISTimedActionQueue.add(ISAddGasolineToVehicle:new(playerObj, part, item, 50))
        end
    end

    local original_onTakeGasoline = ISVehicleMenu.onTakeGasoline
    function ISVehiclePartMenu.onTakeGasoline(playerObj, part)
        if playerObj:getVehicle() then
            ISVehicleMenu.onExit(playerObj)
        end
        local typeToItem = VehicleUtils.getItems(playerObj:getPlayerNum())
        local item = ISVehiclePartMenu.getGasCanNotFull(playerObj, typeToItem)
        if not item then item = ISVehiclePartMenu.getCustomGasCanNotFull(playerObj, typeToItem) end
        if item then
            ISVehiclePartMenu.toPlayerInventory(playerObj, item)
            ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))
            ISInventoryPaneContextMenu.equipWeapon(item, false, false, playerObj:getPlayerNum())
            ISTimedActionQueue.add(ISTakeGasolineFromVehicle:new(playerObj, part, item, 50))
        end
    end

    local original_FillPartMenu = ISVehicleMenu.FillPartMenu
    function ISVehicleMenu.FillPartMenu(playerIndex, context, slice, vehicle)
        original_FillPartMenu(playerIndex, context, slice, vehicle)
        local playerObj = getSpecificPlayer(playerIndex);
        local typeToItem = VehicleUtils.getItems(playerIndex)
        for i=1,vehicle:getPartCount() do
            local part = vehicle:getPartByIndex(i-1)
            if not vehicle:isEngineStarted() and part:isContainer() and part:getContainerContentType() == "Gasoline" then
                if ISVehiclePartMenu.getCustomGasCanNotEmpty(playerObj, typeToItem) and part:getContainerContentAmount() < part:getContainerCapacity() then
                    if slice then
                        if not ISVehiclePartMenu.getGasCanNotEmpty(playerObj, typeToItem) then
                            slice:addSlice(getText("ContextMenu_VehicleAddGas"), getTexture("Item_Petrol"), ISVehiclePartMenu.onAddGasoline, playerObj, part)
                        end
                    else
                        local option = context:getOptionFromName(getText("ContextMenu_VehicleAddGas"))
                        if option then context:removeOption(option) end
                        context:addOption(getText("ContextMenu_VehicleAddGas"), playerObj,ISVehiclePartMenu.onAddGasoline, part)
                    end
                end
                if ISVehiclePartMenu.getCustomGasCanNotFull(playerObj, typeToItem) and part:getContainerContentAmount() > 0 then
                    if slice then
                        if not ISVehiclePartMenu.getGasCanNotFull(playerObj, typeToItem) then
                            slice:addSlice(getText("ContextMenu_VehicleSiphonGas"), getTexture("Item_Petrol"), ISVehiclePartMenu.onTakeGasoline, playerObj, part)
                        end
                    else
                        local option = context:getOptionFromName(getText("ContextMenu_VehicleSiphonGas"))
                        if option then context:removeOption(option) end
                        context:addOption(getText("ContextMenu_VehicleSiphonGas"), playerObj, ISVehiclePartMenu.onTakeGasoline, part)
                    end
                end
            end
        end
    end
end