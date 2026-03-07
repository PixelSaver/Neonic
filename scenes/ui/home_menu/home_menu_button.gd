
extends Button
class_name HomeMenuButton

var sine_t : Tween
var sine_phase := 0.0
var t : Tween
var og_pos : Vector2
var target_pos : Vector2 = Vector2.ZERO
var sine_oscillation := false:
	set(v):
		if v == sine_oscillation: return
		sine_oscillation = v
		
		if v:
			if sine_t and sine_t.is_running():
				sine_t.kill()
			
			sine_t = create_tween().set_loops()
			sine_t.tween_method(_apply_sine, 0.0, TAU, 6.0)
		else:
			if sine_t and sine_t.is_running():
				sine_t.kill()
			target_pos = og_pos

func _ready() -> void:
	await get_tree().process_frame
	og_pos = self.global_position
	target_pos = og_pos
	self.pivot_offset_ratio = Vector2(0.5,0.0)
	sine_oscillation = true

func _apply_sine(v: float) -> void:
	if Global.is_animating:
		if sine_t and sine_t.is_running():
			sine_t.kill()
		target_pos = og_pos
		return
	if not og_pos: return
	
	sine_phase = v
	target_pos = og_pos + Vector2.RIGHT.rotated(v) * 3.

func _process(delta: float) -> void:
	if Global.is_animating: return
	global_position = global_position.lerp(target_pos, delta * 10.)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_MOUSE_ENTER:
			_hover()
		NOTIFICATION_MOUSE_EXIT:
			_unhover()
		_:
			pass


func _hover() -> void:
	if Global.is_animating: return
	if t and t.is_running(): t.kill()
	self.pivot_offset_ratio = Vector2.ONE/2.
	sine_oscillation = false
	t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT).set_parallel(true)
	t.tween_property(self, "modulate", Global.colors.blue * 1.1, 0.5)
	t.tween_property(self, "scale", Vector2.ONE*1.1, 0.5)
func _unhover() -> void:
	if Global.is_animating: return
	if t and t.is_running(): t.kill()
	t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT).set_parallel(true)
	t.tween_property(self, "modulate", Global.colors.blue * 1.0, 0.5)
	t.tween_property(self, "scale", Vector2.ONE, 0.5)
	t.chain()
	t.tween_callback(func():sine_oscillation = true)


func _on_pressed() -> void:
	if Global.is_animating: return
	if t and t.is_running(): t.kill()
	t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT).set_parallel(true)
	t.tween_property(self, "modulate", Global.colors.blue * 1.0, 0.05)
	t.tween_property(self, "scale", Vector2.ONE*1.05, 0.05)
	t.chain().set_ease(Tween.EASE_IN)
	t.tween_property(self, "modulate", Global.colors.blue * 1.1, 0.1)
	t.tween_property(self, "scale", Vector2.ONE*1.1, 0.1)
