@tool
extends RadialContainer

@export var selector : Control
@export var offset : Vector2 = Vector2(0, 0)
var selector_target_global_position : Vector2 = Vector2.ZERO

func _ready() -> void:
	var dynamic_offset = offset
	if flip: 
		dynamic_offset.x *= -1.
		dynamic_offset.x -= selector.size.x
	selector_target_global_position = get_closest_position() + dynamic_offset

func _update_children():
	super()
	if Engine.is_editor_hint(): return

func _process(delta: float) -> void:
	super(delta)
	var dynamic_offset = offset
	if flip: 
		dynamic_offset.x *= -1.
		dynamic_offset.x -= selector.size.x
	selector_target_global_position = get_closest_position() + dynamic_offset
	selector.global_position = selector.global_position.lerp(selector_target_global_position, delta * 30.)
