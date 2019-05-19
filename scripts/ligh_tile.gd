extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var lumiere = false
var HUD = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lumiere:
		$soleil.show()
		$lune.hide()
	else:
		$soleil.hide()
		$lune.show()


func _on_Button_pressed():
	lumiere = not lumiere
