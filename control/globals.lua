prodHubs = {}
prodHubs.debug = 2												-- Debug 1 = level 0. Debug 2 = level 0 + args. Debug 3 = level 1...
																					-- Debug Level 0 = Called, 1 = Called often, 2 = Called periodically
prodHubs.worldMapGenerated = false

function prodHubs.log(var, tab)
	tab = tab or ""
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
	local event = prodHubs.eventQueue
	while event and event.tick < tick do
		lastEvent = event
		event = event.next
	end
	if lastEvent == nil then
		prodHubs.eventQueue = {next = event, tick = tick, f = f, args = args}
	else
		lastEvent.next = {next = event, tick = tick, f = f, args = args}
	end
end

function prodHubs.callEvent(tick)
	if prodHubs.eventQueue and prodHubs.eventQueue.tick <= tick then
		prodHubs.logF("callEvent", {tick}, 1)
		local a = prodHubs.eventQueue.args
		prodHubs.eventQueue.f(a[1], a[2], a[3], a[4], a[5], a[6])
		prodHubs.eventQueue = prodHubs.eventQueue.next
	end
end