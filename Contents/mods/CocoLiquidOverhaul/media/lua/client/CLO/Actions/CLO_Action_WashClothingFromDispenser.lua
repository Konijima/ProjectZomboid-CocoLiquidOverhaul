local functions = require("CLO/Functions")
local DispenserTypes = require("CLO/DispenserTypes")

CLO_Actions = CLO_Actions or {}

require "TimedActions/ISBaseTimedAction"
local ISWashClothingFromDispenser = ISBaseTimedAction:derive("ISWashClothingFromDispenser")

---isValid
function ISWashClothingFromDispenser:isValid()
    if functions.Object.GetObjectWaterAmount(self.dispenserObj) < ISWashClothingFromDispenser.GetRequiredWater(self.item) then
        return false
    end
    return true
end

---start
function ISWashClothingFromDispenser:start()
    self:setActionAnim("Loot")
    self:setAnimVariable("LootPosition", "");
    self:setOverrideHandModels(nil, nil)
end

---stop
function ISWashClothingFromDispenser:stop()
    self.item:setJobDelta(0.0)
    ISBaseTimedAction.stop(self)
end

---update
function ISWashClothingFromDispenser:update()
    self.item:setJobDelta(self:getJobDelta())
    self.character:faceThisObjectAlt(self.dispenserObj)
    self.character:setMetabolicTarget(Metabolics.HeavyDomestic)
end

---GetSoapRemaining
function ISWashClothingFromDispenser.GetSoapRemaining(soaps)
    local total = 0
    for _,soap in ipairs(soaps) do
        total = total + soap:getRemainingUses()
    end
    return total
end

---GetRequiredSoap
function ISWashClothingFromDispenser.GetRequiredSoap(item)
    local total = 0
    if instanceof(item, "Clothing") then
        local coveredParts = BloodClothingType.getCoveredParts(item:getBloodClothingType())
        if coveredParts then
            for i=1,coveredParts:size() do
                local part = coveredParts:get(i-1)
                if item:getBlood(part) > 0 then
                    total = total + 1
                end
            end
        end
    else
        if item:getBloodLevel() > 0 then
            total = total + 1
        end
    end
    return total
end

---GetRequiredWater
function ISWashClothingFromDispenser.GetRequiredWater(item)
    return 10
end

---useSoap
function ISWashClothingFromDispenser:useSoap(item, part)
    local blood = 0;
    if part then
        blood = item:getBlood(part);
    else
        blood = item:getBloodLevel();
    end
    if blood > 0 then
        for _,soap in ipairs(self.soaps) do
            if soap:getRemainingUses() > 0 then
                soap:Use();
                return true;
            end
        end
    else
        return true;
    end
    return false;
end

---perform
function ISWashClothingFromDispenser:perform()
    self.item:setJobDelta(0.0)
    local item = self.item;
    local water = ISWashClothingFromDispenser.GetRequiredWater(item)
    if instanceof(item, "Clothing") then
        local coveredParts = BloodClothingType.getCoveredParts(item:getBloodClothingType())
        if coveredParts then
            for j=0,coveredParts:size()-1 do
                if self.noSoap == false then
                    self:useSoap(item, coveredParts:get(j));
                end
                item:setBlood(coveredParts:get(j), 0);
                item:setDirt(coveredParts:get(j), 0);
            end
        end
        item:setWetness(100);
        item:setDirtyness(0);
    else
        self:useSoap(item, nil);
    end
    item:setBloodLevel(0);

    self.character:resetModel();
    triggerEvent("OnClothingUpdated", self.character)

    local waterAmount = functions.Object.GetObjectWaterAmount(self.dispenserObj) - water
    if waterAmount <= 0.01 then
        functions.Dispenser.TransformDispenserOnSquare(self.square, DispenserTypes.EmptyBottleDispenser, 0, false)
    else
        functions.Object.SetObjectWaterAmount(self.dispenserObj, waterAmount)
    end

    --local obj = self.sink
    --local args = {x=obj:getX(), y=obj:getY(), z=obj:getZ(), units=water}
    --if instanceof (obj, "Drainable") then
    --    self.obj:setUsedDelta(self.startUsedDelta + (self.endUsedDelta - self.startUsedDelta) * self:getJobDelta());
    --end
    --sendClientCommand(self.character, 'object', 'takeWater', args)

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

---new
---@param character IsoPlayer
---@param dispenserObj IsoObject
---@param soapList table
---@param item InventoryItem
---@param bloodAmount number
---@param dirtAmount number
---@param noSoap boolean
function ISWashClothingFromDispenser:new(character, dispenserObj, soapList, item, bloodAmount, dirtAmount, noSoap)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.stopOnWalk = true
    o.stopOnRun = true
    o.character = character
    o.square = dispenserObj:getSquare()
    o.dispenserObj = dispenserObj
    o.item = item
    o.maxTime = ((bloodAmount + dirtAmount) * 15)
    if o.maxTime > 500 then
        o.maxTime = 500
    end
    if noSoap == true then
        o.maxTime = o.maxTime * 5
    end
    if o.maxTime > 800 then
        o.maxTime = 800
    end
    if o.maxTime < 100 then
        o.maxTime = 100
    end
    o.soaps = soapList
    o.noSoap = noSoap
    o.forceProgressBar = true
    if character:isTimedActionInstant() then
        o.maxTime = 1
    end
    return o
end

CLO_Actions.ISWashClothingFromDispenser = ISWashClothingFromDispenser