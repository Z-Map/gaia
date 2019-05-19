extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var grille = null

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(9):
		for j in range(9):
			var light_resource = preload("res://element/light_tile.tscn")
			var light_tile = light_resource.instance()
			light_tile.HUD = self
			light_tile.position = Vector2(j*25+1000, i*25+400) # use set_translation() if you are in 3D
			if j<2: 
				light_tile.lumiere = true
			else:
				if j>6: 
					light_tile.lumiere = false
				else:
					if j <4:
						light_tile.lumiere = true
					else:
						light_tile.lumiere = false
			add_child(light_tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Air.text = "Plantes : "+str(grille.green)
	$Energie.text = "Champis : "+str(grille.yellow)
