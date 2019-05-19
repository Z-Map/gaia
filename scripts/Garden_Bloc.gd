extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var grid = null
var light_on: bool = false setget change_light 
var x: int = 0
var y: int = 0
# Called when the node enters the scene tree for the first time.

func set_pos(px, py):
	if px == 8:
		$Panel1.rotate_y(PI)
	elif px > 0:
		$Panel1.visible = false
	if py == 8:
		$Panel2.rotate_y(PI)
	elif py > 0:
		$Panel2.visible = false
	x = px
	y = py

func change_light(v = false):
	var layer = 2 if v else 4
	$Panel1.layers = layer
	$Panel2.layers = layer
	$dirt_ground.layers = layer
	#layer = 4 if v else 2
	#$Panel1.layers = layer
	#$Panel2.layers =  layer
	#$dirt_ground.layers = layer
	#print("Set layer " + str(layer) + " on " + str(x) + "," + str(y))
	light_on = v

func _ready():
	change_light(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
