extends Node2D

# Declare member variables here. Examples:
var grid = null

var move_panneau = false
var move_panneau_gauche = false

var close_panneau = false
var open_panneau = true
var close_panneau_gauche = false
var open_panneau_gauche = true

var light_toggling = false
var light_toggle_mode = null
var tiles = []
var focus_tile = null

var play_sound = false

var debug_line: String = ""

func call_func_grid(x=0,y=0,etat=false):
	grid.update_light_grid(x,y,etat)

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(9):
		tiles.append([])
		for j in range(9):
			var light_resource = preload("res://element/light_tile.tscn")
			var light_tile = light_resource.instance()
			light_tile.HUD = self
			light_tile.position = Vector2(j*25, i*25) # use set_translation() if you are in 3D
			light_tile.x = i
			light_tile.y = j
			light_tile.lumiere = false
			tiles[i].append(light_tile)
			$Panneau/Pad.add_child(light_tile)

func set_light(x, y, state = false):
	if tiles[x][y].lumiere != state:
		light_toggle_mode = not state
		call_func_grid(x,y, state)
		tiles[x][y].lumiere = state

func reset_button_press():
	light_toggle_mode = null
	for tab in tiles:
		for subtab in tab:
			subtab.pressed = false
	
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
				
	if move_panneau_gauche:
		print(str($Panneau_Gauche.position.x))
		print(str(open_panneau_gauche))
		if open_panneau_gauche:
			if $Panneau_Gauche.position.x < 400:
				$Panneau_Gauche.position.x += 15
			else:
				$Panneau_Gauche/Fleche_Gauche.show()
				open_panneau_gauche = false
				move_panneau_gauche = false
		else:
			if $Panneau_Gauche.position.x > 65:
				$Panneau_Gauche.position.x -= 15
			else:
				$Panneau_Gauche/Fleche_Gauche.hide()
				open_panneau_gauche = true
				move_panneau_gauche = false
	get_node("Panneau/Barre").value = (grid.power / grid.max_power) * 100
	get_node("Panneau/Ecran/power_input").text = str(-grid.power_loss)
	get_node("Panneau/Gauge/Aiguille").rotation = ((grid.oxygen / grid.max_oxygen) * 0.5 - 0.25) * PI
	$DebugTxt.text = debug_line

func _input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			light_toggling = true
			if focus_tile and focus_tile.hover:
				focus_tile.press_btn()
		else:
			light_toggling = false
			reset_button_press()
			

func _on_Button_pressed():
	move_panneau = true
	


func _on_Button_Gauche_pressed():
	move_panneau_gauche = true
