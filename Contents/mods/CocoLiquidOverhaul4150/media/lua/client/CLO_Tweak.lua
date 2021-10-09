local liquidContainerCategory = "Coco_Liquid_Container"

local items = {
	Coco_WaterGallonEmpty = {"CocoLiquidOverhaulItems.Coco_WaterGallonEmpty", liquidContainerCategory},
	Coco_WaterGallonFull = {"CocoLiquidOverhaulItems.Coco_WaterGallonFull", liquidContainerCategory},
	Coco_WaterGallonPetrol = {"CocoLiquidOverhaulItems.Coco_WaterGallonPetrol", liquidContainerCategory}
}

function CLO_TweakItems()
	for _, v in pairs(items) do
		local item = ScriptManager.instance:getItem(v[1])
		if item ~= nil then
			item:DoParam("displaycategory" .. " = " .. v[2])
		end
	end
end
