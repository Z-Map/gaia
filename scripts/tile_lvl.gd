extends Spatial

var growth: float = 0.0 setget change_growth

func change_growth(v):
	growth = v
	for ch in get_children():
		ch.set("blend_shapes/Germ", 1)

func _ready():
	pass
