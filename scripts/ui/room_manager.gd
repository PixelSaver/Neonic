extends PixelMenu
class_name RoomManager

@export var room_container : Node2D
@export var current_room : Room

func start_anim():
	pass

func end_anim(): 
	pass

func _get_tween() -> Tween:
	return create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)

func load_room(room:Room):
	current_room.queue_free()
	current_room = room
	room_container.add_child(current_room)
