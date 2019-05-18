extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var grille = null
var etat  = 0
var lumiere = true


func update_color():
	print(grille)
	if grille:
		grille.refresh_grid()
	if etat == 1:
		$Panel.modulate = Color( 0, 1, 0)
	else:
		if etat == 2:
			$Panel.modulate = Color( 1, 1, 0.5)
		else:
			$Panel.modulate = Color( 1, 1, 1)
	if lumiere:
		$soleil.show()
		$lune.hide()
	else:
		$soleil.hide()
		$lune.show()
# Called when the node enters the scene tree for the first time.
func _ready():
	if lumiere:
		if etat == 0:
			$PlantBirth.start()
		else: if etat == 2:
			$MushDeath.start()
	else: 
		if etat == 0:
			$MushBirth.start()
		else: if etat == 1:
			$PlantDeath.start()
	update_color()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Button_pressed():
	if lumiere:
		lumiere = false
		if etat == 0:
			
			$MushBirth.start()
		else: if etat == 1:
			$PlantDeath.start()
	else: 
		lumiere = true
		if etat == 0:
			$PlantBirth.start()
		else: if etat == 2:
			$MushDeath.start()
	update_color()

func _on_PlantDeath_timeout():
	etat = 0
	$MushBirth.start()
	update_color()


func _on_MushDeath_timeout():
	etat = 0
	$PlantBirth.start()
	update_color()


func _on_PlantBirth_timeout():
	etat = 1
	update_color()


func _on_MushBirth_timeout():
	etat = 2
	update_color()
