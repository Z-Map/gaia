extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var lumiere = false
var HUD = null
var grid = null
var x = 0
var y = 0
var boops = []

# Called when the node enters the scene tree for the first time.
func _ready():
	boops.append($Bip0)
	boops.append($Bip1)
	boops.append($Bip2)
	boops.append($Bip3)
	boops.append($Bip4)

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
	boops[rand_range(0,4)].play()
	HUD.call_func_grid(x,y, lumiere)
