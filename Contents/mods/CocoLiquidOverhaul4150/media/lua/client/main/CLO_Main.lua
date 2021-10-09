---OnLoad
local function OnLoad()
    print(CLO_ModSettings.Name .. " v" .. tostring(CLO_ModSettings.Version) .. " has loaded!")
end

---Game Events
Events.OnGameBoot.Add(CLO_TweakItems)
Events.OnLoad.Add(OnLoad)
Events.OnPreFillInventoryObjectContextMenu.Add(CLO_Contexts.Context_CheckDrainableContent)
Events.OnPreFillInventoryObjectContextMenu.Add(CLO_Contexts.Context_PourGasInto)
Events.OnPreFillWorldObjectContextMenu.Add(CLO_Contexts.Context_TakeFuelFromPump)
Events.OnPreFillWorldObjectContextMenu.Add(CLO_Contexts.Context_InteractWithDispenser)
Events.OnFillWorldObjectContextMenu.Add(CLO_Contexts.Context_Debug)
Events.OnFillInventoryObjectContextMenu.Add(CLO_Contexts.Context_InventoryDebug)
