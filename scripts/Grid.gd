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

func update_light_grid(x=0, y=0,etat = false):
	light_grid[x][y] = etat

func init_grids(lg_size = 9, cg_size = 3):
	light_grid = []
	for i in range(lg_size):
		light_grid.append([])
		for j in range(lg_size):
			light_grid[i].append(false)
	cells_grid = []
	for i in range(lg_size * cg_size):
		cells_grid.append([])
		for j in range(lg_size * cg_size):
			cells_grid[i].append(null)
	print("Grid inited with size " + str(lg_size) + " and sub size " + str(cg_size))

func init_HUD():
	var HUD_resource = preload("res://HUD.tscn")
	HUD = HUD_resource.instance()
	HUD.grid = self
	$UI.add_child(HUD)

# Called when the node enters the scene tree for the first time.
func _ready():
	init_grids()
	init_HUD()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
