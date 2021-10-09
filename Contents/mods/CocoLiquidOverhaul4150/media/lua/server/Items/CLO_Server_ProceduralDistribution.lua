require "Items/ProceduralDistributions"

-- ITEMS
--- CocoLiquidOverhaulItems.Coco_WaterGallonEmpty
--- CocoLiquidOverhaulItems.Coco_WaterGallonFull

--- FridgeBottles
table.insert(ProceduralDistributions["list"]["FridgeBottles"].items, "CocoLiquidOverhaulItems.Coco_WaterGallonFull")
table.insert(ProceduralDistributions["list"]["FridgeBottles"].items, 1)

--- GigamartBottles
table.insert(ProceduralDistributions["list"]["GigamartBottles"].items, "CocoLiquidOverhaulItems.Coco_WaterGallonFull")
table.insert(ProceduralDistributions["list"]["GigamartBottles"].items, 3)

--- KitchenBottles
table.insert(ProceduralDistributions["list"]["KitchenBottles"].items, "CocoLiquidOverhaulItems.Coco_WaterGallonFull")
table.insert(ProceduralDistributions["list"]["KitchenBottles"].items, 2)
