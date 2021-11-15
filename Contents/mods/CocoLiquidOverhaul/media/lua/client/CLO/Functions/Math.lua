---@class MathFunctions
local MathFunctions = {}

---Round
---@param x number
---@return number
function MathFunctions.Round(x)
    return x + 0.5 - (x + 0.5) % 1
end

---Hypo
---@param x number
---@param y number
---@return number
function MathFunctions.Hypo(x, y)
    return math.sqrt(x^2 + y^2)
end

---Distance
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function MathFunctions.Distance(x1, y1, x2, y2)
    return MathFunctions.Hypo(x2 - x1, y2 - y1)
end

return MathFunctions