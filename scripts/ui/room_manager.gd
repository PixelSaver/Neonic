extends PixelMenu
class_name RoomManager

@export var room_container : Node2D
@export var current_room : Room

func _ready() -> void:
	current_room.room_left.connect(func():
		end_anim()
		await get_tree().create_timer(0.5).timeout
		Global.go_to_state(Global.State.HQ)
		queue_free()
	)
	current_room.room_cleared.connect(_on_room_finished)
	pass

func _on_room_finished() -> void:
	var next_wave := WaveDatabase.get_next_wave()

	if next_wave == null:
		await Global.all_enemies_cleared
		current_room.room_exit.activated = true
		current_room.is_last_wave = true
	else:
		current_room.wave_data = next_wave
		current_room.start_waves()

func start_anim():
	self.modulate.a = 0.0
	var t = _get_tween()
	t.tween_property(self, "modulate:a", 1.0, 0.5)
	Global.room_manager = self
	print("going")
	current_room.clear_enemies()
	_on_room_finished()

func end_anim(): 
	Global.room_manager = null
	var t = _get_tween()
	t.tween_property(self, "modulate:a", 0.0, 0.5)

func _get_tween() -> Tween:
	return create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)

func load_room(room:Room):
	current_room.queue_free()
	current_room = room
	room_container.add_child(current_room)
