extends Spatial

var grid = null
var pos_x = 0
var pos_y = 0

# Type : champi = 1 / plant = 0
var type = 1

var light = false setget set_light

# Growth / Death mechanism
var lvl = 0
var max_lvl = 0

export(float) var growth_lvl1:float = 6
export(float) var death_lvl1:float = 3

export(float) var growth_lvl2:float = 12
export(float) var death_lvl2:float = 6

export(float) var growth_lvl3:float = 22
export(float) var death_lvl3:float = 11

var offset = 0
var current_time = 0

var current_level

func set_light(v = false):
	$lvl1.change_layer(v)
	$lvl2.change_layer(v)
	$lvl3.change_layer(v)
	if current_level and v != light:
		var adv = current_level.growth
		var time
		$growth.stop()
		$death.stop()
		if not v:
			if lvl == 0:
				time = growth_lvl1
			elif lvl == 1:
				time = growth_lvl2
			else:
				time = growth_lvl3
			offset = adv * time
			current_time = time
			$growth.start(time - offset)
		else:
			if lvl == 0:
				time = death_lvl1
			elif lvl == 1:
				time = death_lvl2
			else:
				lvl = 2
				time = death_lvl3
			offset = 0
			current_time = time
			$death.start(adv * time)
	light = v
	
func next_level():
	$death.stop()
	$growth.stop()
	lvl += 1
	if lvl > max_lvl:
		max_lvl = lvl
	if lvl == 1:
		current_level = $lvl2
		current_time = growth_lvl2
		if not max_lvl:
			grid.champi_grown(pos_x,pos_y)
	elif lvl == 2:
		current_level = $lvl3
		current_time = growth_lvl3
	else:
		return
	offset = 0
	$growth.start(current_time)

func prev_level():
	$death.stop()
	$growth.stop()
	if lvl >= 2:
		lvl = 1
		current_level = $lvl2
		current_time = death_lvl2
	elif lvl == 1:
		lvl = 0
		current_level = $lvl1
		current_time = death_lvl1
	else:
		return
	offset = 0
	$death.start(current_time)

func set_pos(x, y):
	pos_x = x
	pos_y = y
	translate(Vector3(-26 + y * 2, 0.0, -26 + x * 2))

func refresh_shape():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	# Randomisation des valeurs
	growth_lvl1 += rand_range(-2,2)
	death_lvl1 += rand_range(-1,1)
	growth_lvl2 += rand_range(-3,3)
	death_lvl2 += rand_range(-2,2)
	growth_lvl3 += rand_range(-3,3)
	death_lvl3 += rand_range(-1,1)
	rotate_y(PI * rand_range(0.0, 2.0))
	var rands = rand_range(0.7, 1.5)
	scale_object_local(Vector3(rands, rands, rands))
	
	# Setup growth
	$lvl1.growth = 0
	$lvl2.growth = 0
	$lvl3.growth = 0
	current_level = $lvl1
	current_time = growth_lvl1
	offset = 0
	$growth.start(current_time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not light:
		current_level.growth = (offset + ($growth.wait_time - $growth.time_left)) / current_time
	else:
		current_level.growth =  $death.time_left / current_time
	
func _on_growth_timeout():
	grid.champi_ready(pos_x, pos_y)
	next_level()
	

func _on_death_timeout():
	if lvl == 0:
		grid.champi_die(pos_x, pos_y)
	else:
		prev_level()


func _on_lolilol_timeout():
	if lvl > 0 and not light:
		grid.champi_ready(pos_x, pos_y)
