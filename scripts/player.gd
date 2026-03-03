@tool
extends RigidBody2D
class_name Player

const POINTS = [
	Vector2(-1,1),
	Vector2(1,1),
	Vector2(1,-1),
	Vector2(-1,-1),
]

@export_group("Script Exports")
@export var line : Line2D
@export var collision_shape : CollisionPolygon2D
@export var health_component : HealthComponent
@export_group("Player Shape")
@export var player_size : float = 80 : 
	set(val):
		player_size = val
		if Engine.is_editor_hint():
			_update_size()
@export_group("Player Movement")
@export var acceleration : float = 15000

func _ready() -> void:
	_update_size()
	if health_component == null:
		print("Health Component is null")
	health_component.death.connect(_on_death)
	health_component.health_changed.connect(_on_health_changed)

func _update_size():
	if not is_inside_tree(): return
	if Engine.is_editor_hint(): return
	
	# Line
	line.position = Vector2.ZERO
	line.closed = true
	line.clear_points()
	for point in POINTS:
		line.add_point(point * player_size / 2.)
	line.queue_redraw()
	
	var points : PackedVector2Array = []
	for point in POINTS:
		points.append(point * player_size / 2.)
	collision_shape.polygon = (points)

func _physics_process(_delta:float):
	if not is_inside_tree(): return
	if Engine.is_editor_hint(): return
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if input_dir != Vector2.ZERO:
		apply_central_force(input_dir * acceleration)

func _on_death():
	print("DEAD")

func _on_health_changed(_h, _mh):
	print("Health: " + str(health_component.health))
