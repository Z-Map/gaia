extends Spatial

export(float) var round_scale: float = 0.1

# Tableau d'objets pour la grille
var cells_grid = null
var light_inited = false
var light_grid = null
var dbg_grid = null

# Cell type count
var plant_count = 0
var plant_lvl = 0
var shroom_count = 0
var shroom_lvl = 0

var dbg_counter: int = 0

# Niveau d'énergie stocké
export(int) var power: float = 130
# Énergie généré par tour
var power_input: float = 0
# Énergie maximale stockable
export(int) var max_power: float = 1000
var power_loss: float = 0

# Niveau d'oxygen
export(int) var oxygen_input: float = 0
export(int) var oxygen: float = 30
export(int) var max_oxygen: float = 100

# Consomation d'énergie pour l'eau par tour
var water_output: float = 0
var light_output: float = 0

var Plant_tile = preload("res://element/plant_tile.tscn")
var Champi_tile = preload("res://element/champi_tile.tscn")
var Grid_HUD = preload("res://element/grid_hud.tscn")

var HUD

static func spiral_loop(cb, args):
	var i:int = 1
	var x:int = 13
	var y:int = 13
	var dir:Vector2 = Vector2(1, 0)
	while i <= 27:
		for j in range(2):
			for k in range(i):
				x += dir.x
				y += dir.y
				if x > 26 or y > 26:
					break
				args = cb.call_func(x, y, args)
			if x > 26 or y > 26:
				break
			dir = dir.rotated(PI / 2).round()
		i += 1
	return args

func update_light_grid(x:int = 0, y:int = 0, etat = false):
	if light_inited and etat != light_grid[x][y].light_on:
		light_output += 1 if etat else -1
		light_grid[x][y].light_on = etat
		for i in range(x * 3, (x + 1) * 3):
			for j in range(y * 3, (y + 1) * 3):
				if cells_grid[i][j]:
					cells_grid[i][j].light = etat
					dbg_grid[i][j].light_on = etat

func init_grids(lg_size = 9, cg_size = 3):
	light_grid = []
	for i in range(lg_size):
		light_grid.append([])
		for j in range(lg_size):
			light_grid[i].append(null)
	cells_grid = []
	dbg_grid = []
	for i in range(lg_size * cg_size):
		cells_grid.append([])
		dbg_grid.append([])
		for j in range(lg_size * cg_size):
			cells_grid[i].append(null)
			dbg_grid[i].append(null)
			dbg_grid[i][j] = Grid_HUD.instance()
			dbg_grid[i][j].grid = self
			dbg_grid[i][j].set_pos(i, j)
			add_child(dbg_grid[i][j])
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
					if not cells_grid[k][l] and not light_grid[k / 3][l / 3].light_on:
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
	power_input = 0
	for x in range(len(cells_grid)):
		for y in range(len(cells_grid[x])):
			if cells_grid[x][y]:
				var entity = cells_grid[x][y]
				if entity.type:
					shroom_count += 1
					shroom_lvl += entity.lvl
					power_input += 0.2 * entity.lvl
				else:
					plant_count += 1
					plant_lvl += entity.lvl
					if entity.light:
						oxygen_input += float(entity.lvl)

func power_distribution(x, y, args):
	if cells_grid[x][y] and cells_grid[x][y].type == 0:
		var p = cells_grid[x][y]
		if p.lvl < 3 and args[0] > args[1]:
			p.power = 2
			args[0] -= 2
			#water_output += 2
		elif args[0] >= 1.0:
			p.power = 1
			args[0] -= 1
			#water_output += 1
		else:
			p.power = 0
		args[1] -= 1
	return args

func spore_distribution():
	pass

func _on_Tour_timeout():
	update_values()
	power_loss = 0
	if power_input < 8:
		power_loss += light_output + 8 - power_input
		power_input = 8
	elif power_input >= (light_output + 8):
		power_input -= light_output
	else:
		light_output -= power_input - 8
		power_input = 8
		power_loss += light_output
	var result = spiral_loop(funcref(self, "power_distribution"), [power_input, plant_count])
	power_loss -= result[0]
	var npower = power - (power_loss * round_scale)
	if npower < 0:
		npower = 0
	elif npower > max_power:
		npower = max_power
	if npower != power:
		power = npower
	HUD.debug_line = "Actual : " + str(power) + " - output : " + str(result) + " - input : " + str(power_input)
	oxygen += (oxygen_input - (shroom_lvl / 3.0)) * round_scale
	if oxygen > max_oxygen:
		oxygen = max_oxygen
	elif oxygen < 0:
		oxygen = 0.0

func test_loop(max_loopyloop):
	if not light_inited:
		return
	var i:int = 1
	var x:int = 13
	var y:int = 13
	var dir:Vector2 = Vector2(1, 0)
	while i <= 27:
		for j in range(2):
			for k in range(i):
				x += dir.x
				y += dir.y
				if x > 26 or y > 26:
					break
				if max_loopyloop > 0:
					dbg_grid[x][y].dbg_col = Color.from_hsv(float(max_loopyloop) / 81, 1.0, 1.0, 0.5) 
					max_loopyloop -= 1
			if x > 26 or y > 26:
				break
			dir = dir.rotated(PI / 2).round()
		i += 1

func  dbg_loop(x, y, counter):
	if counter > 0:
		dbg_grid[x][y].dbg_col = Color.from_hsv(float(counter) / 81, 1.0, 1.0, 0.5) 
		counter -= 1
	return counter

func _on_Debugtime_timeout():
	#spiral_loop(funcref(self, "dbg_loop"), dbg_counter)
	#dbg_counter += 1
	pass

func _on_Music_finished():
	$Music.play()
