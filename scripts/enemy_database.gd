extends Node


var scenes = {
	Enemy.Types.BUG : preload("res://scenes/enemies/enemy.tscn")
}
func get_enemy_scene(type:Enemy.Types) -> PackedScene:
	if scenes.has(type):
		return scenes.get(type)
	else:
		return scenes.get(Enemy.Types.BUG)
