extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cells_grid = null
var light_grid = null

func init_grids(lg_size = 9, cg_size = 3):
	light_grid = []
	for i in range(lg_size):
		light_grid.append([])
		for j in range(lg_size):
			light_grid.append(null)
	cells_grid = []
	for i in range(lg_size * cg_size):
		cells_grid.append([])
		for j in range(lg_size * cg_size):
			cells_grid.append(null)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
