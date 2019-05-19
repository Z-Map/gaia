extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.as_text() == "Escape":
		get_tree().quit()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_ENTER):
		get_tree().change_scene("thanos.tscn")


func _on_Button_pressed():
	get_tree().change_scene("thanos.tscn")
	pass # Replace with function body.
