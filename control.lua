require("control/globals.lua")
require("control/prodHubsLib.lua") 

script.on_init(function()
	prodHubs.logF("on_init", {event})
	remote.call("freeplay", "set_disable_crashsite", true)
	prodHubs.addEvent(1, "generateWorldMap", {})
end)

script.on_event(defines.events.on_tick, function(event)
	prodHubs.callEvent(event.tick)
end)

script.on_event(defines.events.on_chunk_generated, function(event)
	prodHubs.logF("on_chunk_generated", {event}, 2)
	if global.worldMapGenerated then	prodHubs.onChunkGenerated(event.surface, event.area) end
end)

script.on_event(defines.events.on_surface_cleared, function(event)
	prodHubs.logF("on_surface_cleared", {event})
	global.worldMapGenerated = true
end)

script.on_event(defines.events.on_built_entity, function(event)
	prodHubs.logF("on_built_entity", {event}, 1)
	if event.created_entity.name == "entity-ghost" then
		if event.created_entity.ghost_name == "prodHubs-picker" then
			local player = game.players[event.player_index]
			prodHubs.handlePositionPicker(player, event.created_entity.position)
			event.created_entity.destroy()
			player.clear_cursor()
		end
	else
		prodHubs.entityCreated(event.created_entity)
	end
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
	prodHubs.logF("on_robot_built_entity", {event}, 1)
	prodHubs.entityCreated(event.created_entity)
end)

script.on_event(defines.events.on_player_created, function(event)
	prodHubs.logF("on_player_created", {event})
	global.gui[event.player_index] = {deployUnitCount = 10, deployAllUnits = true}
	prodHubs.openStatusGui(game.get_player(event.player_index))
	prodHubs.translateStrings(game.get_player(event.player_index))
	if #(global.buildablePatches) > 0 then game.players[event.player_index].insert{name="prodHubs-vault", count=1} end
	--game.players[event.player_index].insert{name="small-electric-pole", count=20}
	--game.players[event.player_index].insert{name="stone-furnace", count=100}
	game.players[event.player_index].insert{name="iron-plate", count=1000}
	game.players[event.player_index].insert{name="copper-plate", count=1000}
	--game.players[event.player_index].insert{name="coal", count=700}
	--game.players[event.player_index].insert{name="electronic-circuit", count=200}
	--game.players[event.player_index].insert{name="iron-stick", count=1000}
	--game.players[event.player_index].insert{name="copper-cable", count=1000}
	--game.players[event.player_index].character = nil
	--/c game.players[1].force.chart(game.players[1].surface, {lefttop = {x = -3000, y = -3000}, rightbottom = {x = 3000, y = 3000}})
end)

script.on_event(defines.events.on_selected_entity_changed, function(event)
	prodHubs.logF("on_selected_entity_changed", {event},2)
	prodHubs.updateStatusGui(game.get_player(event.player_index))
end)

script.on_event(defines.events.on_string_translated , function(event)
	prodHubs.logF("on_string_translated ", {event})
	prodHubs.saveTranslation(event)
end)

script.on_event(defines.events.on_gui_opened, function(event)
	prodHubs.logF("on_gui_opened", {event})
	if event.gui_type == defines.gui_type.entity then
		prodHubs.handleOpenBuiltInGui(game.get_player(event.player_index), event.entity)
	end
end)

script.on_event(defines.events.on_gui_closed, function(event)
	prodHubs.logF("on_gui_closed", {event})
	prodHubs.handleCloseGui(event)
end)

script.on_event(defines.events.on_gui_click, function(event)
	prodHubs.logF("on_gui_click", {event})
	prodHubs.handleGuiButtons(game.players[event.player_index], event.element)
end)

script.on_event(defines.events.on_player_used_capsule, function(event)
	prodHubs.logF("on_player_used_capsule", {event})
	prodHubs.handlePositionPicker(game.players[event.player_index], event.position)
end)

script.on_event(defines.events.on_gui_text_changed, function(event)
	prodHubs.logF("on_gui_text_changed", {event}, 1)
	prodHubs.handleGuiTextChange(game.players[event.player_index], event.element, event.text)
end)

script.on_event(defines.events.on_gui_checked_state_changed, function(event) -- Called when LuaGuiElement checked state is changed (related to checkboxes and radio buttons).
	prodHubs.logF("on_gui_checked_state_changed", {event})
	prodHubs.handleGuiCheckboxPress(game.players[event.player_index], event.element)
end)

script.on_event(defines.events.on_entity_destroyed, function(event)
	prodHubs.logF("on_entity_destroyed", {event})
	prodHubs.entityRemoved(event.unit_number)
end)

script.on_event(defines.events.on_entity_died, function(event) --on_entity_died Called when an entity dies.
	prodHubs.logF("on_entity_died", {event})
	prodHubs.entityRemoved(event.entity.unit_number)
end)

script.on_event(defines.events.on_player_mined_entity, function(event)--Called after the results of an entity being mined are collected just before the entity is destroyed.
	prodHubs.logF("on_player_mined_entity", {event})
	prodHubs.entityRemoved(event.entity.unit_number)
end)

script.on_nth_tick(600, function(event)
	game.forces["player"].rechart()
end)

script.on_event(defines.events.on_game_created_from_scenario, function(event)
	prodHubs.logF("on_game_created_from_scenario", {event})
end)

--CustomInputEvent Called when a CustomInput is activated.
--on_ai_command_completed Called when a unit/group completes a command.
--on_area_cloned Called when an area of the map is cloned.
--on_biter_base_built Called when a biter migration builds a base.
--on_brush_cloned Called when a set of positions on the map is cloned.
--on_build_base_arrived Called when a defines.command.build_base command reaches its destination, and before building starts.
--on_cancelled_deconstruction Called when the deconstruction of an entity is canceled.
--on_cancelled_upgrade Called when the upgrade of an entity is canceled.
--on_character_corpse_expired Called when a character corpse expires due to timeout or all of the items being removed from it.
--on_chart_tag_added Called when a chart tag is created.
--on_chart_tag_modified Called when a chart tag is modified by a player.
--on_chart_tag_removed Called just before a chart tag is deleted.
--on_chunk_charted Called when a chunk is charted or re-charted.
--on_chunk_deleted Called when one or more chunks are deleted using LuaSurface::delete_chunk.
--on_combat_robot_expired Called when a combat robot expires through a lack of energy, or timeout.
--on_console_chat Called when a message is sent to the in-game console, either by a player or through the server interface.
--on_console_command Called when someone enters a command-like message regardless of it being a valid command.
--on_cutscene_cancelled Called when a cutscene is cancelled by the player or by script.
--on_cutscene_waypoint_reached Called when a cutscene is playing, each time it reaches a waypoint in that cutscene.
--on_difficulty_settings_changed Called when the map difficulty settings are changed.
--on_entity_cloned Called when an entity is cloned.
--on_entity_damaged Called when an entity is damaged.

--on_entity_logistic_slot_changed Called when one of an entity's personal logistic slots changes.
--on_entity_renamed Called after an entity has been renamed either by the player or through script.
--on_entity_settings_pasted Called after entity copy-paste is done.
--on_entity_spawned Called when an entity is spawned by a EnemySpawner
--on_equipment_inserted Called after equipment is inserted into an equipment grid.
--on_equipment_removed Called after equipment is removed from an equipment grid.
--on_force_cease_fire_changed Called when the a forces cease fire values change.
--on_force_created Called when a new force is created using game.create_force()
--on_force_friends_changed Called when the a forces friends change.
--on_force_reset Called when LuaForce::reset is finished.
--on_forces_merged Called after two forces have been merged using game.merge_forces().
--on_forces_merging Called when two forces are about to be merged using game.merge_forces().
--on_game_created_from_scenario Called when a game is created from a scenario.
--on_gui_confirmed Called when a LuaGuiElement is confirmed, for example by pressing Enter in a textfield.
--on_gui_elem_changed Called when LuaGuiElement element value is changed (related to choose element buttons).
--on_gui_location_changed Called when LuaGuiElement element location is changed (related to frames in player.gui.screen).
--on_gui_selected_tab_changed Called when LuaGuiElement selected tab is changed (related to tabbed-panes).
--on_gui_selection_state_changed Called when LuaGuiElement selection state is changed (related to drop-downs and listboxes).
--on_gui_switch_state_changed Called when LuaGuiElement switch state is changed (related to switches).
--on_gui_value_changed Called when LuaGuiElement slider value is changed (related to the slider element).
--on_land_mine_armed Called when a land mine is armed.
--on_lua_shortcut Called when a custom Lua shortcut is pressed.
--on_marked_for_deconstruction Called when an entity is marked for deconstruction with the Deconstruction planner or via script.
--on_marked_for_upgrade Called when an entity is marked for upgrade with the Upgrade planner or via script.
--on_market_item_purchased Called after a player purchases some offer from a market entity.
--on_mod_item_opened Called when the player uses the 'Open item GUI' control on an item defined with the 'mod-openable' flag
--on_permission_group_added Called directly after a permission group is added.
--on_permission_group_deleted Called directly after a permission group is deleted.
--on_permission_group_edited Called directly after a permission group is edited in some way.
--on_permission_string_imported Called directly after a permission string is imported.
--on_picked_up_item Called when a player picks up an item.
--on_player_alt_reverse_selected_area Called after a player alt-reverse-selects an area with a selection-tool item.
--on_player_alt_selected_area Called after a player alt-selects an area with a selection-tool item.
--on_player_ammo_inventory_changed Called after a players ammo inventory changed in some way.
--on_player_armor_inventory_changed Called after a players armor inventory changed in some way.
--on_player_banned Called when a player is banned.
--on_player_built_tile Called after a player builds tiles.
--on_player_cancelled_crafting Called when a player cancels crafting.
--on_player_changed_force Called after a player changes forces.
--on_player_changed_position Called when the tile position a player is located at changes.
--on_player_changed_surface Called after a player changes surfaces.
--on_player_cheat_mode_disabled Called when cheat mode is disabled on a player.
--on_player_cheat_mode_enabled Called when cheat mode is enabled on a player.
--on_player_clicked_gps_tag Called when a player clicks a gps tag
--on_player_configured_blueprint Called when a player clicks the "confirm" button in the configure Blueprint GUI.
--on_player_configured_spider_remote Called when a player configures spidertron remote to be connected with a given spidertron
--on_player_crafted_item Called when the player finishes crafting an item.
--on_player_cursor_stack_changed Called after a players cursorstack changed in some way.
--on_player_deconstructed_area Called when a player selects an area with a deconstruction planner.
--on_player_demoted Called when a player is demoted.
--on_player_died Called after a player dies.
--on_player_display_resolution_changed Called when the display resolution changes for a given player.
--on_player_display_scale_changed Called when the display scale changes for a given player.
--on_player_driving_changed_state Called when the player's driving state has changed, meaning a player has either entered or left a vehicle.
--on_player_dropped_item Called when a player drops an item on the ground.
--on_player_fast_transferred Called when a player fast-transfers something to or from an entity.
--on_player_flushed_fluid Called after player flushed fluid
--on_player_gun_inventory_changed Called after a players gun inventory changed in some way.
--on_player_joined_game Called after a player joins the game.
--on_player_kicked Called when a player is kicked.
--on_player_left_game Called after a player leaves the game.
--on_player_main_inventory_changed Called after a players main inventory changed in some way.
--on_player_mined_item Called when the player mines something.
--on_player_mined_tile Called after a player mines tiles.
--on_player_muted Called when a player is muted.
--on_player_pipette Called when a player invokes the "smart pipette" over an entity.
--on_player_placed_equipment Called after the player puts equipment in an equipment grid
--on_player_promoted Called when a player is promoted.
--on_player_removed Called when a player is removed (deleted) from the game.
--on_player_removed_equipment Called after the player removes equipment from an equipment grid
--on_player_repaired_entity Called when a player repairs an entity.
--on_player_respawned Called after a player respawns.
--on_player_reverse_selected_area Called after a player reverse-selects an area with a selection-tool item.
--on_player_rotated_entity Called when the player rotates an entity.
--on_player_selected_area Called after a player selects an area with a selection-tool item.
--on_player_set_quick_bar_slot Called when a player sets a quickbar slot to anything (new value, or set to empty).
--on_player_setup_blueprint Called when a player selects an area with a blueprint.
--on_player_toggled_alt_mode Called when a player toggles alt mode, also known as "show entity info".
--on_player_toggled_map_editor Called when a player toggles the map editor on or off.
--on_player_trash_inventory_changed Called after a players trash inventory changed in some way.
--on_player_unbanned Called when a player is un-banned.
--on_player_unmuted Called when a player is unmuted.
--on_player_used_spider_remote Called when a player uses spidertron remote to send a spidertron to a given position
--on_post_entity_died Called after an entity dies.
--on_pre_build Called when players uses an item to build something.
--on_pre_chunk_deleted Called before one or more chunks are deleted using LuaSurface::delete_chunk.
--on_pre_entity_settings_pasted Called before entity copy-paste is done.
--on_pre_ghost_deconstructed Called before a ghost entity is destroyed as a result of being marked for deconstruction.
--on_pre_ghost_upgraded Called before a ghost entity is upgraded.
--on_pre_permission_group_deleted Called directly before a permission group is deleted.
--on_pre_permission_string_imported Called directly before a permission string is imported.
--on_pre_player_crafted_item Called when a player queues something to be crafted.
--on_pre_player_died Called before a players dies.
--on_pre_player_left_game Called before a player leaves the game.
--on_pre_player_mined_item Called when the player completes a mining action, but before the entity is potentially removed from the map.
--on_pre_player_removed Called before a player is removed (deleted) from the game.
--on_pre_player_toggled_map_editor Called before a player toggles the map editor on or off.
--on_pre_robot_exploded_cliff Called directly before a robot explodes cliffs.
--on_pre_script_inventory_resized Called just before a script inventory is resized.
--on_pre_surface_cleared Called just before a surface is cleared (all entities removed and all chunks deleted).
--on_pre_surface_deleted Called just before a surface is deleted.
--on_research_cancelled Called when research is cancelled.
--on_research_finished Called when a research finishes.
--on_research_reversed Called when a research is reversed (unresearched).
--on_research_started Called when a technology research starts.
--on_resource_depleted Called when a resource entity reaches 0 or its minimum yield for infinite resources.
--on_robot_built_tile Called after a robot builds tiles.
--on_robot_exploded_cliff Called directly after a robot explodes cliffs.
--on_robot_mined Called when a robot mines an entity.
--on_robot_mined_entity Called after the results of an entity being mined are collected just before the entity is destroyed.
--on_robot_mined_tile Called after a robot mines tiles.
--on_robot_pre_mined Called before a robot mines an entity.
--on_rocket_launch_ordered Called when a rocket silo is ordered to be launched.
--on_rocket_launched Called when the rocket is launched.
--on_runtime_mod_setting_changed Called when a runtime mod setting is changed by a player.
--on_script_inventory_resized Called just after a script inventory is resized.
--on_script_path_request_finished Called when a LuaSurface::request_path call completes.
--on_script_trigger_effect Called when a script trigger effect is triggered.
--on_sector_scanned Called when an entity of type radar finishes scanning a sector.
--on_spider_command_completed Called when a spider finishes moving to its autopilot position.
--on_surface_created Called when a surface is created.
--on_surface_deleted Called after a surface is deleted.
--on_surface_imported Called after a surface is imported.
--on_surface_renamed Called when a surface is renamed.
--on_technology_effects_reset Called when LuaForce::reset_technology_effects is finished.
--on_train_changed_state Called when a train changes state (started to stopped and vice versa)
--on_train_created Called when a new train is created either through disconnecting/connecting an existing one or building a new one.
--on_train_schedule_changed Called when a trains schedule is changed either by the player or through script.
--on_trigger_created_entity Called when an entity with a trigger prototype (such as capsules) create an entity AND that trigger prototype defined trigger_created_entity="true".
--on_trigger_fired_artillery Called when an entity with a trigger prototype (such as capsules) fire an artillery projectile AND that trigger prototype defined trigger_fired_artillery="true".
--on_unit_added_to_group Called when a unit is added to a unit group.
--on_unit_group_created Called when a new unit group is created, before any members are added to it.
--on_unit_group_finished_gathering Called when a unit group finishes gathering and starts executing its command.
--on_unit_removed_from_group Called when a unit is removed from a unit group.
--on_worker_robot_expired Called when a worker (construction or logistic) robot expires through a lack of energy.
--script_raised_built A static event mods can use to tell other mods they built something by script.
--script_raised_destroy A static event mods can use to tell other mods they destroyed something by script.
--script_raised_revive A static event mods can use to tell other mods they revived something by script.
--script_raised_set_tiles A static event mods can use to tell other mods they changed tiles on a surface by script.