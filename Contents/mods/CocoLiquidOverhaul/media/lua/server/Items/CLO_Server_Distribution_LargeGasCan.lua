require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"

-- ITEMS
--- CocoLiquidOverhaulItems.Coco_LargeEmptyPetrolCan
--- CocoLiquidOverhaulItems.Coco_LargePetrolCan

-- LOCATIONS
--- all
--- shed
--- garagestorage
--- garage
--- storageunit
--- gasstore
--- gasstorage
--- armyhanger
--- armyhanger

--- ProceduralDistributions

-- StoreShelfMechanics
table.insert(ProceduralDistributions.list.StoreShelfMechanics.items, "CocoLiquidOverhaulItems.Coco_LargeEmptyPetrolCan")
table.insert(ProceduralDistributions.list.StoreShelfMechanics.items, 5)

-- GarageMechanic
table.insert(ProceduralDistributions.list.GarageMechanic.items, "CocoLiquidOverhaulItems.Coco_LargeEmptyPetrolCan")
table.insert(ProceduralDistributions.list.GarageMechanic.items, 3)

--- SuburbsDistributions

-- all
table.insert(SuburbsDistributions["all"]["bin"].items, "CocoLiquidOverhaulItems.Coco_LargeEmptyPetrolCan")
table.insert(SuburbsDistributions["all"]["bin"].items, 0.5)


-- storageunit
--table.insert(SuburbsDistributions["storageunit"]["all"].items, "CocoLiquidOverhaulItems.Coco_LargeEmptyPetrolCan")
--table.insert(SuburbsDistributions["storageunit"]["all"].items, 2)
--table.insert(SuburbsDistributions["storageunit"]["all"].items, "CocoLiquidOverhaulItems.Coco_LargePetrolCan")
--table.insert(SuburbsDistributions["storageunit"]["all"].items, 1.5)

-- armyhanger
--table.insert(SuburbsDistributions["armyhanger"]["metal_shelves"].items, "CocoLiquidOverhaulItems.Coco_LargePetrolCan")
--table.insert(SuburbsDistributions["armyhanger"]["metal_shelves"].items, 1)

