local settings = require("CLO/Settings")
local functions = require("CLO/Functions")

functions.Print("Overriding: 'ISTakeGasolineFromVehicle:start'")

local ISTakeGasolineFromVehicle_start = ISTakeGasolineFromVehicle.start
function ISTakeGasolineFromVehicle:start()
    if self.item:getType() == "EmptyPetrolCan" then
        ISTakeGasolineFromVehicle_start(self)
    else
        local itemType = self.item:getType()
        local customFuelItem = nil
        for i = 1, #settings.CustomFuelItems do
            local fuelItem = settings.CustomFuelItems[i]
            if itemType == fuelItem.empty then
                customFuelItem = fuelItem
                break
            end
        end

        if customFuelItem then
            local wasPrimary = self.character:getPrimaryHandItem() == self.item
            local wasSecondary = self.character:getSecondaryHandItem() == self.item
            self.character:getInventory():DoRemoveItem(self.item)
            if customFuelItem and itemType == customFuelItem.empty then
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
        local itemCurrent = math.floor(self.item:getUsedDelta() / self.item:getUseDelta() + 0.001)
        local itemMax = math.floor(1 / self.item:getUseDelta() + 0.001)
        local take = math.min(tankCurrent, itemMax - itemCurrent)
        self.itemStart = itemCurrent
        self.itemTarget = itemCurrent + take

        self.action:setTime(take * 50)

        self:setActionAnim("TakeGasFromVehicle")
        self:setOverrideHandModels(nil, self.item:getStaticModel())
    end
end

functions.Print("Overriding: 'ISTakeGasolineFromVehicle:update'")

local ISTakeGasolineFromVehicle_update = ISTakeGasolineFromVehicle.update
function ISTakeGasolineFromVehicle:update()
    if self.item:getType() == "PetrolCan" then
        ISTakeGasolineFromVehicle_update(self)
    else
        self.character:faceThisObject(self.vehicle)
        self.item:setJobDelta(self:getJobDelta())
        self.item:setJobType(getText("ContextMenu_VehicleSiphonGas"))

        local actionCurrent = math.floor(self.itemStart + (self.itemTarget - self.itemStart) * self:getJobDelta() + 0.001)
        local itemCurrent = math.floor(self.item:getUsedDelta() / self.item:getUseDelta() + 0.001)

        if actionCurrent > itemCurrent then
            local tankCurrent = math.floor(self.part:getContainerContentAmount() - (actionCurrent - itemCurrent))
            local args = { vehicle = self.vehicle:getId(), part = self.part:getId(), amount = tankCurrent }
            sendClientCommand(self.character, 'vehicle', 'setContainerContentAmount', args)

            self.item:setUsedDelta(actionCurrent * self.item:getUseDelta())
        end

        self.character:setMetabolicTarget(Metabolics.HeavyDomestic);
    end
end

functions.Print("Overriding: 'ISTakeGasolineFromVehicle:perform'")

local ISTakeGasolineFromVehicle_perform = ISTakeGasolineFromVehicle.perform
function ISTakeGasolineFromVehicle:perform()
    if self.item:getType() == "PetrolCan" then
        ISTakeGasolineFromVehicle_perform(self)
    else
        self.item:setJobDelta(0)
        self.item:setUsedDelta(self.itemTarget)

        -- needed to remove from queue / start next.
        ISBaseTimedAction.perform(self)
    end
end
