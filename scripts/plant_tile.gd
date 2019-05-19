extends Spatial

var lvl = 0

func refresh_shape():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	$lvl2.growth = 0
	$growth.start()
	var grille_resource = preload("res://Grille.tscn")
	var grille = grille_resource.instance()
	add_child(grille)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	$lvl1.growth = 1.0 - ($growth.time_left / $growth.wait_time)
	
