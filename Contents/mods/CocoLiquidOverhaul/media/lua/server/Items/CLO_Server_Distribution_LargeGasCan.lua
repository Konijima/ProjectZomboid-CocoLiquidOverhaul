require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"

-- ProceduralDistributions

-- StoreShelfMechanics
table.insert(ProceduralDistributions.list.StoreShelfMechanics.items, "CocoLiquidOverhaulItems.Coco_LargeEmptyPetrolCan")
table.insert(ProceduralDistributions.list.StoreShelfMechanics.items, 5)

-- ArmySurplusMisc
table.insert(ProceduralDistributions.list.ArmySurplusMisc.items, "CocoLiquidOverhaulItems.Coco_LargePetrolCan")
table.insert(ProceduralDistributions.list.ArmySurplusMisc.items, 1)

-- GarageMechanic
table.insert(ProceduralDistributions.list.GarageMechanics.items, "CocoLiquidOverhaulItems.Coco_LargeEmptyPetrolCan")
table.insert(ProceduralDistributions.list.GarageMechanics.items, 3)

table.insert(SuburbsDistributions["all"]["bin"].items, "CocoLiquidOverhaulItems.Coco_LargeEmptyPetrolCan")
table.insert(SuburbsDistributions["all"]["bin"].items, 0.5)
