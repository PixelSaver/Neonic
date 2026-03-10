extends PixelMenu
class_name RoomManager

@export var room_container : Node2D
@export var current_room : Room

func _ready() -> void:
	current_room.room_left.connect(_on_next_room)
	pass

func _on_next_room() -> void:
	var next_wave := Global.get_next_wave()
	if next_wave == null:
		self.end_anim()
		await get_tree().create_timer(0.5).timeout
		Global.go_to_state(Global.State.HQ)
	else:
		current_room.wave_data = next_wave

func start_anim():
	self.modulate.a = 0.0
	var t = _get_tween()
	t.tween_property(self, "modulate:a", 1.0, 0.5)
	Global.room_manager = self
	print("going")
	current_room.clear_enemies()
	#current_room.wave_data = Global.get_next_wave()
	current_room.spawn_enemies()

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
