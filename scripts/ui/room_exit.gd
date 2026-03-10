extends Node2D
class_name RoomExit

signal room_exited
signal is_player_in(_bool:bool)
@export var particles : GPUParticles2D
@export var area : Area2D
@export var label : RichTextLabel
@export var label2 : RichTextLabel
## Whether or not the exit works
var activated := false :
	set(v):
		if v == activated: return
		activated = v
		particles.emitting = v

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	self.is_player_in.connect(_on_player_in)
	particles.emitting = false
	label.visible_ratio = 0.0
	label2.visible_ratio = 0.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("accept") and is_player_in and activated:
		room_exited.emit()

func _on_player_in(is_in:bool) -> void:
	if not activated: return
	var t = create_tween().set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_SINE).set_parallel(true)
	if is_in:
		label.visible_ratio = 0.0
		label2.visible_ratio = 0.0
		t.tween_property(label, "visible_ratio", 1.0, 0.5)
		t.tween_property(label2, "visible_ratio", 1.0, 0.5)
	else:
		label.visible_ratio = 1.0
		label2.visible_ratio = 1.0
		t.tween_property(label, "visible_ratio", 0.0, 0.5)
		t.tween_property(label2, "visible_ratio", 0.0, 0.5)

func _on_body_entered(body:Node2D) -> void:
	if not activated: return
	if body is not Player: return
	is_player_in.emit(true)
func _on_body_exited(body:Node2D) -> void:
	if not activated: return
	if body is not Player: return
	is_player_in.emit(false)
