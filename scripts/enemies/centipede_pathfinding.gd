extends PathfindingComponent
class_name CentipedePathfindingComponent

#func _physics_process(delta: float) -> void:
	#if not player: return
	#
	#var vec_to_player = player.global_position - _parent.global_position
	#var dist = vec_to_player.length()
	#
	#if dist < vision_distance:
		#_chase_player(vec_to_player, delta)
	#else:
		#_wander(delta)
#
#func _chase_player(to_player:Vector2, _delta:float) -> void:
	#var desired_dir := to_player.normalized().rotated(PI/2)
	#_rotate_toward(desired_dir)
	#_move_forward()
#
#func _wander(delta:float) -> void:
	#wander_timer -= delta
	#
	#if wander_timer <= 0:
		#wander_timer = randf_range(1.0, 3.0)
		#wander_dir = Vector2.from_angle(randf() * TAU)
	#
	#_rotate_toward(wander_dir)
	#_move_forward()
