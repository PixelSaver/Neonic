@tool
extends Line2D
class_name ProceduralLeg
@export_group("Nodes")
@export var parent : RigidBody2D
@export var resting : Marker2D 
@export_category("Tweakables")
@export var upper_length := 40.0
@export var lower_length := 40.0
@export var step_distance := 40.0
@export var step_height := 8.0
@export var step_speed := 8.0
@export var resting_position := Vector2(0, -70) :
	set(val):
		if resting_position == val: return
		resting_position = val
@export var flip_knee := false
@export_tool_button("Randomize leg") var update_leg_action = _randomize_leg_pos
var _parent : RigidBody2D

var foot_target : Vector2
var foot_position : Vector2
var is_stepping := false
var t : Tween

func _ready():
	if Engine.is_editor_hint(): return
	if parent != null:
		_parent = parent
	elif get_parent() != null and get_parent() is RigidBody2D:
		_parent = get_parent()
	else:
		print_tree_pretty()
		push_error("Pathfinding component couldn't find parent.")
	foot_position = self.to_global(points[2])
	foot_target = self.to_global(points[2])
	_update_leg_from_resting()
	_randomize_leg_pos()

func _randomize_leg_pos():
	var rng := RandomNumberGenerator.new()
	rng.randomize()

	var side_dir = -get_body_up()
	var body_dir = side_dir.orthogonal()

	var forward_offset = rng.randf_range(-step_distance, step_distance)
	var side_offset = rng.randf_range(-1.0, 1.0) * 1.

	var offset = body_dir * forward_offset + side_dir * side_offset

	foot_position = resting.global_position + offset
	foot_target = foot_position

func _update_leg_from_resting():
	resting.position = resting_position
	foot_position = resting.global_position
	foot_target = resting.global_position
	update_visual()
	self.queue_redraw()
	print("Redrawin: %s" % points[2])

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): 
		update_visual()
		return
	
	if foot_position.distance_to(resting.global_position) > step_distance and !is_stepping:
		var target = resting.global_position + _parent.linear_velocity.normalized() * 40.
		start_step(target)
	update_visual()


func start_step(target: Vector2):
	# Predict where the resting point will be by the time the tween ends (0.2s)
	var prediction_time = 0.5
	
	# Linear prediction
	var velocity_offset = _parent.linear_velocity * prediction_time
	
	# Angular prediction (Rotation)
	var angle_offset = _parent.angular_velocity * prediction_time
	var predicted_resting_pos = resting.global_position.rotated(angle_offset)
	
	foot_target = target + velocity_offset
	is_stepping = true
	if t: t.kill()
	t = create_tween().set_trans(Tween.TRANS_SINE)
	t.tween_method((func(val:Vector2): foot_position = val), foot_position, foot_target, .2)
	t.tween_callback(func():is_stepping = false)

	update_visual()

func get_body_up() -> Vector2:
	var body = get_parent()
	return -body.transform.y.normalized()

func update_visual():
	var local_foot_pos = self.to_local(foot_position)
	#var knee = solve_knee(hip, foot_position)
	var knee = solve_knee(points[0], local_foot_pos)

	points = [
		points[0],
		knee,
		local_foot_pos
	]

func solve_knee(hip: Vector2, foot: Vector2) -> Vector2:
	var dir = foot - hip
	var dist = clamp(dir.length(), 0.001, upper_length + lower_length - 0.001)

	var angle_to_target = dir.angle()

	var cos_angle = (
		upper_length * upper_length +
		dist * dist -
		lower_length * lower_length
	) / (2.0 * upper_length * dist)

	var angle_offset = acos(clamp(cos_angle, -1.0, 1.0))

	var knee_angle = angle_to_target + angle_offset * (-1 if flip_knee else 1)

	return hip + Vector2.RIGHT.rotated(knee_angle) * upper_length
