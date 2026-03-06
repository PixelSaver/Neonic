@tool
extends Container
class_name RadialContainer

@export var radius := 100.0 : 
	set(val):
		radius = val
		queue_sort() 
		if Engine.is_editor_hint():
			_update_children()
@export var separation := 10.0 : 
	set(val):
		separation = val
		queue_sort() 
		if Engine.is_editor_hint():
			_update_children()
@export var circle_center := Vector2(100.0, 0)  : 
	set(val):
		circle_center = val
		queue_sort() 
		if Engine.is_editor_hint():
			_update_children()
@export var flip := false : 
	set(val):
		flip = val
		queue_sort() 
		if Engine.is_editor_hint():
			_update_children()
@export var target_scroll_angle := 0.0 :
	set(val):
		target_scroll_angle = val
		queue_sort() 
		if Engine.is_editor_hint():
			_update_children()
@export_category("Container Exclusion")
@export var excluded: Array[Node] = []
var scroll_angle := 0.0


func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		_update_children()

func _get_layout_children() -> Array[Control]:
	var result: Array[Control] = []
	for child in get_children():
		if not child is Control:
			continue
		if excluded.has(child):
			continue
		result.append(child)
	return result

func _process(delta: float) -> void:
	var children = _get_layout_children()
	if children.size() <= 1: return
		
	var min_limit = -(children.size() - 1) * get_theta()
	var max_limit = 0.0
	
	var is_overshooting = target_scroll_angle > max_limit or target_scroll_angle < min_limit
	
	if is_overshooting:
		var target = clampf(target_scroll_angle, min_limit, max_limit)
		target_scroll_angle = lerpf(target_scroll_angle, target, delta * 10.0) 
	
	scroll_angle = lerpf(scroll_angle, target_scroll_angle, delta * 10.0)
	_update_children()

## Angle separation between two children
func get_theta() -> float:
	return 2.0 * asin(separation / (2.0 * radius))

func get_closest_position() -> Vector2:
	var children = _get_layout_children()
	if children.is_empty():
		return Vector2.ZERO
	
	var theta = get_theta()
	var idx = get_closest_idx()
	
	var angle = scroll_angle + (idx * theta * (1 if not flip else -1))
	
	var center = circle_center + size * Vector2(0.0, 0.5)
	return center + Vector2(cos(angle), sin(angle)) * radius

func scroll_to_index(idx:int) :
	var children = _get_layout_children()
	idx = clamp(idx, 0, children.size() - 1)
	target_scroll_angle = idx * get_theta()

func get_closest_idx() -> int:
	var theta = get_theta()
	var children = _get_layout_children()
	if children.is_empty():
		return -1
	
	var idx = round(-scroll_angle / theta)
	idx = clamp(idx, 0, children.size() - 1)
	return idx

func lerp_to_closest():
	var theta = get_theta()
	var children = _get_layout_children()
	if children.is_empty():
		return
	
	var idx = round(-scroll_angle / theta)
	idx = clamp(idx, 0, children.size() - 1)
	var target_theta = idx * get_theta()
	target_scroll_angle = lerp(target_scroll_angle, target_theta, .01)

func _update_children():
	var children = _get_layout_children()
	var angle := scroll_angle
	var theta = get_theta()
	
	for i in range(children.size()):
		var child = children[i]
		# Use the current item's specific angle
		var current_angle = angle + (i * theta * (1 if not flip else -1))
		
		var pos = (circle_center + self.size * Vector2(0.0, 0.5)) + Vector2(cos(current_angle), sin(current_angle)) * radius
		var child_rect = Rect2(pos, child.get_combined_minimum_size())
		fit_child_in_rect(child, child_rect)

func _gui_input(event: InputEvent) -> void:
	var scroll_strength = 0.1
	if target_scroll_angle > 0 or target_scroll_angle < -(_get_layout_children().size() - 1) * get_theta():
		scroll_strength = 0.05
		
	if event.is_action_pressed("scroll_up"):
		target_scroll_angle += scroll_strength
	elif event.is_action_pressed("scroll_down"):
		target_scroll_angle -= scroll_strength
	elif event.is_action_released("scroll_up") and event.is_action_released("scroll_down"):
		lerp_to_closest()
