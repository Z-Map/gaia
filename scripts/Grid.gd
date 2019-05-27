extends Spatial

export(float) var round_scale: float = 0.1

# Tableau d'objets pour la grille
var cells_grid = null
var light_inited = false
var light_grid = null

# Cell type count
var plant_count = 0
var plant_lvl = 0
var shroom_count = 0
var shroom_lvl = 0

# Niveau d'énergie stocké
export(int) var power: float = 130
# Énergie généré par tour
var power_input: float = 0
# Énergie maximale stockable
export(int) var max_power: float = 1000

# Niveau d'oxygen
export(int) var oxygen_input: float = 0
export(int) var oxygen: float = 30
export(int) var max_oxygen: float = 100

# Consomation d'énergie pour l'eau par tour
var water_output: float = 0
var light_output: float = 0

var Plant_tile = preload("res://element/plant_tile.tscn")
var Champi_tile = preload("res://element/champi_tile.tscn")

var HUD

func update_light_grid(x = 0, y = 0, etat = false):
	if light_inited:
		light_output += 1 if etat else -1
		light_grid[x][y].light_on = etat
		for i in range(0,3):
			for j in range(0,3):
				if cells_grid[x * 3 + i][y * 3 + j]:
					cells_grid[x * 3 + i][y * 3 + j].light = etat

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
			light_grid[i][j].translation = Vector3(-24 + (j * 6), 0, -24 + (i * 6))
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
	if x == 13 and y == 13:
		return false
	if not cells_grid[x][y]:
		cells_grid[x][y] = Plant_tile.instance()
		cells_grid[x][y].grid = self
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
		cells_grid[x][y].grid = self
		cells_grid[x][y].light = light_grid[x / 3][y / 3].light_on
		add_child(cells_grid[x][y])
		return true
	else:
		return false

func start_gardening():
	for i in range(3,6):
		for j in range(3,6):
			HUD.set_light(i, j, true)
	"""for i in range(0,2):
		for j in range(0,2):
			HUD.set_light(i, j, true)"""
	#HUD.set_light(2, 1, true)
	"""for i in range(7,9):
		for j in range(6,9):
			HUD.set_light(i, j, true)"""
	for i in range(12,15):
		for j in range(12,15):
			if i != 13 or j != 13:
				add_plant(i,j)
	"""for i in range(3,6):
		for j in range(0,3):
			add_plant(i,j)"""
	for i in range(0,3):
		for j in range(18,21):
			add_champi(i,j)
	for i in range(21,24):
		for j in range(3,6):
			add_champi(i,j)
	HUD.play_sound = true
# Called when the node enters the scene tree for the first time.
func _ready():
	init_music()
	init_grids()
	init_blocs()
	init_HUD()
	
	start_gardening()
	print("Actual : " + str(power) + " - output : " + str(water_output + light_output) + " - input : " + str(power_input))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func plant_ready(x, y):
	for i in [-1,0,1]:
		for j in [-1,0,1]:
			if i or j:
				var k = x + i
				var l = y + j
				if k >= 0 and k < 27 and l >= 0 and l < 27:
					if not cells_grid[k][l] and light_grid[k / 3][l / 3].light_on:
						add_plant(k, l)

func champi_ready(x,y):
	for i in [-1,0,1]:
		for j in [-1,0,1]:
			if i or j:
				var k = x + i
				var l = y + j
				if k >= 0 and k < 27 and l >= 0 and l < 27:
					if not cells_grid[k][l] and not light_grid[k / 3][l / 3].light_on and oxygen_input > 0.0:
						add_champi(k, l)

func plant_grown(x, y):
	pass

func champi_grown(x, y):
	pass

func plant_die(x, y):
	cells_grid[x][y].queue_free()
	cells_grid[x][y] = null
	
func champi_die(x, y):
	cells_grid[x][y].queue_free()
	cells_grid[x][y] = null

func update_values():
	plant_count = 0
	plant_lvl = 0
	shroom_count = 0
	shroom_lvl = 0
	oxygen_input = 0
	for x in range(len(cells_grid)):
		for y in range(len(cells_grid[x])):
			if cells_grid[x][y]:
				var entity = cells_grid[x][y]
				if entity.type:
					shroom_count += 1
					shroom_lvl += entity.lvl
				else:
					plant_count += 1
					plant_lvl += entity.lvl
					if entity.light:
						oxygen_input += float(entity.lvl) / 2.0

func _on_Tour_timeout():
	update_values()
	power_input = shroom_count
	water_output = plant_lvl
	var npower = power + ((power_input - water_output - light_output) * round_scale)
	if npower < 0:
		npower = 0
	elif npower > max_power:
		npower = max_power
	if npower != power:
		power = npower
		print("Actual : " + str(power) + " - output : " + str(water_output + light_output) + " - input : " + str(power_input))
	oxygen += (oxygen_input - (shroom_lvl / 3.0)) * round_scale
	if oxygen > max_oxygen:
		oxygen = max_oxygen
	elif oxygen < 0:
		oxygen = 0.0