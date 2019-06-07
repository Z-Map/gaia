extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var grid = null
var light_on: bool = false setget change_light 
var x: int = 0
var y: int = 0
var dbg_col: Color = Color(1.0,1.0,1.0, 0.0) setget set_dbg_col


func set_pos(px, py):
	x = px
	y = py
	translate(Vector3(-26 + y * 2, 0.0, -26 + x * 2))
	
func set_dbg_col(v:Color):
	$DebugImg.modulate = v
	$DebugImg.opacity = v.a
	if v.a <= 0.01:
		$DebugImg.visible = false
	else:
		$DebugImg.visible = true
	dbg_col = v

func change_light(v = false):
	light_on = v

func _ready():
	change_light(false)
	set_dbg_col(dbg_col)

