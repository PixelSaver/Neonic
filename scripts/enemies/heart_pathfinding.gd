extends PathfindingComponent
class_name HeartPathfindingComponent

var heart_enemy : HeartEnemy

func _ready() -> void:
	super()
	heart_enemy = _parent as HeartEnemy



func _physics_process(delta: float) -> void:
	if not player: return
	
	var vec_to_player = player.global_position - _parent.global_position
	var vec_to_center = Vector2.ZERO - _parent.global_position
	
	match heart_enemy.current_phase:
		heart_enemy.Phase.APPROACH:
			_parent.speed = 1.0
			_move_toward(vec_to_player, delta)
		heart_enemy.Phase.LAZER:
			_parent.speed = 3.0
			_move_toward(vec_to_center, delta)
		heart_enemy.Phase.COMBO:
			_parent.speed = 3.0
			_move_toward(vec_to_center, delta)


func _move_toward(dir:Vector2, delta:float) -> void:
	var dist = dir.length()
	if is_equal_approx(dist, 0.0): return
	var desired_dir := dir.normalized()
	var slow_radius := 120.0
	var speed_scale := clampf(dist / slow_radius, 0.0, 1.0)
	var force := desired_dir * move_force * _parent.speed * speed_scale
	_parent.apply_central_force(force * delta)

#func _wander(delta:float) -> void:
	#wander_timer -= delta
	#
	#if wander_timer <= 0:
		#wander_timer = randf_range(1.0, 3.0)
		#wander_dir = Vector2.from_angle(randf() * TAU)
	#
	#_rotate_toward(wander_dir)
	#_move_forward()

#func _rotate_toward(target_dir:Vector2) -> void:
	#var target_angle := target_dir.angle()
	#var delta_angle := wrapf(target_angle - _parent.global_rotation, -PI, PI)
	#_parent.apply_torque(delta_angle * turn_speed)

#func _move_forward() -> void:
	#var forward = Vector2.from_angle(_parent.global_rotation)
	#_parent.apply_central_force(forward * move_force * _parent.speed)
	
