CLO_Print("Overriding: 'ISAddGasolineToVehicle:start'")

local ISAddGasolineToVehicle_start = ISAddGasolineToVehicle.start
function ISAddGasolineToVehicle:start()
    local itemType = self.item:getType()

    local customFuelItem = nil
    for i = 1, #CLO_ModSettings.CustomFuelItems do
        local fuelItem = CLO_ModSettings.CustomFuelItems[i]
        if itemType == fuelItem.empty then
            customFuelItem = fuelItem
            break
        end
    end

    if itemType == "EmptyPetrolCan" or customFuelItem then
        local wasPrimary = self.character:getPrimaryHandItem() == self.item
        local wasSecondary = self.character:getSecondaryHandItem() == self.item
        self.character:getInventory():DoRemoveItem(self.item)
        if itemType == "EmptyPetrolCan" then
            self.item = self.character:getInventory():AddItem("Base.PetrolCan")
        elseif customFuelItem and itemType == customFuelItem.empty then
            self.item = self.character:getInventory():AddItem(customFuelItem.module .. "." .. customFuelItem.full)
        end
        self.item:setUsedDelta(0)
        if wasPrimary then
            self.character:setPrimaryHandItem(self.item)
        end
        if wasSecondary then
            self.character:setSecondaryHandItem(self.item)
        end
    end

    local tankCurrent = self.part:getContainerContentAmount()
    local tankMax = self.part:getContainerCapacity()
    local itemCurrent = math.floor(self.item:getUsedDelta() / self.item:getUseDelta() + 0.001)
    local add = tankMax - tankCurrent
    local take = math.min(add, itemCurrent)
    self.itemStart = itemCurrent
    self.itemTarget = math.floor(itemCurrent - take)

    self.action:setTime(take * 50)

    self:setActionAnim("refuelgascan")
    self:setOverrideHandModels(self.item:getStaticModel(), nil)
end

CLO_Print("Overriding: 'ISAddGasolineToVehicle:update'")

local ISAddGasolineToVehicle_update = ISAddGasolineToVehicle.update
function ISAddGasolineToVehicle:update()
    self.character:faceThisObject(self.vehicle)
    self.item:setJobDelta(self:getJobDelta())
    self.item:setJobType(getText("ContextMenu_VehicleAddGas"))

    local actionCurrent = math.floor(self.itemStart + (self.itemTarget - self.itemStart) * self:getJobDelta() + 0.001)
    local itemCurrent = math.floor(self.item:getUsedDelta() / self.item:getUseDelta() + 0.001)

    if actionCurrent < itemCurrent then
        local tankCurrent = math.floor(self.part:getContainerContentAmount() + (itemCurrent - actionCurrent))
        local args = { vehicle = self.vehicle:getId(), part = self.part:getId(), amount = tankCurrent }
        sendClientCommand(self.character, 'vehicle', 'setContainerContentAmount', args)

        self.item:setUsedDelta(actionCurrent * self.item:getUseDelta())
        if self.item:getUsedDelta() <= 0 then self.item:Use() end
    end

    self.character:setMetabolicTarget(Metabolics.HeavyDomestic);
end

CLO_Print("Overriding: 'ISAddGasolineToVehicle:perform'")

local ISAddGasolineToVehicle_perform = ISAddGasolineToVehicle.perform
function ISAddGasolineToVehicle:perform()
    self.item:setJobDelta(0)

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end