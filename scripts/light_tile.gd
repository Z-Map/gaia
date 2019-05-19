extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var lumiere = false setget set_state
var HUD = null
var grid = null
var x = 0
var y = 0
var boops = []
var pressed = false
var hover = false

func update_sprite():
	if not x == 4 or not y == 4:
		if lumiere:
			$soleil.show()
			$lune.hide()
		else:
			$soleil.hide()
			$lune.show()
	else:
		$soleil.hide()
		$lune.hide()

func set_state(v):
	if v != lumiere:
		lumiere = not lumiere
		boops[rand_range(0,4)].play()
		update_sprite()


# Called when the node enters the scene tree for the first time.
func _ready():
	boops.append($Bip0)
	boops.append($Bip1)
	boops.append($Bip2)
	boops.append($Bip3)
	boops.append($Bip4)
	update_sprite()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func press_btn():
	HUD.set_light(x, y, not lumiere)
	pressed = true

func _on_Area2D_mouse_entered():
	if not x == 4 or not y == 4:
		HUD.focus_tile = self
		hover = true
		if HUD.light_toggle_mode == null or HUD.light_toggle_mode == lumiere:
			if HUD.light_toggling and not pressed:
				press_btn()

func _on_Area2D_mouse_exited():
	hover = false
