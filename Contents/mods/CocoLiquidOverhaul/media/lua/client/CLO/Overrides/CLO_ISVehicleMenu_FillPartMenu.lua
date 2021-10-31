CLO_Print("Overriding: 'ISVehicleMenu.FillPartMenu'")

local function tableContainText(options, text)
    for i, v in ipairs(options) do
        if options[i].text == text then
            return true
        end
    end
end

local ISVehicleMenu_FillPartMenu = ISVehicleMenu.FillPartMenu
function ISVehicleMenu.FillPartMenu(playerIndex, context, slice, vehicle)
    ISVehicleMenu_FillPartMenu(playerIndex, context, slice, vehicle)

    local playerObj = getSpecificPlayer(playerIndex)

    local typeToItem = VehicleUtils.getItems(playerIndex)
    for i=1,vehicle:getPartCount() do
        local part = vehicle:getPartByIndex(i-1)
        if not vehicle:isEngineStarted() and part:isContainer() and (part:getContainerContentType() == "Gasoline" or part:getContainerContentType() == "Gasoline Storage") then
            if ISVehiclePartMenu.getGasCanNotEmpty(playerObj, typeToItem) and part:getContainerContentAmount() < part:getContainerCapacity() then
                if slice then
                    if not tableContainText(slice.slices, getText("ContextMenu_VehicleAddGas")) then
                        slice:addSlice(getText("ContextMenu_VehicleAddGas"), getTexture("media/ui/vehicles/vehicle_add_gas.png"), ISVehiclePartMenu.onAddGasoline, playerObj, part)
                    end
                else
                    if not tableContainText(context.options, getText("ContextMenu_VehicleAddGas")) then
                        context:addOption(getText("ContextMenu_VehicleAddGas"), playerObj,ISVehiclePartMenu.onAddGasoline, part)
                    end
                end
            end
            if ISVehiclePartMenu.getGasCanNotFull(playerObj, typeToItem) and part:getContainerContentAmount() > 0 then
                if slice then
                    if not tableContainText(slice.slices, getText("ContextMenu_VehicleSiphonGas")) then
                        slice:addSlice(getText("ContextMenu_VehicleSiphonGas"), getTexture("media/ui/vehicles/vehicle_siphon_gas.png"), ISVehiclePartMenu.onTakeGasoline, playerObj, part)
                    end
                else
                    if not tableContainText(context.options, getText("ContextMenu_VehicleSiphonGas")) then
                        context:addOption(getText("ContextMenu_VehicleSiphonGas"), playerObj, ISVehiclePartMenu.onTakeGasoline, part)
                    end
                end
            end
            local fuelStation = ISVehiclePartMenu.getNearbyFuelPump(vehicle)
            if fuelStation then
                local square = fuelStation:getSquare();
                if square and ((SandboxVars.AllowExteriorGenerator and square:haveElectricity()) or (SandboxVars.ElecShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier)) then
                    if square and part:getContainerContentAmount() < part:getContainerCapacity() then
                        if slice then
                            if not tableContainText(slice.slices, getText("ContextMenu_VehicleRefuelFromPump")) then
                                slice:addSlice(getText("ContextMenu_VehicleRefuelFromPump"), getTexture("media/ui/vehicles/vehicle_refuel_from_pump.png"), ISVehiclePartMenu.onPumpGasoline, playerObj, part)
                            end
                        else
                            if not tableContainText(context.options, getText("ContextMenu_VehicleRefuelFromPump")) then
                                context:addOption(getText("ContextMenu_VehicleRefuelFromPump"), playerObj, ISVehiclePartMenu.onPumpGasoline, part)
                            end
                        end
                    end
                end
            end
        end
    end

    --error(context)
end