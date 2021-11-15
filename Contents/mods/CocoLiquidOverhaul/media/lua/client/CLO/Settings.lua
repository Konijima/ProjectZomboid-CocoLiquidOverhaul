local CustomCategories = {
    LiquidContainer = "Coco_Liquid_Container",
}

--- Mod Settings
local ModSettings = {
    ModID = "CocoLiquidOverhaul",
    Name = "[B41] Coco Liquid Overhaul",
    Version = 2.0,
    DispenserAmountMax = 100,
    Loaded = false,
    PreloadLogs = {},
    Config = {
        Verbose = true,
    },

    ---Assign Custom Category to item
    CustomItems = {
        EmptyPetrolCan = {"Base.EmptyPetrolCan", CustomCategories.LiquidContainer},
        PetrolCan = {"Base.PetrolCan", CustomCategories.LiquidContainer},
        PetrolCanWater = {"Base.PetrolCanWater", CustomCategories.LiquidContainer},
        Coco_WaterGallonEmpty = {"CocoLiquidOverhaulItems.Coco_WaterGallonEmpty", CustomCategories.LiquidContainer},
        Coco_WaterGallonFull = {"CocoLiquidOverhaulItems.Coco_WaterGallonFull", CustomCategories.LiquidContainer},
        Coco_WaterGallonPetrol = {"CocoLiquidOverhaulItems.Coco_WaterGallonPetrol", CustomCategories.LiquidContainer},
        Coco_LargeEmptyPetrolCan = {"CocoLiquidOverhaulItems.Coco_LargeEmptyPetrolCan", CustomCategories.LiquidContainer},
        Coco_LargePetrolCan = {"CocoLiquidOverhaulItems.Coco_LargePetrolCan", CustomCategories.LiquidContainer},
        Coco_LargePetrolCanWater = {"CocoLiquidOverhaulItems.Coco_LargePetrolCanWater", CustomCategories.LiquidContainer},
    },

    ---Custom fuel items list
    CustomFuelItems = {},
}

return ModSettings
