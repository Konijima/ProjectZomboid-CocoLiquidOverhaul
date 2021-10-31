local CustomCategories = {
    LiquidContainer = "Coco_Liquid_Container",
}

--- Mod Settings
CLO_ModSettings = {
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

--- List of Dispenser types
CLO_DispenserTypes = {
    DefaultDispenser = {
        type = "water",
        CustomName = "Dispenser",
        N = "location_business_office_generic_01_57",
        E = "location_business_office_generic_01_48",
        S = "location_business_office_generic_01_49",
        W = "location_business_office_generic_01_56"
    },
    EmptyDispenser = {
        type = "none",
        CustomName = "Empty Dispenser",
        N = "coco_liquid_overhaul_01_0",
        E = "coco_liquid_overhaul_01_1",
        S = "coco_liquid_overhaul_01_2",
        W = "coco_liquid_overhaul_01_3"
    },
    EmptyBottleDispenser = {
        type = "none",
        CustomName = "Empty Bottle Dispenser",
        N = "coco_liquid_overhaul_01_4",
        E = "coco_liquid_overhaul_01_5",
        S = "coco_liquid_overhaul_01_6",
        W = "coco_liquid_overhaul_01_7"
    },
    WaterDispenser = {
        type = "water",
        CustomName = "Water Dispenser",
        N = "coco_liquid_overhaul_01_8",
        E = "coco_liquid_overhaul_01_9",
        S = "coco_liquid_overhaul_01_10",
        W = "coco_liquid_overhaul_01_11"
    },
    FuelDispenser = {
        type = "fuel",
        CustomName = "Fuel Dispenser",
        N = "coco_liquid_overhaul_01_12",
        E = "coco_liquid_overhaul_01_13",
        S = "coco_liquid_overhaul_01_14",
        W = "coco_liquid_overhaul_01_15"
    },
}