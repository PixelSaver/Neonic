extends Control
class_name Overlay

@onready var hp_panel: Panel = $PlayerHP/Panel
@onready var hp_panel_2: Panel = $PlayerHP/Panel2
@export var death_screen: Control 
@export var home_button: Button
@export var room_man: RoomManager
var og_panel_size := -1.
var target_panel_size := -1.

func _ready() -> void:
	await get_tree().process_frame
	og_panel_size = hp_panel.size.x
	target_panel_size = hp_panel.size.x
	await get_tree().process_frame
	await get_tree().process_frame
	Global.player_ref.health_component.health_changed.connect(_on_player_health_changed)
	Global.player_ref.health_component.death.connect(_on_death)
	death_screen.hide()
	home_button.pressed.connect(_on_home_button_pressed)
	
func _process(delta: float) -> void:
	hp_panel.size.x = lerpf(hp_panel.size.x, target_panel_size, delta * 10.)
	hp_panel_2.size.x = lerpf(hp_panel_2.size.x, hp_panel.size.x, delta * 1.)

func _on_player_health_changed(h:float, mh:float) -> void:
	target_panel_size = (h/mh)*og_panel_size

func _on_death() -> void:
	var t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT).set_parallel(true)
	death_screen.show()
	death_screen.modulate.a = 0.0
	t.tween_property(death_screen, "modulate:a", 1.0, 0.6)

func _on_home_button_pressed() -> void:
	Global.go_to_state(Global.State.HQ)
	var t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT).set_parallel(true)
	room_man.end_anim()
