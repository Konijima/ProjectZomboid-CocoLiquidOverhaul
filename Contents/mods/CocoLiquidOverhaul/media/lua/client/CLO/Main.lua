require("CLO/Settings")
require("CLO/Functions")

require("CLO/Overrides/CLO_ISAddGasolineToVehicle")
require("CLO/Overrides/CLO_ISTakeGasolineFromVehicle")
require("CLO/Overrides/CLO_ISVehicleMenu_FillPartMenu")
require("CLO/Overrides/CLO_ISVehiclePartMenu_getGasCanNotEmpty")
require("CLO/Overrides/CLO_ISVehiclePartMenu_getGasCanNotFull")

require("CLO/Contexts/CLO_Context_BurnCorpse")
require("CLO/Contexts/CLO_Context_CheckDrainableContent")
require("CLO/Contexts/CLO_Context_Debug")
require("CLO/Contexts/CLO_Context_InteractWithDispenser")
require("CLO/Contexts/CLO_Context_InteractWithGenerator")
require("CLO/Contexts/CLO_Context_InventoryDebug")
require("CLO/Contexts/CLO_Context_PourGasInto")
require("CLO/Contexts/CLO_Context_TakeFuelFromPump")

---OnLoad
local function OnLoad()
    print(CLO_ModSettings.Name .. " v" .. tostring(CLO_ModSettings.Version) .. " has loaded!")

    for i = 1, #CLO_ModSettings.PreloadLogs do
        print(CLO_ModSettings.PreloadLogs[i])
    end

    CLO_ModSettings.Loaded = true
end

---OnGameBoot
local function OnGameBoot()
    for _, v in pairs(CLO_ModSettings.CustomItems) do
        local item = ScriptManager.instance:getItem(v[1])
        if item ~= nil then
            item:DoParam("displaycategory" .. " = " .. v[2])
        end
    end
end

---Add new GasCan like items
CLO_AddNewFuelItem("CocoLiquidOverhaulItems", "Coco_LargeEmptyPetrolCan", "Coco_LargePetrolCan")
CLO_AddNewFuelItem("CocoLiquidOverhaulItems", "Coco_WaterGallonEmpty", "Coco_WaterGallonPetrol")

---Game Events
Events.OnGameBoot.Add(OnGameBoot)
Events.OnLoad.Add(OnLoad)
Events.OnPreFillInventoryObjectContextMenu.Add(CLO_Contexts.Context_CheckDrainableContent)
Events.OnPreFillInventoryObjectContextMenu.Add(CLO_Contexts.Context_PourGasInto)
Events.OnPreFillWorldObjectContextMenu.Add(CLO_Contexts.Context_TakeFuelFromPump)
Events.OnPreFillWorldObjectContextMenu.Add(CLO_Contexts.Context_InteractWithGenerator)
Events.OnPreFillWorldObjectContextMenu.Add(CLO_Contexts.Context_InteractWithDispenser)
Events.OnFillWorldObjectContextMenu.Add(CLO_Contexts.Context_BurnCorpse)
Events.OnFillWorldObjectContextMenu.Add(CLO_Contexts.Context_Debug)
Events.OnFillInventoryObjectContextMenu.Add(CLO_Contexts.Context_InventoryDebug)
