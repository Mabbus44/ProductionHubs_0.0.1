function prodHubs.translateStrings(player)
	prodHubs.logF("translateStrings ", {player})
  player.request_translations({{"prodHubs-vault"},{"nothing_selected"},{"workers"},{"invulnerable"},{"disabled"},{"population"},{"iron_plates"},{"insufficient"},{"inventory_full"},{"built"},{"one_population_costs"},{"and"},{"coal"},{"level"},{"max_level"},{"leveled_up"},{"deploy"},{"units"},{"no_free_population"},{"deployed"},{"working"},{"fighting"},{"free"},{"growth_mode"},{"stabile"},{"grow"},{"boost"},{"cost_description"},{"boost_description"},{"deploy_population_description"},{"build_vault"},{"build_vault_description"},{"mining_boost"}})
end

function prodHubs.saveTranslation(event)
	prodHubs.logF("saveTranslation ", {event})
  if not event.translated then return end
  if global.translations[event.player_index] == nil then global.translations[event.player_index] = {} end
  global.translations[event.player_index][event.localised_string[1]] = event.result
end

function prodHubs.loadTranslation(player_index, localisedString)
	prodHubs.logF("loadTranslation ", {player_index, localisedString}, 2)
  if global.translations[player_index] == nil or global.translations[player_index][localisedString] == nil then return "" end
  return global.translations[player_index][localisedString]
end