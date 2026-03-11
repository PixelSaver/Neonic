extends Enemy
class_name GunnerEnemy

@export var eye_pivot : Node2D

func _ready() -> void:
	self.enemy_type = Types.GUNNER
