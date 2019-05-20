extends Spatial

export(int) var growth_lvl1:int = 10
export(int) var death_lvl1:int = 5

export(int) var growth_lvl2:int = 20
export(int) var death_lvl2:int = 10

export(int) var growth_lvl3:int = 25
export(int) var death_lvl3:int = 5

var grid = null

var type = 1

var lvl = 0
var pos_x = 0
var pos_y = 0
var light = false setget set_light
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
				time = death_lvl3
			offset = 0
			current_time = time
			$death.start(adv * time)
	light = v
	
func next_level():
	$death.stop()
	$growth.stop()
	if lvl == 0:
		current_level = $lvl2
		current_time = growth_lvl2
	elif lvl == 1:
		current_level = $lvl3
		current_time = growth_lvl3
	else:
		return
	offset = 0
	$growth.start(current_time)
	lvl += 1

func prev_level():
	$death.stop()
	$growth.stop()
	if lvl >= 3:
		current_level = $lvl3
		current_time = death_lvl3
	if lvl == 2:
		current_level = $lvl2
		current_time = death_lvl2
	elif lvl == 1:
		current_level = $lvl1
		current_time = death_lvl1
	else:
		return
	offset = 0
	$death.start(current_time)
	lvl -= 1

func set_pos(x, y):
	pos_x = x
	pos_y = y
	translate(Vector3(-26 + y * 2, 0.0, -26 + x * 2))

func refresh_shape():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	rotate_y(PI * rand_range(0.0, 2.0))
	$lvl1.growth = 0
	$lvl2.growth = 0
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
