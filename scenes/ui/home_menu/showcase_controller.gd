extends Control
class_name ShowcaseController

@export var radial_selector : RadialSelector
@export var entity_showcase : EntityShowcase



func _update_showcase():
	var entry = radial_selector.get_current_child() as WeaponEntry
	if not entry: return
	entity_showcase.entity_data = entry.entity_data
	if entry.entity_data is WeaponData: 
		PlayerSettings.weapon_data = entry.entity_data
	if entry.entity_data is BodyData: 
		PlayerSettings.body_data = entry.entity_data

func _process(_delta: float) -> void:
	if Global.game_state != Global.State.HQ and Global.is_animating: return
	_update_showcase()
