extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var i = 0
var j = 0
var a = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(4):
		for j in range(9):
			var carreau_resource = preload("carreau.tscn")
			var carreau = carreau_resource.instance()
			carreau.position = Vector2(j*100+100, i*100+100) # use set_translation() if you are in 3D
			if j<5: 
				carreau.etat = true
			else: 
				carreau.etat = false
			add_child(carreau) # parent could be whatever node in the scene that you want the car to be child of
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
