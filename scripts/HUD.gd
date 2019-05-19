extends Node2D

# Declare member variables here. Examples:
var grid = null

func call_func_grid(x=0,y=0,etat=false):
	grid.update_light_grid(x,y,etat)

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(9):
		for j in range(9):
			var light_resource = preload("res://element/light_tile.tscn")
			var light_tile = light_resource.instance()
			light_tile.HUD = self
			light_tile.position = Vector2(j*25+1025, i*25+450) # use set_translation() if you are in 3D
			light_tile.x = i
			light_tile.y = j
			if j<2: 
				light_tile.lumiere = true
			else:
				light_tile.lumiere = false
			add_child(light_tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grid:
		$Air.text = "Air : " + str(grid.oxygen)
		$Energie.text = "Energie : "+str(grid.power)
