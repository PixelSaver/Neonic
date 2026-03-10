extends Node
class_name PathfindingComponent

@export var parent : Enemy
@export var turn_speed := 1000.0
@export var move_force := 500.0
@export var vision_distance := 1000.0
var _parent : Enemy
var player : Player
var wander_dir := Vector2.ZERO
var wander_timer := 0.0

func _ready() -> void:
	if parent != null:
		_parent = parent
	elif get_parent() != null and get_parent() is Enemy:
		_parent = get_parent()
	else:
		print_tree_pretty()
		push_error("Pathfinding component couldn't find parent.")
	player = Global.player_ref

func _physics_process(delta: float) -> void:
	if not player: return
	
	var vec_to_player = player.global_position - _parent.global_position
	var dist = vec_to_player.length()
	
	if dist < vision_distance:
		_chase_player(vec_to_player, delta)
	else:
		_wander(delta)

func _chase_player(to_player:Vector2, _delta:float) -> void:
	var desired_dir := to_player.normalized()
	_rotate_toward(desired_dir)
	_move_forward()

func _wander(delta:float) -> void:
	wander_timer -= delta
	
	if wander_timer <= 0:
		wander_timer = randf_range(1.0, 3.0)
		wander_dir = Vector2.from_angle(randf() * TAU)
	
	_rotate_toward(wander_dir)
	_move_forward()

func _rotate_toward(target_dir:Vector2) -> void:
	var target_angle := target_dir.angle()
	var delta_angle := wrapf(target_angle - _parent.global_rotation, -PI, PI)
	_parent.apply_torque(delta_angle * turn_speed)

func _move_forward() -> void:
	var forward = Vector2.from_angle(_parent.global_rotation)
	_parent.apply_central_force(forward * move_force * _parent.speed)
	
