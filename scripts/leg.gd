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
@export var step_speed := .5
@export var resting_position := Vector2(0, -70) :
	set(val):
		if resting_position == val: return
		resting_position = val
		if Engine.is_editor_hint():
			_update_leg_from_resting()
@export var flip_knee := false
@export_tool_button("Randomize leg") var update_leg_action = _randomize_leg_pos
var _parent : RigidBody2D

var foot_target : Vector2
var foot_position : Vector2
## Current visual foot lift
var current_lift := 0.0
var is_stepping := false
var t : Tween

func _ready():
	_parent = parent if parent else get_parent().get_parent()
	#foot_position = self.to_global(points[2])
	#foot_target = self.to_global(points[2])
	_update_leg_from_resting()
	_randomize_leg_pos()

func get_distance_to_resting() -> float:
	return foot_position.distance_to(resting.global_position)

func take_step() -> void:
	var v = _parent.linear_velocity
	var w = _parent.angular_velocity
	
	var lookahead = 0.2
	
	var target = resting.global_position + (v * lookahead)
	
	var offset_from_center = target - _parent.global_position
	target = _parent.global_position + offset_from_center.rotated(w * lookahead)
	
	_start_step(target)

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
	update_visual()


func _start_step(target: Vector2):
	foot_target = target
	is_stepping = true
	
	if t: t.kill()
	t = create_tween().set_trans(Tween.TRANS_SINE).set_parallel(true)
	t.tween_method((func(val:Vector2): foot_position = val), foot_position, foot_target, .2)
	#TODO Get the current_lift to work visually
	t.tween_property(self, "current_lift", step_height, step_speed / 2.0).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "current_lift", 0.0, step_speed / 2.0).set_ease(Tween.EASE_IN).set_delay(step_speed / 2.0)
	
	
	t.chain().tween_callback(func():is_stepping = false)

	update_visual()

func get_body_up() -> Vector2:
	if Engine.is_editor_hint(): return -parent.transform.y.normalized()
	return -_parent.transform.y.normalized()

func update_visual():
	var local_foot_pos = self.to_local(foot_position)
	
	var lift_vector = self.to_local(self.global_position + get_body_up() * current_lift) - points[0]
	var visual_foot = local_foot_pos + lift_vector

	var knee = solve_knee(points[0], visual_foot)
	points = [points[0], knee, visual_foot]

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
