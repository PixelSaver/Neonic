extends PixelMenu
class_name RoomManager

@export var room_container : Node2D
@export var current_room : Room

func _ready() -> void:
	start_anim()

func start_anim():
	Global.room_manager = self
	print("going")
	current_room.clear_enemies()
	#current_room.wave_data = Global.get_next_wave()
	current_room.spawn_enemies()

func end_anim(): 
	Global.room_manager = null

func _get_tween() -> Tween:
	return create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)

func load_room(room:Room):
	current_room.queue_free()
	current_room = room
	room_container.add_child(current_room)
