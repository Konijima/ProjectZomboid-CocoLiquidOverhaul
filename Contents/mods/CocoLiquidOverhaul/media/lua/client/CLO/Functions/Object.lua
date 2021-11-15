local Print = require("CLO/Functions/Print")
local settings = require("CLO/Settings")

---@class ObjectFunctions
local ObjectFunctions = {}

---GetObjectCustomName
---@param _object IsoObject
---@return string
function ObjectFunctions.GetObjectCustomName(_object)
    if not instanceof(_object, "IsoObject") or instanceof(_object, "IsoFire") then return "" end
    return _object:getProperties():Val("CustomName")
end

---GetObjectFacing
---@param _object IsoObject
---@return string
function ObjectFunctions.GetObjectFacing(_object)
    if not instanceof(_object, "IsoObject") then return "" end
    return _object:getProperties():Val("Facing")
end

---GetObjectWaterTainted
---@param _object IsoObject
---@return boolean
function ObjectFunctions.GetObjectWaterTainted(_object)
    if not instanceof(_object, "IsoObject") then return end
    return _object:getModData().taintedWater
end

---SetObjectWaterTainted
---@param _object IsoObject
---@param _tainted boolean
function ObjectFunctions.SetObjectWaterTainted(_object, _tainted)
    if not instanceof(_object, "IsoObject") then return end
    _object:getModData().taintedWater = _tainted
end

---GetObjectWaterAmount
---@param _object IsoObject
---@return number
function ObjectFunctions.GetObjectWaterAmount(_object)
    if not instanceof(_object, "IsoObject") then return 0 end
    return tonumber(_object:getModData().amountWater)
end

---SetObjectWaterAmount
---@param _object IsoObject
---@param _waterAmount number
function ObjectFunctions.SetObjectWaterAmount(_object, _waterAmount)
    if not instanceof(_object, "IsoObject") then return end
    if not _waterAmount then _waterAmount = settings.DispenserAmountMax end
    if _waterAmount > settings.DispenserAmountMax then _waterAmount = settings.DispenserAmountMax end
    _object:getModData().waterAmount = 0
    _object:getModData().amountWater = _waterAmount
end

---GetObjectWaterMax
---@param _object IsoObject
---@return number
function ObjectFunctions.GetObjectWaterMax(_object)
    if not instanceof(_object, "IsoObject") then return 0 end
    return tonumber(_object:getModData().maxWater)
end

---SetObjectWaterMax
---@param _object IsoObject
---@param _waterMax number
function ObjectFunctions.SetObjectWaterMax(_object, _waterMax)
    if not instanceof(_object, "IsoObject") then return end
    _object:getModData().waterMax = 0
    _object:getModData().maxWater = _waterMax
end

---GetObjectFuelAmount
---@param _object IsoObject
---@return number
function ObjectFunctions.GetObjectFuelAmount(_object)
    if not instanceof(_object, "IsoObject") then return 0 end
    return tonumber(_object:getModData().amountFuel)
end

---SetObjectFuelAmount
---@param _object IsoObject
---@param _fuelAmount number
function ObjectFunctions.SetObjectFuelAmount(_object, _fuelAmount)
    if not instanceof(_object, "IsoObject") then return end
    if not _fuelAmount then _fuelAmount = 0 end
    if _fuelAmount > settings.DispenserAmountMax then _fuelAmount = settings.DispenserAmountMax end
    _object:getModData().amountFuel = _fuelAmount
end

---GetObjectFuelMax
---@param _object IsoObject
---@return number
function ObjectFunctions.GetObjectFuelMax(_object)
    if not instanceof(_object, "IsoObject") then return 0 end
    return tonumber(_object:getModData().maxFuel)
end

---SetObjectFuelMax
---@param _object IsoObject
---@param _fuelMax number
function ObjectFunctions.SetObjectFuelMax(_object, _fuelMax)
    if not instanceof(_object, "IsoObject") then return end
    _object:getModData().maxFuel = _fuelMax
end

---CreateObject
---@param _spriteName string
---@param _square IsoGridSquare
---@return IsoObject
function ObjectFunctions.CreateObject(_spriteName, _square)
    if not instanceof(_square, "IsoGridSquare") then return end
    local obj = IsoObject.new(_square, _spriteName, "")
    _square:AddTileObject(obj)
    Print("Created object " .. _spriteName .. " on square x:" .. _square:getX() .. " y:" .. _square:getY())
    return obj
end

---DeleteObject
---@param _object IsoObject
function ObjectFunctions.DeleteObject(_object)
    if not instanceof(_object, "IsoObject") then return end
    local square = _object:getSquare()
    if square then
        local objectCustomName = ObjectFunctions.GetObjectCustomName(_object)
        square:transmitRemoveItemFromSquare(_object)
        square:RecalcProperties()
        Print("Deleted object " .. objectCustomName .. " on square x:" .. tostring(square:getX()) .. " y:" .. tostring(square:getY()))
    end
end

return ObjectFunctions