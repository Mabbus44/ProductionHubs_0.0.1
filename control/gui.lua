function prodHubs.isGuiParent(element, parentName)
	prodHubs.logF("isGuiParent", {element, parentName}, 1)
	local parent = element
	while parent ~= nil do
		if parent.name == parentName then return true end
		parent = parent.parent
	end
	return false
end

function prodHubs.handleOpenBuiltInGui(player, entity)
	prodHubs.logF("handleOpenBuiltInGui", {player, entity})
  global.gui[player.index].entity = entity
  if entity.name == "prodHubs-vault" then
		prodHubs.openVaultGui(player, entity)
	end
end

function prodHubs.handleCloseGui(event)
	prodHubs.logF("handleCloseGui", {event})
  local player = game.get_player(event.player_index)
	if event.gui_type == defines.gui_type.entity then
		--if event.entity.name == "prodHubs-vault" then prodHubs.closeVaultGui(player) end
	elseif event.gui_type == defines.gui_type.custom then
		-- If you set player.opened to a frame factorio will not close that frame if a entity frame is opened, but it will rise this event
		-- letting you close the frame yourself
	end
end

function prodHubs.handleGuiButtons(player, element)
	prodHubs.logF("handleGuiButtons", {player, element})
	if prodHubs.isGuiParent(element, "vaultGui") then prodHubs.handleVaultButtonPress(player, element)
	elseif prodHubs.isGuiParent(element, "commandsGui") then prodHubs.handleCommandsButtonPress(player, element) end
end

function prodHubs.handleGuiTextChange(player, element, text)
	prodHubs.logF("handleGuiTextChange", {player, element, text}, 1)
	if prodHubs.isGuiParent(element, "vaultGui") then prodHubs.handleVaultTextChange(player, element, text) end
end

function prodHubs.handleGuiCheckboxPress(player, element)
	prodHubs.logF("handleGuiCheckboxPress", {player, element})
	if prodHubs.isGuiParent(element, "vaultGui") then prodHubs.handleVaultCheckboxPress(player, element) end
end
