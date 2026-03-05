@tool
extends Button
class_name ButtonMenu

signal self_pressed(val:ButtonMenu)

@export_group("Nodes")
@export var label : RichTextLabel
@export_category("Button")
@export var _name : String = "Play": 
	set(val):
		_name = val
		if Engine.is_editor_hint():
			label.clear()
			label.add_text(val)
			print("label text: %s" % label.text)
			label.queue_redraw()
			self.queue_redraw()
@export_category("Tween")
@export var tween_duration : float = 0.2
@export var pos_offset : Vector2 = Vector2(70,0)
var original_pos : Vector2
@export var trans : Tween.TransitionType = Tween.TRANS_QUINT
@export var tween_ease : Tween.EaseType = Tween.EASE_OUT

var tween : Tween

func _ready() -> void:
	label.clear()
	label.add_text(_name)
	
	self.mouse_entered.connect(manual_entered)
	self.mouse_exited.connect(manual_exited)
	await get_tree().process_frame
	init_position()

func init_position() -> void:
	original_pos = position

func _reset() -> void:
	self.modulate = Global.colors.blue
	self.position = original_pos

func manual_entered() -> void:
	if Global.is_animating: 
		_reset()
		return
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween().set_trans(trans).set_ease(tween_ease).set_parallel(true)
	
	tween.tween_property(self, "modulate", Global.colors.red * 0.96, tween_duration)
	tween.tween_property(self, "position", original_pos + pos_offset, tween_duration)

func manual_exited() -> void:
	if Global.is_animating: 
		_reset()
		return
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween().set_trans(trans).set_ease(tween_ease).set_parallel(true)
	
	tween.tween_property(self, "modulate", Global.colors.blue, tween_duration)
	tween.tween_property(self, "position", original_pos, tween_duration)

func _on_button_down() -> void:
	if tween and tween.is_running():
		tween.kill()
		
	self_pressed.emit(self)
	
	tween = create_tween().set_trans(trans).set_ease(Tween.EASE_IN).set_parallel(true)
	
	tween.tween_property(self, "modulate", Global.colors.red, tween_duration / 2.)
	#tween.tween_property(self, "position", original_pos + Vector2(2000,0), tween_duration)
	tween.chain().tween_property(self, "modulate", Global.colors.red * 0.96, tween_duration / 2.)


func _on_button_up() -> void:
	pass # Replace with function body.
