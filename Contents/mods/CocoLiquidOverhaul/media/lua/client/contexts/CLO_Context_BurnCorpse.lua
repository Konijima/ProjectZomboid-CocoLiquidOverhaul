CLO_Contexts = CLO_Contexts or {}

---onBurnCorpse
local function onBurnCorpse(worldobjects, player, gasItem, corpse)
    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
    if corpse:getSquare() and luautils.walkAdj(playerObj, corpse:getSquare()) then
        if playerInv:containsTypeRecurse("Lighter") then
            ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), playerInv:getFirstTypeRecurse("Lighter"), true, false)
        elseif playerObj:getInventory():containsTypeRecurse("Matches") then
            ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), playerInv:getFirstTypeRecurse("Matches"), true, false)
        end
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), gasItem, false, false)
        ISTimedActionQueue.add(ISBurnCorpseAction:new(playerObj, corpse, 110));
    end
end

---Context_BurnCorpse
---@param player number
---@param context ISContextMenu
local function Context_BurnCorpse(player, context, worldobjects, test)
    local square = clickedSquare
    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()
    if playerObj:isAsleep() then return end

    body = IsoObjectPicker.Instance:PickCorpse(square:getX(), square:getY()) or body
    if body then
        local customFuelItem = nil
        for i = 1, #CLO_ModSettings.CustomFuelItems do
            local fuelItem = CLO_ModSettings.CustomFuelItems[i]
            customFuelItem = CLO_Inventory.GetFirstItemOfTypeInInventory(playerInv, fuelItem.full)
            if customFuelItem then
                break
            end
        end

        if customFuelItem ~= nil and (playerInv:containsTypeRecurse("Lighter") or playerInv:containsTypeRecurse("Matches")) then
            if test == true then return true; end
            context:addOption(getText("ContextMenu_Burn_Corpse"), worldobjects, onBurnCorpse, player, customFuelItem, body);
        end
    end
end

CLO_Contexts.Context_BurnCorpse = Context_BurnCorpse