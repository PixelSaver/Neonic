@tool
extends Enemy
class_name CentipedeEnemy

@export_group("Centipede Tweaking")
@export var segment_cont : Node2D
var segments : Array[Node] = []
@export var segment_length := 50.
@export var first_segment_length := 75.
@export var max_bend_angle := deg_to_rad(45.)

func _ready() -> void:
	self.enemy_type = Types.CENTIPEDE

func _physics_process(_delta: float) -> void:
	segments = segment_cont.get_children()
	_constrain_segments()

func _constrain_segments() -> void:
	if segments.size() < 1: return
	
	for i in range(0, segments.size()):
		var prev
		if i-1 < 0: prev = self
		else: prev = segments[i-1]
		var current = segments[i]
		
		var dir = current.global_position - prev.global_position
		var dist = dir.length()
		
		if is_equal_approx(dist, 0.): continue
		
		dir = dir.normalized()
		current.global_position = prev.global_position + dir * (first_segment_length if i == 0 else segment_length)
		current.look_at(prev.global_position)
		
		# Angle Constraint
		var prev_dir : Vector2
		if i == 0:
			prev_dir = Vector2.RIGHT.rotated(global_rotation).rotated(PI)
		elif i == 1:
			prev_dir = (segments[0].global_position - global_position).normalized()
		else:
			var prev2 = segments[i - 2]
			prev_dir = (prev.global_position - prev2.global_position).normalized()

		var cur_dir = (current.global_position - prev.global_position).normalized()

		var angle = prev_dir.angle_to(cur_dir)
		var clamped = clamp(angle, -max_bend_angle, max_bend_angle)

		var new_dir = prev_dir.rotated(clamped)

		current.global_position = prev.global_position + new_dir * (first_segment_length if i == 0 else segment_length)
		
