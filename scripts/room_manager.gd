extends PixelMenu
class_name RoomManager

@export var room_container : Node2D
@export var current_room : Room

func load_room(room:Room):
	current_room.queue_free()
	current_room = room
	room_container.add_child(current_room)
