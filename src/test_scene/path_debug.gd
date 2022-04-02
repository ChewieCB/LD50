extends Path2D

func _draw():
	for _point in self.curve.get_baked_points():
		draw_circle(_point, 2, Color(0.6, 0, 0.7, 0.4))
