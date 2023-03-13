Patchnotes:

v 0.01
x Unbuildable terrain, exept around resources
x small/endless resource patches
x Remove small bases
x Bases futher apart
x Starting base with all basic resources
x Bring trees, biters, water and cliffs back
x Rail, signals and powerpoles unkillable
x Main vault
x Status ui for buildings
x All buildings require workers
x Build new vault from vault ui
x Increase vault population
x Level up vault from vault ui
x Add workers, fighters and free population to status
x Remove fighter population when units die
x Send workers to attack biter bases from vault ui
x Deploy fighters from vault to map
x Buildings without workers should have a red man icon
x Picking up buildings should redistribute workers to other buildings
x Placeing vault should redistribute workers
x Picking up vault should remove workers
x Buildings are not losing workers when worker count decrease
x Change icon for picker and attack button to be circle of arrows
x Change icon for deploy units
x Unused workers increase miners speed
x biters arent fighting very good
x Buy population cost should depend on population, not level

TODO:
* Tutorial
* Notification when vault can level up
* Autoplace rail blueprints from inventory?


Misc notes to self:
spawn on average one base per 256x256
spawn 1-4 bases per 512x512 in begining, decresing to always 1 at distance 10 000 from starting point
bases at least 150 apart
bases are 10 radius in the begining, increasing to 70 radius at distance 10 000 from starting point
starting base is 20 radius

dist = x * x + y * y
radius = dist / 10000 * 60 + 10
quantity = radius * radius * pi * 0.1
density = (10000-dist+3000)/3000 * quantity / region size / region size

desired quantity = region size * region size * density
desired quantity = spots * quantity

spots = 4 when dist = 0, 1 when dist = 10000
spots = (10000-dist+3000)/3000

spots * quantity = region size * region size * density
density = spots * quantity / region size / region size

/c game.player.print(game.player.position.x .. ", " .. game.player.position.y)
/c game.player.character=nil
/c game.player.insert{name="copper-plate", count=100}
/c game.player.insert{name="iron-plate", count=100}
/c game.player.insert{name="copper-cable", count=100}
/c game.player.insert{name="iron-stick", count=100}
/c game.player.insert{name="stone-furnace", count=100}