extends Spatial

var grid = null
var pos_x = 0
var pos_y = 0

# Type : champi = 1 / plant = 0
var type = 0

var light = false setget set_light
var power = 1 setget set_power

# Growth / Death mechanism
var lvl = 0
var max_lvl = 0
var growing = false setget set_growing
var should_grow = true
var dying = false setget set_dying

export(float) var growth_lvl1:float = 12
export(float) var death_lvl1:float = 6

export(float) var growth_lvl2:float = 30
export(float) var death_lvl2:float = 15

export(float) var growth_lvl3:float = 18
export(float) var death_lvl3:float = 9

var growth_offset: float = 0
var current_time: float = 0
var current_growth: float = 0.0
var current_level

func refresh_growing():
	if (power >=  2 or (power and not max_lvl)) and light and should_grow:
		set_growing(true)
	else:
		set_growing(false)
	if power and light:
		set_dying(false)
	else:
		set_dying(true)

func set_power(v):
	if power != v:
		power = v
		refresh_growing()

func set_growing(v):
	if v != growing:
		$growth.paused = not(v)
		growing = v
	
func set_dying(v):
	if v != dying:
		dying = v
		update_growth_mechanism()
		growth_offset = max(current_growth, 0.01) * current_time
		if v:
			$growth.stop()
			$death.start(growth_offset)
		else:
			$death.stop()
			$growth.start(current_time - growth_offset)

func update_growth_mechanism():
	if lvl <= 0:
		$lvl2.growth = 0
		$lvl3.growth = 0
		current_level = $lvl1
		current_time = death_lvl1 if dying else growth_lvl1
	elif lvl == 1:
		$lvl1.growth = 1.0
		$lvl3.growth = 0
		current_level = $lvl2
		current_time = death_lvl2 if dying else growth_lvl2
	else:
		$lvl1.growth = 1.0
		$lvl2.growth = 1.0
		current_level = $lvl3
		current_time = death_lvl3 if dying else growth_lvl3

func set_light(v = false):
	$lvl1.change_layer(v)
	$lvl2.change_layer(v)
	$lvl3.change_layer(v)
	light = v
	refresh_growing()

func next_level():
	if lvl < 2:
		$growth.stop()
		lvl += 1
		if max_lvl < lvl:
			max_lvl = lvl
		growth_offset = 0.0
		current_growth = 0.0
		should_grow = false
		update_growth_mechanism()
		$growth.start(current_time)
		refresh_growing()

func prev_level():
	if lvl > 0:
		lvl -= 1
	else:
		grid.plant_die(pos_x, pos_y)
	update_growth_mechanism()
	current_growth = 1.0
	growth_offset = current_time
	if dying:
		$death.start(growth_offset)
	else:
		refresh_growing()
	
func refresh_shape():
	pass

func set_pos(x, y):
	pos_x = x
	pos_y = y
	translate(Vector3(-26 + y * 2, 0.0, -26 + x * 2))


# Called when the node enters the scene tree for the first time.
func _ready():
	growth_lvl1 += rand_range(-3,3)
	death_lvl1 += rand_range(-2,2)
	growth_lvl2 += rand_range(-4,4)
	death_lvl2 += rand_range(-1,1)
	growth_lvl3 += rand_range(-3,3)
	death_lvl3 += rand_range(-1,1)
	rotate_y(PI * rand_range(0.0, 2.0))
	var rands = rand_range(0.7, 1.5)
	scale_object_local(Vector3(rands, rands, rands))
	
	$lvl1.growth = 0
	update_growth_mechanism()
	set_growing(true)
	set_dying(false)
	$growth.start(current_time)

func _process(delta):
	if dying:
		current_growth =  $death.time_left / current_time
	elif growing:
		current_growth = (growth_offset + ($growth.wait_time - $growth.time_left)) / current_time
	current_level.growth = current_growth

func _on_growth_timeout():
	next_level()

func _on_death_timeout():
	prev_level()

func _on_lolilol_timeout():
	if not dying and not should_grow:
		if lvl < 3 and rand_range(0,3) >= 2:
			should_grow = true
			refresh_growing()
		else:
			grid.plant_ready(pos_x, pos_y)
