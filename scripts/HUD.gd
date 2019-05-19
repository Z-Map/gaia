extends Node2D

# Declare member variables here. Examples:
var grid = null
var move_panneau = false
var close_panneau = false
var open_panneau = true

func call_func_grid(x=0,y=0,etat=false):
	grid.update_light_grid(x,y,etat)

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(9):
		for j in range(9):
			var light_resource = preload("res://element/light_tile.tscn")
			var light_tile = light_resource.instance()
			light_tile.HUD = self
			light_tile.position = Vector2(j*25, i*25) # use set_translation() if you are in 3D
			light_tile.x = i
			light_tile.y = j
			if j<2: 
				light_tile.lumiere = true
			else:
				light_tile.lumiere = false
			$Panneau/Pad.add_child(light_tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if move_panneau:
		if open_panneau:
			if $Panneau.position.x < 1210:
				$Panneau.position.x += 15
			else:
				$Panneau/Fleche.show()
				open_panneau = false
				move_panneau = false
		else:
			if $Panneau.position.x > 880:
				$Panneau.position.x -= 15
			else:
				$Panneau/Fleche.hide()
				open_panneau = true
				move_panneau = false

func _on_Button_pressed():
	move_panneau = true
	
