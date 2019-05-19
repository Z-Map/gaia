extends Spatial

var lvl = 0
var pos_x = 0
var pos_y = 0

func refresh_shape():
	pass

func set_pos(x, y):
	pos_x = x
	pos_y = y
	translate(Vector3(-26 + x * 2, 0.0, -26 + y * 2))


# Called when the node enters the scene tree for the first time.
func _ready():
	$lvl2.growth = 0
	$growth.start()

func _process(delta):
	$lvl1.growth = 1.0 - ($growth.time_left / $growth.wait_time)
	
