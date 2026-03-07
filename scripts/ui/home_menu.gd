extends PixelMenu
class_name HomeMenu

@export var duration : float = 1.0
var all_tweenables : Array[Tweenable] = []
@export var line: ToolLine
@export var home_anim : HomeAnimationHelper

func _ready() -> void:
	all_tweenables = PixelMenu.get_all_tweenables(self)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("1"):
		start_anim()

func start_anim():
	if is_animating: return
	is_animating = true
	var t = _get_tween()
	t.tween_property(self, "modulate:a", 1, duration*1.5)
	line.size = 0
	t.tween_property(line, "size", 100, duration * 0.2)
	home_anim.anim_boxes(0)
	home_anim.anim_splines(0)
	t.tween_method(home_anim.anim_splines, 0.0, 1.0, duration*0.4).set_ease(Tween.EASE_OUT)
	t.tween_method(home_anim.anim_boxes, 0.0, 1.0, duration*0.4).set_ease(Tween.EASE_IN_OUT).set_delay(duration*0.35)
	
	t.chain().tween_callback(func(): is_animating = false)

func end_anim():
	if is_animating: return
	is_animating = true
	var t = _get_tween()
	t.tween_property(self, "modulate:a", 1, duration*1.5)
	
	for tween in all_tweenables:
		tween.get_parent().global_position = tween.get_final_global_pos()
		t.tween_property(tween.get_parent(), "global_position", tween.get_final_local_pos(), duration)
	
	t.chain().tween_callback(func(): is_animating = false)

func _get_tween() -> Tween:
	return create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT).set_parallel(true)
