extends Resource
class_name EnemySpawn

@export var position : Vector2 = Vector2.ZERO
@export var enemy_scene : PackedScene = preload("res://scenes/enemy.tscn")
@export var wave : int = 1
