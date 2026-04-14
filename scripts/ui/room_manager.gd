extends PixelMenu
class_name RoomManager
@onready var ui: Overlay = $Camera2D/UI

@export var room_container : Node2D
@export var current_room : Room
var _special_ending : Node2D

func _ready() -> void:
	current_room.room_left.connect(func():
		Global.go_to_state(Global.State.HQ)
		end_anim()
		await get_tree().create_timer(0.2).timeout
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

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("3"):
		special_ending(Vector2.ZERO)

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
	t.tween_callback(func():
		self.queue_free()
	)

func _get_tween() -> Tween:
	return create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)

func load_room(room:Room):
	current_room.queue_free()
	current_room = room
	room_container.add_child(current_room)
	
const SPECIAL_ENDING = preload("res://scenes/ui/room_manager/special_ending.tscn")

func special_ending(global_pos : Vector2) -> void:
	if _special_ending: _special_ending.queue_free()
	Global.player_ref.process_mode = Node.PROCESS_MODE_DISABLED
	room_container.process_mode = Node.PROCESS_MODE_DISABLED
	
	var target_pos = get_viewport().get_camera_2d().global_position + Vector2(0, -70)
	
	var inst = SPECIAL_ENDING.instantiate() as SpecialEnding
	inst.scale = Vector2.ONE
	_special_ending = inst
	_special_ending.ended.connect(end_anim)
	get_tree().root.add_child(inst)
	inst.global_position = global_pos
	var t = _get_tween()
	t.tween_property(self, "modulate:a", 0.0, 0.6)
	t.tween_property(ui, "modulate:a", 0.0, 0.6)
	t.tween_property(inst, "global_position", target_pos, 1.0)
	t.tween_property(inst, "scale", Vector2.ONE * 6., 1.5).set_trans(Tween.TRANS_ELASTIC)
