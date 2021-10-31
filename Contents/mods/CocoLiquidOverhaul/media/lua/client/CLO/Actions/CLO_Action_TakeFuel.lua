CLO_Actions = CLO_Actions or {}

require "TimedActions/ISBaseTimedAction"
local TakeFuel = ISBaseTimedAction:derive("TakeFuel")

function TakeFuel:isValid()
    local pumpCurrent = self.fuelStation:getPipedFuelAmount()
    return pumpCurrent > 0
end

function TakeFuel:waitToStart()
    self.character:faceLocation(self.square:getX(), self.square:getY())
    return self.character:shouldBeTurning()
end

function TakeFuel:update()
    self.petrolCan:setJobDelta(self:getJobDelta())
    self.character:faceLocation(self.square:getX(), self.square:getY())
    local actionCurrent = math.floor(self.itemStart + (self.itemTarget - self.itemStart) * self:getJobDelta() + 0.001)
    local itemCurrent = math.floor(self.petrolCan:getUsedDelta() / self.petrolCan:getUseDelta() + 0.001)
    if actionCurrent > itemCurrent then
        -- FIXME: sync in multiplayer
        local pumpCurrent = tonumber(self.fuelStation:getPipedFuelAmount())
        self.fuelStation:setPipedFuelAmount(pumpCurrent - (actionCurrent - itemCurrent))

        self.petrolCan:setUsedDelta(actionCurrent * self.petrolCan:getUseDelta())
    end

    self.character:setMetabolicTarget(Metabolics.LightWork);
end

function TakeFuel:start()
    self.petrolCan:setJobType(getText("ContextMenu_TakeGasFromPump"))
    self.petrolCan:setJobDelta(0.0)

    --- check if current item is empty
    local itemType = self.petrolCan:getType()
    local isEmpty = itemType == "EmptyPetrolCan"
    local customEmpty = nil
    for i = 1, #CLO_ModSettings.CustomFuelItems do
        local fuelItem = CLO_ModSettings.CustomFuelItems[i]
        if not isEmpty and itemType == fuelItem.empty then
            customEmpty = fuelItem
            break
        end
    end

    --- let's transform an empty can into an empty petrol can
    if isEmpty or customEmpty then
        local isPrimary = self.petrolCan == self.character:getPrimaryHandItem()
        local emptyCan = self.petrolCan
        if isEmpty then
            self.petrolCan = self.character:getInventory():AddItem("Base.PetrolCan")
        elseif customEmpty then
            self.petrolCan = self.character:getInventory():AddItem(customEmpty.module .. "." .. customEmpty.full)
        end
        self.petrolCan:setUsedDelta(0)

        if isPrimary then
            self.character:setPrimaryHandItem(self.petrolCan)
        else
            self.character:setSecondaryHandItem(self.petrolCan)
        end
        self.character:getInventory():Remove(emptyCan)
    end

    local pumpCurrent = tonumber(self.fuelStation:getPipedFuelAmount())
    local itemCurrent = math.floor(self.petrolCan:getUsedDelta() / self.petrolCan:getUseDelta() + 0.001)
    local itemMax = math.floor(1 / self.petrolCan:getUseDelta() + 0.001)
    local take = math.min(pumpCurrent, itemMax - itemCurrent)
    self.action:setTime(take * 50)
    self.itemStart = itemCurrent
    self.itemTarget = itemCurrent + take

    self:setActionAnim("TakeGasFromPump")
    self:setOverrideHandModels(nil, self.petrolCan:getStaticModel())
end

function TakeFuel:stop()
    self.petrolCan:setJobDelta(0.0)
    ISBaseTimedAction.stop(self);
end

function TakeFuel:perform()
    self.petrolCan:setJobDelta(0.0)
    local itemCurrent = math.floor(self.petrolCan:getUsedDelta() / self.petrolCan:getUseDelta() + 0.001)
    if self.itemTarget > itemCurrent then
        self.petrolCan:setUsedDelta(self.itemTarget * self.petrolCan:getUseDelta())
        -- FIXME: sync in multiplayer
        local pumpCurrent = self.fuelStation:getPipedFuelAmount()
        self.fuelStation:setPipedFuelAmount(pumpCurrent + (self.itemTarget - itemCurrent))
    end
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

function TakeFuel:new(character, fuelStation, petrolCan, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.fuelStation = fuelStation;
    o.square = fuelStation:getSquare();
    o.petrolCan = petrolCan;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    return o;
end

CLO_Actions.TakeFuel = TakeFuel