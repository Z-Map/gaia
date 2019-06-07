extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var moving = false
var move = Vector3(0.0,0.0,0.0)
var move_mult = Vector3(1.0,0.0,1.3)

var zoom = 100.0
var gcam_pos = Vector3(0,3,0)
var gcam_rot = Vector3(0,0,0)
var lcam_pos = Vector3(0,18,0)
var lcam_rot = Vector3(-32.0,0,0)
var hcam_pos = Vector3(0,40,0)
var hcam_rot = Vector3(-90,0,0)

func refresh_zoom():
	var lvl = zoom / 100
	if zoom <= 100:
		move_mult = lerp(Vector3(1.0,0.0,1.0), Vector3(1.0,0.0,1.3), lvl)
		$CamMgr.translation = lerp(gcam_pos, lcam_pos, lvl)
		$CamMgr.rotation_degrees = lerp(gcam_rot, lcam_rot, lvl)
	else:
		lvl -= 1.0
		move_mult = lerp(Vector3(1.0,0.0,1.3), Vector3(0.0,0.0,0.0), lvl)
		$CamMgr.translation = lerp(lcam_pos, hcam_pos, lvl)
		$CamMgr.rotation_degrees = lerp(lcam_rot, hcam_rot, lvl)

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_zoom()
	move = translation
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.as_text() == "Escape":
		get_tree().quit()
	if event is InputEventMouseButton:
		if event.button_index == 2:
			moving = event.pressed
		elif event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				zoom -= 4.0
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom += 4.0
			zoom = clamp(zoom, 0.0, 200.0)
			refresh_zoom()
	if event is InputEventMouseMotion and moving:
		move += Vector3(event.relative.x * -0.05, 0, event.relative.y * -0.05)
	move.x = clamp(move.x, -20, 20)
	move.z = clamp(move.z, -20, 28)
	translation = move * move_mult