CLO_Contexts = CLO_Contexts or {}

---Context_CheckDrainableContent
---@param _playerNum number
---@param _context ISContextMenu
---@param _items table
local function Context_CheckDrainableContent(_playerNum, _context, _items)

    ---@type table
    local items = CLO_Context.ConvertInventoryItemsToArray(_items)

    if #items == 1 then
        ---@type InventoryItem
        local item = items[1]

        local type = item:getType()
        if item:canStoreWater() or item:IsDrainable() or type == "PetrolCan" or type == "Coco_WaterGallonPetrol" or type == "Coco_LargePetrolCan" then

            if item:IsDrainable() and item:isWaterSource() then
                local option = _context:addOption(item:getName())
                local toolTip = CLO_Context.CreateOptionTooltip(option, getText("ContextMenu_WaterName") .. ": " .. CLO_Inventory.GetDrainableItemContentString(item))
                if item:isTaintedWater() then
                    toolTip.description = toolTip.description .. " <BR> <RGB:1,0.5,0.5> " .. getText("Tooltip_item_TaintedWater")
                end

            elseif item:IsDrainable() and (type == "PetrolCan" or type == "Coco_WaterGallonPetrol" or type == "Coco_LargePetrolCan") then
                local option = _context:addOption(item:getName())
                CLO_Context.CreateOptionTooltip(option, getText("ContextMenu_FuelName") .. ": " .. CLO_Inventory.GetDrainableItemContentString(item))

            elseif not item:IsDrainable() and item:canStoreWater() then
                local option = _context:addOption(item:getName())
                CLO_Context.CreateOptionTooltip(option, getText("ContextMenu_IsEmpty"))
            end
        end
    end

end

CLO_Contexts.Context_CheckDrainableContent = Context_CheckDrainableContent