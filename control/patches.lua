local RESOURCE = {IRON = 1, COPPER = 2, COAL = 3, STONE = 4, OIL = 5, URANIUM = 6}

BuildablePatch = {
	tiles = nil,
	tilesByKey = nil,
	resources = nil,
	cannotFinish = false,
	minX = nil,
	maxX = nil,
	minY = nil,
	maxY = nil,
	centerX = nil,
	centerY = nil,
	dist = nil
}

function BuildablePatch:new(o)
	prodHubs.logF("BuildablePatch:new", {o}, 2)
	o = o or {}
	o.tiles = o.tiles or {}
	o.tilesByKey = o.tilesByKey or {}
	o.resources = o.resources or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function BuildablePatch:tileKey(x,y)
	prodHubs.logF("BuildablePatch:tileKey:new", {x,y}, 2)
	return string.format("%.0f,%.0f", x, y)
end

function BuildablePatch:addTile(x, y, surface)
	prodHubs.logF("BuildablePatch:addTile", {x,y,surface}, 2)
	tileKey = self:tileKey(x,y)
	if self.tilesByKey[tileKey] == nil then
		self.tilesByKey[tileKey] = {x=x, y=y}
		table.insert(self.tiles, {x=x, y=y})
		self:findNeighbours(x, y, surface)
		self.minX = math.min(self.minX or x, x)
		self.maxX = math.max(self.maxX or x, x)
		self.minY = math.min(self.minY or y, y)
		self.maxY = math.max(self.maxY or y, y)
		return true
	end
	return false
end

function BuildablePatch:hasTile(x, y)
	prodHubs.logF("BuildablePatch:hasTile", {x,y}, 2)
	return (self.tilesByKey[BuildablePatch.tileKey(self,x,y)] ~= nil)	--Allows this function to be called with self that is missing the functions
end

function BuildablePatch:findNeighbours(x, y, surface)
	prodHubs.logF("BuildablePatch:findNeighbours", {x,y,surface}, 2)
	for dx = -1,1 do
		for dy = -1,1 do
			if (dy == 0 and dx ~= 0) or (dy ~= 0 and dx == 0)  then
				findX = x + dx
				findY = y + dy
				tile = surface.get_tile(findX, findY)
				if tile.valid then
					if string.find(tile.name, "red") or string.find(tile.name, "sand") then self:addTile(findX, findY, surface) end
				else
					self.cannotFinish = true
				end
			end
		end
	end
end

function BuildablePatch:calculateCenter()
	prodHubs.logF("BuildablePatch:calculateCenter", {}, 2)
	self.centerX = (self.maxX - self.minX)/2+self.minX
	self.centerY = (self.maxY - self.minY)/2+self.minY
	self.dist = math.sqrt(self.centerX*self.centerX + self.centerY*self.centerY)
end

function BuildablePatch:generateResources(surface, isStartingPatch)
	prodHubs.logF("BuildablePatch:generateResources", {surface, isStartingPatch}, 1)
	if isStartingPatch then
		randomTiles1 = self:getRandomConnectedTiles(4)
		randomTiles2 = self:getRandomConnectedTiles(4)
		randomTiles3 = self:getRandomConnectedTiles(4)
		randomTiles4 = self:getRandomConnectedTiles(4)
		for i, v in ipairs(randomTiles1) do
			local resource = surface.create_entity{name="iron-ore", position = {x=v.x, y=v.y}, amount = 100, initial_amount=100, force = "neutral"}
			table.insert(self.resources, {originalInitialAmount = resource.initial_amount, originalAmount = resource.amount, minerMultiplier = 1, entity = resource})
		end
		for i, v in ipairs(randomTiles2) do
			local resource = surface.create_entity{name="coal", position = {x=v.x, y=v.y}, amount = 100, initial_amount=100, force = "neutral"}
			table.insert(self.resources, {originalInitialAmount = resource.initial_amount, originalAmount = resource.amount, minerMultiplier = 1, entity = resource})
		end
		for i, v in ipairs(randomTiles3) do
			local resource = surface.create_entity{name="stone", position = {x=v.x, y=v.y}, amount = 100, initial_amount=100, force = "neutral"}
			table.insert(self.resources, {originalInitialAmount = resource.initial_amount, originalAmount = resource.amount, minerMultiplier = 1, entity = resource})
		end
		for i, v in ipairs(randomTiles4) do
			local resource = surface.create_entity{name="copper-ore", position = {x=v.x, y=v.y}, amount = 100, initial_amount=100, force = "neutral"}
			table.insert(self.resources, {originalInitialAmount = resource.initial_amount, originalAmount = resource.amount, minerMultiplier = 1, entity = resource})
		end
	else
		availableResources = {RESOURCE.IRON, RESOURCE.COPPER, RESOURCE.COAL, RESOURCE.STONE}
		if self.dist > 500 then table.insert(availableResources, RESOURCE.OIL) end
		if self.dist > 1000 then table.insert(availableResources, RESOURCE.URANIUM) end
		randomResource = global.rng(#availableResources)
		
		resourceCount = global.rng(20) + 10
		
		if randomResource ~= RESOURCE.OIL then
			randomTiles = self:getRandomConnectedTiles(resourceCount)
		end
		if randomResource == RESOURCE.IRON then
			resourceName="iron-ore"
		end
		if randomResource == RESOURCE.COPPER then
			resourceName="copper-ore"
		end
		if randomResource == RESOURCE.STONE then
			resourceName="stone"
		end
		if randomResource == RESOURCE.COAL then
			resourceName="coal"
		end
		if randomResource == RESOURCE.OIL then
			resourceCount = global.rng(5) + 2
			resourceName="crude-oil"
			randomTiles = self:getRandomTiles(resourceCount)
		end
		if randomResource == RESOURCE.URANIUM then
			resourceName="uranium-ore"
		end
		for i, v in ipairs(randomTiles) do
			local resource = surface.create_entity{name=resourceName, position = {x=v.x, y=v.y}, amount = 100, initial_amount=100, force = "neutral"}
			table.insert(self.resources, {originalInitialAmount = resource.initial_amount, originalAmount = resource.amount, minerMultiplier = 1, entity = resource})
		end
	end
end

function BuildablePatch:getRandomConnectedTiles(count)
	prodHubs.logF("BuildablePatch:getRandomConnectedTiles", {count}, 2)
	count = math.min(count, #(self.tiles))
	tilesByKey = {}
	tiles = {}
	availableTiles = {}
	availableTilesByKey = {}
	first = true
	while #tiles < count do
		if first then
			-- Get first random tile
			randomTileId = global.rng(#(self.tiles))
			newTile = self.tiles[randomTileId]
			newTileKey = self:tileKey(newTile.x, newTile.y)
			table.insert(tiles, newTile)
			tilesByKey[newTileKey] = newTile
			first = false
		else
			-- Get next random tile
			randomTileId = global.rng(#availableTiles)
			newTile = availableTiles[randomTileId]
			newTileKey = self:tileKey(newTile.x, newTile.y)
			table.insert(tiles, newTile)
			tilesByKey[newTileKey] = newTile
			table.remove(availableTiles, randomTileId)
			availableTilesByKey[newTileKey] = nil
		end
		-- Get available tiles around last added tile
		for dx = -1,1 do
			for dy = -1,1 do
				if (dy == 0 and dx ~= 0) or (dy ~= 0 and dx == 0)  then
					testTileKey = self:tileKey(newTile.x+dx, newTile.y+dy)
					if self.tilesByKey[testTileKey] ~= nil and tilesByKey[testTileKey] == nil and availableTilesByKey[testTileKey] == nil then
						availableTilesByKey[testTileKey] = self.tilesByKey[testTileKey]
						table.insert(availableTiles, self.tilesByKey[testTileKey])
					end
				end
			end
		end
	end
	return tiles
end

function BuildablePatch:getRandomTiles(count)
	prodHubs.logF("BuildablePatch:getRandomTiles", {count}, 2)
	count = math.min(count, #(self.tiles))
	tilesByKey = {}
	tiles = {}
	availableTiles = table.deepcopy(self.tiles)
	availableTilesByKey = table.deepcopy(self.tilesByKey)
	while #tiles < count do
		randomTileId = global.rng(#availableTiles)
		newTile = availableTiles[randomTileId]
		newTileKey = self:tileKey(newTile.x, newTile.y)
		table.insert(tiles, newTile)
		tilesByKey[newTileKey] = newTile
		table.remove(availableTiles, randomTileId)
		availableTilesByKey[newTileKey] = nil
	end
	return tiles
end

function prodHubs.generateWorldMap()
	prodHubs.logF("generateWorldMap", {})
	local surface = game.surfaces["nauvis"]
	surface.clear(true)
	local mgs = surface.map_gen_settings
  prodHubs.addEvent(prodHubs.ticksPerSecond * 10, "adjustPopulation", {})
	--mgs.cliff_settings = {cliff_elevation_0 = 1024}
	mgs.property_expression_names["tile:grass-1:probability"] = "unBuildableTerrain"
	mgs.property_expression_names["tile:grass-2:probability"] = "zero"
	mgs.property_expression_names["tile:grass-3:probability"] = "zero"
	mgs.property_expression_names["tile:grass-4:probability"] = "zero"
	mgs.property_expression_names["tile:red-desert-0:probability"] = "spots"
	mgs.property_expression_names["tile:red-desert-1:probability"] = "zero"
	mgs.property_expression_names["tile:red-desert-2:probability"] = "zero"
	mgs.property_expression_names["tile:red-desert-3:probability"] = "zero"
	mgs.property_expression_names["tile:dirt-1:probability"] = "zero"
	mgs.property_expression_names["tile:dirt-2:probability"] = "zero"
	mgs.property_expression_names["tile:dirt-3:probability"] = "zero"
	mgs.property_expression_names["tile:dirt-4:probability"] = "zero"
	mgs.property_expression_names["tile:dirt-5:probability"] = "zero"
	mgs.property_expression_names["tile:dirt-6:probability"] = "zero"
	mgs.property_expression_names["tile:dirt-7:probability"] = "zero"
	mgs.property_expression_names["tile:sand-1:probability"] = "zero"
	mgs.property_expression_names["tile:sand-2:probability"] = "aroundSpots"
	mgs.property_expression_names["tile:sand-3:probability"] = "zero"
	mgs.property_expression_names["tile:dry-dirt:probability"] = "zero"
	mgs.property_expression_names["entity:coal:probability"] = "zero"
	mgs.property_expression_names["entity:iron-ore:probability"] = "zero"
	mgs.property_expression_names["entity:copper-ore:probability"] = "zero"
	mgs.property_expression_names["entity:stone:probability"] = "zero"
	mgs.property_expression_names["entity:uranium-ore:probability"] = "zero"
	mgs.property_expression_names["entity:crude-oil:probability"] = "zero"
	
	global.rng = game.create_random_generator()
	global.rng.re_seed(mgs.seed)
	surface.map_gen_settings = mgs
end

function prodHubs.onChunkGenerated(surface, area)
	prodHubs.logF("onChunkGenerated", {surface, area}, 2)
	patches = {}
	minY = area.left_top.y
	maxY = area.right_bottom.y-1
	minX = area.left_top.x
	maxX = area.right_bottom.x-1
	startingPatch = nil
	for y = minY, maxY do
		for x = minX, maxX do
			if string.find(surface.get_tile(x, y).name, "red") or string.find(surface.get_tile(x, y).name, "sand") then
				alreadyFound = false
				for _, v in ipairs(patches) do
					if alreadyFound then break end
					if v:hasTile(x,y) then
						alreadyFound = true
					end
				end
				for _, v in ipairs(global.buildablePatches) do
					if alreadyFound then break end
					if BuildablePatch.hasTile(v,x,y) then alreadyFound = true end
				end
				if not alreadyFound then
					newPatch = BuildablePatch:new()
					newPatch:addTile(x, y, surface)
					newPatch:calculateCenter()
					if not alreadyFound then
						if newPatch.dist < 30 then startingPatch = newPatch end
						table.insert(patches, newPatch)
					end
				end
			end
		end
	end
	for k, v in ipairs(patches) do
		if not v.cannotFinish then 
			if #(v.tiles) < 100 then
				removeTiles = {}
				for i,v in ipairs(v.tiles) do
					table.insert(removeTiles, {position={x=v.x, y=v.y}, name = "grass-1"})
				end
				surface.set_tiles(removeTiles, true, false, false, false)
			else
				v:generateResources(surface, v == startingPatch)
				local newPatch = {level=1,population=100,maxPopulation=200,workingPopulation=0,fightingPopulation=0,freePopulation=100,popGrowthMode = prodHubs.popGrowthMode.GROW,popGrowthLimit=100, suppliedEnteties={}, vaults={}, resources=v.resources, centerX=v.centerX, centerY=v.centerY, tiles=v.tiles, tilesByKey=v.tilesByKey}
				prodHubs.calculateGatherSpeed(newPatch)
				table.insert(global.buildablePatches, newPatch)
				if startingPatch then
					for _, player in pairs(game.players) do
						player.insert{name="prodHubs-vault", count=1}
					end
				end
			end
		end
	end	
end

