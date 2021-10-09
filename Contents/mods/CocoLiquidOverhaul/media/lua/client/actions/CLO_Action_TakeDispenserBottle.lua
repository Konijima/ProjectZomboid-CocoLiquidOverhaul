CLO_Actions = CLO_Actions or {}

require "TimedActions/ISBaseTimedAction"
local ISTakeDispenserBottle = ISBaseTimedAction:derive("ISTakeDispenserBottle")

---isValid
function ISTakeDispenserBottle:isValid()
    return true
end

---waitToStart
function ISTakeDispenserBottle:waitToStart()
    self.character:faceLocation(self.square:getX(), self.square:getY())
    return self.character:shouldBeTurning()
end

---start
function ISTakeDispenserBottle:start()
    self:setActionAnim("Loot")
end

---stop
function ISTakeDispenserBottle:stop()
    ISBaseTimedAction.stop(self)
end

---update
function ISTakeDispenserBottle:update()

end

---perform
function ISTakeDispenserBottle:perform()
    ---@type InventoryItem
    local item
    local liquidAmount = 0
    local liquidMax = 0
    local taintedWater = false
    local inventory = self.character:getInventory()

    local dispenserType = CLO_Dispenser.GetDispenserType(self.dispenserObj)
    if dispenserType == CLO_DispenserTypes.EmptyBottleDispenser then
        item = inventory:AddItem("CocoLiquidOverhaulItems.Coco_WaterGallonEmpty")
    elseif dispenserType == CLO_DispenserTypes.WaterDispenser then
        taintedWater = CLO_Object.GetObjectWaterTainted(self.dispenserObj)
        liquidAmount = CLO_Object.GetObjectWaterAmount(self.dispenserObj)
        liquidMax = CLO_Object.GetObjectWaterMax(self.dispenserObj)
        item = inventory:AddItem("CocoLiquidOverhaulItems.Coco_WaterGallonFull")
        if taintedWater then
            item:setTaintedWater(true)
        end
        item:setUsedDelta(liquidAmount / liquidMax)
    elseif dispenserType == CLO_DispenserTypes.FuelDispenser then
        liquidAmount = CLO_Object.GetObjectFuelAmount(self.dispenserObj)
        liquidMax = CLO_Object.GetObjectFuelMax(self.dispenserObj)
        item = inventory:AddItem("CocoLiquidOverhaulItems.Coco_WaterGallonPetrol")
        item:setUsedDelta(liquidAmount / liquidMax)
    end

    if not self.character:getPrimaryHandItem() then
        self.character:setPrimaryHandItem(item)
    else
        self.character:setSecondaryHandItem(item)
    end

    CLO_Dispenser.TransformDispenserOnSquare(self.square, CLO_DispenserTypes.EmptyDispenser, 0, false)

    ISBaseTimedAction.perform(self)
end

---new
---@param playerObj IsoPlayer
---@param dispenserObj IsoObject
---@param time number
function ISTakeDispenserBottle:new(playerObj, dispenserObj, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = playerObj
    o.square = dispenserObj:getSquare()
    o.dispenserObj = dispenserObj
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = time
    return o
end

CLO_Actions.ISTakeDispenserBottle = ISTakeDispenserBottle