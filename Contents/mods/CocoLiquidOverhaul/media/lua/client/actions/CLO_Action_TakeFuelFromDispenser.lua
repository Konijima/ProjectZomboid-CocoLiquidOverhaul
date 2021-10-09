CLO_Actions = CLO_Actions or {}

require "TimedActions/ISBaseTimedAction"
local ISTakeFuelFromDispenser = ISBaseTimedAction:derive("ISTakeFuelFromDispenser")

---isValid
function ISTakeFuelFromDispenser:isValid()
	local pumpCurrent = CLO_Object.GetObjectFuelAmount(self.dispenserObj)
	return pumpCurrent > 0
end

---waitToStart
function ISTakeFuelFromDispenser:waitToStart()
	self.character:faceLocation(self.square:getX(), self.square:getY())
	return self.character:shouldBeTurning()
end

---start
function ISTakeFuelFromDispenser:start()
	self.petrolCan:setJobType(getText("ContextMenu_TakeGasFromPump"))
	self.petrolCan:setJobDelta(0.0)

	-- let's transform an empty can into an empty petrol can
	local itemType = self.petrolCan:getType()
	if itemType == "EmptyPetrolCan" or itemType == "Coco_WaterGallonEmpty" or itemType == "Coco_LargeEmptyPetrolCan" then
		local isPrimary = self.petrolCan == self.character:getPrimaryHandItem()
		local emptyCan = self.petrolCan
		if itemType == "EmptyPetrolCan" then
			self.petrolCan = self.character:getInventory():AddItem("Base.PetrolCan")
		elseif itemType == "Coco_WaterGallonEmpty" then
			self.petrolCan = self.character:getInventory():AddItem("CocoLiquidOverhaulItems.Coco_WaterGallonPetrol")
		elseif itemType == "Coco_LargeEmptyPetrolCan" then
			self.petrolCan = self.character:getInventory():AddItem("CocoLiquidOverhaulItems.Coco_LargePetrolCan")
		end
		self.petrolCan:setUsedDelta(0)

		if isPrimary then
			self.character:setPrimaryHandItem(self.petrolCan)
		else
			self.character:setSecondaryHandItem(self.petrolCan)
		end
		self.character:getInventory():Remove(emptyCan)
	end

	local pumpCurrent = CLO_Object.GetObjectFuelAmount(self.dispenserObj)
	local itemCurrent = math.floor(self.petrolCan:getUsedDelta() / self.petrolCan:getUseDelta() + 0.001)
	local itemMax = math.floor(1 / self.petrolCan:getUseDelta() + 0.001)
	local take = math.min(pumpCurrent, itemMax - itemCurrent)
	self.action:setTime(take * 30)
	self.itemStart = itemCurrent
	self.itemTarget = itemCurrent + take

	self:setActionAnim("fill_container_tap")
	self:setOverrideHandModels(nil, self.petrolCan:getStaticModel())
end

---stop
function ISTakeFuelFromDispenser:stop()
	self.petrolCan:setJobDelta(0.0)
	ISBaseTimedAction.stop(self)
end

---update
function ISTakeFuelFromDispenser:update()
	self.petrolCan:setJobDelta(self:getJobDelta())
	self.character:faceLocation(self.square:getX(), self.square:getY())

	local actionCurrent = math.floor(self.itemStart + (self.itemTarget - self.itemStart) * self:getJobDelta() + 0.001)
	local itemCurrent = math.floor(self.petrolCan:getUsedDelta() / self.petrolCan:getUseDelta() + 0.001)
	if actionCurrent > itemCurrent then
		-- FIXME: sync in multiplayer
		local pumpCurrent = CLO_Object.GetObjectFuelAmount(self.dispenserObj) - (actionCurrent - itemCurrent)
		CLO_Print("Fuel: " .. tostring(pumpCurrent) .. "/" .. tostring(itemCurrent))

		if pumpCurrent <= 0.01 then
			CLO_Dispenser.TransformDispenserOnSquare(self.square, CLO_DispenserTypes.EmptyBottleDispenser, 0, false)
			ISBaseTimedAction.stop(self)
			return
		else
			CLO_Object.SetObjectFuelAmount(self.dispenserObj, pumpCurrent)
		end

		self.petrolCan:setUsedDelta(actionCurrent * self.petrolCan:getUseDelta())
	end

	self.character:setMetabolicTarget(Metabolics.LightWork)
end

---perform
function ISTakeFuelFromDispenser:perform()
	self.petrolCan:setJobDelta(0.0)

	local itemCurrent = math.floor(self.petrolCan:getUsedDelta() / self.petrolCan:getUseDelta() + 0.001)
	if self.itemTarget > itemCurrent then
		self.petrolCan:setUsedDelta(self.itemTarget * self.petrolCan:getUseDelta())
		-- FIXME: sync in multiplayer

		local pumpCurrent = CLO_Object.GetObjectFuelAmount(self.dispenserObj) + (self.itemTarget - itemCurrent)
		if pumpCurrent <= 0.01 then
			CLO_Dispenser.TransformDispenserOnSquare(self.square, CLO_DispenserTypes.EmptyBottleDispenser, 0, false)
		else
			CLO_Object.SetObjectFuelAmount(self.dispenserObj, pumpCurrent)
		end
	end

	ISBaseTimedAction.perform(self)
end

---new
---@param playerObj IsoPlayer
---@param square IsoGridSquare
---@param petrolCan InventoryItem
function ISTakeFuelFromDispenser:new(playerObj, dispenserObj, petrolCan, maxTime)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = playerObj
	o.dispenserObj = dispenserObj
	o.square = dispenserObj:getSquare()
	o.petrolCan = petrolCan
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = maxTime
	return o
end

CLO_Actions.ISTakeFuelFromDispenser = ISTakeFuelFromDispenser
