extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var grille = null
var lumiere = true
var x
var y

func update_color(flag_refresh = true):
	if grille and flag_refresh:
		grille.refresh_grid()
	if grille.grille_etats[x][y] == 1:
		$Panel.modulate = Color( 0, 1, 0)
	else:
		if grille.grille_etats[x][y] == 2:
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
	
	$WatchTime.start()
	update_color(false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Button_pressed():
	if lumiere:
		lumiere = false
		if grille.grille_etats[x][y] == 0  and (grille.grille_etats[min(x+1,8)][y] == 2 or grille.grille_etats[x][min(y+1,8)] == 2 or grille.grille_etats[max(x-1,0)][y] == 2 or grille.grille_etats[x][max(y-1,0)] == 2):
			$MushBirth.start()
		else: if grille.grille_etats[x][y] == 1:
			$PlantDeath.start()
	else: 
		lumiere = true
		if grille.grille_etats[x][y] == 0  and (grille.grille_etats[min(x+1,8)][y] == 1 or grille.grille_etats[x][min(y+1,8)] == 1 or grille.grille_etats[max(x-1,0)][y] == 1 or grille.grille_etats[x][max(y-1,0)] == 1):
			$PlantBirth.start()
		else: if grille.grille_etats[x][y] == 2:
			$MushDeath.start()
	update_color()

func _on_PlantDeath_timeout():
	grille.grille_etats[x][y] = 0
	if grille.grille_etats[min(x+1,8)][y] == 2 or grille.grille_etats[x][min(y+1,8)] == 2 or grille.grille_etats[max(x-1,0)][y] == 2 or grille.grille_etats[x][max(y-1,0)] == 2:
		$MushBirth.start()
	update_color()


func _on_MushDeath_timeout():
	grille.grille_etats[x][y] = 0
	if grille.grille_etats[min(x+1,8)][y] == 1 or grille.grille_etats[x][min(y+1,8)] == 1 or grille.grille_etats[max(x-1,0)][y] == 1 or grille.grille_etats[x][max(y-1,0)] == 1:
		$PlantBirth.start()
	update_color()


func _on_PlantBirth_timeout():
	grille.grille_etats[x][y] = 1
	update_color()


func _on_MushBirth_timeout():
	grille.grille_etats[x][y] = 2
	update_color()

func _on_WatchTime_timeout():
	if lumiere:
		if grille.grille_etats[x][y] == 0  and (grille.grille_etats[min(x+1,8)][y] == 1 or grille.grille_etats[x][min(y+1,8)] == 1 or grille.grille_etats[max(x-1,0)][y] == 1 or grille.grille_etats[x][max(y-1,0)] == 1):
			$PlantBirth.start()
		else: if grille.grille_etats[x][y] == 2:
			$MushDeath.start()
	else: 
		if grille.grille_etats[x][y] == 0  and (grille.grille_etats[min(x+1,8)][y] == 2 or grille.grille_etats[x][min(y+1,8)] == 2 or grille.grille_etats[max(x-1,0)][y] == 2 or grille.grille_etats[x][max(y-1,0)] == 2):
			$MushBirth.start()
		else: if grille.grille_etats[x][y] == 1:
			$PlantDeath.start()
	update_color()
