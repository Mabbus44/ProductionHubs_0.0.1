require("control/globals.lua")
require("control/prodHubsLib.lua") 
require("control/mapGeneration.lua")

script.on_init(function()
	remote.call("freeplay", "set_disable_crashsite", true)
	prodHubs.addEvent(1, prodHubs.generateWorldMap, {})
end)

script.on_event(defines.events.on_chunk_generated, function(event)
	if(prodHubs. worldMapGenerated) then	prodHubs.onChunkGenerated(event.surface, event.area) end
end)

--script.on_event(defines.events.on_player_created, function(event)
--	prodHubs.logF("on_player_created", {event})
--end)

--script.on_event(defines.events.on_selected_entity_changed, function(event)
--end)

--script.on_event(defines.events.on_gui_opened, function(event)
--	prodHubs.logF("on_gui_opened", {event})
--end)

--script.on_event(defines.events.on_gui_closed, function(event)
--	prodHubs.logF("on_gui_closed", {event})
--end)

--script.on_event(defines.events.on_gui_click, function(event)
--end)

--script.on_event(defines.events.on_gui_value_changed, function(event)
--	prodHubs.logF("on_gui_value_changed", {event})
--end)

--script.on_event(defines.events.on_gui_text_changed, function(event)
--	prodHubs.logF("on_gui_text_changed", {event})
--end)

--script.on_event(defines.events.on_built_entity, function(event)
--end)

--script.on_event(defines.events.on_player_crafted_item, function(event)
--end)

--script.on_event(defines.events.on_player_used_capsule, function(event)
--	prodHubs.logF("on_player_used_capsule", {event})
--end)

--script.on_event(defines.events.on_marked_for_deconstruction, function(event)
--end)

--script.on_event(defines.events.on_player_main_inventory_changed, function(event)
--end)

--script.on_event(defines.events.on_player_rotated_entity, function(event)
--	prodHubs.logF("on_player_rotated_entity", {event})
--end)

--script.on_event(defines.events.on_entity_destroyed, function(event)
--	prodHubs.logF("on_entity_destroyed", {event})
--end)

--script.on_event(defines.events.on_tick, function(event)
--	prodHubs.callEvent(event.tick)
--end)
