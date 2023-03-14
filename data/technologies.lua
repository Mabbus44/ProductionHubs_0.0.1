-- Railway available early
data.raw["technology"]["engine"].prerequisites = {"steel-processing"}
data.raw["technology"]["engine"].unit = {count = 50, ingredients = {{"automation-science-pack", 1}}, time = 15}
data.raw["technology"]["railway"].prerequisites = {"engine"}
data.raw["technology"]["railway"].unit = {count = 50, ingredients = {{"automation-science-pack", 1}}, time = 15}
data.raw["technology"]["automated-rail-transportation"].unit = {count = 75, ingredients = {{"automation-science-pack", 1}}, time = 30}
data.raw["technology"]["logistic-science-pack"].prerequisites = {"automated-rail-transportation"}

-- Remove ways for character to fight
data.raw["technology"]["flamethrower"].effects = {{recipe = "flamethrower-ammo",type = "unlock-recipe"},{recipe = "flamethrower-turret",type = "unlock-recipe"}}
data.raw["technology"]["military"].effects = {{recipe = "shotgun-shell",type = "unlock-recipe"}}
data.raw["technology"]["military-3"].effects = {{recipe = "poison-capsule",type = "unlock-recipe"},{recipe = "slowdown-capsule",type = "unlock-recipe"}}
data.raw["technology"]["rocketry"].effects = {{recipe = "rocket",type = "unlock-recipe"}}
