function prodHubs.openStatusGui(player)
	prodHubs.logF("openStatusGui", {player})
	local frame = player.gui.left.add{type="frame", name = "statusGui"}
	frame.caption = {"nothing_selected"}
	local label = frame.add{type="label", caption="", name = "stats"}
	label.style.single_line = false

	frame = player.gui.top.add{type="frame", name = "commandsGui"}
  frame.add{type="sprite-button", sprite="prodHubs-crossHair", name="orderUnits"}
end

function prodHubs.updateStatusGui(player)
	prodHubs.logF("updateStatusGui", {player}, 2)
	if player.selected == nil or not global.entityStats[player.selected.unit_number] then
		player.gui.left["statusGui"].caption = {"nothing_selected"}
		player.gui.left["statusGui"]["stats"].caption = ""
		return
	end
	local caption = player.selected.localised_name
	local stats = ""
	local entityStats = global.entityStats[player.selected.unit_number]
	--stats = stats .. "\n" .. player.selected.unit_number
	if entityStats.entity.name == "prodHubs-vault" then
		local patch = entityStats.patch
		local pop = math.min(math.floor(patch.population), patch.maxPopulation)
		stats = stats .. "\n" .. prodHubs.loadTranslation(player.index,"population") .. ": " .. pop .. "/" .. patch.maxPopulation
		stats = stats .. "\n" .. prodHubs.loadTranslation(player.index,"working") .. ": " .. patch.workingPopulation
		stats = stats .. "\n" .. prodHubs.loadTranslation(player.index,"fighting") .. ": " .. patch.fightingPopulation
		stats = stats .. "\n" .. prodHubs.loadTranslation(player.index,"free") .. ": " .. patch.freePopulation
		stats = stats .. "\n" .. prodHubs.loadTranslation(player.index,"mining_boost") .. ": " .. math.floor(patch.freePopulation / 10100 * 9 * 100) .. " %"
	end
	if entityStats.workers then stats = stats .. "\n" .. prodHubs.loadTranslation(player.index,"workers") .. " " .. entityStats.workers .. "/" .. entityStats.requiredWorkers end
	if entityStats.invulnerable then stats = stats .. "\n" .. prodHubs.loadTranslation(player.index,"invulnerable") end
	if not entityStats.active then stats = stats .. "\n" .. prodHubs.loadTranslation(player.index, "disabled") end
	stats = stats:sub(2)
	player.gui.left["statusGui"].caption = caption
	player.gui.left["statusGui"]["stats"].caption = stats
  player.gui.left.statusGui.stats.style.single_line = false
end

function prodHubs.handleCommandsButtonPress(player, element)
	prodHubs.logF("handleCommandsButtonPress", {player, element})
  if element.name == "orderUnits" then
    global.gui[player.index].positionPickerType = "orderUnits"
		player.cursor_stack.set_stack({name = "blueprint", count = 1})
		player.cursor_stack.set_blueprint_entities({{name = "prodHubs-picker", entity_number = 1, position = {x=0, y=0}}})
		player.cursor_stack_temporary = true
	end
end
