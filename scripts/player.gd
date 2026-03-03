@tool
extends RigidBody2D
class_name Player

const POINTS = [
	Vector2(-1,1),
	Vector2(1,1),
	Vector2(1,-1),
	Vector2(-1,-1),
]
#@onready var line: Line2D = $Line2D
@export var health_component : HealthComponent
@export var player_size : float = 80 : 
	set(val):
		player_size = val
		if Engine.is_editor_hint():
			_update_size()

func _ready() -> void:
	_update_size()
	if health_component == null:
		print("Health Component is null")

func _update_size():
	if not is_inside_tree():
		return
	
	if not has_node("Line2D"):
		return
	print("Updating size in editor:", player_size)
		
	var line: Line2D = get_node("Line2D")

	line.closed = true
	line.clear_points()

	for point in POINTS:
		line.add_point(point * player_size)
	line.queue_redraw()
		
