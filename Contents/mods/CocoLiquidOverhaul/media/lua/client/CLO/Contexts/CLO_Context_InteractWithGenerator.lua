local settings = require("CLO/Settings")
local functions = require("CLO/Functions")

CLO_Contexts = CLO_Contexts or {}

---Context_InteractWithGenerator
---@param player number
---@param context ISContextMenu
local function Context_InteractWithGenerator(player, context, worldobjects, test)
    if test == true then return true end

    ---@type IsoPlayer
    local playerObj = getSpecificPlayer(player)

    ---@type ItemContainer
    local playerInv = playerObj:getInventory()

    ---@type IsoGridSquare
    if clickedSquare and generator then

        if not generator:isActivated() and generator:getFuel() < 100 then

            local allPetrolCans = functions.Inventory.GetAllNotEmptyDrainableItemOfTypeInInventory(playerInv, "PetrolCan")
            for i=1, #settings.CustomFuelItems do
                local item = settings.CustomFuelItems[i]
                local list = functions.Inventory.GetAllNotEmptyDrainableItemOfTypeInInventory(playerInv, item.full)
                for l=1, #list do
                    table.insert(allPetrolCans, list[l])
                end
            end
            if #allPetrolCans > 0 then
                local subMenu = functions.Context.CreateSubMenu(context, getText("ContextMenu_GeneratorAddFuelFrom"))
                for _, petrolCan in pairs(allPetrolCans) do
                    local option = subMenu:addOption(petrolCan:getName(), worldobjects, ISWorldObjectContextMenu.onAddFuel, petrolCan, generator, player);
                    functions.Context.CreateOptionTooltip(option, getText("ContextMenu_FuelName") .. ": " .. functions.Inventory.GetDrainableItemContentString(petrolCan))
                end
            end
        end

    end
end

CLO_Contexts.Context_InteractWithGenerator = Context_InteractWithGenerator