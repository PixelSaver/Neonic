extends Control
class_name ShowcaseController

@export var radial_selector : RadialSelector
@export var gun_showcase : GunShowcase

func _update_showcase():
	var idx = radial_selector.get_closest_idx()
	var entry = radial_selector._get_layout_children()[idx] as WeaponEntry
	if not entry: return
	gun_showcase.weapon_data = entry.weapon_data

func _process(_delta: float) -> void:
	if Global.game_state != Global.State.HQ and Global.is_animating: return
	_update_showcase()
