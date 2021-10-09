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
    local square = clickedSquare

    if square then

        if generator then
            local option = context:addOption(getText("ContextMenu_GeneratorInfo"), worldobjects, ISWorldObjectContextMenu.onInfoGenerator, generator, player);
            if playerObj:DistToSquared(generator:getX() + 0.5, generator:getY() + 0.5) < 2 * 2 then
                CLO_Context.CreateOptionTooltip(option, ISGeneratorInfoWindow.getRichText(generator, true), getText("IGUI_Generator_TypeGas"))
            end
            if generator:isConnected() then
                if generator:isActivated() then
                    context:addOption(getText("ContextMenu_Turn_Off"), worldobjects, ISWorldObjectContextMenu.onActivateGenerator, false, generator, player);
                else
                    local option = context:addOption(getText("ContextMenu_GeneratorUnplug"), worldobjects, ISWorldObjectContextMenu.onPlugGenerator, generator, player, false);
                    if generator:getFuel() > 0 then
                        option = context:addOption(getText("ContextMenu_Turn_On"), worldobjects, ISWorldObjectContextMenu.onActivateGenerator, true, generator, player);
                        local doStats = playerObj:DistToSquared(generator:getX() + 0.5, generator:getY() + 0.5) < 2 * 2
                        local description = ISGeneratorInfoWindow.getRichText(generator, doStats)
                        if description ~= "" then
                            CLO_Context.CreateOptionTooltip(option, description, getText("IGUI_Generator_TypeGas"))
                        end
                    end
                end
            else
                local option = context:addOption(getText("ContextMenu_GeneratorPlug"), worldobjects, ISWorldObjectContextMenu.onPlugGenerator, generator, player, true);
                if not playerObj:isRecipeKnown("Generator") then
                    CLO_Context.CreateOptionTooltip(option, getText("ContextMenu_GeneratorPlugTT"));
                    option.notAvailable = true;
                end
            end
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
                    local subMenu = CLO_Context.CreateSubMenu(context, getText("ContextMenu_GeneratorAddFuel"))
                    for _, petrolCan in pairs(allPetrolCans) do
                        local option = subMenu:addOption(petrolCan:getName(), worldobjects, ISWorldObjectContextMenu.onAddFuel, petrolCan, generator, player);
                        CLO_Context.CreateOptionTooltip(option, getText("ContextMenu_FuelName") .. ": " .. CLO_Inventory.GetDrainableItemContentString(petrolCan))
                    end
                end
            end
            if not generator:isActivated() and generator:getCondition() < 100 then
                local option = context:addOption(getText("ContextMenu_GeneratorFix"), worldobjects, ISWorldObjectContextMenu.onFixGenerator, generator, player);
                if not playerObj:isRecipeKnown("Generator") then
                    CLO_Context.CreateOptionTooltip(option, getText("ContextMenu_GeneratorPlugTT"))
                    option.notAvailable = true;
                end
                if not playerInv:containsTypeRecurse("ElectronicsScrap") then
                    CLO_Context.CreateOptionTooltip(option, getText("ContextMenu_GeneratorFixTT"))
                    option.notAvailable = true;
                end
            end
            if not generator:isConnected() then
                context:addOption(getText("ContextMenu_GeneratorTake"), worldobjects, ISWorldObjectContextMenu.onTakeGenerator, generator, player);
            end

            generator = nil -- disable vanilla generator context menu
        end
    end
end

CLO_Contexts.Context_InteractWithGenerator = Context_InteractWithGenerator