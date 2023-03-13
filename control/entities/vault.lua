function prodHubs.openVaultGui(player)
	prodHubs.logF("openVaultGui", {player})
  if player.gui.relative["vaultGui"] == nil or player.gui.relative["vaultGui"].valid == false then
    prodHubs.createVaultGui(player)
  end
  prodHubs.updateVaultGui(player)
end

function prodHubs.createVaultGui(player)
	prodHubs.logF("createVaultGui", {player})
	local frame = player.gui.relative.add{type="frame", name = "vaultGui", caption = {"prodHubs-vault"}}
	frame.anchor = {gui = defines.relative_gui_type.container_gui, position = defines.relative_gui_position.top, name = "prodHubs-vault"}
	
  local col1 = frame.add{type = "flow", name = "col1", direction = "vertical"}
  local col2 = frame.add{type = "flow", name = "col2", direction = "vertical"}
  
  local levelFlow = col1.add{type = "flow", name = "levelFlow", direction = "vertical"}
  local row1 = levelFlow.add{type="flow", name="row1"}
  local row2 = levelFlow.add{type="flow", name="row2"}
  local row3 = levelFlow.add{type="flow", name="row3"}
  local row4 = levelFlow.add{type="flow", name="row4"}
  local row5 = levelFlow.add{type="flow", name="row5"}
  local row6 = levelFlow.add{type="flow", name="row6"}
  levelFlow.add{type="label", name="emptyRow", caption=""}
  row1.add{type="label", name="levelHeadingLabel", caption=prodHubs.loadTranslation(player.index, "level")}
  row1.add{type="label", name="levelLabel", caption=""}
  row1.add{type="sprite-button", sprite="prodHubs-upArrrow", name="levelUpButton"}
  row2.add{type="label", name="populationHeadingLabel", caption=prodHubs.loadTranslation(player.index, "population") .. ":"}
  row2.add{type="label", name="populationLabel", caption=""}  
  row3.add{type="label", name="workingHeadingLabel", caption=prodHubs.loadTranslation(player.index, "working") .. ":"}
  row3.add{type="label", name="workingLabel", caption=""}  
  row4.add{type="label", name="fightingHeadingLabel", caption=prodHubs.loadTranslation(player.index, "fighting") .. ":"}
  row4.add{type="label", name="fightingLabel", caption=""}  
  row5.add{type="label", name="freeHeadingLabel", caption=prodHubs.loadTranslation(player.index, "free") .. ":"}
  row5.add{type="label", name="freeLabel", caption=""}  
  row6.add{type="label", name="boostHeadingLabel", caption=prodHubs.loadTranslation(player.index, "mining_boost") .. ":"}
  row6.add{type="label", name="boostLabel", caption=""}  

  local growthFlow = col1.add{type = "flow", name = "growthFlow", direction = "vertical"}
  local row1 = growthFlow.add{type="flow", name="row1"}
  local row2 = growthFlow.add{type="flow", name="row2"}
  local row3 = growthFlow.add{type="flow", name="row3"}
  local row4 = growthFlow.add{type="flow", name="row4"}
  local row5 = growthFlow.add{type="flow", name="row5"}
  local row6 = growthFlow.add{type="flow", name="row6"}
  growthFlow.add{type="label", name="emptyRow", caption=""}
  row1.add{type="label", name="growthModeHeadingLabel", caption=prodHubs.loadTranslation(player.index, "growth_mode") .. ":"}
  row2.add{type="radiobutton", name="stabileRadioButton", state=false}
  row2.add{type="label", name="stabileLabel", caption=" " .. prodHubs.loadTranslation(player.index, "stabile")}
  row3.add{type="radiobutton", name="growRadioButton", state=false}
  row3.add{type="label", name="growLabel", caption=" " .. prodHubs.loadTranslation(player.index, "grow")}
  row4.add{type="radiobutton", name="boostRadioButton", state=false}
  row4.add{type="label", name="boostLabel", caption=" " .. prodHubs.loadTranslation(player.index, "boost")}
  row5.add{type="label", name="costDescriptionLabel", caption=prodHubs.loadTranslation(player.index, "cost_description")}
  local costFlow = row5.add{type="flow", name="costFlow", direction = "vertical"}
  costFlow.add{type="flow", name="costRow1"}
  costFlow.add{type="flow", name="costRow2"}
  costFlow.add{type="flow", name="costRow3"}
  row6.add{type="label", name="boostDescriptionLabel", caption=prodHubs.loadTranslation(player.index, "boost_description")}

  local deployFlow = col2.add{type = "flow", name = "deployFlow", direction = "vertical"}
  local row1 = deployFlow.add{type="flow", name="row1"}
  local row2 = deployFlow.add{type="flow", name="row2"}
  deployFlow.add{type="label", name="emptyRow", caption=""}
  row1.add{type="label", name="deployHeadingLabel", caption=prodHubs.loadTranslation(player.index, "deploy")}
  row1.add{type="sprite-button", sprite="prodHubs-crossHair", name="deployUnitsButton"}
  row2.add{type="textfield", name="deployUnitsTextField", numeric=true, allow_decimal=false, allow_negative=false}
  row2.add{type="label", name="deployUnitsDescriptionLabel", caption=prodHubs.loadTranslation(player.index, "deploy_population_description") .. " "}
  row2.add{type="checkbox", name="deployAllCheckbox", state=false}

  local buildVaultFlow = col2.add{type = "flow", name = "buildVaultFlow", direction = "vertical"}
  local row1 = buildVaultFlow.add{type="flow", name="row1"}
  row1.add{type="label", name="buildVaultLabel", caption=prodHubs.loadTranslation(player.index, "build_vault")}
  row1.add{type="sprite-button", sprite="item/prodHubs-vault", name="buildVaultButton"}
  row1.add{type="label", name="buildVault2Label", caption=prodHubs.loadTranslation(player.index, "build_vault_description")}
end

function prodHubs.updateVaultGui(player)
	prodHubs.logF("updateVaultGui", {player})
  entity = global.gui[player.index].entity
  if entity == nil or entity.valid == false or entity.name ~= "prodHubs-vault" then return end
  local patch = global.entityStats[entity.unit_number].patch
	local frame = player.gui.relative["vaultGui"]
  if frame == nil then return end
  local col1 = frame["col1"]
  local col2 = frame["col2"]

  col1["levelFlow"]["row1"]["levelLabel"].caption = patch.level
  local population = math.floor(patch.population)
  population = math.min(population, patch.maxPopulation)
  col1["levelFlow"]["row2"]["populationLabel"].caption = population .. "/" .. patch.maxPopulation
  col1["levelFlow"]["row3"]["workingLabel"].caption = patch.workingPopulation
  col1["levelFlow"]["row4"]["fightingLabel"].caption = patch.fightingPopulation
  col1["levelFlow"]["row5"]["freeLabel"].caption = patch.freePopulation
  col1["levelFlow"]["row6"]["boostLabel"].caption = math.floor(patch.freePopulation / 10100 * 9 * 100) .. " %"

  col1["growthFlow"]["row2"]["stabileRadioButton"].state = patch.popGrowthMode == prodHubs.popGrowthMode.STABILE
  col1["growthFlow"]["row3"]["growRadioButton"].state = patch.popGrowthMode == prodHubs.popGrowthMode.GROW
  col1["growthFlow"]["row4"]["boostRadioButton"].state = patch.popGrowthMode == prodHubs.popGrowthMode.BOOST
  local costRow1 = col1["growthFlow"]["row5"]["costFlow"]["costRow1"]
  local costRow2 = col1["growthFlow"]["row5"]["costFlow"]["costRow2"]
  local costRow3 = col1["growthFlow"]["row5"]["costFlow"]["costRow3"]
  costRow1.clear()
  costRow2.clear()
  costRow3.clear()
  if patch.level >= 1 then
    prodHubs.addLabelSprite(player.index, costRow1, 5, "iron-stick", true)
    prodHubs.addLabelSprite(player.index, costRow1, 10, "copper-cable")
  end
  if patch.level >= 5 then
    prodHubs.addLabelSprite(player.index, costRow1, 10, "electronic-circuit")
    prodHubs.addLabelSprite(player.index, costRow2, 50, "stone-brick", true)
  end
  if patch.level >= 7 then
    prodHubs.addLabelSprite(player.index, costRow2, 10, "advanced-circuit")
  end
  if patch.level >= 8 then
    prodHubs.addLabelSprite(player.index, costRow2, 5, "engine-unit")
  end
  if patch.level >= 9 then
    prodHubs.addLabelSprite(player.index, costRow3, 1, "processing-unit", true)
    prodHubs.addLabelSprite(player.index, costRow3, 100, "concrete")
  end

  col2["deployFlow"]["row2"]["deployUnitsTextField"].text = tostring(global.gui[player.index].deployUnitCount)
  col2["deployFlow"]["row2"]["deployUnitsTextField"].enabled = not global.gui[player.index].deployAllUnits
  col2["deployFlow"]["row2"]["deployAllCheckbox"].state = global.gui[player.index].deployAllUnits
end

function prodHubs.addLabelSprite(playerIndex, flow, count, name, isFirst)
  local isFirst = isFirst or false
  local comma = ""
  if not isFirst then comma = ", " end
  flow.add{type="label", name=name .. "-count-label2", caption = comma .. "[item=" .. name .. "]"}
  flow.add{type="label", name=name .. "-count-label", caption = "" .. count}
  flow.add{type="label", name=name .. "-label", caption = {"item-name." .. name}}
end

--function prodHubs.closeVaultGui(player)
--	prodHubs.logF("closeVaultGui", {player})
--	player.gui.relative["vaultGui"].destroy()
--end

function prodHubs.handleVaultButtonPress(player, element)
	prodHubs.logF("handleVaultButtonPress", {player, element})
  local eStats = global.entityStats[global.gui[player.index].entity.unit_number]
	local patch = eStats.patch
  if element.name == "buildVaultButton" then
    if patch.freePopulation < 100 then
      player.print(prodHubs.loadTranslation(player.index,"insufficient") .. " " .. prodHubs.loadTranslation(player.index,"population"), {r=1})
      return
    end
    local inventory = player.get_main_inventory()
    if inventory.get_item_count("iron-plate") < 500 then
      player.print(prodHubs.loadTranslation(player.index,"insufficient") .. " " .. prodHubs.loadTranslation(player.index,"iron_plates"), {r=1})
      return
    end
    if not inventory.can_insert("prodHubs-vault") then
      player.print(prodHubs.loadTranslation(player.index,"inventory_full"), {r=1})
      return
    end
    patch.population = patch.population - 100
    inventory.remove({name="iron-plate", count=500})
    inventory.insert({name="prodHubs-vault", count=1})
    player.print(prodHubs.loadTranslation(player.index,"prodHubs-vault") .. " " .. prodHubs.loadTranslation(player.index,"built"), {g=1})
  elseif element.name == "levelUpButton" then
    if patch.level == 10 then
      player.print(prodHubs.loadTranslation(player.index,"max_level"), {r=1})
      return
    end
    if patch.population < patch.maxPopulation then
      player.print(prodHubs.loadTranslation(player.index,"insufficient") .. " " .. prodHubs.loadTranslation(player.index,"population"), {r=1})
      return
    end
    patch.freePopulation = patch.freePopulation + (math.floor(patch.population) - patch.maxPopulation)
    patch.level = patch.level + 1
    local l = patch.level
    local lm1 = l-1
    local incPop = ((l*l)-(lm1*lm1))*100
    patch.maxPopulation = patch.maxPopulation + incPop
    player.print(prodHubs.loadTranslation(player.index,"prodHubs-vault") .. " " .. prodHubs.loadTranslation(player.index,"leveled_up"), {g=1})
    prodHubs.updateVaultGui(player)
  elseif element.name == "deployUnitsButton" then
    player.opened = nil
    global.gui[player.index].positionPickerType = "deployUnits"
    global.gui[player.index].deployUnitVault = global.gui[player.index].entity
		player.cursor_stack.set_stack({name = "blueprint", count = 1})
		player.cursor_stack.set_blueprint_entities({{name = "prodHubs-picker", entity_number = 1, position = {x=0, y=0}}})
		player.cursor_stack_temporary = true
  end
end

function prodHubs.handleVaultTextChange(player, element, text)
	prodHubs.logF("handleVaultTextChange", {player, element, text})
  global.gui[player.index].deployUnitCount = tonumber(text)
end

function prodHubs.handleVaultCheckboxPress(player, element)
	prodHubs.logF("handleVaultCheckboxPress", {player, element})
  local entity = global.gui[player.index].entity
  local patch = global.entityStats[entity.unit_number].patch
  if element.name == "deployAllCheckbox" then
    global.gui[player.index].deployAllUnits = element.state
  elseif element.name == "stabileRadioButton" then
    patch.popGrowthMode = prodHubs.popGrowthMode.STABILE
  elseif element.name == "growRadioButton" then
    patch.popGrowthMode = prodHubs.popGrowthMode.GROW
  elseif element.name == "boostRadioButton" then
    patch.popGrowthMode = prodHubs.popGrowthMode.BOOST
  end    
  prodHubs.updateVaultGui(player, entity)
end

function prodHubs.handleVaultPositionPicker(player, position)
	prodHubs.logF("handleVaultPositionPicker", {player, position})
  local originalPosition = table.deepcopy(position)
  local eStats = global.entityStats[global.gui[player.index].deployUnitVault.unit_number]
  local patch = eStats.patch
  local deployUnitCount = math.min(patch.freePopulation, global.gui[player.index].deployUnitCount)
  if global.gui[player.index].deployAllUnits then deployUnitCount = patch.freePopulation end
  if deployUnitCount == 0 then
    player.print(prodHubs.loadTranslation(player.index,"no_free_population"), {r=1})    
    return
  end
  local surface = game.surfaces[1]
  local leftToDeploy = deployUnitCount
  local unitGroup = game.surfaces[1].create_unit_group{position=position, force="player"}
  local spawnBiter = 0
  local entity
  local canPlace
  local entityPop
  local dir = 1
  local sideAdded = 0
  local sideLen = 1
  while leftToDeploy > 3 do
    if patch.level >= 9 and leftToDeploy >= 200 + 200*spawnBiter then
      if spawnBiter == 1 then
        canPlace = surface.can_place_entity{name="behemoth-biter", position = position}
        if canPlace then
          entity = surface.create_entity{name="behemoth-biter", position = position, force="player"}
          entityPop = 400
        end
      else
        canPlace = surface.can_place_entity{name="behemoth-spitter", position = position}
        if canPlace then
          entity = surface.create_entity{name="behemoth-spitter", position = position, force="player"}
          entityPop = 200
        end
      end
    elseif patch.level >= 7 and leftToDeploy >= 30 + 50*spawnBiter then
      if spawnBiter == 1 then
        canPlace = surface.can_place_entity{name="big-biter", position = position}
        if canPlace then
          entity = surface.create_entity{name="big-biter", position = position, force="player"}
          entityPop = 80
        end
      else
        canPlace = surface.can_place_entity{name="big-spitter", position = position}
        if canPlace then
          entity = surface.create_entity{name="big-spitter", position = position, force="player"}
          entityPop = 30
        end
      end
    elseif patch.level >= 5 and leftToDeploy >= 12 + 8*spawnBiter then
      if spawnBiter == 1 then
        canPlace = surface.can_place_entity{name="medium-biter", position = position}
        if canPlace then
          entity = surface.create_entity{name="medium-biter", position = position, force="player"}
          entityPop = 20
        end
      else
        canPlace = surface.can_place_entity{name="medium-spitter", position = position}
        if canPlace then
          entity = surface.create_entity{name="medium-spitter", position = position, force="player"}
          entityPop = 12
        end
      end
    elseif patch.level >= 1 and leftToDeploy >= 4 + 0*spawnBiter then
      if spawnBiter == 1 then
        canPlace = surface.can_place_entity{name="small-biter", position = position}
        if canPlace then
          entity = surface.create_entity{name="small-biter", position = position, force="player"}
          entityPop = 4
        end
      else
        canPlace = surface.can_place_entity{name="small-spitter", position = position}
        if canPlace then
          entity = surface.create_entity{name="small-spitter", position = position, force="player"}
          entityPop = 4
        end
      end
    end
    if canPlace then
      leftToDeploy = leftToDeploy - entityPop
      prodHubs.entityCreated(entity)
      global.entityStats[entity.unit_number].fightingPatch = patch
      global.entityStats[entity.unit_number].fightingPopulation = entityPop
      unitGroup.add_member(entity)
      spawnBiter = 1 - spawnBiter
    end
    -- Move position 1 step to make units spawn next to each other
    if dir == 1 then
      position.x = position.x + 1
    elseif dir == 2 then
      position.y = position.y + 1
    elseif dir == 3 then
      position.x = position.x - 1
    elseif dir == 4 then
      position.y = position.y - 1
    end
    sideAdded = sideAdded + 1
    -- If side done, start moving other direction
    if sideAdded == sideLen then
      dir = dir + 1
      sideAdded = 0
      if dir == 5 then dir = 1 end
      -- Move in bigger and bigger squares
      if dir == 3 or dir == 1 then sideLen = sideLen + 1 end
    end
  end
  deployUnitCount = deployUnitCount - leftToDeploy
  patch.fightingPopulation = patch.fightingPopulation + deployUnitCount
  patch.freePopulation = patch.freePopulation - deployUnitCount
  player.print(prodHubs.loadTranslation(player.index,"deployed") .. " " .. deployUnitCount .. " " .. prodHubs.loadTranslation(player.index,"populationS"), {g=1})
  prodHubs.updateVaultGui(player)
  unitGroup.set_command({type=defines.command.attack_area, destination = originalPosition, radius = 10.0})
  table.insert(global.unitGroups, unitGroup)
end