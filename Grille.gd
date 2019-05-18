extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var bloc_list = []
var green = 0
var yellow = 0

func refresh_grid():
	green = 0
	yellow = 0
	for b in bloc_list:
		if b.etat:
			green += 1
		else:
			yellow += 1
	print("G: " + str(green) + " Y: " + str(yellow))

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(4):
		for j in range(9):
			var carreau_resource = preload("Carreau.tscn")
			var carreau = carreau_resource.instance()
			carreau.position = Vector2(j*100+100, i*100+100) # use set_translation() if you are in 3D
			if j<5: 
				carreau.etat = true
			else: 
				carreau.etat = false
			bloc_list.append(carreau)
			add_child(carreau) # parent could be whatever node in the scene that you want the car to be child of
			carreau.grille = self
	refresh_grid()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
