CLO_Actions = CLO_Actions or {}

require "TimedActions/ISBaseTimedAction"

local ISTakeWaterActionFromDispenser = ISBaseTimedAction:derive("ISTakeWaterActionFromDispenser")

---isValid
function ISTakeWaterActionFromDispenser:isValid()
    if self.oldItem ~= nil then
        if self.oldItem and not self.oldItem:getContainer() then return false end
        return CLO_Object.GetObjectWaterAmount(self.waterObject) > 0
    end
    if self.item and not self.item:getContainer() then return false end
    return CLO_Object.GetObjectWaterAmount(self.waterObject) > 0
end

---waitToStart
function ISTakeWaterActionFromDispenser:waitToStart()
    if self.waterObject then
        self.character:faceThisObject(self.waterObject)
    end
    return self.character:shouldBeTurning()
end

---update
function ISTakeWaterActionFromDispenser:update()
    if self.item ~= nil then
        self.item:setJobDelta(self:getJobDelta())
        self.item:setUsedDelta(self.startUsedDelta + (self.endUsedDelta - self.startUsedDelta) * self:getJobDelta())
    end
    if self.waterObject then
        self.character:faceThisObject(self.waterObject)
    end
end

---start
function ISTakeWaterActionFromDispenser:start()
    local waterAvailable = CLO_Object.GetObjectWaterAmount(self.waterObject)

    if self.oldItem ~= nil then
        self.character:getInventory():AddItem(self.item)
        if self.character:isPrimaryHandItem(self.oldItem) then
            self.character:setPrimaryHandItem(self.item)
        end
        if self.character:isSecondaryHandItem(self.oldItem) then
            self.character:setSecondaryHandItem(self.item)
        end
        self.character:getInventory():Remove(self.oldItem)
        self.oldItem = nil
    end
    self.item = self.item
    if self.item ~= nil then
        self.item:setBeingFilled(true)
        self.item:setJobType(getText("ContextMenu_Fill") .. self.item:getName())
        self.item:setJobDelta(0.0)
        self.sound = self.character:playSound("GetWaterFromTap")
        addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), 10, 1)

        local destCapacity = (1 - self.item:getUsedDelta()) / self.item:getUseDelta()
        self.waterUnit = math.min(math.ceil(destCapacity - 0.001), waterAvailable)
        self.startUsedDelta = self.item:getUsedDelta()
        self.endUsedDelta = math.min(self.item:getUsedDelta() + self.waterUnit * self.item:getUseDelta(), 1.0)
        self.action:setTime((self.waterUnit * 10) + 30)

        self:setAnimVariable("FoodType", self.item:getEatType())
        self:setActionAnim("fill_container_tap")
        if not self.item:getEatType() then
            self:setOverrideHandModels(nil, self.item:getStaticModel())
        else
            self:setOverrideHandModels(self.item:getStaticModel(), nil)
        end
    else
        self.sound = self.character:playSound("DrinkingFromTap")
        addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), 10, 1)

        local thirst = self.character:getStats():getThirst()
        local waterNeeded = math.min(math.ceil(thirst / 0.1), 10)
        self.waterUnit = math.min(waterNeeded, waterAvailable)
        self.action:setTime((self.waterUnit * 10) + 15)

        self:setActionAnim("drink_tap")
        self:setOverrideHandModels(nil, nil)
    end
end

---stopSound
function ISTakeWaterActionFromDispenser:stopSound()
    if self.sound and self.character:getEmitter():isPlaying(self.sound) then
		self.character:stopOrTriggerSound(self.sound);
	end
end

---stop
function ISTakeWaterActionFromDispenser:stop()
    self:stopSound()

    local used = self:getJobDelta() * self.waterUnit
    if used >= 1 then
        local waterAmount = CLO_Object.GetObjectWaterAmount(self.waterObject) - used
        if waterAmount <= 0.01 then
            CLO_Dispenser.TransformDispenserOnSquare(self.square, CLO_DispenserTypes.EmptyBottleDispenser, 0, false)
        else
            CLO_Object.SetObjectWaterAmount(self.waterObject, waterAmount)
        end
        --local obj = self.waterObject
        --local args = {x=obj:getX(), y=obj:getY(), z=obj:getZ(), units=used}
        --sendClientCommand(self.character, 'object', 'takeWater', args)
    end

    if self.item ~= nil then
        self.item:setBeingFilled(false)
        self.item:setJobDelta(0.0)
        if CLO_Object.GetObjectWaterTainted(self.waterObject) then
            self.item:setTaintedWater(true)
        end
    end

    ISBaseTimedAction.stop(self)
end

---perform
function ISTakeWaterActionFromDispenser:perform()
    self:stopSound()

    if self.item ~= nil then
        self.item:setBeingFilled(false)
        self.item:getContainer():setDrawDirty(true)
        self.item:setJobDelta(0.0)
        if CLO_Object.GetObjectWaterTainted(self.waterObject)then
            self.item:setTaintedWater(true)
        end
        --Without this setUsedDelta call, the final tick never goes through.
        -- the item's UsedDelta value is set at like .99
        --This means that the option to fill that container never goes away.
        --		if self.item:getUsedDelta() > 0.91 then
        --			self.item:setUsedDelta(1.0);
        --		end
    else
        local thirst = self.character:getStats():getThirst() - (self.waterUnit / 10)
        self.character:getStats():setThirst(math.max(thirst, 0.0))
        if CLO_Object.GetObjectWaterTainted(self.waterObject) then
            self.character:getBodyDamage():setPoisonLevel(self.character:getBodyDamage():getPoisonLevel() + self.waterUnit)
        end
    end

    local waterAmount = CLO_Object.GetObjectWaterAmount(self.waterObject) - self.waterUnit
    if waterAmount <= 0.01 then
        CLO_Dispenser.TransformDispenserOnSquare(self.square, CLO_DispenserTypes.EmptyBottleDispenser, 0, false)
    else
        CLO_Object.SetObjectWaterAmount(self.waterObject, waterAmount)
    end

    --local obj = self.waterObject
    --local args = {x=obj:getX(), y=obj:getY(), z=obj:getZ(), units=self.waterUnit}
    --sendClientCommand(self.character, 'object', 'takeWater', args)
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end

function ISTakeWaterActionFromDispenser:new (character, item, waterUnit, waterObject, time, oldItem)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.item = item
    o.oldItem = oldItem
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = 10
    o.waterUnit = waterUnit
    o.waterObject = waterObject
    o.square = waterObject:getSquare()
    return o
end

CLO_Actions.ISTakeWaterActionFromDispenser = ISTakeWaterActionFromDispenser