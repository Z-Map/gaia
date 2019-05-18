extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var bloc_list = []
var green = 0
var yellow = 0
var gris = 0

func refresh_grid():
	green = 0
	yellow = 0
	gris = 0
	for b in bloc_list:
		if b.etat == 1:
			green += 1
		else:
			if b.etat == 2:
				yellow += 1
			else:
				gris += 1
	print("V: " + str(green) + " Y: " + str(yellow) + " G: " + str(gris))

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var HUD_resource = preload("res://HUD.tscn")
	var HUD = HUD_resource.instance()
	add_child(HUD)
	HUD.grille = self
	
	for i in range(5):
		for j in range(9):
			var carreau_resource = preload("res://Carreau.tscn")
			var carreau = carreau_resource.instance()
			carreau.position = Vector2(j*100+100, i*100+100) # use set_translation() if you are in 3D
			if j<2: 
				carreau.etat = 1
				carreau.lumiere = true
			else:
				if j>6: 
					carreau.etat = 2
					carreau.lumiere = false
				else:
					carreau.etat = 0
					if j <4:
						carreau.lumiere = true
					else:
						carreau.lumiere = false
			bloc_list.append(carreau)
			add_child(carreau) # parent could be whatever node in the scene that you want the car to be child of
			carreau.grille = self
	refresh_grid()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
