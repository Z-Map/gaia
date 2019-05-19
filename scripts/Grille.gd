extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var grille_etats = [[],[],[],[],[],[],[],[],[]]
var green = 0
var yellow = 0
var gris = 0

func refresh_grid():
	green = 0
	yellow = 0
	gris = 0
	for i in range(9):
		for j in range(9):
			if grille_etats[i][j] == 1:
				green += 1
			else:
				if grille_etats[i][j] == 2:
					yellow += 1
				else:
					gris += 1
	#print("V: " + str(green) + " Y: " + str(yellow) + " G: " + str(gris))

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var HUD_resource = preload("res://HUD.tscn")
	var HUD = HUD_resource.instance()
	add_child(HUD)
	HUD.grille = self
	
	for i in range(9):
		for j in range(9):
			var carreau_resource = preload("res://Carreau.tscn")
			var carreau = carreau_resource.instance()
			carreau.grille = self
			carreau.position = Vector2(j*25+1000, i*25+400) # use set_translation() if you are in 3D
			carreau.x = i
			carreau.y = j
			if j<2: 
				grille_etats[i].append(1)
				carreau.lumiere = true
			else:
				if j>6: 
					grille_etats[i].append(2)
					carreau.lumiere = false
				else:
					grille_etats[i].append(0)
					if j <4:
						carreau.lumiere = true
					else:
						carreau.lumiere = false
			add_child(carreau) # parent could be whatever node in the scene that you want the car to be child of
	refresh_grid()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
