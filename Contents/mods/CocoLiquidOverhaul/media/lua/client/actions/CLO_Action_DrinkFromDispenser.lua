CLO_Actions = CLO_Actions or {}

require "TimedActions/ISBaseTimedAction"
local ISDrinkFromDispenser = ISBaseTimedAction:derive("ISDrinkFromDispenser")

---isValid
function ISDrinkFromDispenser:isValid()
    return true
end

---waitToStart
function ISDrinkFromDispenser:waitToStart()
    self.character:faceLocation(self.square:getX(), self.square:getY())
    return self.character:shouldBeTurning()
end

---start
function ISDrinkFromDispenser:start()
    self:setActionAnim("drink_tap")
    self.sound = self.character:getEmitter():playSound("DrinkingFromTap")
    addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), 10, 1)
    
    local waterAvailable = CLO_Object.GetObjectWaterAmount(self.dispenserObj)
    local thirst = self.character:getStats():getThirst()
    local waterNeeded = math.min(math.ceil(thirst / 0.1), 10)
    self.waterUnit = math.min(waterNeeded, waterAvailable)
    self.action:setTime(self.waterUnit * 30)
end

---stop
function ISDrinkFromDispenser:stop()
    ISBaseTimedAction.stop(self)

    if self.sound then
		self.character:getEmitter():stopSound(self.sound)
		self.sound = nil
	end

    local percentage = self.action:getJobDelta()
    self:drink(percentage)
end

---update
function ISDrinkFromDispenser:update()

end

---perform
function ISDrinkFromDispenser:perform()
    ISBaseTimedAction.perform(self)

    if self.sound then
		self.character:getEmitter():stopSound(self.sound)
		self.sound = nil
	end

    local percentage = self.action:getJobDelta()
    self:drink(percentage)
end

function ISDrinkFromDispenser:drink(percentage)
    -- calcul the percentage drank
    if percentage > 0.95 then
        percentage = 1.0;
    end
    local uses = math.floor(self.waterUnit * percentage + 0.001);

    local waterAmount = CLO_Object.GetObjectWaterAmount(self.dispenserObj)
    for i=1,uses do
        if waterAmount <= 0 then break end

        if self.character:getStats():getThirst() > 0 then
            self.character:getStats():setThirst(self.character:getStats():getThirst() - 0.1)
            if self.character:getStats():getThirst() < 0 then
                self.character:getStats():setThirst(0)
            end
            if CLO_Object.GetObjectWaterTainted(self.dispenserObj) then
                self.character:getBodyDamage():setPoisonLevel(self.character:getBodyDamage():getPoisonLevel() + 10)
            end

            waterAmount = CLO_Object.GetObjectWaterAmount(self.dispenserObj)
            CLO_Object.SetObjectWaterAmount(self.dispenserObj, waterAmount - 1)
        end
    end

    if CLO_Object.GetObjectWaterAmount(self.dispenserObj) <= 0.01 then
        CLO_Dispenser.TransformDispenserOnSquare(self.square, CLO_DispenserTypes.EmptyBottleDispenser, 0, false)
    end
end

---new
---@param playerObj IsoPlayer
---@param dispenserObj IsoObject
---@param time number
function ISDrinkFromDispenser:new(playerObj, dispenserObj, time)
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

CLO_Actions.ISDrinkFromDispenser = ISDrinkFromDispenser