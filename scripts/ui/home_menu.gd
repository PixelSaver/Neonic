extends PixelMenu
class_name HomeMenu

@export var duration : float = 1.0
var all_tweenables : Array[Tweenable] = []
@export var line: ToolLine
@export var home_anim : HomeAnimationHelper
@export var play_button : HomeMenuButton

func _ready() -> void:
	self.modulate.a = 0.0
	home_anim.anim_title(0)
	home_anim.anim_boxes(0)
	home_anim.anim_splines(0)
	all_tweenables = PixelMenu.get_all_tweenables(self)
	play_button.pressed.connect(
		func():
			await get_tree().create_timer(0.2).timeout
			end_anim()
	)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("1"):
		start_anim()
	#if Input.is_action_just_pressed("2"):
		#end_anim()

func start_anim():
	if is_animating or Global.is_animating: return
	print("Startiung")
	is_animating = true
	Global.is_animating = true
	var t = _get_tween()
	self.modulate.a = 0.0
	t.tween_property(self, "modulate:a", 1, duration).set_trans(Tween.TRANS_LINEAR)
	line.size = 0
	t.tween_property(line, "size", 100, duration * 0.2).set_trans(Tween.TRANS_CUBIC)
	home_anim.anim_title(0)
	home_anim.anim_boxes(0)
	home_anim.anim_splines(0)
	t.tween_method(home_anim.anim_title, 0.0, 1.0, duration*0.3).set_ease(Tween.EASE_OUT)
	#t.chain()
	t.set_trans(Tween.TRANS_QUART)
	t.tween_method(home_anim.anim_splines, 0.0, 1.0, duration*0.5).set_ease(Tween.EASE_OUT).set_delay(duration*0.3)
	t.tween_method(home_anim.anim_boxes, 0.0, 1.0, duration*0.5).set_ease(Tween.EASE_IN_OUT).set_delay(duration*0.5)
	
	t.chain().tween_callback(func(): 
		is_animating = false
		Global.is_animating = false
	)

func end_anim():
	if is_animating or Global.is_animating: return
	is_animating = true
	Global.is_animating = true

	var t = _get_tween().set_trans(Tween.TRANS_CUBIC)

	t.tween_method(home_anim.anim_boxes, 1.0, 0.0, duration * 0.5)\
		.set_ease(Tween.EASE_IN_OUT)

	t.tween_method(home_anim.anim_splines, 1.0, 0.0, duration * 0.5)\
		.set_ease(Tween.EASE_IN)
	t.tween_method(home_anim.anim_title, 1.0, 0.0, duration * 0.3)\
		.set_ease(Tween.EASE_IN)

	t.chain()

	t.tween_property(line, "size", 1000, duration * 0.2)
	t.tween_property(self, "modulate:a", 0.0, duration * 0.2)
	

	t.chain().tween_callback(func():
		is_animating = false
		Global.is_animating = false
		Global.go_to_state(Global.State.FIGHT)
		queue_free()
	)

func _get_tween() -> Tween:
	return create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT).set_parallel(true)
