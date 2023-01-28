collision_mask_util = require("collision-mask-util")

-- Unbuildable terrain
layer = collision_mask_util.get_first_unused_layer()
table.insert(data.raw["tile"]["grass-1"].collision_mask, layer)
collideWithGrass = {"accumulator", "ammo-turret", "arithmetic-combinator", "artillery-turret", "assembling-machine", "beacon", "boiler", "burner-generator", "constant-combinator", "container", "decider-combinator", "electric-turret", "fluid-turret", "furnace", "gate", "generator", "heat-pipe", "inserter", "lab", "lamp", "logistic-container", "mining-drill", "offshore-pump", "pipe", "pipe-to-ground", "programmable-speaker", "pump", "radar", "reactor", "roboport", "rocket-silo", "solar-panel", "splitter", "storage-tank", "train-stop", "transport-belt", "underground-belt", "wall"}
for k,v in pairs(collideWithGrass) do
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
	masks = collision_mask_util.get_default_mask(category)
	table.insert(masks, layer)
	for _,entity in pairs(entities) do
		data.raw[category][entity].collision_mask = masks
	end
end
