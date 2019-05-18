extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var grille = null
var etat  = true

func update_color():
	if grille:
		grille.refresh_grid()
	if etat:
		modulate = Color( 0, 1, 0)
	else:
		modulate = Color( 1, 1, 0.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	update_color()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Button_pressed():
	etat = !etat
	update_color()