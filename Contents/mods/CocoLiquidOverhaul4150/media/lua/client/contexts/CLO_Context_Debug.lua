CLO_Contexts = CLO_Contexts or {}

---Context_Debug
---@param _playerNum number
---@param _context ISContextMenu
local function Context_Debug(_playerNum, _context, _, test)
    if test then return end

    if not CLO_ModSettings.Config.Debug then return end

    ---@type IsoPlayer
    local playerObject = getSpecificPlayer(_playerNum)

    ---@type IsoGridSquare
    local square = clickedSquare

    ---@type ISContextMenu
    local subMenu = CLO_Context.CreateSubMenu(_context, "[DEBUG] CLO")

    ---@type ItemContainer
    local inventory = playerObject:getInventory()

    if square then
        ---@type IsoObject
        local dispenser = CLO_Dispenser.GetDispenserOnSquare(square)

        ---@type table
        local dispenserType = CLO_Dispenser.GetDispenserType(dispenser)

        ---@type ISContextMenu
        local dispenserSubMenu = CLO_Context.CreateSubMenu(subMenu, "Dispenser")

        if dispenser then

            if dispenserType == "Dispenser" then
                dispenserSubMenu:addOption("Convert", square, CLO_Dispenser.TransformDispenserOnSquare, CLO_DispenserTypes.WaterDispenser)
            else
                if dispenserType.CustomName == "Empty Dispenser" then
                    local items = CLO_Inventory.GetAllItemOfMultipleTypesInInventory(inventory, {"Coco_WaterGallonEmpty", "Coco_WaterGallonFull", "Coco_WaterGallonPetrol"})
                    if #items > 0 then
                        local placeBottleOnDispenserSubMenu = CLO_Context.CreateSubMenu(dispenserSubMenu, "Add Bottle")
                        for i = 1, #items do
                            local item = items[i]
                            local dispenserNewType
                            local tainted = false
                            local liquidAmount = CLO_Inventory.GetDrainableItemContent(item)
                            local toolTipPrefix = ""
                            if item:getType() == "Coco_WaterGallonFull" then
                                if item:isTaintedWater() then
                                    tainted = true
                                    toolTipPrefix = "Tainted Water: "
                                else
                                    toolTipPrefix = "Water: "
                                end
                                dispenserNewType = CLO_DispenserTypes.WaterDispenser
                            elseif item:getType() == "Coco_WaterGallonPetrol" then
                                toolTipPrefix = "Fuel: "
                                dispenserNewType = CLO_DispenserTypes.FuelDispenser
                            else
                                dispenserNewType = CLO_DispenserTypes.EmptyBottleDispenser
                            end
                            local option = placeBottleOnDispenserSubMenu:addOption(item:getName(), square, CLO_Dispenser.TransformDispenserOnSquare, dispenserNewType, liquidAmount, tainted)
                            CLO_Context.CreateOptionTooltip(option, toolTipPrefix .. CLO_Inventory.GetDrainableItemContentString(item))
                        end
                    end
                else
                    dispenserSubMenu:addOption("Remove Bottle", square, CLO_Dispenser.TransformDispenserOnSquare, CLO_DispenserTypes.EmptyDispenser, 0, false)
                end

                local rotateDispenserSubMenu = CLO_Context.CreateSubMenu(dispenserSubMenu, "Rotate")
                rotateDispenserSubMenu:addOption("North", square, CLO_Dispenser.RotateDispenserOnSquare, dispenserType, "N")
                rotateDispenserSubMenu:addOption("East", square, CLO_Dispenser.RotateDispenserOnSquare, dispenserType, "E")
                rotateDispenserSubMenu:addOption("South", square, CLO_Dispenser.RotateDispenserOnSquare, dispenserType, "S")
                rotateDispenserSubMenu:addOption("West", square, CLO_Dispenser.RotateDispenserOnSquare, dispenserType, "W")
            end
            dispenserSubMenu:addOption("Delete", dispenser, CLO_Object.DeleteObject)
        else
            local addDispenserSubMenu = CLO_Context.CreateSubMenu(dispenserSubMenu, "Create")
            addDispenserSubMenu:addOption("Default", square, CLO_Dispenser.CreateDispenserOnSquare, CLO_DispenserTypes.DefaultDispenser, "S", 0)
            addDispenserSubMenu:addOption("No Bottle", square, CLO_Dispenser.CreateDispenserOnSquare, CLO_DispenserTypes.EmptyDispenser, "S", 0)
            addDispenserSubMenu:addOption("Empty Bottle", square, CLO_Dispenser.CreateDispenserOnSquare, CLO_DispenserTypes.EmptyBottleDispenser, "S", 0)
            addDispenserSubMenu:addOption("Water Bottle", square, CLO_Dispenser.CreateDispenserOnSquare, CLO_DispenserTypes.WaterDispenser, "S", 100)
            addDispenserSubMenu:addOption("Gas Bottle", square, CLO_Dispenser.CreateDispenserOnSquare, CLO_DispenserTypes.FuelDispenser, "S", 100)
        end
    end
end

CLO_Contexts.Context_Debug = Context_Debug