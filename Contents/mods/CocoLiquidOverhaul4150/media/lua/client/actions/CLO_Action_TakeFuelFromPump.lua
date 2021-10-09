CLO_Actions = CLO_Actions or {}

require "TimedActions/ISBaseTimedAction"
local ISTakeFuelFromPump = ISBaseTimedAction:derive("ISTakeFuelFromPump")

---isValid
function ISTakeFuelFromPump:isValid()
	local pumpCurrent = tonumber(self.square:getProperties():Val("fuelAmount"))
	return pumpCurrent > 0
end

---waitToStart
function ISTakeFuelFromPump:waitToStart()
	self.character:faceLocation(self.square:getX(), self.square:getY())
	return self.character:shouldBeTurning()
end

---start
function ISTakeFuelFromPump:start()
	self.petrolCan:setJobType(getText("ContextMenu_TakeGasFromPump"))
	self.petrolCan:setJobDelta(0.0)

	-- let's transform an empty can into an empty petrol can
	if self.petrolCan:getType() == "EmptyPetrolCan" or self.petrolCan:getType() == "Coco_WaterGallonEmpty" then
		local emptyCan = self.petrolCan
		if emptyCan:getType() == "EmptyPetrolCan" then
			self.petrolCan = self.character:getInventory():AddItem("Base.PetrolCan")
		else
			self.petrolCan = self.character:getInventory():AddItem("CocoLiquidOverhaulItems.Coco_WaterGallonPetrol")
		end
		self.petrolCan:setUsedDelta(0)

		if self.character:getPrimaryHandItem() == emptyCan then
			self.character:setPrimaryHandItem(nil)
		end
		if self.character:getSecondaryHandItem() == emptyCan then
			self.character:setSecondaryHandItem(self.petrolCan)
		end

		self.character:getInventory():Remove(emptyCan)
	end

	local pumpCurrent = 1000 + tonumber(self.square:getProperties():Val("fuelAmount"))
	local itemCurrent = math.floor(self.petrolCan:getUsedDelta() / self.petrolCan:getUseDelta() + 0.001)
	local itemMax = math.floor(1 / self.petrolCan:getUseDelta() + 0.001)
	local take = math.min(pumpCurrent, itemMax - itemCurrent)
	self.action:setTime(take * 50)
	self.itemStart = itemCurrent
	self.itemTarget = itemCurrent + take

	self:setActionAnim("TakeGasFromPump")
	self:setOverrideHandModels(nil, self.petrolCan:getStaticModel())
end

---stop
function ISTakeFuelFromPump:stop()
	self.petrolCan:setJobDelta(0.0)
	ISBaseTimedAction.stop(self)
end

---update
function ISTakeFuelFromPump:update()
	self.petrolCan:setJobDelta(self:getJobDelta())
	--self.character:faceLocation(self.square:getX(), self.square:getY())

	local actionCurrent = math.floor(self.itemStart + (self.itemTarget - self.itemStart) * self:getJobDelta() + 0.001)
	local itemCurrent = math.floor(self.petrolCan:getUsedDelta() / self.petrolCan:getUseDelta() + 0.001)
	if actionCurrent > itemCurrent then
		-- FIXME: sync in multiplayer
		local pumpCurrent = tonumber(self.square:getProperties():Val("fuelAmount"))
		self.square:getProperties():Set("fuelAmount", tostring(pumpCurrent - (actionCurrent - itemCurrent)))

		self.petrolCan:setUsedDelta(actionCurrent * self.petrolCan:getUseDelta() + 0.1)
	end

	self.character:setMetabolicTarget(Metabolics.LightWork)
end

---perform
function ISTakeFuelFromPump:perform()
	self.petrolCan:setJobDelta(0.0)

	local itemCurrent = math.floor(self.petrolCan:getUsedDelta() / self.petrolCan:getUseDelta() + 0.001)
	if self.itemTarget > itemCurrent then
		self.petrolCan:setUsedDelta(self.itemTarget * self.petrolCan:getUseDelta())
		-- FIXME: sync in multiplayer
		local pumpCurrent = tonumber(self.square:getProperties():Val("fuelAmount"))
		self.square:getProperties():Set("fuelAmount", tostring(pumpCurrent + (self.itemTarget - itemCurrent)))
	end

	ISBaseTimedAction.perform(self)
end

---new
---@param playerObj IsoPlayer
---@param square IsoGridSquare
---@param petrolCan InventoryItem
function ISTakeFuelFromPump:new(playerObj, square, petrolCan, maxTime)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = playerObj
	o.square = square
	o.petrolCan = petrolCan
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = maxTime
	return o
end

CLO_Actions.ISTakeFuelFromPump = ISTakeFuelFromPump
