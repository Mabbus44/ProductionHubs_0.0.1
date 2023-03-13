function prodHubs.giveEntityWorkers(unitNum)
	prodHubs.logF("giveEntityWorkers", {unitNum}, 2)
  entityStats = global.entityStats[unitNum]
  local patch = entityStats.patch
  local addWorkers = math.min(entityStats.requiredWorkers - entityStats.workers, patch.freePopulation)
  entityStats.workers = entityStats.workers + addWorkers
  prodHubs.setStatusFromWorkers(entityStats)
  patch.workingPopulation = patch.workingPopulation + addWorkers
  patch.freePopulation = patch.freePopulation - addWorkers
  prodHubs.calculateGatherSpeed(patch)
end

function prodHubs.removeEntityWorkers(unitNum, unitRemoved, removeOne)
	prodHubs.logF("removeEntityWorkers", {unitNum}, 2)
  entityStats = global.entityStats[unitNum]
  local patch = entityStats.patch
  local removeCount = entityStats.workers
  if removeOne and entityStats.workers > 0 then removeCount = 1 end
  patch.workingPopulation = patch.workingPopulation - removeCount
  patch.freePopulation = patch.freePopulation + removeCount
  entityStats.workers = entityStats.workers - removeCount
  if unitRemoved then
    prodHubs.removeNoWorkerAnimation(entityStats)
  else
    prodHubs.setStatusFromWorkers(entityStats)
  end
  prodHubs.calculateGatherSpeed(patch)
  return removeCount > 0
end

function prodHubs.addWorkersToAllUnits(patch)
	prodHubs.logF("addWorkersToAllUnits", {patch}, 2)
  for unitNum,_ in pairs(patch.suppliedEnteties) do
    if patch.freePopulation == 0 then break end
    prodHubs.giveEntityWorkers(unitNum)
  end
end

function prodHubs.removeWorkersFromAllUnits(patch, removeOne)
	prodHubs.logF("removeWorkersFromAllUnits", {patch}, 1)
  for unitNum,_ in pairs(patch.suppliedEnteties) do
    if patch.workingPopulation == 0 then break end
    if prodHubs.removeEntityWorkers(unitNum, false, removeOne) and removeOne then return end
  end
end

function prodHubs.setStatusFromWorkers(entityStats)
  local entity = entityStats.entity
  if entityStats.requiredWorkers == entityStats.workers then 
    entityStats.entity.active = true
    entityStats.active = true
    prodHubs.removeNoWorkerAnimation(entityStats)
  else
    entityStats.entity.active = false
    entityStats.active = false
    if entityStats.noWorkersAnimation == nil then
      entityStats.noWorkersAnimation = rendering.draw_animation{animation = "prodHubs-noWorkersAnimation", target=entity.position, surface = entity.surface}
    end
  end
end

function prodHubs.removeNoWorkerAnimation(entityStats)
  if entityStats.noWorkersAnimation ~= nil then rendering.destroy(entityStats.noWorkersAnimation) end
  entityStats.noWorkersAnimation = nil
end

function prodHubs.adjustPopulation()
	prodHubs.logF("adjustPopulation", {}, 2)
  local batchCost = prodHubs.batchCost
  local popPerBatch = 10
  local decayAmount = 0.2
  for _, patch in ipairs(global.buildablePatches) do
    local popIncreaseBatchCount = 0
    local decay = (patch.population > 100)
    local populationBefore = math.floor(math.min(patch.maxPopulation, patch.population))
    local costFactor = 1
    if patch.population <= 100 then popIncreaseBatchCount = 0 end
    if patch.popGrowthMode == prodHubs.popGrowthMode.STABILE and (patch.population <= patch.popGrowthLimit) then
      popIncreaseBatchCount = 1
    elseif patch.popGrowthMode == prodHubs.popGrowthMode.GROW and (patch.population <= patch.maxPopulation) then
      popIncreaseBatchCount = 1
    elseif patch.popGrowthMode == prodHubs.popGrowthMode.BOOST and (patch.population <= patch.maxPopulation) then
      popIncreaseBatchCount = 5
      costFactor = 4
    end
    for _, vault in ipairs(patch.vaults) do
      affordedPopIncrease = popIncreaseBatchCount
      local inventory = vault.get_inventory(defines.inventory.chest)
      for _, oneLevel in ipairs(batchCost) do
        if patch.population >= oneLevel.pop then
          for _, oneItem in ipairs(oneLevel.items) do
            affordedPopIncrease = math.min(math.floor(inventory.get_item_count(oneItem.name)/(oneItem.count*costFactor)), affordedPopIncrease)
          end
        end
      end
      if affordedPopIncrease > 0 then
        for _, oneLevel in ipairs(batchCost) do
          if patch.population >= oneLevel.pop then
            for _, oneItem in ipairs(oneLevel.items) do
              inventory.remove({name=oneItem.name, count=affordedPopIncrease*(oneItem.count*costFactor)})
            end
          end
        end
      end
      popIncreaseBatchCount = popIncreaseBatchCount - affordedPopIncrease
      patch.population = patch.population + affordedPopIncrease * popPerBatch
    end
    local addWorkers = (patch.freePopulation == 0)
    if decay then patch.population = patch.population - decayAmount end
    patch.freePopulation = math.floor(math.min(patch.maxPopulation, patch.population)) - patch.workingPopulation - patch.fightingPopulation
    if addWorkers and patch.freePopulation > 0 then prodHubs.addWorkersToAllUnits(patch) end
    if patch.freePopulation < 0 then
      if patch.workingPopulation == 0 then
        patch.population = patch.population + decayAmount
        patch.freePopulation = 0
      else
        prodHubs.removeWorkersFromAllUnits(patch, true)
      end
    end
    local populationAfter = math.floor(math.min(patch.maxPopulation, patch.population))
    if populationBefore ~= populationAfter then prodHubs.calculateGatherSpeed(patch) end
  end
  for _, player in pairs(game.players) do
    prodHubs.updateVaultGui(player)
  end
  prodHubs.addEvent(prodHubs.ticksPerSecond * 20, "adjustPopulation", {})
end

function prodHubs.calculateGatherSpeed(patch)
	prodHubs.logF("calculateGatherSpeed", {patch}, 2)
  local workerMultiplier = patch.freePopulation / 10100 * 9 + 1
  for i,resourceStats in pairs(patch.resources) do
    local v = resourceStats.entity
    v.initial_amount = resourceStats.originalInitialAmount * resourceStats.minerMultiplier * workerMultiplier
    v.amount = resourceStats.originalAmount * resourceStats.minerMultiplier * workerMultiplier
  end
end

function prodHubs.getResourceStatsFromEntity(patch, resource)
	prodHubs.logF("getResourceStatsFromEntity", {patch}, 2)
  for i,resourceStats in pairs(patch.resources) do
    if resourceStats.entity == resource then return resourceStats end
  end
end