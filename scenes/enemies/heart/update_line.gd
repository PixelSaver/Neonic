@tool
extends Line2D
class_name UpdateLine

@export_range(0.0, 1.0) var display_proportion := 1.0 :
	set(v):
		display_proportion = v
		points[1] = Vector2(-200. + 400. * display_proportion, 0)
