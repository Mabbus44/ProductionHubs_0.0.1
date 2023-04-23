collision_mask_util = require("collision-mask-util")

-- Edit entity group
function editEntityGroup(entityGroup, getValueForCategryFunction, getValueForCategryFunctionArgs, setPropertyFunction)
	for k,v in pairs(entityGroup) do
		if(type(v) == "string") then
			category = v
			entities = {}
			for addEntity,_ in pairs(data.raw[v]) do
				table.insert(entities, addEntity)
			end
		else
			category = v[1]
			entities = {v[2]}
		end
		val = getValueForCategryFunction(category, getValueForCategryFunctionArgs[1])
		for _,entity in pairs(entities) do
			setPropertyFunction(category, entity, val)
		end
	end
end

-- Unbuildable terrain
function getCategoryMask(category, layer)
	mask = collision_mask_util.get_default_mask(category)
	table.insert(mask, layer)
	return mask
end

function setCollisionMask(category, entity, mask)
	data.raw[category][entity].collision_mask = mask
end

local grassLayer = collision_mask_util.get_first_unused_layer()
table.insert(data.raw["tile"]["grass-1"].collision_mask, grassLayer)
collideWithGrass = {"accumulator", "ammo-turret", "arithmetic-combinator", "artillery-turret", "assembling-machine", "beacon", "boiler", "burner-generator", "constant-combinator", "container", "decider-combinator", "electric-turret", "fluid-turret", "furnace", "generator", "heat-pipe", "inserter", "lab", "lamp", "logistic-container", "mining-drill", "offshore-pump", "pipe", "pipe-to-ground", "programmable-speaker", "pump", "radar", "reactor", "roboport", "rocket-silo", "solar-panel", "splitter", "storage-tank", "transport-belt", "underground-belt"}
editEntityGroup(collideWithGrass, getCategoryMask, {grassLayer}, setCollisionMask)

local sandLayer = collision_mask_util.get_first_unused_layer()
table.insert(data.raw["tile"]["sand-2"].collision_mask, sandLayer)
collideWithSand2 = {"accumulator", "arithmetic-combinator", "artillery-turret", "assembling-machine", "beacon", "boiler", "burner-generator", "constant-combinator", "decider-combinator", "furnace", "generator", "heat-pipe", "lab", "lamp", "mining-drill", "offshore-pump", "programmable-speaker", "radar", "reactor", "roboport", "rocket-silo", "solar-panel"}
editEntityGroup(collideWithSand2, getCategoryMask, {sandLayer}, setCollisionMask)

-- Infinite resources
for k, v in pairs(data.raw.resource) do
	v.infinite = true
	v.minimum = 100
	v.normal = 100
	v.infinite_depletion_amount = 0.1
end

-- Place offshore-pump on land
prodHubs.removeValue(data.raw["offshore-pump"]["offshore-pump"].flags, "filter-directions")
prodHubs.removeValue(data.raw["offshore-pump"]["offshore-pump"].adjacent_tile_collision_test, "water-tile")
prodHubs.removeValue(data.raw["offshore-pump"]["offshore-pump"].fluid_box_tile_collision_test, "ground-tile")
prodHubs.removeValue(data.raw["offshore-pump"]["offshore-pump"].adjacent_tile_collision_mask, "ground-tile")

-- Vault
local vault = table.deepcopy(data.raw["container"]["wooden-chest"])
vault.name = "prodHubs-vault"
vault.localised_name = {"prodHubs-vault"}
vault.damaged_trigger_effect = nil
vault.vehicle_impact_sound = nil
vault.max_health = 1000
vault.corpse = nil
vault.dying_explosion = nil
vault.fast_replaceable_group = nil
vault.open_sound = nil
vault.close_sound = nil
vault.circuit_wire_connection_point = nil
vault.circuit_connector_sprites = nil
vault.circuit_wire_max_distance = nil
vault.picture = {filename=prodHubs.modPath .. "/graphics/vault.png", width = 128, height = 94}
vault.collision_box = {{-1.7, -1.7}, {1.7, 1.7}}
vault.selection_box = {{-2, -2}, {2, 2}}
vault.inventory_type = "with_filters_and_bar"
vault.minable.result = "prodHubs-vault"
table.insert(vault.collision_mask, sandLayer)
data:extend{vault}

-- Electric mining drill
data.raw["mining-drill"]["electric-mining-drill"].mining_drill_radius = 1.49
data.raw["mining-drill"]["electric-mining-drill"].resource_searching_radius = 1.49

-- Picker for picking points on the map
local picker = table.deepcopy(data.raw["container"]["wooden-chest"])
picker.name = "prodHubs-picker"
picker.localised_name = {"prodHubs-picker"}
picker.collision_box = nil
picker.collision_mask = nil
picker.picture = {filename=prodHubs.modPath.."/graphics/icons/crosshair.png", width = 64, height = 64}
data:extend{picker}
