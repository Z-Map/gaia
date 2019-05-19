extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.as_text() == "Escape":
		get_tree().quit()
	if event is InputEventMouseButton and event.button_index == 2:
		moving = event.pressed
	if event is InputEventMouseMotion and moving:
		translate(Vector3(event.relative.x * 0.05, 0, event.relative.y * 0.05))