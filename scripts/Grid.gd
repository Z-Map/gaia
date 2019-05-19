extends Spatial

# Tableau d'objets pour la grille
var cells_grid = null
var light_grid = null

# Cell type count
var plant_count = 0
var shroom_count = 0

# Niveau d'énergie stocké
var power: int = 0
# Énergie généré par tour
var power_input: int = 0
# Énergie maximale stockable
var max_power: int = 0

# Niveau d'oxygen
var oxygen: int = 0

# Consomation d'énergie pour l'eau par tour
var water_output: int = 0

var HUD

func init_grids(lg_size = 9, cg_size = 3):
	light_grid = []
	for i in range(lg_size):
		light_grid.append([])
		for j in range(lg_size):
			light_grid.append(false)
	cells_grid = []
	for i in range(lg_size * cg_size):
		cells_grid.append([])
		for j in range(lg_size * cg_size):
			cells_grid.append(null)
	print("Grid inited with size " + str(lg_size) + " and sub size " + str(cg_size))

func init_HUD(hud_scene = "res://HUD.tscn"):
	HUD_resource = preload(hud_scene)
	HUD = HUD_resource.instance()
	HUD.grid = self
	

# Called when the node enters the scene tree for the first time.
func _ready():
	init_grids()
	init_HUD()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
