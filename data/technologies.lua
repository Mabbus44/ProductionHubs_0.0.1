-- Railway available early
data.raw["technology"]["engine"].prerequisites = {"steel-processing"}
data.raw["technology"]["engine"].unit = {count = 100, ingredients = {{"automation-science-pack", 1}}, time = 15}
data.raw["technology"]["railway"].prerequisites = {"engine"}
data.raw["technology"]["railway"].unit = {count = 75, ingredients = {{"automation-science-pack", 1}}, time = 30}
data.raw["technology"]["automated-rail-transportation"].unit = {count = 75, ingredients = {{"automation-science-pack", 1}}, time = 30}
data.raw["technology"]["logistic-science-pack"].prerequisites = {"automated-rail-transportation"}
