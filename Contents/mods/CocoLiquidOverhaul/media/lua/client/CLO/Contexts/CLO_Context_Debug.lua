local functions = require("CLO/Functions")
local DispenserTypes = require("CLO/DispenserTypes")

CLO_Contexts = CLO_Contexts or {}

---Context_Debug
---@param _playerNum number
---@param _context ISContextMenu
local function Context_Debug(_playerNum, _context, _, test)
    if test then return end

    if not getCore():getDebug() then return end

    ---@type IsoPlayer
    local playerObject = getSpecificPlayer(_playerNum)

    ---@type IsoGridSquare
    local square = clickedSquare

    ---@type ISContextMenu
    local subMenu = functions.Context.CreateSubMenu(_context, "[DEBUG] CLO")

    ---@type ItemContainer
    local inventory = playerObject:getInventory()

    if square then
        ---@type IsoObject
        local dispenser = functions.Dispenser.GetDispenserOnSquare(square)

        ---@type table
        local dispenserType = functions.Dispenser.GetDispenserType(dispenser)

        ---@type ISContextMenu
        local dispenserSubMenu = functions.Context.CreateSubMenu(subMenu, "Dispenser")

        if dispenser then

            if dispenserType == "Dispenser" then
                dispenserSubMenu:addOption("Convert", square, functions.Dispenser.TransformDispenserOnSquare, DispenserTypes.WaterDispenser)
            else
                if dispenserType.CustomName == "Empty Dispenser" then
                    local items = functions.Inventory.GetAllItemOfMultipleTypesInInventory(inventory, {"Coco_WaterGallonEmpty", "Coco_WaterGallonFull", "Coco_WaterGallonPetrol"})
                    if #items > 0 then
                        local placeBottleOnDispenserSubMenu = functions.Context.CreateSubMenu(dispenserSubMenu, "Add Bottle")
                        for i = 1, #items do
                            local item = items[i]
                            local dispenserNewType
                            local tainted = false
                            local liquidAmount = functions.Inventory.GetDrainableItemContent(item)
                            local toolTipPrefix = ""
                            if item:getType() == "Coco_WaterGallonFull" then
                                if item:isTaintedWater() then
                                    tainted = true
                                    toolTipPrefix = "Tainted Water: "
                                else
                                    toolTipPrefix = "Water: "
                                end
                                dispenserNewType = DispenserTypes.WaterDispenser
                            elseif item:getType() == "Coco_WaterGallonPetrol" then
                                toolTipPrefix = "Fuel: "
                                dispenserNewType = DispenserTypes.FuelDispenser
                            else
                                dispenserNewType = DispenserTypes.EmptyBottleDispenser
                            end
                            local option = placeBottleOnDispenserSubMenu:addOption(item:getName(), square, functions.Dispenser.TransformDispenserOnSquare, dispenserNewType, liquidAmount, tainted)
                            functions.Context.CreateOptionTooltip(option, toolTipPrefix .. functions.Inventory.GetDrainableItemContentString(item))
                        end
                    end
                else
                    dispenserSubMenu:addOption("Remove Bottle", square, functions.Dispenser.TransformDispenserOnSquare, DispenserTypes.EmptyDispenser, 0, false)
                end

                local rotateDispenserSubMenu = functions.Context.CreateSubMenu(dispenserSubMenu, "Rotate")
                rotateDispenserSubMenu:addOption("North", square, functions.Dispenser.RotateDispenserOnSquare, dispenserType, "N")
                rotateDispenserSubMenu:addOption("East", square, functions.Dispenser.RotateDispenserOnSquare, dispenserType, "E")
                rotateDispenserSubMenu:addOption("South", square, functions.Dispenser.RotateDispenserOnSquare, dispenserType, "S")
                rotateDispenserSubMenu:addOption("West", square, functions.Dispenser.RotateDispenserOnSquare, dispenserType, "W")
            end
            dispenserSubMenu:addOption("Delete", dispenser, functions.Object.DeleteObject)
        else
            local addDispenserSubMenu = functions.Context.CreateSubMenu(dispenserSubMenu, "Create")
            addDispenserSubMenu:addOption("Default", square, functions.Dispenser.CreateDispenserOnSquare, DispenserTypes.DefaultDispenser, "S", 0)
            addDispenserSubMenu:addOption("No Bottle", square, functions.Dispenser.CreateDispenserOnSquare, DispenserTypes.EmptyDispenser, "S", 0)
            addDispenserSubMenu:addOption("Empty Bottle", square, functions.Dispenser.CreateDispenserOnSquare, DispenserTypes.EmptyBottleDispenser, "S", 0)
            addDispenserSubMenu:addOption("Water Bottle", square, functions.Dispenser.CreateDispenserOnSquare, DispenserTypes.WaterDispenser, "S", 100)
            addDispenserSubMenu:addOption("Gas Bottle", square, functions.Dispenser.CreateDispenserOnSquare, DispenserTypes.FuelDispenser, "S", 100)
        end
    end
end

CLO_Contexts.Context_Debug = Context_Debug