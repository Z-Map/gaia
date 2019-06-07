extends Spatial

export(int) var growth_type = 0
var growth: float = 0.0 setget change_growth

var original_scale = null

func change_layer(v = false):
	var layer = 2 if v else 4
	for ch in get_children():
		ch.layers = layer

func change_growth(v):
	if v < 0.0:
		v = 0.0
	elif v > 1.0:
		v = 1.0
	growth = v
	var growth_vec = Vector3(v, v, v)
	if growth_type == 1:
		growth_vec = Vector3(1, v, 1)
	elif growth_type == 2:
		growth_vec = Vector3(v, 1, v)
	var i = 0
	if original_scale != null:
		for ch in get_children():
			ch.scale = growth_vec * original_scale[i]
			i += 1

func _ready():
	original_scale = []
	for ch in get_children():
		original_scale.append(ch.scale)
	change_growth(0.0)
