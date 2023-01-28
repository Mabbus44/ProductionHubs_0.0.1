BuildablePatch = {
	tiles = {},
	tileCount = 0,
	minX = nil,
	maxX = nil,
	minY = nil,
	maxY = nil
}

function BuildablePatch:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function BuildablePatch:tileId(x,y)
	return string.format("%.0f,%.0f", x, y)
end

function BuildablePatch:addTile(x, y, surface)
	tileId = self:tileId(x,y)
	if self.tiles[tileId] == nil then
		self.tiles[tileId] = buildablePatchTile:new({x=x, y=y, parent=self})
		self.tiles[tileId]:findNeighbours(surface)
		return true
	end
	return false
end

function BuildablePatch:hasTile(x, y)
	return (self.tiles[self:tileId(x,y)] ~= nil)
end

local BuildablePatchTile = {
	x=0, y=0, parent = nil,
}

local buildablePatchTile:new(0)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

local buildablePatchTile:findNeighbours(surface)
	findX = self.x + 1
	findY = self.y
	if string.find(surface.get_tile(findX, findY).name, "red") then
		parent:addTile(findX, findY, surface)
	end
	findX = self.x - 1
	if string.find(surface.get_tile(findX, findY).name, "red") then
		parent:addTile(findX, findY, surface)
	end
	findX = self.x
	findY = self.y + 1
	if string.find(surface.get_tile(findX, findY).name, "red") then
		parent:addTile(findX, findY, surface)
	end
	findY = self.y - 1
	if string.find(surface.get_tile(findX, findY).name, "red") then
		parent:addTile(findX, findY, surface)
	end
end

function prodHubs.generateWorldMap()
	local surface = game.surfaces["nauvis"]
	surface.clear(true)
	local mgs = surface.map_gen_settings

	mgs.autoplace_settings["entity"] = {treat_missing_as_default = false, settings = {}}
	mgs.autoplace_settings["tile"] = {treat_missing_as_default = false, settings = {["dirt-1"] = 0, ["red-desert-0"] = 0, ["sand-1"] = 0, ["sand-2"] = 0, ["sand-3"] = 0, ["grass-1"] = 0, ["grass-2"] = 0, ["grass-3"] = 0, ["grass-4"] = 0}}
	mgs.cliff_settings = {cliff_elevation_0 = 1024}
	mgs.property_expression_names["tile:grass-1:probability"] = "dryLvl1"
	mgs.property_expression_names["tile:grass-2:probability"] = "dryLvl2"
	mgs.property_expression_names["tile:grass-3:probability"] = "dryLvl3"
	mgs.property_expression_names["tile:grass-4:probability"] = "dryLvl4"
	mgs.property_expression_names["tile:sand-3:probability"] = "dryLvl5"
	mgs.property_expression_names["tile:sand-2:probability"] = "dryLvl6"
	mgs.property_expression_names["tile:sand-1:probability"] = "dryLvl7"
	mgs.property_expression_names["tile:grass-1:probability"] = "montain"
	mgs.property_expression_names["tile:dirt-1:probability"] = "forest"
	mgs.property_expression_names["entity:iron-ore:probability"] = "montain"
	
	surface.map_gen_settings = mgs
end

function prodHubs.onChunkGenerated(surface, area)
	patches = {}
	minY = area.left_top.y
	maxY = area.right_bottom.y-1
	minX = area.left_top.x
	maxX = area.right_bottom.x-1
	for y = minY, maxY do
		for x = minX, maxX do
			if string.find(surface.get_tile(x, y).name, "red") then
				alreadyFound = false
				for _, v in ipairs(patches) do
					if v:hasTile(x,y) then
						alreadyFound = true
					end
				end
				if not alreadyFound then
					newPatch = BuildablePatch:new()
					newPatch:addTile(x, y, surface)
					table.insert(patches, newPatch)
				end
			end
		end
	end
end