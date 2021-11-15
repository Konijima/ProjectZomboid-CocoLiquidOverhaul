local MathFunctions = require("CLO/Functions/Math")

---@class WorldFunctions
local WorldFunctions = {}

---DistanceBetweenSquares
---@param _squareA IsoGridSquare
---@param _squareB IsoGridSquare
---@return number
function WorldFunctions.DistanceBetweenSquares(_squareA, _squareB)
    if not instanceof(_squareA, "IsoGridSquare") or not instanceof(_squareB, "IsoGridSquare") then return end
    local x1, y1 = _squareA:getX(), _squareA:getY()
    local x2, y2 = _squareB:getX(), _squareB:getY()
    return MathFunctions.Distance(x1, y1, x2, y2)
end

---GetFuelStationOnSquare
---@param _square IsoGridSquare
function WorldFunctions.GetFuelStationOnSquare(_square)
    if not instanceof(_square, "IsoGridSquare") then return end

    local fuelStation = nil
    local objects = _square:getObjects()
    for i = 0, objects:size() - 1 do
        ---@type IsoObject
        local object = objects:get(i)
        if object:getPipedFuelAmount() > 0 then
            fuelStation = object
        end
    end
    return fuelStation
end

---GetAvailableFuelOnSquare
---@param _square IsoGridSquare
---@return number
function WorldFunctions.GetAvailableFuelOnSquare(_square)
    if not instanceof(_square, "IsoGridSquare") then return 0 end

    local fuelAvailable = 0
    local fuelStation = WorldFunctions.GetFuelStationOnSquare(_square)
    if fuelStation then
        fuelAvailable = fuelStation:getPipedFuelAmount()
    end

    return fuelAvailable
end

---SetAvailableFuelOnSquare
---@param _square IsoGridSquare
---@param _fuelAmount number
function WorldFunctions.SetAvailableFuelOnSquare(_square, _fuelAmount)
    if not instanceof(_square, "IsoGridSquare") then return end

    local fuelStation = WorldFunctions.GetFuelStationOnSquare(_square)
    if fuelStation then
        fuelStation:setPipedFuelAmount(tonumber(_fuelAmount))
    end
end

---GetFirstObjectWithCustomNameOnSquare
---@param _square IsoGridSquare
---@param _customName string
---@return IsoObject
function WorldFunctions.GetFirstObjectWithCustomNameOnSquare(_square, _customName)
    if not instanceof(_square, "IsoGridSquare") then return end
    local result
    local objects = _square:getObjects()
    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        local customName = CLO_Funcs.GetObjectCustomName(object)
        if customName == _customName then
            result = object
            break
        end
    end
    return result
end

---GetAllObjectsWithCustomNameOnSquare
---@param _square table
---@param _customName table
---@return table
function WorldFunctions.GetAllObjectsWithCustomNameOnSquare(_square, _customName)
    if not instanceof(_square, "IsoGridSquare") then return {} end
    local result = {}
    local objects = _square:getObjects()
    for i = 0, objects:size() - 1 do
        local object = objects:get(i)
        local customName = CLO_Funcs.GetObjectCustomName(object)
        if customName == _customName then
            table.insert(result, object)
        end
    end
    return result
end

return WorldFunctions