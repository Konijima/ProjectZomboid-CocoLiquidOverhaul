function CLO_Override_ISVehiclePartMenu_getGasCanNotFull()
    CLO_Print("Overriding: 'ISVehiclePartMenu.getGasCanNotFull'")

    function ISVehiclePartMenu.getCustomGasCanNotFull(playerObj, typeToItem)
        local allCustomEmpty = {}
        local allCustomFull = {}
        for i = 1, #CLO_ModSettings.CustomFuelItems do
            local fuelItem = CLO_ModSettings.CustomFuelItems[i]
            if typeToItem[fuelItem.module .. "." .. fuelItem.empty] then
                for _,customItem in ipairs(typeToItem[fuelItem.module .. "." .. fuelItem.empty]) do
                    table.insert(allCustomEmpty, customItem)
                end
            end
            if typeToItem[fuelItem.module .. "." .. fuelItem.full] then
                for _,customItem in ipairs(typeToItem[fuelItem.module .. "." .. fuelItem.full]) do
                    table.insert(allCustomFull, customItem)
                end
            end
        end

        ---Check if already equipped
        local equipped = playerObj:getPrimaryHandItem()

        ---Check if custom already equipped
        local found = nil
        if #allCustomFull > 0 then
            for i=1, #allCustomFull do
                local customItem = allCustomFull[i]
                if equipped and equipped:getType() == customItem:getType() and equipped:getUsedDelta() < 1 then
                    found = equipped
                    break
                end
            end
        end
        if not found and #allCustomEmpty > 0 then
            for i=1, #allCustomEmpty do
                local customItem = allCustomEmpty[i]
                if equipped and equipped:getType() == customItem:getType() then
                    found = equipped
                    break
                end
            end
        end
        if found then return found end

        ---Find custom one in inventory
        if allCustomFull then
            local gasCan = nil
            local usedDelta = -1
            for _,item in ipairs(allCustomFull) do
                if item:getUsedDelta() < 1 and item:getUsedDelta() > usedDelta then
                    gasCan = item
                    usedDelta = gasCan:getUsedDelta()
                end
            end
            if gasCan then return gasCan end
        end

        ---Return first custom found
        if allCustomEmpty then
            return allCustomEmpty[1]
        end

        return nil
    end

    ---store vanilla function
    --local ISVehiclePartMenu_getGasCanNotFull = ISVehiclePartMenu.getGasCanNotFull
    --
    --function ISVehiclePartMenu.getGasCanNotFull(playerObj, typeToItem)
    --    local result = ISVehiclePartMenu_getGasCanNotFull(playerObj, typeToItem) -- run vanilla function first
    --    if result == nil then
    --        return ISVehiclePartMenu.getCustomGasCanNotFull(playerObj, typeToItem)
    --    else
    --        return result
    --    end
    --end
end