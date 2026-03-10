extends Node

enum Types {
	BUG,
	CENTIPEDE,
	BOSS,
}
var scenes = {
	Types.BUG : preload("res://scenes/enemies//enemy.tscn")
}
func get_enemy_scene(type:Types) -> PackedScene:
	if scenes.has(type):
		return scenes.get(type)
	else:
		return scenes.get(Types.BUG)
