-- Vault
item = table.deepcopy(data.raw["item"]["assembling-machine-1"])
item.name = "prodHubs-vault"
item.localised_name = {"prodHubs-vault"}
item.place_result = "prodHubs-vault"
item.icon = "__ProductionHubs__/graphics/icons/vault.png",
data:extend{item}

-- Picker for picking points on the map
item = table.deepcopy(data.raw["item"]["small-electric-pole"])
item.name = "prodHubs-picker"
item.localised_name = {"prodHubs-picker"}
item.place_result = "prodHubs-picker"
data:extend{item}
