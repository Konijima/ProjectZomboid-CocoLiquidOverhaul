CLO_Actions = CLO_Actions or {}

require "TimedActions/ISBaseTimedAction"
local ISPourInto = ISBaseTimedAction:derive("ISPourInto")

---isValid
function ISPourInto:isValid()
	return true
end

---start
function ISPourInto:start()
	self.itemFrom:setJobType(getText("IGUI_JobType_PourOut"))
	self.itemTo:setJobType(getText("IGUI_JobType_PourIn"))

	self.itemFrom:setJobDelta(0.0)
	self.itemTo:setJobDelta(0.0)

	--self.character:playSound("GetWater")
	self:setOverrideHandModels(self.itemFrom:getStaticModel(), nil)
	self:setActionAnim("Pour")
end

---stop
function ISPourInto:stop()
	ISBaseTimedAction.stop(self)
	if self.itemFrom ~= nil then
		self.itemFrom:setJobDelta(0.0)
	end
	if self.itemTo ~= nil then
		self.itemTo:setJobDelta(0.0)
	end
end

---update
function ISPourInto:update()
	if self.itemFrom ~= nil and self.itemTo ~= nil then
		self.itemFrom:setJobDelta(self:getJobDelta())
		self.itemFrom:setUsedDelta(self.itemFromBeginDelta + ((self.itemFromEndingDelta - self.itemFromBeginDelta) * self:getJobDelta()))

		self.itemTo:setJobDelta(self:getJobDelta())
		self.itemTo:setUsedDelta(self.itemToBeginDelta + ((self.itemToEndingDelta - self.itemToBeginDelta) * self:getJobDelta()))
	end
end

---perform
function ISPourInto:perform()
	if self.itemFrom ~= nil and self.itemTo ~= nil then
		self.itemFrom:getContainer():setDrawDirty(true)
		self.itemFrom:setJobDelta(0.0)
		self.itemTo:setJobDelta(0.0)
		if self.itemTo:getContainer() then
			self.itemTo:getContainer():setDrawDirty(true)
		end

		if self.itemFromEndingDelta == 0 then
			self.itemFrom:setUsedDelta(0)
			self.itemFrom:Use()
		else
			self.itemFrom:setUsedDelta(self.itemFromEndingDelta)
		end

		self.itemTo:setUsedDelta(self.itemToEndingDelta)
		self.itemTo:updateWeight()
	end

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

---new
---@param playerObj IsoPlayer
---@param itemFrom InventoryItem
---@param itemTo InventoryItem
function ISPourInto:new(playerObj, itemFrom, itemTo, itemFromEndingDelta, itemToEndingDelta)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = playerObj
	o.itemFrom = itemFrom
	o.itemFromBeginDelta = itemFrom:getUsedDelta()
	o.itemFromEndingDelta = itemFromEndingDelta
	o.itemTo = itemTo
	o.itemToBeginDelta = itemTo:getUsedDelta()
	o.itemToEndingDelta = itemToEndingDelta
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = ((itemFrom:getUsedDelta() - itemFromEndingDelta) / itemFrom:getUseDelta()) * 5
	return o
end

CLO_Actions.ISPourInto = ISPourInto
