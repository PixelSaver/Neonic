extends PixelMenu
class_name StartMenu

@export var all_parents : Array[Node] = []
@export var button_cont : Control
@export var duration : float = 1.0
var all_tweenables : Array[Tweenable] = []

func _ready() -> void:
	all_tweenables = PixelMenu.get_all_tweenables(all_parents)
	for _but in button_cont.get_children():
		var but = _but as ButtonMenu
		but.self_pressed.connect(_on_button_pressed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("1"):
		start_anim()

func start_anim():
	if is_animating: return
	is_animating = true
	Global.is_animating = true
	var t = _get_tween()
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
	Global.is_animating = true
	Global.go_to_state(Global.State.WEAPONS)
	var t = _get_tween()
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
			Global.game_state = Global.State.WEAPONS
		"settings":
			pass
		"credits":
			pass
		"quit":
			get_tree().quit()
