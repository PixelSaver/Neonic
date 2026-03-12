extends Node

var scenes = {
	Enemy.Types.BUG : preload("res://scenes/enemies/enemy.tscn"),
	Enemy.Types.GUNNER : preload("res://scenes/enemies/gunner/gunner_enemy.tscn"),
	Enemy.Types.CENTIPEDE : preload("res://scenes/enemies/centipede/enemy_centipede.tscn"),
}
func get_enemy_scene(type:Enemy.Types) -> PackedScene:
	if scenes.has(type):
		return scenes.get(type)
	else:
		return scenes.get(Enemy.Types.BUG)
