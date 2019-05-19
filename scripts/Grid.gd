extends Spatial

# Tableau d'objets pour la grille
var cells_grid = null
var light_inited = false
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

var Plant_tile = preload("res://element/plant_tile.tscn")
var Champi_tile = preload("res://element/champi_tile.tscn")

var HUD

func update_light_grid(x = 0, y = 0, etat = false):
	if light_inited:
		light_grid[x][y].light_on = etat

func init_grids(lg_size = 9, cg_size = 3):
	light_grid = []
	for i in range(lg_size):
		light_grid.append([])
		for j in range(lg_size):
			light_grid[i].append(null)
	cells_grid = []
	for i in range(lg_size * cg_size):
		cells_grid.append([])
		for j in range(lg_size * cg_size):
			cells_grid[i].append(null)
	print("Grid inited with size " + str(lg_size) + " and sub size " + str(cg_size))

func init_blocs():
	var light_bloc = preload("res://element/Garden_Bloc.tscn")
	for i in range(len(light_grid)):
		for j in range(len(light_grid[i])):
			light_grid[i][j] = light_bloc.instance()
			light_grid[i][j].grid = self
			light_grid[i][j].set_pos(i, j)
			light_grid[i][j].translation = Vector3(-24 + float(j * 6), 0, -24 + float(i * 6))
			add_child(light_grid[i][j])
	light_inited = true

func init_HUD():
	var HUD_resource = preload("res://HUD.tscn")
	HUD = HUD_resource.instance()
	HUD.grid = self
	$UI.add_child(HUD)

func init_music():
	$Music.play()

func add_plant(x, y):
	if not cells_grid[x][y]:
		cells_grid[x][y] = Plant_tile.instance()
		cells_grid[x][y].set_pos(x, y)
		cells_grid[x][y].light = light_grid[x / 3][y / 3].light_on
		add_child(cells_grid[x][y])
		return true
	else:
		return false
		
func add_champi(x, y):
	if not cells_grid[x][y]:
		cells_grid[x][y] = Champi_tile.instance()
		cells_grid[x][y].set_pos(x, y)
		cells_grid[x][y].light = light_grid[x / 3][y / 3].light_on
		add_child(cells_grid[x][y])
		return true
	else:
		return false

func start_gardening():
	for i in range(3,6):
		for j in range(3,6):
			HUD.set_light(i, j, true)
	for i in range(0,2):
		for j in range(0,2):
			HUD.set_light(i, j, true)
	HUD.set_light(2, 1, true)
	for i in range(7,9):
		for j in range(6,9):
			HUD.set_light(i, j, true)
	for i in range(12,15):
		for j in range(12,15):
			if i != 13 or j != 13:
				add_plant(i,j)
	for i in range(3,6):
		for j in range(0,3):
			add_plant(i,j)
	for i in range(21,24):
		for j in range(3,6):
			add_champi(i,j)
# Called when the node enters the scene tree for the first time.
func _ready():
	init_music()
	init_grids()
	init_blocs()
	init_HUD()
	
	start_gardening()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	power+=0.5
#	pass
