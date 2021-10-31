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

            local allPetrolCans = CLO_Inventory.GetAllNotEmptyDrainableItemOfTypeInInventory(playerInv, "PetrolCan")
            for i=1, #CLO_ModSettings.CustomFuelItems do
                local item = CLO_ModSettings.CustomFuelItems[i]
                local list = CLO_Inventory.GetAllNotEmptyDrainableItemOfTypeInInventory(playerInv, item.full)
                for l=1, #list do
                    table.insert(allPetrolCans, list[l])
                end
            end
            if #allPetrolCans > 0 then
                local subMenu = CLO_Context.CreateSubMenu(context, getText("ContextMenu_GeneratorAddFuelFrom"))
                for _, petrolCan in pairs(allPetrolCans) do
                    local option = subMenu:addOption(petrolCan:getName(), worldobjects, ISWorldObjectContextMenu.onAddFuel, petrolCan, generator, player);
                    CLO_Context.CreateOptionTooltip(option, getText("ContextMenu_FuelName") .. ": " .. CLO_Inventory.GetDrainableItemContentString(petrolCan))
                end
            end
        end

    end
end

CLO_Contexts.Context_InteractWithGenerator = Context_InteractWithGenerator