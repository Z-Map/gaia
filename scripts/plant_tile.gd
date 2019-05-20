extends Spatial

export(int) var growth_lvl1:int = 60
export(int) var death_lvl1:int = 24

var grid = null

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
	if current_level and v != light:
		var adv = current_level.growth
		var time
		$death.stop()
		$growth.stop()
		if v:
			if lvl == 0:
				time = growth_lvl1
			else:
				time = 0
			offset = adv * time
			current_time = time
			$growth.start(time - offset)
		else:
			if lvl == 0:
				time = death_lvl1
			else:
				time = 0
			offset = 0
			current_time = time
			$death.start(adv * time)
	light = v

#func next_level():
	

#func prev_level():
	

func refresh_shape():
	pass

func set_pos(x, y):
	pos_x = x
	pos_y = y
	translate(Vector3(-26 + y * 2, 0.0, -26 + x * 2))


# Called when the node enters the scene tree for the first time.
func _ready():
	$lvl1.growth = 0
	$lvl2.growth = 0
	current_level = $lvl1
	current_time = growth_lvl1
	offset = 0
	$growth.start(current_time)

func _process(delta):
	if light:
		current_level.growth = (offset + ($growth.wait_time - $growth.time_left)) / current_time
	else:
		current_level.growth =  $death.time_left / current_time


func _on_growth_timeout():
	if lvl == 0:
		grid.plant_ready(pos_x, pos_y)
	


func _on_death_timeout():
	if lvl == 0:
		grid.plant_die(pos_x, pos_y)
