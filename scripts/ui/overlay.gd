extends Control
class_name Overlay

@onready var hp_panel: Panel = $PlayerHP/Panel
@onready var hp_panel_2: Panel = $PlayerHP/Panel2
var og_panel_size := -1.
var target_panel_size := -1.

func _ready() -> void:
	await get_tree().process_frame
	og_panel_size = hp_panel.size.x
	target_panel_size = hp_panel.size.x
	await get_tree().process_frame
	await get_tree().process_frame
	Global.player_ref.health_component.health_changed.connect(_on_player_health_changed)
	
func _process(delta: float) -> void:
	hp_panel.size.x = lerpf(hp_panel.size.x, target_panel_size, delta * 10.)
	hp_panel_2.size.x = lerpf(hp_panel_2.size.x, hp_panel.size.x, delta * 1.)

func _on_player_health_changed(h:float, mh:float) -> void:
	target_panel_size = (h/mh)*og_panel_size
