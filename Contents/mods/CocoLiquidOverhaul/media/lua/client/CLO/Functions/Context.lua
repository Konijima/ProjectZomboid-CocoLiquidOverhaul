---@class ContextFunctions
local ContextFunctions = {}

---CreateSubMenu
---@param _context ISContextMenu
---@param _title string
function ContextFunctions.CreateSubMenu(_context, _title)
    local option = _context:addOption(_title)
    local subContext = ISContextMenu:getNew(_context)
    _context:addSubMenu(option, subContext)
    return subContext
end

---CreateOptionTooltip
---@param _option ISContextMenu
---@param _description string
---@param _title string
---@return ISToolTip
function ContextFunctions.CreateOptionTooltip(_option, _description, _title)
    _option.toolTip = ISToolTip:new()
    if _title then _option.toolTip.name = _title end
    _option.toolTip.description = _description
    return _option.toolTip
end

---ConvertInventoryItemsToArray
---@return table
function ContextFunctions.ConvertInventoryItemsToArray(_items)
    local result = {}
    for _, v in ipairs(_items) do
        local item = v
        if not instanceof(v, "InventoryItem") then
            item = v.items[1]
        end
        table.insert(result, item)
    end
    return result
end

function ContextFunctions.GetMoveableDisplayName(obj)
    if not obj then return nil end
    if not obj:getSprite() then return nil end
    local props = obj:getSprite():getProperties()
    if props:Is("CustomName") then
        local name = props:Val("CustomName")
        if props:Is("GroupName") then
            name = props:Val("GroupName") .. " " .. name
        end
        return Translator.getMoveableDisplayName(name)
    end
    return nil
end

return ContextFunctions