require("control/globals.lua")
require("control/patches.lua")
require("control/localisation.lua")
require("control/population.lua")
require("control/extraPrototypeStats.lua")
require("control/gui.lua")
require("control/gui/status.lua")
require("control/entities/vault.lua")

function prodHubs.entityCreated(entity)
	prodHubs.logF("entityCreated", {entity}, 1)
  if prodHubs.extraPrototypeStats[entity.name] == nil then return end
  global.entityStats[entity.unit_number] = table.deepcopy(prodHubs.extraPrototypeStats[entity.name])
  local entityStats = global.entityStats[entity.unit_number]
  entityStats.entity = entity
  entityStats.active = true
  if entityStats.invulnerable then entity.destructible = false end
  if entityStats.requiredWorkers then
    entityStats.workers = 0
    entityStats.active = false
    entity.active = false
    for _,patch in ipairs(global.buildablePatches) do
      if BuildablePatch.hasTile(patch,math.floor(entity.position.x),math.floor(entity.position.y)) then -- math.floor because inserters with pos {x=20.5, y=0.5} sits on tile "20,0"
        entityStats.patch = patch
        patch.suppliedEnteties[entity.unit_number] = entityStats
        if #(patch.vaults) > 0 then
          prodHubs.giveEntityWorkers(entity.unit_number, patch)
        end
        break
      end
    end
  end
  if entityStats.adjustMiningSpeed then
    local resources = game.surfaces[1].find_entities_filtered{position = entity.position, radius = entity.prototype.mining_drill_radius, name = {"iron-ore", "copper-ore", "stone", "coal", "uranium-ore", "crude-oil"}}
    local minerMultiplier = #resources
    local workerMultiplier = entityStats.patch.freePopulation / 10100 * 9 + 1
    for i, v in ipairs(resources) do
      local resourceStats = prodHubs.getResourceStatsFromEntity(entityStats.patch, v)
      resourceStats.minerMultiplier = minerMultiplier
      v.initial_amount = resourceStats.originalInitialAmount * minerMultiplier * workerMultiplier
      v.amount = resourceStats.originalAmount * minerMultiplier * workerMultiplier
    end
  end
  if entity.name == "prodHubs-vault" then
    for _,patch in ipairs(global.buildablePatches) do
      if BuildablePatch.hasTile(patch,entity.position.x,entity.position.y) then
        entityStats.patch = patch
        table.insert(patch.vaults, entity)
        if #(patch.vaults) == 1 then prodHubs.addWorkersToAllUnits(patch) end
        break
      end
    end
  end  
end

function prodHubs.entityRemoved(unitNum)
	prodHubs.logF("entityRemoved", {unitNum}, 1)
  local entityStats = global.entityStats[unitNum]
  if entityStats == nil then return end
  local patch = entityStats.patch
  if entityStats.requiredWorkers then
    patch.suppliedEnteties[unitNum] = nil
    prodHubs.removeEntityWorkers(unitNum, true)
    prodHubs.addWorkersToAllUnits(patch)
  end
  if entityStats.entity.name == "prodHubs-vault" then
    prodHubs.removeValue(patch.vaults, entityStats.entity)
    if #(patch.vaults) == 0 then prodHubs.removeWorkersFromAllUnits(patch) end
  end
  if entityStats.fightingPatch then
    entityStats.fightingPatch.fightingPopulation = entityStats.fightingPatch.fightingPopulation - entityStats.fightingPopulation
    entityStats.fightingPatch.freePopulation = entityStats.fightingPatch.freePopulation + entityStats.fightingPopulation
  end
  if entityStats.adjustMiningSpeed then
    local entity = entityStats.entity
    local resources = game.surfaces[1].find_entities_filtered{position = entity.position, radius = entity.prototype.mining_drill_radius, name = {"iron-ore", "copper-ore", "stone", "coal", "uranium-ore", "crude-oil"}}
    local minerMultiplier = 1
    local workerMultiplier = entityStats.patch.freePopulation / 10100 * 9 + 1
    for i, v in ipairs(resources) do
      local resourceStats = prodHubs.getResourceStatsFromEntity(entityStats.patch, v)
      resourceStats.minerMultiplier = 1
      v.initial_amount = resourceStats.originalInitialAmount * minerMultiplier * workerMultiplier
      v.amount = resourceStats.originalAmount * minerMultiplier * workerMultiplier
    end
  end
  global.entityStats[unitNum] = nil
end

function prodHubs.attack(position)
	prodHubs.logF("attack", {position})
  for key, unitGroup in pairs(global.unitGroups) do
    if unitGroup.valid == false then
      global.unitGroups[key] = nil
    else
      unitGroup.set_command({type=defines.command.go_to_location, destination = position})
    end
  end
end

function prodHubs.handlePositionPicker(player, position)
	prodHubs.logF("handlePositionPicker", {player, position})
  if global.gui[player.index].positionPickerType == "deployUnits" then
    prodHubs.handleVaultPositionPicker(player, position)
  elseif global.gui[player.index].positionPickerType == "orderUnits" then
    prodHubs.attack(position)
	end
end
