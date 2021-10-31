CLO_Actions = CLO_Actions or {}

require "TimedActions/ISBaseTimedAction"
local ISPlaceDispenserBottle = ISBaseTimedAction:derive("ISPlaceDispenserBottle")

---isValid
function ISPlaceDispenserBottle:isValid()
    return true
end

---waitToStart
function ISPlaceDispenserBottle:waitToStart()
    self.character:faceLocation(self.square:getX(), self.square:getY())
    return self.character:shouldBeTurning()
end

---start
function ISPlaceDispenserBottle:start()
    local bottleModel = ""

    if self.bottleItemType == "Coco_WaterGallonEmpty" then
        bottleModel = "BigWaterBottleEmpty"
    elseif self.bottleItemType == "Coco_WaterGallonFull" then
        bottleModel = "BigWaterBottle"
    elseif self.bottleItemType == "Coco_WaterGallonPetrol" then
        bottleModel = "BigWaterBottleFuel"
    end

    if bottleModel then
        self:setOverrideHandModels(nil, bottleModel)
        self:setActionAnim("EquipItem")
    end
end

---stop
function ISPlaceDispenserBottle:stop()
    ISBaseTimedAction.stop(self)
end

---update
function ISPlaceDispenserBottle:update()

end

---perform
function ISPlaceDispenserBottle:perform()
    local liquidAmount = 0
    local taintedWater = false

    if self.bottleItem:IsDrainable() then
        liquidAmount = CLO_Inventory.GetDrainableItemContent(self.bottleItem)
    end

    local dispenserType
    if self.bottleItemType == "Coco_WaterGallonEmpty" then
        dispenserType = CLO_DispenserTypes.EmptyBottleDispenser
    elseif self.bottleItemType == "Coco_WaterGallonFull" then
        dispenserType = CLO_DispenserTypes.WaterDispenser
        taintedWater = self.bottleItem:isTaintedWater()
    elseif self.bottleItemType == "Coco_WaterGallonPetrol" then
        dispenserType = CLO_DispenserTypes.FuelDispenser
    end

    if self.character:getPrimaryHandItem() == self.bottleItem then
        self.character:setPrimaryHandItem(nil)
    elseif self.character:getSecondaryHandItem() == self.bottleItem then
        self.character:setSecondaryHandItem(nil)
    end

    self.character:getInventory():Remove(self.bottleItem)

    CLO_Dispenser.TransformDispenserOnSquare(self.square, dispenserType, liquidAmount, taintedWater)
    ISBaseTimedAction.perform(self)
end

---new
---@param playerObj IsoPlayer
---@param dispenserObj IsoObject
---@param bottleItem InventoryItem
---@param time number
function ISPlaceDispenserBottle:new(playerObj, dispenserObj, bottleItem, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = playerObj
    o.square = dispenserObj:getSquare()
    o.dispenserObj = dispenserObj
    o.bottleItem = bottleItem
    o.bottleItemType = bottleItem:getType()
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = time
    return o
end

CLO_Actions.ISPlaceDispenserBottle = ISPlaceDispenserBottle