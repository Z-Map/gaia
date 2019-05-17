extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var etat  = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if etat == true:
		modulate = Color( 0, 1, 0) 
	else:
		modulate = Color( 1, 1, 0.5)
	pass


func _on_Button_pressed():
	etat = !etat
	pass # Replace with function body.
