require("util")
prodHubs = {}
prodHubs.debug = 0												-- Debug 1 = level 0. Debug 2 = level 0 + args. Debug 3 = level 1...
																					-- Debug Level 0 = Called, 1 = Called often, 2 = Called periodically
prodHubs.ticksPerSecond = 60							-- The speed at which factorio runs
prodHubs.popGrowthMode = {STABILE = 0, GROW = 1, BOOST = 2}
prodHubs.batchCost = {
	{pop = 0, items = {{name = "iron-stick", count = 5},{name = "copper-cable", count = 10}}},
	{pop = 1700, items = {{name = "electronic-circuit", count = 10},{name = "stone-brick", count = 50}}},
	{pop = 3700, items = {{name = "advanced-circuit", count = 10}}},
	{pop = 5000, items = {{name = "engine-unit", count = 5}}},
	{pop = 6500, items = {{name = "processing-unit", count = 1},{name = "concrete", count = 100}}}
}

if global and not global.initialized then 
	global.worldMapGenerated = false
	global.buildablePatches = {}
	global.entityStats = {}
	global.gui = {}
	global.translations	= {}
	global.unitGroups = {}
	global.initialized = true
end

function prodHubs.log(var, tab)
	tab = tab or ""
	if string.len(tab) > 6 then return tab .. "*max depth*\n" end -- To avoid lockups with circular references
	local ret = ""
	if type(var) == "table" then
		for k, v in pairs(var) do
			if type(v) == "table" then
				ret = ret .. tab .. "  [(" .. type(k) .. ")" .. tostring(k) .. "]:\n"
				ret = ret .. prodHubs.log(v, tab .. "  ")
			else
				ret = ret .. tab .. "  [(" .. type(k) .. ")" .. tostring(k) .. "]: (" .. type(v) .. ")" .. tostring(v) .. "\n"
			end
		end
	else
		ret = ret .. tab .. "  (" .. type(var) .. ")" .. tostring(var) .. "\n"
	end
	return ret
end

function prodHubs.logF(name, args, level)
	if level == nil then level = 0 end
	if prodHubs.debug > 2*level then
		log("Function: " .. name)
	end
	if prodHubs.debug > 2*level+1 then
		for _, arg in pairs(args) do
			log(prodHubs.log(arg))
		end
	end
end

function prodHubs.addEvent(tick, f, args)
	prodHubs.logF("addEvent", {tick, f, args}, 1)
	local lastEvent = nil
	local event = global.eventQueue
	tick = tick + game.tick
	while event and event.tick < tick do
		lastEvent = event
		event = event.next
	end
	if lastEvent == nil then
		global.eventQueue = {next = event, tick = tick, f = f, args = args}
	else
		lastEvent.next = {next = event, tick = tick, f = f, args = args}
	end
end

function prodHubs.callEvent(tick)
	if global.eventQueue and global.eventQueue.tick <= tick then
		prodHubs.logF("callEvent", {tick}, 1)
		local a = global.eventQueue.args
		prodHubs[global.eventQueue.f](a[1], a[2], a[3], a[4], a[5], a[6])
		global.eventQueue = global.eventQueue.next
	end
end

function prodHubs.removeValue(array, value)
	for index, arr_value in pairs(array) do
		if arr_value == value then
			table.remove(array, index)
			return
		end
	end
end
