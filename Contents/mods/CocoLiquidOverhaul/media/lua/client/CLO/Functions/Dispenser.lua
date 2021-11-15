local settings = require("CLO/Settings")
local ObjectFunctions = require("CLO/Functions/Object")
local DispenserTypes = require("CLO/DispenserTypes")

---@class DispenserFunctions
local DispenserFunctions = {}

---GetDispenserType
---@param _isoObject IsoObject
---@return table
function DispenserFunctions.GetDispenserType(_isoObject)
    if not instanceof(_isoObject, "IsoObject") then return end

    local customName = ObjectFunctions.GetObjectCustomName(_isoObject)
    if customName ~= "" then
        local groupName = _isoObject:getProperties():Val("GroupName")
        if customName == DispenserTypes.DefaultDispenser.CustomName and groupName == "Water" then
            return DispenserTypes.DefaultDispenser
        elseif customName == DispenserTypes.WaterDispenser.CustomName then
            return DispenserTypes.WaterDispenser
        elseif customName == DispenserTypes.FuelDispenser.CustomName then
            return DispenserTypes.FuelDispenser
        elseif customName == DispenserTypes.EmptyDispenser.CustomName then
            return DispenserTypes.EmptyDispenser
        elseif customName == DispenserTypes.EmptyBottleDispenser.CustomName then
            return DispenserTypes.EmptyBottleDispenser
        end
    end
end

---GetDispenserOnSquare
---@param _square table
---@return IsoObject
function DispenserFunctions.GetDispenserOnSquare(_square)
    if not instanceof(_square, "IsoGridSquare") then return end
    local result
    local objects = _square:getObjects()
    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        if object and DispenserFunctions.GetDispenserType(object) then
            result = object
            break
        end
    end
    return result
end

---CreateDispenserOnSquare
---@param _square IsoGridSquare
---@param _dispenserType table
---@param _amount number
---@return IsoObject
function DispenserFunctions.CreateDispenserOnSquare(_square, _dispenserType, _facing, _amount)
    if not instanceof(_square, "IsoGridSquare") then return end

    if not DispenserFunctions.GetDispenserOnSquare(_square) then
        local dispenser = IsoObject.new(_square, _dispenserType[_facing], _dispenserType.CustomName)
        if _dispenserType ~= DispenserTypes.DefaultDispenser then
            if _dispenserType.type == "water" then
                ObjectFunctions.SetObjectWaterAmount(dispenser, _amount)
                ObjectFunctions.SetObjectWaterMax(dispenser, settings.DispenserAmountMax)
            elseif _dispenserType.type == "fuel" then
                ObjectFunctions.SetObjectFuelAmount(dispenser, _amount)
                ObjectFunctions.SetObjectFuelMax(dispenser, settings.DispenserAmountMax)
            end
        end
        _square:AddTileObject(dispenser)
        return dispenser
    end
end

---RotateDispenserOnSquare
---@param _square IsoGridSquare
---@param _dispenserType table
---@param _facing string
---@return IsoObject
function DispenserFunctions.RotateDispenserOnSquare(_square, _dispenserType, _facing)
    if not instanceof(_square, "IsoGridSquare") then return end

    local currentDispenser = DispenserFunctions.GetDispenserOnSquare(_square)
    local currentType = DispenserFunctions.GetDispenserType(currentDispenser)
    if currentDispenser and currentType then
        local currentAmount = 0
        if currentType == DispenserTypes.DefaultDispenser or currentType.type == "water" then
            currentAmount = ObjectFunctions.GetObjectWaterAmount(currentDispenser)
        elseif currentType.type == "fuel" then
            currentAmount = ObjectFunctions.GetObjectFuelAmount(currentDispenser)
        end
        ObjectFunctions.DeleteObject(currentDispenser)
        local newDispenser = DispenserFunctions.CreateDispenserOnSquare(_square, _dispenserType, _facing, currentAmount)
        return newDispenser
    end
end

---TransformDispenserOnSquare
---@param _square IsoGridSquare
---@param _dispenserType table
---@param _liquidAmount number
---@param _tainted boolean
---@return IsoObject
function DispenserFunctions.TransformDispenserOnSquare(_square, _dispenserType, _liquidAmount, _tainted)
    if not instanceof(_square, "IsoGridSquare") then return end

    local currentDispenser = DispenserFunctions.GetDispenserOnSquare(_square)
    local currentType = DispenserFunctions.GetDispenserType(currentDispenser)
    if currentDispenser and currentType then
        local facing = ObjectFunctions.GetObjectFacing(currentDispenser)
        local currentAmount = 0
        if currentType == DispenserTypes.DefaultDispenser or currentType.type == "water" then
            currentAmount = ObjectFunctions.GetObjectWaterAmount(currentDispenser)
        elseif currentType.type == "fuel" then
            currentAmount = ObjectFunctions.GetObjectFuelAmount(currentDispenser)
        end
        if _liquidAmount and _liquidAmount > 0 then
            currentAmount = _liquidAmount
        end
        ObjectFunctions.DeleteObject(currentDispenser)
        local newDispenser = DispenserFunctions.CreateDispenserOnSquare(_square, _dispenserType, facing, currentAmount)
        ObjectFunctions.SetObjectWaterTainted(newDispenser, _tainted)
        return newDispenser
    end
end

return DispenserFunctions