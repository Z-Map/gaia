extends Spatial

var growth: float = 0.0 setget change_growth

func change_growth(v):
	if v < 0.0:
		v = 0.0
	elif v > 1.0:
		v = 1.0
	growth = v
	print(v)
	for ch in get_children():
		ch.scale = Vector3(v, v, v)

func _ready():
	change_growth(0.0)
