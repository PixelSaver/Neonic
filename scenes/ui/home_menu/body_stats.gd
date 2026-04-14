extends MarginContainer
class_name StatsShowcase

enum StatsType {
	BODY,
	WEAPON
}
@export_subgroup("Node Exports", "_")
@export var _name : RichTextLabel
@export var _description : RichTextLabel
@export var type : StatsType = StatsType.BODY

func _process(_delta: float) -> void:
	match type:
		StatsType.BODY:
			_name.clear()
			_description.clear()
			_name.append_text(PlayerSettings.body_data.entity_name)
			var desc = ""
			desc += "Max HP: " + str(PlayerSettings.body_data.max_hp)
			desc += "\n"
			desc += "Move Speed: " + str(PlayerSettings.body_data.move_speed)
			_description.append_text(desc)
		StatsType.WEAPON:
			_name.clear()
			_description.clear()
			_name.append_text(PlayerSettings.weapon_data.entity_name)
			var desc = ""
			desc += "Damage: " + str(PlayerSettings.weapon_data.damage)
			desc += "\n"
			desc += "Fire Rate: " + str(PlayerSettings.weapon_data.fire_rate)
			desc += "\n"
			desc += "Spread: " + str(PlayerSettings.weapon_data.spread)
			desc += "\n"
			desc += "Bullet Speed: " + str(PlayerSettings.weapon_data.bullet_speed)
			_description.append_text(desc)
