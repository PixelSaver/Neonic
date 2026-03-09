extends PixelMenu
class_name StartMenu

@export var duration : float = 1.0
@export var button_cont : Control
var all_tweenables : Array[Tweenable] = []

func _ready() -> void:
	all_tweenables = PixelMenu.get_all_tweenables(self)
	for _but in button_cont.get_children():
		var but = _but as ButtonMenu
		but.self_pressed.connect(_on_button_pressed)
	#HACK Waiting 4 frames to start anim
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	start_anim()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("1") and OS.is_debug_build():
		start_anim()

func start_anim():
	if is_animating: return
	is_animating = true
	Global.is_animating = true
	var t = _get_tween()
	self.modulate.a = 0.0
	t.tween_property(self, "modulate:a", 1, duration*1.5)
	
	for tween in all_tweenables:
		tween.get_parent().position = tween.get_final_local_pos()
		t.tween_property(tween.get_parent(), "position", tween.og_pos, duration)
	
	t.chain().tween_callback(func(): 
		is_animating = false
		Global.is_animating = false
	)

func end_anim():
	if is_animating: return
	is_animating = true
	var t = _get_tween()
	Global.go_to_state(Global.State.HQ)
	t.tween_property(self, "modulate:a", 0.0, duration*1.5)
	
	for tween in all_tweenables:
		tween.get_parent().position = tween.og_pos
		t.tween_property(tween.get_parent(), "position", tween.get_final_local_pos(), duration)
	
	
	t.chain().tween_callback(func(): 
		is_animating = false
		Global.is_animating = false
		self.hide()
	)

func _get_tween() -> Tween:
	return create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)

func _on_button_pressed(but:ButtonMenu):
	match but._name.to_lower():
		"play":
			end_anim()
		"settings":
			pass
		"credits":
			pass
		"quit":
			get_tree().quit()
