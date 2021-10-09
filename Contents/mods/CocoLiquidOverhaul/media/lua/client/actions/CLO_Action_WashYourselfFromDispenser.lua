CLO_Actions = CLO_Actions or {}

require "TimedActions/ISBaseTimedAction"
local ISWashYourselfFromDispenser = ISBaseTimedAction:derive("ISWashYourselfFromDispenser")

---isValid
function ISWashYourselfFromDispenser:isValid()
    return true
end

---start
function ISWashYourselfFromDispenser:start()
    self:setActionAnim("WashFace")
    self:setOverrideHandModels(nil, nil)
end

---stop
function ISWashYourselfFromDispenser:stop()
    ISBaseTimedAction.stop(self)
end

---update
function ISWashYourselfFromDispenser:update()
    self.character:faceThisObjectAlt(self.dispenserObj)
    self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

---perform
function ISWashYourselfFromDispenser:perform()
    local visual = self.character:getHumanVisual()
    local waterUsed = 0
    for i=1,BloodBodyPartType.MAX:index() do
        local part = BloodBodyPartType.FromIndex(i-1)
        if self:washPart(visual, part) then
            waterUsed = waterUsed + 1
            if waterUsed >= CLO_Object.GetObjectWaterAmount(self.dispenserObj) then
                break
            end
        end
    end

    local waterAmount = CLO_Object.GetObjectWaterAmount(self.dispenserObj) - waterUsed
    if waterAmount <= 0.01 then
        CLO_Dispenser.TransformDispenserOnSquare(self.square, CLO_DispenserTypes.EmptyBottleDispenser, 0, false)
    else
        CLO_Object.SetObjectWaterAmount(self.dispenserObj, waterAmount)
    end

    self.character:resetModelNextFrame();
    triggerEvent("OnClothingUpdated", self.character)

    -- remove makeup
    self:removeAllMakeup()

    --TO DO: Need to fix this for multiplayer
    --local obj = self.dispenserObj
    --local args = {x=obj:getX(), y=obj:getY(), z=obj:getZ(), units=waterUsed}
    --sendClientCommand(self.character, 'object', 'takeWater', args)

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

---washPart
function ISWashYourselfFromDispenser:washPart(visual, part)
    if visual:getBlood(part) + visual:getDirt(part) <= 0 then
        return false
    end
    if visual:getBlood(part) > 0 then
        -- Soap is used for blood but not for dirt.
        for _,soap in ipairs(self.soaps) do
            if soap:getRemainingUses() > 0 then
                soap:Use()
                break
            end
        end
    end
    visual:setBlood(part, 0)
    visual:setDirt(part, 0)
    return true
end

---removeAllMakeup
function ISWashYourselfFromDispenser:removeAllMakeup()
    local item = self.character:getWornItem("MakeUp_FullFace")
    self:removeMakeup(item)
    item = self.character:getWornItem("MakeUp_Eyes")
    self:removeMakeup(item)
    item = self.character:getWornItem("MakeUp_EyesShadow")
    self:removeMakeup(item)
    item = self.character:getWornItem("MakeUp_Lips")
    self:removeMakeup(item)
end

---removeMakeup
function ISWashYourselfFromDispenser:removeMakeup(item)
    if item then
        self.character:removeWornItem(item)
        self.character:getInventory():Remove(item)
    end
end

---GetRequiredWater
function ISWashYourselfFromDispenser.GetRequiredWater(character)
    local units = 0
    local visual = character:getHumanVisual()
    for i=1,BloodBodyPartType.MAX:index() do
        local part = BloodBodyPartType.FromIndex(i-1)
        if visual:getBlood(part) + visual:getDirt(part) > 0 then
            units = units + 1
        end
    end
    return units
end

---GetSoapRemaining
function ISWashYourselfFromDispenser.GetSoapRemaining(soaps)
    local total = 0
    for _,soap in ipairs(soaps) do
        total = total + soap:getRemainingUses()
    end
    return total
end

---GetRequiredSoap
function ISWashYourselfFromDispenser.GetRequiredSoap(character)
    local units = 0
    local visual = character:getHumanVisual()
    for i=1,BloodBodyPartType.MAX:index() do
        local part = BloodBodyPartType.FromIndex(i-1)
        -- Soap is used for blood but not for dirt.
        if visual:getBlood(part) > 0 then
            units = units + 1
        end
    end
    return units
end

---new
---@param playerObj IsoPlayer
---@param dispenserObj IsoObject
---@param time number
function ISWashYourselfFromDispenser:new(character, dispenserObj, soapList)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character
    o.square = dispenserObj:getSquare()
    o.dispenserObj = dispenserObj
    o.soaps = soapList
    local waterUnits = math.min(ISWashYourselfFromDispenser.GetRequiredWater(character), CLO_Object.GetObjectWaterAmount(dispenserObj))
    o.maxTime = waterUnits * 70
    o.stopOnWalk = true
    o.stopOnRun = true
    o.forceProgressBar = true
    if ISWashYourselfFromDispenser.GetRequiredSoap(character) > ISWashYourselfFromDispenser.GetSoapRemaining(soapList) then
        o.maxTime = o.maxTime * 1.8
    end
    return o
end

CLO_Actions.ISWashYourselfFromDispenser = ISWashYourselfFromDispenser